# Ensure the PSWindowsUpdate module is installed
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Output "PSWindowsUpdate module not found. Installing..."
    Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
}

# Import the module
Import-Module PSWindowsUpdate

# (Optional) Set the execution policy to allow the module to run, if required
# Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Check for available Windows Updates (this will list updates without installing them)
Write-Output "Checking for available updates..."
$updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot
Write-Output "Available updates:"
$updates | Format-Table -AutoSize

# Install the available updates without automatically restarting
if ($updates) {
    Write-Output "Installing updates..."
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -AutoReboot:$false
} else {
    Write-Output "No updates available."
}

# Optional: Inform the user if a reboot is required
$rebootRequired = (Get-WindowsUpdate -IsInstalled | Where-Object { $_.RebootRequired })
if ($rebootRequired) {
    Write-Output "One or more updates require a restart. Please restart your computer to complete the update process."
} else {
    Write-Output "Update process complete. No restart is required."
}