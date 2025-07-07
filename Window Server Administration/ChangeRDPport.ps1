# Change the RDP port to 5555
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "PortNumber" -Value 5555

# (Optional) Add a new inbound firewall rule for the new RDP port
New-NetFirewallRule -DisplayName "RDP on port 5555" -Direction Inbound -Protocol TCP -LocalPort 5555 -Action Allow

# Restart the server for the change to take effect
Restart-Computer