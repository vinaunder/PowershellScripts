Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Obter o status dos serviços do SharePoint
$services = Get-SPServiceInstance

foreach ($service in $services) {
    Write-Output "Service: $($service.TypeName), Status: $($service.Status)"
}
