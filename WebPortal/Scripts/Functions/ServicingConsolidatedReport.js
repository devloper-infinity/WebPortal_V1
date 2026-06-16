
var tableData = [];
var cc_project_table;
var cc_project_html;
var swu_html = '';
var rev_html = '';
var qcr_html = '';
var prd_html = '';
var feedback_html = '';
var feedbackEnglish_html = '';

function BindYear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("sc_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#sc_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#sc_year").append($("<option></option>").val(i).html(i));
    }
}

function BindAllGrid() {
    
    BindProjectInflowGrid();
    BindProjectQGrid();
    BindSegmentQGrid();
    BindReviewerQGrid();
    BindQualityQGrid();
    BindSegWiseUtilisationRecordsGrid();
    BindIndividualPerformance(); 
    BindProductionReportGrid();
   // BindFeedbackDumpGrid(); 
    BindWeeklyTrendingReport();
    BindMonthlyTrendingReport();
    BindErrorTrendingAllReport();
    BindErrorTrendingUserWiseReport();
    BindFeedbackDumpGrid_English();
    return false;
}


function BindProjectInflowGrid() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 0;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetProjectInflowRecords",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        // data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#project_table')) {
                $('#project_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#project_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindProjectQGrid() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 1;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetProjectQRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        // data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#projectQ_table')) {
                $('#projectQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#projectQ_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindSegmentQGrid() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 2;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetSegmentQRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //  data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#segmentQ_table')) {
                $('#segmentQ_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#segmentQ_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindReviewerQGrid() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 3;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();
    rev_html = '';
    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetReviewerQRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        // data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                rev_html += '<tr>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Week) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Segment) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Employee) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanCount) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoansQCed) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Critical) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonCritical) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NoFeedback) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.GrandTotal) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ValidCritical) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ValidNC) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalValid) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AVGCritical) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AVGNC) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalOpportunities) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MissedOpportunities) + '</td>';
                rev_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QualityPerc) + '</td>';
                rev_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#ReviewerQ_table')) {
                rev_html.destroy();
            }

            $('#ReviewerQ_table tbody').html(rev_html);

            rev_html = $('#ReviewerQ_table').DataTable({
                dom: 't',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    })
    return false;
}

function BindQualityQGrid() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var DataTableNo = 4;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    qcr_html = '';

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetQualityQRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        // data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                qcr_html += '<tr>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Segment) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Employee) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanCount) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Critical) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NonCritical) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.NoFeedback) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.GrandTotal) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InvalidCritical) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InvalidNC) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalInvalid) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ValidCritical) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ValidNonCritical) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalValid) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalErrors) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorIdentifyingRate) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.TotalOpportunities) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.MissedOpportunities) + '</td>';
                qcr_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QualityPerc) + '</td>';
                qcr_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#qualityQ_table')) {
                qcr_html.destroy();
            }

            $('#qualityQ_table tbody').html(qcr_html);

            qcr_html = $('#qualityQ_table').DataTable({
                dom: 't',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    var val = data[3];
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    })

    return false;
}

