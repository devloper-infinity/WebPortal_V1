
var agreeTypeReport_html;
var agreeTypeReport_table;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function bind_AgrVersionReportTable() {

    $.ajax({
        type: "POST",
        url: "AgreementVersionsHistoryReport.aspx/GetAgreementVersionHistory_Report",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            var data = response.d;

            // 🔹 If data comes as string (very common in PageMethod)
            if (typeof data === "string") {
                data = JSON.parse(data);
            }

            if (!data || data.length === 0) {
                console.log("No data returned");
                return;
            }

            var columns = [];

            // 🔹 Dynamically create columns from first row
            Object.keys(data[0]).forEach(function (key) {

                columns.push({
                    title: key.replace(/_/g, "."),  // show 2.8.5 instead of 2_8_5
                    data: key,
                    defaultContent: ""
                });
            });

            // 🔹 Destroy if already initialized
            if ($.fn.DataTable.isDataTable('#table_agreeVerReport')) {
                $('#table_agreeVerReport').DataTable().clear().destroy();
            }

            $('#table_agreeVerReport').DataTable({
                data: data,
                columns: columns,
                scrollX: true,
                autoWidth: false,
                createdHeader: function (th, data, index) {
                    $(th).css("text-align", "center");
                }
            });

        },
        error: function (err) {
            console.log(err);
        }
    });
}


function bind_AgrTypeReportTable() {

    $('#load1').show();
    agreeTypeReport_html = '';

    $.ajax({
        type: "POST",
        url: "AgreementVersionControl.aspx/GetAgreementTypeHistory",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                agreeTypeReport_html += '<tr>';
                agreeTypeReport_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull(value.SrNo) + '</td>';
                agreeTypeReport_html += '<td style="text-wrap: wrap; width: 400px;">' + blankForNull(value.AgreementType) + '</td>';
                agreeTypeReport_html += '<td style="text-wrap: wrap; width: 200px;">' + blankForNull(value.MinServicePeriod) + '</td>';
                agreeTypeReport_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_agreeTypeReport')) {
                agreeTypeReport_table.destroy();
            }

            $('#table_agreeTypeReport tbody').html(agreeTypeReport_html);

            agreeTypeReport_table = $('#table_agreeTypeReport').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: false,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}


async function exportBothTablesToExcel() {

    var table2 = $('#table_agreeVerReport').DataTable();
    var table1 = $('#table_agreeTypeReport').DataTable();

    var data1 = table1.rows().data().toArray();
    var data2 = table2.rows().data().toArray();

    var columns1 = table1.columns().header().toArray().map(x => $(x).text());
    var columns2 = table2.columns().header().toArray().map(x => $(x).text());

    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet("Agreement Report");

    // =========================
    // FIRST TABLE HEADER FEECE7 , color: { argb: 'FFFFFFFF' }
    // =========================

    let headerRow1 = worksheet.addRow(columns1);

    headerRow1.eachCell(cell => {
        cell.font = { bold: true };
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
        cell.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FAA68F' }
        };
        cell.border = {
            top: { style: 'thin' },
            bottom: { style: 'thin' },
            left: { style: 'thin' },
            right: { style: 'thin' }
        };
    });

    // =========================
    // FIRST TABLE DATA
    // =========================
    data1.forEach(row => {
        let newRow = worksheet.addRow(Object.values(row));
        newRow.eachCell(cell => {
            cell.alignment = { vertical: 'top', wrapText: true };
            cell.border = {
                top: { style: 'thin' },
                bottom: { style: 'thin' },
                left: { style: 'thin' },
                right: { style: 'thin' }
            };
        });
    });

    worksheet.addRow([]);
    worksheet.addRow([]);

    // =========================
    // DIFFERENCE BETWEEN (CORRECT POSITION)
    // =========================
    let diffRow = worksheet.addRow(["Difference Between"]);
    let diffRowNumber = worksheet.lastRow.number;

    worksheet.mergeCells(diffRowNumber, 1, diffRowNumber, columns2.length);

    diffRow.getCell(1).font = { bold: true, color: { argb: 'FFFFFFFF' } };
    diffRow.getCell(1).alignment = { horizontal: 'center', vertical: 'middle' };
    diffRow.getCell(1).fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: '65DBCF' }
    };

    // =========================
    // AGREEMENT VERSION TITLE
    // =========================
    let versionRow = worksheet.addRow(["Agreement Version"]);
    let versionRowNumber = worksheet.lastRow.number;

    worksheet.mergeCells(versionRowNumber, 1, versionRowNumber, columns2.length);

    versionRow.getCell(1).font = { bold: true };
    versionRow.getCell(1).alignment = { horizontal: 'center', vertical: 'middle' };

    // =========================
    // SECOND TABLE HEADER
    // =========================
    let headerRow2 = worksheet.addRow(columns2);

    headerRow2.eachCell(cell => {
        cell.font = { bold: true };
        cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
        cell.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: 'FAA68F' }
        };
        cell.border = {
            top: { style: 'thin' },
            bottom: { style: 'thin' },
            left: { style: 'thin' },
            right: { style: 'thin' }
        };
    });

    // =========================
    // SECOND TABLE DATA
    // =========================
    data2.forEach(row => {
        let newRow = worksheet.addRow(Object.values(row));
        newRow.eachCell(cell => {
            cell.alignment = { vertical: 'top', wrapText: true };
            cell.border = {
                top: { style: 'thin' },
                bottom: { style: 'thin' },
                left: { style: 'thin' },
                right: { style: 'thin' }
            };
        });
    });

    // =========================
    // COLUMN WIDTH
    // =========================
    worksheet.getColumn(1).width = 7;

    for (let i = 2; i <= worksheet.columnCount; i++) {
        worksheet.getColumn(i).width = 60;
    }

    // =========================
    // DOWNLOAD
    // =========================
    workbook.xlsx.writeBuffer().then(function (buffer) {
        var blob = new Blob([buffer], {
            type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        });
        saveAs(blob, "AgreementHistoryReport.xlsx");
    });
}
