<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Staff On Leave</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <ol class="breadcrumb m-0">
                                            <li class="breadcrumb-item"><a href="javascript: void(0);">Staff</a></li>
                                            <li class="breadcrumb-item active">On leave list</li>
                                        </ol>
                                </div>
                                <h4 class="page-title">Staff members on Leave </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblstaff" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>Passport</th>
                                    <th>#</th>
                                    <th>School</th>
                                    <th>Code</th>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Gender</th>
                                    <th>Email Address</th>
                                    <th>Phone Number</th>
                                    <th>ID Number</th>
                                    <th>Job Title</th>
                                    <th>Role</th>
                                    <th>Date Hired</th>
                                    <th>Department</th>
                                    <th>Employment Terms</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="tblstaffs">
                            <?php
                            if($dmo->getstaffs(["stf.school"=>$dmo->safeData($user['school_code']),"stf.status"=>"On Leave"])['status']){
                            $response = $dmo->getstaffs(["stf.school"=>$dmo->safeData($user['school_code']),"stf.status"=>"On Leave"]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                <td><img src="<?= $dmo->safeData($row['passport_url']); ?>" alt="image" class="rounded-circle" width="50px" height="50px"></td>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("staff","school",<?= $id ?>,this)'><?= $dmo->safeData($row['school_code']." - ".$row['school_name']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","staff_code",<?= $id ?>,this)'><?= $dmo->safeData($row['staff_code']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","first_name",<?= $id ?>,this)'><?= $dmo->safeData($row['first_name']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","last_name",<?= $id ?>,this)'><?= $dmo->safeData($row['last_name']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","gender",<?= $id ?>,this)'><?= $dmo->safeData($row['gender']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","email",<?= $id ?>,this)'><?= $dmo->safeData($row['email']) ?></td>
                                    <td contentEditable=true onblur='edit("staff","phone",<?= $id ?>,this)'><?= $dmo->safeData($row['phone']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","id_no",<?= $id ?>,this)'><?= $dmo->safeData($row['id_no']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","job_title",<?= $id ?>,this)'><?= $dmo->safeData($row['job_title']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","role",<?= $id ?>,this)'><?= $dmo->safeData($row['role']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","hire_date",<?= $id ?>,this)'><?= $dmo->safeData($row['hire_date']) ?></td>
                                    <td contentEditable=false onblur='edit("staff","department",<?= $id ?>,this)'><?= $dmo->safeData($row['dept_name']) ?></td>
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