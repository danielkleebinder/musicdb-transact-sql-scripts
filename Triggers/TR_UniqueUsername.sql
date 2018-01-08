USE [Music];
GO


------------------------------------------------------------------------------
-- checks if the trigger already exists using the sys.objects and drops it. --
------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'TR_' AND [type] = 'TR')
	DROP TRIGGER [TR_]
GO


------------------------------------------------------------------------------
--
------------------------------------------------------------------------------
CREATE TRIGGER [TR_] ON ___table___
INSTEAD OF INSERT								-- SQL Server does not support BEFORE triggers
AS BEGIN
	-- trigger code goes here
END
GO


------------------------------------------------------------------------------
-- test code for checking trigger behavior.                                 --
------------------------------------------------------------------------------

