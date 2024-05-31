param(
    [string]$sourceSiteUrl,
    [string]$sourceLibraryName,
    [string]$destinationSiteUrl,
    [string]$destinationLibraryName
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Conectar ao site de origem
$sourceContext = Get-SPSite $sourceSiteUrl
$sourceWeb = $sourceContext.OpenWeb()
$sourceLibrary = $sourceWeb.Lists[$sourceLibraryName]

# Conectar ao site de destino
$destinationContext = Get-SPSite $destinationSiteUrl
$destinationWeb = $destinationContext.OpenWeb()
$destinationLibrary = $destinationWeb.Lists[$destinationLibraryName]

# Migrar documentos
foreach ($item in $sourceLibrary.Items) {
    $file = $sourceWeb.GetFile($item.Url)
    $destinationUrl = $destinationWeb.Url + "/" + $destinationLibrary.RootFolder.Url + "/" + $file.Name
    $file.CopyTo($destinationUrl, $true)
    Write-Output "Documento '$($file.Name)' migrado com sucesso para '$destinationUrl'."
}

Write-Output "Migração de documentos concluída."
