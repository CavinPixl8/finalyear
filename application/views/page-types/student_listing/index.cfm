<!---
	This view file has been automatically created by the preside dev tools
	scaffolder. Please fill with meaningful content and remove this comment
--->

<cf_presideparam name="args.title"         field="page.title"        editable="true" />
<cf_presideparam name="args.main_content"  field="page.main_content" editable="true" />


<cfoutput>
	<h1>#args.title#</h1>
	#args.main_content#
	#renderLabel("subject", "74A11EF5-1FCD-4058-877ED804191A6699")#
</cfoutput>