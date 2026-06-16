
var ServSummary_table;
var CredSummary_table;
var CredProduction_table;
var ServProduction_table;


function us_bindCreditSummary() {

    $('#load1').show();
    var FromDate = document.getElementById("us_fromdate").value;
    var ToDate = document.getElementById("us_todate").value;

    if (FromDate != "" && ToDate != "") {

        $.ajax({
            url: "UserPerformanceReport.aspx/GetUserPerformanceReport_Credit",
            type: "POST",
            dataType: "json",
            data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
            contentType: "application/json; charset=utf-8",
            success: function (data) {

                var dataArray = JSON.parse(data.d);
                CredSummary_table = $('#table_CredSummary').DataTable({
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
    }
    else {
        if (FromDate != "")
            alert("Please select From Date");
      else  if (ToDate != "")
            alert("Please select To Date");
        
    }
    return false;

}

function us_bindServicingSummary() {

    $('#load1').show();
    var FromDate = document.getElementById("us_fromdate").value;
    var ToDate = document.getElementById("us_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetUserPerformanceReport_Servicing",
        type: "POST",
        dataType: "json",
        data: "{FromDate:'" + FromDate + "',ToDate:'" + ToDate + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {

            var dataArray = JSON.parse(data.d);//
            CredSummary_table = $('#table_ServSummary').DataTable({
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
                        extend: 'excelHtml5', title: 'Servicing Summary', autoFilter: true,
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

function us_bindCreditProdDetails() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("us_fromdate").value;
    var ToDate = document.getElementById("us_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetOverAllUserPerformanceDetails_Credit_Greg",
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

            CredProduction_table = $('#table_CredProduction').DataTable({
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
                        extend: 'excelHtml5', title: 'Credit Performance', autoFilter: true,
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

function us_bindServicingProdDetails() {

    $('#load1').show();
    var columns = [];
    var FromDate = document.getElementById("us_fromdate").value;
    var ToDate = document.getElementById("us_todate").value;

    $.ajax({
        url: "UserPerformanceReport.aspx/GetOverAllUserPerformanceDetails_Servicing_Greg",
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

            ServProduction_table = $('#table_ServProduction').DataTable({
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
                        extend: 'excelHtml5', title: 'Servicing - Production Details', autoFilter: true,
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
