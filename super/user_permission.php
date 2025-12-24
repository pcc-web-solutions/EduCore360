<?php require_once __DIR__."/uac.php"; $conditions = isset($_GET['permission'])? ["pk.permission"=>$_GET['permission']] : [] ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || User Permissions</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
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