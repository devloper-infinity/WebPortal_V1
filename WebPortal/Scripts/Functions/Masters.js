var setappr_gr_table;
var roam_table;
var roam_html;
var roam_roambranchid;
var apprdesc_table;
var apprdesc_html;
var poshtestres_table;
var poshtestres_html = '';
var posh_ans_table;
var posh_ans_html;
var poshtestSummary_table;
var poshtestSummary_html;
var doc_appDate = '';

function roam_bindbranches() {
    var select = document.getElementById("roam_branch");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#roam_branch").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "RoamingBranch.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#roam_branch").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });
}

function roam_bindemployee() {
    var select = document.getElementById("roam_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#roam_employee").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "RoamingBranch.aspx/GetCodes", dataType: "json", contentType: "application/json",

        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#roam_employee").append($("<option></option>").val(value.EmployeeID).html(value.Code + ' : ' + value.Name));
            })
        }
    });
}

function roam_Message() {
    $('#roam_dverror').modal('hide');
    document.getElementById("roam_employee").selectedIndex = 0;
    document.getElementById("roam_branch").selectedIndex = 0;
    roam_Binddata();
}

function roam_delete(rbid, index) {
    roam_roambranchid = rbid;
    $('#roam_deleteroamingbranch').modal('show');
}

function roam_deleteroamingbranch() {
    PageMethods.DeleteRoamingBranch(roam_roambranchid, roam_DeleteOnSuccess, roam_DeleteOnError);
    return false;
}

function roam_DeleteOnSuccess(result) {
    if (result > 0) {
        $('#roam_deleteroamingbranch').modal('hide');
        document.getElementById("roam_errmsg").innerHTML = "Roaming branch deleted successfully!";
        $('#roam_dverror').modal('show');

    }
    else {
        $('#roam_deleteroamingbranch').modal('hide');
        document.getElementById("roam_errmsg").innerHTML = "Oops! Error occured while deleting roaming branch. Please contact administrator!";
        document.getElementById("roam_errmsg").style.color = 'red';
        $('#roam_dverror').modal('show');

    }
    return false;
}

function roam_DeleteOnError(error) {
    alert(error);
}

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function roam_Binddata() {
    $('#load1').show();
    roam_html = '';
    $.ajax({
        url: "RoamingBranch.aspx/BindGrid",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate;
                if (value.AddedDate != null)
                    addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                roam_html += '<tr>';
                roam_html += '<td style="display:none;">' + value.RomingBranchID + '</td>';
                roam_html += '<td style="text-align:center;"><a title="Delete Record" class="dropdown-item" href="#!" id="Actions" onclick="roam_delete(' + value.RomingBranchID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-trash"></i></span></a></td>';
                roam_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                roam_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.User) + '</td>';
                roam_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                roam_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AddedByName) + '</td>';
                roam_html += '<td style="text-wrap: nowrap; ">' + blankForNull(addeddate) + '</td>';
                roam_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#roam_table')) {
                roam_table.destroy();
            }
            $('#roam_table tbody').html(roam_html);
            //else
            roam_table = $('#roam_table').DataTable({
                dom: 'lBftip',
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
                        extend: 'excelHtml5', title: 'Roaming Branch', autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2],
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function roam_submit() {
    var ddlemp = document.getElementById("roam_employee");
    var roam_employee = ddlemp.options[ddlemp.selectedIndex].text;
    var ddlbranch = document.getElementById("roam_branch");
    var roam_branch = ddlbranch.options[ddlbranch.selectedIndex].value;
    if (roam_employee == "") {
        alert("Please select employee");
        document.getElementById("roam_employee").focus();
        return false;
    }
    if (roam_branch == "") {
        alert("Please select branch");
        document.getElementById("roam_branch").focus();
        return false;
    }

    PageMethods.InsertRoamingBranch(roam_employee, roam_branch, roam_OnSuccess, roam_OnError);
    return false;
}

function roam_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("roam_errmsg").innerHTML = "Roaming branch added successfully!";
        $('#roam_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("roam_errmsg").innerHTML = "Oops! Error occured while adding roaming branch. Please contact administrator!";
        document.getElementById("roam_errmsg").style.color = 'red';
        $('#roam_dverror').modal('show');
        return false;
    }
    return false;
}

function roam_OnError(error) {
    alert(error);
}


function rup_bindusers() {
    var select = document.getElementById("rup_user");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#rup_user").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ResetUserPassword.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#rup_user").append($("<option></option>").val(value.EMPID).html(value.Code + ' : ' + value.NAME));
            })
        }
    });
}

function brup_reset() {
    var ddluser = document.getElementById("rup_user");
    var user = ddluser.options[ddluser.selectedIndex].value;
    if (user == "") {
        alert("Please select employee.");
        return false;
    }
    PageMethods.ResetUserPasswords(user, rup_OnSuccess, rup_OnError);
    return false;
}

function rup_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("rup_errmsg").innerHTML = "Password reset successfully!";
        $('#rup_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("rup_errmsg").innerHTML = "Oops! Error occured while reset password. Please contact administrator!";
        document.getElementById("rup_errmsg").style.color = 'red';
        $('#rup_dverror').modal('show');
        return false;
    }
    return false;
}

function rup_OnError(error) {
    alert(error);
}


/*------------ Document Generation ------------*/


