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
        [Parameter(Mandatory = $true)]
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
        $UseSecrets = $false
    )

    switch ($UseSecrets) {
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
                $sail_base_url = Get-IDNWSecret -Name 'idnw-acc-base-url' -AsPlainText -UseSecrets:$UseSecrets
                $sail_client_id = Get-IDNWSecret -Name 'IDNW-ACC-CLIENT-ID' -AsPlainText -UseSecrets:$UseSecrets
                $sail_client_secret = Get-IDNWSecret -Name 'IDNW-ACC-CLIENT-SECRET'-UseSecrets:$UseSecrets
        }
        "prd" {
            if ($UseSecrets) {
                $sail_base_url = Get-IDNWSecret -Name 'IDNW-PRD-BASE-URL' -AsPlainText
                $sail_client_id = Get-IDNWSecret -Name 'IDNW-PRD-CLIENT-ID' -AsPlainText
                $sail_client_secret = Get-IDNWSecret -Name 'IDNW-PRD-CLIENT-SECRET'
            }
            else {
                $sail_base_url = $env:IDNW_PRD_BASE_URL
                $sail_client_id = $env:IDNW_PRD_CLIENT_ID
                $sail_client_secret = $env:IDNW_PRD_CLIENT_SECRET
            }
        }
    }

    # Checking for empty values
    # Define a hashtable with variable names and their corresponding values
    $variables = @{
        "sail_base_url"      = $sail_base_url
        "sail_client_id"     = $sail_client_id
        "sail_client_secret" = $sail_client_secret
    }
    # Collect missing variables
    $missing = @()
    foreach ($key in $variables.Keys) {
        if ([string]::IsNullOrEmpty($variables[$key])) {
            $missing += $key
        }
    }
    # Throw an error if any variables are missing
    if ($missing.Count -gt 0) {
        throw "The following variables are missing: $($missing -join ', ')"
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
    switch ($UseSecrets) {
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