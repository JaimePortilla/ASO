<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\sumanumeros.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 29/09/2025
    Version: 1.0
    Notas:
#>
$suma = 0
for ($i = 1; $i -le 100; $i++) {
    $suma += $i
}
Write-Output "La suma de los números del 1 al 100 es: $suma"