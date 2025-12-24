<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Finance Office</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/pay_slip.php"); ?>">My Pay Slip</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Procurement Store</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/purchase_requisition.php"); ?>">Purchase Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/store_requisition.php"); ?>">Store Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/transfer_order.php"); ?>">Transfer Order</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Human Resource</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/apply_leave.php"); ?>">Apply Leave</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/staff_appraisal.php"); ?>">Staff Appraisal</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/upload_document.php"); ?>">Upload Documents</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Training & Meetings</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/training_program.php"); ?>">Training Programs</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/track_participation.php"); ?>">Track Participation</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("support/my_certification.php"); ?>">My Certification</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>