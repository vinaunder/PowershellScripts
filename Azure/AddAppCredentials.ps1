param(
    [string]$appId,
    [string]$credentialType, # "Certificate" ou "Secret"
    [string]$certificateName = "DefaultCert",
    [int]$secretDurationMonths = 1
)

# Conectar ao Microsoft Graph
Connect-MgGraph -Scopes 'Application.ReadWrite.All' -NoWelcome

# Obter a aplicação pelo AppId
$app = Get-MgApplication -Filter "appId eq '$appId'"

if ($null -eq $app) {
    Write-Output "Aplicativo com AppId '$appId' não encontrado."
    exit
}

# Função para criar um certificado
function Create-Certificate {
    param(
        [string]$certName
    )

    $cert = New-SelfSignedCertificate -CertStoreLocation "Cert:\CurrentUser\My" -Subject "CN=$certName" -KeyExportPolicy Exportable -KeySpec Signature
    $certData = [System.Convert]::ToBase64String($cert.RawData)
    return @{
        displayName = $certName
        type = "AsymmetricX509Cert"
        key = $certData
    }
}

# Função para criar um segredo
function Create-Secret {
    param(
        [int]$durationMonths
    )
    $startDate = (Get-Date).AddDays(1).Date
    $endDate = $startDate.AddMonths($durationMonths)

    return @{
        displayName = 'Created in PowerShell'
        startDateTime = $startDate
        endDateTime = $endDate
     }
}

# Adicionar credencial à aplicação
if ($credentialType -eq "Certificate") {
    $certificate = Create-Certificate -certName $certificateName
    Add-MgApplicationKey -ApplicationId $app.Id -DisplayName $certificate.displayName -Key $certificate.key -Type $certificate.type
    Write-Output "Certificado '$certificateName' criado e adicionado à aplicação '$($app.DisplayName)'."
} elseif ($credentialType -eq "Secret") {
    $passwordCredReturn = Create-Secret -durationMonths $secretDurationMonths
    $secret = Add-MgApplicationPassword -applicationId $app.Id -PasswordCredential $passwordCredReturn
    $secret | Format-List
} else {
    Write-Output "Tipo de credencial '$credentialType' não suportado. Use 'Certificate' ou 'Secret'."
}
