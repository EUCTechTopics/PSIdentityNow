# New-IDNWObject

## SYNOPSIS
Create a new object in IdentityNow.

## SYNTAX
```
New-IDNWObject [-ObjectType] <string> [-Data] <hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function creates a new object in IdentityNow. The function will return the object details.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
$data = @{
    name = "New Role"
    owner = @{
        type = "IDENTITY"
        id   = "31dbc420411c4c2adf9a7434d33666f8"
    }
}
New-IDNWObject -ObjectType 'roles' -Data $data

```

## PARAMETERS
### -ObjectType <String>
The type of object to create in IdentityNow.
```
Required?                    true
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Data <Hashtable>
The data to create the object with.
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
System.Object

## RELATED LINKS

