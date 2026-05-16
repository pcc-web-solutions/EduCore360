<?php
header('Content-Type: application/json');
require_once "server.php";

if($_SERVER['REQUEST_METHOD'] == "POST"){
    $request_name = $dmo->decryptData($_REQUEST['request']);
    switch($request_name){
        case "counties":
            try{
                $conditions = ["c.region"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getCounties($conditions)['status']){
                    $result = $dmo->getCounties($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['code'], "text"=>$row['description']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "sub_counties":
            try{
                $conditions = ["sc.county"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getSubCounties($conditions)['status']){
                    $result = $dmo->getSubCounties($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['code'], "text"=>$row['description']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "wards":
            try{
                $conditions = ["w.sub_county"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getScWards($conditions)['status']){
                    $result = $dmo->getScWards($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['code'], "text"=>$row['description']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "staffs":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getStaffs($conditions)['status']){
                    $result = $dmo->getStaffs($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['staff_code'], "text"=>$row['first_name']." ".$row['last_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "staffs":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getStaffs($conditions)['status']){
                    $result = $dmo->getStaffs($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['staff_code'], "text"=>$row['first_name']." ".$row['last_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "staffs":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getStaffs($conditions)['status']){
                    $result = $dmo->getStaffs($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['staff_code'], "text"=>$row['first_name']." ".$row['last_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        case "students":
            try{
                switch ($_REQUEST['filter']) {
                    case 'all':
                        $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['school'])];
                        break;
                    
                    case 'class':
                        $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['school']), "sc.class"=>$dmo->decryptData($_REQUEST['class1'])];
                        break;
                    
                    case 'stream':
                        $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['school']), "sc.class"=>$dmo->decryptData($_REQUEST['class2']), "s.stream_code"=>$dmo->decryptData($_REQUEST['stream'])];
                        break;
                    
                    case 'individual':
                        $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['school']), "std.adm_no"=>$dmo->decryptData($_REQUEST['adm_no'])];
                        break;
                    
                    default:
                        $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['school'])];
                        break;
                }
                if($dmo->getStudents($conditions)['status']){
                    $result = $dmo->getStudents($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = $row;
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;

        case "users":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getUsers($conditions)['status']){
                    $result = $dmo->getUsers($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['userid'], "text"=>$row['displayname']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "number_series":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getNoSeries($conditions)['status']){
                    $result = $dmo->getNoSeries($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['ns_code'], "text"=>$row['ns_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "dimensions":
            try{
                if($dmo->getDimensions()['status']){
                    $result = $dmo->getDimensions(); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['dim_id'], "text"=>$row['dim_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "subject_groups":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getSubjectGroups($conditions)['status']){
                    $result = $dmo->getSubjectGroups($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['group_code'], "text"=>$row['group_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "departments":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getDepartments($conditions)['status']){
                    $result = $dmo->getDepartments($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['dept_code'], "text"=>$row['dept_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "subject_departments":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getSubjectDepartments($conditions)['status']){
                    $result = $dmo->getSubjectDepartments($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['dept_code'], "text"=>$row['dept_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;

        case "classes":
            try{
                $conditions = ["school_code"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getClasses($conditions)['status']){
                    $result = $dmo->getClasses($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['class_code'], "text"=>$row['class_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;

        case "streams":
            try{
                $conditions = ["s.school"=>$dmo->userProfile($_SESSION['user']['userid'])['school_code'], "sc.class"=>$dmo->decryptData($_REQUEST['key'])];
                if($dmo->getStreams($conditions)['status']){
                    $result = $dmo->getStreams($conditions); $data = [];
                    foreach ($result['data'] as $row) { 
                        $data[] = ["value"=>$row['stream_code'], "text"=>$row['stream_name']];
                    }
                    echo json_encode(["status"=>true, "data"=>$data]);
                } else {
                    echo json_encode(["status"=>false, "message"=>"No $request_name found"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
            
        case "upload_student_photo":
            try{
                $id = $dmo->decryptData($_REQUEST['id']);
                if (isset($_FILES['photo'])) {
                    $upload_res = $dmo->upload($_FILES['photo']);
                    if ($upload_res['status']) {
                        $table = "student"; $column = "profile_picture"; $value = $upload_res['path'];
                        $updated = $dmo->editValue($table, $column, $id, $value);
                        if($updated){
                            echo json_encode(["status" => true, "filename" => $value ]);
                        } else {
                            echo json_encode(["status" => false, "message" => "Unable to ammend details"]);
                        } 
                    } else {
                        echo json_encode(["status" => false, "message" => "Upload failed"]);
                    }
                } else {
                    echo json_encode(["status" => false, "message" => "No file"]);
                }
            } catch (Exception $e) {
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
        
        case "generate_student_ids":
            try{
                $info = $dmo->getSchInfo($_SESSION['user'])['data'];
                $students = $dmo->cleanData($_POST['students']);
                $id_layout = $dmo->cleanData($_POST['id_layout']);
                /*
                CR80 PVC size (ISO/IEC 7810)
                Width  = 85.6mm
                Height = 54mm
                */

                class IDPDF extends TCPDF {
                    public function Header() {}
                    public function Footer() {}
                }

                $pdf = new IDPDF('L', 'mm', [54, 85.6], true, 'UTF-8', false);
                $pdf->SetMargins(0, 0, 0);
                $pdf->SetAutoPageBreak(false);

                $pdf->SetCreator('Educore360');
                $pdf->SetAuthor($info['school_name']);
                $pdf->SetTitle('Student ID Card');
                $pdf->SetSubject('Automated Student ID Creator');
                $pdf->SetKeywords('');

                foreach ($students as $student) {
                    // ---------- FRONT ---------- */
                    $pdf->AddPage();
                    drawCardFront($pdf, $student, $info);
                
                    // ---------- BACK ---------- */
                    $pdf->AddPage();
                    drawCardBack($pdf, $student, $info);
                }

                /* ---------- OUTPUT ---------- */
                ob_end_clean();
                $pdf->Output(__DIR__."/ids/student_ids.pdf", 'F');
                unset($pdf);

                $saved = $dmo->save(__DIR__."/ids/student_ids.pdf");
                if ($saved['status']) {
                    echo json_encode(["status" => true, "pdf_url" => "request.php?tkn=".$dmo->storeRoute("ids/student_ids.pdf") ]);
                } else {
                    echo json_encode(["status"=>false, "message"=>$saved['message']]);
                }
            } catch (Exception $e){
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;

        case "update_data":
            try{
                $table = $dmo->cleanData($dmo->decryptData($_REQUEST['table']));
                $column = $dmo->cleanData($dmo->decryptData($_REQUEST['column']));
                $id = $dmo->cleanData($dmo->decryptData($_REQUEST['id']));
                $value = $dmo->cleanData($dmo->decryptData($_REQUEST['value']));
                echo $dmo->editValue($table, $column, $id, $value);
            } catch (Exception $e){
                echo json_encode(["status"=>false, "message"=>$e->getMessage()]);
            }
            break;
            
        default: break;
    }
}else{
    echo json_encode(["status"=>"error", "message"=>"No request sent to server!"]);
}