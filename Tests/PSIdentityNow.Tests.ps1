Describe 'Test IDNW Lifecycle' {
    BeforeAll {
        Import-Module ../PSIdentityNow/PSIdentityNow.psm1
        Connect-IDNW
    }

    It 'Perform CRUD Operations' {

        # Define Segment Name
        $name = "PESTER TESTS $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # Create Segment
        $data = @{
            name = $name
        }
        $create_result = New-IDNWObject -ObjectType 'segments' -Data $data -Verbose -Debug
        $create_result | Should -BeOfType "System.Object"

        # Get by ID
        $result = Get-IDNWObject -ObjectType segments -Id $create_result.id -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Get by Filter
        $filters = @()
        $filters += @{
            field    = "name"
            operator = "eq"
            value    = $name
        }
        $result = Get-IDNWObject -ObjectType 'segments' -Filters $filters -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Rename
        $Data = @()
        $Data += @{
            op    = "replace"
            path  = "/name"
            value = $name + " RENAMED"
        }
        $result = Set-IDNWObject -ObjectType 'segments' -Id $create_result.id -Data $Data -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Remove
        $result = Remove-IDNWObject -ObjectType 'segments' -Id $create_result.id -Confirm:$false -Verbose -Debug
        $result | Should -Be $null

    }

    AfterAll {
        Disconnect-IDNW
    }
}Describe 'Test IDNW Lifecycle' {
    BeforeAll {
        Import-Module ../PSIdentityNow/PSIdentityNow.psm1
        Connect-IDNW
    }

    It 'Perform CRUD Operations' {

        # Define Segment Name
        $name = "PESTER TESTS $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        # Create Segment
        $data = @{
            name  = $name
        }
        $create_result = New-IDNWObject -ObjectType 'segments' -Data $data -Verbose -Debug
        $create_result | Should -BeOfType "System.Object"

        # Get by ID
        $result = Get-IDNWObject -ObjectType segments -Id $create_result.id -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Get by Filter
        $filters = @()
        $filters += @{
            field    = "name"
            operator = "eq"
            value    = $name
        }
        $result = Get-IDNWObject -ObjectType 'segments' -Filters $filters -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Rename
        $Data = @()
        $Data += @{
            op    = "replace"
            path  = "/name"
            value = $name + " RENAMED"
        }
        $result = Set-IDNWObject -ObjectType 'segments' -Id $create_result.id -Data $Data -Verbose -Debug
        $result | Should -BeOfType "System.Object"

        # Remove
        $result = Remove-IDNWObject -ObjectType 'segments' -Id $create_result.id -Confirm:$false -Verbose -Debug
        $result | Should -Be $null

    }

    AfterAll {
        Disconnect-IDNW
    }
}