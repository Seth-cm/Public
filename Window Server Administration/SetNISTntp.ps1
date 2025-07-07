#Confirm you're on the PDC Emulator
netdom query fsmo

#Set NTP servers to NIST
w32tm /config /manualpeerlist:"time.nist.gov time-a-b.nist.gov time-b-b.nist.gov" /syncfromflags:manual /reliable:yes /update
net stop w32time
net start w32time
w32tm /resync /nowait

#Set the Time Zone to Eastern Standard Time
tzutil /s "Eastern Standard Time"

#Confirm time status
w32tm /query /status
tzutil /g
