component extends="coldbox.system.Interceptor" {

	property name="presideObjectService" inject="provider:PresideObjectService";
	property name="notificationService"  inject="provider:notificationService";
	property name="subjectService"       inject="provider:subjectService";
	property name="studentService"       inject="provider:studentService";

	public void function preInsertObjectData( required any event, required struct interceptData ){
		var objectName       = arguments.interceptData.objectName ?: "";
		var id               = arguments.interceptData.id         ?: "";
		var data             = arguments.interceptData.data;

		switch( objectName ){
			case "subject":
				data.course_code = UCase( data.course_code );

				if( !len( subjectService.validateSubjectData( data ) ) && !subjectService.isDuplicatedCourseCode( data.course_code ) ){
					writeDump("all clear");
				}else{
					writeDump( subjectService.validateSubjectData( data ) );
					abort;
				}
			break;
			case "student":
				data.student_id = UCase( data.student_id );
				var studentIdValidation = studentService.isValidStudentId( data=data );

				if ( len( studentIdValidation ) ){
					writeDump(studentIdValidation);abort;
				}
				if ( !studentService.validStudentProgram ( data.program ) ){
					writeDump("only DCSMY is allowed");abort;
				}
			break;
		}
	}

	public void function postInsertObjectData( required any event, required struct interceptData ){
		var objectName   = arguments.interceptData.objectName ?: "";
		var id           = arguments.interceptData.id         ?: "";
		var data         = arguments.interceptData.data;

		switch( objectName ){
			case "subject":

			notificationService.createNotification(
				  topic = "newSubjectAdded"
				, type  = "Info"
				, data  = data
			);

			break;
		}
	}


}