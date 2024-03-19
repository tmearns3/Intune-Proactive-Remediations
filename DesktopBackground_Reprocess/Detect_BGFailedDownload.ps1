# Applying the desktop and lock screen backgrounds from a locally deployed picture
# sometimes fails if the policy runs before the picture is available, resulting in
# a stuck "trying to download" state
# If status is 2 (in progress) or 3 (failed), delete the keys and let it try again


$reg_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$reg_desktop_val = "DesktopImageStatus"
$reg_lockscr_val = "LockScreenImageStatus"
$status_inprog = "2"
$status_fail = "3"

If (!(Test-Path $reg_path)) {
    Write-Output "Background set pending"
    Exit 0
}

Try {
    $reg_desktop_status = Get-ItemProperty -Path $reg_path -Name $reg_desktop_val -ErrorAction Stop | Select-Object -ExpandProperty $reg_desktop_val
    $reg_lockscr_status = Get-ItemProperty -Path $reg_path -Name $reg_lockscr_val -ErrorAction Stop | Select-Object -ExpandProperty $reg_lockscr_val
    If (($reg_desktop_status -eq $status_inprog) -or ($reg_desktop_status -eq $status_fail) -or ($reg_lockscr_status -eq $status_inprog) -or ($reg_lockscr_status -eq $status_fail)) {
        Write-Warning "Background set failed"
        Exit 1
    } else {
        Write-Output "Background set ok"
        Exit 0
    }
} 
Catch {
    Write-Warning "Background set failed"
    Exit 1
}