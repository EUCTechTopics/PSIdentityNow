<#
    .SYNOPSIS
        Invoke the IdentityNow REST API.

    .DESCRIPTION
        This function is used to invoke a REST method to the IdentityNow API. It will handle pagination and retries.

    .PARAMETER Url
        The relative URL to call.

    .PARAMETER UrlParams
        The parameters to add to the URL.

    .PARAMETER Method
        The HTTP method to use.

    .PARAMETER Body
        The body of the request.

    .PARAMETER ContentType
        The content type of the request.

    .PARAMETER MaxRetries
        The maximum number of retries to attempt.

    .PARAMETER PauseDuration
        The duration to pause between retries.

    .EXAMPLE
        Invoke-IDNWRestMethod -Url '/roles' -Method 'GET'

    .INPUTS
        None

    .OUTPUTS
        System.Object[]
#>

function Invoke-IDNWRestMethod {
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Url,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $UrlParams,

        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "PATCH", "POST", "PUT", "DELETE")]
        [String]
        $Method = "GET",

        [Parameter(Mandatory = $false)]
        [String]
        $Body,

        [Parameter(Mandatory = $false)]
        [String]
        $ContentType = "application/json",

        [Parameter(Mandatory = $false)]
        [Int]
        $MaxRetries = 3,

        [Parameter(Mandatory = $false)]
        [Int]
        $PauseDuration = 2
    )

    # Check if connected to IdentityNow
    Test-IDNWConnection

    # Form complete URL
    $Url = ("{0}{1}" -f $($script:IDNWEnv.BaseAPIUrl), $Url)

    # Create authorization header
    $Token = ConvertFrom-SecureString $script:IDNWEnv.SessionToken -AsPlainText
    $Headers = @{
        Authorization = "Bearer $Token"
    }
    Remove-Variable -Name Token -Force

    # Add application/json-patch+json content-type for PATCH requests
    if ($Method -eq "PATCH") {
        $ContentType = "application/json-patch+json"
    }

    # Set initial variables
    $SendCall = $true
    $RetryCount = 0
    $AllResults = @()
    $i = 0

    # Add count parameter to the UrlParams to be able to do pagination
    if ($UrlParams) {
        $UrlParams.Add('count', $true)
        $UrlParams.Add('offset', 0)
    } else {
        $UrlParams = @{
            count = $true
            offset = 0
        }
    }

    # Pagination loop
    do {
        # Combine parameters into query string
        if ($Method -eq "GET") {
            $queryString = ($UrlParams.GetEnumerator() | ForEach-Object {
                [string]::Format("{0}={1}", $_.Key, [uri]::EscapeUriString($_.Value))
            }) -join "&"
            $PagedUri = "{0}?{1}" -f $Url, $queryString
        } else {
            $PagedUri = $Url
        }

        $DecodedPagedUri = [System.Web.HttpUtility]::UrlDecode($PagedUri)

        # Log the request
        if ($i -eq 0) {
            Write-Verbose "Sending $Method request to $DecodedPagedUri"
            $Headers.GetEnumerator() | Where-Object name -ne "Authorization" | ForEach-Object {
                Write-Debug ("{0}: {1}" -f $_.Name, $_.Value)
            }
        } elseif ($i -eq 1) {
            Write-Debug "More records are available for this query."
            Write-Debug "Querying $DecodedPagedUri"
        } elseif ($i -gt 1) {
            Write-Debug "Querying $DecodedPagedUri"
        }

        # Try to fetch the page
        while ($SendCall) {
            try {
                $Splat = @{
                    Uri             = $PagedUri
                    UseBasicParsing = $true
                    Headers         = $Headers
                    Method          = $Method
                    ContentType     = $ContentType
                }
                if($Body) { $Splat.Add('Body', $Body) }
                $response = Invoke-WebRequest @Splat -Verbose:$false -Debug:$false

                # Parse and collect results
                $Results = $Response.Content | ConvertFrom-Json
                $AllResults += $Results

                # Get the total count from the header
                if (-not $TotalCount) {
                    # If total count header exists
                    try {
                        $TotalCount = [Int]$Response.Headers.'X-Total-Count'[0]
                    }
                    catch {
                        if ($_.Exception.Message -eq 'Cannot index into a null array.') {
                            $TotalCount = $Results.Count
                        }
                        else {
                            Write-Output "Something went wrong calculating the total number of objects" | Out-Null
                            throw $_
                        }
                    }
                }

                # Update the offset and remaining limit
                $Offset += ($Results | Measure-Object).Count

                # Add pagination parameters to the UrlParams
                $UrlParams.offset = $Offset

                # Exit retry loop if successful
                $i += 1
                $SendCall = $false
            }
            catch {
                # Get the error message
                try {
                    # Try retrieving .messages[0].text
                    $errorDetails = $_.ErrorDetails | ConvertFrom-Json
                    if ($errorDetails.messages -and $errorDetails.messages[0].text) {
                        $message = $errorDetails.messages[0].text
                    }
                    elseif ($errorDetails.error) {
                        # Fallback to .error if .messages[0].text is not available
                        $message = $errorDetails.error
                    }
                    else {
                        # Fallback message if neither is available
                        $message = "Unknown error occurred"
                    }
                }
                catch {
                    # In case of failure in parsing JSON or accessing properties
                    $message = "Error processing error details"
                }

                # Log the error message
                Write-Error ("HTTP {0} {1}: {2}" -f ($_.Exception.Response.StatusCode.value__), ($_.Exception.Response.StatusCode.ToString()), $message)
                if ($_.Exception.Response.StatusCode.value__ -match '^5\d{2}$' -and $RetryCount -lt $MaxRetries) {
                    $RetryCount += 1
                    Write-Verbose "Retry attempt $RetryCount after a $PauseDuration second pause..."
                    Start-Sleep -Seconds $PauseDuration
                }
                else {
                    $SendCall = $false
                    Remove-Variable -Name Headers -Force
                    throw "Failed to retrieve data after $RetryCount attempts."
                }
            }
        }

        # Reset for the next page
        $SendCall = $true
        $RetryCount = 0

    } while ($Offset -lt $TotalCount)

    # Return all results
    Remove-Variable -Name Headers -Force
    Write-Output $AllResults
}