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
    New-Item -Path "$panopto_key"
}

Set-ItemProperty -Path "$panopto_key" -Name "$del_when_uploaded_val" -Value "FALSE" -Type String -ErrorAction SilentlyContinue
Set-ItemProperty -Path "$panopto_key" -Name "$allow_toast_val" -Value "False" -Type String -ErrorAction SilentlyContinue
Set-ItemProperty -Path "$panopto_key" -Name "$bg_upload_val" -Value "TRUE" -Type String -ErrorAction SilentlyContinue
