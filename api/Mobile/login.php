<!--User login api, basically login user account-->
<?php
require_once("../../Config.php");
// Retrieve the raw POST data
$jsonData = file_get_contents('php://input');
// Decode the JSON data into a PHP associative array
$data = json_decode($jsonData, true);
// Check if decoding was successful
if ($data !== null) {
    $email = addslashes(strip_tags($data['Email']));
    $password = addslashes(strip_tags($data['Password']));
    $key = addslashes(strip_tags($data['key']));

    if ($key != "your_key" or trim($name) == "")
        die("access denied");
}

$query = "SELECT * FROM Users WHERE Email='" . $email . "'";
$result = mysqli_query($con, $query);
if (mysqli_num_rows($result) == 0) {
    $response = array(
        'response' => "Invalid Email"
    );
    $jsonData = json_encode($response);
    header('Content-Type: application/json');
    echo $jsonData;
} else {
    // username exists => continue to check password
    $row = mysqli_fetch_array($result);
    // hash the new logging password
    $hash1 = hash('sha256', $password);
    $salt = $row["Salt"]; //from database already encrypted with md5
    $finalPassword = hash('sha256', $hash1 . $salt);
    if ($finalPassword == $row["Password"]) {

        if ($row["RoleId"] == 1) {
            // login as Admin
            $response = array(
                'response' => "Ok"
            );
            $jsonData = json_encode($response);
            header('Content-Type: application/json');
            echo $jsonData;
        } else { // log in as : Public Users
            $response = array(
                'response' => "Ok"
            );
            $jsonData = json_encode($response);
            header('Content-Type: application/json');
            echo $jsonData;
        }
    } else {
        $response = array(
            'response' => "Invalid Password"
        );
        $jsonData = json_encode($response);
        header('Content-Type: application/json');
        echo $jsonData;
    }
}
