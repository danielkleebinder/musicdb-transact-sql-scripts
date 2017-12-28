USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_GetAllTitlesInPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_GetAllTitlesInPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    returns all titles in a given playlist.                 --
----------------------------------------------------------------
CREATE PROCEDURE [USP_GetAllTitlesInPlaylist] (
	@PlaylistID	INT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- a simple fetch for all titles in a given playlist
	BEGIN TRY;
		SELECT t.[title_id], t.[name], t.[titlenumber], t.[duration], t.[bitrate]
		FROM [playlist] AS p
		INNER JOIN [playlist_title] AS pt ON pt.fk_playlist_id = p.playlist_id
		INNER JOIN [title] AS t ON t.title_id = pt.fk_title_id
		WHERE p.playlist_id = @PlaylistID;
	END TRY BEGIN CATCH;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
EXEC dbo.[USP_GetAllTitlesInPlaylist] @PlaylistID = 1;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------