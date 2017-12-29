USE [Music];
GO


------------------------------------------------------------------------------
-- checks if the trigger already exists using the sys.objects and drops it. --
------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'TR_UniqueTitleNumberInAlbum' AND [type] = 'TR')
	DROP TRIGGER [TR_UniqueTitleNumberInAlbum];
GO


------------------------------------------------------------------------------
--
------------------------------------------------------------------------------
CREATE TRIGGER [TR_UniqueTitleNumberInAlbum] ON [title]
INSTEAD OF INSERT				-- SQL Server does not support BEFORE triggers
AS BEGIN
	DECLARE @TitleNumber SMALLINT,
			@TitleAlbum	INT;

	DECLARE CUR_InsertedTitle CURSOR FORWARD_ONLY FOR
		SELECT ins.[titlenumber], ins.[fk_album_id]
		FROM [inserted] AS ins;

	BEGIN TRANSACTION;
		OPEN CUR_InsertedTitle;
		FETCH NEXT FROM CUR_InsertedTitle INTO @TitleNumber, @TitleAlbum;

		WHILE @@FETCH_STATUS = 0 BEGIN;
			IF ((SELECT Count(*) FROM [title] AS t
					WHERE t.[titlenumber] = @TitleNumber
					AND t.[fk_album_id] = @TitleAlbum) > 0)
			BEGIN;
				ROLLBACK;
				
				-- close cursor and free allocated memory to prevent memory leaks
				CLOSE CUR_InsertedTitle;
				DEALLOCATE CUR_InsertedTitle;

				THROW 47000, 'Titlenumber already exists in this album', 2;
			END;

			BEGIN TRY;
				INSERT INTO
					[title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id])
					VALUES ();
			END TRY BEGIN CATCH;
				ROLLBACK;

				-- close cursor and free allocated memory to prevent memory leaks
				CLOSE CUR_InsertedTitle;
				DEALLOCATE CUR_InsertedTitle;

				RETURN 1;
			END CATCH;
			
			FETCH NEXT FROM CUR_InsertedTitle INTO @TitleNumber, @TitleAlbum;
		END;
	ROLLBACK;

	-- close cursor and free allocated memory to prevent memory leaks
	CLOSE CUR_InsertedTitle;
	DEALLOCATE CUR_InsertedTitle;

	/*
	DECLARE CUR_AlbumTitle CURSOR FORWARD_ONLY FOR
		SELECT t.[titlenumber] FROM [title] AS t
		INNER JOIN [inserted] AS ins ON ins.fk_album_id = t.fk_album_id;

	BEGIN TRANSACTION;
		OPEN CUR_AlbumTitle;
		FETCH NEXT FROM CUR_AlbumTitle INTO @TitleNumber;

		WHILE @@FETCH_STATUS = 0 BEGIN;
			IF (@TitleNumber = ANY(SELECT [titlenumber] FROM [inserted])) BEGIN;
				ROLLBACK;
				THROW 47000, 'Titlenumber already exists in this album', 2;
			END;

			FETCH NEXT FROM CUR_AlbumTitle INTO @TitleNumber;
		END;
	ROLLBACK;*/

	-- close cursor and free allocated memory to prevent memory leaks
	CLOSE CUR_AlbumTitle;
	DEALLOCATE CUR_AlbumTitle;
END
GO


------------------------------------------------------------------------------
-- test code for checking trigger behavior.                                 --
------------------------------------------------------------------------------
INSERT INTO [album] ([name], [releaseyear]) VALUES ('Album #1', 2017);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('Title #1', 1, 300, 20000, 1, 1);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('Title #2', 1, 400, 30000, 1, 1);

SELECT * FROM [title];