<?php require "user/user_controller.php"; ?>
<!DOCTYPE html>
<html lang="en"> 
<head>
    <meta charset="utf-8" />
    <title>EC360 || Reset Password</title>
    <?php include("page/header.php");?>
</head>
<body class="authentication-bg authentication-bg-pattern">
    <div class="account-pages mt-5 mb-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6 col-xl-5">
                    <div class="card bg-pattern">
                        <div class="card-body p-4">
                            <div class="text-center w-75 m-auto">
                                <a href="his_doc_reset_pwd.php">
                                    <span><img src="asset/images/logo-dark.png" alt="" height="80"></span>
                                </a>
                                <p class="text-muted mb-1 mt-1">Please enter your new password and submit to reset. You will be redirected back to the login page.</p>
                            </div>

                            <form method="post" id="frmResetPassword">
                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                <div class="form-group mb-3">
                                    <label for="email_address">Email Address</label>
                                    <input class="form-control" name="email" type="email" id="email_address" value="<?= $_SESSION['account']; ?>" readonly>
                                </div>
                                <div class="form-group mb-3">
                                    <label for="new_password">New Password</label>
                                    <input class="form-control" name="new_password" type="password" id="new_password" required="" placeholder="Enter new password">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="confirm_password">Confirm Password</label>
                                    <input class="form-control" name="confirm_password" type="password" id="confirm_password" required="" placeholder="Re-type your new password">
                                </div>
                                <div class="form-group mb-0 text-center">
                                    <button class="btn btn-info btn-block" name="btnResetPassword" type="submit" onclick="resetPassword();">Reset Password</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12 text-center">
                            <p class="text-white-50"><a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="text-white ml-1"><b>I remember my password</b></a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php require "page/footer.php"; ?>
<?php require "page/script.php"; ?>
<script type="text/javascript" src="asset/js/dms.js"></script>
</body>
</html>