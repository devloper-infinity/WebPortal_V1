
var global_reqc = 0;

function btnreqcUtility_Import() {

    var reqcPerc = document.getElementById("reqcUtility_perc").value;
    global_reqc = reqcPerc;

    if (reqcPerc == "") {
        alert("Please enter ReQC %.");
        document.getElementById("reqcUtility_perc").focus();
        return false;
    }
    if (reqcPerc == "0") {
        alert("ReQC % should be not be 0.");
        document.getElementById("reqcUtility_perc").focus();
        return false;
    }

    if (reqcPerc != "" && reqcPerc > 0) {
        $('#reqc_popUp_Waitingpanel').modal('show');
        PageMethods.ImportData(OnSuccess_reqcUtility, OnError_reqcUtility);
    }
    return false;
}

function OnSuccess_reqcUtility(result) {

    if (result > 0) {
        $('#reqc_popUp_Waitingpanel').modal('hide');
        
        bindSummary_Grid(global_reqc);
        bindLoan_Grid(global_reqc);
    }
    else {

        alert("Error importing data.");
    }
}

function OnError_reqcUtility(error) {

    alert(error.responseText);
    return false;
}

function bindSummary_Grid(reqc) {

    $('#load1').show();

    $.ajax({
        url: "ReQcUtility.aspx/GetSummaryDetails",
        type: "POST",
        data: JSON.stringify({ ReQc: reqc }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d); // keep only if WebMethod returns string

            if ($.fn.DataTable.isDataTable('#table_reQcsummary')) {
                $('#table_reQcsummary').DataTable().clear().destroy();
            }

            var table = $('#table_reQcsummary').DataTable({
                dom: 'tp',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    { data: "SrNo" },
                    { data: "QC" },
                    { data: "LoanCount" },
                    { data: "ReQCLoans" }
                ],
                initComplete: function () {
                    $('#load1').hide();
                    var api = this.api();   // DataTables API
                    var rowCount = api.rows().count();
                    document.getElementById("reqcUtility_Summary").textContent = rowCount;
                }
            });
        },

        error: function (error) {
            $('#load1').hide();
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}

function bindLoan_Grid(reqc) {

    $('#load1').show();

    $.ajax({
        url: "ReQcUtility.aspx/GetLoanDetails",
        type: "POST",
        data: "{ReQc:" + reqc + "}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if ($.fn.DataTable.isDataTable('#table_reQcLoanDetails')) {
                $('#table_reQcLoanDetails').DataTable().clear().destroy();
            }

            var table = $('#table_reQcLoanDetails').DataTable({
                dom: 'ftp',
                data: dataArray,
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                ordering: false,
                serverSide: false,
                columns: [
                    { data: "SrNo" },
                    { data: "DealNo" },
                    { data: "LoanNo1" },
                    { data: "LoanNo2" },
                    { data: "Review" },
                    { data: "QC" },
                    { data: "ReviewStatus" },
                    { data: "rn" },
                    { data: "TotalLoans" }
                ],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: 'Export to Excel',
                        title: 'ReQC Summary',
                        exportOptions: {
                            columns: ':visible'
                        }
                    }
                ],
                initComplete: function () {
                    var api = this.api();   // DataTables API
                    var rowCount = api.rows().count();
                    document.getElementById("reqcUtility_LoanDetails").innerHTML = rowCount;
                    $('#load1').hide();
                }
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });
    return false;

}

