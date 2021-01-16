
CREATE PROCEDURE ResetDatabase
	/*
		RESET DATABASE PROCEDURE: 
			danger ..... for debug and development process
	*/
AS
BEGIN
	DECLARE @table_name NVARCHAR(MAX);

	-- get all the tables created by user
	DECLARE tbl_cursor CURSOR FAST_FORWARD 
	FOR
		SELECT Object_name(object_id) AS table_name 
		FROM sys.objects WHERE TYPE = 'U' 
		ORDER BY table_name DESC; -- to delete fact tables first

	OPEN tbl_cursor
	FETCH NEXT FROM tbl_cursor INTO @table_name

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF (@@FETCH_STATUS <> -2)
		BEGIN
			-- sql to reset the identity value and delete all the rows for any table
			DECLARE @statement NVARCHAR(200) = 
				CONCAT(
					'DBCC CHECKIDENT ('+CHAR(39)+@table_name+CHAR(39)+', RESEED, 0);',
					'DELETE FROM ', @table_name, ';'
				);
		
			EXECUTE sp_executesql @statement;
		END
	
		FETCH NEXT FROM tbl_cursor INTO @table_name
	END

	CLOSE tbl_cursor
	DEALLOCATE tbl_cursor
END
GO

CREATE PROCEDURE ResetTable
	@TableName NVARCHAR(40)
AS
BEGIN
	BEGIN TRY
		DECLARE @sql NVARCHAR(MAX) =
			CONCAT('DELETE FROM ', @TableName, ';',
				   'DBCC CHECKIDENT(', CHAR(39), @TableName, CHAR(39), ', RESEED, 0);'
			);

		EXEC sp_sqlexec @sql;
		SELECT '(TABLE '+@TableName+' was resetted)'
	END TRY
	BEGIN CATCH
		SELECT '(TABLE '+@TableName+' was not resetted, the action cannot be performed)'
	END CATCH
END