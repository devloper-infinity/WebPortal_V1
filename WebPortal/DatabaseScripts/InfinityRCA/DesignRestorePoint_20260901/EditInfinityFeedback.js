
var FeedbackID_1 = 0;
var subdomain_new = '';
var UwName = '';
var productionData_table;
var productionData_html;
var feedbackHistory_table;

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

    var employeeId = $("#hdnEmployeeID").val();

    $("#btnAddFeedback").show(); // display
    $("#btnFinalRemark").hide(); // hide
    $("#onshoreConclusionSection").hide();

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
                document.getElementById("infFeedback_FeedbackStatus").text = value.FeedbackStatus || "Select";

                document.getElementById("infFeedback_Source").value = value.Source;
                document.getElementById("infFeedback_RCA").value = value.RCA;
                document.getElementById("infFeedback_Finding").value = value.Finding;

                /* Onshore Response */
                if ((value.RebuttalStatus === "Agree" || value.RebuttalStatus === "Rebuttal") && Number(employeeId) === 10313) {
                  
                    $("#onshoreConclusionSection").show();
                    $("#btnAddFeedback").hide(); // display
                    $("#btnFinalRemark").show();

                    $("#infFeedback_onshore_Response").val(value.RebuttalStatus);
                    $("#infFeedback_OnshoreRebutalComments").val(value.RebuttalRemark);
                }

                /* Final Comments */
                document.getElementById("infFeedback_onshore_Response").text = value.FinalStatus;
                document.getElementById("infFeedback_Finding").text = value.FinalRemark;

                toggleSeverityDependentFields();

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
                productionData_bindGrid(value.LoanNumber, value.UWName);

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


