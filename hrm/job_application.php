<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Job Applications</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewJobApplication"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">New Job Application</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewJobApplication" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                            <div class="form-group">
                                                <label for ="applicant_code">Applicant Name:</label>
                                                <select name="applicant_code"  class="form-control select2" id="applicant_code">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getJobApplicants()['status']){
                                                    $response = $dmo->getJobApplicants();
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['applicant_code'].">".$row['applicant_name']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for ="job_posting_code">Interested Post:</label>
                                                <select name="job_posting_code"  class="form-control select2" id="job_posting_code">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getJobPostings(["jp.school"=>$user['school_code']])['status']){
                                                    $response = $dmo->getJobPostings(["jp.school"=>$user['school_code']]);
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['id'].">".$row['job_title']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewJobApplication" >Apply Now</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal fade" id="ViewDocument"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-xl modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white" id="DocTitle"></h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body p-0 mb-0 mt-0">
                                        <div id="ifrmViewDocument"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <ol class="breadcrumb m-0">
                                            <li class="breadcrumb-item"><a href="javascript: void(0);">HRM</a></li>
                                            <li class="breadcrumb-item active">Job Applications</li>
                                        </ol>
                                    </div>
                                    <h4 class="page-title">Job Applications</h4>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("job_application", "application_status");
                                        if($result['status']){
                                            $count = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <li class="nav-item">
                                                    <a href="<?= "#".str_replace(" ","_", $value); ?>" data-toggle="tab" aria-expanded="false" class="nav-link <?= $count==1? "active" : ""; ?>">
                                                        <?= $value; ?>
                                                    </a>
                                                </li>
                                            <?php $count++; }
                                        } ?>
                                    </ul>
                                    <div class="tab-content">
                                        <?php $result = $dmo->getEnumValues("job_application", "application_status");
                                        if($result['status']){
                                            $cnt = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <div class="tab-pane <?= $cnt==1? "show active" : ""; ?>" id="<?= str_replace(" ","_", $value); ?>">
                                                    <table id="tbl<?= str_replace(" ","_", $value); ?>" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                                                        <thead>
                                                            <tr style="height: 40px;">
                                                                <th>#</th>
                                                                <th>Applicant</th>
                                                                <th>Ref. No</th>
                                                                <th>Job Title</th>
                                                                <th>Applied On</th>
                                                                <th>Resume</th>
                                                                <th>Cover Letter</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= str_replace(" ","_", $value); ?>s">
                                                        <?php
                                                        if($dmo->getJobApplications(["school_code"=>$user['school_code'],"application_status"=>$value])['status']){
                                                        $response = $dmo->getJobApplications(["school_code"=>$user['school_code'],"application_status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=false onblur="edit('job_application','applicant_code','<?= $id ?>',this)"><?= $dmo->safeData($row['applicant_name']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_application','job_posting_code','<?= $id ?>',this)"><?= $dmo->safeData($row['job_posting_code']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_application','job_posting_code','<?= $id ?>',this)"><?= $dmo->safeData($row['job_title']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_application','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td><button class="btn  btn-xs btn-success float-right" onclick='showModal("#ViewDocument"); loadIframe("#ifrmViewDocument", "<?= $dmo->safeData($row["applicant_name"])." - Resume / Curriculum Vitae (CV)" ?>","<?= $dmo->safeData($row["resume"]) ?>")' >Open Resume</button></td>
                                                                <td><button class="btn  btn-xs btn-info float-right" onclick='showModal("#ViewDocument"); loadIframe("#ifrmViewDocument", "<?= $dmo->safeData($row["applicant_name"])." - Cover Letter" ?>","<?= $dmo->safeData($row["cover_letter"]) ?>")' >Cover Letter</button></td>
                                                            </tr>
                                                        <?php $count++; } }?>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            <?php $cnt++; }
                                        } ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php require "page/footer.php"; ?>
            </div>
        </div>
    <div class="rightbar-overlay"></div>
    <?php require "page/script.php"; ?>
    <script src="asset/js/dms.js"></script>
    <script type="text/javascript">  
        $(function(){
            <?php $result = $dmo->getEnumValues("job_application", "application_status");
            if($result['status']){
                $count = 1;
                foreach ($result['data'] as $value) { ?>
                    $("#tbl<?= str_replace(" ","_", $value); ?>").DataTable({
                        "responsive": false, "lengthChange": true, "autoWidth": true
                    }).buttons().container().appendTo('#tbl<?= str_replace(" ","_", $value); ?>_wrapper .col-md-6:eq(0)');
                <?php $count++; }
            } ?>
        })
        
        $(document).ready(function(){
            $("button[name='btnNewJobApplication']").on("click", function(){
                NewJobApplication();
            })
        })
    </script>
</body>
</html>