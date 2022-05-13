$PQD = "K:\CET\PQD\"
$PQDC = "K:\CET\PQDC\"
$Today=get-date -f yyyyMMdd
$Yesterday = (get-date).Adddays(-1).Date | get-date -f yyyyMMdd
#$Total = (Get-ChildItem K:\CET\PQD\ | where { $_.Attributes -eq 'Directory' } | Measure-Object).Count
#$Meter = (Get-ChildItem K:\CET\PQD\*\$Yesterday | Measure-Object).Count
$NotFound = " [QA] $Today PQDIF Log`r`n"
$Send = $false

Get-ChildItem $PQD | where { $_.Attributes -eq 'Directory' } | ForEach-Object {
    if ( $_.Name -eq 'CPDIS_380V_LAB0608_123456D1' ) {
        return
    }
    $fn = $_.FullName + '\' + "$Yesterday" + 'T000000.pqd'
    $fn_pqdc = $PQDC + $_.Name + '\' + "$Yesterday" + 'T000000.pqd'
    if ( !(Test-Path -Path $fn) ) {
        $NotFound += " $fn is missing`r`n"
        $Send = $true
        if ( Test-Path -Path $fn_pqdc ) {
            $NotFound += " But found it in $fn_pqdc`r`n"
        }
    } else {
        ;#write-host "$fn"
    }
}

if ($Send) {
    #write-host "$NotFound"
    #<#
    Send-MailMessage -From e_cpdisadmin@clp.com.hk -to "01c0924@xhg1smtp.clp.com.hk" `
        -bcc "lilly.bo@cet-global.com", "john.wong@cet-global.com" `
        -subject "[QA]: $Today PQDIF log" -body "$NotFound" `
        -SmtpServer XHG1SMTP.corp.clp.com.hk -Port 25
    #>
}