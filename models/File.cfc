/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * File object abstration for simplied access to the disk API.
 *
 * @author Grant Copley <gcopley@ortussolutions.com>, Luis Majano <lmajano@ortussolutions.com>
 */
component accessors="true" {

	/**
	 * The disk instance that all file operations should be performed on.
	 */
	property name="path";

	/**
	 * The relative path to the file on disk.
	 */
	property name="disk";

	/**
	 * Constructor
	 *
	 * @disk The disk instance that all file operations should be performed on.
	 * @path The relative path to the file on disk.
	 *
	 * @return File
	 */
	function init( required disk, required path ){
		setDisk( arguments.disk );
		setPath( arguments.path );
		return this;
	}

	/**
	 * Create a file in the disk
	 *
	 * @contents   The contents of the file to store
	 * @visibility The storage visibility of the file, available options are `public, private, readonly` or a custom data type the implemented driver can interpret
	 * @metadata   Struct of metadata to store with the file
	 * @overwrite  Flag to overwrite the file at the destination, if it exists. Defaults to true.
	 * @mode       Applies to *nix systems. If passed, it overrides the visbility argument and uses these octal values instead
	 *
	 * @return File
	 *
	 * @throws cbfs.FileOverrideException - When a file exists and no override has been provided
	 */
	function create(
		required contents,
		string visibility,
		struct metadata   = {},
		boolean overwrite = true,
		string mode
	){
		arguments.path = getPath();
		getDisk().create( argumentCollection = arguments );
		return this;
	}

	/**
	 * Set the storage visibility of a file, available options are `public, private, readonly` or a custom data type the implemented driver can interpret
	 *
	 * @visibility The storage visibility of the file, available options are `public, private, readonly` or a custom data type the implemented driver can interpret
	 *
	 * @return File
	 */
	function setVisibility( required string visibility ){
		arguments.path = getPath();
		getDisk().setVisibility( argumentCollection = arguments );
		return this;
	};

	/**
	 * Get the storage visibility of a file, the return format can be a string of `public, private, readonly` or a custom data type the implemented driver can interpret.
	 *
	 * @return String
	 */
	public string function visibility(){
		return getDisk().visibility( getpath() );
	};

	/**
	 * Prepend contents to the beginning of a file. This is a very expensive operation for local disk storage.
	 *
	 * @contents       The contents of the file to prepend
	 * @metadata       Struct of metadata to store with the file
	 * @throwOnMissing Boolean flag to throw if the file is missing. Otherwise it will be created if missing.
	 *
	 * @return File
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	function prepend(
		required contents,
		struct metadata        = {},
		boolean throwOnMissing = false
	){
		arguments.path = getPath();
		getDisk().prepend( argumentCollection = arguments );
		return this;
	}

	/**
	 * Append contents to the end of a file
	 *
	 * @contents       The contents of the file to append
	 * @metadata       Struct of metadata to store with the file
	 * @throwOnMissing Boolean flag to throw if the file is missing. Otherwise it will be created if missing.
	 *
	 * @return File
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	function append(
		required contents,
		struct metadata        = {},
		boolean throwOnMissing = false
	){
		arguments.path = getPath();
		getDisk().append( argumentCollection = arguments );
		return this;
	}

	/**
	 * Copy a file from one destination to another
	 *
	 * @destination The end destination path
	 * @overwrite   Flag to overwrite the file at the destination, if it exists. Defaults to true.
	 *
	 * @return File  - returns the copied file object
	 *
	 * @throws cbfs.FileNotFoundException - When the source doesn't exist
	 * @throws cbfs.FileOverrideException - When the destination exists and no override has been provided
	 */
	function copy( required destination, boolean overwrite = true ){
		arguments.source = getPath();
		getDisk().copy( argumentCollection = arguments );
		return new File( disk = getDisk(), path = arguments.destination );
	}

	/**
	 * Move a file from one destination to another
	 *
	 * @destination The end destination path
	 *
	 * @return File - the moved file object
	 *
	 * @throws cbfs.FileNotFoundException - When the source doesn't exist
	 * @throws cbfs.FileOverrideException - When the destination exists and no override has been provided
	 */
	function move( required destination, boolean overwrite = true ){
		arguments.source = getPath();
		getDisk().move( argumentCollection = arguments );
		return new File( disk = getDisk(), path = arguments.destination );
	}

	/**
	 * Get the contents of a file
	 *
	 * @return The contents of the file
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	any function get(){
		return getDisk().get( getPath() );
	}

	/**
	 * Delete a file or an array of file paths. If a file does not exist a `false` will be shown for it's return.
	 *
	 * @throwOnMissing Boolean to throw an exception if the file is missing.
	 *
	 * @return boolean or struct report of deletion
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	public boolean function delete( boolean throwOnMissing = false ){
		arguments.path = getPath();
		return getDisk().delete( argumentCollection = arguments );
	}

	/**
	 * Download a file to the browser
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	string function download(){
		return getDisk().download( getPath() );
	}

	/**
	 * Create a new empty file if it does not exist
	 *
	 * @createPath if set to false, expects all parent directories to exist, true will generate necessary directories. Defaults to true.
	 *
	 * @return File
	 *
	 * @throws cbfs.PathNotFoundException
	 */
	function touch( boolean createPath = true ){
		arguments.path = getPath();
		getDisk().touch( argumentCollection = arguments );
		return this;
	}

	/**
	 * Returns the size of a file (in bytes). The size may differ from the actual size on the file system due to compression, support for sparse files, or other reasons.
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	numeric function size(){
		arguments.path = getPath();
		return getDisk().size( argumentCollection = arguments );
	}

	/**
	 * Retrieve the file's last modified timestamp
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	function lastModified(){
		arguments.path = getPath();
		return getDisk().lastModified( argumentCollection = arguments );
	}

	/**
	 * Retrieve the file's mimetype
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	function mimeType(){
		arguments.path = getPath();
		return getDisk().mimeType( argumentCollection = arguments );
	}

	/**
	 * Return information about the file.  Will contain keys such as lastModified, size, path, name, type, canWrite, canRead, isHidden and more
	 * depending on the provider used
	 *
	 * @return A struct of file metadata according to provider
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	struct function info(){
		arguments.path = getPath();
		return getDisk().info( argumentCollection = arguments );
	}

	/**
	 * Generate checksum for a file in different hashing algorithms
	 *
	 * @algorithm Default is MD5, but SHA-1, SHA-256, and SHA-512 can also be used.
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	string function checksum( algorithm = "MD5" ){
		arguments.path = getPath();
		return getDisk().checksum( argumentCollection = arguments );
	}

	/**
	 * Extract the extension from the file path
	 */
	string function extension(){
		arguments.path = getPath();
		return getDisk().extension( argumentCollection = arguments );
	}

	/**
	 * Returns the name of the file
	 */
	string function name(){
		return getDisk().name( getPath() );
	}

	/**
	 * Sets the access attributes of the file on Unix based disks
	 *
	 * @mode Access mode, the same attributes you use for the Linux command `chmod`
	 *
	 * @return File
	 */
	function chmod( required string mode ){
		arguments.path = getPath();
		getDisk().chmod( argumentCollection = arguments );
		return this;
	}

	/**
	 * Is the path writable or not
	 *
	 * @return Boolean
	 */
	boolean function isWritable(){
		arguments.path = getPath();
		return getDisk().isWritable( argumentCollection = arguments );
	}

	/**
	 * Is the path readable or not
	 *
	 * @return Boolean
	 */
	boolean function isReadable(){
		arguments.path = getPath();
		return getDisk().isReadable( argumentCollection = arguments );
	}

	/**
	 * Is the file executable or not
	 *
	 * @return Boolean
	 *
	 * @throws cbfs.FileNotFoundException - If the filepath is missing
	 */
	boolean function isExecutable(){
		arguments.path = getPath();
		return getDisk().isExecutable( argumentCollection = arguments );
	}

	/**
	 * Is the file is hidden or not
	 *
	 * @return Boolean
	 *
	 * @throws cbfs.FileNotFoundException - If the filepath is missing
	 */
	boolean function isHidden(){
		arguments.path = getPath();
		return getDisk().isHidden( argumentCollection = arguments );
	}

	/**
	 * Is the file is a symbolic link
	 *
	 * @return Boolean
	 *
	 * @throws cbfs.FileNotFoundException - If the filepath is missing
	 */
	boolean function isSymbolicLink(){
		arguments.path = getPath();
		return getDisk().isSymbolicLink( argumentCollection = arguments );
	}

	/**
	 * Get the URL for this file.
	 *
	 * @throws cbfs.FileNotFoundException
	 */
	string function url(){
		return getDisk().url( getPath() );
	}

	/**
	 * Get a temporary url for the given file
	 *
	 * @expiration The number of minutes this url should be valid for. Defaults to 60 minutes
	 */
	string function temporaryUrl( numeric expiration = 60 ){
		// TODO: Build out a proxy method on the module to validate these.
		return this.url( getPath() ) & "?expiration=#arguments.expiration#";
	}

	/**
	 * Validate if a file exists
	 *
	 * @path  The file path to verify
	 * @force If set to true, it will force the disk to check for the file. Otherwise, it will use the internal cache of the disk.
	 */
	boolean function exists( force = true ){
		return getDisk().exists( getPath(), arguments.force );
	}

	/**
	 * Return a Java stream of the file using non-blocking IO classes. The stream will represent every line in the file so you can navigate through it.
	 * This method leverages the `cbstreams` library used accordingly by implementations (https://www.forgebox.io/view/cbstreams)
	 *
	 * @return Stream object: See https://apidocs.ortussolutions.com/coldbox-modules/cbstreams/1.1.0/index.html
	 */
	function stream(){
		arguments.path = getPath();
		return getDisk().stream( argumentCollection = arguments );
	};

	/**
	 * Create a file in the disk from a file path
	 *
	 * @source       The source file path to copy from
	 * @visibility   The storage visibility of the file, available options are `public, private, readonly` or a custom data type the implemented driver can interpret
	 * @overwrite    Flag to overwrite the file at the destination, if it exists. Defaults to true.
	 * @deleteSource Flag to remove the source file upon creation in the disk.  Defaults to false.
	 *
	 * @return cbfs.models.IDisk
	 *
	 * @throws cbfs.FileOverrideException - When a file exists and no override has been provided
	 */
	function createFromFile(
		required source,
		string visibility    = variables.properties.visibility,
		boolean overwrite    = true,
		boolean deleteSource = false
	){
		arguments.name      = this.name();
		arguments.directory = getDirectoryFromPath( getPath() );
		getDisk().createFromFile( argumentCollection = arguments );
		return this;
	}

}
