<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || Students</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewStudent" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Student</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewStudent" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school">School Code:</label>
                                            <select name="school"  class="form-control select2" id="school" onchange='loadSelect("classes", "fetch.php", "class", this)'>
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getSchools()['status']){
                                                $response = $dmo->getSchools();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['school_code'].">".$row['school_code']." - ".$row['school_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="adm_no">Adm. Number:</label>
                                            <input type="text" name="adm_no" class="form-control " id="adm_no" placeholder="11575">
                                        </div>
                                        <div class="form-group">
                                            <label for="first_name">First Name:</label>
                                            <input type="text" name="first_name" class="form-control " id="first_name" placeholder="Abiud">
                                        </div>
                                        <div class="form-group">
                                            <label for="surname">Surname:</label>
                                            <input type="text" name="surname" class="form-control " id="surname" placeholder="Musee">
                                        </div>
                                        <div class="form-group">
                                            <label for="last_name">Last Name:</label>
                                            <input type="text" name="last_name" class="form-control " id="last_name" placeholder="Makwa">
                                        </div>
                                        <div class="form-group">
                                            <label for="dob">Date of Birth:</label>
                                            <input type="date" name="dob" class="form-control " id="dob">
                                        </div>
                                        <div class="form-group">
                                            <label for="doa">Date of Admission:</label>
                                            <input type="date" name="doa" class="form-control " id="doa">
                                        </div>
                                        <div class="form-group">
                                            <label for="gender">Gender:</label>
                                            <select name="gender" class="form-control select2" id="gender">
                                                <option value="">--select--</option>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="class">Class:</label>
                                            <select name="class" class="form-control select2" id="class" onchange='loadSelect("streams", "fetch.php", "stream", this)'>
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="stream">Stream:</label>
                                            <select name="stream" class="form-control select2" id="stream">
                                                <option value="">--select--</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="term">Term:</label>
                                            <select name="term" class="form-control select2" id="term">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getTerms()['status']){
                                                $response = $dmo->getTerms();
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['term_code'].">".$row['term_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="year">Year of Admission:</label>
                                            <input type="number" name="year" class="form-control " id="year">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewStudent" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewStudent')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Students </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblstudent" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Adm No</th>
                                    <th>First Name</th>
                                    <th>SurName</th>
                                    <th>Last Name</th>
                                    <th>Gender</th>
                                    <th>D.O.B</th>
                                    <th>D.O.A</th>
                                    <th>Form</th>
                                    <th>Stream</th>
                                    <th>Term</th>
                                </tr>
                            </thead>
                            <tbody id="tblstudents">
                            <?php
                            if($dmo->getStudents()['status']){
                            $response = $dmo->getStudents(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("student","school",<?= $id ?>,this)'><?= $dmo->safeData($row['school']) ?></td>
                                    <td contentEditable=true onblur='edit("student","adm_no",<?= $id ?>,this)'><?= $dmo->safeData($row['adm_no']) ?></td>
                                    <td contentEditable=true onblur='edit("student","first_name",<?= $id ?>,this)'><?= $dmo->safeData($row['first_name']) ?></td>
                                    <td contentEditable=true onblur='edit("student","surname",<?= $id ?>,this)'><?= $dmo->safeData($row['surname']) ?></td>
                                    <td contentEditable=true onblur='edit("student","last_name",<?= $id ?>,this)'><?= $dmo->safeData($row['last_name']) ?></td>
                                    <td contentEditable=false onblur='edit("student","gender",<?= $id ?>,this)'><?= $dmo->safeData($row['gender']) ?></td>
                                    <td contentEditable=true onblur='edit("student","dob",<?= $id ?>,this)'><?= $dmo->safeData($row['dob']) ?></td>
                                    <td contentEditable=true onblur='edit("student","doa",<?= $id ?>,this)'><?= $dmo->safeData($row['doa']) ?></td>
                                    <td contentEditable=false onblur='edit("student","class",<?= $id ?>,this)'><?= $dmo->safeData($row['class']) ?></td>
                                    <td contentEditable=false onblur='edit("student","stream",<?= $id ?>,this)'><?= $dmo->safeData($row['stream']) ?></td>
                                    <td contentEditable=false onblur='edit("student","term",<?= $id ?>,this)'><?= $dmo->safeData($row['term']) ?></td>
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
	$("#tblstudent").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblstudent_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewStudent']").on("click", function(){
        saveNewStudent();
	})
})
</script>
</body>
</html>