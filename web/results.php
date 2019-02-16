<?

	include "processing/shared.php";

	global $runnerid;
	global $runnername;
	global $tstamp1;
	global $tstamp2;
	global $tstamp3;
	global $tstamp4;
	global $duration;
	global $terminalid;
	$username = $_POST['username'];
	$password = $_POST['password'];

	if(!$username == ""){

		selectDatabase("runnershigh");

		$sql = "SELECT username FROM users WHERE username = '$username' LIMIT 1";
		$result = mysqli_query($conn, $sql);

		while($row = mysqli_fetch_assoc($result)) {
			$realusername = $row["username"];
		}

		if(strcmp($username, $realusername) !== 0) {
			include "incorrect-username.html";
			return;
		}

		$sql = "SELECT password FROM users WHERE username = '$username' LIMIT 1";
		$result = mysqli_query($conn, $sql);

		while($row = mysqli_fetch_assoc($result)) {
			$realpassword = $row["password"];
		}

		if(strcmp($password, $realpassword) !== 0) {
			include ("incorrect-password.html");
			return;
		}

		$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password' LIMIT 1";
		$result = mysqli_query($conn, $sql);

		while($row = mysqli_fetch_assoc($result)) {
			$runnerid = $row["id"];
			$runnername = $row["runnername"];
		}

		$sql = "SELECT * FROM runs WHERE runnerid = '$runnerid' ORDER BY id DESC LIMIT 1";
		$result = mysqli_query($conn, $sql);

		if($row = mysqli_fetch_assoc($result)) {

			$date = $row['date'];
			$tstamp1 = $row['tstamp1'];
			$tstamp2 = $row['tstamp2'];
			$tstamp3 = $row['tstamp3'];
			$tstamp4 = $row['tstamp4'];
			$duration = $row['duration'];
			$terminalid = $row['terminalid'];

			if($tstamp2 == "") {
				$duration = "";
			}

		}

		if(!$tstamp1 == "") {

				include "results.html";

		}

	} else {

		include "results-search.html";

	}

?>