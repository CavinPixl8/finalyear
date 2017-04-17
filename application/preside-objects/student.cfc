/**
* @labelField name
* @dataManagerGridFields student_id,name,email,program
*/
component dataManagerGroup="studentInfo"{
	property name="name"       type="string" dbtype="varchar" required=true;
	property name="student_id" type="string" dbtype="varchar" required=true minlength=8 maxlength=8 uniqueindexes="studentid";
	property name="email"      type="string" dbtype="varchar" required=true;
	property name="program"    relationship="many-to-one"     relatedTo="program" required=true;
}