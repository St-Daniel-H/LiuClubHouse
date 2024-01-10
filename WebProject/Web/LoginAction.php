<?php
session_start();
require("../Config.php");

// clean user entries
$email = mysqli_real_escape_string($con, $_POST["Email"]);
$pass = mysqli_real_escape_string($con, $_POST["Password"]);

$query = "SELECT * FROM users WHERE Email='" . $email . "'";
$result = mysqli_query($con, $query);
if ($email == "" || $pass == "") {
    $_SESSION["ERROR"] = "Please fill Inputs"; // no result returned
    header("Location: Login.php");
}
if (!$result) {
    die(mysqli_error($con)); // error in query or connection
}

if (mysqli_num_rows($result) == 0) {
    $_SESSION["ERROR"] = "Invalid Email"; // no result returned
    header("Location: Login.php");
} else {
    // username exists => continue to check password
    $row = mysqli_fetch_array($result);

    // hash the new logging password
    $hash1 = hash('sha256', $pass);
    $salt = $row["Salt"]; // from database already encrypted with md5

    // Ensure both password and salt are not empty before hashing
    if (!empty($pass) && !empty($salt)) {
        $finalPassword = hash('sha256', $hash1 . $salt);

        if ($finalPassword == $row["Password"]) {
            if ($row["RoleID"] == 1) {
                // login as Admin
                $_SESSION["LoggedIN_Admin"] = 1;
                $_SESSION["Email_Admin"] = $email;
                $_SESSION["UserId_Admin"] = $row["ID"];
                header("Location: ./Admin/Home.php");
            } else { // log in as: Public Users
                echo "Login Successful";
                $_SESSION["LoggedIN"] = 1;
                $_SESSION["Email"] = $email;
                $_SESSION["UserId"] = $row["ID"];
                header("Location: ./User/Home.php");
            }
        } else {
            $_SESSION["ERROR"] = "Invalid Password";
            header("Location: Login.php");
        }
    } else {
        $_SESSION["ERROR"] = "Invalid Password ";
        header("Location: Login.php");
    }
}
