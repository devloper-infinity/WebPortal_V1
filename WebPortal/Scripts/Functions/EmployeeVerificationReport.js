var ExEmployee_table;
var ExEmployee_userID;
var ExEmployee_selectedrow;
var html = '';
var ExEmployee_VerIDs;
var ExEmployee_empids;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function ExEmployerVerification_BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("ExEmp_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#ExEmp_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#ExEmp_year").append($("<option></option>").val(i).html(i));
    }
}

function ExEmployer_UpdateRemark() {
    var ddlisRequired = document.getElementById("ExEmployer_bgvrequired");
    var isrequired = ddlisRequired.options[ddlisRequired.selectedIndex].value;
    var remark = document.getElementById("ExEmployer_remark1").value;
    if (isrequired == "") {
        alert("Please select action.");
        ddlisRequired.focus();
        return false;
    }
    if (remark == "") {
        alert("Please enter remark.");
        document.getElementById("ExEmployer_remark1").focus();
        return false;
    }

    PageMethods.InsertIsVerificationRequired(ExEmployee_VerIDs, isrequired, remark, OnIsRequiredSuccess, OnIsRequiredError);

    return false;
}

function OnIsRequiredSuccess(result) {
    if (result > 0) {
        document.getElementById("errmsg").innerHTML = "Record saved successfully!";
        $('#dverror').modal('show');
    }
    else {
        document.getElementById("errmsg").innerHTML = "Oops! Error occured while submitting information. Please contact administrator!";
        document.getElementById("errmsg").style.color = 'red';
        $('#dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function OnIsRequiredError(error) {
    alert(error);
}

function ExEmployer_Message() {
    ExEmployerVerification_Submit();
    document.getElementById("ExEmployer_bgvrequired").selectedIndex = 0;
    document.getElementById("ExEmployer_remark1").value = '';
    $('#dverror').modal('hide');
    $('#exemployerisrequired').modal('hide');


}

function ExForm_Message() {
    location.reload();
}

function ExFormConf_Message() {
    location.reload();
}

function ExEmployerVerification_IsRequired(VerificationID, Index) {
    var row = ExEmployee_table.row(Index).data();
    document.getElementById("ExEmployer_empname").innerHTML = row[4];
    ExEmployee_VerIDs = row[1];
    var EmailStatus = row[10];
    if (EmailStatus == "Pending" || EmailStatus == "N/A") {
        document.getElementById("ExEmployer_bgvrequired").disabled = false;
        document.getElementById("ExEmployer_remark1").disabled = false;
        document.getElementById("btnExEmployerUpdateRequired").disabled = false;
    }
    else {
        document.getElementById("ExEmployer_bgvrequired").disabled = true;
        document.getElementById("ExEmployer_remark1").disabled = true;
        document.getElementById("btnExEmployerUpdateRequired").disabled = true;
    }
    //ExEmployee_VerIDs = VerificationID;
    $('#exemployerisrequired').modal('show');
}

function ExEmployerVerification_StartVerification(VerificationID, Index) {
    var row = ExEmployee_table.row(Index).data();
    ExEmployee_VerIDs = row[1];
    location.href = "EmployeeVerificationForm.aspx?Emp=" + ExEmployee_VerIDs;
}

function ExEmployerVerification_VerifyData(VerificationID, Index) {
    var row = ExEmployee_table.row(Index).data();
    ExEmployee_VerIDs = row[1];
    location.href = "EmployeeVerificationConfirmation.aspx?Emp=" + ExEmployee_VerIDs;
}

function ExEmpVer_ViewDetails(VerificationID, Index) {
    var row = ExEmployee_table.row(Index).data();
    ExEmployee_VerIDs = row[1];
    location.href = "EmployeeVerificationConfirmation.aspx?Emp=" + ExEmployee_VerIDs;
}

function ExEmployerVerification_ResendEmail(VerificationID, Index) {
    var row = ExEmployee_table.row(Index).data();
    document.getElementById("ExEmployer_empnameresend").value = row[4];
    document.getElementById("ExEmployer_receiverresend").innerHTML = row[15];
    ExEmployee_VerIDs = row[0];
    $('#resendemail').modal('show');
}

function BindFormInformation() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmployeeID = urlParams.get('Emp');
    $.ajax({
        type: "POST", url: "EmployeeVerificationForm.aspx/GetUserName", dataType: "json", contentType: "application/json",
        data: "{EmployeeID:" + EmployeeID + "}",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                document.getElementById("ExEmpForm_name").value = value1.Code + ' : ' + value1.FullName;
                document.getElementById("ExEmpForm_name").disabled = true;
            });
        }
    });
}

