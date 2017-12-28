USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_CreatePlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_CreatePlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    creates a new playlist for a given user                 --
----------------------------------------------------------------
CREATE PROCEDURE [USP_CreatePlaylist] (
	@UserID			INT,
	@Title			NVARCHAR(32),
	@Description	NVARCHAR(200),
	@Result			INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			INSERT INTO
				[playlist] ([description], [title], [fk_user_id])
				VALUES (@Description, @Title, @UserID);
			
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
SELECT * FROM [user];
DECLARE @Out INT;
EXEC dbo.[USP_CreatePlaylist]
	@UserID = 3,
	@Title = 'My Playlist',
	@Description = 'This is my Rock & Roll Playlist for working out',
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
INSERT INTO
	[user] ([username], [firstname], [lastname], [password], [email])
	VALUES ('Peter8855', 'Peter', 'Müller', 'mYp@ccW#r1', 'peter.müller@gmail.com');

-- Delete Test Dataset
DELETE FROM [user]
WHERE [username] = 'Peter8855';