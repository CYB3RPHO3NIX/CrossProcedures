CREATE PROCEDURE [cp].[ContainsFilter]
    @SchemaName NVARCHAR(100),
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @ColumnValue NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    -- Build the dynamic SQL query
    SET @ColumnValue = '%' + @ColumnValue + '%'; -- Add % wildcard characters
    SET @SqlQuery = '
        SELECT *
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
        WHERE ' + QUOTENAME(@ColumnName) + ' LIKE @ColumnValue';

    -- Execute the dynamic SQL query
    EXEC sp_executesql @SqlQuery, N'@ColumnValue NVARCHAR(MAX)', @ColumnValue;
END
