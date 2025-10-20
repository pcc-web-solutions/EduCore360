<?php
header('Content-Type: application/json');
require_once "server.php";

if($_SERVER['REQUEST_METHOD'] == "POST"){
    $request_name = $dmo->decryptData($_REQUEST['request']);
    switch($request_name){
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
                $conditions = ["s.class"=>$dmo->decryptData($_REQUEST['key'])];
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
    echo json_encode(array("status"=>"error", "message"=>"No request sent to server!"));
}
?>