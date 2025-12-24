<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HR || Job Applicants</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewJobApplicant"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Job Applicant</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewJobApplicant" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="applicant_code">Applicant Identity Code:</label>
                                            <input type="text" name="applicant_code" class="form-control " id="applicant_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="applicant_name">Applicant Name:</label>
                                            <input type="text" name="applicant_name" class="form-control " id="applicant_name" placeholder="e.g Musee Makwa Abiud">
                                        </div>
                                        <div class="form-group">
                                            <label for="contact_phone">Contact Phone Number:</label>
                                            <input type="number" name="contact_phone" class="form-control " id="contact_phone" placeholder="e.g 0741915943">
                                        </div>
                                        <div class="form-group">
                                            <label for="contact_email">Primary Email Address:</label>
                                            <input type="email" name="contact_email" class="form-control " id="contact_email" placeholder="e.g museabiud70@gmail.com">
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewJobApplicant" >Register</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewJobApplicant')">New Applicant</button>
                                </div>
                                <h4 class="page-title">Job Applicants</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tbljobapplicant" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Applicant Name</th>
                                    <th>Phone Number</th>
                                    <th>Email Address</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tbljobapplicants">
                            <?php
                            if($dmo->getJobApplicants()['status']){
                            $response = $dmo->getJobApplicants(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','applicant_code','<?= $id ?>',this)"><?= $dmo->safeData($row['applicant_code']) ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','applicant_name','<?= $id ?>',this)"><?= $dmo->cleanData($row['applicant_name']) ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','contact_phone','<?= $id ?>',this)"><?= $dmo->safeData($row['contact_phone']) ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','contact_email','<?= $id ?>',this)"><?= $dmo->safeData($row['contact_email']) ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur="edit('job_applicant','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tbljobapplicant").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbljobapplicant_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewJobApplicant']").on("click", function(){
        NewJobApplicant();
	})
})
</script>
</body>
</html>