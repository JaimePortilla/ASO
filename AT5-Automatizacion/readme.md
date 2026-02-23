# Administracion de Sistemas Operativos
## Jaime Portilla Pérez

## UT1-Scripts
  * PoweShell
  * Bash
## UT2-Active_Directory
 Actividades dominio
 # Tarea de Automatización con GPOs - Windows Server
 **Alumno:** Jaime Portilla Pérez 
 **Iniciales:** JPP  
 **Fecha:** Febrero 2026
 
 ---
 
 ## Parte 1: Mapeo Automático de Unidades de Red
 
 **Objetivo**  
 Configurar el mapeo automático de unidades de red según el grupo de seguridad al que pertenece el usuario mediante una Política de Grupo (GPO).
 
 ### Estructura de Unidades Organizativas (UO) y Grupos
 
 Se ha creado la siguiente estructura en Active Directory:
 
 
 ![alt text](parte1/uos.png)
 
 **Grupos de seguridad creados:**
 - GRP_Administracion (con user_admin1 y user_admin2)
 - GRP_Informatica (con user_info1 y user_info2)
 
 ### Carpetas Compartidas en el Servidor
 
 Se crearon las carpetas en `C:\Compartidas\`:
 
 ![alt text](parte1/compartidas.png)
 
 ### Configuración de Permisos
 
 Se eliminó el grupo “Todos” en las carpetas restringidas y se aplicaron permisos tanto en **Recurso compartido** como en **NTFS**:
 
 | Carpeta compartida     | Ruta local                        | Grupo con acceso          | Justificación |
 |------------------------|-----------------------------------|---------------------------|---------------|
 | **Compartida-Admin**   | `C:\Compartidas\Admin`            | GRP_Administracion        | Solo Administración |
 | **Compartida-Info**    | `C:\Compartidas\Informatica`      | GRP_Informatica           | Solo Informática |
 | **Compartida-Todos**   | `C:\Compartidas\Comun`            | Todos los usuarios        | Acceso común |
 
 **Capturas de permisos:**
 
 **Carpeta Admin**  
 
 ![alt text](parte1/compartida-admin.png)
 
 ![alt text](parte1/compartida-admin2.png)
 **Carpeta Informatica**  
 
 ![alt text](parte1/compartidaInformatica.png)
 
 **Carpeta Comun**
 
 ![alt text](parte1/compartidacomun.png)
 
 ### Creación de la GPO
 
 **Nombre de la GPO:** `Mapeo-Unidades-JPP`
 
 ![alt text](parte1/creargpo.png)
 
 **Ubicación:** Configuración de usuario > Preferencias > Asignaciones de unidad
 
 Se configuraron 3 unidades con **Acción = Crear** y segmentación por grupo:
 
 ![alt text](parte1/mapeo1.png)
 
 ![alt text](parte1/mapeo2.png)
 
 ![alt text](parte1/mapeo3.png)
 
 ![alt text](parte1/mapeo4.png)
 
 ![alt text](parte1/mapeo5.png)
 
 ![alt text](parte1/mapeo6.png)
 
 
 **Vista general de las tres unidades:**
 
 ![alt text](parte1/mapeo7.png)
 
 **Vinculación:**  
 Vinculada a: `UO_Administracion`, `UO_Informatica` y `UO_Usuarios`
 
 ### Pruebas de Verificación
 
 **Con usuario de Administración (user_admin1):**
 
 ![alt text](parte1/pruebas.png)
 
 **Con usuario de Informática (user_info1):**
 
 ![alt text](parte1/pruebas2.png)
 
 
 
 **Acceso denegado correcto:** Usuario de Informática no puede acceder a Compartida-Admin.
 
 ---
 ![alt text](parte1/pruebas3.png)
 
 ## Parte 2: Script de Limpieza Automático
 
 **Objetivo**  
 Desplegar y programar automáticamente un script de limpieza de archivos temporales mediante GPO, sin intervención del usuario.
 
 ### Script Utilizado
 
 ![alt text](parte2/script1.png)
 
 ### Ubicación del Script en SYSVOL
 Ruta completa:
 \\JPP.local\SYSVOL\JPP.local\scripts\Limpieza-Temporal.ps1
 
 ![alt text](parte2/sysvol.png)
 
 ### Creacion GPO
 Desencadenador: Semanal (día y hora elegidos)
 Cuenta: SYSTEM
 Privilegios: Ejecutar con los privilegios más elevados
 Acción:powershell.exe con argumento -ExecutionPolicy Bypass -File "\\JPP.local\SYSVOL\JPP.local\scripts\Limpieza-Temporal.ps1"
 
 ![alt text](parte2/creargpo2.png)
 
 ### Tarea Programada
 
 ![alt text](parte2/programada.png)
 
 ![alt text](parte2/programada2.png)
 
 ### Pruebas
 
 Tuve un problema y no me dejaba ejecutarlo en el windows 11, por lo que lo ejecute en el windows server, los logs aparecen en el disco local (C:)
 
 ![alt text](parte2/pruebafin.png)