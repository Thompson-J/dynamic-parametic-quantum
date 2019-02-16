<?

	include "shared.php";

	$password = $_POST['password'];

	selectDatabase("runnershigh");

	if ($password == "password") {

		$sql = "DROP DATABASE runnershigh";
		$result = mysqli_query($conn, $sql);

		echo("Deleted the database.");

	} else {

		echo("Incorrect password, didn't delete the database.");

	}

?>