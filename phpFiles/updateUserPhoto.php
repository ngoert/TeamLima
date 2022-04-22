<?php
//Author: Cole Hutson
//sql information
$server = 'cs.okstate.edu';
$userName = '<username>';
$password = '<password>';
$dbName = 'MAD_Spr22_Lima';

$mysqlDB = new mysqli($server, $userName, $password, $dbName);

$json = file_get_contents('php://input');
$data = json_decode($json);

$query = 'UPDATE users SET profileImageURL="' . $data->profileImageURL  . '" WHERE uuid = "' . $data->uuid  . '"';

if($result = $mysqlDB->query($query))
{
    $listings = array();
    while($listing = $result->fetch_assoc())
    {
        $listings[] = $listing;
    }

    header('Content-Type: application/json');

	echo json_encode($listings);
}
else {
    echo "Invalid Query";
}
?>
