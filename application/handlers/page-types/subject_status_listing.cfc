component {
	property name="studentService" inject="StudentService";
	property name="subjectService" inject="SubjectService";

	private function index( event, rc, prc, args={} ) {

		if ( event.isRegisteredStudent( rc.student ?: "" ) ) {

			args.studentData    = studentService.getStudentDataById( id = rc.student );
			subjectStatusQuery  = studentService.getStudentSubjectStatus ( studentObjectId = args.studentData.id );
			args.subjectStatusArray = [];
			for (row in subjectStatusQuery ){
				if ( row.completed ){
					var status="<b>Completed</b>";
				}else{
					var status="<i>Incomplete</i>";
				}
				arrayAppend( args.subjectStatusArray, [ row.course_code, row.subject, status] );
			}

			return renderView(
				  view = 'page-types/subject_status_listing/index'
				, args = args
			);
		}
		else{
			setNextEvent(
				url = event.buildLink( page="student_listing" )
			);
		}
	}
}
