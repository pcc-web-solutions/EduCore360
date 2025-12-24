<?php
require_once "server.php";

$dmo->check_login();
$dmo->manageSessionTimeout(false);
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
            $sql = "UPDATE user SET attempts = ? WHERE userid = ? ";
			$dmo->executeUpdate(query: $sql, params: [4, $user['userid']]);
            unset($_SESSION['locked']);
            $_SESSION['last_activity'] = time();
            $loginstatus = $dmo->login(user: $user);
            $dmo->reportLogin(userid: $user['userid']);
            header(header: "location: ".$loginstatus." ");
		}else{
			$attempts--;
            $sql = "UPDATE user SET attempts = ? WHERE userid = ?";
			$dmo->executeUpdate(query: $sql, params: [$attempts, $user['userid']]);
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
                $stmt = "UPDATE user SET displayname = ?, contact = ?, email = ?, photo = ? WHERE id = ? ";
                $result = $dmo->executeUpdate(query: $stmt, params: [$displayname, $contact, $email, $profile, $user['id']]);
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
                $stmt = "INSERT INTO dimension (dim_id, dim_name, dim_description) VALUES (?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$dim_id, $dim_name, $dim_description])){
                    $success = "$dim_name created successfully";
                }else{ throw new Exception("Unable to create $dim_name");}
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
                $stmt = "INSERT INTO dim_value (school, dim_id, dv_code, dv_name, description, inv_nos, rct_nos, incharge, filter_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $dim_id, $dv_id, $dv_name, $description, $inv_nos, $rct_nos, $incharge, $filter_name])){
                    $success = "$dv_name created successfully";
                }else{ throw new Exception("Unable to create $dv_name");}
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
                $stmt = "INSERT INTO no_series (school, ns_code, ns_name, description, startno, endno, lastused, canskip, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $ns_code, $ns_name, $description, $startno, $endno, $lastused, $canskip, $category])){
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
                $stmt = "INSERT INTO user (userid, username, password, displayname, role, email, contact, photo, regdate, attempts, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                $last_insert_id = $dmo->executeInsert(query: $stmt, params: [$userid, $username, $password, $display_name, $role, $email, $contact, $tmp_profile_image, $dmo->todaysDate(), 4, 1]);
                if($last_insert_id){
                    $success = "Account created successfully";
                }else{throw new Exception("Unable to sign you up");}
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
                    $stmt = "INSERT INTO school (school_code, school_name, category, mail, contact, logo) VALUES (?, ?, ?, ?, ?, ?) ";
                    if($dmo->executeInsert(query: $stmt, params: [$school_code,$school_name,$category,$mail,$contact,$response['path']])){
                        $success = "$school_name added successfully";
                    }else{throw new Exception("Unable to add $school_name");}
                } else {
                    throw new Exception($response['message']);
                }
            }else{ throw new Exception("$school_name already exists");}
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
                $stmt = "INSERT INTO term (term_code, term_name, opening_date, closing_date) VALUES (?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$term_code,$term_name,$opening_date, $closing_date])){
                    $success = "$term_name added successfully";
                }else{throw new Exception("Unable to add $term_name");}
            }else{throw new Exception("$term_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewClass'])){
        try{
            $school = $dmo->cleanData($_REQUEST['school']);
            $class_code = $dmo->cleanData($_REQUEST['class_code']);
            $class_name = $dmo->cleanData($_REQUEST['class_name']);
            $class_number = $dmo->cleanData($_REQUEST['class_number']);

            $stmt = "SELECT class_code FROM class WHERE class_code = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$class_code]);
            if($num_rows<1){
                $stmt = "INSERT INTO class (school, class_code, class_name, class_number) VALUES (?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school,$class_code,$class_name, $class_number])){
                    $success = "$class_name added successfully";
                }else{ throw new Exception("Unable to add $class_name");}
            }else{ throw new Exception("$class_name already exists");}
        }catch(Exception $e){
            $err = $e->getMessage();
        }
    }

    if(isset($_POST['btnNewStream'])){
        try{
            $class_code = $dmo->cleanData($_REQUEST['class_code']);
            $stream_code = $dmo->cleanData($_REQUEST['stream_code']);
            $stream_name = $dmo->cleanData($_REQUEST['stream_name']);
            $description = $dmo->cleanData($_REQUEST['description']);
            $capacity = $dmo->cleanData($_REQUEST['capacity']);
            $class_teacher = $dmo->cleanData($_REQUEST['class_teacher']);

            $stmt = "SELECT stream_code FROM stream WHERE class = ? AND stream_code = ? ";
            $num_rows = $dmo->numRows(query: $stmt, params: [$class_code, $stream_code]);
            if($num_rows<1){
                $stmt = "INSERT INTO stream (class, stream_code, stream_name, description, capacity, class_teacher) VALUES (?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$class_code,$stream_code,$stream_name,$description,$capacity,$class_teacher])){
                    $success = "$stream_name added successfully";
                }else{ throw new Exception("Unable to add $stream_name");}
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
                $stmt = "INSERT INTO subject (school, class, subject_code, subject_name, `group`, department, category) VALUES (?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school,$class,$subject_code,$subject_name,$group,$department,$category])){
                    $success = "$subject_name added successfully";
                }else{ throw new Exception("Unable to add $subject_name");}
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
                $stmt = "INSERT INTO student (school, adm_no, first_name, surname, last_name, gender, dob, doa) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school,$adm_no,$first_name,$surname,$last_name,$gender,$dob,$doa]) && $dmo->mapStudentToClass($school, $adm_no, $class, $stream, $term, $year)['status']){
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
                $stmt = "INSERT INTO staff (school, staff_code, first_name, last_name, gender, email, phone, id_no, job_title, role, hire_date, department, emp_term, profile_picture) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school,$staff_code,$first_name,$last_name,$gender,$email,$phone,$id_no,$job_title,$role,$hire_date,$department,$emp_term,$profile_picture])){
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
                    $stmt = "INSERT INTO staff_file (school, file_id, staff, document_type, file_path) VALUES (?, ?, ?, ?, ?) ";
                    if($dmo->executeInsert(query: $stmt, params: [$school,$file_id,$staff,$document_type,$file_path])){
                        $success = "$document_type uploaded successfully";
                    }else{ throw new Exception("Unable to upload $document_type");}
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
                $stmt = "INSERT INTO job_category (name, description) VALUES (?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$name, $description])){
                    $success = "$name created successfully";
                }else{ throw new Exception("Unable to create $name");}
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
                $stmt = "INSERT INTO job_level (name, description) VALUES (?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$name, $description])){
                    $success = "$name created successfully";
                }else{ throw new Exception("Unable to create $name");}
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
                $stmt = "INSERT INTO job_group (name, description, min_salary, max_salary) VALUES (?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$name, $description, $min_salary, $max_salary])){
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
                $stmt = "INSERT INTO job_title (school, title, category_id, level_id, group_id, description, department, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $name, $category_id, $level_id, $group_id, $description, $department, $status])){
                    $success = "$name created successfully";
                }else{ throw new Exception("Unable to create $name");}
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
                $stmt = "INSERT INTO skill (name, description) VALUES (?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$name, $description])){
                    $success = "$name created successfully";
                }else{ throw new Exception("Unable to create $name");}
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
                $stmt = "INSERT INTO job_skill (school, job_title_id, skill_id) VALUES (?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $job_title_id, $skill_id])){
                    $success = "Skill mapped successfully";
                }else{ throw new Exception("Unable to map skill");}
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
                $stmt = "INSERT INTO job_posting (school, department, job_posting_code, job_title, vacant_posts, posting_date, closing_date, description, employment_type, location, salary_range) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $department, $job_posting_code, $job_title, $vacant_posts, $posting_date, $closing_date, $description, $employment_type, $location, $salary_range])){
                    $success = "Job vacancy posted successfully";
                }else{ throw new Exception("Unable to post job vacancy");}
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
                $stmt = "INSERT INTO benefit_type (school, benefit_type_code, benefit_type_name, is_recurring, recurring_type, quantity) VALUES (?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $benefit_type_code, $benefit_type_name, $is_recurring, $recurring_type, $quantity])){
                    $success = "Benefit type created successfully";
                }else{ throw new Exception("Unable to create benefit type");}
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
                $stmt = "INSERT INTO staff_benefit (school, benefit_code, staff_code, benefit_type, description, effective_date) VALUES (?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $benefit_code, $staff_code, $benefit_type, $description, $effective_date])){
                    $success = "Staff benefit requested successfully, Awaiting Approval";
                }else{ throw new Exception("Unable to request benefit");}
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
                $stmt = "INSERT INTO training_program (school, program_code, program_name, facilitator_name, start_date, end_date, comment) VALUES (?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $program_code, $program_name, $facilitator_name, $start_date, $end_date, $comment])){
                    $success = "Training program recorded successfully";
                }else{ throw new Exception("Unable to record program");}
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
                $stmt = "INSERT INTO leave_type (school, leave_type_code, leave_type_name, applies_to, no_of_days_off, maximum_leaves) VALUES (?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $leave_type_code, $leave_type_name, $applies_to, $no_of_days_off, $maximum_leaves])){
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
                $stmt = "INSERT INTO leave_request (school, leave_code, staff_code, leave_type, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$school, $leave_code, $staff_code, $leave_type, $start_date, $end_date])){
                    $success = "Leave application submitted successfully";
                }else{ throw new Exception("Unable to submit your leave application");}
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
                $stmt = "INSERT INTO staff_transfer_request (transfer_code, transfer_from, transfer_to, date_requested, requested_by, on_behalf_of, effective_date, approval_status, approved_by, rejected_by, comment, reason) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
                if($dmo->executeInsert(query: $stmt, params: [$transfer_code, $transfer_from, $transfer_to, $date_requested, $user['userid'], $on_behalf_of, $effective_date, 'New', "", "", $comment, ""])){
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