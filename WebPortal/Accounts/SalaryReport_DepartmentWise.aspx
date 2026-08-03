<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Accounts/SalaryReport_DepartmentWise.aspx.cs" Inherits="WebPortal.Reports.SalaryReport" MasterPageFile="~/Accounts/Accounts.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../Content/DataTables/css/fixedHeader.dataTables.min.css" rel="stylesheet" />
<link href="../Content/DataTables/css/fixedColumns.dataTables.min.css" rel="stylesheet" />
<style>
    .salary-page { padding:12px 15px 25px; }
    .page-hero { background:#fff; border-left:4px solid #5a78a8; border-radius:6px; padding:14px 18px; margin-bottom:14px; box-shadow:0 1px 5px rgba(0,0,0,.08); }
    .page-hero h3 { margin:0; color:#27364b; font-size:21px; font-weight:600; }
    .page-hero small { color:#7b8797; }
    .erp-panel { background:#fff; border:1px solid #e4e8ee; border-radius:7px; margin-bottom:15px; box-shadow:0 1px 4px rgba(0,0,0,.05); }
    .erp-panel-title { padding:11px 15px; border-bottom:1px solid #e8ebef; font-weight:600; color:#33445c; background:#f8fafc; border-radius:7px 7px 0 0; }
    .erp-panel-body { padding:15px; }
    .form-label { display:block; font-size:12px; font-weight:600; color:#536174; margin-bottom:5px; }
    .btn-report { background:#5a78a8; color:#fff; border-color:#5a78a8; min-width:100px; }
    .btn-report:hover { color:#fff; background:#49678f; }
    .summary-card { height:100%; border:1px solid #e4e8ee; border-radius:7px; padding:13px 15px; background:#fbfcfe; }
    .summary-card span { display:block; color:#778397; font-size:12px; }
    .summary-card strong { color:#2e4057; font-size:19px; }
    .summary-card small { display:block; margin-top:3px; color:#7b8797; }
    .positive { color:#16834a !important; }
    .negative { color:#c43b3b !important; }
    .grid-wrapper { position:relative; min-height:130px; width:100%; overflow:hidden; }
    .grid-loader { display:none; position:absolute; inset:0; z-index:20; background:rgba(255,255,255,.75); align-items:center; justify-content:center; }
    .grid-loader div { background:#fff; border:1px solid #dfe4ea; border-radius:5px; padding:10px 16px; box-shadow:0 2px 10px rgba(0,0,0,.08); }
    table.dataTable thead th { white-space:nowrap; background:#eef2f7; color:#35455c; font-size:12px; text-align:center; }
    table.dataTable tbody td { white-space:nowrap; font-size:12px; }
    .amount { text-align:right; }
    .month-head { text-align:center !important; }
    .month-subhead { min-width:105px; }
    .report-section-title { margin:2px 0 12px; padding:10px 14px; background:#eaf0f8; border-left:4px solid #5a78a8; font-weight:600; color:#30435d; border-radius:4px; }
    .excel-block-title { padding:9px 12px; margin:0 0 8px; background:#f3f6fa; border:1px solid #e0e6ee; font-weight:600; color:#40526a; }
    .chart-summary { font-size:12px; color:#5f6f82; margin-bottom:10px; }
    .chart-summary strong { color:#2f4058; }
    .chart-box { position:relative; height:340px !important; min-height:340px; }
    .metric-chart-wrap .chart-box { height:420px !important; min-height:420px; }
    .trend-heatmap-wrap { max-height:420px; overflow:auto; border:1px solid #dfe5ec; border-radius:5px; background:#fff; }
    .trend-heatmap { min-width:720px; }
    .trend-heatmap table { width:100%; border-collapse:separate; border-spacing:0; font-size:11px; }
    .trend-heatmap th, .trend-heatmap td { padding:6px 8px; border-right:1px solid #e3e8ee; border-bottom:1px solid #e3e8ee; text-align:right; white-space:nowrap; }
    .trend-heatmap thead th { position:sticky; top:0; z-index:3; background:#eef3f8; color:#34465f; text-align:center; font-weight:600; }
    .trend-heatmap .department-cell { position:sticky; left:0; z-index:2; min-width:150px; max-width:220px; overflow:hidden; text-overflow:ellipsis; background:#f8fafc; color:#35465d; text-align:left; font-weight:600; }
    .trend-heatmap thead .department-cell { z-index:4; background:#e7edf5; }
    .trend-heatmap .value-cell { min-width:78px; font-variant-numeric:tabular-nums; }
    .trend-heatmap .spark-cell { min-width:150px; width:150px; padding:3px 8px; text-align:center; background:#fbfcfe; }
    .trend-heatmap .spark-cell svg { display:block; width:135px; height:30px; margin:auto; }
    .heatmap-note { margin-top:7px; color:#748195; font-size:11px; }
    .chart-box.tall { height:430px !important; min-height:430px; }
    .chart-note { margin-top:8px; font-size:11px; color:#7b8797; }
    .dev-up { color:#16834a; font-weight:600; }
    .dev-down { color:#c43b3b; font-weight:600; }
    .dev-flat { color:#6c757d; }
    .metric-section { border:1px solid #dfe5ec; border-radius:8px; background:#fff; margin-bottom:18px; overflow:hidden; }
    .metric-section-head { padding:12px 16px; background:#f5f8fc; border-bottom:1px solid #e1e6ed; display:flex; justify-content:space-between; align-items:center; }
    .metric-section-head strong { color:#30435d; font-size:15px; }
    .metric-section-head span { color:#768397; font-size:11px; }
    .metric-chart-wrap { padding:15px; border-bottom:1px solid #e5e9ef; }
    .metric-table-wrap { padding:15px; }
    .horizontal-report .dataTables_scrollHeadInner, .horizontal-report .dataTables_scrollHeadInner table,
    .horizontal-report .dataTables_scrollBody table { width:auto !important; table-layout:fixed !important; }
    .horizontal-report table.dataTable th:first-child, .horizontal-report table.dataTable td:first-child { width:220px !important; min-width:220px !important; max-width:220px !important; }
    .horizontal-report table.dataTable th:not(:first-child), .horizontal-report table.dataTable td:not(:first-child) { width:140px !important; min-width:140px !important; max-width:140px !important; }
    .horizontal-report .dataTables_filter { margin-bottom:8px; }
    @media (max-width:767px) { .filter-action { margin-top:10px; } .chart-box,.chart-box.tall { height:290px; } }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="salary-page">
    <div class="page-hero">
        <h3>Salary & Headcount Dashboard</h3>
        <small>Department-wise salary, headcount, deviation trends and employee-level details</small>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Report Filters</div>
        <div class="erp-panel-body">
            <div class="row align-items-end">
                <div class="col-md-3"><label class="form-label">From Month-Year</label><input type="month" id="txtFromMonth" class="form-control" /></div>
                <div class="col-md-3"><label class="form-label">To Month-Year</label><input type="month" id="txtToMonth" class="form-control" /></div>
                <div class="col-md-4 filter-action">
                    <button type="button" id="btnSearch" class="btn btn-report">Submit</button>
                    <button type="button" id="btnClear" class="btn btn-light border ml-1">Clear</button>
                    <button type="button" id="btnExport" class="btn btn-success ml-1">Export Excel</button>
                </div>
            </div>
        </div>
    </div>

    <div class="row" id="totalsRow" style="display:none;">
        <div class="col-lg-3 col-md-6 mb-3"><div class="summary-card"><span>Latest Month Headcount</span><strong id="lblEmployeeCount">0</strong><small id="lblHeadcountPeriod"></small></div></div>
        <div class="col-lg-3 col-md-6 mb-3"><div class="summary-card"><span>Latest Month Gross Salary</span><strong id="lblGross">0.00</strong><small id="lblGrossPeriod"></small></div></div>
        <div class="col-lg-3 col-md-6 mb-3"><div class="summary-card"><span>Salary Change vs Previous Month</span><strong id="lblSalaryChange">-</strong><small id="lblSalaryChangeText"></small></div></div>
        <div class="col-lg-3 col-md-6 mb-3"><div class="summary-card"><span>Headcount Change vs Previous Month</span><strong id="lblHeadcountChange">-</strong><small id="lblDepartmentCount"></small></div></div>
    </div>

    <div class="dashboard-section" style="display:none;">
        <div class="report-section-title">Salary and Headcount Analysis</div>

        <div class="metric-section">
            <div class="metric-section-head"><strong>1. Headcount Analysis</strong><span>Trend chart and Excel-format department table</span></div>
            <div class="metric-chart-wrap">
                <div id="txtHeadcountInsight" class="chart-summary"></div>
                <div class="trend-heatmap-wrap"><div id="chtHeadcountTrend" class="trend-heatmap"></div></div>
                <div class="heatmap-note">Darker cells indicate higher values within that department. Hover a cell for month, value and change.</div>
            </div>
            <div class="metric-table-wrap horizontal-report">
                <div class="excel-block-title">Department-wise Headcount by Month</div>
                <div class="grid-wrapper"><div class="grid-loader"><div>Loading headcount report...</div></div><table id="tblHeadcountHorizontal" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div>
            </div>
        </div>

        <div class="metric-section">
            <div class="metric-section-head"><strong>2. Gross Salary Analysis</strong><span>Trend chart and Excel-format department table</span></div>
            <div class="metric-chart-wrap">
                <div id="txtSalaryInsight" class="chart-summary"></div>
                <div class="trend-heatmap-wrap"><div id="chtSalaryTrend" class="trend-heatmap"></div></div>
                <div class="heatmap-note">Darker cells indicate higher values within that department. Hover a cell for month, value and change.</div>
            </div>
            <div class="metric-table-wrap horizontal-report">
                <div class="excel-block-title">Department-wise Gross Salary by Month</div>
                <div class="grid-wrapper"><div class="grid-loader"><div>Loading gross salary report...</div></div><table id="tblSalaryHorizontal" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div>
            </div>
        </div>

        <div class="metric-section">
            <div class="metric-section-head"><strong>3. Salary Deviation Analysis</strong><span>Month-over-month movement and Excel-format department table</span></div>
            <div class="metric-chart-wrap">
                <div id="txtDeviationInsight" class="chart-summary"></div>
                <div class="trend-heatmap-wrap"><div id="chtDeviationTrend" class="trend-heatmap"></div></div>
                <div class="chart-note">Green indicates an increase and red indicates a decrease. Colour intensity is normalized per department.</div>
            </div>
            <div class="metric-table-wrap horizontal-report">
                <div class="excel-block-title">Department-wise Salary Deviation % by Month</div>
                <div class="chart-note mb-2">Green indicates an increase; red indicates a decrease against the previous month.</div>
                <div class="grid-wrapper"><div class="grid-loader"><div>Loading deviation report...</div></div><table id="tblDeviationHorizontal" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div>
            </div>
        </div>

        <div class="report-section-title">Additional Department Analysis</div>
        <div class="row">
            <div class="col-lg-6"><div class="erp-panel"><div class="erp-panel-title">Department-wise Gross Salary — Latest Month</div><div class="erp-panel-body"><div class="chart-box tall"><canvas id="chtDepartmentSalary"></canvas></div><div class="chart-note">Departments are sorted highest to lowest. Production is excluded so smaller departments remain readable.</div></div></div></div>
            <div class="col-lg-6"><div class="erp-panel"><div class="erp-panel-title">Department-wise Headcount — Latest Month</div><div class="erp-panel-body"><div class="chart-box tall"><canvas id="chtHeadcountShare"></canvas></div><div class="chart-note">Departments are sorted highest to lowest.</div></div></div></div>
            <div class="col-lg-12"><div class="erp-panel"><div class="erp-panel-title">Production Department — Salary and Headcount Trend</div><div class="erp-panel-body"><div class="chart-box"><canvas id="chtProductionTrend"></canvas></div><div class="chart-note">Gross salary uses the left axis; headcount uses the right axis.</div></div></div></div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Year-wise Department Summary</div>
        <div class="erp-panel-body"><div class="grid-wrapper"><div class="grid-loader"><div>Loading year summary...</div></div><table id="tblYearSummary" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div></div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Monthly Tidy Data</div>
        <div class="erp-panel-body"><div class="grid-wrapper"><div class="grid-loader"><div>Loading monthly details...</div></div><table id="tblMonthTidy" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div></div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Employee Details</div>
        <div class="erp-panel-body"><div class="grid-wrapper"><div class="grid-loader"><div>Loading employee details...</div></div><table id="tblEmployees" class="display nowrap table table-bordered table-sm" style="width:100%"></table></div></div>
    </div>
</div>

<script src="../Scripts/jquery-3.6.0.min.js"></script>
<script src="../Scripts/DataTables/jquery.dataTables.min.js"></script>
<script src="../Scripts/DataTables/dataTables.fixedHeader.min.js"></script>
<script src="../Scripts/DataTables/dataTables.fixedColumns.min.js"></script>
<script src="../Scripts/Chart.min.js"></script>
<script>
    var headcountHorizontalTable, salaryHorizontalTable, deviationHorizontalTable, yearTable, monthTidyTable, employeeTable;
    var reportCharts = {};

    $(function () {
        setDefaultMonths();
        $('#btnSearch').on('click', loadReport);
        $('#btnExport').on('click', exportReport);
        $('#btnClear').on('click', clearReport);
    });

    function setDefaultMonths() {
        var now = new Date();
        $('#txtToMonth').val(now.getFullYear() + '-' + pad2(now.getMonth() + 1));
        var fromDate = new Date(now.getFullYear(), now.getMonth() - 5, 1);
        $('#txtFromMonth').val(fromDate.getFullYear() + '-' + pad2(fromDate.getMonth() + 1));
    }

    function clearReport() {
        setDefaultMonths(); destroyTables(); destroyCharts();
        $('#totalsRow,.dashboard-section').hide();
    }

    function exportReport() {
        var p = selectedPeriod(); if (!p) return;
        window.location.href = 'SalaryReport_DepartmentWise.aspx?export=1&fromMonth=' + p.fromMonth + '&fromYear=' + p.fromYear + '&toMonth=' + p.toMonth + '&toYear=' + p.toYear;
    }

    function selectedPeriod() {
        var from = $('#txtFromMonth').val(), to = $('#txtToMonth').val();
        if (!from || !to) { alert('Please select From Month-Year and To Month-Year.'); return null; }
        if (from > to) { alert('From Month-Year cannot be greater than To Month-Year.'); return null; }
        var fp = from.split('-'), tp = to.split('-');
        return { fromMonth: +fp[1], fromYear: +fp[0], toMonth: +tp[1], toYear: +tp[0] };
    }

    function loadReport() {
        var p = selectedPeriod(); if (!p) return;
        toggleLoader(true);
        $.ajax({
            type: 'POST', url: 'SalaryReport_DepartmentWise.aspx/GetSalaryReport',
            data: JSON.stringify(p), contentType: 'application/json; charset=utf-8', dataType: 'json',
            success: function (response) {
                var result = response.d;
                if (!result.Success) { alert(result.Message); return; }
                var months = normalizeMonthlyData(result.MonthDetails || [], result.EmployeeDetails || []);
                bindCards(months);
                bindCharts(months);
                bindHorizontal(months);
                bindYearSummary(result.YearSummary || [], result.EmployeeDetails || []);
                bindMonthTidy(months);
                bindEmployees(result.EmployeeDetails || []);
                $('#totalsRow,.dashboard-section').show();
            },
            error: function (xhr) { alert('Unable to load report.' + (xhr.responseJSON && xhr.responseJSON.Message ? '\n' + xhr.responseJSON.Message : '')); },
            complete: function () { toggleLoader(false); }
        });
    }

    function normalizeMonthlyData(monthRows, employeeRows) {
        var countMap = buildMonthEmployeeCountMap(employeeRows), periods = {}, periodList = [], departments = {};
        $.each(monthRows, function (_, r) {
            var month = num(r.MonthNumber || r.MonthNo); if (!month) month = monthNumberFromLabel(r.MonthYear || r.MonthName);
            var key = num(r.Year) * 100 + month, label = r.MonthYear || ((r.MonthName || '') + '-' + r.Year), dept = String(r.Department || 'Not Assigned');
            if (!periods[key]) { periods[key] = { key: key, label: label, rows: {} }; periodList.push(periods[key]); }
            periods[key].rows[dept] = { department: dept, gross: num(r.GrossSalary), net: num(r.NetSalary), count: getCount(countMap, key, dept) };
            departments[dept] = true;
        });
        periodList.sort(function (a, b) { return a.key - b.key; });
        var departmentList = Object.keys(departments).sort();
        $.each(periodList, function (i, p) {
            $.each(departmentList, function (_, d) {
                if (!p.rows[d]) p.rows[d] = { department: d, gross: 0, net: 0, count: 0 };
                var prev = i > 0 ? periodList[i - 1].rows[d] : null;
                p.rows[d].deviation = prev && prev.gross !== 0 ? ((p.rows[d].gross - prev.gross) / prev.gross) * 100 : null;
            });
            p.totalGross = 0; p.totalNet = 0; p.totalCount = 0;
            $.each(p.rows, function (_, v) { p.totalGross += v.gross; p.totalNet += v.net; p.totalCount += v.count; });
        });
        return { periods: periodList, departments: departmentList };
    }

    function bindCards(model) {
        var latest = model.periods.length ? model.periods[model.periods.length - 1] : null;
        var previous = model.periods.length > 1 ? model.periods[model.periods.length - 2] : null;
        if (!latest) return;
        var salaryChange = previous && previous.totalGross ? ((latest.totalGross - previous.totalGross) / previous.totalGross) * 100 : null;
        var headcountChange = previous && previous.totalCount ? ((latest.totalCount - previous.totalCount) / previous.totalCount) * 100 : null;
        $('#lblEmployeeCount').text(latest.totalCount.toLocaleString('en-IN'));
        $('#lblGross').text(formatMoney(latest.totalGross));
        $('#lblHeadcountPeriod,#lblGrossPeriod').text(latest.label);
        setChange('#lblSalaryChange', salaryChange);
        setChange('#lblHeadcountChange', headcountChange);
        $('#lblSalaryChangeText').text(previous ? 'Compared with ' + previous.label : 'Previous month unavailable');
        $('#lblDepartmentCount').text(model.departments.length.toLocaleString('en-IN') + ' departments in ' + latest.label);
    }

    function setChange(selector, value) {
        var el = $(selector).removeClass('positive negative');
        if (value === null || value === undefined || !isFinite(value)) { el.text('-'); return; }
        el.text((value > 0 ? '+' : '') + value.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '%')
            .addClass(value > 0 ? 'positive' : value < 0 ? 'negative' : '');
    }

    function bindCharts(model) {
        destroyCharts();
        if (typeof Chart === 'undefined') { console.warn('Chart.js is not loaded.'); return; }
        if (!model.periods.length) return;

        var labels = $.map(model.periods, function (p) { return p.label; });
        var latest = model.periods[model.periods.length - 1];
        var previous = model.periods.length > 1 ? model.periods[model.periods.length - 2] : null;
        $('#txtHeadcountInsight').html(buildTrendInsight('Headcount', latest.totalCount, previous ? previous.totalCount : null, latest.label, previous ? previous.label : null, false));
        $('#txtSalaryInsight').html(buildTrendInsight('Gross salary', latest.totalGross, previous ? previous.totalGross : null, latest.label, previous ? previous.label : null, true));

        createTrendHeatmap('chtHeadcountTrend', labels, model, 'count', 'Headcount', false);
        createTrendHeatmap('chtSalaryTrend', labels, model, 'gross', 'Gross Salary', true);

        var deviationValues = [], latestDeviation = null;
        $.each(model.periods, function (i, p) {
            if (i === 0 || model.periods[i - 1].totalGross === 0) deviationValues.push(null);
            else deviationValues.push(((p.totalGross - model.periods[i - 1].totalGross) / model.periods[i - 1].totalGross) * 100);
        });
        latestDeviation = deviationValues.length ? deviationValues[deviationValues.length - 1] : null;
        $('#txtDeviationInsight').html(latestDeviation === null ? '<strong>Previous month is not available for comparison.</strong>' : '<strong>' + html(latest.label) + ': ' + (latestDeviation > 0 ? '+' : '') + latestDeviation.toFixed(2) + '%</strong> change in total gross salary compared with ' + html(previous ? previous.label : '') + '.');
        createTrendHeatmap('chtDeviationTrend', labels, model, 'deviation', 'Change %', false, true);

        var otherDepartments = $.grep(model.departments, function (d) { return d.toLowerCase() !== 'production'; });
        otherDepartments.sort(function (a, b) { return latest.rows[b].gross - latest.rows[a].gross; });
        reportCharts.departmentSalary = createHorizontalBar('chtDepartmentSalary', otherDepartments, $.map(otherDepartments, function (d) { return latest.rows[d].gross; }), 'Gross Salary', true, '#6f8fbf');

        var headcountDepartments = model.departments.slice(0);
        headcountDepartments.sort(function (a, b) { return latest.rows[b].count - latest.rows[a].count; });
        reportCharts.headcountShare = createHorizontalBar('chtHeadcountShare', headcountDepartments, $.map(headcountDepartments, function (d) { return latest.rows[d].count; }), 'Headcount', false, '#6fa58d');

        var productionName = findDepartment(model.departments, 'production'), prodSalary = [], prodCount = [];
        $.each(model.periods, function (_, p) { var v = productionName ? p.rows[productionName] : null; prodSalary.push(v ? v.gross : 0); prodCount.push(v ? v.count : 0); });
        reportCharts.production = new Chart(document.getElementById('chtProductionTrend'), {
            type: 'line',
            data: {
                labels: labels, datasets: [
                    { label: 'Gross Salary', data: prodSalary, borderColor: '#5a78a8', backgroundColor: 'rgba(90,120,168,.08)', fill: false, lineTension: 0, pointRadius: 4, pointHoverRadius: 6, yAxisID: 'salary' },
                    { label: 'Headcount', data: prodCount, borderColor: '#d28b40', backgroundColor: 'rgba(210,139,64,.08)', fill: false, lineTension: 0, pointRadius: 4, pointHoverRadius: 6, yAxisID: 'count' }
                ]
            },
            options: { responsive: true, maintainAspectRatio: false, legend: { display: true, position: 'bottom' }, tooltips: { mode: 'index', intersect: false, callbacks: { label: function (t, d) { return d.datasets[t.datasetIndex].label + ': ' + (t.datasetIndex === 0 ? formatMoney(t.yLabel) : Number(t.yLabel).toLocaleString('en-IN')); } } }, scales: { xAxes: [{ scaleLabel: { display: true, labelString: 'Month' }, gridLines: { display: false } }], yAxes: [{ id: 'salary', position: 'left', scaleLabel: { display: true, labelString: 'Gross Salary' }, ticks: { beginAtZero: false, callback: compactMoney } }, { id: 'count', position: 'right', scaleLabel: { display: true, labelString: 'Headcount' }, gridLines: { drawOnChartArea: false }, ticks: { beginAtZero: false, precision: 0, callback: function (v) { return Number(v).toLocaleString('en-IN'); } } }] } }
        });

    }

    function createTrendHeatmap(id, labels, model, metric, axisLabel, moneyValues, percentageValues) {
        var container = $('#' + id).empty();
        var table = $('<table aria-label="' + html(axisLabel) + ' department trend heatmap"></table>');
        var header = $('<tr></tr>').append($('<th class="department-cell">Department</th>'));
        $.each(labels, function (_, label) { header.append($('<th></th>').text(label)); });
        header.append($('<th>Trend</th>'));
        table.append($('<thead></thead>').append(header));
        var body = $('<tbody></tbody>');

        $.each(model.departments, function (_, department) {
            var values = $.map(model.periods, function (period) { return period.rows[department][metric]; });
            var numericValues = $.grep(values, function (value) { return value !== null && value !== undefined && isFinite(Number(value)); });
            var minimum = numericValues.length ? Math.min.apply(Math, numericValues) : 0;
            var maximum = numericValues.length ? Math.max.apply(Math, numericValues) : 0;
            var maximumAbsolute = numericValues.length ? Math.max(Math.abs(minimum), Math.abs(maximum)) : 0;
            var row = $('<tr></tr>').append($('<th class="department-cell"></th>').text(department).attr('title', department));

            $.each(values, function (index, value) {
                var previous = index > 0 ? values[index - 1] : null;
                var display = formatHeatmapValue(value, moneyValues, percentageValues);
                var tooltip = 'Department: ' + department + '\nMonth: ' + labels[index] + '\n' + axisLabel + ': ' + display;
                if (!percentageValues && previous !== null && previous !== undefined && Number(previous) !== 0 && value !== null && value !== undefined) {
                    var change = ((Number(value) - Number(previous)) / Number(previous)) * 100;
                    tooltip += '\nChange: ' + (change > 0 ? '+' : '') + change.toFixed(2) + '%';
                }
                var background = percentageValues
                    ? deviationHeatColor(value, maximumAbsolute)
                    : sequentialHeatColor(value, minimum, maximum);
                row.append($('<td class="value-cell"></td>').text(display).attr('title', tooltip).css('background-color', background));
            });

            row.append($('<td class="spark-cell"></td>').html(buildSparkline(values, percentageValues)));
            body.append(row);
        });

        table.append(body);
        container.append(table);
    }

    function formatHeatmapValue(value, moneyValues, percentageValues) {
        if (value === null || value === undefined || !isFinite(Number(value))) return '-';
        var numeric = Number(value);
        if (percentageValues) return (numeric > 0 ? '+' : '') + numeric.toFixed(2) + '%';
        return moneyValues
            ? numeric.toLocaleString('en-IN', { minimumFractionDigits: 0, maximumFractionDigits: 0 })
            : numeric.toLocaleString('en-IN');
    }

    function sequentialHeatColor(value, minimum, maximum) {
        if (value === null || value === undefined) return '#f5f7fa';
        var range = maximum - minimum;
        var intensity = range === 0 ? .45 : (Number(value) - minimum) / range;
        return 'rgba(54,112,170,' + (.12 + Math.max(0, Math.min(1, intensity)) * .58).toFixed(2) + ')';
    }

    function deviationHeatColor(value, maximumAbsolute) {
        if (value === null || value === undefined) return '#f5f7fa';
        var numeric = Number(value), intensity = maximumAbsolute ? Math.min(1, Math.abs(numeric) / maximumAbsolute) : 0;
        if (numeric > 0) return 'rgba(40,145,85,' + (.12 + intensity * .58).toFixed(2) + ')';
        if (numeric < 0) return 'rgba(196,65,65,' + (.12 + intensity * .58).toFixed(2) + ')';
        return 'rgba(135,145,155,.14)';
    }

    function buildSparkline(values, percentageValues) {
        var width = 135, height = 30, pad = 3;
        var valid = $.grep(values, function (value) { return value !== null && value !== undefined && isFinite(Number(value)); });
        if (!valid.length) return '';
        var minimum = Math.min.apply(Math, valid), maximum = Math.max.apply(Math, valid);
        if (percentageValues) { minimum = Math.min(0, minimum); maximum = Math.max(0, maximum); }
        if (maximum === minimum) maximum = minimum + 1;
        var points = [];
        $.each(values, function (index, value) {
            if (value === null || value === undefined || !isFinite(Number(value))) return;
            var x = values.length === 1 ? width / 2 : pad + index * (width - pad * 2) / (values.length - 1);
            var y = pad + (maximum - Number(value)) * (height - pad * 2) / (maximum - minimum);
            points.push(x.toFixed(1) + ',' + y.toFixed(1));
        });
        var zeroLine = '';
        if (percentageValues && minimum <= 0 && maximum >= 0) {
            var zeroY = pad + maximum * (height - pad * 2) / (maximum - minimum);
            zeroLine = '<line x1="0" y1="' + zeroY.toFixed(1) + '" x2="' + width + '" y2="' + zeroY.toFixed(1) + '" stroke="#c7ced7" stroke-width="1"/>';
        }
        return '<svg viewBox="0 0 ' + width + ' ' + height + '" role="img" aria-label="Trend">' + zeroLine + '<polyline points="' + points.join(' ') + '" fill="none" stroke="#355f8c" stroke-width="2" stroke-linejoin="round" stroke-linecap="round"/></svg>';
    }

    function createHorizontalBar(id, labels, values, label, moneyValues, color, percentageValues) {
        return new Chart(document.getElementById(id), { type: 'horizontalBar', data: { labels: labels, datasets: [{ label: label, data: values, backgroundColor: color, borderWidth: 0 }] }, options: { responsive: true, maintainAspectRatio: false, legend: { display: false }, tooltips: { callbacks: { label: function (t) { var v = Number(t.xLabel || 0); return label + ': ' + (percentageValues ? ((v > 0 ? '+' : '') + v.toFixed(2) + '%') : (moneyValues ? formatMoney(v) : v.toLocaleString('en-IN'))); } } }, scales: { xAxes: [{ scaleLabel: { display: true, labelString: percentageValues ? 'Change %' : label }, ticks: { beginAtZero: true, callback: function (v) { return percentageValues ? v + '%' : moneyValues ? compactMoney(v) : Number(v).toLocaleString('en-IN'); } } }], yAxes: [{ gridLines: { display: false }, ticks: { autoSkip: false, fontSize: 10 } }] } } });
    }

    function buildTrendInsight(label, current, previous, currentPeriod, previousPeriod, moneyValue) {
        var currentText = moneyValue ? formatMoney(current) : Number(current).toLocaleString('en-IN');
        if (previous === null || previous === undefined || previous === 0) return '<strong>' + html(currentPeriod) + ': ' + currentText + '</strong> — previous month not available.';
        var change = ((current - previous) / previous) * 100, direction = change > 0 ? 'increased' : change < 0 ? 'decreased' : 'remained unchanged';
        return '<strong>' + html(currentPeriod) + ': ' + currentText + '</strong> — ' + html(label) + ' ' + direction + (change === 0 ? '' : ' by ' + Math.abs(change).toFixed(2) + '%') + ' compared with ' + html(previousPeriod) + '.';
    }

    function bindHorizontal(model) {
        bindExcelHorizontalTable('#tblHeadcountHorizontal', 'headcount', model);
        bindExcelHorizontalTable('#tblSalaryHorizontal', 'salary', model);
        bindExcelHorizontalTable('#tblDeviationHorizontal', 'deviation', model);
    }

    function bindExcelHorizontalTable(selector, type, model) {
        if ($.fn.DataTable.isDataTable(selector)) $(selector).DataTable().destroy();
        $(selector).empty();
        if (!model.periods.length) { $(selector).html('<thead><tr><th>No data available</th></tr></thead>'); return; }

        var columns = [{ title: 'Department', data: 'Department' }], rows = [];
        $.each(model.periods, function (_, p) {
            if (type === 'headcount') columns.push({ title: p.label, data: String(p.key), className: 'amount' });
            else if (type === 'salary') columns.push({ title: p.label, data: String(p.key), render: money, className: 'amount' });
            else columns.push({ title: p.label, data: String(p.key), render: deviation, className: 'amount' });
        });
        $.each(model.departments, function (_, d) {
            var row = { Department: d };
            $.each(model.periods, function (_, p) {
                row[String(p.key)] = type === 'headcount' ? p.rows[d].count : type === 'salary' ? p.rows[d].gross : p.rows[d].deviation;
            });
            rows.push(row);
        });

        var options = {
            data: rows, columns: columns, paging: false, searching: true, info: true, ordering: false,
            autoWidth: false, scrollX: true, scrollY: '42vh', scrollCollapse: true, fixedHeader: true,
            fixedColumns: { leftColumns: 1 },
            columnDefs: [{ targets: '_all', width: '140px' }, { targets: 0, width: '220px' }],
            initComplete: function () {
                var api = this.api();
                api.columns.adjust();
                synchronizeHorizontalScroll();
            }
        };
        var table = $(selector).DataTable(options);
        table.columns.adjust();
        if (type === 'headcount') headcountHorizontalTable = table;
        else if (type === 'salary') salaryHorizontalTable = table;
        else deviationHorizontalTable = table;
    }

    function synchronizeHorizontalScroll() {
        var bodies = $('.horizontal-report .dataTables_scrollBody');
        bodies.off('scroll.salarySync').on('scroll.salarySync', function () {
            var left = this.scrollLeft;
            bodies.not(this).each(function () { if (this.scrollLeft !== left) this.scrollLeft = left; });
        });
    }

    function bindYearSummary(rows, employeeRows) {
        if ($.fn.DataTable.isDataTable('#tblYearSummary')) $('#tblYearSummary').DataTable().destroy(); $('#tblYearSummary').empty();
        if (!rows.length) { $('#tblYearSummary').html('<thead><tr><th>No data available</th></tr></thead>'); return; }
        var departments = getDepartmentsFromYearRows(rows), countMap = buildYearEmployeeCountMap(employeeRows), tableRows = [];
        $.each(rows, function (_, r) { var item = { Year: r.Year }; $.each(departments, function (_, d) { item[d + ' Count'] = getCount(countMap, r.Year, d); item[d + ' Gross'] = num(r[d + ' - Gross']); item[d + ' Net'] = num(r[d + ' - Net']); }); tableRows.push(item); });
        var cols = [{ title: 'Year', data: 'Year' }]; $.each(departments, function (_, d) { cols.push({ title: d + ' - Employee Count', data: d + ' Count', className: 'amount' }, { title: d + ' - Gross', data: d + ' Gross', render: money, className: 'amount' }, { title: d + ' - Net', data: d + ' Net', render: money, className: 'amount' }); });
        yearTable = $('#tblYearSummary').DataTable({ data: tableRows, columns: cols, paging: false, searching: false, info: true, scrollX: true, fixedHeader: true, order: [[0, 'desc']] });
    }

    function bindMonthTidy(model) {
        if ($.fn.DataTable.isDataTable('#tblMonthTidy')) $('#tblMonthTidy').DataTable().destroy(); $('#tblMonthTidy').empty();
        var rows = []; $.each(model.periods, function (_, p) { $.each(model.departments, function (_, d) { var v = p.rows[d]; rows.push({ Month: p.label, Department: d, Count: v.count, 'Gross Salary': v.gross, 'Net Salary': v.net, 'Deviation %': v.deviation }); }); });
        monthTidyTable = $('#tblMonthTidy').DataTable({ data: rows, columns: [{ title: 'Month', data: 'Month' }, { title: 'Department', data: 'Department' }, { title: 'Headcount', data: 'Count', className: 'amount' }, { title: 'Gross Salary', data: 'Gross Salary', render: money, className: 'amount' }, { title: 'Net Salary', data: 'Net Salary', render: money, className: 'amount' }, { title: 'Deviation %', data: 'Deviation %', render: deviation, className: 'amount' }], paging: false, searching: true, info: true, scrollX: true, scrollY: '55vh', scrollCollapse: true, fixedHeader: true, order: [[0, 'asc'], [1, 'asc']] });
    }

    function bindEmployees(rows) {
        if ($.fn.DataTable.isDataTable('#tblEmployees')) $('#tblEmployees').DataTable().destroy(); $('#tblEmployees').empty();
        var fields = rows.length ? Object.keys(rows[0]) : ['Month', 'Year', 'Department', 'Code', 'Name', 'Pseudoname', 'Gross Salary', 'Net Salary', 'Joining Date', 'Branch', 'Domain', 'Subdomain', 'DepartmentName', 'Designation', 'OfficialEmailID', 'Reporting Manager', 'Tenure', 'Segment', 'Current Status', 'Resignation Date', 'Last Working Date', 'Remark', 'Latest Login Date', 'DailyTaskProductivity'];
        var columns = $.map(fields, function (f) { var isAmount = f === 'Gross Salary' || f === 'Net Salary'; return { title: f, data: f, defaultContent: '', render: isAmount ? money : function (d) { return html(d); }, className: isAmount ? 'amount' : '' }; });
        employeeTable = $('#tblEmployees').DataTable({ data: rows, columns: columns, paging: false, info: true, searching: true, scrollX: true, scrollY: '60vh', scrollCollapse: true, fixedHeader: true, fixedColumns: { leftColumns: 4 }, order: [[1, 'asc'], [0, 'asc'], [2, 'asc'], [3, 'asc']] });
    }

    function buildMonthEmployeeCountMap(rows) { var map = {}; $.each(rows || [], function (_, r) { var month = num(r.MonthNumber || r.MonthNo); if (!month) month = monthNumberFromLabel(r.MonthYear || r.Month); var key = num(r.Year) * 100 + month, dept = String(r.Department || ''), emp = String(r.Code || r.EmployeeID || r.Name || ''); if (!key || !dept || !emp) return; var k = key + '||' + dept; if (!map[k]) map[k] = {}; map[k][emp] = true; }); return map; }
    function buildYearEmployeeCountMap(rows) { var map = {}; $.each(rows || [], function (_, r) { var y = String(r.Year || ''), d = String(r.Department || ''), e = String(r.Code || r.EmployeeID || r.Name || ''); if (!y || !d || !e) return; var k = y + '||' + d; if (!map[k]) map[k] = {}; map[k][e] = true; }); return map; }
    function getCount(map, period, department) { var s = map[String(period) + '||' + String(department)]; return s ? Object.keys(s).length : 0; }
    function getDepartmentsFromYearRows(rows) { var d = []; $.each(rows, function (_, r) { $.each(r, function (k) { var m = k.match(/^(.*) - Gross$/); if (m && d.indexOf(m[1]) < 0) d.push(m[1]); }); }); d.sort(); return d; }
    function findDepartment(list, name) { var n = name.toLowerCase(), found = null; $.each(list, function (_, d) { if (String(d).toLowerCase() === n) found = d; }); return found; }
    function monthNumberFromLabel(label) { if (!label) return 0; var m = String(label).split(/[-\s]/)[0].toLowerCase(), a = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']; return a.indexOf(m.substring(0, 3)) + 1; }
    function destroyTables() { ['#tblHeadcountHorizontal', '#tblSalaryHorizontal', '#tblDeviationHorizontal', '#tblYearSummary', '#tblMonthTidy', '#tblEmployees'].forEach(function (id) { if ($.fn.DataTable.isDataTable(id)) $(id).DataTable().destroy(); $(id).empty(); }); }
    function destroyCharts() { $.each(reportCharts, function (_, c) { if (c && c.destroy) c.destroy(); }); reportCharts = {}; }
    function toggleLoader(show) { $('.grid-loader').css('display', show ? 'flex' : 'none'); }
    function deviation(data, type) { if (data === null || data === undefined || data === '') return type === 'display' ? '-' : -999999; var v = num(data); if (type !== 'display') return v; var cls = v > 0 ? 'dev-up' : v < 0 ? 'dev-down' : 'dev-flat'; return '<span class="' + cls + '">' + (v > 0 ? '+' : '') + v.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '%</span>'; }
    function money(data, type) { var v = num(data); return type === 'display' ? formatMoney(v) : v; }
    function compactMoney(v) { var n = Number(v || 0); if (Math.abs(n) >= 10000000) return (n / 10000000).toFixed(1) + ' Cr'; if (Math.abs(n) >= 100000) return (n / 100000).toFixed(1) + ' L'; if (Math.abs(n) >= 1000) return (n / 1000).toFixed(0) + ' K'; return n.toLocaleString('en-IN'); }
    function formatMoney(v) { return Number(v || 0).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
    function num(v) { var n = parseFloat(v); return isNaN(n) ? 0 : n; }
    function pad2(v) { return ('0' + v).slice(-2); }
    function html(v) { return $('<div/>').text(v == null ? '' : v).html(); }
</script>
</asp:Content>
