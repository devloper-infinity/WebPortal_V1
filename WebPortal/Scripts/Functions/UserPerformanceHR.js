var tablesToLoad = 11;
var tablesLoaded = 0;

var nondd_Summary_table;
var nondd_prod_table;
var nondd_feedback_table;
var nondd_attn_table;
var cred_Summary_table;
var cred_prod_table;
var cred_feedback_table;
var cred_attn_table;
var serv_Summary_table;
var serv_prod_table;
var serv_feedback_table;
var serv_attn_table;
var fromDate;
var toDate;

var tablesToLoad = 12;
var tablesLoaded = 0;
var currentStep = 0;
var waitingModal;
var progressInterval;
var exportStarted = false;
var isExportButtonClicked = false;

function normalizeHRRows(response) {
    var payload = response && response.d !== undefined ? response.d : response;

    if (typeof payload === "string") {
        payload = payload.trim();

        if (!payload) {
            return [];
        }

        try {
            payload = JSON.parse(payload);
        }
        catch (ex) {
            showHRGridError("Unable to read report data returned by the server.");
            console.error("Invalid HR report JSON response", ex, payload);
            return [];
        }
    }

    if (payload && payload.error) {
        showHRGridError(payload.error);
        return [];
    }

    if (payload && $.isArray(payload.data)) {
        return payload.data;
    }

    if ($.isArray(payload)) {
        return payload;
    }

    if (payload == null) {
        return [];
    }

    showHRGridError("Unexpected report data format returned by the server.");
    console.warn("Unexpected HR report response", response);
    return [];
}

function showHRGridError(message) {
    hidePageLoader();

    var cleanMessage = message || "Unable to load report data.";

    if (typeof Swal !== "undefined") {
        Swal.fire({
            icon: "error",
            title: "Report data not loaded",
            text: cleanMessage
        });
    }
    else {
        alert(cleanMessage);
    }
}

function showHRGridAjaxError(error) {
    var message = "Unable to load report data.";

    if (error && error.responseJSON && error.responseJSON.Message) {
        message = error.responseJSON.Message;
    }
    else if (error && error.responseText) {
        message = error.responseText;
    }

    showHRGridError(message);
}

function showPageLoader() {
    $('#load1').css('display', 'flex');
}

function hidePageLoader() {
    $('#load1').hide();
}

function syncHRDateRange(fromDateOverride, toDateOverride) {
    fromDate = fromDateOverride || $("#hrUser_fromDate").val() || fromDate;
    toDate = toDateOverride || $("#hrUser_toDate").val() || toDate;

    if (!fromDate || !toDate) {
        if (typeof Swal !== "undefined") {
            Swal.fire({
                icon: "warning",
                title: "Select dates",
                text: "Please select From Date and To Date."
            });
        }
        else {
            alert("Select dates");
        }

        return false;
    }

    return true;
}

$(document).on('shown.bs.tab', 'a[data-toggle="pill"]', function () {
    if ($.fn.dataTable) {
        $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust();
    }
});


