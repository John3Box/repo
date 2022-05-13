$today=get-date -f yyyy-MM-dd
$zip="K:\CET\" + "QA-cpdis-web" + "$today" + ".zip"
Get-ChildItem -Path K:\CET\iEMSWeb\-WebService\Log -filter '*.log' -ErrorAction SilentlyContinue | `
    Where-Object { $_.LastWriteTime -ge (Get-Date).AddDays(-1).Date } | `
    Compress-Archive -DestinationPath $zip
Get-ChildItem -Path K:\CET\iEMSWeb\-WebService\Profile\CommunicationStatus.ini, `
    K:\CET\iEMSWeb\-WebService\Profile\CLP.ini, `
    K:\CET\Common\PQDIFServer.ini, K:\CET\Common\Log -Filter '*.eve' | `
    Compress-Archive -Update -DestinationPath $zip

Send-MailMessage -From e_cpdisadmin@clp.com.hk -to "01c0924@xhg1smtp.clp.com.hk" -bcc "john.wong@cet-global.com", "lilly.bo@cet-global.com" -subject "[QA]: $today log" `
    -body "[QA] $today cpdis log" -Attachments "$zip" -SmtpServer XHG1SMTP.corp.clp.com.hk -Port 25

Remove-Item "$zip" -Force -ErrorAction SilentlyContinue

