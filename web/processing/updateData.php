<?

	include "shared.php";

	/*
	global $runnerid;
	
	selectDatabase("feelingarunnershigh");
	
	$query = "SELECT * FROM Josh WHERE card_id='$cardid'";
	
	
	
	$runnerid = 
	*/

	$cardid = $_GET['cid'];
	$tstamp2 = $_GET['tstamp2'];
	$tstamp3 = $_GET['tstamp3'];
	$tstamp4 = $_GET['tstamp4'];
	$duration = $_GET['duration'];
	$terminalid = $_GET['terminalid'];

	selectDatabase("runnershigh");

	/* Check the connection

	if($conn) {
		echo("working connection");
	} else {
		echo("no working connection");
	}
	*/

	if(!$_GET['cid'] == ""){

		//Update the most recent record for the card so that it has a second timestamp
		if(!$_GET['tstamp2'] == ""){

			$sql = "UPDATE runs SET tstamp2='$tstamp2', duration='$duration', terminalid='$terminalid' WHERE cardid='$cardid' AND terminalid='1' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			echo("Updated the second timestamp");

		} else {
			echo("Didn't update the second timestamp.");
		}

		//Update the most recent record for the card so that it has a third timestamp
		if(!$_GET['tstamp3'] == ""){

			$sql = "UPDATE runs SET tstamp3='$tstamp3', duration='$duration', terminalid='$terminalid' WHERE cardid='$cardid' AND terminalid='2' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			echo("Updated the third timestamp");

		} else {
			echo("Didn't update the third timestamp.");
		}

		//Update the most recent record for the card so that it has a fourth timestamp
		if(!$_GET['tstamp4'] == ""){

			$sql = "UPDATE runs SET tstamp4='$tstamp4', duration='$duration', terminalid='$terminalid' WHERE cardid='$cardid' AND terminalid='3' ORDER BY id DESC LIMIT 1";
			$result = mysqli_query($conn, $sql);
			echo("Updated the fourth timestamp");

		} else {
			echo("Didn't update the fourth timestamp.");
		}

	}

	
/*
	//Insert data into the 'runs' table

	$sql = "INSERT INTO runs (runnerid, cardid, tstamp1, tstamp2, tstamp3, tstamp4, duration, terminalid) VALUES ('$runnerid', '$cardid', '$tstamp1', '$tstamp2', '$tstamp3', '$tstamp4', '$duration', '$terminalid')";	
	if (mysqli_query($conn, $sql)){
		echo("inserted the run data");
	} else {
		echo("didn't insert the run data");
	}

}

//$query = "DELETE FROM Josh WHERE card_id='$cardid'";
//$result = mysql_query($query, $link_id);

//echo("deleted");


//Insert into the run info into the database
$query = "INSERT INTO runs (runnerid, cardid, tstamp1, tstamp2, tstamp3, tstamp4, duration, terminalid) VALUES ('$runnerid', '$cardid', '$tstamp1', '$tstamp2', '$tstamp3', '$tstamp4', '$duration', '$terminalid')";

//echo($query);
$result = mysql_query($query, $link_id);

$query = "SELECT * FROM runs WHERE card_id='$cardid'";
$result = mysql_query($query, $link_id);

while($row = mysql_fetch_row($result)){

	echo("<br>ID:$row[0] <br> cardid: $row[1] name: $row[2] tstamp: $row[3] tstamp2: $row[4] duration: $row[5] isactive: $row[6]<br><br><hr>");

}
*/


?>