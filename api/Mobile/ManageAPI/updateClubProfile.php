<?php
require_once("../../../Config.php");
$targetDirectory = "../../../Uploads/ClubLogo/";
$uploadedFile = "";
$title = "";
$clubId = "";
$userId = "";
$description = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle form data
    $title = addslashes(strip_tags($_POST['Name']));
    $clubId = addslashes(strip_tags($_POST['ClubId']));
    $userId = addslashes(strip_tags($_POST['UserId']));
    $description = addslashes(strip_tags($_POST['Description']));

    // Handle file upload
    if (isset($_FILES['file']) && $_FILES['file']['error'] == 0) {
        $uploadedFile = $targetDirectory . $clubId;
        if (file_exists($uploadedFile)) {
            unlink($uploadedFile); // Delete the old file
        }

        if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadedFile)) {
            $allowedExtensions = ["jpg", "jpeg", "png", "gif"];
            $uploadedFileName = $_FILES["file"]["name"];
            $uploadedFileExtension = pathinfo($uploadedFileName, PATHINFO_EXTENSION);

            if (!in_array(strtolower($uploadedFileExtension), $allowedExtensions)) {
                http_response_code(400);
                die("Invalid file format.");
            }

            if ($_FILES["file"]["size"] > 500000) {
                http_response_code(400);
                die("File is too large.");
            }
        } else {
            http_response_code(400);
            die("Error moving uploaded file.");
        }
    } else {
    }

    // Continue with the rest of your script...
} else {
    http_response_code(400);
    die("Invalid request method");
}




// Validate if user is the owner of the club
$checkIfUserIsOwner = "SELECT * FROM Clubs WHERE ManagerID = ? AND ID = ?";
$check = mysqli_prepare($con, $checkIfUserIsOwner);
mysqli_stmt_bind_param($check, "ss", $userId, $clubId);
mysqli_stmt_execute($check);
mysqli_stmt_store_result($check);

if (mysqli_stmt_num_rows($check) > 0) {
    $Logo = "Uploads/ClubLogo/" . $clubId;
    // Use prepared statements to prevent SQL injection
    $query = 'UPDATE Clubs SET Name = ?, Description = ?, Logo = ? WHERE ID = ?';

    $stmt = mysqli_prepare($con, $query);
    mysqli_stmt_bind_param($stmt, "ssss", $title, $description, $Logo, $clubId);

    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(array('success' => true));
    } else {
        echo json_encode(array('success' => false, 'error' => mysqli_error($con)));
    }

    mysqli_stmt_close($stmt);
    mysqli_close($con);
} else {
    http_response_code(400);
    die("Invalid Club or User " . $userId . "club: " . $clubId);
}