function bindemployeedocumentheader() {
    $('#load1').show();
    $.ajax({
        url: "EmployeeDocuments.aspx/GetUserInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                document.getElementById("empdoc_code").innerHTML = blankForNull(value.Code);
                document.getElementById("empdoc_name").innerHTML = blankForNull(value.FirstName) + ' ' + blankForNull(value.MiddleName) + ' ' + blankForNull(value.lastName);
                document.getElementById("empdoc_joiningdate").innerHTML = blankForNull(value.JoiningDate);
                document.getElementById("empdoc_branch").innerHTML = blankForNull(value.WorkingBranchName);
                document.getElementById("empdoc_department").innerHTML = blankForNull(value.DepartmentName);
                document.getElementById("empdoc_designation").innerHTML = blankForNull(value.DesignationName);
                document.getElementById("empdoc_subdomain_hid").value = blankForNull(value.SubDomain);
                doc_appDate = blankForNull(value.AppointmentDate1);
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    $('#load1').hide();
}

function getoptions() {

    var ddl = document.getElementById("empdoc_doctype");
    var value = ddl.options[ddl.selectedIndex].value;

    if ((value == "AppointmentLetter" || value == "EmployeeAgreementWithoutBondForExpAnalyst" || value == "EmployeeAgreementWithoutBondForExpAnalyst4" || value == "EmployeeAgreementWithoutBondForExpAnalyst5") && (document.getElementById("empdoc_subdomain_hid").value == "Credit" || document.getElementById("empdoc_subdomain_hid").value == "Servicing")) {

        document.getElementById("trprocess").style.display = '';
        document.getElementById("trincentive").style.display = '';
        document.getElementById("trAppoint").style.display = '';

        var date = new Date(doc_appDate);
        var day = date.getDate();
        if (day < 10)
            day = '0' + day;
        var month = date.getMonth() + 1;
        if (month < 10)
            month = '0' + month;
        var year = date.getFullYear();
        var actualdate = year + "-" + (month) + "-" + (day);

        $("#empdoc_appoint").val(actualdate);
    }
    else if (value == "EmployeeAgreementWithoutBond4" || value == "EmployeeAgreementWithoutBond" || value == "EmployeeAgreementWithoutBondForExp" || value == "EmployeeAgreementWithoutBondForExpAnalyst" || value == "EmployeeAgreement5") {

        document.getElementById("trAppoint").style.display = '';
        document.getElementById("trprocess").style.display = 'none';
        document.getElementById("trincentive").style.display = 'none';

        var date = new Date(doc_appDate);
        var day = date.getDate();
        if (day < 10)
            day = '0' + day;
        var month = date.getMonth() + 1;
        if (month < 10)
            month = '0' + month;
        var year = date.getFullYear();
        var actualdate = year + "-" + (month) + "-" + (day);

        $("#empdoc_appoint").val(actualdate);
    }
    else {
        document.getElementById("empdoc_appoint").value = '';
        document.getElementById("trprocess").style.display = 'none';
        document.getElementById("trincentive").style.display = 'none';
        document.getElementById("trAppoint").style.display = 'none';
    }

    return false;
}

function getamount() {
    var ddl = document.getElementById("empdoc_process");
    var value = ddl.options[ddl.selectedIndex].value;
    if (value == "Loan Set-up") {
        document.getElementById("empdoc_incentive").value = "50000";
    }
    else if (value == "Credit Analyst") {
        document.getElementById("empdoc_incentive").value = "80000";
    }
    else if (value == "Compliance Analyst") {
        document.getElementById("empdoc_incentive").value = "80000";
    }
    else if (value == "Process Lead (QC)") {
        document.getElementById("empdoc_incentive").value = "100000";
    }
    else {
        document.getElementById("empdoc_incentive").value = "";
    }
}

function bindEmpInfoForDocs() {
    $.ajax({
        url: "GenerateEmpDocs.aspx/GetUserInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d || "[]");

            $.each(dataArray, function (index, value) {
                var code = blankForNull(value.Code);
                var fullName = [
                    blankForNull(value.FirstName),
                    blankForNull(value.MiddleName),
                    blankForNull(value.lastName)
                ].join(' ').replace(/\s+/g, ' ').trim();

                $('#empdoc_code').text(code);
                $('#empdoc_name').text(fullName);
                $('#empdoc_joining').text(blankForNull(value.JoiningDate));
                $('#empdoc_branch').text(blankForNull(value.WorkingBranchName));
                $('#empdoc_department').text(blankForNull(value.DepartmentName));
                $('#empdoc_designation').text(blankForNull(value.DesignationName));

                $('#empdoc_subdomain_hid').val(blankForNull(value.SubDomain));

                doc_appDate = blankForNull(value.AppointmentDate1);
            });
        },

        error: function (xhr) {
            alert('error: ' + xhr.responseText);
        }
    });
}

function empdoc_bindddl() {
    var code = '';
    var type = '';
    const urlParams = new URLSearchParams(window.location.search);
    var param = urlParams.toString().indexOf("Exists");
    if (param != -1) {
        code = urlParams.get('Exists');
        type = 'Exists';
    }
    else {
        param = urlParams.toString().indexOf("Dropout");
        if (param != -1) {
            code = urlParams.get('Dropout');
            type = 'Dropout';
        }
        else
            code = '';
    }
    if (code != '' && type == 'Exists') {
        $.ajax({
            url: "EmployeeDocuments.aspx/GetDropoutInformation",
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);//
                if (dataArray == null || dataArray == '') {
                    $("#empdoc_doctype").append($("<option></option>").val("").html("Select"));
                    $("#empdoc_doctype").append($("<option></option>").val("OfferLetter").html("Offer Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("AppointmentLetter").html("Appointment Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("ConfirmationLetter").html("Confirmation Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("IdemnityBond").html("Idemnity Bond"));
                    $("#empdoc_doctype").append($("<option></option>").val("AppendixA").html("Appendix A"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBond").html("Employee Agreement 3"));
                    $("#empdoc_doctype").append($("<option></option>").val("PromotionLetter").html("Promotion Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("SalaryRivisionLetter").html("Salary Revision Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("AddressVerificationLetter").html("Address Verification Letter"));
                    /*$("#empdoc_doctype").append($("<option></option>").val("SelfTransport").html("Self Transport Affidavit (Undertaking)"));*/
                    $("#empdoc_doctype").append($("<option></option>").val("Annexure").html("Annexure"));
                    $("#empdoc_doctype").append($("<option></option>").val("Account Transfer Letter").html("Account Transfer Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("Renewal Agreement").html("Renewal Agreement"));
                    $("#empdoc_doctype").append($("<option></option>").val("Psuedo Name").html("Psuedo Name"));
                    /*$("#empdoc_doctype").append($("<option></option>").val("Transfer Letter").html("Transfer Letter"));*/
                    $("#empdoc_doctype").append($("<option></option>").val("Addendum to the Employment Agreement - 2").html("Addendum 2"));
                    $("#empdoc_doctype").append($("<option></option>").val("Addendum to the Employment Agreement").html("Addendum 2.5"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst").html("Employee Agreement - Analyst"));
                    $("#empdoc_doctype").append($("<option></option>").val("ClientAcknowledgementLetterNew").html("Client Acknowledgement Letter"));
                    /*$("#empdoc_doctype").append($("<option></option>").val("ShowCauseNotice").html("Show Cause Notice"));*/
                    $("#empdoc_doctype").append($("<option></option>").val("JoiningDocumentsChecklist").html("Joining Documents Checklist"));
                    $("#empdoc_doctype").append($("<option></option>").val("PersonalDetailsForm").html("Personal Details Form"));
                    $("#empdoc_doctype").append($("<option></option>").val("BackgroundVerificationForm").html("Background Verification Form"));
                    $("#empdoc_doctype").append($("<option></option>").val("AppendixB").html("Appendix B"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBond4").html("Employee Agreement 4"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst4").html("Employee Agreement 4 - Analyst"));
                    $("#empdoc_doctype").append($("<option></option>").val("POSH Policy - Acknowledgement Form").html("POSH Policy - Acknowledgement Form"));
                    $("#empdoc_doctype").append($("<option></option>").val("POSH Policy Document").html("POSH Policy Document"));
                    $("#empdoc_doctype").append($("<option></option>").val("PF Declaration Form - 11 - 2017").html("PF Declaration Form - 11 - 2017"));
                    $("#empdoc_doctype").append($("<option></option>").val("PF Declaration Form - 11 - 2019").html("PF Declaration Form - 11 - 2019"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreement5").html("Employee Agreement 5"));
                    $("#empdoc_doctype").append($("<option></option>").val("EmployeeAgreementWithoutBondForExpAnalyst5").html("Employee Agreement 5 Analyst"));
                }
                else {
                    $("#empdoc_doctype").append($("<option></option>").val("").html("Select"));
                    $("#empdoc_doctype").append($("<option></option>").val("Relievingletter").html("Relieving Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("Experienceletter").html("Experience Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("ClientAcknowledgementLetterNew").html("Client Acknowledgement Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("NoDueCertificate").html("No Due Certificate"));
                    $("#empdoc_doctype").append($("<option></option>").val("ExitInterviewForm").html("Exit Interview Form"));
                    $("#empdoc_doctype").append($("<option></option>").val("UnderTakingLetterUnderwriter").html("UnderTaking Letter"));
                    $("#empdoc_doctype").append($("<option></option>").val("ExitChecklist").html("Exit Checklist"));
                    $("#empdoc_doctype").append($("<option></option>").val("ExitDocumentsChecklist").html("Exit Documents Checklist"));
                }
            },
            error: function (error) {
                alert('error; ' + eval(error));
                alert('error; ' + error.responseText);
            }
        });
    }
    else if (code != '' && type == 'Dropout') {
        $("#empdoc_doctype").append($("<option></option>").val("").html("Select"));
        $("#empdoc_doctype").append($("<option></option>").val("Relievingletter").html("Relieving Letter"));
        $("#empdoc_doctype").append($("<option></option>").val("Experienceletter").html("Experience Letter"));
        $("#empdoc_doctype").append($("<option></option>").val("ClientAcknowledgementLetterNew").html("Client Acknowledgement Letter"));
        $("#empdoc_doctype").append($("<option></option>").val("NoDueCertificate").html("No Due Certificate"));
        $("#empdoc_doctype").append($("<option></option>").val("ExitInterviewForm").html("Exit Interview Form"));
        $("#empdoc_doctype").append($("<option></option>").val("UnderTakingLetterUnderwriter").html("UnderTaking Letter"));
        $("#empdoc_doctype").append($("<option></option>").val("ExitChecklist").html("Exit Checklist"));
        $("#empdoc_doctype").append($("<option></option>").val("ExitDocumentsChecklist").html("Exit Documents Checklist"));
    }
}


/*------------ Appreciation and Desciplinary Actions ------------*/

function apprdesc_bindmastertable() {

    apprdesc_html = '';
    $.ajax({
        url: "AppreciationAndDisciplinaryActionMaster.aspx/GetAllAppreciationDisciplinary",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                apprdesc_html += '<tr>';
                apprdesc_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                apprdesc_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.actionformat) + '</td>';
                apprdesc_html += '<td style="text-wrap: wrap; ">' + blankForNull(value.Title) + '</td>';
                apprdesc_html += '<td style="text-wrap: wrap; ">' + blankForNull(value.Description) + '</td>';
                apprdesc_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.AddedByName) + '</td>';
                apprdesc_html += '<td style="text-wrap: nowrap; ">' + blankForNull(addeddate) + '</td>';
                apprdesc_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#apprdesc_table')) {
                apprdesc_table.destroy();
            }
            $('#apprdesc_table tbody').html(apprdesc_html);
            //else
            apprdesc_table = $('#apprdesc_table').DataTable({
                dom: 'tip',
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


            });


        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function apprdesc_submit() {
    var ddltype = document.getElementById("apprdesc_type");
    var type = ddltype.options[ddltype.selectedIndex].value;
    if (type == "") {
        alert("Please select type.");
        return false;
    }
    var title = document.getElementById("apprdesc_title").value;
    if (title == "") {
        alert("Please enter title.");
        return false;
    }
    var description = CKEDITOR.instances['apprdesc_description'].getData();
    if (description == "") {
        alert("Please enter description.");
        return false;
    }

    PageMethods.InsertAppreciationDesceplinaryAction(type, title, description, apprdesc_OnSuccess, apprdesc_OnError);
    return false;
}

function apprdesc_OnSuccess(result) {
    if (result > 0) {
        document.getElementById("apprdesc_errmsg").innerHTML = "Details added successfully!";
        $('#apprdesc_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("apprdesc_errmsg").innerHTML = "Oops! Error occured while adding details. Please contact administrator!";
        document.getElementById("apprdesc_errmsg").style.color = 'red';
        $('#apprdesc_dverror').modal('show');
        return false;
    }
    return false;
}

function apprdesc_OnError(error) {
    alert(error);
}

function setappr_BindUsers() {
    var select = document.getElementById("setappr_employee");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#setappr_employee").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "SetAppreciationDisciplinaryAction.aspx/GetAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#setappr_employee").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
            })
        }

    });
}

function setappr_getEmpInfo(ddlemp) {
    var code = ddlemp.options[ddlemp.selectedIndex].value;
    $.ajax({
        type: "POST", url: "SetAppreciationDisciplinaryAction.aspx/GetUserInformation", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                document.getElementById("setappr_empname").innerHTML = blankForNull(value.FullName);
                document.getElementById("setappr_joiningdate").innerHTML = blankForNull(value.JoiningDate);
                document.getElementById("setappr_department").innerHTML = blankForNull(value.DepartmentName);
                document.getElementById("setappr_designation").innerHTML = blankForNull(value.DesignationName);
                document.getElementById("setappr_repotingmanager").innerHTML = blankForNull(value.ReportingManager);
            })
        }

    });

}

function setappr_getApprTitle(ddltype) {
    var type = ddltype.options[ddltype.selectedIndex].value;
    var select = document.getElementById("setappr_title");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#setappr_title").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "SetAppreciationDisciplinaryAction.aspx/GetTypewiseTitle", dataType: "json", contentType: "application/json",
        data: "{Type:'" + type + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#setappr_title").append($("<option></option>").val(value.Title).html(value.Title));
            })
        }

    });

    document.getElementById("setappr_apprid").innerHTML = "";
    if (window.CKEDITOR && CKEDITOR.instances && CKEDITOR.instances['setappr_description']) {
        CKEDITOR.instances['setappr_description'].setData("");
    }

    if (type == "Appreciation" || type == "") {
        document.getElementById("setappr_trother").style.display = "none";
        $("#setappr_period").html('<option value="">Select</option>');
        document.getElementById("setappr_effectivedate").value = "";
    }
    else if (type == "DisciplinaryAction") {
        document.getElementById("setappr_trother").style.display = "";
        document.getElementById("setappr_tdperiodheader").style.display = "";
        document.getElementById("setappr_tdperiodrow").style.display = "";
        document.getElementById("setappr_tdeffectivedateheader").style.display = "none";
        document.getElementById("setappr_tdeffectivedaterow").style.display = "none";

        var select = document.getElementById("setappr_period");
        let options = select.getElementsByTagName('option');

        for (var i = options.length; i--;) {
            select.removeChild(options[i]);
        }
        $("#setappr_period").append($("<option></option>").val("").html("Select"));
        $("#setappr_period").append($("<option></option>").val("5").html("5 Days"));
        $("#setappr_period").append($("<option></option>").val("10").html("10 Days"));
        $("#setappr_period").append($("<option></option>").val("15").html("15 Days"));
        $("#setappr_period").append($("<option></option>").val("20").html("20 Days"));
        $("#setappr_period").append($("<option></option>").val("25").html("25 Days"));
        $("#setappr_period").append($("<option></option>").val("30").html("30 Days"));
    }
    else if (type == "PerformanceImprovementPlan") {
        document.getElementById("setappr_trother").style.display = "";
        document.getElementById("setappr_tdperiodheader").style.display = "";
        document.getElementById("setappr_tdperiodrow").style.display = "";
        document.getElementById("setappr_tdeffectivedateheader").style.display = "";
        document.getElementById("setappr_tdeffectivedaterow").style.display = "";

        var select = document.getElementById("setappr_period");
        let options = select.getElementsByTagName('option');

        for (var i = options.length; i--;) {
            select.removeChild(options[i]);
        }
        $("#setappr_period").append($("<option></option>").val("").html("Select"));
        $("#setappr_period").append($("<option></option>").val("1 Week").html("1 Week"));
        $("#setappr_period").append($("<option></option>").val("2 Weeks").html("2 Weeks"));
        $("#setappr_period").append($("<option></option>").val("3 Weeks").html("3 Weeks"));
        $("#setappr_period").append($("<option></option>").val("4 Weeks").html("4 Weeks"));
    }
}

function setappr_getApprDesc(ddltitle) {
    var title = ddltitle.options[ddltitle.selectedIndex].value;
    var ddltype = document.getElementById("setappr_type");
    var type = ddltype.options[ddltype.selectedIndex].value;
    $.ajax({
        type: "POST", url: "SetAppreciationDisciplinaryAction.aspx/GetTypeandTitlewiseDescription", dataType: "json", contentType: "application/json",
        data: "{Type:'" + type + "', Title:'" + title + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                if (window.CKEDITOR && CKEDITOR.instances && CKEDITOR.instances['setappr_description']) {
                    CKEDITOR.instances['setappr_description'].setData(blankForNull(value.DesignDescription));
                } else {
                    $("#setappr_description").val(blankForNull(value.DesignDescription));
                }
                document.getElementById("setappr_apprid").innerHTML = blankForNull(value.AppreciationDisciplinaryID);
            })
        }

    });
}

