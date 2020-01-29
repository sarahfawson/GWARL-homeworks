USE gwsis;
CREATE DEFINER=`root`@`localhost` PROCEDURE `terminate_student_enrollment`(
-- This procedure accepts four parameters
	StudentID_in varchar(45),
  CourseCode_in varchar(45),
  Section_in varchar(45),
  EndDate_in date
  -- course code, section, student ID, and effective date
)
BEGIN
UPDATE classparticipant
SET EndDate = NOW()
WHERE ID_Class = 
(
	SELECT ID_Class
    FROM Class c
    INNER JOIN Course co 
    ON C.id_Course = co.ID_Course
    WHERE Section = Section_in
    AND co.CourseDescription = CourseName_in
);

END
