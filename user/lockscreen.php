<?php require "controller.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>EC360 || Lockscreen</title>
    <?php require "page/header.php";?>
</head>

<body class="authentication-bg authentication-bg-pattern">
    <div class="account-pages mt-5 mb-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 col-xl-5">
                    <div class="card bg-pattern">
                        <div class="card-body p-4">  
                            <div class="text-center w-75 m-auto">
                                <a href="#">
                                    <span><img src="asset/images/logo-dark.png" alt="" height="80"></span>
                                </a>
                                <p class="text-muted mb-1 mt-1">Session locked due to inactivity. Please enter your password to continue:</p>
                            </div>
                            <?php 
                            if(isset($_GET["success"])) {
                                echo "<div class='alert alert-success alert-dismissible'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h5><i class='icon fas fa-check'></i> Success</h5>".$_GET['success']."</div>";
                            }
                            ?>
                            <?php 
                            if(isset($_GET["info"])) {
                                echo "<div class='alert alert-info alert-dismissible'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h5><i class='icon fas fa-info'></i> Info!</h5>".$_GET['info']."</div>";
                            }
                            ?>
                            <?php 
                            if(isset($_GET["warning"])) {
                                echo "<div class='alert alert-warning alert-dismissible'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h5> Warning <i class='icon fas fa-exclamation'></i></h5>".$_GET['warning']."</div>";
                            }
                            ?>
                            <?php 
                            if(isset($_GET["error"])) {
                                echo "<div class='alert alert-danger alert-dismissible'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h5><i class='icon fas fa-ban'></i> Error!</h5>".$_GET['error']."</div>";
                            }
                            ?>
                            <form method='post' id="frmUnlockScreen" autocomplete="off">
                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                <div class="form-group mb-3">
                                    <label for="password">Password</label>
                                    <input class="form-control" name="password" type="password" id="password" required="" placeholder="Enter your password">
                                </div>

                                <div class="form-group mb-0 text-center">
                                    <button class="btn btn-success btn-flat float-right" name="btnUnlockScreen" type="submit" onclick="UnlockScreen()">Unlock Screen</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php require "page/footer.php";?>
<?php require "page/script.php"; ?>
<script type="text/javascript" src="asset/js/dms.js"></script>  
</body>
</html>
