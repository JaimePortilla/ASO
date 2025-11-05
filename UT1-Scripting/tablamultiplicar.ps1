<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\tablamultiplicar.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 06/10/2025
    Version: 1.0
    Notas:
#>
for ($i = 1; $i -le 10; $i++) {
    $resultado = 5 * $i
    Write-Output "5 x $i = $resultado"
}