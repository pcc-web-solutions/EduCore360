<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Finance || Charges</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewCharge"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Charge</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewCharge" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="charge_code">Unique ID:</label>
                                            <input type="text" name="charge_code" class="form-control " id="charge_code" value="<?= $dmo->generateUid() ?>">
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Description:</label>
                                            <textarea type="text" name="description" class="form-control" id="description" placeholder="Type in here..."></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="type">Charge Type:</label>
                                            <select name="type" class="form-control select2" id="type">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("charge", "type");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="is_recurring">Is Recurring:</label>
                                            <select name="is_recurring"  class="form-control select2" id="is_recurring">
                                                <option value="">--select--</option>
                                                <option value="1">Yes</option>
                                                <option value="0">No</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="recurring_type">Recurring Type:</label>
                                            <select name="recurring_type" class="form-control select2" id="recurring_type">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("charge", "recurring_type");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="income_gl_account">Income GL Account:</label>
                                            <select name="income_gl_account"  class="form-control select2" id="income_gl_account">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getChartOfAccounts(["school_code"=>$user['school_code'],"coa.type"=>"Income"])['status']){
                                                $response = $dmo->getChartOfAccounts(["school_code"=>$user['school_code'],"coa.type"=>"Income"]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$row['no']." - ".$row['name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="expense_gl_account">Expense GL Account:</label>
                                            <select name="expense_gl_account"  class="form-control select2" id="expense_gl_account">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getChartOfAccounts(["school_code"=>$user['school_code'],"coa.type"=>"Expense"])['status']){
                                                $response = $dmo->getChartOfAccounts(["school_code"=>$user['school_code'],"coa.type"=>"Expense"]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$row['no']." - ".$row['name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="department">Department:</label>
                                            <select name="department"  class="form-control select2" id="department">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="normal_charge">Default Amount:</label>
                                            <input type="number" name="normal_charge" class="form-control" id="normal_charge" placeholder="0.00">
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewCharge" >Save</button> 
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
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewCharge')">New</button>
                                    </ol>
                                </div>
                                <h4 class="page-title">Setup School Charges</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tblcharge" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Code</th>
                                <th>Description</th>
                                <th>Type</th>
                                <th>Is Recurring</th>
                                <th>Recurring Type</th>
                                <th>Income GL Account</th>
                                <th>Expense GL Account</th>
                                <th>Default Charge</th>
                            </tr>
                        </thead>
                        <tbody id="tblcharge">
                        <?php
                        if($dmo->getSchoolCharges(["c.school"=>$user['school_code']])['status']){
                        $response = $dmo->getSchoolCharges(["c.school"=>$user['school_code']]); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('charge','charge_code','<?= $id ?>',this)"><?= $dmo->safeData($row['charge_code']) ?></td>
                                <td contentEditable=false onblur="edit('charge','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                <td contentEditable=false onblur="edit('charge','type','<?= $id ?>',this)"><?= $dmo->safeData($row['type']) ?></td>
                                <td contentEditable=false onblur="edit('charge','is_recurring','<?= $id ?>',this)"><?= $dmo->safeData($row['is_recurring']? "Yes" : "No") ?></td>
                                <td contentEditable=false onblur="edit('charge','recurring_type','<?= $id ?>',this)"><?= $dmo->safeData($row['recurring_type']) ?></td>
                                <td contentEditable=false onblur="edit('charge','income_gl_account','<?= $id ?>',this)"><?= $dmo->safeData($row['income_gl_account']) ?></td>
                                <td contentEditable=false onblur="edit('charge','expense_gl_account','<?= $id ?>',this)"><?= $dmo->safeData($row['expense_gl_account']) ?></td>
                                <td contentEditable=false onblur="edit('charge','department','<?= $id ?>',this)"><?= $dmo->safeData($row['department']) ?></td>
                                <td contentEditable=false onblur="edit('charge','normal_charge','<?= $id ?>',this)"><?= $dmo->safeData($row['normal_charge']) ?></td>
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
	$("#tblcharge").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblcharge_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewCharge']").on("click", function(){
        NewCharge();
	})
})
</script>
</body>
</html>