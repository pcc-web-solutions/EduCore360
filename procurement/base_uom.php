<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Procurement || Base U.O.M</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewBaseUOM" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Base Unit of Measure</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewBaseUOM" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group mb-3">
                                            <label for="base_unit_name">Unit Name</label>
                                            <input type="text" class="form-control" name="name" id="base_unit_name" placeholder="e.g. Kilogram" required>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="base_unit_abbr">Abbreviation</label>
                                            <input type="text" class="form-control" name="abbreviation" id="base_unit_abbr" placeholder="e.g. kg" required>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="unit_category">Category</label>
                                            <select name="category_id" class="form-control select2" id="unit_category" required>
                                                <option value="">-- select --</option>
                                                <?php
                                                if($dmo->getUnitCategories()['status']){
                                                $response = $dmo->getUnitCategories();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$dmo->safeData($row['unit_category'].": ".$row['description'])."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="description">Description</label>
                                            <textarea type="text" class="form-control" name="description" id="description" placeholder="" ></textarea>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="symbol">Symbol</label>
                                            <input type="text" class="form-control" name="symbol" id="symbol">
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="si_unit">Is an SI Unit</label>
                                            <select name="si_unit" class="form-control select2" id="si_unit">
                                            <option value="0" selected>No</option>
                                            <option value="1">Yes</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="is_active">Is Active?</label>
                                            <select name="is_active" class="form-control select2" id="is_active">
                                            <option value="1" selected>Yes</option>
                                            <option value="0">No</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewBaseUOM" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewBaseUOM')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Base Unit of Measures </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblbaseuom" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Base UOM</th>
                                    <th>Abreviation</th>
                                    <th>Category</th>
                                    <th>Description</th>
                                    <th>Symbol</th>
                                    <th>SI Unit</th>
                                    <th>Is Active</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tblbaseuoms">
                            <?php
                            if($dmo->getBaseUOMs()['status']){
                            $response = $dmo->getBaseUOMs(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur='edit("base_unit_of_measure","name",<?= $id ?>,this)'><?= $dmo->safeData($row['base_uom']) ?></td>
                                    <td contentEditable=true onblur='edit("base_unit_of_measure","abbreviation",<?= $id ?>,this)'><?= $dmo->safeData($row['abbreviation']) ?></td>
                                    <td contentEditable=false onblur='edit("base_unit_of_measure","category_id",<?= $id ?>,this)'><?= $dmo->safeData($row['category_name']) ?></td>
                                    <td contentEditable=true onblur='edit("base_unit_of_measure","description",<?= $id ?>,this)'><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=true onblur='edit("base_unit_of_measure","symbol",<?= $id ?>,this)'><?= $dmo->safeData($row['symbol']) ?></td>
                                    <td contentEditable=false onblur='edit("base_unit_of_measure","si_unit",<?= $id ?>,this)'><?= $dmo->safeData($row['si_unit']) ?></td>
                                    <td contentEditable=false onblur='edit("base_unit_of_measure","is_active",<?= $id ?>,this)'><?= $dmo->safeData($row['is_active']) ?></td>
                                    <td contentEditable=false onblur='edit("base_unit_of_measure","created_at",<?= $id ?>,this)'><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur='edit("base_unit_of_measure","updated_at",<?= $id ?>,this)'><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tblbaseuom").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblbaseuom_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewBaseUOM']").on("click", function(){
        saveNewBaseUOM();
	})
})
</script>
</body>
</html>