function btnreqcUtility_ExportToExcel() {

    var summaryTable = $('#table_reQcsummary').DataTable();
    var loanTable = $('#table_reQcLoanDetails').DataTable();

    var summaryData = summaryTable.rows().data().toArray();
    var loanData = loanTable.rows().data().toArray();

    // === Summary Sheet ===
    var summarySheetData = [];
    var summaryHeaders = ["Sr #", "QC", "Loan Count", "ReQc Loans"];
    summarySheetData.push(summaryHeaders);

    summaryData.forEach(function (row) {
        summarySheetData.push([row.SrNo, row.QC, row.LoanCount, row.ReQCLoans]);
    });

    var wsSummary = XLSX.utils.aoa_to_sheet(summarySheetData);

    // Set column widths
    wsSummary['!cols'] = [
        { wch: 6 },
        { wch: 20 },
        { wch: 12 },
        { wch: 12 }
    ];

    // Add autofilter for headers
    //   wsSummary['!autofilter'] = { ref: "A1:D" + summarySheetData.length };
    for (let C = 0; C < summaryHeaders.length; C++) {
        const cell = XLSX.utils.encode_cell({ r: 0, c: C });
        if (!wsSummary[cell]) continue;
        wsSummary[cell].s = {
            font: { bold: true, color: { rgb: "FFFFFF" } },
            fill: { fgColor: { rgb: "4472C4" } }, // blue background
            alignment: { horizontal: "center", vertical: "center" },
            border: {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            }
        };
    }

    // Apply border to all data rows
    for (let R = 1; R < summarySheetData.length; R++) {
        for (let C = 0; C < summaryHeaders.length; C++) {
            const cell = XLSX.utils.encode_cell({ r: R, c: C });
            if (!wsSummary[cell]) continue;
            wsSummary[cell].s = wsSummary[cell].s || {};
            wsSummary[cell].s.border = {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            };
        }
    }



    // === Loan Details Sheet ===
    var loanSheetData = [];
    var loanHeaders = ["Sr #", "Deal #", "Loan #-1", "Loan #-2", "Review", "QC", "Review Status", "Random #", "Total Loans"];
    loanSheetData.push(loanHeaders);

    loanData.forEach(function (row) {
        loanSheetData.push([row.SrNo, row.DealNo, row.LoanNo1, row.LoanNo2, row.Review, row.QC, row.ReviewStatus, row.rn, row.TotalLoans]);
    });

    var wsLoan = XLSX.utils.aoa_to_sheet(loanSheetData);

    // Set column widths
    wsLoan['!cols'] = [
        { wch: 6 },
        { wch: 12 },
        { wch: 12 },
        { wch: 12 },
        { wch: 20 },
        { wch: 20 },
        { wch: 15 },
        { wch: 10 },
        { wch: 12 }
    ];

    //// Add autofilter for headers
    //wsLoan['!autofilter'] = { ref: "A1:I" + loanSheetData.length };


    // Apply header style
    for (let C = 0; C < loanHeaders.length; C++) {
        const cell = XLSX.utils.encode_cell({ r: 0, c: C });
        if (!wsLoan[cell]) continue;
        wsLoan[cell].s = {
            font: { bold: true, color: { rgb: "FFFFFF" } },
            fill: { fgColor: { rgb: "4472C4" } },
            alignment: { horizontal: "center", vertical: "center" },
            border: {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            }
        };
    }

    // Apply border to all data rows
    for (let R = 1; R < loanSheetData.length; R++) {
        for (let C = 0; C < loanHeaders.length; C++) {
            const cell = XLSX.utils.encode_cell({ r: R, c: C });
            if (!wsLoan[cell]) continue;
            wsLoan[cell].s = wsLoan[cell].s || {};
            wsLoan[cell].s.border = {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            };
        }
    }


    // === Create Workbook ===
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, wsSummary, "Summary");
    XLSX.utils.book_append_sheet(wb, wsLoan, "LoanDetails");

    // === Export Excel ===
    XLSX.writeFile(wb, "ReQC_Report.xlsx");
}

function btnreqcUtility_ExportToExcel2() {


    var summaryTable = $('#table_reQcsummary').DataTable();
    var loanTable = $('#table_reQcLoanDetails').DataTable();

    var summaryData = summaryTable.rows().data().toArray();
    var loanData = loanTable.rows().data().toArray();

    // === Summary Sheet ===
    var summarySheetData = [];
    var summaryHeaders = ["Sr #", "QC", "Loan Count", "ReQc Loans"];
    summarySheetData.push(summaryHeaders);

    summaryData.forEach(function (row) {
        summarySheetData.push([row.SrNo, row.QC, row.LoanCount, row.ReQCLoans]);
    });

    var wsSummary = XLSX.utils.aoa_to_sheet(summarySheetData);

    // Apply styles: header bold + background + borders
    for (var C = 0; C < summaryHeaders.length; ++C) {
        var cell_address = XLSX.utils.encode_cell({ c: C, r: 0 });
        if (!wsSummary[cell_address]) continue;
        wsSummary[cell_address].s = {
            font: { bold: true, color: { rgb: "FFFFFF" } },
            fill: { fgColor: { rgb: "4472C4" } }, // blue header
            border: {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            },
            alignment: { horizontal: "center", vertical: "center" }
        };
    }

    // Set column widths
    wsSummary['!cols'] = [
        { wch: 6 },   // Sr #
        { wch: 20 },  // QC
        { wch: 12 },  // Loan Count
        { wch: 12 }   // ReQc Loans
    ];

    // Add border to all cells
    for (var R = 1; R < summarySheetData.length; ++R) {
        for (var C = 0; C < summaryHeaders.length; ++C) {
            var cell_address = XLSX.utils.encode_cell({ c: C, r: R });
            if (!wsSummary[cell_address]) continue;
            wsSummary[cell_address].s = wsSummary[cell_address].s || {};
            wsSummary[cell_address].s.border = {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            };
        }
    }

    // === Loan Details Sheet ===
    var loanSheetData = [];
    var loanHeaders = ["Sr #", "Deal #", "Loan #-1", "Loan #-2", "Review", "QC", "Review Status", "Random #", "Total Loans"];
    loanSheetData.push(loanHeaders);

    loanData.forEach(function (row) {
        loanSheetData.push([row.SrNo, row.DealNo, row.LoanNo1, row.LoanNo2, row.Review, row.QC, row.ReviewStatus, row.rn, row.TotalLoans]);
    });

    var wsLoan = XLSX.utils.aoa_to_sheet(loanSheetData);

    // Apply header style
    for (var C = 0; C < loanHeaders.length; ++C) {
        var cell_address = XLSX.utils.encode_cell({ c: C, r: 0 });
        if (!wsLoan[cell_address]) continue;
        wsLoan[cell_address].s = {
            font: { bold: true, color: { rgb: "FFFFFF" } },
            fill: { fgColor: { rgb: "4472C4" } }, // blue header
            border: {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            },
            alignment: { horizontal: "center", vertical: "center" }
        };
    }

    // Set column widths
    wsLoan['!cols'] = [
        { wch: 6 },  // Sr #
        { wch: 12 }, // Deal #
        { wch: 12 }, // Loan #-1
        { wch: 12 }, // Loan #-2
        { wch: 20 }, // Review
        { wch: 20 }, // QC
        { wch: 15 }, // Review Status
        { wch: 10 }, // Random #
        { wch: 12 }  // Total Loans
    ];

    // Add border to all cells
    for (var R = 1; R < loanSheetData.length; ++R) {
        for (var C = 0; C < loanHeaders.length; ++C) {
            var cell_address = XLSX.utils.encode_cell({ c: C, r: R });
            if (!wsLoan[cell_address]) continue;
            wsLoan[cell_address].s = wsLoan[cell_address].s || {};
            wsLoan[cell_address].s.border = {
                top: { style: "thin", color: { rgb: "000000" } },
                bottom: { style: "thin", color: { rgb: "000000" } },
                left: { style: "thin", color: { rgb: "000000" } },
                right: { style: "thin", color: { rgb: "000000" } }
            };
        }
    }

    // === Create Workbook ===
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, wsSummary, "Summary");
    XLSX.utils.book_append_sheet(wb, wsLoan, "LoanDetails");

    // === Export Excel ===
    XLSX.writeFile(wb, "ReQC_Report.xlsx");
}

