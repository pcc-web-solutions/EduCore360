<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Finance || Tax Rates</title>
    <?php require "page/header.php";?>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="NewTaxRate"  tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">New Tax Rate</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body">
                                    <form id="frmNewTaxRate" autocomplete="off" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                        <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                                        <div class="form-group">
                                            <label for="name">Tax Description:</label>
                                            <textarea type="text" name="name" class="form-control" id="name" placeholder="e.g Housing Lavy"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="e.g 16">Tax Rate (In Percentage):</label>
                                            <input type="number" name="e.g 16" class="form-control" id="e.g 16" placeholder="0.00">
                                        </div>
                                        <div class="form-group">
                                            <label for="type">Tax Type:</label>
                                            <select name="type" class="form-control select2" id="type">
                                                <option value="">--select--</option>
                                                <?php $result = $dmo->getEnumValues("tax", "type");
                                                if($result['status']){
                                                    foreach ($result['data'] as $value) {
                                                        echo "<option value=\"$value\">$value</option>";
                                                    }
                                                } ?>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn-sm btn-info btn-flat float-right" name="btnNewTaxRate" >Save</button> 
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
                                        <button type="button" class="btn btn-success float-right" onclick="showModal('#NewTaxRate')">New</button>
                                    </ol>
                                </div>
                                <h4 class="page-title">Setup Tax Rates</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">  
                    <table id="tbltaxrate" class="table-bordered table-head-fixed table-striped table-responsive text-nowrap">
                        <thead>
                            <tr style="height: 40px;">
                                <th>#</th>
                                <th>Description</th>
                                <th>Tax Rate (%ge)</th>
                                <th>Rate Type</th>
                            </tr>
                        </thead>
                        <tbody id="tbltaxrate">
                        <?php
                        if($dmo->getTaxRates(["school_code"=>$user['school_code']])['status']){
                        $response = $dmo->getTaxRates(["school_code"=>$user['school_code']]); $count=1;
                        foreach ($response['data'] as $row) { $id = $dmo->safeData($row['id']); ?>
                            <tr>
                                <td><?= $count ?></td>
                                <td contentEditable=false onblur="edit('charge','name','<?= $id ?>',this)"><?= $dmo->safeData($row['name']) ?></td>
                                <td contentEditable=false onblur="edit('charge','rate','<?= $id ?>',this)"><?= $dmo->safeData($row['description']) ?></td>
                                <td contentEditable=false onblur="edit('charge','type','<?= $id ?>',this)"><?= $dmo->safeData($row['type']) ?></td>
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
	$("#tbltaxrate").DataTable({
    "responsive": false, "lengthChange": true, "autoWidth": true
  }).buttons().container().appendTo('#tbltaxrate_wrapper .col-md-6:eq(0)');
})

$(document).ready(function(){
	$("button[name='btnNewTaxRate']").on("click", function(){
        NewTaxRate();
	})
})
</script>
</body>
</html>