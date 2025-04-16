# Requires -Module Pester
Describe "Get-IDNWEnvironment" {

    BeforeAll {
        . "../PSIdentityNow/Private/Get-IDNWEnvironment.ps1"
        . "../PSIdentityNow/Private/Get-IDNWSecret.ps1"
        . "../PSIdentityNow/Private/Get-IDNWSessionToken.ps1"
        . "../PSIdentityNow/Private/Get-IDNWTokenDetail.ps1"
    }

    It "Should return a valid token" {
        $Environment = Get-IDNWEnvironment -ApiVersion "v3" -UseSecretManagement:$false
        $Environment.SessionToken | Should -BeOfType "System.Security.SecureString"
        [guid]$Environment.SessionTokenDetails.tenant_id | Should -BeOfType "System.Guid"
    }

}
