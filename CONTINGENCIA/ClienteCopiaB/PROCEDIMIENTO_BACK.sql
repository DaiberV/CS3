USE [master]
GO
/****** Object:  StoredProcedure [dbo].[sp_BackupDatabases]    Script Date: 12/01/2016 14:43:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_BackupDatabases]
@databaseName sysname = null,
@backupType char (10),
@backupLocation nvarchar (200)
AS
SET NOCOUNT ON;
           
            DECLARE @DBs TABLE
            (
                 ID int IDENTITY PRIMARY KEY,

                DBNAME nvarchar(500)
            )
            INSERT INTO @DBs (DBNAME)
            SELECT Name FROM master.sys.databases
            where state=0
            AND name=@databaseName
            OR @databaseName IS NULL
            ORDER BY Name
            --IF @backupType='SWIT'
            --      BEGIN
            --      DELETE @DBs where DBNAME <> (@databaseName)
            --      END
            --ELSE IF @backupType='SIIAFE'
            --      BEGIN
            --      DELETE @DBs where DBNAME <> (@databaseName)
            --      END
            --ELSE
            --      BEGIN
            --      RETURN
            --      END
            DECLARE @BackupName varchar(100)
            DECLARE @BackupFile varchar(100)
            DECLARE @DBNAME varchar(300)
            DECLARE @sqlCommand NVARCHAR(1000) 
			DECLARE @dateTime NVARCHAR(20)
            DECLARE @Loop int 
            SELECT @Loop = min(ID) FROM @DBs
 
      WHILE @Loop IS NOT NULL
      BEGIN
      SET @DBNAME = '['+(SELECT DBNAME FROM @DBs WHERE ID = @Loop)+']'
       SET @dateTime = REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(CONVERT(CHARACTER,GETDATE(),120))),' ','_'),'-',''),':','')
		IF @backupType = 'SWIT'
            SET @BackupFile = @backupLocation+REPLACE(REPLACE(@DBNAME, '[',''),']','')+ @dateTime+ '.BAK'
      ELSE IF @backupType = 'SIIAFE'
            SET @BackupFile = @backupLocation+REPLACE(REPLACE(@DBNAME, '[',''),']','')+ @dateTime+ '.BAK'
      ELSE IF @backupType = 'SIIAFE2014'
            SET @BackupFile = @backupLocation+REPLACE(REPLACE(@DBNAME, '[',''),']','')+ @dateTime+ '.BAK'
	  ELSE IF @backupType = 'SWIT2012'
            SET @BackupFile = @backupLocation+REPLACE(REPLACE(@DBNAME, '[',''),']','')+ @dateTime+ '.BAK'	
      IF @backupType = 'SWIT'
            SET @BackupName = REPLACE(REPLACE(@DBNAME,'[',''),']','') +' differential backup for '+ @dateTime
      IF @backupType = 'SIIAFE'
            SET @BackupName = REPLACE(REPLACE(@DBNAME,'[',''),']','') +' differential backup for '+ @dateTime
      IF @backupType = 'SIIAFE2014'
            SET @BackupName = REPLACE(REPLACE(@DBNAME,'[',''),']','') +' differential backup for '+ @dateTime
	  IF @backupType = 'SWIT2012'
            SET @BackupName = REPLACE(REPLACE(@DBNAME,'[',''),']','') +' differential backup for '+ @dateTime
       IF @backupType = 'SWIT'
                  BEGIN
               SET @sqlCommand = 'BACKUP DATABASE ' +@DBNAME+  ' TO DISK = '''+@BackupFile+ ''' WITH INIT, NAME= ''' +@BackupName+''', NOSKIP, NOFORMAT'         
                  END
       IF @backupType = 'SIIAFE' 
                  BEGIN
               SET @sqlCommand = 'BACKUP DATABASE ' +@DBNAME+  ' TO DISK = '''+@BackupFile+ ''' WITH INIT, NAME= ''' +@BackupName+''', NOSKIP, NOFORMAT'        
                 END
       IF @backupType = 'SIIAFE2014' 
                  BEGIN
               SET @sqlCommand = 'BACKUP DATABASE ' +@DBNAME+  ' TO DISK = '''+@BackupFile+ ''' WITH INIT, NAME= ''' +@BackupName+''', NOSKIP, NOFORMAT'        
                 END          
       IF @backupType = 'SWIT2012' 
                  BEGIN
               SET @sqlCommand = 'BACKUP DATABASE ' +@DBNAME+  ' TO DISK = '''+@BackupFile+ ''' WITH INIT, NAME= ''' +@BackupName+''', NOSKIP, NOFORMAT'        
                 END
		EXEC(@sqlCommand)
                  SELECT @Loop = min(ID) FROM @DBs where ID>@Loop
END