#Run System Files Checker
sfc /scannow

#Run DISM (Deployment Imaging Service and Management Tool)
DISM /Online /Cleanup-Image /RestoreHealth

#command-line utility scans the specified disk for file system errors and bad sectors and, optionally, fixes them.
chkdsk C: /F /R