/*------------- bind grid -------------*/
function NonDD_summary_bindGrid(fromDate1, toDate1) {

    if (!syncHRDateRange(fromDate1, toDate1)) {
        return;
    }

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            nondd_Summary_table = $('#table_nondd_Summary').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'Code', title: 'Code' },
                    { data: 'Employee', title: 'Name' },
                    { data: 'EmployeeName', title: 'Pseudo Name' },
                    { data: 'LoanCount', title: 'Production Count' },
                    { data: 'ProdPerc', title: 'Production %' },
                    { data: 'QualityPerc', title: 'Quality %' },
                    { data: 'AttPerc', title: 'Attendance %' },
                    { data: 'ProdGrade', title: 'Production Grade', className: "text-center" },
                    { data: 'QualGrade', title: 'Quality Grade', className: "text-center" },
                    { data: 'AttnGrade', title: 'Attendance Grade', className: "text-center" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function NonDD_Prod_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            nondd_prod_table = $('#table_nondd_prod').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: "Code", title: "Code" },
                    { data: "Name", title: "Name" },
                    { data: "Project #", title: "Project #" },
                    { data: "Process", title: "Process" },
                    { data: "Process Date", title: "Process Date" },
                    { data: "Production", title: "Production" },
                    { data: "Target", title: "Target" },
                    { data: "Time Spent", title: "Time Spent" },
                    { data: "Remark", title: "Remark" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function NonDD_feedback_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            nondd_feedback_table = $('#table_nondd_feedback').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'ProjectName', title: 'Project' },
                    { data: 'DealNo', title: 'Deal #' },
                    { data: 'OrderNo', title: 'Loan #' },
                    { data: 'OrderDate', title: 'Order Date' },
                    { data: 'ProcessName', title: 'Process' },
                    { data: 'ErrorDoneBY', title: 'Error Done By' },
                    { data: 'FeedbackBy', title: 'Feedback Given By' },
                    { data: 'ErrorType', title: 'Error Type' },
                    { data: 'Severity', title: 'Severity' },
                    { data: 'FeildName', title: 'Error Field' },
                    { data: 'Category', title: 'Category' },
                    { data: 'SubCategory', title: 'Sub Category' },
                    { data: 'Error', title: 'Error' },
                    { data: 'ShouldBe', title: 'Should Be' },
                    { data: 'FeedbackType', title: 'Feedback Type' },
                    { data: 'FeedbackRecivedDate', title: 'Feedback Recived Date' },
                    { data: 'Remark', title: 'Remark' },
                    { data: 'Status', title: 'Status' },
                    { data: 'Explaination', title: 'Explaination' },
                    { data: 'PMStatus', title: 'PM Status' },
                    { data: 'PMRemark', title: 'PM Remark' },
                    { data: 'AddedDate', title: 'Added Date' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function NonDD_attn_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            nondd_attn_table = $('#table_nondd_attn').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Code', title: 'Code' },
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'TotalCalenderDays', title: 'Total Days (Calender Days)' },
                    { data: 'AbsentDays', title: 'Absent Days (Full Days)' },
                    { data: 'PartialCount', title: 'Partial Days' },
                    { data: 'PartialDays', title: 'Partial days (equivalent full days)' },
                    { data: 'TotalAbsentDays', title: 'Total Absents (Full day + Partial Days)' },
                    { data: 'SalaryPresentDays', title: 'Present Days (as per Final Salary Calculation)' },
                    { data: 'AttendancePercOnTotalDays', title: 'Attendance % on Total Days' },
                    { data: 'Latemarks', title: 'Latemarks' },
                    { data: 'RemovedLatemarks', title: 'Latemarks Removed' },
                    { data: 'TotalLatemarks', title: 'Total Latemarks' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });

        },

        error: showHRGridAjaxError
    });

    return false;
}


function cred_summary_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            cred_Summary_table = $('#table_cred_Summary').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'Code', title: 'Code' },
                    { data: 'Employee', title: 'Name' },
                    { data: 'EmployeeName', title: 'Pseudo Name' },
                    { data: 'LoanCount', title: 'Production Count' },
                    { data: 'ProdPerc', title: 'Production %' },
                    { data: 'QualityPerc', title: 'Quality %' },
                    { data: 'AttPerc', title: 'Attendance %' },
                    { data: 'ProdGrade', title: 'Production Grade', className: "text-center" },
                    { data: 'QualGrade', title: 'Quality Grade', className: "text-center" },
                    { data: 'AttnGrade', title: 'Attendance Grade', className: "text-center" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function cred_Prod_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            cred_prod_table = $('#table_cred_prod').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                columns: [
                    { data: "Code", title: "Code" },
                    { data: "Name", title: "Name" },
                    { data: "Project #", title: "Project #" },
                    { data: "Process", title: "Process" },
                    { data: "Process Date", title: "Process Date" },
                    { data: "Production", title: "Production" },
                    { data: "Target", title: "Target" },
                    { data: "Time Spent", title: "Time Spent" },
                    { data: "Remark", title: "Remark" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function cred_feedback_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            cred_feedback_table = $('#table_cred_feedback').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'ProjectName', title: 'Project' },
                    { data: 'DealNo', title: 'Deal #' },
                    { data: 'OrderNo', title: 'Loan #' },
                    { data: 'OrderDate', title: 'Order Date' },
                    { data: 'ProcessName', title: 'Process' },
                    { data: 'ErrorDoneBY', title: 'Error Done By' },
                    { data: 'FeedbackBy', title: 'Feedback Given By' },
                    { data: 'ErrorType', title: 'Error Type' },
                    { data: 'Severity', title: 'Severity' },
                    { data: 'FeildName', title: 'Error Field' },
                    { data: 'Category', title: 'Category' },
                    { data: 'SubCategory', title: 'Sub Category' },
                    { data: 'Error', title: 'Error' },
                    { data: 'ShouldBe', title: 'Should Be' },
                    { data: 'FeedbackType', title: 'Feedback Type' },
                    { data: 'FeedbackRecivedDate', title: 'Feedback Recived Date' },
                    { data: 'Remark', title: 'Remark' },
                    { data: 'Status', title: 'Status' },
                    { data: 'Explaination', title: 'Explaination' },
                    { data: 'PMStatus', title: 'PM Status' },
                    { data: 'PMRemark', title: 'PM Remark' },
                    { data: 'AddedDate', title: 'Added Date' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });
        },

        error: showHRGridAjaxError
    });

    return false;
}

