<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || Permission Keys</title>
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
                                            <li class="breadcrumb-item"><a href="javascript: void(0);">Finance</a></li>
                                            <li class="breadcrumb-item active">User Permission Keys</li>
                                        </ol>
                                </div>
                                <h4 class="page-title">Setup User Permission Keys</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcoa" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>User Role</th>
                                <th>Permission Key</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tblcoa">
                        <?php
                        if($dmo->getPermissionKeys()['status']){
                        $response = $dmo->getPermissionKeys(); $count=1;
                        foreach ($response['data'] as $row) { ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['profile']) ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['permission']) ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['description']) ?></td>
                                <td><a href="<?= "request.php?tkn=".$dmo->storeRoute("super/user_permission.php")."&permission=".$row['permission'] ?>" class="btn btn-xs btn-info"><i class="fas fa-users"></i>&nbsp;Assigned Users</a></td>
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
	$("button[name='btnChartOfAccount']").on("click", function(){
        ChartOfAccount();
	})
})
</script>
</body>
</html>