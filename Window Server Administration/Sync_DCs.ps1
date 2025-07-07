#Sync DCs on-prem
repadmin /syncall /A /e /P
#Sync DCs to Azure
Start-ADSyncSyncCycle -PolicyType Delta