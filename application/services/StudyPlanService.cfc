component {
	/**
	 * @presideObjectService.inject presideObjectService
	 */
	public any function init( required any presideObjectService ) {
		_setPresideObjectService( arguments.presideObjectService );
		return this;
	}

	public array function createStudyPlan( required string student, required string month ) {

		var incompleteSubjectQuery = _getPresideObjectService().selectData(
			  objectName   = "student_subject_status"
			, selectFields = [ "subject.course_code as course_code", "subject.course_name" ]
			, filter       = { student = arguments.student, completed = false }
			, orderBy      = "course_code"
		);
		var subjectArray = [];
		for ( var row in incompleteSubjectQuery ){
			arrayAppend( subjectArray, row.course_code );
		}
		var subjectsWithPrereq     = _fillPrerequisite( subjectArray );
		var rearrangedSubjectArray = _checkPrerequisitePosition ( subjectsWithPrereq );
		var semesterArray          = _setSemesters( rearrangedSubjectArray, arguments.month );
		var args.semesterArray     = _checkPrerequisiteClashInSemester( semesterArray, subjectsWithPrereq );

		return args.semesterArray;
	}

	private array function _fillPrerequisite( required array subjectArray ){
		var outerArray = [];
		for ( var i=1; i LTE arrayLen( arguments.subjectArray ); i+=1 ) {
			var innerArray = [];
			var prereqQuery = _getPrerequisites( arguments.subjectArray[i] )

			arrayAppend( innerArray, arguments.subjectArray[i] );
			for ( var row in prereqQuery){
				arrayAppend( innerArray, prereqQuery.course_code);
			}
			for ( var length=arrayLen( innerArray ); length LT 4; length++){
				arrayAppend( innerArray, "" );
			}
			arrayAppend( outerArray, innerArray );
		}
		return outerArray;
	}

	private query function _getPrerequisites ( required string subjectId ){
		var filter = { "subject.course_code" = arguments.subjectId };

		return _getPresideObjectService().selectManyToManyData(
				  objectName   = "subject"
				, propertyName = "prerequisite"
				, filter       = filter
		);

	}
	private array function _checkPrerequisitePosition( required array subjectArray ){
		var subjectArray = arguments.subjectArray;
		var returnArray  = duplicate( arguments.subjectArray );
		for ( var i = arrayLen( subjectArray ); i GT 1; i-- ){
			if ( subjectArray[i][2]==subjectArray[i-1][1] ){
				if ( i==arrayLen( subjectArray ) ){
					subjectArray = _swapPositionInArray ( subjectArray, i-1, i-2 );
				}
				else{
					subjectArray = _swapPositionInArray ( subjectArray, i, i+1 );
				}

				returnArray = _checkPrerequisitePosition( subjectArray );
				break;
			}
		}
		return returnArray;
	}
	private array function _swapPositionInArray( required array arrayToSwap, required numeric position1, required numeric position2 ){
		var targetArray = duplicate( arguments.arrayToSwap );
		var buffer = [];

		for ( var i=1; i LTE arrayLen( targetArray[arguments.position1] ); i++ ){
			buffer[i]                           = targetArray[arguments.position1][i];
			targetArray[arguments.position1][i] = targetArray[arguments.position2][i];
			targetArray[arguments.position2][i] = buffer[i];
		}
		return targetArray;
	}
	private array function _setSemesters( required array subjectArray, required string month ){
		var subjectArray  = duplicate( arguments.subjectArray );
		var month         = LCase( arguments.month );
		var subjectCount  = 0;
		var semesterArray = [];
		var buffer        = [];

		for ( i=1; i LTE arrayLen(subjectArray); i++ ){

			switch( month ){
				case "january":

					var subjectLimit      = 3;
					var specialCourseCode = "ENL";
				break;
				default:

					var subjectLimit      = 5;
					var specialCourseCode = "MPU";
			}

			if( subjectCount == 0 ){
				for ( j=i; j LTE arrayLen( subjectArray ); j++ ){
					if ( findNoCase( specialCourseCode, subjectArray[j][1] ) ){
						arrayAppend( buffer, subjectArray[j][1] );
						subjectCount++;
						subjectArray[j][1] = "";
						break;
					}
				}
			}

			if( subjectCount < subjectLimit && len(subjectArray[i][1]) ){
				arrayAppend( buffer, subjectArray[i][1] );
				subjectCount++;
			}

			if( subjectCount == 4 ){
				for ( j=i; j LTE arrayLen( subjectArray ); j++ ){
					if ( findNoCase( "MTH", subjectArray[j][1] ) ){
						arrayAppend( buffer, subjectArray[j][1] );
						subjectCount++;
						subjectArray[j][1] = "";
						break;
					}
				}
			}

			if ( subjectCount == subjectLimit OR i == arrayLen(subjectArray) && arrayLen( buffer ) ){
				arrayAppend( semesterArray, buffer );
				buffer       = [];
				month        = _changeMonth( month );
				subjectCount = 0;
			}
		}
		return semesterArray;
	}
	private string function _changeMonth( required string month ){

		if ( arguments.month == "january" ){
			var nextMonth = "april";
		}else if ( arguments.month == "april" ){
			var nextMonth = "august";
		}else{
			var nextMonth = "january";
		}

		return nextMonth;
	}
	private array function _checkPrerequisiteClashInSemester ( required array semesterArray, required array subjectArray ){
		var semesterArray = duplicate( arguments.semesterArray );
		var subjectArray  = duplicate( arguments.subjectArray );
		var returnArray   = duplicate( arguments.semesterArray );

		for ( var x = arrayLen( semesterArray ); x GT 1; x-- ){
			for ( var y = arrayLen( semesterArray[x] ); y GT 1; y-- ){

				var prerequisite = "";
				var courseCode   = semesterArray[x][y];
				var z=0;
				while( z++ LT arrayLen( subjectArray ) ){
					if ( subjectArray[z][1] == courseCode ){
						prerequisite = subjectArray[z][2];
						break;
					}
				}
				if ( len( prerequisite ) ){
					for ( w = y - 1; w GT 0; w-- ){
						if ( semesterArray[x][w] == prerequisite ){
							returnArray = _rearrangeSubjectsInSemesters( returnArray, x, y, w, subjectArray );
						}
					}
				}
			}
		}
		return returnArray;
	}
	private array function _rearrangeSubjectsInSemesters(
		  required array   semesterArray
		, required numeric clashSemester
		, required numeric subjectPosition
		, required numeric prereqPosition
		, required array   subjectArray
	){
		var semesterArray = duplicate( arguments.semesterArray );
		var c_s           = arguments.clashSemester;
		var s_p           = arguments.subjectPosition;
		var p_p           = arguments.subjectPosition;
		var subjectArray  = duplicate( arguments.subjectArray );
		var returnArray   = duplicate( arguments.semesterArray );
		var buffer        = "";
//check if clash in last semester
		if ( c_s == arrayLen( semesterArray ) ){
			for ( var row = c_s; row GT 1; row -- ){
				for ( var col = 0; col LTE arrayLen( semesterArray[row] ); col++ ){
					//move prerequisite into previous semester.
					if ( _isFinalSemSubject( semesterArray[row][col], subjectArray ) ){
						buffer                = returnArray[c_s][p_p];
						returnArray[c_s][p_p] = returnArray[row][col];
						returnArray[row][col] = buffer;
						break;
					}
				}
			}
		}else if ( c_s == 1 && arrayLen( semesterArray ) > 4 ){
		//if clash in first semester && number of semestsers > 4
			for ( var row = c_s + 1; row LTE arrayLen( semesterArray ); row++ ){
				for ( var col = 1; col LTE arrayLen( semesterArray[row] ); col++ ){

					if ( _isFirstSemSubject( semesterArray[row][col], subjectArray ) ){
						//move subject into later semester
						buffer                  = semesterArray[c_s][s_p];
						semesterArray[c_s][s_p] = semesterArray[row][col];
						semesterArray[row][col] = buffer;
						break;
					}
				}
			}
			//if clash other than last or first semester,
		}else{
			//swap swith safe subjects
			buffer                  = semesterArray[c_s][s_p];
			semesterArray[c_s][s_p] = semesterArray[c_s+1][1];
			semesterArray[c_s+1][1] = buffer;
		}
		return semesterArray;
	}
	private boolean function _isFinalSemSubject( required string courseCode, required array subjectArray ){
		var courseCode   = arguments.courseCode;
		var subjectArray = duplicate( arguments.subjectArray );
		var status = true;

		if ( findNoCase( "CSC", courseCode ) ){
			for ( i = 1; i LTE arrayLen( subjectArray ); i++ ){
				if (   subjectArray[i][2]==courseCode
					OR subjectArray[i][3]==courseCode
					OR subjectArray[i][4]==courseCode
				){
					status = false;
					break;
				}
			}
		}else{
			status = false;
		}
		return status;
	}
	private boolean function _isFirstSemSubject( required string courseCode, required array subjectArray ){
		var courseCode   = arguments.courseCode;
		var subjectArray = duplicate( arguments.subjectArray);
		var status = false;

		if ( !findNoCase( "MPU", courseCode ) ){
			for ( i = 1; i LTE arrayLen( subjectArray ); i++ ){
				//if course code does not have a prerequisite
				if ( subjectArray[i][1]==courseCode && subjectArray[i][2]=="" ){
					status = true;
					break;
				}
			}
		}
		return status;
	}
	private any function _getPresideObjectService() {
		return _presideObjectService;
	}
	private void function _setPresideObjectService( required any presideObjectService ) {
		_presideObjectService = arguments.presideObjectService;
	}

}