#!/bin/bash
#==============================================
# Nombre: Saludo
# Descripción: un saludo
# Autor: Jaime Portilla Pérez
# Fecha: 03/11/2025
# Versión:1.0
# Uso: ./saludo.sh "Nombre"
# Comentarios:
#==============================================
if [ $# -eq 0 ]
then
    echo "No se han recibido parametros."
    exit 1
fi

Nombre=$1
echo "hola $Nombre"
