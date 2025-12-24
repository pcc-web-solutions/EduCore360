<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Subjects</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewSubject" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Subject</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewSubject" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school">School Code:</label>
                                            <select name="school"  class="form-control select2" id="school" onchange='loadSelect("classes", "fetch.php", "class", this); loadSelect("subject_groups", "fetch.php", "group", this); loadSelect("subject_departments", "fetch.php", "department", this)'>
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getSchools(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                                                $response = $dmo->getSchools(["school_code"=>$dmo->safeData($user['school_code'])]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['school_code'].">".$row['school_code']." - ".$row['school_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="class">Class Code:</label>
                                            <select name="class" class="form-control select2" id="class">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="subject_code">Subject Code:</label>
                                            <input type="text" name="subject_code" class="form-control " id="subject_code" placeholder="e.g., 451">
                                        </div>
                                        <div class="form-group">
                                            <label for="subject_name">Subject Name:</label>
                                            <input type="text" name="subject_name" class="form-control " id="subject_name" placeholder="e.g., Computer Studies">
                                        </div>
                                        <div class="form-group">
                                            <label for="group">Group Code:</label>
                                            <select name="group" class="form-control select2" id="group">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="department">Department Code:</label>
                                            <select name="department" class="form-control select2" id="department">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="category">Subject Category:</label>
                                            <select name="category" class="form-control select2" id="category">
                                                <option value="">--select--</option>
                                                <option value="Compulsory">Compulsory</option>
                                                <option value="Optional">Optional</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewSubject" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewSubject')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Subjects </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblsubject" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Class</th>
                                    <th>Subject Code</th>
                                    <th>Subject Name</th>
                                    <th>Group</th>
                                    <th>Department</th>
                                    <th>Category</th>
                                </tr>
                            </thead>
                            <tbody id="tblsubjects">
                            <?php
                            if($dmo->getSubjects(["sbj.school"=>$user['school_code']])['status']){
                            $response = $dmo->getSubjects(["sbj.school"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur='edit("subject","school",<?= $id ?>,this)'><?= $dmo->safeData($row['school_code']." - ".$row['school_name']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","class",<?= $id ?>,this)'><?= $dmo->safeData($row['class_code']." - ".$row['class_name']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","subject_code",<?= $id ?>,this)'><?= $dmo->safeData($row['subject_code']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","subject_name",<?= $id ?>,this)'><?= $dmo->safeData($row['subject_name']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","group",<?= $id ?>,this)'><?= $dmo->safeData($row['group_code']." - ".$row['group_name']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","department",<?= $id ?>,this)'><?= $dmo->safeData($row['dept_code']." - ".$row['dept_name']) ?></td>
                                    <td contentEditable=true onblur='edit("subject","category",<?= $id ?>,this)'><?= $dmo->safeData($row['category']) ?></td>
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
	$("#tblsubject").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblsubject_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewSubject']").on("click", function(){
        saveNewSubject();
	})
})
</script>
</body>
</html>