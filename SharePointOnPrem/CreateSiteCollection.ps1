param(
    [string]$webAppUrl,
    [string]$siteCollectionUrl,
    [string]$siteTitle,
    [string]$siteTemplate,
    [string]$owner,
    [string]$quotaTemplate = "Standard"
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Criar o Site Collection
New-SPSite -Url $siteCollectionUrl -OwnerAlias $owner -Template $siteTemplate -Name $siteTitle -QuotaTemplate $quotaTemplate -Description "Created via PowerShell"

Write-Output "Site Collection '$siteTitle' criado com sucesso em '$siteCollectionUrl'."