function BindSegWiseUtilisationRecordsGrid() {

    swu_html = '';

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var DataTableNo = 5;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetSegWiseUtilisationRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //  data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#segmentwiseutilisation_table')) {
                $('#segmentwiseutilisation_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                swu_html += '<tr>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Month) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FTE) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Prod) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.AvgProd) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Target) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Capacity) + '</td>';
                swu_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Utilisation) + '</td>';
                swu_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#segmentwiseutilisation_table')) {
                swu_html.destroy();
            }

            $('#segmentwiseutilisation_table tbody').html(swu_html);

            swu_html = $('#segmentwiseutilisation_table').DataTable({
                dom: 't',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    var val = data[3];
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

function BindProductionReportGrid() {

    prd_html = '';

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var DataTableNo = 6;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetProductionRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //   data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#production_table')) {
                $('#production_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                prd_html += '<tr>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LocationCode) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Employee) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DealNo) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNo) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Process) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProcessStartTime) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProcessEndTime) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Project) + '</td>';
                prd_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date) + '</td>';
                prd_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#production_table')) {
                prd_html.destroy();
            }

            $('#production_table tbody').html(prd_html);

            prd_html = $('#production_table').DataTable({
                dom: 't',
                scrollX: true,
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
                "rowCallback": function (row, data) {
                    var val = data[3];
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

function BindFeedbackDumpGrid_English()
{
    feedbackEnglish_html = '';
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var DataTableNo = 7;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDumpRecords_Servicing_English",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //  data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#feedbackDumpEnglish_table')) {
                $('#feedbackDumpEnglish_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                //    alert(data.d);
                feedbackEnglish_html += '<tr>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectNo) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DealNo) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNo) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorMarkedTo) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReviewProcess) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReviewDate) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackGivenBy) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCProcess) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QcDate) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorType) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Severity) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorField) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SubCategory) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Error) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShouldBe) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorSource) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Status) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Explaination) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PMStatus) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PMRemark) + '</td>';
                feedbackEnglish_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PM) + '</td>';
                feedbackEnglish_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#feedbackDumpEnglish_table')) {
                feedbackEnglish_html.destroy();
            }

            $('#feedbackDumpEnglish_table tbody').html(feedbackEnglish_html);

            feedback_html = $('#feedbackDumpEnglish_table').DataTable({
                dom: 't',
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
                    var val = data[3];
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

function BindFeedbackDumpGrid() {

    feedback_html = '';

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var DataTableNo = 7;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }

    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetFeedbackDumpRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //  data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#feedbackDump_table')) {
                $('#feedbackDump_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                //    alert(data.d);
                feedback_html += '<tr>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ProjectNo) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.DealNo) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LoanNo) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorMarkedTo) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReviewProcess) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ReviewDate) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.FeedbackGivenBy) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QCProcess) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.QcDate) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorType) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Severity) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorField) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Category) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.SubCategory) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Error) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShouldBe) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ErrorSource) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Remark) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Status) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Explaination) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PMStatus) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PMRemark) + '</td>';
                feedback_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.PM) + '</td>';
                feedback_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#feedbackDump_table')) {
                feedback_html.destroy();
            }

            $('#feedbackDump_table tbody').html(feedback_html);

            feedback_html = $('#feedbackDump_table').DataTable({
                dom: 't',
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
                    var val = data[3];
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

function BindIndividualPerformance() {

    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 8;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();


    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetIndvPerformanceRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //   data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {


            if ($.fn.dataTable.isDataTable('#indvPerformance_table')) {
                $('#indvPerformance_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);

            });
            $('#indvPerformance_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindWeeklyTrendingReport() {
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 9;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetWeeklyTrendingRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        // data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#weeklytrending_table')) {
                $('#weeklytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#weeklytrending_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindMonthlyTrendingReport() {
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 10;

    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetMonthlyTrendingRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //  data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#monthlytrending_table')) {
                $('#monthlytrending_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#monthlytrending_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindErrorTrendingAllReport() {
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 11;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetErrorTrendingAllRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //   data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#errortrendingall_table')) {
                $('#errortrendingall_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#errortrendingall_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

function BindErrorTrendingUserWiseReport() {
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    var columns = [];
    var DataTableNo = 12;
    if (month == "") {
        alert("Please select month");
        return false;
    }
    if (year == "") {
        alert("Please select year");
        return false;
    }
    $('#load1').show();

    $.ajax({
        url: "ServicingConsolidatedReport.aspx/GetErrorTrendingUserWiseRecords_Servicing",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        //   data: "{Month:'" + month + "', Year:'" + year + "', DataTableNo:'" + DataTableNo + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#errortrendinguser_table')) {
                $('#errortrendinguser_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#errortrendinguser_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

//---- Working Code 
function BindGrid() {
    var ddlmonth = document.getElementById("sc_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("sc_year");
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
    $('#load1').show();

    $.ajax({
        url: "CreditConsolidatedReport.aspx/GetReport",
        type: "POST",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            if ($.fn.dataTable.isDataTable('#project_table')) {
                $('#project_table').DataTable().destroy();
            }
            dataArray = JSON.parse(data.d);
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });
            $('#project_table').DataTable({
                dom: 'lftp',
                destroy: true,
                paging: true,
                "autoWidth": true,
                select: true,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        }
    });

    return false;
}

//function createTable() {
//    var table = document.getElementById("tblProject");
//    var columnsInput = document.getElementById("columns");
//    var rowsInput = document.getElementById("rows");
//    var columns = parseInt(columnsInput.value);
//    var rows = parseInt(rowsInput.value);

//    // Clear existing table
//    while (table.firstChild) {
//        table.removeChild(table.firstChild);
//    }

//    // Create table header
//    var headerRow = document.createElement("tr");
//    for (var i = 0; i < columns; i++) {
//        var th = document.createElement("th");
//        var input = document.createElement("input");
//        input.setAttribute("type", "text");
//        input.setAttribute("class", "header-input");
//        input.setAttribute("placeholder", "Column " + (i + 1));
//        th.appendChild(input);
//        headerRow.appendChild(th);
//    }
//    table.appendChild(headerRow);

//    // Create table rows
//    for (var i = 0; i < rows; i++) {
//        var rowData = [];
//        var row = document.createElement("tr");
//        for (var j = 0; j < columns; j++) {
//            var cell = document.createElement("td");
//            cell.setAttribute("contenteditable", "true");
//            cell.setAttribute("class", "editable-cell");
//            cell.addEventListener("input", updateCell);
//            rowData.push("");
//            row.appendChild(cell);
//        }
//        table.appendChild(row);
//        tableData.push(rowData);
//    }
//}


