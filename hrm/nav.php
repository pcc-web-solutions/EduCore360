<?php require_once __DIR__."/uac.php"; ?>
    <div class="modal fade" id="SwitchUserRole">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info">
                    <h4 class="modal-title text-white">Change User Roll</h4>
                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                </div>
                <div class="modal-body">
                    <form id="frmSwitchUserRole" autocomplete="off" method="post">
                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                        <div class="form-group">
                            <label for="user_role">User Role:</label>
                            <select name="user_role" class="form-control select2" id="user_role">
                                <option value="">--select--</option>
                                <?php
                                    $response = $dmo->getUserProfiles($user['role']);
                                    foreach($response as $row) { 
                                        echo "<option value=".$row['can_switch_to'].">".$row['role_name']."</option>";
                                    }
                                ?>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSwitchUserRole" onclick="SwitchUserRole()">Switch Role</button> 
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="BackupDatabase">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info">
                    <h4 class="modal-title text-white">Database Backup</h4>
                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                </div>
                <div class="modal-body">
                    <form id="frmBackupDatabase" autocomplete="off" method="post">
                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                        <div class="form-group">
                            <label for="format">Choose Format:</label>
                            <select name="format" class="form-control select2" id="format" onchange="displayInfo(this)">
                                <option value="" data-extra="">--select--</option>
                                <option value="sql" data-extra="Download a full SQL dump of the database, including table structures, indexes, and data. Ideal for restoring the database on another server or system.">.sql</option>
                                <option value="sql.gz" data-extra="Download a compressed SQL dump (.sql.gz) of the database. Combines full backup capabilities with reduced file size for easier storage and faster transfer.">.sql.gz</option>
                                <option value="csv" data-extra="Export all tables in a structured, comma-separated format. Suitable for opening in spreadsheet applications like Microsoft Excel or importing into other systems.">.csv</option>
                                <option value="xlsx" data-extra="Download all tables in an Excel spreadsheet format, with each table in a separate worksheet. Best for easy viewing, analysis, and reporting.">.xlsx</option>
                                <option value="json" data-extra="Export the database in a lightweight, structured JSON format, ideal for data interchange between applications and web services.">.json</option>
                                <option value="xml" data-extra="Download the database in XML format, preserving hierarchical relationships. Commonly used for system integrations and data migrations.">.xml</option>
                                <option value="yaml" data-extra="Export data in YAML format, which is human-readable and commonly used for configuration files and structured data storage.">.x-yaml</option>
                            </select>
                        </div>
                        <div id="description"></div>
                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnBackupDatabase" onclick="BackupDatabase();"><i class='icon fas fa-download'></i> Download</button> 
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="navbar-custom">
        <ul class="list-unstyled topnav-menu float-right mb-0">
            
            <li class="dropdown notification-list">
                <a class="nav-link dropdown-toggle nav-user mr-0 waves-effect waves-light" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                    <img src="<?= $user['photo'];?>" alt="profile" class="rounded-circle">
                    <span class="pro-user-name ml-1">
                        <?= $user['displayname'];?> <i class="mdi mdi-chevron-down"></i> 
                    </span>
                </a>
                <div class="dropdown-menu dropdown-menu-right profile-dropdown ">
                    <a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/profile.php");?>" class="dropdown-item notify-item">
                        <i class="fe-user"></i>
                        <span>My Profile</span>
                    </a>
                    <?php if(sizeof($dmo->getUserProfiles($user['role']))>0){ ?>
                        <a href="#" data-toggle="modal" onclick="showModal('#SwitchUserRole');" class="dropdown-item notify-item">
                            <i class="fa fa-refresh"></i>
                            <span>Change Roll</span>
                        </a>
                    <?php } ?>
                    <?php if($user['role'] == 'sa'){ ?>
                        <a href="#" data-toggle="modal" onclick="showModal('#BackupDatabase');" class="dropdown-item notify-item">
                            <i class="fe-database"></i>
                            <span>DB Backup</span>
                        </a>
                    <?php } ?>
                    <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/logout_partial.php");?>" class="dropdown-item notify-item">
                        <i class="fe-log-out"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </li>
        </ul>

        <div class="logo-box">
            <a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/home.php"); ?>" class="logo text-center">
                <span class="logo-lg">
                    <img src="asset/images/logo-light.png" alt="" height="50">
                </span>
                <span class="logo-sm">
                    <img src="asset/images/app-icon-light.png" alt="" height="30">
                </span>
            </a>
        </div>

        <ul class="list-unstyled topnav-menu topnav-menu-left m-0">
            <li>
                <button class="button-menu-mobile waves-effect waves-light">
                    <i class="fe-menu"></i>
                </button>
            </li>

            <li class="dropdown d-none d-lg-block">
                <a class="nav-link dropdown-toggle waves-effect waves-light" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                    Register New
                    <i class="mdi mdi-chevron-down"></i> 
                </a>
                <div class="dropdown-menu">
                    <a href="<?= "request.php?tkn=".$dmo->storeRoute("hrm/register_user.php");?>" class="dropdown-item">
                        <i class="fe-users mr-1"></i>
                        <span>User</span>
                    </a>
                </div>
            </li>
            <!-- <li class="dropdown d-lg-block">
                <a class="nav-link dropdown-toggle waves-effect waves-light" data-toggle="dropdown" href="#" role="button" aria-haspopup="false" aria-expanded="false">
                    Reports
                    <i class="mdi mdi-chevron-down"></i> 
                </a>
                <div class="dropdown-menu">
                    <a href="#" class="dropdown-item">
                        <i class="fe-book-open mr-1"></i>
                        <span>General Analysis</span>
                    </a>
                    <a href="#" class="dropdown-item">
                        <i class="fe-book-open mr-1"></i>
                        <span>Analysis Per School</span>
                    </a>
                </div>
            </li> -->
        </ul>
    </div>
    <script>
        function displayInfo(obj){
            let info = $(obj).children('option:selected').data('extra');
            if(info != ""){
                $("#description").html("<div class='alert alert-info alert-dismissible'><button type='button' class='close' ata-dismiss='alert' aria-hidden='true'>&times;</button><h5><i class='icon fas fa-info'></i> Info</h5>"+info+"</div>");
            } else {
                $("#description").empty();
            }
        }
    </script>