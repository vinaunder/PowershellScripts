param(
    [string]$siteCollectionUrl,
    [string]$backupFilePath
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Realizar o backup do Site Collection
Backup-SPSite -Identity $siteCollectionUrl -Path $backupFilePath -Force

Write-Output "Backup do Site Collection '$siteCollectionUrl' concluído com sucesso. Arquivo de backup: '$backupFilePath'."
