param(
    [string]$siteUrl,
    [string]$sourceListName,
    [string]$archiveListName,
    [datetime]$archiveDate
)

# Conectar ao SharePoint Online
Connect-PnPOnline -Url $siteUrl -Interactive

# Obter itens a serem arquivados
$itemsToArchive = Get-PnPListItem -List $sourceListName -Query "<View><Query><Where><Lt><FieldRef Name='Created' /><Value IncludeTimeValue='FALSE' Type='DateTime'>$($archiveDate.ToString('yyyy-MM-ddTHH:mm:ssZ'))</Value></Lt></Where></Query></View>"

# Mover itens para a lista de arquivamento
foreach ($item in $itemsToArchive) {
    # Copiar o item para a lista de arquivamento
    $itemFields = $item.FieldValues
    Add-PnPListItem -List $archiveListName -Values $itemFields
    
    # Remover o item da lista original
    Remove-PnPListItem -List $sourceListName -Identity $item.Id -Force
}

Write-Output "Itens arquivados com sucesso."
