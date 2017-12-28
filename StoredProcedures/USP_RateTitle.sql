USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_RateTitle', 'P') IS NOT NULL
	DROP PROCEDURE [USP_RateTitle];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    rates a single title.                                   --
----------------------------------------------------------------
CREATE PROCEDURE [USP_RateTitle] (
	@UserID		INT,
	@TitleID	INT,
	@Rating		SMALLINT,
	@Comment	NVARCHAR(200),
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- do a range check to prevent wrong data
	IF (@Rating < 1 OR @Rating > 5) BEGIN;
		THROW 51000, 'Rating must be in range of [1;5].', 1;
	END;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			INSERT INTO
				[rating] ([ratingvalue], [comment], [fk_title_id], [fk_user_id])
				VALUES (@Rating, @Comment, @TitleID, @UserID);

			-- fetch the resulting affected row count
			SELECT @Result = @@ROWCOUNT;
		END TRY BEGIN CATCH;
			-- Undo all changes when an error occurs
			ROLLBACK;
			SET @Result = 0;
			RETURN 1;
		END CATCH;
	COMMIT;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_RateTitle]
	@UserID = 1,
	@TitleID = 13,
	@Rating = 5,
	@Comment = 'Best SONG EVERRRR!!!1!11',
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.
---------------------------------------------------------------------------