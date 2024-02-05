function Compare-Dictionary {
    [OutputType([object[]])]
    param(
        [System.Collections.IDictionary] $ReferenceObject,
        [Parameter(ValueFromPipeline = $true)]
        [System.Collections.IDictionary] $DifferenceObject
    )

    process {
        [int] $syncWindow = if ($ReferenceObject -is [ordered] -or $DifferenceObject -is [ordered]) { 0 } else { [Int32]::MaxValue }

        $results = @()
        $results += Compare-Object -ReferenceObject ([array]$ReferenceObject.Keys) -DifferenceObject ([array]$DifferenceObject.Keys) -SyncWindow $syncWindow
        $results += Compare-Object -ReferenceObject ([array]$ReferenceObject.Values) -DifferenceObject ([array]$DifferenceObject.Values) -SyncWindow $syncWindow

        return , $results
    }
}
