<?php
require "server.php";

try {
    if (isset($_GET['tkn'])) {
        $fileName = $dmo->getRoute($_GET['tkn']);
        if (!$fileName || !file_exists($fileName)) {
            $dmo->log($fileName." with token ".$_GET['tkn']." could not be found.");
            die(http_response_code(404));
        }
        include $fileName;
        exit;
    }
    if (isset($_GET['pg'])) {
        $fileName = $dmo->decryptFile($_GET['pg']);
        if (!$fileName || !file_exists($fileName)) {
            $dmo->log($fileName." with token ".$_GET['pg']." could not be found.");
            die(http_response_code(404));
        }
        include $fileName;
        exit;
    }
    $dmo->log("Invalid request sent to server");
    die(http_response_code(403));
} catch (Exception $e) {
    $dmo->log($e->getMessage());
    die(http_response_code(401));
}