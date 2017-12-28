USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_AddTitleToPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_AddTitleToPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    adds a title to a users given playlist.                 --
----------------------------------------------------------------
CREATE PROCEDURE [USP_AddTitleToPlaylist] (
	@TitleID	INT,
	@PlaylistID	INT,
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			INSERT INTO
				[playlist_title] ([fk_title_id], [fk_playlist_id])
				VALUES (@TitleID, @PlaylistID);
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
EXEC dbo.[USP_AddTitleToPlaylist]
	@TitleID = 3,
	@PlaylistID = 1,
	@Result = @Out OUTPUT;
SELECT @Out;

SELECT * FROM [playlist_title];


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
