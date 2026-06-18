var ekyc_familytable;
var ekyc_familyhtml;
var ekyc_code;
var ekyc_name;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function getmarriagedate(ddl) {
    var value = ddl.options[ddl.selectedIndex].value;
    if (value == "M") {
        document.getElementById("ekyc_marriagedate").disabled = false;
    }
    else {
        document.getElementById("ekyc_marriagedate").value = "";
        document.getElementById("ekyc_marriagedate").disabled = true;
    }
}

function BindEmployeeKYCInfo() {

    $('#load1').show();

    $.ajax({
        url: "EmployeeKYC.aspx/getEmployeeKYCInfo",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray, function (index, value) {

                ekyc_code = blankForNull(value.Code);
                ekyc_name = blankForNull(value.FullName);

                document.getElementById("ekyc_fullname").value = blankForNull(value.Code) + ' : ' + blankForNull(value.FullName);
                document.getElementById("ekyc_doj").value = blankForNull(value.DOJ);
                //document.getElementById("ekyc_dob").value = blankForNull(value.DOB);
                var date = new Date(value.DOB);
                var day = date.getDate();
                if (day < 10)
                    day = '0' + day
                var month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                var year = date.getFullYear();
                var actualdate = year + "-" + (month) + "-" + (day);
                $("#ekyc_dob").val(actualdate);

                $("#ekyc_gender").val(value.Gender);
                document.getElementById("ekyc_contact").value = blankForNull(value.ContactNo);
                $("#ekyc_qualification").val(value.Qual);
                $("#ekyc_maritalstatus").val(value.MStatus);
                //document.getElementById("ekyc_marriagedate").value = blankForNull(value.MarriageDate);
                var date1 = new Date(value.MarriageDate);
                var day1 = date1.getDate();
                if (day1 < 10)
                    day1 = '0' + day1
                var month1 = date1.getMonth() + 1;
                if (month1 < 10)
                    month1 = '0' + month1;
                var year1 = date1.getFullYear();
                var actualdate1 = year1 + "-" + (month1) + "-" + (day1);
                $("#ekyc_marriagedate").val(actualdate1);
                document.getElementById("ekyc_fatherhusbandname").value = blankForNull(value.FahterName);
                $("#ekyc_physicalhandicap").val(value.PH);
                $("#ekyc_handicapcategory").val(value.PHC);
                document.getElementById("ekyc_presentaddress").value = blankForNull(value.PresentAddress);
                document.getElementById("ekyc_permanentaddress").value = blankForNull(value.PermanentAddress);
                document.getElementById("ekyc_bankname").value = blankForNull(value.BankName);
                document.getElementById("ekyc_accno").value = blankForNull(value.BankAccNO);
                document.getElementById("ekyc_ifsccode").value = blankForNull(value.IFSCCode);
                $("#ekyc_documenttype").val(value.DocName);
                document.getElementById("ekyc_docno").value = blankForNull(value.DocNumber);
                //document.getElementById("ekyc_expirydate").value = blankForNull(value.ExpDate);
                var date2 = new Date(value.ExpDate);
                var day2 = date2.getDate();
                if (day2 < 10)
                    day2 = '0' + day2
                var month2 = date2.getMonth() + 1;
                if (month2 < 10)
                    month2 = '0' + month2;
                var year2 = date2.getFullYear();
                var actualdate2 = year2 + "-" + (month2) + "-" + (day2);
                $("#ekyc_expirydate").val(actualdate2);
                document.getElementById("ekyc_aadharno").value = blankForNull(value.AadharCardNo);
                document.getElementById("ekyc_panno").value = blankForNull(value.PAN);
                document.getElementById("ekyc_nomineename").value = blankForNull(value.Nominee);
                $("#ekyc_nomineerelation").val(value.NRelation);
                //document.getElementById("ekyc_nomineebirthdate").value = blankForNull(value.NDOB);
                var date3 = new Date(value.NDOB);
                var day3 = date3.getDate();
                if (day3 < 10)
                    day3 = '0' + day3
                var month3 = date3.getMonth() + 1;
                if (month3 < 10)
                    month3 = '0' + month3;
                var year3 = date3.getFullYear();
                var actualdate3 = year3 + "-" + (month3) + "-" + (day3);
                $("#ekyc_nomineebirthdate").val(actualdate3);
                document.getElementById("ekyc_nomineecontact").value = blankForNull(value.NContactNo);
                document.getElementById("ekyc_nomineeaddress").value = blankForNull(value.NAddress);

            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#load1').hide();
    return false;
}

function ekyc_BindFamilyGrid() {

    ekyc_familyhtml = '';

    $.ajax({
        url: "EmployeeKYC.aspx/getEmployeeFamilyInfo",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                ekyc_familyhtml += '<tr>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Relation) + '</td>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Profession) + '</td>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Age) + '</td>';
                ekyc_familyhtml += '<td style="text-wrap: nowrap; "><a class="dropdown-item" href="#!" id="Actions" onclick="DeleteFamilyInfo(' + value.FamilyInfoID + ');"><span style="color: red;"><i class="uil fs-0 me-2 uil-trash"></i></span></a></td>';
                ekyc_familyhtml += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#ekyc_familytable')) {
                ekyc_familytable.destroy();
            }
            $('#ekyc_familytable tbody').html(ekyc_familyhtml);
            //else
            ekyc_familytable = $('#ekyc_familytable').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Bank Names', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2],
                        }

                    },


                ],

            });


        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function ekyc_submit() {

    var ddlgender = document.getElementById("ekyc_gender");
    var gender = ddlgender.options[ddlgender.selectedIndex].value;

    var ddlmarstatus = document.getElementById("ekyc_maritalstatus");
    var marstatus = ddlmarstatus.options[ddlmarstatus.selectedIndex].value;

    var contact = document.getElementById("ekyc_contact").value.trim();
    var presentaddress = document.getElementById("ekyc_presentaddress").value.trim();
    var permanentaddress = document.getElementById("ekyc_permanentaddress").value.trim();
    var fatherhusbandname = document.getElementById("ekyc_fatherhusbandname").value.trim();
    var joiningdate = document.getElementById("ekyc_doj").value;
    var dob = document.getElementById("ekyc_dob").value;

    var ifsccode = document.getElementById("ekyc_ifsccode").value.trim();

    var bankname = document.getElementById("ekyc_bankname").value.trim();
    var accno = document.getElementById("ekyc_accno").value.trim();
    var panno = document.getElementById("ekyc_panno").value.trim();
    var adhar = document.getElementById("ekyc_aadharno").value.trim();

    var ddlqual = document.getElementById("ekyc_qualification");
    var qual = ddlqual.options[ddlqual.selectedIndex].value;

    var ddlph = document.getElementById("ekyc_physicalhandicap");
    var ph = ddlph.options[ddlph.selectedIndex].value;

    var ddlphc = document.getElementById("ekyc_handicapcategory");
    var phc = ddlphc.options[ddlphc.selectedIndex].value;

    var nomineename = document.getElementById("ekyc_nomineename").value.trim();
    var nomineeaddress = document.getElementById("ekyc_nomineeaddress").value.trim();

    var ddlnomineerelation = document.getElementById("ekyc_nomineerelation");
    var nomineerelation = ddlnomineerelation.options[ddlnomineerelation.selectedIndex].value;

    var nomineedob = document.getElementById("ekyc_nomineebirthdate").value;
    var nomineecontact = document.getElementById("ekyc_nomineecontact").value.trim();

    var marriagedate = document.getElementById("ekyc_marriagedate").value;

    var ddldoctype = document.getElementById("ekyc_documenttype");
    var doctype = ddldoctype.options[ddldoctype.selectedIndex].value;

    var docno = document.getElementById("ekyc_docno").value.trim();
    var docexpdate = document.getElementById("ekyc_expirydate").value;

    // ✅ Validation config (clean & reusable)
    if (!validateFields([
        { id: "ekyc_gender", type: "select", message: "Please select gender" },
        { id: "ekyc_maritalstatus", type: "select", message: "Please select marital status" },
        { id: "ekyc_contact", message: "Contact is required" },
        { id: "ekyc_presentaddress", message: "Present address is required" },
        { id: "ekyc_permanentaddress", message: "Permanent address is required" },
        { id: "ekyc_fatherhusbandname", message: "Father/Husband name is required" },
        { id: "ekyc_doj", message: "Joining date is required" },
        { id: "ekyc_dob", message: "Date of birth is required" },
        { id: "ekyc_ifsccode", message: "IFSC code is required" },
        { id: "ekyc_bankname", message: "Bank name is required" },
        { id: "ekyc_accno", message: "Account number is required" },
        { id: "ekyc_panno", message: "PAN number is required" },
        { id: "ekyc_aadharno", message: "Aadhar number is required" },
        { id: "ekyc_qualification", type: "select", message: "Please select qualification" },
        { id: "ekyc_nomineename", message: "Nominee name is required" },
        { id: "ekyc_nomineeaddress", message: "Nominee address is required" },
        { id: "ekyc_nomineerelation", type: "select", message: "Please select nominee relation" },
        { id: "ekyc_nomineebirthdate", message: "Nominee DOB is required" },
        { id: "ekyc_nomineecontact", message: "Nominee contact is required" },
        // { id: "ekyc_documenttype", type: "select", message: "Please select document type" },
        // { id: "ekyc_docno", message: "Document number is required" }
    ])) {
        return false;
    }

    // ✅ Server call
    PageMethods.InsertUpdateKYCInfo(
        ekyc_code, ekyc_name.toUpperCase(), gender, marstatus, contact, presentaddress, permanentaddress, fatherhusbandname,
        joiningdate, dob, ifsccode, bankname, accno, panno, adhar, qual, ph, phc,
        nomineename, nomineeaddress, nomineerelation, nomineedob, nomineecontact,
        marriagedate, doctype, docno, docexpdate,

        function (result) {

            Swal.fire({
                icon: result > 0 ? 'success' : 'error',
                title: result > 0 ? 'Success' : 'Oops!',
                text: result > 0
                    ? 'KYC information updated successfully!'
                    : 'Error occurred while updating KYC information.'
            }).then((response) => {

                if (response.isConfirmed && result > 0) {

                    window.location.href = 'DashboardEmployee.aspx';
                }
            });
        },
        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.responseText || 'Something went wrong!'
            });
        }
    );

    return false;
}


