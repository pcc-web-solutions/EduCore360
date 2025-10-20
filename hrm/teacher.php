<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Teachers</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewStaff" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Teacher</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewStaff" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="staff_code">Staff. Code:</label>
                                            <input type="text" name="staff_code" class="form-control " id="staff_code" value="<?= $dmo->generateUid(); ?>">
                                        </div>
                                        <div class="form-group">
                                            <label for="first_name">First Name:</label>
                                            <input type="text" name="first_name" class="form-control " id="first_name" placeholder="e.g, Abiud">
                                        </div>
                                        <div class="form-group">
                                            <label for="last_name">Last Name:</label>
                                            <input type="text" name="last_name" class="form-control " id="last_name" placeholder="e.g, Musee">
                                        </div>
                                        <div class="form-group">
                                            <label for="gender">Gender:</label>
                                            <select name="gender" class="form-control select2" id="gender">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("staff", "gender");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Email Address:</label>
                                            <input type="email" name="email" class="form-control " id="email">
                                        </div>
                                        <div class="form-group">
                                            <label for="phone">Phone Number:</label>
                                            <input type="number" name="phone" class="form-control " id="phone">
                                        </div>
                                        <div class="form-group">
                                            <label for="id_no">ID Number:</label>
                                            <input type="number" name="id_no" class="form-control " id="id_no">
                                        </div>
                                        <div class="form-group">
                                            <label for="job_title">Job Title:</label>
                                            <select name="job_title"  class="form-control select2" id="job_title">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getJobTitles(["school_code"=>$user['school_code']])['status']){
                                                $response = $dmo->getJobTitles(["school_code"=>$user['school_code']]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['id'].">".$row['title']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="role">Staff Role:</label>
                                            <select name="role" class="form-control select2" id="role">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("staff", "role");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="hire_date">Date Hired:</label>
                                            <input type="date" name="hire_date" class="form-control " id="hire_date">
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
                                            <label for="emp_term">Employment Terms:</label>
                                            <select name="emp_term" class="form-control select2" id="emp_term">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("staff", "emp_term");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="profile_picture">Passport Photo:</label>
                                            <input type="file" name="profile_picture" accept="image/jpeg" class="form-control " id="profile_picture">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewStaff" ><i class="far fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewStaff')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Teachers </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblstaff" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Code</th>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Gender</th>
                                    <th>Email Address</th>
                                    <th>Phone Number</th>
                                    <th>ID Number</th>
                                    <th>Date Hired</th>
                                    <th>Employment Terms</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="tblstaffs">
                            <?php
                            if($dmo->getTeachers(["school_code"=>$user['school_code']])['status']){
                            $response = $dmo->getTeachers(["school_code"=>$user['school_code']]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("staff","school",<?= $id ?>,this)'><?= $dmo->safeData($row['school_code']." - ".$row['school_name']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","staff_code",<?= $id ?>,this)'><?= $dmo->safeData($row['teacher_code']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","first_name",<?= $id ?>,this)'><?= $dmo->safeData($row['first_name']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","last_name",<?= $id ?>,this)'><?= $dmo->safeData($row['last_name']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","gender",<?= $id ?>,this)'><?= $dmo->safeData($row['gender']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","email",<?= $id ?>,this)'><?= $dmo->safeData($row['email']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","phone",<?= $id ?>,this)'><?= $dmo->safeData($row['phone']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","id_no",<?= $id ?>,this)'><?= $dmo->safeData($row['id_no']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","hire_date",<?= $id ?>,this)'><?= $dmo->safeData($row['hire_date']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","emp_term",<?= $id ?>,this)'><?= $dmo->safeData($row['emp_term']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","status",<?= $id ?>,this)'><?= $dmo->safeData($row['status']) ?></td>
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
	$("#tblstaff").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblstaff_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewStaff']").on("click", function(){
        saveNewStaff();
	})
})
</script>
</body>
</html>