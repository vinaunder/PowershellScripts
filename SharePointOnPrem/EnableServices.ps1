param(
    [string]$serviceName,
    [string]$action # "Start" ou "Stop"
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Obter o serviço
$service = Get-SPServiceInstance | Where-Object { $_.TypeName -eq $serviceName }

if ($service -ne $null) {
    if ($action -eq "Start") {
        # Habilitar o serviço
        Start-SPServiceInstance -Identity $service
        Write-Output "Serviço '$serviceName' habilitado com sucesso."
    } elseif ($action -eq "Stop") {
        # Desabilitar o serviço
        Stop-SPServiceInstance -Identity $service
        Write-Output "Serviço '$serviceName' desabilitado com sucesso."
    } else {
        Write-Output "Ação desconhecida. Use 'Start' ou 'Stop'."
    }
} else {
    Write-Output "Serviço '$serviceName' não encontrado."
}
