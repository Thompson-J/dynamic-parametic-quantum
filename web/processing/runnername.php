<?

	include "shared.php";

	$cardid = $_GET['cid'];

	selectDatabase("runnershigh");

	$sql = "SELECT runnerid FROM runs WHERE cardid = '$cardid' ORDER BY id DESC LIMIT 1";
	$result = mysqli_query($conn, $sql);

	if($row = mysqli_fetch_assoc($result)) {

		$runnerid = $row["runnerid"];

	}

	$sql = "SELECT runnername FROM users WHERE id = '$runnerid' LIMIT 1";
	$result = mysqli_query($conn, $sql);

	if($row = mysqli_fetch_assoc($result)) {

		$runnername = $row["runnername"];
		echo("$runnername");

	}

?>