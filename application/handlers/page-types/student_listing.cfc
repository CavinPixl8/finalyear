component {
	property name="studentService" inject="StudentService";

	private function index( event, rc, prc, args={} ) {

		var program   = rc.program   ?: "";

		args.studentData = studentService.getAllStudentData( program=program );
		args.programList = valueList ( studentService.getAllPrograms().label );

		return renderView(
			  view  = 'page-types/student_listing/index'
			, args  = args
		);
	}

}
