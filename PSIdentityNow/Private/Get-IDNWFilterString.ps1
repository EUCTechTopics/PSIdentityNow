<#
    .SYNOPSIS
        Helper function to generate filterstring.

    .DESCRIPTION
        Converts a hashtable of filters to a string that can be used in IdentityNow API requests.

    .EXAMPLE
        $filters = @()
        $filters += @{
            field    = "id"
            operator = "in"
            value    = "asdf"
        }
        Get-IDNWObject -ObjectType 'roles' -Filters $filters -Verbose

    .PARAMETER Filters
        An array of hashtables containing the filter details.

    .INPUTS
        None

    .OUTPUTS
        System.String
#>
function Get-IDNWFilterString {
    [CmdletBinding(
        SupportsShouldProcess = $False,
        ConfirmImpact = "None",
        SupportsPaging = $False,
        PositionalBinding = $True)
    ]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-IDNWFilter -Filters $_ })]
        [Hashtable[]]
        $Filters
    )

    # Initiate Empty FilterItems Array
    $FilterItems = @()

    $Filters | ForEach-Object {
        # Convert the operator to the IdentityNow API format
        switch ($_.operator.ToLower()) {
            'containsall' { $operator = "ca" }
            'contains' { $operator = "co" }
            'present' { $operator = "pr" }
            'startswith' { $operator = "sw" }
            default { $operator = $_ }
        }
        $field = $_.field
        $value = $_.value

        # Handle operators that don't require a value
        if ($operator -eq 'pr') {
            $FilterItems += ('{0} {1}' -f $operator, $field)
        }
        elseif ($operator -eq 'isnull') {
            $FilterItems += ('{0} {1}' -f $field, $operator)
        }
        # Handle cases where the value is a collection (e.g., "ca", "in")
        elseif ($value -is [array]) {
            $formattedValues = ("""" + ($value -join '","') + """") # Add quotes and commas
            $FilterItems += ('{0} {1} ({2})' -f $field, $operator, $formattedValues)
        }
        # Handle numeric values
        elseif ($value -is [int]) {
            $FilterItems += ('{0} {1} {2}' -f $field, $operator, $value)
        }
        # Handle boolean values
        elseif ($value -is [bool]) {
            $FilterItems += ('{0} {1} {2}' -f $field, $operator, $value.ToString().ToLower())
        }
        # Handle string values (add quotes and escape special characters)
        elseif ($value -is [string]) {
            $escapedValue = $value.Replace('"', '\"') # Escape double quotes
            $FilterItems += ('{0} {1} "{2}"' -f $field, $operator, $escapedValue)
        }
        # Handle date values (format to ISO 8601)
        elseif ($value -is [datetime]) {
            $isoDate = $value.ToString("yyyy-MM-ddTHH:mm:ssZ")
            $FilterItems += ('{0} {1} {2}' -f $field, $operator, $isoDate)
        }
        # Fallback for unknown types
        else {
            throw "Unsupported value type for field '$field' and operator '$operator'."
        }
    }

    # Join the filter items with "and"
    $FilterString = ($FilterItems -join ' and ')

    # Return FilterString
    return $FilterString

}