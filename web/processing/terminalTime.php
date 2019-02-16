<?

	include "shared.php";

	$cardid = $_GET['cid'];
	$terminalid = $_GET['terminalid'];

	if(!($cardid == "") AND !($terminalid == "")){

		selectDatabase("runnershigh");

		if($terminalid == "1") {

			//Look for the lastest cardid row in the 'Runs' table and echo the timestamp entry
			$sql = "SELECT tstamp1 FROM runs WHERE cardid='$cardid' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			while($row = mysqli_fetch_assoc($result)) {
				$tstamp1 = $row["tstamp1"];
				echo("$tstamp1");
			}

		}

		if($terminalid == "2") {

			//Look for the lastest cardid row in the 'Runs' table and echo the timestamp entry
			$sql = "SELECT tstamp2 FROM runs WHERE cardid='$cardid' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			while($row = mysqli_fetch_assoc($result)) {
				$tstamp2 = $row["tstamp2"];
				echo("$tstamp2");
			}
			
		}

		if($terminalid == "3") {

			//Look for the lastest cardid row in the 'Runs' table and echo the timestamp entry
			$sql = "SELECT tstamp3 FROM runs WHERE cardid='$cardid' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			while($row = mysqli_fetch_assoc($result)) {
				$tstamp3 = $row["tstamp3"];
				echo("$tstamp3");
			}
			
		}

		if($terminalid == "4") {

			//Look for the lastest cardid row in the 'Runs' table and echo the timestamp entry
			$sql = "SELECT tstamp4 FROM runs WHERE cardid='$cardid' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			while($row = mysqli_fetch_assoc($result)) {
				$tstamp4 = $row["tstamp4"];
				echo("$tstamp4");
			}
			
		}

		/*
		$sql = "SELECT tstamp1 FROM Runs WHERE cardid='$cardid' ORDER BY id DESC LIMIT 1";

		$result = mysqli_query($conn, $sql);

		echo("$result");

		}
		*/

	} else {
		echo("error: no paramaters were entered");
	}

?>