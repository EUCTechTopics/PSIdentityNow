# Requires -Module Pester
Describe "Get-IDNWFilterString" {

    BeforeAll {
        . "../PSIdentityNow/PSIdentityNow/Private/Get-IDNWFilterString.ps1"
        . "../PSIdentityNow/PSIdentityNow/Private/Test-IDNWFilter.ps1"
    }

    It "should handle string values correctly" {
        $filters = @(@{ field = "name"; operator = "eq"; value = "test" })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'name eq "test"'
    }

    It "should handle integer values correctly" {
        $filters = @(@{ field = "count"; operator = "eq"; value = 5 })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'count eq 5'
    }

    It "should handle boolean values correctly" {
        $filters = @(@{ field = "enabled"; operator = "eq"; value = $true })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'enabled eq true'
    }

    It "should handle 'present' operator correctly" {
        $filters = @(@{ field = "email"; operator = "present"; value = $null })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'pr email'
    }

    It "should handle 'isnull' operator correctly" {
        $filters = @(@{ field = "lastLogin"; operator = "isnull"; value = $null })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'lastLogin isnull'
    }

    It "should handle array values with 'in' operator correctly" {
        $filters = @(@{ field = "id"; operator = "in"; value = @("one", "two") })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'id in ("one","two")'
    }

    It "should handle 'containsall' operator and arrays correctly" {
        $filters = @(@{ field = "tags"; operator = "containsall"; value = @("foo", "bar") })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'tags ca ("foo","bar")'
    }

    It "should handle 'contains' operator and string values correctly" {
        $filters = @(@{ field = "description"; operator = "contains"; value = "admin" })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'description co "admin"'
    }

    It "should handle 'startswith' operator correctly" {
        $filters = @(@{ field = "username"; operator = "startswith"; value = "dev" })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'username sw "dev"'
    }

    It "should handle DateTime values correctly" {
        $dt = Get-Date -Date "2024-01-01T12:00:00"
        $filters = @(@{ field = "created"; operator = "ge"; value = $dt })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'created ge 2024-01-01T12:00:00Z'
    }

    It "should handle multiple filters combined with 'and'" {
        $filters = @(
            @{ field = "name"; operator = "eq"; value = "admin" },
            @{ field = "enabled"; operator = "eq"; value = $true }
        )
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'name eq "admin" and enabled eq true'
    }

    It "should escape double quotes in string values" {
        $filters = @(@{ field = "comment"; operator = "eq"; value = 'He said "hello"' })
        $result = Get-IDNWFilterString -Filters $filters
        $result | Should -Be 'comment eq "He said \"hello\""'
    }

    It "should throw on unsupported value types" {
        $filters = @(@{ field = "bad"; operator = "eq"; value = @{ unexpected = "type" } })
        { Get-IDNWFilterString -Filters $filters } | Should -Throw
    }
}
