USE [master];
GO
/*** Object: Database [webredirector] ***/
CREATE DATABASE [webredirector];
GO
USE [webredirector]
GO
/*** Object: Table [dbo].[urls] ***/
CREATE TABLE [dbo].[urls] (
	[id] UNIQUEIDENTIFIER PRIMARY KEY,
	[alias] VARCHAR(255) UNIQUE NOT NULL,
	[destination] NVARCHAR(MAX) NOT NULL
);
GO
/*** Object: StoredProcedure [dbo].[newLink] ***/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[newLink]
	@alias VARCHAR(255),
	@destination NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @alias IS NULL OR LEN(@alias) = 0
		BEGIN
			RAISERROR('Alias is required', 16, 1);
			RETURN;
		END

	IF @destination IS NULL OR LEN(@destination) = 0
		BEGIN
			RAISERROR('Destination is required', 16, 1);
			RETURN;
		END

	IF @alias IN ('wwwroot', 'css', 'js', 'lib', 'admin', 'root', 'git', 'fav', 'icon', 'hostmaster')
		BEGIN
			RAISERROR('Alias name must not in the reserved list', 16, 1);
			RETURN;
		END

	IF UPPER(@alias) IN ('CREATE', 'ALTER', 'DROP', 'TRUNCATE', 'RENAME', 'INSERT', 'UPDATE', 'DELETE', 
						'MERGE', 'GRANT', 'REVOKE', 'COMMIT', 'ROLLBACK', 'SAVEPOINT', 'SELECT')
		BEGIN
			RAISERROR('SQL comamnds are not allowed', 16, 1);
			RETURN;
		END
	
	IF PATINDEX('%[^A-Za-z0-9]%', @alias COLLATE Latin1_General_BIN) > 0
		BEGIN
			RAISERROR('The alias should only contain English characters and numbers', 16, 1);
			RETURN;
		END

	IF EXISTS (
		SELECT 1
			FROM [dbo].[urls] AS u
			WHERE u.alias = @alias
	) BEGIN
		RAISERROR ('This alias is already existed.', 16, 1);
		RETURN;
	END

	IF EXISTS (
		SELECT 1
			FROM [dbo].[urls] AS u
			WHERE u.destination = @destination
	) BEGIN
		RAISERROR ('Same destination detected.', 16, 1);
		RETURN;
	END

	INSERT INTO [dbo].[urls] ([id], [alias], [destination])
		VALUES (NEWID(), @alias, @destination);
END
GO
/*** Object: Trigger [dbo].[noDupDest] **/
CREATE OR ALTER TRIGGER [dbo].[noDupDest] 
	ON [dbo].[urls]
	AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT u.destination, COUNT(u.destination) AS [udc]
			FROM [dbo].[urls] AS u
			GROUP BY u.destination
			HAVING COUNT(u.destination) > 1
	) BEGIN
		RAISERROR ('Having a duplicated URL, rolling back', 16, 1);
		ROLLBACK TRANSACTION;
	END
END
GO

/*** Add new values for database ***/
EXEC [dbo].[newLink] @alias = 'myapps', @destination = 'https://myapps.web.neko';
EXEC [dbo].[newLink] @alias = 'adcs', @destination = 'https://workshop.neko/certsrv/';
EXEC [dbo].[newLink] @alias = 'gitlab', @destination = 'https://gitlab.workshop.neko/';
EXEC [dbo].[newLink] @alias = 'adfs', @destination = 'https://adfs.workshop.neko/adfs/ls/idpinitiatedsignon';
GO