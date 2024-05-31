#
# 1. Install-Module PnP.PowerShell
# 2. Connect-PnPOnline -Url https://yourtenant-admin.sharepoint.com -Interactive
#


param(
    [string]$siteUrl,
    [string]$listName,
    [string]$listUrl,
    [string]$listType, # "List" para lista ou "Library" para biblioteca de documentos
    [hashtable]$fields # Campos a serem criados, no formato @{FieldName="FieldType"}
)

# Conectar ao SharePoint Online
Connect-PnPOnline -Url $siteUrl -Interactive

# Verificar se a lista ou biblioteca já existe
$listExists = Get-PnPList | Where-Object { $_.Title -eq $listName }

if ($listExists) {
    Write-Output "A lista ou biblioteca com o nome '$listName' já existe."
    return
}

# Criar a lista ou biblioteca
Write-Output "Criando a $listType '$listName'..."
if ($listType -eq "List") {
    New-PnPList -Title $listName -Url $listUrl -Template GenericList -OnQuickLaunch
} elseif ($listType -eq "Library") {
    New-PnPList -Title $listName -Url $listUrl -Template DocumentLibrary -OnQuickLaunch
} else {
    Write-Output "Tipo de lista desconhecido. Use 'List' ou 'Library'."
    return
}

# Adicionar campos à lista ou biblioteca
foreach ($fieldName in $fields.Keys) {
    $fieldType = $fields[$fieldName]
    Write-Output "Adicionando campo '$fieldName' do tipo '$fieldType'..."
    Add-PnPField -List $listName -DisplayName $fieldName -InternalName $fieldName -Type $fieldType
}

Write-Output "$listType '$listName' criada com sucesso na URL '$listUrl'."
