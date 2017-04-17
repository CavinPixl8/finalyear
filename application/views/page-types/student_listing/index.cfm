<cfscript>
	var studentData     = args.studentData    ?: queryNew('');
	var programList     = args.programList    ?: "";
	var selectedProgram = rc.program          ?: "";
</cfscript>

<cfoutput>
	<h1>Student listing page </h1>

	<cfif studentData.recordCount >
		<form name="filter" action="#event.buildLink()#">
			<select name="program">
				<option value="" >All Programs</option>
				<cfloop list="#programList#" index="program">
					<option value="#program#" <cfif selectedProgram == program>selected</cfif> >
						#program#
					</option>
				</cfloop>
			</select>
			<input type="submit" value="Filter Program" />
		</form>

		<cfloop query="#studentData#">
			<h3> <a href="#event.buildLink( page='subject_status_listing', querystring='student=#studentData.id#' )#">
				#studentData.name# (#studentData.student_id#)
			</a></h3>
			<p> #studentData.email# </p>
		</cfloop>

	<cfelse>
		<h2>No student record found</h2>
	</cfif>

</cfoutput>