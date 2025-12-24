<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || System Users</title>
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
                                            <li class="breadcrumb-item active">User Accounts</li>
                                        </ol>
                                </div>
                                <h4 class="page-title">Setup User Accounts</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcoa" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Code</th>
                                <th>User Name</th>
                                <th>Display Name</th>
                                <th>User Role</th>
                                <th>Profile</th>
                                <th>Email Address</th>
                                <th>Contact</th>
                                <th>Reg. Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tblcoa">
                        <?php
                        if($dmo->getUserList(["school_code"=>$user['school_code']])['status']){
                        $response = $dmo->getUserList(["school_code"=>$user['school_code']]); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('user','userid','<?= $id ?>',this)"><?= $dmo->safeData($row['userid']) ?></td>
                                <td contentEditable=false onblur="edit('user','username','<?= $id ?>',this)"><?= $dmo->safeData($row['username']) ?></td>
                                <td contentEditable=false onblur="edit('user','displayname','<?= $id ?>',this)"><?= $dmo->safeData($row['displayname']) ?></td>
                                <td contentEditable=false onblur="edit('user','role','<?= $id ?>',this)"><?= $dmo->safeData($row['role']) ?></td>
                                <td contentEditable=false onblur="edit('user','profile','<?= $id ?>',this)"><?= $dmo->safeData($row['profile']) ?></td>
                                <td contentEditable=false onblur="edit('user','email','<?= $id ?>',this)"><?= $dmo->safeData($row['email']) ?></td>
                                <td contentEditable=false onblur="edit('user','contact','<?= $id ?>',this)"><?= $dmo->safeData($row['contact']) ?></td>
                                <td contentEditable=false onblur="edit('user','regdate','<?= $id ?>',this)"><?= $dmo->safeData($row['regdate']) ?></td>
                                <td contentEditable=false onblur="edit('user','status','<?= $id ?>',this)"><?= $dmo->safeData($row['status']? "Active" : "Inactive") ?></td>
                                <td><a href="<?= "request.php?tkn=".$dmo->storeRoute("school/user_permission.php")."&user=".$row['userid'] ?>" class="btn btn-xs btn-<?=$row['status']? "danger" : "success";?>" ><i class="fas fa-<?=$row['status']? "lock" : "lock-open"?>"></i>&nbsp;<?= $row['status']? "Deactivate" : "Activate" ?></a></td>
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