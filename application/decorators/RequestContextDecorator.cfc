component extends="preside.system.coldboxModifications.RequestContextDecorator" {

	public boolean function isRegisteredStudent( string id="" ){

		return getModel( "presideObjectService" ).dataExists(
			  objectName = "student"
			, filter     = { "id"=arguments.id }
		);
	}
}