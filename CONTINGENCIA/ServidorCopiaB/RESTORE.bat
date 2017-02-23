CD %1
FOR %%G IN (*.zip) DO SET NombreArchivoZIP=%%G
ECHO %NombreArchivoZIP%
MOVE %NombreArchivoZIP% %2
CD %2
7z e %NombreArchivoZIP%
FOR %%F IN (*.bak) DO SET NombreArchivo=%%F
ECHO NombreArchivo: %NombreArchivo%
SET NOM=%NombreArchivo%
MOVE %NombreArchivo% %1
MOVE %NombreArchivoZIP% %4
CD %1
SET ruta=%1
SET RUTAARCHIVO=%ruta%%NombreArchivo%
SET MASTER=%3
sqlcmd -S S166-62-88-36\SQLEXPRESS -Q "EXEC daiberRestore @PATH='%RUTAARCHIVO%', @DBNAME='%NOM%',@PATHMASTER='%MASTER%'" -b
IF %ERRORLEVEL% NEQ 0 SET ERROR1=ERROR_NO_SE_RESTAURO_EL_BACK_UP
ECHO %ERROR1%
START C:\Users\goadmon\Documents\RestoreBack\RestoreEXE\GetRestore.exe %NOM% %ERROR1%
del %NOM%