<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Classes</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewClass" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Class</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewClass" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="class_code">Class Unique Code:</label>
                                            <input type="text" name="class_code" class="form-control " id="class_code" value="<?= $dmo->generateUid() ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="class_name">Description:</label>
                                            <input type="text" name="class_name" class="form-control " id="class_name" placeholder="e.g., Form 1">
                                        </div>
                                        <div class="form-group">
                                            <label for="class_number">Class Number:</label>
                                            <input type="text" name="class_number" class="form-control " id="class_number" placeholder="e.g., 1">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewClass" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewClass')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Classes </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblclass" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Code</th>
                                    <th>Form</th>
                                    <th>Index</th>
                                </tr>
                            </thead>
                            <tbody id="tblclasses">
                            <?php
                            if($dmo->getClasses(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                            $response = $dmo->getClasses(["school_code"=>$dmo->safeData($user['school_code'])]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("class","school",<?= $id ?>,this)'><?= $dmo->safeData($row['school']) ?></td>
                                    <td contentEditable=false onblur='edit("class","class_code",<?= $id ?>,this)'><?= $dmo->safeData($row['class_code']) ?></td>
                                    <td contentEditable=true onblur='edit("class","class_name",<?= $id ?>,this)'><?= $dmo->safeData($row['class_name']) ?></td>
                                    <td contentEditable=true onblur='edit("class","class_number",<?= $id ?>,this)'><?= $dmo->safeData($row['class_number']) ?></td>
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
	$("#tblclass").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblclass_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewClass']").on("click", function(){
        saveNewClass();
	})
})
</script>
</body>
</html>