function setappr_selectedValue(id) {
    var element = document.getElementById(id);
    if (!element || element.selectedIndex < 0 || !element.options[element.selectedIndex]) {
        return "";
    }
    return element.options[element.selectedIndex].value;
}

function setappr_editorData() {
    if (window.CKEDITOR && CKEDITOR.instances && CKEDITOR.instances['setappr_description']) {
        return CKEDITOR.instances['setappr_description'].getData();
    }
    return $("#setappr_description").val() || "";
}

function setappr_showMessage(message, isError, reloadOnClose) {
    var button = $("#setappr_btnMessage");
    $("#setappr_errmsg")
        .html(message)
        .css("color", isError ? "#fee2e2" : "#fff");

    button.off("click").on("click", function () {
        $("#setappr_dverror").modal("hide");
        if (reloadOnClose) {
            location.reload();
        }
    });

    $("#setappr_dverror").modal("show");
}

function setappr_subject(type, title) {
    if (type === "DisciplinaryAction") {
        return "Warning: " + title;
    }
    if (type === "PerformanceImprovementPlan") {
        return "Performance Improvement Plan: " + title;
    }
    return "Appreciation: " + title;
}

function setappr_formatDate(value) {
    var text = blankForNull(value);
    var match;
    var date;

    if (!text) {
        return "";
    }

    match = /\/Date\((-?\d+)\)\//.exec(text);
    if (match) {
        date = new Date(parseInt(match[1], 10));
    } else {
        date = new Date(text);
    }

    if (isNaN(date.getTime())) {
        return text;
    }

    return date.toLocaleDateString("en-US");
}

