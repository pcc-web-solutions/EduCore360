<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Leave Applications</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewLeaveApplication"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">New Leave Application</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewLeaveApplication" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code']; ?>" readonly>
                                            <div class="form-group">
                                                <label for="leave_code">Leave Ref No:</label>
                                                <input type="text" name="leave_code" class="form-control " id="leave_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                            </div>
                                            <div class="form-group">
                                                <label for="staff_code">Staff Name:</label>
                                                <select name="staff_code"  class="form-control select2" id="staff_code">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getStaffs(["stf.school"=>$user['school_code']])['status']){
                                                    $response = $dmo->getStaffs(["stf.school"=>$user['school_code']]);
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['staff_code'].">".$row['last_name']." ".$row['first_name']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="leave_type">Leave Type:</label>
                                                <select name="leave_type"  class="form-control select2" id="leave_type">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getLeaveTypes(["school_code"=>$user['school_code']])['status']){
                                                    $response = $dmo->getLeaveTypes(["school_code"=>$user['school_code']]);
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['leave_type_code'].">".$row['leave_type_name']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="start_date">To Begin On</label>
                                                <input type="date" name="start_date" class="form-control " id="start_date" placeholder="e.g 90">
                                            </div>
                                            <div class="form-group">
                                                <label for="end_date">Leave Ends On</label>
                                                <input type="date" name="end_date" class="form-control " id="end_date" placeholder="e.g 90">
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewLeaveApplication">Apply</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>    
                    
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewLeaveApplication')">New Application</button>
                                    </div>
                                    <h4 class="page-title">Staff Leave Applications</h4>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("leave_request", "approval_status");
                                        if($result['status']){
                                            $count = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <li class="nav-item">
                                                    <a href="<?= "#$value" ?>" data-toggle="tab" aria-expanded="false" class="nav-link <?= $count==1? "active" : ""; ?>">
                                                        <?= $value; ?>
                                                    </a>
                                                </li>
                                            <?php $count++; }
                                        } ?>
                                    </ul>
                                    <div class="tab-content">
                                        <?php $result = $dmo->getEnumValues("leave_request", "approval_status");
                                        if($result['status']){
                                            $cnt = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <div class="tab-pane <?= $cnt==1? "show active" : ""; ?>" id="<?= $value ?>">
                                                    <table id="tbl<?= $value; ?>" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                                                        <thead>
                                                            <tr style="height: 40px;">
                                                                <th>#</th>
                                                                <th>Code</th>
                                                                <th>Staff Name</th>
                                                                <th>Leave Type</th>
                                                                <th>Start Date</th>
                                                                <th>End Date</th>
                                                                <th>Approval Status</th>
                                                                <th>Reason</th>
                                                                <th>Comment / Notes</th>
                                                                <th>Approved By</th>
                                                                <th>Rejected By</th>
                                                                <th>Created At</th>
                                                                <th>Updated At</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= $value; ?>s">
                                                        <?php
                                                        if($dmo->getLeaveApplications(["school_code"=>$user['school_code'],"approval_status"=>$value])['status']){
                                                        $response = $dmo->getLeaveApplications(["school_code"=>$user['school_code'],"approval_status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','leave_code','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_code']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','staff_code','<?= $id ?>',this)"><?= $dmo->safeData($row['staff_name']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','leave_type','<?= $id ?>',this)"><?= $dmo->safeData($row['leave_type_name']) ?></td>
                                                                <td contentEditable=true onblur="edit('leave_request','start_date','<?= $id ?>',this)"><?= $dmo->safeData($row['start_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('leave_request','end_date','<?= $id ?>',this)"><?= $dmo->safeData($row['end_date']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','approval_status','<?= $id ?>',this)"><?= $dmo->safeData($row['approval_status']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','reason','<?= $id ?>',this)"><?= $dmo->safeData($row['reason']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','comment','<?= $id ?>',this)"><?= $dmo->safeData($row['comment']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','approved_by','<?= $id ?>',this)"><?= $dmo->safeData($row['approved_by']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','rejected_by','<?= $id ?>',this)"><?= $dmo->safeData($row['rejected_by']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td contentEditable=false onblur="edit('leave_request','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
            <?php $result = $dmo->getEnumValues("leave_request", "approval_status");
            if($result['status']){
                $count = 1;
                foreach ($result['data'] as $value) { ?>
                    $("#tbl<?= $value; ?>").DataTable({
                        "responsive": false, "lengthChange": true, "autoWidth": true
                    }).buttons().container().appendTo('#tbl<?= $value; ?>_wrapper .col-md-6:eq(0)');
                <?php $count++; }
            } ?>
        })
        
        $(document).ready(function(){
            $("button[name='btnNewLeaveApplication']").on("click", function(){
                NewLeaveApplication();
            })
        })
    </script>
</body>
</html>