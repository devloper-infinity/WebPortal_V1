<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="VendorBillingGeneratePeriod.aspx.cs" Inherits="WebPortal.Vendor.VendorBillingGeneratePeriod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/DataTables/css/jquery.dataTables.min.css" />
    <style>
        .vb-page {
            padding: 15px;
        }

        .vb-panel {
            background: #fff;
            border: 1px solid #dfe5ec;
            border-radius: 6px;
            margin-bottom: 16px;
        }

        .vb-panel-title {
            padding: 12px 15px;
            font-size: 16px;
            font-weight: 600;
            border-bottom: 1px solid #e8edf2;
            background: #f8fafc;
        }

        .vb-panel-body {
            padding: 15px;
        }

        .vb-tabs {
            border-bottom: 1px solid #dfe5ec;
            margin-bottom: 16px;
        }

            .vb-tabs button {
                border: 0;
                background: transparent;
                padding: 11px 18px;
                font-weight: 600;
                color: #596675;
                border-bottom: 3px solid transparent;
            }

                .vb-tabs button.active {
                    color: #245f9e;
                    border-bottom-color: #245f9e;
                }

        .vb-tab {
            display: none;
        }

            .vb-tab.active {
                display: block;
            }

        .vb-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(220px, 320px));
            gap: 14px;
            align-items: end;
        }

        .vb-label {
            display: block;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .vb-control {
            width: 100%;
            height: 36px;
            padding: 6px 10px;
            border: 1px solid #cbd3dc;
            border-radius: 4px;
        }

        .vb-actions {
            margin-top: 15px;
        }

        .vb-btn {
            border: 0;
            border-radius: 4px;
            padding: 8px 18px;
            font-weight: 600;
            cursor: pointer;
        }

        .vb-btn-primary {
            color: #fff;
            background: #286aa6;
        }

        .vb-btn-light {
            color: #334155;
            background: #e9eef4;
        }

        .vb-message {
            display: none;
            padding: 10px 14px;
            border-radius: 4px;
            margin-bottom: 14px;
            font-weight: 600;
        }

            .vb-message.success {
                display: block;
                color: #22603a;
                background: #eaf7ef;
                border: 1px solid #bde1c9;
            }

            .vb-message.error {
                display: block;
                color: #8a2830;
                background: #fdecee;
                border: 1px solid #efc2c7;
            }

        .vb-summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(150px, 1fr));
            gap: 10px;
            margin-bottom: 15px;
        }

        .vb-summary-card {
            border: 1px solid #dde4ec;
            border-radius: 5px;
            padding: 11px;
            background: #fafcfe;
        }

        .vb-summary-label {
            font-size: 12px;
            color: #657383;
        }

        .vb-summary-value {
            font-size: 17px;
            font-weight: 700;
            margin-top: 3px;
        }

        .vb-table-wrap {
            position: relative;
            overflow: auto;
        }

        .vb-loader {
            display: none;
            position: absolute;
            inset: 0;
            z-index: 10;
            background: rgba(255,255,255,.72);
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }

            .vb-loader.show {
                display: flex;
            }

        table.dataTable thead th {
            white-space: nowrap;
        }

        table.dataTable tbody td {
            white-space: nowrap;
        }

        .vb-edit {
            border: 0;
            background: transparent;
            cursor: pointer;
            padding: 2px 6px;
        }

            .vb-edit img {
                width: 18px;
                height: 18px;
            }

        .erp-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 22px;
            margin-bottom: 16px;
            border-radius: 8px;
            background: linear-gradient(135deg,#123d68,#245f9e);
            color: #fff;
            box-shadow: 0 4px 12px rgba(15,50,85,.14);
        }

            .erp-hero h1 {
                margin: 0 0 5px;
                font-size: 23px;
                font-weight: 600;
                color: #fff;
            }

        .erp-breadcrumb {
            font-size: 13px;
            color: rgba(255,255,255,.82);
        }

            .erp-breadcrumb span {
                margin: 0 7px;
                color: rgba(255,255,255,.55);
            }

        .dataTables_wrapper {
            width: 100%;
            font-size: 13px;
        }

            .dataTables_wrapper .dataTables_filter {
                float: right;
                margin: 0 0 12px;
            }

                .dataTables_wrapper .dataTables_filter label {
                    font-weight: 600;
                    color: #475569;
                }

                .dataTables_wrapper .dataTables_filter input {
                    width: 220px;
                    height: 34px;
                    margin-left: 8px;
                    padding: 6px 10px;
                    border: 1px solid #cbd5e1;
                    border-radius: 5px;
                    outline: none;
                    background: #fff;
                }

                    .dataTables_wrapper .dataTables_filter input:focus {
                        border-color: #2f74b5;
                        box-shadow: 0 0 0 2px rgba(47,116,181,.12);
                    }

        .dataTables_scroll {
            clear: both;
            border: 1px solid #dbe3ec;
            border-radius: 6px;
            overflow: hidden;
        }

        .dataTables_scrollHead {
            background: #eef4f9 !important;
        }

        table.dataTable {
            margin: 0 !important;
            border-collapse: collapse !important;
            width: 100% !important;
        }

            table.dataTable thead th {
                padding: 11px 10px !important;
                background: #eaf1f7;
                color: #173b5f;
                font-weight: 700;
                border-right: 1px solid #d7e0e9;
                border-bottom: 1px solid #cbd5df !important;
                text-align: left;
            }

            table.dataTable tbody td {
                padding: 9px 10px !important;
                color: #334155;
                border-right: 1px solid #edf1f5;
                border-bottom: 1px solid #e8edf2;
                vertical-align: middle;
            }

            table.dataTable tbody tr:nth-child(even) {
                background: #f8fafc;
            }

            table.dataTable tbody tr:hover {
                background: #eef6fc;
            }

            table.dataTable.no-footer {
                border-bottom: 0 !important;
            }

        .dataTables_empty {
            padding: 24px !important;
            color: #64748b !important;
        }

        .dataTables_scrollBody {
            scrollbar-width: thin;
        }

        @media (max-width: 900px) {
            .vb-summary {
                grid-template-columns: repeat(2, minmax(140px, 1fr));
            }

            .vb-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="vb-page">
    <div class="erp-hero">
        <div>
            <h1>Generate Billing Period</h1>
            <div class="erp-breadcrumb">Vendor Billing <span>/</span> Generate Billing Period</div>
        </div>
    </div>

    <div id="messageBox" class="vb-message"></div>

    <div class="vb-tabs">
        <button type="button" class="active" data-tab="generateTab">Generate Billing Period</button>
        <button type="button" data-tab="pqaTab">PQA</button>
        <button type="button" data-tab="yqaTab">YQA</button>
    </div>

    <div id="generateTab" class="vb-tab active">
        <div class="vb-panel">
            <div class="vb-panel-title">Generate Billing Period</div>
            <div class="vb-panel-body">
                <div class="vb-form-grid">
                    <div>
                        <label class="vb-label" for="txtFromDate">From Date</label>
                        <input id="txtFromDate" type="text" class="vb-control" readonly="readonly" />
                    </div>
                    <div>
                        <label class="vb-label" for="txtToDate">To Date</label>
                        <input id="txtToDate" type="date" class="vb-control" />
                    </div>
                </div>
                <div class="vb-actions">
                    <button id="btnGenerate" type="button" class="vb-btn vb-btn-primary">Generate</button>
                    <button id="btnClear" type="button" class="vb-btn vb-btn-light">Clear</button>
                </div>
            </div>
        </div>

        <div class="vb-panel">
            <div class="vb-panel-title">Generated Periods &nbsp;|&nbsp; Total Count: <span id="periodCount">0</span></div>
            <div class="vb-panel-body vb-table-wrap">
                <div id="periodLoader" class="vb-loader">Loading...</div>
                <table id="periodTable" class="display nowrap" style="width:100%">
                    <thead><tr><th>Sr. #</th><th>From Date</th><th>To Date</th><th>Period Status</th><th>Added Date</th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="pqaTab" class="vb-tab">
        <div class="vb-panel">
            <div class="vb-panel-title">PQA Pending Billing Summary</div>
            <div class="vb-panel-body">
                <div class="vb-summary">
                    <div class="vb-summary-card"><div class="vb-summary-label">Invoice Period</div><div id="pqaPeriod" class="vb-summary-value">-</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Total Files</div><div id="pqaTotalFiles" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">No. of Projects</div><div id="pqaProjects" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Total Cost</div><div id="pqaTotalCost" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Amount Paid</div><div id="pqaAmountPaid" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Penalty Amount</div><div id="pqaPenalty" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Verified Files</div><div id="pqaVerified" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Unverified Files</div><div id="pqaUnverified" class="vb-summary-value">0</div></div>
                    <div class="vb-summary-card"><div class="vb-summary-label">Status</div><div id="pqaStatus" class="vb-summary-value">-</div></div>
                </div>
                <div class="vb-table-wrap">
                    <div id="pqaLoader" class="vb-loader">Loading...</div>
                    <div><strong>Total Count: <span id="pqaCount">0</span></strong></div><br />
                    <table id="pqaTable" class="display nowrap" style="width:100%">
                        <thead><tr><th>Sr. #</th><th>Vendor Code</th><th>Vendor Name</th><th>No. of Projects</th><th>Total Files</th><th>Verified Files</th><th>Unverified Files</th><th>Calculated Cost</th><th>Adjust/Penalty</th><th>Payable Amount</th><th>Status</th><th>Action</th></tr></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="yqaTab" class="vb-tab">
        <div class="vb-panel"><div class="vb-panel-title">YQA</div><div class="vb-panel-body">No YQA binding functions were present in the supplied code-behind.</div></div>
    </div>
</div>

<script src="../Scripts/jquery-3.6.0.min.js"></script>
<script src="../Scripts/DataTables/jquery.dataTables.min.js"></script>
<script type="text/javascript">
    var periodTable, pqaTable, currentInvoiceId = 0;

    $(function () {
        initTables();
        bindEvents();
        loadPage();
    });

    function initTables() {
        periodTable = $('#periodTable').DataTable({ paging: false, searching: true, info: false, ordering: true, scrollX: true, scrollY: '55vh', autoWidth: false });
        pqaTable = $('#pqaTable').DataTable({ paging: false, searching: true, info: false, ordering: true, scrollX: true, scrollY: '55vh', autoWidth: false, columnDefs: [{ orderable: false, targets: -1 }] });
    }

    function bindEvents() {
        $('.vb-tabs button').on('click', function () {
            $('.vb-tabs button').removeClass('active');
            $('.vb-tab').removeClass('active');
            $(this).addClass('active');
            $('#' + $(this).data('tab')).addClass('active');
            setTimeout(function () { periodTable.columns.adjust(); pqaTable.columns.adjust(); }, 100);
        });
        $('#btnGenerate').on('click', generatePeriod);
        $('#btnClear').on('click', function () { $('#txtToDate').val(''); hideMessage(); });
        $('#pqaTable tbody').on('click', '.js-edit', function () {
            var row = pqaTable.row($(this).closest('tr')).data();
            openProjectSummary(row);
        });
    }

    function loadPage() {
        showLoader('#periodLoader', true); showLoader('#pqaLoader', true);
        $.when(callPageMethod('GetInitialData', {})).done(function (response) {
            var result = unwrap(response);
            if (!result.Success) { showMessage(result.Message, false); return; }
            $('#txtFromDate').val(result.Data.FromDate || '');
            bindPeriods(result.Data.Periods || []);
            bindPqa(result.Data.PendingSummary, result.Data.PendingFiles || []);
            if (result.Data.ActiveTab === 'PQA') $('.vb-tabs button[data-tab="pqaTab"]').trigger('click');
            if (result.Data.ActiveTab === 'YQA') $('.vb-tabs button[data-tab="yqaTab"]').trigger('click');
        }).fail(showAjaxError).always(function () { showLoader('#periodLoader', false); showLoader('#pqaLoader', false); });
    }

    function generatePeriod() {
        var fromDate = $('#txtFromDate').val();
        var toDate = $('#txtToDate').val();
        if (!fromDate || !toDate) { showMessage('Please select the billing period dates.', false); return; }
        $('#btnGenerate').prop('disabled', true);
        callPageMethod('GeneratePeriod', { fromDate: fromDate, toDate: toDate }).done(function (response) {
            var result = unwrap(response);
            showMessage(result.Message, result.Success);
            if (result.Success) { $('#txtToDate').val(''); loadPage(); }
        }).fail(showAjaxError).always(function () { $('#btnGenerate').prop('disabled', false); });
    }

    function bindPeriods(rows) {
        periodTable.clear();
        $.each(rows, function (i, row) { periodTable.row.add([i + 1, val(row, 'FromDate'), val(row, 'ToDate'), val(row, 'PeriodStatus'), formatDotNetDateTime(val(row, 'AddedDate'))]); });
        periodTable.draw(false); $('#periodCount').text(rows.length);
    }
    function bindPqa(summary, rows) {
        summary = summary || {};
        rows = rows || [];

        currentInvoiceId = parseInt(summary.InvoiceId || 0, 10);

        $('#pqaPeriod').text(
            summary.FromDate && summary.ToDate
                ? formatDotNetDate(summary.FromDate) + ' ~ ' + formatDotNetDate(summary.ToDate)
                : '-'
        );

        $('#pqaTotalFiles').text(summary.TotalFiles || 0);
        $('#pqaProjects').text(summary.NoOfProject || 0);
        $('#pqaTotalCost').text(summary.TotalCost || 0);
        $('#pqaAmountPaid').text(summary.AmountPaid || 0);
        $('#pqaPenalty').text(summary.PenaltyAmount || 0);
        $('#pqaVerified').text(summary.VerifiedFiles || 0);
        $('#pqaUnverified').text(summary.PendingFiles || 0);
        $('#pqaStatus').text(summary.PeriodStatus || '-');

        pqaTable.clear();

        $.each(rows, function (i, row) {
            var vendorCode = val(row, 'VendorCode');
            var totalFiles = val(row, 'TotalFiles');
            var verifiedFiles = valAny(row, ['VarifiedFiles', 'VerifiedFiles']);
            var unverifiedFiles = valAny(row, ['UnVarifiedFiles', 'UnVerifiedFiles']);
            var status = val(row, 'Status');
            var totalCost = valAny(row, ['Total Cost', 'CalculatedCost']);

            var editButton =
                '<button type="button"' +
                ' class="vb-edit js-edit"' +
                ' title="Edit"' +
                ' data-vendor-code="' + escapeHtml(vendorCode) + '"' +
                ' data-total-files="' + escapeHtml(totalFiles) + '"' +
                ' data-verified-files="' + escapeHtml(verifiedFiles) + '"' +
                ' data-unverified-files="' + escapeHtml(unverifiedFiles) + '"' +
                ' data-status="' + escapeHtml(status) + '"' +
                ' data-total-cost="' + escapeHtml(totalCost) + '">' +
                '<i class="fa fa-edit"></i>' +
                '</button>';

            pqaTable.row.add([
                i + 1,
                vendorCode,
                val(row, 'VendorName'),
                valAny(row, ['NoOfProjects', 'NoOfProject']),
                totalFiles,
                verifiedFiles,
                unverifiedFiles,
                totalCost,
                valAny(row, ['Penalty Amount', 'Adjust/Penalty']),
                valAny(row, ['Amount Paid', 'PaybleAmount', 'PayableAmount']),
                status,
                editButton
            ]);
        });

        pqaTable.draw(false);
        $('#pqaCount').text(rows.length);
    }

    function openProjectSummary(row) {
        var url = '../Vendor/ProjectWiseSummary.aspx?' + $.param({ VendorCode: row[1], InvoiceId: currentInvoiceId, TotalFiles: row[4], VarifiedFiles: row[5], UnVarifiedFiles: row[6], Status: row[10], TotalCost: row[7] });
        window.location.href = url;
    }
    function formatDotNetDate(value) {

        if (!value) return '';

        if (value.indexOf('/Date(') === 0) {

            var ticks = parseInt(value.replace('/Date(', '').replace(')/', ''));

            var dt = new Date(ticks);

            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

            return ('0' + dt.getDate()).slice(-2) + '-' +
                months[dt.getMonth()] + '-' +
                dt.getFullYear();
        }

        return value;
    }

    function formatDotNetDateTime(value) {

        if (!value) return '';

        if (value.indexOf('/Date(') === 0) {

            var ticks = parseInt(value.replace('/Date(', '').replace(')/', ''));

            var dt = new Date(ticks);

            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

            var hh = ('0' + dt.getHours()).slice(-2);
            var mm = ('0' + dt.getMinutes()).slice(-2);

            return ('0' + dt.getDate()).slice(-2) + '-' +
                months[dt.getMonth()] + '-' +
                dt.getFullYear() + ' ' + hh + ':' + mm;
        }

        return value;
    }
    var pageUrl = '<%= ResolveUrl("VendorBillingGeneratePeriod.aspx") %>';
    function callPageMethod(method, data) { return $.ajax({ type: 'POST', url: pageUrl + '/' + method, data: JSON.stringify(data), contentType: 'application/json; charset=utf-8', dataType: 'json' }); }
    function unwrap(response) { return response && response.d ? response.d : response; }
    function val(row, key) { return row && row[key] != null ? row[key] : ''; }
    function valAny(row, keys) { for (var i = 0; i < keys.length; i++) if (row && row[keys[i]] != null) return row[keys[i]]; return ''; }
    function showLoader(selector, show) { $(selector).toggleClass('show', show); }
    function showMessage(text, success) { $('#messageBox').removeClass('success error').addClass(success ? 'success' : 'error').text(text).show(); setTimeout(hideMessage, 5000); }
    function hideMessage() { $('#messageBox').fadeOut(150); }
    function showAjaxError(xhr) { var message = 'Unable to complete the request.'; if (xhr.responseJSON && xhr.responseJSON.Message) message = xhr.responseJSON.Message; else if (xhr.responseText) { try { var x = JSON.parse(xhr.responseText); message = x.Message || message; } catch (e) { message = 'Request failed. HTTP ' + xhr.status + ' - ' + xhr.statusText; } } showMessage(message, false); }
</script>
</asp:Content>
