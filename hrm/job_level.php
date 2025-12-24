<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Job Levels</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewJobLevel"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Job Level</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewJobLevel" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="name">Job Level Name</label>
                                            <input type="text" name="name" class="form-control " id="name" placeholder="Entry Level">
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Brief Description</label>
                                            <textarea type="text" name="description" class="form-control" id="description" placeholder="Give a brief description about the job level..."></textarea>
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnSaveJobLevel" >Save</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewJobLevel')">Add New</button>
                                </div>
                                <h4 class="page-title">Setup Job Levels</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tbljoblevel" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Job Level</th>
                                    <th>Description</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbljoblevels">
                            <?php
                            if($dmo->getJobLevels()['status']){
                            $response = $dmo->getJobLevels(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur="edit('job_level','name','<?= $id ?>',this)"><?= $dmo->safeData($row['name']) ?></td>
                                    <td contentEditable=true onblur="edit('job_level','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=false onblur="edit('job_level','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('job_level','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbljoblevel").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbljoblevel_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveJobLevel']").on("click", function(){
        SaveJobLevel();
	})
})
</script>
</body>
</html>