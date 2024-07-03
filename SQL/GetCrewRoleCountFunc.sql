       --USE ShipCrews

	   --DROP FUNCTION GetCrewRoleCountFunc
	   CREATE FUNCTION GetCrewRoleCountFunc 
		(@CrewId INT, @RoleId INT)
		RETURNS INT
		AS
		BEGIN
			DECLARE @Result AS INT=0
			SET @Result = (SELECT COUNT(*) FROM CrewAssignments c, People  p WHERE c.PersonId = p.PersonId AND p.RoleId = @RoleId AND c.CrewId = @CrewId)
			RETURN @Result
		END

		--delete from CrewAssignments  where PersonId=10
		--delete from CrewAssignments
		--delete from People

		--ALTER TABLE CrewAssignments
		--DROP CONSTRAINT CheckSkipper
		--USE ShipCrews

		ALTER TABLE CrewAssignments 
		ADD CONSTRAINT CheckSkipper
		CHECK (dbo.GetCrewRoleCountFunc(CrewId,1) <= 1)