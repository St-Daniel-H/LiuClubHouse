<?php
session_start(); ?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In</title>
    <link rel="stylesheet" href="./Login.css">
</head>

<body>
    <div id="loginTop">
        <h1>
            <span style="color: blue">L</span>
            <span style="color: red">I</span>
            <span style="color: green">U</span>
            <span style="color: rgb(110, 110, 110)"> Club House</span>
        </h1>
    </div>
    <div id="formContainer">

        <form method="POST" action="LoginAction.php">

            <label for=" Email">Email*</label>
            <br>
            <input name="Email" id="Email">
            <br>
            <br>
            <label for="Password">Password*</label>
            <br>
            <input name="Password" type="password" id="Password">
            <br>
            <br>
            <button type="submit" id="submit">
                <b>Log in</b>
            </button>
            <?php
            if (isset($_SESSION["ERROR"]))
                echo "<span style='color:red;'>" . $_SESSION["ERROR"] . "</span><br/>";
            ?>
        </form>

    </div>
</body>


</html>