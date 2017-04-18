/**
* @labelField            student
* @dataManagerGridFields student,subject,completed
**/
component dataManagerGroup="studentInfo" {
	property name="student"   relationship="many-to-one" relatedTo="student" required=true;
	property name="subject"   relationship="many-to-one" relatedTo="subject" required=true;
	property name="completed" type="boolean" dbtype="boolean";
}