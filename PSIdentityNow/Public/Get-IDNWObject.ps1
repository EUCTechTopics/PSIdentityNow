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
        [ValidateSet("access-profiles", "entitlements", "roles", "public-identities", "requestable-objects", "segments")]
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
            # Get FilterString
            $FilterString = Get-IDNWFilterString -Filters $Filters

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