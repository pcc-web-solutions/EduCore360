<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || Manage Dimensions</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewDimension"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Dimension</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewDimension" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="dim_name">Dimension Name</label>
                                            <input type="text" name="dim_name" class="form-control" id="dim_name" placeholder="School Branch">
                                        </div>
                                        <div class="form-group">
                                            <label for="dim_description">Brief Description</label>
                                            <textarea type="text" name="dim_description" class="form-control" id="dim_description" placeholder="Give a brief description..."></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSaveDimension" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewDimension')"><i class="fas fa-plus"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Setup Dimensions</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tbldimension" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Dimension Name</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="tbldimension">
                        <?php
                        if($dmo->getDimensions()['status']){
                        $response = $dmo->getDimensions(); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=true onblur="edit('dimension','dim_name','<?= $id ?>',this)"><?= $dmo->safeData($row['dim_name']) ?></td>
                                <td contentEditable=true onblur="edit('dimension','dim_description','<?= $id ?>',this)"><?= $dmo->safeData($row['dim_description']) ?></td>
                                <td><a href="<?= "request.php?tkn=".$dmo->storeRoute("super/dimension_value.php")."&id=".$row['dim_id']; ?>" class="btn btn-xs btn-success" >Dimension Values</a></td>
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
	$("#tbldimension").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbldimension_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveDimension']").on("click", function(){
        saveDimension();
	})
})
</script>
</body>
</html>