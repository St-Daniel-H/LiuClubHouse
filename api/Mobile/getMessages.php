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

    if ($key != "your_key" or trim($clubId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$query = "SELECT Messages.Content, Messages.Date, Users.Name,Users.ID
          FROM Messages 
          INNER JOIN Users on Messages.SenderId = Users.ID
          WHERE Messages.ClubID = '" . $clubId . "'";


if ($result = mysqli_query($con, $query)) {
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
