# Trust PowerShell Gallery
If (Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" -and $_.InstallationPolicy -ne "Trusted" }) {
    Install-PackageProvider -Name "NuGet" -MinimumVersion 2.8.5.208 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
}

# Install or update module
$module_name = "DellBIOSProvider"
Write-Output "Install or update $module_name module"
$Installed = Get-Module -Name "$module_name" -ListAvailable | `
    Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } | `
    Select-Object -First 1
$Published = Find-Module -Name "$module_name"
If ($Null -eq $Installed) {
    Install-Module -Name "$module_name"
}
ElseIf ([System.Version]$Published.Version -gt [System.Version]$Installed.Version) {
    Update-Module -Name "$module_name"
}

Import-Module $module_name -Force

$isAutoOn = (Get-Item -Path DellSmbios:\PowerManagement\AutoOn).currentvalue

If ($null -eq $isAutoOn) {
    Write-Error "** Failed to detect AutoOn status **"
    Exit 0
}

# can be Disabled, Everyday, Weekdays, and SelectDays
If ("$isAutoOn" -eq "Disabled") {
    Write-Output "AutoOn $isAutoOn"
    Exit 1
}

If ($isAutoOn -eq "SelectDays") {
    $Sun = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnSun).currentvalue
    $Mon = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnMon).currentvalue
    $Tue = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnTue).currentvalue
    $Wed = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnWed).currentvalue
    $Thur = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnThur).currentvalue
    $Fri = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnFri).currentvalue
    $Sat = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnSat).currentvalue
}

$AutoOnHr = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnHr).currentvalue
$AutoOnMn = (Get-Item -Path DellSmbios:\PowerManagement\AutoOnMn).currentvalue

If ($isAutoOn -eq "SelectDays") {
    $days = ""
    If ($Sun -eq "Enabled") { $days = "$days{0}" -f "Sun," }
    If ($Mon -eq "Enabled") { $days = "$days{0}" -f "Mon," }
    If ($Tue -eq "Enabled") { $days = "$days{0}" -f "Tue," }
    If ($Wed -eq "Enabled") { $days = "$days{0}" -f "Wed," }
    If ($Thur -eq "Enabled") { $days = "$days{0}" -f "Thur," }
    If ($Fri -eq "Enabled") { $days = "$days,{0}" -f "Fri," }
    If ($Sat -eq "Enabled") { $days = "$days{0}" -f "Sat," }
    If ($days.length -eq 0) {
        $days = "None"
    } Else {
        $days = $days.Substring(0,$days.Length-1)
    }
    Write-Output $("AutoOn {0}, Time {1:D2}:{2:D2}, Days:{3}" -f $IsAutoOn,[int32]$AutoOnHr,[int]$AutoOnMn,$days)
} Else {
    Write-Output $("AutoOn {0}, Time {1:D2}:{2:D2}" -f $IsAutoOn,[int32]$AutoOnHr,[int]$AutoOnMn)
}

Exit 0
