# Connect-IDNW

## SYNOPSIS
Connects to IdentityNow.

## SYNTAX
```
Connect-IDNW [-Instance] <string> [[-APIVersion] <string>] [<CommonParameters>]
```

## DESCRIPTION
This function connects to IdentityNow and sets the environment variables for the specified instance.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
Connect-IDNW -Instance "Sandbox"

```

## PARAMETERS
### -Instance <String>
The IdentityNow instance to connect to.
```
Required?                    true
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


## INPUTS
None

## OUTPUTS
None

## RELATED LINKS

