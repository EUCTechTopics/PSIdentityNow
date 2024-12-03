<#
    .SYNOPSIS
        Checks if the filters are valid.

    .DESCRIPTION
        This function checks if the filters are valid. If the filters are not valid, the function will throw an error.

    .EXAMPLE
        Test-Filters -Filters $Filters

    .INPUTS
        None

    .OUTPUTS
        None
#>

function Test-IDNWFilter {
    param (
        [Hashtable[]]$Filters
    )

    foreach ($Filter in $Filters) {
        # Ensure required keys are present based on the operator
        if (-not $Filter.ContainsKey('field') -or -not $Filter.ContainsKey('operator')) {
            throw "Each filter must contain at least 'field' and 'operator'. Invalid filter: $($filter.GetEnumerator().ForEach({ "$($_.Name)=$($_.Value)" }))"
        }

        $operator = $Filter['operator'].ToLower()

        # Operators that don't require a 'value'
        $noValueOperators = @('pr', 'isnull')

        if ($operator -in $noValueOperators) {
            if ($Filter.ContainsKey('value') -and $null -ne $Filter['value']) {
                throw "The 'value' key must not be present or must be null for operator '$operator'. Invalid filter: $($filter.GetEnumerator().ForEach({ "$($_.Name)=$($_.Value)" }))"
            }
        }
        # All other operators require a 'value'
        else {
            if (-not $Filter.ContainsKey('value')) {
                throw "The 'value' key is required for operator '$operator'. Invalid filter: $($filter.GetEnumerator().ForEach({ "$($_.Name)=$($_.Value)" }))"
            }

            $value = $Filter['value']

            # Validate the type of 'value'
            if (-not (
                $value -is [string] -or
                $value -is [array] -or
                $value -is [int] -or
                $value -is [bool] -or
                $value -is [datetime]
            ) ) {
                throw "Invalid value type for field '$($Filter['field'])' with operator '$operator'. Allowed types: string, array, int, bool, datetime. Invalid filter: $($filter.GetEnumerator().ForEach({ "$($_.Name)=$($_.Value)" }))"
            }
        }

        # Ensure the operator is valid
        if (-not ($operator -in @('eq', 'ne', 'co', 'contains', 'sw', 'startswith', 'pr', 'present', 'isnull', 'ca', 'containsall', 'gt', 'lt', 'ge', 'le', 'in'))) {
            throw "Invalid operator '$operator' in filter. Allowed operators: eq, ne, co, contains, sw, startswith, pr, present, isnull, ca, containsall, gt, lt, gte, lte, in."
        }
    }
    return $true
}