$Namespaces = Get-Content "namespaces.txt"
$timestampForFile = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "pod-metrics-$timestampForFile.log"

while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp"

    foreach ($Namespace in $Namespaces) {
        Add-Content -Path $LogFile -Value "Namespace: $Namespace"

        $output = kubectl top pod -n $Namespace 2>&1  # Error if don't have pods
        foreach ($line in $output) {
            Add-Content -Path $LogFile -Value $line.TrimEnd()
        }

        Add-Content -Path $LogFile -Value "" # Empty row between namespaces
    }

    Add-Content -Path $LogFile -Value "`n--------------------------------------------------------------------------------------`n"

    Start-Sleep -Seconds 3600
}
