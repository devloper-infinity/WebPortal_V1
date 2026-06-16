var segutil_html = '';
var segutil_table;
var indvPerformance_table;
var indvPerformance_html = '';
var production_table;
var production_html = '';
var feedbackDump_table;
var feedbackDump_html = '';
var feedbackDumpEnglish_table;
var feedbackDumpEnglish_html = '';
var feedbackDumpDelivery_table=''
var feedbackDumpReQC_table = ''


function blankForNull(s) {
    return s == "null" || s == null ? "" : s;

}

function servcons_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("servcons_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#servcons_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#servcons_year").append($("<option></option>").val(i).html(i));
    }
}

function Servicing_OpenReport(index) {
   
    if (index == 2)
        BindProjectQGrid_Serv();
    else if (index == 3)
        BindSegmentQGrid_Serv();
    else if (index == 4)
        BindReviewerQGrid_Serv();
    else if (index == 5)
        BindQualityQGrid_Serv();
    else if (index == 6)
        BindAvgSalaryGrid_Serv();
    else if (index == 7)
        BindIndividualPerfrmanceGrid_Serv();
    else if (index == 8)
        BindProductionReportGrid_Serv();
    else if (index == 9)
        BindFeedbackDumpGrid_Serv();
    else if (index == 10)
        BindWeeklyTrendingGrid_Serv();
    else if (index == 11)
        BindMonthlyTrendingGrid_Serv();
    else if (index == 12)
        BindErrorTrendingAllGrid_Serv();
    else if (index == 13)
        BindErrorTrendingUserGrid_Serv();
    else if (index == 14) 
        BindFeedbackDumpGrid_English_Serv();
    else if (index == 15)
        BindFeedbackDumpGrid_RQC_Serv();
    else if (index == 16)
        BindFeedbackDumpGrid_RQCRW_Serv();
}


function BindFeedbackDumpGrid_RQCRW_Serv() {
    $('#load1').show();
    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDump_RQC_RW",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#feedbackDumpReQC_table')) {
                $('#feedbackDumpReQC_table').DataTable().destroy();
            }  /*alert(data.d);*/
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#feedbackDumpReQC_table').DataTable({
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

function BindFeedbackDumpGrid_RQC_Serv() {

    $('#load1').show();
    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDump_RQC",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
          
            if ($.fn.dataTable.isDataTable('#feedbackDumpDelivery_table')) {
                $('#feedbackDumpDelivery_table').DataTable().destroy();
            }  /*alert(data.d);*/
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#feedbackDumpDelivery_table').DataTable({
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

function BindFeedbackDumpGrid_English_Serv() {

    $('#load1').show();
    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDump_1",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            if ($.fn.dataTable.isDataTable('#feedbackDumpEnglish_table')) {
                $('#feedbackDumpEnglish_table').DataTable().destroy();
            }  /*alert(data.d);*/
            dataArray = JSON.parse(data.d);
            columnNames = Object.keys(dataArray[0]); //.Table[0]] refers to the propery name of the returned json
            for (var i in columnNames) {
                columns.push({
                    data: columnNames[i],
                    title: columnNames[i]
                });
            }
            $('#feedbackDumpEnglish_table').DataTable({
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

function BindAllGrids_Serv() {
   // $('#load1').show();
    BindProjectInflowGrid_Serv();
    //BindProjectQGrid_Serv();
    //BindReviewerQGrid_Serv();
    //BindQualityQGrid_Serv();
    //BindAvgSalaryGrid_Serv();
    //BindIndividualPerfrmanceGrid_Serv();
    //BindProductionReportGrid_Serv();
    //BindFeedbackDumpGrid_Serv();
    //$('#load1').hide();
    return false;
}

function BindProjectInflowGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetProjectInflow",
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

function BindProjectQGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetProjectQ",
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
                ordering:false,
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

function BindReviewerQGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetReviewerQ",
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

function BindSegmentQGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetSegmentQ",
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

function BindQualityQGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetQualityQ",
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

function BindAvgSalaryGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetAvgSalaryQ",
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

function BindIndividualPerfrmanceGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetIndividualalary",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {
                indvPerformance_html += '<tr>';
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

function BindProductionReportGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetProductionReport",
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

function BindFeedbackDumpGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDump",
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
    BindWeeklyTrendingGrid_Serv();
    return false;
}

function getmonthlytrending() {
    BindMonthlyTrendingGrid_Serv();
    return false;
}

function BindWeeklyTrendingGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetWeeklyTrending",
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

function BindMonthlyTrendingGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetMonthlyTrending",
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

function BindErrorTrendingAllGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetErrorTrendingAll",
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

function BindErrorTrendingUserGrid_Serv() {
    $('#load1').show();

    var ddlmonth = document.getElementById("servcons_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("servcons_year");
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
        url: "ServicingConsolidatedReport.aspx/GetErrorTrendingUser",
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