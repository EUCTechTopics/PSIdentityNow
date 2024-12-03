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
 - segments

## Installation
```powershell
Install-Module -Name PSIdentityNow -AllowPrerelease
```

## Usage
You must provide configuration to the SDK so that it can authenticate to your IdentityNow tenant and make API calls. 

To do so, you need to configure the following environment variables.

```powershell
$env:IDNW_ACC_BASE_URL=https://[tenant]-sb.api.identitynow.com
$env:IDNW_ACC_CLIENT_ID=[clientID]
$env:IDNW_ACC_CLIENT_SECRET=[clientSecret]
$env:IDNW_PRD_BASE_URL=https://[tenant].api.identitynow.com
$env:IDNW_PRD_CLIENT_ID=[clientID]
$env:IDNW_PRD_CLIENT_SECRET=[clientSecret]
```

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