<#
    .SYNOPSIS
        Create a new object in IdentityNow.

    .DESCRIPTION
        This function creates a new object in IdentityNow. The function will return the object details.

    .PARAMETER ObjectType
        The type of object to create in IdentityNow.

    .PARAMETER Data
        The data to create the object with.

    .EXAMPLE
        $data = @{
            name = "New Role"
            owner = @{
                type = "IDENTITY"
                id   = "31dbc420411c4c2adf9a7434d33666f8"
            }
        }
        New-IDNWObject -ObjectType 'roles' -Data $data

    .INPUTS
        None

    .OUTPUTS
        System.Object
#>

function New-IDNWObject {
    [CmdletBinding(
        SupportsShouldProcess = $True,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateSet("access-profiles", "roles", "segments")]
        [String]
        $ObjectType,

        [Parameter(Mandatory = $True)]
        [HashTable]
        $Data
    )

    # Define POST method to update information
    $Method = 'POST'

    # Convert hashtable to JSON
    $Body = $Data | ConvertTo-Json

    # Configure the Url
    $url = "$($script:IDNWEnv.BaseAPIUrl)/$ObjectType"

    # ShouldProcess to support -WhatIf
    if ($PSCmdlet.ShouldProcess($ObjectType, "Create object")){
        # Invoke Rest Request
        Write-Verbose ('Calling {0}' -f $url)
        Write-Debug ('Body: {0}' -f $Body)
        $Result = Invoke-IDNWRestMethod -Url $url -Method $Method -Body $Body
        Write-Debug ('Calling {0} successful' -f $url)
        return $Result
    }
}