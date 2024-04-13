﻿CREATE PROCEDURE [cp].[GetTableData]
    @SchemaName NVARCHAR(100),
    @TableName NVARCHAR(100),
    @PageNumber INT = NULL,
    @PageSize INT = NULL,
    @TotalRows INT OUTPUT,
    @TotalPages INT OUTPUT
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX);
    DECLARE @Offset INT;
    DECLARE @FetchNext INT;

    -- Calculate Offset and FetchNext based on pagination
    IF @PageNumber IS NOT NULL AND @PageSize IS NOT NULL
    BEGIN
        SET @Offset = (@PageNumber - 1) * @PageSize;
        SET @FetchNext = @PageSize;
    END
    ELSE
    BEGIN
        SET @Offset = NULL;
        SET @FetchNext = NULL;
    END

    DECLARE @CountQuery NVARCHAR(MAX);

    SET @CountQuery = 'SELECT @TotalRows=COUNT(*) FROM '+ QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);
    EXEC sp_executesql @CountQuery, N'@TotalRows INT OUTPUT', @TotalRows OUTPUT;

    SET @TotalPages = CEILING(CAST(@TotalRows AS DECIMAL) / @PageSize);

    -- Build the dynamic SQL query with optional pagination
    SET @SqlQuery = '
        SELECT * 
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);

    IF @Offset IS NOT NULL AND @FetchNext IS NOT NULL
    BEGIN
        SET @SqlQuery = @SqlQuery + '
        ORDER BY (SELECT NULL) -- Dummy ordering for OFFSET-FETCH
        OFFSET ' + CAST(@Offset AS NVARCHAR(10)) + ' ROWS
        FETCH NEXT ' + CAST(@FetchNext AS NVARCHAR(10)) + ' ROWS ONLY';
    END

    -- Execute the dynamic SQL query
    EXEC sp_executesql @SqlQuery;
END
