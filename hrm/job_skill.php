<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Job Skills</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewJobSkill"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Map A New Job Skill</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewJobSkill" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="job_title_id">Job Title:</label>
                                            <select name="job_title_id" class="form-control select2" id="job_title_id">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getJobTitles()['status']){
                                                    $response = $dmo->getJobTitles(); $count=1; 
                                                    isset($_GET['id'])? $selected_id = $_GET['id'] : $selected_id = "";
                                                    foreach ($response['data'] as $row) {
                                                        $row['id']==$selected_id? $state='selected': $state='';
                                                        echo "<option value=".$row['id']." ".$state.">".$row['title']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="skill_id">Skill Name:</label>
                                            <select name="skill_id" class="form-control select2" id="skill_id">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getSkills()['status']){
                                                    $response = $dmo->getSkills(); $count=1;
                                                    foreach ($response['data'] as $row) { 
                                                        echo "<option value=".$row['id'].">".$row['name']."</option>";
                                                    } 
                                                }?>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnSaveJobSkill" >Save</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewJobSkill')">Add New</button>
                                </div>
                                <h4 class="page-title">Setup Job Skills</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tbljobskill" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Job Title</th>
                                    <th>Skill Required</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbljobskills">
                            <?php
                            if($dmo->getJobSkills()['status']){
                            $response = $dmo->getJobSkills(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur="edit('job_skill','job_title_id','<?= $id ?>',this)"><?= $dmo->safeData($row['job_title']) ?></td>
                                    <td contentEditable=true onblur="edit('job_skill','skill_id','<?= $id ?>',this)"><?= $dmo->safeData($row['skill_name']) ?></td>
                                    <td contentEditable=false onblur="edit('job_skill','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('job_skill','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbljobskill").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbljobskill_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnSaveJobSkill']").on("click", function(){
        SaveJobSkill();
	})
})
</script>
</body>
</html>