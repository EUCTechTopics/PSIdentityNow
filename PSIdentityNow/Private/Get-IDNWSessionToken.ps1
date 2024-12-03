<#
    .SYNOPSIS
        Get the session token for the specified IdentityNow instance.

    .DESCRIPTION
        This function gets the session token for the specified IdentityNow instance.

    .EXAMPLE
        Get-IDNWSessionToken -token_url "https://instance-sb.api.identitynow.com/oauth/token" -token_client_id $env:IDNW_ACC_CLIENT_ID -token_client_secret $env:IDNW_ACC_CLIENT_SECRET

    .PARAMETER token_url
        The URL to retrieve the session token from.

    .PARAMETER token_client_id
        The client ID to use to retrieve the session token.

    .PARAMETER token_client_secret
        The client secret to use to retrieve the session token.

    .INPUTS
        None

    .OUTPUTS
        System.Security.SecureString
#>

function Get-IDNWSessionToken {
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [parameter(mandatory = $true)]
        [String]
        $token_url,

        [parameter(mandatory = $true)]
        [String]
        $token_client_id,

        [parameter(mandatory = $true)]
        [String]
        $token_client_secret
    )

    # Get access token from IdentityNow
    $postParams = @{
        grant_type    = "client_credentials"
        client_id     = $token_client_id
        client_secret = $token_client_secret
    }

    try {
        Write-Verbose ('Retrieving session token for IdentityNow from {0}' -f $token_url)

        # Retrieve the token from the REST API
        $token = (Invoke-RestMethod -Uri $token_url -Method POST -Body $postParams).access_token

        # Convert the token to a SecureString without -AsPlainText
        $secureToken = New-Object -TypeName System.Security.SecureString
        $token.ToCharArray() | ForEach-Object { $secureToken.AppendChar($_) }
        $secureToken.MakeReadOnly()

        # Securely remove plaintext token from memory
        Remove-Variable -Name token -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Debug ('Error retrieving session token for IdentityNow from {0}' -f $token_url)
        throw "Unable to retrieve session token from IdentityNow"
    }

    Write-Output $secureToken
}
