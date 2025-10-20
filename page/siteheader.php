<?php require "user/user_controller.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EduCore360</title>
  <?php require "page/header.php";?>
  <link rel="stylesheet" href="asset/css/style.css" rel="stylesheet">
</head>
<body class="authentication-bg authentication-bg-pattern" style="margin: auto;">
  <header class="bg-darkcyan text-white p-1">
    <div class="container d-flex justify-content-between align-items-center">
      <h3 class="text-white">EduCore360</h3>
      <nav>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/index.php");?>" class="nav-link d-inline text-white">Home</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/about.php");?>" class="nav-link d-inline text-white">About</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/admissions.php");?>" class="nav-link d-inline text-white">Admissions</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/careers.php");?>" class="nav-link d-inline text-white">Careers</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/news.php");?>" class="nav-link d-inline text-white">News</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="btn btn-light btn-sm">Login</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signup.php");?>" class="btn btn-light btn-sm">Register</a>
      </nav>
    </div>
  </header>
  <main class="container my-4"></main>