function setappr_detailHash(type) {
    if (type === "DisciplinaryAction") {
        return "#tab-disciplinary";
    }
    if (type === "PerformanceImprovementPlan") {
        return "#tab-pip";
    }
    return "#tab-appreciation";
}

function setappr_countLink(employeeId, type, count) {
    var id = parseInt(blankForNull(employeeId), 10) || 0;
    return '<a href="#!" onclick="return setappr_binddetailsbyType(' + id + ',\'' + type + '\');">' + blankForNull(count) + '</a>';
}

function setappr_validateAction(requireDescription) {
    var employee = setappr_selectedValue("setappr_employee");
    var type = setappr_selectedValue("setappr_type");
    var title = setappr_selectedValue("setappr_title");
    var period = setappr_selectedValue("setappr_period");
    var description = setappr_editorData();

    if (!employee) {
        setappr_showMessage("Please select employee.", true, false);
        $("#setappr_employee").focus();
        return false;
    }
    if (!type) {
        setappr_showMessage("Please select type.", true, false);
        $("#setappr_type").focus();
        return false;
    }
    if (!title) {
        setappr_showMessage("Please select title.", true, false);
        $("#setappr_title").focus();
        return false;
    }
    if (type !== "Appreciation" && !period) {
        setappr_showMessage("Please select period.", true, false);
        $("#setappr_period").focus();
        return false;
    }
    if (requireDescription && !$.trim($("<div>").html(description).text())) {
        setappr_showMessage("Please enter description.", true, false);
        return false;
    }

    return true;
}

function setappr_preview() {
    var title;
    var type;

    if (!setappr_validateAction(true)) {
        return false;
    }

    title = setappr_selectedValue("setappr_title");
    type = setappr_selectedValue("setappr_type");

    document.getElementById("setappr_popname").innerHTML = document.getElementById("setappr_empname").innerHTML;
    document.getElementById("setappr_popdoj").innerHTML = document.getElementById("setappr_joiningdate").innerHTML;
    document.getElementById("setappr_popsubject").innerHTML = setappr_subject(type, title);
    document.getElementById("setappr_popdesc").innerHTML = setappr_editorData();
    document.getElementById("setappr_popdate").innerHTML = new Date().toLocaleDateString("en-US");
    $("#setappr_previewpop").modal("show");
    return false;
}

function setappr_submit() {
    var empid;
    var title;
    var type;
    var period;
    var apprdescID;
    var editor;

    if (!setappr_validateAction(true)) {
        return false;
    }

    empid = setappr_selectedValue("setappr_employee");
    title = setappr_selectedValue("setappr_title");
    type = setappr_selectedValue("setappr_type");
    period = type === "Appreciation" ? "" : setappr_selectedValue("setappr_period");
    apprdescID = document.getElementById("setappr_apprid").innerHTML;
    editor = setappr_editorData();

    $('#waitingpanel').modal('show');
    PageMethods.SetAppreciationDescAction(empid, apprdescID, editor, title, type, period, setappr_sub_OnSuccess, setappr_sub_OnError);
    return false;
}

function setappr_sub_OnSuccess(result) {
    $('#waitingpanel').modal('hide');
    if (result > 0) {
        setappr_showMessage("Record added successfully.", false, true);
    }
    else {
        setappr_showMessage("Oops! Error occurred while sending notification.<br />Please contact administrator.", true, false);
    }
    return false;
}

function setappr_sub_OnError(error) {
    $('#waitingpanel').modal('hide');
    setappr_showMessage("Oops! Error occurred while saving details.<br />Please contact administrator.", true, false);
}

function setappr_resetFilters() {
    $("#filterYear").html('<option value="">All Years</option>').off("change");
    $("#filterMonth").html('<option value="">All Months</option>').off("change");
    $("#filterLocation").html('<option value="">All Locations</option>').off("change");
    $("#filterDepartment").html('<option value="">All Departments</option>').off("change");
}

function setappr_bindFilters(table, hasMonthYear) {
    var locationColumn = table.column(4);
    var departmentColumn = table.column(5);

    locationColumn.data().unique().sort().each(function (d) {
        if (blankForNull(d)) {
            $('#filterLocation').append('<option value="' + blankForNull(d) + '">' + blankForNull(d) + '</option>');
        }
    });

    departmentColumn.data().unique().sort().each(function (d) {
        if (blankForNull(d)) {
            $('#filterDepartment').append('<option value="' + blankForNull(d) + '">' + blankForNull(d) + '</option>');
        }
    });

    if (hasMonthYear) {
        var years = table.column(8).data().unique().toArray().sort().reverse();
        var months = [];

        $.each(years, function (i, d) {
            if (blankForNull(d)) {
                $('#filterYear').append('<option value="' + blankForNull(d) + '">' + blankForNull(d) + '</option>');
            }
        });

        table.column(7).data().unique().each(function (d) {
            if (blankForNull(d)) {
                months.push(d);
            }
        });

        months.sort(function (a, b) {
            return new Date(Date.parse(a + " 1, 2012")) - new Date(Date.parse(b + " 1, 2012"));
        });

        $.each(months, function (i, m) {
            $('#filterMonth').append('<option value="' + blankForNull(m) + '">' + blankForNull(m) + '</option>');
        });
    }

    $('#filterLocation').on('change', function () {
        table.column(4).search(this.value).draw();
    });

    $('#filterDepartment').on('change', function () {
        table.column(5).search(this.value).draw();
    });

    if (hasMonthYear) {
        $('#filterMonth').on('change', function () {
            table.column(7).search(this.value).draw();
        });

        $('#filterYear').on('change', function () {
            table.column(8).search(this.value).draw();
        });
    }
}

