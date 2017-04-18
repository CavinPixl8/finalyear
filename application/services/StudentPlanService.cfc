component {
	/**
	 * @presideObjectService.inject presideObjectService
	 */
	public any function init( required any presideObjectService ) {
		_setPresideObjectService( arguments.presideObjectService );
		return this;
	}

	public array function createStudyPlan( required string student, required string month ) {

		// var incompleteSubjectQuery = _getPresideObjectService().selectData(
		// 	  objectName   = "student_subject_status"
		// 	, selectFields = [ "subject.course_code as course_code", "subject.course_name" ]
		// 	, filter       = { student = arguments.student, completed = false }
		// 	, orderBy      = "course_code"
		// );
		// var subjectArray = [];
		// for ( row in incompleteSubjectQuery ){
		// 	arrayAppend( subjectArray, row.course_code );
		// }
		// var subjectsWithPrereq     = _fillPrerequisite( subjectArray );
		// var rearrangedSubjectArray = _checkPrerequisitePosition ( subjectsWithPrereq );
		// var semesterArray          = _setSemesters( rearrangedSubjectArray, arguments.month );
		// var semesterArray          = _checkPrerequisiteClashInSemester( semesterArray, subjectsWithPrereq );
		// writeDump("checked study plan");writeDump(semesterArray);abort;

		return semesterArray;
	}

	private any function _getPresideObjectService() {
		return variables._presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		variables._presideObjectService = arguments.presideObjectService;
	}

}