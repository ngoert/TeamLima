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
$query = 
    'INSERT INTO listings (itemName, uuid, description, imageUrl) VALUES ("' . $data->itemName . '", "' . $data->uuid. '", "' . $data->description . '", "' . $data->imageURL . '")';

echo $query;
if($result = $mysqlDB->query($query)) {
    echo 'Success';
}	
else {
    echo "Invalid Query";
}
?>