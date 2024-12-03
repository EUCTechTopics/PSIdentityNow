# Get-IDNWObject

## SYNOPSIS
Get the specified objects from IdentityNow.

## SYNTAX
```
Get-IDNWObject -ObjectType <string> [<CommonParameters>]

Get-IDNWObject -ObjectType <string> -Filters <hashtable[]> [<CommonParameters>]

Get-IDNWObject -ObjectType <string> -Id <string> [<CommonParameters>]
```

## DESCRIPTION
This function gets the specified objects from IdentityNow. The function will return the object details.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
Get-IDNWObject -ObjectType 'roles' -Id '50d47a8999f34e8a9e302248405ccfe8'


-------------------------- EXAMPLE 2 --------------------------
$filters = @()
$filters += @{
    field = "firstname"
    operator = "eq"
    value = "John"
}
$filters += @{
    field = "identityState"
    operator = "eq"
    value = "ACTIVE"
}
Get-IDNWObject -ObjectType 'public-identities' -Filters $filters

```

## PARAMETERS
### -ObjectType <String>
The type of object to get from IdentityNow.
```
Required?                    true
Position?                    named
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Id <String>
The Id of the object to get from IdentityNow.
```
Required?                    true
Position?                    named
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Filters <Hashtable[]>
The filters to apply to the query.
```
Required?                    true
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
https://developer.sailpoint.com/docs/api/standard-collection-parameters/#primitive-operators

