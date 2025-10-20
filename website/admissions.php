<?php require "page/siteheader.php"; ?>
<h3 class="text-darkcyan">Admissions</h3>
<div class="card p-3 mb-3">
  <h5>Requirements & Deadlines</h5>
  <p>Submit your application before March 31, 2025. Attach KCPE results, ID, and testimonials.</p>
</div>

<div class="row">
  <div class="col-md-6">
    <div class="card p-3">
      <h5 class="text-darkcyan">Apply Online</h5>
      <form id="frmApplyForAdmission" method="post" enctype="multipart/form-data">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
        <input type="text" name="name" class="form-control mb-2" placeholder="Full Name" required>
        <input type="email" name="email" class="form-control mb-2" placeholder="Email" required>
        <input type="text" name="dob" class="form-control mb-2" placeholder="Date of Birth" required>
        <input type="file" name="docs" class="form-control mb-2">
        <button type="submit" class="btn btn-darkcyan text-white" name="btnApplyForAdmission">Submit Application</button>
      </form>
    </div>
  </div>
  <div class="col-md-6">
    <div class="card p-3">
      <h5 class="text-darkcyan">Track Application</h5>
      <form id="frmTrackApplication" method="get">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
        <input type="hidden" name="action" value="track_admission">
        <input type="text" name="application_id" class="form-control mb-2" placeholder="Application ID">
        <button type="submit" class="btn btn-outline-darkcyan" name="btnTrackApplication">Check Status</button>
      </form>
    </div>
  </div>
</div>
<?php require "page/sitefooter.php"; ?>