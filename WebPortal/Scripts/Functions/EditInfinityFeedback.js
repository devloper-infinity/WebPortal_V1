
var FeedbackID_1 = 0;
var subdomain_new = '';
var UwName = '';
var productionData_table;
var productionData_html;

function isNoErrorSeverityValue(severity) {
    return $.trim(severity).toLowerCase() === "no error";
}

function severityRequiresFeedbackStatus(severity) {
    var normalizedSeverity = $.trim(severity).toLowerCase();
    return normalizedSeverity === "critical" || normalizedSeverity === "non-critical";
}

function toggleSeverityDependentFields() {
    var severity = $("#infFeedback_Severity").val();
    var shouldHide = isNoErrorSeverityValue(severity);
    var shouldShowFeedbackStatus = severityRequiresFeedbackStatus(severity);
    var $dependentFields = $(".inf-severity-dependent");
    var $feedbackStatusField = $(".inf-feedback-status-field");

    $dependentFields.prop("hidden", shouldHide).attr("aria-hidden", shouldHide ? "true" : "false");
    $feedbackStatusField.prop("hidden", !shouldShowFeedbackStatus).attr("aria-hidden", shouldShowFeedbackStatus ? "false" : "true");

    if (shouldHide) {
        $dependentFields.find(":input").val("");
    }

    if (!shouldShowFeedbackStatus) {
        $feedbackStatusField.find(":input").val("");
    }
}

