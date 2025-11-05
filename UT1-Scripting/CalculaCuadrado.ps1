<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\CalculaCuadrado.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 06/10/2025
    Version: 1.0
    Notas:
#>
$numeros = 1..10

foreach ($numero in $numeros) {
    $cuadrado = [math]::Pow($numero, 2)
    Write-Output "El cuadrado de $numero es $cuadrado"
}