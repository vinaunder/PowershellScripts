param(
    [string]$webAppUrl,
    [string]$siteCollectionUrl,
    [string]$backupFilePath
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Restaurar o Site Collection
Restore-SPSite -Identity $siteCollectionUrl -Path $backupFilePath -Force

Write-Output "Site Collection '$siteCollectionUrl' restaurado com sucesso a partir do arquivo de backup '$backupFilePath'."
