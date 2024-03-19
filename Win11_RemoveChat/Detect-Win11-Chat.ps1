$teamspkg = Get-AppxPackage MicrosoftTeams*
$teamsprovpkg = Get-AppxProvisionedPackage -online | where-object {$_.PackageName -like "*MicrosoftTeams*"}


if ( ($null -ne $teamspkg) -or ($null -ne $teamsprovpkg) ) {
    Write-Output "Teams Chat app found"
    Exit 1
}
