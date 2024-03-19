$vboxmanagepath1 = "C:\Program Files\Oracle\VirtualBox\vboxmanage.exe"
$vboxmanagepath2 = "C:\VirtualBox\vboxmanage.exe"

If (Test-Path "$vboxmanagepath1") {
    $vboxmanagepath = $vboxmanagepath1
} else {
    if (Test-Path "$vboxmanagepath2") {
        $vboxmanagepath = $vboxmanagepath2
    } else {
        Write-Output "VBoxManage not found"
        Exit 0
    }
}

Write-Output "VboxManage path $vboxmanagepath"

$params = 'extpack','uninstall','"Oracle VM VirtualBox Extension Pack"'

& "$vboxmanagepath" $params
