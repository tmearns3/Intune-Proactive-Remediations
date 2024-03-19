# search for KxConnections.exe in
# C:\Users\*\AppData\Local\KxLocal\Live
# C:\Users\*\AppData\Local\KxLocal\KxUAT
# C:\Users\*\AppData\Local\KxLocal\Kx_UAT

$paths = @(
    'C:\Users\*\AppData\Local\KxLocal\Live\KxConnections.exe'
    'C:\Users\*\AppData\Local\KxLocal\KxUAT\KxConnections.exe'
    'C:\Users\*\AppData\Local\KxLocal\Kx_UAT\KxConnections.exe'
)

$found_items = Get-childitem $paths

$found = 0

foreach ($found_item in $found_items) {
    $found = 1
    Write-Output "Found $($found_item.FullName)"
}

Exit $found
