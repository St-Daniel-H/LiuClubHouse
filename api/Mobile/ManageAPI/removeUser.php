<?php
require_once("../../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$clubId = "";
$userId = "";
$userToDelete = "";
if ($data !== null) {
    $clubId = addslashes(strip_tags($data['ClubId']));
    $userId = addslashes(strip_tags($data['UserId']));
    $userToDelete = addslashes(strip_tags($data['UserToDeleteId']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($clubId) == "" or trim($userId) == "" or trim($userToDelete) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$checkIfUserIsManager = "SELECT * FROM Clubs WHERE ManagerID = " . $userId . " AND ID = " . $clubId;
$check = mysqli_query($con, $checkIfUserIsManager);
if (mysqli_num_rows($check) > 0) {
    if ($userToDelete == $userId) {
        die("Please transfer ownership first");
    }
    $query = "DELETE FROM UserClub WHERE UserID = " . $userToDelete . " AND ClubID = " . $clubId;
    $deleteResult = mysqli_query($con, $query);
    if ($deleteResult) {
        // Deletion was successful
        echo json_encode(array('success' => true));
    } else {
        // Deletion failed
        echo json_encode(array('success' => false, 'error' => mysqli_error($con)));
    }

    mysqli_close($con);
} else {
    http_response_code(403);
    die("Access Denied");
}
