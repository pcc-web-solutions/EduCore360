<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Benefit Types</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewBenefitType"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Benefit Type</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewBenefitType" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="benefit_type_code">Benefit Type Code:</label>
                                            <input type="text" name="benefit_type_code" class="form-control " id="benefit_type_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="benefit_type_name">Benefit Type Name:</label>
                                            <input type="text" name="benefit_type_name" class="form-control " id="benefit_type_name" placeholder="e.g Health Insurance Cover">
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
                                                <?php $result = $dmo->getEnumValues("benefit_type", "recurring_type");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="quantity">Quantity</label>
                                            <input type="number" name="quantity" class="form-control " id="quantity" placeholder="e.g 5">
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewBenefitType" >Create</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewBenefitType')">New</button>
                                </div>
                                <h4 class="page-title">Benefit Types</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblbenefittype" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Benefit Type</th>
                                    <th>Is Recurring</th>
                                    <th>Recurring Type</th>
                                    <th>Quantity</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tblbenefittypes">
                            <?php
                            if($dmo->getBenefitTypes(["school_code"=>$user['school_code']])['status']){
                            $response = $dmo->getBenefitTypes(["school_code"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('benefit_type','benefit_type_code','<?= $id ?>',this)"><?= $dmo->safeData($row['benefit_type_code']) ?></td>
                                    <td contentEditable=true onblur="edit('benefit_type','benefit_type_name','<?= $id ?>',this)"><?= $dmo->safeData($row['benefit_type_name']) ?></td>
                                    <td contentEditable=false onblur="edit('benefit_type','is_recurring','<?= $id ?>',this)"><?= $dmo->safeData($row['is_recurring']) ?></td>
                                    <td contentEditable=false onblur="edit('benefit_type','recurring_type','<?= $id ?>',this)"><?= $dmo->safeData($row['recurring_type']) ?></td>
                                    <td contentEditable=true onblur="edit('benefit_type','quantity','<?= $id ?>',this)"><?= $dmo->safeData($row['quantity']) ?></td>
                                    <td contentEditable=false onblur="edit('benefit_type','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('benefit_type','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
    $("#tblbenefittype").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblbenefittype_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewBenefitType']").on("click", function(){
        NewBenefitType();
	})
	$("input[name='is_recurring']").on("change", function(){
        $('#recurring_type_field').toggleClass('hidden');
	})
})
</script>
</body>
</html>