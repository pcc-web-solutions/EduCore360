let encryptionKeyBuffer;

async function initializeEncryptionKey(base64Key) {
    await sodium.ready;
    encryptionKeyBuffer = sodium.from_base64(base64Key, sodium.base64_variants.ORIGINAL);
}

(async function() {
    await initializeEncryptionKey("hEfkW3P2IL+0jrMNj1R9UnW+7ZuiHOHYv2fwMffeCrU=");
});

async function encryptData(data) {
    await sodium.ready;
    if (!encryptionKeyBuffer) {
        throw new Error("Encryption key is not initialized.");
    }

    const nonce = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES);
    const message = sodium.from_string(data);
    const cipher = sodium.crypto_secretbox_easy(message, nonce, encryptionKeyBuffer);

    return {
        nonce: sodium.to_base64(nonce, sodium.base64_variants.ORIGINAL),
        cipher: sodium.to_base64(cipher, sodium.base64_variants.ORIGINAL)
    };
}

function hasValue(selector) {
    let $el = $(selector);
    if ($el.is(":checkbox, :radio")) {
        return $el.is(":checked");
    }
    return $el.val().trim().lenghth > 0;
}

function submitData(form, rules, messages) {
    $(form).validate({
        rules: rules,
        messages: messages,
        errorPlacement: function(error, element) {
            error.addClass('invalid-feedback');
            element.closest('.form-group').append(error);
        },
        highlight: function(element, errorClass, validClass) {
            $(element).addClass('is-invalid');
        },
        unhighlight: function(element, errorClass, validClass) {
            $(element).removeClass('is-invalid');
        },
        submitHandler: function(form) {
            form.submit();
        }
    })
}

// async function loadSelect(request, url, selectID, obj) {
//     let key = $(obj).children("option:selected").val();
//     $.ajax({
//         url: url,
//         method: 'post',
//         data: {
//             request: JSON.stringify(await encryptData(request)),
//             key: JSON.stringify(await encryptData(key))
//         },
//         dataType: 'json',
//         success: async function(response) {
//             if (response.status == true) {
//                 var data = response.data;
//                 var len = data.length;
//                 $("#" + selectID).empty();
//                 $("#" + selectID).append("<option value=''>--select--</option>")
//                 for (var i = 0; i < len; i++) {
//                     var value = data[i]['value'];
//                     var text = data[i]['text'];
//                     $("#" + selectID).append("<option value=" + value + ">" + text + "</option>");
//                 }
//             } else {
//                 $("#" + selectID).empty();
//                 $("#" + selectID).append("<option value=''>" + response.message + "</option>")
//             }
//         }
//     })
// }

// async function edit(table, column, id, obj) {
//     var values = {
//         request: JSON.stringify(await encryptData("update_data")),
//         table: JSON.stringify(await encryptData(table)),
//         column: JSON.stringify(await encryptData(column)),
//         id: JSON.stringify(await encryptData(id)),
//         value: JSON.stringify(await encryptData(obj.innerHTML))
//     }
//     $.ajax({
//         type: "POST",
//         url: "fetch.php",
//         data: values,
//         dataType: 'json',
//         success: function(response) {
//             if (response) {
//                 $(obj).closest("td").css({ "border": "2px solid darkcyan", "color": "darkcyan" })
//             } else {
//                 $(obj).closest("td").css({ "border": "2px solid red", "color": "red" })
//             }
//         }
//     });
// }

async function loadSelect(request, url, selectID, obj) {
    let key = $(obj).children("option:selected").val();
    $.ajax({
        url: url,
        method: 'post',
        data: {
            request: request,
            key: key
        },
        dataType: 'json',
        success: async function(response) {
            if (response.status == true) {
                var data = response.data;
                var len = data.length;
                $("#" + selectID).empty();
                $("#" + selectID).append("<option value=''>--select--</option>")
                for (var i = 0; i < len; i++) {
                    var value = data[i]['value'];
                    var text = data[i]['text'];
                    $("#" + selectID).append("<option value=" + value + ">" + text + "</option>");
                }
            } else {
                $("#" + selectID).empty();
                $("#" + selectID).append("<option value=''>" + response.message + "</option>")
            }
        }
    })
}

function edit(table, column, id, obj) {
    var values = {
        request: "update_data",
        table: table,
        column: column,
        id: id,
        value: obj.innerHTML
    }
    $.ajax({
        type: "POST",
        url: "fetch.php",
        data: values,
        dataType: 'json',
        success: function(response) {
            if (response) {
                $(obj).closest("td").css({ "border": "2px solid darkcyan", "color": "darkcyan" })
            } else {
                $(obj).closest("td").css({ "border": "2px solid red", "color": "red" })
            }
        }
    });
}

