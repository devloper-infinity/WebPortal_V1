<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEBilling_Orig.aspx.cs" Inherits="WebPortal.FTE.FTEBilling" %>

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
                    <button type="button" id="btnSendToAccounts" onclick="return btnSubmitSendToAccounts();" class="btn btn-success">
                        <i class="fas fa-paper-plane"></i> Send to Accounts
                    </button>
                </div>
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
    </div>
</asp:Content>