function cred_attn_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            cred_attn_table = $('#table_cred_attn').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                dom: 'ftip',
                columns: [
                    { data: 'Code', title: 'Code' },
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'TotalCalenderDays', title: 'Total Days (Calender Days)' },
                    { data: 'AbsentDays', title: 'Absent Days (Full Days)' },
                    { data: 'PartialCount', title: 'Partial Days' },
                    { data: 'PartialDays', title: 'Partial days (equivalent full days)' },
                    { data: 'TotalAbsentDays', title: 'Total Absents (Full day + Partial Days)' },
                    { data: 'SalaryPresentDays', title: 'Present Days (as per Final Salary Calculation)' },
                    { data: 'AttendancePercOnTotalDays', title: 'Attendance % on Total Days' },
                    { data: 'Latemarks', title: 'Latemarks' },
                    { data: 'RemovedLatemarks', title: 'Latemarks Removed' },
                    { data: 'TotalLatemarks', title: 'Total Latemarks' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });

        },

        error: showHRGridAjaxError
    });

    return false;
}


function serv_summary_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            serv_Summary_table = $('#table_serv_Summary').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'Code', title: 'Code' },
                    { data: 'Employee', title: 'Name' },
                    { data: 'EmployeeName', title: 'Pseudo Name' },
                    { data: 'LoanCount', title: 'Production Count' },
                    { data: 'ProdPerc', title: 'Production %' },
                    { data: 'QualityPerc', title: 'Quality %' },
                    { data: 'AttPerc', title: 'Attendance %' },
                    { data: 'ProdGrade', title: 'Production Grade', className: "text-center" },
                    { data: 'QualGrade', title: 'Quality Grade', className: "text-center" },
                    { data: 'AttnGrade', title: 'Attendance Grade', className: "text-center" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function serv_Prod_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            serv_prod_table = $('#table_serv_prod').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: "Code", title: "Code" },
                    { data: "Name", title: "Name" },
                    { data: "Project #", title: "Project #" },
                    { data: "Process", title: "Process" },
                    { data: "Process Date", title: "Process Date" },
                    { data: "Production", title: "Production" },
                    { data: "Target", title: "Target" },
                    { data: "Time Spent", title: "Time Spent" },
                    { data: "Remark", title: "Remark" }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },


            });

        },

        error: showHRGridAjaxError
    });

    return false;
}

function serv_feedback_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            serv_feedback_table = $('#table_serv_feedback').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                language: {
                    emptyTable: "No data available"
                },
                dom: 'ftip',
                columns: [
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'ProjectName', title: 'Project' },
                    { data: 'DealNo', title: 'Deal #' },
                    { data: 'OrderNo', title: 'Loan #' },
                    { data: 'OrderDate', title: 'Order Date' },
                    { data: 'ProcessName', title: 'Process' },
                    { data: 'ErrorDoneBY', title: 'Error Done By' },
                    { data: 'FeedbackBy', title: 'Feedback Given By' },
                    { data: 'ErrorType', title: 'Error Type' },
                    { data: 'Severity', title: 'Severity' },
                    { data: 'FeildName', title: 'Error Field' },
                    { data: 'Category', title: 'Category' },
                    { data: 'SubCategory', title: 'Sub Category' },
                    { data: 'Error', title: 'Error' },
                    { data: 'ShouldBe', title: 'Should Be' },
                    { data: 'FeedbackType', title: 'Feedback Type' },
                    { data: 'FeedbackRecivedDate', title: 'Feedback Recived Date' },
                    { data: 'Remark', title: 'Remark' },
                    { data: 'Status', title: 'Status' },
                    { data: 'Explaination', title: 'Explaination' },
                    { data: 'PMStatus', title: 'PM Status' },
                    { data: 'PMRemark', title: 'PM Remark' },
                    { data: 'AddedDate', title: 'Added Date' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

            });
        },

        error: showHRGridAjaxError
    });

    return false;
}

