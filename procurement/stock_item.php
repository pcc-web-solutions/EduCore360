<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Procurement || Stock Item</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewStockItem" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Stock Item</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewStockItem" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>

                                        <!-- Name -->
                                        <div class="form-group mb-3">
                                            <label for="name">Item Name</label>
                                            <input type="text" name="name" id="name" class="form-control" required>
                                        </div>

                                        <!-- Description -->
                                        <div class="form-group mb-3">
                                            <label for="description">Description</label>
                                            <textarea name="description" id="description" class="form-control" rows="2"></textarea>
                                        </div>

                                        <!-- Category -->
                                        <div class="form-group mb-3">
                                            <label for="category_id">Category</label>
                                            <select name="category_id" id="category_id" class="form-control select2">
                                                <option value="">-- select --</option>
                                                <?php
                                                if($dmo->getItemCategories()['status']){
                                                $response = $dmo->getItemCategories();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$dmo->safeData($row['item_category']." (".$row['description'].")")."</option>";
                                                } }?>
                                            </select>
                                        </div>

                                        <!-- Type -->
                                        <div class="form-group mb-3">
                                            <label for="type">Item Type</label>
                                            <select name="type" id="type" class="form-control select2" required>
                                                <option value="">-- select --</option>
                                                <option value="inventory">Inventory</option>
                                                <option value="non-inventory">Non-Inventory</option>
                                                <option value="service">Service</option>
                                                <option value="fixed-asset">Fixed Asset</option>
                                            </select>
                                        </div>

                                        <!-- Base Unit of Measure -->
                                        <div class="form-group mb-3">
                                            <label for="base_unit_of_measure_id">Base Unit of Measure</label>
                                            <select name="base_unit_of_measure_id" id="base_unit_of_measure_id" class="form-control select2">
                                                <option value="">-- select --</option>
                                                <?php
                                                if($dmo->getBaseUOMs()['status']){
                                                $response = $dmo->getBaseUOMs();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$dmo->safeData($row['base_uom']." (".$row['abbreviation'].")")."</option>";
                                                } }?>
                                            </select>
                                        </div>

                                        <!-- Is Active -->
                                        <div class="form-group mb-3">
                                            <label for="is_active">Is Active?</label>
                                            <select name="is_active" id="is_active" class="form-control select2">
                                            <option value="1">Yes</option>
                                            <option value="0">No</option>
                                            </select>
                                        </div>

                                        <!-- Purchase Cost -->
                                        <div class="form-group mb-3">
                                            <label for="purchase_cost">Purchase Cost</label>
                                            <input type="number" step="0.01" name="purchase_cost" id="purchase_cost" class="form-control">
                                        </div>

                                        <!-- Is Depreciable -->
                                        <div class="form-group mb-3">
                                            <label for="is_depreciable">Is Depreciable?</label>
                                            <select name="is_depreciable" id="is_depreciable" class="form-control select2">
                                            <option value="1">Yes</option>
                                            <option value="0" selected>No</option>
                                            </select>
                                        </div>

                                        <!-- Depreciation Rate -->
                                        <div class="form-group mb-3">
                                            <label for="depreciation_rate">Depreciation Rate (%)</label>
                                            <input type="number" step="0.01" name="depreciation_rate" id="depreciation_rate" class="form-control">
                                        </div>

                                        <!-- Quantity in Stock -->
                                        <div class="form-group mb-3">
                                            <label for="quantity_in_stock">Quantity in Stock</label>
                                            <input type="number" step="0.01" name="quantity_in_stock" id="quantity_in_stock" class="form-control">
                                        </div>

                                        <!-- Reorder Level -->
                                        <div class="form-group mb-3">
                                            <label for="reorder_level">Reorder Level</label>
                                            <input type="number" step="0.01" name="reorder_level" id="reorder_level" class="form-control">
                                        </div>

                                        <!-- Asset Tag -->
                                        <div class="form-group mb-3">
                                            <label for="asset_tag">Asset Tag</label>
                                            <input type="text" name="asset_tag" id="asset_tag" class="form-control">
                                        </div>

                                        <!-- Purchase Date -->
                                        <div class="form-group mb-3">
                                            <label for="purchase_date">Purchase Date</label>
                                            <input type="date" name="purchase_date" id="purchase_date" class="form-control">
                                        </div>

                                        <!-- Last Service Date -->
                                        <div class="form-group mb-3">
                                            <label for="last_service_date">Last Service Date</label>
                                            <input type="date" name="last_service_date" id="last_service_date" class="form-control">
                                        </div>

                                        <!-- Expected Service Lifetime -->
                                        <div class="form-group mb-3">
                                            <label for="expected_service_lifetime">Expected Service Lifetime (Months)</label>
                                            <input type="number" name="expected_service_lifetime" id="expected_service_lifetime" class="form-control">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewStockItem" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewStockItem')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Stock Items </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblstockitem" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Item Name</th>
                                    <th>Description</th>
                                    <th>Category</th>
                                    <th>Item Type</th>
                                    <th>Base UOM</th>
                                    <th>Purchase Cost</th>
                                    <th>Is Depreciable</th>
                                    <th>Depreciation Rate</th>
                                    <th>Quantity In Stock</th>
                                    <th>Re-Order Level</th>
                                    <th>Asset Tag</th>
                                    <th>Purchase Date</th>
                                    <th>Last Service Date</th>
                                    <th>Expected Lifetime</th>
                                    <th>Is Active</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbluoms">
                            <?php
                            if($dmo->getStockItems(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                            $response = $dmo->getStockItems(["school_code"=>$dmo->safeData($user['school_code'])]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","name",<?= $id ?>,this)'><?= $dmo->safeData($row['item_name']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","description",<?= $id ?>,this)'><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","category_id",<?= $id ?>,this)'><?= $dmo->safeData($row['item_category']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","type",<?= $id ?>,this)'><?= $dmo->safeData($row['item_type']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","base_unit_of_measure_id",<?= $id ?>,this)'><?= $dmo->safeData($row['base_uom']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","purchase_cost",<?= $id ?>,this)'><?= $dmo->safeData($row['purchase_cost']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","is_depreciable",<?= $id ?>,this)'><?= $dmo->safeData($row['is_depreciable']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","depreciation_rate",<?= $id ?>,this)'><?= $dmo->safeData($row['depreciation_rate']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","quantity_in_stock",<?= $id ?>,this)'><?= $dmo->safeData($row['quantity_in_stock']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","reorder_level",<?= $id ?>,this)'><?= $dmo->safeData($row['reorder_level']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","asset_tag",<?= $id ?>,this)'><?= $dmo->safeData($row['asset_tag']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","purchase_date",<?= $id ?>,this)'><?= $dmo->safeData($row['purchase_date']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","last_service_date",<?= $id ?>,this)'><?= $dmo->safeData($row['last_service_date']) ?></td>
                                    <td contentEditable=true onblur='edit("stock_item","expected_service_lifetime",<?= $id ?>,this)'><?= $dmo->safeData($row['expected_service_lifetime']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","is_active",<?= $id ?>,this)'><?= $dmo->safeData($row['is_active']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","created_at",<?= $id ?>,this)'><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur='edit("stock_item","updated_at",<?= $id ?>,this)'><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tblstockitem").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblstockitem_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewStockItem']").on("click", function(){
        saveNewStockItem();
	})
})
</script>
</body>
</html>