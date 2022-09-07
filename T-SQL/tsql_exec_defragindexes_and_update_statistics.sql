SET NOCOUNT ON; -- отключаем вывод количества возвращаемых строк, это несколько ускорит обработку
DECLARE @objectid INT; -- ID объекта
DECLARE @indexid INT; -- ID индекса
DECLARE @partitioncount BIGINT; -- количество секций если индекс секционирован
DECLARE @schemaname nvarchar(130); -- имя схемы в которой находится таблица
DECLARE @DatabaseName nvarchar(130);
DECLARE @fragment_count INT;
DECLARE @objectname nvarchar(130); -- имя таблицы 
DECLARE @indexname nvarchar(130); -- имя индекса
DECLARE @partitionnum BIGINT; -- номер секции
DECLARE @frag FLOAT; -- процент фрагментации индекса
DECLARE @command nvarchar(4000); -- инструкция T-SQL для дефрагментации либо ренидексации
DECLARE @name nvarchar(70);
DECLARE @preferredReplica INT;
DECLARE @SQL1 nvarchar (800);
DECLARE @SQL2 nvarchar (2000);
DECLARE @SQL3 nvarchar (800);
DECLARE @dbname nvarchar(200);
DECLARE @TableName SYSNAME;
DECLARE @TurnOnExecCommand BIT;
--====================================================================
--Если @TurnOnExecCommand = 0; То будет просто вывод на консоль без выполнения
--Если @TurnOnExecCommand = 1; То будет выполнение команд, с выводом на консоль
--====================================================================
SET @TurnOnExecCommand = 0;
--начало выборки по списку баз 
DECLARE db_cursor CURSOR FOR 
	SELECT name
	FROM master.dbo.sysdatabases
	WHERE name NOT IN ('master','model','msdb','tempdb','SSISDB') AND version NOT LIKE 'null'
 
--проверка на существование объектов
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

--Начало выборки по курсору со списком баз
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name
WHILE @@FETCH_STATUS = 0
BEGIN
 
		-- Отбор таблиц и индексов с помощью системного представления sys.dm_db_index_physical_stats
		-- Отбор только тех объектов которые являются индексами (index_id > 0), 
		-- фрагментация которых более 10% и количество страниц в индексе более 128
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
 
		-- Объявление курсора для чтения секций
		DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
 
		-- Открытие курсора
		OPEN partitions;
 
		-- Цикл по секциям
		WHILE (1=1)
			BEGIN;
				FETCH NEXT
				   FROM partitions
				   INTO @DatabaseName,@objectid, @indexid, @partitionnum, @frag,@fragment_count;
				IF @@FETCH_STATUS < 0 BREAK;
				SET @command = 'use ' + QUOTENAME(@name) + ';
				';
				-- Собираем имена объектов по ID
				--использую параметры функции sp_executesql для передачи и получения переменных из запроса.
				--Здесь один момент, если через переменную передать значение имени базы, то запрос не отрабатывает корректно. Поэтому заранее формируем строку с именем базы.
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
 
				-- Если фрагментация менее или равна 30% тогда дефрагментация, иначе реиндексация
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
 
				-- Если реиндексация, то для ускорения добавляем параметры использования TEMPDB(имеет смысл только если TempDB на отдельном физ. диске) и многопроцессорной обработки 
					IF @frag >= 30.0
					SET @command = @command + N' WITH (SORT_IN_TEMPDB = ON, MAXDOP = 0)';	
 
				PRINT @command;
				--выполнить команду
				IF @TurnOnExecCommand =1 EXEC (@command);
				--заполняем таблицу, для последующей обработки
				INSERT #work_to_temp VALUES(@name,@objectname,@indexname,@frag);
			END; --Конец 		WHILE (1=1)
			SELECT * FROM #work_to_do
			
		-- Закрытие курсора
		CLOSE partitions;
		DEALLOCATE partitions; 
		-- Удаление временной таблицы
		DROP TABLE #work_to_do; 
	FETCH NEXT FROM db_cursor INTO @name
END --конец выборки по списку баз
SELECT * FROM #work_to_temp order by infrag
--DROP TABLE #work_to_temp;
CLOSE db_cursor
DEALLOCATE db_cursor
/*=============================================================================================================*/
/*============================= следующий блок программы ======================================================*/
/*Итак, мы имеем таблицу #work_to_temp, в которой список баз данных и таблиц в которых нужно обновить статистику*/

SET NOCOUNT ON;
--удаляем временную таблицу если есть.
IF OBJECT_ID('tempdb..#work_to_sqltemp') IS NOT NULL     --Remove dbo here 
		DROP TABLE #work_to_sqltemp;
--создаем временную таблицу
CREATE TABLE #work_to_sqltemp
(
	schema_id int,
	tablename nvarchar(200),
	stat_name nvarchar(200),
	no_recompute int
);
--Начинаем выборку из таблицы #work_to_temp по имени базы
DECLARE db_name_cursor CURSOR FOR 
	SELECT dbname FROM #work_to_temp GROUP BY dbname;
	
OPEN db_name_cursor
FETCH NEXT FROM db_name_cursor INTO @dbname
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '--Begin select tables on DB: ' + @dbname;
	--Начало выборки по таблицам в текущей БД
	DECLARE table_name_cursor CURSOR FOR
		SELECT dbtable FROM #work_to_temp WHERE dbname = @dbname;
	OPEN table_name_cursor
	FETCH NEXT FROM table_name_cursor INTO @TableName;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--убрать вот эти скобки [] из имени таблицы
		set @TableName = PARSENAME(@TableName,1);
		--мега ЗАПРОС на получение названий объектов статистики из таблицы текущей бд
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
					-- Отбор по имени таблицы итогов, у которой мы расследуем проблему	
					AND o.name = @tablename1
					ORDER BY [rowmodctr] DESC;'
		--PRINT @SQL2;
		--данные во временную таблицу
		INSERT INTO #work_to_sqltemp EXEC sp_executesql @SQL2,N'@tablename1 nvarchar(200)',@tablename1 = @TableName;
		--следующий блок кода, на формирование команды обновления статистики
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
			--выполняем обновление статистики
			IF @TurnOnExecCommand = 1 EXEC sp_executesql @SQL3;
			--печать команды на консоль
			PRINT @SQL3;
		END
 
		CLOSE todo;
		DEALLOCATE todo;
		--Очистка временной таблицы
		TRUNCATE TABLE #work_to_sqltemp;
		--следующая запись
		FETCH NEXT FROM table_name_cursor INTO @TableName;
	END --Конец выборки по таблицам в текущей БД
	--destroy cursor
	CLOSE table_name_cursor
	DEALLOCATE table_name_cursor
--следующая запись
FETCH NEXT FROM db_name_cursor INTO @dbname
END --Конец выборки:  курсор на таблицу #work_to_temp, где храним значения БД,Таблица

--destroy cursor
CLOSE db_name_cursor
DEALLOCATE db_name_cursor