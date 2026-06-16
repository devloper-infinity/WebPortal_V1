

var ITCostReport_table;
var ITCostReportDetail_table;
var CreditCardDeviation_table;
var CreditCardSummaryReport_table;


function showITCostReport() {

    var FromDate = document.getElementById("ITCost_FromDate").value;
    var ToDate = document.getElementById("ITCost_ToDate").value;

    if (FromDate == "") {
        alert("Please select From Date.");
        return false;
    }
    if (ToDate == "") {
        alert("Please select To Date.");
        return false;
    }

    if (FromDate != null && ToDate != null) {

        BindITCostReport_Grid(FromDate, ToDate);
        BindITCostReportDetail_Grid(FromDate, ToDate);
        BindITCreditCardSummary_Grid(FromDate, ToDate);
       // BindITCreditCardDeviation_Grid(FromDate, ToDate);
    }
}

function BindITCostReport_Grid(FromDate, ToDate) {

    $('#load1').show();

    var filename = "IT Cost Report -" + FromDate + " " + ToDate;
    var columns = [];

    $.ajax({
        url: "ITCostReport.aspx/ITCostReportYearly",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            //var header = {};
            //header.title = '<input type="checkbox" id="select-all" onclick="return getselected(this);">';
            //header.data = null;
            //columns.push(header);

            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            ITCostReport_table = $('#table_ITCostReport').DataTable({
                dom: 'Blftip',
                scrollx: false,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

                initComplete: function () {

                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: filename, autoFilter: true,
                    },
                ],
                //columnDefs: [

                //    {
                //        targets: 0,
                //        "width": "45px",
                //        render: function (data, type, row, meta) {
                //            return '<input type="checkbox" id="chkId_' + row.chkAll + '" onclick="return getselected(this,\'' + meta.row + '\');" />';//<td style="text-wrap: nowrap;text-align:center;"></td>';
                //        }
                //    },
                //    {
                //        targets: 1,
                //        visible: false,
                //    },
                //    {
                //        targets: columns.length - 1,
                //        render: function (data, type, row, meta) {

                //            //alert(row.chkAll);
                //            //alert("txt_reconcileRemark_" + row.chkAll);

                //            return '<td style="text-wrap: nowrap;text-align:center;"><input type="text" id="txt_reconcileRemark_' + row.chkAll + '"  style="width:500px;" value="' + blankForNull(row.UserRemark) + '"/></td>';
                //        }
                //    }
                //],
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function BindITCostReportDetail_Grid(FromDate, ToDate) {

    $('#load1').show();

    var filename = "IT Cost Report Detail-" + FromDate + " " + ToDate;
    var columns = [];

    $.ajax({
        url: "ITCostReport.aspx/ITCostReportYearlyDetail",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            ITCostReportDetail_table = $('#table_ITCostReportDetail').DataTable({
                dom: 'Blftip',
                scrollx: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

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
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function BindITCreditCardSummary_Grid(FromDate, ToDate) {

    $('#load1').show();

    var filename = "Credit Card Summary - " + FromDate + " " + ToDate;
    var columns = [];

    $.ajax({
        url: "ITCostReport.aspx/ITCostReportYearly_CreditCardwise",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            CreditCardSummaryReport_table = $('#table_CreditCardSummaryReport').DataTable({
                dom: 'Blftip',
                scrollx: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

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
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function BindITCreditCardDeviation_Grid(FromDate, ToDate) {

    $('#load1').show();

    var filename = "Credit Card Deviation - " + FromDate + " " + ToDate;
    var columns = [];

    $.ajax({
        url: "ITCostReport.aspx/ITCostReportYearly_CreditCardDeviation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            CreditCardDeviation_table = $('#table_CreditCardDeviation').DataTable({
                dom: 'Blftip',
                scrollx: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },
                "data": dataArray,
                "columns": columns,

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
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}
