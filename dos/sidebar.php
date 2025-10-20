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
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/pay_slip.php"); ?>">My Pay Slip</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Procurement Store</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/purchase_requisition.php"); ?>">Purchase Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/store_requisition.php"); ?>">Store Requisition</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/transfer_order.php"); ?>">Transfer Order</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-folder"></i>
                        <span>Human Resource</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/apply_leave.php"); ?>">Apply Leave</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/staff_appraisal.php"); ?>">Staff Appraisal</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/upload_document.php"); ?>">Upload Documents</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-users"></i>
                        <span>Registration Office</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/student.php"); ?>">Admitted Student</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/teacher.php"); ?>">Registered Teachers</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-book-open"></i>
                        <span>Academic Module</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/assigned_classes.php"); ?>">Assigned Classes</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/lesson_plan.php"); ?>">Lesson Plans</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/schemes_of_work.php"); ?>">Schemes of Work</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-chalkboard"></i>
                        <span>Class Management</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/teaching_timetable.php"); ?>">Teaching Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/remedial_timetable.php"); ?>">Remedial Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/class_attendance.php"); ?>">Class Attendance</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/exam_attendance.php"); ?>">Exam Attendance</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-bar-chart"></i>
                        <span>Examination Office</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/competency.php"); ?>">Competency</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/assessment.php"); ?>">Assessments</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/assessment_result.php"); ?>">Assessment Results</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/exam_timetable.php"); ?>">Exam Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/mark_entry.php"); ?>">Enter Marks</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-cog"></i>
                        <span>System Settings</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/class.php"); ?>">Setup Classes</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/stream.php"); ?>">Setup Streams</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/student.php"); ?>">Setup Students</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/term.php"); ?>">Setup Terms</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/subject.php"); ?>">Setup Subjects</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/paper.php"); ?>">Setup Papers</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/config_teaching_timetable.php"); ?>">Class Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/config_remedial_timetable.php"); ?>">Remedial Timetable</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("dos/config_exam_timetable.php"); ?>">Exam Timetable</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>