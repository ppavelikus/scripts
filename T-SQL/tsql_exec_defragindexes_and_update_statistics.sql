SET NOCOUNT ON; -- ��������� ����� ���������� ������������ �����, ��� ��������� ������� ���������
DECLARE @objectid INT; -- ID �������
DECLARE @indexid INT; -- ID �������
DECLARE @partitioncount BIGINT; -- ���������� ������ ���� ������ �������������
DECLARE @schemaname nvarchar(130); -- ��� ����� � ������� ��������� �������
DECLARE @DatabaseName nvarchar(130);
DECLARE @fragment_count INT;
DECLARE @objectname nvarchar(130); -- ��� ������� 
DECLARE @indexname nvarchar(130); -- ��� �������
DECLARE @partitionnum BIGINT; -- ����� ������
DECLARE @frag FLOAT; -- ������� ������������ �������
DECLARE @command nvarchar(4000); -- ���������� T-SQL ��� �������������� ���� ������������
DECLARE @name nvarchar(70);
DECLARE @preferredReplica INT;
DECLARE @SQL1 nvarchar (800);
DECLARE @SQL2 nvarchar (2000);
DECLARE @SQL3 nvarchar (800);
DECLARE @dbname nvarchar(200);
DECLARE @TableName SYSNAME;
DECLARE @TurnOnExecCommand BIT;
--====================================================================
--���� @TurnOnExecCommand = 0; �� ����� ������ ����� �� ������� ��� ����������
--���� @TurnOnExecCommand = 1; �� ����� ���������� ������, � ������� �� �������
--====================================================================
SET @TurnOnExecCommand = 0;
--������ ������� �� ������ ��� 
DECLARE db_cursor CURSOR FOR 
	SELECT name
	FROM master.dbo.sysdatabases
	WHERE name NOT IN ('master','model','msdb','tempdb','SSISDB') AND version NOT LIKE 'null'
 
--�������� �� ������������� ��������
IF OBJECT_ID('tempdb..#work_to_do') IS NOT NULL     --Remove dbo here 
		DROP TABLE #work_to_do;
IF OBJECT_ID('tempdb..#work_to_temp') IS NOT NULL
	DROP TABLE #work_to_temp;

CREATE TABLE #work_to_temp (
	dbname nvarchar(200),
	dbtable nvarchar(200),
	tbindexname nvarchar(200),
	infrag float
)

