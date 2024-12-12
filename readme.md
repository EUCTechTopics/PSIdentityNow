# PSIdentityNow
[![PSIdentityNow](https://img.shields.io/powershellgallery/v/PSIdentityNow.svg?style=flat-square&label=Powershell%20Gallery)](https://www.powershellgallery.com/packages/PSIdentityNow/)
![powershell gallery](https://img.shields.io/powershellgallery/dt/PSIdentityNow)
[![License](https://img.shields.io/badge/license-GPL&ndash;3.0-blue.svg)](https://github.com/EUCTechTopics/PSIdentityNow/blob/main/LICENSE) 
<img src="https://img.shields.io/badge/supports ps-core-blue.svg"></img>

## Summary
A PowerShell module to interact with the IdentityNow REST API.

<details>
<summary>A bit more...</summary>
I’m excited to share my first publicly released PowerShell module!<br>
I decided to create this because the official SailPoint PowerShell module didn’t quite meet my needs when it came to error handling and ease of use.<br>
My goal was to keep things as simple and modular as possible.<br>
If you run into any bugs or have feedback, please let me know by raising an issue—I’d love to hear from you!<br>
</details>

## Key Features

- Handles retrying failed request
- Supports pagination
- Automatically generates filter string

Currently supports the following Objects:
 - access-profiles
 - public-identities
 - roles
 - requestable-objects
 - segments

## Installation
```powershell
Install-Module -Name PSIdentityNow -AllowPrerelease
```

### SDK Configuration for Authentication

To use the SDK with your IdentityNow tenant, you must configure authentication by providing the required environment variables or using Azure Key Vault (or another vault) with the Microsoft.PowerShell.SecretManagement module.

#### Option 1: Use Environment Variables

1. **Set Environment Variables**

    Set the following environment variables to authenticate to your IdentityNow tenant:

    ```powershell
    $env:IDNW_ACC_BASE_URL=https://[tenant]-sb.api.identitynow.com
    $env:IDNW_ACC_CLIENT_ID=[clientID]
    $env:IDNW_ACC_CLIENT_SECRET=[clientSecret]
    $env:IDNW_PRD_BASE_URL=https://[tenant].api.identitynow.com
    $env:IDNW_PRD_CLIENT_ID=[clientID]
    $env:IDNW_PRD_CLIENT_SECRET=[clientSecret]
    ```

    Replace `[tenant]`, `[clientID]`, and `[clientSecret]` with your specific values.

2. **Connect to IdentityNow using SecretManagement**

   Use the `Connect-IDNW` command to authenticate using secrets from the registered Key Vault. Specify the `Instance` (e.g., `ACC` or `PRD`) as needed:

   ```powershell
   Connect-IDNW -Instance ACC
   ```

#### Option 2: Use Azure Key Vault with SecretManagement
You can securely store and manage the required credentials in Azure Key Vault and use the `Microsoft.PowerShell.SecretManagement` module to access them.

1. **Register your Key Vault**

   Use the following command to register your Azure Key Vault:

   ```powershell
   $kvparams = @{
       AZKVaultName = "KEYVAULT-NAME"
       SubscriptionId = "subscription-id"
   }
   Register-SecretVault -Name 'KEYVAULT-NAME' -ModuleName Az.KeyVault -VaultParameters $kvparams -Verbose
   ```

   Replace `KEYVAULT-NAME` with your Key Vault name and `subscription-id` with your Azure subscription ID.

2. **Add Secrets to Key Vault**

   Ensure the required secrets are stored in your Azure Key Vault. The secrets should correspond to the following environment variable names:

   - `IDNW_ACC_BASE_URL`
   - `IDNW_ACC_CLIENT_ID`
   - `IDNW_ACC_CLIENT_SECRET`
   - `IDNW_PRD_BASE_URL`
   - `IDNW_PRD_CLIENT_ID`
   - `IDNW_PRD_CLIENT_SECRET`

3. **Connect to IdentityNow using SecretManagement**

   Use the `Connect-IDNW` command with the `-UseSecretManagement` parameter to authenticate using secrets from the registered Key Vault. Specify the `Instance` (e.g., `ACC` or `PRD`) as needed:

   ```powershell
   Connect-IDNW -Instance ACC -UseSecretManagement
   ```

   This retrieves the required secrets from your registered Key Vault and authenticates the SDK.

### Notes
- Make sure the Azure Key Vault and the `Microsoft.PowerShell.SecretManagement` module are properly configured and accessible from your environment.
- For more information, consult the the [SecretManagement module documentation](https://learn.microsoft.com/powershell/module/microsoft.powershell.secretmanagement/).


## Functions
#### [Connect-IDNW](Documentation/Connect-IDNW.md)
Connects to IdentityNow.
#### [Disconnect-IDNW](Documentation/Disconnect-IDNW.md)
Disconnects from IdentityNow.
#### [Get-IDNWObject](Documentation/Get-IDNWObject.md)
Get the specified objects from IdentityNow.
#### [New-IDNWObject](Documentation/New-IDNWObject.md)
Create a new object in IdentityNow.
#### [Remove-IDNWObject](Documentation/Remove-IDNWObject.md)
Delete an object in IdentityNow.
#### [Set-IDNWObject](Documentation/Set-IDNWObject.md)
Update an object in IdentityNow.

## Reporting Issues and Feedback
- [File a bug report](https://github.com/EUCTechTopics/PSIdentityNow/issues/new?assignees=&labels=bug)
- [Raise a feature request](https://github.com/EUCTechTopics/PSIdentityNow/issues/new?assignees=&labels=enhancement)
- [Something else](https://github.com/EUCTechTopics/PSIdentityNow/issues/new/choose)

## Changelog
- [Changelog](/CHANGELOG.md)