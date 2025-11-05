<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\PintaArray.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 06/10/2025
    Version: 1.0
    Notas:
#>
$nombres = @("Ana", "Luis", "María", "Carlos", "Sofía")

foreach ($nombre in $nombres) {
    Write-Output "Hola, $nombre"
}