<#
    .SYNOPSIS
        Checks if connected to IdentityNow and if the token has expired.

    .DESCRIPTION
        This function checks if connected to IdentityNow and if the token has expired. If not connected to IdentityNow, the function will throw an error. If the token has expired, the function will throw an error.

    .EXAMPLE
        Test-IDNWConnection

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Test-IDNWConnection {

    # Check if connected to IdentityNow
    if (-not $script:IDNWEnv) {
        throw "Not connected to IdentityNow, please use Connect-IDNW first"
    }

    # Check if token has expired
    if (-not ($script:IDNWEnv.SessionTokenDetails.timeToExpiry.TotalSeconds -gt 0)) {
        throw "Access Token has expired, please use Connect-IDNW to reconnect"
    }

}