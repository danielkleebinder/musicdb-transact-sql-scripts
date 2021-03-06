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

---------------------------------------------------------------------------
-- run the stored procedure to check correct behaviour and return values --
---------------------------------------------------------------------------
/*DECLARE @Out INT;
EXEC dbo.[USP_Login]
	@Username = 'Peter8855',
	@Password = 'mYp@ccW#r1',
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
WHERE [username] = 'Peter8855';*/