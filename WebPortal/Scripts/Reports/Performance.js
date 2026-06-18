var upr_attendancetable;
var upr_feedbacktable;
var upr_tableprod;
var upr_table;


function upr_BindUsers() {
    var select = document.getElementById("upr_users");
    let options = select.getElementsByTagName('upr_users');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#upr_users").append($("<option></option>").val("").html("Select"));
    $("#upr_users").append($("<option></option>").val("0").html("All"));


    $.ajax({
        type: "POST", url: "UserPerformanceReport.aspx/GetAllUsers", dataType: "json", contentType: "application/json",

        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#upr_users").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
            })
        }
    });
}


function perform_validations() {

    var FromDate = $("#upr_fromdate").val();
    var ToDate = $("#upr_todate").val();

    // FromDate = '26-Apr-2026';
    // ToDate = '25-May-2026';


    if (!FromDate) {
        Swal.fire("Validation", "Please select From Date.", "warning");
        return false;
    }

    if (!ToDate) {
        Swal.fire("Validation", "Please select To Date.", "warning");
        return false;
    }

    var from = new Date(FromDate);
    var to = new Date(ToDate);

    if (isNaN(from.getTime())) {
        Swal.fire("Validation", "Invalid From Date.", "warning");
        return false;
    }

    if (isNaN(to.getTime())) {
        Swal.fire("Validation", "Invalid To Date.", "warning");
        return false;
    }

    if (to < from) {
        Swal.fire("Validation", "To Date must be greater than or equal to From Date.", "warning");
        return false;
    }

    upr_bindSummary();
}

function upr_submit() {

    perform_validations();
}

function upr_bindSummary() {

    Swal.fire({
        title: "Please Wait",
        text: "Generating user performance report...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceReport",
        type: "POST",
        dataType: "json",
        data: JSON.stringify({
            FromDate: FromDate,
            ToDate: ToDate
        }),
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            Swal.close();

            var dataArray = JSON.parse(data.d);

            if (!dataArray || dataArray.length === 0) {
                Swal.fire("No Data", "No records found for selected date range.", "info");
                return false;
            }

            upr_table = $('#upr_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                filter: true,
                serverSide: false,
                data: dataArray,
                select: {
                    style: 'single'
                },
                columns: [
                    { data: 'Month' },
                    { data: 'Year' },
                    { data: 'Code' },
                    { data: 'EmployeeName' },
                    { data: 'Employee' },
                    { data: 'LoanCount' },
                    { data: 'ProdPerc' },
                    { data: 'QualityPerc' },
                    { data: 'AttPerc' },
                    { data: 'ProdGrade' },
                    { data: 'QualGrade' },
                    { data: 'AttnGrade' }
                ],
                fnCreatedRow: function (nRow) {
                    $(nRow).children("td").css({
                        "text-wrap": "nowrap",
                        "text-align": "center"
                    });
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'User Performance Report',
                        autoFilter: true
                    }
                ]
            });
        },

        error: function (error) {

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: error.responseText || "Something went wrong while generating report."
            });
        }
    });

    return false;
}

function core_upr_submit() {

    $('#load1').show();
    var FromDate = document.getElementById("upr_fromdate").value;
    var ToDate = document.getElementById("upr_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceReport",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);//
            upr_table = $('#upr_table').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                    { data: 'Month' },
                    { data: 'Year' },
                    { data: 'Code' },
                    { data: 'EmployeeName' },
                    { data: 'Employee' },
                    { data: 'LoanCount' },
                    { data: 'ProdPerc' },
                    { data: 'QualityPerc' },
                    { data: 'AttPerc' },
                    { data: 'ProdGrade' },
                    { data: 'QualGrade' },
                    { data: 'AttnGrade' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },

                initComplete: function () {

                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'User Performance Report', autoFilter: true,
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

function upr_getProdDetails() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("upr_fromdate").value;
    var ToDate = document.getElementById("upr_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceProdDetails",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            upr_tableprod = $('#upr_tableprod').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
                columnDefs: [
                    { className: "dt-center", targets: "_all" } // Centers all columns
                ],

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'User Performance Report - Production Details', autoFilter: true,
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

function upr_getFeedbackDetails() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("upr_fromdate").value;
    var ToDate = document.getElementById("upr_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceFeedbackDetails",
        type: "POST",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            upr_feedbacktable = $('#upr_feedbacktable').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                columns: columns,

                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Feedback Details', autoFilter: true,
                    },
                ],
                columnDefs: [
                    { className: "dt-center", targets: "_all" } // Centers all columns
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

function upr_getAttendanceDetails() {

    $('#load1').show();
    var FromDate = document.getElementById("upr_fromdate").value;
    var ToDate = document.getElementById("upr_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceAttendanceDetails",
        type: "POST",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            upr_attendancetable = $('#upr_attendancetable').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                    { data: 'Code' },
                    { data: 'TotalCalenderDays' },
                    { data: 'AbsentDays' },
                    { data: 'PartialCount' },
                    { data: 'PartialDays' },
                    { data: 'TotalAbsentDays' },
                    { data: 'SalaryPresentDays' },
                    { data: 'AttendancePercOnTotalDays' },
                    { data: 'Latemarks' },
                    { data: 'RemovedLatemarks' },
                    { data: 'TotalLatemarks' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Attendance Details', autoFilter: true,
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

//Loan and Process Details
function GetLoanAndProcessDetails() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("trckloan_fromdate").value;
    var ToDate = document.getElementById("trckloan_todate").value;

    $.ajax({
        url: "LoanDetails.aspx/GetLoanProcessDetails",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#trckloan_tableprod').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
                columnDefs: [
                    { className: "dt-center", targets: "_all" } // Centers all columns
                ],
                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Tracking Sheet', autoFilter: true,
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

function GetLoanAndProcesssummary() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("trckloan_fromdate").value;
    var ToDate = document.getElementById("trckloan_todate").value;

    $.ajax({
        url: "LoanDetails.aspx/GetLoanProcessSummary",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#trckloan_summarytable').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
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
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    $(nRow).children("td").css("text-align", "center");
                },
                columnDefs: [
                    { className: "dt-center", targets: "_all" } // Centers all columns
                ],
                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Tracking Sheet', autoFilter: true,
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


/*------------------- User Performance Report Marketing -------------------*/
