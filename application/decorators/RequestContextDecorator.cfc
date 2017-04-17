component extends="preside.system.coldboxModifications.RequestContextDecorator" {

	public boolean function isRegisteredStudent( string id="" ){

		var studentQuery = getModel( "presideObjectService" ).selectData(
			  objectName   = "student"
			, selectFields = [ "student_id", "name" ]
			, filter       = { "id"=arguments.id }
		);

		if ( studentQuery.recordCount() ){
			return true;
		}
		return false;
	}
}