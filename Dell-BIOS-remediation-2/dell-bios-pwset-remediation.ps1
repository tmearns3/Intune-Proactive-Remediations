#Connect to the SecurityInterface WMI class
try {
    $SecurityInterface = Get-WmiObject -Namespace root\dcim\sysman\wmisecurity -Class SecurityInterface
} catch {
    Write-Output "Hardware too old to correct"
    Exit 1
}

$x = "base64 password"
$z = [System.Text.Encoding]::Ascii.GetString([System.Convert]::FromBase64String($x));
#Set the admin password when no password is currently set
$SecurityInterface.SetNewPassword(0,0,0,"Admin","","$z")

Exit 0 
