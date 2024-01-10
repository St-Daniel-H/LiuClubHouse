<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Club</title>
    <!-- <link rel="stylesheet" href="style.css"> -->
    <link rel="stylesheet" href="../css/sideTopBarClubs.css">
    <link rel="stylesheet" href="../css/sideBar.css">
    <link rel="stylesheet" href="../css/announcements.css">
    <link rel="stylesheet" href="../css/MainPage.css">
    <link rel="stylesheet" href="../css/clubMain.css">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <script src="https://kit.fontawesome.com/e46ff3aebe.js" crossorigin="anonymous"></script>
</head>

<body>
    <?php session_start();
    require_once("../../../Config.php");
    include("../Sidebar.php");
    $clubID = "";
    $name = "";
    $description = "";
    $logo = "";
    $createdAt = "";
    $managerId = "";

    if (isset($_GET['club'])) {
        // Retrieve the value of "club" parameter
        $clubID = $_GET['club'];
        $query = "SELECT * FROM Clubs WHERE Clubs.ID ='$clubID'";
        $result = mysqli_query($con, $query);
        $row = mysqli_fetch_array($result);
        $name = $row["Name"];
        $description = $row["Description"];
        $logo = $row["Logo"];
        $managerId = $row["ManagerID"];
        $createdAt = $row["DateCreated"];
    } else {
        // Handle the case where "club" parameter is not set
        echo "Club ID not provided in the URL.";
    } ?>
    <!-- background-image: URL("../../../images/actingClubBg.jpg"); -->

    <div id="chessClubBody">
        <div id="backGroundContainer">
            <div id="backGround" style='background-image: url("https://liuclubhouse.000webhostapp.com/<?php echo ($logo); ?>");'></div>
            <h2><?php echo $name ?></h2>
        </div>

    </div>
    <div id="chessClubRightLeftContainer">
        <div id="rightSide">
            <form id="form" method="post" action="../Actions/sendMessage.php">
                <input name="userId" type="hidden" value="<?php echo $userId ?>">
                <input name="clubId" type="hidden" value="<?php echo $clubID ?>">
                <input name="content" placeholder="announce Something to your class" id="messageInput" type="text">
                <button id="sendAnnouncementButton" name="sendMsg" type="submit">
                    <i class="fa-solid fa-paper-plane"></i>
                </button>
            </form>
            <div id="renderContent">

                <?php
                $userId = $_SESSION["UserId"];
                $checkIfAdminOfClub = "SELECT * FROM clubs WHERE clubs.ID = $clubID AND clubs.ManagerID = " . $userId;
                $checkQuery = mysqli_query($con, $checkIfAdminOfClub);
                $rowCount = mysqli_num_rows($checkQuery);
                $isManager = $rowCount > 0;

                echo "<script>console.log(" . $isManager . ");</script>";
                $query = "SELECT messages.Content, messages.Date,messages.ID, users.Name,users.ID userId,users.Picture
                FROM messages
                INNER JOIN Users on messages.SenderId = Users.ID
                WHERE messages.ClubID = '" . $clubId . "' ORDER BY Messages.Date DESC";
                $result = mysqli_query($con, $query);
                while ($row = mysqli_fetch_array($result)) {
                    if ($userId == $row['userId'] || $isManager) {
                        echo ("<li key='" . $row['ID'] . "' id='" . $row['ID'] . "' class='messageCard'>
                        <form method='POST' action='" . htmlspecialchars($_SERVER['PHP_SELF']) . "' class='messageCardinfo'>
                        <input type='hidden' value=" . $row["ID"] . " name='messageId'>
                            <div class='messageCardleft'>
                                <img class='cardImage' src='https://liuclubhouse.000webhostapp.com/" . $row['Picture'] . "'>
                            </div>
                            <div class='messageCardright'>
                                <h3>" . $row["Name"] . "</h3>
                                <p>" . $row["Date"] . "</p>
                            </div>
                            <div id='delete'>
                                <button name='deleteMsg' id='deleteButton'><i class='fa-solid fa-x'></i></button>
                            </div>
                        </form>
                        <form class='messageCardmessage'>" . $row["Content"] . "</form>
                    </li>");
                    } else {
                        echo ("<li key=" .
                            $row['ID'] .
                            " id=" .
                            $row['ID'] .
                            " class='messageCard'>
                            <div class='messageCardinfo'>
                                <div class='messageCardleft'><img class='cardImage' src='https://liuclubhouse.000webhostapp.com/" . $row['Picture'] . "'></div><div class='messageCardright'><h3>" . $row["Name"] . "</h3><p>" . $row["Date"] . "</p></div></div><div class='messageCardmessage'>" . $row["Content"] . "</div></li>");
                    }
                } ?>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
    <script src="../scripts/sendAnnouncements.js"></script>
</body>
<?php

if (isset($_POST["deleteMsg"])) {
    echo "hi";
    $userId = $_SESSION["UserId"];
    $messageId = $_POST["messageId"];
    $checkIfUserSentMessage = "SELECT * FROM Messages WHERE SenderID = " . $userId . " AND ID = " . $messageId;
    $check = mysqli_query($con, $checkIfUserSentMessage);
    if (mysqli_num_rows($check) > 0) {
        $query = "DELETE FROM Messages WHERE ID = " . $messageId;
        $deleteResult = mysqli_query($con, $query);
        if ($deleteResult) {
            // Deletion was successful
            echo '<script type="text/javascript">            history.back();
        </script>';
        } else {
            // Deletion failed
            die("network error");
        }

        mysqli_close($con);
    } else {
        die("Invalid Message or User");
    }
}
?>

</html>