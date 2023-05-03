/**
 * Create a new ORM Event Handler in an existing ColdBox application.  Make sure you are running this command in the root
 * of your app for it to find the correct folder.
 * .
 * {code:bash}
 * coldbox create orm-event-handler MyEventHandler --open
 * {code}
 *
 **/
component {

	// DI
	property name="utility"  inject="utility@coldbox-cli";
	property name="settings" inject="box:modulesettings:coldbox-cli";

	/**
	 * @name      Name of the event handler to create without the .cfc. For packages, specify name as 'myPackage/myModel'
	 * @directory The base directory to create your event handler in and creates the directory if it does not exist.
	 * @open      Open the file once generated
	 * @force     Force overwrite of existing files
	 **/
	function run(
		required name,
		directory     = "models",
		boolean open  = false,
		boolean force = false
	){
		// This will make each directory canonical and absolute
		arguments.directory = resolvePath( arguments.directory );

		// Validate directory
		if ( !directoryExists( arguments.directory ) ) {
			directoryCreate( arguments.directory );
		}

		// Allow dot-delimited paths
		arguments.name = replace( arguments.name, ".", "/", "all" );
		// This help readability so the success messages aren't up against the previous command line
		print.line();

		// Read in Template
		var modelContent = fileRead( "#variables.settings.templatePath#/orm/ORMEventHandler.txt" );
		// Write out the model
		var modelPath    = "#directory#/#arguments.name#.cfc";
		// Create dir if it doesn't exist
		directoryCreate( getDirectoryFromPath( modelPath ), true, true );

		// Prompt for override
		if (
			fileExists( modelPath ) && !arguments.force && !confirm(
				"The file '#getFileFromPath( modelPath )#' already exists, overwrite it (y/n)?"
			)
		) {
			print.redLine( "Exiting..." );
			return;
		}

		// Write out the model
		fileWrite( modelPath, trim( modelContent ) );
		print.greenLine( "Created Model: [#modelPath#]" );

		// Open file?
		if ( arguments.open ) {
			openPath( modelPath );
		}
	}

}
