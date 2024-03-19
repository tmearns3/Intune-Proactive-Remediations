# remove all user profiles that arent loaded

Get-CimInstance Win32_UserProfile | Where-Object {(!$_.Special) -and (!$_.Loaded) } | Remove-CimInstance