--������ ������� �� ������� �� ������� ���
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
 
		-- ����� ������ � �������� � ������� ���������� ������������� sys.dm_db_index_physical_stats
		-- ����� ������ ��� �������� ������� �������� ��������� (index_id > 0), 
		-- ������������ ������� ����� 10% � ���������� ������� � ������� ����� 128
		SELECT
			DB_Name(database_id) AS DatabaseName,
			object_id AS objectid,
			index_id AS indexid,
			partition_number AS partitionnum,
			avg_fragmentation_in_percent AS frag,
			fragment_count AS fragcount
		INTO #work_to_do
		FROM sys.dm_db_index_physical_stats (DB_ID(@name), NULL, NULL , NULL, 'LIMITED')
		WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND fragment_count > 128;
 
		-- ���������� ������� ��� ������ ������
		DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
 
		-- �������� �������
		OPEN partitions;
 
		-- ���� �� �������
		WHILE (1=1)
			BEGIN;
				FETCH NEXT
				   FROM partitions
				   INTO @DatabaseName,@objectid, @indexid, @partitionnum, @frag,@fragment_count;
				IF @@FETCH_STATUS < 0 BREAK;
				SET @command = 'use ' + QUOTENAME(@name) + ';
				';
				-- �������� ����� �������� �� ID
				--��������� ��������� ������� sp_executesql ��� �������� � ��������� ���������� �� �������.
				--����� ���� ������, ���� ����� ���������� �������� �������� ����� ����, �� ������ �� ������������ ���������. ������� ������� ��������� ������ � ������ ����.
				--USE [DBNAME]
				SET @SQL1 = N'USE ['+@name+'];
				SELECT @objectname1 = QUOTENAME(o.name), @schemaname1 = QUOTENAME(s.name)
				FROM sys.objects AS o
				JOIN sys.schemas AS s ON s.schema_id = o.schema_id
				WHERE o.object_id = @objectid1;
				SELECT @indexname1 = QUOTENAME(name)
				FROM sys.indexes
				WHERE  object_id = @objectid1 AND index_id = @indexid1;
				SELECT @partitioncount1 = COUNT (*)
				FROM sys.partitions
				WHERE object_id = @objectid1 AND index_id = @indexid1;
				'
				EXEC sp_executesql
				@SQL1,
				N'@objectname1 nvarchar(130) OUTPUT, 
				@schemaname1 nvarchar(130) OUTPUT, 
				@indexname1 nvarchar(130) OUTPUT,
				@partitioncount1 BIGINT OUTPUT,
				@objectid1 int, @indexid1 int',
				@objectname1=@objectname OUTPUT,
				@schemaname1=@schemaname OUTPUT,
				@indexname1=@indexname OUTPUT,
				@partitioncount1=@partitioncount OUTPUT,
				@objectid1 = @objectid,
				@indexid1=@indexid;
 
				-- ���� ������������ ����� ��� ����� 30% ����� ��������������, ����� ������������
				IF @frag <= 30.0 AND @frag >= 10.0
				BEGIN
				    SET @command = @command + N'--Fragment ' + STR(@frag,5,2) +'% and PageCount' + STR(@fragment_count,7) + '
					';
					SET @command = @command +  N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
				END
				IF @frag > 30.0
				BEGIN
				    SET @command = @command + N'--Fragment ' + STR(@frag,5,2) +'% and PageCount' + STR(@fragment_count,7) + '
					';
					SET @command = @command + N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
				END
				IF @partitioncount > 1
					SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
 
				-- ���� ������������, �� ��� ��������� ��������� ��������� ������������� TEMPDB(����� ����� ������ ���� TempDB �� ��������� ���. �����) � ����������������� ��������� 
					IF @frag >= 30.0
					SET @command = @command + N' WITH (SORT_IN_TEMPDB = ON, MAXDOP = 0)';	
 
				PRINT @command;
				--��������� �������
				IF @TurnOnExecCommand =1 EXEC (@command);
				--��������� �������, ��� ����������� ���������
				INSERT #work_to_temp VALUES(@name,@objectname,@indexname,@frag);
			END; --����� 		WHILE (1=1)
			SELECT * FROM #work_to_do
			
		-- �������� �������
		CLOSE partitions;
		DEALLOCATE partitions; 
		-- �������� ��������� �������
		DROP TABLE #work_to_do; 
	FETCH NEXT FROM db_cursor INTO @name
END --����� ������� �� ������ ���
SELECT * FROM #work_to_temp order by infrag
--DROP TABLE #work_to_temp;
CLOSE db_cursor
DEALLOCATE db_cursor
/*=============================================================================================================*/
/*============================= ��������� ���� ��������� ======================================================*/
/*����, �� ����� ������� #work_to_temp, � ������� ������ ��� ������ � ������ � ������� ����� �������� ����������*/

SET NOCOUNT ON;
--������� ��������� ������� ���� ����.
IF OBJECT_ID('tempdb..#work_to_sqltemp') IS NOT NULL     --Remove dbo here 
		DROP TABLE #work_to_sqltemp;
--������� ��������� �������
CREATE TABLE #work_to_sqltemp
(
	schema_id int,
	tablename nvarchar(200),
	stat_name nvarchar(200),
	no_recompute int
);
--�������� ������� �� ������� #work_to_temp �� ����� ����
DECLARE db_name_cursor CURSOR FOR 
	SELECT dbname FROM #work_to_temp GROUP BY dbname;
	
