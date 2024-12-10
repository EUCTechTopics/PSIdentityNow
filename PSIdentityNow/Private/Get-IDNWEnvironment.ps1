<#
    .SYNOPSIS
        Get the environment details for the specified IdentityNow instance.

    .DESCRIPTION
        This function gets the environment details for the specified IdentityNow instance. The function will return the base URL, the base API URL, the session token data, the session token, and the API version.

    .EXAMPLE
        Get-IDNWEnvironment -Instance "Sandbox"

    .PARAMETER Instance
        The IdentityNow instance to get the environment details for.

    .INPUTS
        None

    .OUTPUTS
        PSCustomObject
#>

function Get-IDNWEnvironment {
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $false)]
        [Alias("Environment")]
        [ValidateSet("Sandbox", "ACC", "PRD")]
        [String]
        $Instance,

        [Parameter(Mandatory = $true)]
        [ValidateSet("v3", "v2024", "beta")]
        [String]
        $APIVersion,

        [Parameter(Mandatory = $true)]
        [Switch]
        $UseSecretManagement
    )

    switch ($UseSecretManagement) {
        $true {
            Write-Verbose "Using Secrets Management module to retrieve secrets"
            if (-not (Get-Command -Name Get-Secret -ErrorAction SilentlyContinue)) {
                throw "Get-Secret function not available. Please import the Microsoft.PowerShell.SecretManagement module."
            }
        }
        $false {
            Write-Verbose "Using Environment Variables to retrieve secrets"
        }
    }

    # Determine correct set of secrets for session
    switch ($Instance.ToLower()) {
        { "sandbox", "acc" -contains $_ } {
            $sail_base_url = Get-IDNWSecret -Name 'IDNW-ACC-BASE-URL' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_id = Get-IDNWSecret -Name 'IDNW-ACC-CLIENT-ID' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_secret = Get-IDNWSecret -Name 'IDNW-ACC-CLIENT-SECRET'-UseSecretManagement:$UseSecretManagement
        }
        "prd" {
            $sail_base_url = Get-IDNWSecret -Name 'IDNW-PRD-BASE-URL' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_id = Get-IDNWSecret -Name 'IDNW-PRD-CLIENT-ID' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_secret = Get-IDNWSecret -Name 'IDNW-PRD-CLIENT-SECRET'-UseSecretManagement:$UseSecretManagement
        }
        default {
            $sail_base_url = Get-IDNWSecret -Name 'IDNW-BASE-URL' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_id = Get-IDNWSecret -Name 'IDNW-CLIENT-ID' -AsPlainText -UseSecretManagement:$UseSecretManagement
            $sail_client_secret = Get-IDNWSecret -Name 'IDNW-CLIENT-SECRET'-UseSecretManagement:$UseSecretManagement
        }
    }

    $sessiontokendata = @{
        token_url           = "$sail_base_url/oauth/token"
        token_client_id     = $sail_client_id
        token_client_secret = $sail_client_secret
    }

    $Params = @{
        token_url           = $sessiontokendata.token_url
        token_client_id     = $sessiontokendata.token_client_id
    }

    switch ($UseSecretManagement) {
        $true {
            $token_client_secret = ConvertFrom-SecureString $sessiontokendata.token_client_secret -AsPlainText
            $Params.Add('token_client_secret', $token_client_secret)
        }
        $false {
            $Params.Add('token_client_secret', $sessiontokendata.token_client_secret)
        }
    }
    
    $SessionToken = Get-IDNWSessionToken @Params
    Remove-Variable -Name Params -Force
    $SessionTokenDetails = Get-IDNWTokenDetail -SecureToken $SessionToken

    $output = [PSCustomObject]@{
        Instance            = $Instance
        BaseUrl             = $sail_base_url -replace '.api', ''
        BaseAPIUrl          = ('{0}/{1}' -f $sail_base_url, $APIVersion)
        SessionTokenData    = $sessiontokendata
        SessionToken        = $SessionToken
        SessionTokenDetails = $SessionTokenDetails
        APIVersion          = $APIVersion
    }

    return $output
}