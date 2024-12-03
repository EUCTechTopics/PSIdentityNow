<#
    .SYNOPSIS
        Get the specified objects from IdentityNow.

    .DESCRIPTION
        This function gets the specified objects from IdentityNow. The function will return the object details.

    .PARAMETER ObjectType
        The type of object to get from IdentityNow.

    .PARAMETER Id
        The Id of the object to get from IdentityNow.

    .PARAMETER Filters
        The filters to apply to the query.

    .EXAMPLE
        Get-IDNWObject -ObjectType 'roles' -Id '50d47a8999f34e8a9e302248405ccfe8'

    .EXAMPLE
        $filters = @()
        $filters += @{
            field = "firstname"
            operator = "eq"
            value = "John"
        }
        $filters += @{
            field = "identityState"
            operator = "eq"
            value = "ACTIVE"
        }
        Get-IDNWObject -ObjectType 'public-identities' -Filters $filters

    .INPUTS
        None

    .OUTPUTS
        System.Object

    .LINK
        https://developer.sailpoint.com/docs/api/standard-collection-parameters/#primitive-operators
#>

function Get-IDNWObject {
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'byFilter')]
        [Parameter(Mandatory = $true, ParameterSetName = 'all')]
        [ValidateSet("access-profiles", "roles", "segments", "public-identities")]
        [String]
        $ObjectType,

        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [ValidateScript({ Test-IDNWId -Id $_ })]
        [String]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byFilter')]
        [ValidateScript({ Test-IDNWFilter -Filters $_ })]
        [Hashtable[]]
        $Filters
    )

    # Initialize empty hashtable
    $Splat = @{}

    # Configure the Url
    $url = "$($script:IDNWEnv.BaseAPIUrl)/$ObjectType"

    switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            # Add the ID to the URL
            $url = "$url/$Id"
        }
        'byFilter' {
            # Add the filters to the URL
            $FilterItems = @()

            $Filters | ForEach-Object {
                # Convert the operator to the IdentityNow API format
                switch ($_.operator.ToLower()) {
                    'containsall' { $operator = "ca"}
                    'contains' { $operator = "co" }
                    'present' { $operator = "pr" }
                    'startswith' { $operator = "sw" }
                    default { $operator = $_ }
                }
                $field = $_.field
                $value = $_.value

                # Handle operators that don't require a value
                if ($operator -eq 'pr') {
                    $FilterItems += ('{0} {1}' -f $operator, $field)
                }
                elseif ($operator -eq 'isnull') {
                    $FilterItems += ('{0} {1}' -f $field, $operator)
                }
                # Handle cases where the value is a collection (e.g., "ca", "in")
                elseif ($value -is [array]) {
                    $formattedValues = ("""" + ($value -join '","') + """") # Add quotes and commas
                    $FilterItems += ('{0} {1} ({2})' -f $field, $operator, $formattedValues)
                }
                # Handle numeric values
                elseif ($value -is [int]) {
                    $FilterItems += ('{0} {1} {2}' -f $field, $operator, $value)
                }
                # Handle boolean values
                elseif ($value -is [bool]) {
                    $FilterItems += ('{0} {1} {2}' -f $field, $operator, $value.ToString().ToLower())
                }
                # Handle string values (add quotes and escape special characters)
                elseif ($value -is [string]) {
                    $escapedValue = $value.Replace('"', '\"') # Escape double quotes
                    $FilterItems += ('{0} {1} "{2}"' -f $field, $operator, $escapedValue)
                }
                # Handle date values (format to ISO 8601)
                elseif ($value -is [datetime]) {
                    $isoDate = $value.ToString("yyyy-MM-ddTHH:mm:ssZ")
                    $FilterItems += ('{0} {1} {2}' -f $field, $operator, $isoDate)
                }
                # Fallback for unknown types
                else {
                    throw "Unsupported value type for field '$field' and operator '$operator'."
                }
            }

            # Join the filter items with "and"
            $FilterString = ($FilterItems -join ' and ')

            # Add the filters to URL parameters
            $UrlParams = @{
                filters = $FilterString
            }
        }
    }

    # Invoke the API
    $Splat.Add('Url', $url)
    if ($UrlParams) { $Splat.Add('UrlParams', $UrlParams) }
    $response = Invoke-IDNWRestMethod @Splat

    # Return the object
    return $response
}