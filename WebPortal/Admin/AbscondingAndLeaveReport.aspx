<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AbscondingAndLeaveReport.aspx.cs" Inherits="WebPortal.Admin.AbscondingAndLeaveReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .al-hero {
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            box-shadow: 0 12px 30px rgba(37,99,235,.22);
        }

        .al-title {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
        }

        .al-subtitle {
            margin-top: 5px;
            font-size: 13px;
            opacity: .9;
        }

        .al-chip {
            background: rgba(255,255,255,.18);
            padding: 9px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }

        .al-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 28px rgba(15,23,42,.08);
            border: 1px solid #edf2f7;
            padding: 18px;
        }

        .al-label {
            font-size: 13px;
            font-weight: 700;
            color: #374151;
            margin-bottom: 6px;
        }

        .al-input {
            height: 42px !important;
            border-radius: 12px !important;
            border: 1px solid #dbe3ef !important;
        }

        .al-btn {
            height: 42px;
            border: 0;
            border-radius: 12px;
            color: #fff;
            font-weight: 700;
            width: 100%;
            transition: .2s;
        }

            .al-btn:hover {
                transform: translateY(-2px);
                color: #fff;
            }

        .al-show {
            background: linear-gradient(135deg, #2563eb, #22c1dc);
        }

        .al-export {
            background: linear-gradient(135deg, #16a34a, #22c55e);
        }

        .al-tabs-card {
            margin-top: 18px;
            border-radius: 18px;
            overflow: hidden;
            border: 1px solid #edf2f7;
            box-shadow: 0 8px 28px rgba(15,23,42,.08);
        }

            .al-tabs-card .nav-tabs {
                background: #f8fafc;
                border-bottom: 1px solid #e5e7eb;
                padding: 10px 10px 0;
            }

            .al-tabs-card .nav-link {
                border: 0;
                border-radius: 12px 12px 0 0;
                font-weight: 700;
                color: #475569;
                padding: 11px 18px;
            }

                .al-tabs-card .nav-link.active {
                    background: #fff;
                    color: #1d4ed8;
                    box-shadow: 0 -3px 12px rgba(15,23,42,.06);
                }

        .al-table-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 14px;
            background: #fff;
        }

        .al-table {
            width: 100% !important;
            white-space: nowrap;
        }

            .al-table thead th {
                background: #edf3f6 !important;
                color: #111827 !important;
                font-size: 13px;
                font-weight: 800;
                height: 42px;
                vertical-align: middle;
            }

            .al-table tbody td {
                font-size: 13px;
                vertical-align: middle;
            }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(255,255,255,.72);
            z-index: 99999;
            align-items: center;
            justify-content: center;
            text-align: center;
            margin: auto;
            width: 210px;
            height: 150px;
            z-index: 99999;
            border: 1px solid var(--fw-border);
            border-radius: 24px;
            box-shadow: var(--fw-shadow);
            padding: 22px;
        }

        @media(max-width:768px) {
            .al-hero {
                flex-direction: column;
                align-items: flex-start;
            }

            .al-title {
                font-size: 20px;
            }

            .al-chip {
                width: 100%;
                text-align: center;
            }
        }

        .sec-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 17px 35px;
            margin-bottom: 25px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg,#0a5fd7 0%,#1976f3 35%,#1da8ea 70%,#22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

        .sec-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
            backdrop-filter: blur(4px);
        }

            .sec-hero-icon i {
                font-size: 34px;
                color: #fff;
            }

        .sec-kicker {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            opacity: .9;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .sec-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: -10px;
        }

            .sec-title i {
                margin-right: 10px;
            }

        .sec-subtitle {
            margin: 10px 0 0;
            font-size: 14px;
            color: rgba(255,255,255,.92);
            line-height: 1.6;
            max-width: 900px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js"></script>
    <script src="../Scripts/Functions/AbscondingAndLeaveReport.js" type="text/javascript"></script>
    <script>
        function export_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        $(document).ready(function () {
            BindYear_AbscondingLeave();
            YearWiseBindYear_AbscondingLeave();


            $('#yearableave_btnExport').on('click', function (e) {
                e.preventDefault();

                if (typeof XLSX === 'undefined') {
                    alert("SheetJS library is missing!");
                    return;
                }

                var selectedYear = $('#yearableave_year').val();
                if (!selectedYear) {
                    selectedYear = new Date().getFullYear();
                }
                var absRows = $('#YearWiseabscondleavelist tbody tr').length;
                var leaveRows = $('#YearWisetotalleavelist tbody tr').length;

                if (absRows === 0 && leaveRows === 0) {
                    Swal.fire("Validation", "No data found to export!", "warning");
                    return;
                }
                var fileName = 'Absconding_and_Leaves_Report_' + selectedYear + '.xlsx';

                try {
                    var wb = XLSX.utils.book_new();

                    function createTableFromDataTable(tableId) {
                        var origTbl = document.getElementById(tableId);
                        if (!origTbl) return null;

                        var tempTbl = document.createElement('table');
                        tempTbl.className = 'table';

                        var thead = origTbl.querySelector('thead').cloneNode(true);
                        tempTbl.appendChild(thead);

                        var tbody = document.createElement('tbody');
                        var dtInstance = $.fn.DataTable.isDataTable('#' + tableId) ? $('#' + tableId).DataTable() : null;

                        if (dtInstance) {
                            dtInstance.rows({ search: 'applied' }).every(function () {
                                var node = this.node();
                                if (node) {
                                    tbody.appendChild(node.cloneNode(true));
                                }
                            });
                        } else {
                            var rows = origTbl.querySelectorAll('tbody tr');
                            rows.forEach(function (r) {
                                tbody.appendChild(r.cloneNode(true));
                            });
                        }

                        tempTbl.appendChild(tbody);
                        return tempTbl;
                    }


                    $.ajax({
                        type: "POST",
                        url: "AbscondingAndLeaveReport.aspx/GetYearWiseAbscondingEmployeesSummary",
                        data: JSON.stringify({ Year: selectedYear }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            var allTables = JSON.parse(response.d);
                            var months = [];
                            for (var t = 0; t < allTables.length; t++) {
                                if (allTables[t] && allTables[t].length > 0) {
                                    Object.keys(allTables[t][0]).forEach(function (key) {
                                        if (key.endsWith("_AbscondingCount")) {
                                            months.push(key.replace("_AbscondingCount", ""));
                                        }
                                    });
                                    break;
                                }
                            }
                            var sequenceIndices = [0, 1, 2];
                            var tableTitles = ["Domain Wise Summary", "Location Wise Summary", "Domain Head Wise Summary"];
                            var categoryLabels = ["Domain", "Location", "Domain Head"];

                            var aoa = [];
                            var merges = [];
                            var headerRowsTracker = [];
                            var titleRowsTracker = [];
                            var currentRow = 0;
                            var totalRowsTracker = [];


                            sequenceIndices.forEach(function (tableIdx, loopPos) {
                                var summaryData = allTables[tableIdx];
                                if (summaryData && summaryData.length > 0) {

                                    var sectionTitle = tableTitles[loopPos] || ("Summary Table " + (loopPos + 1));
                                    aoa.push([sectionTitle]);
                                    titleRowsTracker.push(currentRow);

                                    if (tableIdx === 2) {
                                        var monthLocationMap = {};
                                        var firstColLabel = categoryLabels[loopPos] || "Domain Head";

                                        summaryData.forEach(function (item) {
                                            Object.keys(item).forEach(function (key) {
                                                if (key.endsWith("_AbscondingCount") && key !== "RowName") {
                                                    var parts = key.replace("_AbscondingCount", "").split("_");
                                                    var m = parts[0];
                                                    var loc = parts.slice(1).join("_");

                                                    if (!monthLocationMap[m]) {
                                                        monthLocationMap[m] = [];
                                                    }
                                                    if (!monthLocationMap[m].includes(loc)) {
                                                        monthLocationMap[m].push(loc);
                                                    }
                                                }
                                            });
                                        });
                                        Object.keys(monthLocationMap).forEach(function (m) {
                                            monthLocationMap[m].sort();
                                        });
                                        var headerRow1 = [firstColLabel];
                                        var headerRow2 = [firstColLabel];
                                        var totalColumns = 0;
                                        var currentStreamCol = 1;
                                        var distinctMonthsCount = Object.keys(monthLocationMap).length;

                                        Object.keys(monthLocationMap).forEach(function (m) {
                                            var locations = monthLocationMap[m];
                                            var startCol = currentStreamCol;

                                            locations.forEach(function (loc, index) {
                                                headerRow1.push(m);
                                                headerRow2.push(loc);
                                                totalColumns++;
                                                currentStreamCol++;
                                            });

                                            var endCol = currentStreamCol - 1;
                                            if (endCol > startCol) {
                                                merges.push({ s: { r: currentRow + 1, c: startCol }, e: { r: currentRow + 1, c: endCol } });
                                            }
                                        });

                                        headerRow1.push("Grand Total");
                                        headerRow2.push("Grand Total");
                                        merges.push({ s: { r: currentRow + 1, c: currentStreamCol }, e: { r: currentRow + 2, c: currentStreamCol } });


                                        merges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: distinctMonthsCount } });
                                        currentRow++;

                                        headerRowsTracker.push(currentRow);
                                        headerRowsTracker.push(currentRow + 1);
                                        aoa.push(headerRow1);
                                        aoa.push(headerRow2);

                                        merges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow + 1, c: 0 } });
                                        currentRow += 2;
                                        var colTotals = new Array(totalColumns).fill(0);
                                        var grandTotalOfAll = 0;
                                        summaryData.forEach(function (item) {
                                            var row = [item.RowName || ""];
                                            var colIdx = 0;
                                            var rowGrandTotal = 0;
                                            Object.keys(monthLocationMap).forEach(function (m) {
                                                monthLocationMap[m].forEach(function (loc) {
                                                    var targetKey = m + "_" + loc + "_AbscondingCount";
                                                    var val = item[targetKey] !== undefined ? parseInt(item[targetKey]) || 0 : 0;
                                                    row.push(val);
                                                    colTotals[colIdx] += val;
                                                    rowGrandTotal += val;
                                                    colIdx++;
                                                });
                                            });
                                            row.push(rowGrandTotal);
                                            grandTotalOfAll += rowGrandTotal;
                                            aoa.push(row);
                                            currentRow++;
                                        });
                                        var totalRow = ["Total"];
                                        colTotals.forEach(function (tVal) {
                                            totalRow.push(tVal);
                                        });
                                        totalRow.push(grandTotalOfAll);
                                        aoa.push(totalRow);
                                        totalRowsTracker.push(currentRow);
                                        currentRow++;




                                    } else {
                                        var months = [];
                                        Object.keys(summaryData[0]).forEach(function (key) {
                                            if (key.endsWith("_AbscondingCount")) {
                                                months.push(key.replace("_AbscondingCount", ""));
                                            }
                                        });

                                        merges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: months.length } });
                                        currentRow++;

                                        var firstColLabel = categoryLabels[loopPos] || "Category";
                                        var headerRow = [firstColLabel];

                                        months.forEach(function (m) {
                                            headerRow.push(m);
                                        });
                                        headerRow.push("Grand Total");
                                        headerRowsTracker.push(currentRow);
                                        aoa.push(headerRow);
                                        currentRow += 1;
                                        var colTotalsSimple = new Array(months.length).fill(0);
                                        var grandTotalOfAllSimple = 0;
                                        summaryData.forEach(function (item) {
                                            var row = [item.RowName || ""];
                                            var rowGrandTotal = 0;
                                            months.forEach(function (m, idx) {
                                                var val = item[m + "_AbscondingCount"] !== undefined ? parseInt(item[m + "_AbscondingCount"]) || 0 : 0;
                                                row.push(val);
                                                colTotalsSimple[idx] += val;
                                                rowGrandTotal += val;
                                            });
                                            row.push(rowGrandTotal);
                                            grandTotalOfAllSimple += rowGrandTotal;
                                            aoa.push(row);
                                            currentRow++;
                                        });

                                        var totalRowSimple = ["Total"];
                                        colTotalsSimple.forEach(function (tVal) {
                                            totalRowSimple.push(tVal);
                                        });
                                        totalRowSimple.push(grandTotalOfAllSimple);
                                        aoa.push(totalRowSimple);
                                        totalRowsTracker.push(currentRow);
                                        currentRow++;



                                    }

                                    aoa.push([]);
                                    currentRow += 1;
                                }
                            });

                            var wsAbsSummary = XLSX.utils.aoa_to_sheet(aoa);
                            wsAbsSummary['!totalRows'] = totalRowsTracker;
                            wsAbsSummary['!merges'] = merges;
                            wsAbsSummary['!headerRows'] = headerRowsTracker;
                            wsAbsSummary['!titleRows'] = titleRowsTracker;

                            XLSX.utils.book_append_sheet(wb, wsAbsSummary, "Absconding Summary");
                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching absconding summary data for Excel:", error);
                        }
                    });

                    // 2. Absconding Details Sheet
                    var absTableElem = createTableFromDataTable('YearWiseabscondleavelist');
                    if (absTableElem) {
                        var wsAbs = XLSX.utils.table_to_sheet(absTableElem, { raw: true });
                        XLSX.utils.book_append_sheet(wb, wsAbs, "Absconding Details");
                    }
                    // 4. Single "leave summary" Sheet (Sequence: Domain [0] -> Location [1] -> Domain Head [2])
                    $.ajax({
                        type: "POST",
                        url: "AbscondingAndLeaveReport.aspx/GetYearWiseTotalLeavesSummary",
                        data: JSON.stringify({ Year: selectedYear }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            var allTables = JSON.parse(response.d);
                            var months = [];
                            for (var t = 0; t < allTables.length; t++) {
                                if (allTables[t] && allTables[t].length > 0) {
                                    Object.keys(allTables[t][0]).forEach(function (key) {
                                        if (key.endsWith("_EmployeeCount")) {
                                            months.push(key.replace("_EmployeeCount", ""));
                                        }
                                    });
                                    break;
                                }
                            }
                            var sequenceIndices = [0, 1, 2];
                            var tableTitles = ["Domain Wise Summary", "Location Wise Summary", "Domain Head Wise Summary"];
                            var categoryLabels = ["Domain", "Location", "Domain Head"];

                            var aoa = [];
                            var merges = [];
                            var headerRowsTracker = [];
                            var titleRowsTracker = [];
                            var totalRowsTracker = [];
                            var currentRow = 0;


                            sequenceIndices.forEach(function (tableIdx, loopPos) {
                                var summaryData = allTables[tableIdx];
                                if (summaryData && summaryData.length > 0) {
                                    var sectionTitle = tableTitles[loopPos] || ("Summary Table " + (loopPos + 1));
                                    aoa.push([sectionTitle]);
                                    titleRowsTracker.push(currentRow);
                                    merges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow, c: 10 } });
                                    currentRow++;

                                    var firstColLabel = categoryLabels[loopPos] || "Category";
                                    var headerRow1 = [firstColLabel];
                                    var headerRow2 = [firstColLabel];

                                    months.forEach(function (m) {
                                        headerRow1.push(m, m);
                                        headerRow2.push("Employee Count", "For Days");
                                    });

                                    headerRowsTracker.push(currentRow);
                                    headerRowsTracker.push(currentRow + 1);

                                    aoa.push(headerRow1);
                                    aoa.push(headerRow2);

                                    merges.push({ s: { r: currentRow, c: 0 }, e: { r: currentRow + 1, c: 0 } });
                                    for (var i = 0; i < months.length; i++) {
                                        var colIdx = 1 + (i * 2);
                                        merges.push({ s: { r: currentRow, c: colIdx }, e: { r: currentRow, c: colIdx + 1 } });
                                    }

                                    currentRow += 2;

                                    var totalColumnsCount = months.length * 2;
                                    var colTotals = new Array(totalColumnsCount).fill(0);

                                    summaryData.forEach(function (item) {
                                        var row = [item.RowName || ""];
                                        var colIdx = 0;
                                        months.forEach(function (m) {
                                            var empVal = item[m + "_EmployeeCount"] !== undefined ? parseInt(item[m + "_EmployeeCount"]) || 0 : 0;
                                            var daysVal = item[m + "_ForDays"] !== undefined ? parseInt(item[m + "_ForDays"]) || 0 : 0;

                                            row.push(empVal);
                                            row.push(daysVal);
                                            colTotals[colIdx] += empVal;
                                            colTotals[colIdx + 1] += daysVal;
                                            colIdx += 2;
                                        });
                                        aoa.push(row);
                                        currentRow++;
                                    });

                                    var totalRow = ["Total"];
                                    colTotals.forEach(function (tVal) {
                                        totalRow.push(tVal);
                                    });
                                    aoa.push(totalRow);
                                    totalRowsTracker.push(currentRow);
                                    currentRow++;

                                    aoa.push([]);
                                    currentRow += 1;
                                }
                            });

                            var wsSummary = XLSX.utils.aoa_to_sheet(aoa);
                            wsSummary['!merges'] = merges;
                            wsSummary['!headerRows'] = headerRowsTracker;
                            wsSummary['!titleRows'] = titleRowsTracker;
                            wsSummary['!totalRows'] = totalRowsTracker;
                            XLSX.utils.book_append_sheet(wb, wsSummary, "Leaves Summary");
                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching leave summary data for Excel:", error);
                        }
                    });
                    // 3. Leaves Details Sheet
                    var leaveTableElem = createTableFromDataTable('YearWisetotalleavelist');
                    if (leaveTableElem) {
                        var wsLeave = XLSX.utils.table_to_sheet(leaveTableElem, { raw: true });
                        XLSX.utils.book_append_sheet(wb, wsLeave, "Leaves Details");
                    }



                    // Sheets formatting loop
                    wb.SheetNames.forEach(function (sName) {
                        var wsSheet = wb.Sheets[sName];
                        if (wsSheet['!ref']) {
                            var range = XLSX.utils.decode_range(wsSheet['!ref']);

                            for (var R = range.s.r; R <= range.e.r; ++R) {
                                for (var C = range.s.c; C <= range.e.c; ++C) {
                                    var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
                                    var cell = wsSheet[cellAddress];
                                    if (cell && cell.v !== undefined) {
                                        if (!isNaN(cell.v) && cell.v !== "" && typeof cell.v !== 'boolean') {
                                            cell.t = 'n';
                                            cell.v = Number(cell.v);
                                        }
                                    }
                                }
                            }

                            if (sName !== "Leaves Summary" && sName !== "Absconding Summary") {
                                wsSheet['!autofilter'] = { ref: wsSheet['!ref'] };
                            }

                            var colWidths = [];
                            for (var C = range.s.c; C <= range.e.c; ++C) {
                                var maxWidth = 12;
                                for (var R = range.s.r; R <= range.e.r; ++R) {
                                    var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });
                                    if (wsSheet[cellAddress] && wsSheet[cellAddress].v) {
                                        var cellLength = wsSheet[cellAddress].v.toString().length;
                                        if (cellLength > maxWidth) {
                                            maxWidth = cellLength;
                                        }
                                    }
                                }
                                colWidths.push({ wch: maxWidth + 4 });
                            }
                            wsSheet['!cols'] = colWidths;

                            // Styling loop
                            for (var R = range.s.r; R <= range.e.r; ++R) {
                                for (var C = range.s.c; C <= range.e.c; ++C) {
                                    var cellAddress = XLSX.utils.encode_cell({ r: R, c: C });

                                    var cell = wsSheet[cellAddress];
                                    if (!cell || cell.v === undefined || cell.v === null || cell.v === '') {
                                        var isMerged = false;
                                        if (wsSheet['!merges']) {
                                            isMerged = wsSheet['!merges'].some(function (m) {
                                                return R >= m.s.r && R <= m.e.r && C >= m.s.c && C <= m.e.c;
                                            });
                                        }
                                        if (!isMerged) {
                                            if (cell) delete cell.s;
                                            continue;
                                        }
                                    }
                                    if (!wsSheet[cellAddress]) wsSheet[cellAddress] = { t: 's', v: '' };

                                    if (!wsSheet[cellAddress].s) wsSheet[cellAddress].s = {};

                                    wsSheet[cellAddress].s.border = {
                                        top: { style: "thin", color: { rgb: "000000" } },
                                        bottom: { style: "thin", color: { rgb: "000000" } },
                                        left: { style: "thin", color: { rgb: "000000" } },
                                        right: { style: "thin", color: { rgb: "000000" } }
                                    };

                                    if (sName === "Leaves Summary" || sName === "Absconding Summary") {
                                        if (wsSheet['!titleRows'] && wsSheet['!titleRows'].includes(R)) {
                                            wsSheet[cellAddress].s.font = { bold: true, color: { rgb: "000000" }, sz: 12 };
                                            wsSheet[cellAddress].s.alignment = { horizontal: "center", vertical: "center" };
                                        }
                                        else if (wsSheet['!headerRows'] && wsSheet['!headerRows'].includes(R)) {
                                            wsSheet[cellAddress].s.fill = { patternType: "solid", fgColor: { rgb: "D3D3D3" } };
                                            wsSheet[cellAddress].s.font = { bold: true, color: { rgb: "000000" } };
                                            wsSheet[cellAddress].s.alignment = { horizontal: "center", vertical: "center", wrapText: true };
                                        }
                                        else if (wsSheet['!totalRows'] && wsSheet['!totalRows'].includes(R)) {
                                            wsSheet[cellAddress].s.fill = { patternType: "solid", fgColor: { rgb: "EAEAEA" } }; // हलका लाईट कलर
                                            wsSheet[cellAddress].s.font = { bold: true, color: { rgb: "000000" } }; // **यामुळे Bold होईल**
                                            wsSheet[cellAddress].s.alignment = { horizontal: C === 0 ? "left" : "right", vertical: "center" };
                                        }
                                    } else if (R === 0) {
                                        wsSheet[cellAddress].s.fill = { patternType: "solid", fgColor: { rgb: "D3D3D3" } };
                                        wsSheet[cellAddress].s.font = { bold: true, color: { rgb: "000000" } };
                                        wsSheet[cellAddress].s.alignment = { horizontal: "center", vertical: "center" };
                                    }
                                }
                            }
                        }
                    });
                    if (wb.Sheets["Leaves Details"]) {
                        var ws = wb.Sheets["Leaves Details"];
                        if (!ws['!cols']) ws['!cols'] = [];
                        ws['!cols'][13] = { wch: 50 };
                        ws['!cols'][18] = { wch: 50 };
                    }
                    if (wb.Sheets["Absconding Details"]) {
                        var ws = wb.Sheets["Absconding Details"];
                        if (!ws['!cols']) ws['!cols'] = [];
                        ws['!cols'][14] = { wch: 50 };
                    }
                    XLSX.writeFile(wb, fileName);

                } catch (err) {
                    console.error("Export Error: ", err);
                    alert("Export Error occurred while generating reports.");
                }
            });
        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

 
            <div class="sec-hero">
                <span class="sec-hero-icon">
                    <i class="fas fa-user-clock"></i>
                </span>
                <div>
                    <h1 class="sec-title">Monthly Absconding and Leaves Report</h1>
                    <p class="sec-subtitle">
                        View absconding employees and leave records by month and year.
                    </p>
                </div>
            </div>
  

                <ul class="nav nav-tabs border-bottom-0" id="main-report-tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active font-weight-bold" id="tab-monthly-link" data-toggle="pill" href="#tab-monthly-content" role="tab" aria-controls="tab-monthly-content" aria-selected="true"> <i class="fas fa-calendar-alt"></i>&nbsp;&nbsp;Monthly Report</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link font-weight-bold" id="tab-yearly-link" data-toggle="pill" href="#tab-yearly-content" role="tab" aria-controls="tab-yearly-content" aria-selected="false"> <i class="fas fa-layer-group"></i>&nbsp;&nbsp;Yearly Report</a>
                    </li>
                </ul>


                <div class="tab-content">
                    <div class="tab-pane fade show active" id="tab-monthly-content" role="tabpanel" aria-labelledby="tab-monthly-link">
                        <div class="al-card">
                            <div class="row align-items-end g-3">
                                <div class="col-lg-4 col-md-6">
                                    <label class="al-label">Month</label>
                                    <select id="ableave_month" name="ableave_month" class="form-control al-input">
                                        <option value="">Select Month</option>
                                        <option value="January">January</option>
                                        <option value="February">February</option>
                                        <option value="March">March</option>
                                        <option value="April">April</option>
                                        <option value="May">May</option>
                                        <option value="June">June</option>
                                        <option value="July">July</option>
                                        <option value="August">August</option>
                                        <option value="September">September</option>
                                        <option value="October">October</option>
                                        <option value="November">November</option>
                                        <option value="December">December</option>
                                    </select>
                                </div>

                                <div class="col-lg-4 col-md-6">
                                    <label class="al-label">Year</label>
                                    <select id="ableave_year" name="ableave_year" class="form-control al-input">
                                        <option value="">Select Year</option>
                                    </select>
                                </div>

                                <div class="col-lg-2 col-md-6">
                                    <button id="ableave_btnShow" type="button" class="al-btn al-show" onclick="return ableave_Submit();">
                                        <i class="fas fa-search"></i>&nbsp;&nbsp;Get Record
                                    </button>
                                </div>

                                <div class="col-lg-2 col-md-6">
                                    <button id="ableave_btnExport" type="button" class="al-btn al-export" onclick="return export_Submit();">
                                        <i class="fas fa-file-excel"></i>&nbsp;&nbsp;Export
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="al-tabs-card">
                            <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><i class="fas fa-user-slash"></i>&nbsp;&nbsp;Absconding</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><i class="fas fa-calendar-minus"></i>&nbsp;&nbsp;Leaves</a>
                                </li>

                            </ul>

                            <div class="tab-content" id="custom-tabs-one-tabContent">
                                <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel">
                                    <div class="al-table-wrap">
                                        <table class="table table-bordered table-hover al-table" id="abscondleavelist">
                                            <!-- keep your same thead and tbody here -->
                                        </table>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel">
                                    <div class="al-table-wrap">
                                        <table class="table table-bordered table-hover al-table" id="totalleavelist">
                                            <!-- keep your same thead and tbody here -->
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="tab-yearly-content" role="tabpanel" aria-labelledby="tab-yearly-link">
                        <div class="al-card">
                            <div class="row align-items-end g-3">
                                <div class="col-lg-4 col-md-6">
                                    <label class="al-label">Year</label>
                                    <select id="yearableave_year" name="yearableave_year" class="form-control al-input">
                                        <option value="">Select Year</option>
                                    </select>
                                </div>

                                <div class="col-lg-2 col-md-6">
                                    <button id="yearableave_btnShow" type="button" class="al-btn al-show" onclick="return yearableave_Submit();">
                                        <i class="fas fa-search"></i>&nbsp;&nbsp;Get Record
                                    </button>
                                </div>

                                <div class="col-lg-2 col-md-6">
                                    <button id="yearableave_btnExport" type="button" class="al-btn al-export">
                                        <i class="fas fa-file-excel"></i>&nbsp;&nbsp;Export
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="al-tabs-card">
                            <ul class="nav nav-tabs" id="Yearcustom-tabs-one-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="Yearcustom-tabs-one-home-tab" data-toggle="pill" href="#Yearcustom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><i class="fas fa-user-slash"></i>&nbsp;&nbsp;Absconding</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Yearcustom-tabs-one-profile-tab" data-toggle="pill" href="#Yearcustom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><i class="fas fa-calendar-minus"></i>&nbsp;&nbsp;Leaves</a>
                                </li>
                            </ul>
                            <div class="tab-content" id="Yearcustom-tabs-one-tabContent">
                                <div class="tab-pane fade show active" id="Yearcustom-tabs-one-home" role="tabpanel">
                                    <div class="al-table-wrap">
                                        <table class="table table-bordered table-hover al-table" id="YearWiseabscondleavelist">
                                           
                                        </table>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="Yearcustom-tabs-one-profile" role="tabpanel">
                                    <div class="al-table-wrap">
                                        <table class="table table-bordered table-hover al-table" id="YearWisetotalleavelist">
                                           
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
           
      
    
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
</asp:Content>
