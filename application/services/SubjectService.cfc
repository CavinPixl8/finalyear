component {
	/**
	 * @presideObjectService.inject presideObjectService
	 */
	public any function init( required any presideObjectService ) {
		_setPresideObjectService( arguments.presideObjectService );
		return this;
	}

	public query function getSubjectDataById( required string id ) {
		return _getPresideObjectService().selectData(
			  objectName   = "subject"
			, id           = arguments.id
			, selectFields = [ "course_code", "label", "credit_hours", "prerequisite", "program" ]
		);
	}

	public string function validateSubjectData( required struct data ){

		var programQuery = _getPresideObjectService().selectData(
			  objectName   = "program"
			, id           = arguments.data.program
			, selectFields = [ "shortname" ]
		)

		if ( not isValid( "regex", arguments.data.course_code, "\b[A-Z]{3}\s[0-9]{4}\b" ) ){
			return "wrong course code format";
		}
		if ( arguments.data.credit_hours < 2 OR arguments.data.credit_hours > 4 ){
			return "invalid credit hours"
		}
		if ( programQuery.shortname != "DCSMY"){
			return "only DCSMY accepted for now";
		}

		return "";
	}

	public boolean function isDuplicatedCourseCode( required string course_code ){

		var subjectList = _getPresideObjectService().selectData(
			  objectName   = "subject"
			, selectFields = [ "course_code" ]
		);

		if ( listFindNoCase( valueList( subjectList.course_code ), arguments.course_code ) ){
			writeDump("duplicate course code");abort;
			return true;
		}

		return false;
	}

	private any function _getPresideObjectService() {
		return variables._presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		variables._presideObjectService = arguments.presideObjectService;
	}

}