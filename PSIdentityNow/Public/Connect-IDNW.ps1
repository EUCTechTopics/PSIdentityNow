<#
    .SYNOPSIS
        Connects to IdentityNow.

    .DESCRIPTION
        This function connects to IdentityNow and sets the environment variables for the specified instance.

    .EXAMPLE
        Connect-IDNW -Instance "DEV" -APIVersion "beta"
        Connects to the DEV instance using the beta API version.

    .EXAMPLE
        Connect-IDNW -Instance "TST" -APIVersion "v3"
        Connects to the TST instance using the v3 API version.

    .EXAMPLE
        Connect-IDNW -Instance "ACC" -APIVersion "v3"
        Connects to the ACC instance using the v3 API version.

    .EXAMPLE
        Connect-IDNW -Instance "PRD" -APIVersion "v3" -UseSecretManagement
        Connects to the PRD instance using the v3 API version and retrieves secrets using Microsoft.PowerShell.SecretManagement.

    .PARAMETER Instance
        The IdentityNow instance to connect to.

    .PARAMETER APIVersion
        The API version to use when executing API Calls. Default is 'v3'.

    .PARAMETER UseSecretManagement
        Use Microsoft.PowerShell.SecretManagement to retrieve the IDNW secrets. Default is $false.

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Connect-IDNW {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("Environment")]
        [ValidateSet("DEV", "TST", "ACC", "PRD")]
        [String]
        $Instance,

        [Parameter(Mandatory = $false)]
        [ValidateSet("v3", "v2024", "beta")]
        [String]
        $APIVersion = 'v3',

        [Parameter(Mandatory = $false)]
        [Switch]
        $UseSecretManagement = $false
    )

    $Parameters = @{
        APIVersion          = $APIVersion
        UseSecretManagement = $UseSecretManagement
    }
    if ($PSBoundParameters.ContainsKey('Instance')) {
        Write-Verbose "Instance: $Instance"
        $Parameters.Add("Instance", $Instance)
    }
    else {
        Write-Verbose "Instance: Not Specified"
    }

    $script:IDNWEnv = Get-IDNWEnvironment @Parameters

    # Concatenate full version string with prerelease label if present
    if ($MyInvocation.MyCommand.Module -and
        $MyInvocation.MyCommand.Module.PrivateData -and
        $MyInvocation.MyCommand.Module.PrivateData.PSData) {
        $PrereleaseLabel = $MyInvocation.MyCommand.Module.PrivateData.PSData['Prerelease']
    }
    else {
        $PrereleaseLabel = $null
    }
    $ModuleVersion = $MyInvocation.MyCommand.Module.Version
    if (-not [string]::isNullOrEmpty($PrereleaseLabel)) {
        $VersionString = ("{0}-{1}" -f $ModuleVersion, $PrereleaseLabel)
    }
    else {
        $VersionString = $ModuleVersion
    }
    # Build formatted output using a here-string for alignment
    $identityNowInfo = @"

=========================================
        Connected to IdentityNow
=========================================

Instance:             $Instance
Tenant ID:            $($script:IDNWEnv.SessionTokenDetails.tenant_id)
User:                 $($script:IDNWEnv.SessionTokenDetails.user_name)
Pod:                  $($script:IDNWEnv.SessionTokenDetails.pod)
Org:                  $($script:IDNWEnv.SessionTokenDetails.org)
Authorities:          $($script:IDNWEnv.SessionTokenDetails.Authorities -join ', ')
Base URL:             $($script:IDNWEnv.BaseAPIURL)
API Version:          $($script:IDNWEnv.APIVersion)
Module Version:       $($VersionString)
Token Expires:        $($script:IDNWEnv.SessionTokenDetails.expiryDateTime)

"@

    # Write the formatted output
    Write-Output $identityNowInfo

}