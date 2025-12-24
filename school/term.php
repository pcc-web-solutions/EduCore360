<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Terms</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewTerm" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Term</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewTerm" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <div class="form-group">
                                        <label for="term">Term Code:</label>
                                            <select name="term_code"  class="form-control select2" id="term_code" onchange="$('#term_name').val('Term '+$(this).children('option:selected').val())">
                                                <option value="">--select--</option>
                                                <option value="1">Term 1</option>
                                                <option value="2">Term 2</option>
                                                <option value="3">Term 3</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="term_name">Term Name:</label>
                                            <input type="text" name="term_name" class="form-control " id="term_name" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label for="opening_date">Opening Date:</label>
                                            <input type="date" name="opening_date" class="form-control " id="opening_date">
                                        </div>
                                        <div class="form-group">
                                            <label for="closing_date">Closing Date:</label>
                                            <input type="date" name="closing_date" class="form-control " id="closing_date">
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-info btn-flat float-right" name="btnNewTerm" ><i class="fas fa-save"></i>&nbspSave</button> 
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <button type="button" class="btn btn-success float-right" onclick="showModal('#NewTerm')"><i class="fas fa-plus-circle"></i>&nbspNew</button>
                                </div>
                                <h4 class="page-title">Set Up Terms </h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                        <table id="tblterm" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                            <thead>
                                <tr style="height: 40px;">
                                    <th>#</th>
                                    <th>Term Code</th>
                                    <th>Term Name</th>
                                    <th>Opening Date</th>
                                    <th>Closing Date</th>
                                </tr>
                            </thead>
                            <tbody id="tblterms">
                            <?php
                            if($dmo->getTerms()['status']){
                            $response = $dmo->getTerms(); $count=1;
                            foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                                <tr>
                                    <td><?= $count ?></td>
                                    <td contentEditable=false onblur='edit("term","term_code",<?= $id ?>,this)'><?= $dmo->safeData($row['term_code']) ?></td>
                                    <td contentEditable=false onblur='edit("term","term_name",<?= $id ?>,this)'><?= $dmo->safeData($row['term_name']) ?></td>
                                    <td contentEditable=true onblur='edit("term","opening_date",<?= $id ?>,this)'><?= $dmo->safeData($row['opening_date']) ?></td>
                                    <td contentEditable=true onblur='edit("term","closing_date",<?= $id ?>,this)'><?= $dmo->safeData($row['closing_date']) ?></td>
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
	$("#tblterm").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tblterm_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewTerm']").on("click", function(){
        saveNewTerm();
	})
})
</script>
</body>
</html>