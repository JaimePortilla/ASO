#==============================================
# Nombre: Backup.sh
# Descripción: Realiza una copia de seguridad de un directorio dado
# Autor: Jaime Portilla Pérez
# Fecha: 05/11/2025
# Versión:1.0
# Uso: ./Backup.sh [directorio]
# Comentarios:si no se proporciona un directorio, se usará el directorio actual
#==============================================
Directorio="$1"

if [ $# -eq 0 ]; then
    echo "no se ha proporcionado ningun directorio"
    exit 1
fi

if [ ! -d "$Directorio" ]; then
    echo "El directorio \"$Directorio\" no existe"
    exit 1
fi

if (dirname "$Directorio")";
then
    echo "Backup creado correctamente: $DEST"
    exit 0
else
    echo "Error al crear el backup"
    exit 1
fi