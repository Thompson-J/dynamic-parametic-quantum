<?

	function selectDatabase($database) {

		global $conn;
		$servername = "";
		$username = "";
		$password = "";
		$port = "";

		// Create connection
		$conn = mysqli_connect("$servername", "$username", "$password", "", "$port");

		// Check connection
		if (!$conn) {
		    die("Connection failed: " . mysqli_connect_error());
		}
		//echo "Connected successfully";

		// Create database
		$sql = "CREATE DATABASE $database";
		if (mysqli_query($conn, $sql)) {
		    //echo "Database created successfully";
		} else {
		    //echo "Error creating database: " . mysqli_error($conn);
		}

		$conn = mysqli_connect("$servername", "$username", "$password", "$database", "$port");

	}

?>