<?php
require_once __DIR__."/uac.php"; $schInfo = $dmo->getSchInfo($user)['status']? $dmo->getSchInfo($user)['data'] : [];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || School Info</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
            <div class="content-page">
                <div class="content">
                    <div class="container-fluid">
                        <div class="modal fade" id="NewCompanyContact"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">Add a School Contact</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewCompanyContact" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                            <div class="form-group">
                                                <label for="contact_type">Contact Type</label>
                                                <select name="contact_type" class="form-control select2" id="contact_type">
                                                    <option value="">--select--</option>
                                                    <?php $result = $dmo->getEnumValues("school_contact", "contact_type");
                                                    if($result['status']){
                                                        foreach ($result['data'] as $value) {
                                                            echo "<option value=\"$value\">$value</option>";
                                                        }
                                                    } ?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="contact_value">Contact Value</label>
                                                <input type="text" name="contact_value" class="form-control" id="contact_value" placeholder="Give a brief description..." />
                                            </div>
                                            <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSaveCompanyContact" ><i class="fas fa-save"></i>&nbspSave</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal fade" id="NewCompanySocial"  tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-info">
                                        <h4 class="modal-title text-white">New School Social Handle</h4>
                                        <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                    </div>
                                    <div class="modal-body">
                                        <form id="frmNewCompanySocial" autocomplete="off" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                            <div class="form-group">
                                                <label for="platform">Platform</label>
                                                <select name="platform" class="form-control select2" id="platform">
                                                    <option value="">--select--</option>
                                                    <?php $result = $dmo->getEnumValues("school_social", "platform");
                                                    if($result['status']){
                                                        foreach ($result['data'] as $value) {
                                                            echo "<option value=\"$value\">$value</option>";
                                                        }
                                                    } ?>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="account_link">Account Link</label>
                                                <textarea type="text" name="account_link" class="form-control" id="account_link" placeholder="Give a brief description..."></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnSaveCompanySocial" ><i class="fas fa-save"></i>&nbspSave</button> 
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="page-title-box">
                                    <div class="page-title-right">
                                        <ol class="breadcrumb m-0">
                                            <li class="breadcrumb-item"><a href="javascript: void(0);">Dashboard</a></li>
                                            <li class="breadcrumb-item active">Company Profile</li>
                                        </ol>
                                    </div>
                                    <h4 class="page-title"><?= $schInfo['school_name']."'s Profile";?> </h4>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-12 col-xl-12">
                                <div class="card-box">
                                    <ul class="nav nav-pills navtab-bg nav-justified">
                                        <li class="nav-item">
                                            <a href="#companybasicinfo" data-toggle="tab" aria-expanded="false" class="nav-link active">
                                                Company Info
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#companycontactinfo" data-toggle="tab" aria-expanded="false" class="nav-link">
                                                Contact Info
                                            </a>
                                        </li>
                                        <!-- <li class="nav-item">
                                            <a href="#companybankinfo" data-toggle="tab" aria-expanded="false" class="nav-link">
                                                Bank Account Details
                                            </a>
                                        </li> -->
                                        <li class="nav-item">
                                            <a href="#companysocialinfo" data-toggle="tab" aria-expanded="false" class="nav-link">
                                                Social Info
                                            </a>
                                        </li>
                                    </ul>
                                    <div class="tab-content">
                                        <div class="tab-pane show active" id="companybasicinfo">
                                            <form id="frmCompanyBasicInfo" autocomplete="off" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                                <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                                <h5 class="mb-4 text-uppercase bg-light p-2"><i class="mdi mdi-account-circle mr-1"></i> Company Info</h5>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="school_name">School Name</label>
                                                            <input type="text" name="school_name"  class="form-control" id="school_name" placeholder="<?= $schInfo['school_name']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="county">County</label>
                                                            <select name="county"  class="form-control select2" id="county" onchange='loadSelect("sub_counties", "fetch.php", "sub_county", this)'>
                                                                <option value="">--select--</option>
                                                                <?php
                                                                $response = $dmo->getCounties();
                                                                if($response['status']){
                                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                                    echo "<option value=".$row['code'].">".$row['description']."</option>";
                                                                } }?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="sub_county">Sub-County</label>
                                                            <select name="sub_county" class="form-control select2" id="sub_county" onchange='loadSelect("wards", "fetch.php", "ward", this)'>
                                                                <option value="">--select--</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="ward">Ward:</label>
                                                            <select name="ward" class="form-control select2" id="ward">
                                                                <option value="">--select--</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="kra_pin">KRA Pin</label>
                                                            <input type="text" name="kra_pin"  class="form-control" id="kra_pin" placeholder="<?= $schInfo['kra_pin']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="reg_no">Reg. Number</label>
                                                            <input type="text" name="reg_no"  class="form-control" id="reg_no" placeholder="<?= $schInfo['reg_no']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for=" emis_code">EMIS Code</label>
                                                            <input type="text" name="emis_code"  class="form-control" id="emis_code" placeholder="<?= $schInfo['emis_code']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="knec_centre_no">Centre No</label>
                                                            <input type="number" name="knec_centre_no"  class="form-control" id="knec_centre_no" placeholder="<?= $schInfo['knec_centre_no']?? "";?>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="curriculum">Curriculum</label>
                                                            <select name="curriculum" class="form-control select2" id="curriculum">
                                                                <option value="">--select--</option>
                                                                <?php $result = $dmo->getEnumValues("school", "curriculum");
                                                                if($result['status']){
                                                                    foreach ($result['data'] as $value) {
                                                                        echo "<option value=\"$value\">$value</option>";
                                                                    }
                                                                } ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="level">Level</label>
                                                            <select name="level" class="form-control select2" id="level">
                                                                <option value="">--select--</option>
                                                                <?php $result = $dmo->getEnumValues("school", "level");
                                                                if($result['status']){
                                                                    foreach ($result['data'] as $value) {
                                                                        echo "<option value=\"$value\">$value</option>";
                                                                    }
                                                                } ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="gender">Admission Gender</label>
                                                            <select name="gender" class="form-control select2" id="gender">
                                                                <option value="">--select--</option>
                                                                <?php $result = $dmo->getEnumValues("school", "gender");
                                                                if($result['status']){
                                                                    foreach ($result['data'] as $value) {
                                                                        echo "<option value=\"$value\">$value</option>";
                                                                    }
                                                                } ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="boarding_status">Boarding Status</label>
                                                            <select name="boarding_status" class="form-control select2" id="boarding_status">
                                                                <option value="">--select--</option>
                                                                <?php $result = $dmo->getEnumValues("school", "boarding_status");
                                                                if($result['status']){
                                                                    foreach ($result['data'] as $value) {
                                                                        echo "<option value=\"$value\">$value</option>";
                                                                    }
                                                                } ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="type">School Type</label>
                                                            <select name="type" class="form-control select2" id="type">
                                                                <option value="">--select--</option>
                                                                <?php $result = $dmo->getEnumValues("school", "type");
                                                                if($result['status']){
                                                                    foreach ($result['data'] as $value) {
                                                                        echo "<option value=\"$value\">$value</option>";
                                                                    }
                                                                } ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="address">Full Address</label>
                                                            <input type="text" name="address"  class="form-control" id="address" placeholder="<?= $schInfo['address']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="longitude">Longitude</label>
                                                            <input type="number" name="longitude"  class="form-control" id="longitude" placeholder="<?= $schInfo['longitude']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="latitude">Latitude</label>
                                                            <input type="number" name="latitude"  class="form-control" id="latitude" placeholder="<?= $schInfo['latitude']?? "";?>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="motto">Motto</label>
                                                            <textarea type="text" name="motto"  class="form-control" id="motto" placeholder="<?= $schInfo['motto']?? "";?>"></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="mission">Mission</label>
                                                            <textarea type="text" name="mission"  class="form-control" id="mission" placeholder="<?= $schInfo['mission']?? "";?>"></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="vision">Vision</label>
                                                            <textarea type="text" name="vision"  class="form-control" id="vision" placeholder="<?= $schInfo['vision']?? "";?>"></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3">
                                                        <div class="form-group">
                                                            <label for="core_values">Core Values</label>
                                                            <textarea type="text" name="core_values"  class="form-control" id="core_values" placeholder="<?= $schInfo['core_values']?? "";?>"></textarea>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="form-group">
                                                            <label for="logo">School Logo</label>
                                                            <input type="file" name="logo" accept="image/jpeg" class="form-control " id="logo">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <button type="submit" name="updateCompanyBasicInfo" class="btn btn-success waves-effect waves-light mt-2"><i class="mdi mdi-content-save"></i> Update</button>
                                                </div>
                                            </form>
                                        </div>
                                        <div class="tab-pane" id="companycontactinfo">
                                            <h5 class="mb-3 text-uppercase bg-light p-2"><i class="mdi mdi-office-building mr-1"></i> Contact Details <span class="fas fa-plus-circle text-success float-right" style="cursor: pointer;" onclick="showModal('#NewCompanyContact')"></span></h5>
                                            <div class="table-responsive">
                                                <table id="tblcompanycontact" class="table-bordered table-head-fixed table-striped text-nowrap w-100">
                                                    <thead>
                                                        <tr style="height: 40px;">
                                                            <th>#</th>
                                                            <th>Contact Type</th>
                                                            <th>Contact Value</th>
                                                            <th>Is Primary</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="tblcompanycontacts">
                                                    <?php
                                                    $response = $dmo->getCompanyContacts(["sc.school"=>$user['school_code']]);
                                                    if($response['status']){
                                                    $count=1;
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                        <tr>
                                                            <td><?= $count ?></td>
                                                            <td contentEditable=false onblur='edit("school_contact","contact_type",<?= $id ?>,this)'><?= $dmo->safeData($row['contact_type']) ?></td>
                                                            <td contentEditable=true onblur='edit("school_contact","contact_value",<?= $id ?>,this)'><?= $dmo->safeData($row['subject_name']) ?></td>
                                                            <td contentEditable=false onblur='edit("school_contact","is_primary",<?= $id ?>,this)'><?= $dmo->safeData($row['is_primary']) ?></td>
                                                        </tr>
                                                    <?php $count++; } }?>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <!-- <div class="tab-pane" id="companybankinfo">
                                            <form id="frmCompanyContactInfo" autocomplete="off" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                                <h5 class="mb-3 text-uppercase bg-light p-2"><i class="mdi mdi-office-building mr-1"></i> Bank Details</h5>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="bacc_name">Account Name:</label>
                                                            <input type="text" name="bacc_name" class="form-control" id="bacc_name" placeholder="<?= $schInfo['acc_name']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="bacc_branch">Branch Name</label>
                                                            <input type="text" name="bacc_branch" class="form-control" id="bacc_branch" placeholder="<?= $schInfo['acc_branch']?? "";?>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="bacc_no">Account Number:</label>
                                                            <input type="number" name="bacc_no" class="form-control" id="bacc_no" placeholder="<?= $schInfo['hs_name']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="bacc_contact_person">Contact Person Phone</label>
                                                            <input type="text" name="bacc_contact_person" class="form-control" id="bacc_contact_person" placeholder="<?= $schInfo['banck_contact_person']?? "";?>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <button type="submit" name="update_bacc_info" class="btn btn-success waves-effect waves-light mt-2"><i class="mdi mdi-content-save"></i> Save</button>
                                                </div>
                                            </form>
                                        </div> -->
                                        <div class="tab-pane" id="companysocialinfo">
                                            <h5 class="mb-3 text-uppercase bg-light p-2"><i class="mdi mdi-earth mr-1"></i> Social Media Handles <span class="fas fa-plus-circle text-success float-right" style="cursor: pointer;" onclick="showModal('#NewCompanySocial')"></span></h5>
                                            <div class="table-responsive">
                                                <table id="tblcompanysocial" class="table-bordered table-head-fixed table-striped text-nowrap w-100">
                                                    <thead>
                                                        <tr style="height: 40px;">
                                                            <th>Platform</th>
                                                            <th>Account Link</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="tblcompanysocials">
                                                    <?php
                                                    $response = $dmo->getCompanySocialHandles(["ss.school"=>$user['school_code']]);
                                                    if($response['status']){
                                                    $count=1;
                                                    foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                                        <tr>
                                                            <td contentEditable=false onblur='edit("school_social","platform",<?= $id ?>,this)'><?= $dmo->safeData($row['platform']) ?></td>
                                                            <td contentEditable=true onblur='edit("school_social","account_link",<?= $id ?>,this)'><?= $dmo->safeData($row['account_link']) ?></td>
                                                        </tr>
                                                    <?php $count++; } }?>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
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
    <script type="text/javascript" src="asset/js/dms.js"></script>
    <script>
        $(function(){
            $("#tblcompanycontact").DataTable({
                "responsive": false, "lengthChange": true, "autoWidth": true
            }).buttons().container().appendTo('#tblcompanycontact_wrapper .col-md-6:eq(0)');

            $("#tblcompanysocial").DataTable({
                "responsive": false, "lengthChange": true, "autoWidth": true
            }).buttons().container().appendTo('#tblcompanysocial_wrapper .col-md-6:eq(0)');
        })
        $(document).ready(function(){
            $("button[name='updateCompanyBasicInfo']").on("click", function(){
                updateCompanyBasicInfo();
            })
            $("button[name='btnSaveCompanyContact']").on("click", function(){
                SaveCompanyContact();
            })
            $("button[name='btnSaveCompanySocial']").on("click", function(){
                SaveCompanySocial();
            })
        })
    </script>
</body>
</html>