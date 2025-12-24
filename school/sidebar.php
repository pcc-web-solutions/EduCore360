<?php require_once __DIR__."/uac.php"; ?>
<div class="left-side-menu">
    <div class="slimscroll-menu">
        <div id="sidebar-menu">
            <ul class="metismenu" id="side-menu">   
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-cog"></i>
                        <span>System Setups</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/nos.php"); ?>">Number Series</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/class.php"); ?>">Setup Classes</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/stream.php"); ?>">Setup Streams</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/student.php"); ?>">Setup Students</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/term.php"); ?>">Setup Terms</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/subject.php"); ?>">Setup Subjects</a></li>
                    </ul>
                </li>
                <li>
                    <a href="javascript: void(0);">
                        <i class="fas fa-users"></i>
                        <span>User Setups</span>
                        <span class="menu-arrow"></span>
                    </a>
                    <ul class="nav-second-level" aria-expanded="false">
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/user.php"); ?>">Manage Users</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/user_permission.php"); ?>">User Permissions</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/permission_key.php"); ?>">Permissions Keys</a></li>
                        <li><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/system_profile.php"); ?>">Available Profiles</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="clearfix"></div>
    </div>
</div>