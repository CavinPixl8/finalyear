component {

	private string function datatable( event, rc, prc, args={} ) {

		return "A new student for " & renderLabel ( "program", args.program ) & " was added to the website.";
	}

	private string function full( event, rc, prc, args={} ) {

		return renderView(
			  view = "/renderers/notifications/newStudentAdded/full"
			, args = args
		);
	}

}