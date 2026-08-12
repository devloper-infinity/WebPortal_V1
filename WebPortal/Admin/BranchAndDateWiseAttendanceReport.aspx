<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BranchAndDateWiseAttendanceReport.aspx.cs" Inherits="WebPortal.Admin.BranchAndDateWiseAttendanceReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --bda-primary: #1f3c88;
            --bda-blue: #2575fc;
            --bda-cyan: #1bc5e8;
            --bda-bg: #f4f7fb;
            --bda-card: #ffffff;
            --bda-text: #172033;
            --bda-muted: #64748b;
            --bda-border: #dbe3ef;
            --bda-shadow: 0 12px 28px rgba(21, 98, 228, .12);
        }

        body {
            background: var(--bda-bg);
        }

        #load1.bda-loading-overlay {
            display: none !important;
            position: fixed !important;
            top: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            padding: 0 !important;
            z-index: 99999 !important;
            float: none !important;
            background: rgba(255,255,255,.72);
            backdrop-filter: blur(3px);
        }

        #load1.bda-loading-overlay.bda-loading-visible {
            display: block !important;
        }

        #load1 .bda-loading-content {
            position: fixed !important;
            top: 50% !important;
            left: 50% !important;
            width: 180px;
            margin: 0 !important;
            text-align: center;
            transform: translate(-50%, -50%) !important;
        }

        #load1 .bda-loading-content img {
            display: block;
            width: 70px;
            height: 70px;
            margin: 0 auto;
        }

        #load1 .bda-loading-text {
            margin-top: 10px;
            color: var(--bda-text);
            font-size: 12px;
            font-weight: 700;
        }

        .bda-page {
            background: var(--bda-bg);
            min-height: calc(100vh - 90px);
        }

        .bda-hero {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 17px 35px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: var(--bda-shadow);
        }

        .bda-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 8px;
            border: 2px solid rgba(255,255,255,.75);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
        }

            .bda-hero-icon i {
                color: #fff;
                font-size: 28px;
            }

        .bda-title {
            margin: 0;
            color: #fff;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.2;
        }

        .bda-subtitle {
            margin: 8px 0 0;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.5;
        }

        .bda-panel {
            margin-bottom: 18px;
            border: 1px solid var(--bda-border);
            border-radius: 8px;
            background: var(--bda-card);
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .bda-panel-body {
            padding: 18px;
        }

        .bda-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px;
            align-items: end;
        }

        .bda-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .bda-field .form-control {
            min-height: 42px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: #fff;
            color: var(--bda-text);
            font-size: 13px;
            box-shadow: 0 1px 2px rgba(15, 23, 42, .03);
        }

            .bda-field .form-control:focus {
                border-color: rgba(37, 117, 252, .68);
                box-shadow: 0 0 0 .15rem rgba(37, 117, 252, .14);
            }

        .bda-actions {
            display: flex;
            gap: 10px;
            align-items: end;
        }

        .bda-btn {
            min-height: 42px;
            min-width: 122px;
            border: 0;
            border-radius: 8px;
            color: #fff !important;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: .2s ease;
        }

            .bda-btn:hover {
                color: #fff !important;
                transform: translateY(-1px);
                box-shadow: 0 10px 18px rgba(15, 23, 42, .14);
            }

        .bda-btn-primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 60%, #1bc5e8 100%);
        }

        .bda-btn-muted {
            background: #f1f5f9;
            color: #334155 !important;
            border: 1px solid #dbe3ef;
        }

            .bda-btn-muted:hover {
                color: #334155 !important;
            }

        .bda-table-panel {
            border: 1px solid var(--bda-border);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .bda-table-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--bda-border);
            background: #f8fafc;
        }

        .bda-table-title {
            margin: 0;
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
        }

        .bda-count {
            color: var(--bda-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bda-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        #bda_table {
            width: 100% !important;
            margin-bottom: 0;
        }

            #bda_table thead th {
                background: #edf3f6 !important;
                color: #0f172a !important;
                font-size: 12px;
                font-weight: 800;
                white-space: nowrap;
                vertical-align: middle;
                border-bottom: 1px solid #dbe3ef !important;
                text-align: center;
            }

            #bda_table thead tr:first-child th {
                color: #163a63 !important;
                background: #bfdbfe !important;
                border-color: #93c5fd !important;
            }

            #bda_table thead tr:first-child th[rowspan] {
                background: #dbeafe !important;
            }

            #bda_table thead tr:nth-child(2) th {
                color: #1e3a5f !important;
                background: #eff6ff !important;
                border-color: #bfdbfe !important;
            }

            #bda_table thead .bda-group-total,
            #bda_table tbody .bda-group-total,
            #bda_table tfoot .bda-group-total {
                color: #163a63 !important;
                background: #dbeafe !important;
                font-weight: 800;
            }

            #bda_table tbody td {
                color: #334155;
                font-size: 12px;
                vertical-align: middle;
                white-space: nowrap;
                text-align: center;
            }

                #bda_table tbody td:first-child {
                    text-align: left;
                }

            #bda_table tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            height: 34px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 9px;
        }

        div.dt-buttons {
            float: left;
            margin: 0 0 8px 12px;
        }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: linear-gradient(90deg, #10b981, #22c55e) !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 13px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
        }

        @media (max-width: 992px) {
            .bda-filter-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }

            .bda-actions {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 576px) {
            .bda-hero {
                padding: 16px;
                align-items: flex-start;
            }

            .bda-hero-icon {
                width: 46px;
                height: 46px;
                min-width: 46px;
            }

            .bda-filter-grid {
                grid-template-columns: 1fr;
            }

            .bda-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .bda-btn {
                width: 100%;
            }

            .bda-table-head {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        /* DataTable Footer */
        #bda_table tfoot th {
            background: #EDF3F6 !important;
            font-weight: 700;
            text-align: center !important;
            vertical-align: middle;
            border: 1px solid #d6e4f0;
            padding: 10px 8px;
            white-space: nowrap;
        }

            #bda_table tfoot th:first-child {
                text-align: center !important;
            }
    </style>

    <script>
        var bdaTable = null;

        $(document).ready(function () {
            bdaBindMonthYear();
            // bdaRenderTable([]);
        });

        function bdaBindMonthYear() {
            var months = [
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ];
            var now = new Date();
            var ddlMonth = $("#bda_month");
            var ddlYear = $("#bda_year");
            var currentYear = now.getFullYear();
            var i;

            ddlMonth.empty();
            ddlMonth.append($("<option></option>").val("").text("Select Month"));

            for (i = 0; i < months.length; i++) {
                ddlMonth.append($("<option></option>").val(months[i]).text(months[i]));
            }

            ddlMonth.val(months[now.getMonth()]);

            ddlYear.empty();
            ddlYear.append($("<option></option>").val("").text("Select Year"));

            for (i = currentYear - 5; i <= currentYear + 1; i++) {
                ddlYear.append($("<option></option>").val(String(i)).text(String(i)));
            }

            ddlYear.val(String(currentYear));
        }

        function bdaShowReport() {

            var month = $("#bda_month").val();
            var year = $("#bda_year").val();

            if (month === "") {
                bdaNotify("Please select month.");
                $("#bda_month").focus();
                return false;
            }

            if (year === "") {
                bdaNotify("Please select year.");
                $("#bda_year").focus();
                return false;
            }

            $("#load1").addClass("bda-loading-visible");

            bd_bindGrid(month, year);

            return false;
        }

        var bda_table = null;
        var bdaLocations = ["AJ", "KP", "Akola", "Bangalore", "Solapur"];

        function bdaToNumber(value) {
            var number = parseInt(String(value == null ? "0" : value).replace(/,/g, ""), 10);
            return isNaN(number) ? 0 : number;
        }

        function bdaLocationName(value) {
            var location = $.trim(String(value == null ? "" : value)).toLowerCase();
            var i;

            for (i = 0; i < bdaLocations.length; i++) {
                if (bdaLocations[i].toLowerCase() === location) {
                    return bdaLocations[i];
                }
            }

            return "";
        }

        function bdaFormatDate(value) {
            var text = $.trim(String(value == null ? "" : value));
            var match = /^(\d{1,2})-([A-Za-z]{3})-(\d{4})$/.exec(text);
            var months = { Jan: 1, Feb: 2, Mar: 3, Apr: 4, May: 5, Jun: 6, Jul: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11, Dec: 12 };

            if (match && months[match[2]]) {
                return months[match[2]] + "/" + parseInt(match[1], 10) + "/" + match[3];
            }

            return text;
        }

        function bdaPivotRows(sourceRows) {
            var rowsByDate = {};
            var pivotRows = [];

            $.each(sourceRows || [], function (_, source) {
                var dateKey = $.trim(String(source.AttendanceDate == null ? "" : source.AttendanceDate));
                var dayName = $.trim(String(source.DayName == null ? "" : source.DayName));
                var key = dateKey + "|" + dayName;
                var location = bdaLocationName(source.Location);
                var dd = bdaToNumber(source.DD);
                var nonDd = bdaToNumber(source["Non-DD"] != null ? source["Non-DD"] : source.NonDD);
                var support = bdaToNumber(source.Support);
                var total = source.Total == null || source.Total === ""
                    ? dd + nonDd + support
                    : bdaToNumber(source.Total);
                var row;
                var i;

                if (!rowsByDate[key]) {
                    row = {
                        AttendanceDate: bdaFormatDate(dateKey),
                        DayName: dayName,
                        Total: 0
                    };

                    for (i = 0; i < bdaLocations.length; i++) {
                        row["DD_" + bdaLocations[i]] = 0;
                        row["NDD_" + bdaLocations[i]] = 0;
                        row["Support_" + bdaLocations[i]] = 0;
                    }

                    row.DD_Total = 0;
                    row.NDD_Total = 0;
                    row.Support_Total = 0;

                    rowsByDate[key] = row;
                    pivotRows.push(row);
                }

                row = rowsByDate[key];

                if (location) {
                    row["DD_" + location] += dd;
                    row["NDD_" + location] += nonDd;
                    row["Support_" + location] += support;
                }

                row.DD_Total += dd;
                row.NDD_Total += nonDd;
                row.Support_Total += support;
                row.Total += total;
            });

            return pivotRows;
        }

        function bdaColumns() {
            var columns = [
                { data: "AttendanceDate", defaultContent: "", className: "text-nowrap" },
                { data: "DayName", defaultContent: "", className: "text-nowrap" }
            ];

            $.each(["DD", "NDD", "Support"], function (_, group) {
                $.each(bdaLocations, function (__, location) {
                    columns.push({
                        data: group + "_" + location,
                        defaultContent: 0,
                        className: "text-center"
                    });
                });

                columns.push({
                    data: group + "_Total",
                    defaultContent: 0,
                    className: "text-center bda-group-total"
                });
            });

            columns.push({ data: "Total", defaultContent: 0, className: "text-center font-weight-bold" });
            return columns;
        }

        function bdaExcelColumnName(columnNumber) {
            var name = "";

            while (columnNumber > 0) {
                columnNumber--;
                name = String.fromCharCode(65 + (columnNumber % 26)) + name;
                columnNumber = Math.floor(columnNumber / 26);
            }

            return name;
        }

        function bdaCustomizeExcel(xlsx) {
            var sheet = xlsx.xl.worksheets["sheet1.xml"];
            var styles = xlsx.xl["styles.xml"];
            var worksheet = sheet.documentElement;
            var sheetData = worksheet.getElementsByTagName("sheetData")[0];
            var fills = styles.getElementsByTagName("fills")[0];
            var cellXfs = styles.getElementsByTagName("cellXfs")[0];
            var mergeRanges = [];
            var occupied = {};
            var excelRows = {};
            var rowNumber = 1;

            function addFill(rgb) {
                var fill = styles.createElement("fill");
                var pattern = styles.createElement("patternFill");
                var foreground = styles.createElement("fgColor");
                var background = styles.createElement("bgColor");

                pattern.setAttribute("patternType", "solid");
                foreground.setAttribute("rgb", rgb);
                background.setAttribute("indexed", "64");
                pattern.appendChild(foreground);
                pattern.appendChild(background);
                fill.appendChild(pattern);
                fills.appendChild(fill);
                fills.setAttribute("count", fills.getElementsByTagName("fill").length.toString());
                return fills.getElementsByTagName("fill").length - 1;
            }

            function addStyle(fontId, fillId, boldBorder) {
                var style = styles.createElement("xf");
                var alignment = styles.createElement("alignment");

                style.setAttribute("numFmtId", "0");
                style.setAttribute("fontId", String(fontId));
                style.setAttribute("fillId", String(fillId));
                style.setAttribute("borderId", boldBorder ? "1" : "1");
                style.setAttribute("xfId", "0");
                style.setAttribute("applyFont", "1");
                style.setAttribute("applyFill", "1");
                style.setAttribute("applyBorder", "1");
                style.setAttribute("applyAlignment", "1");

                alignment.setAttribute("horizontal", "center");
                alignment.setAttribute("vertical", "center");
                alignment.setAttribute("wrapText", "1");
                style.appendChild(alignment);
                cellXfs.appendChild(style);
                cellXfs.setAttribute("count", cellXfs.getElementsByTagName("xf").length.toString());
                return cellXfs.getElementsByTagName("xf").length - 1;
            }

            var topHeaderFill = addFill("FFBFDBFE");
            var subHeaderFill = addFill("FFEFF6FF");
            var totalFill = addFill("FFDBEAFE");
            var topHeaderStyle = addStyle(2, topHeaderFill, true);
            var subHeaderStyle = addStyle(2, subHeaderFill, true);
            var dataStyle = addStyle(0, 0, true);
            var totalStyle = addStyle(2, totalFill, true);

            while (sheetData.firstChild) {
                sheetData.removeChild(sheetData.firstChild);
            }

            $(worksheet).find("mergeCells, cols").remove();

            function getExcelRow(number, height) {
                var row = excelRows[number];

                if (!row) {
                    row = sheet.createElement("row");
                    row.setAttribute("r", number);
                    row.setAttribute("ht", height || 21);
                    row.setAttribute("customHeight", "1");
                    excelRows[number] = row;
                }

                return row;
            }

            function appendCell(row, columnNumber, value, styleIndex, isNumber) {
                var cell = sheet.createElement("c");
                var cellRef = bdaExcelColumnName(columnNumber) + row.getAttribute("r");

                cell.setAttribute("r", cellRef);
                cell.setAttribute("s", String(styleIndex));

                if (isNumber) {
                    var numericValue = sheet.createElement("v");
                    cell.setAttribute("t", "n");
                    numericValue.textContent = String(bdaToNumber(value));
                    cell.appendChild(numericValue);
                }
                else {
                    var inlineString = sheet.createElement("is");
                    var text = sheet.createElement("t");
                    cell.setAttribute("t", "inlineStr");
                    text.textContent = String(value == null || value === "" ? " " : value);
                    inlineString.appendChild(text);
                    cell.appendChild(inlineString);
                }

                row.appendChild(cell);
            }

            $("#bda_table thead tr").each(function (headerIndex) {
                var currentRowNumber = rowNumber + headerIndex;
                var excelRow = getExcelRow(currentRowNumber, 24);
                var columnNumber = 1;
                var headerStyle = headerIndex === 0 ? topHeaderStyle : subHeaderStyle;

                $(this).children("th").each(function () {
                    var colspan = parseInt($(this).attr("colspan"), 10) || 1;
                    var rowspan = parseInt($(this).attr("rowspan"), 10) || 1;
                    var startColumn;
                    var endColumn;
                    var endRow;
                    var rr;
                    var cc;

                    while (occupied[currentRowNumber + "-" + columnNumber]) {
                        columnNumber++;
                    }

                    startColumn = columnNumber;
                    endColumn = startColumn + colspan - 1;
                    endRow = currentRowNumber + rowspan - 1;
                    appendCell(excelRow, startColumn, $.trim($(this).text()), $(this).hasClass("bda-group-total") ? totalStyle : headerStyle, false);

                    for (rr = currentRowNumber; rr <= endRow; rr++) {
                        for (cc = startColumn; cc <= endColumn; cc++) {
                            occupied[rr + "-" + cc] = true;

                            if (rr !== currentRowNumber || cc !== startColumn) {
                                appendCell(getExcelRow(rr, 24), cc, "", headerStyle, false);
                            }
                        }
                    }

                    if (colspan > 1 || rowspan > 1) {
                        mergeRanges.push(bdaExcelColumnName(startColumn) + currentRowNumber + ":" + bdaExcelColumnName(endColumn) + endRow);
                    }

                    columnNumber += colspan;
                });
            });

            rowNumber += 2;

            var columnDefinitions = bdaColumns();
            var exportedRows = bda_table.rows({ search: "applied" }).data().toArray();
            var groupTotalColumns = { 8: true, 14: true, 20: true, 21: true };

            $.each(exportedRows, function (_, dataRow) {
                var excelRow = getExcelRow(rowNumber, 20);

                $.each(columnDefinitions, function (columnIndex, definition) {
                    var excelColumn = columnIndex + 1;
                    var numeric = excelColumn > 2;
                    appendCell(
                        excelRow,
                        excelColumn,
                        dataRow[definition.data],
                        groupTotalColumns[excelColumn] ? totalStyle : dataStyle,
                        numeric
                    );
                });

                rowNumber++;
            });

            var footerRow = getExcelRow(rowNumber, 22);
            appendCell(footerRow, 1, "Grand Total", totalStyle, false);
            appendCell(footerRow, 2, "", totalStyle, false);
            mergeRanges.push("A" + rowNumber + ":B" + rowNumber);

            for (var footerColumn = 3; footerColumn <= 21; footerColumn++) {
                var propertyName = columnDefinitions[footerColumn - 1].data;
                var columnTotal = 0;

                $.each(exportedRows, function (_, dataRow) {
                    columnTotal += bdaToNumber(dataRow[propertyName]);
                });

                appendCell(footerRow, footerColumn, columnTotal, totalStyle, true);
            }

            Object.keys(excelRows).sort(function (a, b) { return Number(a) - Number(b); }).forEach(function (key) {
                var excelRow = excelRows[key];
                var cells = Array.prototype.slice.call(excelRow.getElementsByTagName("c"));

                cells.sort(function (left, right) {
                    function columnIndex(cell) {
                        var letters = cell.getAttribute("r").replace(/[0-9]/g, "");
                        var index = 0;

                        for (var i = 0; i < letters.length; i++) {
                            index = (index * 26) + letters.charCodeAt(i) - 64;
                        }

                        return index;
                    }

                    return columnIndex(left) - columnIndex(right);
                });

                $.each(cells, function (_, cell) {
                    excelRow.appendChild(cell);
                });

                sheetData.appendChild(excelRow);
            });

            var columns = sheet.createElement("cols");
            for (var widthColumn = 1; widthColumn <= 21; widthColumn++) {
                var column = sheet.createElement("col");
                var width = widthColumn === 1 ? 14 : (widthColumn === 2 ? 12 : (groupTotalColumns[widthColumn] ? 11 : 10));
                column.setAttribute("min", widthColumn);
                column.setAttribute("max", widthColumn);
                column.setAttribute("width", width);
                column.setAttribute("customWidth", "1");
                columns.appendChild(column);
            }
            worksheet.insertBefore(columns, sheetData);

            var mergeCells = sheet.createElement("mergeCells");
            mergeCells.setAttribute("count", mergeRanges.length);
            $.each(mergeRanges, function (_, range) {
                var mergeCell = sheet.createElement("mergeCell");
                mergeCell.setAttribute("ref", range);
                mergeCells.appendChild(mergeCell);
            });

            if (sheetData.nextSibling) {
                worksheet.insertBefore(mergeCells, sheetData.nextSibling);
            }
            else {
                worksheet.appendChild(mergeCells);
            }
        }

        function bd_bindGrid(month, year) {

            $('#load1').addClass('bda-loading-visible');

            $.ajax({
                type: "POST",
                url: "BranchAndDateWiseAttendanceReport.aspx/GetBranchAndDateWiseAttendanceReport",
                data: JSON.stringify({ Month: month, Year: year }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (data) {

                    var result = JSON.parse(data.d || "{}");
                    var dataArray = bdaPivotRows(result.Rows || []);

                    if ($.fn.DataTable.isDataTable('#bda_table')) {
                        $('#bda_table').DataTable().clear().destroy();
                    }

                    bda_table = $('#bda_table').DataTable({
                        data: dataArray,
                        dom: 'Bfrtip',
                        paging: false,
                        searching: true,
                        info: true,
                        autoWidth: false,
                        ordering: false,
                        processing: true,
                        deferRender: true,

                        buttons: [
                            {
                                extend: 'excelHtml5',
                                text: 'Excel',
                                className: 'btn btn-success',
                                title: 'Date Wise Attendance Details',
                                footer: true,
                                customize: bdaCustomizeExcel
                            }
                        ],

                        columns: bdaColumns(),

                        footerCallback: function () {

                            var api = this.api();

                            var intVal = function (i) {
                                return parseInt(i, 10) || 0;
                            };

                            for (var col = 2; col <= 20; col++) {

                                var total = api.column(col).data().reduce(function (a, b) {
                                    return intVal(a) + intVal(b);
                                }, 0);

                                $(api.column(col).footer())
                                    .html(total)
                                    .css({
                                        "text-align": "center",
                                        "font-weight": "700",
                                        "vertical-align": "middle"
                                    });
                            }

                            $(api.column(0).footer())
                                .attr("colspan", 2)
                                .html("Grand Total")
                                .css({
                                    "text-align": "center",
                                    "font-weight": "700"
                                });
                        },

                        initComplete: function () {
                            $("#bda_count").text(dataArray.length + (dataArray.length === 1 ? " record" : " records"));
                            this.api().columns.adjust();
                        }
                    });
                },

                error: function (error) {
                    $('#load1').removeClass('bda-loading-visible');
                    alert('error: ' + error.responseText);
                },

                complete: function () {
                    $('#load1').removeClass('bda-loading-visible');
                }
            });

            return false;
        }



        function bdaClearReport() {
            if ($.fn.DataTable.isDataTable('#bda_table')) {
                $('#bda_table').DataTable().clear().destroy();
            }

            $('#bda_table tbody').empty();
            $('#bda_table tfoot th').not(':first').empty();
            $('#bda_count').text('0 records');
            bdaBindMonthYear();
            return false;
        }


        function bdaNotify(message) {
            if (window.Swal) {
                Swal.fire("Validation", message, "warning");
            }
            else {
                alert(message);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="bda-loading-overlay" id="load1">
        <div class="bda-loading-content">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="bda-loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="bda-page">
        <div class="bda-hero">
            <span class="bda-hero-icon">
                <i class="fas fa-calendar-check"></i>
            </span>
            <div>
                <h1 class="bda-title">Branch And Date Wise Attendance Report</h1>
                <p class="bda-subtitle">View daily attendance counts branch wise for the selected month and year.</p>
            </div>
        </div>

        <div class="bda-panel">
            <div class="bda-panel-body">
                <div class="bda-filter-grid">
                    <div class="bda-field">
                        <label for="bda_month"><i class="far fa-calendar-alt mr-1"></i>Month</label>
                        <select id="bda_month" class="form-control"></select>
                    </div>

                    <div class="bda-field">
                        <label for="bda_year"><i class="far fa-calendar-check mr-1"></i>Year</label>
                        <select id="bda_year" class="form-control"></select>
                    </div>

                    <div class="bda-actions">
                        <button type="button" id="bda_btnshow" class="bda-btn bda-btn-primary" onclick="return bdaShowReport();">
                            <i class="fas fa-search"></i>Show
                       
                        </button>
                        <button type="button" id="bda_btnclear" class="bda-btn bda-btn-muted" onclick="return bdaClearReport();">
                            <i class="fas fa-undo"></i>Clear
                       
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="bda-table-panel">
            <div class="bda-table-head">
                <h2 class="bda-table-title"><i class="fas fa-table mr-2"></i>Date Wise Attendance Details</h2>
                <span class="bda-count" id="bda_count">0 records</span>
            </div>
            <div class="bda-table-wrap">
            <table id="bda_table" class="table table-bordered" style="width: 100%;">
                <thead>
                    <tr>
                        <th rowspan="2">Date</th>
                        <th rowspan="2">Day</th>
                        <th colspan="6">DD</th>
                        <th colspan="6">Non-DD</th>
                        <th colspan="6">Support</th>
                        <th rowspan="2">Total</th>
                    </tr>
                    <tr>
                        <th>AJ</th><th>KP</th><th>Akola</th><th>Bangalore</th><th>Solapur</th><th class="bda-group-total">Total</th>
                        <th>AJ</th><th>KP</th><th>Akola</th><th>Bangalore</th><th>Solapur</th><th class="bda-group-total">Total</th>
                        <th>AJ</th><th>KP</th><th>Akola</th><th>Bangalore</th><th>Solapur</th><th class="bda-group-total">Total</th>
                    </tr>
                </thead>

                <tbody></tbody>

                <tfoot>
                    <tr>
                        <th colspan="2">Grand Total</th>
                        <th></th><th></th><th></th><th></th><th></th><th class="bda-group-total"></th>
                        <th></th><th></th><th></th><th></th><th></th><th class="bda-group-total"></th>
                        <th></th><th></th><th></th><th></th><th></th><th class="bda-group-total"></th>
                        <th></th>
                    </tr>
                </tfoot>
            </table>
            </div>
        </div>
    </div>
</asp:Content>
