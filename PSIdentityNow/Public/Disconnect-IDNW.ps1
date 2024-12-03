<#
    .SYNOPSIS
        Disconnects from IdentityNow.

    .DESCRIPTION
        This function disconnects from IdentityNow and clears the environment variables.

    .EXAMPLE
        Disconnect-IDNW

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Disconnect-IDNW {

    if (-not $script:IDNWEnv) {
        throw "Not connected to IdentityNow."
    } else {
        Write-Output ('Disconnecting from IdentityNow instance {0}' -f $script:IDNWEnv.Instance) | Out-Null
        $script:IDNWEnv = $null
    }

}