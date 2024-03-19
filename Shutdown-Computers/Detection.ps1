$explorerprocesses = @(Get-WmiObject -Query "Select * FROM Win32_Process WHERE Name='explorer.exe'" -ErrorAction SilentlyContinue)
If ($explorerprocesses.Count -eq 0)
{
    Write-Output "Nobody interactively logged on"
    Exit 1
}
Else
{
    Write-Output "Computer is in use"
    Exit 0
}