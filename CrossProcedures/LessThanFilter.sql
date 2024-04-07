CREATE PROCEDURE [cp].[LessThanFilter] (
    @schemaName NVARCHAR(128),
    @tableName NVARCHAR(128),
    @columnName NVARCHAR(128),
    @value NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX)
    SET @sqlQuery = '
        SELECT *
        FROM ' + QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName) + '
        WHERE ' + QUOTENAME(@columnName) + ' < @value
    '

    EXEC sp_executesql @sqlQuery, N'@value NVARCHAR(MAX)', @value
END
