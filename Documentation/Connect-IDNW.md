# Connect-IDNW

## SYNOPSIS
Connects to IdentityNow.

## SYNTAX
```
Connect-IDNW [[-Instance] <string>] [[-APIVersion] <string>] [-UseSecretManagement] [<CommonParameters>]
```

## DESCRIPTION
This function connects to IdentityNow and sets the environment variables for the specified instance.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
Connect-IDNW -Instance "DEV" -APIVersion "beta"
Connects to the DEV instance using the beta API version.


-------------------------- EXAMPLE 2 --------------------------
Connect-IDNW -Instance "TST" -APIVersion "v3"
Connects to the TST instance using the v3 API version.


-------------------------- EXAMPLE 3 --------------------------
Connect-IDNW -Instance "ACC" -APIVersion "v3"
Connects to the ACC instance using the v3 API version.


-------------------------- EXAMPLE 4 --------------------------
Connect-IDNW -Instance "PRD" -APIVersion "v3" -UseSecretManagement
Connects to the PRD instance using the v3 API version and retrieves secrets using Microsoft.PowerShell.SecretManagement.

```

## PARAMETERS
### -Instance <String>
The IdentityNow instance to connect to.
```
Required?                    false
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -APIVersion <String>
The API version to use when executing API Calls. Default is 'v3'.
```
Required?                    false
Position?                    2
Default value                v3
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -UseSecretManagement <SwitchParameter>
Use Microsoft.PowerShell.SecretManagement to retrieve the IDNW secrets. Default is $false.
```
Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false
```


## INPUTS
None

## OUTPUTS
None

## RELATED LINKS

