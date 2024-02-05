BeforeAll {
    [string] $Here = [System.IO.Path]::GetDirectoryName($PSCommandPath)
    . ([System.IO.Path]::Join($Here, 'CompareDictionary.ps1'))
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}


Describe 'ConvertFrom-ExcelCellCoordinate' {
    It 'Processes ''<InputObject>'' and returns ''<Expected>''' -ForEach @(
        @{ InputObject = 'a1'; Expected = @{ Column = 1; Row = 1 } }
        @{ InputObject = 'A1'; Expected = @{ Column = 1; Row = 1 } }
        @{ InputObject = 'TI12'; Expected = @{ Column = 529; Row = 12 } }
        @{ InputObject = 'XFD12'; Expected = @{ Column = 16384; Row = 12 } }
        @{ InputObject = 'XFD1048576'; Expected = @{ Column = 16384; Row = 1048576 } }
    ) {
        $actual = ConvertFrom-ExcelCellCoordinate -InputObject $InputObject

        $actual | Compare-Dictionary -ReferenceObject $Expected `
        | Should -BeNullOrEmpty
    }
}


Describe 'Expand-ExcelCellCoordinate' {
    It 'Processes null or empty and throws an error' -ForEach @(
        @{ InputObject = $null }
        @{ InputObject = '' }
    ) {
        { Expand-ExcelCellCoordinate -InputObject $InputObject } `
        | Should -Throw -ExceptionType ArgumentException
    }

    It 'Processes ''<InputObject>'' and returns a hashtable' -ForEach @(
        @{ InputObject = 'A1' }
        @{ InputObject = 'AB12' }
    ) {
        Expand-ExcelCellCoordinate -InputObject $InputObject `
        | Should -BeOfType [hashtable]
    }

    It 'Processes ''<InputObject>'' and returns ''<Expected>''' -ForEach @(
        @{ InputObject = 'A1'; Expected = @{ Column = 'A'; Row = 1 } }
        @{ InputObject = 'AB12'; Expected = @{ Column = 'AB'; Row = 12 } }
    ) {
        Expand-ExcelCellCoordinate -InputObject $InputObject `
        | Compare-Dictionary -ReferenceObject $Expected `
        | Should -BeNullOrEmpty
    }
}


Describe 'Convert-StringToRankedAsciiCode' {
    It 'Processes ''<InputObject>'' and return an Int64 array' -ForEach @(
        @{ InputObject = $null }
        @{ InputObject = '' }
        @{ InputObject = 'A' }
        @{ InputObject = 'AB' }
    ) {
        Convert-StringToRankedAsciiCode -InputObject $InputObject `
        | Should -BeOfType [Int64[]]
    }

    It 'Processes ''<InputObject>'' and returns ''<Expected>''' -ForEach @(
        @{ InputObject = $null; Expected = @() }
        @{ InputObject = ''; Expected = @() }
        @{ InputObject = 'A'; Expected = @(65) }
        @{ InputObject = 'AB'; Expected = @(66, 65) }
    ) {
        Convert-StringToRankedAsciiCode -InputObject $InputObject `
        | Compare-Object -ReferenceObject $expected `
        | Should -BeNullOrEmpty
    }
}


Describe 'Measure-RankedAsciiCode' {
    It 'Processes ''<InputObject>'' and returns an Int64' -ForEach @(
        @{ InputObject = @(65) }
        @{ InputObject = @(65, 65) }
    ) {
        Measure-RankedAsciiCode -InputObject $InputObject `
        | Should -BeOfType [Int64]
    }

    It 'Processes ''<InputObject>'' and returns ''<Expected>''' -ForEach @(
        @{ InputObject = @(65); Expected = 1 }
        @{ InputObject = @(66); Expected = 2 }
        @{ InputObject = @(66, 65); Expected = 28 }
    ) {
        Measure-RankedAsciiCode -InputObject $InputObject `
        | Should -BeExactly $Expected
    }
}