<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Leave Balances</title>
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
                                    <button type="button" class="btn btn-success float-right" onclick="<?php // $dmo->recalculateLeaveBalances($user['school_code']); ?>"><i class="fa fa-refresh"></i>&nbsp;Re-calculate</button>
                                </div>
                                <h4 class="page-title">Leave Balances</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblleavebalance" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Staff Name</th>
                                    <th>Leave Type</th>
                                    <th>Total Leave</th>
                                    <th>Leave Used</th>
                                    <th>Leave Remaining</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tblleavebalances">
                            <?php
                            if($dmo->getLeaveBalances(["school_code"=>$user['school_code']])['status']){
                            $response = $dmo->getLeaveBalances(["school_code"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_balance_code','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_balance_code']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','staff_code','<?= $id ?>',this)"><?= $dmo->safeData($row['staff_name']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_type','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_type']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','total_leave','<?= $id ?>',this)"><?= $dmo->safeData($row['total_leave']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_used','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_used']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_remaining','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_remaining']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
    $("#tblleavebalance").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblleavebalance_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewLeaveBalance']").on("click", function(){
        NewLeaveBalance();
	})
})
</script>
</body>
</html>