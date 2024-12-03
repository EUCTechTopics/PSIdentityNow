<#
    .SYNOPSIS
        Checks if provided Id is a valid IdentityNow Id.

    .DESCRIPTION
        This function checks if the provided Id is a valid IdentityNow Id. If the Id is not a valid IdentityNow Id, the function will throw an error.

    .EXAMPLE
        Test-IDNWId

    .PARAMETER Id
        The Id to test.

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Test-IDNWId {
    param (
        [string]$Id
    )

    # Regular expressions for standard and compressed UUID formats
    $standardUuidPattern = '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$'
    $compressedUuidPattern = '^[a-fA-F0-9]{32}$'

    # Validate the ID against both patterns
    if ($Id -match $standardUuidPattern -or $Id -match $compressedUuidPattern) {
        return $true
    }
    else {
        return $false
    }
}