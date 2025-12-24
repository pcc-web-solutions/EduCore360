<?php
include "config.php";

$action = $_REQUEST['action'] ?? '';

switch ($action) {
  case "apply_admission":
    $stmt = $pdo->prepare("INSERT INTO admissions_applications (name,email,dob,docs) VALUES (?,?,?,?)");
    $stmt->execute([$_POST['name'], $_POST['email'], $_POST['dob'], $_FILES['docs']['name']]);
    move_uploaded_file($_FILES['docs']['tmp_name'], "upload/" . $_FILES['docs']['name']);
    jsonResponse("success", "Admission application submitted.");
    break;

  case "track_admission":
    $stmt = $pdo->prepare("SELECT status FROM admissions_applications WHERE id=?");
    $stmt->execute([$_GET['application_id']]);
    $status = $stmt->fetchColumn();
    jsonResponse("success", "Application Status", ["status" => $status ?: "Not found"]);
    break;

  case "apply_job":
    $stmt = $pdo->prepare("INSERT INTO job_applications (job_id,name,email,cv) VALUES (?,?,?,?)");
    $stmt->execute([$_POST['job_id'], $_POST['name'], $_POST['email'], $_FILES['cv']['name']]);
    move_uploaded_file($_FILES['cv']['tmp_name'], "upload/" . $_FILES['cv']['name']);
    jsonResponse("success", "Job application submitted.");
    break;

  case "login":
    jsonResponse("success", "Login successful (hook into MIS auth here).");
    break;

  default:
    jsonResponse("error", "Invalid action.");
}