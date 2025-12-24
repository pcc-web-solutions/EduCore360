<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Training Programs</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewTrainingProgram"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">New Training Program</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewTrainingProgram" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                            <div class="form-group">
                                                <label for="program_code">Program Code:</label>
                                                <input type="text" name="program_code" class="form-control " id="program_code" value="<?= $dmo->generateUid(); ?>">
                                            </div>
                                            <div class="form-group">
                                                <label for="program_name">Program Name:</label>
                                                <input type="text" name="program_name" class="form-control " id="program_name" placeholder="MIS Training">
                                            </div>
                                            <div class="form-group">
                                                <label for="facilitator_name">Program Facilitator:</label>
                                                <input type="text" name="facilitator_name" class="form-control " id="facilitator_name" placeholder="Paracoumt Communications Limited">
                                            </div>
                                            <div class="form-group">
                                                <label for="start_date">Start Date:</label>
                                                <input type="date" name="start_date" class="form-control " id="start_date">
                                            </div>
                                            <div class="form-group">
                                                <label for="end_date">End Date:</label>
                                                <input type="date" name="end_date" class="form-control " id="end_date">
                                            </div>
                                            <div class="form-group">
                                                <label for="comment">Comment / Description / Note:</label>
                                                <textarea  name="comment" class="form-control " id="comment" placeholder="Type in here ..."></textarea>
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewTrainingProgram" >Create</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewTrainingProgram')">Add New</button>
                                    </div>
                                    <h4 class="page-title">Training Programs</h4>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("training_program", "status");
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
                                        <?php $result = $dmo->getEnumValues("training_program", "status");
                                        if($result['status']){
                                            $cnt = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <div class="tab-pane <?= $cnt==1? "show active" : ""; ?>" id="<?= str_replace(" ","_", $value); ?>">
                                                    <table id="tbl<?= str_replace(" ","_", $value); ?>" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                                                        <thead>
                                                            <tr style="height: 40px;">
                                                                <th>#</th>
                                                                <th>Code</th>
                                                                <th>Program</th>
                                                                <th>Facilitator</th>
                                                                <th>Start Date</th>
                                                                <th>End Date</th>
                                                                <th>Status</th>
                                                                <th>Comment</th>
                                                                <th>Created At</th>
                                                                <th>Updated At</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= str_replace(" ","_", $value); ?>s">
                                                        <?php
                                                        if($dmo->getTrainingPrograms(["tp.school"=>$user['school_code'],"tp.status"=>$value])['status']){
                                                        $response = $dmo->getTrainingPrograms(["tp.school"=>$user['school_code'],"tp.status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','program_code','<?= $id ?>',this)"><?= $dmo->safeData($row['program_code']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','program_name','<?= $id ?>',this)"><?= $dmo->safeData($row['program_name']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','facilitator_name','<?= $id ?>',this)"><?= $dmo->safeData($row['facilitator_name']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','start_date','<?= $id ?>',this)"><?= $dmo->safeData($row['start_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','end_date','<?= $id ?>',this)"><?= $dmo->safeData($row['end_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','status','<?= $id ?>',this)"><?= $dmo->safeData($row['status']) ?></td>
                                                                <td contentEditable=true onblur="edit('training_program','comment','<?= $id ?>',this)"><?= $dmo->safeData($row['comment']) ?></td>
                                                                <td contentEditable=false onblur="edit('training_program','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td contentEditable=false onblur="edit('training_program','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
            <?php $result = $dmo->getEnumValues("training_program", "status");
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
            $("button[name='btnNewTrainingProgram']").on("click", function(){
                NewTrainingProgram();
            })
        })
    </script>
</body>
</html>