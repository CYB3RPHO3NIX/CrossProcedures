ALTER PROCEDURE [cp].[Filter]
	@InputParameters VARCHAR(MAX)
AS
BEGIN
	DECLARE @Arguments TABLE (Value NVARCHAR(MAX));

	--Storing the arguments in an Array
	INSERT INTO @Arguments (Value)
	SELECT value FROM STRING_SPLIT(@InputParameters, '|');

	--Fetching the first argument
	DECLARE @FirstRow NVARCHAR(MAX);
	SELECT TOP 1 @FirstRow = Value
	FROM @Arguments;

	DECLARE @SchemaName NVARCHAR(MAX), @TableName NVARCHAR(MAX);
	
	DECLARE @DotIndex INT = CHARINDEX('.', @FirstRow);
	SET @SchemaName = SUBSTRING(@FirstRow, 1, @DotIndex - 1); -- Schema
	SET @TableName = SUBSTRING(@FirstRow, @DotIndex + 1, LEN(@FirstRow) - @DotIndex);

	DELETE FROM @Arguments
	WHERE Value = (SELECT TOP 1 Value FROM @Arguments);

	--Declare the ResultTable--A
	DECLARE @ResultsQuery NVARCHAR(MAX);
	SET @ResultsQuery = 'SELECT * INTO FinalResults FROM '+@SchemaName+'.'+@TableName+' WHERE 1=0';
	EXECUTE sp_executesql @ResultsQuery;

	--Declare the CurrentResults--B
	DECLARE @CurrentResultsQuery NVARCHAR(MAX);
	SET @CurrentResultsQuery = 'SELECT * INTO CurrentResults FROM '+@SchemaName+'.'+@TableName+' WHERE 1=0';
	EXECUTE sp_executesql @CurrentResultsQuery;

	--Declare the TempIntersection
	DECLARE @IntersectionQuery NVARCHAR(MAX);
	SET @IntersectionQuery = 'SELECT * INTO TempIntersection FROM '+@SchemaName+'.'+@TableName+' WHERE 1=0';
	EXECUTE sp_executesql @IntersectionQuery;

	--Starting the Loop
	DECLARE @CurrentArgs NVARCHAR(MAX);

	DECLARE argCursor CURSOR FOR
	SELECT Value
	FROM @Arguments;

	OPEN argCursor;

	FETCH NEXT FROM argCursor INTO @CurrentArgs;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Your logic for each row goes here
		--PRINT @CurrentArgs; -- Example: print the current value
		DECLARE @FilterName VARCHAR(100), @Args NVARCHAR(MAX);

		DECLARE @OpenParenIndex INT = CHARINDEX('(', @CurrentArgs);
		SET @FilterName = SUBSTRING(@CurrentArgs, 1, @OpenParenIndex - 1);

		SET @Args = SUBSTRING(@CurrentArgs, @OpenParenIndex + 1, LEN(@CurrentArgs) - @OpenParenIndex - 1);

		--we have @FilterName and @Args

		IF @FilterName = 'ContainsFilter'
		BEGIN
			
			DECLARE @Column VARCHAR(MAX), @Value VARCHAR(MAX);
			
			SET @Column = LEFT(@Args, CHARINDEX(',', @Args) - 1);
			SET @Value = RIGHT(@Args, LEN(@Args) - CHARINDEX(',', @Args));
			--Executing the ContainsFilter Stored procedure.
			
			DECLARE @SqlExecQuery NVARCHAR(MAX);
			SET @SqlExecQuery = 'EXEC';

			select @SchemaName, @TableName, @Column, @Value;

			INSERT INTO CurrentResults
			EXEC [cp].[ContainsFilter] @SchemaName, @TableName, @Column, @Value;

		END
		ELSE IF @FilterName = 'EqualsFilter'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'GreaterThan'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'GreaterThanOrEqualTo'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'HasOneOf'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'LessThan'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'LessThanOrEqualTo'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'NotContains'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'NotHasAnyOf'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		ELSE IF @FilterName = 'Range'
		BEGIN
			-- Statements to execute if condition2 is true
			CONTINUE;
		END
		--Perform Intersection of Final and Current and store in Temp

		IF EXISTS (SELECT 1 FROM CurrentResults)
		BEGIN
			INSERT INTO TempIntersection
			SELECT * FROM FinalResults
			INTERSECT
			SELECT * FROM CurrentResults;

			--Delete all from Final and Current

			DELETE FROM FinalResults;
			DELETE FROM CurrentResults;

			--Transfer from Intersection to Final

			INSERT INTO FinalResults
			SELECT * FROM TempIntersection;
		END

		-- Fetch the next row 
		FETCH NEXT FROM argCursor INTO @CurrentArgs;
	END
	CLOSE argCursor;

	-- Deallocate the cursor
	DEALLOCATE argCursor;

	Select * From FinalResults;

	--Cleanup
	DROP TABLE FinalResults;
	DROP TABLE CurrentResults;
	DROP TABLE TempIntersection;
END
