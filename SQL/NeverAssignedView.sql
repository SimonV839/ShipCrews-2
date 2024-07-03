

	   ---------------------------------------------------
       -- Create a view 'NeverAssignedPeople'
	   CREATE VIEW NeverAssignedPeople AS
			SELECT p.FirstName, p.LastName
			FROM People p
			WHERE p.PersonId NOT IN (SELECT PersonId FROM CrewAssignments)


		-- SELECT * FROM NeverAssignedPeople
		-- SELECT * FROM CrewAssignments
		-- SELECT * FROM People
		-- SELECT PersonId FROM CrewAssignments
		-- SELECT p.FistName, p.LastName
			-- FROM People p 
			-- WHERE p.PersonId NOT IN (3)
		-- SELECT *
			-- FROM People p 
			-- WHERE p.PersonId NOT IN (SELECT PersonId FROM CrewAssignments)