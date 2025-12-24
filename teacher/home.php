<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Teacher || Home</title>
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