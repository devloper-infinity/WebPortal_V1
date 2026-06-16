var us_segutil_html = '';
var us_segutil_table;
var us_indvPerformance_table;
var us_indvPerformance_html = '';
var us_production_table;
var us_production_html = '';
var us_feedbackDump_table;
var us_feedbackDump_html = '';

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function us_creditcons_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_creditcons_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_creditcons_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_creditcons_year").append($("<option></option>").val(i).html(i));
    }
}

function us_creditutil_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_creditutil_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_creditutil_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_creditutil_year").append($("<option></option>").val(i).html(i));
    }
}

function US_Credit_OpenReport(index) {
    if (index == 2)
        BindProjectQGrid();
    else if (index == 3)
        BindSegmentQGrid();
    else if (index == 4)
        BindReviewerQGrid();
    else if (index == 5)
        BindQualityQGrid();
    else if (index == 6)
        BindAvgSalaryGrid();
    else if (index == 7)
        BindIndividualPerfrmanceGrid();
    else if (index == 8)
        BindProductionReportGrid();
    else if (index == 9)
        BindFeedbackDumpGrid();
    else if (index == 10)
        BindWeeklyTrendingGrid();
    else if (index == 11)
        BindMonthlyTrendingGrid();
    else if (index == 12)
        BindErrorTrendingAllGrid();
    else if (index == 13)
        BindErrorTrendingUserGrid();
}

function US_BindAllGrids() {
    // $('#load1').show();
    BindProjectInflowGrid();
    //BindProjectQGrid();
    //BindReviewerQGrid();
    //BindQualityQGrid();
    //BindAvgSalaryGrid();
    //BindIndividualPerfrmanceGrid();
    //BindProductionReportGrid();
    //BindFeedbackDumpGrid();
    //$('#load1').hide();
    return false;
}

function US_BindProjectInflowGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetProjectInflow",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_project_table')) {
                $('#us_project_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_project_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: false,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindProjectQGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetProjectQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_projectQ_table')) {
                $('#us_projectQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_projectQ_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: false,
                ordering: false,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindReviewerQGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetReviewerQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_ReviewerQ_table')) {
                $('#us_ReviewerQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_ReviewerQ_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindSegmentQGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetSegmentQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_segmentQ_table')) {
                $('#us_segmentQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_segmentQ_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindQualityQGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetQualityQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_qualityQ_table')) {
                $('#us_qualityQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_qualityQ_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindAvgSalaryGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    us_segutil_html = '';
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetAvgSalaryQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                us_segutil_html += '<tr>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Month) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Process) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.FTE) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Prod) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.AvgProd) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Target) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Capacity) + '</td>';
                us_segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Utilisation) + '</td>';
                us_segutil_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#us_segmentwiseutilisation_table')) {
                us_segutil_table.destroy();
            }
            $('#us_segmentwiseutilisation_table tbody').html(us_segutil_html);

            us_segutil_table = $('#us_segmentwiseutilisation_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: false,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

                },
            });
        }
    });

    return false;
}

function US_BindIndividualPerfrmanceGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    us_indvPerformance_html = '';
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetIndividualalary",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                us_indvPerformance_html += '<tr>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Segment) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Stage) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Code) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.JoiningDate) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Name) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Pseudoname) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Tenured) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.ProductivityPercentage) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.QualPerc) + '</td>';
                us_indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Production) + '</td>';
                us_indvPerformance_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#us_indvPerformance_table')) {
                us_indvPerformance_table.destroy();
            }
            $('#us_indvPerformance_table tbody').html(us_indvPerformance_html);

            us_indvPerformance_table = $('#us_indvPerformance_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: false,
                "autoWidth": true,
                select: true,
                processing: true,
                ordering: false,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                },
            });
        }
    });

    return false;
}

function US_BindProductionReportGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    us_production_html = '';

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetProductionReport",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                us_production_html += '<tr>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Employee) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Projectname) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.DealNo) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.LoanNo) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Process1) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Date) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.StartDate) + '</td>';
                us_production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.EndDate) + '</td>';
                us_production_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#production_table')) {
                us_production_table.destroy();
            }
            $('#production_table tbody').html(us_production_html);

            us_production_table = $('#production_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                ordering: false,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');

                },
            });
        }
    });

    return false;
}

function US_BindFeedbackDumpGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetFeedbackDump",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_feedbackDump_table')) {
                $('#us_feedbackDump_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_feedbackDump_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function us_getweeklytrending() {
    US_BindWeeklyTrendingGrid();
    return false;
}

function us_getmonthlytrending() {
    US_BindMonthlyTrendingGrid();
    return false;
}

function US_BindWeeklyTrendingGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    var columns = [];

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetWeeklyTrending",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_weeklytrending_table')) {
                $('#us_weeklytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_weeklytrending_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindMonthlyTrendingGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    var columns = [];

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetMonthlyTrending",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_monthlytrending_table')) {
                $('#us_monthlytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_monthlytrending_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindErrorTrendingAllGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetErrorTrendingAll",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_errortrendingall_table')) {
                $('#us_errortrendingall_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_errortrendingall_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function US_BindErrorTrendingUserGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("us_creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }


    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetErrorTrendingUser",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#us_errortrendinguser_table')) {
                $('#us_errortrendinguser_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#us_errortrendinguser_table').DataTable({
                dom: 'lftp',
                scrollX: true,
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                "aaSorting": [],
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                columns: columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}