# Remove-IDNWObject

## SYNOPSIS
Delete an object in IdentityNow.

## SYNTAX
```
Remove-IDNWObject [-ObjectType] <string> [-Id] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function deletes an object in IdentityNow.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
Remove-IDNWObject -ObjectType 'roles' -Id '50d47a8999f34e8a9e302248405ccfe8'

```

## PARAMETERS
### -ObjectType <String>
The type of object to delete in IdentityNow.
```
Required?                    true
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Id <String>
The Id of the object to delete in IdentityNow.
```
Required?                    true
Position?                    2
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -WhatIf <SwitchParameter>

```
Required?                    false
Position?                    named
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Confirm <SwitchParameter>

```
Required?                    false
Position?                    named
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```


## INPUTS
None

## OUTPUTS
None

## RELATED LINKS

