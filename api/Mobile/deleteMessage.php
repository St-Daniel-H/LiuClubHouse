<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$messageId = "";
$userId = "";
if ($data !== null) {
    $messageId = addslashes(strip_tags($data['MessageId']));
    $userId = addslashes(strip_tags($data['UserId']));
    $key = addslashes(strip_tags($data['Key']));

    if ($key != "your_key" or trim($messageId) == "" or trim($userId) == "") {
        http_response_code(403);
        die("access denied");
    }
}
$checkIfUserSentMessage = "SELECT * FROM Messages WHERE SenderID = " . $userId . " AND ID = " . $messageId;
$check = mysqli_query($con, $checkIfUserSentMessage);
if (mysqli_num_rows($check) > 0) {
    $query = "DELETE FROM Messages WHERE ID = " . $messageId;
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
    die("Invalid Message or User");
}
