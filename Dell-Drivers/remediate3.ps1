<#
.SYNOPSIS
    Update Dell Drivers using Dell Command Update. 

.DESCRIPTION
    Please make sure that Dell Command update is installed on the machines
    
.NOTES
    Filename: remediate3.ps1
    1.0   -   Script created

#>

$DCU_Dir = "C:\Program Files\Dell\CommandUpdate"
$DCU_report = "C:\Temp\Dell_report\update.log"
$DCU_exe = "$DCU_Dir\dcu-cli.exe"
$DCU_category = "firmware,driver,application"  # bios,firmware,driver,application,others
$DCU_Severity = "security,critial,recommended"


try{
    Start-Process $DCU_exe -ArgumentList "/applyUpdates -silent -reboot=disable -updateType=$DCU_category -updateSeverity=$DCU_Severity -updatesNotification=disable -outputlog=$DCU_report" -Wait
    Write-Output "Installation completed"
}catch{
    Write-Error $_.Exception
}