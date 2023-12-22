<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$clubId = "";
if ($data !== null) {
    $clubId = addslashes(strip_tags($data['ClubId']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$query = "SELECT * FROM Events WHERE ClubID = '" . $clubId . "'";

$sql = "SELECT * FROM Clubs WHERE Clubs.ID = (SELECT ClubID FROM UserClub WHERE UserId = '$userId')";
if ($result = mysqli_query($con, $sql)) {
    $emparray = array();
    while ($row = mysqli_fetch_assoc($result))
        $emparray[] = $row;

    echo (json_encode($emparray));
    // Free result set
    mysqli_free_result($result);
    mysqli_close($con);
} else {
    die("Invalid Club");
}
