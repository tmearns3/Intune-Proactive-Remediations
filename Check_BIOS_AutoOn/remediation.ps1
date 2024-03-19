$module_name = "DellBIOSProvider"
Import-Module $module_name -Force

$x = "place base64 passwd here"
$z = [System.Text.Encoding]::Ascii.GetString([System.Convert]::FromBase64String($x));

# can be Disabled, Everyday, Weekdays, and SelectDays
Set-Item -Path DellSmbios:\PowerManagement\AutoOn Weekdays -Password "$z"

Set-Item -Path DellSmbios:\PowerManagement\AutoOnHr 7 -Password "$z"
Set-Item -Path DellSmbios:\PowerManagement\AutoOnMn 0 -Password "$z"

Exit 0
