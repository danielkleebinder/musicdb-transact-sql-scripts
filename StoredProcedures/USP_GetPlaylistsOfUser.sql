USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_GetPlaylistsOfUser', 'P') IS NOT NULL
	DROP PROCEDURE [USP_GetPlaylistsOfUser];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    Get all Playlists of a user                                               --
----------------------------------------------------------------
CREATE PROCEDURE [USP_GetPlaylistsOfUser] (
	@UserID	INT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- use transactions to rollback invalid statements
		BEGIN TRY;
			SELECT * FROM [playlist] WHERE [fk_user_id] = @UserID
		END TRY BEGIN CATCH;
			
			RETURN 1;
		END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
EXEC dbo.[USP_GetPlaylistsOfUser]
	@UserID = 1;


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