USE [Music];
GO


------------------------------------------------------------------------------
-- checks if the trigger already exists using the sys.objects and drops it. --
------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'TR_UniqueUsername' AND [type] = 'TR')
	DROP TRIGGER [TR_UniqueUsername]
GO


------------------------------------------------------------------------------
--
------------------------------------------------------------------------------
CREATE TRIGGER [TR_UniqueUsername] ON [user]
INSTEAD OF INSERT								-- SQL Server does not support BEFORE triggers
AS BEGIN
	DECLARE 
		@Username		NVARCHAR(32),
		@Firstname		NVARCHAR(32),
		@Lastname		NVARCHAR(32),
		@Password		NVARCHAR(32),
		@email			NVARCHAR(32);

	DECLARE CUR_InsertedUser CURSOR FORWARD_ONLY FOR
		SELECT ins.[username], ins.[firstname], ins.[lastname], ins.[password], ins.[email]
		FROM [inserted] AS ins;
			
	BEGIN TRANSACTION
		OPEN CUR_InsertedUser;
		FETCH NEXT FROM CUR_InsertedUser INTO @Username, @Firstname, @Lastname, @Password, @email;

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			IF ((SELECT COUNT(*) FROM [user] WHERE [user].username = @Username) > 0)
			BEGIN
				ROLLBACK;
				-- close cursor and free allocated memory to prevent memory leaks
				CLOSE CUR_InsertedUser;
				DEALLOCATE CUR_InsertedUser;
				THROW 50000, 'Could not insert user, username already exists!', 2;
			END --if
			BEGIN TRY
				INSERT INTO [user] ([username], [firstname], [lastname], [password], [email]) VALUES (@Username, @Firstname, @Lastname, @Password, @email);
				FETCH NEXT FROM CUR_InsertedUser INTO @Username, @Firstname, @Lastname, @Password, @email;
			END TRY BEGIN CATCH
				ROLLBACK;
				CLOSE CUR_InsertedUser;
				DEALLOCATE CUR_InsertedUser;
				THROW;
			END CATCH
		END --while
	CLOSE CUR_InsertedUser;
	DEALLOCATE CUR_InsertedUser;
	COMMIT;
END; --trigger


------------------------------------------------------------------------------
-- test code for checking trigger behavior.                                 --
------------------------------------------------------------------------------


select * from [user];

insert into [user] values ('Peter855', 'Peter','Müller','1234','name@mail.com');