function BindInfinityFeedback(FeedbackID, subdomain) {
    FeedbackID_1 = FeedbackID;
    subdomain_new = subdomain;
    $.ajax({
        url: "EditInfinityFeedback.aspx/GetFeedbackDetailsByID_NewFormat",
        type: "POST",
        dataType: "json",
        data: "{FeedbackID:" + FeedbackID + ", Subdomain:'" + subdomain + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                document.getElementById("infFeedback_LoanNo").value = value.LoanNumber;
                document.getElementById("infFeedback_Client").value = value.Client;
                document.getElementById("infFeedback_UWName").value = value.UWName.toUpperCase();
                document.getElementById("infFeedback_QCName").value = value.QCName.toUpperCase();
                document.getElementById("infFeedback_DateReviewed").value = value.DateReviewed;
                document.getElementById("infFeedback_QcDate").value = value.QCDate;

                document.getElementById("infFeedback_Category").value = value.Category;
                document.getElementById("infFeedback_SubCategory").value = value.Subcategory;
                document.getElementById("infFeedback_ErrorField").value = value.ErrorField;
                document.getElementById("infFeedback_Screen").value = value.Screen;
                document.getElementById("infFeedback_ErrorType").value = value.ErrorType;
                document.getElementById("infFeedback_FeedbackType").value = value.FeedbackType;
                document.getElementById("infFeedback_Severity").value = value.Severity;
                document.getElementById("infFeedback_FeedbackStatus").value = value.FeedbackStatus || "";

                document.getElementById("infFeedback_Source").value = value.Source;
                document.getElementById("infFeedback_RCA").value = value.RCA;
                document.getElementById("infFeedback_Finding").value = value.Finding;

                toggleSeverityDependentFields();



                // document.getElementById("chk_IsShowFeedbackToUser").checked = value.IsDisplayFeedbackInERP;

                var date = new Date(value.FDate);
                var day = date.getDate();
                if (day < 10)
                    day = '0' + day
                var month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                var year = date.getFullYear();
                var actualdate = (month) + "/" + (day) + "/" + year;

                $("#infFeedback_FeedbackRecDate").val(actualdate);
                BindProductionDataGrid(value.LoanNumber, value.UWName);

                // BindProductionDataGrid('9761798470', 'EDWIN ROBERT');
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function BindProductionDataGrid(LoanNo, UwName) {

    $('#load1').show();

    var productionData_html = '';

    $.ajax({
        url: "EditInfinityFeedback.aspx/GetProductionDataForUpdateFeedback_NewFormat",
        type: "POST",
        dataType: "json",
        data: "{LoanNo:'" + LoanNo + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                var EmpName1 = value.Employee;

                productionData_html += '<tr>';

                if (UwName.toUpperCase() == EmpName1.toUpperCase()) {
                    productionData_html += '<td style="text-wrap: nowrap; display:none;"><input type="checkbox" checked="checked" id="' + blankForNull(value.ProdID) + '" onchange="return GetCheckedCheckboxes_Prod(this);" /></td>';
                }
                else {
                    productionData_html += '<td style="text-wrap: nowrap; display:none;"><input type="checkbox" id="' + blankForNull(value.ProdID) + '" onchange="return GetCheckedCheckboxes_Prod(this);" /></td>';
                }

                productionData_html += '<td style="text-wrap: nowrap;">' + blankForNull((index + 1)) + '</td>';
                productionData_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProdID) + '</td>';
                productionData_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                productionData_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Employee.toUpperCase()) + '</td>';
                productionData_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                productionData_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.CompletionDate) + '</td>';
                productionData_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_productionData')) {
                productionData_table.destroy();
            }
            $('#table_productionData tbody').html(productionData_html);

            productionData_table = $('#table_productionData').DataTable({
                dom: 't',
                scrollx: true,
                destroy: true,
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
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function edit_OnClickAddFeedback() {

    var ProdIDs = "0";

    var chkLen = chkIds_feedback.length;

    if (chkLen > 0) {
        for (let i = 0; i < chkLen; i++) {
            ProdIDs = ProdIDs + "," + chkIds_feedback[i];
        }
    }


    var Category = document.getElementById("infFeedback_Category").value.trim();
    var SubCategory = document.getElementById("infFeedback_SubCategory").value.trim();
    var ErrorField = document.getElementById("infFeedback_ErrorField").value.trim();
    var Screen = document.getElementById("infFeedback_Screen").value.trim();
    var ErrorType = document.getElementById("infFeedback_ErrorType").value.trim();
    var Finding = document.getElementById("infFeedback_Finding").value.trim();
    var FeedbackType = document.getElementById("infFeedback_FeedbackType").value.trim();
    var RCA = document.getElementById("infFeedback_RCA").value.trim();
    var Source = document.getElementById("infFeedback_Source").value.trim();
    var FeedbackRecDate = document.getElementById("infFeedback_FeedbackRecDate").value.trim();

    var inf_Severity = document.getElementById("infFeedback_Severity");
    var Severity = inf_Severity.options[inf_Severity.selectedIndex].value;
    var FeedbackStatus = document.getElementById("infFeedback_FeedbackStatus").value.trim();
    var isNoError = isNoErrorSeverityValue(Severity);

    if (isNoError) {
        Category = "";
        SubCategory = "";
        ErrorField = "";
        Screen = "";
        ErrorType = "";
        Finding = "";
        FeedbackType = "";
        FeedbackStatus = "";
        RCA = "";
    }

    var IsDisplayInERP = true;


    if (Severity == "" || Severity == "Select") {
        return showValidation("Please select Severity.", "infFeedback_Severity");
    }

    if (!isNoError) {
        if (Category == "") {
            document.getElementById("infFeedback_Category").focus();
            return showValidation("Please enter Category.", "infFeedback_Category");
        }

        if (SubCategory == "") {
            document.getElementById("infFeedback_SubCategory").focus();
            return showValidation("Please enter Sub-Category.", "infFeedback_SubCategory");
        }

        if (ErrorField == "") {
            document.getElementById("infFeedback_ErrorField").focus();
            return showValidation("Please enter Error Field.", "infFeedback_ErrorField");
        }

        if (Screen == "") {
            document.getElementById("infFeedback_Screen").focus();
            return showValidation("Please enter Screen.", "infFeedback_Screen");
        }

        if (ErrorType == "") {
            document.getElementById("infFeedback_ErrorType").focus();
            return showValidation("Please enter Error Type.", "infFeedback_ErrorType");
        }

        if (Finding == "") {
            document.getElementById("infFeedback_Finding").focus();
            return showValidation("Please enter Finding.", "infFeedback_Finding");
        }

        if (FeedbackType == "") {
            document.getElementById("infFeedback_FeedbackType").focus();
            return showValidation("Please enter Feedback Type.", "infFeedback_FeedbackType");
        }

        if (RCA == "") {
            document.getElementById("infFeedback_RCA").focus();
            return showValidation("Please enter RCA.", "infFeedback_RCA");
        }
    }

    if (severityRequiresFeedbackStatus(Severity) && FeedbackStatus == "") {
        document.getElementById("infFeedback_FeedbackStatus").focus();
        return showValidation("Please select Feedback Status.", "infFeedback_FeedbackStatus");
    }

    if (Source == "") {
        document.getElementById("infFeedback_Source").focus();
        return showValidation("Please enter Source.", "infFeedback_Source");
    }

    if (FeedbackRecDate == "") {
        document.getElementById("infFeedback_FeedbackRecDate").focus();
        return showValidation("Please enter Feedback Rec Date.", "infFeedback_FeedbackRecDate");
    }


    Swal.fire({
        title: "Please wait...", text: "Updating feedback...", allowOutsideClick: false, allowEscapeKey: false, showConfirmButton: false, didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.UpdateInfinityImportedFeedback_NewERP(FeedbackID_1, ProdIDs, Category, SubCategory, ErrorField, Screen, ErrorType, Finding, FeedbackType, Severity, FeedbackStatus, RCA, Source, FeedbackRecDate, IsDisplayInERP, subdomain_new,

        function (result) {

            Swal.close();

            FeedbackID_1 = 0;
            subdomain_new = "";

            if (result > 0) {

                Swal.fire({ icon: "success", title: "Success", text: "Feedback updated successfully." }).then(function () {
                    location.reload();
                });
            } else {
                Swal.fire({
                    icon: "error", title: "Error", text: "Oops! Error occurred while updating status. Please contact administrator."
                }).then(function () {
                    location.reload();
                });
            }
        },

        function (error) {

            Swal.close();

            console.log(error);

            Swal.fire({ icon: "error", title: "Error", text: error.get_message ? error.get_message() : "Something went wrong while updating feedback." });
        }
    );

    return false;
}



function showValidation(message, elementId) {

    Swal.fire({ icon: "warning", title: "Validation", text: message }).then(function () { document.getElementById(elementId).focus(); });

    return false;
}

function core_edit_OnClickAddFeedback() {

    var ProdIDs = 0;

    var chkLen = chkIds_feedback.length;

    if (chkLen > 0) {

        for (let i = 0; i < chkLen; i++) {

            ProdIDs = ProdIDs + "," + chkIds_feedback[i];
        }
    }

    var Category = document.getElementById("infFeedback_Category").value;
    var SubCategory = document.getElementById("infFeedback_SubCategory").value;
    var ErrorField = document.getElementById("infFeedback_ErrorField").value;
    var Screen = document.getElementById("infFeedback_Screen").value;
    var ErrorType = document.getElementById("infFeedback_ErrorType").value;
    var Finding = document.getElementById("infFeedback_Finding").value;
    var FeedbackType = document.getElementById("infFeedback_FeedbackType").value;
    var RCA = document.getElementById("infFeedback_RCA").value;
    var Source = document.getElementById("infFeedback_Source").value;
    var FeedbackRecDate = document.getElementById("infFeedback_FeedbackRecDate").value;
    var inf_Severity = document.getElementById("infFeedback_Severity");
    var Severity = inf_Severity.options[inf_Severity.selectedIndex].value;
    var FeedbackStatus = document.getElementById("infFeedback_FeedbackStatus").value;
    var isNoError = isNoErrorSeverityValue(Severity);

    if (isNoError) {
        Category = "";
        SubCategory = "";
        ErrorField = "";
        Screen = "";
        ErrorType = "";
        Finding = "";
        FeedbackType = "";
        FeedbackStatus = "";
        RCA = "";
    }

    var IsDisplayInERP = true;

    if (!isNoError) {
        if (Category == "") {
            alert("Please enter Category.");
            document.getElementById("infFeedback_Category").focus();
            return false;
        }
        if (SubCategory == "") {
            alert("Please enter Sub-Category");
            document.getElementById("infFeedback_SubCategory").focus();
            return false;
        }
        if (ErrorField == "") {
            alert("Please enter Error Field.");
            document.getElementById("infFeedback_ErrorField").focus();
            return false;
        }
        if (Screen == "") {
            alert("Please enter Screen.");
            document.getElementById("infFeedback_Screen").focus();
            return false;
        }
        if (ErrorType == "") {
            alert("Please enter Error Type.");
            document.getElementById("infFeedback_ErrorType").focus();
            return false;
        }
        if (Finding == "") {
            alert("Please enter Finding.");
            document.getElementById("infFeedback_Finding").focus();
            return false;
        }
        if (FeedbackType == "") {
            alert("Please enter Feedback Type.");
            document.getElementById("infFeedback_FeedbackType").focus();
            return false;
        }
        if (RCA == "") {
            alert("Please enter RCA.");
            document.getElementById("infFeedback_RCA").focus();
            return false;
        }
    }
    if (severityRequiresFeedbackStatus(Severity) && FeedbackStatus == "") {
        alert("Please select Feedback Status.");
        document.getElementById("infFeedback_FeedbackStatus").focus();
        return false;
    }
    if (Source == "") {
        alert("Please enter Source.");
        document.getElementById("infFeedback_Source").focus();
        return false;
    }
    if (FeedbackRecDate == "") {
        alert("Please enter FeedbackRecDate.").focus();
        return false;
    }
    if (Severity == "") {
        alert("Please select Severity.").focus();
        return false;
    }
    PageMethods.UpdateInfinityImportedFeedback_NewERP(FeedbackID_1, ProdIDs, Category, SubCategory, ErrorField, Screen, ErrorType, Finding, FeedbackType, Severity, FeedbackStatus, RCA, Source, FeedbackRecDate, IsDisplayInERP, subdomain_new, OnSuccessFeedback, OnErrorFeedback);
    return false;
}

function OnSuccessFeedback(result) {

    FeedbackID_1 = 0;
    subdomain_new = '';

    if (result > 0) {
        alert("Feedback updated successfully.");
        location.reload();
        return false;
    }
    else {
        alert("Oops! Error occured while updating status. Please contact administrator");
        location.reload();
        return false;
    }
}

function OnErrorFeedback(error) {
    alert(error.get_message());
}

const chkIds_feedback = [];

function GetCheckedCheckboxes_Prod(ID) {

    if (ID.checked) {
        if (!chkIds_feedback.includes(ID.id)) {

            chkIds_feedback.push(ID.id);
        }
    }
    else {
        if (chkIds_feedback.includes(ID.id)) {
            chkIds_feedback.splice(chkIds_feedback.indexOf(ID.id), 1);
        }
    }
    return false;
}












