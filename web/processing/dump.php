<?

	include ("shared.php");

	selectDatabase("runnershigh");

	// Select all the row of run data where runners have finished the run
	$sqlRuns = "SELECT * FROM runs WHERE terminalid='2' ORDER BY id DESC";
	$resultRuns = mysqli_query($conn, $sqlRuns);
	while($rowRuns = mysqli_fetch_assoc($resultRuns)){

		$runnerid = $rowRuns['runnerid'];
		//echo("$runnerid");
		//Test if the script gets to here
		//echo("hi world");

		// Select the name of the runner
		$sqlUsers = "SELECT runnername FROM users WHERE id = $runnerid ORDER BY id DESC LIMIT 1";
		$resultUsers = mysqli_query($conn, $sqlUsers);
		while($rowUsers = mysqli_fetch_assoc($resultUsers)){

			$runnername = $rowUsers['runnername'];
			//echo("runnername is: $runnername" );
			//echo("$runnername| " );

		}

	//echo ("runnerid: $rowRuns[runnerid], runnername: $runnername date: $rowRuns[date], duration: $rowRuns[duration], terminalid: $rowRuns[terminalid]<br><hr>");
	// Return the runnername and their duration
	echo ("**$runnername|$rowRuns[duration]<br><hr>");

	}

	/*
	$sql = "SELECT * FROM users ORDER BY id DESC";
	$result = mysqli_query($conn, $sql);
	while($row = mysqli_fetch_assoc($result)){

	echo ("runnername: $row[runnername]<br><hr>");

	}
	*/


?>