function setappr_renderGridRows(dataArray, includeMonthYear) {
    var html = '';

    $.each(dataArray, function (index, value) {
        html += '<tr>';
        html += '<td>' + blankForNull(value.Code) + '</td>';
        html += '<td>' + blankForNull(value.Name) + '</td>';
        html += '<td>' + blankForNull(value.JoiningDate) + '</td>';
        html += '<td>' + blankForNull(value.BranchName) + '</td>';
        html += '<td>' + blankForNull(value.DepartmentName) + '</td>';
        html += '<td>' + blankForNull(value.DesignationName) + '</td>';
        html += '<td>' + blankForNull(value.ReportingManager) + '</td>';

        if (includeMonthYear) {
            html += '<td>' + blankForNull(value.ActionMonth) + '</td>';
            html += '<td>' + blankForNull(value.ActionYear) + '</td>';
        }

        html += '<td class="text-center">' + setappr_countLink(value.EmployeeID, 'Appreciation', value.Appreciation) + '</td>';
        html += '<td class="text-center">' + setappr_countLink(value.EmployeeID, 'DisciplinaryAction', value.Warnings) + '</td>';
        html += '<td class="text-center">' + setappr_countLink(value.EmployeeID, 'PerformanceImprovementPlan', value.PIP) + '</td>';
        html += '</tr>';
    });

    return html;
}

function setappr_initTable(hasMonthYear) {
    setappr_gr_table = $('#setappr_gr_table').DataTable({
        dom: 'ftip',
        scrollX: true,
        destroy: true,
        paging: true,
        autoWidth: false,
        select: true,
        ordering: false,
        processing: true,
        select: {
            style: 'single'
        },
        initComplete: function () {
            var tableApi = this.api();
            setappr_gr_table = tableApi;
            setappr_resetFilters();
            setappr_bindFilters(tableApi, hasMonthYear);
            $('#load1').hide();
        }
    });
}

function setappr_bindgrid() {
    $('#load1').show();

    $.ajax({
        url: "SetAppreciationDisciplinaryAction.aspx/GetAllAppreciationWarningsRecords",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if ($.fn.dataTable.isDataTable('#setappr_gr_table')) {
                $('#setappr_gr_table').DataTable().clear().destroy();
            }

            $('#setappr_gr_table tbody').empty();
            $('#setappr_gr_table tbody').html(setappr_renderGridRows(dataArray, true));
            setappr_initTable(true);
        },
        error: function (error) {
            $('#load1').hide();
            setappr_showMessage('Unable to load action details.', true, false);
        }
    });
    return false;
}

function setappr_bindgrid_core() {
    $('#load1').show();

    $.ajax({
        url: "SetAppreciationDisciplinaryAction.aspx/GetAllAppreciationWarningsRecords",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if ($.fn.dataTable.isDataTable('#setappr_gr_table')) {
                $('#setappr_gr_table').DataTable().clear().destroy();
            }

            $('#setappr_gr_table tbody').empty();
            $('#setappr_gr_table tbody').html(setappr_renderGridRows(dataArray, true));
            setappr_initTable(true);
        },
        error: function (error) {
            $('#load1').hide();
            setappr_showMessage('Unable to load action details.', true, false);
        }
    });
    return false;
}

function setappr_slideHtml(value) {
    var addedDate = setappr_formatDate(value.AddedDate);

    return '' +
        '<div class="setappr-slide-card">' +
        '  <div class="setappr-slide-meta">' +
        '    <div>' +
        '      <div><b>Name:</b> ' + blankForNull(value.Name) + '</div>' +
        '      <div><b>Joining Date:</b> ' + blankForNull(value.JoiningDate) + '</div>' +
        '      <div><b>Location:</b> ' + blankForNull(value.BranchName) + '</div>' +
        '    </div>' +
        '    <div class="setappr-slide-date"><b>Date:</b> ' + blankForNull(addedDate) + '</div>' +
        '  </div>' +
        '  <div class="setappr-slide-subject"><h5>' + blankForNull(value.Title) + '</h5></div>' +
        '  <div class="setappr-slide-content"><label>' + blankForNull(value.Description) + '</label></div>' +
        '</div>';
}

function setappr_binddetailsbyType(empid, type) {
    var carouselId = "setapprActionCarousel";
    var headerText = setappr_subject(type, "Details");
    var modifyHref = "UsersAppreciationDisplinaryAction.aspx?EmployeeID=" + blankForNull(empid) + setappr_detailHash(type);

    $('#load1').show();
    $("#dvslidermain").html("");
    $("#setappr_detailsheader").html('<i class="fas fa-copy"></i>' + headerText);
    $("#setappr_openmodify").attr("href", modifyHref).show();

    $.ajax({
        url: "SetAppreciationDisciplinaryAction.aspx/GetAllAppreciationWarningsByType",
        type: "POST",
        dataType: "json",
        data: JSON.stringify({ EmployeeID: empid, Type: type }),
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            var html = '';
            var indicators = '';
            var slides = '';

            $('#load1').hide();

            if (!dataArray.length) {
                $("#dvslidermain").html('<div class="setappr-empty-state"><i class="fas fa-inbox"></i><br />No records found.</div>');
                $("#setappr_viewdetails").modal('show');
                return;
            }

            $.each(dataArray, function (index, value) {
                indicators += '<li data-target="#' + carouselId + '" data-slide-to="' + index + '"' + (index === 0 ? ' class="active"' : '') + '></li>';
                slides += '<div class="carousel-item' + (index === 0 ? ' active' : '') + '">' + setappr_slideHtml(value) + '</div>';
            });

            html += '<div id="' + carouselId + '" class="carousel slide" data-ride="carousel" data-interval="false">';
            if (dataArray.length > 1) {
                html += '<ol class="carousel-indicators">' + indicators + '</ol>';
            }
            html += '<div class="carousel-inner" role="listbox">' + slides + '</div>';
            if (dataArray.length > 1) {
                html += '<a class="carousel-control-prev" href="#' + carouselId + '" role="button" data-slide="prev"><span class="carousel-control-prev-icon" aria-hidden="true"></span></a>';
                html += '<a class="carousel-control-next" href="#' + carouselId + '" role="button" data-slide="next"><span class="carousel-control-next-icon" aria-hidden="true"></span></a>';
            }
            html += '</div>';

            $("#dvslidermain").html(html);
            $("#" + carouselId).carousel({ interval: false, ride: false });
            $("#setappr_viewdetails").modal('show');
        },
        error: function (error) {
            $('#load1').hide();
            setappr_showMessage('Unable to load selected details.', true, false);
        }
    });
    return false;
}


/*-------------------  Project Configuration -------------------*/

function projectconf_binddomaingroups() {
    var select = document.getElementById("projectconf_domain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#projectconf_domain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ProjectConfiguration.aspx/GetAllDomainGroups", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#projectconf_domain").append($("<option></option>").val(value.DomainGroupId).html(value.DomainGroupName));
            })
        }

    });
}

function projectconf_domainchange() {
    var select = document.getElementById("projectconf_subdomain");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var ddlDomain = document.getElementById('projectconf_domain');
    var index = ddlDomain.selectedIndex;
    var DomainGroupId = ddlDomain.options[index].value;
    $("#projectconf_subdomain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "ProjectConfiguration.aspx/GetSubdomains", dataType: "json", contentType: "application/json",
        data: "{DomainGroupId:" + DomainGroupId + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                $("#projectconf_subdomain").append($("<option></option>").val(value.SubdomainID).html(value.SubdomainName));
            })
        }
    });
    return false;
}


