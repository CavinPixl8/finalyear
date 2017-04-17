component {
	/**
	 * @presideObjectService.inject presideObjectService
	 */
	public any function init( required any presideObjectService ) {
		_setPresideObjectService( arguments.presideObjectService );
		return this;
	}

	public query function getAllStudentData( string program="" ) {

		var filter = "1=1"
		if ( len( arguments.program ) ){
			filter = { "program.label" = arguments.program }
		}

		return _getPresideObjectService().selectData(
			  objectName   = "student"
			, selectFields = [ "id", "name", "student_id", "email", "program.label as program" ]
			, filter       = filter
		);
	}

	public query function getAllPrograms() {
		return _getPresideObjectService().selectData(
			  objectName   = "program"
			, selectFields = [ "label" ]
		);
	}

	public query function getStudentDataById( required string id ) {
		return _getPresideObjectService().selectData(
			  objectName   = "student"
			, filter       = { "id"=arguments.id }
			, selectFields = [ "id", "name", "student_id", "email", "program" ]
		);
	}

	public void function setStudentSubjectStatus( required string studentObjectId, required string subject ){

		_getPresideObjectService().insertData(
			  objectName = "student_subject_status"
			, data = {
				  student   = arguments.studentObjectId
				, subject   = arguments.subject
				, completed = 0
			  }
			, insertManyToManyRecords = true
		)
	}

	public query function getStudentSubjectStatus( required string studentObjectId ) {

		return _getPresideObjectService().selectData(
			  objectName   = "student_subject_status"
			, filter       = { "student"=arguments.studentObjectId }
			, selectFields = [ "course_name as subject", "course_code", "completed" ]
			, orderBy      = "subject.course_code ASC"
		);
	}

	public string function isValidStudentId( required struct data ){

		if ( not isValid( "regex", data.student_id, "\b[C][0-9]{7}\b" ) ){
			return "wrong student ID format";
		}

		var studentIdListQuery = _getPresideObjectService().selectData(
			  objectName   = "student"
			, selectFields = [ "student_id" ]
		)

		if ( listFindNoCase( valueList( studentIdListQuery.student_id ), data.student_id ) ){
			return "duplicate student ID";
		}

		return "";
	}

	public boolean function validStudentProgram ( required string program ){
		var programQuery = _getPresideObjectService().selectData(
			  objectName   = "program"
			, id           = arguments.program
			, selectFields = [ "shortname" ]
		);

		if ( programQuery.shortname != "DCSMY"){
			return false;
		}
		return true;
	}

	public void function deleteStudentSubjectStatusData( required string student ){
		_getPresideObjectService().deleteData(
			  objectName = "student_subject_status"
			, filter     = { "student" = arguments.student }
		);
	}

	private any function _getPresideObjectService() {
		return variables._presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		variables._presideObjectService = arguments.presideObjectService;
	}

}