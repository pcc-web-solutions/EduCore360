<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">   
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-cog"></i>
                        <span>System Settings</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_category.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Job Categories</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_group.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Job Groups</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_level.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Job Levels</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/skill.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Skills</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_title.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Job Titles</a></li>                    
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_skill.php"); ?>"><i class="far fa-circle"></i>&nbsp;Create Job Skill</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-users"></i>
                        <span>Recruitment & Training</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_posting.php"); ?>"><i class="far fa-circle"></i>&nbsp;Job Postings</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_applicant.php"); ?>"><i class="far fa-circle"></i>&nbsp;Job Applicants</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/job_application.php"); ?>"><i class="far fa-circle"></i>&nbsp;Job Applications</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/interview_scheduling.php"); ?>"><i class="far fa-circle"></i>&nbsp;Interview Scheduling</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/hiring_decision.php"); ?>"><i class="far fa-circle"></i>&nbsp;Hiring Decisions</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/onboarding_checklist.php"); ?>"><i class="far fa-circle"></i>&nbsp;Onboarding Checklist</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-users"></i>
                        <span>Staff Management</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/staff.php"); ?>"><i class="far fa-circle"></i>&nbsp;Staff Members</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/upload_document.php"); ?>"><i class="far fa-circle"></i>&nbsp;Staff Documents</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/benefit_type.php"); ?>"><i class="far fa-circle"></i>&nbsp;Benefit Types</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/staff_benefit.php"); ?>"><i class="far fa-circle"></i>&nbsp;Staff Benefits</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-chalkboard"></i>
                        <span>Staff Training</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/training_program.php"); ?>"><i class="far fa-circle"></i>&nbsp;Training Programs</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/track_participation.php"); ?>"><i class="far fa-circle"></i>&nbsp;Track Participation</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/certification_upload.php"); ?>"><i class="far fa-circle"></i>&nbsp;Certification Uploads</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-bar-chart"></i>
                        <span>Staff Perfomance</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/perfomance_review.php"); ?>"><i class="far fa-circle"></i>&nbsp;Performance Reviews</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/perfomance_appraisal.php"); ?>"><i class="far fa-circle"></i>&nbsp;Performance Appraisal</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="far fa-clock"></i>
                        <span>Staff Attendance</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/attendance_list.php"); ?>"><i class="far fa-circle"></i>&nbsp;Attendance List</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/upload_attendance.php"); ?>"><i class="far fa-circle"></i>&nbsp;Upload Attendance</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/staff_attendance_report.php"); ?>"><i class="far fa-circle"></i>&nbsp;Attendance Reports</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-home"></i>
                        <span>Leave Management</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/leave_type.php"); ?>"><i class="far fa-circle"></i>&nbsp;Leave Types</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/leave_application.php"); ?>"><i class="far fa-circle"></i>&nbsp;Leave Applications</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/on_leave_list.php"); ?>"><i class="far fa-circle"></i>&nbsp;On Leave List</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/leave_balance.php"); ?>"><i class="far fa-circle"></i>&nbsp;Leave Balances</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-refresh"></i>
                        <span>Staff Transfers</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/transfer_application.php"); ?>"><i class="far fa-circle"></i>&nbsp;Transfer Applications</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>