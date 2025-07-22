# Import AD module (required if not already loaded)

Import-Module ActiveDirectory
 
# Target OU

$OU = "OU=Computers,DC=example,DC=com"  # Change this to your target OU
 
# Get all enabled computer names from the OU

$computers = Get-ADComputer -SearchBase $OU -Filter 'enabled -eq $true' -Properties Name | Select-Object -ExpandProperty Name
 
# Run gpupdate /force on each computer

foreach ($computer in $computers) {

    Write-Host "Attempting gpupdate on $computer..." -ForegroundColor Cyan

    try {

        Invoke-Command -ComputerName $computer -ScriptBlock {

            gpupdate /force

        } -ErrorAction Stop
 
        Write-Host "Success on $computer" -ForegroundColor Green

    } catch {

        Write-Host "Failed on ${computer}: $($_)" -ForegroundColor Red

    }

}

 