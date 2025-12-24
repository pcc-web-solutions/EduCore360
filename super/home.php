<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Super || Home</title>
        <?php require "page/header.php";?>
        <style>
        .chart-box {
            width: 100%;
            height: 400px;
            background-color: white;
            border-radius:  0px 0px 8px 8px;
            padding: 10px;
        }
        .chart-box-header{
            width: 100%;
            height: 40px;
            background-color: darkcyan;
            margin: 0 auto;
            padding: 0 auto;
            border-radius: 8px 8px 0px 0px;
        }
        .chart-box-header-title{
            font-weight:bold;
            color: silver;
            text-align: left;
            margin: 0 auto;
            padding: 5px 5px 5px 5px;
            height: auto;
            max-height: 40px;
        }
        </style>
    </head>
    
    <body>
        <div id="wrapper">
            <?php require __DIR__."/nav.php"; ?>
            <?php require __DIR__."/sidebar.php"; ?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <p class="page-title"><?= "Welcome ".$user['displayname']."!" ?></p>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("super/student.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getStudents()['status']? $count = sizeof($dmo->getStudents()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Students</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users  font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getTeachers()['status']? $count = sizeof($dmo->getTeachers()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Teachers</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("super/staff.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users  font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getSupportStaffs()['status']? $count = sizeof($dmo->getSupportStaffs()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Support Staffs</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users   font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getVendors()['status']? $count = sizeof($dmo->getVendors()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Vendors</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                        </div>
                        <div class="row">
                            
                            <div class="col-xl-6 col-md-6 col-sm-6 col-xs-6">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("super/school.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users  font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getSchools()['status']? $count = sizeof($dmo->getSchools()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Registered Schools</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                            <div class="col-xl-6 col-md-6 col-sm-6 col-xs-6">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("super/user.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users  font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getUserList()['status']? $count = sizeof($dmo->getUserList()['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">System Users</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>

                        </div>
                    </div>
                </div>
                <?php include "page/footer.php"; ?>
            </div>
        </div>
        <div class="rightbar-overlay"></div>
        <?php include "page/script.php" ?>
        <script src="asset/libs/flatpickr/flatpickr.min.js"></script>
        <script src="asset/libs/jquery-knob/jquery.knob.min.js"></script>
        <script src="asset/libs/jquery-sparkline/jquery.sparkline.min.js"></script>
        <script type="text/javascript" src="asset/libs/chart.js/Chart.min.js"></script>
        <script type="text/javascript" src="asset/js/dms.js"></script>
    </body>
</html>