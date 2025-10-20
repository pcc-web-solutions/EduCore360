<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Job Posting</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewJobPosting"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">Post A New Job Vacancy</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewJobPosting" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
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
                                                <label for="job_posting_code">Code / Vacancy No:</label>
                                                <input type="text" name="job_posting_code" class="form-control " id="job_posting_code">
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
                                                <label for="vacant_posts">Vacant Posts</label>
                                                <input type="number" name="vacant_posts" class="form-control " id="vacant_posts" placeholder="10">
                                            </div>
                                            <div class="form-group">
                                                <label for="posting_date">Posting Date</label>
                                                <input type="date" name="posting_date" class="form-control " id="posting_date">
                                            </div>
                                            <div class="form-group">
                                                <label for="closing_date">Closing Date</label>
                                                <input type="date" name="closing_date" class="form-control " id="closing_date">
                                            </div>
                                            <div class="form-group">
                                                <label for="description">Brief Description</label>
                                                <textarea type="text" name="description" class="form-control" id="description" placeholder="Give a brief description about the skill..."></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="employment_type">Employmnt Terms:</label>
                                                <select name="employment_type" class="form-control select2" id="employment_type">
                                                    <option value="">--select--</option>
                                                    <?php $result = $dmo->getEnumValues("job_posting", "employment_type");
                                                    if($result['status']){
                                                        foreach ($result['data'] as $value) {
                                                            echo "<option value=\"$value\">$value</option>";
                                                        }
                                                    } ?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="location">Prefered Location:</label>
                                                <input type="text" name="location" class="form-control " id="location">
                                            </div>
                                            <div class="form-group">
                                                <label for="salary_range">Salary Range:</label>
                                                <input type="text" name="salary_range" class="form-control " id="salary_range">
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewJobPosting" >Post</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewJobPosting')">Post New</button>
                                    </div>
                                    <h4 class="page-title">Post Job Vacancies</h4>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("job_posting", "status");
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
                                        <?php $result = $dmo->getEnumValues("job_posting", "status");
                                        if($result['status']){
                                            $cnt = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <div class="tab-pane <?= $cnt==1? "show active" : ""; ?>" id="<?= str_replace(" ","_", $value); ?>">
                                                    <table id="tbl<?= str_replace(" ","_", $value); ?>" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                                                        <thead>
                                                            <tr style="height: 40px;">
                                                                <th>#</th>
                                                                <th>Code</th>
                                                                <th>Department</th>
                                                                <th>Job Title</th>
                                                                <th>Posts</th>
                                                                <th>Posting Date</th>
                                                                <th>Closing Date</th>
                                                                <th>Description</th>
                                                                <th>Terms</th>
                                                                <th>Prefferably From</th>
                                                                <th>Salary Range</th>
                                                                <th>Status</th>
                                                                <th>Posted At</th>
                                                                <th>Updated At</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= str_replace(" ","_", $value); ?>s">
                                                        <?php
                                                        if($dmo->getJobPostings(["jp.school"=>$user['school_code'],"jp.status"=>$value])['status']){
                                                        $response = $dmo->getJobPostings(["jp.school"=>$user['school_code'],"jp.status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','job_posting_code','<?= $id ?>',this)"><?= $dmo->safeData($row['job_posting_code']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','department','<?= $id ?>',this)"><?= $dmo->safeData($row['dept_name']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','job_title','<?= $id ?>',this)"><?= $dmo->safeData($row['job_title']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','vacant_posts','<?= $id ?>',this)"><?= $dmo->safeData($row['vacant_posts']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','posting_date','<?= $id ?>',this)"><?= $dmo->safeData($row['posting_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','closing_date','<?= $id ?>',this)"><?= $dmo->safeData($row['closing_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','employment_type','<?= $id ?>',this)"><?= $dmo->safeData($row['employment_type']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','location','<?= $id ?>',this)"><?= $dmo->safeData($row['location']) ?></td>
                                                                <td contentEditable=true onblur="edit('job_posting','salary_range','<?= $id ?>',this)"><?= $dmo->safeData($row['salary_range']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','status','<?= $id ?>',this)"><?= $dmo->safeData($row['status']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td contentEditable=false onblur="edit('job_posting','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
            <?php $result = $dmo->getEnumValues("job_posting", "status");
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
            $("button[name='btnNewJobPosting']").on("click", function(){
                NewJobPosting();
            })
        })
    </script>
</body>
</html>