<#
    .SYNOPSIS
        Get the IdentityNow Organisation.

    .DESCRIPTION
        This function returns the connected IdentityNow Organisation.

    .EXAMPLE
        Get-IDNWOrg

    .INPUTS
        None

    .OUTPUTS
        System.String
#>

function Get-IDNWOrg {

    # Check if connected to IdentityNow
    if (-not $script:IDNWEnv) {
        throw "Not connected to IdentityNow, please use Connect-IDNW first"
    }

    try {
        $($script:IDNWEnv.SessionTokenDetails.org)
    }
    catch {
        throw "Failed to get IdentityNow Org"
    }
    
}