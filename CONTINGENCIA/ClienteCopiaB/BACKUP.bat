@ECHO ON
sqlcmd -S GXPRODUCTION\SS2008R2 -Q "EXEC sp_BackupDatabases @backupLocation='%1', @backupType='%8', @databaseName='%2'" -b
IF %ERRORLEVEL% NEQ 0 SET ERROR1=ERROR_NO_SE_GENERO_EL_BACK_UP
ECHO %ERROR1%
cd %1
@ECHO OFF
FOR %%F IN (*.bak) DO SET NombreArchivo=%%F
ECHO NombreArchivo: %NombreArchivo%
SET ruta=%1
SET RUTAARCHIVO=%ruta%%NombreArchivo%
goto sub


:sub
cd %1
SET NOMBRE=%5
SET CLAVE=%6
SET IP=%7
SET PORT=%9
@ECHO ON
7z a -tzip %NombreArchivo%.zip %RUTAARCHIVO%
goto sub2


:sub2
move %NombreArchivo%.zip %4
cd %1
SET RUT=%4
SET ARCHIVO=%NombreArchivo%
FORFILES /S /M *.bak /C "cmd /c echo @fsize">tamaño.txt
FOR /F %%A IN (tamaño.txt) DO SET tamaño=%%A
del tamaño.txt
DEL %NombreArchivo%
cd /d %3
FOR /F %%B IN (LastReorg.dat) DO SET REORG=%%B
cd /d %1
CALL FTP.bat %NOMBRE% %CLAVE% %IP% %RUT% %ARCHIVO% %PORT%
CALL C:\Users\Andres\Desktop\CONTINGENCIA\PARTICION.bat %NombreArchivo% %ERROR1% %8 %NOMBRE% %tamaño% %REORG% 