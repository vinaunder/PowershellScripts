# Conectar ao Azure
Connect-AzAccount

# Obter informações do contexto atual
$context = Get-AzContext

# Obter informações do tenant
$tenantId = $context.Tenant.Id
$tenantDetails = Get-AzTenant | Where-Object { $_.Id -eq $tenantId }

# Exibir informações do tenant
Write-Output "Tenant ID: $($tenantDetails.Id)"
# Verificar e exibir domínios
if ($tenantDetails.Domains.Count -gt 1) {
    Write-Output "Tenant Domains:"
    foreach ($domain in $tenantDetails.Domains) {
        Write-Output "- $domain"
    }
} else {
    Write-Output "Tenant Domain: $($tenantDetails.Domains)"
}

# Obter mais detalhes sobre o tenant
$tenantName = $tenantDetails.Name

# Exibir detalhes adicionais
Write-Output "Tenant Name: $tenantName"