function userSignUp() {
    var form = document.querySelector('#frmSignUp');
    var rules = {
        id_no: { required: true, number: true, minlength: 8, maxlength: 10 },
        alias: { required: true },
        user_password: { required: true },
        confirm_password: { required: true, equalTo: user_password }
    };
    var messages = {
        id_no: { required: "ID Number is required", number: "Invalid ID Number", minlength: "ID Number too short", maxlength: "ID Number too long" },
        alias: { required: "Enter your preffered username" },
        user_password: { required: "Create a strong password" },
        confirm_password: { required: "Please re-type your password", equalTo: "Password Mismatch" }
    };
    submitData(form, rules, messages);
}

function userSignin() {
    var form = document.querySelector('#frmSignin');
    var rules = {
        username: { required: true },
        password: { required: true }
    };
    var messages = {
        username: { required: "Username is required" },
        password: { required: "Password is required" }
    };
    submitData(form, rules, messages);
}

function UnlockScreen() {
    var form = document.querySelector('#frmUnlockScreen');
    var rules = {
        password: { required: true }
    };
    var messages = {
        password: { required: "Please type in your password" }
    };
    submitData(form, rules, messages);
}

function userUpdateProfile() {
    var form = document.querySelector('#frmUpdateProfile');
    var rules = {
        displayname: { required: true },
        contact: { required: true, number: true, minlength: 10, maxlength: 10 },
        email: { required: true, email: true }
    };
    var messages = {
        displayname: { required: "Display name is required" },
        contact: { required: "Contact is required", number: "Invalid contact", minlength: "Contact too short", maxlength: "Contact too long" },
        email: { required: "Email is required", email: "Invalid Email" }
    };
    submitData(form, rules, messages);
}

function userUpdatePassword() {
    var form = document.querySelector('#frmUpdatePassword');
    var rules = {
        old_password: { required: true },
        new_password: { required: true }
    };
    var messages = {
        old_password: { required: "Please provide your old password" },
        new_password: { required: "Please set you new password" }
    };
    submitData(form, rules, messages);
}

function submitEmail() {
    var form = document.querySelector('#frmSubmitEmail');
    var rules = {
        email: { required: true, email: true }
    };
    var messages = {
        email: { required: "Provide your email address", email: "Invalid email address" }
    };
    submitData(form, rules, messages);
}

function saveUser() {
    var form = document.querySelector('#frmNewUser');
    var rules = {
        username: { required: true },
        password: { required: true },
        c_password: { required: true, equalTo: password },
        display_name: { required: true },
        roll: { required: true },
        email: { required: true, email: true },
        contact: { required: true, number: true }
    };
    var messages = {
        username: { required: "Username is required" },
        password: { required: "Password is required" },
        c_password: { required: "Please confirm password", equalTo: "Password Mismatch" },
        display_name: { required: "Display name is required" },
        roll: { required: "Roll is required" },
        email: { required: "Email address is required", email: "Invalid email address" },
        contact: { required: "Contact is required", number: "Invalid Contact" }
    };
    submitData(form, rules, messages);
}

function resetPassword() {
    var form = document.querySelector('#frmResetPassword');
    var rules = {
        email: { required: true, email: true },
        new_password: { required: true },
        confirm_password: { required: true, equalTo: new_password }
    };
    var messages = {
        email: { required: "Email address is required", email: "Invalid email" },
        new_password: { required: "Create a new required" },
        confirm_password: { required: "Confirm Password", equalTo: "Password Mismatch" }
    };
    submitData(form, rules, messages);
}

