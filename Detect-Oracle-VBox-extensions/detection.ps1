$ext_lic_path1 = "C:\Program Files\Oracle\VirtualBox\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\ExtPack-license.txt"
$ext_lic_path2 = "C:\VirtualBox\ExtensionPacks\Oracle_VM_VirtualBox_Extension_Pack\ExtPack-license.txt"

If (Test-Path "$ext_lic_path1") {
    Write-Output "VBox extension lic file found at $ext_lic_path1 ***"
} else {
    if (Test-Path "$ext_lic_path2") {
        Write-Output "VBox extension lic file found at $ext_lic_path2 ***"
    } else {
        Write-Output "VBox extension lic file not found"
    }
}   

exit 0
