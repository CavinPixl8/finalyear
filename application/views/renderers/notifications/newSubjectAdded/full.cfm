<cfparam name="args.course_code"  type="string"  default="default course code"/>
<cfparam name="args.label"        type="string"  default="default course name"/>
<cfparam name="args.credit_hours" type="integer" default=0/>
<cfparam name="args.prerequisite" type="string"  default="" />
<cfparam name="args.program"      type="string"  default="" />


<cfoutput>
	<div class="alert alert-danger">
		<h3><i class="fa fa-fw fa-user"></i>
			A new subject has been added to #renderLabel( "program", args.program )#
		</h3>
		<h4> Course code  is #args.course_code# </h4>
		<h4> Course name  is #args.label# </h4>
		<h4> Credit hours is #args.credit_hours# </h4>
		<h4> Prerequisite:
		<cfif len( args.prerequisite )>
			<cfloop list="#args.prerequisite#" item="prereq">
				#renderLabel( "prerequisite" , prereq )# ,
			</cfloop>
		<cfelse>
			<i>this subject has no prerequisites</i>
		</cfif>

		</h4>
	</div>
</cfoutput>