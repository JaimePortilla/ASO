#==============================================
# Nombre: archivo
# Descripción: Cuenta el número de archivos en un directorio dado
# Autor: Jaime Portilla Pérez
# Fecha: 05/11/2025
# Versión:1.0
# Uso: ./archivo.sh
# Comentarios:Debe proporcionarse un directorio como parámetro
#==============================================

Directorio=$1

if [ $# -eq 0 ]
then 
    echo "no se ha proporcionado ningun directorio"
    exit 1
elif [ ! -d "$Directorio" ]
then   
    echo "El directorio "$Directorio" no existe"
    exit 1
fi
NumArchivos=$(ls -l "$Directorio"| wc -l)
echo "El directorio "$Directorio" tiene "$NumArchivos" archivos" 