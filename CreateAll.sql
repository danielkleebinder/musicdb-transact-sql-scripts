-- Create the music database using
-- standard Transact-SQL syntax.

IF (DB_ID(N'Music') IS NULL)
	CREATE DATABASE [Music];


USE [Music];
GO


---------------------------------
-- delete tables if they exist --
---------------------------------

IF OBJECT_ID('playlist_title', 'U') IS NOT NULL 
  DROP TABLE [playlist_title]; 
GO

IF OBJECT_ID('playlist', 'U') IS NOT NULL 
  DROP TABLE [playlist]; 
GO

IF OBJECT_ID('rating', 'U') IS NOT NULL 
  DROP TABLE [rating]; 
GO

IF OBJECT_ID('title_interpret', 'U') IS NOT NULL 
  DROP TABLE [title_interpret]; 
GO

IF OBJECT_ID('title', 'U') IS NOT NULL 
  DROP TABLE [title]; 
GO

IF OBJECT_ID('interpret', 'U') IS NOT NULL 
  DROP TABLE [interpret]; 
GO

IF OBJECT_ID('album', 'U') IS NOT NULL 
  DROP TABLE [album]; 
GO

IF OBJECT_ID('genre', 'U') IS NOT NULL 
  DROP TABLE [genre]; 
GO

IF OBJECT_ID('label', 'U') IS NOT NULL 
  DROP TABLE [label]; 
GO

IF OBJECT_ID('user', 'U') IS NOT NULL 
  DROP TABLE [user]; 
GO



-------------------
-- create tables --
-------------------

-- user --
CREATE TABLE [user] (
	[user_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[username]	NVARCHAR(32)	NOT NULL,
	[firstname]	NVARCHAR(32)	NOT NULL,
	[lastname]	NVARCHAR(32)	NOT NULL,
	[password]	NVARCHAR(32)	NOT NULL,
	[email]		NVARCHAR(32)	NOT NULL
);
GO


-- label --
CREATE TABLE [label] (
	[label_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]		NVARCHAR(32)	NOT NULL,
	[location]	NVARCHAR(32)	NOT NULL,
	[website]	NVARCHAR(32)	NULL
);
GO


-- genre --
CREATE TABLE [genre] (
	[genre_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]		NVARCHAR(32)	NOT NULL
);
GO


-- album --
CREATE TABLE [album] (
	[album_id]		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[releaseyear]	SMALLINT		NOT NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_label_id]	INT				NULL FOREIGN KEY REFERENCES label (label_id)
);
GO


-- interpret --
CREATE TABLE [interpret] (
	[interpret_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[origin]		NVARCHAR(32)	NOT NULL,
	[website]		NVARCHAR(32)	NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id)
);
GO


-- title --
CREATE TABLE [title] (
	[title_id]		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[titlenumber]	SMALLINT		NULL,
	[duration]		SMALLINT		NOT	NULL,
	[bitrate]		INT				NULL,
	[fk_genre_id]	INT				NOT NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_album_id]	INT				NULL FOREIGN KEY REFERENCES album (album_id)
);
GO


-- title_interpret --
CREATE TABLE [title_interpret] (
	[fk_interpret_id]	INT			NOT NULL FOREIGN KEY REFERENCES interpret (interpret_id),
	[fk_title_id]		INT			NOT NULL FOREIGN KEY REFERENCES title (title_id),
	PRIMARY KEY ([fk_interpret_id], [fk_title_id])
);
GO


-- rating --
CREATE TABLE [rating] (
	[ratingvalue]	SMALLINT		NOT NULL,
	[comment]		NVARCHAR(200)	NULL,
	[fk_title_id]	INT				NOT NULL FOREIGN KEY REFERENCES title (title_id),
	[fk_user_id]	INT				NOT NULL FOREIGN KEY REFERENCES [user] ([user_id]),
	PRIMARY KEY ([fk_title_id], [fk_user_id])
);
GO


-- playlist --
CREATE TABLE [playlist] (
	[playlist_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[description]	NVARCHAR(200)	NULL,
	[title]			NVARCHAR(32)	NOT NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_user_id]	INT				NOT NULL FOREIGN KEY REFERENCES [user] ([user_id])
);
GO


-- playlist_title --
CREATE TABLE [playlist_title] (
	[fk_playlist_id]	INT			NOT NULL FOREIGN KEY REFERENCES playlist (playlist_id),
	[fk_title_id]		INT			NOT NULL FOREIGN KEY REFERENCES title (title_id),
	PRIMARY KEY ([fk_playlist_id], [fk_title_id])
);
GO



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




USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_RatingOfTitle', 'P') IS NOT NULL
	DROP PROCEDURE [USP_RatingOfTitle];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    computes the average rating of a title.                 --
----------------------------------------------------------------
CREATE PROCEDURE [USP_RatingOfTitle] (
	@TitleID	INT,
	@Result		FLOAT = 0 OUTPUT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- check if there are any rating for the given title
	IF (SELECT Count(*) FROM [rating] where fk_title_id = @TitleID) <= (0) BEGIN;
		SET @Result = 0;
		RETURN;
	END

	-- use the average function to compute the title rating
	BEGIN TRY;
		SELECT @Result = Avg(r.ratingvalue) FROM [rating] AS r
		WHERE r.fk_title_id = @TitleID;
	END TRY BEGIN CATCH;
		SET @Result = -1;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_RatingOfTitle]
	@TitleID = 1,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------



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
--    Get all Playlists of a user                             --
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




USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_RateTitle', 'P') IS NOT NULL
	DROP PROCEDURE [USP_RateTitle];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    rates a single title.                                   --
