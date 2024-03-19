$StartMenuFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
$Count = (Get-ChildItem $StartMenuFolder | Where-Object Name -match "Word|Outlook|Powerpoint|Excel").count
if ($count -ge 4) { "Installed" }
else
{ Exit 1 }