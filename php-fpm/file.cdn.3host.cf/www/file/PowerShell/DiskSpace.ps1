$Drive_Name = 'N'
Write-VolumeCache $Drive_Name
$PSD = Get-PSDrive $Drive_Name

$Used = [Math]::Round(($PSD.Used/1GB), 2)
$Free = [Math]::Round(($PSD.Free/1GB), 2)
$Total = $Free + $Used
$Free_Precent = [Math]::Round(($Free / $Total * 100), 2)
#$Free_Precent = $Free_Precent.ToString() + '%';
$spaceNotUsed = $PSD.Free

$LogTime = get-date -Format "yyyy-MM-dd HH:mm:ss"
$Query = "insert into DiskSpace (Logtime, Drive_Name, Total_Space_GB, Used_Space_GB, Free_Space_GB, Free_Space_Precent, spaceNotUsed) values ('$LogTime', '$Drive_Name', '$Total', '$Used', '$Free', '$Free_Precent', '$spaceNotUsed');"

#Write-Host "$Query"
Invoke-Sqlcmd -ServerInstance '172.29.60.15' -Username 'iEMS_SERVER' -Password 'tsd@181224' -Database 'PECSTAR_DATA_CPDIS' -Query $Query
