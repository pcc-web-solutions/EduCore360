<?php require "page/siteheader.php"; ?>
<div class="row">
  <div class="col-md-8">
    <div class="card mb-3">
      <div class="card-body">
        <h3 class="text-darkcyan">Welcome to EduCore360</h3>
        <p>A Smarter Way to Manage Schools. Admissions, HR, Finance, Exams — all in one MIS platform.</p>
      </div>
    </div>
    <div class="card mb-3">
      <div class="card-body">
        <h5 class="text-darkcyan">Latest News</h5>
        <ul>
          <li>Admissions 2025 now open</li>
          <li>Teacher recruitment drive ongoing</li>
        </ul>
      </div>
    </div>
  </div>
  <div class="col-md-4">
    <div class="card text-center mb-3">
      <div class="card-body">
        <h5 class="text-darkcyan">Quick Links</h5>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/admissions.php");?>" class="btn btn-darkcyan text-white w-100 mb-2">Apply for Admission</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("website/careers.php");?>" class="btn btn-darkcyan text-white w-100 mb-2">Apply for a Job</a>
        <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>" class="btn btn-outline-darkcyan w-100">Portal Login</a>
      </div>
    </div>
  </div>
</div>
<?php require "page/sitefooter.php"; ?>