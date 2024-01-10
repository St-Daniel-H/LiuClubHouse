<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin</title>
    <link rel="stylesheet" type="text/css" href="./css/Home.css">

</head>

<body>
    <div id="adminHome">
        <div id="left-drawer">
            <div id="lefttitle">
                <img id="UniLogo" src="./Images/Liu.png">
            </div>
            <div id="sections">
                <div class="leftDrawerOptions <?php
                                                $currentPath = $_SERVER['REQUEST_URI'];
                                                $desiredPathClubs = '/webproject/Web/Admin/Home.php';
                                                echo (strpos($currentPath, $desiredPathClubs) !== false) ? 'active-link' : ''; ?>">

                    <a href="clubs.php">Clubs</a>
                </div>
                <div class="leftDrawerOptions" id=" <?php
                                                    $currentPath = $_SERVER['REQUEST_URI'];
                                                    $desiredPathClubs = '/webproject/Web/Admin/members.php';
                                                    echo (strpos($currentScript, $desiredPathClubs) !== false) ? 'active-link' : ''; ?>">
                    <a href="members.php">Members</a>
                </div>
            </div>
        </div>
        <div id="right-side">
            <div id="topBar">
                <h1>Lebanese Intenrational university</h1>
            </div>
            <div id="main-area">
                <div id="formArea">
                    <?php
                    require_once("../../Config.php");
                    $nameError = "";
                    $emailError = "";
                    $descError = "";
                    $success = "";
                    if (isset($_POST["submit"])) {
                        $name = $_POST["name"];
                        $description = $_POST["description"];
                        $email = $_POST["email"];
                        $isValid = true;

                        if ($name == "") {
                            $nameError = "Fill club name, please";
                            $isValid = false;
                        }
                        if ($description == "") {
                            $descError = "Fill club description, please";
                            $isValid = false;
                        }
                        if ($email == "") {
                            $emailError = "Fill manager email, please";
                            $isValid = false;
                        }
                        if ($isValid) {
                            $checkManagerQuery = "SELECT * FROM users WHERE Email = '$email'";
                            $checkresult = mysqli_query($con, $checkManagerQuery);
                            if ($checkresult) {
                                $rowCount = mysqli_num_rows($checkresult);

                                if ($rowCount == 1) {
                                    $row = mysqli_fetch_assoc($checkresult);
                                    $userId = $row['ID'];
                                    //add club
                                    // Add club
                                    $query = "INSERT INTO clubs(`Name`, `Description`, `ManagerID`, `DateCreated`, Logo) VALUES ('$name','$description','$userId',NOW(),'Uploads/ClubLogo/default.jpg')";

                                    $result = mysqli_query($con, $query);

                                    if ($result) {
                                        // Get the ClubID of the recently added club
                                        $clubId = mysqli_insert_id($con);

                                        // Add user to the club
                                        $query2 = "INSERT INTO userclub(`UserID`, `ClubID`) VALUES ('$userId', '$clubId')";

                                        $result2 = mysqli_query($con, $query2);

                                        if ($result2) {
                                            $success = "Club added successfully with ClubID: " . $clubId;
                                        } else {
                                            $success =  "Error adding user to the club: " . mysqli_error($con);
                                        }
                                    } else {
                                        echo "Error adding club: " . mysqli_error($con);
                                    }
                                } else {
                                    $emailError = "User Does Not Exist";
                                    $isValid = false;
                                }
                            } else {
                                $isValid = false;
                            }
                        }
                    }
                    ?>

                    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                        <label for="name">Name <?php echo "<span style='color:red;'>$nameError</span>" ?></label><br />
                        <input id="name" name="name"><br />

                        <label for="description">Description <?php echo "<span style='color:red;'>$descError</span>" ?></label><br />
                        <textarea id="description" name="description"></textarea><br />

                        <label for="email">Email <?php echo "<span style='color:red;'>$emailError</span>" ?></label><br />
                        <input id="email" name="email"><br />
                        <?php echo "<span style='color:green;'>$success</span>" ?>
                        <input type="reset"> <input type="submit" name="submit"><br />
                    </form>
                </div>


                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Manager</th>
                            <th>Edit</th>
                        </tr>
                    </thead>
                    <?php

                    $query = "SELECT clubs.ID, clubs.Name AS club_name, clubs.Description, users.Name AS manager_name
                     FROM clubs
                     INNER JOIN users ON clubs.ManagerID = users.ID";

                    $result = mysqli_query($con, $query);
                    while ($row = mysqli_fetch_array($result)) {
                        echo ("<tr>
                                <td>" . $row['ID'] . "</td>
                                <td>" . $row['club_name'] . "</td>
                                <td>" . $row['Description'] . "</td>
                                <td>" . $row['manager_name'] . "</td>
                                <td><a href='./editClub.php?id=" . $row['ID'] . "'>edit</a></td>
                                </tr>");
                    }
                    ?>
                </table>
            </div>
        </div>
    </div>
</body>

</html>