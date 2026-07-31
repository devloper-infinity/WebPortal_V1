<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="FeedbackPerformanceReport.aspx.cs" Inherits="WebPortal.Admin.FeedbackPerformanceReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   
    <style>
        body { background: #f4f6f9; color: #263238; }
        .report-page { padding: 18px; }
        .page-hero {
            background: linear-gradient(135deg, #1f4e78, #2f75b5);
            color: #fff; border-radius: 8px; padding: 18px 22px; margin-bottom: 16px;
            box-shadow: 0 4px 14px rgba(31, 78, 120, .18);
        }
        .page-hero h4 { margin: 0 0 4px; font-weight: 600; }
        .page-hero .breadcrumb-text { font-size: 12px; opacity: .88; }
        .erp-panel {
            background: #fff; border: 1px solid #dfe5eb; border-radius: 8px;
            margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0, 0, 0, .05);
        }
        .erp-panel-title {
            padding: 12px 16px; border-bottom: 1px solid #e7ebef; font-weight: 600;
            color: #1f4e78; background: #fbfcfd; border-radius: 8px 8px 0 0;
        }
        .erp-panel-body { padding: 16px; }
        label { font-size: 12px; font-weight: 600; color: #455a64; margin-bottom: 5px; }
        .btn-report { min-width: 125px; }
        .summary-card {
            border: 1px solid #e1e6eb; border-radius: 7px; padding: 12px 14px;
            background: #fff; height: 100%;
        }
        .summary-card .label { color: #78909c; font-size: 11px; text-transform: uppercase; }
        .summary-card .value { color: #1f4e78; font-size: 22px; font-weight: 700; line-height: 1.2; }
        .report-tabs { border-bottom: 1px solid #dee2e6; margin-bottom: 12px; }
        .report-tabs .nav-link { color: #546e7a; font-size: 13px; font-weight: 600; }
        .report-tabs .nav-link.active { color: #1f4e78; border-bottom: 3px solid #1f4e78; }
        .grid-wrapper { position: relative; min-height: 180px; }
        .grid-loader {
            display: none; position: absolute; inset: 0; z-index: 20; align-items: center;
            justify-content: center; background: rgba(255,255,255,.78); border-radius: 6px;
        }
        .grid-loader.show { display: flex; }
        .loader-box { text-align: center; color: #1f4e78; font-weight: 600; }
        .spinner {
            width: 34px; height: 34px; margin: 0 auto 8px; border: 4px solid #d9eaf7;
            border-top-color: #1f4e78; border-radius: 50%; animation: spin .8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        table.dataTable thead th { white-space: nowrap; background: #d9eaf7; color: #263238; }
        table.dataTable tbody td { vertical-align: middle; }
        .text-wrap { white-space: normal !important; min-width: 300px; }
        .error-message { display: none; margin-top: 12px; }
        .empty-state { padding: 35px; text-align: center; color: #78909c; }
        @media (max-width: 767px) { .report-page { padding: 10px; } .btn-report { width: 100%; margin-top: 7px; } }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="report-page">
        <div class="page-hero">
            <h4>Feedback Performance Report</h4>
            <div class="breadcrumb-text">Management Reports / Feedback Performance</div>
        </div>

        <div class="erp-panel">
            <div class="erp-panel-title">Report Filter</div>
            <div class="erp-panel-body">
                <div class="row align-items-end">
                    <div class="col-md-3">
                        <label for="txtMonth">Month</label>
                        <input type="month" id="txtMonth" class="form-control" />
                    </div>
                    <div class="col-md-9 mt-3 mt-md-0">
                        <button type="button" id="btnView" class="btn btn-primary btn-report">View Report</button>
                        <button type="button" id="btnDownload" class="btn btn-success btn-report ml-md-2">Download Excel</button>
                        <button type="button" id="btnClear" class="btn btn-light border btn-report ml-md-2">Clear</button>
                    </div>
                </div>
                <div id="errorMessage" class="alert alert-danger error-message"></div>
            </div>
        </div>

        <div id="reportSection" class="erp-panel" style="display:none;">
            <div class="erp-panel-title d-flex justify-content-between align-items-center">
                <span>Report Preview</span><span id="selectedPeriod" class="small text-muted"></span>
            </div>
            <div class="erp-panel-body">
                <div class="row mb-3">
                    <div class="col-md-3 mb-2"><div class="summary-card"><div class="label">Reviewers</div><div id="reviewerCount" class="value">0</div></div></div>
                    <div class="col-md-3 mb-2"><div class="summary-card"><div class="label">QCers</div><div id="qcerCount" class="value">0</div></div></div>
                    <div class="col-md-3 mb-2"><div class="summary-card"><div class="label">Reviewer Loans</div><div id="reviewerLoans" class="value">0</div></div></div>
                    <div class="col-md-3 mb-2"><div class="summary-card"><div class="label">QCed Loans</div><div id="qcerLoans" class="value">0</div></div></div>
                </div>

                <ul class="nav report-tabs" role="tablist">
                    <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#reviewerTab">Reviewer Performance</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#qcerTab">QCer Performance</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#reviewerExceptionTab">Reviewer Exceptions</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#qcerExceptionTab">QCer Exceptions</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#trendTab">Weekly Trend</a></li>
                </ul>

                <div class="grid-wrapper">
                    <div id="gridLoader" class="grid-loader"><div class="loader-box"><div class="spinner"></div>Loading report...</div></div>
                    <div class="tab-content">
                        <div id="reviewerTab" class="tab-pane fade show active"><table id="reviewerTable" class="table table-sm table-bordered table-striped w-100"><thead><tr></tr></thead><tbody></tbody></table></div>
                        <div id="qcerTab" class="tab-pane fade"><table id="qcerTable" class="table table-sm table-bordered table-striped w-100"><thead><tr></tr></thead><tbody></tbody></table></div>
                        <div id="reviewerExceptionTab" class="tab-pane fade"><table id="reviewerExceptionTable" class="table table-sm table-bordered table-striped w-100"><thead><tr></tr></thead><tbody></tbody></table></div>
                        <div id="qcerExceptionTab" class="tab-pane fade"><table id="qcerExceptionTable" class="table table-sm table-bordered table-striped w-100"><thead><tr></tr></thead><tbody></tbody></table></div>
                        <div id="trendTab" class="tab-pane fade"><table id="trendTable" class="table table-sm table-bordered table-striped w-100"><thead><tr></tr></thead><tbody></tbody></table></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../Scripts/jquery-3.5.1.min.js"></script>
    <script src="../Scripts/bootstrap.bundle.min.js"></script>
    <script src="../Scripts/jquery.dataTables.min.js"></script>
    <script src="../Scripts/dataTables.bootstrap4.min.js"></script>
    <script src="../Scripts/dataTables.fixedHeader.min.js"></script>

    <script>
        var reportTables = {};

        $(function () {
            $('#txtMonth').val(getPreviousMonth());
            $('#btnView').on('click', loadReport);
            $('#btnDownload').on('click', downloadReport);
            $('#btnClear').on('click', clearReport);
            $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
                $.each(reportTables, function (_, table) { if (table) table.columns.adjust(); });
            });
        });

        function getPreviousMonth() {
            var d = new Date();
            d.setDate(1); d.setMonth(d.getMonth() - 1);
            return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0');
        }

        function validateMonth() {
            var month = $('#txtMonth').val();
            if (!/^\d{4}-\d{2}$/.test(month)) {
                showError('Please select a valid month.');
                return null;
            }
            hideError();
            return month;
        }

        function loadReport() {
            var month = validateMonth();
            if (!month) return;
            $('#reportSection').show();
            toggleLoader(true);
            setButtonsDisabled(true);

            $.ajax({
                type: 'POST',
                url: 'FeedbackPerformanceReport.aspx/GetReportPreview',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({ month: month }),
                success: function (response) {
                    var result = response.d;
                    if (!result || !result.Success) {
                        showError(result && result.Message ? result.Message : 'Unable to load report.');
                        return;
                    }
                    bindReport(result.Data);
                },
                error: function (xhr) {
                    showError(getAjaxError(xhr));
                },
                complete: function () {
                    toggleLoader(false);
                    setButtonsDisabled(false);
                }
            });
        }

        function bindReport(data) {
            $('#selectedPeriod').text(data.Period || '');
            $('#reviewerCount').text((data.ReviewerPerformance || []).length);
            $('#qcerCount').text((data.QCerPerformance || []).length);
            $('#reviewerLoans').text(sumColumn(data.ReviewerPerformance, 'LoanCount'));
            $('#qcerLoans').text(sumColumn(data.QCerPerformance, 'LoanCount'));

            bindDataTable('reviewerTable', data.ReviewerPerformance || []);
            bindDataTable('qcerTable', data.QCerPerformance || []);
            bindDataTable('reviewerExceptionTable', data.ReviewerExceptions || [], ['FeedbackSummary']);
            bindDataTable('qcerExceptionTable', data.QCerExceptions || [], ['FeedbackSummary']);
            bindDataTable('trendTable', data.WeeklyTrend || []);
        }

        function bindDataTable(tableId, rows, wrapColumns) {
            if (reportTables[tableId]) {
                reportTables[tableId].destroy();
                reportTables[tableId] = null;
            }

            var $table = $('#' + tableId);
            var columns = [];
            $.each(rows, function (_, row) {
                $.each(row, function (key) {
                    if ($.inArray(key, columns) === -1) columns.push(key);
                });
            });

            var $head = $table.find('thead tr').empty();
            var $body = $table.find('tbody').empty();
            if (!columns.length) {
                $head.append('<th>Result</th>');
                $body.append('<tr><td class="empty-state">No records found for the selected month.</td></tr>');
            } else {
                $.each(columns, function (_, col) { $head.append($('<th/>').text(formatHeader(col))); });
                $.each(rows, function (_, row) {
                    var $tr = $('<tr/>');
                    $.each(columns, function (_, col) {
                        var value = row[col] === null || row[col] === undefined ? '' : row[col];
                        var $td = $('<td/>').text(value);
                        if ($.inArray(col, wrapColumns || []) !== -1) $td.addClass('text-wrap');
                        $tr.append($td);
                    });
                    $body.append($tr);
                });
            }

            reportTables[tableId] = $table.DataTable({
                paging: false,
                searching: true,
                info: true,
                ordering: true,
                scrollX: true,
                scrollY: '55vh',
                scrollCollapse: true,
                fixedHeader: true,
                autoWidth: false,
                destroy: true
            });
        }

        function formatHeader(value) {
            return value.replace(/([a-z0-9])([A-Z])/g, '$1 $2').replace(/_/g, ' ');
        }

        function sumColumn(rows, column) {
            var total = 0;
            $.each(rows || [], function (_, row) { total += parseInt(row[column] || 0, 10); });
            return total;
        }

        function downloadReport() {
            var month = validateMonth();
            if (!month) return;
            window.location.href = 'FeedbackPerformanceReport.aspx?action=download&month=' + encodeURIComponent(month);
        }

        function clearReport() {
            $('#txtMonth').val('');
            $('#reportSection').hide();
            hideError();
            $.each(reportTables, function (key, table) { if (table) table.destroy(); reportTables[key] = null; });
        }

        function setButtonsDisabled(disabled) { $('#btnView, #btnDownload, #btnClear').prop('disabled', disabled); }
        function toggleLoader(show) { $('#gridLoader').toggleClass('show', show); }
        function hideError() { $('#errorMessage').hide().text(''); }
        function showError(message) { $('#errorMessage').text(message).show(); }
        function getAjaxError(xhr) {
            try { return JSON.parse(xhr.responseText).Message || 'Unable to load report.'; }
            catch (e) { return 'Unable to load report. Please try again.'; }
        }
    </script>


</asp:Content>

