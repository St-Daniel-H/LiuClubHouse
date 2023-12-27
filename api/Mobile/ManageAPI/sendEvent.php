<?php
require_once("../../../Config.php");

// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');

// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);

$clubId = "";
$userId = "";
$Title = "";
$Description = "";
$StartDate = "";

if ($data !== null) {
    $clubId = addslashes(strip_tags($data['ClubId']));
    $userId = addslashes(strip_tags($data['UserId']));
    $Title = addslashes(strip_tags($data['Title']));
    $Description = addslashes(strip_tags($data['Description']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($clubId) == "" or trim($userId) == "") {
        http_response_code(403);
        die("Access denied");
    }
}

// Check if the user is a manager of the club
$checkIfUserIsManager = "SELECT * FROM Clubs WHERE ManagerID = '" . $userId . "' AND ID = '" . $clubId . "'";
$check = mysqli_query($con, $checkIfUserIsManager);

if (mysqli_num_rows($check) == 1) {
    // Convert the start date to the correct format
    $startDate = date('Y-m-d', strtotime($data['StartDate']));

    // Insert the event into the Events table
    $query = "INSERT INTO Events (`Title`, `Description`, `DateCreated`, `StartDate`, `UserID`, `ClubID`) 
        VALUES ('" . $Title . "', '" . $Description . "', NOW(), '" . $startDate . "', '" . $userId . "', '" . $clubId . "')";

    $sendEvent = mysqli_query($con, $query);

    if ($sendEvent) {
        // Insertion was successful
        echo json_encode(array('success' => true));
    } else {
        // Insertion failed
        echo json_encode(array('success' => false, 'error' => mysqli_error($con)));
    }

    mysqli_close($con);
} else {
    // User is not a manager of the club
    http_response_code(403);
    die("Access Danied");
}