function serv_attn_bindGrid() {

    if (!syncHRDateRange()) return false;

    showPageLoader();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = normalizeHRRows(data);

            serv_attn_table = $('#table_serv_attn').DataTable({
                destroy: true,
                data: dataArray,
                scrollX: true,
                scrollCollapse: true,
                paging: false,
                pageLength: 10,
                deferRender: true,
                processing: true,
                ordering: false,
                searching: false,
                autoWidth: false,
                columnDefs: [{ targets: '_all', defaultContent: '' }],
                dom: 'ftip',
                columns: [
                    { data: 'Code', title: 'Code' },
                    { data: 'Month', title: 'Month' },
                    { data: 'Year', title: 'Year' },
                    { data: 'TotalCalenderDays', title: 'Total Days (Calender Days)' },
                    { data: 'AbsentDays', title: 'Absent Days (Full Days)' },
                    { data: 'PartialCount', title: 'Partial Days' },
                    { data: 'PartialDays', title: 'Partial days (equivalent full days)' },
                    { data: 'TotalAbsentDays', title: 'Total Absents (Full day + Partial Days)' },
                    { data: 'SalaryPresentDays', title: 'Present Days (as per Final Salary Calculation)' },
                    { data: 'AttendancePercOnTotalDays', title: 'Attendance % on Total Days' },
                    { data: 'Latemarks', title: 'Latemarks' },
                    { data: 'RemovedLatemarks', title: 'Latemarks Removed' },
                    { data: 'TotalLatemarks', title: 'Total Latemarks' }
                ],

                initComplete: function () {
                    hidePageLoader();
                    tableLoaded();
                },

                //complete: function () {
                //    hidePageLoader();
                //    tableLoaded();
                //},
            });

        },

        error: showHRGridAjaxError
    });

    return false;
}


/*------------- export to excel -------------*/
function getExcelStepCount() {
    return $(".excel-steps li").length || tablesToLoad + 1 || 13;
}

function getExcelStepLabel(stepItem) {
    var label = stepItem.data("label");

    if (!label) {
        label = $.trim(stepItem.find(".excel-step-name").text() || stepItem.text());
        label = label.replace(/^[^A-Za-z0-9]+/, "").trim();
        stepItem.data("label", label);
    }

    return label;
}

function renderExcelStep(stepItem, stateClass) {
    var label = getExcelStepLabel(stepItem);

    stepItem.removeClass("step-active activeStep step-done");

    if (stateClass) {
        stepItem.addClass(stateClass);
    }

    stepItem.empty()
        .append($("<span>", { "class": "excel-step-marker", "aria-hidden": "true" }))
        .append($("<span>", { "class": "excel-step-name", text: label }));
}

function setExcelProgress(percent) {
    var value = Math.max(0, Math.min(100, Math.round(percent)));

    $("#excelProgressBar")
        .css("width", value + "%")
        .attr("aria-valuenow", value);

    $("#excelProgressText").text(value + "%");
}

function resetExcelProgress() {
    setExcelProgress(0);

    $(".excel-steps li").each(function (index) {
        renderExcelStep($(this), index === 0 ? "step-active" : "");
    });
}

function setExcelStepState(activeStep) {
    var totalSteps = getExcelStepCount();
    var boundedStep = Math.max(1, Math.min(totalSteps, activeStep));

    $(".excel-steps li").each(function () {
        var stepNumber = parseInt(this.id.replace("step", ""), 10);
        var stateClass = "";

        if (stepNumber < boundedStep) {
            stateClass = "step-done";
        }
        else if (stepNumber === boundedStep) {
            stateClass = "step-active";
        }

        renderExcelStep($(this), stateClass);
    });
}

function showWaiting() {
    waitingModal = new bootstrap.Modal(document.getElementById('waitingpanel'));
    waitingModal.show();

    resetExcelProgress();

    tablesLoaded = 0;
    currentStep = 0;
}

function hideWaiting() {
    if (waitingModal) waitingModal.hide();
}

function updateProgressStep() {
    currentStep++;

    var totalSteps = getExcelStepCount();
    var boundedStep = Math.min(currentStep, totalSteps);
    var percent = (boundedStep / totalSteps) * 100;

    setExcelProgress(percent);
    setExcelStepState(boundedStep);

    // Safe scroll
    var stepItem = $("#step" + boundedStep);
    if (stepItem.length) {
        stepItem[0].scrollIntoView({ behavior: "smooth", block: "center" });
    }
}

