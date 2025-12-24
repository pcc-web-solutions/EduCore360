<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Streams</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewStream" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Stream</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewStream" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                            <label for="class_code">Class Code:</label>
                                            <select name="class_code"  class="form-control select2" id="class_code">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getClasses(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                                                $response = $dmo->getClasses(["school_code"=>$dmo->safeData($user['school_code'])]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['class_code'].">".$row['school_code']." - ".$row['class_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="stream_code">Stream Code:</label>
                                            <input type="text" name="stream_code" class="form-control " id="stream_code" value="<?= $dmo->generateUid() ?>" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="stream_name">Stream Name:</label>
                                            <input type="text" name="stream_name" class="form-control " id="stream_name" placeholder="East">
                                        </div>
                                        <div class="form-group">
                                            <label for="description">Description:</label>
                                            <textarea name="description" class="form-control " id="description" placeholder="e.g The eagles class"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="capacity">Capacity:</label>
                                            <input type="number" name="capacity" class="form-control " id="capacity" placeholder="40">
                                        </div>
                                        <div class="form-group">
                                            <label for="class_teacher">Class Teacher:</label>
                                            <select name="class_teacher"  class="form-control select2" id="class_teacher">
                                                <option value="">--select--</option>
                                                <?php
                                                if($dmo->getTeachers(["school_code"=>$user['school_code']])['status']){
                                                $response = $dmo->getTeachers(["school_code"=>$user['school_code']]);
                                                foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']);
                                                    echo "<option value=".$row['teacher_code'].">".$row['last_name']." ".$row['first_name']."</option>";
                                                } }?>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewStream" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewStream')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Streams </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblstream" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>School Code</th>
                                    <th>School Name</th>
                                    <th>Class</th>
                                    <th>Code</th>
                                    <th>Stream</th>
                                    <th>Description</th>
                                    <th>Capacity</th>
                                    <th>Class Teacher</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                </tr>
                            </thead>
                            <tbody id="tblstreams">
                            <?php
                            if($dmo->getStreams(["school_code"=>$dmo->safeData($user['school_code'])])['status']){
                            $response = $dmo->getStreams(["school_code"=>$dmo->safeData($user['school_code'])]); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("stream","school_code",<?= $id ?>,this)'><?= $dmo->safeData($row['school_code']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","school_name",<?= $id ?>,this)'><?= $dmo->safeData($row['school_name']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","class_code",<?= $id ?>,this)'><?= $dmo->safeData($row['class_name']) ?></td>
                                    <td contentEditable=true onblur='edit("stream","stream_code",<?= $id ?>,this)'><?= $dmo->safeData($row['stream_code']) ?></td>
                                    <td contentEditable=true onblur='edit("stream","stream_name",<?= $id ?>,this)'><?= $dmo->safeData($row['stream_name']) ?></td>
                                    <td contentEditable=true onblur='edit("stream","description",<?= $id ?>,this)'><?= $dmo->safeData($row['description']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","capacity",<?= $id ?>,this)'><?= $dmo->safeData($row['capacity']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","class_teacher",<?= $id ?>,this)'><?= $dmo->safeData($row['class_teacher']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","created_at",<?= $id ?>,this)'><?= $dmo->safeData($row['created_at']) ?></td>
                                    <td contentEditable=false onblur='edit("stream","updated_at",<?= $id ?>,this)'><?= $dmo->safeData($row['updated_at']) ?></td>
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
	$("#tblstream").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblstream_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewStream']").on("click", function(){
        saveNewStream();
	})
})
</script>
</body>
</html>