----------------------------------------------------------------
CREATE PROCEDURE [USP_RateTitle] (
	@UserID		INT,
	@TitleID	INT,
	@Rating		SMALLINT,
	@Comment	NVARCHAR(200),
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- do a range check to prevent wrong data
	IF (@Rating < 1 OR @Rating > 5) BEGIN;
		THROW 51000, 'Rating must be in range of [1;5].', 1;
	END;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			INSERT INTO
				[rating] ([ratingvalue], [comment], [fk_title_id], [fk_user_id])
				VALUES (@Rating, @Comment, @TitleID, @UserID);

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
DECLARE @Out INT;
EXEC dbo.[USP_RateTitle]
	@UserID = 1,
	@TitleID = 13,
	@Rating = 5,
	@Comment = 'Best SONG EVERRRR!!!1!11',
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------


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
	IF (SELECT Count(*) FROM [playlist] where playlist_id = @PlaylistID) <= (0) BEGIN;
		SET @Result = 0;
		RETURN;
	END
	
	-- usage of select statement to sum up all the title durations in the
	-- given playlist on the sql server side
	BEGIN TRY;
		SELECT @Result = Sum(t.duration) FROM [playlist] AS p
		INNER JOIN [playlist_title] AS pt ON pt.fk_playlist_id = p.playlist_id
		INNER JOIN [title] AS t ON t.title_id = pt.fk_title_id
		WHERE p.playlist_id = @PlaylistID;
	END TRY BEGIN CATCH;
		SET @Result = -1;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
DECLARE @Out INT;
EXEC dbo.[USP_PlaytimeOfPlaylist]
	@PlaylistID = 1,
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------




USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_RateTitle', 'P') IS NOT NULL
	DROP PROCEDURE [USP_RateTitle];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    rates a single title.                                   --
----------------------------------------------------------------
CREATE PROCEDURE [USP_RateTitle] (
	@UserID		INT,
	@TitleID	INT,
	@Rating		SMALLINT,
	@Comment	NVARCHAR(200),
	@Result		INT = 0 OUTPUT
)
AS BEGIN
	-- count number of affected rows
	SET NOCOUNT OFF;

	-- do a range check to prevent wrong data
	IF (@Rating < 1 OR @Rating > 5) BEGIN;
		THROW 51000, 'Rating must be in range of [1;5].', 1;
	END;

	-- use transactions to rollback invalid statements
	BEGIN TRANSACTION;
		BEGIN TRY;
			INSERT INTO
				[rating] ([ratingvalue], [comment], [fk_title_id], [fk_user_id])
				VALUES (@Rating, @Comment, @TitleID, @UserID);

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
DECLARE @Out INT;
EXEC dbo.[USP_RateTitle]
	@UserID = 1,
	@TitleID = 13,
	@Rating = 5,
	@Comment = 'Best SONG EVERRRR!!!1!11',
	@Result = @Out OUTPUT;
SELECT @Out;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------



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




USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_Login', 'P') IS NOT NULL
	DROP PROCEDURE [USP_Login];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    checks if a user with the given username and password   --
--    do exist.                                               --
----------------------------------------------------------------
CREATE PROCEDURE [USP_Login] (
	@Username	NVARCHAR(32),
	@Password	NVARCHAR(32)
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT OFF;

	-- do a simple select to return the number of affected rows for a
	-- specific user
	SELECT [user_id], [username], [firstname], [lastname], [password], [email] FROM [user] AS usr
		WHERE usr.[username] = @Username
		AND	  usr.[password] = @Password;
END
GO




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


USE [Music];
GO


--------------------------------------------------------------------------------------
-- using the object id to check if the stored procedure with the given name already --
-- exists. If it exists, it will be dropped from the context.                       --
--------------------------------------------------------------------------------------
IF OBJECT_ID('USP_GetAllGenresOfPlaylist', 'P') IS NOT NULL
	DROP PROCEDURE [USP_GetAllGenresOfPlaylist];
GO


----------------------------------------------------------------
-- creation of a stored procedure with the following purpose: --
--    returns all genres of a playlist.                       --
----------------------------------------------------------------
CREATE PROCEDURE [USP_GetAllGenresOfPlaylist] (
	@PlaylistID	INT
)
AS BEGIN
	-- no console outputs are needed here
	SET NOCOUNT ON;

	-- use try-catch to prevent exceptions
	BEGIN TRY;
		SELECT g.genre_id, g.name FROM [playlist] AS p
		INNER JOIN [playlist_title] AS pt ON pt.fk_playlist_id = p.playlist_id
		INNER JOIN [title] AS t ON t.title_id = pt.fk_title_id
		INNER JOIN [genre] AS g ON g.genre_id = t.fk_genre_id
		WHERE p.playlist_id = @PlaylistID;
	END TRY BEGIN CATCH;
		RETURN 1;
	END CATCH;
END
GO

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
EXEC dbo.[USP_GetAllGenresOfPlaylist] @PlaylistID = 1;


---------------------------------------------------------------------------
-- add a test dataset to be sure the results given by the stored         --
-- procedure are correct.                                                --
---------------------------------------------------------------------------


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
		SELECT TOP 50 [title_id], [name], [titlenumber], [duration], [bitrate]
		FROM [title] AS t
		WHERE Upper([name]) LIKE Upper(Concat('%', @TitleName, '%'));
	END TRY BEGIN CATCH;
		RETURN 1;
	END CATCH;
END
GO

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
			SELECT *
			FROM [playlist];
		ELSE
			SELECT *
			FROM [playlist]
			WHERE [title] LIKE Concat('%', @Playlistname, '%')
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
	@Result		INT = 0 OUTPUT
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





USE [Music];
GO

GO  
SET NOCOUNT ON;  

---------------------------------
-- delete tables if they exist --
---------------------------------

IF OBJECT_ID('playlist_title', 'U') IS NOT NULL 
  DROP TABLE [playlist_title]; 
GO

IF OBJECT_ID('playlist', 'U') IS NOT NULL 
  DROP TABLE [playlist]; 
GO

IF OBJECT_ID('rating', 'U') IS NOT NULL 
  DROP TABLE [rating]; 
GO

IF OBJECT_ID('title_interpret', 'U') IS NOT NULL 
  DROP TABLE [title_interpret]; 
GO

IF OBJECT_ID('title', 'U') IS NOT NULL 
  DROP TABLE [title]; 
GO

IF OBJECT_ID('interpret', 'U') IS NOT NULL 
  DROP TABLE [interpret]; 
GO

IF OBJECT_ID('album', 'U') IS NOT NULL 
  DROP TABLE [album]; 
GO

IF OBJECT_ID('genre', 'U') IS NOT NULL 
  DROP TABLE [genre]; 
GO

IF OBJECT_ID('label', 'U') IS NOT NULL 
  DROP TABLE [label]; 
GO

IF OBJECT_ID('user', 'U') IS NOT NULL 
  DROP TABLE [user]; 
GO



-------------------
-- create tables --
-------------------

-- user --
CREATE TABLE [user] (
	[user_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[username]	NVARCHAR(32)	NOT NULL,
	[firstname]	NVARCHAR(32)	NOT NULL,
	[lastname]	NVARCHAR(32)	NOT NULL,
	[password]	NVARCHAR(32)	NOT NULL,
	[email]		NVARCHAR(32)	NOT NULL
);
GO


-- label --
CREATE TABLE [label] (
	[label_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]		NVARCHAR(32)	NOT NULL,
	[location]	NVARCHAR(32)	NOT NULL,
	[website]	NVARCHAR(32)	NULL
);
GO


-- genre --
CREATE TABLE [genre] (
	[genre_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]		NVARCHAR(32)	NOT NULL
);
GO


-- album --
CREATE TABLE [album] (
	[album_id]		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[releaseyear]	SMALLINT		NOT NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_label_id]	INT				NULL FOREIGN KEY REFERENCES label (label_id)
);
GO


-- interpret --
CREATE TABLE [interpret] (
	[interpret_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[origin]		NVARCHAR(32)	NOT NULL,
	[website]		NVARCHAR(32)	NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id)
);
GO


-- title --
CREATE TABLE [title] (
	[title_id]		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[name]			NVARCHAR(32)	NOT NULL,
	[titlenumber]	SMALLINT		NULL,
	[duration]		SMALLINT		NOT	NULL,
	[bitrate]		INT				NULL,
	[fk_genre_id]	INT				NOT NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_album_id]	INT				NULL FOREIGN KEY REFERENCES album (album_id)
);
GO


-- title_interpret --
CREATE TABLE [title_interpret] (
	[fk_interpret_id]	INT			NOT NULL FOREIGN KEY REFERENCES interpret (interpret_id),
	[fk_title_id]		INT			NOT NULL FOREIGN KEY REFERENCES title (title_id),
	PRIMARY KEY ([fk_interpret_id], [fk_title_id])
);
GO


-- rating --
CREATE TABLE [rating] (
	[ratingvalue]	SMALLINT		NOT NULL,
	[comment]		NVARCHAR(200)	NULL,
	[fk_title_id]	INT				NOT NULL FOREIGN KEY REFERENCES title (title_id),
	[fk_user_id]	INT				NOT NULL FOREIGN KEY REFERENCES [user] ([user_id]),
	PRIMARY KEY ([fk_title_id], [fk_user_id])
);
GO


-- playlist --
CREATE TABLE [playlist] (
	[playlist_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[description]	NVARCHAR(200)	NULL,
	[title]			NVARCHAR(32)	NOT NULL,
	[fk_genre_id]	INT				NULL FOREIGN KEY REFERENCES genre (genre_id),
	[fk_user_id]	INT				NOT NULL FOREIGN KEY REFERENCES [user] ([user_id])
);
GO


-- playlist_title --
CREATE TABLE [playlist_title] (
	[fk_playlist_id]	INT			NOT NULL FOREIGN KEY REFERENCES playlist (playlist_id),
	[fk_title_id]		INT			NOT NULL FOREIGN KEY REFERENCES title (title_id),
	PRIMARY KEY ([fk_playlist_id], [fk_title_id])
);
GO


-------------------
-- START TEST DATA GENERATION --
-------------------



IF OBJECT_ID('usernameHelper', 'U') IS NOT NULL 
  DROP TABLE [usernameHelper]; 
GO


IF OBJECT_ID('firstnameHelper', 'U') IS NOT NULL 
  DROP TABLE [firstnameHelper]; 
GO


IF OBJECT_ID('surnameHelper', 'U') IS NOT NULL 
  DROP TABLE [surnameHelper]; 
GO


IF OBJECT_ID('titleHelper', 'U') IS NOT NULL 
  DROP TABLE [titleHelper]; 
GO

-- Fill genre table

INSERT INTO [genre] ([name]) VALUES ('Rock & Roll');
INSERT INTO [genre] ([name]) VALUES ('Pop');
INSERT INTO [genre] ([name]) VALUES ('Classic');
INSERT INTO [genre] ([name]) VALUES ('Jazz');
INSERT INTO [genre] ([name]) VALUES ('Blues');
INSERT INTO [genre] ([name]) VALUES ('Country');
INSERT INTO [genre] ([name]) VALUES ('Electronic');
INSERT INTO [genre] ([name]) VALUES ('Folk');
INSERT INTO [genre] ([name]) VALUES ('Hip-Hop');
INSERT INTO [genre] ([name]) VALUES ('Reggae');
GO

-- Fill label table
INSERT INTO [label] ([name], [location], [website]) VALUES ('4AD', 'United Kingdom', 'www.4AD.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('3 Beat Records', 'United Kingdom', 'www.3BeatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Andmoresound', 'United Kingdom', 'www.Andmoresound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Audio Antihero', 'United Kingdom', 'www.AudioAntihero.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Audiobulb Records', 'United Kingdom', 'www.AudiobulbRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('AudioPorn Records', 'United Kingdom', 'www.AudioPornRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('ATP Recordings', 'United Kingdom', 'www.ATPRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Barely Breaking Even', 'United Kingdom', 'www.BarelyBreakingEven.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Beggars Banquet Records', 'United Kingdom', 'www.BeggarsBanquetRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Bella Union', 'United Kingdom', 'www.BellaUnion.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Best Before Records', 'United Kingdom', 'www.BestBeforeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Black Crow Records', 'United Kingdom', 'www.BlackCrowRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blast First', 'United Kingdom', 'www.BlastFirst.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Bloody Chamber Music', 'United Kingdom', 'www.BloodyChamberMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blow Up Records', 'United Kingdom', 'www.BlowUpRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Dog Records', 'United Kingdom', 'www.BlueDogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Room Released', 'United Kingdom', 'www.BlueRoomReleased.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Blue Horizon', 'United Kingdom', 'www.BlueHorizon.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Boy Better Know', 'United Kingdom', 'www.BoyBetterKnow.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Brownswood Recordings', 'United Kingdom', 'www.BrownswoodRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Butterz', 'United Kingdom', 'www.Butterz.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Candid Records', 'United Kingdom', 'www.CandidRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Celtic Music', 'United Kingdom', 'www.CelticMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Chemikal Underground', 'United Kingdom', 'www.ChemikalUnderground.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Cherry Red', 'United Kingdom', 'www.CherryRed.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Circle Records', 'United Kingdom', 'www.CircleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Citinite', 'United Kingdom', 'www.Citinite.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Clay Records', 'United Kingdom', 'www.ClayRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Cooking Vinyl', 'United Kingdom', 'www.CookingVinyl.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Convivium Records', 'United Kingdom', 'www.ConviviumRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Crass Records', 'United Kingdom', 'www.CrassRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Creation Records', 'United Kingdom', 'www.CreationRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Creeping Bent', 'United Kingdom', 'www.CreepingBent.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Criminal Records', 'United Kingdom', 'www.CriminalRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Damaged Goods Records', 'United Kingdom', 'www.DamagedGoodsRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Damnably', 'United Kingdom', 'www.Damnably.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dance to the Radio', 'United Kingdom', 'www.DancetotheRadio.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dancing Turtle Records', 'United Kingdom', 'www.DancingTurtleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Deltasonic', 'United Kingdom', 'www.Deltasonic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dented Records', 'United Kingdom', 'www.DentedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dick Bros Record Company', 'United Kingdom', 'www.DickBrosRecordCompany.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Different Recordings', 'United Kingdom', 'www.DifferentRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Document Records', 'United Kingdom', 'www.DocumentRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Domino Recording Company', 'United Kingdom', 'www.DominoRecordingCompany.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Dreamboat Records', 'United Kingdom', 'www.DreamboatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Drowned in Sound', 'United Kingdom', 'www.DrownedinSound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Él', 'United Kingdom', 'www.Él.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Electric Honey', 'United Kingdom', 'www.ElectricHoney.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Enhanced Music', 'United Kingdom', 'www.EnhancedMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Erased Tapes Records', 'United Kingdom', 'www.ErasedTapesRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Factory Records', 'United Kingdom', 'www.FactoryRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Falling A Records', 'United Kingdom', 'www.FallingARecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fällt', 'United Kingdom', 'www.Fällt.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fanfare Records', 'United Kingdom', 'www.FanfareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fantastic Plastic Records', 'United Kingdom', 'www.FantasticPlasticRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fast Product', 'United Kingdom', 'www.FastProduct.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fat Cat Records', 'United Kingdom', 'www.FatCatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fellside Records', 'United Kingdom', 'www.FellsideRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Field Records', 'United Kingdom', 'www.FieldRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fierce Panda Records', 'United Kingdom', 'www.FiercePandaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fire Records', 'United Kingdom', 'www.FireRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Flicknife Records', 'United Kingdom', 'www.FlicknifeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('FM Records', 'United Kingdom', 'www.FMRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Fortuna Pop!', 'United Kingdom', 'www.FortunaPop.uk!');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Full Time Hobby', 'United Kingdom', 'www.FullTimeHobby.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gargleblast Records', 'United Kingdom', 'www.GargleblastRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Glass Records', 'United Kingdom', 'www.GlassRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Grand Central Records', 'United Kingdom', 'www.GrandCentralRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gut Records', 'United Kingdom', 'www.GutRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Gwarn Music', 'United Kingdom', 'www.GwarnMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hassle Records', 'United Kingdom', 'www.HassleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heaven Records', 'United Kingdom', 'www.HeavenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heavenly Recordings', 'United Kingdom', 'www.HeavenlyRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Heist Or Hit Records', 'United Kingdom', 'www.HeistOrHitRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Holy Roar Records', 'United Kingdom', 'www.HolyRoarRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hospital Records', 'United Kingdom', 'www.HospitalRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hyperdub', 'United Kingdom', 'www.Hyperdub.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hyperion Records', 'United Kingdom', 'www.HyperionRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Hope Recordings', 'United Kingdom', 'www.HopeRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ill Flava Records', 'United Kingdom', 'www.IllFlavaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Imaginary Records', 'United Kingdom', 'www.ImaginaryRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Incus Records', 'United Kingdom', 'www.IncusRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Independiente Records', 'United Kingdom', 'www.IndependienteRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Invisible Hands Music', 'United Kingdom', 'www.InvisibleHandsMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Irregular Records', 'United Kingdom', 'www.IrregularRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Jeepster Records', 'United Kingdom', 'www.JeepsterRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Jungle Records', 'United Kingdom', 'www.JungleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Junior Aspirin Records', 'United Kingdom', 'www.JuniorAspirinRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Kitchenware Records', 'United Kingdom', 'www.KitchenwareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Kscope', 'United Kingdom', 'www.Kscope.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('LAB Records', 'United Kingdom', 'www.LABRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Launchpad Records', 'United Kingdom', 'www.LaunchpadRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Leader Records', 'United Kingdom', 'www.LeaderRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Leaf Label', 'United Kingdom', 'www.TheLeafLabel.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Lex Records', 'United Kingdom', 'www.LexRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Lojinx', 'United Kingdom', 'www.Lojinx.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Loose Music', 'United Kingdom', 'www.LooseMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Low Life Records', 'United Kingdom', 'www.LowLifeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Market Square Records', 'United Kingdom', 'www.MarketSquareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Marrakesh Records', 'United Kingdom', 'www.MarrakeshRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Memphis Industries', 'United Kingdom', 'www.MemphisIndustries.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Moshi Moshi', 'United Kingdom', 'www.MoshiMoshi.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Motile', 'United Kingdom', 'www.Motile.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mr Bongo Records', 'United Kingdom', 'www.MrBongoRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mukatsuku Records', 'United Kingdom', 'www.MukatsukuRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Mute Records', 'United Kingdom', 'www.MuteRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('My Kung Fu', 'United Kingdom', 'www.MyKungFu.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Naim Edge', 'United Kingdom', 'www.NaimEdge.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Native Records', 'United Kingdom', 'www.NativeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Neat Records', 'United Kingdom', 'www.NeatRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Never Fade Records', 'United Kingdom', 'www.NeverFadeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ninja Tune', 'United Kingdom', 'www.NinjaTune.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('No Masters', 'United Kingdom', 'www.NoMasters.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Odd Box Records', 'United Kingdom', 'www.OddBoxRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Or Records', 'United Kingdom', 'www.OrRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Outta Sight Records', 'United Kingdom', 'www.OuttaSightRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ozit Records', 'United Kingdom', 'www.OzitRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Pantone Music', 'United Kingdom', 'www.PantoneMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Peacefrog Records', 'United Kingdom', 'www.PeacefrogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Peaceville Records', 'United Kingdom', 'www.PeacevilleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('People In The Sky', 'United Kingdom', 'www.PeopleInTheSky.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Perfecto Records', 'United Kingdom', 'www.PerfectoRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Phantasy Sound', 'United Kingdom', 'www.PhantasySound.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Pickled Egg Records', 'United Kingdom', 'www.PickledEggRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Placid Casual', 'United Kingdom', 'www.PlacidCasual.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Play It Again Sam', 'United Kingdom', 'www.PlayItAgainSam.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Postcard Records', 'United Kingdom', 'www.PostcardRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Probe Plus', 'United Kingdom', 'www.ProbePlus.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Radiant Future Records', 'United Kingdom', 'www.RadiantFutureRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('RAM Records', 'United Kingdom', 'www.RAMRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Real World Records', 'United Kingdom', 'www.RealWorldRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Recommended Records', 'United Kingdom', 'www.RecommendedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Red Girl Records', 'United Kingdom', 'www.RedGirlRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rise Above Records', 'United Kingdom', 'www.RiseAboveRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rock Action Records', 'United Kingdom', 'www.RockActionRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rocket Girl', 'United Kingdom', 'www.RocketGirl.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rockville Records', 'United Kingdom', 'www.RockvilleRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Ron Johnson Records', 'United Kingdom', 'www.RonJohnsonRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Rough Trade Records', 'United Kingdom', 'www.RoughTradeRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sarah Records', 'United Kingdom', 'www.SarahRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sain', 'United Kingdom', 'www.Sain.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('See Monkey Do Monkey', 'United Kingdom', 'www.SeeMonkeyDoMonkey.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Setanta Records', 'United Kingdom', 'www.SetantaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Shinkansen Records', 'United Kingdom', 'www.ShinkansenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Silvertone Records', 'United Kingdom', 'www.SilvertoneRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('SimG Records', 'United Kingdom', 'www.SimGRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Situation Two', 'United Kingdom', 'www.SituationTwo.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Skam Records', 'United Kingdom', 'www.SkamRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Skint Records', 'United Kingdom', 'www.SkintRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sleep It Off Records', 'United Kingdom', 'www.SleepItOffRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Smalltown America', 'United Kingdom', 'www.SmalltownAmerica.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Small Wonder Records', 'United Kingdom', 'www.SmallWonderRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Snapper Music', 'United Kingdom', 'www.SnapperMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Some Bizzare Records', 'United Kingdom', 'www.SomeBizzareRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Sonic Vista Music', 'United Kingdom', 'www.SonicVistaMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Southern Fried Records', 'United Kingdom', 'www.SouthernFriedRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Southern Records', 'United Kingdom', 'www.SouthernRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Standby Records', 'United Kingdom', 'www.StandbyRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Steel Tiger Records', 'United Kingdom', 'www.SteelTigerRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Stiff Records', 'United Kingdom', 'www.StiffRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Street Soul Productions', 'United Kingdom', 'www.StreetSoulProductions.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Super Records', 'United Kingdom', 'www.SuperRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Stolen Recordings', 'United Kingdom', 'www.StolenRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tempa Records', 'United Kingdom', 'www.TempaRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Third Mind Records', 'United Kingdom', 'www.ThirdMindRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tigertrap Records', 'United Kingdom', 'www.TigertrapRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tin Angel Records', 'United Kingdom', 'www.TinAngelRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tiny Dog Records', 'United Kingdom', 'www.TinyDogRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('TNSrecords', 'United Kingdom', 'www.TNSrecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Too Pure', 'United Kingdom', 'www.TooPure.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Topic Records', 'United Kingdom', 'www.TopicRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Touch Music', 'United Kingdom', 'www.TouchMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transatlantic Records', 'United Kingdom', 'www.TransatlanticRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transcend Music', 'United Kingdom', 'www.TranscendMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Transgressive Records', 'United Kingdom', 'www.TransgressiveRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trash Aesthetics', 'United Kingdom', 'www.TrashAesthetics.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trepan Records', 'United Kingdom', 'www.TrepanRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trend Records', 'United Kingdom', 'www.TrendRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tru Thoughts', 'United Kingdom', 'www.TruThoughts.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Truck Records', 'United Kingdom', 'www.TruckRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Trunk Records', 'United Kingdom', 'www.TrunkRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Tumi Music', 'United Kingdom', 'www.TumiMusic.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Valentine Records', 'United Kingdom', 'www.ValentineRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Village Thing', 'United Kingdom', 'www.TheVillageThing.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('The Viper Label', 'United Kingdom', 'www.TheViperLabel.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('VIP Records', 'United Kingdom', 'www.VIPRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Visible Noise', 'United Kingdom', 'www.VisibleNoise.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Warp Records', 'United Kingdom', 'www.WarpRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Whirlwind Recordings', 'United Kingdom', 'www.WhirlwindRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wichita Recordings', 'United Kingdom', 'www.WichitaRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Willkommen Records', 'United Kingdom', 'www.WillkommenRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wiiija', 'United Kingdom', 'www.Wiiija.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Wrath Records', 'United Kingdom', 'www.WrathRecords.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('XL Recordings', 'United Kingdom', 'www.XLRecordings.uk');
INSERT INTO [label] ([name], [location], [website]) VALUES ('Xtra Mile Recordings', 'United Kingdom', 'www.XtraMileRecordings.uk');
GO

--Prepare additional join tables for User tabel insert.
CREATE TABLE [usernameHelper] (
	[usernameHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[username]			NVARCHAR(32)	NOT NULL
);

CREATE TABLE [firstnameHelper] (
	[firstnameHelper_id]	INT			NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[firstname]			NVARCHAR(32)	NOT NULL
);

CREATE TABLE [surnameHelper] (
	[surnameHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[surname]			NVARCHAR(32)	NOT NULL
);

CREATE TABLE [titleHelper1] (
	[titleHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[title]				NVARCHAR(32)	NOT NULL
);
GO

CREATE TABLE [titleHelper2] (
	[titleHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[title]				NVARCHAR(32)	NOT NULL
);
GO

CREATE TABLE [titleHelper3] (
	[titleHelper_id]	INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[title]				NVARCHAR(32)	NOT NULL
);
GO

--about 100 firstnames

INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Miguel');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Steven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mirac');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Semih');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sinan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Etienne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ibrahim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mario');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Timon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Xaver');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Armin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Efe');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Janosch');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kerem');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mio');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Wilhelm');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Albert');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Erwin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Hans');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Anthony');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Cem');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emre');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Eymen');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Leonidas');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Aras');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ensar');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kenan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kuzey');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lutz');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Selim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Tamme');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Valentino');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Danny');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emanuel');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Giuliano');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Hassan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kerim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Umut');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Amin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Arda');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Danilo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Eren');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mattes');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Vince');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Arvid');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Darius');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Dustin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jake');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jarne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marten');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('James');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jean');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Lucien');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rayan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Elian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Emirhan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Furkan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jonne');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Kalle');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Karim');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Milian');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Timur');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Damon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Enrico');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marek');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Quentin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Alwin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Angelo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jesse');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Otto');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Samir');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Yassin');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Bilal');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Caspar');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jannek');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jarno');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Maddox');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Mahir');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Marlo');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rico');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Tjark');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Elija');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Iven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Joscha');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Nikolai');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Rocco');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sven');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Berkay');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Dion');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Gregor');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Jano');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Koray');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Ramon');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Sandro');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Taylan');
INSERT INTO [firstnameHelper] ([firstname]) VALUES ('Davin');
GO

