<?php require "page/siteheader.php"; ?>
<div class="row">
  <div class="col-md-2"></div>
  <div class="col-md-8">
    <h3 class="text-darkcyan">Current Openings</h3>
    <?php if (isset($_GET['vn'])): ?>
      <div class="card p-2">
        <h5 class="text-darkcyan">Apply for vacancy no. <?= $_GET['vn']; ?></h5>
        <form id="frmApplyForJob" autocomplete="off" method="post" enctype="multipart/form-data">
          <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
          <input type="hidden" name="job_posting_code" value="<?php echo $_GET['vn']; ?>">
          <div class="form-group">
            <label for="applicant_code">National ID Number</label>
            <input type="number" name="applicant_code" class="form-control" placeholder="e.g. 39489473">
          </div>
          <div class="form-group">
            <label for="applicant_name">Full Name</label>
            <input type="text" name="applicant_name" class="form-control" placeholder="e.g. Musee Makwa Abiud">
          </div>
          <div class="form-group">
            <label for="contact_phone">Contact Phone Number</label>
            <input type="number" name="contact_phone" class="form-control" placeholder="e.g. 0741915943">
          </div>
          <div class="form-group">
            <label for="contact_email">Contact Email Address</label>
            <input type="email" name="contact_email" class="form-control" placeholder="e.g. museeabiud70@gmail.com">
          </div>
          <div class="form-group">
              <label for="resume">Attach Resume:</label>
              <input type="file" name="resume" accept="application/pdf" class="form-control" id="resume">
          </div>
          <div class="form-group">
              <label for="cover_letter">Attach Cover Letter</label>
              <input type="file" name="cover_letter" accept="application/pdf" class="form-control" id="cover_letter">
          </div>
          <button type="submit" class="btn btn-darkcyan text-white float-right" name="btnApplyForJob">Submit Application</button>
      </form>
      </div>
    <?php endif; ?>
    <?php
      if($dmo->getJobPostings(["jp.status"=>"new"])['status']){
        echo '<div class="card p-1 mb-1">';
        $response = $dmo->getJobPostings(["jp.status"=>"new"]);
        foreach ($response['data'] as $job) { $id = $dmo->safeData($job['id']);
            echo "<div class='border p-1 mb-1'>
            <strong class='text-muted'>School Name:</strong> {$job['school_name']}<br>
            <strong class='text-muted'>Department:</strong> {$job['dept_name']}<br>
            <strong class='text-muted'>Job Title:</strong> {$job['job_title']} ({$job['vacant_posts']}) posts<br>
            <strong class='text-muted'>Description:</strong> {$job['description']}<br>
            <strong class='text-muted'>Terms:</strong> {$job['employment_type']} Job<br>
            <strong class='text-muted'>Location:</strong> {$job['location']}<br>
            <strong class='text-muted'>Salary Range:</strong> {$job['salary_range']}<br>
            <strong class='text-muted'>Posted On:</strong> {$job['posting_date']}<br>
            <strong class='text-muted'>Deadline:</strong> {$job['closing_date']} <a href='request.php?tkn=".$dmo->storeRoute("website/careers.php")."&vn={$job['job_posting_code']}' class='btn btn-sm btn-darkcyan text-white float-end'>Apply</a></div>";
        }
        echo "</div>";
      }else{
        echo '<strong class="text-muted">There is no job openning yet</strong>';
      }
    ?>
  </div>
  <div class="col-md-2"></div>
</div>
<?php require "page/sitefooter.php"; ?>