<?php
require_once("../../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
$clubId = $_POST["clubId"] ?? "";
$userId = $_POST["userId"] ?? "";
$content = $_POST["content"] ?? "";
if ($clubId == "" || $userId == "" || $content == "") {
    die("invalid data");
}
$query = "INSERT INTO Messages (SenderID, ClubID, Content, Date) VALUES ('" . $userId . "','" . $clubId . "','" . $content . "', NOW())";
$result = mysqli_query($con, $query);
header("Location: http://localhost/webproject/Web/User/Club/main.php?club=$clubId");
