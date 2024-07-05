--BEGIN TRANSACTION

       USE ShipCrews
       
	   ---------------------------------------------------
       -- Create a new table called 'Crews' in schema 'dbo'
       -- Drop the table if it already exists
       IF OBJECT_ID('dbo.Crews', 'U') IS NOT NULL
           DROP TABLE dbo.Crews
       GO
       
       -- Create the table in the specified schema
       CREATE TABLE dbo.Crews (
           CrewId INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- primary key column
           Name VARCHAR(50) UNIQUE
		          );
       GO

	   ---------------------------------------------------
       -- Create a new table called 'Roles' in schema 'dbo'
       -- Drop the table if it already exists
       IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL
           DROP TABLE dbo.Roles
       GO
       
       -- Create the table in the specified schema
       CREATE TABLE dbo.Roles (
           RoleId INT NOT NULL PRIMARY KEY, -- primary key column
           Name VARCHAR(50)
		          );
		
		GO


	   ---------------------------------------------------
       -- Create a new table called 'Person' in schema 'dbo'
       -- Drop the table if it already exists
       IF OBJECT_ID('dbo.People', 'U') IS NOT NULL
           DROP TABLE dbo.People
       GO
       
       -- Create the table in the specified schema
       CREATE TABLE dbo.People (
           PersonId INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- primary key column
           FirstName NVARCHAR(50),
		   LastName NVARCHAR(50) NOT NULL, 
		   RoleId INT FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
		          );
       GO


	   --------------------------------------------------- For another time
       -- Create a new table called 'CrewActivations' in schema 'dbo'
       -- Drop the table if it already exists
       -- IF OBJECT_ID('dbo.CrewActivations', 'U') IS NOT NULL
           -- DROP TABLE dbo.CrewActivations
       -- GO
       
       -- Create the table in the specified schema
       -- CREATE TABLE dbo.CrewActivations (
           -- CrewActivationId INT NOT NULL PRIMARY KEY, -- primary key column
		   -- CrewId INT FOREIGN KEY (CrewId) REFERENCES Crews(CrewId),
           -- StartTime DATETIME,
		   -- EndTime DATETIME
		          -- );
       GO

		---------------------------------------------------
       -- Create a new table called 'CrewAssignments' in schema 'dbo'
       -- Drop the table if it already exists
       IF OBJECT_ID('dbo.CrewAssignments', 'U') IS NOT NULL
           DROP TABLE dbo.CrewAssignments
       GO
       
       -- Create the table in the specified schema
       CREATE TABLE dbo.CrewAssignments (
	       Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- primary key column -- needed for entity framework. a composite primary key does not work
           CrewId INT FOREIGN KEY (CrewId) REFERENCES Crews(CrewId),
		   PersonId INT FOREIGN KEY (PersonId) REFERENCES People(PersonId),
           -- PRIMARY KEY(CrewId, PersonId) -- leads to probelms with entity framework
		   CONSTRAINT CK_CrewAssignments_Unique UNIQUE(CrewId, PersonId)
		   -- CONSTRAINT CK_CrewAssignments_NoOverlap CHECK (PersonId NOT IN (SELECT PersonId From CrewAssignments)) -- Subqueries are not allowed in this context. Only scalar expressions are allowed.
		   );
       GO


		--CREATE TRIGGER ON_INS_CrewAssignment
		--ON CrewAssignments
		--FOR INSERT
		--AS
		--BEGIN
			--DECLARE @caid INT, @pid INT
			--DECLARE @rowCount INT;
			--SELECT @rowCount = COUNT(*) FROM ROLES INNER JOIN PEOPLE ON Roles.RoleId = People.RoleId AND People.RoleId = 3 GROUP BY Roles.RoleId
			--SELECT Acode, COUNT(Bcode) FROM TableName GROUP BY Acode HAVING COUNT(Bcode) > 1
			--IF ((SELECT COUNT(*) FROM CrewAssignments WHERE (SELECT COUNT(RoleId) FROM CrewAssignments WHERE (CrewActivationId = @caid)) > 1)
			--BEGIN
				--RAISERROR ('You are not allowed to Add These Data.', 10, 11)
			--END
		--END
		--CREATE TRIGGER INS_CrewAssignment
			--ON dbo.CrewAssignments
			--INSTEAD OF INSERT
			--AS
			--BEGIN
				--DECLARE @caid INT, @pid INT
				--SELECT @caid=CrewActivationId, @pid=PersonId FROM inserted
				--IF ((SELECT COUNT(*) FROM CrewAssignments WHERE (CrewActivationId = @caid AND PersonId = @pid)) > 1)
				--BEGIN
					--RAISERROR ('You are not allowed to Add These Data.', 10, 11)
			--END
			--ELSE
				--INSERT INTO dbo.CrewAssignments (CrewActivationId ,PersonId) values (@caid,@pid)
--SELECT *
--FROM sys.foreign_keys
--WHERE referenced_object_id = object_id('Student')

--ROLLBACK
--COMMIT

--END
