<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BankDeatailsApprovalReport.aspx.cs" Inherits="WebPortal.Admin.BankDeatailsApprovalReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --bank-primary: #1d4ed8;
            --bank-secondary: #22c1dc;
            --bank-dark: #0f172a;
            --bank-muted: #64748b;
            --bank-border: #e2e8f0;
            --bank-soft: #f8fafc;
            --bank-success: #16a34a;
            --bank-warning: #f59e0b;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 192px;
            height: 192px;
            z-index: 99999;
            background: rgba(255,255,255,.92);
            border-radius: 24px;
            box-shadow: 0 20px 45px rgba(15,23,42,.18);
            text-align: center;
            padding-top: 28px;
        }

        .loading img {
            max-width: 72px;
            margin-bottom: 12px;
        }

        .bank-page {
            background: #f5f7fb;
            min-height: calc(100vh - 80px);
        }

        .bank-hero {
            position: relative;
            overflow: hidden;
            border-radius: 22px;
            padding: 20px 22px;
            margin-bottom: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 62%, #22c1dc 100%);
            box-shadow: 0 18px 45px rgba(37,99,235,.25);
        }

        .bank-hero:before,
        .bank-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
        }

        .bank-hero:before {
            width: 170px;
            height: 170px;
            right: -42px;
            top: -58px;
        }

        .bank-hero:after {
            width: 110px;
            height: 110px;
            right: 140px;
            bottom: -58px;
        }

        .bank-hero-content {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .bank-title-wrap {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .bank-hero-icon {
            width: 60px;
            height: 60px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.25);
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.08);
            font-size: 28px;
        }

        .bank-hero h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .bank-hero p {
            margin: 5px 0 0;
            opacity: .9;
            font-size: 13px;
        }

        .bank-hero-chip {
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 999px;
            padding: 9px 16px;
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .bank-shell {
            background: #fff;
            border: 1px solid var(--bank-border);
            border-radius: 22px;
            box-shadow: 0 14px 34px rgba(15,23,42,.08);
            overflow: hidden;
        }

        .bank-tabs-header {
            padding: 18px 18px 0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            border-bottom: 1px solid var(--bank-border);
        }

        .bank-tabs-header .nav-tabs {
            border: 0;
            gap: 12px;
            flex-wrap: wrap;
        }

        .bank-tabs-header .nav-tabs .nav-link {
            border: 1px solid var(--bank-border) !important;
            border-radius: 999px !important;
            color: #475569;
            background: #fff;
            font-weight: 800;
            padding: 11px 18px;
            min-width: 145px;
            text-align: center;
            transition: .25s ease;
            box-shadow: 0 5px 14px rgba(15,23,42,.05);
        }

        .bank-tabs-header .nav-tabs .nav-link:hover {
            transform: translateY(-2px);
            border-color: #bfdbfe !important;
            color: var(--bank-primary);
        }

        .bank-tabs-header .nav-tabs .nav-link.active {
            color: #fff !important;
            border-color: transparent !important;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
            box-shadow: 0 10px 22px rgba(37,99,235,.22);
        }

        .bank-tabs-header .nav-link i {
            margin-right: 7px;
        }

        .bank-tab-body {
            padding: 18px;
        }

        .bank-grid-card {
            border: 1px solid var(--bank-border);
            border-radius: 18px;
            background: #fff;
            overflow: hidden;
        }

        .bank-grid-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding: 16px 18px;
            border-bottom: 1px solid var(--bank-border);
            background: #f8fafc;
        }

        .bank-grid-title h5 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--bank-dark);
        }

        .bank-grid-title span {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: var(--bank-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .bank-table-wrap {
            padding: 14px;
            overflow-x: auto;
        }

        .table.dataTable,
        table.dataTable {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            width: 100% !important;
            margin: 0 !important;
        }

        .table.dataTable thead th,
        table.dataTable thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-weight: 800 !important;
            font-size: 12px !important;
            border-bottom: 1px solid #dbe4ea !important;
            padding: 12px 14px !important;
            white-space: nowrap;
            vertical-align: middle;
        }

        .table.dataTable tbody td,
        table.dataTable tbody td {
            background: #fff !important;
            color: #334155;
            font-size: 12px;
            padding: 12px 14px !important;
            border-bottom: 1px solid #eef2f7;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table.dataTable tbody tr:hover td,
        table.dataTable tbody tr:hover td {
            background: #f8fbff !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--bank-border) !important;
            border-radius: 10px !important;
            padding: 6px 10px !important;
            outline: none !important;
            background: #fff !important;
        }

        .dataTables_wrapper .dataTables_filter input:focus,
        .dataTables_wrapper .dataTables_length select:focus {
            border-color: #60a5fa !important;
            box-shadow: 0 0 0 3px rgba(37,99,235,.12) !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info {
            float: left !important;
            color: var(--bank-muted);
            font-weight: 600;
            font-size: 12px;
        }

        div.dt-buttons {
            position: static;
            padding-left: 14px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            background: linear-gradient(120deg, #16a34a, #22c55e) !important;
            border: 0 !important;
            border-radius: 10px !important;
            box-shadow: 0 8px 18px rgba(22,163,74,.18) !important;
            font-weight: 800 !important;
            margin: 0 8px !important;
            padding: 7px 14px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 9px !important;
            border: 1px solid var(--bank-border) !important;
            margin: 0 3px !important;
            padding: 5px 10px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            color: #fff !important;
            border: 0 !important;
            background: linear-gradient(120deg, #1d4ed8, #22c1dc) !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 700 !important;
            border: none !important;
            color: #475569;
        }

        @media (max-width: 767px) {
            .bank-page { padding: 12px; }
            .bank-hero { padding: 20px; border-radius: 18px; }
            .bank-hero h3 { font-size: 20px; }
            .bank-title-wrap { align-items: flex-start; }
            .bank-hero-icon { width: 54px; height: 54px; font-size: 23px; }
            .bank-tabs-header .nav-tabs .nav-link { min-width: 100%; }
            div.dt-buttons { padding-left: 0; margin-top: 8px; }
        }
    </style>

    <script>
        $(document).ready(function () {
            bankapproval_bindgrid();
            bankpending_bindgrid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="bank-page">
        <div class="bank-hero">
            <div class="bank-hero-content">
                <div class="bank-title-wrap">
                    <div class="bank-hero-icon">
                        <i class="fas fa-university"></i>
                    </div>
                    <div>
                        <h3>Bank Details Approval Report</h3>
                        <p>Review approved and pending employee bank verification details in one place.</p>
                    </div>
                </div>
                <div class="bank-hero-chip">
                    <i class="fas fa-shield-alt"></i>
                    Secure Verification
                </div>
            </div>
        </div>

        <div class="bank-shell">
            <div class="bank-tabs-header">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                            <i class="fas fa-check-circle"></i> Approved
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">
                            <i class="fas fa-clock"></i> Pending
                        </a>
                    </li>
                </ul>
            </div>

            <div class="bank-tab-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="bank-grid-card">
                            <div class="bank-grid-title">
                                <h5><i class="fas fa-user-check"></i> Approved Bank Details</h5>
                                <span><i class="fas fa-file-excel"></i> Export available from grid actions</span>
                            </div>
                            <div class="bank-table-wrap">
                                <table class="table" id="bankapproval_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Verified Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <div class="bank-grid-card">
                            <div class="bank-grid-title">
                                <h5><i class="fas fa-hourglass-half"></i> Pending Bank Details</h5>
                                <span><i class="fas fa-search"></i> Search and verify pending entries quickly</span>
                            </div>
                            <div class="bank-table-wrap">
                                <table class="table" id="bankpending_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
