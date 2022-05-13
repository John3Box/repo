$Drive = "N"
$Now = Get-Date
$Log = 'K:\CET\' + $Drive + 'drive_' + (Get-Date -Format yyyy-MM) + '.log'

Get-PSDrive "$Drive" | Where-Object {
    $Total = [Math]::Round((($_.Used + $_.Free)/1GB), 2)
    $Free = [Math]::Round(($_.Free/1GB), 2)
    $Used = [Math]::Round(($_.Used/1GB), 2)
    $Free_Precent = [Math]::Round(($Free / $Total * 100), 2)

    $Subject = "[QA]: DB drive less than $Free GB ($Free_Precent%) free space"
    $Content = "$Now" + ": [QA] Total: $Total GB, Used: $Used GB, Free Space ($Free_Precent%): $Free GB"

    Write-Output "$Content" | Out-File -Append -FilePath "$Log"
    $Body = Get-Content -Delimiter "`n" $Log

    if ((($_.free/($_.free+$_.used)) -le 0.15) -or ((get-date).AddDays(+1).day -eq '1')) {
        #Write-Host "Subject: $Subject, Body: $Body"
	    Send-MailMessage -to "01c0924@xhg1smtp.clp.com.hk" -Bcc "john.wong@cet-global.com" -from "E_CPDISADMIN@clp.com.hk" -subject "$Subject" -body "$Body" -SmtpServer "xhg1smtp.corp.clp.com.hk" -Port 25
    #} else {
        Send-MailMessage -to "01c0924@xhg1smtp.clp.com.hk" -from "E_CPDISADMIN@clp.com.hk" -subject "$Subject" -body "$Body" -SmtpServer "xhg1smtp.corp.clp.com.hk" -Port 25
    }
}

