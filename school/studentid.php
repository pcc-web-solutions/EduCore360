<?php require_once __DIR__."/uac.php"; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>School || Student IDs</title>
    <?php require "page/header.php";?>
    <style>
        .student-photo:hover {
            opacity: 0.7;
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <?php require __DIR__."/nav.php";?>
        <?php require __DIR__."/sidebar.php";?>
        <div class="content-page">
            <div class="content">
                <div class="container-fluid">
                    <div class="modal fade" id="mdlStudentID" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg" style="margin: 3px auto;">
                            <div class="modal-content">
                                <div class="modal-header bg-info">
                                    <h4 class="modal-title text-white">Student Identity Cards</h4>
                                    <span class="card-tools"><a href="#" data-dismiss="modal" class="text-white"><i class="fa fa-times"></i></a></span>
                                </div>
                                <div class="modal-body p-0 mb-0 mt-0">
                                    <div id="pdfreport"></div> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <div class="page-title-right">
                                    <ol class="breadcrumb m-0">
                                        <li class="breadcrumb-item"><a href="javascript: void(0);">Generate</a></li>
                                        <li class="breadcrumb-item active">Student IDs</li>
                                    </ol>
                                </div>
                                <h4 class="page-title">Generate Student IDs</h4>
                            </div>
                        </div>
                    </div>
                    <div class="card-box">
                        <form id="frmStudentIDs" autocomplete="off" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                            <div class="row">
                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <div class="form-group">
                                        <label for="filter">Filter By:</label>
                                        <select name="filter" class="form-control select2" id="filter">
                                            <option value="all">--select--</option>
                                            <option value="class">Class</option>
                                            <option value="stream">Stream</option>
                                            <option value="individual">Student</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-xs-6" id="key_option">
                                    <div class="form-group">
                                        <label for="key_value">For All:</label>
                                        <input type="text" name="option_value" class="form-control " id="option_value" value="All" readonly>
                                    </div>
                                </div>
                                <div class="col-xl-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                    <div class="form-group">
                                        <label for="action">Action:</label>
                                        <button type="submit" class="form-control btn-sm btn-info btn-flat float-right" name="btnFetchSIDData"><i class="fas fa-refresh"></i>&nbspGet Students</button> 
                                    </div>
                                </div>
                            </div>
                        </form>
                        <hr style="margin: 3px auto; border: 1px solid darkcyan">
                        <form id="frmStudentIDType" autocomplete="off" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($dmo->generateCsrfToken()); ?>">
                            <input type="hidden" name="school" class="form-control " id="school" value="<?= $user['school_code'] ?>" readonly>
                            <div class="form-group" style="margin: 3px auto;">
                                <input type="text" class="form-control form-control-sm border-width-1 search" onkeyup="search_table('#tblclasses')" placeholder="Type in here ...">
                            </div>
                            <hr style="margin: 3px auto; border: 1px solid darkcyan">
                            <div class="table-responsive">
                                <table id="tblstudent" class="table-bordered table-head-fixed table-striped text-nowrap" style="width: 100%">
                                    <thead>
                                        <tr style="height: 40px;">
                                            <th>Photo</th>
                                            <th>Adm. No</th>
                                            <th>First Name</th>
                                            <th>SurName</th>
                                            <th>Last Name</th>
                                            <th>Gender</th>
                                            <th>Date of Birth</th>
                                            <th>Admitted On</th>
                                            <th>Admitted In</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tblstudent_data"></tbody>
                                </table>
                            </div>
                            <hr style="margin: 3px auto; border: 1px solid darkcyan">
                            <div class="row" style="padding: 0px auto">
                                <div class="col-xl-8 col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                    <div class="form-group">
                                        <select name="id_layout"  class="form-control" id="id_layout">
                                            <option value="">--Select Layout (Single / A4 Grid)--</option>
                                            <option value="single">Single ID Per Page</option>
                                            <option value="multiple">10 IDs on A4 Page</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <button type="submit" class="btn btn-info btn-block" name="btnGenerateIDs" ><i class="fas fa-cog"></i>&nbspGenerate</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <?php require "page/footer.php"; ?>
        </div>
    </div>
<div class="rightbar-overlay"></div>

<?php require "page/script.php"; ?>
<script type="text/javascript" src="asset/js/dms.js"></script>
<script type="text/javascript">
$(document).ready(function(){
    var frmStudentIDs = $('#frmStudentIDs');
    var frmStudentIDType = $('#frmStudentIDType');

    frmStudentIDs.validate({
        rules: {
            filter: { required: true },
            class1: {
                required: function () {
                    return $("#filter").val() === "class" || $("#filter").val() === "stream";
                }
            },
            class2: {
                required: function () {
                    return $("#filter").val() === "stream";
                }
            },
            stream: {
                required: function () {
                    return $("#filter").val() === "stream";
                }
            },
            adm_no: {
                required: function () {
                    return $("#filter").val() === "individual";
                },
                maxlength: 20
            }
        },

        messages: {
            filter: { required: "Please select a filter" },
            class1: { required: "Please select class" },
            class2: { required: "Please select class" },
            stream: { required: "Please select stream" },
            adm_no: { 
                required: "Please enter admission number", 
                maxlength: "Admission Number too long" 
            }
        },

        errorPlacement: function(error, element) {
            error.addClass('invalid-feedback');
            element.closest('.form-group').append(error);
        },

        highlight: function(element) {
            $(element).addClass('is-invalid');
        },

        unhighlight: function(element) {
            $(element).removeClass('is-invalid');
        },

        submitHandler: function(frmStudentIDs) {
            var filter = $("#filter").val();
            var school = $("#school").val();
            var class1 = $("select[name='class1']").val();
            var class2 = $("select[name='class2']").val();
            var stream = $("select[name='stream']").val();
            var adm_no = $("input[name='adm_no']").val();

            var data = { 
                request: "students", 
                filter: filter, 
                school: school 
            };

            if (filter === "class") {
                data.class1 = class1;

            } else if (filter === "stream") {
                data.class1 = class1;
                data.class2 = class2;
                data.stream = stream;

            } else if (filter === "individual") {
                data.adm_no = adm_no;
            }

            $.ajax({
                url: "fetch.php",
                method: 'POST',
                data: data,
                dataType: 'json',

                success: function(response) {
                    $("#tblstudent_data").empty();
                    if (response.status === true) {
                        var rows = '';
                        response.data.forEach(function(item) {
                            rows += `
                                <tr>
                                    <td>
                                        <img src="${item.profile_picture}" 
                                            class="student-photo" 
                                            data-id="${item.id}" 
                                            style="width:40px;height:40px;border-radius:10%;cursor:pointer;">
                                        
                                        <input type="file" 
                                            class="upload_photo d-none" 
                                            data-id="${item.id}">
                                    </td>
                                    <td>${item.adm_no}</td>
                                    <td>${item.first_name}</td>
                                    <td>${item.surname}</td>
                                    <td>${item.last_name}</td>
                                    <td>${item.gender}</td>
                                    <td>${item.dob}</td>
                                    <td>${item.doa}</td>
                                    <td>${item.class} ${item.stream}</td>
                                </tr>`;
                        });
                        $("#tblstudent_data").html(rows);
                    } else {
                        $("#tblstudent_data").html(
                            `<tr><td colspan="9">${response.message}</td></tr>`
                        );
                    }
                }
            });
        }
    });

    frmStudentIDType.validate({
        rules: {
            id_layout: { required: true }
        },
        messages: {
            id_layout: { required: "Please choose a layout" }
        },
        errorPlacement: function(error, element) {
            error.addClass('invalid-feedback');
            element.closest('.form-group').append(error);
        },
        highlight: function(element) {
            $(element).addClass('is-invalid');
        },
        unhighlight: function(element) {
            $(element).removeClass('is-invalid');
        },
        submitHandler: function(frmStudentIDs) {
            var students = [];
            $("#tblstudent_data tr").each(function() {
                var row = $(this);
                var student = {
                    photo: row.find("td:eq(0) img").attr("src"),
                    adm_no: row.find("td:eq(1)").text().trim(),
                    first_name: row.find("td:eq(2)").text().trim(),
                    surname: row.find("td:eq(3)").text().trim(),
                    last_name: row.find("td:eq(4)").text().trim(),
                    gender: row.find("td:eq(5)").text().trim(),
                    dob: row.find("td:eq(6)").text().trim(),
                    admitted_on: row.find("td:eq(7)").text().trim(),
                    admitted_in: row.find("td:eq(8)").text().trim()
                };
                students.push(student);
            });

            if (students.length > 0) {
                var data = {
                    request: "generate_student_ids",
                    students: students,
                    id_layout: $("select[name='id_layout']").val()
                };
                $.ajax({
                    url: "fetch.php",
                    method: "POST",
                    data: data,
                    dataType: 'json',
                    success: function(response) {
                        showModal('#mdlStudentID');
                        $("#pdfreport").html(
                            '<iframe id="ifrm" type="application/pdf" style="width: 100%; height: 500px; border: 2px solid darkcyan;"></iframe>'
                        );
				        $("#ifrm").attr("src", response.pdf_url + "&v=" + Date.now());
                    }
                });
            } else {
                alert("No students found");
            }
            return false;
        }
    });

	$("select[name='filter']").on("change", function(){
        createOptionKey($(this).children("option:selected").val());
	});

    $(document).on("change", "select[name='class2']", function(){
        loadSelect("streams", "fetch.php", "stream", this);
    });
    $(document).on("click", ".student-photo", function(){
        $(this).siblings(".upload_photo").click();
    });
    $(document).on("change", ".upload_photo", function(){
        var fileInput = this;

        var file = fileInput.files[0];
        var id = $(this).data("id");
        var allowed = ["image/jpeg", "image/png"];

        if (!file) return;

        if (!allowed.includes(file.type)) {
            alert("Only JPG/PNG allowed");
            return;
        }

        if (file.size > 5 * 1024 * 1024) {
            alert("Max file size is 5MB");
            return;
        }

        var formData = new FormData();
        formData.append("request", "upload_student_photo");
        formData.append("id", id);
        formData.append("photo", file);

        $.ajax({
            url: "fetch.php",
            method: "POST",
            data: formData,
            contentType: false,
            processData: false,

            success: function(response){
                if (response.status) {
                    var newSrc = response.filename + "?v=" + Date.now();
                    $(fileInput)
                        .closest("td")
                        .find(".student-photo")
                        .attr("src", newSrc);

                } else {
                    alert(response.message);
                }
            }
        });
    });
})
</script>
</body>
</html>