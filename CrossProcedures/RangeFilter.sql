CREATE PROCEDURE [cp].[RangeFilter]
    @SchemaName NVARCHAR(100),
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @lValue NVARCHAR(MAX),
    @hValue NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    -- Build the dynamic SQL query
    SET @SqlQuery = '
        SELECT * 
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
        WHERE ' + QUOTENAME(@ColumnName) + ' >= @lValue 
        AND ' + QUOTENAME(@ColumnName) + ' <= @hValue';

    -- Execute the dynamic SQL query
    EXEC sp_executesql @SqlQuery, 
        N'@lValue NVARCHAR(MAX), @hValue NVARCHAR(MAX)', 
        @lValue, @hValue;
END
