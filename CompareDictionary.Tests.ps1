BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}


Describe 'Compare-Dictionary' {
    It 'Compare null args return nothing' {
        { Compare-Dictionary `
                -ReferenceObject $null `
                -DifferenceObject $null `
        } | Should -Throw
    }

    It 'Compare dictionaries with different items in same order should return results' {
        Compare-Dictionary `
            -ReferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
            -DifferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2'; 'Key3' = 'Value 3' } `
        | Should -Not -BeNullOrEmpty
    }

    It 'Compare dictionaries with different items in different order should return results' {
        Compare-Dictionary `
            -ReferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
            -DifferenceObject @{ 'Key3' = 'Value 3'; 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
        | Should -Not -BeNullOrEmpty
    }

    It 'Compare dictionaries with same items in same order should throw error' {
        Compare-Dictionary `
            -ReferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
            -DifferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
        | Should -BeNullOrEmpty
    }

    It 'Compare dictionaries with same items in different order should return nothing' {
        Compare-Dictionary `
            -ReferenceObject @{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' } `
            -DifferenceObject @{ 'Key2' = 'Value 2'; 'Key1' = 'Value 1' } `
        | Should -BeNullOrEmpty
    }

    It 'Compare ordered dictionaries with different items in same order should return results' {
        Compare-Dictionary `
            -ReferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
            -DifferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2'; 'Key3' = 'Value 3' }) `
        | Should -Not -BeNullOrEmpty
    }

    It 'Compare ordered dictionaries with different items in different order should return results' {
        Compare-Dictionary `
            -ReferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
            -DifferenceObject ([ordered]@{ 'Key3' = 'Value 3'; 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
        | Should -Not -BeNullOrEmpty
    }

    It 'Compare ordered dictionaries with same items in same order should return nothing' {
        Compare-Dictionary `
            -ReferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
            -DifferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
        | Should -BeNullOrEmpty
    }

    It 'Compare ordered dictionaries with same items in different order should return results' {
        Compare-Dictionary `
            -ReferenceObject ([ordered]@{ 'Key1' = 'Value 1'; 'Key2' = 'Value 2' }) `
            -DifferenceObject ([ordered]@{ 'Key2' = 'Value 2'; 'Key1' = 'Value 1' }) `
        | Should -Not -BeNullOrEmpty
    }
}