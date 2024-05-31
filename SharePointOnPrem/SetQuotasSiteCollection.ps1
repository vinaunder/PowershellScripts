param(
    [string]$siteCollectionUrl,
    [int]$storageLimitMB,
    [int]$warningLimitMB
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Configurar quotas do Site Collection
$quotaTemplate = Get-SPQuotaTemplate -Identity "Standard"
$quotaTemplate.StorageMaximumLevel = $storageLimitMB * 1MB
$quotaTemplate.StorageWarningLevel = $warningLimitMB * 1MB
Set-SPSite -Identity $siteCollectionUrl -QuotaTemplate $quotaTemplate

Write-Output "Quotas configuradas para o Site Collection '$siteCollectionUrl': Limite de armazenamento = $storageLimitMB MB, Nível de aviso = $warningLimitMB MB."
