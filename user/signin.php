<?php require "user/user_controller.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>EC360 || Sign In</title>
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
                                <p class="text-muted mb-1 mt-1">Please type in your login credentials to proceed.</p>
                            </div>

                            <form method='post' id="frmSignin" autocomplete="off">
                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
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
                                <div class="form-group mb-3">
                                    <label for="username">Username</label>
                                    <input class="form-control" name="username" type="text" id="username" required="" placeholder="Enter your username">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="password">Password</label>
                                    <input class="form-control" name="password" type="password" id="password" required="" placeholder="Enter your password">
                                </div>

                                <div class="form-group mb-0 text-center">
                                    <button class="btn btn-success btn-flat float-left" name="btnSignin" type="submit" onclick="userSignin()">Sign In </button>
                                    <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/index.php");?>" class="btn btn-secondary btn-flat float-right"><b>Back Home</b></a>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12 text-center">
                            <p><a href="<?= "request.php?tkn=".$dmo->storeRoute("user/step1_password_reset.php");?>" class="text-white ml-1"><b>Reset Password</b></a></p>
                            <p><a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signup.php");?>" class="text-white ml-1"><b>Create an account</b></a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php require "page/footer.php";?>
<script src="asset/js/vendor.min.js"></script>
<script src="asset/libs/jquery-validation/jquery.validate.min.js"></script>
<script src="asset/libs/jquery-validation/additional-methods.min.js"></script>
<script src="asset/libs/select2/js/select2.full.min.js"></script>

<!-- cryptoJs -->
<script src="asset/libs/crypto-js/core.js"></script>
<script src="asset/libs/crypto-js/cipher-core.js"></script>
<script src="asset/libs/crypto-js/aes.js"></script>
<script src="asset/libs/crypto-js/enc-base64.js"></script>

<!-- libsodium -->
<script src="asset/libs/sodium.js"></script>
<script src="asset/js/app.min.js"></script>
<script src="asset/js/dms.js"></script> 
</body>
</html>