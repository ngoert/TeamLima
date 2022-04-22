<?php
//Author: Cole Hutson
//sql information
$server = 'cs.okstate.edu';
$userName = '<username>';
$password = '<password>';
$dbName = 'MAD_Spr22_Lima';

$mysqlDB = new mysqli($server, $userName, $password, $dbName);

$request = explode("/", trim($_SERVER["PATH_INFO"],"/"));
$userID = array_shift($request);

$query = 'SELECT * FROM users WHERE uuid="' . $userID . '"';

if($result = $mysqlDB->query($query)) {
    $user = $result->fetch_assoc();

    header('Content-Type: application/json');

	echo json_encode($user);
}	
else {
    echo "Invalid Query";
}
?>