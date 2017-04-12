/**
* @labelField course_name
* @dataManagerGridFields course_code,course_name
**/
component dataManagerGroup="programsAndSubjects" {
	property name="course_code"  type="string"  dbtype="varchar" required=true maxLength="8" uniqueindexes="course_code";
	property name="course_name"  type="string"  dbtype="varchar" required=true;
}