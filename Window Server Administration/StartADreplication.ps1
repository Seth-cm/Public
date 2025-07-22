function Invoke-ADTopologyReplicationPlan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SourceDC
    )

    Import-Module ActiveDirectory -ErrorAction Stop

    $updatedDCs = [System.Collections.Generic.HashSet[string]]::new()
    $queue = [System.Collections.Queue]::new()

    # Normalize source to NetBIOS
    $sourceNetBIOS = ($SourceDC -split '\.')[0].ToUpper()
    $queue.Enqueue($sourceNetBIOS)
    $updatedDCs.Add($sourceNetBIOS) | Out-Null

    # For reporting
    $allDCs = Get-ADDomainController -Filter * | ForEach-Object { ($_.Name).ToUpper() }

    Write-Host "`nStarting staged replication from Source DC: $sourceNetBIOS" -ForegroundColor Cyan
	$namingContext = "CN=Configuration," + (Get-ADDomain).DistinguishedName
    while ($queue.Count -gt 0) {
        $currentSource = $queue.Dequeue()
        Write-Host "`nProcessing replication from: $currentSource" -ForegroundColor Green

        # Get replication partners of currentSource
        $partners = Get-ADReplicationPartnerMetadata -Target $currentSource -Scope Server

        foreach ($partner in $partners) {
            $partnerHost = ($partner.Partner -split ',')[1] -replace '^CN=', ''
            $partnerHost = $partnerHost.ToUpper()

            if (-not $updatedDCs.Contains($partnerHost)) {
                # Check if the target DC considers currentSource a valid replication source
                $targetSources = Get-ADReplicationPartnerMetadata -Target $partnerHost -Scope Server |
                    Where-Object { $_.Partner -like "*CN=$currentSource,*" }

                if ($targetSources.Count -eq 0) {
                    Write-Host "-> Skipping $partnerHost (does not replicate from $currentSource)" -ForegroundColor DarkGray
                    continue
                }

                Write-Host "-> Replicating to $partnerHost from $currentSource..."
                $result = & repadmin /replicate $partnerHost $currentSource $namingContext

                if ($LASTEXITCODE -eq 0) {
                    $updatedDCs.Add($partnerHost) | Out-Null
                    $queue.Enqueue($partnerHost)
                } else {
                    Write-Warning "Replication to $partnerHost from $currentSource failed with code $LASTEXITCODE"
                }
            } else {
                Write-Host "-> Skipping $partnerHost (already replicated or is original source)" -ForegroundColor DarkGray
            }
        }
    }

    Write-Host "`nStaged replication completed." -ForegroundColor Cyan
    Write-Host "Updated DCs: $($updatedDCs.Count) / $($allDCs.Count)"
    Write-Host "DCs replicated: $($updatedDCs -join ', ')"
}

# --- MAIN SCRIPT LOGIC ---

Import-Module ActiveDirectory -ErrorAction Stop

$domain = (Get-ADDomain).Name
$dcs = Get-ADDomainController -Filter * | Sort-Object Name

Write-Host "Domain Controllers in domain '$domain':" -ForegroundColor Cyan

# Display DC list with index and use NetBIOS name
for ($i = 0; $i -lt $dcs.Count; $i++) {
    Write-Host "$($i + 1)): $($dcs[$i].Name)"
}

# Prompt for selection
do {
    $selection = Read-Host "`nEnter the number of the Domain Controller to use as source (1-$($dcs.Count))"
} while (-not ($selection -match '^\d+$') -or [int]$selection -lt 1 -or [int]$selection -gt $dcs.Count)

# Use NetBIOS name as source
$sourceDC = $dcs[[int]$selection - 1].Name
Invoke-ADTopologyReplicationPlan -SourceDC $sourceDC
