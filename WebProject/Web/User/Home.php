<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LIU Club House</title>
    <link rel="stylesheet" href="./css/Home.css">
    <link rel="stylesheet" href="./css/sideTopBar.css">
    <link rel="stylesheet" href="./css/sideBar.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <script src="https://kit.fontawesome.com/e46ff3aebe.js" crossorigin="anonymous"></script>
</head>

<body>
    <?php session_start();
    require_once("../../Config.php");
    include("Sidebar.php"); ?>
    <div id="indexBody">
        <div id="indexBodyGridContainer">

            <?php
            $userId = $_SESSION["UserId"];


            $query = "SELECT * FROM clubs WHERE clubs.ID IN (SELECT ClubID FROM userclub WHERE UserId = '$userId')";
            $result = mysqli_query($con, $query);
            while ($row = mysqli_fetch_array($result)) {
                echo ("<div class='card' style='width: 25rem;'>
            <img src='https://liuclubhouse.000webhostapp.com/" . $row['Logo'] . "' class='card-img-top' alt='...'>
            <div class='card-body'>
                <h5 class='card-title'>" . $row["Name"] . "</h5>
                <p class='card-text'>" . $row["Description"] . "</p>
                <a  href='http://localhost/webproject/Web/User/Club/main.php?club=" . $row["ID"] . "' class='btn btn-primary'>Visit</a>
            </div>
        </div>");
            }


            ?>

            <!-- <div class="card" style="width: 25rem;">
                <img src="../../images/actingClubBg.jpg" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">Acting Club</h5>
                    <p class="card-text">Join our acting club to hone your craft, practice scenes, and perform in a supportive and creative environment. All experience levels welcome!</p>
                    <a href="../actingClub/main/actingMain.html" class="btn btn-primary">Visit</a>
                </div>
            </div>
            <div class="card" style="width: 25rem;">
                <img src="../../images/gamingClubBg.webp" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">Gaming Club</h5>
                    <p class="card-text">Join our gaming club for fun, competition, and community. Play a variety of games with fellow gamers.</p>
                    <a href="../gamingClub/main/gamingMain.html" class="btn btn-primary">Visit</a>
                </div>
            </div>
            <div class="card" style="width: 25rem;">
                <img src="../../images/musicClubbg.jpg" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">Music Club</h5>
                    <p class="card-text">Join our music club for jam sessions, performances, and music appreciation. All skill levels welcome!.</p>
                    <a href="../musicClub/main/musicMain.html" class="btn btn-primary">Visit</a>
                </div>
            </div>
            <div class="card" style="width: 25rem;">
                <img src="../../images/photoClubBg.webp" class="card-img-top" alt="...">
                <div class="card-body">
                    <h5 class="card-title">Photography Club</h5>
                    <p class="card-text">Join our photography club to learn and improve your photography skills, share your work, and explore new techniques.</p>
                    <a href="../photoClub/main/photoMain.html" class="btn btn-primary">Visit</a>
                </div>
            </div> -->
        </div>
    </div>
    </div>
    <div class="footer">
        <h1>
            <span style="color: blue">L</span>
            <span style="color: red">I</span>
            <span style="color: green">U</span>
            Club House
        </h1>
        <div>
            <p>All rights reserved</p>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
</body>

</html>