<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">
                <li>
                    <a href="javascript: void(0);">
                        <i class="fa fa-money"></i>
                        <span>Finance Office</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/pay_slip.php"); ?>">My Pay Slip</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Procurement Store</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/purchase_requisition.php"); ?>">Purchase Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/store_requisition.php"); ?>">Store Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/transfer_order.php"); ?>">Transfer Order</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Human Resource</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/apply_leave.php"); ?>">Apply Leave</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/staff_appraisal.php"); ?>">Staff Appraisal</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/upload_document.php"); ?>">Upload Documents</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-book-open"></i>
                        <span>Director Of Studies</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/assigned_classes.php"); ?>">Assigned Classes</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/teaching_timetable.php"); ?>">Teaching Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/remedial_timetable.php"); ?>">Remedial Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/lesson_plan.php"); ?>">My Lesson Plan</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/schemes_of_work.php"); ?>">Schemes of Work</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-chalkboard"></i>
                        <span>Class Management</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/class_attendance.php"); ?>">Class Attendance</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/exam_attendance.php"); ?>">Exam Attendance</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-bar-chart"></i>
                        <span>Examination Office</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/exam_timetable.php"); ?>">Exam Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("teacher/mark_entry.php"); ?>">Enter Marks</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>