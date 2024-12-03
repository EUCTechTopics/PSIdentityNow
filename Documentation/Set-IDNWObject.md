# Set-IDNWObject

## SYNOPSIS
Update an object in IdentityNow.

## SYNTAX
```
Set-IDNWObject [-ObjectType] <string> [-Id] <string> [-Data] <hashtable[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function updates an object in IdentityNow.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
$Data = @()
$Data += @{
    op    = "replace"
    path  = "/description"
    value = "New Description"
}
Set-IDNWObject -ObjectType 'roles' -Id 92c524d2972942a48a4818ce5ef2c432 -Data $Data

```

## PARAMETERS
### -ObjectType <String>
The type of object to update in IdentityNow.
```
Required?                    true
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Id <String>

```
Required?                    true
Position?                    2
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Data <Hashtable[]>
The data to update the object with.
```
Required?                    true
Position?                    3
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

