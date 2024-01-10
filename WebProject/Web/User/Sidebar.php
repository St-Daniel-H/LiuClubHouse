<div id="topBar">
    <div id="burgerAndLogo">
        <button id="Burger" class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasWithBothOptions" aria-controls="offcanvasWithBothOptions">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="offcanvas offcanvas-start" data-bs-scroll="true" tabindex="-1" id="offcanvasWithBothOptions" aria-labelledby="offcanvasWithBothOptionsLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasWithBothOptionsLabel">
                    <span style="color: blue">L</span>
                    <span style="color: red">I</span>
                    <span style="color: green">U</span>
                    <span style="color: rgb(110, 110, 110)"> Club House</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div id="drawer" class="offcanvas-body">
                <ul>
                    <?php

                    ?>
                    <li id="activeSideBar">
                        <i class="fa-solid fa-house"></i>
                        &nbsp;Classes
                    </li>
                    <li>
                        <i class="fa-solid fa-calendar-days"></i>
                        &nbsp;Calender
                    </li>
                    <hr>
                    <p>enrolled</p>
                    <?php
                    $userId = $_SESSION["UserId"];

                    echo ($userId);
                    $query = "SELECT * FROM clubs WHERE clubs.ID IN (SELECT ClubID FROM userclub WHERE UserID = '$userId')";
                    $result = mysqli_query($con, $query);
                    while ($row = mysqli_fetch_array($result)) {
                        echo ("<li>
                            &nbsp;
                            <img src='https://liuclubhouse.000webhostapp.com/" . $row['Logo'] . "' height='32' width='32' style='border-radius: 50%;'>&nbsp;
                            <a href='http://localhost/webproject/Web/User/Club/main.php?club=" . $row["ID"] . "'>" . $row['Name'] . "</a>
                        </li>");
                    }


                    ?>

                </ul>
            </div>
        </div>
        <h2>
            <span style="color: blue">L</span>
            <span style="color: red">I</span>
            <span style="color: green">U</span>
            <span style="color: rgb(110, 110, 110)"> Club House</span>
        </h2>
    </div>
    <?php
    // Check if the current path is /webproject/Web/User/Club
    $currentPath = $_SERVER['REQUEST_URI'];
    $desiredPath = '/webproject/Web/User/Club';

    if (strpos($currentPath, $desiredPath) !== false) {
        $clubId = "";
        if (isset($_GET['club'])) {
            $clubId = $_GET['club'];
        }
        // Render the additional content only if the path matches
        echo '
             <div id="switch">
                 <h4 id="switchActive" class="switchOption">
                     <a>Stream</a>
                 </h4>
                 <h4 style="margin-left: 50px" class="switchOption">
                     &nbsp;
                     <a href="./events?club=' . $clubId . '">Events</a>
                 </h4>
                 <h4 style="margin-left: 50px" class="switchOption">
                     &nbsp;
                     <a  href="./people?club=' . $clubId . '">People</a>
                 </h4>
             </div>';
    }
    $userId = $_SESSION["UserId"];


    $query = "SELECT Picture FROM users WHERE ID  = '$userId'";
    $result = mysqli_query($con, $query);
    $row = mysqli_fetch_array($result);
    echo ("
                            <img src='https://liuclubhouse.000webhostapp.com/" . $row['Picture'] . "' 
                        ");



    ?>
    <img id="userProfileImg" src="../../images/userProfilePicture.png">
</div>