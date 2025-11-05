<# 
.SYNOPSIS
    script bucles
.DESCRIPCION
    Script de bucles anidados
.EXAMPLE
    .\buclesanidados.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 13/10/2025
    Version: 1.0
    Notas:
#>

$contador = 1
if ($contador -eq 9)
    ($cuentaAscendente = $true)
else
    ($cuentaAscendente = $false)
$numeroFilas = 3, $numeroColumnas = 3
for ($fila = 1; $fila -le $numeroFilas; fila++) {
    
}