function BindFormInformation_Conf() {
    const urlParams = new URLSearchParams(window.location.search);
    const EmployeeID = urlParams.get('Emp');
    $.ajax({
        type: "POST", url: "EmployeeVerificationConfirmation.aspx/BindExistingInformation", dataType: "json", contentType: "application/json",
        data: "{EmployeeID:" + EmployeeID + "}",
        success: function (res1) {
            var dataArray = JSON.parse(res1.d);
            $.each(dataArray, function (data1, value1) {
                document.getElementById("ExEmpConf_name").innerHTML = value = value1.EmployeeName;
                document.getElementById("ExEmpConf_organizationname").value = value1.CompanyName;
                document.getElementById("ExEmpConf_candidatename").value = value1.CandidateName;
                document.getElementById("ExEmpConf_employeeid").value = value1.EmployeeCode;
                document.getElementById("ExEmpConf_designation").value = value1.LastDesignation;
                document.getElementById("ExEmpConf_employmentperiod").value = value1.EmploymentPeriod;
                document.getElementById("ExEmpConf_salary").value = value1.Salary;
                document.getElementById("ExEmpConf_reportingmanager").value = value1.ReportingPersonName;
                document.getElementById("ExEmpConf_reportingdesignation").value = value1.ReportingPersonDesignation;
                document.getElementById("ExEmpConf_reportingmanageremail").value = value1.ReportingPersonContact;
                document.getElementById("ExEmpConf_hrname").value = value1.HRName;
                document.getElementById("ExEmpConf_hremail").value = value1.HRContact;
                document.getElementById("ExEmpConf_reasonforleaving").value = value1.ReasonForLiving;
                document.getElementById("ExEmpConf_exitformality").value = value1.PendingExitFormalities;
                document.getElementById("ExEmpConf_eligibility").value = value1.EligibilityToRehire;
                document.getElementById("ExEmpConf_verifiedby").value = value1.VerifiedBy;

                document.getElementById("ExEmpConf_organizationnameVer").value = value1.VerifiedCompanyName;
                document.getElementById("ExEmpConf_candidatenameVer").value = value1.VerifiedCandidateName;
                document.getElementById("ExEmpConf_employeeidVer").value = value1.VerifiedEmployeeCode;
                document.getElementById("ExEmpConf_designationVer").value = value1.VerifiedLastDesignation;
                document.getElementById("ExEmpConf_employmentperiodVer").value = value1.VerifiedEmploymentPeriod;
                document.getElementById("ExEmpConf_salaryVer").value = value1.VerifiedSalary;
                document.getElementById("ExEmpConf_reportingmanagerVer").value = value1.VerifiedReportingPersonName;
                document.getElementById("ExEmpConf_reportingdesignationVer").value = value1.VerifiedReportingPersonDesignation;
                document.getElementById("ExEmpConf_reportingmanageremailVer").value = value1.VerifiedReportingPersonContact;
                document.getElementById("ExEmpConf_hrnameVer").value = value1.VerifiedHRName;
                document.getElementById("ExEmpConf_hremailVer").value = value1.VerifiedHRContact;
                document.getElementById("ExEmpConf_reasonforleavingVer").value = value1.VerifiedReasonForLiving;
                document.getElementById("ExEmpConf_exitformalityVer").value = value1.VerifiedPendingExitFormalities;
                document.getElementById("ExEmpConf_eligibilityVer").value = value1.VerifiedEligibilityToRehire;
                document.getElementById("ExEmpConf_verifiedbyVer").value = value1.VerifiedByVerified;

            });
        }
    });
}

