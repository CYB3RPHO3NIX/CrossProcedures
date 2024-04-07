CREATE PROCEDURE [cp].[EqualsFilter]
    @SchemaName NVARCHAR(100),
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @ColumnValue NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    -- Build the dynamic SQL query
    SET @SqlQuery = '
        SELECT *
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
        WHERE ' + QUOTENAME(@ColumnName) + ' = @ColumnValue';

    -- Execute the dynamic SQL query
    EXEC sp_executesql @SqlQuery, N'@ColumnValue NVARCHAR(MAX)', @ColumnValue;
END
