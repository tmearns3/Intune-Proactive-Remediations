#Connect to the PasswordObject WMI class

if (!(get-wmiobject -namespace root -class __NAMESPACE -filter "name='dcim'")) {
	Write-Output "Hardware too old to check"
	Exit 0
}

try {
	$Password = Get-CimInstance -Namespace root\dcim\sysman\wmisecurity -ClassName PasswordObject
} catch {
	Write-Output "Couldnt get ciminstance"
	Exit 0
}

#Check the status of the admin password
$IsPasswordSet = $Password | Where-Object NameId -EQ "Admin" | Select-Object -ExpandProperty IsPasswordSet
 
If(($IsPasswordSet -eq 1) -or ($IsPasswordSet -eq "true") -or ($IsPasswordSet -eq $true) -or ($IsPasswordSet -eq 2)) {
	Write-Output "Your BIOS is password protected"
	Exit 0
} Else {
	Write-Output "Your BIOS is not password protected"	
	Exit 1
}




