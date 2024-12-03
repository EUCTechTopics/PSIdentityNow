<#
    .SYNOPSIS
        Connects to IdentityNow.

    .DESCRIPTION
        This function connects to IdentityNow and sets the environment variables for the specified instance.

    .EXAMPLE
        Connect-IDNW -Instance "Sandbox"

    .PARAMETER Instance
        The IdentityNow instance to connect to.

    .PARAMETER APIVersion
        The API version to use when executing API Calls. Default is 'v3'.

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Connect-IDNW {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments","")]
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Environment")]
        [ValidateSet("Sandbox","ACC", "PRD")]
        [String]
        $Instance,

        [Parameter(Mandatory = $false)]
        [ValidateSet("v3", "v2024", "beta")]
        [String]
        $APIVersion = 'v3'
    )

    switch ($Instance.ToLower()) {
        { "sandbox" } {
            $Instance = "Sandbox"
        }
         { "prd", "acc" -contains $_ } {
            $Instance = $_.ToUpper()
        }
    }

    $script:IDNWEnv = Get-IDNWEnvironment -Instance $Instance -APIVersion $APIVersion
    Write-Output @"
Connected to IdentityNow instance: $Instance
API Version: $($script:IDNWEnv.APIVersion)
Base URL: $($script:IDNWEnv.BaseURL)
Base API URL: $($script:IDNWEnv.BaseAPIURL)
Session Token Expires: $($script:IDNWEnv.SessionTokenDetails.expiryDateTime)
"@

}