function ConvertFrom-ExcelCellCoordinate {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string] $InputObject
    )

    process {
        [hashtable] $cell = Expand-ExcelCellCoordinate -InputObject $InputObject
        [Int64[]] $asciiCodes = Convert-StringToRankedAsciiCode -InputObject $cell.Column
        [Int64] $result = Measure-RankedAsciiCode -InputObject $asciiCodes

        $cell.Column = $result

        Write-Output $cell
    }
}

function Expand-ExcelCellCoordinate {
    [OutputType([hashtable])]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string] $InputObject
    )

    process {
        if ($InputObject -notmatch '^(?<Column>[a-z]{1,3})(?<Row>\d{1,7})$') {
            throw [System.ArgumentException]::new('InputObject should be in format LettersNumbers', 'InputObject')
        }

        $cell = @{
            Row    = [Int64]$Matches['Row']
            Column = $Matches['Column'].ToUpperInvariant()
        }

        Write-Output $cell
    }
}

function Convert-StringToRankedAsciiCode {
    [OutputType([Int64[]])]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string] $InputObject
    )

    process {
        [Int64[]] $parts = $InputObject.ToCharArray();
        [Array]::Reverse($parts)

        Write-Output (, $parts)
    }
}

function Measure-RankedAsciiCode {
    [OutputType([Int64])]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [Int64[]] $InputObject
    )

    process {
        [int64] $result = 0;

        for ($i = 0; $i -lt $InputObject.Length; $i++) {
            $result += [Math]::Pow(26, $i) * ($InputObject[$i] - 64)
        }

        Write-Output $result
    }
}