--about 100 surnames
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADOUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BADUEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEHR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAELEMANS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERSCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAERTELS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESCHKE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAESECKE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAETZEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEYENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAEZEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAG');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGAGE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGAN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGARY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGEIN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAGGI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAHOLTZER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAHRES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIKRICH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILEY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLIEU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLIEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAILLY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAIRISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISIR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISSELING');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAISSON');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAJO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAK');
INSERT INTO [surnameHelper] ([surname]) VALUES ('BAKER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAAS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABALZAR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABINET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABOLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CABY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACHEBACH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACHELIÈVRE');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CACITTI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADAMURO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADENBACH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CADOT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAEL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAELS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAESAR');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAGNEAUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHAY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHMBERS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAHS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLARD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLAUD');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLETEAU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLIAU');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLIET');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLOT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILLOUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAILTEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAL');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALBAUM');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALBERSCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALÉ');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALIGO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALIN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALISCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLÉ');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLENS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLIES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLIGARO');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALLOCH');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMEN');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMENT');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMES');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALMUS');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALTEUX');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CALVISI');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAM');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMBIER');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMBY');
INSERT INTO [surnameHelper] ([surname]) VALUES ('CAMERIERI');
GO

--about 100 usernames
INSERT INTO [usernameHelper] ([username]) VALUES ('shieldbreak');
INSERT INTO [usernameHelper] ([username]) VALUES ('tailoredglozing');
INSERT INTO [usernameHelper] ([username]) VALUES ('castorbitwise');
INSERT INTO [usernameHelper] ([username]) VALUES ('millervariant');
INSERT INTO [usernameHelper] ([username]) VALUES ('guardsmanchortle');
INSERT INTO [usernameHelper] ([username]) VALUES ('sybaselimey');
INSERT INTO [usernameHelper] ([username]) VALUES ('visanumnah');
INSERT INTO [usernameHelper] ([username]) VALUES ('seafowlallege');
INSERT INTO [usernameHelper] ([username]) VALUES ('bellatrixceramic');
INSERT INTO [usernameHelper] ([username]) VALUES ('sharesorrel');
INSERT INTO [usernameHelper] ([username]) VALUES ('passionateloophole');
INSERT INTO [usernameHelper] ([username]) VALUES ('neuronrangale');
INSERT INTO [usernameHelper] ([username]) VALUES ('fullcrib');
INSERT INTO [usernameHelper] ([username]) VALUES ('ecologygive');
INSERT INTO [usernameHelper] ([username]) VALUES ('bagscurator');
INSERT INTO [usernameHelper] ([username]) VALUES ('yencrimp');
INSERT INTO [usernameHelper] ([username]) VALUES ('stadiumneedless');
INSERT INTO [usernameHelper] ([username]) VALUES ('siliconconnect');
INSERT INTO [usernameHelper] ([username]) VALUES ('stickerpug');
INSERT INTO [usernameHelper] ([username]) VALUES ('sitesearchbending');
INSERT INTO [usernameHelper] ([username]) VALUES ('scratchsavi');
INSERT INTO [usernameHelper] ([username]) VALUES ('preferredwrench');
INSERT INTO [usernameHelper] ([username]) VALUES ('codatriton');
INSERT INTO [usernameHelper] ([username]) VALUES ('glaziermonumental');
INSERT INTO [usernameHelper] ([username]) VALUES ('valvehole');
INSERT INTO [usernameHelper] ([username]) VALUES ('foulhydroxide');
INSERT INTO [usernameHelper] ([username]) VALUES ('diaphragmvile');
INSERT INTO [usernameHelper] ([username]) VALUES ('rhinitisphoto');
INSERT INTO [usernameHelper] ([username]) VALUES ('cosineposset');
INSERT INTO [usernameHelper] ([username]) VALUES ('mobdull');
INSERT INTO [usernameHelper] ([username]) VALUES ('invincibleshrewdness');
INSERT INTO [usernameHelper] ([username]) VALUES ('forwardsubway');
INSERT INTO [usernameHelper] ([username]) VALUES ('dispenserbluepeter');
INSERT INTO [usernameHelper] ([username]) VALUES ('nibblestrut');
INSERT INTO [usernameHelper] ([username]) VALUES ('compressionhooves');
INSERT INTO [usernameHelper] ([username]) VALUES ('oncologycuckoo');
INSERT INTO [usernameHelper] ([username]) VALUES ('bragladder');
INSERT INTO [usernameHelper] ([username]) VALUES ('hangerrare');
INSERT INTO [usernameHelper] ([username]) VALUES ('pourheater');
INSERT INTO [usernameHelper] ([username]) VALUES ('birdsbundevara');
INSERT INTO [usernameHelper] ([username]) VALUES ('einsteinwindows');
INSERT INTO [usernameHelper] ([username]) VALUES ('seriesrevelation');
INSERT INTO [usernameHelper] ([username]) VALUES ('compressedprogram');
INSERT INTO [usernameHelper] ([username]) VALUES ('cyclasescaup');
INSERT INTO [usernameHelper] ([username]) VALUES ('endconfused');
INSERT INTO [usernameHelper] ([username]) VALUES ('shoessite');
INSERT INTO [usernameHelper] ([username]) VALUES ('hedgecab');
INSERT INTO [usernameHelper] ([username]) VALUES ('interestboastful');
INSERT INTO [usernameHelper] ([username]) VALUES ('laughablemaxwell');
INSERT INTO [usernameHelper] ([username]) VALUES ('wimpprism');
INSERT INTO [usernameHelper] ([username]) VALUES ('rampallianpad');
INSERT INTO [usernameHelper] ([username]) VALUES ('lether');
INSERT INTO [usernameHelper] ([username]) VALUES ('abjectcelebrated');
INSERT INTO [usernameHelper] ([username]) VALUES ('halepod');
INSERT INTO [usernameHelper] ([username]) VALUES ('instinctdebate');
INSERT INTO [usernameHelper] ([username]) VALUES ('frailfreak');
INSERT INTO [usernameHelper] ([username]) VALUES ('minglingfonticons');
INSERT INTO [usernameHelper] ([username]) VALUES ('hijackumbra');
INSERT INTO [usernameHelper] ([username]) VALUES ('softwareshrimp');
INSERT INTO [usernameHelper] ([username]) VALUES ('holesneptune');
INSERT INTO [usernameHelper] ([username]) VALUES ('splatterblinkered');
INSERT INTO [usernameHelper] ([username]) VALUES ('dropboxthrowing');
INSERT INTO [usernameHelper] ([username]) VALUES ('harpyspeedy');
INSERT INTO [usernameHelper] ([username]) VALUES ('doradoheart');
INSERT INTO [usernameHelper] ([username]) VALUES ('yorkshireubiquity');
INSERT INTO [usernameHelper] ([username]) VALUES ('agentcup');
INSERT INTO [usernameHelper] ([username]) VALUES ('twotinosbarcode');
INSERT INTO [usernameHelper] ([username]) VALUES ('madcappupils');
INSERT INTO [usernameHelper] ([username]) VALUES ('porphyryunnatural');
INSERT INTO [usernameHelper] ([username]) VALUES ('liggerfishing');
INSERT INTO [usernameHelper] ([username]) VALUES ('nestingrhyolite');
INSERT INTO [usernameHelper] ([username]) VALUES ('roblego');
INSERT INTO [usernameHelper] ([username]) VALUES ('endothermicpeanut');
INSERT INTO [usernameHelper] ([username]) VALUES ('hollandaiseexperience');
INSERT INTO [usernameHelper] ([username]) VALUES ('umbrellabloated');
INSERT INTO [usernameHelper] ([username]) VALUES ('compasswayward');
INSERT INTO [usernameHelper] ([username]) VALUES ('encouragesuperb');
INSERT INTO [usernameHelper] ([username]) VALUES ('sessionssever');
INSERT INTO [usernameHelper] ([username]) VALUES ('chatfeigned');
INSERT INTO [usernameHelper] ([username]) VALUES ('punishmentsynth');
INSERT INTO [usernameHelper] ([username]) VALUES ('snashpoorly');
INSERT INTO [usernameHelper] ([username]) VALUES ('blowingscholar');
INSERT INTO [usernameHelper] ([username]) VALUES ('ornatetorso');
INSERT INTO [usernameHelper] ([username]) VALUES ('helmmarrow');
INSERT INTO [usernameHelper] ([username]) VALUES ('eyepieceelite');
INSERT INTO [usernameHelper] ([username]) VALUES ('volcanoesreporting');
INSERT INTO [usernameHelper] ([username]) VALUES ('endlesscomments');
INSERT INTO [usernameHelper] ([username]) VALUES ('flossclubs');
INSERT INTO [usernameHelper] ([username]) VALUES ('sacknees');
INSERT INTO [usernameHelper] ([username]) VALUES ('scarpthroated');
INSERT INTO [usernameHelper] ([username]) VALUES ('networksnowboard');
INSERT INTO [usernameHelper] ([username]) VALUES ('aldusbudget');
INSERT INTO [usernameHelper] ([username]) VALUES ('guineafearful');
INSERT INTO [usernameHelper] ([username]) VALUES ('meterpause');
INSERT INTO [usernameHelper] ([username]) VALUES ('clottedvroom');
INSERT INTO [usernameHelper] ([username]) VALUES ('cantermuscles');
INSERT INTO [usernameHelper] ([username]) VALUES ('apricotcarriage');
INSERT INTO [usernameHelper] ([username]) VALUES ('seatarias');
INSERT INTO [usernameHelper] ([username]) VALUES ('cartloadmourning');
INSERT INTO [usernameHelper] ([username]) VALUES ('buttresssustain');
INSERT INTO [usernameHelper] ([username]) VALUES ('isometryalert');
INSERT INTO [usernameHelper] ([username]) VALUES ('fixedcheater');
INSERT INTO [usernameHelper] ([username]) VALUES ('gardenwear');
INSERT INTO [usernameHelper] ([username]) VALUES ('curiumpestle');
INSERT INTO [usernameHelper] ([username]) VALUES ('beingteething');
INSERT INTO [usernameHelper] ([username]) VALUES ('submergemorris');
INSERT INTO [usernameHelper] ([username]) VALUES ('bastingdispenser');
INSERT INTO [usernameHelper] ([username]) VALUES ('dysnomiarich');
INSERT INTO [usernameHelper] ([username]) VALUES ('alcoholicsquid');
INSERT INTO [usernameHelper] ([username]) VALUES ('raysyllable');
INSERT INTO [usernameHelper] ([username]) VALUES ('assureand');
INSERT INTO [usernameHelper] ([username]) VALUES ('whimbrelfrozen');
INSERT INTO [usernameHelper] ([username]) VALUES ('niobiumconvection');
INSERT INTO [usernameHelper] ([username]) VALUES ('maximumfishy');
INSERT INTO [usernameHelper] ([username]) VALUES ('gnuformal');
INSERT INTO [usernameHelper] ([username]) VALUES ('particularboiling');
INSERT INTO [usernameHelper] ([username]) VALUES ('disguisingskull');
INSERT INTO [usernameHelper] ([username]) VALUES ('fesnyingmartingale');
INSERT INTO [usernameHelper] ([username]) VALUES ('liberiangranulation');
INSERT INTO [usernameHelper] ([username]) VALUES ('collagenchildren');
INSERT INTO [usernameHelper] ([username]) VALUES ('shinyperiod');
INSERT INTO [usernameHelper] ([username]) VALUES ('criticalcub');
INSERT INTO [usernameHelper] ([username]) VALUES ('twitchgemini');
INSERT INTO [usernameHelper] ([username]) VALUES ('fonticonsrage');
INSERT INTO [usernameHelper] ([username]) VALUES ('crownflexible');
INSERT INTO [usernameHelper] ([username]) VALUES ('drawhelper');
INSERT INTO [usernameHelper] ([username]) VALUES ('googolgleeking');
INSERT INTO [usernameHelper] ([username]) VALUES ('knowledgetriple');
INSERT INTO [usernameHelper] ([username]) VALUES ('purchasingmountain');
INSERT INTO [usernameHelper] ([username]) VALUES ('pigletsleuth');
INSERT INTO [usernameHelper] ([username]) VALUES ('scuppercheesecake');
INSERT INTO [usernameHelper] ([username]) VALUES ('studchalky');
INSERT INTO [usernameHelper] ([username]) VALUES ('kneeslay');
INSERT INTO [usernameHelper] ([username]) VALUES ('cheekplus');
INSERT INTO [usernameHelper] ([username]) VALUES ('hotpotgalvanic');
INSERT INTO [usernameHelper] ([username]) VALUES ('cherriestrustee');
INSERT INTO [usernameHelper] ([username]) VALUES ('reclusivesneeze');
INSERT INTO [usernameHelper] ([username]) VALUES ('asthmajarring');
INSERT INTO [usernameHelper] ([username]) VALUES ('uttermostcancer');
INSERT INTO [usernameHelper] ([username]) VALUES ('herculesrein');
INSERT INTO [usernameHelper] ([username]) VALUES ('terrylarge');
INSERT INTO [usernameHelper] ([username]) VALUES ('pedagogydartboard');
INSERT INTO [usernameHelper] ([username]) VALUES ('equablecrochet');
INSERT INTO [usernameHelper] ([username]) VALUES ('surfingwinks');
INSERT INTO [usernameHelper] ([username]) VALUES ('careenflex');
INSERT INTO [usernameHelper] ([username]) VALUES ('sparklingdeeply');
INSERT INTO [usernameHelper] ([username]) VALUES ('educatesomething');
INSERT INTO [usernameHelper] ([username]) VALUES ('summeryrotten');
INSERT INTO [usernameHelper] ([username]) VALUES ('xiphoidvolume');
INSERT INTO [usernameHelper] ([username]) VALUES ('breezywhimsical');
INSERT INTO [usernameHelper] ([username]) VALUES ('dominantprominence');
INSERT INTO [usernameHelper] ([username]) VALUES ('jockeyeither');
INSERT INTO [usernameHelper] ([username]) VALUES ('nasalmalaysian');
INSERT INTO [usernameHelper] ([username]) VALUES ('parasitewigga');
INSERT INTO [usernameHelper] ([username]) VALUES ('walkerbee');
INSERT INTO [usernameHelper] ([username]) VALUES ('motorboatbackground');
INSERT INTO [usernameHelper] ([username]) VALUES ('blendunruly');
INSERT INTO [usernameHelper] ([username]) VALUES ('shearwill');
INSERT INTO [usernameHelper] ([username]) VALUES ('radpallas');
INSERT INTO [usernameHelper] ([username]) VALUES ('daintyspotless');
INSERT INTO [usernameHelper] ([username]) VALUES ('mandibleexternal');
INSERT INTO [usernameHelper] ([username]) VALUES ('wrenbones');
INSERT INTO [usernameHelper] ([username]) VALUES ('intendedaphanic');
INSERT INTO [usernameHelper] ([username]) VALUES ('chordperl');
INSERT INTO [usernameHelper] ([username]) VALUES ('canessiblings');
INSERT INTO [usernameHelper] ([username]) VALUES ('collarbonefamiliar');
INSERT INTO [usernameHelper] ([username]) VALUES ('bewitchedmarked');
INSERT INTO [usernameHelper] ([username]) VALUES ('huntingmining');
INSERT INTO [usernameHelper] ([username]) VALUES ('canondeliver');
INSERT INTO [usernameHelper] ([username]) VALUES ('eastertrophy');
INSERT INTO [usernameHelper] ([username]) VALUES ('bioticcartridges');
INSERT INTO [usernameHelper] ([username]) VALUES ('superiorjurassic');
INSERT INTO [usernameHelper] ([username]) VALUES ('busytremolo');
INSERT INTO [usernameHelper] ([username]) VALUES ('hyundaiordinal');
INSERT INTO [usernameHelper] ([username]) VALUES ('enquiryhiccup');
INSERT INTO [usernameHelper] ([username]) VALUES ('coronethurtful');
INSERT INTO [usernameHelper] ([username]) VALUES ('loafflack');
INSERT INTO [usernameHelper] ([username]) VALUES ('twangdepartment');
INSERT INTO [usernameHelper] ([username]) VALUES ('partnerjumbo');
INSERT INTO [usernameHelper] ([username]) VALUES ('musclefibroids');
INSERT INTO [usernameHelper] ([username]) VALUES ('lodgepecan');
INSERT INTO [usernameHelper] ([username]) VALUES ('worldalcoholic');
INSERT INTO [usernameHelper] ([username]) VALUES ('selectionstint');
INSERT INTO [usernameHelper] ([username]) VALUES ('feathernoodle');
INSERT INTO [usernameHelper] ([username]) VALUES ('sortmop');
INSERT INTO [usernameHelper] ([username]) VALUES ('jaundiceraw');
INSERT INTO [usernameHelper] ([username]) VALUES ('crymen');
INSERT INTO [usernameHelper] ([username]) VALUES ('queryinggem');
INSERT INTO [usernameHelper] ([username]) VALUES ('tablecos');
INSERT INTO [usernameHelper] ([username]) VALUES ('glutinousouzel');
INSERT INTO [usernameHelper] ([username]) VALUES ('innercosmetic');
INSERT INTO [usernameHelper] ([username]) VALUES ('justpedals');
INSERT INTO [usernameHelper] ([username]) VALUES ('drafterplay');
INSERT INTO [usernameHelper] ([username]) VALUES ('metscary');
INSERT INTO [usernameHelper] ([username]) VALUES ('medialknife');
INSERT INTO [usernameHelper] ([username]) VALUES ('elaboraterightful');
INSERT INTO [usernameHelper] ([username]) VALUES ('slingingloaf');
INSERT INTO [usernameHelper] ([username]) VALUES ('pejorativekneel');
INSERT INTO [usernameHelper] ([username]) VALUES ('prolapsemckinley');
INSERT INTO [usernameHelper] ([username]) VALUES ('longingconvex');
GO

