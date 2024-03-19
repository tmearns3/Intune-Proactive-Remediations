<#
======================================================================================================
 
 Created on:    22.04.2021
 Modified:      27.04.2021
 Created by:    Mattias Melkersen
 Version:       0.2  
 Mail:          mm@mindcore.dk
 twitter:       @mmelkersen
 Function:      Remediation script if .net 3.5 windows feature has been enabled. Use it together with ProActive Remediation.
 History log
 v0.1 - Working natively with downloading content only from Microsoft
 v0.2 - Thanks to @maleroytw for elaborating on devices with state: DisabledWithPayloadRemoved. This version will be able to get payload from Github and add it using /Limitaccess
 This script is provided As Is
 Compatible with Windows 10 1909 -> 20H2
======================================================================================================
#>

[string]$Owner = "mmelkersen"
[String]$Repository = "EndpointManager"
[String]$path = "Microsoft .NET Framework/"
[string]$Logfile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Baseline.log" 
Function Write_Log
	{
	param(
	$Message_Type, 
	$Message
	)
		$MyDate = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)  
		Add-Content $LogFile  "$MyDate - $Message_Type : $Message"  
	} 

    if (!(test-path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"))
        {
            New-Item -ItemType Directory -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
            Write_Log -Message_Type "INFO" -Message "Created folder"
        }
        else 
        {
            Write_Log -Message_Type "INFO" -Message "Folder existed"
        }

    Write_Log -Message_Type "INFO" -Message "Script started!"
    Write-Host "Script started!" -BackgroundColor Blue
    $DotNetState = Get-WindowsOptionalFeature -Online -FeatureName 'NetFx3'
    
    If ($DotNetState.State -eq "Enabled")
        {
            Write-Host "Net 3.5 state Enabled. Exiting!"
            #Exit 0
        }
        elseif ($DotNetState.State -eq "DisabledWithPayloadRemoved")
        {
            
            $msg = "NetFX State: " + $DotNetState.State
            Write-Host $msg -BackgroundColor Blue
            Write_Log -Message_Type "INFO" -Message $msg

            #Get build number
            $WindowsVersion = Get-ComputerInfo WindowsVersion
            
            $msg = "Windows version: " + $WindowsVersion.WindowsVersion
            Write-Host $msg -BackgroundColor Blue
            Write_Log -Message_Type "INFO" -Message $msg
            
        
            #Check if C:\Windows\temp\WinSXS exists
            $msg = "Checking folder exists: C:\temp\NetFX\$($WindowsVersion.WindowsVersion)"
            Write-Host $msg -BackgroundColor Blue
            Write_Log -Message_Type "INFO" -Message $msg
            if (!(test-path "C:\temp\NetFX\$($WindowsVersion.WindowsVersion)"))
                {
                    New-Item -ItemType Directory -Path "C:\temp\NetFX\$($WindowsVersion.WindowsVersion)"
                    Write_Log -Message_Type "INFO" -Message "Created folder"
                }
                else 
                {
                    Write_Log -Message_Type "INFO" -Message "Folder existed"
                }
                
            #Get files from Github    
            Write_Log -Message_Type "INFO" -Message "Getting data from Github"
            [String]$DestinationPath = "C:\temp\NetFX\$($WindowsVersion.WindowsVersion)"
            [String]$path = $path + "$($WindowsVersion.WindowsVersion)"
            $baseUri = "https://api.github.com/"
            $args = "repos/$Owner/$Repository/contents/$Path"
            $wr = Invoke-WebRequest -Uri $($baseuri+$args)
            
            $msg = "Invoking data from: $($baseuri+$args)"
            Write-Host $msg -BackgroundColor Blue
            Write_Log -Message_Type "INFO" -Message $msg
            
            $objects = $wr.Content | ConvertFrom-Json
            $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
            $directories = $objects | where {$_.type -eq "dir"}
            
            $directories | ForEach-Object { 
                DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
            }
        
            foreach ($file in $files) {
                $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
                try {
                    Invoke-WebRequest -Uri $file -OutFile $fileDestination -ErrorAction Stop -Verbose
                    $msg = "Grabbed '$($file)' to '$fileDestination'"
                    Write-Host $msg -BackgroundColor Blue
                    Write_Log -Message_Type "INFO" -Message $msg
                } 
                catch 
                {
                    $msg = "Unable to download '$($file.path)'"
                    Write-Host $msg -BackgroundColor Blue
                    Write_Log -Message_Type "WARNING" -Message $msg
                }
            }
            
            if (!(test-path $fileDestination))
            {
                    $msg = "Unable to find'$($fileDestination)'"
                    Write-Host $msg -BackgroundColor Blue
                    Write_Log -Message_Type "WARNING" -Message $msg
            }
            else 
            {
                #Extract Zip File
                $msg = 'Starting unzipping the GitHub Repository locally'
                Write-Host $msg -BackgroundColor Blue
                Write_Log -Message_Type "INFO" -Message $msg
                Expand-Archive -Path $fileDestination -DestinationPath $DestinationPath -Force
                $msg = 'Unzip finished' 
                Write-Host $msg -BackgroundColor Blue
                Write_Log -Message_Type "INFO" -Message $msg

                # remove the zip file
                Remove-Item -Path $fileDestination -Force
            }
    
     
            $msg = "Running Command: dism /online /enable-feature /featurename:NetFX3 /all /Source:$($DestinationPath) /LimitAccess"
            Write-Host $msg -BackgroundColor Blue
            Write_Log -Message_Type "INFO" -Message $msg
            dism /online /enable-feature /featurename:NetFX3 /all /LimitAccess /Source:$DestinationPath
            Write_Log -Message_Type "INFO" -Message "NetFX installed used sources from Github!"
            Write_Log -Message_Type "INFO" -Message "Done"
            Write-Host "Done" -BackgroundColor Blue
        }
        elseif ($DotNetState.State -eq "Disabled")
        {
            Try 
            {
                Write_Log -Message_Type "INFO" -Message "Enabling NetFx3..."
                Enable-WindowsOptionalFeature -Online -FeatureName 'NetFx3' -NoRestart
                Write-Host "Installed .Net 3.5 Successfully"
                Write_Log -Message_Type "INFO" -Message "Enabled NetFx3 Successfully"
            }
            catch
            {
                Write-Host ".net 3.5 installation failed"
                Write_Log -Message_Type "WARNING" -Message "Failed to enable NetFx3"
            }
        }