<#
    .SYNOPSIS
        Get the secret value for the specified secret name.

    .DESCRIPTION
        This function gets the secret value for the specified secret name. The function will return the secret value as a string.

    .EXAMPLE
        Get-IDNWSecret -Name 'idnw-acc-base-url'

    .PARAMETER Name
        The name of the secret to retrieve.

    .PARAMETER AsPlainText
        Defines how the secret value should be retrieved.

    .PARAMETER UseSecretManagement
        Use the Secrets Management module to retrieve the secret.

    .INPUTS
        None

    .OUTPUTS
        System.String
        System.Securiy.SecureString
#>
function Get-IDNWSecret {
    param (
        [string]$Name,
        [switch]$AsPlainText = $false,
        [switch]$UseSecretManagement = $false
    )
    if ($UseSecretManagement) {
        try {
            return Get-Secret -Name $Name.ToUpper() -AsPlainText:$AsPlainText
        }
        catch [System.Management.Automation.ItemNotFoundException] {
            Write-Verbose "Secret $Name not found. Attempting to retrieve secret in lowercase."
            return Get-Secret -Name $Name.ToLower() -AsPlainText:$AsPlainText
        }
        catch {
            throw $_
        }
    } else {
        # Try both original and lowercase formatted versions
        $formattedNames = @(
            $name.ToUpper().Replace('-', '_'),
            $name.ToLower().Replace('-', '_')
        )

        foreach ($formattedName in $formattedNames) {
            $value = [environment]::GetEnvironmentVariable($formattedName)
            if (-not [string]::IsNullOrEmpty($value)) {
                return $value
            }
        }

        throw "Secret $Name not found."

    }
}