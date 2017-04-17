<cfscript>
	var id            = args.studentData.id         ?: "";
	var name          = args.studentData.name       ?: "default name";
	var studentId     = args.studentData.student_id ?: "default student Id";
	var email         = args.studentData.email      ?: "default email";
	var program       = "default program"
	var subjectStatus = args.subjectStatusArray     ?: [];

	if ( len( args.studentData.program ?: "" ) ){
		program = renderLabel( "program", args.studentData.program )
	}
</cfscript>

<cfoutput>
	<h2> Subject Status Page </h2>
	<h3> #name# (#studentId#)  <sub> Email address: #email# </sub> </h3>
	<hr />
	<table class="table table-striped">
		<thead>
			<tr>
				<th> Course Code </th>
				<th> Course Name </th>
				<th> Completion Status </th>
			</tr>
		</thead>
		<cfscript>
			for ( i=1; i LTE arrayLen( subjectStatus ); i+=1 ) {
				writeOutput("<tr>")
				for ( j=1; j LTE arrayLen( subjectStatus[ i ] ); j+=1 ) {
					WriteOutput( "<td>" & subjectStatus[ i ][ j ] & "</td>" );
				}
				writeOutput("</tr>")
			}
		</cfscript>
	</table>
	<form name="plan" action="#event.buildLink( page='study_plan' )#" method="post">
		<h3>Study plan start:</h3>

		<select name="month">
			<option value="january"> January </option>
			<option value="april">   April   </option>
			<option value="august">  August  </option>
		</select>
		<input type="hidden" value="#args.studentData.id#" name="student"/>
		<input type="submit" value="Generate!" />
	</form>
</cfoutput>