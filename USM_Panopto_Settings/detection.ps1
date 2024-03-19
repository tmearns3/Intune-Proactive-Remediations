# registry keys for Panopto on USM


$panopto_key = "HKLM:\\SOFTWARE\Panopto\Panopto Recorder"

# WRDeleteWhenUploadComplete REG_SZ  FALSE 
$del_when_uploaded_val = "WRDeleteWhenUploadComplete"

# AllowToastNotifications  REG_SZ False 
$allow_toast_val = "AllowToastNotifications"

# BackgroundUpload REG_SZ TRUE 
$bg_upload_val = "BackgroundUpload"

If (!(Test-Path -Path "$panopto_key")) {
    Write-Output "Panopto reg key doesnt exist"
    #    New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\University of Surrey"
    Exit 1
}

$del_when_uploaded = Get-ItemProperty -Path "$panopto_key" -Name "$del_when_uploaded_val" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "$del_when_uploaded_val"
$allow_toast = Get-ItemProperty -Path "$panopto_key" -Name "$allow_toast_val" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "$allow_toast_val"
$bg_upload = Get-ItemProperty -Path "$panopto_key" -Name "$bg_upload_val" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "$bg_upload_val"

If ($del_when_uploaded -ne "FALSE" -or $allow_toast -ne "False" -or $bg_upload -ne "TRUE") {
    Write-Output "Resetting reg keys"
    Exit 1
} Else {
    Exit 0
}

