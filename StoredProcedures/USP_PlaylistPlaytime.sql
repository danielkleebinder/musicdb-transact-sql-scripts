USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_PlaytimeOfPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_PlaytimeOfPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    sums up the total playtime of a playlist by adding the  --
--    durations of all songs together.                        --
----------------------------------------------------------------
CREATE PROCEDURE [USP_PlaytimeOfPlaylist] (
	@PlaylistID	INT,
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- check if the playlist even exists
	IF (SELECT Count(*) FROM [playlist] where playlist_id = @PlaylistID) <= (0) BEGIN
		RETURN;
	END

	-- usage of select statement to sum up all the title durations in the
	-- given playlist on the sql server side
	SELECT @Result = Sum(t.duration) FROM [playlist] AS p
	INNER JOIN [playlist_title] AS pt ON pt.fk_playlist_id = p.playlist_id
	INNER JOIN [title] AS t ON t.title_id = pt.fk_title_id
	WHERE p.playlist_id = @PlaylistID;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_PlaytimeOfPlaylist]
	@PlaylistID = 4,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.
---------------------------------------------------------------------------
