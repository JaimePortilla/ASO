param(
    [string]$OutputPath = "H:\ASR2\Practica_PS",
    [string]$LogPath = "H:\ASR2\Practica_PS\logs",
    [string]$SessionCode = "UT1_P1_JPP"
)

# === BLOQUEAR ARGUMENTOS POSICIONALES ===
if ($args.Count -gt 0) {
    Write-Error "ERROR: Parametro no reconocido: '$($args -join ', ')'
    Uso correcto:
      .\UT1_practical-PortillaJaime.ps1
      .\UT1_practical-PortillaJaime.ps1 -SessionCode 'UT1_P1_JPP'"
    exit 1
}

# === FUNCIÓN: REGISTRO DE ACTIVIDAD (LOGS) ===
function Write-Log {
    param(
        [Parameter(Mandatory)] [string]$Message,
        [Parameter(Mandatory)] [ValidateSet("INFO","WARN","ERROR")] [string]$Level
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] <$Level> <$env:computername> <$SessionCode> $Message"

    try {
        Add-Content -Path $ErrorLogPath -Value $logLine -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        $fallback = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Inventory-Error.log"
        try { Add-Content -Path $fallback -Value $logLine -Encoding UTF8 } catch { }
    }
}

# === FUNCIÓN: PRUEBA DE ESCRITURA ===
function Test-WriteAccess {
    param([string]$Path)
    $testFile = Join-Path $Path "test_$(Get-Random).tmp"
    try {
        "test" | Out-File -FilePath $testFile -Encoding UTF8 -Force -ErrorAction Stop
        Remove-Item -Path $testFile -Force -ErrorAction Stop
        return $true
    }
    catch { return $false }
}

# === RUTAS ===
$csv = Join-Path $OutputPath "$env:computername-$SessionCode-Inventory.csv"
$ErrorLogPath = Join-Path $LogPath "$SessionCode.log"
$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$infoColl = @()
$usedFallback = $false

Write-Host "INICIANDO RECOLECCION DE INVENTARIO..." -ForegroundColor Cyan
Write-Log -Message "Script iniciado por $Username" -Level "INFO"

# === ASEGURAR CARPETA DE LOGS (ANTES DE NADA) ===
$logFolder = Split-Path $ErrorLogPath -Parent
if (-not (Test-Path $logFolder)) {
    try {
        New-Item -ItemType Directory -Path $logFolder -Force -ErrorAction Stop | Out-Null
        Write-Log -Message "Carpeta de logs creada: $logFolder" -Level "INFO"
    }
    catch {
        Write-Warning "NO SE PUDO CREAR CARPETA DE LOGS: $logFolder"
        $ErrorLogPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell-PC-Inventory-Error-Log-$SessionCode.log"
        Write-Log -Message "Fallback de logs a Documentos" -Level "WARN"
    }
}
if (-not (Test-WriteAccess -Path $logFolder)) {
    Write-Warning "SIN PERMISOS EN CARPETA DE LOGS"
    $ErrorLogPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell-PC-Inventory-Error-Log-$SessionCode.log"
    Write-Log -Message "Fallback de logs por permisos" -Level "WARN"
}

# === RECOLECCIÓN DE DATOS ===
Write-Verbose "Obteniendo datos del sistema..."
Write-Log -Message "Iniciando recoleccion de datos" -Level "INFO"