function tableLoaded() {
    if (!isExportButtonClicked) {
        return;
    }

    tablesLoaded++;

    console.log("Tables Loaded: " + tablesLoaded);

    updateProgressStep();

    if (tablesLoaded >= tablesToLoad && !exportStarted && isExportButtonClicked) {
        exportStarted = true;

        setTimeout(function () {
            exportNow();
            hideWaiting();
            tablesLoaded = 0;
            isExportButtonClicked = false; // reset
        }, 300);
    }

    //if (tablesLoaded >= tablesToLoad && !exportStarted) {
    //    exportStarted = true;

    //    setTimeout(function () {
    //        exportNow();
    //        hideWaiting();
    //        tablesLoaded = 0;
    //    }, 300);
   // }
}

function exportNow() {

    updateProgressStep();

    var wb = XLSX.utils.book_new();

    function exportTable(dtTable, sheetName) {

        var exportData = [];

        if (!dtTable) {
            exportData.push(["No Data"]);
        }
        else {
            // Headers

            dtTable.rows().every(function () { }); // force DataTables sync

            var headers = [];
            dtTable.columns().every(function () {
                headers.push($(this.header()).text().trim());
            });
            exportData.push(headers);

            // Data
            var rowCount = dtTable.rows().count();
            var colCount = dtTable.columns().count();

            for (var i = 0; i < rowCount; i++) {
                var rowData = [];
                for (var j = 0; j < colCount; j++) {
                    rowData.push(dtTable.cell(i, j).data());
                }
                exportData.push(rowData);
            }
        }

        var ws = XLSX.utils.aoa_to_sheet(exportData);
        var range = XLSX.utils.decode_range(ws['!ref']);

        // Header Style Bold
        for (var C = range.s.c; C <= range.e.c; ++C) {
            var cellAddress = XLSX.utils.encode_cell({ r: 0, c: C });

            if (!ws[cellAddress]) continue;

            ws[cellAddress].s = {
                font: { bold: true },
                fill: { fgColor: { rgb: "CBD5C0" } },
                alignment: { horizontal: "center", vertical: "center" }
            };
        }

        // Apply border to all cells
        for (var R = range.s.r; R <= range.e.r; ++R) {
            for (var C = range.s.c; C <= range.e.c; ++C) {
                var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });

                if (!ws[cellAddress]) continue;

                if (!ws[cellAddress].s) ws[cellAddress].s = {};

                ws[cellAddress].s.border = {
                    top: { style: "thin" },
                    bottom: { style: "thin" },
                    left: { style: "thin" },
                    right: { style: "thin" }
                };
            }
        }

        // Auto Width
        var colWidths = [];
        exportData.forEach(function (row) {
            row.forEach(function (cell, i) {
                var length = cell ? cell.toString().length : 10;
                colWidths[i] = Math.max(colWidths[i] || 10, length + 2);
            });
        });

        ws['!cols'] = colWidths.map(w => ({ wch: w }));

        // Freeze header
        ws['!freeze'] = { xSplit: 0, ySplit: 1 };


        // Header height
        ws['!rows'] = [{ hpx: 20 }];

        XLSX.utils.book_append_sheet(wb, ws, sheetName);

    }

    exportTable(nondd_Summary_table, "NonDD Summary");
    exportTable(nondd_prod_table, "NonDD Production");
    exportTable(nondd_feedback_table, "NonDD Feedback");
    exportTable(nondd_attn_table, "NonDD Attendance");

    exportTable(cred_Summary_table, "Credit Summary");
    exportTable(cred_prod_table, "Credit Production");
    exportTable(cred_feedback_table, "Credit Feedback");
    exportTable(cred_attn_table, "Credit Attendance");

    exportTable(serv_Summary_table, "Servicing Summary");
    exportTable(serv_prod_table, "Servicing Production");
    exportTable(serv_feedback_table, "Servicing Feedback");
    exportTable(serv_attn_table, "Servicing Attendance");

    var excelName = "User_Performance_Report_" + fromDate + "_" + toDate + ".xlsx"

    XLSX.writeFile(wb, excelName);
}

