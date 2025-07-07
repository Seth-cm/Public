# ---------------------------
# PowerShell Script: Initialize, Partition, and Format Disks for SQL Server
# ---------------------------
# Run PowerShell as Administrator.
# Verify the disk numbers before running.

# ========== PARAMETERS: Adjust these to match your environment ==========

# Mapping of "DiskNumber" to "DriveLetter" and "VolumeLabel".
# Make sure these disk numbers match what you see in Disk Management or Get-Disk.
# If you only need 5 disks (S, D, L, T, B), remove the extra lines as needed.

$DiskConfigs = @(
    @{
        DiskNumber   = 1
        DriveLetter  = 'D'
        VolumeLabel  = 'SQLData'
        AllocationUnitSize = 65536
    },
    @{
        DiskNumber   = 2
        DriveLetter  = 'B'
        VolumeLabel  = 'SQLBackup'
        AllocationUnitSize = 65536
    },
    @{
        DiskNumber   = 3
        DriveLetter  = 'L'
        VolumeLabel  = 'SQLLogs'
        AllocationUnitSize = 65536
    },
    @{
        DiskNumber   = 4
        DriveLetter  = 'T'
        VolumeLabel  = 'TempDB'
        AllocationUnitSize = 65536
    },
    @{
        DiskNumber   = 5
        DriveLetter  = 'S'
        VolumeLabel  = 'System'
        AllocationUnitSize = 65536
    }
)

# ========== SCRIPT LOGIC ==========

foreach ($config in $DiskConfigs) {

    Write-Host "Processing Disk $($config.DiskNumber) for drive $($config.DriveLetter)..."

    # 1. Initialize Disk as GPT (if not already initialized).
    #    Note: If the disk is already initialized, this command will fail unless you force it.
    #    If necessary, add -Confirm:$false -ErrorAction SilentlyContinue to skip prompts.
    Initialize-Disk -Number $config.DiskNumber -PartitionStyle GPT -Confirm:$false -ErrorAction Continue

    # 2. Create a new partition that uses all available space on this disk
    $partition = New-Partition -DiskNumber $config.DiskNumber -UseMaximumSize -AssignDriveLetter:$false

    # 3. Assign the specified drive letter
    Set-Partition -InputObject $partition -NewDriveLetter $config.DriveLetter

    # 4. Format the partition with NTFS, 64K allocation unit, and label it
    Format-Volume -Partition $partition `
                  -FileSystem NTFS `
                  -AllocationUnitSize $config.AllocationUnitSize `
                  -NewFileSystemLabel $config.VolumeLabel `
                  -Confirm:$false
    
    Write-Host "Disk $($config.DiskNumber) formatted and mounted as $($config.DriveLetter): [$($config.VolumeLabel)]"
    Write-Host "----------------------------------------------------------"
}

Write-Host "All specified disks have been initialized and formatted."
