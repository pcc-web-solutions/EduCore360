<?php
require "server.php";
$allowed = ['pdf', 'php'];
try {
    if (isset($_GET['tkn'])) {
        $fileName = $dmo->getRoute($_GET['tkn']);
        if (!$fileName || !file_exists($fileName)) {
            $dmo->log($fileName." with token ".$_GET['tkn']." could not be found.");
            die(http_response_code(404));
        }

        $fileExt = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

        if (!in_array($fileExt, $allowed)) {
            $dmo->log("Forbiden File Extension: Unable to load {$fileExt} file");
            die(http_response_code(403));
        }

        if ($fileExt === 'pdf') {
            if (ob_get_length()) {
                ob_end_clean();
            }
            header('Content-Type: application/pdf');
            header('Content-Disposition: inline; filename="'.basename($fileName).'"');
            header('Content-Length: ' . filesize($fileName));

            readfile($fileName);
            exit;
        }
        // fallback for normal pages
        include $fileName;
        exit;
    }
    $dmo->log("Invalid request sent to server");
    die(http_response_code(403));
} catch (Exception $e) {
    $dmo->log($e->getMessage());
    die(http_response_code(401));
}