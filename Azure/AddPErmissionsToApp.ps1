param(
    [string]$tenantId,
    [string]$clientId,
    [string]$clientSecret,
    [string]$appId, # ID do aplicativo registrado
    [string[]]$permissions # Permissões a serem adicionadas
)

$secureClientSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$token = New-MgGraphClientSecretToken -TenantId $tenantId -ClientId $clientId -ClientSecret $secureClientSecret

Select-MgProfile -Name "beta"
Connect-MgGraph -AccessToken $token.AccessToken

$app = Get-MgApplication -ApplicationId $appId

$apiPermissions = @()
foreach ($permission in $permissions) {
    $apiPermissions += @{
        "resourceAppId" = "00000003-0000-0000-c000-000000000000" # ID do recurso da API do Microsoft Graph
        "resourceAccess" = @(
            @{
                "id" = (Get-MgServicePrincipalOauth2PermissionGrant | Where-Object {$_.Scope -eq $permission}).Id
                "type" = "Scope"
            }
        )
    }
}

$app.RequiredResourceAccess = $apiPermissions
Set-MgApplication -ApplicationId $appId -RequiredResourceAccess $apiPermissions

Write-Output "Permissões adicionadas ao aplicativo '$appId'. Concedendo consentimento..."

foreach ($permission in $permissions) {
    New-MgServicePrincipalOauth2PermissionGrant -ClientId $appId -Scope $permission -ConsentType "AllPrincipals"
}

Write-Output "Consentimento concedido para as permissões: $($permissions -join ', ')."


#.\AddPermissionsToApp.ps1 -tenantId "your-tenant-id" -clientId "your-client-id" -clientSecret "your-client-secret" -appId "your-app-id" -permissions @("User.Read.All", "Sites.Read.All")

