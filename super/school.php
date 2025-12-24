<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Super || Schools</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewSchool" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New School</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewSchool" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="school_code">School Code:</label>
                                            <input type="text" name="school_code" class="form-control " id="school_code" placeholder="36626126">
                                        </div>
                                        <div class="form-group">
                                            <label for="school_name">School Name:</label>
                                            <input type="text" name="school_name" class="form-control " id="school_name" placeholder="AC. Butonge High School">
                                        </div>
                                        <div class="form-group">
                                            <label for="category">Category:</label>
                                            <select name="category" class="form-control select2" id="category">
                                                <option value="National">National</option>
                                                <option value="Extra-County">Extra-County</option>
                                                <option value="County">County</option>
                                                <option value="District">District</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="mail">Email Address:</label>
                                            <input type="email" name="mail" class="form-control " id="mail" placeholder="e.g., schoolcode@mail.com">
                                        </div>
                                        <div class="form-group">
                                            <label for="contact">School Contact:</label>
                                            <input type="number" name="contact" class="form-control " id="contact" placeholder="e.g., 0741915943">
                                        </div>
                                        <div class="form-group">
                                            <label for="logo">School Logo:</label>
                                            <input type="file" name="logo" accept="image/jpeg" class="form-control " id="logo">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewSchool" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewSchool')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Schools </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblschool" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>Logo</th>
                                    <th>#</th>
                                    <th>School Code</th>
                                    <th>School Name</th>
                                    <th>Category</th>
                                    <th>Email Address</th>
                                    <th>Contact Number</th>
                                    <th>Logo Path</th>
                                </tr>
                            </thead>
                            <tbody id="tblschools">
                            <?php
                            if($dmo->getSchools()['status']){
                            $response = $dmo->getSchools(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><img src="<?= $dmo->safeData($row['logo']); ?>" alt="image" class="rounded-circle" width="50px" height="50px"></td>
                                    <td><?= $count ?></td>
                                    <td contentEditable=true onblur='edit("school","school_code",<?= $id ?>,this)'><?= $dmo->safeData($row['school_code']) ?></td>
                                    <td contentEditable=true onblur='edit("school","school_name",<?= $id ?>,this)'><?= $dmo->safeData($row['school_name']) ?></td>
                                    <td contentEditable=true onblur='edit("school","category",<?= $id ?>,this)'><?= $dmo->safeData($row['category']) ?></td>
                                    <td contentEditable=true onblur='edit("school","contact",<?= $id ?>,this)'><?= $dmo->safeData($row['contact']) ?></td>
                                    <td contentEditable=true onblur='edit("school","mail",<?= $id ?>,this)'><?= $dmo->safeData($row['mail']) ?></td>
                                    <td contentEditable=true onblur='edit("school","logo",<?= $id ?>,this)'><?= $dmo->safeData($row['logo']) ?></td>
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
	$("#tblschool").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblschool_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewSchool']").on("click", function(){
        saveNewSchool();
	})
})
</script>
</body>
</html>