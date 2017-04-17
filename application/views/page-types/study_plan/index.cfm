<cfscript>
	var studyPlan  = args.studyPlan              ?: queryNew('');
	var name       = args.studentData.name       ?: "default name";
	var student_id = args.studentData.student_id ?: "default student Id";
</cfscript>

<cfoutput>
	<h1>Study plan for #name# (#student_id#) </h1>

	<cfscript>
		for ( row=1; row LTE arrayLen(studyPlan); row++ ){
			writeOutput( "<h3>Semester ##" & row & "</h3></ul>" );

			for ( col=1; col LTE arrayLen(studyPlan[row]); col++ ){
				writeOutput( "<li>" & studyPlan[row][col] & "</li>" );
			}
			writeOutput("</ul><hr>");
		}
	</cfscript>
</cfoutput>