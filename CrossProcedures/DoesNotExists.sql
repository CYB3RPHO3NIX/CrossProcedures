CREATE PROCEDURE [cp].[DoesNotExistsFilter]
    @SchemaName NVARCHAR(100),
    @TableName NVARCHAR(100),
    @ColumnName NVARCHAR(100),
    @Value NVARCHAR(MAX)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);

    -- Build the dynamic SQL query
    SET @SqlQuery = '
        SELECT CASE WHEN EXISTS (
            SELECT 1 
            FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
            WHERE ' + QUOTENAME(@ColumnName) + ' <> @Value
        ) THEN ''True'' ELSE ''False'' END AS ValueExists';

    -- Execute the dynamic SQL query
    EXEC sp_executesql @SqlQuery, N'@Value NVARCHAR(MAX)', @Value;
END
