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
                                        <li class="nav-item">
                                            <a href="#companybankinfo" data-toggle="tab" aria-expanded="false" class="nav-link">
                                                Bank Account Details
                                            </a>
                                        </li>
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
                                                            <input type="text" name="knec_centre_no"  class="form-control" id="knec_centre_no" placeholder="<?= $schInfo['knec_centre_no']?? "";?>">
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
                                            <form id="frmCompanyContactInfo" autocomplete="off" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                                <h5 class="mb-3 text-uppercase bg-light p-2"><i class="mdi mdi-office-building mr-1"></i> Contact Details</h5>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="mail">Contact Email Address</label>
                                                            <input type="email" name="mail" class="form-control" id="mail" placeholder="<?= $schInfo['mail']?? "";?>">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="contact">Contact Phone Number</label>
                                                            <input type="text" name="contact" class="form-control" id="contact" placeholder="<?= $schInfo['contact']?? "";?>">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <button type="submit" name="updateCompanyContactInfo" class="btn btn-success waves-effect waves-light mt-2"><i class="mdi mdi-content-save"></i> Update</button>
                                                </div>
                                            </form>
                                        </div>
                                        <div class="tab-pane" id="companybankinfo">
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
                                        </div>
                                        <div class="tab-pane" id="companysocialinfo">
                                            <form id="frmCompanySocialInfo" autocomplete="off" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                                <h5 class="mb-3 text-uppercase bg-light p-2"><i class="mdi mdi-earth mr-1"></i> Social Media Handles</h5>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="facebook">Facebook</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fab fa-facebook-square"></i></span>
                                                                </div>
                                                                <input type="text" name="facebook" class="form-control" id="facebook" placeholder="<?= $schInfo['facebook']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="twitter">Twitter</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fab fa-twitter"></i></span>
                                                                </div>
                                                                <input type="text" name="twitter" class="form-control" id="twitter" placeholder="<?= $schInfo['twitter']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div> 
                                                </div> 

                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="instagram">Instagram</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fab fa-instagram"></i></span>
                                                                </div>
                                                                <input type="text" name="instagram" class="form-control" id="instagram" placeholder="<?= $schInfo['instagram']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="linkedin">Linkedin</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fab fa-linkedin"></i></span>
                                                                </div>
                                                                <input type="text" name="linkedin" class="form-control" id="linkedin" placeholder="<?= $schInfo['linkedin']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div> 
                                                </div> 

                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="skype">Skype</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fab fa-skype"></i></span>
                                                                </div>
                                                                <input type="text" name="skype" class="form-control" id="skype" placeholder="<?= $schInfo['skype']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="website">Website</label>
                                                            <div class="input-group">
                                                                <div class="input-group-prepend">
                                                                    <span class="input-group-text"><i class="fa fa-globe"></i></span>
                                                                </div>
                                                                <input type="text" name="website" class="form-control" id="website" placeholder="<?= $schInfo['website']?? "";?>">
                                                            </div>
                                                        </div>
                                                    </div> 
                                                </div>
                                                <div class="text-right">
                                                    <button type="submit" name="updateCompanySocialInfo" class="btn btn-success waves-effect waves-light mt-2"><i class="mdi mdi-content-save"></i> Update</button>
                                                </div>
                                            </form>
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
        $(document).ready(function(){
            $("button[name='updateCompanyBasicInfo']").on("click", function(){
                updateCompanyBasicInfo();
            })
            $("button[name='updateCompanyContactInfo']").on("click", function(){
                updateCompanyContactInfo();
            })
            $("button[name='updateCompanySocialInfo']").on("click", function(){
                updateCompanySocialInfo();
            })
        })
    </script>
</body>
</html>