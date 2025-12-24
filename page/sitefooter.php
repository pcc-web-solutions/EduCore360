  </main>
  <footer class="footer text-center">
    <p style="padding: 1; margin: 0;">&copy; <?php echo date("Y"); ?> EduCore360. All Rights Reserved.</p>
    <p style="padding: 1; margin: 0;">Powered By: <strong>Paramount Communication Centre</strong></p>
  </footer>
  <script src="asset/js/vendor.min.js"></script>
  <script src="asset/libs/jquery-validation/jquery.validate.min.js"></script>
  <script src="asset/libs/jquery-validation/additional-methods.min.js"></script>
  <script src="asset/libs/select2/js/select2.full.min.js"></script>

  <!-- cryptoJs -->
  <script src="asset/libs/crypto-js/core.js"></script>
  <script src="asset/libs/crypto-js/cipher-core.js"></script>
  <script src="asset/libs/crypto-js/aes.js"></script>
  <script src="asset/libs/crypto-js/enc-base64.js"></script>

  <!-- libsodium -->
  <script src="asset/libs/sodium.js"></script>
  <script src="asset/js/app.min.js"></script>
  <script src="asset/js/dms.js"></script>
  <script type="text/javascript">
    $(document).ready(function(){
      $("button[name='btnApplyForJob']").on("click", function(){
            ApplyForJob();
      })
    })
  </script> 
</body>
</html>