function ExEmployerVerification_Submit() {

    var ddlmonth = document.getElementById("ExEmp_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("ExEmp_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();
    html = '';
    $.ajax({
        url: "EmployeeVerificationReport.aspx/GetExEmployerVerification",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                html += '<tr>';
                html += '<td style="display:none;">' + value.VerificationID + '</td>';
                html += '<td style="display:none;">' + value.EmployeeID + '</td>';
                html += '<td class=""><div class="btn-group">';
                html += '<div class="btn-group">';
                html += '<div type="button" data-toggle="dropdown" aria-expanded="false"><i style="color: dodgerblue; font-size:14px;" class="uil fs-0 me-2 uil-cog"></i>';
                html += '<span class="sr-only"></span></div><div class="dropdown-menu" role="menu" style="">';
                if (value.MailStatus == "Pending" || value.MailStatus == "N/A")
                    html += '<a class="dropdown-item" href="#!" id="Actions" onclick="ExEmployerVerification_IsRequired(' + value.VerificationID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-question-circle" style="font-size:14px;"></i></span>&nbsp;&nbsp;Verification Required?</a>';
                else
                    html += '<a class="dropdown-item isDisabled" href="#!" id="Actions"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-question-circle" style="font-size:14px;"></i></span>&nbsp;&nbsp;Verification Required?</a>';

                if (value.MailStatus == "Pending")
                    html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ExEmployerVerification_StartVerification(' + value.VerificationID + ',' + index + ');"><span style="color: cornflowerblue;"><i class="uil fs-0 me-2 uil-closed-captioning" style="font-size:14px;"></i></span>&nbsp;&nbsp;Start Verification</a><div class="dropdown-divider"></div>';

                else
                    html += '<a class="dropdown-item isDisabled" href="#!" id="ActionsEx"><span style="color: cornflowerblue;"><i class="uil fs-0 me-2 uil-closed-captioning" style="font-size:14px;"></i></span>&nbsp;&nbsp;Start Verification</a><div class="dropdown-divider"></div>';
                if (value.MailStatus != "Pending" && value.MailStatus != "N/A")
                    html += '<a class="dropdown-item" href="#!" id="ActionsEx" onclick="ExEmployerVerification_ResendEmail(' + value.VerificationID + ',' + index + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-fast-mail" style="font-size:14px;"></i></span>&nbsp;&nbsp;Resend Email</a>';
                else
                    html += '<a class="dropdown-item isDisabled" href="#!" id="ActionsEx"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-fast-mail" style="font-size:14px;"></i></span>&nbsp;&nbsp;Resend Email</a>';

                if (value.MailStatus != "Pending" && value.MailStatus != "N/A")
                    html += '<a class="dropdown-item" href="#!" id="ActionsExVerify" onclick="ExEmployerVerification_VerifyData(' + value.VerificationID + ',' + index + ');"><span style="color: #fe7096;"><i class="uil fs-0 me-2 uil-coins" style="font-size:14px;"></i></span>&nbsp;&nbsp;Verify Details</a><div class="dropdown-divider"></div>';
                else
                    html += '<a class="dropdown-item isDisabled" href="#!" id="ActionsExVerify"><span style="color: #fe7096;"><i class="uil fs-0 me-2 uil-coins" style="font-size:14px;"></i></span>&nbsp;&nbsp;Verify Details</a><div class="dropdown-divider"></div>';

                if (value.Document != null)
                    // html += '<a class="dropdown-item" target="_blank" href="../' + value.Document.substring(value.Document.indexOf("EmployeeDocuments")) + '" id="DownloadAtt"><span style="color: brown;"><i class="uil fs-0 me-2 uil-download-alt"></i></span>&nbsp;&nbsp;Download Attachment</a>';
                    html += '<a class="dropdown-item" href="#!" id="Actionsdoc" onclick="docs_download(\'' + blankForNull(value.Attachment1) + '\',' + index + ');"><span><i class="uil fs-0 me-2 uil-cloud-download" style="font-size:14px;"></i></span>&nbsp;&nbsp;Download Attachment</a>';
                // html += '<a class="dropdown-item" href="#!" id="Actions" onclick="ExEmployerVerification_IsRequired(' + value.VerificationID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-question-circle" style="font-size:14px;"></i></span>&nbsp;&nbsp;Verification Required?</a>';
                else
                    html += '<a class="dropdown-item isDisabled" href="#url" id="DownloadAtt"><span style="color: brown;"><i class="uil fs-0 me-2 uil-download-alt"></i></span>&nbsp;&nbsp;Download Attachment</a>';

                html += '<a class="dropdown-item" href="#url" id="ViewDetails" onclick="ExEmpVer_ViewDetails(' + value.VerificationID + ',' + index + ');"><span style="color: brown;"><i class="uil fs-0 me-2 uil-search"></i></span>&nbsp;&nbsp;View Details</a></div></div></td > ';

                html += '<td>' + blankForNull(value.Code) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.EmpName) + '</td>';
                html += '<td>' + blankForNull(value.JoiningDate) + '</td>';
                html += '<td>' + blankForNull(value.Gender) + '</td>';
                html += '<td>' + blankForNull(value.Branch) + '</td>';
                html += '<td>' + blankForNull(value.CurrentStatus) + '</td>';
                html += '<td>' + blankForNull(value.LatestLoginDate) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MailStatus) + '</td>';
                html += '<td>' + blankForNull(value.VerStatus) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.VerifiedByName) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.VerifyDateTime1) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Document) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Receiver) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#ExEmployerVerification')) {
                ExEmployee_table.destroy();
            }
            $('#ExEmployerVerification tbody').html(html);

            ExEmployee_table = $('#ExEmployerVerification').DataTable({
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

                "rowCallback": function (row, data) {
                    // Cell at index 5 in the row is 'Active'.
                    var val = data[3];
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Ex Employer Verification Report', autoFilter: true,
                        exportOptions: {
                            columns: [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
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

function docs_download(path, index) {

    if (path == "" || path == null) {
        alert("No attachment found.");
        return;
    }
    else {
        window.location.href = "DownloadFiles.aspx?ExEmpDocPath=" + path;
    }
}

function ExEmpForm_SubmitData() {
    if (typeof exEmpFormUploadInProgress !== "undefined" && exEmpFormUploadInProgress) {
        showExEmpFormMessage("Please wait for the attachment upload to finish.", true);
        return false;
    }

    const urlParams = new URLSearchParams(window.location.search);
    const EmployeeID = parseInt(urlParams.get('Emp'), 10);
    if (!Number.isInteger(EmployeeID) || EmployeeID <= 0) {
        showExEmpFormMessage("A valid employee was not selected. Please return to the verification report and try again.", true);
        return false;
    }

    var ExEmpForm_name = document.getElementById("ExEmpForm_name").value;
    var ExEmpForm_organizationname = document.getElementById("ExEmpForm_organizationname").value;
    var ExEmpForm_candidatename = document.getElementById("ExEmpForm_candidatename").value;
    var ExEmpForm_employeeid = document.getElementById("ExEmpForm_employeeid").value;
    var ExEmpForm_designation = document.getElementById("ExEmpForm_designation").value;
    var ExEmpForm_employmentperiod = document.getElementById("ExEmpForm_employmentperiod").value;
    var ExEmpForm_salary = document.getElementById("ExEmpForm_salary").value;
    var ExEmpForm_reportingmanager = document.getElementById("ExEmpForm_reportingmanager").value;
    var ExEmpForm_reportingdesignation = document.getElementById("ExEmpForm_reportingdesignation").value;
    var ExEmpForm_reportingmanageremail = document.getElementById("ExEmpForm_reportingmanageremail").value;
    var ExEmpForm_hrname = document.getElementById("ExEmpForm_hrname").value;
    var ExEmpForm_hremail = document.getElementById("ExEmpForm_hremail").value;
    var ExEmpForm_reasonforleaving = document.getElementById("ExEmpForm_reasonforleaving").value;
    var ExEmpForm_exitformality = document.getElementById("ExEmpForm_exitformality").value;
    var ExEmpForm_eligibility = document.getElementById("ExEmpForm_eligibility").value;
    var ExEmpForm_verifiedby = document.getElementById("ExEmpForm_verifiedby").value;
    var ExEmpForm_receiver = document.getElementById("ExEmpForm_receiver").value;
    var DutiesAndResponsibilitiesl = "";

    if (!ExEmpForm_candidatename.trim() || !ExEmpForm_organizationname.trim() || !ExEmpForm_receiver.trim()) {
        showExEmpFormMessage("Candidate name, organization name, and receiver email are required.", true);
        return false;
    }

    var receiverInput = document.getElementById("ExEmpForm_receiver");
    if (!receiverInput.checkValidity()) {
        showExEmpFormMessage("Please enter a valid receiver email address.", true);
        receiverInput.focus();
        return false;
    }

    setExEmpFormSubmitting(true);
    PageMethods.InsertVerificationInformation(EmployeeID, ExEmpForm_candidatename, ExEmpForm_employeeid, ExEmpForm_salary, ExEmpForm_organizationname, ExEmpForm_employmentperiod, ExEmpForm_designation, ExEmpForm_reportingmanager,
        ExEmpForm_reportingdesignation, ExEmpForm_reportingmanageremail, ExEmpForm_hrname, ExEmpForm_hremail, ExEmpForm_reasonforleaving, ExEmpForm_exitformality, ExEmpForm_eligibility, ExEmpForm_verifiedby, ExEmpForm_receiver, DutiesAndResponsibilitiesl, OnSuccessExEmpForm, OnErrorExEmpForm)
    return false;
}

function OnSuccessExEmpForm(result) {
    setExEmpFormSubmitting(false);
    if (result > 0) {
        showExEmpFormMessage("Information submitted successfully!", false);
    }
    else {
        showExEmpFormMessage("The information could not be submitted. Please contact the administrator.", true);
        return false;
    }
    //location.reload();
    return false;
}

function OnErrorExEmpForm(error) {
    setExEmpFormSubmitting(false);
    var message = error && error.get_message ? error.get_message() : "The information could not be submitted. Please try again.";
    showExEmpFormMessage(message, true);
}

function setExEmpFormSubmitting(isSubmitting) {
    var submitButton = document.getElementById("ExEmpForm_btnSubmit");
    if (submitButton) {
        submitButton.disabled = isSubmitting;
    }

    if (isSubmitting) {
        $('#load1').show();
    }
    else {
        $('#load1').hide();
    }
}

function showExEmpFormMessage(message, isError) {
    var messageElement = document.getElementById("form_errmsg");
    messageElement.textContent = message;
    messageElement.style.color = isError ? 'red' : '';
    $('#form_dverror').modal('show');
}

function ExEmployer_ResendEmail() {

    $('#resendemail').modal('hide');
    $('#waitingpanel').modal('show');
    var receiver = document.getElementById("ExEmployer_receiverresend").value;
    PageMethods.ResendVerificationEmail(ExEmployee_VerIDs, receiver, OnEmailSuccess, OnEmailError);
    return false;
}

function OnEmailSuccess(result) {
    if (result > 0) {

        document.getElementById("ExEmployer_receiverresend").value = "";
        removeResendFile();

        $('#waitingpanel').modal('hide');
        document.getElementById("errmsg").innerHTML = "Email sent successfully!";
        $('#dverror').modal('show');
    }
    else if (result == -1) {
        $('#waitingpanel').modal('hide');
        document.getElementById("errmsg").innerHTML = "Please check attached file.";
        document.getElementById("errmsg").style.color = 'red';
        $('#dverror').modal('show');
        return false;
    }
    else {
        $('#waitingpanel').modal('hide');
        document.getElementById("errmsg").innerHTML = "Oops! Error occured while sending email. Please contact administrator!";
        document.getElementById("errmsg").style.color = 'red';
        $('#dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function OnEmailError(error) {
    alert(error);
}

function ExEmpConf_SubmitData() {

    const urlParams = new URLSearchParams(window.location.search);
    const EmployeeID = urlParams.get('Emp');
    var ExEmpConf_organizationname = document.getElementById("ExEmpConf_organizationnameVer").value;
    var ExEmpConf_candidatename = document.getElementById("ExEmpConf_candidatenameVer").value;
    var ExEmpConf_employeeid = document.getElementById("ExEmpConf_employeeidVer").value;
    var ExEmpConf_designation = document.getElementById("ExEmpConf_designationVer").value;
    var ExEmpConf_employmentperiod = document.getElementById("ExEmpConf_employmentperiodVer").value;
    var ExEmpConf_salary = document.getElementById("ExEmpConf_salaryVer").value;
    var ExEmpConf_reportingmanager = document.getElementById("ExEmpConf_reportingmanagerVer").value;
    var ExEmpConf_reportingdesignation = document.getElementById("ExEmpConf_reportingdesignationVer").value;
    var ExEmpConf_reportingmanageremail = document.getElementById("ExEmpConf_reportingmanageremailVer").value;
    var ExEmpConf_hrname = document.getElementById("ExEmpConf_hrname").value;
    var ExEmpConf_hrnameVer = document.getElementById("ExEmpConf_hrnameVer").value;
    var ExEmpConf_hremail = document.getElementById("ExEmpConf_hremailVer").value;
    var ExEmpConf_reasonforleaving = document.getElementById("ExEmpConf_reasonforleavingVer").value;
    var ExEmpConf_exitformality = document.getElementById("ExEmpConf_exitformalityVer").value;
    var ExEmpConf_eligibility = document.getElementById("ExEmpConf_eligibility").value;
    var ExEmpConf_eligibilityVer = document.getElementById("ExEmpConf_eligibilityVer").value;
    var ExEmpConf_verifiedby = document.getElementById("ExEmpConf_verifiedby").value;
    var ExEmpConf_verifiedbyVer = document.getElementById("ExEmpConf_verifiedbyVer").value;

    PageMethods.InsertVerificationConfirmation(EmployeeID, ExEmpConf_candidatename, ExEmpConf_employeeid, ExEmpConf_salary, ExEmpConf_organizationname, ExEmpConf_employmentperiod, ExEmpConf_designation, ExEmpConf_reportingmanager,
        ExEmpConf_reportingdesignation, ExEmpConf_reportingmanageremail, ExEmpConf_hrname, ExEmpConf_hrnameVer, ExEmpConf_hremail, ExEmpConf_reasonforleaving, ExEmpConf_exitformality, ExEmpConf_eligibility, ExEmpConf_eligibilityVer, ExEmpConf_verifiedby, ExEmpConf_verifiedbyVer, OnSuccessExEmpConf, OnErrorExEmpConf)
    return false;
}

function OnSuccessExEmpConf(result) {
    if (result > 0) {
        document.getElementById("formCof_errmsg").innerHTML = "Information submitted successfully!";
        $('#formCof_dverror').modal('show');
    }
    else {
        document.getElementById("formCof_errmsg").innerHTML = "Oops! Error occured while submitting information. Please contact administrator!";
        document.getElementById("formCof_errmsg").style.color = 'red';
        $('#formCof_dverror').modal('show');
        return false;
    }
    //location.reload();
    return false;
}

function OnErrorExEmpConf(error) {
    alert(error);
}

function removeResendFile() {

    // 1️⃣ Clear file input completely
    document.getElementById("ExEmpResend_attachment").value = "";

    // 2️⃣ Hide preview section
    document.getElementById("conentdiv").style.display = "none";

    // 3️⃣ Clear filename
    document.getElementById("filesdiv").innerHTML = "";

    // 4️⃣ Remove max-file UI class
    document.getElementById("dropzone").classList.remove("dz-max-files-reached");

    // 5️⃣ Clear hidden field also (if used)
    if (document.getElementById("filep")) {
        document.getElementById("filep").value = "";
    }

}


