USE [Music];
GO


----------------------------------------------------------------------
-- a view which stores the number of genres in a playlist as key    --
-- value pairs.                                                     --
----------------------------------------------------------------------
IF OBJECT_ID('VW_NumberOfGenresInPlaylist', 'V') IS NOT NULL
	DROP VIEW [VW_NumberOfGenresInPlaylist];
GO

CREATE VIEW [VW_NumberOfGenresInPlaylist]
AS
	SELECT	pt.[fk_playlist_id] AS "playlist_id",
			Count(DISTINCT t.[fk_genre_id]) As "Number of Genres"
	FROM [playlist_title] AS pt
	INNER JOIN [title] AS t ON t.[title_id] = pt.[fk_title_id]
	GROUP BY pt.[fk_playlist_id];
GO


----------------------------------------------------------------------
-- a view which stores the number of interprets per album as key    --
-- value pairs.                                                     --
----------------------------------------------------------------------
IF OBJECT_ID('VW_NumberOfInterpretsInAlbum', 'V') IS NOT NULL
	DROP VIEW [VW_NumberOfInterpretsInAlbum];
GO

CREATE VIEW [VW_NumberOfInterpretsInAlbum]
AS
	SELECT	t.[fk_album_id] AS "album_id",
			Count(DISTINCT ti.[fk_interpret_id]) As "Number of Interprets"
	FROM [title] AS t
	INNER JOIN [title_interpret] AS ti ON ti.fk_title_id = t.title_id
	GROUP BY t.[fk_album_id];
GO
