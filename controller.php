<?php
header("Cache-Control: no-cache, no-store, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

require_once "server.php";
$dmo->manageSessionTimeout(false);
$dmo->check_login();
$user = $dmo->userProfile($_SESSION['user']['userid']);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    try {
        if (!isset($_POST['csrf_token']) || !$dmo->validateCsrfToken($_POST['csrf_token'])) {
            throw new Exception("Invalid CSRF token");
        }
    } catch (Exception $e) {
        $err = $e->getMessage(); exit;
    }

    if (isset($_POST['btnUnlockScreen'])) {
        $password = $_POST['password'] ?? ''; 
        $attempts = $user['attempts'];
        if(password_verify($password, $user['password']) === TRUE) {
            $dmo->executeUpdate('user', ['attempts'=>4], ['userid'=>$user['userid']]);
            unset($_SESSION['locked']);
            $_SESSION['last_activity'] = time();
            $loginstatus = $dmo->login(user: $user);
            $dmo->reportLogin(userid: $user['userid']);
            header(header: "location: ".$loginstatus." ");
		}else{
			$attempts--;
            $dmo->executeUpdate('user', ['attempts'=>$attempts], ['userid'=>$user['userid']]);
			if($attempts > 0){$warning = "Incorrect password: $attempts attempts remaining";}
			else{$err = "Account blocked";}
		}
    }

    if(isset($_POST['btnSwitchUserRole'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $profile = $dmo->cleanData($_REQUEST['user_role']);
            $dmo->editValue("user","school",$user['id'],$school);
            $dmo->editValue("user","profile",$user['id'], $profile);
            $user = $dmo->userProfile($_SESSION['user']['userid']);
            header("location: ".$dmo->switch_role($user));
                
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['updateCompanyBasicInfo'])){
        try{
            $school_name = $dmo->cleanData($_REQUEST['school_name']);
            $address = $dmo->cleanData($_REQUEST['address']);
            $logo = !empty($_FILES['logo'])? $dmo->upload($_FILES['logo']) : ["status"=>FALSE,"message"=>"File not posted"];
            $dmo->editValue("school","school_name",$dmo->getSchInfo($user)['data']['id'], $school_name);
            $dmo->editValue("school","address",$dmo->getSchInfo($user)['data']['id'], $address);
            if($logo['status']){$dmo->editValue("school","logo",$dmo->getSchInfo($user)['data']['id'], $logo['path']);}
            $info = "Schoo Info Updated successfully";           
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnUpdateProfile'])){
        try{
            $displayname = $dmo->cleanData($_REQUEST['displayname']);
            $contact = $dmo->cleanData($_REQUEST['contact']);
            $email = $dmo->cleanData($_REQUEST['email']);

            if(isset($_FILES["profile"])){
                $response = $dmo->upload($_FILES['profile']);
                $profile = $response['status']? $response['path'] : $user['photo'];
            }
            try{
                $dmo->executeUpdate('user', ['displayname'=>$displayname, 'contact'=>$contact, 'email'=>$email, 'photo'=>$profile], ['id'=>$user['id']]);
                $info = "Profile updated successfully";
            } catch (Exception $e){
                $err = "An error occured: ".$e->getMessage();
            }
            
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnUpdatePassword'])){
        try{
            $old_password = $dmo->cleanData($_REQUEST['old_password']);
            $new_password = $dmo->cleanData($_REQUEST['new_password']);
            if(!password_verify($old_password, $user['password'])){ throw new Exception("Please enter a correct old password");}
            if(password_verify($new_password, $user['password'])){ throw new Exception("Password cannot be old password");}
            try {
                $result = $dmo->editValue("user", "password", $user['id'], password_hash($new_password, PASSWORD_DEFAULT));
                if($result){
                    header("location: request.php?tkn=".$dmo->storeRoute("user/signin.php")."&info=Password updated successfully. Please sign in to proceed");
                    $_SESSION['user'] = null;
                } else{ $info = 'We were not able update password'; }
            } catch (Exception $e) {
                $err = $e->getMessage();
            }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnSaveDimension'])){
        try{
            $dim_id = $dmo->generateUid();
            $dim_name = $dmo->cleanData($_REQUEST['dim_name']);
            $dim_description = $dmo->cleanData($_REQUEST['dim_description']);

            $stmt = "SELECT dim_id FROM dimension WHERE dim_id = ? OR dim_name = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$dim_id, $dim_name]);
            if($num_rows<1){
                if($dmo->executeInsert('dimension', ['dim_id'=>$dim_id, 'dim_name'=>$dim_name, 'dim_description'=>$dim_description])['status']){
                    $success = "$dim_name created successfully";
                } else { throw new Exception("Unable to create $dim_name"); }
            }else{ throw new Exception("$dim_name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSaveDimensionValue'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $dv_id = $dmo->generateUid();
            $dim_id = $dmo->cleanData($_REQUEST['dim_id']);
            $dv_name = $dmo->cleanData($_REQUEST['dv_name']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $rct_nos = $dmo->cleanData($_REQUEST['rct_nos']);
            $inv_nos = $dmo->cleanData($_REQUEST['inv_nos']);
            $incharge = $dmo->cleanData($_REQUEST['incharge']);
            $filter_name = $dmo->cleanData($_REQUEST['filter_name']);
    
            $stmt = "SELECT dv_code FROM dim_value WHERE dv_code = ? OR dv_name = ? AND dim_id = ? AND school = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$dv_id, $dv_name, $dim_id, $school]);
            if($num_rows<1){
                if($dmo->executeInsert('dim_value', ['school'=>$school, 'dim_id'=>$dim_id, 'dv_code'=>$dv_id, 'dv_name'=>$dv_name, 'description'=>$description, 'inv_nos'=>$inv_nos, 'rct_nos'=>$rct_nos, 'incharge'=>$incharge, 'filter_name'=>$filter_name])['status']){
                    $success = "$dv_name created successfully";
                } else {
                    throw new Exception("Unable to create $dv_name");
                }
            }else{ throw new Exception("$dv_name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSaveNoSeries'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $ns_code = $dmo->cleanData($_REQUEST['ns_code']);
            $ns_name = $dmo->cleanData($_REQUEST['ns_name']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $startno = $dmo->cleanData($_REQUEST['startno']);
            $endno = $dmo->cleanData($_REQUEST['endno']);
            $lastused = $dmo->cleanData($_REQUEST['lastused']);
            $canskip = $dmo->cleanData($_REQUEST['canskip']);
            $category = $dmo->cleanData($_REQUEST['category']);

            $stmt = "SELECT id FROM no_series WHERE ns_code = ? AND category = ? OR ns_name = ? AND school = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$ns_code, $category, $ns_name, $school]);
            if($num_rows<1){
                if($dmo->executeInsert('no_series', ['school'=>$school, 'ns_code'=>$ns_code, 'ns_name'=>$ns_name, 'description'=>$description, 'startno'=>$startno, 'endno'=>$endno, 'lastused'=>$lastused, 'canskip'=>$canskip, 'category'=>$category])){
                    $success = "$ns_name added successfully";
                }else{ throw new Exception("Unable to add $ns_name");}
            }else{ throw new Exception("$ns_name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewUser'])){
        try{
            $userid = $dmo->generateUid();
            $username = $dmo->cleanData($_REQUEST['username']);
            $password = $dmo->cleanData($_REQUEST['password']);
            $display_name = $dmo->cleanData($_REQUEST['display_name']);
            $role = $dmo->cleanData($_REQUEST['roll']);
            $email = $dmo->cleanData($_REQUEST['email']);
            $contact = $dmo->cleanData($_REQUEST['contact']);
            $profile = $_FILES['profile'];
            $tmp_profile_image = "upload/png/user-default-2-min.png";

            $stmt = "SELECT userid FROM user WHERE username = ? ";
            if($dmo->numRows(query: $stmt, params: [$username])){
                if($dmo->executeInsert('user', ['userid'=>$userid, 'username'=>$username, 'password'=>password_hash($password, PASSWORD_DEFAULT), 'displayname'=>$display_name, 'role'=>$role, 'email'=>$email, 'contact'=>$contact, 'photo'=>$tmp_profile_image, 'regdate'=>$dmo->todaysDate(), 'attempts'=>4, 'status'=>1])['status']){
                    $success = "Account created successfully";
                } else { throw new Exception("Unable to sign you up"); }
            }else{
                throw new Exception("A user with the supplied alias already exists.");
            }
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewSchool'])){
        try{
            $school_code = $dmo->cleanData($_REQUEST['school_code']);
            $school_name = $dmo->cleanData($_REQUEST['school_name']);
            $category = $dmo->cleanData($_REQUEST['category']);
            $mail = $dmo->cleanData($_REQUEST['mail']);
            $contact = $dmo->cleanData($_REQUEST['contact']);
            $logo = $_FILES['logo'];
            $tmp_school_logo = "upload/png/user-default-2-min.png";

            $stmt = "SELECT school_code FROM school WHERE school_code = ? OR school_code = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school_code, $school_name]);
            if($num_rows<1){
                $response = $dmo->upload($logo);
                if($response['status']){
                    if($dmo->executeInsert('school', ['school_code'=>$school_code, 'school_name'=>$school_name, 'category'=>$category, 'mail'=>$mail, 'contact'=>$contact, 'logo'=>$response['path']])['status']){
                        $success = "$school_name added successfully";
                    }else{throw new Exception("Unable to add $school_name");}
                } else {
                    throw new Exception($response['message']);
                }
            }else{ throw new Exception("$school_name already exists"); }
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewTerm'])){
        try{
            $term_code = $dmo->cleanData($_REQUEST['term_code']);
            $term_name = $dmo->cleanData($_REQUEST['term_name']);
            $opening_date = $dmo->cleanData($_REQUEST['opening_date']);
            $closing_date = $dmo->cleanData($_REQUEST['closing_date']);

            $stmt = "SELECT term_code FROM term WHERE term_code = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$term_code]);
            if($num_rows<1){
                if(strtotime($opening_date) >= strtotime($closing_date)){ throw new Exception("Opening date must be before closing date"); }

                if($dmo->executeInsert('term', ['term_code'=>$term_code, 'term_name'=>$term_name, 'opening_date'=>$opening_date, 'closing_date'=>$closing_date])['status']){
                    $success = "$term_name added successfully";
                } else {
                    throw new Exception("Unable to add $term_name");
                }
            }else{throw new Exception("$term_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewClass'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $classes = $dmo->cleanData($_REQUEST['class']);
            if(empty($classes)){ echo json_encode(["status"=>false, "message"=>"Please select at least one class from the template"]); return;}
            foreach($classes as $class){
                // Process each selected class
                if($dmo->executeInsert('school_class', ['school'=>$school, 'class'=>$class, 'is_offered'=>1])['status'] == false){
                    throw new Exception("Unable to add class: $class");
                }
            }
            echo json_encode(["status"=>true, "message"=>"Classes configured successfully"]);
        }catch(Exception $e){
            $err = $e->getMessage();
            echo json_encode(["status"=>false, "message"=>$err]);
        }
    }

    if(isset($_POST['btnNewStream'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user['school_code'];
            $class_code = $dmo->cleanData($_REQUEST['class_code']);
            $stream_code = $dmo->cleanData($_REQUEST['stream_code']);
            $stream_name = $dmo->cleanData($_REQUEST['stream_name']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $capacity = $dmo->cleanData($_REQUEST['capacity']);
            $class_teacher = $dmo->cleanData($_REQUEST['class_teacher']);

            $stmt = "SELECT stream_code FROM stream WHERE school = ? AND class = ? AND stream_name = ? OR stream_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $class_code, $stream_name, $stream_code]);
            if($num_rows<1){
                if($dmo->executeInsert('stream', ['school'=>$school, 'class'=>$class_code, 'stream_code'=>$stream_code, 'stream_name'=>$stream_name, 'description'=>$description, 'capacity'=>$capacity, 'class_teacher'=>$class_teacher])['status'] == true){
                    $success = "$stream_name added successfully";
                } else {
                    throw new Exception("Unable to add $stream_name");
                }
            }else{ throw new Exception("$stream_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewSubject'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $class = $dmo->cleanData($_REQUEST['class']);
            $subject_code = $dmo->cleanData($_REQUEST['subject_code']);
            $subject_name = $dmo->cleanData($_REQUEST['subject_name']);
            $group = $dmo->cleanData($_REQUEST['group']);
            $department = $dmo->cleanData($_REQUEST['department']);
            $category = $dmo->cleanData($_REQUEST['category']);

            $stmt = "SELECT id FROM subject WHERE school = ? AND class = ? AND subject_code = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $class, $subject_code]);
            if($num_rows<1){
                if($dmo->executeInsert('subject', ['school'=>$school, 'class'=>$class, 'subject_code'=>$subject_code, 'subject_name'=>$subject_name, 'group'=>$group, 'department'=>$department, 'category'=>$category])['status']){
                    $success = "$subject_name added successfully";
                } else {
                    throw new Exception("Unable to add $subject_name");
                }
            }else{ throw new Exception("$subject_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewStudent'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $adm_no = $dmo->cleanData($_REQUEST['adm_no']);
            $first_name = $dmo->cleanData($_REQUEST['first_name']);
            $surname = $dmo->cleanData($_REQUEST['surname']);
            $last_name = $dmo->cleanData($_REQUEST['last_name']);
            $gender = $dmo->cleanData($_REQUEST['gender']);
            $dob = $dmo->cleanData($_REQUEST['dob']);
            $doa = $dmo->cleanData($_REQUEST['doa']);
            $class = $dmo->cleanData($_REQUEST['class']);
            $stream = $dmo->cleanData($_REQUEST['stream']);
            $term = $dmo->cleanData($_REQUEST['term']);
            $year = $dmo->cleanData($_REQUEST['year']);

            $stmt = "SELECT adm_no FROM student WHERE school = ? AND adm_no = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $adm_no]);
            if($num_rows<1){
                if($dmo->executeInsert('student', ['school'=>$school, 'adm_no'=>$adm_no, 'first_name'=>$first_name, 'surname'=>$surname, 'last_name'=>$last_name, 'gender'=>$gender, 'dob'=>$dob, 'doa'=>$doa]) && $dmo->mapStudentToClass($school, $adm_no, $class, $stream, $term, $year)['status']){
                    $success = "$first_name $last_name added successfully";
                }else{ throw new Exception("Unable to add $first_name $last_name");}
            }else{ throw new Exception("$first_name $last_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewStaff'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $staff_code = $dmo->cleanData($_REQUEST['staff_code']);
            $first_name = $dmo->cleanData($_REQUEST['first_name']);
            $last_name = $dmo->cleanData($_REQUEST['last_name']);
            $gender = $dmo->cleanData($_REQUEST['gender']);
            $email = $dmo->cleanData($_REQUEST['email']);
            $phone = $dmo->cleanData($_REQUEST['phone']);
            $id_no = $dmo->cleanData($_REQUEST['id_no']);
            $job_title = $dmo->cleanData($_REQUEST['job_title']);
            $role = $dmo->cleanData($_REQUEST['role']);
            $hire_date = $dmo->cleanData($_REQUEST['hire_date']);
            $department = $dmo->cleanData($_REQUEST['department']);
            $emp_term = $dmo->cleanData($_REQUEST['emp_term']);

            $profile_picture = $_FILES['profile_picture'];
            $spp = $dmo->upload($profile_picture);
            $profile_picture = $spp['status'] == true? $spp['path'] : "upload/png/user-default-2-min.png";

            $stmt = "SELECT staff_code FROM staff WHERE email = ? OR phone = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$email, $phone]);
            if($num_rows<1){
                if($dmo->executeInsert('staff', [
                    'school' => $school,
                    'staff_code' => $staff_code,
                    'first_name' => $first_name,
                    'last_name' => $last_name,
                    'gender' => $gender,
                    'email' => $email,
                    'phone' => $phone,
                    'id_no' => $id_no,
                    'job_title' => $job_title,
                    'role' => $role,
                    'hire_date' => $hire_date,
                    'department' => $department,
                    'emp_term' => $emp_term,
                    'profile_picture' => $profile_picture
                ])['status']){
                    $success = "$first_name $last_name added successfully";
                }else{ throw new Exception("Unable to add $first_name $last_name");}
            }else{ throw new Exception("$first_name $last_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnUploadDocument'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $file_id = $dmo->cleanData($_REQUEST['file_id']);
            $staff = $dmo->cleanData($_REQUEST['staff']);
            $document_type = $dmo->cleanData($_REQUEST['document_type']);
            $document = $_FILES['file_path'];
            
            $stmt = "SELECT file_id FROM staff_file WHERE school = ? AND staff = ? AND document_type = ? OR file_id = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $staff, $document_type, $file_id]);
            $upload_response = $dmo->upload($document);
            if($upload_response['status'] == TRUE){
                $file_path = $upload_response['path'];
                if($num_rows<1){
                    if($dmo->executeInsert('staff_file', ['school'=>$school, 'file_id'=>$file_id, 'staff'=>$staff, 'document_type'=>$document_type, 'file_path'=>$file_path])['status']){
                        $success = "$document_type uploaded successfully";
                    } else { throw new Exception("Unable to upload $document_type"); }
                }else{ throw new Exception("$document_type already exists");}
            }else{ throw new Exception($upload_response['message']); }
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSaveJobCategory'])){
        try{
            $name = $dmo->cleanData($_REQUEST['name']);
            $description = $dmo->cleanData($_REQUEST['description']);

            $stmt = "SELECT id FROM job_category WHERE job_category.name = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$name]);
            if($num_rows<1){
                if($dmo->executeInsert('job_category', ['name'=>$name, 'description'=>$description])['status']){
                    $success = "$name created successfully";
                } else { throw new Exception("Unable to create $name"); }
            }else{ throw new Exception("$name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSaveJobLevel'])){
        try{
            $name = $dmo->cleanData($_REQUEST['name']);
            $description = $dmo->cleanData($_REQUEST['description']);

            $stmt = "SELECT id FROM job_level WHERE job_level.name = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$name]);
            if($num_rows<1){
                if($dmo->executeInsert('job_level', ['name'=>$name, 'description'=>$description])['status']){
                    $success = "$name created successfully";
                } else { throw new Exception("Unable to create $name"); }
            }else{ throw new Exception("$name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnSaveJobGroup'])){
        try{
            $name = $dmo->cleanData($_REQUEST['name']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $min_salary = $dmo->cleanData($_REQUEST['min_salary']);
            $max_salary = $dmo->cleanData($_REQUEST['max_salary']);

            $stmt = "SELECT id FROM job_group WHERE job_group.name = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$name]);
            if($num_rows<1){
                if($dmo->executeInsert('job_group', ['name'=>$name, 'description'=>$description, 'min_salary'=>$min_salary, 'max_salary'=>$max_salary])['status']){
                    $success = "$name created successfully";
                }else{ throw new Exception("Unable to create $name");}
            }else{ throw new Exception("$name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnSaveJobTitle'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $name = $dmo->cleanData($_REQUEST['name']);
            $category_id = $dmo->cleanData($_REQUEST['category_id']);
            $level_id = $dmo->cleanData($_REQUEST['level_id']);
            $group_id = $dmo->cleanData($_REQUEST['group_id']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $department = $dmo->cleanData($_REQUEST['department']);
            $status = $dmo->cleanData($_REQUEST['job_status']);

            $stmt = "SELECT id FROM job_title WHERE job_title.title = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$name]);
            if($num_rows<1){
                if($dmo->executeInsert('job_title', ['school'=>$school, 'title'=>$name, 'category_id'=>$category_id, 'level_id'=>$level_id, 'group_id'=>$group_id, 'description'=>$description, 'department'=>$department, 'status'=>$status])['status']){
                    $success = "$name created successfully";
                } else { throw new Exception("Unable to create $name"); }
            }else{ throw new Exception("$name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnSaveSkill'])){
        try{
            $name = $dmo->cleanData($_REQUEST['name']);
            $description = $dmo->cleanData($_REQUEST['description']);

            $stmt = "SELECT id FROM skill WHERE skill.name = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$name]);
            if($num_rows<1){
                if($dmo->executeInsert('skill', ['name'=>$name, 'description'=>$description])['status']){
                    $success = "$name created successfully";
                } else { throw new Exception("Unable to create $name"); }
            }else{ throw new Exception("$name already exists");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnSaveJobSkill'])){
        try{
            $job_title_id = $dmo->cleanData($_REQUEST['job_title_id']);
            $skill_id = $dmo->cleanData($_REQUEST['skill_id']);
            $school = $dmo->cleanData($user['school_code']);

            $stmt = "SELECT id FROM job_skill WHERE job_title_id = ? AND skill_id = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$job_title_id, $skill_id]);
            if($num_rows<1){
                if($dmo->executeInsert('job_skill', ['school'=>$school, 'job_title_id'=>$job_title_id, 'skill_id'=>$skill_id])['status']){
                    $success = "Skill mapped successfully";
                } else { throw new Exception("Unable to map skill"); }
            }else{ throw new Exception("Skill already mapped");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewJobPosting'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $department = $dmo->cleanData($_REQUEST['department']);
            $job_posting_code = $dmo->cleanData($_REQUEST['job_posting_code'])?? $dmo->cleanData($dmo->generateUid());
            $job_title = $dmo->cleanData($_REQUEST['job_title']);
            $vacant_posts = $dmo->cleanData($_REQUEST['vacant_posts']);
            $posting_date = $dmo->cleanData($_REQUEST['posting_date']);
            $closing_date = $dmo->cleanData($_REQUEST['closing_date']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $employment_type = $dmo->cleanData($_REQUEST['employment_type']);
            $location = $dmo->cleanData($_REQUEST['location']);
            $salary_range = $dmo->cleanData($_REQUEST['salary_range']);
            if($dmo->IsValidPeriod($posting_date, $closing_date) == false){
                throw new Exception("Invalid period selected");
            }
            $stmt = "SELECT id FROM job_posting WHERE school = ? AND department = ? AND job_title = ? AND status = ? OR job_posting_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $department, $job_title, 'new', $job_posting_code]);
            if($num_rows<1){
                if($dmo->executeInsert('job_posting', ["school"=>$school, "department"=>$department, "job_posting_code"=>$job_posting_code, "job_title"=>$job_title, "vacant_posts"=>$vacant_posts, "posting_date"=>$posting_date, "closing_date"=>$closing_date, "description"=>$description, "employment_type"=>$employment_type, "location"=>$location, "salary_range"=>$salary_range])['status']){
                    $success = "Job vacancy posted successfully";
                } else { throw new Exception("Unable to post job vacancy"); }
            }else{ throw new Exception("There already exists a new vacancy post for this job opening");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewBenefitType'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $benefit_type_code = $dmo->cleanData($_REQUEST['benefit_type_code'])?? $dmo->cleanData($dmo->generateUid());
            $benefit_type_name = $dmo->cleanData($_REQUEST['benefit_type_name']);
            $is_recurring = $dmo->cleanData($_REQUEST['is_recurring']);
            $recurring_type = $dmo->cleanData($_REQUEST['recurring_type']);
            $quantity = $dmo->cleanData($_REQUEST['quantity']);

            $stmt = "SELECT id FROM benefit_type WHERE school = ? AND benefit_type_name = ? OR benefit_type_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $benefit_type_name, $benefit_type_code]);
            if($num_rows<1){
                if($dmo->executeInsert('benefit_type', ['school'=>$school, 'benefit_type_code'=>$benefit_type_code, 'benefit_type_name'=>$benefit_type_name, 'is_recurring'=>$is_recurring, 'recurring_type'=>$recurring_type, 'quantity'=>$quantity])['status']){
                    $success = "Benefit type created successfully";
                } else { throw new Exception("Unable to create benefit type"); }
            }else{ throw new Exception("Benefit type already available");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewStaffBenefit'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $benefit_code = $dmo->cleanData($_REQUEST['benefit_code'])?? $dmo->cleanData($dmo->generateUid());
            $staff_code = $dmo->cleanData($_REQUEST['staff_code']);
            $benefit_type = $dmo->cleanData($_REQUEST['benefit_type']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $effective_date = $dmo->cleanData($_REQUEST['effective_date']);

            $stmt = "SELECT id FROM staff_benefit WHERE school = ? AND staff_code = ? AND benefit_type = ? OR benefit_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $staff_code, $benefit_type, $benefit_code]);
            if($num_rows<1){
                if($dmo->executeInsert('staff_benefit', ['school'=>$school, 'benefit_code'=>$benefit_code, 'staff_code'=>$staff_code, 'benefit_type'=>$benefit_type, 'description'=>$description, 'effective_date'=>$effective_date])['status']){
                    $success = "Staff benefit requested successfully, Awaiting Approval";
                } else { throw new Exception("Unable to request benefit"); }
            }else{ throw new Exception("Staff benefit already requested. Please track the status");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewTrainingProgram'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $program_code = $dmo->cleanData($_REQUEST['program_code'])?? $dmo->cleanData($dmo->generateUid());
            $program_name = $dmo->cleanData($_REQUEST['program_name']);
            $facilitator_name = $dmo->cleanData($_REQUEST['facilitator_name']);
            $start_date = $dmo->cleanData($_REQUEST['start_date']);
            $end_date = $dmo->cleanData($_REQUEST['end_date']);
            $comment = $dmo->cleanData($_REQUEST['comment']);

            if($dmo->IsValidPeriod($start_date, $end_date) == false){
                throw new Exception("Invalid period selected");
            }
            $stmt = "SELECT id FROM training_program WHERE school = ? OR program_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $program_code]);
            if($num_rows<1){
                if($dmo->executeInsert('training_program', ['school'=>$school, 'program_code'=>$program_code, 'program_name'=>$program_name, 'facilitator_name'=>$facilitator_name, 'start_date'=>$start_date, 'end_date'=>$end_date, 'comment'=>$comment])['status']){
                    $success = "Training program recorded successfully";
                } else { throw new Exception("Unable to record program"); }
            }else{ throw new Exception("Training program already recorded.");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewLeaveType'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $leave_type_code = $dmo->cleanData($_REQUEST['leave_type_code'])?? $dmo->cleanData($dmo->generateUid());
            $leave_type_name = $dmo->cleanData($_REQUEST['leave_type_name']);
            $applies_to = $dmo->cleanData($_REQUEST['applies_to']);
            $no_of_days_off = $dmo->cleanData($_REQUEST['no_of_days_off']);
            $maximum_leaves = $dmo->cleanData($_REQUEST['maximum_leaves']);

            $stmt = "SELECT id FROM leave_type WHERE school = ? AND leave_type_name = ? OR leave_type_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $leave_type_name, $leave_type_code]);
            if($num_rows<1){
                if($dmo->executeInsert('leave_type', ['school'=>$school, 'leave_type_code'=>$leave_type_code, 'leave_type_name'=>$leave_type_name, 'applies_to'=>$applies_to, 'no_of_days_off'=>$no_of_days_off, 'maximum_leaves'=>$maximum_leaves])['status']){
                    $success = "Leave type created successfully";
                }else{ throw new Exception("Unable to create leave type");}
            }else{ throw new Exception("Leave type already available");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewLeaveApplication'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school'])?? $user($user['school_code']);
            $leave_code = $dmo->cleanData($_REQUEST['leave_code'])?? $dmo->cleanData($dmo->generateUid());
            $staff_code = $dmo->cleanData($_REQUEST['staff_code']);
            $leave_type = $dmo->cleanData($_REQUEST['leave_type']);
            $start_date = $dmo->cleanData($_REQUEST['start_date']);
            $end_date = $dmo->cleanData($_REQUEST['end_date']);
            if($dmo->IsValidPeriod($start_date, $end_date) == false){
                throw new Exception("Invalid period selected");
            }
            $stmt = "SELECT id FROM leave_request WHERE school = ? AND leave_type = ? OR leave_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$school, $leave_type, $leave_code]);
            if($num_rows<1){
                if($dmo->hasOngoingLeave($staff_code)){
                    throw new Exception("You have an ongoing leave. Please track the status of your current leave application");
                }

                if($dmo->getLeaveBalance($staff_code, $leave_type) < 1){
                    throw new Exception("You have no leave days left for this leave type");
                }

                if(strtotime($start_date) < strtotime(date('Y-m-d'))){
                    throw new Exception("Start date cannot be in the past");
                }

                if(strtotime($start_date) > strtotime($end_date)){
                    throw new Exception("Start date cannot be after end date");
                }

                if($dmo->getLeaveDuration($start_date, $end_date) > $dmo->getLeaveBalance($staff_code, $leave_type)){
                    throw new Exception("You do not have enough leave days for the selected period");
                }

                if($dmo->hasOverlappingLeave($staff_code, $start_date, $end_date)){
                    throw new Exception("You have another leave application that overlaps with the selected period");
                }

                if($dmo->hasPendingLeaveApplication($staff_code)){
                    throw new Exception("You have a pending leave application. Please wait for it to be processed before submitting a new one");
                }

                if($dmo->hasLeaveConflictWithTraining($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a training program that conflicts with the selected leave period");
                }

                if($dmo->hasLeaveConflictWithJobPosting($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a job posting that conflicts with the selected leave period");
                }

                if($dmo->hasLeaveConflictWithBenefit($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a staff benefit that conflicts with the selected leave period");
                }

                if ($dmo->hasLeaveConflictWithTransfer($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a transfer request that conflicts with the selected leave period");
                }

                if($dmo->hasLeaveConflictWithPerformanceReview($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a performance review that conflicts with the selected leave period");
                }

                if($dmo->hasLeaveConflictWithDisciplinaryAction($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a disciplinary action that conflicts with the selected leave period");
                }

                if($dmo->hasLeaveConflictWithPayroll($staff_code, $start_date, $end_date)){
                    throw new Exception("You have a payroll process that conflicts with the selected leave period");
                }

                if($dmo->executeInsert('leave_request', ['school'=>$school, 'leave_code'=>$leave_code, 'staff_code'=>$staff_code, 'leave_type'=>$leave_type, 'start_date'=>$start_date, 'end_date'=>$end_date])['status']){
                    $success = "Leave application submitted successfully";
                } else { throw new Exception("Unable to submit your leave application"); }
            }else{ throw new Exception("You already have an ongoing leave");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnNewTransferApplication'])){
        try{
            $transfer_code = $dmo->cleanData($_REQUEST['transfer_code']);
            $transfer_from = $dmo->cleanData($_REQUEST['transfer_from']);
            $transfer_to = $dmo->cleanData($_REQUEST['transfer_to']);
            $date_requested = $dmo->cleanData($_REQUEST['date_requested']);
            $on_behalf_of = $dmo->cleanData($_REQUEST['on_behalf_of']);
            $effective_date = $dmo->cleanData($_REQUEST['effective_date']);
            $comment = $dmo->cleanData($_REQUEST['comment']);
            if($dmo->IsValidPeriod($date_requested, $effective_date) == false){
                throw new Exception("Invalid period selected");
            }
            $stmt = "SELECT id FROM staff_transfer_request WHERE transfer_from = ? AND transfer_to = ? OR transfer_code = ?";
            $num_rows = $dmo->numRows(query: $stmt, params: [$transfer_from, $transfer_to, $transfer_code]);
            if($num_rows<1){
                if($dmo->executeInsert('staff_transfer_request', ['transfer_code'=>$transfer_code, 'transfer_from'=>$transfer_from, 'transfer_to'=>$transfer_to, 'date_requested'=>$date_requested, 'requested_by'=>$user['userid'], 'on_behalf_of'=>$on_behalf_of, 'effective_date'=>$effective_date, 'approval_status'=>'New', 'approved_by'=>"", 'rejected_by'=>"", 'comment'=>$comment, 'reason'=>""])){
                    $success = "Transfer requested successfully";
                }else{ throw new Exception("Unable to request transfer");}
            }else{ throw new Exception("Transfer request already available");}
        } catch (Exception $e) {
            $err = $e->getMessage();
        }    
    }

    if(isset($_POST['btnBackupDatabase'])){
        try{
            $format = $dmo->cleanData($_REQUEST['format']) ?? 'sql';
            $dmo->export($format);
        } catch (Exception $e) {
            $err = $e->getMessage();
        } 
    }
}
?>