function btnreqcUtility_ExportToExcel_1() {
    // Get DataTables instances
    var summaryTable = $('#table_reQcsummary').DataTable();
    var loanTable = $('#table_reQcLoanDetails').DataTable();

    // Get all data (not just current page)
    var summaryData = summaryTable.rows().data().toArray();
    var loanData = loanTable.rows().data().toArray();

    // Convert objects to arrays including headers
    var summarySheetData = [];
    summarySheetData.push(Object.keys(summaryData[0] || {})); // header row
    summaryData.forEach(function (row) {
        summarySheetData.push(Object.values(row));
    });

    var loanSheetData = [];
    loanSheetData.push(Object.keys(loanData[0] || {})); // header row
    loanData.forEach(function (row) {
        loanSheetData.push(Object.values(row));
    });

    // Create workbook
    var wb = XLSX.utils.book_new();
    var wsSummary = XLSX.utils.aoa_to_sheet(summarySheetData);
    var wsLoan = XLSX.utils.aoa_to_sheet(loanSheetData);

    XLSX.utils.book_append_sheet(wb, wsSummary, "Summary");
    XLSX.utils.book_append_sheet(wb, wsLoan, "LoanDetails");

    // Export Excel
    XLSX.writeFile(wb, "ReQC_Report.xlsx");
}

function btnreqcUtility_ExportToExcel_Core() {

    // Get Summary table data
    var summaryData = [];
    $('#table_reQcsummary tbody tr').each(function () {
        var row = [];
        $(this).find('td').each(function () {
            row.push($(this).text().trim());
        });
        summaryData.push(row);
    });

    // Get Loan Details table data
    var loanData = [];
    $('#table_reQcLoanDetails tbody tr').each(function () {
        var row = [];
        $(this).find('td').each(function () {
            row.push($(this).text().trim());
        });
        loanData.push(row);
    });

    // Create workbook
    var wb = XLSX.utils.book_new();

    // Convert arrays to sheets
    var wsSummary = XLSX.utils.aoa_to_sheet([
        $("#table_reQcsummary thead tr th").map(function () { return $(this).text(); }).get(),
        ...summaryData
    ]);

    var wsLoan = XLSX.utils.aoa_to_sheet([
        $("#table_reQcLoanDetails thead tr th").map(function () { return $(this).text(); }).get(),
        ...loanData
    ]);

    // Add sheets to workbook
    XLSX.utils.book_append_sheet(wb, wsSummary, "Summary");
    XLSX.utils.book_append_sheet(wb, wsLoan, "LoanDetails");

    // Export Excel
    XLSX.writeFile(wb, "ReQC_Report.xlsx");
}
