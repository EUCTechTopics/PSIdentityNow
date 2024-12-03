<#
    .SYNOPSIS
        Checks if the provided data is valid.

    .DESCRIPTION
        This function checks if the provided data to update an object is valid.

    .EXAMPLE
        Test-IDNWUpdateData -Data $Data

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Test-IDNWUpdateData {
    param (
        [Hashtable[]]$Data
    )

    $Data | ForEach-Object {
        # Check if op is allowed
        if ($_.op -notin @('add', 'remove', 'replace', 'move', 'copy', 'test')) {
            throw "Invalid op '$($_.op)'. Allowed values: 'add', 'remove', 'replace', 'move', 'copy', 'test'"
        }
    }
    return $true
}