param(
    [Parameter(Mandatory = $true)]
    [string]$WebConfigPath,
    [string]$TcpEndpoint = 'tcp:23.111.175.186,1433',
    [switch]$ValidateOnly
)

# Run in Windows PowerShell on the live IIS server.
# Tests connection opening only. Does not modify configuration or database rows.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Data

$configPath = (Resolve-Path -LiteralPath $WebConfigPath).Path
[xml]$config = Get-Content -LiteralPath $configPath -Raw
$section = $config.configuration.connectionStrings
if ($section.configSource) {
    $externalPath = Join-Path (Split-Path -Parent $configPath) ([string]$section.configSource)
    [xml]$external = Get-Content -LiteralPath $externalPath -Raw
    $section = $external.connectionStrings
}
if ($section.EncryptedData) {
    throw 'The connectionStrings section is encrypted. This diagnostic requires the deployed setting to be resolved by the server administrator.'
}
$entry = @($section.add | Where-Object { $_.name -eq 'InfinityBillingUW' })
if ($entry.Count -ne 1) {
    throw 'Expected one InfinityBillingUW entry in the deployed Web.config connectionStrings section.'
}
$billingConnection = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
try {
    # Explicit setters avoid Windows PowerShell's IDictionary property adapter.
    $billingConnection.set_ConnectionString([string]$entry[0].connectionString)
} catch {
    throw 'The InfinityBillingUW connection string could not be parsed. Check its syntax on the server.'
}

Write-Host "Configuration file: $configPath"
Write-Host "Configured SQL endpoint: $($billingConnection.DataSource)"
Write-Host "Database: $($billingConnection.InitialCatalog)"
Write-Host "Windows authentication: $($billingConnection.IntegratedSecurity)"
Write-Host "64-bit diagnostic process: $([Environment]::Is64BitProcess)"
Write-Host 'No password or full connection string will be displayed.'
if ($billingConnection.IntegratedSecurity) {
    Write-Host 'This test uses your Windows account. IIS uses its application identity, which may have different access.'
}
if ($ValidateOnly) {
    Write-Host 'PASS - Connection configuration parsed. No database connection was attempted.'
    return
}

function Test-BillingConnection {
    param([string]$Label, [string]$Endpoint)
    $candidate = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
    $candidate.set_ConnectionString($billingConnection.get_ConnectionString())
    $candidate.set_DataSource($Endpoint)
    $candidate.set_ConnectTimeout(15)
    $candidate.set_Pooling($false)
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $candidate.ConnectionString
    try {
        $connection.Open()
        Write-Host "PASS - $Label - SQL login and database opening succeeded."
        return $true
    } catch {
        $failure = $_.Exception
        while ($failure.InnerException -and -not ($failure -is [System.Data.SqlClient.SqlException])) {
            $failure = $failure.InnerException
        }
        Write-Host "FAIL - $Label"
        if ($failure -is [System.Data.SqlClient.SqlException]) {
            Write-Host "SQL error number: $($failure.Number)"
        }
        $message = $failure.Message
        if ($billingConnection.Password) {
            $message = $message.Replace($billingConnection.Password, '[redacted]')
        }
        Write-Host $message
        return $false
    } finally {
        $connection.Dispose()
    }
}

$configuredSuccess = Test-BillingConnection -Label 'Deployed configuration' -Endpoint $billingConnection.DataSource
$tcpSuccess = Test-BillingConnection -Label 'Explicit TCP endpoint' -Endpoint $TcpEndpoint
if ($configuredSuccess -and $tcpSuccess) {
    Write-Host 'Both tests passed. Compare the deployed application configuration, IIS process bitness/identity, SQL aliases, and the time of the failing request.'
} elseif ($tcpSuccess) {
    Write-Host 'Explicit TCP passed. Investigate the configured endpoint/protocol and SQL client aliases before changing the live connection string.'
} else {
    Write-Host 'Use the SQL error shown above to investigate login, database availability, pre-login/TLS, or endpoint configuration.'
}
