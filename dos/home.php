<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>D.O.S || Home</title>
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
                                    <tem class="page-title"><?= "Welcome ".$user['displayname']."!" ?></tem>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/student.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getStudents(["school_code"=>$user['school_code']])['status']? $count = sizeof($dmo->getStudents(["school_code"=>$user['school_code']])['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Active Students</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/teacher.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-users font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getTeachers(["school_code"=>$user['school_code']])['status']? $count = sizeof($dmo->getTeachers(["school_code"=>$user['school_code']])['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Teachers</p>
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
                                                <i class="fas fa-school font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getDepartments(["school_code"=>$user['school_code']])['status']? $count = sizeof($dmo->getDepartments(["school_code"=>$user['school_code']])['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Departments</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/stream.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-chalkboard font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?php $dmo->getStreams(["school_code"=>$user['school_code']])['status']? $count = sizeof($dmo->getStreams(["school_code"=>$user['school_code']])['data']) : $count = 0; echo number_format($count, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Class Rooms</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xl-4 col-md-4 col-sm-4 col-xs-4">
                                <a href="<?=  "request.php?tkn=".$dmo->storeRoute("support/approval_request.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Approval Requests</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-4 col-md-4 col-sm-4 col-xs-4">
                                <a href="<?=  "request.php?tkn=".$dmo->storeRoute("support/pending_approval.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Pending Approvals</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-4 col-md-4 col-sm-4 col-xs-4">
                                <a href="<?=  "request.php?tkn=".$dmo->storeRoute("support/pending_approval.php"); ?>">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Pending Approvals</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-9">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Previous %age Rate</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-9">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Current %age Rate</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-9">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">%age Deviation Rate</p>
                                            </div>
                                        </div>
                                    </div>
                                </div></a>
                            </div>
                            <div class="col-xl-3 col-md-3 col-sm-3 col-xs-3">
                                <a href="#">
                                <div class="widget-rounded-circle card-box">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="avatar-lg rounded-circle bg-soft-success border-success border">
                                                <i class="fas fa-hourglass-half font-22 avatar-title text-success"></i>
                                            </div>
                                        </div>
                                        <div class="col-9">
                                            <div class="text-right">
                                                <h3 class="text-success mt-1"><span data-plugin="counterup"><?= number_format(0, 0); ?></span></h3>
                                                <p class="text-muted mb-1 text-truncate">Target age% Rate</p>
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