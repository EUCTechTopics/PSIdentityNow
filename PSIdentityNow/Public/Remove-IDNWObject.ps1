<#
    .SYNOPSIS
        Delete an object in IdentityNow.

    .DESCRIPTION
        This function deletes an object in IdentityNow.

    .PARAMETER ObjectType
        The type of object to delete in IdentityNow.

    .PARAMETER Id
        The Id of the object to delete in IdentityNow.

    .EXAMPLE
        Remove-IDNWObject -ObjectType 'roles' -Id '50d47a8999f34e8a9e302248405ccfe8'

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Remove-IDNWObject {
    [CmdletBinding(
        SupportsShouldProcess = $True,
        ConfirmImpact = "High",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateSet("access-profiles", "roles", "segments")]
        [String]
        $ObjectType,

        [Parameter(Mandatory = $True)]
        [ValidateScript({ Test-IDNWId -Id $_ })]
        [String]
        $Id
    )

    # Define POST method to update information
    $Method = 'DELETE'

    # Configure the Url
    $url = "$($script:IDNWEnv.BaseAPIUrl)/$ObjectType/$Id"

    # ShouldProcess to support -WhatIf
    if ($PSCmdlet.ShouldProcess($Id, "Delete $ObjectType")) {
        # Invoke Rest Request
        Write-Verbose ('Calling {0}' -f $url)
        $Result = Invoke-IDNWRestMethod -Url $url -Method $Method -Body $Body
        Write-Debug ('Calling {0} successful' -f $url)
        return $Result
    }
}