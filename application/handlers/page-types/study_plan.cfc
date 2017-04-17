component {
	property name="studentService"   inject="StudentService";
	property name="subjectService"   inject="SubjectService";
	property name="studyPlanService" inject="StudyPlanService";

	private function index( event, rc, prc, args={} ) {

		if ( event.isRegisteredStudent( rc.student ?: "" ) ) {
			args.studentData = studentService.getStudentDataById( rc.student );
			semesterArray    = studyPlanService.createStudyPlan( rc.student, rc.month );
			args.studyPlan   = [];
			var buffer = [];

			for ( var row = 1; row LTE arrayLen( semesterArray ); row++ ){
				for ( var col = 1; col LTE arrayLen( semesterArray[row] ); col++ ){
					arrayAppend( buffer, subjectService.getCourseNameByCourseCode( semesterArray[row][col] ) )
				}
				arrayAppend( args.studyPlan, buffer );
				buffer = [];
			}

			return renderView(
				  view          = 'page-types/study_plan/index'
				, args          = args
			);
		}else{
			setNextEvent(
				url = event.buildLink( page="student_listing" )
			);
		}
	}
}
