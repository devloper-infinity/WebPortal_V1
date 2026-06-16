var segutil_html = '';
var segutil_table;
var indvPerformance_table;
var indvPerformance_html = '';
var production_table;
var production_html = '';
var feedbackDump_table;
var feedbackDump_html = '';

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function creditcons_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("creditcons_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#creditcons_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#creditcons_year").append($("<option></option>").val(i).html(i));
    }
}

function creditutil_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("creditutil_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#creditutil_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#creditutil_year").append($("<option></option>").val(i).html(i));
    }
}

function Credit_OpenReport(index) {
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

function BindAllGrids() {
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

function BindProjectInflowGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetProjectInflow",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#project_table')) {
                $('#project_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#project_table').DataTable({
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

function BindProjectQGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetProjectQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#projectQ_table')) {
                $('#projectQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#projectQ_table').DataTable({
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

function BindReviewerQGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetReviewerQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#ReviewerQ_table')) {
                $('#ReviewerQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#ReviewerQ_table').DataTable({
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

function BindSegmentQGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetSegmentQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#segmentQ_table')) {
                $('#segmentQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#segmentQ_table').DataTable({
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

function BindQualityQGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetQualityQ",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#qualityQ_table')) {
                $('#qualityQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#qualityQ_table').DataTable({
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

function BindAvgSalaryGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    segutil_html = '';
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
                segutil_html += '<tr>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Month) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Process) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.FTE) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Prod) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.AvgProd) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Target) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Capacity) + '</td>';
                segutil_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Utilisation) + '</td>';
                segutil_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#segmentwiseutilisation_table')) {
                segutil_table.destroy();
            }
            $('#segmentwiseutilisation_table tbody').html(segutil_html);

            segutil_table = $('#segmentwiseutilisation_table').DataTable({
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

function BindIndividualPerfrmanceGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    indvPerformance_html = '';
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
                indvPerformance_html += '<tr>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Segment) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Stage) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Code) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.JoiningDate) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Name) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Pseudoname) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Tenured) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.ProductivityPercentage) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.QualPerc) + '</td>';
                indvPerformance_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Production) + '</td>';
                indvPerformance_html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#indvPerformance_table')) {
                indvPerformance_table.destroy();
            }
            $('#indvPerformance_table tbody').html(indvPerformance_html);

            indvPerformance_table = $('#indvPerformance_table').DataTable({
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

function BindProductionReportGrid() {
    $('#load1').show();

    var ddlmonth = document.getElementById("creditcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("creditcons_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    production_html = '';
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
                production_html += '<tr>';
                production_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Employee) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Projectname) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.DealNo) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.LoanNo) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Process1) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.Date) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.StartDate) + '</td>';
                production_html += '<td style="text-wrap: nowrap; text-align: center; ">' + blankForNull(value.EndDate) + '</td>';
                production_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#production_table')) {
                production_table.destroy();
            }
            $('#production_table tbody').html(production_html);

            production_table = $('#production_table').DataTable({
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

function BindFeedbackDumpGrid() {
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
            if ($.fn.dataTable.isDataTable('#feedbackDump_table')) {
                $('#feedbackDump_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#feedbackDump_table').DataTable({
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

function getweeklytrending() {
    BindWeeklyTrendingGrid();
    return false;
}

function getmonthlytrending() {
    BindMonthlyTrendingGrid();
    return false;
}

function BindWeeklyTrendingGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetWeeklyTrending",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#weeklytrending_table')) {
                $('#weeklytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#weeklytrending_table').DataTable({
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

function BindMonthlyTrendingGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetMonthlyTrending",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#monthlytrending_table')) {
                $('#monthlytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#monthlytrending_table').DataTable({
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

function BindErrorTrendingAllGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetErrorTrendingAll",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#errortrendingall_table')) {
                $('#errortrendingall_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#errortrendingall_table').DataTable({
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

function BindErrorTrendingUserGrid() {
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
        url: "CreditConsolidatedReport.aspx/GetErrorTrendingUser",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#errortrendinguser_table')) {
                $('#errortrendinguser_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#errortrendinguser_table').DataTable({
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