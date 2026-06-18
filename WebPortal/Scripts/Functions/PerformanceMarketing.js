
var uprMark_attendancetable;
var uprMarkprod_html = "";
var uprMarkprod_table;
var uprSummaryMark_html = "";
var uprSummaryMark_table;
var uprMark_table;

function uprMark_submit() {

    var FromDate = document.getElementById("uprMark_fromdate").value;
    var ToDate = document.getElementById("uprMark_todate").value;

    //uprMark_BindSummaryGrid("26-Jun-2025", "25-Jul-2025");
    //uprMark_BindProductionGrid("26-Jun-2025", "25-Jul-2025");
    //uprMark_BindAttendanceGrid("26-Jun-2025", "25-Jul-2025");

    if (FromDate == "") {
        alert("Please select From Date");
        return false;
    }
    if (ToDate == "") {
        alert("Please select To Date");
        return false;
    }

    if (FromDate != "" && ToDate != "")
    {
        uprMark_BindSummaryGrid(FromDate, ToDate);
        uprMark_BindProductionGrid(FromDate, ToDate);
        uprMark_BindAttendanceGrid(FromDate, ToDate);
    }

    return false;
}

function uprMark_BindSummaryGrid(FromDate, ToDate) {

    $('#load1').show();

    var filename = 'Marketing Summary ' + FromDate + ' ~ ' + ToDate;

    $.ajax({
        url: "UserPerformanceReportMarketing.aspx/GetDailyProducvityReport_KPSummary",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            uprSummaryMark_html = "";

            $.each(dataArray, function (index, value) {

                uprSummaryMark_html += '<tr>';
                /*uprSummaryMark_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';*/
                //uprSummaryMark_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Month) + '</td>';
                //uprSummaryMark_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Year) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FullName) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Pseudoname) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.Production) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.ProductivityPer) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.ProductionGrade) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.QualPerc) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.QualGrade) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.OnTotalDays) + '</td>';
                uprSummaryMark_html += '<td style="text-wrap: nowrap; text-align: center;">' + blankForNull(value.AttendanceGrade) + '</td>';
                uprSummaryMark_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#table_uprSummaryMark')) {
                uprSummaryMark_table.destroy();
            }

            $('#table_uprSummaryMark tbody').html(uprSummaryMark_html);
            uprSummaryMark_table = $('#table_uprSummaryMark').DataTable({
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
                        extend: 'excelHtml5', title: filename, autoFilter: true,
                    },
                ],
            });

        },
        error: function (error) {
            $('#load1').hide();
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function uprMark_BindProductionGrid(FromDate, ToDate) {

    $('#load1').show();

    var filename = 'Production Report ' + FromDate + ' ~ ' + ToDate;

    $.ajax({
        url: "UserPerformanceReportMarketing.aspx/GetDailyProducvityReport",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            uprMarkprod_html = "";

            $.each(dataArray, function (index, value) {
                uprMarkprod_html += '<tr>';
                /*uprMarkprod_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';*/
                uprMarkprod_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FullName) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Date) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.DomainName) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Criteria) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Target) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Production) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.Leads) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.TimeSpent) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Source) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                uprMarkprod_html += '<td style="text-wrap: nowrap; text-align:center;">' + blankForNull(value.AddedDate) + '</td>';
                uprMarkprod_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#uprMark_tableprod')) {
                uprMarkprod_table.destroy();
            }

            $('#uprMark_tableprod tbody').html(uprMarkprod_html);
            uprMarkprod_table = $('#uprMark_tableprod').DataTable({
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
                        extend: 'excelHtml5', title: filename, autoFilter: true,
                    },
                ],
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function uprMark_BindAttendanceGrid(FromDate, ToDate) {
    $('#load1').show();
    var filename = 'Attendance Details ' + FromDate + ' ~ ' + ToDate;

    $.ajax({
        url: "UserPerformanceReportMarketing.aspx/GetUserPerformanceAttendanceDetails_KP",
        type: "POST",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//

            uprMark_attendancetable = $('#uprMark_attendancetable').DataTable({
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
                        extend: 'excelHtml5', title: filename, autoFilter: true,
                    },
                ],
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}
