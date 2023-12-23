<?php
require_once("../../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$clubId = "";
$userId = "";
$userToAddId = "";
if ($data !== null) {
    $clubId = addslashes(strip_tags($data['ClubId']));
    $userId = addslashes(strip_tags($data['UserId']));
    $userToAddId = addslashes(strip_tags($data['UserToAddId']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($clubId) == "" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$checkIfUserInClub = "SELECT * FROM Clubs WHERE ManagerID = " . $userId . " AND ID = " . $clubId;
$check = mysqli_query($con, $checkIfUserInClub);

$checkIfUserExist = "SELECT * FROM Users WHERE ID = " . $userToAddId;
$checkUserExist = mysqli_query($con, $checkIfUserExist);

$checkIfUserAlreadyInClub = "SELECT * FROM UserClub WHERE UserID = " . $userToAddId . " AND ClubID = " . $clubId;
$checkUserAlreadyJoined = mysqli_query($con, $checkIfUserExist);
if (mysqli_num_rows($check) > 0) {

    if (mysqli_num_rows($checkUserExist) == 0) {
        http_response_code(403);
        die("User does not exist");
        return;
    }
    if (mysqli_num_rows($checkUserAlreadyJoined) > 0) {
        http_response_code(403);
        die("User already joined");
        return;
    }
    $query = "INSERT INTO UserClub (UserID, ClubID, DateJoined) VALUES ('" . $userToAddId . "', '" . $clubId . "', NOW())";
    $insertResult = mysqli_query($con, $query);
    if ($insertResult) {
        // Insertion was successful
        echo json_encode(array('success' => true));
    } else {
        // Insertion failed
        echo json_encode(array('success' => false, 'error' => mysqli_error($con)));
    }

    mysqli_close($con);
} else {
    http_response_code(403);
    die("Access Denied");
}
