<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>HRM || Staff Benefits</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewStaffBenefit"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">Create A New Staff Benefit</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-danger"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewStaffBenefit" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <div class="form-group">
                                                <label for ="school">School Code:</label>
                                                <select name="school"  class="form-control select2" id="school">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getSchools(["school_code"=>$user['school_code']])['status']){
                                                    $response = $dmo->getSchools(["school_code"=>$user['school_code']]);
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['school_code'].">".$row['school_code']." - ".$row['school_name']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="benefit_code">Staff Benefit Code:</label>
                                                <input type="text" name="benefit_code" class="form-control " id="benefit_code" value="<?= $dmo->generateUid(); ?>" readonly>
                                            </div>
                                            <div class="form-group">
                                                <label for ="staff_code">Staff Name:</label>
                                                <select name="staff_code" class="form-control select2" id="staff_code">
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
                                                <label for ="benefit_type">Benefit Type:</label>
                                                <select name="benefit_type" class="form-control select2" id="benefit_type">
                                                    <option value="">--select--</option>
                                                    <?php
                                                    if($dmo->getBenefitTypes(["school_code"=>$user['school_code']])['status']){
                                                    $response = $dmo->getBenefitTypes(["school_code"=>$user['school_code']]);
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                        echo "<option value=".$row['benefit_type_code'].">".$row['benefit_type_name']."</option>";
                                                    } }?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="description">Brief Description:</label>
                                                <textarea name="description" class="form-control " id="description" placeholder="Type in a brief description ..."></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="effective_date">Effective Date</label>
                                                <input type="date" name="effective_date" class="form-control " id="effective_date">
                                            </div>
                                            <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewStaffBenefit" >Create</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <button type="button" class="btn btn-success float-right" data-toggle="modal"  onclick="showModal('#NewStaffBenefit')">New Staff Benefit</button>
                                    </div>
                                    <h4 class="page-title">Staff Benefits</h4>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <?php $result = $dmo->getEnumValues("staff_benefit", "status");
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
                                        <?php $result = $dmo->getEnumValues("staff_benefit", "status");
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
                                                                <th>Benefit Type</th>
                                                                <th>Description</th>
                                                                <th>Date Effective</th>
                                                                <th>Status</th>
                                                                <th>Created At</th>
                                                                <th>Updated At</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="tbl<?= $value; ?>s">
                                                        <?php
                                                        if($dmo->getStaffBenefits(["school_code"=>$user['school_code'],"sb.status"=>$value])['status']){
                                                        $response = $dmo->getStaffBenefits(["school_code"=>$user['school_code'],"sb.status"=>$value]); $count=1;
                                                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                            <tr>
                                                                <td><?= $count ?></td>
                                                                <td contentEditable=false onblur="edit('staff_benefit','benefit_code','<?= $id ?>',this)"><?= $dmo->safeData($row['benefit_code']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_benefit','staff_code','<?= $id ?>',this)"><?= $dmo->safeData($row['staff_name']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_benefit','benefit_type','<?= $id ?>',this)"><?= $dmo->safeData($row['benefit_type_name']) ?></td>
                                                                <td contentEditable=true onblur="edit('staff_benefit','description','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                                                <td contentEditable=true onblur="edit('staff_benefit','effective_date','<?= $id ?>',this)"><?= $dmo->safeData($row['effective_date']) ?></td>
                                                                <td contentEditable=true onblur="edit('staff_benefit','status','<?= $id ?>',this)"><?= $dmo->safeData($row['status']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_benefit','created_at','<?= $id ?>',this)"><?= $dmo->safeData($row['created_at']) ?></td>
                                                                <td contentEditable=false onblur="edit('staff_benefit','updated_at','<?= $id ?>',this)"><?= $dmo->safeData($row['updated_at']) ?></td>
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
            <?php $result = $dmo->getEnumValues("staff_benefit", "status");
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
            $("button[name='btnNewStaffBenefit']").on("click", function(){
                NewStaffBenefit();
            })
        })
    </script>
</body>
</html>