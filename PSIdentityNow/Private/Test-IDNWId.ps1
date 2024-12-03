<#
    .SYNOPSIS
        Checks if provided Id is a valid IdentityNow Id.

    .DESCRIPTION
        This function checks if the provided Id is a valid IdentityNow Id. If the Id is not a valid IdentityNow Id, the function will throw an error.

    .EXAMPLE
        Test-IDNWId

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Test-IDNWId {
    param (
        [string]$Id
    )

    if (-not ($Id.Length -eq 32)) {
        throw "$_ Is not a valid IdentityNow ID"
    }
    else {
        $true
    }

}