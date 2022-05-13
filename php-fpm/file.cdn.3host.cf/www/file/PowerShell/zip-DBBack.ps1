Write-VolumeCache "N"

ls "N:\CET\DBBack\MAIN" |  where { $_.Attributes -eq 'Directory' } | `
foreach {
    $fn = $_.FullName
    #$d = $fn.ToString() + '.d'
    $zip = $fn.ToString() + '.zip'
    $sha256 = $zip.ToString() + '.sha256.txt'

    #Write-Host "Compress-Archive -Path $fn -DestinationPath $zip -CompressionLeve Optimal -Force"
    
    Compress-Archive -Path $fn -DestinationPath $zip -CompressionLeve Optimal -Force
    Write-VolumeCache "N"
    Start-Sleep -Seconds 2
    Get-FileHash -Path $zip | Out-File -FilePath $sha256
}