# === EXPORTAR A CSV ===
function OutputToCSV {
    Write-Verbose "Exportando a CSV..."
    Write-Log -Message "Intentando exportar CSV" -Level "INFO"

    $obj = [PSCustomObject]@{
        "Date Collected" = $Date
        "Hostname" = $env:computername
        "IP Address" = $interfaceIP
        "MAC Address" = $interfaceMAC
        "User" = $Username
        "Type" = $ChassisDescription
        "Serial Number/Service Tag" = $SN
        "Model" = $Model
        "BIOS" = $BIOS
        "CPU" = $CPU
        "RAM (GB)" = $RAM
        "Storage (GB)" = $Storage
        "GPU 0" = $GPU0
        "GPU 1" = $GPU1
        "OS" = $OS.Caption
        "OS Version" = $OSBuild
        "Up time" = $uptimeReadable
        "Monitor 1" = $Monitor1
        "Monitor 1 Serial Number" = $Monitor1SN
        "Monitor 2" = $Monitor2
        "Monitor 2 Serial Number" = $Monitor2SN
        "Monitor 3" = $Monitor3
        "Monitor 3 Serial Number" = $Monitor3SN
        "Installed Apps" = $appsList
    }

    $script:infoColl += $obj

    try {
        $infoColl | Export-Csv -Path $csv -NoTypeInformation -Append -Force -Encoding UTF8
        Write-Log -Message "CSV exportado correctamente: $csv" -Level "INFO"
        return $true
    }
    catch {
        Write-Log -Message "ERROR al exportar CSV: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# === CREAR CARPETA Y ARCHIVO CSV ===
if (-not (Test-Path $csv)) {
    Write-Host "PREPARANDO ARCHIVO DE INVENTARIO..." -ForegroundColor Cyan
    Write-Log -Message "Preparando ruta de salida: $OutputPath" -Level "INFO"

    $csvFolder = Split-Path $csv -Parent

    if (-not (Test-Path $csvFolder)) {
        try {
            New-Item -ItemType Directory -Path $csvFolder -Force -ErrorAction Stop | Out-Null
            Write-Log -Message "Carpeta creada: $csvFolder" -Level "INFO"
        }
        catch {
            Write-Warning "NO SE PUDO CREAR CARPETA: $csvFolder"
            Write-Log -Message "Fallo al crear carpeta. Fallback a Documentos." -Level "WARN"
            $csvFolder = [Environment]::GetFolderPath("MyDocuments")
            $csv = Join-Path $csvFolder "$env:computername-$SessionCode-Inventory.csv"
            $usedFallback = $true
        }
    }

    if (-not (Test-WriteAccess -Path $csvFolder)) {
        Write-Warning "SIN PERMISOS EN: $csvFolder"
        Write-Log -Message "Sin permisos de escritura. Fallback a Documentos." -Level "WARN"
        $csvFolder = [Environment]::GetFolderPath("MyDocuments")
        $csv = Join-Path $csvFolder "$env:computername-$SessionCode-Inventory.csv"
        $usedFallback = $true
    }

    try {
        New-Item -ItemType "file" -Path $csv -Force -ErrorAction Stop | Out-Null
        try { icacls $csv /grant "$env:USERNAME:F" /Q 2>$null | Out-Null } catch { }
        Write-Log -Message "Archivo CSV creado: $csv" -Level "INFO"
    }
    catch {
        Write-Log -Message "ERROR CRITICO: No se pudo crear CSV" -Level "ERROR"
        throw "FALLO EN CREACION DE ARCHIVO"
    }
}

# === EJECUTAR ===
$exportOk = OutputToCSV

# === RESUMEN FINAL ===
Write-Host "`n=== RESUMEN FINAL ===" -ForegroundColor Cyan
if ($exportOk) {
    if ($usedFallback) {
        Write-Host "GUARDADO LOCAL POR FALTA DE CONEXION O PERMISOS" -ForegroundColor Yellow
        Write-Host "RUTA: $csv" -ForegroundColor White
        Write-Log -Message "Inventario guardado localmente: $csv" -Level "WARN"
    } else {
        Write-Host "INVENTARIO GENERADO CORRECTAMENTE" -ForegroundColor Green
        Write-Host "RUTA: $csv" -ForegroundColor White
        Write-Log -Message "Inventario completado en red" -Level "INFO"
    }
} else {
    Write-Host "ERROR AL GENERAR INVENTARIO" -ForegroundColor Red
    Write-Host "REVISA LOG: $ErrorLogPath" -ForegroundColor White
    Write-Log -Message "Fallo final en exportacion" -Level "ERROR"
}

Write-Host "`nFIN DEL SCRIPT." -ForegroundColor Cyan
exit 0