function SwitchUserRole() {
    var form = document.querySelector('#frmSwitchUserRole');
    var rules = {
        school: { required: true },
        user_role: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        user_role: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveDimension() {
    var form = document.querySelector('#frmNewDimension');
    var rules = {
        // school: {required: true},
        dim_name: { required: true },
        dim_description: { required: true, maxlength: 255 }
    };
    var messages = {
        // school: {required: "This field is required"},
        dim_name: { required: "This field is required" },
        dim_description: { required: "This field is required", maxlength: "Description too long" }
    };
    submitData(form, rules, messages);
}

function updateCompanyBasicInfo() {
    var form = document.querySelector('#frmCompanyBasicInfo');
    var rules = {
        school_name: {required: true},
        address: { required: true },
        logo: { required: true }
    };
    var messages = {
        school_name: {required: "This field is required"},
        address: { required: "This field is required" },
        logo: { required: "Upload school logo" }
    };
    submitData(form, rules, messages);
}

function updateCompanyContactInfo() {
    var form = document.querySelector('#frmCompanyContactInfo');
    var rules = {
        mail: { required: true, email: true },
        contact: { required: true, number: true, minlength: 10, maxlength: 10 }
    };
    var messages = {
        mail: { required: "This field is required", email: "Invalid email address" },
        contact: { required: "This field is required", number: "Invalid contact", minlength: "Contact too short", maxlength: "Contact too long" }
    };
    submitData(form, rules, messages);
}

function updateCompanySocialInfo() {
    var form = document.querySelector('#frmCompanySocialInfo');
    var rules = {
        facebook: { maxlength: 100 },
        twitter: { maxlength: 100 },
        instagram: { maxlength: 100 },
        linkedin: { maxlength: 100 },
        skype: { maxlength: 100 },
        website: { maxlength: 100 }
    };
    var messages = {
        facebook: { maxlength: "facebook link too long" },
        twitter: { maxlength: "twitter link too long" },
        instagram: { maxlength: "instagram link too long" },
        linkedin: { maxlength: "linkedin link too long" },
        skype: { maxlength: "skype link too long" },
        website: { maxlength: "website link too long" }
    };
    submitData(form, rules, messages);
}

function saveDimensionValue() {
    var form = document.querySelector('#frmNewDimensionValue');
    var rules = {
        school: { required: true },
        dim_id: { required: true },
        dv_name: { required: true, maxlength: 50 },
        description: { required: true, maxlength: 200 },
        filter_name: { required: true, maxlength: 45 }
    };
    var messages = {
        school: { required: "This field is required" },
        dim_id: { required: "This field is required" },
        dv_name: { required: "This field is required", maxlength: "Dimension value too long" },
        description: { required: "This field is required", maxlength: "Description too long" },
        filter_name: { required: "This field is required", maxlength: "Filter name too long" }
    };
    submitData(form, rules, messages);
}

function saveNoSeries() {
    var form = document.querySelector('#frmNewNoSeries');
    var rules = {
        school: { required: true },
        ns_code: { required: true, maxlength: 10 },
        ns_name: { required: true, maxlength: 5 },
        description: { required: true, minlength: 5, maxlength: 100 },
        startno: { required: true, number: true, minlength: 4, maxlength: 10 },
        endno: { required: true, number: true, minlength: 4, maxlength: 10 },
        lastused: { required: true, number: true, minlength: 4, maxlength: 10 },
        canskip: { required: true },
        category: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        ns_code: { required: "This field is required", maxlength: "Code too long" },
        ns_name: { required: "This field is required", maxlength: "Number too long" },
        description: { required: "This field is required", minlength: "Description too short", maxlength: "Description too long" },
        startno: { required: "This field is required", number: "Invalid number", minlength: "Number too short", maxlength: "Number too long" },
        endno: { required: "This field is required", number: "Invalid number", minlength: "Number too short", maxlength: "Number too long" },
        lastused: { required: "This field is required", number: "Invalid number", minlength: "Number too short", maxlength: "Number too long" },
        canskip: { required: "This field is required" },
        category: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewTerm() {
    var form = document.querySelector('#frmNewTerm');
    var rules = {
        term_code: { required: true },
        term_name: { required: true, maxlength: 20 },
        opening_date: { required: true, date: true },
        closing_date: { required: true, date: true }
    };
    var messages = {
        term_code: { required: "This field is required" },
        term_name: { required: "This field is required", maxlength: "Term name too long" },
        opening_date: { required: "This field is required", date: "Invalid opening date" },
        closing_date: { required: "This field is required", date: "Invalid closing date" }
    };
    submitData(form, rules, messages);
}

function saveNewSchool() {
    var form = document.querySelector('#frmNewSchool');
    var rules = {
        school_code: { required: true, number: true, minlength: 8, maxlength: 8 },
        school_name: { required: true, maxlength: 100 },
        category: { required: true },
        mail: { required: true, email: true, maxlength: 50 },
        contact: { required: true, number: true, maxlength: 10 },
        logo: { required: true }
    };
    var messages = {
        school_code: { required: "This field is required", number: "Invalid School Code", minlength: "School code too short", maxlength: "School code too long" },
        school_name: { required: "This field is required", maxlength: "School name too long" },
        category: { required: "Please select category" },
        mail: { required: "This field is required", email: "Invalid email address", maxlength: "Email too long" },
        contact: { required: "This field is required", number: "Invalid contact number", maxlength: "Contact too long" },
        logo: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewClass() {
    var form = document.querySelector('#frmNewClass');
    var rules = {
        school: { required: true },
        class_code: { required: true, maxlength: 10 },
        class_name: { required: true, maxlength: 20 },
        class_number: { required: true, number: true, maxlength: 2 }
    };
    var messages = {
        school: { required: "This field is required" },
        class_code: { required: "This field is required", maxlength: "Class code too long" },
        class_name: { required: "This field is required", maxlength: "Class name too long" },
        class_number: { required: "This field is required", number: "Invalid class number", maxlength: "Class number too long" }
    };
    submitData(form, rules, messages);
}

function saveNewStream() {
    var form = document.querySelector('#frmNewStream');
    var rules = {
        form_code: { required: true },
        stream_code: { required: true, maxlength: 10 },
        stream_name: { required: true, maxlength: 20 },
        description: { maxlength: 100 },
        capacity: { number: true },
        class_teacher: { required: true }
    };
    var messages = {
        form_code: { required: "This field is required" },
        stream_code: { required: "This field is required", maxlength: "Stream code too long" },
        stream_name: { required: "This field is required", maxlength: "Stream name too long" },
        description: { maxlength: "Description too long" },
        capacity: { maxlength: "Invalid student capacity" },
        class_teacher: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewSubject() {
    var form = document.querySelector('#frmNewSubject');
    var rules = {
        school: { required: true },
        class: { required: true },
        subject_code: { required: true, maxlength: 10 },
        subject_name: { required: true, maxlength: 50 },
        group: { required: true },
        department: { required: true },
        category: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        class: { required: "This field is required" },
        subject_code: { required: "This field is required", maxlength: "Subject code too long" },
        subject_name: { required: "This field is required", maxlength: "Subject name too long" },
        group: { required: "This field is required" },
        department: { required: "This field is required" },
        category: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewStudent() {
    var form = document.querySelector('#frmNewStudent');
    var rules = {
        school: { required: true },
        adm_no: { required: true, maxlength: 10 },
        first_name: { required: true, maxlength: 20 },
        surname: { maxlength: 20 },
        last_name: { required: true, maxlength: 20 },
        dob: { date: true },
        doa: { date: true },
        gender: { required: true },
        class: { required: true },
        stream: { required: true },
        term: { required: true },
        year: { required: true, number: true, minlength: 4, maxlength: 4 }
    };
    var messages = {
        school: { required: "School code is required" },
        adm_no: { required: "School name is required", maxlength: "Admission number too long" },
        first_name: { required: "This field is required", maxlength: "First name too long" },
        surname: { maxlength: "Surname too long" },
        last_name: { required: "This field is required", maxlength: "Last name too long" },
        dob: { date: "Invalid date of birth" },
        doa: { date: "Invalid date of admission" },
        gender: { required: "This field is required" },
        class: { required: "This field is required" },
        stream: { required: "This field is required" },
        term: { required: "This field is required" },
        year: { required: "This field is required", number: "Invalid Year", minlength: "Year too short", maxlength: "Year too long" }
    };
    submitData(form, rules, messages);
}

function saveNewStaff() {
    var form = document.querySelector('#frmNewStaff');
    var rules = {
        school: { required: true },
        staff_code: { required: true },
        first_name: { required: true, maxlength: 20 },
        last_name: { required: true, maxlength: 20 },
        gender: { required: true },
        email: { required: true, email: true, maxlength: 50 },
        phone: { required: true, number: true, minlength: 10, maxlength: 10 },
        id_no: { number: true, minlength: 7, maxlength: 10 },
        job_title: { required: true },
        role: { required: true },
        hire_date: { required: true },
        department: { required: true },
        emp_term: { required: true },
        profile_picture: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        staff_code: { required: "This field is required" },
        first_name: { required: "This field is required", maxlength: 20 },
        last_name: { required: "This field is required", maxlength: 20 },
        gender: { required: "This field is required" },
        email: { required: "This field is required", email: "Invalid email address", maxlength: "Email too long" },
        phone: { required: "This field is required", number: "Invalid phone number", minlength: "Phone number too short", maxlength: "Phone number too long" },
        id_no: { number: "Invalid id number", minlength: "ID number too short", maxlength: "ID number too long" },
        job_title: { required: "This field is required" },
        role: { required: "This field is required" },
        hire_date: { required: "This field is required" },
        department: { required: "This field is required" },
        emp_term: { required: "This field is required" },
        profile_picture: { required: "Please upload a passport photo" }
    };
    submitData(form, rules, messages);
}

function UploadStaffDocument() {
    var form = document.querySelector('#frmNewDocumentUpload');
    var rules = {
        school: { required: true },
        file_id: { required: true },
        staff: { required: true },
        document_type: { required: true },
        file_path: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        file_id: { required: "This field is required" },
        staff: { required: "Please select a staff whose document is uploaded" },
        document_type: { required: "You must choose a document type" },
        file_path: { required: "File not chosen" }
    };
    submitData(form, rules, messages);
}

function saveCountry() {
    var form = document.querySelector('#frmNewCountry');
    var rules = {
        country_code: { required: true, number: true, minlength: 2, maxlength: 5 },
        country_name: { required: true },
        curr_code: { required: true, maxlength: 5 }
    };
    var messages = {
        country_code: { required: "This field is required", number: "Invalid number", minlength: "Accepts 2 or more numbers", maxlength: "Accepts 5 or less numbers" },
        country_name: { required: "This field is required" },
        curr_code: { required: "This field is required", maxlength: "Accepts 5 characters" }
    };
    submitData(form, rules, messages);
}

function saveRegion() {
    var form = document.querySelector('#frmNewRegion');
    var rules = {
        rgn_country: { required: true },
        region_name: { required: true }
    };
    var messages = {
        rgn_country: { required: "This field is required" },
        region_name: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveCounty() {
    var form = document.querySelector('#frmNewCounty');
    var rules = {
        county_name: { required: true, minlength: 4, maxlength: 30 },
        region_name: { required: true }
    };
    var messages = {
        county_name: { required: "This field is required", minlength: "Accepts 4 or more numbers", maxlength: "Accepts 30 or less numbers" },
        region_name: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveSubCounty() {
    var form = document.querySelector('#frmNewSubCounty');
    var rules = {
        sub_county: { required: true },
        county_code: { required: true }
    };
    var messages = {
        sub_county: { required: "This field is required" },
        county_code: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveScWard() {
    var form = document.querySelector('#frmNewScWard');
    var rules = {
        ward_name: { required: true },
        sub_county: { required: true }
    };
    var messages = {
        ward_name: { required: "This field is required" },
        sub_county: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function RegisterSupplier() {
    var form = document.querySelector('#frmRegisterSupplier');
    var rules = {
        supplier_name: { required: true, minlength: 20, maxlength: 60 },
        contact_name: { required: true, minlength: 20, maxlength: 50 },
        contact_number: { required: true, number: true, minlength: 10, maxlength: 10 },
        country: { required: true },
        email: { required: true, email: true },
        address: { required: true },
        supplier_rating: { required: true }
    };
    var messages = {
        supplier_name: { required: "Supplier name is required", minlength: "Supplier name too short", maxlength: "Supplier name too long" },
        contact_name: { required: "Contact name is required", minlength: "Contact name too short", maxlength: "Contact name too long" },
        contact_number: { required: "Contact number is required", number: "Invalid Contact number", minlength: "Contact number too short", maxlength: "Contact number too long" },
        country: { required: "Please select country" },
        email: { required: "Email address is required", email: "Invalid email address" },
        address: { required: "Physical address is required" },
        supplier_rating: { required: "Physical address is required" }
    };
    submitData(form, rules, messages);
}

function saveNewBaseUOM() {
    var form = document.querySelector('#frmNewBaseUOM');
    var rules = {
        name: { required: true, maxlength: 50 },
        abbreviation: { required: true, maxlength: 10 },
        category_id: { required: true },
        description: { maxlength: 255 },
        symbol: { maxlength: 10 },
        si_unit: { required: true },
        is_active: { required: true }
    };
    var messages = {
        name: { required: "This field is required", maxlength: "Name too long" },
        abbreviation: { required: "This field is required", maxlength: "Abbreviation too long" },
        category_id: { required: "This field is required" },
        description: { maxlength: "Description too long" },
        symbol: { maxlength: "Symbol too long" },
        si_unit: { required: "This field is required" },
        is_active: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewUOM() {
    var form = document.querySelector('#frmNewUOM');
    var rules = {
        name: { required: true, maxlength: 50 },
        abbreviation: { required: true, maxlength: 10 },
        base_unit_id: { required: true },
        conversion_factor: { required: true, number: true },
        is_default: { required: true },
        is_compound: {
            required: function() {
                return hasValue("#compound_structure");
            }
        },
        compound_structure: {
            required: function() {
                return hasValue("#is_compound");
            }
        },
        is_active: { required: true }
    };
    var messages = {
        name: { required: "This field ia required", maxlength: "Name too long" },
        abbreviation: { required: "This field ia required", maxlength: "Abbreviation too long" },
        base_unit_id: { required: "This field ia required" },
        conversion_factor: { required: "This field is required", number: "Invalid conversion factor" },
        is_default: { required: "This field ia required" },
        is_compound: "Please describe the compound unit",
        compound_structure: "Please select Is Compound Unit",
        is_active: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function saveNewStockItem() {
    var form = document.querySelector('#frmNewStockItem');
    var rules = {
        school: { required: true, minlength: 8, maxlength: 8 },
        name: { required: true, maxlength: 255 },
        description: { maxlength: 255 },
        category_id: { required: true },
        type: { required: true },
        base_unit_of_measure_id: { required: true },
        is_active: { required: true },
        purchase_cost: { required: true, number: true },
        is_depreciable: { required: true },
        depreciation_rate: { required: true, number: true },
        quantity_in_stock: { required: true, number: true },
        reorder_level: { required: true, number: true },
        asset_tag: { required: true, maxlength: 50 },
        purchase_date: { required: true },
        last_service_date: { required: true },
        expected_service_lifetime: { required: true }
    };
    var messages = {
        school: { required: "This field is required", minlength: "Too short", maxlength: "Too long" },
        name: { required: "This field is required", maxlength: "Name too long" },
        description: { maxlength: "Description too long" },
        category_id: { required: "This field is required" },
        type: { required: "This field is required" },
        base_unit_of_measure_id: { required: "This field is required" },
        is_active: { required: "This field is required" },
        purchase_cost: { required: "This field is required", number: "Invalid value" },
        is_depreciable: { required: "This field is required" },
        depreciation_rate: { required: "This field is required", number: "Invalid value" },
        quantity_in_stock: { required: "This field is required", number: "Invalid value" },
        reorder_level: { required: "This field is required", number: "Invalid value" },
        asset_tag: { required: "This field is required", maxlength: 50 },
        purchase_date: { required: "This field is required" },
        last_service_date: { required: "This field is required" },
        expected_service_lifetime: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveJobCategory() {
    var form = document.querySelector('#frmNewJobCategory');
    var rules = {
        name: { required: true },
        description: { required: true }
    };
    var messages = {
        name: { required: "This field is required" },
        description: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveJobLevel() {
    var form = document.querySelector('#frmNewJobLevel');
    var rules = {
        name: { required: true },
        description: { required: true }
    };
    var messages = {
        name: { required: "This field is required" },
        description: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveJobGroup() {
    var form = document.querySelector('#frmNewJobGroup');
    var rules = {
        name: { required: true, maxlength: 1 },
        description: { required: true },
        min_salary: { required: true, number: true },
        max_salary: { required: true, number: true }
    };
    var messages = {
        name: { required: "This field is required", maxlength: "Job group name too long" },
        description: { required: "This field is required" },
        min_salary: { required: "This field is required", number: "Invalid Amount" },
        max_salary: { required: "This field is required", number: "Invalid Amount" }
    };
    submitData(form, rules, messages);
}

function SaveJobTitle() {
    var form = document.querySelector('#frmNewJobTitle');
    var rules = {
        school: { required: true },
        name: { required: true },
        category_id: { required: true },
        level_id: { required: true },
        group_id: { required: true },
        description: { required: true },
        department: { required: true },
        job_status: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        name: { required: "This field is required" },
        category_id: { required: "This field is required" },
        level_id: { required: "This field is required" },
        group_id: { required: "This field is required" },
        description: { required: "This field is required" },
        department: { required: "This field is required" },
        job_status: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveSkill() {
    var form = document.querySelector('#frmNewSkill');
    var rules = {
        name: { required: true },
        description: { required: true }
    };
    var messages = {
        name: { required: "This field is required" },
        description: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveJobSkill() {
    var form = document.querySelector('#frmNewJobSkill');
    var rules = {
        job_title_id: { required: true },
        skill_id: { required: true }
    };
    var messages = {
        job_title_id: { required: "This field is required" },
        skill_id: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function NewJobPosting() {
    var form = document.querySelector('#frmNewJobPosting');
    var rules = {
        school: { required: true },
        department: { required: true },
        job_posting_code: { required: true },
        job_title: { required: true },
        vacant_posts: { required: true, number: true },
        posting_date: { required: true, date: true },
        closing_date: { required: true, date: true },
        description: { required: true, maxlength: 255 },
        employment_type: { required: true },
        location: { maxlength: 100 },
        salary_range: { maxlength: 100 }
    };
    var messages = {
        school: { required: "This field is required" },
        department: { required: "This field is required" },
        job_posting_code: { required: "This field is required" },
        job_title: { required: "This field is required" },
        vacant_posts: { required: "This field is required", number: "Invalid vacant posts" },
        posting_date: { required: "This field is required", date: "Invalid date" },
        closing_date: { required: "This field is required", date: "Invalid date" },
        description: { required: "This field is required", maxlength: "Description too long" },
        employment_type: { required: "This field is required" },
        location: { maxlength: "Location too long" },
        salary_range: { maxlength: "Salary range too long" }
    };
    submitData(form, rules, messages);
}

function NewJobApplicant() {
    var form = document.querySelector('#frmNewJobApplicant');
    var rules = {
        applicant_code: { required: true },
        applicant_name: { required: true, minlength: 10, maxlength: 60 },
        contact_phone: { required: true, number: true, minlength: 10, maxlength: 10 },
        contact_email: { required: true, email: true, maxlength: 50 },
        resume: { required: true }
    };
    var messages = {
        applicant_code: { required: "This field is required" },
        applicant_name: { required: "This field is required", minlength: "Name too short", maxlength: "Name too long" },
        contact_phone: { required: "This field is required", number: "Invalid phone number", minlength: "Contact too short", maxlength: "Contact too long" },
        contact_email: { required: "This field is required", email: "Invalid email address", maxlength: "Email too long" },
        resume: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function ApplyForJob() {
    var form = document.querySelector('#frmApplyForJob');
    var rules = {
        applicant_code: { number: true, minlength: 7, maxlength: 10 },
        applicant_name: { required: true, minlength: 10, maxlength: 60 },
        contact_phone: { required: true, number: true, minlength: 10, maxlength: 10 },
        contact_email: { required: true, email: true, maxlength: 50 },
        resume: { required: true },
        cover_letter: { required: true }
    };
    var messages = {
        applicant_code: { number: "Invalid ID number", minlength: "ID too short", maxlength: "ID too long" },
        applicant_name: { required: "This field is required", minlength: "Name too short", maxlength: "Name too long" },
        contact_phone: { required: "This field is required", number: "Invalid phone number", minlength: "Contact too short", maxlength: "Contact too long" },
        contact_email: { required: "This field is required", email: "Invalid email address", maxlength: "Email too long" },
        resume: { required: "Kindly attach your resume" },
        cover_letter: { required: "Kindly attach your cover letter" }
    };
    submitData(form, rules, messages);
}

function NewJobApplication() {
    var form = document.querySelector('#frmNewJobApplication');
    var rules = {
        school: { required: true },
        applicant_code: { required: true },
        job_posting_code: { required: true }
    };
    var messages = {
        school: { required: "This field is required" },
        applicant_code: { required: "This field is required" },
        job_posting_code: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function SaveEmployee() {
    var form = document.querySelector('#frmNewEmployee');
    var rules = {
        id_no: { required: true, number: true },
        p_no: { number: true },
        first_name: { required: true, maxlength: 20 },
        last_name: { required: true, maxlength: 20 },
        gender: { required: true },
        marital_status: { required: true },
        primary_number: { required: true, number: true, minlength: 10, maxlength: 10 },
        alternative_number: { number: true, minlength: 10, maxlength: 10 },
        primary_email: { required: true, email: true },
        alternative_email: { email: true },
        employer_name: { required: true },
        employment_term: { required: true },
        job_title: { required: true },
        branch: { required: true },
        department: { required: true }
    };
    var messages = {
        id_no: { required: "This field is required", number: "Invalid ID Number" },
        p_no: { number: "Invalid Personal Number" },
        first_name: { required: "This field is required", maxlength: "First name too long" },
        last_name: { required: "This field is required", maxlength: "Last name too long" },
        gender: { required: "This field is required" },
        marital_status: { required: "This field is required" },
        primary_number: { required: "This field is required", number: "Invalid Phone Number", minlength: "Number too short", maxlength: "Number too long" },
        alternative_number: { number: "Invalid Phone Number", minlength: "Number too short", maxlength: "Number too long" },
        primary_email: { required: "This field is required", email: "Invalid Email Address" },
        alternative_email: { email: "Invalid Email Address" },
        employer_name: { required: "This field is required" },
        employment_term: { required: "This field is required" },
        job_title: { required: "This field is required" },
        branch: { required: "This field is required" },
        department: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function NewTrainingProgram() {
    var form = document.querySelector('#frmNewTrainingProgram');
    var rules = {
        school: { required: true },
        program_code: { required: true },
        program_name: { required: true, maxlength: 50 },
        facilitator_name: { required: true, maxlength: 50 },
        start_date: { required: true },
        end_date: { required: true },
        comment: { required: false }
    };
    var messages = {
        school: { required: "This field is required" },
        program_code: { required: "This field is required" },
        program_name: { required: "This field is required", maxlength: "Leave type too long" },
        facilitator_name: { required: "This field is required", maxlength: "Leave type too long" },
        start_date: {required: "This field is required"},
        end_date: {required: "This field is required"},
        comment: { required: "This field is required" }
    };
    submitData(form, rules, messages);
}

function NewBenefitType() {
    var form = document.querySelector('#frmNewBenefitType');
    var rules = {
        school: { required: true },
        benefit_type_code: { required: true },
        benefit_type_name: { required: true, maxlength: 50 },
        is_recurring: { required: false },
        recurring_type: { required: false },
        quantity: { required: true, number: true }
    };
    var messages = {
        school: { required: "This field is required" },
        benefit_type_code: { required: "This field is required" },
        benefit_type_name: { required: "This field is required", maxlength: "Leave type too long" },
        is_recurring: {required: "Is recurring is required for recurring benefits"},
        recurring_type: {required: "Please select is recurring"},
        quantity: { required: "This field is required", number: "Invalid number of leaves" }
    };
    submitData(form, rules, messages);
}

function NewStaffBenefit() {
    var form = document.querySelector('#frmNewStaffBenefit');
    var rules = {
        school: { required: true },
        benefit_code: { required: true },
        staff_code: { required: true },
        benefit_type: { required: true },
        description: { required: true, maxlength: 255 },
        effective_date: { required: true, date: true }
    };
    var messages = {
        school: { required: "This field is required" },
        benefit_code: { required: "This field is required" },
        staff_code: { required: "This field is required" },
        benefit_type: { required: "This field is required" },
        description: { required: "This field is required", maxlength: "Description too long" },
        effective_date: { required: "This field is required", date: "Invalid end date" }
    };
    submitData(form, rules, messages);
}

function NewLeaveType() {
    var form = document.querySelector('#frmNewLeaveType');
    var rules = {
        school: { required: true },
        leave_type_code: { required: true },
        leave_type_name: { required: true, maxlength: 50 },
        applies_to: { required: true },
        no_of_days_off: { required: true, number: true },
        maximum_leaves: { required: true, number: true }
    };
    var messages = {
        school: { required: "This field is required" },
        leave_type_code: { required: "This field is required" },
        leave_type_name: { required: "This field is required", maxlength: "Leave type too long" },
        applies_to: { required: "This field is required" },
        no_of_days_off: { required: "This field is required", number: "Invalid number of days off" },
        maximum_leaves: { required: "This field is required", number: "Invalid number of leaves" }
    };
    submitData(form, rules, messages);
}

function NewLeaveApplication() {
    var form = document.querySelector('#frmNewLeaveApplication');
    var rules = {
        school: { required: true },
        leave_code: { required: true },
        staff_code: { required: true },
        leave_type: { required: true },
        start_date: { required: true, date: true },
        end_date: { required: true, date: true }
    };
    var messages = {
        school: { required: "This field is required" },
        leave_code: { required: "This field is required" },
        staff_code: { required: "This field is required" },
        leave_type: { required: "This field is required" },
        start_date: { required: "This field is required", date: "Invalid start date" },
        end_date: { required: "This field is required", date: "Invalid end date" }
    };
    submitData(form, rules, messages);
}

function NewTransferApplication() {
    var form = document.querySelector('#frmNewTransferApplication');
    var rules = {
        transfer_code: { required: true },
        transfer_from: { required: true },
        transfer_to: { required: true },
        date_requested: { required: true, date: true },
        on_behalf_of: { required: false },
        effective_date: { required: true, date: true },
        comment: { maxlength: 255 }
    };
    var messages = {
        transfer_code: { required: "This field is required" },
        transfer_from: { required: "This field is required" },
        transfer_to: { required: "This field is required" },
        date_requested: { required: "This field is required", date: "Invalid date" },
        on_behalf_of: { required: "This field is required" },
        effective_date: { required: "This field is required", date: "Invalid date" },
        comment: { maxlength: "Comment too long" }
    };
    submitData(form, rules, messages);
}

function BackupDatabase() {
    var form = document.querySelector('#frmBackupDatabase');
    var rules = {
        format: { required: true }
    };
    var messages = {
        format: { required: "Please choose a database format" }
    };
    submitData(form, rules, messages);
}