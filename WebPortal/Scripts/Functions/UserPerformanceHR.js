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


/*------------- bind grid -------------*/
function NonDD_summary_bindGrid(fromDate1, toDate1) {

    fromDate = fromDate1;
    toDate = toDate1;

    if (!fromDate || !toDate) {
        alert("Select dates");
        return;
    }

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

            });

            if (dataArray.length == 0) {

                $('#load1').hide();
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function NonDD_Prod_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

            });

            if (dataArray.length == 0) {
                $('#load1').hide();
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function NonDD_feedback_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

            });

            if (dataArray.length == 0) {
                $('#load1').hide();
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function NonDD_attn_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "nondd", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}


function cred_summary_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function cred_Prod_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function cred_feedback_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function cred_attn_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "credit", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}


function serv_summary_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "summary", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function serv_Prod_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "production", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },


            });

            if (dataArray.length == 0) {
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function serv_feedback_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "feedback", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

            });
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}

function serv_attn_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "UserPerformanceHrReport.aspx/GetHRUserData",
        data: JSON.stringify({ type: "servicing", tab: "attendance", FromDate: fromDate, EndDate: toDate }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = data.d || [];

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
                    $('#load1').hide();
                    tableLoaded();
                },

                //complete: function () {
                //    $('#load1').hide();
                //    tableLoaded();
                //},
            });

            if (dataArray.length == 0) {
                $('#load1').hide();
                tableLoaded();
            }
        },

        error: function (error) {
            alert(error.responseText);
        }
    });

    return false;
}


/*------------- export to excel -------------*/
function showWaiting() {
    waitingModal = new bootstrap.Modal(document.getElementById('waitingpanel'));
    waitingModal.show();

    $("#excelProgressBar").css("width", "0%");

    $(".excel-steps li").each(function () {
        var text = $(this).text().substring(2);
        $(this).text("⬜ " + text);
    });

    tablesLoaded = 0;
    currentStep = 0;
}

function hideWaiting() {
    if (waitingModal) waitingModal.hide();
}

function updateProgressStep() {
    currentStep++;

    var percent = (currentStep / tablesToLoad) * 100;
    $("#excelProgressBar").css("width", percent + "%");

    var stepItem = $("#step" + currentStep);
    var text = stepItem.text().substring(2);

    // Highlight current step
    $("#excelSteps li").removeClass("activeStep");
    stepItem.addClass("activeStep");

    stepItem.text("✔ " + text);

    // Safe scroll
    if (stepItem.length) {
        stepItem[0].scrollIntoView({ behavior: "smooth", block: "center" });
    }
}

function tableLoaded() {
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
    $('#load1').hide();

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

    $("#excelProgressBar").css("width", "0%");
    $(".excel-steps li").each(function () {
        var text = $(this).text().substring(2);
        $(this).text("⬜ " + text);
    });
}

function server_updateProgress(step) {

    var totalSteps = 13;

    $(".excel-steps li").each(function () {
        var id = $(this).attr("id").replace("step", "");
        id = parseInt(id);

        var text = $(this).text().substring(2);

        if (id < step) {
            $(this).text("✔ " + text);
            $(this).removeClass("step-active").addClass("step-done");
        }
        else if (id == step) {
            $(this).text("⏳ " + text);
            $(this).removeClass("step-done").addClass("step-active");
        }
        else {
            $(this).text("⬜ " + text);
            $(this).removeClass("step-active step-done");
        }
    });

    // Progress Bar
    var percent = ((step - 1) / totalSteps) * 100;
    $("#excelProgressBar").css("width", percent + "%");
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
                $("#excelProgressBar").css("width", "100%");

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

    $('#load1').hide();

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

