<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\condicional.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 06/10/2025
    Version: 1.0
    Notas:
#>

[double] $numero=Read-Host -Promp: 'Introduce un numero'
if ($numero %2 -eq 0) {
    Write-Output "$Numero es par"
} else {
    Write-Output "$numero es impar"
}