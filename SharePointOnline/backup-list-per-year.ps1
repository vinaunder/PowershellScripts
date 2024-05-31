# Install this modules before running the script:
# Install-Module PnP.PowerShell
# Install-Module Microsoft.PowerShell.Archive

param(
    [string]$siteUrl,
    [string]$listName,
    [int]$years
)

Connect-PnPOnline -Url $siteUrl -Interactive

$currentYear = (Get-Date).Year
$yearLimit = $currentYear - $years

$items = Get-PnPListItem -List $listName -Query "<View><Query><Where><Lt><FieldRef Name='Created' /><Value IncludeTimeValue='FALSE' Type='DateTime'>$yearLimit-01-01T00:00:00Z</Value></Lt></Where></Query></View>"

$excelFile = "$listName-Backup-$(Get-Date -Format yyyyMMdd).xlsx"
$excel = New-Object -ComObject Excel.Application
$workbook = $excel.Workbooks.Add()
$sheet = $workbook.Worksheets.Item(1)

$headers = $items[0].FieldValues.Keys
for ($i = 0; $i -lt $headers.Count; $i++) {
    $sheet.Cells.Item(1, $i + 1) = $headers[$i]
}

$row = 2
foreach ($item in $items) {
    $col = 1
    foreach ($header in $headers) {
        $sheet.Cells.Item($row, $col) = $item[$header]
        $col++
    }
    $row++
}

$workbook.SaveAs($excelFile)
$workbook.Close()
$excel.Quit()

$attachmentDir = "$listName-Attachments-$(Get-Date -Format yyyyMMdd)"
New-Item -ItemType Directory -Path $attachmentDir

foreach ($item in $items) {
    $itemId = $item.Id
    $itemDir = "$attachmentDir\$itemId"
    New-Item -ItemType Directory -Path $itemDir

    $attachments = Get-PnPAttachment -List $listName -ListItem $itemId
    foreach ($attachment in $attachments) {
        $fileName = $attachment.FileName
        $fileContent = Get-PnPFile -Url $attachment.ServerRelativeUrl -AsFile
        $filePath = "$itemDir\$fileName"
        [System.IO.File]::WriteAllBytes($filePath, $fileContent)
    }
}

$zipFile = "$attachmentDir.zip"
Compress-Archive -Path $attachmentDir -DestinationPath $zipFile

foreach ($item in $items) {
    Remove-PnPListItem -List $listName -Identity $item.Id -Force
}

Disconnect-PnPOnline

Write-Output "Backup File: $excelFile"
Write-Output "Zip File: $zipFile"

#.\backup-list-per-year.ps1 -siteUrl "https://contoso.sharepoint.com/sites/finance" -listName "Invoices" -years 2