--167 title fragments all smaller than 10 chars


INSERT INTO [titleHelper1] ([title]) VALUES ('Castle');
INSERT INTO [titleHelper1] ([title]) VALUES ('Catalogue');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cath');
INSERT INTO [titleHelper1] ([title]) VALUES ('Chains');
INSERT INTO [titleHelper1] ([title]) VALUES ('Changed');
INSERT INTO [titleHelper1] ([title]) VALUES ('Chapter');
INSERT INTO [titleHelper1] ([title]) VALUES ('Children');
INSERT INTO [titleHelper1] ([title]) VALUES ('Chin');
INSERT INTO [titleHelper1] ([title]) VALUES ('Chlorine');
INSERT INTO [titleHelper1] ([title]) VALUES ('Chocolate');
INSERT INTO [titleHelper1] ([title]) VALUES ('Ciao!');
INSERT INTO [titleHelper1] ([title]) VALUES ('Clan');
INSERT INTO [titleHelper1] ([title]) VALUES ('Class');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cleaner');
INSERT INTO [titleHelper1] ([title]) VALUES ('Clear');
INSERT INTO [titleHelper1] ([title]) VALUES ('Climbing');
INSERT INTO [titleHelper1] ([title]) VALUES ('Clipped');
INSERT INTO [titleHelper1] ([title]) VALUES ('Clustered');
INSERT INTO [titleHelper1] ([title]) VALUES ('CN1');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cobalt');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cocteau');
INSERT INTO [titleHelper1] ([title]) VALUES ('Colourbox');
INSERT INTO [titleHelper1] ([title]) VALUES ('Come');
INSERT INTO [titleHelper1] ([title]) VALUES ('Comforts');
INSERT INTO [titleHelper1] ([title]) VALUES ('Complete');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cookie');
INSERT INTO [titleHelper1] ([title]) VALUES ('Counting');
INSERT INTO [titleHelper1] ([title]) VALUES ('Country');
INSERT INTO [titleHelper1] ([title]) VALUES ('Crime');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cross');
INSERT INTO [titleHelper1] ([title]) VALUES ('Cry');
INSERT INTO [titleHelper1] ([title]) VALUES ('Curse');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dagger');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dance');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dark');
INSERT INTO [titleHelper1] ([title]) VALUES ('Day');
INSERT INTO [titleHelper1] ([title]) VALUES ('De-Luxe');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dead');
INSERT INTO [titleHelper1] ([title]) VALUES ('Death');
INSERT INTO [titleHelper1] ([title]) VALUES ('Debaser');
INSERT INTO [titleHelper1] ([title]) VALUES ('Demo');
INSERT INTO [titleHelper1] ([title]) VALUES ('Demon');
INSERT INTO [titleHelper1] ([title]) VALUES ('Desire');
INSERT INTO [titleHelper1] ([title]) VALUES ('Detrola');
INSERT INTO [titleHelper1] ([title]) VALUES ('Diamonds');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dig');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dirt');
INSERT INTO [titleHelper1] ([title]) VALUES ('Distant');
INSERT INTO [titleHelper1] ([title]) VALUES ('Divine');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dizzy');
INSERT INTO [titleHelper1] ([title]) VALUES ('Doghouse');
INSERT INTO [titleHelper1] ([title]) VALUES ('Donde');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dream');
INSERT INTO [titleHelper1] ([title]) VALUES ('Dreams');
INSERT INTO [titleHelper1] ([title]) VALUES ('Eaters');
INSERT INTO [titleHelper1] ([title]) VALUES ('Enjoyment');
INSERT INTO [titleHelper1] ([title]) VALUES ('Entries');
INSERT INTO [titleHelper1] ([title]) VALUES ('esta');
INSERT INTO [titleHelper1] ([title]) VALUES ('Fingers');
INSERT INTO [titleHelper1] ([title]) VALUES ('Fire');
INSERT INTO [titleHelper1] ([title]) VALUES ('For');
INSERT INTO [titleHelper1] ([title]) VALUES ('Frank');
INSERT INTO [titleHelper1] ([title]) VALUES ('Girl');
INSERT INTO [titleHelper1] ([title]) VALUES ('Gun');
INSERT INTO [titleHelper1] ([title]) VALUES ('Hammer');
INSERT INTO [titleHelper1] ([title]) VALUES ('Hearts');
INSERT INTO [titleHelper1] ([title]) VALUES ('Heidi');
INSERT INTO [titleHelper1] ([title]) VALUES ('Here');
INSERT INTO [titleHelper1] ([title]) VALUES ('II');
INSERT INTO [titleHelper1] ([title]) VALUES ('Insects');
INSERT INTO [titleHelper1] ([title]) VALUES ('is');

