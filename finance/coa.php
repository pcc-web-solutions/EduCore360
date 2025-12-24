<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Finance || Chart of Accounts</title>
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
                                            <li class="breadcrumb-item active">Chart of accounts</li>
                                        </ol>
                                </div>
                                <h4 class="page-title">Setup Chart of Accounts</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcoa" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Code</th>
                                <th>Chart of Account</th>
                                <th>Type</th>
                                <th>Category</th>
                                <th>Sub Account Of</th>
                                <th>Typical Balance</th>
                                <th>Opening Balance</th>
                                <th>Is Active</th>
                            </tr>
                        </thead>
                        <tbody id="tblcoa">
                        <?php
                        if($dmo->getChartOfAccounts(["school_code"=>$user['school_code']])['status']){
                        $response = $dmo->getChartOfAccounts(["school_code"=>$user['school_code']]); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','no','<?= $id ?>',this)"><?= $dmo->safeData($row['no']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','name','<?= $id ?>',this)"><?= $dmo->safeData($row['name']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','type','<?= $id ?>',this)"><?= $dmo->safeData($row['type']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','category','<?= $id ?>',this)"><?= $dmo->safeData($row['category']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','parent','<?= $id ?>',this)"><?= $dmo->safeData($row['parent']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','typical_balance','<?= $id ?>',this)"><?= $dmo->safeData($row['typical_balance']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','opening_balance','<?= $id ?>',this)"><?= $dmo->safeData($row['opening_balance']) ?></td>
                                <td contentEditable=false onblur="edit('chart_of_account','is_active','<?= $id ?>',this)"><?= $dmo->safeData($row['is_active']) ?></td>
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