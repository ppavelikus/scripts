
CREATE PROCEDURE [dbo].[sp_sys_BackupDB]
@DBName varchar(50)= 'pubs',
@BackupFileName varchar(500)= 'MyBackUp.bak' ,
@BackupFolderPath varchar(500) = 'C:\' output
--=============================================
--Created : 22-Jul-2005 Altered: 23-Dec-2005
--Creates a Backup of a database.
/*

--Run this proc/ like this:
exec sp_sys_BackupDB 'Pubs', default

*/
--=============================================
AS

DECLARE @BackupFolder varchar(300)
DECLARE @SQL varchar(8000)
DECLARE @SingleQuote varchar(4) -- single quote symbol
DECLARE @RetainDays int -- number of days backup-file will acamulate new backups

SET @SingleQuote = CHAR(39) -- single quote symbol
SET @RetainDays = 30

-- Return the full path to the backup folder (the resulted string always ends with "\" symbol)
IF RIGHT (@BackupFolder,1) <> '\' SET @BackupFolder = @BackupFolder + '\'
SET @BackupFolderPath = @BackupFolder
--PRINT @BackupFolder

--0) Make full Backup of the database
--WITH NOINIT means that do not owerite data, but add new data (see @RetainDays variable)
SET @BackupFileName = RTRIM(LTRIM(@BackupFileName))
IF @BackupFileName = ''
SET @BackUPFileName = @BackupFolder + @DBName +'_FullBackup_' + dbo.udfFormatDate (GetDate()) + '_' + dbo.udfFormatTime (GetDate(),'-')
ELSE
SET @BackUPFileName = @BackupFolder + @BackUPFileName

SET @BackUPFileName = @BackUPFileName + '.BAK'
--Print @BackUPFileName
SET @SQL = 'BACKUP DATABASE [' + @DBName + '] TO DISK = ' + @SingleQuote + @BackUPFileName + @SingleQuote +
' WITH NOINIT , NOUNLOAD , RETAINDAYS = ' + LTRIM(STR(@RetainDays)) + ',' +
' MEDIANAME = ' + @SingleQuote + 'Full backup of <' + @DBName + '> database, storing backups for ' + LTRIM(STR(@RetainDays)) + ' day(s).' + @SingleQuote
--The following string will be formed:
--print @SQL
-- BACKUP DATABASE [MedCash] TO DISK = 'C:\Pubs_FullBackup_23-Dec-2005_15-00.BAK' WITH NOINIT ,
-- NOUNLOAD , RETAINDAYS = 31,
-- MEDIANAME = ' Full backup of <Pubsh > database, storing backups for 31 day(s).'

EXEC (@SQL)

IF @@ERROR = 0
BEGIN
RETURN 0
END
ELSE
BEGIN
RETURN 1
END

GO