GO


INSERT INTO [titleHelper2] ([title]) VALUES ('Bug');
INSERT INTO [titleHelper2] ([title]) VALUES ('Burden');
INSERT INTO [titleHelper2] ([title]) VALUES ('Burning');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cage');
INSERT INTO [titleHelper2] ([title]) VALUES ('Calendar');
INSERT INTO [titleHelper2] ([title]) VALUES ('Calistan');
INSERT INTO [titleHelper2] ([title]) VALUES ('Can');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cant');
INSERT INTO [titleHelper2] ([title]) VALUES ('Candida');
INSERT INTO [titleHelper2] ([title]) VALUES ('Carnival');
INSERT INTO [titleHelper2] ([title]) VALUES ('Carolyns');
INSERT INTO [titleHelper2] ([title]) VALUES ('Carroll');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cassette');
INSERT INTO [titleHelper2] ([title]) VALUES ('Castle');
INSERT INTO [titleHelper2] ([title]) VALUES ('Catalogue');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cath');
INSERT INTO [titleHelper2] ([title]) VALUES ('Chains');
INSERT INTO [titleHelper2] ([title]) VALUES ('Changed');
INSERT INTO [titleHelper2] ([title]) VALUES ('Chapter');
INSERT INTO [titleHelper2] ([title]) VALUES ('Children');
INSERT INTO [titleHelper2] ([title]) VALUES ('Chin');
INSERT INTO [titleHelper2] ([title]) VALUES ('Chlorine');
INSERT INTO [titleHelper2] ([title]) VALUES ('Chocolate');
INSERT INTO [titleHelper2] ([title]) VALUES ('Ciao!');
INSERT INTO [titleHelper2] ([title]) VALUES ('Clan');
INSERT INTO [titleHelper2] ([title]) VALUES ('Class');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cleaner');
INSERT INTO [titleHelper2] ([title]) VALUES ('Clear');
INSERT INTO [titleHelper2] ([title]) VALUES ('Climbing');
INSERT INTO [titleHelper2] ([title]) VALUES ('Clipped');
INSERT INTO [titleHelper2] ([title]) VALUES ('Clustered');
INSERT INTO [titleHelper2] ([title]) VALUES ('CN1');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cobalt');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cocteau');
INSERT INTO [titleHelper2] ([title]) VALUES ('Colourbox');
INSERT INTO [titleHelper2] ([title]) VALUES ('Come');
INSERT INTO [titleHelper2] ([title]) VALUES ('Comforts');
INSERT INTO [titleHelper2] ([title]) VALUES ('Complete');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cookie');
INSERT INTO [titleHelper2] ([title]) VALUES ('Counting');
INSERT INTO [titleHelper2] ([title]) VALUES ('Country');
INSERT INTO [titleHelper2] ([title]) VALUES ('Crime');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cross');
INSERT INTO [titleHelper2] ([title]) VALUES ('Cry');
INSERT INTO [titleHelper2] ([title]) VALUES ('Curse');
INSERT INTO [titleHelper2] ([title]) VALUES ('Dagger');
INSERT INTO [titleHelper2] ([title]) VALUES ('Dance');
INSERT INTO [titleHelper2] ([title]) VALUES ('Dark');
INSERT INTO [titleHelper2] ([title]) VALUES ('Day');
INSERT INTO [titleHelper2] ([title]) VALUES ('De-Luxe');
INSERT INTO [titleHelper2] ([title]) VALUES ('Dead');
INSERT INTO [titleHelper2] ([title]) VALUES ('Death');
INSERT INTO [titleHelper2] ([title]) VALUES ('Debaser');
INSERT INTO [titleHelper2] ([title]) VALUES ('Demo');
GO


