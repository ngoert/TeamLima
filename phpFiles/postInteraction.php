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

$didPass = 0;
if($data->didPass == true) {
    $didPass = 1;
}

$query = 
    'INSERT INTO interactions (listingID, ownerID, interactorID, didPass) VALUES ("' 
    . $data->listingID . '", "' . $data->ownerID. '", "' . $data->interactorID. '",' . $didPass . ')';

echo $query;
if($result = $mysqlDB->query($query)) {
    echo 'Success';
}	
else {
    echo "Invalid Query";
}
?>