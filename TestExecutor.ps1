[string] $Here = [System.IO.Path]::GetDirectoryName($PSCommandPath)

$filesToTest = @(
    ([System.IO.Path]::Join($Here, 'CompareDictionary.Tests.ps1'))
    ([System.IO.Path]::Join($Here, 'ExcelCoordinates.Tests.ps1'))
)

$filesToCover = @(
    ([System.IO.Path]::Join($Here, 'CompareDictionary.ps1'))
    ([System.IO.Path]::Join($Here, 'ExcelCoordinates.ps1'))
)

$filesToAnalyze = @(
    ([System.IO.Path]::Join($Here, 'CompareDictionary.ps1'))
    ([System.IO.Path]::Join($Here, 'ExcelCoordinates.ps1'))
)

Clear-Host
Import-Module Pester
$config = New-PesterConfiguration
$config.Run.Path = $filesToTest
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = $filesToCover

Invoke-Pester -Configuration $config


Import-Module PSScriptAnalyzer

foreach ($file in $filesToAnalyze) {
    Invoke-ScriptAnalyzer -Path $file
}