INSERT INTO [titleHelper3] ([title]) VALUES ('Bride');
INSERT INTO [titleHelper3] ([title]) VALUES ('Bright');
INSERT INTO [titleHelper3] ([title]) VALUES ('Buddha');
INSERT INTO [titleHelper3] ([title]) VALUES ('Bug');
INSERT INTO [titleHelper3] ([title]) VALUES ('Burden');
INSERT INTO [titleHelper3] ([title]) VALUES ('Burning');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cage');
INSERT INTO [titleHelper3] ([title]) VALUES ('Calendar');
INSERT INTO [titleHelper3] ([title]) VALUES ('Calistan');
INSERT INTO [titleHelper3] ([title]) VALUES ('Can');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cant');
INSERT INTO [titleHelper3] ([title]) VALUES ('Candida');
INSERT INTO [titleHelper3] ([title]) VALUES ('Carnival');
INSERT INTO [titleHelper3] ([title]) VALUES ('Carolyns');
INSERT INTO [titleHelper3] ([title]) VALUES ('Carroll');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cassette');
INSERT INTO [titleHelper3] ([title]) VALUES ('Castle');
INSERT INTO [titleHelper3] ([title]) VALUES ('Catalogue');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cath');
INSERT INTO [titleHelper3] ([title]) VALUES ('Chains');
INSERT INTO [titleHelper3] ([title]) VALUES ('Changed');
INSERT INTO [titleHelper3] ([title]) VALUES ('Chapter');
INSERT INTO [titleHelper3] ([title]) VALUES ('Children');
INSERT INTO [titleHelper3] ([title]) VALUES ('Chin');
INSERT INTO [titleHelper3] ([title]) VALUES ('Chlorine');
INSERT INTO [titleHelper3] ([title]) VALUES ('Chocolate');
INSERT INTO [titleHelper3] ([title]) VALUES ('Ciao!');
INSERT INTO [titleHelper3] ([title]) VALUES ('Clan');
INSERT INTO [titleHelper3] ([title]) VALUES ('Class');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cleaner');
INSERT INTO [titleHelper3] ([title]) VALUES ('Clear');
INSERT INTO [titleHelper3] ([title]) VALUES ('Climbing');
INSERT INTO [titleHelper3] ([title]) VALUES ('Clipped');
INSERT INTO [titleHelper3] ([title]) VALUES ('Clustered');
INSERT INTO [titleHelper3] ([title]) VALUES ('CN1');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cobalt');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cocteau');
INSERT INTO [titleHelper3] ([title]) VALUES ('Colourbox');
INSERT INTO [titleHelper3] ([title]) VALUES ('Come');
INSERT INTO [titleHelper3] ([title]) VALUES ('Comforts');
INSERT INTO [titleHelper3] ([title]) VALUES ('Complete');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cookie');
INSERT INTO [titleHelper3] ([title]) VALUES ('Counting');
INSERT INTO [titleHelper3] ([title]) VALUES ('Country');
INSERT INTO [titleHelper3] ([title]) VALUES ('Crime');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cross');
INSERT INTO [titleHelper3] ([title]) VALUES ('Cry');
INSERT INTO [titleHelper3] ([title]) VALUES ('Curse');
INSERT INTO [titleHelper3] ([title]) VALUES ('Dagger');
GO



