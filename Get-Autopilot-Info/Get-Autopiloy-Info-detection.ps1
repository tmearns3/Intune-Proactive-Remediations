<#PSScriptInfo

.VERSION 1.0

.GUID 

.AUTHOR Mark Ellis

.COMPANYNAME University of Surrey

.COPYRIGHT 

.TAGS Windows AutoPilot

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
Version 1.0:  Simplified from autopilot enrollment script by Michael Niehaus
#>

<#
.SYNOPSIS
Retrieves the Windows AutoPilot deployment details from a computer

.DESCRIPTION
This script uses WMI to retrieve properties needed for a customer to register a device with Windows Autopilot.  It is normal to not collect a Windows Product ID (PKID) value since this is not required to register a device.  Only the serial number and hardware hash will be populated. This will be output on a single line to be collected in a proactive remediation.
.PARAMETER Name
The names of the computers.  These can be provided via the pipeline (property name Name or one of the available aliases, DNSHostName, ComputerName, and Computer).
.PARAMETER GroupTag
An optional tag value that should be included in a CSV file that is intended to be uploaded via Intune (not supported by Partner Center or Microsoft Store for Business).
.EXAMPLE
.\Get-WindowsAutoPilotInfo.ps1 -ComputerName MYCOMPUTER 
.EXAMPLE
.\Get-WindowsAutoPilotInfo.ps1 -ComputerName MYCOMPUTER -GroupTag Kiosk

#>

Begin
{
}

Process
{
	$bad = $false
    $comp = $env:computername

    # we can add a grouptag here if we want
    $GroupTag = ""

	# Get a CIM session
	$session = New-CimSession

	# Get the common properties.
	Write-Verbose "Checking $comp"
	$serial = (Get-CimInstance -CimSession $session -Class Win32_BIOS).SerialNumber

	# Get the hash (if available)
	$devDetail = (Get-CimInstance -CimSession $session -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'")
	if ($devDetail)
	{
		$hash = $devDetail.DeviceHardwareData
	}
	else
	{
		$bad = $true
		$hash = ""
	}

	# If the hash isn't available, get the make and model
	if ($bad)
	{
		$cs = Get-CimInstance -CimSession $session -Class Win32_ComputerSystem
		$make = $cs.Manufacturer.Trim()
		$model = $cs.Model.Trim()
	}
	else
	{
		$make = ""
		$model = ""
	}

	# Depending on the format requested, create the necessary object
	# Create a pipeline object
	$c = New-Object psobject -Property @{
		"Device Serial Number" = $serial
        "Windows Product ID" = $product
		"Hardware Hash" = $hash
	}
			
	if ($GroupTag -ne "")
	{
		Add-Member -InputObject $c -NotePropertyName "Group Tag" -NotePropertyValue $GroupTag
	}

	# Write the object to the pipeline or array
	if ($bad)
	{
		# Report an error when the hash isn't available
		Write-Error -Message "Unable to retrieve device hardware data (hash) from computer $comp" -Category DeviceError
	}
	else
	{
		Write-Host "$serial,$product,$hash"
	}

	Remove-CimSession $session
}

End
{

}
