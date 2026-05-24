<?php
header("Cache-Control: no-cache, no-store, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

if (!extension_loaded('gd')) {
    die('GD extension not enabled');
}

if (!function_exists('config')) {
    function config(string $key, $default = null) {
        $value = $_ENV[$key];

        if ($value === false) {
            return $default;
        }
        $lower = strtolower($value);
        if (in_array($lower, ['true', 'false'])) {
            return $lower === 'true';
        }

        return $value;
    }
}

if (!function_exists('sanitizePngForTcpdf')) {
    function sanitizePngForTcpdf(string $input, string $output, int $quality = 90): bool{
        if (!file_exists($input)) {
            return false;
        }

        // Load PNG
        $img = imagecreatefrompng($input);
        if (!$img) {
            return false;
        }

        $width  = imagesx($img);
        $height = imagesy($img);

        // Create truecolor image (8-bit RGB)
        $clean = imagecreatetruecolor($width, $height);

        // Remove alpha channel
        $white = imagecolorallocate($clean, 255, 255, 255);
        imagefilledrectangle($clean, 0, 0, $width, $height, $white);

        // Copy image
        imagecopy($clean, $img, 0, 0, 0, 0, $width, $height);

        // Disable interlacing
        imageinterlace($clean, false);

        // Save as JPG (most reliable for TCPDF)
        $saved = imagejpeg($clean, $output, $quality);

        return $saved;
    }
}

if (!function_exists('normalizeStudentPhoto')) {
    function normalizeStudentPhoto(string $input, string $output, int $targetW = 300, int $targetH = 400): bool {
        if (!file_exists($input)) return false;

        $info = getimagesize($input);
        if (!$info) return false;

        [$srcW, $srcH] = $info;
        $mime = $info['mime'];

        if ($mime === 'image/jpeg') {
            $src = imagecreatefromjpeg($input);

            // ✅ FIX ORIENTATION
            $exif = @exif_read_data($input);
            if (!empty($exif['Orientation'])) {
                switch ($exif['Orientation']) {
                    case 3: $src = imagerotate($src, 180, 0); break;
                    case 6: $src = imagerotate($src, -90, 0); break;
                    case 8: $src = imagerotate($src, 90, 0); break;
                }
            }
        } elseif ($mime === 'image/png') {
            $src = imagecreatefrompng($input);
        } else {
            return false;
        }

        $srcW = imagesx($src);
        $srcH = imagesy($src);

        // Target ratio (portrait)
        $targetRatio = $targetW / $targetH;
        $srcRatio    = $srcW / $srcH;

        if ($srcRatio > $targetRatio) {
            // Too wide → crop sides
            $cropH = $srcH;
            $cropW = (int)($srcH * $targetRatio);
            $x = (int)(($srcW - $cropW) / 2);
            $y = 0;
        } else {
            // Too tall → crop bottom
            $cropW = $srcW;
            $cropH = (int)($srcW / $targetRatio);
            $x = 0;
            $y = (int)(($srcH - $cropH) / 4);
        }

        $dest = imagecreatetruecolor($targetW, $targetH);

        $white = imagecolorallocate($dest, 255, 255, 255);
        imagefill($dest, 0, 0, $white);

        imagecopyresampled(
            $dest,
            $src,
            0, 0,
            $x, $y,
            $targetW, $targetH,
            $cropW, $cropH
        );

        imagejpeg($dest, $output, 90);

        return true;
    }
}

function drawCardFront(TCPDF $pdf, array $student, array $info){
    global $dmo;

    /* ---------- SAFE DATA ---------- */
    $admNo = $student['adm_no'] ?? '';
    if (empty($admNo)) return; // skip bad record

    /* ---------- COLORS ---------- */
    $skyBlue  = [135, 206, 235];
    $cyan     = [224, 255, 255];
    $navy     = [11, 60, 93];
    $darkCyan = [0, 138, 138];

    /* ---------- CARD SIZE ---------- */
    $cardW = 85.6;
    $cardH = 54;

    /* ---------- BACKGROUND ---------- */
    $pdf->SetFillColor(...$cyan);
    $pdf->Rect(0, 0, $cardW, $cardH, 'F');

    /* ---------- WATERMARK ---------- */
    $wm = "asset/images/kenya_logo.png";
    if (file_exists($wm)) {
        $pdf->SetAlpha(0.08);
        $pdf->Image($wm, 22, 6, 40);
        $pdf->SetAlpha(1);
    }

    /* ---------- HEADER ---------- */
    $pdf->SetFillColor(...$skyBlue);
    $pdf->Rect(0, 0, $cardW, 10, 'F');

    if (file_exists($wm)) {
        $pdf->Image($wm, 1.2, 1.2, 7);
    }

    if (!empty($info['logo']) && file_exists($info['logo'])) {
        $pdf->Image($info['logo'], 76.5, 1.2, 7);
    }

    /* ---------- SCHOOL TEXT ---------- */
    $pdf->SetFont('courier', 'B', 9);
    $pdf->SetTextColor(...$navy);

    $pdf->SetXY(0, 0.5);
    $pdf->Cell($cardW, 4, $info['school_name'] ?? '', 0, 0, 'C');

    $pdf->SetXY(0, 3);
    $pdf->Cell($cardW, 4, $info['address'] ?? '', 0, 0, 'C');

    $pdf->SetXY(0, 6);
    $pdf->Cell($cardW, 4, strtoupper('MOTTO: '.($info['motto'] ?? '')), 0, 0, 'C');

    /* ---------- LINE ---------- */
    $pdf->SetDrawColor(...$navy);
    $pdf->SetLineWidth(0.7);
    $pdf->Line(0, 10, $cardW, 10);

    /* ---------- TITLE ---------- */
    $pdf->SetFont('courier', 'B', 16);
    $pdf->SetTextColor(...$darkCyan);
    $pdf->SetXY(0, 11);
    $pdf->Cell($cardW, 6, 'STUDENT IDENTITY CARD', 0, 0, 'C');

    /* ---------- PHOTO ---------- */
    $pdf->SetLineWidth(0.6);
    $pdf->Rect(2, 18, 22, 27);

    try {
        if (!empty($student['photo'])) {

            // Convert URL → physical path
            $photoPath = parse_url($student['photo'], PHP_URL_PATH);
            $originalPhoto = $_SERVER['DOCUMENT_ROOT'] . $photoPath;

            // Normalized directory
            $normalizedDir = __DIR__ . "/ids/photos/normalized/";

            if (!is_dir($normalizedDir)) { mkdir($normalizedDir, 0777, true); }
            // Normalized image path
            $normalized = $normalizedDir . $info['school_code'] . "_" . $admNo . ".jpg";

            if (file_exists($originalPhoto)) {
                $needsNormalization = false;

                // If normalized image missing
                if (!file_exists($normalized)) {
                    $needsNormalization = true;
                } else {
                    // Re-normalize ONLY if original photo changed
                    $originalModified   = filemtime($originalPhoto);
                    $normalizedModified = filemtime($normalized);
                    if ($originalModified > $normalizedModified) {
                        $needsNormalization = true;
                    }
                }

                // Normalize only when necessary
                if ($needsNormalization) {
                    normalizeStudentPhoto($originalPhoto, $normalized);
                }

                // Use cached normalized image
                if (file_exists($normalized)) {
                    $pdf->Image($normalized, 2, 18, 22, 27);
                }
            }
        }

    } catch (Exception $e) {
        $dmo->log("Could not process passport photo for Adm. No: $admNo");
    }

    /* ---------- STUDENT DETAILS ---------- */
    $pdf->SetFont('times', '', 8);
    $startX = 25;
    $startY = 18;
    $lineH  = 4.5;

    $details = [
        'Assessment. No:' => $admNo,
        'Full Name:'      => trim(($student['first_name'] ?? '')." ".($student['surname'] ?? '')." ".($student['last_name'] ?? '')),
        'Date of Birth:'  => !empty($student['dob']) ? date('d M Y', strtotime($student['dob'])) : '',
        'Admission Date:' => !empty($student['admitted_on']) ? date('d M Y', strtotime($student['admitted_on'])) : '',
        'Admitted In:'    => $student['admitted_in'] ?? '',
        'Valid Until:'    => !empty($student['admitted_on']) ? date('d M Y', strtotime($student['admitted_on'])) : ''
    ];

    $pdf->SetXY($startX, $startY);
    foreach ($details as $label => $value) {
        $pdf->SetTextColor(0,0,0);
        $pdf->Cell(20, $lineH, $label, 0, 0);

        $pdf->SetTextColor(0,0,153);
        $pdf->Cell(45, $lineH, $value, 0, 1);

        $pdf->SetX($startX);
    }

    /* ---------- QR CODE ---------- */
    try {
        $scheme = (!empty($_SERVER['HTTPS']) ? 'https://' : 'http://');

        $verifyUrl = $scheme.$_SERVER['HTTP_HOST']
            ."/request.php?tkn="
            .$dmo->storeRoute("ids/verifyid.php&id=".urlencode($admNo));

        $pdf->write2DBarcode($verifyUrl, 'QRCODE,H', 67, 27, 18, 18);

    } catch (Exception $e) {
        $dmo->log("Unable to generate QR Code for ID No: $admNo");
    }

    /* ---------- FOOTER ---------- */
    $pdf->SetFillColor(...$navy);
    $pdf->Rect(0, 46, $cardW, 8, 'F');

    $pdf->SetTextColor(255,255,255);
    $pdf->SetFont('helvetica', 'I', 6);
    $pdf->SetXY(0, 48);
    $pdf->Cell($cardW, 3, 'This card remains property of the school', 0, 0, 'C');

    /* ---------- SIGNATURE ---------- */
    $sign = "asset/images/principal_sign.png";
    if (file_exists($sign)) {
        $pdf->Image($sign, 45, 38, 18);
    }
}

function drawCardBack(TCPDF $pdf, array $student, array $info) {
    global $dmo;
    /* ---------- SAFE DATA ---------- */
    $admNo = $student['adm_no'] ?? '';
    if (empty($admNo)) return;

    $admittedOn = $student['admitted_on'] ?? null;

    $cardW = 85.6;
    $cardH = 54;

    $navy     = [11, 60, 93];
    $darkGray = [60, 60, 60];

    /* ---------- BACKGROUND ---------- */
    $pdf->SetFillColor(255,255,255);
    $pdf->Rect(0, 0, $cardW, $cardH, 'F');

    /* ---------- WATERMARK ---------- */
    $wm = "asset/images/school_logo.png";
    if (file_exists($wm)) {
        $pdf->SetAlpha(0.05);
        $pdf->Image($wm, 22, 6, 40);
        $pdf->SetAlpha(1);
    }

    /* ---------- EXPIRY WATERMARK ---------- */
    try {
        if (!empty($admittedOn)) {
            $today = date('Y-m-d');

            if (strtotime($admittedOn) < strtotime($today)) {

                $pdf->SetAlpha(0.18);
                $pdf->SetTextColor(180, 0, 0);
                $pdf->SetFont('helvetica', 'B', 28);

                $pdf->StartTransform();
                $pdf->Rotate(35, 43, 27);
                $pdf->Text(15, 30, 'EXPIRED');
                $pdf->StopTransform();

                $pdf->SetAlpha(1);
                $pdf->SetTextColor(0, 0, 0);
            }
        }
    } catch (Exception $e) {
        $dmo->log("Problem drawing expiry watermark for Adm. No: $admNo");
    }

    /* ---------- HEADER ---------- */
    $pdf->SetFillColor(...$navy);
    $pdf->Rect(0, 0, $cardW, 8, 'F');

    $pdf->SetFont('helvetica', 'B', 8);
    $pdf->SetTextColor(255,255,255);
    $pdf->SetXY(0, 2.5);
    $pdf->Cell($cardW, 3, 'IMPORTANT NOTICE', 0, 0, 'C');

    /* ---------- RULES ---------- */
    $pdf->SetFont('courier', '', 7);
    $pdf->SetTextColor(...$darkGray);
    $pdf->SetXY(6, 12);

    $rules = [
        '1. This card must be carried at all times.',
        '2. Loss or damage must be reported immediately.',
        '3. This card is not transferable.',
        '4. Any alteration renders the card invalid.',
        '5. If found, return to the school administration.'
    ];

    foreach ($rules as $rule) {
        $pdf->MultiCell(80, 4, $rule, 0, 'L');
        $pdf->SetX(6);
    }

    /* ---------- SCHOOL CONTACT ---------- */
    $pdf->SetFont('helvetica', 'B', 7);
    $pdf->SetTextColor(0,0,0);
    $pdf->SetXY(6, 38);
    $pdf->Cell(40, 4, 'School Contact:', 0, 1);

    $pdf->SetFont('helvetica', '', 7);
    $pdf->SetTextColor(...$darkGray);
    $pdf->SetX(6);
    $pdf->Cell(70, 4, $info['contact'] ?? '', 0, 1);

    /* ---------- SIGNATURE ---------- */
    $sign = "asset/images/principal_sign.png";
    if (file_exists($sign)) {
        try {
            $pdf->Image($sign, 55, 36, 22);
        } catch (Exception $e) {
            $dmo->log("Problem drawing principals's signature on ID for Adm. No: $admNo");
        }
    }

    $pdf->SetFont('helvetica', 'I', 6);
    $pdf->SetTextColor(0,0,0);
    $pdf->SetXY(55, 46);
    $pdf->Cell(22, 3, 'Principal', 0, 0, 'C');

    /* ---------- CARD NUMBER ---------- */
    $pdf->SetFont('courier', '', 6);
    $pdf->SetTextColor(120,120,120);
    $pdf->SetXY(6, 48);
    $pdf->Cell(40, 3, 'Card No: '.$admNo, 0, 0, 'L');

    /* ---------- MICRO TEXT ---------- */
    $pdf->SetFont('helvetica', '', 3.5);
    $pdf->SetTextColor(80, 80, 80);

    $microText = str_repeat('SCHOOL OFFICIAL STUDENT ID • ', 4);

    $pdf->SetXY(2, 50);
    $pdf->Cell(81, 2.5, $microText, 0, 0, 'C');
}