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
    $userToAddId = addslashes(strip_tags($data['email']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($clubId) == "" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$checkIfUserInClub = "SELECT * FROM Clubs WHERE ManagerID = " . $userId . " AND ID = " . $clubId;
$check = mysqli_query($con, $checkIfUserInClub);

$getUserIdQuery = "SELECT ID FROM Users WHERE Email = ?";
$getUserIdStmt = mysqli_prepare($con, $getUserIdQuery);
mysqli_stmt_bind_param($getUserIdStmt, "s", $userToAddId);
mysqli_stmt_execute($getUserIdStmt);
$resultUserId = mysqli_stmt_get_result($getUserIdStmt);

$checkIfUserExist = "SELECT * FROM Users WHERE Email = '" . $userToAddId . "'";
$checkUserExist = mysqli_query($con, $checkIfUserExist);

$checkIfUserAlreadyInClub = "SELECT * FROM UserClub WHERE 
UserId = (SELECT ID FROM Users WHERE Email = '" . $userToAddId . "') 
AND ClubID = " . $clubId;
$checkUserAlreadyJoined = mysqli_query($con, $checkIfUserAlreadyInClub);

if (mysqli_num_rows($check) > 0) {
    if ($rowUserId = mysqli_fetch_assoc($resultUserId)) {
        $userId = $rowUserId['ID'];
        if (mysqli_num_rows($checkUserAlreadyJoined) > 0) {
            http_response_code(403);
            echo ("User already joined");
            return;
        }
        $query = "INSERT INTO UserClub (UserID, ClubID, DateJoined) VALUES (?, ?, NOW())";
        $insertStmt = mysqli_prepare($con, $query);
        mysqli_stmt_bind_param($insertStmt, "is", $userId, $clubId);
        mysqli_stmt_execute($insertStmt);

        if (mysqli_stmt_affected_rows($insertStmt) > 0) {
            // Insertion was successful
            echo json_encode(array('success' => true));
        } else {
            // Insertion failed
            echo json_encode(array('success' => false, 'error' => mysqli_error($con)));
        }

        mysqli_close($con);
    } else {
        http_response_code(403);
        echo ("User does not exist");
        return;
    }
} else {
    http_response_code(403);
    echo "Access Denied";
}
