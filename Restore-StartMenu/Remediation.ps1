$Office_path = "C:\Program Files\Microsoft Office\root\Office16"
$StartMenuFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\"

        $shortcuts = @(
        'Excel'
        'WinWord'
        'POWERPNT'
        'Outlook'
        'OneNote'
        )

Foreach ($shortcut in $shortcuts) {

    $ShortcutName = $shortcut
    $LocationofTarget = $Office_path + "/" + $shortcut + ".exe"
    $LocationofShortcut = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

# Create Shortcut

    if ($shortcut -eq 'Winword') { $shortcutname = 'Word' }
    if ($shortcut -eq 'POWERPNT') { $shortcutname = 'PowerPoint' }
    $Shortcutfullpath = $LocationofShortcut + "/" + $ShortcutName + ".lnk"
    if (!(Test-Path $Shortcutfullpath)) {
    Write-Host "Creating Shortcut $StartMenuFolder$shortcut" -ForegroundColor Green
    New-Item -ErrorAction SilentlyContinue -ItemType Directory -Path $LocationofShortcut
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut($Shortcutfullpath)
    $ShortCut.TargetPath = "$LocationofTarget"
    $ShortCut.Arguments = "$ShortcutArguments"
    $ShortCut.WorkingDirectory = "$PathtoWorkingDirectory"
    $ShortCut.WindowStyle = 1
    $ShortCut.Hotkey = ""
    $ShortCut.IconLocation = "$LocationofTarget, 0"
    $ShortCut.Description = "$ShortcutName"
    $ShortCut.Save()
}

if(!(Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")){  
    $ComObj = New-Object -ComObject WScript.Shell
       $ShortCut = $ComObj.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk")
       $ShortCut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
       $ShortCut.Description = "Edge"
       $ShortCut.FullName 
       $ShortCut.WindowStyle = 1
       $ShortCut.Save()
}

if(!(Test-Path -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Chrome.lnk")){  
    $ComObj = New-Object -ComObject WScript.Shell
       $ShortCut = $ComObj.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Chrome.lnk")
       $ShortCut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe"
       $ShortCut.Description = "Google Chrome"
       $ShortCut.FullName 
       $ShortCut.WindowStyle = 1
       $ShortCut.Save()
}

}