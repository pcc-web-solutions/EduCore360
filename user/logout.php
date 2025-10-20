<!DOCTYPE html>
<html lang="en">  
    <head>
        <meta charset="utf-8" />
        <title>EC360 || Sign Out</title>
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
                                    <a href="his_admin_logout.php">
                                        <span><img src="asset/images/logo-dark.png" alt="" height="80"></span>
                                    </a>
                                </div>
                                <div class="text-center">
                                    <div class="mt-4">
                                        <div class="logout-checkmark">
                                            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 130.2 130.2">
                                                <circle class="path circle" fill="none" stroke="#4bd396" stroke-width="6" stroke-miterlimit="10" cx="65.1" cy="65.1" r="62.1"/>
                                                <polyline class="path check" fill="none" stroke="#4bd396" stroke-width="6" stroke-linecap="round" stroke-miterlimit="10" points="100.2,40.2 51.5,88.8 29.8,67.5 "/>
                                            </svg>
                                        </div>
                                    </div>
                                    <h3>See you again !</h3>
                                    <p class="text-muted font-13"> You are now successfully sign out. </p>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12 text-center">
                                <p class="text-white">Back to <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="text-white ml-1"><b>Log In</b></a> OR <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/index.php");?>" class="text-white ml-1"><b>HomePage</b></a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php require "page/footer.php"; ?>
        <script src="asset/js/vendor.min.js"></script>
        <script src="asset/js/app.min.js"></script>
    </body>
</html>