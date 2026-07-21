<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="~/Accounts/SalaryReport_DepartmentWise.aspx.cs" Inherits="WebPortal.Reports.SalaryReport" MasterPageFile="~/Accounts/Accounts.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../Content/DataTables/css/fixedHeader.dataTables.min.css" rel="stylesheet" />
    <link href="../Content/DataTables/css/fixedColumns.dataTables.min.css" rel="stylesheet" />
    <style>
        .salary-page { padding: 12px 15px 25px; }
        .page-hero { background: #fff; border-left: 4px solid #5a78a8; border-radius: 6px; padding: 14px 18px; margin-bottom: 14px; box-shadow: 0 1px 5px rgba(0,0,0,.08); }
        .page-hero h3 { margin: 0; color: #27364b; font-size: 21px; font-weight: 600; }
        .page-hero small { color: #7b8797; }
        .erp-panel { background: #fff; border: 1px solid #e4e8ee; border-radius: 7px; margin-bottom: 15px; box-shadow: 0 1px 4px rgba(0,0,0,.05); }
        .erp-panel-title { padding: 11px 15px; border-bottom: 1px solid #e8ebef; font-weight: 600; color: #33445c; background: #f8fafc; border-radius: 7px 7px 0 0; }
        .erp-panel-body { padding: 15px; }
        .form-label { display:block; font-size: 12px; font-weight: 600; color:#536174; margin-bottom:5px; }
        .btn-report { background:#5a78a8; color:#fff; border-color:#5a78a8; min-width:100px; }
        .btn-report:hover { color:#fff; background:#49678f; }
        .summary-card { border:1px solid #e4e8ee; border-radius:6px; padding:13px 15px; background:#fbfcfe; }
        .summary-card span { display:block; color:#778397; font-size:12px; }
        .summary-card strong { color:#2e4057; font-size:19px; }
        .grid-wrapper { position:relative; min-height:130px; width:100%; overflow:hidden; }
        .grid-loader { display:none; position:absolute; inset:0; z-index:20; background:rgba(255,255,255,.75); align-items:center; justify-content:center; }
        .grid-loader div { background:#fff; border:1px solid #dfe4ea; border-radius:5px; padding:10px 16px; box-shadow:0 2px 10px rgba(0,0,0,.08); }
        table.dataTable thead th { white-space:nowrap; background:#eef2f7; color:#35455c; font-size:12px; }
        table.dataTable tbody td { white-space:nowrap; font-size:12px; }
        .amount { text-align:right; }
        .month-head { text-align:center !important; }
        .month-subhead { min-width:105px; }
        @media (max-width: 767px) { .filter-action { margin-top: 10px; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="salary-page">
    <div class="page-hero">
        <h3>Salary Summary Report</h3>
        <small>Year-wise and month-wise gross salary, deviation and employee details</small>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Report Filters</div>
        <div class="erp-panel-body">
            <div class="row align-items-end">
                <div class="col-md-3">
                    <label class="form-label">From Month-Year</label>
                    <input type="month" id="txtFromMonth" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">To Month-Year</label>
                    <input type="month" id="txtToMonth" class="form-control" />
                </div>
                <div class="col-md-4 filter-action">
                    <button type="button" id="btnSearch" class="btn btn-report">Submit</button>
                    <button type="button" id="btnClear" class="btn btn-light border ml-1">Clear</button>
                    <button type="button" id="btnExport" class="btn btn-success ml-1">Export Excel</button>
                </div>
            </div>
        </div>
    </div>

    <div class="row" id="totalsRow" style="display:none;">
        <div class="col-md-4 mb-3"><div class="summary-card"><span>Employee Count</span><strong id="lblEmployeeCount">0</strong></div></div>
        <div class="col-md-4 mb-3"><div class="summary-card"><span>Total Gross Salary</span><strong id="lblGross">0.00</strong></div></div>
        <div class="col-md-4 mb-3"><div class="summary-card"><span>Department Count</span><strong id="lblDepartmentCount">0</strong></div></div>
    </div>


    <div class="erp-panel">
        <div class="erp-panel-title">Year-wise Gross Salary Summary</div>
        <div class="erp-panel-body">
            <div class="grid-wrapper">
                <div class="grid-loader"><div>Loading gross salary summary...</div></div>
                <table id="tblGrossYearSummary" class="display nowrap table table-bordered table-sm" style="width:100%"></table>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Year-wise Gross Salary Summary with Employee Count</div>
        <div class="erp-panel-body">
            <div class="grid-wrapper">
                <div class="grid-loader"><div>Loading salary summary...</div></div>
                <table id="tblYearSummary" class="display nowrap table table-bordered table-sm" style="width:100%"></table>
            </div>
        </div>
    </div>
<div class="erp-panel">
        <div class="erp-panel-title">Month and Year-wise Gross Salary Details</div>
        <div class="erp-panel-body">
            <div class="grid-wrapper">
                <div class="grid-loader"><div>Loading month-wise details...</div></div>
                <table id="tblMonthDetails" class="display nowrap table table-bordered table-sm" style="width:100%"></table>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Employee Details</div>
        <div class="erp-panel-body">
            <div class="grid-wrapper">
                <div class="grid-loader"><div>Loading employee details...</div></div>
                <table id="tblEmployees" class="display nowrap table table-bordered table-sm" style="width:100%"></table>
            </div>
        </div>
    </div>
</div>

<script src="../Scripts/jquery-3.6.0.min.js"></script>
<script src="../Scripts/DataTables/jquery.dataTables.min.js"></script>
<script src="../Scripts/DataTables/dataTables.fixedHeader.min.js"></script>
<script src="../Scripts/DataTables/dataTables.fixedColumns.min.js"></script>
<script>
    var grossYearTable, yearTable, monthTable, employeeTable;

    $(function () {
        setDefaultMonths();
        $('#btnSearch').on('click', loadReport);
        $('#btnExport').on('click', exportReport);
        $('#btnClear').on('click', function () {
            setDefaultMonths();
            destroyTables();
            $('#totalsRow').hide();
        });
        //loadReport();
    });

    function setDefaultMonths() {
        var now = new Date();
        var to = now.getFullYear() + '-' + pad2(now.getMonth() + 1);
        var fromDate = new Date(now.getFullYear() - 1, now.getMonth(), 1);
        var from = fromDate.getFullYear() + '-' + pad2(fromDate.getMonth() + 1);
        $('#txtFromMonth').val(from);
        $('#txtToMonth').val(to);
    }


    function exportReport() {
        var from = $('#txtFromMonth').val();
        var to = $('#txtToMonth').val();
        if (!from || !to) { alert('Please select From Month-Year and To Month-Year.'); return; }
        if (from > to) { alert('From Month-Year cannot be greater than To Month-Year.'); return; }

        var fp = from.split('-'), tp = to.split('-');
        var url = 'SalaryReport_DepartmentWise.aspx?export=1'
            + '&fromMonth=' + encodeURIComponent(fp[1])
            + '&fromYear=' + encodeURIComponent(fp[0])
            + '&toMonth=' + encodeURIComponent(tp[1])
            + '&toYear=' + encodeURIComponent(tp[0]);
        window.location.href = url;
    }

    function loadReport() {
        var from = $('#txtFromMonth').val();
        var to = $('#txtToMonth').val();
        if (!from || !to) { alert('Please select From Month-Year and To Month-Year.'); return; }
        if (from > to) { alert('From Month-Year cannot be greater than To Month-Year.'); return; }

        var fp = from.split('-'), tp = to.split('-');
        toggleLoader(true);
        $.ajax({
            type: 'POST',
            url: 'SalaryReport_DepartmentWise.aspx/GetSalaryReport',
            data: JSON.stringify({ fromMonth: +fp[1], fromYear: +fp[0], toMonth: +tp[1], toYear: +tp[0] }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var result = response.d;
                if (!result.Success) { alert(result.Message); return; }
                var employeeRows = result.EmployeeDetails || [];
                bindGrossYearSummary(result.YearSummary || [], employeeRows);
                bindYearSummary(result.YearSummary || [], employeeRows);
                bindMonthDetails(result.MonthDetails || [], employeeRows);
                bindEmployees(employeeRows);
                bindCards(result.YearSummary || [], employeeRows);
            },
            error: function (xhr) {
                var message = 'Unable to load report.';
                if (xhr.responseJSON && xhr.responseJSON.Message) message += '\n' + xhr.responseJSON.Message;
                alert(message);
            },
            complete: function () { toggleLoader(false); }
        });
    }


    function bindGrossYearSummary(rows, employeeRows) {
        if ($.fn.DataTable.isDataTable('#tblGrossYearSummary')) $('#tblGrossYearSummary').DataTable().destroy();
        $('#tblGrossYearSummary').empty();
        if (!rows.length) {
            $('#tblGrossYearSummary').html('<thead><tr><th>No data available</th></tr></thead><tbody></tbody>');
            return;
        }

        var years = rows.slice().sort(function (a, b) { return num(b.Year) - num(a.Year); });
        var departments = getDepartmentsFromYearRows(years);
        var countMap = buildYearEmployeeCountMap(employeeRows);
        var row1 = '<tr>', row2 = '<tr>', row3 = '<tr>';
        var columns = [], dataRow = {};

        $.each(years, function (yearIndex, row) {
            var currentYear = row.Year;
            var previous = yearIndex < years.length - 1 ? years[yearIndex + 1] : null;
            row1 += '<th colspan="' + (departments.length * 3) + '" class="month-head">' + html(currentYear) + '</th>';

            $.each(departments, function (_, department) {
                row2 += '<th colspan="3" class="month-head">' + html(department) + '</th>';
                row3 += '<th class="month-subhead">Employee Count</th><th class="month-subhead">Gross</th><th class="month-subhead">Gross Dev %</th>';

                var key = currentYear + '||' + department;
                var gross = num(row[department + ' - Gross']);
                var previousGross = previous ? num(previous[department + ' - Gross']) : 0;

                dataRow[key + '||Count'] = getCount(countMap, currentYear, department);
                dataRow[key + '||Gross'] = gross;
                dataRow[key + '||GrossDev'] = previous && previousGross !== 0
                    ? ((gross - previousGross) / previousGross) * 100
                    : null;

                columns.push({ data: key + '||Count', defaultContent: 0, className: 'amount' });
                columns.push({ data: key + '||Gross', defaultContent: 0, render: money, className: 'amount' });
                columns.push({ data: key + '||GrossDev', defaultContent: null, render: percentage, className: 'amount' });
            });
        });

        $('#tblGrossYearSummary').html('<thead>' + row1 + '</tr>' + row2 + '</tr>' + row3 + '</tr></thead><tbody></tbody>');
        grossYearTable = $('#tblGrossYearSummary').DataTable({
            data: [dataRow], columns: columns, paging: false, searching: false, info: false, ordering: false,
            scrollX: true, scrollY: '260px', scrollCollapse: true, fixedHeader: true
        });
    }

    function bindYearSummary(rows, employeeRows) {
        if ($.fn.DataTable.isDataTable('#tblYearSummary')) $('#tblYearSummary').DataTable().destroy();
        $('#tblYearSummary').empty();
        if (!rows.length) {
            $('#tblYearSummary').html('<thead><tr><th>No data available</th></tr></thead><tbody></tbody>');
            return;
        }
        var years = rows.slice().sort(function (a, b) { return num(b.Year) - num(a.Year); });
        var departments = getDepartmentsFromYearRows(years);
        var countMap = buildYearEmployeeCountMap(employeeRows);
        var row1 = '<tr>', row2 = '<tr>', row3 = '<tr>';
        var columns = [], dataRow = {};
        $.each(years, function (yearIndex, row) {
            var currentYear = row.Year;
            var previous = yearIndex < years.length - 1 ? years[yearIndex + 1] : null;
            row1 += '<th colspan="' + (departments.length * 3) + '" class="month-head">' + html(currentYear) + '</th>';
            $.each(departments, function (_, department) {
                row2 += '<th colspan="3" class="month-head">' + html(department) + '</th>';
                row3 += '<th class="month-subhead">Employee Count</th><th class="month-subhead">Gross</th><th class="month-subhead">Gross Dev %</th>';
                var key = currentYear + '||' + department;
                var gross = num(row[department + ' - Gross']);
                var previousGross = previous ? num(previous[department + ' - Gross']) : 0;
                dataRow[key + '||Count'] = getCount(countMap, currentYear, department);
                dataRow[key + '||Gross'] = gross;
                dataRow[key + '||GrossDev'] = previous && previousGross !== 0 ? ((gross - previousGross) / previousGross) * 100 : null;
                columns.push({ data: key + '||Count', defaultContent: 0, className: 'amount' });
                columns.push({ data: key + '||Gross', defaultContent: 0, render: money, className: 'amount' });
                columns.push({ data: key + '||GrossDev', defaultContent: null, render: percentage, className: 'amount' });
            });
        });
        $('#tblYearSummary').html('<thead>' + row1 + '</tr>' + row2 + '</tr>' + row3 + '</tr></thead><tbody></tbody>');
        yearTable = $('#tblYearSummary').DataTable({ data: [dataRow], columns: columns, paging: false, searching: false, info: false, ordering: false, scrollX: true, fixedHeader: true });
    }

    function buildYearEmployeeCountMap(rows) {
        var map = {};
        $.each(rows || [], function (_, r) {
            var year = String(r.Year || '');
            var department = String(r.Department || '');
            var employee = String(r.Code || r.EmployeeID || r.Name || '');
            if (!year || !department || !employee) return;
            var key = year + '||' + department;
            if (!map[key]) map[key] = {};
            map[key][employee] = true;
        });
        return map;
    }

    function getCount(map, period, department) {
        var set = map[String(period) + '||' + String(department)];
        return set ? Object.keys(set).length : 0;
    }

    function getDepartmentsFromYearRows(rows) {
        var departments = [];
        $.each(rows, function (_, row) {
            $.each(row, function (key) {
                var match = key.match(/^(.*) - Gross$/);
                if (match && departments.indexOf(match[1]) < 0) departments.push(match[1]);
            });
        });
        departments.sort();
        return departments;
    }


    function bindMonthDetails(rows, employeeRows) {
        if ($.fn.DataTable.isDataTable('#tblMonthDetails')) $('#tblMonthDetails').DataTable().destroy();
        $('#tblMonthDetails').empty();
        if (!rows.length) {
            $('#tblMonthDetails').html('<thead><tr><th>No data available</th></tr></thead><tbody></tbody>');
            return;
        }
        var periods = [], departments = [], values = {};
        $.each(rows, function (_, r) {
            var month = num(r.MonthNumber || r.MonthNo || r.Month);
            if (!month) month = monthNumberFromLabel(r.MonthYear);
            var period = { key: num(r.Year) * 100 + month, label: r.MonthYear };
            if (!values[period.key]) { values[period.key] = { departments: {} }; periods.push(period); }
            if (departments.indexOf(r.Department) < 0) departments.push(r.Department);
            values[period.key].departments[r.Department] = { gross: num(r.GrossSalary) };
        });
        periods.sort(function (a, b) { return b.key - a.key; });
        departments.sort();
        var countMap = buildMonthEmployeeCountMap(employeeRows);
        var row1 = '<tr>', row2 = '<tr>', row3 = '<tr>';
        var columns = [], dataRow = {};
        $.each(periods, function (periodIndex, period) {
            var current = values[period.key];
            var previous = periodIndex < periods.length - 1 ? values[periods[periodIndex + 1].key] : null;
            row1 += '<th colspan="' + (departments.length * 3) + '" class="month-head">' + html(period.label) + '</th>';
            $.each(departments, function (_, department) {
                row2 += '<th colspan="3" class="month-head">' + html(department) + '</th>';
                row3 += '<th class="month-subhead">Employee Count</th><th class="month-subhead">Gross</th><th class="month-subhead">Gross Dev %</th>';
                var currentValue = current.departments[department] || { gross: 0 };
                var previousValue = previous ? (previous.departments[department] || { gross: 0 }) : null;
                var key = period.key + '||' + department;
                dataRow[key + '||Count'] = getCount(countMap, period.key, department);
                dataRow[key + '||Gross'] = currentValue.gross;
                dataRow[key + '||GrossDev'] = previousValue && previousValue.gross !== 0 ? ((currentValue.gross - previousValue.gross) / previousValue.gross) * 100 : null;
                columns.push({ data: key + '||Count', defaultContent: 0, className: 'amount' });
                columns.push({ data: key + '||Gross', defaultContent: 0, render: money, className: 'amount' });
                columns.push({ data: key + '||GrossDev', defaultContent: null, render: percentage, className: 'amount' });
            });
        });
        $('#tblMonthDetails').html('<thead>' + row1 + '</tr>' + row2 + '</tr>' + row3 + '</tr></thead><tbody></tbody>');
        monthTable = $('#tblMonthDetails').DataTable({ data: [dataRow], columns: columns, paging: false, searching: false, info: false, ordering: false, scrollX: true, fixedHeader: true });
    }

    function buildMonthEmployeeCountMap(rows) {
        var map = {};
        $.each(rows || [], function (_, r) {
            var month = num(r.MonthNumber || r.MonthNo || r.Month);
            if (!month) month = monthNumberFromLabel(r.MonthYear || r.Month);
            var periodKey = num(r.Year) * 100 + month;
            var department = String(r.Department || '');
            var employee = String(r.Code || r.EmployeeID || r.Name || '');
            if (!periodKey || !department || !employee) return;
            var key = periodKey + '||' + department;
            if (!map[key]) map[key] = {};
            map[key][employee] = true;
        });
        return map;
    }

    function monthNumberFromLabel(label) {
        if (!label) return 0;
        var monthName = String(label).split(/[-\s]/)[0].toLowerCase();
        var names = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];
        var index = names.indexOf(monthName);
        if (index < 0) index = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'].indexOf(monthName.substring(0, 3));
        return index + 1;
    }

    function bindEmployees(rows) {
        if ($.fn.DataTable.isDataTable('#tblEmployees')) $('#tblEmployees').DataTable().destroy();
        $('#tblEmployees').empty();

        var fields = rows.length ? Object.keys(rows[0]) : [
            'Month', 'Year', 'Department', 'Code', 'Name', 'Pseudoname', 'Gross Salary', 'Net Salary', 'Joining Date', 'Branch',
            'Domain', 'Subdomain', 'Designation', 'OfficialEmailID', 'Reporting Manager', 'Tenure', 'Segment', 'Current Status',
            'Resignation Date', 'Last Working Date', 'Remark', 'Latest Login Date', 'DailyTaskProductivity'
        ];

        var columns = $.map(fields, function (f) {
            var isAmount = f === 'Gross Salary' || f === 'Net Salary';
            return {
                title: f,
                data: f,
                defaultContent: '',
                render: isAmount ? money : function (d) { return html(d); },
                className: isAmount ? 'amount' : ''
            };
        });

        employeeTable = $('#tblEmployees').DataTable({
            data: rows,
            columns: columns,
            paging: false,
            info: true,
            searching: true,
            scrollX: true,
            scrollY: '60vh',
            scrollCollapse: true,
            fixedHeader: true,
            fixedColumns: { leftColumns: 3 },
            order: [[1, 'asc'], [0, 'asc'], [2, 'asc'], [3, 'asc']]
        });
    }

    function bindCards(yearRows, employeeRows) {
        var gross = 0, employees = {}, departments = {};
        $.each(yearRows, function (_, row) {
            $.each(row, function (key, value) {
                if (/ - Gross$/.test(key)) {
                    gross += num(value);
                    departments[key.replace(/ - Gross$/, '')] = true;
                }
            });
        });
        $.each(employeeRows || [], function (_, row) {
            var employee = String(row.Code || row.EmployeeID || row.Name || '');
            if (employee) employees[employee] = true;
        });
        $('#lblEmployeeCount').text(Object.keys(employees).length.toLocaleString('en-IN'));
        $('#lblGross').text(formatMoney(gross));
        $('#lblDepartmentCount').text(Object.keys(departments).length.toLocaleString('en-IN'));
        $('#totalsRow').show();
    }

    function destroyTables() {
        ['#tblGrossYearSummary', '#tblYearSummary', '#tblMonthDetails', '#tblEmployees'].forEach(function (id) {
            if ($.fn.DataTable.isDataTable(id)) $(id).DataTable().destroy();
            $(id + ' tbody').empty();
        });
    }
    function toggleLoader(show) { $('.grid-loader').css('display', show ? 'flex' : 'none'); }
    function percentage(data, type) {
        if (data === null || data === undefined || data === '') return type === 'display' ? '-' : 0;
        var value = num(data);
        return type === 'display' ? value.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '%' : value;
    }

    function money(data, type) { var v = num(data); return type === 'display' ? formatMoney(v) : v; }
    function formatMoney(v) { return Number(v || 0).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
    function num(v) { var n = parseFloat(v); return isNaN(n) ? 0 : n; }
    function pad2(v) { return ('0' + v).slice(-2); }
    function html(v) { return $('<div/>').text(v == null ? '' : v).html(); }
</script>
</asp:Content>
