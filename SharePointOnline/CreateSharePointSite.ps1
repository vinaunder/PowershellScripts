param(
    [string]$tenantAdminUrl,
    [string]$siteName,
    [string]$siteUrl,
    [string]$template,
    [string]$owner,
    [string]$hubSiteName = $null, # Nome do hub opcional
    [string]$description = "Created by PowerShell",
    [int]$timeZone = 3 # Fuso horário padrão, pode ser ajustado
)

# Conectar ao SharePoint Online Admin
Connect-PnPOnline -Url $tenantAdminUrl -Interactive

# Verificar se o site já existe
$siteExists = Get-PnPTenantSite | Where-Object { $_.Url -eq $siteUrl }

if ($siteExists) {
    Write-Output "O site com a URL '$siteUrl' já existe."
    return
}

# Criar o site
Write-Output "Criando o site '$siteName'..."
New-PnPSite -Type $template -Title $siteName -Url $siteUrl -Owner $owner -TimeZone $timeZone -Description $description

# Associar o site ao hub, se especificado
if ($hubSiteName) {
    $hubSite = Get-PnPHubSite | Where-Object { $_.Title -eq $hubSiteName }
    if ($hubSite) {
        Write-Output "Associando o site ao hub '$hubSiteName'..."
        Connect-PnPOnline -Url $siteUrl -Interactive
        Register-PnPHubSiteAssociation -Site $hubSite.SiteId
    } else {
        Write-Output "O hub site '$hubSiteName' não foi encontrado."
    }
}

Write-Output "Site '$siteName' criado com sucesso na URL '$siteUrl'."
