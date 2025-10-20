<?php require "user/user_controller.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>EC360 || Sign Up</title>
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
                                <p class="text-muted mb-1 mt-1">Please provide the specified information and proceed to create your account</p>
                            </div>
                            <form method='post' id="frmSignUp" autocomplete="off" enctype = "multipart/form-data">
                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                <div class="form-group mb-3">
                                    <label for="employee_id">ID Number</label>
                                    <input class="form-control" name="id_no" type="text" id="id_no" required="" placeholder="ID Number">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="alias">Alias</label>
                                    <input class="form-control" name="alias" type="text" id="alias" required="" placeholder="Your preffered login name">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="user_password">Create a strong password </label>
                                    <input class="form-control" name="user_password" type="password" id="user_password" required="" placeholder="Create Password">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="confirm_password">Confirm Password</label>
                                    <input class="form-control" name="confirm_password" type="password" id="confirm_password" required="" placeholder="Re-enter Password">
                                </div>
                                <div class="form-group mb-0 text-center">
                                    <button class="btn btn-success btn-flat float-right" name="btnSignup" type="submit" onclick="userSignUp();">Sign Up </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12 text-center">
                            <p class="text-white">Already have an account? <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="text-white ml-1"><b>Sign In</b></a></p>
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