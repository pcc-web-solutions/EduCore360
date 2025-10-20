<?php require_once "controller.php";?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || My Profile</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <ol class="breadcrumb m-0">
                                        <li class="breadcrumb-item"><a href="javascript: void(0);">Dashboard</a></li>
                                        <li class="breadcrumb-item active">Profile</li>
                                    </ol>
                                </div>
                                <h4 class="page-title"><?= $user['school_name'];?> </h4>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-4 col-xl-4">
                            <div class="card-box text-center">
                                <img src="<?= $user['photo'];?>" class="rounded-circle avatar-lg img-thumbnail"
                                    alt="profile-image">
                                <h4 class="mb-0"><?= $user['displayname'];?></h4>
                                <p class="text-muted"><strong>Logged in as:</strong> <?= "@".$user['role']; ?></p>
                                <div class="text-left mt-3">
                                    <p class="text-muted mb-2 font-13"><strong>Member Since :</strong> <span class="ml-2"><?= $user['regdate'];?></span></p>
                                    <p class="text-muted mb-2 font-13"><strong>Last login date :</strong> <span class="ml-2 "><?= $user['lastlogindate'].' '.$user['lastlogintime'];?></span></p>
                                </div>
                                <div class="text-left mt-3">
                                    <h6 class="text-muted mb-2 font-13"><strong>My Responsibilities :</strong></h6>
                                    <p class="text-muted mb-2 font-11" disabled><?=  $user['responsibilities'];?></p>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8 col-xl-8">
                            <div class="card-box">
                                <ul class="nav nav-pills navtab-bg nav-justified">
                                    <li class="nav-item">
                                        <a href="#aboutme" data-toggle="tab" aria-expanded="false" class="nav-link active">
                                            Update Profile
                                        </a>
                                    </li>
                                    
                                    <li class="nav-item">
                                        <a href="#settings" data-toggle="tab" aria-expanded="false" class="nav-link">
                                            Change Password
                                        </a>
                                    </li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane show active" id="aboutme">
                                        <form id="frmUpdateProfile" method="post" enctype="multipart/form-data" autocomplete="off">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <h5 class="mb-4 text-uppercase bg-light p-2"><i class="mdi mdi-account-circle mr-1"></i> Personal Info</h5>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="displayname">Display Name</label>
                                                        <input type="text" name="displayname"  class="form-control" id="displayname" placeholder="<?= $user['displayname'];?>">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="contact">Phone Number</label>
                                                        <input type="text" name="contact" class="form-control" id="contact" placeholder="<?= $user['contact'];?>">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="email">Email Address</label>
                                                        <input type="email" name="email" class="form-control" id="email" placeholder="<?= $user['email'];?>">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="profile">Profile Picture</label>
                                                        <input type="file" accept="image/jpeg" name="profile" class="form-control" id="profile">
                                                    </div>
                                                </div>
                                            </div> 
                                            <div class="text-right">
                                                <button type="submit" class="btn btn-success waves-effect waves-light mt-2" name="btnUpdateProfile"><i class="mdi mdi-content-save"></i> Save</button>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="tab-pane" id="settings">
                                        <form id="frmUpdatePassword" method="post" enctype="multipart/form-data" autocomplete="off">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <h5 class="mb-4 text-uppercase bg-light p-2"><i class="mdi mdi-account-circle mr-1"></i> Login Info</h5>
                                            <div class="form-group">
                                                <label for="old_password">Old Password</label>
                                                <input type="password" class="form-control" name="old_password" placeholder="Enter Old Password">
                                            </div>
                                            <div class="form-group">
                                                <label for="new_password">New Password</label>
                                                <input type="password" class="form-control" name="new_password" placeholder="Enter New Password">
                                            </div>
                                            <div class="text-right">
                                                <button type="submit" class="btn btn-success waves-effect waves-light mt-2" name="btnUpdatePassword"><i class="mdi mdi-content-save"></i> Update Password</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <?php require "page/footer.php"; ?>
        </div>
    </div>
    <?php require "page/script.php"; ?>
    <script src="asset/js/dms.js"></script>
    <script>
        $(function(){
            $("button[name='btnUpdateProfile']").click(function(){
                userUpdateProfile();
            });
            $("button[name='btnUpdatePassword']").click(function(){
                userUpdatePassword();
            })
        })
    </script>
</body>
</html>