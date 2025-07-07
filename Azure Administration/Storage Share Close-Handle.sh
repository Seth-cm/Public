#Close all active connections to folder in file share 
#https://learn.microsoft.com/en-us/cli/azure/storage/share?view=azure-cli-latest#az-storage-share-close-handle
az storage share close-handle --account-name storageaccount --name iot-docs --path 'Operations/Quotes/00 - HOW TO QUOTE' --close-all --recursive