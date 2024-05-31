# Install this modules before running the script:
# Install-Module -Name Az -AllowClobber -Force
# and Connect-AzAccount
param(
    [string]$resourceGroupName,
    [string]$location,
    [string]$appServicePlanName,
    [string]$appServiceName,
    [string]$skuName = "F1", 
    [string]$runtimeStack = "DOTNETCORE|3.1" 
)


$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
    Write-Output "Criando grupo de recursos '$resourceGroupName' no local '$location'..."
    $resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location
} else {
    Write-Output "Grupo de recursos '$resourceGroupName' já existe."
}


$appServicePlan = Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $appServicePlanName -ErrorAction SilentlyContinue
if (-not $appServicePlan) {
    Write-Output "Criando App Service Plan '$appServicePlanName' no grupo de recursos '$resourceGroupName'..."
    $appServicePlan = New-AzAppServicePlan -Name $appServicePlanName -Location $location -ResourceGroupName $resourceGroupName -Tier $skuName -WorkerSize "Small"
} else {
    Write-Output "App Service Plan '$appServicePlanName' já existe."
}


$appService = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appServiceName -ErrorAction SilentlyContinue
if (-not $appService) {
    Write-Output "Criando App Service '$appServiceName' no grupo de recursos '$resourceGroupName'..."
    $appService = New-AzWebApp -Name $appServiceName -Location $location -AppServicePlan $appServicePlanName -ResourceGroupName $resourceGroupName -RuntimeStack $runtimeStack
} else {
    Write-Output "App Service '$appServiceName' já existe."
}

Write-Output "Azure App Service '$appServiceName' criado com sucesso no grupo de recursos '$resourceGroupName'."

#.\CreateAppService.ps1 -resourceGroupName "MyResourceGroup" -location "EastUS" -appServicePlanName "MyAppServicePlan" -appServiceName "MyAppService" -skuName "B1" -runtimeStack "NODE|14-lts"

