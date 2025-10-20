<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Leave Types</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewLeaveType"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Leave Type</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewLeaveType" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="leave_type_code">Leave Type Code:</label>
                                            <input type="text" name="leave_type_code" class="form-control " id="leave_type_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="leave_type_name">Leave Type Name:</label>
                                            <input type="text" name="leave_type_name" class="form-control " id="leave_type_name" placeholder="e.g Maternity">
                                        </div>
                                        <div class="form-group">
                                            <label for="applies_to">Applies To (Gender):</label>
                                            <select name="applies_to" class="form-control select2" id="applies_to">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("leave_type", "applies_to");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="no_of_days_off">Number of Days Off</label>
                                            <input type="number" name="no_of_days_off" class="form-control " id="no_of_days_off" placeholder="e.g 90">
                                        </div>
                                        <div class="form-group">
                                            <label for="maximum_leaves">Maximum Number of Leaves Allowed</label>
                                            <input type="number" name="maximum_leaves" class="form-control " id="maximum_leaves" placeholder="e.g 1">
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewLeaveType" >Create</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewLeaveType')">New</button>
                                </div>
                                <h4 class="page-title">Available Leave Types</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblleavetype" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Leave Type</th>
                                    <th>Applies To</th>
                                    <th>No. of Days</th>
                                    <th>Maximum Leaves</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tblleavetypes">
                            <?php
                            if($dmo->getLeaveTypes(["school_code"=>$user['school_code']])['status']){
                            $response = $dmo->getLeaveTypes(["school_code"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_type_code','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_type_code']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','leave_type_name','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_type_name']) ?></td>
                                    <td contentEditable=false onblur="edit('leave_type','applies_to','<?= $id ?>',this)"><?= $dmo->safeData($row['applies_to']) ?></td>
                                    <td contentEditable=true onblur="edit('leave_type','no_of_days_off','<?= $id ?>',this)"><?= $dmo->safeData($row['no_of_days_off']) ?></td>
                                    <td contentEditable=true onblur="edit('leave_type','maximum_leaves','<?= $id ?>',this)"><?= $dmo->safeData($row['maximum_leaves']) ?></td>
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
    $("#tblleavetype").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblleavetype_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewLeaveType']").on("click", function(){
        NewLeaveType();
	})
})
</script>
</body>
</html>