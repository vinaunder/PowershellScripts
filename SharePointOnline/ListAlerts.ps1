param(
    [string]$siteUrl,
    [string]$listName,
    [string]$userEmail,
    [string]$alertTitle = "List Alert",
    [string]$changeType = "All"
)

# Conectar ao SharePoint Online
Connect-PnPOnline -Url $siteUrl -Interactive

# Criar o alerta
New-PnPAlert -List $listName -User $userEmail -Title $alertTitle -ChangeType $changeType

Write-Output "Alerta de e-mail criado para a lista '$listName' para o usuário '$userEmail'."
