USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_RatingOfTitle', 'P') IS NOT NULL
	DROP PROCEDURE [USP_RatingOfTitle];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    computes the average rating of a title.                 --
----------------------------------------------------------------
CREATE PROCEDURE [USP_RatingOfTitle] (
	@TitleID	INT,
	@Result		FLOAT = 0 OUTPUT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- check if there are any rating for the given title
	IF (SELECT Count(*) FROM [rating] where fk_title_id = @TitleID) <= (0) BEGIN;
		SET @Result = 0;
		RETURN;
	END

	-- use the average function to compute the title rating
	BEGIN TRY;
		SELECT @Result = Avg(r.ratingvalue) FROM [rating] AS r
		WHERE r.fk_title_id = @TitleID;
	END TRY BEGIN CATCH;
		SET @Result = -1;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_RatingOfTitle]
	@TitleID = 1,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