/*------------------- POSH Test -------------------*/

function posh_BindTest() {

    $('#load1').show();
    var Current;
    var Prev;
    $.ajax({
        type: "POST", url: "PoshTest.aspx/GetPoshQuestions", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            var index = 0;
            var questionno = 1;
            var dvmain = document.getElementById("dvposhtest");
            var dvHeader;
            $.each(dataArray, function (data, value) {
                Current = blankForNull(value.Section);
                if (index == 0 || Current != Prev) {
                    dvHeader = document.createElement("div");
                    dvHeader.classList.add("col-12");
                    dvHeader.classList.add("col-md");
                    var h4 = document.createElement("h5");
                    h4.innerHTML = blankForNull(value.Section);
                    if (index > 0)
                        h4.style.paddingTop = "20px";
                    dvHeader.appendChild(h4);
                    var hr = document.createElement("hr");
                    dvHeader.appendChild(hr);

                    if (questionno == 19) {
                        var p1 = document.createElement("p");
                        p1.innerHTML = "<h6>Read the following case and answer the questions below:</h6>";
                        dvHeader.appendChild(p1);
                        var p2 = document.createElement("p");
                        p2.innerHTML = "<h6><b>Case:</b> A colleague regularly makes inappropriate comments about your appearance and shares sexually suggestive memes via email.You have politely told them to stop, but the behavior continues.</h6><br />";
                        dvHeader.appendChild(p2);
                    }

                    var p = document.createElement("h6");
                    p.innerHTML = questionno + ": " + blankForNull(value.Question);
                    p.style.marginLeft = "5%";
                    p.classList.add("mb-2");
                    p.classList.add("mt-0");
                    p.classList.add("text-body-primary");
                    p.classList.add("fs-0");
                    dvHeader.appendChild(p);
                    questionno++;

                    var select = document.createElement("select");
                    select.id = "option_" + blankForNull(value.QuestionID);
                    select.style.width = "300px";
                    select.style.marginLeft = "5%";
                    select.classList.add("form-control");
                    var option = document.createElement("option");
                    option.value = "";
                    option.textContent = "Select";
                    select.appendChild(option);
                    if (blankForNull(value.Option1) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option1);
                        option.textContent = blankForNull(value.Option1);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option2) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option2);
                        option.textContent = blankForNull(value.Option2);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option3) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option3);
                        option.textContent = blankForNull(value.Option3);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option4) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option4);
                        option.textContent = blankForNull(value.Option4);
                        select.appendChild(option);
                    }
                    dvHeader.appendChild(select);
                    dvmain.appendChild(dvHeader);
                }
                else {
                    var p = document.createElement("h6");
                    p.innerHTML = questionno + ": " + blankForNull(value.Question);
                    p.style.marginLeft = "5%";
                    p.style.paddingTop = "20px";
                    p.classList.add("mb-2");
                    p.classList.add("mt-0");
                    p.classList.add("text-body-primary");
                    p.classList.add("fs-0");
                    dvHeader.appendChild(p);
                    questionno++;

                    var select = document.createElement("select");
                    select.id = "option_" + blankForNull(value.QuestionID);
                    select.style.width = "300px";
                    select.style.marginLeft = "5%";
                    select.classList.add("form-control");
                    var option = document.createElement("option");
                    option.value = "";
                    option.textContent = "Select";
                    select.appendChild(option);
                    if (blankForNull(value.Option1) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option1);
                        option.textContent = blankForNull(value.Option1);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option2) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option2);
                        option.textContent = blankForNull(value.Option2);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option3) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option3);
                        option.textContent = blankForNull(value.Option3);
                        select.appendChild(option);
                    }
                    if (blankForNull(value.Option4) != "") {
                        option = document.createElement("option");
                        option.value = blankForNull(value.Option4);
                        option.textContent = blankForNull(value.Option4);
                        select.appendChild(option);
                    }
                    dvHeader.appendChild(select);
                    dvmain.appendChild(dvHeader);
                }

                Prev = Current;
                index++;

            })
            var btn = document.createElement("button");
            btn.id = "posh_btnsubmit";
            btn.classList.add("btn");
            btn.classList.add("btn-primary");
            btn.style.marginLeft = "50%";
            btn.setAttribute("onclick", "return posh_submit();");
            btn.innerHTML = "Submit";
            dvmain.appendChild(btn);
        }

    });
    $('#load1').hide();
}

function posh_submit() {

    var params = "";
    var parameters = "";
    $.ajax({
        type: "POST", url: "PoshTest.aspx/GetPoshQuestions", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            var index = 0;
            var questionno = 1;

            $.each(dataArray, function (data, value) {
                var control = document.getElementById("option_" + blankForNull(value.QuestionID));
                var id = control.id;
                var value = control.options[control.selectedIndex].value;
                params = id + '~' + value;
                parameters = parameters + ':' + params;
                if (value == "") {
                    alert("All questions are mandatory. Please fill Question #" + questionno);
                    parameters = "";
                    document.getElementById("option_" + blankForNull(value.QuestionID)).focus();
                    return false;
                }
                questionno++;

            })
            if (parameters != "") {
                $('#waitingpanel').modal('show');
                PageMethods.InsertPoshTest(parameters, poshtest_OnSuccess, poshtest_OnError);
            }
        }
    });

    return false;
}

function poshtest_OnSuccess(result) {

    $('#waitingpanel').modal('hide');
    if (result > 0) {
        document.getElementById("posh_errmsg").innerHTML = "Induction test submitted succesfully.!";
        $('#posh_dverror').modal('show');
        return false;
    }
    else {
        document.getElementById("posh_errmsg").innerHTML = "Oops! Error occured while submitting indeuction test. <br /> Please contact administrator!";
        document.getElementById("posh_errmsg").style.color = 'red';
        $('#posh_dverror').modal('show');
        return false;
    }
}

function poshtest_OnError(error) {

    alert(error);
}

function posh_Message() {

    $('#posh_dverror').modal('hide');
    $.ajax({
        type: "POST", url: "PoshTest.aspx/GetPoshTestResult", dataType: "json", contentType: "application/json",
        success: function (data) {
            var dataArray1 = JSON.parse(data.d);
            $.each(dataArray1, function (data1, value1) {
                if (value1.Result == "Pass")
                    location.href = "DashboardEmployee.aspx";
                if (value1.Result == "Fail") {
                    document.getElementById("dvposhtest").innerHTML = "<h5>You have successfully completed test. Please check your result below.<br /><br />Marks:&nbsp;" + value1.Marks + " &nbsp;&nbsp;&nbsp;&nbsp;Result:&nbsp;" + value1.Result + "</h5>";
                    document.getElementById("dvposhtest").innerHTML += "<br /><h5>Please <a style='font-style:italic;' href='#url' onclick='return posh_setretest();'>click here</a> for one more attempt.<h5>";
                }
            });
        }
    });
}

function posh_setretest() {
    PageMethods.SetPoshRetest(poshretest_OnSuccess, poshretest_OnError);
    return false;
}

function poshretest_OnSuccess(result) {
    ChekIfPoshTestExists();
    return false;
}

function poshretest_OnError(error) {
    alert(error);
}

function posh_setretestvideo() {
    PageMethods.SetPoshRetest(poshretestvideo_OnSuccess, poshretestvideo_OnError);
    return false;
}

function poshretestvideo_OnSuccess(result) {
    location.href = "POSHVideo.aspx";
    return false;
}

function poshretestvideo_OnError(error) {
    alert(error);
}

