USE [Music];
GO

CREATE NONCLUSTERED INDEX title_index
ON title ([name]);

CREATE NONCLUSTERED INDEX username_index
ON [user] ([username]);

CREATE NONCLUSTERED INDEX genre_index
ON [genre] ([name]);