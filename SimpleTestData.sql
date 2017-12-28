USE [Music];
GO


-- to check datasets in given tables
SELECT * FROM [album];
SELECT * FROM [interpret];
SELECT * FROM [label];
SELECT * FROM [rating];
SELECT * FROM [genre];
SELECT * FROM [title];
SELECT * FROM [playlist];
SELECT * FROM [playlist_title];
SELECT * FROM [title_interpret];
SELECT * FROM [user];
GO


-- to test the basic functionallity of stored procedures
INSERT INTO [genre] ([name]) VALUES ('Rock & Roll');
INSERT INTO [genre] ([name]) VALUES ('Pop');
INSERT INTO [genre] ([name]) VALUES ('Classic');
INSERT INTO [genre] ([name]) VALUES ('Jazz');

INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Title #1', 1, 300, 20000, 1);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Title #2', 2, 200, 5000, 3);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Title #3', 3, 350, 60000, 2);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Title #4', 2, 400, 40000, 1);
INSERT INTO [title] ([name], [titlenumber], [duration], [bitrate], [fk_genre_id]) VALUES ('Title #5', 1, 250, 30000, 4);

INSERT INTO [user] ([username], [password], [firstname], [lastname], [email]) VALUES ('Peter8855', 'Peter', 'Müller', 'mYp@ccW#r1', 'peter.müller@gmail.com');

INSERT INTO [playlist] ([description], [title], [fk_genre_id], [fk_user_id]) VALUES ('This is my first playlist', 'Workout Playlist', 1, 1);

INSERT INTO [interpret] ([name], [origin], [website], [fk_genre_id]) VALUES ('Interpret #1', 'L.A.', 'www.interpret.us', 4);

INSERT INTO [rating] ([ratingvalue], [comment], [fk_title_id], [fk_user_id]) VALUES (5, 'My Text Comment #1', 1, 1);
GO