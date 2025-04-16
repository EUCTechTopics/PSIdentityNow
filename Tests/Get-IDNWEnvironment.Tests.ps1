# Requires -Module Pester
Describe "Get-IDNWEnvironment" {

    BeforeAll {
        . "../PSIdentityNow/PSIdentityNow/Private/Get-IDNWEnvironment.ps1"
        . "../PSIdentityNow/PSIdentityNow/Private/Get-IDNWSecret.ps1"
        . "../PSIdentityNow/PSIdentityNow/Private/Get-IDNWSessionToken.ps1"
        . "../PSIdentityNow/PSIdentityNow/Private/Get-IDNWTokenDetail.ps1"
    }

    It "Should return a valid token" {
        $Environment = Get-IDNWEnvironment -Instance "ACC" -ApiVersion "v3" -UseSecretManagement:$false
        $Environment.SessionToken | Should -BeOfType "System.Security.SecureString"
        [guid]$Environment.SessionTokenDetails.tenant_id | Should -BeOfType "System.Guid"
    }

}
