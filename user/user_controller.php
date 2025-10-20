<?php 
require_once "server.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    try {
        if (!isset($_POST['csrf_token']) || !$dmo->validateCsrfToken($_POST['csrf_token'])) {
            throw new Exception("Invalid CSRF token");
        }
    } catch (Exception $e) {
        $err = $e->getMessage(); exit;
    }
    if(isset($_POST['btnApplyForJob'])){
        try{
            $applicant_code = $dmo->cleanData($_REQUEST['applicant_code'])?? $dmo->cleanData($dmo->generateUid());
            $applicant_name = $dmo->cleanData($_REQUEST['applicant_name']);
            $contact_phone = $dmo->cleanData($_REQUEST['contact_phone']);
            $contact_email = $dmo->cleanData($_REQUEST['contact_email']);
            $applicant_code = $dmo->cleanData($_REQUEST['applicant_code']);
            $job_posting_code = $dmo->cleanData($_REQUEST['job_posting_code']);
            $resume = $_FILES['resume'];
            $cover_letter = $_FILES['cover_letter'];

            $reg_status = $dmo->registerApplicant($applicant_code, $applicant_name, $contact_phone, $contact_email);
            if($reg_status['status'] = "success" || $reg_status['status'] == "warning"){
                $apl_status = $dmo->applyForJob($applicant_code, $job_posting_code, $resume, $cover_letter);
                if($apl_status["status"] == "success"){
                    $success = $apl_status["message"];
                }else if($apl_status["status"] == "warning"){
                    $warning = $apl_status["message"];
                }else{
                    $err = $apl_status["message"];
                }
            }else{
                $err = $reg_status["message"];
            }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }
    if(isset($_POST['btnSignup'])) {
        try{
            $id_no = $dmo->cleanData($_POST['id_no']);
            $alias = $dmo->cleanData($_POST['alias']);
            $user_password = password_hash(password: $dmo->cleanData($_POST['user_password']), algo: PASSWORD_DEFAULT);
            $confirm_password = $dmo->cleanData($_POST['confirm_password']);

            $stmt = "SELECT school, id_no, CONCAT(first_name,' ',last_name) AS displayname, email, phone, role, profile_picture FROM staff WHERE id_no = ? ";
            if($dmo->numRows(query: $stmt, params: [$id_no])){
                $resultset = $dmo->readData(query: $stmt, params: [$id_no]);
                $stmt = "SELECT userid FROM user WHERE userid = ? OR email = ? OR username = ? ";
                if($dmo->numRows(query: $stmt, params: [$id_no, $resultset['email'], $alias])){
                    $err = "ID Number: $id_no is already tied to an account with the email: ".$resultset['email'].".";
                }else{
                    switch($resultset['role']){
                        case 'Principal': $role = "school"; break;
                        case 'Admin': $role = "school"; break;
                        case 'Support': $role = "support"; break;
                        case 'Teacher': $role = "teacher"; break;
                        default: $role = "guest";
                    }
                    $params = [$resultset['school'], $id_no, $alias, $user_password, $resultset['displayname'], $role, $role, $resultset['email'], $resultset['phone'], $resultset['profile_picture'], $dmo->todaysDate(), 4, 1];
                    $stmt = "INSERT INTO user (school, userid, username, password, displayname, role, profile, email, contact, photo, regdate, attempts, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    $last_insert_id = $dmo->executeInsert(query: $stmt, params: $params);
                    if($last_insert_id){ header("location: request.php?tkn=".$dmo->storeRoute("user/signin.php")."&info=Account created successfully. Please sign in to proceed");
                    }else{$err = "Unable to sign you up";}
                }
                
            }else{ $err = "You must have been registered as an employee before creating an account with us."; }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSubmitEmail'])){
        try{
            $address = $dmo->cleanData($_REQUEST['email']);
            if($dmo->checkmail(address: $address)){
                $_SESSION['account'] = $address;
                header(header: "location: request.php?tkn=".$dmo->storeRoute("user/reset_password.php"));
            }else{
                $_SESSION['account'] = null;
                $err = "We could not find the provided email address";
            }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnResetPassword'])){
        try{
            $password = password_hash(password: $dmo->cleanData($_REQUEST['new_password']),algo: PASSWORD_DEFAULT);
            $email = $dmo->cleanData($_REQUEST['email']);

            if($dmo->resetPassword(new_password: $password, address: $email)){
                header(header: "location: request.php?tkn=".$dmo->storeRoute("user/signin.php")."&info=Password updated successfully. Please you can now sign in");
            }else{
                $_SESSION['account'] = null;
                $err = "Sorry we were unable to reset your account.";
            }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }
    if(isset($_POST['btnSignin'])) {
        try{
            $username = $dmo->cleanData($_POST['username']);
            $password = $dmo->cleanData($_POST['password']);
            $dmo->initUser(username: $username,password: $password);
            $feedback = $dmo->exists();
            if($feedback == true){
                $userDetails = $dmo->getUsers(["username"=>$username])['data'][0];
                if($userDetails != ""){
                    $accountHealth = $dmo->accountHealth( $userDetails['status'], $userDetails['attempts'] );
                    if($accountHealth === TRUE){
                        $userid = $userDetails['userid']; $password = $userDetails['password'];
                        $attempts = $userDetails['attempts'];
                        $pass_state = $dmo->verifyPassword(userid: $userid, password: $password, attempts: $attempts);
                        if($pass_state === TRUE){
                            $loginstatus = $dmo->login(user: $userDetails);
                            $dmo->reportLogin(userid: $userDetails['userid']);
                            header(header: "location: ".$loginstatus." ");
                        }else{ $warning = $pass_state; }
                    }else{ $info = $accountHealth; }
                }else{ $err = "Problem retrieving your details"; }
            }else{ $err = "Username could not be found"; }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }
}    
?>