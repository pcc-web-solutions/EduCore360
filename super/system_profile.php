<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || System Profiles</title>
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
                                            <li class="breadcrumb-item active">System Profiles</li>
                                        </ol>
                                </div>
                                <h4 class="page-title">View System Profiles</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcoa" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Profile ID</th>
                                <th>Profile Name</th>
                                <th>Is Available</th>
                                <th>Default Page</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tblcoa">
                        <?php
                        if($dmo->getUserRoles()['status']){
                        $response = $dmo->getUserRoles(); $count=1;
                        foreach ($response['data'] as $row) { ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['role_id']) ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['role_name']) ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['is_available']? "Yes" : "No") ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['default_page'] != null? $_SERVER['HTTP_HOST']."/request.php?tkn=".$dmo->storeRoute($row['default_page']): null) ?></td>
                                <td contentEditable=false><?= $dmo->safeData($row['status']) ?></td>
                                <td><?= $row['default_page'] != null? '<button type="button" name="btnFollowPage" class="btn btn-xs btn-info" ><i class=" fa-like"></i>&nbsp;Follow Page</button>' : NULL ?></td>
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
	$("button[name='btnFollowPage']").on("click", function(){
        btnFollowPage();
	})
})
</script>
</body>
</html>