--fill username table
INSERT INTO [user] ([username], [firstname], [lastname], [password], [email])
SELECT LEFT(cast(Concat(firstnameHelper.firstname, surnameHelper.surname, usernameHelper.username) AS nvarchar), 32), firstnameHelper.firstname, surnameHelper.surname, '1234', Concat(firstnameHelper.firstname, '@', surnameHelper.surname, '.com')
From firstnameHelper
CROSS JOIN surnameHelper
CROSS JOIN usernameHelper;
GO

SELECT * FROM [user]

--fill interpret table

INSERT INTO [interpret] ([name], [origin], [website], [fk_genre_id])
SELECT TOP 10000 Concat(firstnameHelper.firstname, ' ', surnameHelper.surname), 'United Kingdom', 'foo.bar.com', genre.genre_id
FROM firstnameHelper
CROSS JOIN surnameHelper
INNER JOIN genre
on (((surnameHelper.surnameHelper_id % 10)+1) = genre_id);
GO

SELECT * FROM [interpret];



--fill album table
DECLARE @counter INT
SET @counter = 1

--prepare album table, create over 50.000 albums
WHILE @counter < 501
   BEGIN  
		INSERT INTO [album] ([name], [releaseyear])
		SELECT  CONCAT(titleHelper1.title, @counter), 1970
		FROM titleHelper1

		SET @counter = @counter + 1;
	END;
