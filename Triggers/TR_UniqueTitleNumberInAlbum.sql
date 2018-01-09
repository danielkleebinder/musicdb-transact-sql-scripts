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
			@TitleAlbum	INT,
			@TitleBitrate INT,
			@TitleDuration SMALLINT,
			@TitleGenre INT,
			@TitleName NVARCHAR(32);

	DECLARE CUR_InsertedTitle CURSOR FORWARD_ONLY FOR
		SELECT ins.[titlenumber], ins.[fk_album_id], ins.[bitrate], ins.[duration], ins.[fk_genre_id], ins.[name]
		FROM [inserted] AS ins;

	BEGIN TRANSACTION;
		OPEN CUR_InsertedTitle;
		FETCH NEXT FROM CUR_InsertedTitle INTO @TitleNumber, @TitleAlbum, @TitleBitrate, @TitleDuration, @TitleGenre, @TitleName;

		WHILE @@FETCH_STATUS = 0 BEGIN;
			IF ((SELECT Count(*) FROM [title] AS t
					WHERE t.[titlenumber] = @TitleNumber
					AND t.[fk_album_id] = @TitleAlbum) > 0)
			BEGIN
				ROLLBACK;
				
				-- close cursor and free allocated memory to prevent memory leaks
				CLOSE CUR_InsertedTitle;
				DEALLOCATE CUR_InsertedTitle;

				THROW 50000, 'Titlenumber already exists in this album', 2;
			END; -- end if

			BEGIN TRY
				INSERT INTO
					[title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id])
					VALUES (@TitleName, @TitleNumber, @TitleDuration, @TitleBitrate, @TitleGenre, @TitleAlbum);
					FETCH NEXT FROM CUR_InsertedTitle INTO @TitleNumber, @TitleAlbum, @TitleBitrate, @TitleDuration, @TitleGenre, @TitleName;
			END TRY BEGIN CATCH
				ROLLBACK;
				CLOSE CUR_InsertedTitle;
				DEALLOCATE CUR_InsertedTitle;
				THROW;
			END CATCH;
			
			FETCH NEXT FROM CUR_InsertedTitle INTO @TitleNumber, @TitleAlbum, @TitleBitrate, @TitleDuration, @TitleGenre, @TitleName;
		END;
	-- close cursor and free allocated memory to prevent memory leaks
	CLOSE CUR_InsertedTitle;
	DEALLOCATE CUR_InsertedTitle;
	commit;
END;



	-- close cursor and free allocated memory to prevent memory leaks

/*	/*
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

*/
------------------------------------------------------------------------------
-- test code for checking trigger behavior.                                 --
------------------------------------------------------------------------------
INSERT INTO [album] ([name], [releaseyear]) VALUES ('Album #1', 2017);
INSERT INTO [album] ([name], [releaseyear]) VALUES ('Album #2', 2012);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('Title #1', 1, 300, 20000, 1, 9);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('Title #2', 2, 400, 30000, 1, 9);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('MySong', 3, 400, 30000, 1, 9);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('MySong 2', 2, 400, 30000, 1, 10);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('MySong 3', 4, 400, 30000, 1, 10);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('MySong 4', 6, 400, 30000, 1, 10);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id], [fk_album_id]) VALUES ('MySong 4', 7, 400, 30000, 1, 10);
INSERT INTO [rating] ([ratingvalue], [comment], [fk_title_id], [fk_user_id]) VALUES (5, 'Really nice track!', 1, 1);

SELECT * FROM [title];
SELECT * FROM [album];
select * from rating;

delete from title
delete from album
delete from rating