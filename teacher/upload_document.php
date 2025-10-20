<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Teacher || Upload Documents</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewDocumentUpload"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Upload A New Document</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewDocumentUpload" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school">School Code</label>
                                            <input type="text" name="school" class="form-control" id="school" value="<?= $user['school_code']?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="file_id">File Identity Code</label>
                                            <input type="text" name="file_id" class="form-control" id="file_id" value="<?= $dmo->generateUid()?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="staff">Staff. Name:</label>
                                            <select name="staff"  class="form-control select2" id="staff">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getStaffs(["stf.school"=>$user['school_code']])['status']){
                                                $response = $dmo->getStaffs(["stf.school"=>$user['school_code']]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['staff_code'].">".$row['first_name']." ".$row['last_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="document_type">Document Type:</label>
                                            <select name="document_type" class="form-control select2" id="document_type">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("staff_file", "document_type");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="file_path">File Path</label>
                                            <input type="file" name="file_path" accept="application/pdf" class="form-control" id="file_path">
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnUploadDocument" ><i class="fa fa-upload"></i>&nbspUpload</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewDocumentUpload')">Add New</button>
                                </div>
                                <h4 class="page-title">Staff Document Uploads</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tbldocumentupload" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Staff. Name</th>
                                    <th>Document Type</th>
                                    <th>File Path</th>
                                    <th>Uploaded At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbldocumentuploads">
                            <?php
                            if($dmo->getDocumentUploads()['status']){
                            $response = $dmo->getDocumentUploads(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','file_id','<?= $id ?>',this)"><?= $dmo->safeData($row['file_id']) ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','staff','<?= $id ?>',this)"><?= $dmo->safeData($row['staff_name']) ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','document_type','<?= $id ?>',this)"><?= $dmo->safeData($row['document_type']) ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','file_path','<?= $id ?>',this)"><?= $dmo->safeData($row['file_path']) ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','uploaded_at','<?= $id ?>',this)"><?= $dmo->safeData($row['uploaded_at']) ?></td>
                                    <td contentEditable=false onblur="edit('staff_file','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbldocumentupload").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbldocumentupload_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnUploadDocument']").on("click", function(){
        UploadStaffDocument();
	})
})
</script>
</body>
</html>