GO

--enter correct year, label and genre
DECLARE @albumCount INT
DECLARE @genreCount INT
DECLARE @labelCount INT
DECLARE @genreID INT
DECLARE @labelID INT
DECLARE @counter INT

SET @counter = 1
SET @albumCount = (SELECT Count(*) FROM album) + 1
SET @genreCount = (SELECT Count(*) FROM genre)
SET @labelCount = (SELECT Count(*) FROM label)

WHILE @counter < @albumCount 
   BEGIN  
		SET @genreID = (@counter % @genreCount) + 1
		SET @labelID = (@counter % @labelCount) + 1

		UPDATE 	[album]
		SET 	[releaseyear] = Round(1950 + (Rand() * 68), 0),
				[fk_genre_id] = @genreID,
				[fk_label_id] = @labelID
		WHERE album_id = @counter

		SET @counter = @counter + 1;
	END;
GO

SELECT * FROM album

--prepare title table ([name], [duration], [bitrate])
INSERT INTO title ([name], [duration], [bitrate], [fk_genre_id])
SELECT Concat(titleHelper1.title, ' ', titleHelper2.title, ' ', titleHelper3.title), Round(Rand() * 500, 0), 22000, 1
FROM titleHelper1
CROSS JOIN titleHelper2
CROSS JOIN titleHelper3;
GO

-------------------------------------------------------------------------------------------
GO
DECLARE @titlenumber INT

DECLARE @title_titlenumber INT
DECLARE @title_genre_id INT
DECLARE @title_album_id INT

DECLARE @album_genre_id INT
DECLARE @album_album_id INT



--Titlecursor
DECLARE title_cursor CURSOR FOR
    SELECT dbo.title.titlenumber, dbo.title .fk_genre_id, dbo.title .fk_album_id
    FROM dbo.title
    FOR UPDATE OF dbo.title.titlenumber, dbo.title .fk_genre_id, dbo.title .fk_album_id
OPEN title_cursor;

--album_cursor
DECLARE album_cursor CURSOR FOR
    SELECT dbo.album.album_id, dbo.album.fk_genre_id
    FROM dbo.album
    FOR READ ONLY
OPEN album_cursor;

FETCH NEXT FROM album_cursor
INTO @album_album_id, @album_genre_id

WHILE (@@FETCH_STATUS = 0)
BEGIN

	FETCH NEXT FROM title_cursor
	INTO 	@title_titlenumber,
			@title_genre_id,
			@title_album_id

	SET @titlenumber = 1
	WHILE @titlenumber < 12 AND @@FETCH_STATUS = 0
		BEGIN
			UPDATE dbo.title
				SET dbo.title.titlenumber = @titlenumber,
					dbo.title.fk_genre_id = @album_genre_id,
					dbo.title.fk_album_id = @album_album_id
			WHERE CURRENT OF title_cursor

			FETCH NEXT FROM title_cursor
			INTO 	@title_titlenumber,
					@title_genre_id,
					@title_album_id
			SET @titlenumber = @titlenumber + 1
		END

	FETCH NEXT FROM album_cursor
	INTO @album_album_id, @album_genre_id
END

CLOSE title_cursor;
CLOSE album_cursor;

DEALLOCATE title_cursor;
DEALLOCATE album_cursor;

SELECT * FROM title
--fill title_interpret table
DECLARE @counter INT

DECLARE @titleCount INT
DECLARE @interpretCount INT

SET @counter = 1
SET @titleCount = (SELECT COUNT (*) FROM title)
SET @interpretCount = (SELECT COUNT (*) FROM interpret)

WHILE @counter < (@titleCount + 1)
   BEGIN
   		INSERT INTO title_interpret ([fk_title_id], [fk_interpret_id])
   		VALUES (@counter, ((@counter % @interpretCount) + 1))

		SET @counter = @counter + 1;
	END;
GO

SELECT * FROM title_interpret
ORDER BY fk_title_id

--fill rating table
INSERT INTO [rating] ([ratingvalue], [fk_title_id], [fk_user_id])
SELECT 5, dbo.title.title_id, [user].user_id
FROM title
LEFT OUTER JOIN [user]
ON title.title_id = [user].user_id

--playlist table
INSERT INTO [playlist] ([title], [fk_genre_id], [fk_user_id])
SELECT TOP 100 Concat(Left([user].username, 19), '''s playlist'), genre.genre_id, [user].user_id
FROM [user]
JOIN genre
on (([user].user_id % (SELECT Count (*) FROM genre))+1) = genre_id;

SELECT * FROM playlist

--fill playlist_title table
DECLARE @counter INT

SET @counter = 0
WHILE @counter < 100
	BEGIN
		INSERT INTO [playlist_title] ([fk_playlist_id], [fk_title_id])
		SELECT playlist.playlist_id, title.title_id
		FROM playlist
		join title
		On playlist_id+@counter = title_id

		SET @counter = @counter + 1
	END;
GO
SELECT * FROM playlist_title


DROP TABLE [usernameHelper];
DROP TABLE [firstnameHelper];
DROP TABLE [surnameHelper];
DROP TABLE [titleHelper1];
DROP TABLE [titleHelper2];
DROP TABLE [titleHelper3];

GO  
SET NOCOUNT OFF; 
GO



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


USE [Music];
GO

CREATE NONCLUSTERED INDEX DX_TitleIndex
ON [title] ([name]);

CREATE NONCLUSTERED INDEX DX_UsernameIndex
ON [user] ([username]);

CREATE NONCLUSTERED INDEX DX_GenreIndex
ON [genre] ([name]);