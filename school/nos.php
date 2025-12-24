<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Number Series</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewNoSeries" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Number Series</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewNoSeries" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="ns_code">Code Series:</label>
                                            <input type="text" name="ns_code" class="form-control " id="ns_code" value="<?= $dmo->generateUid() ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="ns_name">Number Series:</label>
                                            <input type="text" name="ns_name" class="form-control " id="ns_name" placeholder="BRCT">
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Description:</label>
                                            <input type="text" name="description" class="form-control " id="description" placeholder="Bungoma Receipts">
                                        </div>
                                        <div class="form-group">
                                            <label for="startno">Starting Number:</label>
                                            <input type="number" name="startno" class="form-control" id="startno" placeholder="1000">
                                        </div>
                                        <div class="form-group">
                                            <label for="endno">Ending Number:</label>
                                            <input type="number" name="endno" class="form-control" id="endno" placeholder="9999">
                                        </div>
                                        <div class="form-group">
                                            <label for="lastused">Last Used</label>
                                            <input type="number" name="lastused" class="form-control" id="lastused" placeholder="1000">
                                        </div>
                                        <div class="form-group">
                                            <label for="canskip">Can Skip?</label>
                                            <select name="canskip" class="form-control select2" id="canskip">
                                                <option value="0">No</option>
                                                <option value="1">Yes</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="category">Category</label>
                                            <select name="category" class="form-control select2" id="category" placeholder="1000">
                                                <option value="">--select--</option>
                                                <option value="invoice">Invoices</option>
                                                <option value="receipt">Receipts</option>
                                                <option value="Payment">Payment</option>
                                                <option value="Student">Student</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSaveNoSeries" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewNoSeries')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Number Series </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblnos" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Code</th>
                                    <th>Series</th>
                                    <th>Description</th>
                                    <th>Start Number</th>
                                    <th>End Number</th>
                                    <th>Last Used</th>
                                    <th>Can Skip</th>
                                    <th>Category</th>
                                </tr>
                            </thead>
                            <tbody id="tblnoss">
                            <?php
                            if($dmo->getNoSeries(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                            $response = $dmo->getNoSeries(["school_code"=>$dmo->safeData($user['school_code'])]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('no_series','school','<?= $id ?>',this)"><?= $dmo->safeData($row['school_code']." - ".$row['school_name']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','ns_code','<?= $id ?>',this)"><?= $dmo->safeData($row['ns_code']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','ns_name','<?= $id ?>',this)"><?= $dmo->safeData($row['ns_name']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','startno','<?= $id ?>',this)"><?= $dmo->safeData($row['startno']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','endno','<?= $id ?>',this)"><?= $dmo->safeData($row['endno']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','lastused','<?= $id ?>',this)"><?= $dmo->safeData($row['lastused']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','canskip','<?= $id ?>',this)"><?= $dmo->safeData($row['canskip']) ?></td>
                                    <td contentEditable=true onblur="edit('no_series','category','<?= $id ?>',this)"><?= $dmo->safeData($row['category']) ?></td>
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
	$("#tblnos").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblnos_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveNoSeries']").on("click", function(){
        saveNoSeries();
	})
})
</script>
</body>
</html>