param(
    [string]$appId,
    [string[]]$permissions # Ex: @("User.Read.All", "Sites.Read.All")
)

# Conectar ao Microsoft Graph
Connect-MgGraph -Scopes "Application.ReadWrite.All", "Directory.ReadWrite.All"

# Obter a aplicação pelo AppId
$app = Get-MgApplication -Filter "appId eq '$appId'"

if ($null -eq $app) {
    Write-Output "Aplicativo com AppId '$appId' não encontrado."
    exit
}

# Obter o Service Principal do Microsoft Graph
$graphServicePrincipal = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'"

if ($null -eq $graphServicePrincipal) {
    Write-Output "Service Principal do Microsoft Graph não encontrado."
    exit
}

# Função para obter o ID de permissão do Microsoft Graph
function Get-GraphPermissionId {
    param(
        [string]$permissionName
    )

    $permission = $graphServicePrincipal.AppRoles | Where-Object { $_.Value -eq $permissionName -and $_.AllowedMemberTypes -contains "Application" }
    if ($null -eq $permission) {
        $permission = $graphServicePrincipal.Oauth2PermissionScopes | Where-Object { $_.Value -eq $permissionName }
    }
    return $permission.Id
}

# Construir a lista de permissões necessárias
$requiredPermissions = @()
foreach ($permissionName in $permissions) {
    $permissionId = Get-GraphPermissionId -permissionName $permissionName
    if ($null -ne $permissionId) {
        $requiredPermissions += [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphResourceAccess]@{
            Id   = $permissionId
            Type = "Role" # ou "Scope" dependendo do tipo de permissão
        }
    } else {
        Write-Output "Permissão '$permissionName' não encontrada no Microsoft Graph."
    }
}

if ($requiredPermissions.Count -eq 0) {
    Write-Output "Nenhuma permissão válida foi encontrada para adicionar."
    exit
}

# Adicionar permissões à aplicação
$requiredResourceAccess = [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphRequiredResourceAccess]@{
    ResourceAppId = $graphServicePrincipal.AppId
    ResourceAccess = $requiredPermissions
}

Update-MgApplication -ApplicationId $app.Id -RequiredResourceAccess $requiredResourceAccess

Write-Output "Permissões adicionadas à aplicação '$($app.DisplayName)'."

# Conceder Admin Consent
$servicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$appId'"

foreach ($permission in $requiredPermissions) {
    $oauth2PermissionGrant = @{
        ClientId     = $servicePrincipal.Id
        ConsentType  = "AllPrincipals"
        PrincipalId  = $null
        ResourceId   = $graphServicePrincipal.Id
        Scope        = (Get-GraphPermissionId -permissionName $permissionName)
    }
    New-MgOauth2PermissionGrant -BodyParameter $oauth2PermissionGrant
}

Write-Output "Admin consent concedido para as permissões especificadas."
