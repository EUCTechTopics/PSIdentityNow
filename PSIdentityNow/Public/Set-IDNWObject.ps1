<#
    .SYNOPSIS
        Update an object in IdentityNow.

    .DESCRIPTION
        This function updates an object in IdentityNow.

    .PARAMETER ObjectType
        The type of object to update in IdentityNow.

    .PARAMETER Data
        The data to update the object with.

    .EXAMPLE
        $Data = @()
        $Data += @{
            op    = "replace"
            path  = "/description"
            value = "New Description"
        }
        Set-IDNWObject -ObjectType 'roles' -Id 92c524d2972942a48a4818ce5ef2c432 -Data $Data

    .INPUTS
        None

    .OUTPUTS
        System.Object
#>

function Set-IDNWObject {
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

        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-IDNWId -Id $_ })]
        [String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-IDNWUpdateData -Data $_ })]
        [Hashtable[]]
        $Data
    )

    # Define PATCH method to update information
    $Method = 'PATCH'

    # Convert hashtable to JSON
    $Body = ConvertTo-Json @($Data)

    # Configure the Url
    $url = "$($script:IDNWEnv.BaseAPIUrl)/$ObjectType/$Id"

    # ShouldProcess to support -WhatIf
    if ($PSCmdlet.ShouldProcess($ObjectType, "Update object")){
        # Invoke Rest Request
        Write-Verbose ('Calling {0}' -f $url)
        Write-Debug 'Body:'
        Write-Debug $body
        $Result = Invoke-IDNWRestMethod -Url $url -Method $Method -Body $Body
        Write-Debug ('Calling {0} successful' -f $url)
        return $Result
    }
}