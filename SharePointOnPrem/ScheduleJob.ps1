param(
    [string]$jobName,
    [string]$jobTypeName,
    [string]$webAppUrl,
    [string]$schedule = "Daily" # Pode ser Daily, Weekly, Monthly, etc.
)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Obter a aplicação web
$webApp = Get-SPWebApplication $webAppUrl

# Agendar o Job de Timer
if ($schedule -eq "Daily") {
    $schedule = New-SPDailySchedule -Begin 01:00 -End 01:15
} elseif ($schedule -eq "Weekly") {
    $schedule = New-SPWeeklySchedule -Begin 01:00 -End 01:15 -DayOfWeek Monday
} elseif ($schedule -eq "Monthly") {
    $schedule = New-SPMonthlySchedule -Begin 01:00 -End 01:15 -Day 1
} else {
    Write-Output "Agendamento desconhecido. Use 'Daily', 'Weekly' ou 'Monthly'."
    return
}

$job = New-SPTimerJob -Type $jobTypeName -Name $jobName -WebApplication $webApp -Schedule $schedule

Write-Output "Job de Timer '$jobName' agendado com sucesso."