OPEN db_name_cursor
FETCH NEXT FROM db_name_cursor INTO @dbname
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '--Begin select tables on DB: ' + @dbname;
	--������ ������� �� �������� � ������� ��
	DECLARE table_name_cursor CURSOR FOR
		SELECT dbtable FROM #work_to_temp WHERE dbname = @dbname;
	OPEN table_name_cursor
	FETCH NEXT FROM table_name_cursor INTO @TableName;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--������ ��� ��� ������ [] �� ����� �������
		set @TableName = PARSENAME(@TableName,1);
		--���� ������ �� ��������� �������� �������� ���������� �� ������� ������� ��
		set @SQL2='USE ['+ @dbname +'];
		SELECT [o].[schema_id], [o].[name] as [tablename],[s].[name] as [stat_name], [s].[no_recompute]
		FROM (
			SELECT
				[object_id]
				,[name]
				,[stats_id]
				,[no_recompute]
				,[last_update] = STATS_DATE([object_id], [stats_id])
				,[auto_created]
			FROM sys.stats WITH(NOLOCK)
			WHERE [is_temporary] = 0) s
				LEFT JOIN sys.objects o WITH(NOLOCK) 
					ON [s].[object_id] = [o].[object_id]
				LEFT JOIN (
					SELECT
						[p].[object_id]
						,[p].[index_id]
						,[total_pages] = SUM([a].[total_pages])
					FROM sys.partitions p WITH(NOLOCK)
						JOIN sys.allocation_units a WITH(NOLOCK) ON [p].[partition_id] = [a].[container_id]
					GROUP BY 
						[p].[object_id]
						,[p].[index_id]) p 
					ON [o].[object_id] = [p].[object_id] AND [p].[index_id] = [s].[stats_id]
				LEFT JOIN sys.sysindexes si
					ON [si].[id] = [s].[object_id] AND [si].[indid] = [s].[stats_id]
					WHERE [o].[TYPE] IN (''U'', ''V'') AND [o].[is_ms_shipped] = 0
					-- ����� �� ����� ������� ������, � ������� �� ���������� ��������	
					AND o.name = @tablename1
					ORDER BY [rowmodctr] DESC;'
		--PRINT @SQL2;
		--������ �� ��������� �������
		INSERT INTO #work_to_sqltemp EXEC sp_executesql @SQL2,N'@tablename1 nvarchar(200)',@tablename1 = @TableName;
		--��������� ���� ����, �� ������������ ������� ���������� ����������
		DECLARE todo CURSOR FOR
		SELECT
			'
			UPDATE STATISTICS [' + SCHEMA_NAME([schema_id]) + '].[' + [tablename] + '] [' + [stat_name] + ']
				WITH FULLSCAN' + CASE WHEN [no_recompute] = 1 THEN ', NORECOMPUTE' ELSE '' END + ';'
		FROM #work_to_sqltemp;

		OPEN todo;
		WHILE 1=1
		BEGIN
			FETCH NEXT FROM todo INTO @SQL3
 
			IF @@FETCH_STATUS != 0
				BREAK;
			--��������� ���������� ����������
			IF @TurnOnExecCommand = 1 EXEC sp_executesql @SQL3;
			--������ ������� �� �������
			PRINT @SQL3;
		END
 
		CLOSE todo;
		DEALLOCATE todo;
		--������� ��������� �������
		TRUNCATE TABLE #work_to_sqltemp;
		--��������� ������
		FETCH NEXT FROM table_name_cursor INTO @TableName;
	END --����� ������� �� �������� � ������� ��
	--destroy cursor
	CLOSE table_name_cursor
	DEALLOCATE table_name_cursor
--��������� ������
FETCH NEXT FROM db_name_cursor INTO @dbname
END --����� �������:  ������ �� ������� #work_to_temp, ��� ������ �������� ��,�������

--destroy cursor
CLOSE db_name_cursor
DEALLOCATE db_name_cursor