<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEBilling.aspx.cs" Inherits="WebPortal.FTE.FTEBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --billing-blue: #1d4ed8;
            --billing-cyan: #0ea5b7;
            --billing-ink: #10233f;
            --billing-muted: #69778d;
            --billing-border: #dbe5f3;
            --billing-soft: #f6f9fd;
        }

        #load1.billing-loading {
            display: none !important;
            position: fixed !important;
            top: 0 !important;
            right: 0 !important;
            bottom: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            margin: 0 !important;
            transform: none !important;
            z-index: 999999 !important;
            background: rgba(248, 250, 252, .72);
            opacity: 1 !important;
        }

        #load1.billing-loading.is-visible {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
        }

        #load1.billing-loading .loading-inner {
            position: relative !important;
            top: auto !important;
            left: auto !important;
            width: 220px;
            min-height: 130px;
            padding: 22px;
            transform: none !important;
            border: 1px solid var(--billing-border);
            border-radius: 8px;
            background: #fff;
            text-align: center;
            box-shadow: 0 20px 48px rgba(15, 23, 42, .18);
        }

        #load1.billing-loading .loading-inner img {
            width: 52px;
            height: 52px;
        }

        #load1.billing-loading .loading-text {
            margin-top: 12px;
            color: var(--billing-ink);
            font-size: 13px;
            font-weight: 800;
        }

        .billing-page {
            padding: 0px 0 28px;
        }

        .billing-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 16px;
            padding: 20px 22px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(120deg, var(--billing-blue) 0%, var(--billing-cyan) 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .billing-hero h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 850;
            letter-spacing: 0;
        }

        .billing-hero p {
            margin: 5px 0 0;
            color: rgba(255,255,255,.85);
            font-size: 13px;
        }

        .billing-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 12px;
            border: 1px solid rgba(255,255,255,.32);
            border-radius: 999px;
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
        }

        .billing-panel {
            margin-bottom: 16px;
            border: 1px solid var(--billing-border);
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .08);
        }

        .billing-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid #e7eef8;
        }

        .billing-panel-header h2 {
            margin: 0;
            color: var(--billing-ink);
            font-size: 15px;
            font-weight: 850;
        }

        .billing-panel-body {
            padding: 16px;
        }

        .billing-form {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px 16px;
        }

        .billing-field label {
            display: block;
            margin: 0 0 6px;
            color: #273b60;
            font-size: 13px;
            font-weight: 800 !important;
        }

        .billing-field textarea {
            min-height: 38px;
            resize: vertical;
        }

        .billing-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 16px;
        }

        .billing-actions .btn {
            min-width: 106px;
            font-weight: 800;
        }

        .billing-metrics {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .billing-metric {
            min-height: 80px;
            padding: 13px 15px;
            border: 1px solid var(--billing-border);
            border-radius: 8px;
            background: #fff;
        }

        .billing-metric span {
            display: block;
            color: #77849a;
            font-size: 11px;
            font-weight: 850;
            letter-spacing: .04em;
            text-transform: uppercase;
        }

        .billing-metric strong {
            display: block;
            margin-top: 8px;
            color: var(--billing-ink);
            font-size: 22px;
            font-weight: 900;
            line-height: 1;
            word-break: break-word;
        }

        .billing-table-wrap {
            overflow-x: auto;
        }

        #tableFteBilling {
            width: 100% !important;
            margin: 0 !important;
        }

        #tableFteBilling thead th {
            border-bottom: 1px solid #cdd9ea;
            background: linear-gradient(to bottom, #f9fbfe, #edf4fc);
            color: #0f2d56;
            font-size: 12px;
            font-weight: 850;
            white-space: nowrap;
        }

        #tableFteBilling tbody td {
            color: #1f2f48;
            font-size: 12px;
            vertical-align: middle;
            white-space: nowrap;
        }

        .dataTables_wrapper {
            width: 100%;
        }

        .dataTables_wrapper .dt-buttons .btn {
            margin: 0 4px 8px;
            border: 1px solid #d9e4f2;
            border-radius: 6px;
            background: #fff;
            color: #16345f;
            font-weight: 800;
            box-shadow: 0 5px 14px rgba(15, 23, 42, .08);
        }



        .extra-fte-note {
            display: none;
            margin-top: 10px;
            color: #7a4a00;
            font-size: 12px;
            font-weight: 800;
        }

        .extra-fte-modal {
            display: none;
            position: fixed;
            z-index: 99999;
            inset: 0;
            background: rgba(15, 23, 42, .45);
            align-items: center;
            justify-content: center;
            padding: 18px;
        }

        .extra-fte-modal.is-visible {
            display: flex;
        }

        .extra-fte-dialog {
            width: min(980px, 96vw);
            max-height: 88vh;
            overflow: hidden;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 22px 60px rgba(15, 23, 42, .25);
        }

        .extra-fte-dialog-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 16px;
            border-bottom: 1px solid #e7eef8;
            background: linear-gradient(to bottom, #f9fbfe, #edf4fc);
        }

        .extra-fte-dialog-header h3 {
            margin: 0;
            color: var(--billing-ink);
            font-size: 15px;
            font-weight: 900;
        }

        .extra-fte-dialog-body {
            max-height: calc(88vh - 58px);
            overflow: auto;
            padding: 16px;
        }

        .extra-fte-grid {
            display: grid;
            grid-template-columns: 1.4fr .7fr .7fr auto;
            gap: 12px;
            align-items: end;
            margin-bottom: 14px;
        }

        #tableExtraFteEntry th {
            background: linear-gradient(to bottom, #f9fbfe, #edf4fc);
            color: #0f2d56;
            font-size: 12px;
            font-weight: 850;
        }

        #tableExtraFteEntry td {
            font-size: 12px;
            vertical-align: middle;
        }

        @media (max-width: 780px) {
            .extra-fte-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 1050px) {
            .billing-form,
            .billing-metrics {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            .billing-form,
            .billing-metrics {
                grid-template-columns: 1fr;
            }

            .billing-hero,
            .billing-panel-header,
            .billing-actions {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            BindBillingProject();
            initializeFteBillingTable([]);
        });

        function selectedExtraFteProjectText() {
            return ($('#fte_billingProject option:selected').text() || '').toLowerCase();
        }

        function isExtraFteProject() {
            // Required only for project 791-001. Change/extend this check if your ProjectID is different.
            return selectedExtraFteProjectText().indexOf('791-001') >= 0;
        }

        function toggleExtraFteButton() {
            var show = isExtraFteProject();
            $('#btnManageExtraFte').toggle(show);
            $('#extraFteNote').toggle(show);
        }

        function getCurrentBillingPeriod() {
            return $('#fte_BillingPeriod').val() || 'Select';
        }

        function openExtraFteDialog() {
            if (!isExtraFteProject()) {
                showBillingMessage('Extra FTE entry is available only for project 791-001.', 'warning');
                return false;
            }

            if ($('#fte_billingProject').val() === 'Select' || getCurrentBillingPeriod() === 'Select') {
                showBillingMessage('Please select project and billing period first.', 'warning');
                return false;
            }

            populateExtraFteDates();
            loadExtraFteRows();
            $('#extraFteModal').addClass('is-visible');
            return false;
        }

        function closeExtraFteDialog() {
            $('#extraFteModal').removeClass('is-visible');
            return false;
        }

        function populateExtraFteDates() {
            var $ddl = $('#ddlExtraFteDate');
            $ddl.empty();

            var dateColumnIndex = -1;
            $('#tableFteBilling thead th').each(function (index) {
                var header = $.trim($(this).text()).toLowerCase();
                if (header === 'date') {
                    dateColumnIndex = index;
                }
            });

            if (dateColumnIndex >= 0) {
                $('#tableFteBilling tbody tr').each(function () {
                    var dateText = $.trim($(this).find('td').eq(dateColumnIndex).text());
                    if (dateText) {
                        $ddl.append($('<option/>').val(dateText).text(dateText));
                    }
                });
            }

            // Fallback: build dates from selected billing period if table is not loaded yet.
            if ($ddl.children().length === 0) {
                var period = getCurrentBillingPeriod().replace(/ to /ig, ' ~ ');
                var parts = period.split('~');
                if (parts.length === 2) {
                    var start = new Date($.trim(parts[0]));
                    var end = new Date($.trim(parts[1]));
                    if (!isNaN(start.getTime()) && !isNaN(end.getTime())) {
                        for (var d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
                            var text = formatExtraFteDate(d);
                            $ddl.append($('<option/>').val(text).text(text));
                        }
                    }
                }
            }
        }

        function formatExtraFteDate(date) {
            var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            var dd = ('0' + date.getDate()).slice(-2);
            return dd + '-' + months[date.getMonth()] + '-' + date.getFullYear();
        }

        function addExtraFteTempRow() {
            var workDate = $('#ddlExtraFteDate').val();
            var operatorNo = parseInt($('#txtExtraFteNo').val(), 10);
            var hours = $.trim($('#txtExtraFteHours').val());

            if (!workDate || isNaN(operatorNo) || operatorNo <= 0 || hours === '') {
                showBillingMessage('Please select date, extra operator number and hours.', 'warning');
                return false;
            }

            var hourNumber = parseFloat(hours);
            if (isNaN(hourNumber) || hourNumber < 0 || hourNumber > 24) {
                showBillingMessage('Hours should be between 0 and 24.', 'warning');
                return false;
            }

            var existing = findExtraFteRow(workDate, operatorNo);
            if (existing.length > 0) {
                existing.find('.extra-fte-hours').text(hourNumber.toFixed(2));
            } else {
                $('#tableExtraFteEntry tbody').append(
                    '<tr data-date="' + htmlEncode(workDate) + '" data-operator="' + operatorNo + '">' +
                    '<td>' + htmlEncode(workDate) + '</td>' +
                    '<td>Extra Operator ' + operatorNo + '</td>' +
                    '<td class="extra-fte-hours">' + hourNumber.toFixed(2) + '</td>' +
                    '<td class="text-center"><button type="button" class="btn btn-xs btn-danger" onclick="return removeExtraFteTempRow(this);"><i class="fas fa-trash"></i></button></td>' +
                    '</tr>'
                );
            }

            $('#txtExtraFteHours').val('');
            return false;
        }

        function findExtraFteRow(workDate, operatorNo) {
            return $('#tableExtraFteEntry tbody tr').filter(function () {
                return $(this).attr('data-date') === workDate && parseInt($(this).attr('data-operator'), 10) === operatorNo;
            });
        }

        function removeExtraFteTempRow(btn) {
            $(btn).closest('tr').remove();
            return false;
        }

        function loadExtraFteRows() {
            $('#tableExtraFteEntry tbody').empty();
            showBillingLoader();
            $.ajax({
                type: 'POST',
                url: 'FTEBilling.aspx/GetExtraFteRows',
                data: JSON.stringify({ ProjectID: parseInt($('#fte_billingProject').val(), 10), BillingPeriod: getCurrentBillingPeriod() }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    hideBillingLoader();
                    var rows = JSON.parse(response.d || '[]');
                    $.each(rows, function (_, row) {
                        $('#tableExtraFteEntry tbody').append(
                            '<tr data-date="' + htmlEncode(row.WorkDateText) + '" data-operator="' + row.ExtraOperatorNo + '">' +
                            '<td>' + htmlEncode(row.WorkDateText) + '</td>' +
                            '<td>Extra Operator ' + row.ExtraOperatorNo + '</td>' +
                            '<td class="extra-fte-hours">' + htmlEncode(row.Hours) + '</td>' +
                            '<td class="text-center"><button type="button" class="btn btn-xs btn-danger" onclick="return removeExtraFteTempRow(this);"><i class="fas fa-trash"></i></button></td>' +
                            '</tr>'
                        );
                    });
                },
                error: function () {
                    hideBillingLoader();
                    showBillingMessage('Unable to load extra FTE rows.', 'danger');
                }
            });
            return false;
        }

        function saveExtraFteRows() {
            var details = [];
            $('#tableExtraFteEntry tbody tr').each(function () {
                details.push({
                    WorkDateText: $(this).attr('data-date'),
                    ExtraOperatorNo: parseInt($(this).attr('data-operator'), 10),
                    Hours: parseFloat($(this).find('.extra-fte-hours').text())
                });
            });

            showBillingLoader();
            $.ajax({
                type: 'POST',
                url: 'FTEBilling.aspx/SaveExtraFteRows',
                data: JSON.stringify({ ProjectID: parseInt($('#fte_billingProject').val(), 10), BillingPeriod: getCurrentBillingPeriod(), DetailsJson: JSON.stringify(details) }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (response) {
                    hideBillingLoader();
                    var result = JSON.parse(response.d || '{}');
                    showBillingMessage(result.Message || 'Extra FTE saved.', result.Success ? 'success' : 'danger');
                    if (result.Success) {
                        closeExtraFteDialog();
                        if (typeof btnShowFteBilling === 'function') { btnShowFteBilling(); }
                    }
                },
                error: function () {
                    hideBillingLoader();
                    showBillingMessage('Unable to save extra FTE rows.', 'danger');
                }
            });
            return false;
        }

        function htmlEncode(value) {
            return $('<div/>').text(value == null ? '' : value).html();
        }

        function showBillingLoader() { $('#load1').addClass('is-visible'); }
        function hideBillingLoader() { $('#load1').removeClass('is-visible'); }

        function showBillingMessage(message, type) {
            var css = 'alert alert-' + (type || 'info');
            $('#billingMessage').removeClass().addClass(css).html(message).show();
        }

        $(document).on('change', '#fte_billingProject', function () {
            setTimeout(toggleExtraFteButton, 50);
        });

        $(document).ajaxComplete(function () {
            toggleExtraFteButton();
        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="billing-loading" id="load1" aria-hidden="true">
        <div class="loading-inner">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div class="loading-text">One moment, please...</div>
        </div>
    </div>

    <div class="billing-page">
        <div id="billingMessage" class="alert" style="display: none;"></div>

        <section class="billing-hero">
            <div>
                <h1>FTE Project Billing</h1>
                <p>Review FTE billing details, totals, attendance support, and account submission.</p>
            </div>
            <span class="billing-chip"><i class="fas fa-file-invoice-dollar"></i> Billing</span>
        </section>

        <section class="billing-panel">
            <div class="billing-panel-header">
                <h2><i class="fas fa-filter"></i>&nbsp;&nbsp;Billing Filters</h2>
            </div>
            <div class="billing-panel-body">
                <div class="billing-form">
                    <div class="billing-field">
                        <label for="fte_billingProject">Project</label>
                        <select id="fte_billingProject" name="fte_billingProject" onchange="return getBillingCycle(this);" class="form-control">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="billing-field">
                        <label for="fte_billingCycle">Billing Cycle</label>
                        <select id="fte_billingCycle" name="fte_billingCycle" onchange="return getBillingPeriod(this);" class="form-control">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="billing-field">
                        <label for="fte_BillingPeriod">Billing Period</label>
                        <select id="fte_BillingPeriod" name="fte_BillingPeriod" class="form-control">
                            <option value="Select">Select</option>
                        </select>
                    </div>
                    <div class="billing-field" style="grid-column: 1 / -1;">
                        <label for="fte_billingRemark">Remark</label>
                        <textarea id="fte_billingRemark" name="fte_billingRemark" class="form-control"></textarea>
                    </div>
                </div>
                <div class="billing-actions">
                    <button type="button" id="btnBillingReset" onclick="return resetFteBilling();" class="btn btn-default">
                        <i class="fas fa-undo"></i> Reset
                    </button>
                    <button type="button" id="btnBillingShow" onclick="return btnShowFteBilling();" class="btn btn-primary">
                        <i class="fas fa-search"></i> Show
                    </button>
                    <button type="button" id="btnManageExtraFte" onclick="return openExtraFteDialog();" class="btn btn-info" style="display:none;">
                        <i class="fas fa-user-plus"></i> Extra FTE
                    </button>
                    <button type="button" id="btnSendToAccounts" onclick="return btnSubmitSendToAccounts();" class="btn btn-success">
                        <i class="fas fa-paper-plane"></i> Send to Accounts
                    </button>
                </div>
                <div id="extraFteNote" class="extra-fte-note">Extra FTE facility is enabled for project 791-001 only. Add extra operator hours for selected dates and click Show again to refresh the grid.</div>
            </div>
        </section>

        <section class="billing-metrics">
            <div class="billing-metric"><span>Records</span><strong id="metricBillingRows">0</strong></div>
            <div class="billing-metric"><span>Average Billed FTE</span><strong id="metricAverageFte">-</strong></div>
            <div class="billing-metric"><span>Billable Hours</span><strong id="metricBillableHours">-</strong></div>
            <div class="billing-metric"><span>Total FTE Hours</span><strong id="metricTotalFteHours">-</strong></div>
            <div class="billing-metric"><span>Working Hours</span><strong id="metricWorkingHours">-</strong></div>
            <div class="billing-metric"><span># of Invoices</span><strong id="metricInvoiceCount">-</strong></div>
            <div class="billing-metric"><span>Time Spent (Mins)</span><strong id="metricTimeMins">-</strong></div>
            <div class="billing-metric"><span>Time Spent (Hrs)</span><strong id="metricTimeHrs">-</strong></div>
        </section>

        <section class="billing-panel">
            <div class="billing-panel-header">
                <h2><i class="fas fa-table"></i>&nbsp;&nbsp;FTE Billing Report</h2>
                <span id="billingRecordLabel" class="text-muted small">Current records</span>
            </div>
            <div class="billing-panel-body">
                <div class="billing-table-wrap">
                    <table class="table table-bordered table-hover" id="tableFteBilling">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </section>

        <div id="extraFteModal" class="extra-fte-modal">
            <div class="extra-fte-dialog">
                <div class="extra-fte-dialog-header">
                    <h3><i class="fas fa-user-plus"></i>&nbsp;&nbsp;Extra FTE / Operator Hours - 791-001</h3>
                    <button type="button" class="btn btn-xs btn-default" onclick="return closeExtraFteDialog();">Close</button>
                </div>
                <div class="extra-fte-dialog-body">
                    <div class="extra-fte-grid">
                        <div class="billing-field">
                            <label for="ddlExtraFteDate">Date</label>
                            <select id="ddlExtraFteDate" class="form-control"></select>
                        </div>
                        <div class="billing-field">
                            <label for="txtExtraFteNo">Extra Operator #</label>
                            <input type="number" id="txtExtraFteNo" class="form-control" min="1" step="1" value="1" />
                        </div>
                        <div class="billing-field">
                            <label for="txtExtraFteHours">Hours</label>
                            <input type="number" id="txtExtraFteHours" class="form-control" min="0" max="24" step="0.25" placeholder="9" />
                        </div>
                        <button type="button" class="btn btn-primary" onclick="return addExtraFteTempRow();">
                            <i class="fas fa-plus"></i> Add / Update
                        </button>
                    </div>

                    <div class="billing-table-wrap">
                        <table id="tableExtraFteEntry" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Extra Operator</th>
                                    <th>Hours</th>
                                    <th style="width:80px;">Action</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="billing-actions">
                        <button type="button" class="btn btn-default" onclick="return closeExtraFteDialog();">Cancel</button>
                        <button type="button" class="btn btn-success" onclick="return saveExtraFteRows();">
                            <i class="fas fa-save"></i> Save Extra FTE
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
