<?php require "page/siteheader.php"; ?>
<h3 class="text-darkcyan">News & Announcements</h3>
<div class="row">
  <?php
    if($dmo->getNews([])['status']){
      $response = $dmo->getNews([]);
      foreach ($response['data'] as $n) { $id = $dmo->safeData($row['id']);
        echo "<div class='col-md-6'><div class='card p-3 mb-3'><h5>{$n['title']}</h5><p>{$n['content']}</p><small class='text-muted'>{$n['created_at']}</small></div></div>";
      }
    }else{
      // echo "<div class='col-md-6'><div class='card p-3 mb-3'><h5></h5><p>No news posted at the moment</p><small class='text-muted'></small></div></div>";
    }

  ?>
</div>
<?php require "page/sitefooter.php"; ?>