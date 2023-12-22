<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$clubId = "";
$userId = "";
$content = "";
if ($data !== null) {
    $clubId = addslashes(strip_tags($data['ClubId']));
    $userId = addslashes(strip_tags($data['UserId']));
    $content = addslashes(strip_tags($data['Content']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($clubId) == "" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$query = "INSERT INTO Messages (SenderID, ClubID, Content, Date) VALUES ('" . $userId . "','" . $clubId . "','" . $content . "', NOW())";
$result = mysqli_query($con, $query);
if ($result) {
    $response = array(
        'response' => "Ok"
    );
    $jsonData = json_encode($response);
    echo $jsonData;
} else {
    http_response_code(403);

    die("Network error");
}
