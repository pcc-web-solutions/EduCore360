<?php require_once __DIR__."/uac.php"; $conditions = isset($_GET['permission'])? ["permission"=>$_GET['permission']] : ["user"=>$user['userid']] ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || User Permissions</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewSubject" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Subject</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewSubject" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school">School Code:</label>
                                            <select name="school"  class="form-control select2" id="school" onchange='loadSelect("classes", "fetch.php", "class", this); loadSelect("subject_groups", "fetch.php", "group", this); loadSelect("subject_departments", "fetch.php", "department", this)'>
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getSchools()['status']){
                                                $response = $dmo->getSchools();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['school_code'].">".$row['school_code']." - ".$row['school_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="class">Class Code:</label>
                                            <select name="class" class="form-control select2" id="class">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="subject_code">Subject Code:</label>
                                            <input type="text" name="subject_code" class="form-control " id="subject_code" placeholder="e.g., 451">
                                        </div>
                                        <div class="form-group">
                                            <label for="subject_name">Subject Name:</label>
                                            <input type="text" name="subject_name" class="form-control " id="subject_name" placeholder="e.g., Computer Studies">
                                        </div>
                                        <div class="form-group">
                                            <label for="group">Group Code:</label>
                                            <select name="group" class="form-control select2" id="group">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="department">Department Code:</label>
                                            <select name="department" class="form-control select2" id="department">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="category">Subject Category:</label>
                                            <select name="category" class="form-control select2" id="category">
                                                <option value="">--select--</option>
                                                <option value="Compulsory">Compulsory</option>
                                                <option value="Optional">Optional</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewSubject" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <ol class="breadcrumb m-0">
                                        <li class="breadcrumb-item"><button type="button" class="btn btn-success float-right" onclick="showModal('#NewUserPermission')"><i class="fas fa-plus-circle"></i>&nbspNew</button></li>
                                    </ol>
                                </div>
                                <h4 class="page-title">Setup User Permissions</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcoa" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>User</th>
                                <th>Permission</th>
                                <th>Is Allowed</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tblcoa">
                        <?php
                        if($dmo->getUserPermission($conditions)['status']){
                        $response = $dmo->getUserPermission($conditions); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('user_permission','user','<?= $id ?>',this)"><?= $dmo->safeData($row['user']) ?></td>
                                <td contentEditable=false onblur="edit('user_permission','permission','<?= $id ?>',this)"><?= $dmo->safeData($row['permission']) ?></td>
                                <td contentEditable=false onblur="edit('user_permission','is_allowed','<?= $id ?>',this)"><?= $dmo->safeData($row['is_allowed']? "Allowed" : "Denied") ?></td>
                                <td><a href="#" id="upermission"><i class="<?= $row['is_allowed']? "fa fa-block text-danger" : "fa fa-check text-success" ?>"></i>&nbsp;<?= $row['is_allowed']? "Deny" : "Allow" ?></a></td>
                            </tr>
                        <?php $count++; } }?>
                        </tbody>
                    </table>
                    </div>
                </div>
            </div>
            <?php require "page/footer.php"; ?>
        </div>
    </div>
<div class="rightbar-overlay"></div>

<?php require "page/script.php"; ?>
<script type="text/javascript" src="asset/js/dms.js"></script>
<script type="text/javascript">
$(function(){
	$("#tblcoa").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblcoa_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("#upermission").on("click", function(){
        alert($(this).innerTEXT);
	})
})
</script>
</body>
</html>