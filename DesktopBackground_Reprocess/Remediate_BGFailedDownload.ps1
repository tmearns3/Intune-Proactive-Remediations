$reg_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$reg_desktop_val = "DesktopImageStatus"
$reg_desktop_url = "DesktopImageUrl"
$reg_desktop_path = "DesktopImagePath"
$reg_lockscr_val = "LockScreenImageStatus"
$reg_lockscr_url = "LockScreenImageUrl"
$reg_lockscr_path = "LockScreenImagePath"


If (!(Test-Path $reg_path)) {
    Write-Warning "No reg key, we shouldn't get here"
    Exit 1
}

Remove-ItemProperty -Path $reg_path -Name $reg_desktop_val -Force
Remove-ItemProperty -Path $reg_path -Name $reg_desktop_url -Force
Remove-ItemProperty -Path $reg_path -Name $reg_desktop_path -Force

Remove-ItemProperty -Path $reg_path -Name $reg_lockscr_val -Force
Remove-ItemProperty -Path $reg_path -Name $reg_lockscr_url -Force
Remove-ItemProperty -Path $reg_path -Name $reg_lockscr_path -Force

Exit 0



