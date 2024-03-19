
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

$params = 'list', 'extpacks'
[array]$manage_out = & "$vboxmanagepath" $params

$extpack_found = $false
ForEach ($outline in $manage_out) {
    If ("$outline" -match "VirtualBox Extension Pack") {
        $extpack_found = $true
        break
    }
}

If ($extpack_found) {
    Write-Output "Extpack found ****"
    Exit 1
} Else {
    Write-Output "Extpack not found"
    Exit 0
}

