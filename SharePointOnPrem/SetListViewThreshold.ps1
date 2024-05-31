param(
    [string]$siteUrl,
    [bool]$disableLimit
)

# Carregar os cmdlets do SharePoint
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Obter a coleção de sites
$site = Get-SPSite $siteUrl

# Verificar se a coleção de sites foi encontrada
if ($site -eq $null) {
    Write-Output "A coleção de sites com a URL '$siteUrl' não foi encontrada."
    return
}

# Definir o limite de visualização de lista
if ($disableLimit) {
    Write-Output "Desabilitando o limite de 5000 itens na coleção de sites '$siteUrl'..."
    $site.WebApplication.MaxItemsPerThrottledOperation = 20000 
} else {
    Write-Output "Habilitando o limite padrão de 5000 itens na coleção de sites '$siteUrl'..."
    $site.WebApplication.MaxItemsPerThrottledOperation = 5000 
}

# Aplicar as alterações
$site.WebApplication.Update()

Write-Output "Configuração aplicada com sucesso para a coleção de sites '$siteUrl'."
