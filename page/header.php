    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="PCC Web Solutions" name="author" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link rel="shortcut icon" href="asset/images/app-icon.png">
    <!-- Plugins css -->
    <link href="asset/libs/flatpickr/flatpickr.min.css" rel="stylesheet" type="text/css" />

    <!-- App css -->
    <link href="asset/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="asset/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="asset/css/font-awesome.min.css">
    <link rel="stylesheet" href="asset/libs/select2/css/select2.min.css">
    <link rel="stylesheet" href="asset/libs/select2-bootstrap4-theme/select2-bootstrap4.min.css">
    <link rel="stylesheet" href="asset/libs/datatables/dataTables.bootstrap4.css">
    <link rel="stylesheet" href="asset/libs/datatables/responsive.bootstrap4.css">
    <link rel="stylesheet" href="asset/libs/datatables/buttons.bootstrap4.css">
    <link href="asset/css/app.min.css" rel="stylesheet" type="text/css" />
    <!-- Loading button css -->
    <link href="asset/libs/ladda/ladda-themeless.min.css" rel="stylesheet" type="text/css" />
    <!--Load Sweet Alert Javascript-->
    <script src="asset/js/swal.js"></script>
    <style>
        .bg-darkcyan { background-color: darkcyan !important; }
        .text-darkcyan { color: darkcyan !important; }
        .btn-darkcyan { background-color: darkcyan; border: none; }
        .btn-darkcyan:hover { background-color: #008b8b; }
        .btn-outline-darkcyan { color: darkcyan; border: 1px solid darkcyan; }
        .btn-outline-darkcyan:hover { background-color: darkcyan; color: #fff; }
    </style>
    <?php if(isset($success)) {?>
        <script>
            setTimeout(function () { swal("Success","<?= $success;?>","success"); }, 100);
        </script>
    <?php } ?>

    <?php if(isset($info)) {?>
        <script>
            setTimeout(function () { swal("Information","<?= $info;?>","info"); }, 100);
        </script>
    <?php } ?>

    <?php if(isset($warning)) {?>
        <script>
            setTimeout(function () { swal("Warning","<?= $warning;?>","warning"); }, 100);
        </script>
    <?php } ?>

    <?php if(isset($err)) {?>
        <script>
            setTimeout(function () { swal("Failed","<?= $err;?>","error"); }, 100);
        </script>
    <?php } ?>