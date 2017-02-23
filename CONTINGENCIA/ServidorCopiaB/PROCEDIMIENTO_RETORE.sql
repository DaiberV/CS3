USE [master]
GO
/****** Object:  StoredProcedure [dbo].[daiberRestore]    Script Date: 12/03/2016 07:56:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[daiberRestore]
@PATH nchar(300),
@DBNAME nchar(30),
@PATHMASTER varchar(200)
AS
BEGIN
DECLARE @TEMP nchar(300)
DECLARE @SQLDROP NCHAR(300)
DECLARE @SUBSTRIN NCHAR(300)=RTRIM((SUBSTRING(@DBNAME,1,LEN(@DBNAME)-4)))
DECLARE @VARELE CHAR(35)
DECLARE @VARELE2 VARCHAR(200)=(SUBSTRING(@SUBSTRIN,1,LEN(@SUBSTRIN)-8))
SET @VARELE=@SUBSTRIN
SET @TEMP=
(
SELECT 
	name 
FROM 
	master.sys.databases 
	WHERE state=0 
	and name LIKE @VARELE2+'%'
)
SET @SQLDROP='DROP DATABASE'+' '+@TEMP
EXEC(@SQLDROP)


declare @var2 varchar(200)=@PATH;
DECLARE @MDF VARCHAR(300)=@PATHMASTER+''+@VARELE+''+'.mdf';
DECLARE @LDF VARCHAR(300)=@PATHMASTER+''+@VARELE+''+'.ldf';
declare @fileListTable table
(
    LogicalName          nvarchar(128),
    PhysicalName         nvarchar(260),
    [Type]               char(1),
    FileGroupName        nvarchar(128),
    Size                 numeric(20,0),
    MaxSize              numeric(20,0),
    FileID               bigint,
    CreateLSN            numeric(25,0),
    DropLSN              numeric(25,0),
    UniqueID             uniqueidentifier,
    ReadOnlyLSN          numeric(25,0),
    ReadWriteLSN         numeric(25,0),
    BackupSizeInBytes    numeric(30),
    SourceBlockSize      numeric(30),
    FileGroupID          numeric(30),
    LogGroupGUID         uniqueidentifier,
    DifferentialBaseLSN  numeric(25,0),
    DifferentialBaseGUID uniqueidentifier,
    IsReadOnl            bit,
    IsPresent            bit,
    TDEThumbprint        varbinary(32)
)
insert into @fileListTable exec('restore filelistonly from disk = '''+@var2+'''')
declare @logicalname varchar(30)=(
select
	LogicalName
from 
	@fileListTable
	Where
		[Type]='D'
)
declare @logicalnameLog varchar(30)=(
select
	LogicalName
from 
	@fileListTable
	Where
		[Type]='L'
)
 RESTORE DATABASE  @VARELE FROM DISK = @var2 WITH FILE=1,
    MOVE   @LogicalName  TO		@MDF,
	MOVE   @LogicalNameLog TO	@LDF,  NOUNLOAD,  REPLACE,  STATS = 10;
END

SET @SQLDROP='DROP DATABASE'+' '+@VARELE
EXEC(@SQLDROP)