component extends="preside.system.config.Config" {

	public void function configure() {
		super.configure();

		settings.preside_admin_path  = "finalyear_admin";
		settings.system_users        = "sysadmin";
		settings.default_locale      = "en";

		settings.default_log_name    = "finalyear";
		settings.default_log_level   = "information";
		settings.sql_log_name        = "finalyear";
		settings.sql_log_level       = "information";

		settings.ckeditor.defaults.stylesheets.append( "css-bootstrap" );
		settings.ckeditor.defaults.stylesheets.append( "css-layout" );

		settings.features.websiteUsers.enabled = true;

		_setupInterceptors();

		settings.notificationTopics.append( "newSubjectAdded" );
		settings.notificationTopics.append( "newStudentAdded" );

		coldbox.requestContextDecorator = "app.decorators.RequestContextDecorator";
	}

	private void function _setupInterceptors(){

		interceptors.append( { class="app.interceptors.DataChangeInterceptor", properties={} } );
	}
}
