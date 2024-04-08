CREATE PROCEDURE [cp].[LessThanOrEqualToFilter] (
    @SchemaName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128),
    @Value NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX)
    SET @sqlQuery = '
        SELECT *
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
        WHERE ' + QUOTENAME(@ColumnName) + ' <= @Value
    '

    EXEC sp_executesql @sqlQuery, N'@Value NVARCHAR(MAX)', @Value
END
