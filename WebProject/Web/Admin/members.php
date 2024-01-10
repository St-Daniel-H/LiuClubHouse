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

                    <a href="Home.php">Clubs</a>
                </div>
                <div class="leftDrawerOptions <?php
                                                $currentPath = $_SERVER['REQUEST_URI'];
                                                $desiredPathClubs = '/webproject/Web/Admin/members.php';
                                                echo (strpos($currentPath, $desiredPathClubs) !== false) ? 'active-link' : ''; ?>">
                    <a href="members.php">Members</a>
                </div>
            </div>
        </div>
        <div id="right-side">
            <div id="topBar">
                <h1>Lebanese Intenrational university</h1>
            </div>
            <div id="main-area">


                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Picture</th>
                        </tr>
                    </thead>
                    <?php
                    require_once("../../Config.php");
                    $query = "SELECT *
                     FROM users";

                    $result = mysqli_query($con, $query);
                    while ($row = mysqli_fetch_array($result)) {
                        echo ("<tr>
                                <td>" . $row['ID'] . "</td>
                                <td>" . $row['Name'] . "</td>
                                <td>" . $row['Email'] . "</td>
                                <td><img src='https://liuclubhouse.000webhostapp.com/" . $row['Picture'] . "' style='width:32px; height:32px; border-radius:50%;'></td>
                             
                                </tr>");
                    }
                    ?>
                </table>
            </div>
        </div>
    </div>
</body>

</html>