<?php 
require "server.php";

try {
    if($dmo->getSchools()['status']){
        $response = $dmo->getSchools(); $school_count = 0; $user_count = 0;
        foreach ($response['data'] as $row) {
            $school_code = $row['school_code'];
            $school_name = $row['school_name'];
            $school_mail = $row['mail'];
            $school_contact = $row['contact'];
            $school_logo = $row['logo'];
            
            $result = $dmo->getUsers(["school_code"=>$school_code, "username"=>$school_code]);
            if($result['status']){
                $user_count++;
            } else {
                try{
                    $response = $dmo->create_default_school_account($school_code,$school_name,$school_mail,$school_contact,$school_logo);
                    if($response['status']){
                        $user_count++;
                    } else {
                        echo json_encode(array("status"=>false,"msg"=>$response['message'])); exit;
                    }
                } catch (Exception $e) {
                    echo json_encode(array("status"=>false,"msg"=>$e->getMessage())); exit;
                }
            } $school_count++;
        }
        header("location: request.php?tkn=".$dmo->storeRoute("website/index.php")); exit;
    } else {
        try{
            $code = "12345678"; $name = "PCC Secondary School"; $category = "National"; $mail = "pccws.limited@gmail.com"; $contact = "0741915943";
            $response1 = $dmo->create_dummy_school($code,$name,$category,$mail,$contact);
            if($response1['status']){
                try{
                    $response2 = $dmo->create_default_school_account($code, $name, $mail, $contact);
                    if($response2['status']){
                        header("location: request.php?tkn=".$dmo->storeRoute("website/index.php"));
                    } else{
                        echo json_encode(array("status"=>false,"msg"=>$response2['message'])); exit;
                    }
                } catch (Exception $e) {
                    echo json_encode(array("status"=>false,"msg"=>$e->getMessage())); exit;
                }
            } else{
                echo json_encode(array("status"=>false,"msg"=>$response1['message'])); exit;
            }
            
        }catch(Exception $e){
            echo json_encode(array("status"=>false,"msg"=>$e->getMessage()));
        }
    }
}
catch (Exception $e) {
    echo json_encode(array("status"=>false,"msg"=>$e->getMessage()));
}
?>