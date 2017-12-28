USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_', 'P') IS NOT NULL
	DROP PROCEDURE [USP_];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    <PURPOSE>                                               --
----------------------------------------------------------------
CREATE PROCEDURE [USP_] (
	@Param1		NVARCHAR(32),
	@Param2		FLOAT,
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			-- stored procedure code here
		END TRY BEGIN CATCH;
			RETURN 1;
		END CATCH;
	ROLLBACK;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_]
	@Param1 = 'Hello World',
	@Param2 = 10,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
INSERT INTO
	[table] ([col1], [col2], [coln])
	VALUES (val1, val2, valn);

-- Delete Test Dataset
DELETE FROM [table]
WHERE [col1] = val1;