<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DynamicReport.aspx.cs" Inherits="WebPortal.Admin.DynamicReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.6.2/css/bootstrap.min.css" />
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.6.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/css/bootstrap-multiselect.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pivottable/2.23.0/pivot.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pivottable/2.23.0/export_renderers.min.js"></script>
    <style>
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

        .buttons-excel {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
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

        .btn-group {
            width: 205px !important;
        }

        #pivotContainer {
            overflow: hidden; /* Disable scrolling */
            width: 100%; /* Ensure the container takes full available width */
            max-width: 100%; /* Ensure container width is always 100% of the screen */
            padding: 10px;
            box-sizing: border-box;
            margin-bottom: 20px;
            height: auto; /* Make it dynamic height */
        }

        /* Allow table to resize */
        .pvtTable {
            width: auto !important;
            max-width: none !important;
            overflow-x: scroll !important;
            display: block !important;
        }

            .pvtTable th, .pvtTable td {
                word-wrap: break-word; /* Allow word wrapping */
                max-width: 150px; /* Set max width for readability */
                text-align: center;
                padding: 8px;
                white-space: normal; /* Make sure text can wrap within cells */
            }

            .pvtTable th {
                background-color: #f1f1f1;
                font-weight: bold;
            }
    </style>
    <script>
        let masterColumns = [];
        let filterList = [];
        let tableInstance = null;
        let lastResultData = [];
        var pivotData = [];
        var pivotOptions = {
            rows: [],
            cols: [],
            vals: [],
            aggregatorName: "Count"
        };


        // Generate pivot from dropdown selections
        $(document).on("click", "#pivotBtn", function () {
            document.getElementById("pivotContainer").style.display = "";

            let renderers = $.extend(
                {},
                $.pivotUtilities.renderers,
                $.pivotUtilities.export_renderers
            );

            pivotOptions.rows = $("#ddlRow").val() ? [$("#ddlRow").val()] : [];
            pivotOptions.cols = $("#ddlColumn").val() ? [$("#ddlColumn").val()] : [];
            pivotOptions.vals = $("#ddlValue").val() ? [$("#ddlValue").val()] : [];
            pivotOptions.aggregatorName = $("#ddlAggregator").val();
            pivotOptions.renderers = renderers;

            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
            document.getElementById("exportBtn").style.display = "";

        });

        function exportPivotToExcel() {
            var table = $("#pivotContainer table.pvtTable");

            if (table.length === 0) {
                alert("No Pivot Table Found!");
                return;
            }

            var uri = "data:application/vnd.ms-excel;base64,";
            var template = `
        <html xmlns:o="urn:schemas-microsoft-com:office:office"
              xmlns:x="urn:schemas-microsoft-com:office:excel"
              xmlns="http://www.w3.org/TR/REC-html40">
        <head><meta charset="UTF-8"></head>
        <body>${table.prop("outerHTML")}</body>
        </html>`;

            var base64 = s => window.btoa(unescape(encodeURIComponent(s)));

            var downloadLink = document.createElement("a");
            downloadLink.href = uri + base64(template);
            downloadLink.download = "DynamicReport.xls";

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        }


        $(document).ready(function () {
            $.ajax({
                url: 'DynamicReport.aspx/GetColumnsList',
                type: 'POST',
                contentType: 'application/json',
                success: function (res) {
                    let cols = JSON.parse(res.d);
                    masterColumns = cols;

                    $('#ddlGroup1').append(`<option value="">-- Select --</option>`);
                    $('#ddlGroup2').append(`<option value="">-- Select --</option>`);
                    $('#ddlGroup3').append(`<option value="">-- Select --</option>`);
                    $('#ddlAggColumn').append(`<option value="">-- Select --</option>`);

                    cols.forEach(function (c) {
                        $('#ddlColumns').append(`<option value="${c.ColumnName}">${c.Label}</option>`);
                        // populate group level selects
                        $('#ddlGroup1').append(`<option value="${c.ColumnName}">${c.Label}</option>`);
                        $('#ddlGroup2').append(`<option value="${c.ColumnName}">${c.Label}</option>`);
                        $('#ddlGroup3').append(`<option value="${c.ColumnName}">${c.Label}</option>`);
                        $('#filterColumn').append(`<option value="${c.ColumnName}">${c.Label}</option>`);

                        if (c.IsNumeric) {

                            $('#ddlAggColumn').append(`<option value="${c.ColumnName}">${c.Label}</option>`);
                        }
                    });

                    $('#ddlColumns').multiselect({
                        includeSelectAllOption: true,
                        enableFiltering: true,
                        buttonWidth: '220px',
                        maxHeight: 300
                    });
                }
            });
        });

        $(document).on("change", "#filterOperator", function () {
            if ($(this).val() === "BETWEEN") $('#filterValue2Wrapper').show();
            else $('#filterValue2Wrapper').hide();
        });

        $(document).on("click", "#addFilterBtn", function () {
            let col = $('#filterColumn').val();
            let op = $('#filterOperator').val();
            let v1 = $('#filterValue').val();
            let v2 = $('#filterValue2').val();

            if (!col || !op || !v1) { alert('Missing filter input'); return; }

            filterList.push({ Column: col, Operator: op, Value1: v1, Value2: v2 });
            renderFilterList();
        });

        function renderFilterList() {
            $('#activeFiltersList').empty();
            filterList.forEach((f, i) => {
                let txt = (f.Operator === 'BETWEEN') ?
                    `${f.Column} BETWEEN ${f.Value1} AND ${f.Value2}` :
                    `${f.Column} ${f.Operator} ${f.Value1}`;

                $('#activeFiltersList').append(
                    `<li>${txt} <button type='button' class='btn btn-danger btn-sm' onclick='removeFilter(${i})'>x</button></li>`
                );
            });
        }

        function removeFilter(i) {
            filterList.splice(i, 1);
            renderFilterList();
        }

        $(document).on("click", "#generateBtn", function () {
            let cols = ($('#ddlColumns').val() || []).join(',');
            let groups = [];
            // use selected group levels
            [$('#ddlGroup1').val(), $('#ddlGroup2').val(), $('#ddlGroup3').val()].forEach(g => { if (g) groups.push(g); });
            let aggColumn = $('#ddlAggColumn').val();
            let aggFunc = $('#ddlAggFunc').val();
            let filtersJson = JSON.stringify(window.SelectedFilters || []);
            $.ajax({
                url: 'DynamicReport.aspx/GetReportData',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    Columns: cols,
                    //Filters: JSON.stringify(filterList),
                    Filters: filtersJson,
                    GroupBy: groups.join(','),
                    AggregateColumn: aggColumn,
                    AggregateFunc: aggFunc,
                    GroupLevels: groups,
                    Summaries: ['COUNT', 'SUM']
                }),
                success: function (res) {
                    // let payload = JSON.parse(res.d);
                    let payload = JSON.parse(res.d);
                    //for pivot
                    let fields = Object.keys(payload.details[0]);
                    fields.forEach(f => {
                        $("#ddlRow").append(`<option value="${f}">${f}</option>`);
                        $("#ddlColumn").append(`<option value="${f}">${f}</option>`);
                        $("#ddlValue").append(`<option value="${f}">${f}</option>`);
                    });

                    // Initialize Pivot UI only once
                    const details = payload.details || [];
                    const summaries = payload.summaries || [];
                    const groupCols = payload.groupCols || [];

                    if (payload && payload.details && payload.summaries) {
                        lastResultData = buildDetailsWithSummaries(payload.details, payload.summaries, payload.groupCols);
                    } else {
                        lastResultData = payload;
                    }
                    pivotData = payload.details.map(r => {
                        const clean = {};
                        for (const k in r) {
                            if (r[k] !== null && r[k] !== undefined &&
                                !k.startsWith("_"))  // remove _isSummary, _count, etc
                            {
                                clean[k] = r[k];
                            }
                        }
                        return clean;
                    });
                    renderTable(lastResultData, groupCols);
                    //initializePivot();
                },
                error: function (err) { console.error(err); alert('Error generating report'); }
            });
        });

        function initializePivot() {
            $("#pivotContainer").pivotUI(pivotData, pivotOptions, true);
        }

        // buildDetailsWithSummaries(details, summaries, groupCols)
        // - details: array of employee rows (objects)
        // - summaries: array of aggregated rows (objects)
        // - groupCols: array of column names used for grouping (e.g. ['ReportingManager'])
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

        // renderTable(data, groupCols)
        // - data: combined array returned by buildDetailsWithSummaries
        // - groupCols: array of group column names, optional (used to order columns)
        function renderTable(data, groupCols) {
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

            // add hidden helper columns (useful for rowCallback)
            dtCols.push({ data: '_isSummary', title: '_isSummary', visible: false, defaultContent: "" });
            dtCols.push({ data: '_count', title: 'Count', visible: false, defaultContent: "" });
            dtCols.push({ data: '_sumSalary', title: 'Sum(Salary)', visible: false, defaultContent: "" });

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






    </script>
    <script>
        const dateColumns = [
            "Joining_Date",
            "Resignation_Date",
            "Last_Working_Date",
            "Latest_Login_Date"
        ];
        var selectedTemplateId = 0;
        function openFilterPopup() {
            window.EditingTemplateID = null;
            window.EditingTemplateName = null;

            // Hide Update button (because not editing)
            $("#btnUpdateTemplateFilter").addClass("d-none");

            // Show filter modal
            $("#filterModal").modal("show");
            $("#filterModal").modal("show");

            $.ajax({
                url: "DynamicReport.aspx/GetFiltersList",
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
                                <option value="LIKE">LIKE</option>
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

        function loadReport() {
            let cols = ($('#ddlColumns').val() || []).join(',');
            let groups = [];
            // use selected group levels
            [$('#ddlGroup1').val(), $('#ddlGroup2').val(), $('#ddlGroup3').val()].forEach(g => { if (g) groups.push(g); });
            let aggColumn = $('#ddlAggColumn').val();
            let aggFunc = $('#ddlAggFunc').val();
            let filtersJson = JSON.stringify(window.SelectedFilters || []);
            $.ajax({
                url: 'DynamicReport.aspx/GetReportData',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    Columns: cols,
                    //Filters: JSON.stringify(filterList),
                    Filters: filtersJson,
                    GroupBy: groups.join(','),
                    AggregateColumn: aggColumn,
                    AggregateFunc: aggFunc,
                    GroupLevels: groups,
                    Summaries: ['COUNT', 'SUM']
                }),
                success: function (res) {
                    // let payload = JSON.parse(res.d);
                    let payload = JSON.parse(res.d);
                    //for pivot
                    let fields = Object.keys(payload.details[0]);
                    fields.forEach(f => {
                        $("#ddlRow").append(`<option value="${f}">${f}</option>`);
                        $("#ddlColumn").append(`<option value="${f}">${f}</option>`);
                        $("#ddlValue").append(`<option value="${f}">${f}</option>`);
                    });

                    // Initialize Pivot UI only once
                    const details = payload.details || [];
                    const summaries = payload.summaries || [];
                    const groupCols = payload.groupCols || [];

                    if (payload && payload.details && payload.summaries) {
                        lastResultData = buildDetailsWithSummaries(payload.details, payload.summaries, payload.groupCols);
                    } else {
                        lastResultData = payload;
                    }
                    pivotData = payload.details.map(r => {
                        const clean = {};
                        for (const k in r) {
                            if (r[k] !== null && r[k] !== undefined &&
                                !k.startsWith("_"))  // remove _isSummary, _count, etc
                            {
                                clean[k] = r[k];
                            }
                        }
                        return clean;
                    });
                    renderTable(lastResultData, groupCols);
                    //initializePivot();
                },
                error: function (err) { console.error(err); alert('Error generating report'); }
            });
        }

        function saveFilterTemplate() {
            $("#saveTemplateModal").modal("show");
            return false;
        }
        function saveTemplateToServer() {

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
                url: "DynamicReport.aspx/SaveTemplate",
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
                    loadAllTemplates();
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


        function saveTemplateToServer4() {

            let filters = window.SelectedFilters || [];
            let tempName = window.tempTemplateName;

            if (!tempName) {
                alert("Template name missing!");
                return false;
            }

            $.ajax({
                url: "DynamicReport.aspx/SaveTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateID: selectedTemplateId,
                    TemplateName: tempName,
                    FiltersJson: JSON.stringify(filters)
                }),
                success: function () {
                    alert("Template saved!");
                    $("#filterPopupModal").modal("hide");
                    loadAllTemplates();
                }
            });

            return false;
        }


        function saveTemplateToServer3() {

            let filters = window.SelectedFilters || [];

            let tempName = $("#templateName").val().trim();
            if (!tempName) {
                alert("Enter a template name");
                return false;
            }

            let payload = {
                TemplateID: selectedTemplateId,            // NEW or EDIT
                TemplateName: tempName,
                FiltersJson: JSON.stringify(filters)
            };

            $.ajax({
                url: "DynamicReport.aspx/SaveTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(payload),
                success: function (res) {

                    // Response from server
                    let savedId = res.d;

                    alert("Template saved successfully!");

                    // Close popup
                    $("#saveTemplateModal").modal("hide");

                    // Reset selected template
                    selectedTemplateId = 0;

                    // Reload template list
                    loadAllTemplates();
                },
                error: function (err) {
                    console.error(err);
                    alert("Error saving template");
                }
            });

            return false;
        }


        function saveTemplateToServer1() {

            let filters = window.SelectedFilters || [];

            let tempName = $("#templateName").val().trim();
            if (!tempName) {
                alert("Enter a template name");
                return;
            }

            $.ajax({
                url: "DynamicReport.aspx/SaveTemplate",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TemplateName: tempName,
                    FiltersJson: JSON.stringify(filters)
                }),
                success: function () {
                    alert("Template saved!");
                    $("#saveTemplateModal").modal("hide");
                }
            });
            return false;
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
        $(document).ready(function () {
            loadTemplatesDropdown();
            loadTemplatesTable();
        });
        function loadTemplatesDropdown() {

            $.ajax({
                url: "DynamicReport.aspx/GetTemplates",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res) {

                    let templates = JSON.parse(res.d);
                    let html = "";

                    templates.forEach(t => {
                        html += `
                    <div class="dropdown-item d-flex justify-content-between align-items-center">
                        
                        <span onclick="loadTemplate(${t.TemplateID}, '${t.TemplateName}')"
                              style="cursor:pointer;">&nbsp;&nbsp;
                            📄 ${t.TemplateName}
                        </span>
&nbsp;&nbsp;
                        <span>
                            <i class="fa fa-edit text-warning mr-2" style="cursor:pointer"
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
                url: "DynamicReport.aspx/GetTemplateData",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function (res) {

                    let filters = JSON.parse(res.d);

                    $("#filterModal").modal("show");

                    $.ajax({
                        url: "DynamicReport.aspx/GetFiltersList",
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
                url: "DynamicReport.aspx/UpdateTemplateLastAccessed",
                method: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: templateID })
            });
        }
        //function editTemplate(id, name) {
        //    window.EditingTemplateID = id;
        //    $("#templateName").val(name);
        // /*   $("#saveTemplateModal").modal("show");*/
        //    $("#btnSaveNewTemplate").addClass("d-none");
        //    $("#btnUpdateTemplate").removeClass("d-none");

        //    // Load filter grid + apply saved values
        //    loadTemplate(id, name);
        //}

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
                url: "DynamicReport.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res1) {
                    let cols = JSON.parse(res1.d);
                    buildFilterGrid(cols);

                    // now load the template JSON and fill grid
                    $.ajax({
                        url: "DynamicReport.aspx/GetTemplateData",
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
                url: "DynamicReport.aspx/UpdateTemplateLastAccessed",
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
                url: "DynamicReport.aspx/DeleteTemplate",
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
                url: "DynamicReport.aspx/GetFiltersList",
                method: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (res1) {

                    let allColumns = JSON.parse(res1.d);
                    buildFilterGrid(allColumns);   // build full grid

                    // 2) Now load template data
                    $.ajax({
                        url: "DynamicReport.aspx/GetTemplateData",
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
                url: "DynamicReport.aspx/UpdateTemplate",
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
                url: "DynamicReport.aspx/GetAllTemplates",
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
                                    console.log("RAW LastAccessedOn:", d);
                                    return formatDate(d);
                                }
                            },
                           
                            {
                                data: "TemplateID",
                                title: "Download",
                                orderable: false,
                                render: function (id) {
                                    return `
                                        <button type="button" class="btn btn-sm btn-success"
                                                onclick="return downloadTemplateData(${id});">
                                            <i class="fa fa-file-excel"></i> Download
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
            $.ajax({
                url: "DynamicReport.aspx/DownloadTemplateActualData",
                type: "POST",
                contentType: "application/json;charset=utf-8",
                data: JSON.stringify({ TemplateID: id }),
                success: function (res) {
                    if (res.d) {
                        window.location = res.d;
                    } else {
                        alert("No data found for this template.");
                    }
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
                        <td style="width: 150px; display:none;"><b>Column List:</b></td>
                        <td style="width: 250px;display:none;">
                            <select id="ddlColumns" class="form-control" multiple="multiple"></select>
                        </td>
                        <td style="width: 350px; display:none;">
                            <button class="btn btn-primary" onclick="return openFilterPopup();">
                                <i class="fa fa-filter"></i>Filters
                            </button>

                            &nbsp;
                            <button class="btn btn-warning" onclick="return saveFilterTemplate();">Save as Template</button>
                        </td>
                        <td>
                            <b>Templates:</b>&nbsp;<div class="dropdown">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button" style="display:inline;"
                                    id="templateDropdownBtn" data-toggle="dropdown">
                                    Load Template
                                </button>

                                <div class="dropdown-menu" id="templateDropdownMenu" aria-labelledby="templateDropdownBtn">
                                    <h6 class="dropdown-header">Saved Templates</h6>
                                    <div id="templateList"></div>

                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item text-info" href="#" onclick="return createNewTemplate();">➕ Create New Template
                                    </a>
                                </div>
                            </div>

                        </td>

                    </tr>
                </table>
                <hr />
                <table id="templateMasterTable" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Report Name</th>
                            <th>Created By</th>
                            <th>Created On</th>
                            <th>Last Accessed By</th>
                            <th>Last Accessed On</th>
                            <th>Download</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>




                <div class="d-flex flex-wrap" style="gap: 20px; display: none;" id="mainfiltersdiv">
                    <!-- Column List -->

                    <!-- Group By -->
                    <div class="col-panel" style="display: none;">
                        <div class="panel-title">Group By (Levels)</div>
                        <label>Level 1</label>
                        <select id="ddlGroup1" class="form-control"></select>
                        <label class="mt-2">Level 2</label>
                        <select id="ddlGroup2" class="form-control"></select>
                        <label class="mt-2">Level 3</label>
                        <select id="ddlGroup3" class="form-control"></select>
                        <small class="form-text text-muted">Choose 1–3 grouping levels in order.</small>
                    </div>
                    <div class="col-panel" style="display: none;">
                        <div class="panel-title">Aggregates</div>
                        <label>Select Numeric Column</label>
                        <select id="ddlAggColumn" class="form-control"></select>
                        <label class="mt-2">Aggregate Function</label>
                        <select id="ddlAggFunc" class="form-control">
                            <option value="">None</option>
                            <option value="SUM">SUM</option>
                            <option value="AVG">AVG</option>
                            <option value="MIN">MIN</option>
                            <option value="MAX">MAX</option>
                        </select>
                    </div>
                    <!-- Filter Builder -->
                    <div class="col-panel" style="display: none;">
                        <div class="panel-title">Filters</div>
                        <label>Column</label>
                        <select id="filterColumn" class="form-control"></select>
                        <label class="mt-2">Operator</label>
                        <select id="filterOperator" class="form-control">
                            <option value="=">=</option>
                            <option value="<>"><></option>
                            <option value=">">></option>
                            <option value="<"><</option>
                            <option value=">=">>=</option>
                            <option value="<="><=</option>
                            <option value="LIKE">Contains</option>
                            <option value="BETWEEN">Between</option>
                            <option value="IN">IN (comma separated)</option>
                        </select>
                        <label class="mt-2">Value</label>
                        <input id="filterValue" class="form-control" />
                        <div id="filterValue2Wrapper" style="display: none;">
                            <label class="mt-2">Value 2 (for BETWEEN)</label>
                            <input id="filterValue2" class="form-control" />
                        </div>
                        <button id="addFilterBtn" type="button" class="btn btn-secondary btn-sm mt-3">Add Filter</button>
                    </div>
                    <!-- Active Filters -->
                    <div class="col-panel" style="display: none;">
                        <div class="panel-title">Active Filters</div>
                        <ul id="activeFiltersList"></ul>
                    </div>
                    <div style="align-self: flex-end;">

                        <button id="generateBtn" type="button" class="btn btn-primary" style="display: none;">Generate</button>
                    </div>
                </div>

                <button id="pivotBtn" type="button" class="btn btn-warning" style="display: none;">Generate Pivot</button>
                <button id="exportBtn" type="button" class="btn btn-success" onclick="return exportPivotToExcel();" style="display: none;">Export</button>
                <div id="pivotContainer" style="width: 100%; overflow-x: scroll!important; height: 400px; overflow-y: scroll!important; display: none;"></div>
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

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Select Filters</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>

                <div class="modal-body">
                    <table class="table table-bordered table-sm" id="filterTable">
                        <thead class="table-dark">
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
</asp:Content>
