# Invoke-IDNWRestMethod

## SYNOPSIS
Invoke the IdentityNow REST API.

## SYNTAX
```
Invoke-IDNWRestMethod [-Url] <string> [[-UrlParams] <hashtable>] [[-Method] <string>] [[-Body] <string>] [[-ContentType] <string>] [[-MaxRetries] <int>] [[-PauseDuration] <int>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to invoke a REST method to the IdentityNow API. It will handle pagination and retries.

## EXAMPLES
```powershell
-------------------------- EXAMPLE 1 --------------------------
Invoke-IDNWRestMethod -Url '/roles' -Method 'GET'

```

## PARAMETERS
### -Url <String>
The relative URL to call.
```
Required?                    true
Position?                    1
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -UrlParams <Hashtable>
The parameters to add to the URL.
```
Required?                    false
Position?                    2
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Method <String>
The HTTP method to use.
```
Required?                    false
Position?                    3
Default value                GET
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -Body <String>
The body of the request.
```
Required?                    false
Position?                    4
Default value                
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -ContentType <String>
The content type of the request.
```
Required?                    false
Position?                    5
Default value                application/json
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -MaxRetries <Int32>
The maximum number of retries to attempt.
```
Required?                    false
Position?                    6
Default value                3
Accept pipeline input?       false
Accept wildcard characters?  false
```
### -PauseDuration <Int32>
The duration to pause between retries.
```
Required?                    false
Position?                    7
Default value                2
Accept pipeline input?       false
Accept wildcard characters?  false
```


## INPUTS
None

## OUTPUTS
System.Object[]

## RELATED LINKS

