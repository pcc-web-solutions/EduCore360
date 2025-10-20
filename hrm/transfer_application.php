<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Transfer Applications</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewTransferApplication"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">New Transfer Application</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewTransferApplication" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="transfer_from" class="form-control " id="transfer_from" value="<?= $user['school_code']; ?>" readonly>
                                            <div class="form-group">
                                                <label for="transfer_code">Transfer Ref Code:</label>
                                                <input type="text" name="transfer_code" class="form-control " id="transfer_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                            </div>
                                            <div class="form-group">
                                                <label for="transfer_to">Transfer To:</label>
                                                <select name="transfer_to"  class="form-control select2" id="transfer_to">
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
                                                <label for="date_requested">Date of Requested / Posted:</label>
                                                <input type="date" name="date_requested" class="form-control " id="date_requested">
                                            </div>
                                            <div class="form-group">
                                                <label for="on_behalf_of">On Behalf Of (Leave blank if self application):</label>
                                                <select name="on_behalf_of"  class="form-control select2" id="on_behalf_of">
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
                                                <label for="effective_date">Effective Transfer Date:</label>
                                                <input type="date" name="effective_date" class="form-control " id="effective_date">
                                            </div>
                                            <div class="form-group">
                                                <label for="comment">Brief Notes / Comment</label>
                                                <textarea type="text" name="comment" class="form-control " id="comment" placeholder="Type in comments here"></textarea>
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewTransferApplication" onclick="NewTransferApplication()">Apply</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>    
                    
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewTransferApplication')">New Application</button>
                                    </div>
                                    <h4 class="page-title">Staff Transfer Applications</h4>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("staff_transfer_request", "approval_status");
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
                                        <?php $result = $dmo->getEnumValues("staff_transfer_request", "approval_status");
                                        if($result['status']){
                                            $cnt = 1;
                                            foreach ($result['data'] as $value) { ?>
                                                <div class="tab-pane <?= $cnt==1? "show active" : ""; ?>" id="<?= $value ?>">
                                                    <table id="tbl<?= $value; ?>" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap" style="width: 100%;">
                                                        <thead>
                                                            <tr style="height: 40px;">
                                                                <th>#</th>
                                                                <th>Code</th>
                                                                <th>Transfer From</th>
                                                                <th>Transfer To</th>
                                                                <th>Date Requested</th>
                                                                <th>Requested By</th>
                                                                <th>On Behalf Of</th>
                                                                <th>Effective Date</th>
                                                                <th>Approval Status</th>
                                                                <th>Approved By</th>
                                                                <th>Rejected By</th>
                                                                <th>Comment</th>
                                                                <th>Reason</th>
                                                                <th>Created At</th>
                                                                <th>Updated At</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= $value; ?>s">
                                                        <?php
                                                        if($dmo->getStaffTransferRequests(["str.approval_status"=>$value])['status']){
                                                        $response = $dmo->getStaffTransferRequests(["str.approval_status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','transfer_code','<?= $id ?>',this)"><?= $dmo->safeData($row['transfer_code']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','transfer_from','<?= $id ?>',this)"><?= $dmo->safeData($row['transfer_from']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','transfer_to','<?= $id ?>',this)"><?= $dmo->safeData($row['transfer_to']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','date_requested','<?= $id ?>',this)"><?= $dmo->safeData($row['date_requested']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','requested_by','<?= $id ?>',this)"><?= $dmo->safeData($row['requested_by']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','on_behalf_of','<?= $id ?>',this)"><?= $dmo->safeData($row['on_behalf_of']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','effective_date','<?= $id ?>',this)"><?= $dmo->safeData($row['effective_date']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','approval_status','<?= $id ?>',this)"><?= $dmo->safeData($row['approval_status']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','approved_by','<?= $id ?>',this)"><?= $dmo->safeData($row['approved_by']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','rejected_by','<?= $id ?>',this)"><?= $dmo->safeData($row['rejected_by']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','comment','<?= $id ?>',this)"><?= $dmo->safeData($row['comment']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','reason','<?= $id ?>',this)"><?= $dmo->safeData($row['reason']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_transfer_request','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
            <?php $result = $dmo->getEnumValues("staff_transfer_request", "approval_status");
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
            $("button[name='btnNewTransferApplication']").on("click", function(){
                NewTransferApplication();
            })
        })
    </script>
</body>
</html>