<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Job Titles</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewJobTitle"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Create A New Job Title</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewJobTitle" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="name">Job Title:</label>
                                            <input type="text" name="name" class="form-control " id="name" placeholder="e.g., ICT Officer III">
                                        </div>
                                        <div class="form-group">
                                            <label for="category_id">Job Category</label>
                                            <select name="category_id" class="form-control select2" id="category_id">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getJobCategories()['status']){
                                                    $response = $dmo->getJobCategories(); $count=1;
                                                    foreach ($response['data'] as $row) { 
                                                        echo "<option value=".$row['id'].">".$row['name']." => ".$row['description']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="level_id">Job Level</label>
                                            <select name="level_id" class="form-control select2" id="level_id" >
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getJobLevels()['status']){
                                                    $response = $dmo->getJobLevels(); $count=1;
                                                    foreach ($response['data'] as $row) { 
                                                        echo "<option value=".$row['id'].">".$row['name']." => ".$row['description']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="group_id">Job Group</label>
                                            <select name="group_id" class="form-control select2" id="group_id" >
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getJobGroups()['status']){
                                                    $response = $dmo->getJobGroups(); $count=1;
                                                    foreach ($response['data'] as $row) { 
                                                        echo "<option value=".$row['id'].">".$row['name']." : ".$row['description']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Brief Description:</label>
                                            <textarea type="text" name="description" class="form-control" id="description" placeholder="Give a brief description about the job title..."></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="department">Department:</label>
                                            <select name="department"  class="form-control select2" id="department">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getDepartments(["school_code"=>$user['school_code']])['status']){
                                                $response = $dmo->getDepartments(["school_code"=>$user['school_code']]);
                                                foreach ($response['data'] as $row) {
                                                    echo "<option value=".$row['dept_code'].">".$row['dept_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="job_status">Status</label>
                                            <select name="job_status" class="form-control select2" id="job_status" >
                                                <option value="">--select--</option>
                                                <option value="1" selected>Active</option>
                                                <option value="0">Inactive</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnSaveJobTitle" >Save</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewJobTitle')">Add New</button>
                                </div>
                                <h4 class="page-title">Setup Job Titles</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box w-100">  
                        <table id="tbljobtitle" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap w-100">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Job Title</th>
                                    <th>Job Category</th>
                                    <th>Job Level</th>
                                    <th>Job Group</th>
                                    <th>Description</th>
                                    <th>Department</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbljobtitles">
                            <?php
                            if($dmo->getJobTitles(["school_code"=>$user['school_code']])['status']){
                            $response = $dmo->getJobTitles(["school_code"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur="edit('job_title','title','<?= $id ?>',this)"><?= $dmo->safeData($row['title']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','category_id','<?= $id ?>',this)"><?= $dmo->safeData($row['category']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','level_id','<?= $id ?>',this)"><?= $dmo->safeData($row['level']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','group_id','<?= $id ?>',this)"><?= $dmo->safeData($row['job_group']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','department','<?= $id ?>',this)"><?= $dmo->safeData($row['department']) ?></td>
                                    <td contentEditable=true onblur="edit('job_title','status','<?= $id ?>',this)"><?= $dmo->safeData($row['status']) ?></td>
                                    <td contentEditable=false onblur="edit('job_title','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('job_title','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbljobtitle").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbljobtitle_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveJobTitle']").on("click", function(){
        SaveJobTitle();
	})
})
</script>
</body>
</html>