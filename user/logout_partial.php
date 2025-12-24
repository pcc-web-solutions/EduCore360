<?php
    $dmo->reportLogout(userid: $_SESSION['user']['userid']);
    // session_unset();
    // session_destroy();
    unset($_SESSION["user"]);
    header(header: "location: request.php?tkn=".$dmo->storeRoute("user/logout.php"));
    exit();
?>