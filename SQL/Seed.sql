BEGIN TRANSACTION

       USE ShipCrews

	   -- Populate the Crews table
	   INSERT INTO dbo.Crews 
			([CrewId], [Name])
		VALUES
			(1, 'Alpha Even'),
			(2, 'Beta Even'),
			(3, 'Gamma Even'),
			(10, 'Alpha Odd'),
			(20, 'Beta Odd'),
			(30, 'Gamma odd');
		
		GO

	   -- Populate the Crews table
	   INSERT INTO dbo.Roles
			([RoleId], [Name])
		VALUES
			(1, 'Skipper'),
			(2, 'Navigator'),
			(3, 'RadarOperator');
		GO

	   -- Populate the People table
	   DELETE FROM dbo.People 
	   INSERT INTO dbo.People 
			([PersonId], [FirstName], [LastName], [RoleId])
		VALUES
			(1, 'Tony', 'Best', 1),
			(2, NULL, 'Doe', NULL),
			(3, 'Tracy', 'Next', 3),
			(4, 'OtherTracy', 'Next', 3),
			(10, 'Tony', 'Next', 1),
			(20, 'Gill', 'Doe', 2),
			(30, 'Tracy', 'Next', 3),
			(40, 'OtherOtherTracy', 'Next', 3)
		--SELECT * FROM dbo.People;
		GO

		


		SELECT * FROM dbo.CrewAssignments;
		DELETE FROM dbo.CrewAssignments;

		INSERT INTO dbo.CrewAssignments ([CrewId], [PersonId])
			VALUES
			(1, 1),
			(1, 2),
			(1, 3),
			(1, 4),
			(1, 40),
			(1, 20);
		INSERT INTO dbo.CrewAssignments ([CrewId], [PersonId])
			VALUES
			(1, 10);
		INSERT INTO dbo.CrewAssignments ([CrewId], [PersonId])
			VALUES
			(2, 2);
		INSERT INTO dbo.CrewAssignments ([CrewId], [PersonId])
			VALUES
			(3, 10),
			(3, 20),
			(3, 40);
		INSERT INTO dbo.CrewAssignments ([CrewId], [PersonId])
			VALUES
			(10, 1),
			(10, 2),
			(10, 3);
		GO

		SELECT COUNT(*) FROM CrewAssignments c, People  p WHERE c.PersonId = p.PersonId AND p.RoleId = @RoleId

		SELECT * FROM dbo.CrewAssignments;
		SELECT COUNT(*) FROM CrewAssignments WHERE (CrewId = 1 AND PersonId = 1)
		--SELECT *, COUNT(t.name) AS mycount FROM "myTable" AS t WHERE t.id=t.orig_id GROUP BY t.id;
		SELECT * FROM People
		SELECT * FROM Roles
		SELECT Roles.RoleId, Roles.Name FROM Roles, People WHERE Roles.RoleId = People.RoleId

		SELECT Roles.RoleId, COUNT(Roles.RoleId) FROM ROLES INNER JOIN PEOPLE ON Roles.RoleId = People.RoleId AND People.RoleId = 3 GROUP BY Roles.RoleId
		SELECT CrewId FROM People INNER JOIN CrewAssignments ON People.PersonId = CrewAssignments.PersonId WHERE People.RoleId = 3 GROUP BY CrewAssignments.CrewId

		SELECT COUNT(CASE Roles.RoleId when 3 then 1 else null end) FROM ROLES INNER JOIN PEOPLE ON Roles.RoleId = People.RoleId

		SELECT * FROM CrewAssignments
		SELECT * FROM dbo.CrewAssignments
		SELECT * FROM dbo.CrewAssignments INNER JOIN People ON People.PersonId = CrewAssignments.PersonId
		SELECT CrewAssignments.CrewId, COUNT(People.PersonId) NrMembers FROM dbo.CrewAssignments INNER JOIN People ON People.PersonId = CrewAssignments.PersonId GROUP BY CrewId
		SELECT * FROM dbo.CrewAssignments INNER JOIN People ON People.PersonId = CrewAssignments.PersonId WHERE People.RoleId = 3
		SELECT * FROM People INNER JOIN CrewAssignments ON People.PersonId = CrewAssignments.PersonId INNER JOIN Roles ON People.RoleId = Roles.RoleId ORDER BY People.PersonId

		SELECT People.RoleId, CrewAssignments.CrewId, COUNT(*) FROM People INNER JOIN CrewAssignments ON People.PersonId = CrewAssignments.PersonId INNER JOIN Roles ON People.RoleId = Roles.RoleId GROUP BY People.RoleId, CrewAssignments.CrewId

		SELECT * FROM People p1, People p2, CrewAssignments c1, CrewAssignments c2
			WHERE p1.PersonId = c1.PersonId AND p2.PersonId = c1.PersonId AND p1.RoleId = p2.RoleId

		SELECT * FROM dbo.CrewAssignments, People, Roles WHERE CrewAssignments.PersonId = People.PersonId AND Roles.RoleId = People.RoleId
		-- gets duplicate roles
		SELECT c1.CrewId, p1.RoleId, r1.Name, COUNT(*) AS DuplicateRoles FROM People p1, People p2, CrewAssignments c1, CrewAssignments c2, Roles r1
			WHERE p1.PersonId = c1.PersonId AND p2.PersonId = c2.PersonId AND p1.RoleId = p2.RoleId AND p1.PersonId != p2.PersonId AND c1.CrewId = c2.CrewId AND r1.RoleId = p1.RoleId
			GROUP BY c1.CrewId, p1.RoleId, r1.Name
		SELECT c1.CrewId, p1.RoleId, COUNT(*) AS DuplicateRoles FROM People p1, People p2, CrewAssignments c1, CrewAssignments c2
			WHERE p1.PersonId = c1.PersonId AND p2.PersonId = c2.PersonId AND p1.RoleId = p2.RoleId AND c1.PersonId != c2.PersonId AND c1.CrewId = c2.CrewId
			GROUP BY c1.CrewId, p1.RoleId

		-- gets duplicate roles within a crew
		SELECT t1.CrewId, t1.RoleId, t1.Name, DuplicateRoles FROM
		(SELECT c1.CrewId, p1.RoleId, r1.Name, COUNT(*) AS DuplicateRoles FROM People p1, People p2, CrewAssignments c1, CrewAssignments c2, Roles r1
			WHERE p1.PersonId = c1.PersonId AND p2.PersonId = c2.PersonId AND p1.RoleId = 3 AND p2.RoleId = 3 AND c1.PersonId != c2.PersonId AND c1.CrewId = c2.CrewId AND r1.RoleId = p1.RoleId
			GROUP BY c1.CrewId, p1.RoleId, r1.Name
			) t1

		SELECT COUNT(*) FROM CrewAssignments c, People  p WHERE c.PersonId = p.PersonId AND c.CrewId = 1 AND p.RoleId = 1

		CREATE FUNCTION GetCrewRoleCountFunc 
		(@CrewId INT, @RoleId INT)
		RETURNS INT
		AS
		BEGIN
			DECLARE @Result AS INT=0
			SET @Result = (SELECT COUNT(*) FROM CrewAssignments c, People  p WHERE c.PersonId = p.PersonId AND c.CrewId = @CrewId AND p.RoleId = @RoleId)
			RETURN @Result
		END

--		SELECT Roles.RoleId, COUNT(Roles.RoleId) FROM Roles INNER JOIN People ON Roles.RoleId = People.RoleId INNER JOIN CrewAssignments ON People.PersonId = CrewAssignments.PersonId Group By CrewAssignments.CrewActivationId

--		CrewAssignments ON Roles.RoleId = CrewAssignments.RoleId
--		SELECT *, COUNT(RoleId) FROM CrewAssignments AS t WHERE (t.CrewActivationId = 1 AND RoleId = 1) GROUP BY t.CrewActivationId
--		SELECT COUNT(*) FROM CrewAssignments WHERE (SELECT * FROM CrewAssignments WHERE (CrewActivationId = 1) > 1)
		--delete FROM dbo.CrewAssignments;

ROLLBACK
--COMMIT
