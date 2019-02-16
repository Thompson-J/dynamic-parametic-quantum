<?

	include "shared.php";

	/*
	global $runnerid;
	
	selectDatabase("feelingarunnershigh");
	
	$query = "SELECT * FROM Josh WHERE card_id='$cardid'";
	
	
	
	$runnerid = 
	*/

	$username = $_GET['username'];
	$password = $_GET['password'];
	$runnername = $_GET['runnername'];
	$cardid = $_GET['cid'];
	$date = $_GET['date'];
	$tstamp1 = $_GET['tstamp1'];
	$terminalid = $_GET['terminalid'];

	selectDatabase("runnershigh");

	//If a username, password and runnername is provided and a card is scanned then enter the user details and the run details
	if (!$username == ""  && !$password == ""  && !$runnername == ""  && !$cardid == "") {

		//THIS SHOULD CREATE AND OR SUBMIT ITEMS TO THE MYSQL DATABASE THAT CONTAINS SEMINARS.

		/* Check the connection

		if($conn) {
			echo("working connection");
		} else {
			echo("no working connection");
		}
		*/

		//Create the user table

		$sql = "CREATE TABLE users (id INT AUTO_INCREMENT PRIMARY KEY, username TEXT, password TEXT, runnername TEXT)";
		
		if (mysqli_query($conn, $sql)){
			echo("success in table creation.");
		} else {
			echo("no table created this time around - process failed because item already exists.");
		}

		//Insert the user info into the database
		//First check that the username isn't already taken
		$sql = "SELECT username FROM users WHERE username='$username'";
		$result = mysqli_query($conn, $sql);

		if (mysqli_num_rows($result) == 0) {
			$sql = "INSERT INTO users (username, password, runnername) VALUES ('$username', '$password', '$runnername')";
			$result = mysqli_query($conn, $sql);
			echo("username is free so create the entry");
		} else {
			echo("username is taken so don't create the entry");
		}

		//Create the run info table

		$sql = "CREATE TABLE runs (id INT AUTO_INCREMENT PRIMARY KEY, runnerid TEXT, cardid TEXT, date TEXT, tstamp1 TEXT, tstamp2 TEXT, tstamp3 TEXT, tstamp4 TEXT, duration TEXT, terminalid TEXT)";
		
		if (mysqli_query($conn, $sql)){
			echo("success in table creation.");
		} else {
			echo("no table created this time around - process failed because item already exists.");
		}

		//Insert the run info into the database
		//The runnerid is the id for that username in the Users table
		$sql = "SELECT id FROM users WHERE username='$username'";
		$result = mysqli_query($conn, $sql);

		while($row = mysqli_fetch_assoc($result)) {
	        $runnerid = $row["id"];
	    }

		echo("set the runnerid to the id for that username and insert the run info");

		$sql = "INSERT INTO runs (runnerid, cardid, date, tstamp1, terminalid) VALUES ('$runnerid', '$cardid', '$date', '$tstamp1', '$terminalid')";
		$result = mysqli_query($conn, $sql);
	}

	//If a username isn't provided then only enter the run details
	if ($username  == "" && !$cardid == "") {

		//Insert the run info into the database
		//The runnerid is the runnerid for that cardid in the runs table
		$sql = "SELECT runnerid FROM runs WHERE cardid = '$cardid' ORDER BY id DESC LIMIT 1";
		$result = mysqli_query($conn, $sql);
		$row = mysqli_fetch_assoc($result);
		$runnerid = $row['runnerid'];

		$sql = "INSERT INTO runs (runnerid, cardid, date, tstamp1, terminalid) VALUES ('$runnerid', '$cardid', '$date', '$tstamp1', '$terminalid')";
		$result = mysqli_query($conn, $sql);

	}

?>