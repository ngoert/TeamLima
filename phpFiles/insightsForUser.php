<?php
//Author: Cole Hutson
$server = 'cs.okstate.edu';
$userName = '<username>';
$password = '<password>';
$dbName = 'MAD_Spr22_Lima';

$mysqlDB = new mysqli($server, $userName, $password, $dbName);

$request = explode("/", trim($_SERVER["PATH_INFO"],"/"));
$userID = array_shift($request);

$query = 'SELECT * FROM interactions WHERE ownerID="' . $userID . '"';

$user_insights = array(
    'numInteractions' => 0,
    'numAsks' => 0,
    'numPasses' => 0,
    'numPosts' => 0,
);

//calculating
if($result = $mysqlDB->query($query)) {
   $user_insights['numInteractions'] = $result->num_rows;   
}	
else {
    echo "Invalid Query for num interactions";
}

//calculating the number of times this user's products have been asked for
$query = 'SELECT * FROM interactions WHERE didPass=0 AND ownerID="' . $userID . '"';

if($result = $mysqlDB->query($query)) {
    $user_insights['numAsks'] = $result->num_rows;
    $user_insights['numPasses'] = $user_insights['numInteractions'] - $user_insights['numAsks'];   
}	
else {
     echo "Invalid Query for num Asks";
}

//calculating the number of times this user has posted
$query = 'SELECT * FROM listings WHERE uuid="' . $userID . '"';

if($result = $mysqlDB->query($query)) {
    $user_insights['numPosts'] = $result->num_rows; 
}	
else {
     echo "Invalid Query for num posts";
}

header('Content-Type: application/json');

echo json_encode($user_insights);

?>