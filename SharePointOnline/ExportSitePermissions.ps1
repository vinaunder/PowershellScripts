param(
    [string]$siteUrl,
    [string]$outputFile = "PermissionsReport.csv"
)

if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -AllowClobber -Force
}

Import-Module PnP.PowerShell

# Conectar ao SharePoint Online
Connect-PnPOnline -Url $siteUrl -Interactive

# Obter todas as permissões do site
$permissions = Get-PnPRoleAssignment -Scope Web

# Exportar permissões para CSV
$permissions | Select-Object -Property PrincipalType, PrincipalName, RoleDefinitionBindings | Export-Csv -Path $outputFile -NoTypeInformation

Write-Output "Permissões exportadas para '$outputFile'."
