component {

	private string function datatable( event, rc, prc, args={} ) {

		return "A new subject was added to " & renderLabel ( "program", args.program );
	}

	private string function full( event, rc, prc, args={} ) {

		return renderView(
			  view = "/renderers/notifications/newStudentAdded/full"
			, args = args
		);
	}

}