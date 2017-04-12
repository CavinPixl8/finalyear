component {
	/**
	 * @presideObjectService.inject presideObjectService
	 */
	public any function init( required any presideObjectService ) {
		_setPresideObjectService( arguments.presideObjectService );
		return this;
	}

	public query function getAllStudentsFromProgram( required string program ) {
		return _getPresideObjectService().selectData(
			  objectName   = "student"
			, selectFields = [ "name", "student_id", "email" ]
			, filter       = { "program" = arguments.program }
		);
	}
	public query function getStudentDataById( required string id ) {
		return _getPresideObjectService().selectData(
			  objectName   = "student"
			, id           = arguments.id
			, selectFields = [ "name", "student_id", "email" ]
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
		)

		if ( programQuery.shortname != "DCSMY"){
			return false;
		}
		return true;
	}

	private any function _getPresideObjectService() {
		return variables._presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		variables._presideObjectService = arguments.presideObjectService;
	}

}