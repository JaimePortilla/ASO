# Inventory Script

Este script en PowerShell recopila información del sistema (hardware, software, red y monitores) y la exporta a un archivo CSV.  
Incluye registro de actividad (logs), validación de permisos, creación automática de carpetas y un sistema de fallback si no puede escribir en la ruta indicada.  
Permite personalizar rutas y código de sesión mediante parámetros.  
El resultado final se almacena en un archivo CSV y los errores o eventos se registran en un archivo log.
