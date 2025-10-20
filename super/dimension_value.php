<?php
require_once "controller.php";
isset($_GET['id'])? $conditions = ["dv.dim_id"=>$_GET['id']] : $conditions = [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || Manage Dimension Values</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewDimensionValue" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Dimension Value</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewDimensionValue" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school">School Code:</label>
                                            <select name="school" class="form-control select2" id="school" onchange='loadSelect("dimensions", "fetch.php", "dim_id", this); loadSelect("number_series", "fetch.php", "rct_nos", this); loadSelect("number_series", "fetch.php", "inv_nos", this); loadSelect("users", "fetch.php", "incharge", this)'>
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getSchools()['status']){
                                                    $response = $dmo->getSchools(); $count=1;
                                                    foreach ($response['data'] as $row) { 
                                                        echo "<option value=".$row['school_code'].">".$row['school_code']." - ".$row['school_name']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="dim_id">Dimension Name:</label>
                                            <select name="dim_id" class="form-control select2" id="dim_id" onchange="$('#filter_name').val($(this).children('option:selected').text())">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="dv_name">Value Name:</label>
                                            <input type="text" name="dv_name" class="form-control" id="dv_name" placeholder="Main">
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Description:</label>
                                            <input type="text" name="description" class="form-control" id="description" placeholder="Main School Name">
                                        </div>
                                        <div class="form-group">
                                            <label for="rct_nos">Receipt No. Series:</label>
                                            <select name="rct_nos" class="form-control select2" id="rct_nos">
                                                <option value="">--select--</option>
                                                <option value="new">Create New</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="inv_nos">Invoice No. Series:</label>
                                            <select name="inv_nos" class="form-control select2" id="inv_nos">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="incharge">In-Charge:</label>
                                            <select name="incharge" class="form-control select2" id="incharge">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="filter_name">Filter Name:</label>
                                            <input type="text" name="filter_name" class="form-control" id="filter_name" placeholder="Branch" readonly>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSaveDimensionValue" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewDimensionValue')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Setup Dimension Values </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tbldimensionvalue" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>School</th>
                                <th>Dimension</th>
                                <th>Value Name</th>
                                <th>Description</th>
                                <th>Receipt No. Series</th>
                                <th>Invoice No. Series</th>
                                <th>In-Charge</th>
                                <th>Caption</th>
                            </tr>
                        </thead>
                        <tbody id="tbldimensionvalues">
                        <?php
                        if($dmo->getDimensionValues( $conditions)['status']){
                        $response = $dmo->getDimensionValues( $conditions); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('dim_value','school','<?= $id ?>',this)"><?= $dmo->safeData($row['school_code']." - ".$row['school_name']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','dv_code','<?= $id ?>',this)"><?= $dmo->safeData($row['dim_name']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','dv_name','<?= $id ?>',this)"><?= $dmo->safeData($row['dv_name']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','inv_nos','<?= $id ?>',this)"><?= $dmo->safeData($row['rct_nos']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','rct_nos','<?= $id ?>',this)"><?= $dmo->safeData($row['inv_nos']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','incharge','<?= $id ?>',this)"><?= $dmo->safeData($row['incharge']) ?></td>
                                <td contentEditable=true onblur="edit('dim_value','filter_name','<?= $id ?>',this)"><?= $dmo->safeData($row['filter_name']) ?></td>
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
	$("#tbldimensionvalue").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbldimensionvalue_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveDimensionValue']").on("click", function(){
        saveDimensionValue();
	})

    $("select[name=rct_nos]").change(function(){
        if($(this).children("option:selected").val() == "new"){
            showModal("NewNoSeries")
        }
    })
    $("select[name=inv_nos]").change(function(){
        if($(this).children("option:selected").val() == "new"){
            showModal("NewNoSeries")
        }
    })
	$("button[name='btnSaveNoSeries']").on("click", function(){
        saveNoSeries();
	})
})
</script>
</body>
</html>