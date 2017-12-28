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