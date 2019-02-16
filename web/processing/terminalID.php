<?

	include "shared.php";

	if(!$_GET['cid'] == ""){

		$cardid = $_GET['cid'];

		selectDatabase("runnershigh");

		//Look for the lastest cardid row in the 'Runs' table and echo the 'terminalid' entry
		$sql = "SELECT terminalid FROM runs WHERE cardid = '$cardid' ORDER BY id DESC LIMIT 1";
		$result = mysqli_query($conn, $sql);

		$row = mysqli_fetch_assoc($result);
		echo("$row[terminalid]");

	} else {
		echo("No card ID specified so can't lookup the termainal id.");
	}

?>