function ChekIfPoshTestExists() {

    $.ajax({
        type: "POST", url: "PoshTest.aspx/GetExistanceOfPoshTest", dataType: "json", contentType: "application/json",

        success: function (res) {
            var dataArray = JSON.parse(res.d);
            var index = 0;
            var questionno = 1;
            if (dataArray == null || dataArray == '') {

                $.ajax({
                    type: "POST", url: "PoshTest.aspx/GetPoshTestResult", dataType: "json", contentType: "application/json",

                    success: function (data) {

                        var dataArray1 = JSON.parse(data.d);

                        $.each(dataArray1, function (data1, value1) {
                            document.getElementById("dvposhtest").innerHTML = "<h5>You have successfully completed test. Please check your result below.<br /><br />Marks:&nbsp;" + value1.Marks + " &nbsp;&nbsp;&nbsp;&nbsp;Result:&nbsp;" + value1.Result + "</h5>";
                            if (value1.Result == "Fail")
                                document.getElementById("dvposhtest").innerHTML += "<br /><h5>Please <a style='font-style:italic;' href='#url' onclick='return posh_setretestvideo();'>click here</a> to watch the video again, or <a style='font-style:italic;' href='#url' onclick='return posh_setretest();'>click here</a> to skip it and reattempt the test.<h5>";
                        });
                    }
                });
            }
            else {
                document.getElementById("dvposhtest").innerHTML = "";
                // $.each(dataArray, function (data, value) {
                posh_BindTest();
                // })
            }
        }
    });

}

function poshvi_Message() {
    location.href = "PoshTest.aspx";
}


/*------------- POSH Test Result ------------- */

function poshtestres_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("poshtestres_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#poshtestres_year").append($("<option></option>").val("Select").html("Select"));
    for (var i = start; i > start - 15; i--) {
        $("#poshtestres_year").append($("<option></option>").val(i).html(i));
    }
}

function poshtestres_submit() {
    var ddlmonth = document.getElementById("poshtestres_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("poshtestres_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    if (month == "") {
        alert("Please select Month");
        return false;
    }
    if (year == "") {
        alert("Please select Year");
        return false;
    }

    bind_poshtestSummary(month, year);

    $('#load1').show();
    poshtestres_html = '';
    $.ajax({
        url: "PoshTestResult.aspx/getPoshTestReport",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "',Year:'" + year + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                poshtestres_html += '<tr>';
                poshtestres_html += '<td style="display:none;">' + value.EmployeeID + '</td>';

                if (value.Status == "Completed")
                    poshtestres_html += '<td style="text-align:center;"><a class="dropdown-item" href="#!" id="Actions" onclick="poshtestres_paper_showanswersheet(' + value.EmployeeID + ',' + index + ');" title="Show Answer Sheet"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file-check" style="font-size:16px;"></i></span></a></td>';
                else
                    poshtestres_html += '<td style="text-align:center;"><a class="dropdown-item isDisabled" href="#!" id="Actions" onclick="poshtestres_paper_showanswersheet(' + value.EmployeeID + ',' + index + ');" title="Show Answer Sheet"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-file-check" style="font-size:16px;"></i></span></a></td>';

                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Name) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.JoiningDate) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TestStatus) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TestDate) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Marks) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Result) + '</td>';
                poshtestres_html += '<td style="text-wrap: nowrap; display:none;"><a href="#url">View Result</a></td>';
                poshtestres_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#poshtestres_table')) {
                poshtestres_table.destroy();
            }
            $('#poshtestres_table tbody').html(poshtestres_html);
            //else
            poshtestres_table = $('#poshtestres_table').DataTable({
                dom: 'Bftip',
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
                        extend: 'excelHtml5', title: 'POSH Test Result Report', autoFilter: true,
                        exportOptions: {
                            columns: [1, 2, 3, 4, 5, 6, 7, 8],
                        }
                    },
                ],
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function poshtestres_paper_showanswersheet(EmpID, index) {

    location.href = 'POSHAnswerSheet.aspx?EmpID=' + EmpID;
}

function posh_ans_BindGrid() {

    var title = "POSH Answer Sheet";

    const urlParams = new URLSearchParams(window.location.search);
    const EmpID = urlParams.get('EmpID');


    if (EmpID != '') {
        $('#load1').show();

        posh_ans_html = '';
        $.ajax({
            url: "POSHAnswerSheet.aspx/GetPoshAnswerSheet",
            type: "POST",
            data: "{EmpID:" + EmpID + "}",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var dataArray = JSON.parse(data.d);

                var TotalMarks = 0;
                var ObtainMark = 0;

                $.each(dataArray, function (index, value) {

                    posh_ans_html += '<tr>';
                    posh_ans_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                    posh_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Section) + '</td>';
                    posh_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Question) + '</td>';
                    posh_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Answer) + '</td>';
                    posh_ans_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.CorrectAnswer) + '</td>';
                    posh_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Weightage) + '</td>';
                    posh_ans_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.ObtainMarks) + '</td>';
                    posh_ans_html += '</tr>';

                    TotalMarks = parseInt(value.Weightage) + TotalMarks;
                    ObtainMark = parseInt(value.ObtainMarks) + ObtainMark;

                    document.getElementById("posh_ans_marks").innerHTML = "<b>Obtain Marks : </b>" + ObtainMark + " / " + TotalMarks;
                    document.getElementById("posh_ans_name").innerHTML = "<b>Employee Name : </b>" + blankForNull(value.EmpName);
                    document.getElementById("posh_ans_examdate").innerHTML = "<b>Exam Date : </b>" + blankForNull(value.ExamDate);
                });


                if (parseInt(ObtainMark) >= 35) {
                    document.getElementById("posh_answer_result").innerHTML = "Result : PASS";
                    document.getElementById("posh_answer_result").style.color = "green";
                    document.getElementById("posh_answer_result").style.font.bold = true;
                }
                else if (parseInt(ObtainMark) < 35 && parseInt(ObtainMark) > 0) {
                    document.getElementById("posh_answer_result").innerHTML = "Result : FAIL";
                    document.getElementById("posh_answer_result").style.color = "red";
                    document.getElementById("posh_answer_result").style.font.bold = true;
                }
                else {
                    document.getElementById("posh_answer_result").innerHTML = "Result : Test Pending";
                    document.getElementById("posh_answer_result").style.color = "black";
                    document.getElementById("posh_answer_result").style.font.bold = true;
                }

                if ($.fn.dataTable.isDataTable('#table_posh_ans')) {
                    posh_ans_table.destroy();
                }
                $('#table_posh_ans tbody').html(posh_ans_html);
                //else
                posh_ans_table = $('#table_posh_ans').DataTable({
                    dom: 't',
                    destroy: true,
                    scrollX: true,
                    "paging": false,
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

                    footerCallback: function (row, data, start, end, display) {
                        let api = this.api();

                        // Remove the formatting to get integer data for summation
                        let intVal = function (i) {
                            return typeof i === 'string' ? i.replace(/[\$,]/g, '') * 1 : typeof i === 'number' ? i : 0;
                        };

                        // Total over all pages
                        totalLoan = api.column(5).data().reduce((a, b) => intVal(a) + intVal(b), 0);
                        totalAmt = api.column(6).data().reduce((a, b) => intVal(a) + intVal(b), 0);

                        // Total over this page

                        // Update footer
                        api.column(5).footer().innerHTML = Number(totalLoan).toFixed(2);
                        api.column(6).footer().innerHTML = Number(totalAmt).toFixed(2);
                    },

                    //buttons: [
                    //    {
                    //        extend: 'excelHtml5', title: title, autoFilter: true,
                    //        exportOptions: {
                    //            columns: [0, 1, 2, 3],
                    //        }
                    //    },
                    //],
                });
            },
            error: function (error) {
                alert('error; ' + eval(error));
                alert('error; ' + error.responseText);
            }
        });
    }
    return false;
}

