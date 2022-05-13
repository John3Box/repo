$bu1 = "S:\DBBKUP\PECSTAR_CONFIG_CPDIS_backup_2021_12_16_210009_6459815.bak"
$bu2 = "S:\DBBKUP\PECSTAR_DATA_CPDIS_backup_2021_12_16_210009_6459815.bak"

$db1 = "PECSTAR_CONFIG_CPDIS"
$db2 = "PECSTAR_DATA_CPDIS"

$7z = "K:\CET\Common\7z.exe"
$today = Get-Date -Format "yyyy-MM-dd"
$wd = "N:\CET\" + "$today"

Write-VolumeCache "N"
Write-VolumeCache "S"

if ( -not (Test-Path -Path "$wd") ) {
    mkdir -Path "$wd"
}
Set-Location "$wd"

function get-archive
{
    param (
        $_db,
        $_bu
    )
    & "$7z" "a" "-pcet" "-v2g" "$_db" "$_bu"

    Write-VolumeCache "N"
    Start-Sleep -Seconds 5
    Write-VolumeCache "N"

    ls $wd | foreach {
        $fn = $_.FullName
        $sha256 = $wd + '\' + "$_db" + '.sha256.txt'
        #Write-Output "$fn $sha256"
        Get-FileHash -Path $fn | Out-File -Append -FilePath $sha256
    }
}
get-archive "$db1" "$bu1"
get-archive "$db2" "$bu2"

