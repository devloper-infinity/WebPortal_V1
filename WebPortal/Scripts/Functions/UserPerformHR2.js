
var excelName;


var tableConfig = {
    "nondd_summary": { tableId: "table_nondd_Summary", url: "UserPerformanceHrReport.aspx/GetUserPerformanceReport_NonDD" },
    "nondd_production": { tableId: "table_nondd_prod", url: "UserPerformanceHrReport.aspx/GetUserPerformanceProdDetails_NonDD" },
    "nondd_feedback": { tableId: "table_nondd_feedback", url: "UserPerformanceHrReport.aspx/GetUserPerformanceFeedbackDetails_NonDD" },
    "nondd_attendance": { tableId: "table_nondd_attn", url: "UserPerformanceHrReport.aspx/GetUserPerformanceAttendanceDetails_NonDD" },

    "credit_summary": { tableId: "table_cred_Summary", url: "UserPerformanceHrReport.aspx/GetUserPerformanceReport_Credit" },
    "credit_production": { tableId: "table_cred_prod", url: "UserPerformanceHrReport.aspx/GetUserPerformanceProdDetails_Credit" },
    "credit_feedback": { tableId: "table_cred_feedback", url: "UserPerformanceHrReport.aspx/GetUserPerformanceFeedbackDetails_Credit" },
    "credit_attendance": { tableId: "table_cred_attn", url: "UserPerformanceHrReport.aspx/GetUserPerformanceAttendanceDetails_Credit" },

    "servicing_summary": { tableId: "table_serv_Summary", url: "UserPerformanceHrReport.aspx/GetUserPerformanceReport_Servicing" },
    "servicing_production": { tableId: "table_serv_prod", url: "UserPerformanceHrReport.aspx/GetUserPerformanceProdDetails_Servicing" },
    "servicing_feedback": { tableId: "table_serv_feedback", url: "UserPerformanceHrReport.aspx/GetUserPerformanceFeedbackDetails_Servicing" },
    "servicing_attendance": { tableId: "table_serv_attn", url: "UserPerformanceHrReport.aspx/GetUserPerformanceAttendanceDetails_Servicing" }
};

function bindDataTable_1(config) {

    var tableId = config.tableId;
    var url = config.url;
    var columns = config.columns || [];

    var fromDate = $("#hrUser_fromDate").val();
    var toDate = $("#hrUser_toDate").val();

    fromDate = '2026-01-26';
    toDate = '2026-02-25';

    if (!fromDate || !toDate) {
        alert("Select From Date and To Date");
        return;
    }

    // Destroy existing table
    if ($.fn.DataTable.isDataTable('#' + tableId)) {
        $('#' + tableId).DataTable().destroy();
        $('#' + tableId).empty();
    }

    // 🔥 AJAX CALL
    $.ajax({
        url: url,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        data: JSON.stringify({
            FromDate: fromDate,
            EndDate: toDate
        }),

        success: function (res) {

            var dataArray = [];

            try {
                dataArray = JSON.parse(res.d);

                alert(dataArray);
            } catch (e) {
                console.error("JSON Parse Error", e);
            }

            //  console.log("Table:", tableId, dataArray);


            if (!dataArray || dataArray.length === 0) {
                alert("No data found");
                return;
            }

            // 🔥 AUTO COLUMN FIX (MAIN CHANGE)
            if (!columns || columns.length === 0) {
                columns = Object.keys(dataArray[0]).map(function (key) {
                    return { data: key, title: key };
                });
            }

            alert(columns);

            // 🔥 Bind DataTable
            $('#' + tableId).DataTable({

                data: dataArray,
                columns: columns,

                processing: true,
                scrollX: true,
                pageLength: 10,
                lengthMenu: [10, 25, 50, 100],
                destroy: true,

                dom: 'frtip',

            });
        },

        initComplete: function () {
            alert("init");

            /*$('#load1').hide();*/
        },
        error: function (xhr) {
            console.error("ERROR:", xhr.responseText);
            alert("Error loading " + tableId);
        }
    });
}

function loadCurrentTable_1() {

    var key = currentMainTab + "_" + currentSubTab;

    if (tableConfig[key]) {
        bindDataTable(tableConfig[key]);
    }
}

function exportAllToExcel_1() {

    var fromDate = $("#hrUser_fromDate").val();
    var toDate = $("#hrUser_toDate").val();

    fromDate = '01/26/2026';
    toDate = '02/25/2026';

    excelName = "User Performance Report_" + fromDate + "_" + toDate + ".xlsx";

    var allKeys = Object.keys(tableConfig);

    var allData = [];

    var requests = [];

    allKeys.forEach(function (key) {

        var config = tableConfig[key];

        var req = $.ajax({
            url: config.url,
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                FromDate: fromDate,
                EndDate: toDate
            })
        }).then(function (res) {

            var data = JSON.parse(res.d);

            data.forEach(function (row) {
                row["Module"] = key; // add tab name
                allData.push(row);
            });

        });

        requests.push(req);

    });

    $.when.apply($, requests).then(function () {

        downloadExcel(allData);

    });

}

function downloadExcel_1(data) {

    var ws = XLSX.utils.json_to_sheet(data);

    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "All Data");

    XLSX.writeFile(wb, excelName);
}

function handleShowClick_1() {

    var fromDate = $("#hrUser_fromDate").val();
    var toDate = $("#hrUser_toDate").val();

    fromDate = '01/26/2026';
    toDate = '02/25/2026';

    if (!fromDate || !toDate) {
        alert("Select dates");
        return false;
    }

    loadCurrentTable();

    return false; // 🔥 VERY IMPORTANT (stops refresh)
}