function bind_poshtestSummary(Month, Year) {

    $('#load1').show();
    poshtestSummary_html = '';
    $.ajax({
        url: "PoshTestResult.aspx/GetPOSHDataForSummary_MonthWise",
        data: "{Month:'" + Month + "', Year:'" + Year + "'}",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                poshtestSummary_html += '<tr>';
                poshtestSummary_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                poshtestSummary_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.BranchName) + '</td>';
                poshtestSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Total) + '</td>';
                poshtestSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Completed) + '</td>';
                poshtestSummary_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Pending) + '</td>';
                poshtestSummary_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_poshtestSummary')) {
                poshtestSummary_table.destroy();
            }
            $('#table_poshtestSummary tbody').html(poshtestSummary_html);
            poshtestSummary_table = $('#table_poshtestSummary').DataTable({
                dom: 'fti',
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
            });

        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


/*----------- Underwriting Test Result ----------- */

function cruw_send_Submit() {
    var fromdate = document.getElementById("cruw_send_from").value;
    var todate = document.getElementById("cruw_send_to").value;

    if (fromdate == "") {
        alert("Please select from date");
        return false;
    }
    if (todate == "") {
        alert("Please select to date");
        return false;
    }
    $('#load1').show();
    cruw_send_html = '';
    $.ajax({
        url: "UnderwritingTestModule.aspx/GetCredit_UWCandidateForSendMail",
        type: "POST",
        data: "{FromDate:'" + fromdate + "', ToDate:'" + todate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                cruw_send_html += '<tr>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(index + 1) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:center;"><input type="checkbox" class="custom-checkbox" id="chk' + blankForNull(value.AppID) + '"></td>';
                cruw_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.AppID) + '</td>';
                cruw_send_html += '<td style="text-wrap: wrap; text-align:left;">' + blankForNull(value.Name) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Position) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.EmailID) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.CellPhoneNo) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.Result) + '</td>';
                cruw_send_html += '<td style="text-wrap: nowrap; text-align:left;">' + blankForNull(value.MarksObtained) + '</td>';
                cruw_send_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#cruw_send_table')) {
                cruw_send_table.destroy();
            }
            $('#cruw_send_table tbody').html(cruw_send_html);
            //else
            cruw_send_table = $('#cruw_send_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                "paging": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                    $("#cruw_table").wrap("<div style='overflow:auto; width:100%;position:relative;'></div>");

                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Credit Test Candidates', autoFilter: true,
                        exportOptions: {
                            columns: [0, 2, 3, 4, 5, 6, 7, 8],
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


// Worked Holiday

function wholiday_bindgrid() {

    $('#load1').show();

    $.ajax({
        url: "WorkedHolidays.aspx/GetAllEmployeeWorkedHoliday",
        type: "POST",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (response) {

            let dataArray = [];

            try {
                dataArray = response.d ? JSON.parse(response.d) : [];
            } catch (e) {
                $('#load1').hide();

                Swal.fire({
                    icon: "error",
                    title: "Invalid Data",
                    text: "Server returned invalid JSON data."
                });

                console.error(e);
                return;
            }

            if ($.fn.DataTable.isDataTable('#wholidays_table')) {
                $('#wholidays_table').DataTable().clear().destroy();
            }

            $('#wholidays_table tbody').empty();

            $('#wholidays_table').DataTable({
                dom: 'ftip',
                data: dataArray,
                destroy: true,
                deferRender: true,
                processing: true,
                paging: true,
                pageLength: 25,
                lengthMenu: [[25, 50, 100], [25, 50, 100]],

                ordering: false,
                searching: true,
                autoWidth: false,
                fixedHeader: false,

                columns: [
                    {
                        data: null,
                        width: "45px",
                        orderable: false,
                        className: "text-center",
                        render: function (data, type, row, meta) {
                            return `
                                <a href="#!" title="View Worked Holiday Details"
                                   onclick="wholiday_showpopup('${meta.row}')">
                                    <i class="uil uil-search" style="color:dodgerblue;"></i>
                                </a>`;
                        }
                    },
                    { data: 'Code', defaultContent: '' },
                    { data: 'FullName', defaultContent: '' },
                    { data: 'Branch', defaultContent: '' },
                    { data: 'Days', defaultContent: '' },
                    { data: 'ReportingManager', defaultContent: '' }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {
            $('#load1').hide();

            Swal.fire({
                icon: "error",
                title: "Loading Failed",
                text: "Something went wrong while loading worked holiday data."
            });

            console.error(xhr.responseText);
        }
    });

    return false;
}

function wholiday_showpopup(index) {

    var rows = $('#wholidays_table').DataTable().row(index).data();
    document.getElementById("wholiday_popup_name").innerHTML = rows.Code + ' : ' + rows.FullName;

    $('#load1').show();
    $.ajax({
        url: "WorkedHolidays.aspx/GetWorkedHolidayLogDetails",
        type: "POST",
        dataType: "json",
        data: "{Code:'" + rows.Code + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $('#wholiday_logdetails').DataTable({
                dom: 't',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: '' },
                    { data: 'date' },
                    { data: 'In_Time' },
                    { data: 'Out_Time2' },
                    { data: 'TotalHrs' },
                    { data: 'IN_IP_SD' },
                    { data: 'OUT_IP_SD' }

                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                columnDefs: [
                    {
                        targets: 0,
                        "width": "45px",
                        render: function (data, type, row, meta) {
                            return '<input type="checkbox" id="' + meta.row + '" name="' + meta.row + '" onclick="GetCheckedDates(this);" class="nodata" value="No Volume" /> ';
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();

                }
            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    $("#wholiday_detailspop").modal("show");
    return false;

}

const w_chkIds = [];

function GetCheckedDates(ID) {

    if (ID.checked) {
        if (!w_chkIds.includes(ID.id)) {
            w_chkIds.push(ID.id);
        }
    }
    else {
        const index = w_chkIds.indexOf(ID.id);
        if (index > -1) {
            w_chkIds.splice(index, 1);
        }
    }

    return false;
}

function wholiday_pupup_submit() {

    const name = $("#wholiday_popup_name").text().trim();
    const code = name.substring(0, 3);
    const remark = $("#wholiday_popup_remark").val().trim();

    if (remark === "") {
        Swal.fire({
            icon: "warning",
            title: "Remark Required",
            text: "Please enter remark."
        });
        return false;
    }

    if (w_chkIds.length === 0) {
        Swal.fire({
            icon: "warning",
            title: "No Selection",
            text: "Please select at least one worked holiday."
        });
        return false;
    }

    let dates = [];

    for (let i = 0; i < w_chkIds.length; i++) {
        const row = $('#wholiday_logdetails').DataTable().row(w_chkIds[i]).data();
        if (row) {
            dates.push(row.date);
        }
    }

    // $('#load1').show();

    PageMethods.ApproveWorkedHolidays(
        code,
        dates.join(","),
        remark,

        function (result) {

            $('#load1').hide();

            Swal.fire({
                icon: "success",
                title: "Success",
                text: "Worked holiday approved successfully.",
                confirmButtonText: "OK"
            }).then(() => {

                $("#wholiday_detailspop").modal("hide");
                wholiday_bindgrid();
            });

        },

        function (error) {

            $('#load1').hide();

            Swal.fire({
                icon: "error",
                title: "Approval Failed",
                text: error.get_message(),
                confirmButtonText: "OK"
            });

        });
}