function DeleteFamilyInfo(familyinfoid) {

    Swal.fire({
        title: 'Confirm Action', html: `Are you sure you want to delete family record?`, icon: 'question',
        allowOutsideClick: false,
        showCancelButton: true, confirmButtonText: 'Yes', cancelButtonText: 'Cancel', confirmButtonColor: '#3085d6', cancelButtonColor: '#d33'
    }).then((result) => {

        // Call PageMethod only when user clicks YES
        if (result.isConfirmed) {

            PageMethods.DeleteFamilyInfo(
                familyinfoid,
                function (response) {

                    if (response > 0) {
                        Swal.fire({ icon: 'success', title: 'Deleted!', text: 'Family information deleted successfully!' }).then(() => {

                            ekyc_BindFamilyGrid();

                        });
                    }
                    else {
                        Swal.fire({ icon: 'error', title: 'Oops!', text: 'Error occurred while deleting family information. Please contact administrator!' });
                    }
                },
                function (error) {
                    Swal.fire({ icon: 'error', title: 'Server Error', text: error.responseText || 'Something went wrong!' });
                }
            );
        }
    });
}

function ekyc_addfamilyinfo() {

    var familyname = document.getElementById("ekcy_familyname").value.trim();

    var ddlrelation = document.getElementById("ekyc_familyrelation");
    var relation = ddlrelation.options[ddlrelation.selectedIndex].value;

    var ddloccupation = document.getElementById("ekyc_familyoccupation");
    var occupation = ddloccupation.options[ddloccupation.selectedIndex].value;

    var familydob = document.getElementById("ekyc_familybirthdate").value.trim();

    // Validation - all fields mandatory
    if (familyname === "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Family name is required' });
        return false;
    }

    if (relation === "" || relation === "0") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select relation' });
        return false;
    }

    if (occupation === "" || occupation === "0") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Please select occupation' });
        return false;
    }

    if (familydob === "") {
        Swal.fire({ icon: 'warning', title: 'Required', text: 'Date of birth is required' });
        return false;
    }

    // Call PageMethod only if validation passes
    PageMethods.InsertFamilyInfo(familyname, relation, occupation, familydob,
        function (result) {

            if (result > 0) {
                Swal.fire({ icon: 'success', title: 'Success', text: 'Record added successfully!' }).then(() => {

                    ekyc_BindFamilyGrid();
                    // Optional: clear form after success
                    document.getElementById("ekcy_familyname").value = "";
                    document.getElementById("ekyc_familyrelation").selectedIndex = 0;
                    document.getElementById("ekyc_familyoccupation").selectedIndex = 0;
                    document.getElementById("ekyc_familybirthdate").value = "";
                });
            }
            else {
                Swal.fire({ icon: 'error', title: 'Oops!', text: 'Error occurred while adding record. Please contact administrator!' });
            }
        },
        function (error) {
            Swal.fire({ icon: 'error', title: 'Server Error', text: error.responseText || 'Something went wrong!' });
        }
    );

    return false;
}

function validateFields(fields) {
    for (var i = 0; i < fields.length; i++) {

        var f = fields[i];
        var el = document.getElementById(f.id);

        if (!el) continue;

        var value;

        if (el.tagName === "SELECT") {
            value = el.options[el.selectedIndex].value;
        } else {
            value = el.value.trim();
        }

        if (f.type === "select") {
            if (value === "" || value === "0") {
                Swal.fire({
                    icon: 'warning',
                    title: 'Required',
                    text: f.message
                });
                return false;
            }
        }
        else {
            if (!value) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Required',
                    text: f.message
                });
                return false;
            }
        }
    }

    return true;
}

/*---------------------- OLD CODE ------------------------*/
