<# 
.SYNOPSIS
    Script de practicas.
.DESCRIPCION
    Script de practicas
.EXAMPLE
    .\crearcarpetas.ps1
.NOTES
    Autor: Jaime Portilla
    Fecha: 06/10/2025
    Version: 1.0
    Notas:
#>

$Carpetas= @("ASIR1", "ASIR2", "DAM1", "DAM2", "DAW1", "DAW2", "SMR1", "SMR2", "SMRd1", "SMRd2")
foreach ($carpeta in $Carpetas){
    New-Item -Path "$usuario\carpeta\$carpeta" -ItemType Directory
    for ($i=1; $i -le 20; $i++){
    New-item -Path "$usuario\carpeta\$carpeta\$concat $carpeta$i" -ItemType Directory -Force
    }
}