function exportAllDataTables() {

    isExportButtonClicked = true;
    hidePageLoader();

    fromDate = $("#hrUser_fromDate").val();
    toDate = $("#hrUser_toDate").val();

    if (!fromDate || !toDate) {
        alert("Select dates");
        return;
    }

    exportStarted = false;   // IMPORTANT
    tablesLoaded = 0;
    currentStep = 0;

    showWaiting();

    NonDD_summary_bindGrid(fromDate, toDate);
    NonDD_Prod_bindGrid();
    NonDD_feedback_bindGrid();
    NonDD_attn_bindGrid();

    cred_summary_bindGrid();
    cred_Prod_bindGrid();
    cred_feedback_bindGrid();
    cred_attn_bindGrid();

    serv_summary_bindGrid();
    serv_Prod_bindGrid();
    serv_feedback_bindGrid();
    serv_attn_bindGrid();

    // fallback
    setTimeout(function () {
        if (tablesLoaded < tablesToLoad && !exportStarted) {
            console.log("Fallback Export Triggered");
            exportStarted = true;
            exportNow();
            hideWaiting();
        }
    }, 20000);
}

$(document).ajaxError(function () {

    console.log("Ajax error occurred");
    /* tableLoaded();*/
});



/*Server side*/
function server_showWaiting() {
    waitingModal = new bootstrap.Modal(document.getElementById('waitingpanel'));
    waitingModal.show();

    resetExcelProgress();
}

function server_updateProgress(step) {

    var totalSteps = getExcelStepCount();
    var boundedStep = Math.max(1, Math.min(totalSteps, step));

    setExcelStepState(boundedStep);
    setExcelProgress((boundedStep / totalSteps) * 100);
}

function updateProgress(step) {
    server_updateProgress(step);
}

function exportExcel() {

    showWaiting();

    $.ajax({
        url: "UserPerformanceHrReport.aspx/StartExport",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({
            FromDate: fromDate,
            ToDate: toDate
        }),
        success: function () {
            progressInterval = setInterval(checkExportProgress, 1000);
        }
    });
}

function checkExportProgress() {

    $.ajax({
        url: "UserPerformanceHrReport.aspx/GetExportProgress",
        method: "POST",
        contentType: "application/json",
        success: function (res) {

            var step = res.d;

            updateProgress(step);

            if (step >= 13) {
                setExcelProgress(100);

                clearInterval(progressInterval);

                setTimeout(function () {
                    window.location = "UserPerformanceHrReport.aspx?download=1";
                    hideWaiting();
                }, 500);
            }
        }
    });
}



/*Client  side*/
function core_tableLoaded() {
    tablesLoaded++;

    console.log("Tables Loaded: " + tablesLoaded);

    updateProgressStep();

    if (tablesLoaded >= tablesToLoad) {
        setTimeout(function () {
            exportNow();
            hideWaiting();
            tablesLoaded = 0;
        }, 300);
    }
}

function Core_exportAllDataTables() {

    hidePageLoader();

    fromDate = $("#hrUser_fromDate").val();
    toDate = $("#hrUser_toDate").val();

    if (!fromDate || !toDate) {
        alert("Select dates");
        return;
    }

    showWaiting();

    NonDD_summary_bindGrid(fromDate, toDate);
    NonDD_Prod_bindGrid();
    NonDD_feedback_bindGrid();
    NonDD_attn_bindGrid();

    cred_summary_bindGrid();
    cred_Prod_bindGrid();
    cred_feedback_bindGrid();
    cred_attn_bindGrid();

    serv_summary_bindGrid();
    serv_Prod_bindGrid();
    serv_feedback_bindGrid();
    serv_attn_bindGrid();

    // FALLBACK TIMER (ADD HERE)
    setTimeout(function () {
        if (tablesLoaded < tablesToLoad) {

            console.log("Fallback Export Triggered");
            exportNow();
            hideWaiting();

        }
    }, 300);

}

function Core_exportTable(dtTable, sheetName) {

    var exportData = [];

    if (!dtTable) {
        // If table not created, still create empty sheet
        exportData.push(["No Data"]);
    }
    else {
        var headers = [];
        dtTable.columns().every(function () {
            headers.push($(this.header()).text());
        });

        exportData.push(headers);

        var data = dtTable.rows().data().toArray();

        if (data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                exportData.push(Object.values(data[i]));
            }
        }
    }

    var ws = XLSX.utils.aoa_to_sheet(exportData);
    XLSX.utils.book_append_sheet(wb, ws, sheetName);
}

