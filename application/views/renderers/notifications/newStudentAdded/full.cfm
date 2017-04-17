<cfparam name="args.name"       type="string"  default="default name"/>
<cfparam name="args.student_id" type="string"  default="default studentId"/>
<cfparam name="args.email"      type="string"  default="default email address"/>
<cfparam name="args.program"    type="string"  default="default program" />


<cfoutput>
	<div class="alert alert-danger">
		<h3><i class="fa fa-fw fa-user"></i>
			A new student has enroleld for #renderLabel( "program", args.program )#
		</h3>
		<h4> Student name  is #args.name# </h4>
		<h4> Student ID    is #args.student_id# </h4>
		<h4> Email address is #args.email# </h4>
		<h3>
			#renderLabel( "program", args.program )# subjects status has been generated into student_subject_status object.
		</h3>
	</div>
</cfoutput>