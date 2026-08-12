<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="VerifyBilling.aspx.cs" Inherits="WebPortal.Search.VerifyBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <style>
        :root {
            --order-bg: #f4f6f8;
            --order-surface: #ffffff;
            --order-border: #d9e1e8;
            --order-border-soft: #eef2f5;
            --order-text: #1f2937;
            --order-muted: #667085;
            --order-primary: #0f766e;
            --order-primary-dark: #115e59;
            --order-accent: #2563eb;
            --order-warning: #f59e0b;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .72);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading img {
                width: 64px;
                height: 64px;
                display: block;
                margin: 0 auto 10px;
            }

            .loading div {
                font-size: 12px;
                font-weight: 700;
                color: var(--order-text);
            }

        .verify-billing-page {
            background: var(--order-bg);
            min-height: calc(100vh - 72px);
        }

        .order-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            max-width: 1440px;
            margin: 0 auto 14px;
            padding: 14px 18px;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-left: 4px solid var(--order-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .order-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--order-text);
            font-size: 22px;
            font-weight: 700;
        }

            .order-title i {
                width: 36px;
                height: 36px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                background: var(--order-primary);
                border-radius: 8px;
                font-size: 15px;
            }

        .order-context {
            color: var(--order-muted);
            font-size: 12px;
            font-weight: 600;
            margin-top: 2px;
        }

        .order-shell {
            max-width: 1440px;
            margin: 0 auto;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .order-section {
            padding: 16px;
            border-bottom: 1px solid var(--order-border-soft);
        }

            .order-section:last-child {
                border-bottom: 0;
            }

        .section-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 12px;
            color: var(--order-text);
            font-size: 14px;
            font-weight: 700;
        }

            .section-title i {
                color: var(--order-primary);
            }

        .field-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(220px, 1fr));
            gap: 14px 16px;
        }

        .filter-action-field {
            display: flex;
            align-items: flex-end;
        }

            .filter-action-field .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 7px;
                min-height: 38px;
                padding: 8px 18px;
                border: 0;
                border-radius: 7px;
                background: var(--order-primary) !important;
                color: #ffffff !important;
                font-size: 13px;
                font-weight: 700;
                box-shadow: 0 6px 14px rgba(15, 118, 110, .16);
            }

                .filter-action-field .btn:hover {
                    background: var(--order-primary-dark) !important;
                }

        .order-field label {
            display: block;
            margin-bottom: 5px;
            color: var(--order-text);
            font-size: 12px;
            font-weight: 700 !important;
            border: 0 !important;
            line-height: 1.25;
        }

        .order-field .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            font-size: 13px;
            color: var(--order-text);
            box-shadow: none;
        }

            .order-field .form-control:focus {
                border-color: var(--order-primary);
                box-shadow: 0 0 0 .16rem rgba(15, 118, 110, .12);
            }

        .remark-actions-grid {
            display: grid;
            grid-template-columns: minmax(320px, 2fr) minmax(300px, 1fr);
            gap: 16px;
            align-items: end;
        }

        .verify-action-group {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
        }

            .verify-action-group .btn,
            .modal .btn-primary {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 7px;
                min-height: 38px;
                padding: 8px 16px;
                border: 0;
                border-radius: 7px;
                font-size: 13px;
                font-weight: 700;
                box-shadow: none;
            }

            .verify-action-group .btn-primary,
            .modal .btn-primary {
                background: var(--order-primary) !important;
                color: #ffffff !important;
            }

                .verify-action-group .btn-primary:hover,
                .modal .btn-primary:hover {
                    background: var(--order-primary-dark) !important;
                }

        .verify-card {
            border: 1px solid var(--order-border-soft);
            border-radius: 8px;
            background: #ffffff;
            overflow: hidden;
            margin-bottom: 16px;
        }

            .verify-card:last-child {
                margin-bottom: 0;
            }

        .verify-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            color: var(--order-text);
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border-soft);
            font-size: 14px;
            font-weight: 700;
        }

            .verify-card-header i {
                color: var(--order-primary);
                margin-right: 6px;
            }

        .verify-card-body {
            padding: 14px;
        }

        .summary-grid {
            display: grid;
            gap: 12px;
        }

        .summary-period {
            overflow: hidden;
            border: 1px solid var(--order-border);
            border-radius: 10px;
            background: #ffffff;
        }

        .summary-period-header {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            color: var(--order-primary-dark);
            background: linear-gradient(90deg, #ecfdf5 0%, #f8fafc 100%);
            border-bottom: 1px solid #d9eee9;
            font-size: 12px;
            font-weight: 800;
        }

            .summary-period-header i {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 28px;
                height: 28px;
                color: #ffffff;
                background: var(--order-primary);
                border-radius: 7px;
            }

        .summary-metrics {
            display: grid;
            grid-template-columns: repeat(7, minmax(115px, 1fr));
            gap: 10px;
            padding: 12px;
        }

        .summary-metric {
            position: relative;
            min-width: 0;
            padding: 11px 12px 11px 14px;
            border: 1px solid #e1e8ee;
            border-radius: 9px;
            background: #fbfcfd;
        }

            .summary-metric::before {
                content: "";
                position: absolute;
                top: 10px;
                bottom: 10px;
                left: 0;
                width: 3px;
                border-radius: 0 3px 3px 0;
                background: var(--metric-color, var(--order-primary));
            }

        .summary-metric-label {
            display: block;
            overflow: hidden;
            color: var(--order-muted);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .035em;
            text-overflow: ellipsis;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .summary-metric-value {
            display: block;
            margin-top: 3px;
            color: var(--order-text);
            font-size: 21px;
            font-weight: 800;
            line-height: 1.15;
        }

        .summary-metric.received {
            --metric-color: #2563eb;
        }

        .summary-metric.dispatch {
            --metric-color: #059669;
        }

        .summary-metric.cancel {
            --metric-color: #dc2626;
        }

        .summary-metric.hold {
            --metric-color: #d97706;
        }

        .summary-metric.pending-search {
            --metric-color: #7c3aed;
        }

        .summary-metric.pending-typing {
            --metric-color: #0891b2;
        }

        .summary-metric.pending-tax {
            --metric-color: #db2777;
        }

        .summary-empty {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 72px;
            padding: 16px;
            color: var(--order-muted);
            border: 1px dashed #ccd6df;
            border-radius: 9px;
            background: #fbfcfd;
            font-size: 12px;
            font-weight: 700;
        }

        #table_grdPending,
        #table_grdPending_wrapper {
            display: none !important;
        }

        .count-badge {
            display: inline-flex !important;
            align-items: center;
            min-height: 26px;
            padding: 3px 9px;
            margin-left: 8px;
            border-radius: 999px;
            background: #edf7f5;
            color: var(--order-primary-dark) !important;
            font-size: 13px !important;
            font-weight: 700 !important;
        }

        #lblfiltercount {
            background: #fff7ed;
            color: #9a3412 !important;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--order-muted);
            font-size: 12px;
            font-weight: 600;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #263747;
            box-shadow: none;
            background: var(--order-primary) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            margin: 0 6px;
            padding: 7px 14px !important;
        }

        /* Center checkbox */
        #VerifyOrders_Search_Billing thead th:first-child label {
            margin: 0 auto;
        }


        /* Keep all header cells same height */
        #VerifyOrders_Search_Billing thead th {
            height: 42px;
            vertical-align: middle !important;
        }

            /* First header column same as other headers */
            #VerifyOrders_Search_Billing thead th:first-child {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid var(--order-border) !important;
                text-align: center;
                vertical-align: middle;
                width: 44px;
                padding: 8px 6px;
            }

        .VerifyOrders_Search_Billing thead th,
        .VerifyOrders_Search_Billing.dataTable th {
            color: #263747;
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            border-bottom: 1px solid var(--order-border) !important;
            font-size: 13px;
            font-weight: 700;
            vertical-align: middle;
            white-space: nowrap;
        }

        #VerifyOrders_Search_Billing th:first-child,
        #VerifyOrders_Search_Billing td:first-child {
            text-align: center;
            width: 44px;
        }

        /* hide real checkbox but keep clickable */
        #VerifyOrders_Search_Billing input[type="checkbox"] {
            display: none;
        }

            /* custom visible checkbox */
            #VerifyOrders_Search_Billing input[type="checkbox"] + label {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 20px;
                height: 20px;
                margin: 0;
                border: 2px solid darkcyan;
                border-radius: 4px;
                background: #EDF3F6;
                cursor: pointer;
            }

            /* checked style */
            #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label {
                background: var(--order-primary);
                border-color: var(--order-primary);
            }

                #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label::after {
                    content: "\2713";
                    color: #fff;
                    font-size: 13px;
                    font-weight: 700;
                }

        .ost-table-frame {
            overflow: hidden;
            border: 1px solid var(--order-border);
            border-radius: 9px;
            background: #ffffff;
        }

        #VerifyOrders_Search_Billing_wrapper {
            padding: 12px;
        }

            #VerifyOrders_Search_Billing_wrapper .dt-buttons {
                margin: 0 0 10px;
                padding: 0;
            }

                #VerifyOrders_Search_Billing_wrapper .dt-buttons .dt-button {
                    min-height: 36px;
                    margin: 0;
                    padding: 7px 14px !important;
                    color: #ffffff !important;
                    background: var(--order-primary) !important;
                    border: 0 !important;
                    border-radius: 7px !important;
                    font-size: 12px;
                    font-weight: 800 !important;
                    box-shadow: 0 5px 12px rgba(15, 118, 110, .14);
                }

                    #VerifyOrders_Search_Billing_wrapper .dt-buttons .dt-button:hover {
                        background: var(--order-primary-dark) !important;
                    }

            #VerifyOrders_Search_Billing_wrapper .dataTables_filter {
                float: right;
                margin: 0 0 10px;
            }

                #VerifyOrders_Search_Billing_wrapper .dataTables_filter label {
                    display: flex;
                    align-items: center;
                    gap: 7px;
                    margin: 0;
                    color: var(--order-muted);
                    font-size: 12px;
                    font-weight: 700 !important;
                }

                #VerifyOrders_Search_Billing_wrapper .dataTables_filter input {
                    width: 220px;
                    min-height: 36px;
                    margin: 0;
                    padding: 6px 11px;
                    border: 1px solid #ccd6df;
                    border-radius: 8px;
                    background: #ffffff;
                    color: var(--order-text);
                    box-shadow: none;
                }

                    #VerifyOrders_Search_Billing_wrapper .dataTables_filter input:focus {
                        border-color: var(--order-primary);
                        box-shadow: 0 0 0 .16rem rgba(15, 118, 110, .12);
                        outline: 0;
                    }

            #VerifyOrders_Search_Billing_wrapper .dataTables_scroll {
                clear: both;
                overflow: hidden;
                border: 1px solid #dbe4ea;
                border-radius: 8px;
            }

            #VerifyOrders_Search_Billing_wrapper .dataTables_scrollHead {
                background: #eaf4f3;
            }

            #VerifyOrders_Search_Billing_wrapper table.dataTable {
                margin: 0 !important;
                border-collapse: separate !important;
                border-spacing: 0;
            }

                #VerifyOrders_Search_Billing_wrapper table.dataTable thead th {
                    height: 42px;
                    /*  padding: 9px 10px !important;*/
                    color: #17413e;
                    background: #eaf4f3 !important;
                    background-image: none !important;
                    border-top: 3px solid var(--order-primary) !important;
                    border-right: 1px solid #d6e5e3 !important;
                    border-bottom: 1px solid #bdd6d2 !important;
                    font-size: 11px;
                    font-weight: 800;
                    letter-spacing: .015em;
                    vertical-align: middle !important;
                    white-space: nowrap;
                }

        #VerifyOrders_Search_Billing tbody td {
            padding: 9px 10px !important;
            color: #334155;
            background: #ffffff;
            border-right: 1px solid #edf2f5;
            border-bottom: 1px solid #e7edf1;
            font-size: 11px;
            vertical-align: middle;
            white-space: nowrap;
        }

        #VerifyOrders_Search_Billing tbody tr:nth-child(even) td {
            background: #f8fafb;
        }

        #VerifyOrders_Search_Billing tbody tr:hover td {
            background: #eef8f6;
        }

        #VerifyOrders_Search_Billing tbody tr.selected-row td {
            background: #dff3ef !important;
        }

        #VerifyOrders_Search_Billing_wrapper .dataTables_scrollBody {
            min-height: 0 !important;
            scrollbar-color: #94a3b8 #edf2f5;
            scrollbar-width: thin;
        }

            #VerifyOrders_Search_Billing_wrapper .dataTables_scrollBody::-webkit-scrollbar {
                width: 8px;
                height: 8px;
            }

            #VerifyOrders_Search_Billing_wrapper .dataTables_scrollBody::-webkit-scrollbar-track {
                background: #edf2f5;
            }

            #VerifyOrders_Search_Billing_wrapper .dataTables_scrollBody::-webkit-scrollbar-thumb {
                background: #94a3b8;
                border-radius: 999px;
            }

        #VerifyOrders_Search_Billing_wrapper .dataTables_paginate {
            padding-top: 10px;
        }

        .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 20px 45px rgba(31, 41, 55, .2);
            overflow: hidden;
        }

        .modal-header {
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border-soft);
        }

        .modal-title {
            color: var(--order-text);
            font-size: 16px;
            font-weight: 700;
        }

        @media (max-width: 992px) {
            .field-grid,
            .remark-actions-grid {
                grid-template-columns: 1fr;
            }

            .verify-action-group {
                justify-content: flex-start;
            }

            .summary-metrics {
                grid-template-columns: repeat(3, minmax(110px, 1fr));
            }
        }

        @media (max-width: 576px) {
            .summary-metrics {
                grid-template-columns: repeat(2, minmax(100px, 1fr));
            }

            #VerifyOrders_Search_Billing_wrapper .dataTables_filter {
                float: none;
                width: 100%;
            }

                #VerifyOrders_Search_Billing_wrapper .dataTables_filter label,
                #VerifyOrders_Search_Billing_wrapper .dataTables_filter input {
                    width: 100%;
                }
        }
    </style>

    <style>
        .account-mail-loader {
            padding: 8px 15px 5px;
            text-align: center;
        }

        .mail-icon-wrapper {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 78px;
            height: 78px;
            margin-bottom: 14px;
            border-radius: 50%;
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            color: #2563eb;
            font-size: 30px;
            overflow: hidden;
        }

        .mail-send-animation {
            position: absolute;
            right: -18px;
            width: 22px;
            height: 3px;
            border-radius: 10px;
            background: #2563eb;
            box-shadow: 0 -8px 0 rgba(37, 99, 235, 0.55), 0 8px 0 rgba(37, 99, 235, 0.35);
            animation: sendMailLine 1.2s infinite ease-in-out;
        }

        .mail-project-name {
            margin-bottom: 6px;
            color: #111827;
            font-size: 15px;
            font-weight: 700;
        }

        .mail-status-text {
            margin-bottom: 16px;
            color: #6b7280;
            font-size: 13px;
        }

        .mail-progress {
            width: 100%;
            height: 6px;
            overflow: hidden;
            border-radius: 20px;
            background: #e5e7eb;
        }

        .mail-progress-bar {
            width: 35%;
            height: 100%;
            border-radius: 20px;
            background: linear-gradient(90deg, #2563eb, #60a5fa);
            animation: mailProgress 1.4s infinite ease-in-out;
        }

        .email-success-details {
            padding: 5px 10px;
            text-align: left;
            color: #374151;
            font-size: 14px;
            line-height: 1.8;
        }

        .success-note {
            margin-top: 12px;
            padding: 12px;
            border: 1px solid #bbf7d0;
            border-radius: 8px;
            background: #f0fdf4;
            color: #166534;
            line-height: 1.5;
        }

        @keyframes sendMailLine {
            0% {
                opacity: 0;
                transform: translateX(-15px);
            }

            50% {
                opacity: 1;
            }

            100% {
                opacity: 0;
                transform: translateX(35px);
            }
        }

        @keyframes mailProgress {
            0% {
                margin-left: -35%;
            }

            100% {
                margin-left: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {

            verifyOrdres_BindProject();

          //  Bind_SearchBilling_Grid("735", "01-Aug-2026", "15-Aug-2026");
        });


        function vrbil_showFileName(input) {
            var fileNameElement = document.getElementById("vrbil_fileName");

            if (input.files && input.files.length > 0) {
                var file = input.files[0];
                var fileName = file.name;

                var extension = fileName
                    .substring(fileName.lastIndexOf("."))
                    .toLowerCase();

                if (extension !== ".msg") {
                    alert("Please upload only Outlook .msg files.");

                    input.value = "";
                    fileNameElement.innerHTML = "or click to browse";
                    return false;
                }

                fileNameElement.textContent = fileName;
            } else {
                fileNameElement.innerHTML = "or click to browse";
            }
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading search-page-loader" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="verify-billing-page">
        <div class="order-page-header search-modern-header">
            <div class="search-header-identity">
                <span class="search-header-icon"><i class="fas fa-clipboard-check"></i></span>
                <div class="search-header-copy">
                    <h1 class="order-title"><span>Verify Billing Orders</span></h1>
                    <div class="order-context">Review billable orders, add remarks, verify, and send selected orders to accounts.</div>
                </div>
            </div>
        </div>

        <div class="order-shell">
            <div class="order-section">
                <h2 class="section-title"><i class="fas fa-filter"></i>Billing Filters</h2>
                <div class="field-grid">
                    <div class="order-field">
                        <label for="VerifyOrdres_projectno">Project #</label>
                        <select id="VerifyOrdres_projectno" name="VerifyOrdres_projectno" onchange="return BindBillingCycle(this)" class="form-control">
                        </select>
                    </div>
                    <div class="order-field">
                        <label for="VerifyOrdres_BillingCycle">Billing Cycle</label>
                        <select id="VerifyOrdres_BillingCycle" name="VerifyOrdres_BillingCycle" onchange="return BindDatePeriod(this)" class="form-control">
                        </select>
                    </div>
                    <div class="order-field">
                        <label for="VerifyOrdres_dateperild">Date Period</label>
                        <select id="VerifyOrdres_dateperild" name="VerifyOrdres_dateperild" class="form-control">
                        </select>
                    </div>
                    <div class="order-field filter-action-field">
                        <button type="button" id="VerifyOrdres_btnsubmit" class="btn btn-primary" onclick="return VerifyOrdres_Show();"><i class="fas fa-search"></i>Show</button>
                    </div>
                </div>
            </div>
            <div class="verify-card">
                <div class="verify-card-body">
                    <div id="totalOrdersSummary" class="summary-grid" aria-live="polite">
                        <div class="summary-empty"><i class="fas fa-info-circle"></i><span>Select the billing filters and click Show to view the order summary.</span></div>
                    </div>
                    <table class="table" id="table_grdPending" aria-hidden="true" style="width: 100% !important;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">BillingPeriod</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Received</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Dispatch</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Cancel</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Hold</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Search</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Typing</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Tax</th>
                            </tr>
                        </thead>
                        <tbody style="font-size: 14px;"></tbody>
                    </table>
                </div>
            </div>
            <div class="order-section">
                <h2 class="section-title"><i class="fas fa-comment-alt"></i>Verification Remark</h2>
                <div class="remark-actions-grid">
                    <div class="order-field">
                        <textarea id="VerifyOrdres_Remark" name="VerifyOrdres_Remark" class="form-control" textmode="MultiLine" rows="3"></textarea>
                    </div>
                    <div class="verify-action-group">
                        <button type="button" id="VerifyOrdres_btnVerify" class="btn btn-primary" onclick="return VerifyOrdres_Verify();"><i class="fas fa-check-circle"></i>Verify</button>
                        <button type="button" id="VerifyOrdres_btnSendToAccount" class="btn btn-primary" onclick="return VerifyOrdres_SendToAccount();"><i class="fas fa-paper-plane"></i>Send To Accounts</button>
                    </div>
                </div>
            </div>

            <div class="order-section">


                <div class="verify-card">
                    <div class="verify-card-header">
                        <span><i class="fas fa-table"></i>Billable Orders (Dispatch + Cancel + Previous)</span>
                        <span>
                            <label id="lbltotalcount" name="lbltotalcount" class="count-badge"></label>
                            <label id="lblfiltercount" name="lblfiltercount" class="count-badge"></label>
                        </span>
                    </div>
                    <div class="ost-table-frame">
                        <table class="table" id="VerifyOrders_Search_Billing">
                            <thead>
                                <tr>
                                    <th class="text-center">
                                        <input type="checkbox" id="chkall" />
                                        <label for="chkall"></label>
                                    </th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Order No</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">State</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">County</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Received Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Dispatch Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">No of Documents</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">No of Pages</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Tax Information</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Taxes Calling(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name + Property Search cost in title plant</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Document Download Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Retrieval Cost (Searching + Downloading)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Property Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Product Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process Done</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Online Offline</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Typing(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">SnippingTools(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Production Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Search Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Copy Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Cost paid for Independent Abstractor</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 200px;">Abstractor Name</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">OrderID</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Order verification in progress. Please wait.</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="popUp_viewBilling_addRemark" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content vrbil-modal-content">

                <!-- ================= HEADER ================= -->
                <div class="modal-header vrbil-modal-header">
                    <h5 class="modal-title">
                        <label id="lblupdateRemark" style="font-weight: bold !important;"></label>
                    </h5>
                    <button type="button" class="close vrbil-modal-close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>

                <!-- ================= BODY ================= -->
                <div class="modal-body vrbil-modal-body">

                    <!-- Primary fields -->
                    <div class="vrbil-form-grid">
                        <div class="vrbil-form-group">
                            <label for="vrbil_orderCost" class="form-label vrbil-label"><span class="vrbil-field-icon">$</span>Order Cost :</label>
                            <input type="number" name="vrbil_orderCost" id="vrbil_orderCost" class="form-control vrbil-control" placeholder="Enter order cost" min="0" step="0.01" />
                        </div>

                        <div class="vrbil-form-group">
                            <label for="vrbil_remark" class="form-label vrbil-label"><span class="vrbil-field-icon">&#9998;</span>Remark :</label>
                            <textarea name="vrbil_remark" id="vrbil_remark" class="form-control vrbil-control" rows="3" placeholder="Enter remark"></textarea>
                        </div>
                    </div>

                    <!-- ================= ADDITIONAL DETAILS ================= -->
                    <div class="vrbil-additional-wrapper" id="costingDiffEmail_div" style="display: none;">
                        <div class="vrbil-switch-card">
                            <div class="vrbil-switch-info">
                                <div class="vrbil-switch-symbol">+</div>
                                <div>
                                    <div class="vrbil-switch-title">Add Additional Details</div>
                                    <div class="vrbil-switch-description">Enable to enter additional information</div>
                                </div>
                            </div>

                            <label class="vrbil-switch">
                                <input type="checkbox" id="vrbil_additional" onchange="vrbil_toggleAdditional();" />
                                <span class="vrbil-slider"></span>
                            </label>
                        </div>

                        <!-- Dependent fields -->
                        <div id="vrbil_additionalFields" class="vrbil-dependent-section" style="display: none;">
                            <div class="vrbil-dependent-grid">
                                <div class="vrbil-form-group">
                                    <label for="vrbil_additionalText" class="form-label vrbil-label">
                                        <span class="vrbil-field-icon">&#177;</span>Cost Difference :
                                    </label>
                                    <input type="number" name="vrbil_costDiff" id="vrbil_costDiff" class="form-control vrbil-control" placeholder="Enter cost difference" step="0.01" />
                                </div>

                                <div class="vrbil-form-group">
                                    <label for="vrbil_attachment" class="form-label vrbil-label">
                                        <span class="vrbil-field-icon">&#128206;</span>Attachment :
                                    </label>
                                    <%--   <div class="vrbil-upload-box" id="vrbil_dropzone">
                                        <input type="file" name="vrbil_attachment" id="vrbil_attachment" class="vrbil-upload-input" onchange="vrbil_showFileName(this);" />
                                        <div class="vrbil-upload-content">
                                            <div class="vrbil-upload-main">
                                                <div class="vrbil-upload-icon">&#8593;</div>
                                                <div class="vrbil-upload-title">Drag &amp; drop file here</div>
                                            </div>
                                            <div id="vrbil_fileName" class="vrbil-file-name">or click to browse</div>
                                        </div>
                                    </div>--%>
                                    <div class="vrbil-upload-box" id="vrbil_dropzone">
                                        <input type="file"
                                            name="vrbil_attachment"
                                            id="vrbil_attachment"
                                            class="vrbil-upload-input"
                                            accept=".msg"
                                            onchange="vrbil_showFileName(this);" />

                                        <div class="vrbil-upload-content">
                                            <div class="vrbil-upload-main">
                                                <div class="vrbil-upload-icon">&#8593;</div>
                                                <div class="vrbil-upload-title">Drag &amp; drop .msg file here</div>
                                            </div>

                                            <div id="vrbil_fileName" class="vrbil-file-name">
                                                or click to browse
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="vrbil-form-group vrbil-email-note-full">
                                    <label for="vrbil_EmailNote" class="form-label vrbil-label"><span class="vrbil-field-icon">&#9993;</span>Email Note :</label>
                                    <textarea name="vrbil_EmailNote" id="vrbil_EmailNote" class="form-control vrbil-email-note-full" rows="3" placeholder="Enter email note"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- ================= FOOTER ================= -->
                <div class="modal-footer vrbil-modal-footer">
                    <button type="button" class="btn vrbil-btn-secondary" data-dismiss="modal" onclick="clearBillingFields();">Close</button>
                    <button type="submit" class="btn vrbil-btn-primary" id="btnvrfBilling" onclick="return btnverfybilling_AddRemark();">Add Remark</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* =========================================================
       ADD REMARK MODAL - MODERN UI
       Prefix: vrbil-
       ========================================================= */

        #popUp_viewBilling_addRemark {
            --vrbil-primary: #0c8f8f;
            --vrbil-primary-dark: #087575;
            --vrbil-primary-soft: #e9f8f7;
            --vrbil-blue: #2563eb;
            --vrbil-bg: #f7f9fc;
            --vrbil-surface: #ffffff;
            --vrbil-border: #dbe3ee;
            --vrbil-border-focus: #54a7a7;
            --vrbil-text: #172033;
            --vrbil-text-secondary: #526175;
            --vrbil-muted: #8a98aa;
            --vrbil-danger: #dc3545;
            --vrbil-radius: 16px;
            --vrbil-input-radius: 9px;
            --vrbil-shadow: 0 24px 70px rgba(15, 23, 42, 0.18);
        }

            /* ---------- Dialog ---------- */

            #popUp_viewBilling_addRemark .modal-dialog {
                max-width: 1080px;
                width: calc(100% - 32px);
                margin: 1rem auto;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-content {
                border: 0;
                border-radius: var(--vrbil-radius);
                overflow: hidden;
                background: var(--vrbil-surface);
                box-shadow: var(--vrbil-shadow);
            }

            /* ---------- Header ---------- */

            #popUp_viewBilling_addRemark .vrbil-modal-header {
                min-height: 72px;
                padding: 18px 24px;
                border-bottom: 1px solid #edf1f6;
                background: linear-gradient(135deg, #ffffff 0%, #fbfdff 55%, #f2fbfb 100%);
                display: flex;
                align-items: center;
            }

            #popUp_viewBilling_addRemark .modal-title {
                margin: 0;
                color: var(--vrbil-text);
                font-size: 17px;
                font-weight: 700;
                letter-spacing: -0.2px;
                line-height: 1.4;
            }

            #popUp_viewBilling_addRemark #lblupdateRemark {
                margin: 0;
                font-weight: 700 !important;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-close {
                width: 38px;
                height: 38px;
                margin: 0 0 0 auto;
                padding: 0;
                border: 0;
                border-radius: 10px;
                background: transparent;
                color: #6b7a90;
                opacity: 1;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 25px;
                line-height: 1;
                transition: all 0.2s ease;
                outline: none;
            }

                #popUp_viewBilling_addRemark .vrbil-modal-close:hover {
                    color: #dc3545;
                    background: #fff1f2;
                    transform: rotate(4deg);
                }

            /* ---------- Body ---------- */

            #popUp_viewBilling_addRemark .vrbil-modal-body {
                padding: 26px 28px 20px;
                background: var(--vrbil-surface);
            }

            #popUp_viewBilling_addRemark .vrbil-form-grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 22px 24px;
            }

            #popUp_viewBilling_addRemark .vrbil-form-group {
                min-width: 0;
            }

            #popUp_viewBilling_addRemark .vrbil-full-width {
                grid-column: 1 / -1;
            }

            /* ---------- Labels ---------- */

            #popUp_viewBilling_addRemark .vrbil-label {
                display: flex;
                align-items: center;
                gap: 7px;
                margin-bottom: 8px;
                color: #344258;
                font-size: 13px;
                font-weight: 600;
                line-height: 1.4;
            }

            #popUp_viewBilling_addRemark .vrbil-field-icon {
                width: 25px;
                height: 25px;
                border-radius: 7px;
                background: var(--vrbil-primary-soft);
                color: var(--vrbil-primary);
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                flex-shrink: 0;
            }

            /* ---------- Inputs ---------- */

            #popUp_viewBilling_addRemark .vrbil-control {
                width: 100%;
                min-height: 44px;
                padding: 10px 13px;
                border: 1px solid var(--vrbil-border);
                border-radius: var(--vrbil-input-radius);
                background: #ffffff;
                color: var(--vrbil-text);
                font-size: 14px;
                font-weight: 400;
                outline: none;
                box-shadow: none;
                transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease, transform 0.2s ease;
            }

            #popUp_viewBilling_addRemark textarea.vrbil-control {
                min-height: 76px;
                resize: vertical;
                line-height: 1.55;
            }

            #popUp_viewBilling_addRemark .vrbil-control::placeholder {
                color: #9aa7b7;
            }

            #popUp_viewBilling_addRemark .vrbil-control:hover {
                border-color: #bdcad9;
            }

            #popUp_viewBilling_addRemark .vrbil-control:focus {
                border-color: var(--vrbil-border-focus);
                background: #ffffff;
                box-shadow: 0 0 0 4px rgba(12, 143, 143, 0.10);
            }

            #popUp_viewBilling_addRemark input[type="number"]::-webkit-inner-spin-button,
            #popUp_viewBilling_addRemark input[type="number"]::-webkit-outer-spin-button {
                opacity: 0.6;
            }

            /* ---------- Additional Details Card ---------- */

            #popUp_viewBilling_addRemark .vrbil-additional-wrapper {
                margin-top: 24px;
                border: 1px solid var(--vrbil-border);
                border-radius: 14px;
                overflow: hidden;
                background: #fff;
                transition: box-shadow 0.25s ease;
            }

                #popUp_viewBilling_addRemark .vrbil-additional-wrapper:hover {
                    box-shadow: 0 8px 24px rgba(30, 41, 59, 0.05);
                }

            #popUp_viewBilling_addRemark .vrbil-switch-card {
                min-height: 55px !important;
                padding: 15px 18px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
                background: linear-gradient(90deg, #f9fbfd 0%, #f7fbfb 100%);
                border-bottom: 0;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-info {
                display: flex;
                align-items: center;
                gap: 12px;
                min-width: 0;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-symbol {
                width: 38px;
                height: 38px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
                background: var(--vrbil-primary-soft);
                color: var(--vrbil-primary);
                font-size: 17px;
                font-weight: 700;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-title {
                margin-bottom: 3px;
                color: #27364a;
                font-size: 13px;
                font-weight: 700;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-description {
                color: #8794a7;
                font-size: 11px;
                line-height: 1.4;
            }

            /* ---------- Modern Switch ---------- */

            #popUp_viewBilling_addRemark .vrbil-switch {
                position: relative;
                display: inline-block;
                width: 65px;
                height: 35px;
                margin: 0;
                flex-shrink: 0;
            }

                #popUp_viewBilling_addRemark .vrbil-switch input {
                    width: 0;
                    height: 0;
                    opacity: 0;
                }

            #popUp_viewBilling_addRemark .vrbil-slider {
                position: absolute;
                inset: 0;
                cursor: pointer;
                border-radius: 50px;
                background: #cbd5e1;
                box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.04);
                transition: 0.25s ease;
            }

                #popUp_viewBilling_addRemark .vrbil-slider::before {
                    content: "";
                    position: absolute;
                    width: 30px;
                    height: 30px;
                    left: 5px;
                    top: 3px;
                    border-radius: 50%;
                    background: #fff;
                    box-shadow: 0 2px 5px rgba(15, 23, 42, 0.22);
                    transition: 0.25s ease;
                }

            #popUp_viewBilling_addRemark .vrbil-switch input:checked + .vrbil-slider {
                background: var(--vrbil-primary);
            }

                #popUp_viewBilling_addRemark .vrbil-switch input:checked + .vrbil-slider::before {
                    transform: translateX(21px);
                }

            #popUp_viewBilling_addRemark .vrbil-switch input:focus + .vrbil-slider {
                box-shadow: 0 0 0 4px rgba(12, 143, 143, 0.12);
            }

            /* ---------- Dependent Section ---------- */

            #popUp_viewBilling_addRemark .vrbil-dependent-section {
                padding: 22px 18px 20px;
                border-top: 1px solid #edf1f6;
                background: #ffffff;
                animation: vrbilFadeIn 0.25s ease;
            }

            #popUp_viewBilling_addRemark .vrbil-dependent-grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 22px 24px;
            }

        @keyframes vrbilFadeIn {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ---------- Upload ---------- */

        #popUp_viewBilling_addRemark .vrbil-upload-box {
            position: relative;
            min-height: 74px;
            border: 1.5px dashed #b9cce2;
            border-radius: 12px;
            overflow: hidden;
            background: linear-gradient(135deg, #fbfdff 0%, #f8fbff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: border-color 0.2s ease, background 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
        }

            #popUp_viewBilling_addRemark .vrbil-upload-box:hover {
                border-color: var(--vrbil-primary);
                background: #f6fdfc;
                box-shadow: 0 0 0 4px rgba(12, 143, 143, 0.06);
            }

        #popUp_viewBilling_addRemark .vrbil-upload-input {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
            z-index: 2;
        }

        #popUp_viewBilling_addRemark .vrbil-upload-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 5px;
            text-align: center;
            pointer-events: none;
        }

        /* Icon + Drag text same line */
        .vrbil-upload-main {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        #popUp_viewBilling_addRemark .vrbil-upload-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: #e8f0ff;
            color: #087575;
            font-size: 21px;
            font-weight: 500;
            margin: 0;
        }

        #popUp_viewBilling_addRemark .vrbil-upload-title {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            white-space: nowrap;
        }

        #popUp_viewBilling_addRemark .vrbil-upload-subtitle {
            color: #8a98aa;
            font-size: 11px;
        }

        #popUp_viewBilling_addRemark .vrbil-file-name {
            margin-top: 0;
            min-height: auto;
            font-size: 12px;
            color: #087575;
        }

        #popUp_viewBilling_addRemark .vrbil-email-note-full {
            grid-column: 1 / -1;
            border-radius: 10px;
            width: 100% !important;
        }

            #popUp_viewBilling_addRemark .vrbil-email-note-full textarea {
                width: 100% !important;
                border-radius: 10px;
            }

        /* ---------- Footer ---------- */

        #popUp_viewBilling_addRemark .vrbil-modal-footer {
            min-height: 76px;
            padding: 14px 24px;
            border-top: 1px solid #edf1f6;
            background: #fbfcfe;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

            #popUp_viewBilling_addRemark .vrbil-modal-footer::before,
            #popUp_viewBilling_addRemark .vrbil-modal-footer::after {
                display: none;
            }

        #popUp_viewBilling_addRemark .vrbil-btn-secondary,
        #popUp_viewBilling_addRemark .vrbil-btn-primary {
            min-width: 112px;
            min-height: 42px;
            padding: 9px 18px;
            border: none;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.2;
            box-shadow: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
        }

        #popUp_viewBilling_addRemark .vrbil-btn-secondary {
            color: #ffffff;
            background: #64748b;
        }

            #popUp_viewBilling_addRemark .vrbil-btn-secondary:hover {
                color: #ffffff;
                background: #536176;
                transform: translateY(-1px);
                box-shadow: 0 7px 15px rgba(71, 85, 105, 0.18);
            }

        #popUp_viewBilling_addRemark .vrbil-btn-primary {
            color: #ffffff;
            background: linear-gradient(135deg, var(--vrbil-primary), var(--vrbil-primary-dark));
            box-shadow: 0 6px 14px rgba(12, 143, 143, 0.18);
        }

            #popUp_viewBilling_addRemark .vrbil-btn-primary:hover {
                color: #ffffff;
                transform: translateY(-1px);
                box-shadow: 0 9px 20px rgba(12, 143, 143, 0.25);
            }

            #popUp_viewBilling_addRemark .vrbil-btn-primary:active,
            #popUp_viewBilling_addRemark .vrbil-btn-secondary:active {
                transform: translateY(0);
            }

        #popUp_viewBilling_addRemark button:focus {
            outline: none;
        }

        /* =========================================================
       RESPONSIVE
       ========================================================= */

        @media (max-width: 767.98px) {

            #popUp_viewBilling_addRemark .modal-dialog {
                width: calc(100% - 20px);
                margin: 10px auto;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-content {
                border-radius: 13px;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-header {
                min-height: 62px;
                padding: 14px 16px;
            }

            #popUp_viewBilling_addRemark .modal-title {
                font-size: 15px;
                padding-right: 10px;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-body {
                padding: 18px 16px;
            }

            #popUp_viewBilling_addRemark .vrbil-form-grid,
            #popUp_viewBilling_addRemark .vrbil-dependent-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }

            #popUp_viewBilling_addRemark .vrbil-additional-wrapper {
                margin-top: 20px;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-card {
                padding: 14px;
            }

            #popUp_viewBilling_addRemark .vrbil-dependent-section {
                padding: 18px 14px;
            }

            #popUp_viewBilling_addRemark textarea.vrbil-control {
                min-height: 88px;
            }

            #popUp_viewBilling_addRemark .vrbil-upload-box {
                min-height: 125px;
            }

            #popUp_viewBilling_addRemark .vrbil-modal-footer {
                min-height: auto;
                padding: 13px 16px;
                gap: 12px;
            }

            #popUp_viewBilling_addRemark .vrbil-btn-secondary,
            #popUp_viewBilling_addRemark .vrbil-btn-primary {
                flex: 1 1 0;
                min-width: 0;
            }
        }

        @media (max-width: 420px) {

            #popUp_viewBilling_addRemark .modal-dialog {
                width: calc(100% - 12px);
                margin: 6px auto;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-symbol {
                display: none;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-card {
                gap: 10px;
            }

            #popUp_viewBilling_addRemark .vrbil-switch-description {
                max-width: 210px;
            }
        }
    </style>

</asp:Content>
