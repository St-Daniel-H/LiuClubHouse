<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
// Check if decoding was successful
$email = "";
$password = "";
$confirm = "";
$name = "";
$picture = "/Uploads/UserProfiles/default.jpg";
if ($data !== null) {
    $email = addslashes(strip_tags($data['Email']));
    $password = addslashes(strip_tags($data['Password']));
    $confirm = addslashes($data["Confirm"]);
    $name = addslashes($data["Name"]);
    $key = addslashes(strip_tags($data['key']));

    if ($key != "your_key" or trim($name) == "")
        die("access denied");
}
$query = "SELECT * FROM Users WHERE Email = '" . $email . "'";

$result = mysqli_query($con, $query);
if (mysqli_num_rows($result) > 0) {
    // username already exist
    $response = array(
        'response' => "Email already exist"
    );
    $jsonData = json_encode($response);
    echo $jsonData;
} else {
    if ($email == "" || $password == "" || $name == "") {
        $response = array(
            'response' => "Fill All Inputs"
        );
        $jsonData = json_encode($response);
        echo $jsonData;
    }
    if ($password != $confirm) {
        // password doesn't match
        $response = array(
            'response' => "Invalid Password"
        );
        $jsonData = json_encode($response);
        echo $jsonData;
    } else {
        // add a new user
        //1- hashing of password by sha256
        $hash = hash("sha256", $password);

        //2- generate encrypted salt by md5
        $salt = md5(uniqid(rand(), true));
        $salt = substr($salt, 0, 3);

        //3- hash the password and salt by sha256
        $finalPass = hash("sha256", $hash . $salt);

        // Insert query
        $query = "INSERT INTO Users (Name, Email, Password, Salt, RoleId, Picture, DateCreated) 
          VALUES ('" . $name . "', '" . $email . "', '" . $finalPass . "', '" . $salt . "', 3, '" . $picture . "', NOW())";


        $result = mysqli_query($con, $query);
        if (!$result)
            echo mysqli_error();
        else
            echo "Successfully";
    }
}
