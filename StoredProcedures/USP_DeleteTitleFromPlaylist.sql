USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_DeleteTitleFromPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_DeleteTitleFromPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    <PURPOSE>                                               --
----------------------------------------------------------------
CREATE PROCEDURE [USP_DeleteTitleFromPlaylist] (
	@PlaylistID	INT,
	@TitleID	INT,
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			DELETE FROM [playlist_title]
			WHERE [fk_playlist_id] = @PlaylistID AND [fk_title_id] = @TitleID;
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
EXEC dbo.[USP_DeleteTitleFromPlaylist]
	@PlaylistID = 1,
	@TitleID = 3,
	@Result = @Out OUTPUT;
SELECT @Out;

SELECT * FROM playlist_title;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
