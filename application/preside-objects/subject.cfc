/**
* @labelField course_name
* @dataManagerGridFields course_code,course_name,credit_hours,prerequisite,program
**/

component dataManagerGroup="programsAndSubjects" {
	property name="course_code"  type="string"  dbtype="varchar" required=true maxLength="8";
	property name="course_name"  type="string"  dbtype="varchar" required=true;
	property name="credit_hours" type="numeric" dbtype="integer" required=true maxLength="1";
	property name="prerequisite" relationship="many-to-many"     relatedTo="prerequisite" quickadd="true" quickedit="true";
	property name="program"      relationship="many-to-one"      relatedTo="program" required=true;
}