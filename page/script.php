<script src="asset/js/vendor.min.js"></script>
<script src="asset/libs/jquery-ui.min.js"></script>
<script src="asset/libs/jquery-validation/jquery.validate.min.js"></script>
<script src="asset/libs/jquery-validation/additional-methods.min.js"></script>
<script src="asset/libs/datatables/jquery.dataTables.min.js"></script>
<script src="asset/libs/datatables/dataTables.bootstrap4.js"></script>
<script src="asset/libs/datatables/dataTables.responsive.min.js"></script>
<script src="asset/libs/datatables/responsive.bootstrap4.min.js"></script>
<script src="asset/libs/datatables/dataTables.buttons.min.js"></script>
<script src="asset/libs/datatables/buttons.bootstrap4.min.js"></script>
<script src="asset/libs/datatables/buttons.html5.min.js"></script>
<script src="asset/libs/datatables/buttons.print.min.js"></script>
<script src="asset/libs/datatables/buttons.colVis.min.js"></script>
<script src="asset/libs/jszip/jszip.min.js"></script>
<script src="asset/libs/pdfmake/pdfmake.min.js"></script>
<script src="asset/libs/pdfmake/vfs_fonts.js"></script>
<script src="asset/libs/select2/js/select2.full.min.js"></script>
<!-- cryptoJs -->
<script src="asset/libs/crypto-js/core.js"></script>
<script src="asset/libs/crypto-js/cipher-core.js"></script>
<script src="asset/libs/crypto-js/aes.js"></script>
<script src="asset/libs/crypto-js/enc-base64.js"></script>

<!-- libsodium -->
<script src="asset/libs/sodium.js"></script>
<script src="asset/js/app.min.js"></script>

<script>
$(function(){
  $('.select2').select2()
  $('.select2bs4').select2({
    theme: 'bootstrap4'
  })
})

function showModal(modalID){
  $(modalID).modal({backdrop: 'static', keyboard: false, display: true});
  
  $(modalID).on('shown.bs.modal', function(){
      $(this).find('select.select2').each(function(){
          $(this).select2({
              dropdownParent: $(this).parent(),
              placeholder: '--select--',
              allowClear: true,
              width: '100%'
          });
      });

      $(this).on('scroll', function(){
          $('.select2-container--open').each(function(){
              let select = $(this).prev('select');
              select.select2('close').select2('open');
          });
      });
  });

  $(modalID).on('hidden.bs.modal', function(){
      $(this).find('select.select2').each(function(){
          $(this).select2('destroy');
      });
  });
}
function hideModal(modalID){
  $(modalID).modal("hide");
}

function errorResponse(message){
  $("#response").html('<div class="alert alert-danger alert-dismissible"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><h5><i class="icon fas fa-ban"></i> Error!</h5>'+message+'</div>') 
}

function successResponse(message){
  $("#response").html('<div class="alert alert-success alert-dismissible"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><h5><i class="icon fas fa-check"></i> Success!</h5>'+message+'</div>')
}

function infoResponse(message){
  $("#response").html('<div class="alert alert-info alert-dismissible"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><h5><i class="icon fas fa-info"></i> Info!</h5>'+message+'</div>')
}

function warningResponse(message){
  $("#response").html('<div class="alert alert-warning alert-dismissible"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>'+message+'</div>')
}

function showAlert(alertType, icon, title, elementID, message){
  document.querySelector(elementID).innerHTML = "<div class='alert alert-"+alertType+" alert-dismissible'><button type='button' class='close'data-dismiss='alert' aria-hidden='true'>&times;</button><h6><i class='icon fas fa-"+icon+"'></i> "+title+"</h6>"+message+"</div>"
}
function loadIframe(id, title, src){
  document.querySelector("#DocTitle").innerText = title;
  $(id).html('<iframe src="'+src+'" width="100%" height="500px" style="border: 2px solid darkcyan"></iframe>')
}
window.encodedLockPage = "<?= $dmo->storeRoute("user/lockscreen.php"); ?>";
window.encodedLogoutPage = "<?= $dmo->storeRoute("user/signin.php"); ?>";
</script>
<script src="asset/js/timer.js"></script>