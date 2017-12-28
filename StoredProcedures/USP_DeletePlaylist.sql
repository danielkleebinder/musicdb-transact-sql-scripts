USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_DeletePlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_DeletePlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    deletes the playlist with the given id                  --
----------------------------------------------------------------
CREATE PROCEDURE [USP_DeletePlaylist] (
	@PlaylistID	INT,
	@Result		INT OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;
	
	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			DELETE FROM [playlist] WHERE [playlist_id] = @PlaylistID;
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
SELECT * FROM [playlist];
DECLARE @Out INT;
EXEC dbo.[USP_DeletePlaylist]
	@PlaylistID = 3,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
