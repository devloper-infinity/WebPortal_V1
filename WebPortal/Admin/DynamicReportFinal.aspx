<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DynamicReportFinal.aspx.cs" Inherits="WebPortal.Admin.DynamicReportFinal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    <style>
        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            color: black !important;
            font-weight: bold;
        }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_paginate {
            float: right !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel,
        .buttons-copy,
        .buttons-csv,
        .buttons-pdf,
        .buttons-print,
        .buttons-colvis {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin-right: 6px;
            margin-bottom: 6px;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .col-panel {
            border: 1px solid #ccc;
            padding: 12px;
            border-radius: 6px;
            width: 250px;
            background: #fafafa;
        }

        .panel-title {
            font-weight: bold;
            margin-bottom: 6px;
        }

        #activeFiltersList li {
            margin-bottom: 4px;
        }

        .report-tools {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
        }

        .report-tool-summary {
            color: #555;
            font-size: 12px;
            font-weight: 600;
            margin-left: 4px;
        }
    </style>

    <script>
        let filterList = [];
        const dateColumns = [
            "Joining_Date",
            "Resignation_Date",
            "Last_Working_Date",
            "Latest_Login_Date"
        ];
        var selectedTemplateId = 0;
        var SharingTemplateID = 0;
        var lastResultData = [];
        var pivotData = [];

        function getReportTitle(defaultTitle) {
            let templateName = ($("#templateDropdownBtn").text() || "").trim();

            if (templateName && templateName !== "Choose Report Template") {
                return templateName;
            }

            return defaultTitle || "Dynamic Report";
        }

        function getReportButtons(defaultTitle, exportOptions) {
            let title = getReportTitle(defaultTitle);
            let options = $.extend(true, { columns: ':visible' }, exportOptions || {});

            return [
                { extend: 'copy', title: title, exportOptions: options },
                { extend: 'csv', title: title, exportOptions: options },
                { extend: 'excelHtml5', title: title, autoFilter: true, exportOptions: options },
                { extend: 'pdfHtml5', title: title, orientation: 'landscape', pageSize: 'A4', exportOptions: options },
                { extend: 'print', title: title, exportOptions: options },
                { extend: 'colvis', text: 'Columns' }
            ];
        }

        function updateReportToolSummary(rowCount, mode) {
            $("#reportToolSummary").text("Rows: " + (rowCount || 0) + " | Mode: " + mode);
        }

        function resetPivotSelectors(fields) {
            $("#ddlRow, #ddlColumn, #ddlValue").empty();

            fields.forEach(f => {
                $("#ddlRow").append(`<option value="${f}">${f}</option>`);
                $("#ddlColumn").append(`<option value="${f}">${f}</option>`);
                $("#ddlValue").append(`<option value="${f}">${f}</option>`);
            });

            $("#ddlRow, #ddlColumn, #ddlValue").trigger("change");
        }

        function clearReportFilters() {
            window.SelectedFilters = [];
            $("#templateDropdownBtn").text("Choose Report Template");
            loadReport();
            return false;
        }

        function downloadCurrentReport() {
            $("#waitingpanel").modal("show");
            $("#spntext").text("Generating excel sheet : Dynamic Report");

            $.ajax({
                url: "DynamicReportFinal.aspx/DownloadCurrentReport",
                type: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({
                    Filters: JSON.stringify(window.SelectedFilters || []),
                    HiddenColumns: JSON.stringify(window.UserHiddenColumns || []),
                    ReportName: getReportTitle("Dynamic Report")
                }),
                success: function (res) {
                    $("#waitingpanel").modal("hide");

                    if (res.d) {
                        window.location = res.d;
                    } else {
                        alert("No data found for the current report.");
                    }
                },
                error: function (err) {
                    $("#waitingpanel").modal("hide");
                    alert(err.responseText || "Error downloading report.");
                }
            });

            return false;
        }

        $(document).ready(function () {
            loadTemplatesDropdown();
            loadTemplatesTable();

            $("#ddlRow, #ddlColumn, #ddlValue").select2({
                width: '100%',
                placeholder: "Select..."
            });
        });

        function openFilterPopup() {
            window.EditingTemplateID = null;
            window.EditingTemplateName = null;

            // Hide Update button (because not editing)
            $("#btnUpdateTemplateFilter").addClass("d-none");

            // Show filter modal
            $("#filterModal").modal("show");
            $("#filterModal").modal("show");

            $.ajax({
                url: "DynamicReportFinal.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    let list = JSON.parse(result.d);
                    buildFilterGrid(list);
                }
            });
            return false;
        }

        function buildFilterGrid(list) {
            let tbody = $("#filterTable tbody");
            tbody.empty();

            list.forEach(item => {

                let col = item.ColumnName || item.COLNAME || item.Name || item.Label;

                let isDate = dateColumns.includes(col.replace(' ', '_'));

                let valueInput1 = isDate
                    ? `<input type='date' class='form-control f-val1'>`
                    : `<input type='text' class='form-control f-val1'>`;

                let valueInput2 = isDate
                    ? `<input type='date' class='form-control f-val2'>`
                    : `<input type='text' class='form-control f-val2'>`;

                let row = `
                    <tr>
                        <td><input type='checkbox' class='f-select'></td>
                        <td class='f-col'>${col}</td>
                        <td>
                            <select class='form-control f-op' onchange="onOperatorChange(this)">
                                <option value="=">=</option>
                                <option value="LIKE">CONTAINS</option>
                                <option value=">">></option>
                                <option value="<"><</option>
                                <option value=">=">>=</option>
                                <option value="<="><=</option>
                                <option value="<>"><></option>
                                <option value="BETWEEN">BETWEEN</option>
                                <option value="IN">IN</option>
                            </select>
                        </td>
                        <td>${valueInput1}</td>
                        <td>${valueInput2}</td>
                    </tr>
                    `;

                tbody.append(row);
            });
        }

        function applyAllFilters() {

            let filters = [];

            $("#filterTable tbody tr").each(function () {

                if ($(this).find(".f-select").is(":checked")) {

                    filters.push({
                        Column: $(this).find(".f-col").text(),
                        Operator: $(this).find(".f-op").val(),
                        Value1: $(this).find(".f-val1").val(),
                        Value2: $(this).find(".f-val2").val()
                    });
                }
            });


            // Save to global variable so you can pass it into GetReportData()
            window.SelectedFilters = filters;

            $("#filterModal").modal("hide");

            // Here you can trigger report reload
            loadReport();
            return false;
        }

        function renderTable(data, groupCols) {
            if (!Array.isArray(data)) data = [];

            // 🔥 1) Hidden columns (for shared templates)
            // This is filled earlier when a shared user loads template.
            let hiddenCols = window.UserHiddenColumns || [];
            // 2) Get selected order from UI
            let selectedOrder = ($('#ddlColumns').val() || []).slice();

            // 3) Determine all keys in data
            const keySet = new Set();
            data.forEach(row => {
                Object.keys(row || {}).forEach(k => keySet.add(k));
            });

            // 4) Build ordered list
            const orderedKeys = [];

            // (A) Selected columns
            selectedOrder.forEach(col => {
                if (keySet.has(col)) {
                    orderedKeys.push(col);
                    keySet.delete(col);
                }
            });

            // (B) Group columns
            if (Array.isArray(groupCols)) {
                groupCols.forEach(g => {
                    if (keySet.has(g)) {
                        orderedKeys.push(g);
                        keySet.delete(g);
                    }
                });
            }

            // (C) Remaining columns
            Array.from(keySet).forEach(k => orderedKeys.push(k));

            // Remove internal helper fields
            let visibleCols = orderedKeys.filter(k =>
                k !== '_isSummary' &&
                k !== '_count' &&
                k !== '_sumSalary'
            );

            // 🔥 NEW: Apply hidden column removal
            visibleCols = visibleCols.filter(col => !hiddenCols.includes(col));

            // Build DataTable column definitions
            const dtCols = visibleCols.map(k => ({ data: k, title: k, defaultContent: "" }));

            // destroy old table
            if (window.tableInstance && $.fn.dataTable.isDataTable('#tblResult')) {
                window.tableInstance.destroy();
                $('#tblResult').empty();
            }

            // Initialize DataTable
            window.tableInstance = $('#tblResult').DataTable({
                dom: "Blfrtip",
                data: data,
                columns: dtCols,
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                paging: true,
                lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                autoWidth: true,
                select: true,
                ordering: false,
                processing: true,
                filter: true,
                select: { style: 'single' },
                serverSide: false,
                buttons: getReportButtons('Details Report'),

                createdRow: function (row, rowData, dataIndex) {
                    if (rowData && rowData._isSummary) {
                        $(row).css({
                            'font-weight': 'bold',
                            'background': '#f0f0f0',
                            'text-wrap': 'nowrap'
                        });

                        var $visibleCells = $('td', row).filter(function () {
                            return $(this).is(':visible');
                        });

                        if ($visibleCells.length) {
                            $visibleCells.first().html(
                                'Summary: Count=' + (rowData._count || 0) +
                                ', Sum(Salary)=' + (rowData._sumSalary || 0)
                            );
                        }
                        $visibleCells.slice(1).hide();
                    } else {
                        $(row).css({ 'text-wrap': 'nowrap' });
                    }
                }
            });

            // Disable sorting on headers
            $('#tblResult thead th').css('pointer-events', 'none');
            updateReportToolSummary(data.length, "Details");
        }

        function buildPivotMatrix(data, rowFields, colFields, valueField, aggType) {

            // Normalize inputs
            rowFields = Array.isArray(rowFields) ? rowFields : (rowFields ? [rowFields] : []);
            colFields = Array.isArray(colFields) ? colFields : (colFields ? [colFields] : []);
            aggType = (aggType || "COUNT").toUpperCase();

            const matrix = {};
            const colSet = new Set();
            const rowKeyPartsMap = {}; // keep the actual parts for rendering separate columns

            data.forEach(item => {
                // build row key string by joining parts with '||' (safe separator)
                const rowParts = rowFields.map(f => (item[f] != null ? String(item[f]) : "(Blank)"));
                const rowKey = rowParts.join("||");

                // build column key string similarly
                const colParts = colFields.map(f => (item[f] != null ? String(item[f]) : "(Blank)"));
                const colKey = colParts.join("||");

                colSet.add(colKey);

                if (!matrix[rowKey]) matrix[rowKey] = {};
                if (!matrix[rowKey][colKey]) {
                    if (aggType === "SUM") matrix[rowKey][colKey] = 0;
                    else matrix[rowKey][colKey] = 0; // COUNT initial 0
                }

                if (aggType === "SUM") {
                    const v = parseFloat(item[valueField]);
                    if (!isNaN(v)) matrix[rowKey][colKey] += v;
                    // else ignore non-numeric for SUM
                } else { // COUNT
                    // count each row occurrence
                    matrix[rowKey][colKey] += 1;
                }

                // record parts for rendering separate columns later
                rowKeyPartsMap[rowKey] = rowParts;
            });

            // stable ordering for columns and rows
            const colHeaders = Array.from(colSet).sort((a, b) => a.localeCompare(b, undefined, { numeric: true }));
            const rowKeys = Object.keys(matrix); // order as encountered (or sort if you want)
            // optionally sort rowKeys:
            // rowKeys.sort();

            return {
                rowFields: rowFields,          // names of row fields
                colHeaders: colHeaders,        // array of column key strings (joined by '||')
                matrix: matrix,                // { rowKey: { colKey: value } }
                rowKeyParts: rowKeyPartsMap,   // { rowKey: [part1, part2, ...] }
                rowKeys: rowKeys
            };
        }


        function buildPivot(data, rowFields, colFields, valueField) {

            let matrix = {};
            let rowKeys = new Set();
            let colKeys = new Set();

            data.forEach(r => {

                let rowKey = rowFields.map(f => r[f]).join(" | ");
                let colKey = colFields.map(f => r[f]).join(" | ");

                rowKeys.add(rowKey);
                colKeys.add(colKey);

                if (!matrix[rowKey])
                    matrix[rowKey] = {};

                if (!matrix[rowKey][colKey])
                    matrix[rowKey][colKey] = 0;

                let val = parseFloat(r[valueField]);
                if (!isNaN(val)) {
                    matrix[rowKey][colKey] += val;
                }
            });

            // FINAL correct structure
            return {
                rowHeaders: Array.from(rowKeys),
                colHeaders: Array.from(colKeys),
                matrix: matrix
            };
        }

        function renderPivotTable(pivotObj) {

            if (!pivotObj || !pivotObj.matrix) {
                console.error("Invalid pivot object", pivotObj);
                return;
            }

            // Create DataTable column definitions:
            // First, one column per row field (Domain, SubDomain, ...)
            const dtCols = (pivotObj.rowFields || []).map((f, idx) => ({
                data: "row_" + idx,
                title: f,
                defaultContent: ""
            }));

            // Then dynamic pivot columns (colHeaders)
            // convert colHeader keys (joined by '||') into display text with ' | '
            const colDisplayNames = pivotObj.colHeaders.map(ch => ch.split("||").join(" | "));

            pivotObj.colHeaders.forEach((colKey, i) => {
                dtCols.push({
                    data: colKey,
                    title: colDisplayNames[i],
                    defaultContent: 0
                });
            });

            // Build rows: one row object per rowKey
            const dtRows = (pivotObj.rowKeys || []).map(rowKey => {
                const rowParts = pivotObj.rowKeyParts[rowKey] || [];

                const obj = {};
                // fill row_0, row_1 ... with individual parts
                rowParts.forEach((p, idx) => obj["row_" + idx] = p);

                // fill each pivot column value or 0
                pivotObj.colHeaders.forEach(colKey => {
                    obj[colKey] = pivotObj.matrix[rowKey] && pivotObj.matrix[rowKey][colKey] ? pivotObj.matrix[rowKey][colKey] : 0;
                });

                return obj;
            });

            // destroy existing table
            if ($.fn.DataTable.isDataTable('#tblResult')) {
                $('#tblResult').DataTable().destroy();
                $('#tblResult').empty();
            }

            // Initialize DataTable
            $('#tblResult').DataTable({
                dom: "Blfrtip",
                data: dtRows,
                columns: dtCols,
                ordering: false,
                paging: true,
                lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                scrollX: true,
                autoWidth: false,
                searching: false,
                createdRow: function (row, data) {
                    // style first N row columns (row fields) lightly
                    const rowFieldCount = pivotObj.rowFields ? pivotObj.rowFields.length : 0;
                    for (let i = 0; i < rowFieldCount; i++) {
                        $('td:eq(' + i + ')', row).css({ "font-weight": "600", "background": "#fafafa" });
                    }
                },
                buttons: getReportButtons('Pivot Report')
            });

            updateReportToolSummary(dtRows.length, "Pivot");
        }


        function renderPivotTable_Existing_1(pivot) {

            if (!pivot || !pivot.matrix) {
                console.error("Invalid pivot object", pivot);
                return;
            }

            let dtCols = [];

            // First column: combined row headers
            dtCols.push({
                data: "RowHeader",
                title: pivot.rowHeaders.join(" | "),
                defaultContent: ""
            });

            // Add all dynamic pivot columns
            pivot.colHeaders.forEach(col => {
                dtCols.push({
                    data: col,
                    title: col,
                    defaultContent: "0"
                });
            });

            let dtRows = [];

            Object.keys(pivot.matrix).forEach(rowKey => {

                let rowObj = {
                    RowHeader: rowKey
                };

                pivot.colHeaders.forEach(col => {
                    rowObj[col] = (pivot.matrix[rowKey][col] ?? 0);
                });

                dtRows.push(rowObj);
            });

            // Destroy previous table
            if ($.fn.DataTable.isDataTable('#tblResult')) {
                $('#tblResult').DataTable().destroy();
                $('#tblResult').empty();
            }

            $('#tblResult').DataTable({
                dom: "Bfrtip",
                data: dtRows,
                columns: dtCols,
                ordering: false,
                paging: true,
                scrollX: true,
                autoWidth: false,
                searching: false,

                createdRow: function (row, data) {
                    // style row header
                    $("td:eq(0)", row).css({
                        "font-weight": "bold",
                        "background": "#f6f6f6",
                        "white-space": "nowrap"
                    });
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Pivot Report',
                        exportOptions: { orthogonal: "export" }
                    }
                ]
            });
        }

        function renderPivotTable_Existing(pivot) {

            let dtCols = [
                { data: "RowHeader", title: "Row", defaultContent: "" }
            ];

            pivot.colHeaders.forEach(col => {
                dtCols.push({
                    data: col,
                    title: col,
                    defaultContent: ""
                });
            });

            let dtRows = [];

            Object.keys(pivot.matrix).forEach(rowKey => {
                let rowObj = { RowHeader: rowKey };

                pivot.colHeaders.forEach(col => {
                    rowObj[col] = pivot.matrix[rowKey][col] || 0;
                });

                dtRows.push(rowObj);
            });

            // destroy previous table
            if ($.fn.DataTable.isDataTable('#tblResult')) {
                $('#tblResult').DataTable().destroy();
                $('#tblResult').empty();
            }

            $('#tblResult').DataTable({
                dom: "Bfrtip",
                data: dtRows,
                columns: dtCols,
                ordering: false,
                paging: true,
                scrollX: true,
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Pivot Report'
                    }
                ]
            });
        }

        function generatePivot() {

            //let rowField = $("#ddlRow").val();
            //let colField = $("#ddlColumn").val();
            //let valField = $("#ddlValue").val();
            let rowField = $("#ddlRow").val() || [];
            let colField = $("#ddlColumn").val() || [];
            let valField = $("#ddlValue").val();
            let aggType = $("#ddlAgg").val();

            if (rowField.length === 0 || colField.length === 0 || !valField) {
                alert("Please select Row, Column, and Value fields.");
                return false;
            }

            // Block hidden columns
            let hidden = window.UserHiddenColumns || [];
            let pivotFields = rowField.concat(colField).concat([valField]);
            if (pivotFields.some(f => hidden.includes(f))) {
                alert("Cannot generate pivot using restricted columns.");
                return false;
            }

            let pivot = buildPivotMatrix(pivotData, rowField, colField, valField, aggType);

            renderPivotTable(pivot);
            return false;
        }

        function renderTable_existing(data, groupCols) {
            if (!Array.isArray(data)) data = [];

            // ensure group columns appear first (optional)
            let selectedOrder = ($('#ddlColumns').val() || []).slice();   // array of column names in user order

            // 2) Determine all keys in data
            const keySet = new Set();
            data.forEach(row => {
                Object.keys(row || {}).forEach(k => keySet.add(k));
            });

            // 3) Build ordered list
            const orderedKeys = [];

            // (A) First = all selected columns in EXACT UI order
            selectedOrder.forEach(col => {
                if (keySet.has(col)) {
                    orderedKeys.push(col);
                    keySet.delete(col);
                }
            });

            // (B) Then = group columns (if not already included)
            if (Array.isArray(groupCols)) {
                groupCols.forEach(g => {
                    if (keySet.has(g)) {
                        orderedKeys.push(g);
                        keySet.delete(g);
                    }
                });
            }

            // (C) Finally = any remaining columns (e.g. when filters included extra fields)
            Array.from(keySet).forEach(k => orderedKeys.push(k));
            // remove internal helper keys from normal columns if you don't want them visible
            // but keep them in data (we will add them as hidden columns later)
            const visibleCols = orderedKeys.filter(k => k !== '_isSummary' && k !== '_count' && k !== '_sumSalary');

            // 2) build DataTable columns array - use defaultContent to avoid 'unknown parameter' errors
            const dtCols = visibleCols.map(k => ({ data: k, title: k, defaultContent: "" }));

            // 3) destroy previous table if present
            if (window.tableInstance && $.fn.dataTable.isDataTable('#tblResult')) {
                window.tableInstance.destroy();
                $('#tblResult').empty();
            }

            // 4) init DataTable - disable ordering so the order we built is kept
            window.tableInstance = $('#tblResult').DataTable({
                dom: "Bftip",
                data: data,
                columns: dtCols,
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
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Details Report', autoFilter: true
                    },
                ],

                createdRow: function (row, rowData, dataIndex) {
                    // style summary row
                    if (rowData && rowData._isSummary) {
                        $(row).css({ 'font-weight': 'bold', 'background': '#f0f0f0', 'text-wrap': 'nowrap' });
                        // put the summary text in the first visible cell
                        var $visibleCells = $('td', row).filter(function () {
                            // exclude hidden cells (they may be there because we've added hidden helper columns)
                            return $(this).is(':visible');
                        });
                        if ($visibleCells.length) {
                            $visibleCells.first().html(
                                'Summary: Count=' + (rowData._count || 0) + ', Sum(Salary)=' + (rowData._sumSalary || 0)
                            );
                        }
                        // hide other visible cells to make the summary row look compact
                        $visibleCells.slice(1).hide();
                    }
                    else {
                        $(row).css({ 'text-wrap': 'nowrap' });

                    }
                }
            });

            // optional: disable pointer events on headers so user doesn't try to reorder
            $('#tblResult thead th').css('pointer-events', 'none');
            //document.getElementById("pivotBtn").style.display = '';
        }

        function buildDetailsWithSummaries(details, summaries, groupCols) {
            // 1) ensure details is an array
            details = Array.isArray(details) ? details.slice() : [];

            // 2) sort details by group columns so rows for the same group are contiguous
            details.sort((a, b) => {
                for (let c of groupCols) {
                    const av = (a[c] !== undefined && a[c] !== null) ? String(a[c]) : "";
                    const bv = (b[c] !== undefined && b[c] !== null) ? String(b[c]) : "";
                    if (av < bv) return -1;
                    if (av > bv) return 1;
                }
                return 0;
            });

            // safe key function (returns empty string for missing)
            const keyFor = (row, cols) => {
                if (!row) return "";
                return cols.map(c => (row[c] !== undefined && row[c] !== null) ? String(row[c]) : "").join("||");
            };

            // 3) index summaries by group key (summary rows should contain only groupCols + aggregates)
            const summaryMap = {};
            (Array.isArray(summaries) ? summaries : []).forEach(s => {
                const k = keyFor(s, groupCols);
                summaryMap[k] = s;
            });

            // 4) group details
            const grouped = {};
            const order = [];
            details.forEach(r => {
                const k = keyFor(r, groupCols);
                if (!grouped[k]) { grouped[k] = []; order.push(k); }
                grouped[k].push(r);
            });

            // 5) combine: for each group push detail rows then a summary row (if exists)
            const combined = [];
            order.forEach(k => {
                const rows = grouped[k] || [];
                rows.forEach(rr => combined.push(rr));

                const s = summaryMap[k];
                if (s) {
                    // build summary row that contains only groupCols + summary fields and nothing else
                    const summaryRow = {};
                    // keep group columns so they display in the summary row
                    groupCols.forEach(gc => summaryRow[gc] = s[gc]);

                    // standard summary keys
                    summaryRow._isSummary = true;
                    summaryRow._count = s.GroupCount || s.Count || 0;
                    summaryRow._sumSalary = s.GroupSalarySum || s.SumSalary || s.GroupSalary || 0;

                    combined.push(summaryRow);
                }
            });

            // 6) If there were details with no group (key === ""), and there was a summary for "", they are handled above.
            return combined;
        }

        function loadReport() {
            let cols = ($('#ddlColumns').val() || []).join(',');
            let groups = [];
            // use selected group levels
            [$('#ddlGroup1').val(), $('#ddlGroup2').val(), $('#ddlGroup3').val()].forEach(g => { if (g) groups.push(g); });
            let aggColumn = $('#ddlAggColumn').val();
            let aggFunc = $('#ddlAggFunc').val();
            let filtersJson = JSON.stringify(window.SelectedFilters || []);
            $.ajax({
                url: 'DynamicReportFinal.aspx/GetReportData',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    Columns: cols,
                    //Filters: JSON.stringify(filterList),
                    Filters: filtersJson
                }),
                success: function (res) {
                    // let payload = JSON.parse(res.d);
                    let payload = JSON.parse(res.d);
                    //for pivot
                    let hidden = window.UserHiddenColumns || [];
                    let firstDetail = (payload.details && payload.details.length > 0) ? payload.details[0] : {};
                    let fields = Object.keys(firstDetail).filter(f => !hidden.includes(f));

                    resetPivotSelectors(fields);

                    //console.log("Fields in pivot:", fields);
                    // Initialize Pivot UI only once
                    const details = payload.details || [];
                    const summaries = payload.summaries || [];
                    const groupCols = payload.groupCols || [];

                    if (payload && payload.details && payload.summaries) {
                        lastResultData = buildDetailsWithSummaries(payload.details, payload.summaries, payload.groupCols);
                    } else {
                        lastResultData = payload;
                    }
                    pivotData = (payload.details || []).map(r => {
                        const clean = {};
                        let hidden = window.UserHiddenColumns || [];
                        for (const k in r) {

                            // ignore internal helper fields + hidden columns
                            if (k.startsWith("_")) continue;
                            if (hidden.includes(k)) continue;

                            clean[k] = r[k];
                        }
                        return clean;
                    });
                    renderTable(lastResultData, groupCols);
                    //initializePivot();
                },
                error: function (err) { console.error(err); alert('Error generating report'); }
            });

            return false;
        }

        function saveFilterTemplate() {
            $("#saveTemplateModal").modal("show");
            return false;
        }

        function saveTemplateToServer() {

            let filters = collectFiltersFromPopup();

            if (!filters || filters.length === 0) {
                alert("Please select filters before saving template.");
                return false;
            }

            let pivotLayout = {
                Rows: $("#ddlRow").val() || [],
                Columns: $("#ddlColumn").val() || [],
                Value: $("#ddlValue").val() || null
            };

            let tempName = prompt("Enter Template Name:");
            if (!tempName) {
                alert("Template name is required.");
                return false;
            }

            $.ajax({
                url: "DynamicReportFinal.aspx/SaveTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateID: 0,          // ALWAYS 0 = NEW TEMPLATE
                    TemplateName: tempName,
                    FiltersJson: JSON.stringify(filters),
                    PivotJson: JSON.stringify(pivotLayout)
                }),
                success: function () {
                    alert("Template saved!");
                    $("#filterModal").modal("hide");
                    loadTemplatesTable();
                    loadTemplatesDropdown();
                }
            });

            return false;
        }

        function saveTemplateToServer_existing() {
            // ALWAYS read latest filters from popup
            let filters = collectFiltersFromPopup();

            if (!filters || filters.length === 0) {
                alert("Please select filters before saving template.");
                return false;
            }

            let tempName = window.tempTemplateName;
            if (!tempName) {
                alert("Template name is missing!");
                return false;
            }

            $.ajax({
                url: "DynamicReportFinal.aspx/SaveTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateID: selectedTemplateId,
                    TemplateName: tempName,
                    FiltersJson: JSON.stringify(filters)
                }),
                success: function (res) {
                    alert("Template saved successfully!");
                    $("#filterModal").modal("hide");
                    loadTemplatesTable();
                    loadTemplatesDropdown();
                }
            });

            return false;
        }

        function collectFiltersFromPopup() {
            let filters = [];

            $("#filterTable tbody tr").each(function () {

                if ($(this).find(".f-select").is(":checked")) {

                    filters.push({
                        Column: $(this).find(".f-col").text().trim(),
                        Operator: $(this).find(".f-op").val(),
                        Value1: $(this).find(".f-val1").val(),
                        Value2: $(this).find(".f-val2").val()
                    });
                }
            });

            return filters;
        }

        function loadFiltersIntoGrid(filters) {
            $("#filterTable tbody tr").each(function () {
                let row = $(this);
                let column = row.find(".f-col").text();

                let match = filters.find(f => f.Column === column);
                if (match) {
                    row.find(".f-select").prop("checked", true);
                    row.find(".f-op").val(match.Operator);
                    row.find(".f-val1").val(match.Value1);
                    row.find(".f-val2").val(match.Value2).show();
                }
            });
            return false;
        }

        function loadTemplatesDropdown() {

            $.ajax({
                url: "DynamicReportFinal.aspx/GetTemplates",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res) {

                    let templates = JSON.parse(res.d);
                    let html = "";

                    templates.forEach(t => {
                        html += `
                    <div class="dropdown-item d-flex justify-content-between align-items-center">
                        
                        <span style="cursor:pointer;">&nbsp;&nbsp;
                            📄 ${t.TemplateName}
                        </span>
&nbsp;&nbsp;
                        <span>
                            <i class="fa fa-share text-info mr-2" style="cursor:pointer"
                                onclick="shareTemplateFromList(${t.TemplateID}, '${t.TemplateName}')"></i>

                            <i class="fa fa-edit text-success mr-2" style="cursor:pointer"
                               onclick="editTemplate(${t.TemplateID}, '${t.TemplateName}')"></i>

                            <i class="fa fa-trash text-danger" style="cursor:pointer"
                               onclick="deleteTemplate(${t.TemplateID})"></i>
                        </span>

                    </div>`;
                    });

                    $("#templateList").html(html);
                }
            });
        }

        function loadTemplate(id, name) {

            $("#templateDropdownBtn").text(name);

            $.ajax({
                url: "DynamicReportFinal.aspx/GetTemplateData",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function (res) {

                    let t = JSON.parse(res.d);

                    // -----------------------------
                    // 1. Load FILTERS
                    // -----------------------------
                    window.SelectedFilters = t.Filters || [];

                    // -----------------------------
                    // 2. Load PIVOT SETTINGS
                    // -----------------------------
                    if (t.Pivot) {
                        $("#ddlRow").val(t.Pivot.Rows || []).trigger("change");
                        $("#ddlColumn").val(t.Pivot.Columns || []).trigger("change");
                        $("#ddlValue").val(t.Pivot.Value || "").trigger("change");
                    }

                    // -----------------------------
                    // 3. Load HIDDEN COLUMNS
                    // -----------------------------
                    window.HiddenColumns = t.HiddenColumns || [];

                    // -----------------------------
                    // 4. LOAD REPORT NOW
                    // -----------------------------
                    loadReport();
                }
            });

            // -----------------------------
            // 5. Update "Last Accessed"
            // -----------------------------
            $.ajax({
                url: "DynamicReportFinal.aspx/UpdateTemplateLastAccessed",
                method: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: id })
            });

        }


        function loadTemplate_existing(id, name) {
            $("#templateDropdownBtn").text(name);

            $.ajax({
                url: "DynamicReportFinal.aspx/GetTemplateData",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function (res) {

                    let filters = JSON.parse(res.d);

                    $("#filterModal").modal("show");

                    $.ajax({
                        url: "DynamicReportFinal.aspx/GetFiltersList",
                        method: "POST",
                        contentType: "application/json; charset=utf-8",
                        success: function (res2) {
                            let cols = JSON.parse(res2.d);

                            buildFilterGrid(cols);
                            loadFiltersIntoGrid(filters);
                        }
                    });
                }
            });

            $.ajax({
                url: "DynamicReportFinal.aspx/UpdateTemplateLastAccessed",
                method: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: id })
            });
        }

        function collectFiltersFromUI() {
            let filters = [];

            $("#filterTable tbody tr").each(function () {
                let $row = $(this);
                if (!$row.find(".f-select").is(":checked")) return;

                let col = $row.find(".f-col").text().trim();
                let op = $row.find(".f-op").val();
                let v1 = $row.find(".f-val1").val();
                let v2 = $row.find(".f-val2").val();

                filters.push({
                    Column: col,
                    Operator: op,
                    Value1: v1,
                    Value2: v2
                });
            });

            // store globally if other parts expect window.SelectedFilters
            window.SelectedFilters = filters;
            return filters;
        }

        function editTemplate(templateID, templateName) {
            // mark editing state
            window.EditingTemplateID = templateID;
            window.EditingTemplateName = templateName || "";

            // show filter modal first
            $("#filterModal").modal("show");

            // show update button in filter modal
            $(".btn-primary[onclick*='saveTemplateToServer']").addClass("d-none");
            $("#btnUpdateTemplateFilter").removeClass("d-none");

            // load all columns into grid, then load template values
            $.ajax({
                url: "DynamicReportFinal.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res1) {
                    let cols = JSON.parse(res1.d);
                    buildFilterGrid(cols);

                    // now load the template JSON and fill grid
                    $.ajax({
                        url: "DynamicReportFinal.aspx/GetTemplateData",
                        method: "POST",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ TemplateID: templateID }),
                        success: function (res2) {
                            // res2.d expected to be FiltersJson (stringified array)
                            let filters = JSON.parse(res2.d);
                            window.SelectedFilters = filters;
                            loadFiltersIntoGrid(filters);

                            // ensure operator change handlers applied
                            $("#filterTable").find(".f-op").trigger("change");
                        },
                        error: function (e) {
                            console.error("GetTemplateData error:", e);
                        }
                    });
                },
                error: function (e) {
                    console.error("GetFiltersList error:", e);
                }
            });

            $.ajax({
                url: "DynamicReportFinal.aspx/UpdateTemplateLastAccessed",
                method: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: templateID })
            });
        }

        function createNewTemplate() {

            // Clear any template currently selected
            selectedTemplateId = 0;

            // Reset fields
            $("#templateName").val("");
            $(".btn-primary[onclick*='saveTemplateToServer']").removeClass("d-none");
            $("#btnUpdateTemplateFilter").addClass("d-none");
            // $("#templateError").text("");

            // Show popup for entering template name
            $("#saveTemplateModal").modal("show");

            return false;  // Prevent default link action
        }

        function deleteTemplate(id) {

            if (!confirm("Delete this template permanently?")) return;

            $.ajax({
                url: "DynamicReportFinal.aspx/DeleteTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function () {

                    alert("Template deleted.");

                    loadTemplatesDropdown();
                }
            });
        }

        function onTemplateSelected(sel) {
            let id = $(sel).val();
            if (!id) return;

            $("#filterModal").modal("show");

            // 1) Load all filter columns first
            $.ajax({
                url: "DynamicReportFinal.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res1) {

                    let allColumns = JSON.parse(res1.d);
                    buildFilterGrid(allColumns);   // build full grid

                    // 2) Now load template data
                    $.ajax({
                        url: "DynamicReportFinal.aspx/GetTemplateData",
                        method: "POST",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ TemplateID: id }),
                        success: function (res2) {

                            let filters = JSON.parse(res2.d);
                            window.SelectedFilters = filters;

                            // 3) Fill template data into built grid
                            loadFiltersIntoGrid(filters);
                        }
                    });

                }
            });
        }

        function onUpdateTemplateClicked() {

            let id = window.EditingTemplateID;
            if (!id) {
                alert("No template selected for update.");
                return;
            }

            // collect current filters from the UI
            let filters = collectFiltersFromUI();

            // optionally let user change template name inline (or keep existing)
            // we'll use existing name if not changed
            let templateName = window.EditingTemplateName || $("#templateName").val() || "";

            // confirm action (optional)
            if (!confirm("Update template '" + templateName + "' with current filters?")) return;

            // call server
            $.ajax({
                url: "DynamicReportFinal.aspx/UpdateTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateID: id,
                    TemplateName: templateName,
                    FiltersJson: JSON.stringify(filters)
                }),
                success: function (res) {
                    // server returns "OK" or similar
                    alert("Template updated successfully.");
                    $("#filterModal").modal("hide");

                    // hide update button again (reset UI)
                    $("#btnUpdateTemplateFilter").addClass("d-none");

                    // refresh dropdown/menu
                    loadTemplatesDropdown();

                    // clear editing state
                    window.EditingTemplateID = null;
                    window.EditingTemplateName = null;
                },
                error: function (err) {
                    console.error("UpdateTemplate error:", err);
                    alert("Failed to update template. See console.");
                }
            });
        }

        function openUpdateTemplatePopup() {
            $("#templateName").val(
                $("#templateDropdownBtn").text()
            );

            $("#btnSaveNewTemplate").addClass("d-none");
            $("#btnUpdateTemplate").removeClass("d-none");

            $("#saveTemplateModal").modal("show");
            return false;
        }

        function loadTemplatesTable() {

            $.ajax({
                url: "DynamicReportFinal.aspx/GetAllTemplates",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    let data = JSON.parse(res.d);
                    $("#templateMasterTable").DataTable({
                        destroy: true,
                        data: data,
                        columns: [
                            { data: "TemplateName" },
                            { data: "CreatedBy", title: "Requested By", defaultContent: "-" },
                            {
                                data: "CreatedOn",
                                render: d => formatDate(d)
                            },
                            { data: "LastAccessedBy", title: "Last Accessed By", defaultContent: "-" },
                            {
                                data: "LastAccessedOn",
                                render: function (d) {
                                    return formatDate(d);
                                }
                            },

                            {
                                data: "TemplateID",
                                title: "View/Download",
                                orderable: false,
                                render: function (id) {
                                    return `
                                        <button type="button" class="btn btn-sm btn-info"
                                                onclick="return showSavedReport(${id});">
                                            <i class="fa fa-eye"></i> 
                                        </button>

                                        <button type="button" class="btn btn-sm btn-success"
                                                onclick="return downloadTemplateData(${id});">
                                            <i class="fa fa-file-excel"></i> 
                                        </button>`;
                                }
                            }
                        ],
                        order: [[1, "desc"]],
                        pageLength: 10
                    });
                }
            });
        }

        function formatDate(d) {
            if (!d || d === "null" || d === null || d === "" || d === "undefined")
                return "-";

            // Handle JSON date: /Date(…)/ 
            if (typeof d === "string" && d.includes("/Date")) {

                let ticks = parseInt(d.replace(/[^0-9-]/g, ""));

                // NULL indicators in .NET JSON
                if (isNaN(ticks) || ticks <= 0) return "-";   // /Date(0)/ or negative /Date(-xxx)/

                let date = new Date(ticks);

                // Block invalid default dates
                if (date.getFullYear() < 1950 || date.getFullYear() > 2030)
                    return "-";

                return date.toLocaleDateString("en-IN") + " " + date.toLocaleTimeString("en-IN");
            }

            // Normalize SQL datetime formats
            let s = d.toString().replace("T", " ").replace(/\.\d+/, "").trim();
            let date = new Date(s);

            // Invalid → return "-"
            if (isNaN(date.getTime())) return "-";

            // Block all out-of-range values
            if (date.getFullYear() < 1950 || date.getFullYear() > 2030)
                return "-";

            return date.toLocaleDateString("en-IN") + " " + date.toLocaleTimeString("en-IN");
        }

        function downloadTemplateData(id) {
            $("#waitingpanel").modal("show");
            $("#spntext").text("Generating excel sheet : Saved Report");
            $.ajax({
                url: "DynamicReportFinal.aspx/DownloadTemplateActualData",
                type: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function (res) {
                    if (res.d) {
                        $("#waitingpanel").modal("hide");
                        window.location = res.d;
                    } else {
                        alert("No data found for this template.");
                    }
                },
                error: function (err) {
                    $("#waitingpanel").modal("hide");
                    alert(err.responseText || "Error downloading template report.");
                }
            });
            return false;
        }

        function proceedToFilters() {

            let name = $("#templateName").val().trim();
            if (!name) {
                alert("Enter a template name");
                return false;
            }

            // Store temporarily
            window.tempTemplateName = name;

            // Close name popup
            $("#saveTemplateModal").modal("hide");

            // Open FILTER popup NOW
            //$("#filterModal").modal("show");
            openFilterPopup();

            return false;
        }

        function showSavedReport(templateID) {

            // 1️⃣ Get saved filter JSON from server
            $.ajax({
                url: "DynamicReportFinal.aspx/GetTemplateData",
                type: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: templateID }),
                success: function (res) {

                    let filters = JSON.parse(res.d);

                    // Save globally for report use
                    window.SelectedFilters = filters;

                    // 2️⃣ Directly load report using saved filters
                    $.ajax({
                        url: "DynamicReportFinal.aspx/GetHiddenColumns",
                        type: "POST",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify({ TemplateID: templateID }),
                        success: function (res) {
                            window.UserHiddenColumns = JSON.parse(res.d) || [];
                            loadReport();
                        }
                    });

                },
                error: function (err) {
                    console.error(err);
                    alert("Failed to load template filters.");
                }
            });

            return false;
        }

        function openAdvancedFilter() {

            // Not editing a template
            window.EditingTemplateID = null;
            window.EditingTemplateName = null;

            // Show Save Template button
            $("#btnUpdateTemplateFilter").addClass("d-none");
            $(".btn-primary[onclick*='saveTemplateToServer']").removeClass("d-none");

            // Open filter popup
            $("#filterModal").modal("show");

            // Load all filter rows
            $.ajax({
                url: "DynamicReportFinal.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    let list = JSON.parse(result.d);
                    buildFilterGrid(list);
                }
            });

            return false;
        }

        function openShareTemplatePopup() {
            if (!window.EditingTemplateID) {
                alert("Save the template first before sharing.");
                return false;
            }

            SharingTemplateID = window.EditingTemplateID;

            loadUsersForSharing();
            loadColumnsForHiding();
            $("#shareTemplateModal").modal("show");
            return false;
        }

        function shareTemplateFromList(id, name) {
            SharingTemplateID = id;

            loadUsersForSharing();
            loadColumnsForHiding();
            $("#shareTemplateModal").modal("show");
        }

        function loadUsersForSharing() {
            $.ajax({
                url: "DynamicReportFinal.aspx/GetAllUsers",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    let users = JSON.parse(res.d);
                    let html = "";
                    users.forEach(u => {
                        html += `<option value="${u.Code}">${u.FullName}</option>`;
                    });

                    $("#ddlShareUsers").html(html).select2();
                }
            });
        }

        function shareTemplateToUsers() {
            let selectedUsers = $("#ddlShareUsers").val();
            let hiddenCols = $("#ddlHiddenColumns").val() || [];

            if (!selectedUsers || selectedUsers.length === 0) {
                alert("Select at least one user.");
                return false;
            }

            $.ajax({
                url: "DynamicReportFinal.aspx/ShareTemplateToUsers",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateID: SharingTemplateID,
                    UserIDs: selectedUsers,
                    HiddenColumns: hiddenCols
                }),
                success: function () {
                    alert("Template shared successfully!");
                    $("#shareTemplateModal").modal("hide");
                }
            });

            return false;
        }


        function loadColumnsForHiding() {
            $.ajax({
                url: "DynamicReportFinal.aspx/GetFiltersList",
                type: "POST",
                contentType: "application/json;charset=utf-8",
                success: function (res) {
                    let cols = JSON.parse(res.d);
                    let html = "";

                    cols.forEach(c => {
                        let col = c.ColumnName || c.COLNAME;
                        html += `<option value="${col}">${col}</option>`;
                    });

                    $("#ddlHiddenColumns").html(html).select2();
                }
            });
        }




    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Dynamic Report Builder</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table1">
                    <tr>
                        <td style="width: 150px; display: none;"><b>Column List:</b></td>
                        <td style="width: 250px; display: none;">
                            <select id="ddlColumns" class="form-control" multiple="multiple"></select>
                        </td>
                        <td style="width: 350px; display: none;">
                            <button class="btn btn-primary" onclick="return openFilterPopup();">
                                <i class="fa fa-filter"></i>Filters
                            </button>

                            &nbsp;
                            <button class="btn btn-warning" onclick="return saveFilterTemplate();">Save as Template</button>
                        </td>
                        <td>
                            <div class="dropdown">
                                <b>Report Templates:</b>&nbsp;   
                                <button class="form-control btn-outline-primary dropdown-toggle" type="button" style="display: inline!important; height: 28px!important"
                                    id="templateDropdownBtn" data-toggle="dropdown">
                                    Choose Report Template
                                </button>

                                <div class="dropdown-menu" id="templateDropdownMenu" aria-labelledby="templateDropdownBtn" style="width: 100%; border-radius: 10px;">
                                    <div id="templateList"></div>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item text-info" href="#" onclick="return createNewTemplate();">➕ Create New Template
                                    </a>
                                </div>
                            </div>
                        </td>
                        <td><b>Advanced Filters:</b>&nbsp; 
                            <button class="form-control btn-primary" onclick="return openAdvancedFilter();" style="display: inline!important; height: 28px;">
                                <i class="fa fa-sliders-h"></i>Choose Filters
                            </button>
                        </td>

                    </tr>
                </table>
                <div class="report-tools mt-3">
                    <button type="button" class="btn btn-sm btn-primary" onclick="return loadReport();">
                        <i class="fa fa-sync-alt"></i> Refresh
                    </button>
                    <button type="button" class="btn btn-sm btn-success" onclick="return downloadCurrentReport();">
                        <i class="fa fa-file-excel"></i> Export Current Report
                    </button>
                    <button type="button" class="btn btn-sm btn-secondary" onclick="return clearReportFilters();">
                        <i class="fa fa-eraser"></i> Clear Filters
                    </button>
                    <span id="reportToolSummary" class="report-tool-summary">Rows: 0 | Mode: Details</span>
                </div>
                <hr />
                <table id="templateMasterTable" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Report Name</th>
                            <th>Created By</th>
                            <th>Created On</th>
                            <th>Last Accessed By</th>
                            <th>Last Accessed On</th>
                            <th>View/Download</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <hr />
                <div class="card p-3 mb-3 border">

                    <h6><b>Pivot Options</b></h6>

                    <div class="row">
                        <div class="col-md-3">
                            <label>Row Field</label>
                            <select id="ddlRow" class="form-control" multiple="multiple"></select>
                        </div>

                        <div class="col-md-3">
                            <label>Column Field</label>
                            <select id="ddlColumn" class="form-control" multiple="multiple"></select>
                        </div>

                        <div class="col-md-3">
                            <label>Value Field</label>
                            <select id="ddlValue" class="form-control"></select>
                        </div>

                        <div class="col-md-3">
                            <label>Aggregation</label>
                            <select id="ddlAgg" class="form-control">
                                <option value="SUM">SUM</option>
                                <option value="COUNT">COUNT</option>
                            </select>
                        </div>
                    </div>

                    <button class="btn btn-primary mt-3" onclick="return generatePivot();">Generate Pivot</button>

                </div>
                <hr />
                <table id="tblResult" class="table table-bordered" style="width: 100%"></table>
            </div>
        </div>
    </div>
    <div class="modal" id="saveTemplateModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header bg-warning">
                    <h5 class="modal-title">Save Filter Template</h5>
                    <button class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <input type="text" id="templateName" class="form-control"
                        placeholder="Template Name">
                </div>

                <div class="modal-footer">
                    <button class="btn btn-success" onclick="return proceedToFilters();">Save</button>
                </div>

            </div>
        </div>
    </div>



    <div class="modal fade" id="filterModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">

                <div class="modal-header text-white" style="background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;">
                    <h5 class="modal-title" style="padding-left: 50px;">Select Filters</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <table class="table table-bordered table-sm" id="filterTable">
                        <thead class="table-dark" style="background-color: lightslategray!important;">
                            <tr>
                                <th>Select</th>
                                <th>Column</th>
                                <th>Operator</th>
                                <th>Value 1</th>
                                <th>Value 2</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary" onclick="return saveTemplateToServer();"><i class="fa fa-save"></i>Save Template</button>
                    <button class="btn btn-warning d-none" id="btnUpdateTemplateFilter" onclick="onUpdateTemplateClicked()"><i class="fa fa-save"></i>Update Template</button>
                    <button class="btn btn-success" onclick="return applyAllFilters();">Apply Filters</button>
                    <button class="btn btn-secondary" data-dismiss="modal">Close</button>

                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is generating excel. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="shareTemplateModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">Share Template</h5>
                    <button class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <label>Select Users to Share</label>
                    <select id="ddlShareUsers" class="form-control" multiple></select>

                    <hr />

                    <label><b>Select Columns to Hide for Shared Users</b></label>
                    <select id="ddlHiddenColumns" class="form-control" multiple>
                    </select>
                </div>


                <div class="modal-footer">
                    <button class="btn btn-info" onclick="return shareTemplateToUsers();">
                        <i class="fa fa-share"></i>Share
                    </button>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
