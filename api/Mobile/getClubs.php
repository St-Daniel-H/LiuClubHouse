<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$userId = "";
if ($data !== null) {
    $userId = addslashes(strip_tags($data['UserId']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$query = "SELECT * FROM Users WHERE ID = '" . $userId . "'";

$checkUser = mysqli_query($con, $query);
if (!(mysqli_num_rows($checkUser) > 0)) {
    http_response_code(403);
    // username already exist
    die("Invalid User");
} else {
    $sql = "SELECT * FROM Clubs WHERE Clubs.ID = (SELECT ClubID FROM UserClub WHERE UserId = '$userId')";
    if ($result = mysqli_query($con, $sql)) {
        $emparray = array();
        while ($row = mysqli_fetch_assoc($result))
            $emparray[] = $row;

        echo (json_encode($emparray));
        // Free result set
        mysqli_free_result($result);
        mysqli_close($con);
    }
}
