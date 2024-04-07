﻿CREATE PROCEDURE [cp].[HasOneOfFilter]
(
    @SchemaName NVARCHAR(128),
    @TableName NVARCHAR(128),
    @ColumnName NVARCHAR(128),
    @SearchString NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX)
    SET @sqlQuery = '
        SELECT *
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '
        WHERE ' + QUOTENAME(@ColumnName) + ' IN (''' + REPLACE(@SearchString, '|', ''',''') + ''')
    '

    EXEC sp_executesql @sqlQuery
END
