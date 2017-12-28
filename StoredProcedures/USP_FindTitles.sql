USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_FindTitles', 'P') IS NOT NULL
	DROP PROCEDURE [USP_FindTitles];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    returns all titles which contain the given @TitleName   --
--    symbols.                                                --
----------------------------------------------------------------
CREATE PROCEDURE [USP_FindTitles] (
	@TitleName		NVARCHAR(32)
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- use a basic "string-like" search, no google like algorithm, but it works
	-- just fine :)
	BEGIN TRY;
		SELECT [title_id], [name], [titlenumber], [duration], [bitrate]
		FROM [title] AS t
		WHERE [name] LIKE Concat('%', @TitleName, '%');
	END TRY BEGIN CATCH;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
EXEC dbo.[USP_FindTitles] @TitleName = 'ghway';


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Hearts on Fire', 1, 540, 20000, 1);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Highway to Hell', 1, 320, 20000, 1);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Livin on a Prayer', 1, 260, 20000, 1);