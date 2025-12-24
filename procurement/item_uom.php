<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Procurement || Stock Item U.O.M</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewUOM" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Item Unit of Measure</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewUOM" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group mb-3">
                                            <label for="unit_name">Unit Name</label>
                                            <input type="text" class="form-control" name="name" id="unit_name" placeholder="e.g. Box of 12 Each" required>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="unit_abbreviation">Abbreviation</label>
                                            <input type="text" class="form-control" name="abbreviation" id="unit_abbreviation" placeholder="e.g. BOX12" required>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="base_unit_id">Base Unit</label>
                                            <select name="base_unit_id" class="form-control select2" id="base_unit_id" required>
                                                <option value="">-- select --</option>
                                                <?php
                                                if($dmo->getBaseUOMs()['status']){
                                                $response = $dmo->getBaseUOMs();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$dmo->safeData($row['base_uom']." (".$row['abbreviation'].")")."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="conversion_factor">Conversion Factor (to base unit)</label>
                                            <input type="number" step="0.01" class="form-control" name="conversion_factor" id="conversion_factor" placeholder="e.g. 12" required>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="is_default">Is Default?</label>
                                            <select class="form-control select2" name="is_default" id="is_default">
                                                <option value="1">Yes</option>
                                                <option value="0" selected>No</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="is_compound">Is Compound Unit?</label>
                                            <select class="form-control select2" name="is_compound" id="is_compound">
                                                <option value="1">Yes</option>
                                                <option value="0">No</option>
                                                <option value="" selected>--choose--</option>
                                            </select>
                                        </div>
                                        <!-- Compound Structure (JSON string) -->
                                        <div class="form-group mb-3">
                                            <label for="compound_structure">Compound Structure (JSON)</label>
                                            <textarea class="form-control" name="compound_structure" id="compound_structure" rows="3" placeholder='e.g. {"contains":12,"unit":"Each"}'></textarea>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="description">Description</label>
                                            <textarea class="form-control" name="description" id="description" rows="2" placeholder="Optional description of this unit"></textarea>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label for="is_active">Is Active?</label>
                                            <select class="form-control select2" name="is_active" id="is_active">
                                                <option value="1" selected>Yes</option>
                                                <option value="0">No</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewUOM" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewUOM')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Item Units of Measure </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tbluom" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Item UOM</th>
                                    <th>Abreviation</th>
                                    <th>Base Unit</th>
                                    <th>Conversion Factor</th>
                                    <th>Is Default</th>
                                    <th>Is Compound</th>
                                    <th>compound_structure</th>
                                    <th>Description</th>
                                    <th>IS Active</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbluoms">
                            <?php
                            if($dmo->getItemUOMs()['status']){
                            $response = $dmo->getItemUOMs(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur='edit("unit_of_measure","name",<?= $id ?>,this)'><?= $dmo->safeData($row['item_uom']) ?></td>
                                    <td contentEditable=true onblur='edit("unit_of_measure","abbreviation",<?= $id ?>,this)'><?= $dmo->safeData($row['abbreviation']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","base_unit_id",<?= $id ?>,this)'><?= $dmo->safeData($row['base_uom']) ?></td>
                                    <td contentEditable=true onblur='edit("unit_of_measure","conversion_factor",<?= $id ?>,this)'><?= $dmo->safeData($row['conversion_factor']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","is_default",<?= $id ?>,this)'><?= $dmo->safeData($row['is_default']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","is_compound",<?= $id ?>,this)'><?= $dmo->safeData($row['is_compound']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","compound_structure",<?= $id ?>,this)'><?= $dmo->safeData($row['compound_structure']) ?></td>
                                    <td contentEditable=true onblur='edit("unit_of_measure","description",<?= $id ?>,this)'><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","is_active",<?= $id ?>,this)'><?= $dmo->safeData($row['is_active']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","created_at",<?= $id ?>,this)'><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur='edit("unit_of_measure","updated_at",<?= $id ?>,this)'><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbluom").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbluom_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewUOM']").on("click", function(){
        saveNewUOM();
	})
})
</script>
</body>
</html>