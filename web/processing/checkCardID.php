<?

	include "shared.php";

	$cardid = $_GET['cid'];

	selectDatabase("runnershigh");

	//Check if a card ID exists in the 'Runs' table
	$sql  = "SELECT cardid FROM runs WHERE cardid = '$cardid' LIMIT 1";
	$result = mysqli_query($conn, $sql);
	if (mysqli_fetch_array($result)) {
		echo("1");
	} else {
		echo("0");
	}

?>