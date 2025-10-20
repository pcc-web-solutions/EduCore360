<?php require "user/user_controller.php"; ?>
<!DOCTYPE html>
<html lang="en"> 
<head>
    <meta charset="utf-8" />
    <title>EC360 || Password Reset</title>
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
                                <a href="#">
                                    <span><img src="asset/images/logo-dark.png" alt="" height="80"></span>
                                </a>
                                <p class="text-muted mb-1 mt-1">Enter your email address and we'll send you an email with instructions to reset your password.</p>
                            </div>

                            <form method="post" id="frmSubmitEmail" autocomplete="off">
                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                <div class="form-group mb-3">
                                    <label for="email_address">Email address</label>
                                    <input class="form-control" name="email" type="email" id="emailaddress" required="" placeholder="Enter your email">
                                </div>
                                <div class="form-group mb-0 text-center">
                                    <button class="btn btn-info btn-block" name="btnSubmitEmail" type="submit" onclick="submitEmail();">Submit Email</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="row mt-3">
                        <div class="col-12 text-center">
                            <p class="text-white"><a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="text-white ml-1"><b>I remember my password</b></a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php require "page/footer.php"; ?>
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