function edit_UpdateFinalRemark() {

    var inf_status = document.getElementById("infFeedback_finalStatus");
    var final_status = inf_status.options[inf_status.selectedIndex].value;

    var FinalComments = document.getElementById("infFeedback_FinalComments").value.trim();

    if (final_status == "" || final_status == "Select") {
        return showValidation("Final status is mandatory.", "infFeedback_finalStatus");
    }

    if (FinalComments == "") {
        document.getElementById("infFeedback_FinalComments").focus();
        return showValidation("Final remark is mandatory.", "infFeedback_FinalComments");
    }

    Swal.fire({
        title: "Please wait...", text: "Updating status...", allowOutsideClick: false, allowEscapeKey: false, showConfirmButton: false, didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.UpdateFinalRemark(FeedbackID_1, final_status, FinalComments, subdomain_new,

        function (result) {

            Swal.close();

            FeedbackID_1 = 0;
            subdomain_new = "";

            if (result > 0) {

                Swal.fire({ icon: "success", title: "Success", text: "Final status updated successfully." }).then(function () {
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

function BindFeedbackHistory_Grid(feedbackId, subdomain) {

    $('#load1').show();

    $.ajax({
        url: "EditInfinityFeedback.aspx/GetCreditAndServicingFeedbackHistory",
        type: "POST",
        data: JSON.stringify({
            FeedbackID: feedbackId,
            SubDomain: subdomain
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var dataArray = [];

            try {
                dataArray = typeof response.d === "string"
                    ? JSON.parse(response.d || "[]")
                    : (response.d || []);
            }
            catch (e) {
                console.error("Invalid JSON response:", e);
                console.log("Response:", response.d);

                $('#load1').hide();

                Swal.fire({ icon: 'error', title: 'Invalid Response', text: 'Unable to read feedback history data.' });

                return;
            }

            if ($.fn.DataTable.isDataTable('#table_feedbackHistory')) {
                $('#table_feedbackHistory').DataTable().clear().destroy();
            }

            $('#table_feedbackHistory').DataTable({
                data: dataArray,
                dom: 't',
                paging: false,
                searching: false,
                info: false,
                ordering: false,
                processing: true,
                deferRender: true,
                destroy: true,
                autoWidth: false,
                // scrollX: true,

                columns: [
                    {
                        data: null,
                        title: "Sr. No.",
                        className: "text-center text-nowrap",
                        width: "60px",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: "UW Name",
                        title: "UW Name",
                        className: "text-nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "QC Name",
                        title: "QC Name",
                        className: "text-nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Date Reviewed",
                        title: "Date Reviewed",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "QC Date",
                        title: "QC Date",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "Category",
                        title: "Category",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Sub category",
                        title: "Sub Category",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Error Field",
                        title: "Error Field",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Screen",
                        title: "Screen",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Error Type",
                        title: "Error Type",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Finding",
                        title: "Finding",
                        defaultContent: "",
                        className: "nowrap",
                        width: "500px"
                    },
                    {
                        data: "Feedback Type",
                        title: "Feedback Type",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Severity",
                        title: "Severity",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "RCA",
                        title: "RCA/Rebuttal",
                        className: "text-nowrap",
                        defaultContent: "",
                        width: "500px",
                    },
                    {
                        data: "Week",
                        title: "Week",
                        className: "text-center",
                        defaultContent: ""
                    },
                    {
                        data: "Month",
                        title: "Month",
                        defaultContent: ""
                    },
                    {
                        data: "Feedback Pending",
                        title: "Feedback Pending",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Comments",
                        title: "Comments",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Onshore/GT",
                        title: "Onshore / GT",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Source",
                        title: "Source",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "Feedback Received Date",
                        title: "Feedback Received Date",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "Emp Status",
                        title: "Emp Status",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "F25",
                        title: "F25",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "UpdatedByName",
                        title: "Updated By",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "UpdatedDate",
                        title: "Updated Date",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "IsDisplayFeedbackInERP",
                        title: "Display In ERP",
                        className: "text-center",
                        defaultContent: "",
                        render: function (data) {
                            return data === true ||
                                data === 1 ||
                                data === "1" ||
                                String(data).toLowerCase() === "true"
                                ? "Yes"
                                : "No";
                        }
                    },
                    {
                        data: "Status",
                        title: "Status",
                        className: "nowrap",
                        defaultContent: ""
                    },
                    {
                        data: "StatusUpdatedDate",
                        title: "Status Updated Date",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "QCDate_Converted",
                        title: "QC Date Converted",
                        className: "text-nowrap text-center",
                        defaultContent: ""
                    },
                    {
                        data: "Finding Status",
                        title: "Finding Status",
                        className: "nowrap",
                        defaultContent: ""
                    }
                ],

                language: {
                    emptyTable: "No feedback records found."
                },

                initComplete: function () {
                    $('#load1').hide();
                }
            });

            $('#table_feedbackHistory')
                .off('error.dt')
                .on('error.dt', function (e, settings, techNote, message) {
                    console.error("DataTable error:", message);
                });
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error("AJAX error:", xhr.responseText);

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: xhr.responseJSON && xhr.responseJSON.Message
                    ? xhr.responseJSON.Message
                    : 'Unable to load feedback data.'
            });
        }
    });

    return false;
}

function productionData_bindGrid(LoanNo, UwName) {

    $('#load1').show();

    $.ajax({
        url: "EditInfinityFeedback.aspx/GetProductionDataForUpdateFeedback_NewFormat",
        type: "POST",
        data: JSON.stringify({
            LoanNo: LoanNo
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var dataArray = [];

            try {
                dataArray = JSON.parse(response.d || "[]");
            }
            catch (e) {
                console.error("Invalid JSON response:", e);
                dataArray = [];
            }

            var uwNameValue = (UwName || "").trim().toUpperCase();

            if ($.fn.DataTable.isDataTable('#table_productionData')) {
                $('#table_productionData').DataTable().clear().destroy();
            }

            productionData_table = $('#table_productionData').DataTable({
                data: dataArray,
                dom: 't',
                paging: false,
                searching: false,
                info: false,
                ordering: false,
                processing: true,
                deferRender: true,
                destroy: true,
                autoWidth: false,
                scrollX: true,
                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: null,
                        title: "Select",
                        visible: false,
                        orderable: false,
                        searchable: false,
                        className: "text-center",
                        render: function (data, type, row) {

                            var employeeName = (row.Employee || "")
                                .trim()
                                .toUpperCase();

                            var isChecked = employeeName === uwNameValue
                                ? 'checked'
                                : '';

                            return `
                                <input type="checkbox"
                                       class="production-checkbox"
                                       id="${blankForNull(row.ProdID)}"
                                       data-prodid="${blankForNull(row.ProdID)}"
                                       ${isChecked}
                                       onchange="return GetCheckedCheckboxes_Prod(this);" />
                            `;
                        }
                    },
                    {
                        data: null,
                        title: "Sr. No.",
                        className: "text-center text-nowrap",
                        width: "70px",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    {
                        data: "ProdID",
                        title: "ProdID",
                        visible: false,
                        defaultContent: ""
                    },
                    {
                        data: "Code",
                        title: "Code",
                        className: "text-nowrap",
                        defaultContent: "",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                    {
                        data: "Employee",
                        title: "Employee",
                        className: "text-nowrap",
                        defaultContent: "",
                        render: function (data) {
                            return blankForNull(data).toUpperCase();
                        }
                    },
                    {
                        data: "Process",
                        title: "Process",
                        className: "text-nowrap",
                        defaultContent: "",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    },
                    {
                        data: "CompletionDate",
                        title: "Completion Date",
                        className: "text-nowrap text-center",
                        defaultContent: "",
                        render: function (data) {
                            return blankForNull(data);
                        }
                    }
                ],

                language: {
                    emptyTable: "No production records found."
                },

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {

            $('#load1').hide();

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: xhr.responseJSON && xhr.responseJSON.Message
                    ? xhr.responseJSON.Message
                    : 'Unable to load production data.'
            });
        }
    });

    return false;
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












