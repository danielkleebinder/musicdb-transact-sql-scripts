USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_FindPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_FindPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--	Get Titles of Playlists that match the search parameter   --
--	if parameter is empty, return all playlists               --
----------------------------------------------------------------
CREATE PROCEDURE [USP_FindPlaylist] (
	@Playlistname	NVARCHAR(32)
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;
	BEGIN TRY;
		IF (@Playlistname = '')
			SELECT [playlist_id], [description], [title], [name] as 'genre', [username] as 'creator'
			FROM [playlist] AS p, [genre] AS g, [user] as u
			WHERE p.[fk_genre_id] = g.[genre_id] AND p.[fk_user_id] = u.[user_id];
		ELSE
			SELECT [playlist_id], [description], [title], [name] as 'genre', [username] as 'creator'
			FROM [playlist] AS p, [genre] AS g, [user] as u
			WHERE [title] LIKE Concat('%', @Playlistname, '%') AND p.[fk_genre_id] = g.[genre_id] AND p.[fk_user_id] = u.[user_id];
	END TRY BEGIN CATCH;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------

-- with specified playlist title
EXEC dbo.[USP_FindPlaylist]
	@Playlistname = 'out';

-- get all playlists when title is empty
EXEC dbo.[USP_FindPlaylist]
	@Playlistname = '';

---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------
INSERT INTO [playlist] ([description], [title], [fk_genre_id], [fk_user_id]) VALUES ('Very nice grooves', 'Groovy Playlist', 2, 1);
INSERT INTO [playlist] ([description], [title], [fk_genre_id], [fk_user_id]) VALUES ('Trash', 'Bad Playlist', 3, 1);
INSERT INTO [playlist] ([description], [title], [fk_genre_id], [fk_user_id]) VALUES ('Trying something new, hopy you like it', 'Diving in the Stars', 4, 1);