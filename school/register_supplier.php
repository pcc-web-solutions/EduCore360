<?php
require_once __DIR__."/uac.php";
?>
<!DOCTYPE html>
<html lang="en">
    <title>School || Register Supplier</title>
    <?php require "page/header.php";?>
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
                                                <li class="breadcrumb-item active">Register Supplier</li>
                                            </ol>
                                        </div>
                                        <h4 class="page-title">New Supplier Registration </h4>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-lg-12 col-xl-12">
                                    <div class="card-box">
                                        <div class="tab-content">
                                            <form id="frmRegisterSupplier" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="supplier_name">Supplier Name:</label>
                                                            <input type="text" name="supplier_name"  class="form-control" id="supplier_name" placeholder="PCC Suppliers">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="contact_name">Contact Name:</label>
                                                            <input type="text" name="contact_name"  class="form-control" id="contact_name" placeholder="Musee Abiud">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="contact_number">Contact Number:</label>
                                                            <input type="text" name="contact_number"  class="form-control" id="contact_number" placeholder="Makwa">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="email">Email Address:</label>
                                                            <input type="email" name="email"  class="form-control" id="email" placeholder="pccws.limited@gmail.com">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label for="address">Physical Address:</label>
                                                            <input type="text" name="address" class="form-control " id="address"  placeholder="P.o Box 77 - 50200, Sirisia (Bungoma). Chwele - Lwakhakha Street"></input>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="supplier_rating">Supplier Rating:</label>
                                                            <select name="supplier_rating" class="form-control select2" id="supplier_rating">
                                                                <option value="">--select--</option>
                                                                <option value="Excellent">Excellent</option>
                                                                <option value="Average">Average</option>
                                                                <option value="Poor">Poor</option>
                                                                <option value="Very Poor">Very Poor</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="created_at">Registration On:</label>
                                                            <input type="date" name="created_at" class="form-control " id="id_no" value="<?= $dmo->todaysDate(); ?>" readonly>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="date_joined">Last Updated On:</label>
                                                            <input type="date" name="date_joined" class="form-control " id="date_joined" value="<?= $dmo->todaysDate(); ?>" readonly>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-right">
                                                    <button type="submit" name="btnRegisterSupplier" class="btn btn-success waves-effect waves-light mt-2" onclick="RegisterSupplier()"><i class="mdi mdi-content-save"></i> Save</button>
                                                </div>
                                            </form>
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
        <script type="text/javascript">
            $(document).ready(function(){
                $("button[name='btnRegisterSupplier']").on("click", function(){
                    RegisterSupplier();
                })
            })
        </script>
    </body>
</html>