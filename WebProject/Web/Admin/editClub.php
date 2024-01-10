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
                    $name = "";
                    $email = "";
                    $desc = "";
                    $nameError = "";
                    $emailError = "";
                    $descError = "";
                    $clubID = "";
                    if (isset($_GET['id'])) {

                        // Retrieve the value of "club" parameter
                        $clubID = $_GET['id'];
                        $query = "SELECT clubs.*, users.Email AS ManagerEmail
                        FROM Clubs
                        INNER JOIN users ON Clubs.ManagerID = users.ID
                        WHERE clubs.ID = '$clubID'";
                        $result = mysqli_query($con, $query);
                        $row = mysqli_fetch_array($result);
                        $name = $row["Name"];
                        $desc = $row["Description"];
                        $logo = $row["Logo"];
                        $email = $row["ManagerEmail"];
                        $createdAt = $row["DateCreated"];
                    } else {
                        // Handle the case where "club" parameter is not set
                        //echo "Club ID not provided in the URL.";
                    }

                    $success = "";
                    if (isset($_POST["delete"])) {
                        $clubIDToDelete = $_POST["clubID"];
                        $deleteEvents = "DELETE FROM events
                        WHERE ClubID = '$clubIDToDelete';";
                        $delete2 = mysqli_query($con, $deleteEvents);
                        $deleteEvents = "DELETE FROM messages
                        WHERE ClubID = '$clubIDToDelete';";
                        $delete2 = mysqli_query($con, $deleteEvents);
                        $deleteQuery = "DELETE FROM clubs WHERE ID=$clubIDToDelete";
                        $delete = mysqli_query($con, $deleteQuery);
                        if ($delete) {
                            $success = "Club is deleted";
                            header("Location: Home.php");
                        }
                    }
                    if (isset($_POST["submit"])) {
                        $clubIDToUpdate = $_POST["clubID"];

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
                                    $query = "UPDATE clubs SET `Name`='$name', `Description` = '$description', `ManagerID`='$userId' WHERE ID='$clubIDToUpdate'";

                                    $result = mysqli_query($con, $query);

                                    if ($result) {
                                        // Get the ClubID of the recently added club
                                        $clubId = mysqli_insert_id($con);
                                        $checkIfUserInClubAlready = "SELECT * FROM userclub WHERE userID = '$userId' AND clubID='$clubIDToUpdate'";
                                        $checkResultOfUserInClub = mysqli_query($con, $checkIfUserInClubAlready);
                                        $rowCount = mysqli_num_rows($checkResultOfUserInClub);
                                        if ($rowCount == 0) {
                                            // Add user to the club
                                            $query2 = "INSERT INTO userclub(`UserID`, `ClubID`) VALUES ('$userId', '$clubIDToUpdate')";

                                            $result2 = mysqli_query($con, $query2);
                                            if ($result2) {
                                                $success = "Club updated successfully with ClubID: " . $clubId;
                                            } else {
                                                $success =  "Error adding user to the club: " . mysqli_error($con);
                                            }
                                        }
                                    } else {
                                        echo "Error updating club: " . mysqli_error($con);
                                    }
                                    header("Location: Home.php");
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
                        <input id="name" name="name" value="<?php echo $name; ?>"><br />
                        <input type="hidden" name="clubID" value="<?php echo $clubID; ?>">

                        <label for="description">Description <?php echo "<span style='color:red;'>$descError</span>" ?></label><br />
                        <textarea id="description" name="description"><?php echo $desc; ?></textarea><br />

                        <label for="email">Email <?php echo "<span style='color:red;'>$emailError</span>" ?></label><br />
                        <input id="email" name="email" value="<?php echo $email; ?>"><br />
                        <?php echo "<span style='color:green;'>$success</span>" ?>
                        <input type="reset"> <input type="submit" name="submit"><br />
                        <button name="delete" id="deleteButton">Delete</button>
                    </form>

                </div>

            </div>
        </div>
    </div>
</body>

</html>