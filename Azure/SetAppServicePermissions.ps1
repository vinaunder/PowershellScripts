param(
    [string]$resourceGroupName,
    [string]$appServiceName,
    [string]$userPrincipalName,
    [string]$roleName = "Contributor" 
)

Connect-AzAccount

$appService = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appServiceName
$appServiceId = $appService.Id

$user = Get-AzADUser -UserPrincipalName $userPrincipalName
$userId = $user.Id

New-AzRoleAssignment -ObjectId $userId -RoleDefinitionName $roleName -Scope $appServiceId

Write-Output "Permissão '$roleName' atribuída ao usuário '$userPrincipalName' no App Service '$appServiceName'."


#.\SetAppServicePermissions.ps1 -resourceGroupName "MyResourceGroup" -appServiceName "MyAppService" -userPrincipalName "user@domain.com" -roleName "Contributor"

