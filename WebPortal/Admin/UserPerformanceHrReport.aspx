<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceHrReport.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceHrReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --upr-primary: #155e75;
            --upr-primary-2: #0f766e;
            --upr-cyan: #0891b2;
            --upr-success: #16a34a;
            --upr-dark: #0f172a;
            --upr-muted: #64748b;
            --upr-border: #e2e8f0;
            --upr-soft: #f8fafc;
            --upr-white: #ffffff;
        }

        .upr-page {
            min-height: calc(100vh - 120px);
            background: #f6f8fb;
        }

        .upr-hero {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            padding: 18px 20px;
            margin-bottom: 16px;
            background: #fff;
            color: var(--upr-dark);
            border: 1px solid var(--upr-border);
            box-shadow: 0 10px 26px rgba(15,23,42,.06);
        }

        .upr-hero:before,
        .upr-hero:after {
            display: none;
        }

        .upr-hero:before {
            width: 180px;
            height: 180px;
            right: -50px;
            top: -60px;
        }

        .upr-hero:after {
            width: 110px;
            height: 110px;
            right: 120px;
            bottom: -55px;
        }

        .upr-hero-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
        }

        .upr-hero-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .upr-hero-icon {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
            font-size: 22px;
        }

        .upr-hero h4 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .upr-hero p {
            margin: 4px 0 0;
            color: var(--upr-muted);
            font-size: 13px;
        }

        .upr-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            color: #166534;
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .upr-filter-card,
        .upr-report-card {
            background: var(--upr-white);
            border: 1px solid var(--upr-border);
            border-radius: 8px;
            box-shadow: 0 10px 26px rgba(15,23,42,.05);
            margin-bottom: 16px;
        }

        .upr-card-body {
            padding: 18px;
        }

        .upr-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            color: var(--upr-dark);
            margin-bottom: 14px;
        }

        .upr-section-title i {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: var(--upr-primary);
        }

        .upr-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 12px;
            font-weight: 800;
        }

        .upr-field .form-control {
            min-height: 42px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            box-shadow: none !important;
            font-size: 13px;
            background: #fff;
        }

        .upr-field .form-control:focus {
            border-color: var(--upr-primary-2);
            box-shadow: 0 0 0 3px rgba(37,99,235,.12) !important;
        }

        .upr-actions {
            display: flex;
            align-items: flex-end;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
            height: 100%;
        }

        .upr-btn {
            min-height: 42px;
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-weight: 800;
            transition: all .22s ease;
            white-space: nowrap;
        }

        .upr-btn-primary {
            color: #fff;
            background: var(--upr-primary);
            box-shadow: 0 8px 18px rgba(21,94,117,.18);
        }

        .upr-btn-success {
            color: #fff;
            background: var(--upr-success);
            box-shadow: 0 8px 18px rgba(22,163,74,.18);
        }

        .upr-btn:hover {
            transform: translateY(-2px);
            color: #fff;
        }

        .upr-tabs-card {
            border: 0;
            box-shadow: none;
            margin-bottom: 0;
            background: transparent;
        }

        .upr-tabs-card > .card-header {
            background: transparent;
            border: 0;
            padding: 0 0 12px !important;
        }

        .upr-tabs-card > .card-body {
            border: 1px solid var(--upr-border);
            border-radius: 8px;
            padding: 14px;
            background: #fff;
        }

        .upr-main-tabs,
        .upr-sub-tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            border: 0 !important;
        }

        .upr-main-tabs .nav-link,
        .upr-sub-tabs .nav-link {
            border: 1px solid #dbe3ef !important;
            background: #fff;
            color: #334155;
            border-radius: 8px !important;
            font-weight: 800;
            font-size: 13px;
            padding: 10px 14px;
            transition: all .22s ease;
        }

        .upr-sub-tabs .nav-link {
            border-radius: 8px !important;
            padding: 8px 13px;
            font-size: 12px;
        }

        .upr-main-tabs .nav-link:hover,
        .upr-sub-tabs .nav-link:hover {
            background: #eef6ff;
            color: var(--upr-primary);
        }

        .upr-main-tabs .nav-link.active,
        .upr-sub-tabs .nav-link.active {
            background: var(--upr-primary) !important;
            color: #fff !important;
            border-color: transparent !important;
            box-shadow: 0 8px 18px rgba(21,94,117,.16);
        }

        .upr-data-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--upr-border);
            border-radius: 8px;
            background: #fff;
            padding: 0;
        }

        .upr-data-wrap .table {
            margin-bottom: 0 !important;
            width: 100% !important;
        }

        table.dataTable thead th,
        .upr-data-wrap table thead th {
            white-space: nowrap !important;
            text-align: center !important;
            background: #f1f5f9 !important;
            color: #0f172a !important;
            font-weight: 800 !important;
            border-bottom: 1px solid #dbe3ef !important;
            vertical-align: middle !important;
        }

        .table.dataTable tr td,
        .upr-data-wrap table td {
            background: none;
            vertical-align: middle !important;
            font-size: 12px;
            color: #334155;
        }

        .upr-data-wrap table.dataTable tbody tr:hover td {
            background: #f8fafc !important;
        }

        .upr-data-wrap .dataTables_wrapper {
            padding: 10px;
        }

        .upr-data-wrap .dataTables_info {
            color: var(--upr-muted);
            font-size: 12px;
            padding-top: 12px !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 8px;
            outline: none;
        }

        div.dt-buttons {
            position: static;
            padding-left: 0;
            float: left;
            margin-right: 12px;
        }

        .buttons-excel {
            color: #fff !important;
            background: var(--upr-success) !important;
            border: 0 !important;
            border-radius: 8px !important;
            font-weight: 800 !important;
            margin: 0 8px 8px 0 !important;
            box-shadow: 0 8px 16px rgba(22,163,74,.16) !important;
        }

        .dataTables_paginate {
            float: right;
            text-align: right;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 8px !important;
            border: 1px solid transparent !important;
            margin-left: 4px !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current,
        .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
            background: var(--upr-primary) !important;
            border-color: var(--upr-primary) !important;
            color: #fff !important;
        }

        .dt-center {
            text-align: center;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(15,23,42,.32);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .loading img {
            width: 78px;
            height: 78px;
        }

        .loading > div {
            background: #fff;
            padding: 22px 28px;
            border-radius: 10px;
            box-shadow: 0 16px 45px rgba(15,23,42,.20);
            font-size: 13px !important;
            font-weight: 800 !important;
            color: #334155;
        }

        #waitingpanel .modal-dialog {
            max-width: 520px;
        }

        #waitingpanel .modal-content {
            border: 0;
        }

        #waitingpanel .modal-content.waiting-box {
            position: relative;
            overflow: hidden;
            padding: 0 !important;
            border-radius: 10px;
            border: 1px solid rgba(226,232,240,.95);
            background: #fff;
            box-shadow: 0 24px 70px rgba(15,23,42,.28);
        }

        .waiting-box:before {
            content: "";
            display: block;
            height: 5px;
            background: linear-gradient(90deg, #2563eb, #06b6d4, #22c55e);
        }

        .excel-progress-panel {
            padding: 22px 24px 18px;
        }

        .excel-progress-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            text-align: left;
        }

        .excel-progress-icon {
            width: 46px;
            height: 46px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #ecfeff;
            color: #0891b2;
            border: 1px solid #cffafe;
            font-size: 20px;
            flex: 0 0 46px;
        }

        .excel-progress-title {
            margin: 0;
            color: #0f172a;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 0;
        }

        .excel-progress-subtitle {
            margin: 4px 0 0;
            color: #64748b;
            font-size: 13px;
            line-height: 1.35;
        }

        .excel-progress-track-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
        }

        .excel-progress-track {
            flex: 1 1 auto;
            height: 14px;
            padding: 3px;
            margin: 0;
            border-radius: 999px;
            background: #e2e8f0;
            box-shadow: inset 0 1px 2px rgba(15,23,42,.12);
            overflow: hidden;
        }

        .excel-progress-track .progress-bar {
            height: 100%;
            border-radius: 999px;
            background: linear-gradient(90deg, #2563eb 0%, #06b6d4 48%, #22c55e 100%) !important;
            box-shadow: 0 0 0 1px rgba(255,255,255,.25), 0 5px 12px rgba(14,165,233,.24);
            transition: width .35s ease;
        }

        .excel-progress-value {
            min-width: 48px;
            padding: 5px 9px;
            border-radius: 999px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #0f172a;
            font-size: 12px;
            font-weight: 800;
            text-align: center;
        }

        .excel-steps {
            display: grid;
            gap: 8px;
            list-style: none;
            padding: 16px 18px 18px;
            font-size: 13px;
            max-height: 275px;
            overflow-y: auto;
            margin: 0;
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
        }

        .excel-steps::-webkit-scrollbar {
            width: 8px;
        }

        .excel-steps::-webkit-scrollbar-track {
            background: #e2e8f0;
            border-radius: 999px;
        }

        .excel-steps::-webkit-scrollbar-thumb {
            background: #94a3b8;
            border-radius: 999px;
        }

        .excel-steps li,
        #excelSteps li {
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 42px;
            padding: 9px 12px;
            border-radius: 8px;
            margin: 0;
            transition: background-color .25s ease, border-color .25s ease, box-shadow .25s ease, color .25s ease;
            background: #fff;
            border: 1px solid #e2e8f0;
            color: #334155;
            font-weight: 700;
        }

        .excel-step-marker {
            width: 22px;
            height: 22px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 22px;
            border: 2px solid #cbd5e1;
            background: #fff;
        }

        .excel-step-marker:after {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 999px;
            background: #94a3b8;
        }

        .step-active,
        .activeStep {
            background: #eff6ff !important;
            border-color: #93c5fd !important;
            color: #1d4ed8 !important;
            box-shadow: 0 8px 18px rgba(37,99,235,.12);
        }

        .step-active .excel-step-marker,
        .activeStep .excel-step-marker {
            border-color: #2563eb;
            background: #dbeafe;
        }

        .step-active .excel-step-marker:after,
        .activeStep .excel-step-marker:after {
            width: 8px;
            height: 8px;
            background: #2563eb;
        }

        .step-done {
            background: #f0fdf4 !important;
            color: #166534 !important;
            border-color: #bbf7d0 !important;
            font-weight: 800;
        }

        .step-done .excel-step-marker {
            border-color: #22c55e;
            background: #dcfce7;
        }

        .step-done .excel-step-marker:after {
            content: "\2713";
            width: auto;
            height: auto;
            border-radius: 0;
            background: transparent;
            color: #15803d;
            font-size: 13px;
            font-weight: 900;
            line-height: 1;
        }

        .dots::after {
            content: '';
            animation: dots 1.5s steps(4, end) infinite;
        }

        @keyframes dots {
            0% { content: ''; }
            25% { content: '.'; }
            50% { content: '..'; }
            75% { content: '...'; }
            100% { content: ''; }
        }

        @media (max-width: 768px) {
            .upr-page { padding: 10px; }
            .upr-hero { padding: 18px; border-radius: 8px; }
            .upr-hero-left { align-items: flex-start; }
            .upr-hero-icon { width: 48px; height: 48px; font-size: 21px; }
            .upr-hero h4 { font-size: 17px; }
            .upr-card-body { padding: 14px; }
            .upr-actions { justify-content: stretch; }
            .upr-btn { width: 100%; }
            .upr-main-tabs .nav-link,
            .upr-sub-tabs .nav-link { width: 100%; text-align: center; border-radius: 8px !important; }
            #waitingpanel .modal-dialog { margin: .75rem; }
            .excel-progress-panel { padding: 18px; }
            .excel-progress-track-row { align-items: stretch; flex-direction: column; }
            .excel-progress-value { align-self: flex-end; }
            .excel-steps { max-height: 50vh; padding: 14px; }
        }
    </style>

    <script>
        $(document).ready(function () {
            $("#hrUser_fromDate").val("2025-03-26");
            $("#hrUser_toDate").val("2025-04-25");
        });

        function showData() {
            fromDate = $("#hrUser_fromDate").val();
            toDate = $("#hrUser_toDate").val();

            if (!fromDate || !toDate) {
                if (typeof Swal !== "undefined") {
                    Swal.fire({ icon: "warning", title: "Select dates", text: "Please select From Date and To Date." });
                } else {
                    alert("Select dates");
                }
                return;
            }

            NonDD_summary_bindGrid(fromDate, toDate);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="upr-page">
        <div class="upr-hero">
            <div class="upr-hero-inner">
                <div class="upr-hero-left">
                    <div class="upr-hero-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div>
                        <h4>User Performance HR Report</h4>
                        <p>Review Non-DD, Credit and Servicing productivity, feedback and attendance details.</p>
                    </div>
                </div>
                <div class="upr-chip">
                    <i class="fas fa-file-excel"></i>
                    HR Performance Analytics
                </div>
            </div>
        </div>

        <div class="upr-filter-card">
            <div class="upr-card-body">
                <div class="upr-section-title">
                    <i class="fas fa-filter"></i>
                    <span>Report Filters</span>
                </div>

                <div class="row align-items-end">
                    <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 mb-3">
                        <div class="upr-field">
                            <label for="hrUser_fromDate">From Date</label>
                            <input type="date" id="hrUser_fromDate" class="form-control" />
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 mb-3">
                        <div class="upr-field">
                            <label for="hrUser_toDate">To Date</label>
                            <input type="date" id="hrUser_toDate" class="form-control" />
                        </div>
                    </div>
                    <div class="col-xl-6 col-lg-4 col-md-12 col-sm-12 mb-3">
                        <div class="upr-actions">
                            <button type="button" class="upr-btn upr-btn-primary" onclick="showData();">
                                <i class="fas fa-search"></i>
                                <span>Show Report</span>
                            </button>
                            <button type="button" class="upr-btn upr-btn-success" onclick="exportAllDataTables();">
                                <i class="fas fa-file-excel"></i>
                                <span>Export All Excel</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="upr-report-card">
            <div class="upr-card-body">
                <div class="card card-tabs upr-tabs-card">
                    <div class="card-header">
                        <ul class="nav nav-tabs upr-main-tabs" id="custom-tabs-main-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-main-nonDD-tab" data-toggle="pill" href="#custom-tabs-main-nonDD" role="tab" aria-controls="custom-tabs-main-nonDD" aria-selected="true">
                                    <i class="fas fa-layer-group"></i> Non-DD
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-profile-tab" data-toggle="pill" onclick="cred_summary_bindGrid();" href="#custom-tabs-main-Crdit" role="tab" aria-controls="custom-tabs-main-Crdit" aria-selected="false">
                                    <i class="fas fa-credit-card"></i> Credit
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-feedback-tab" data-toggle="pill" onclick="serv_summary_bindGrid();" href="#custom-tabs-main-Servicing" role="tab" aria-controls="custom-tabs-main-Servicing" aria-selected="false">
                                    <i class="fas fa-headset"></i> Servicing
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-main-nonDD" role="tabpanel" aria-labelledby="custom-tabs-main-nonDD-tab">
                                <div class="card card-tabs upr-tabs-card">
                                    <div class="card-header">
                                        <ul class="nav nav-tabs upr-sub-tabs" id="custom-tabs-inner-tab_1" role="tablist">
                                            <li class="nav-item"><a class="nav-link active" id="custom-tabs-nonDD-tab-1" onclick="NonDD_summary_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-1" role="tab" aria-controls="custom-tabs-nonDD" aria-selected="true"><i class="fas fa-list"></i> Summary</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-nonDD-tab-2" onclick="NonDD_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-2" role="tab" aria-controls="custom-tabs-nonDD_Prod" aria-selected="false"><i class="fas fa-industry"></i> Production Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-nonDD-tab-3" onclick="NonDD_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-3" role="tab" aria-controls="custom-tabs-nonDD_Qual" aria-selected="false"><i class="fas fa-comments"></i> Feedback Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-nonDD-tab-4" onclick="NonDD_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-4" role="tab" aria-controls="custom-tabs-nonDD_Attn" aria-selected="false"><i class="fas fa-calendar-check"></i> Attendance Details</a></li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-nonDD">
                                            <div class="tab-pane fade show active" id="custom-tabs-nonDD-sub-1" role="tabpanel" aria-labelledby="custom-tabs-nonDD"><div class="upr-data-wrap"><table class="table" id="table_nondd_Summary" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-2" role="tabpanel" aria-labelledby="custom-tabs-nonDD-Prod"><div class="upr-data-wrap"><table class="table" id="table_nondd_prod" style="width:100%"></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-3" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Qual"><div class="upr-data-wrap"><table class="table" id="table_nondd_feedback" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-4" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Attn"><div class="upr-data-wrap"><table class="table" id="table_nondd_attn" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-main-Crdit" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div class="card card-tabs upr-tabs-card">
                                    <div class="card-header">
                                        <ul class="nav nav-tabs upr-sub-tabs" id="custom-tabs-inner-tab_2" role="tablist">
                                            <li class="nav-item"><a class="nav-link active" id="custom-tabs-Crdit-tab-1" data-toggle="pill" href="#custom-tabs-Crdit-sub-1" role="tab" aria-controls="custom-tabs-Crdit" aria-selected="true"><i class="fas fa-list"></i> Summary</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Crdit-tab-2" onclick="cred_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-2" role="tab" aria-controls="custom-tabs-Crdit_Prod" aria-selected="false"><i class="fas fa-industry"></i> Production Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Crdit-tab-3" onclick="cred_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-3" role="tab" aria-controls="custom-tabs-Crdit_Qual" aria-selected="false"><i class="fas fa-comments"></i> Feedback Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Crdit-tab-4" onclick="cred_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-4" role="tab" aria-controls="custom-tabs-Crdit_Attn" aria-selected="false"><i class="fas fa-calendar-check"></i> Attendance Details</a></li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Crdit">
                                            <div class="tab-pane fade show active" id="custom-tabs-Crdit-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Crdit"><div class="upr-data-wrap"><table class="table" id="table_cred_Summary" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Prod"><div class="upr-data-wrap"><table class="table" id="table_cred_prod" style="width:100%"></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Qual"><div class="upr-data-wrap"><table class="table" id="table_cred_feedback" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Attn"><div class="upr-data-wrap"><table class="table" id="table_cred_attn" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-main-Servicing" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                                <div class="card card-tabs upr-tabs-card">
                                    <div class="card-header">
                                        <ul class="nav nav-tabs upr-sub-tabs" id="custom-tabs-inner-tab_3" role="tablist">
                                            <li class="nav-item"><a class="nav-link active" id="custom-tabs-Servicing-tab-1" data-toggle="pill" href="#custom-tabs-Servicing-sub-1" role="tab" aria-controls="custom-tabs-Servicing" aria-selected="true"><i class="fas fa-list"></i> Summary</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Servicing-tab-2" onclick="serv_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-2" role="tab" aria-controls="custom-tabs-Servicing_Prod" aria-selected="false"><i class="fas fa-industry"></i> Production Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Servicing-tab-3" onclick="serv_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-3" role="tab" aria-controls="custom-tabs-Servicing_Qual" aria-selected="false"><i class="fas fa-comments"></i> Feedback Details</a></li>
                                            <li class="nav-item"><a class="nav-link" id="custom-tabs-Servicing-tab-4" onclick="serv_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-4" role="tab" aria-controls="custom-tabs-Servicingt_Attn" aria-selected="false"><i class="fas fa-calendar-check"></i> Attendance Details</a></li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Servicing">
                                            <div class="tab-pane fade show active" id="custom-tabs-Servicing-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Servicing"><div class="upr-data-wrap"><table class="table" id="table_serv_Summary" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Prod"><div class="upr-data-wrap"><table class="table" id="table_serv_prod" style="width:100%"></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Qual"><div class="upr-data-wrap"><table class="table" id="table_serv_feedback" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Attn"><div class="upr-data-wrap"><table class="table" id="table_serv_attn" style="width:100%"><thead></thead><tbody></tbody></table></div></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-backdrop="static" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content waiting-box">
                <div class="excel-progress-panel">
                    <div class="excel-progress-heading">
                        <div class="excel-progress-icon"><i class="fas fa-file-excel"></i></div>
                        <div>
                            <h5 class="excel-progress-title">Preparing Excel File<span class="dots"></span></h5>
                            <p class="excel-progress-subtitle">Collecting report sheets and formatting workbook</p>
                        </div>
                    </div>
                    <div class="excel-progress-track-row">
                        <div class="progress excel-progress-track">
                            <div id="excelProgressBar" class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-label="Excel export progress" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0" style="width:0%"></div>
                        </div>
                        <span id="excelProgressText" class="excel-progress-value">0%</span>
                    </div>
                </div>
                <ul id="excelSteps" class="excel-steps">
                    <li id="step1" data-label="NonDD Summary"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">NonDD Summary</span></li>
                    <li id="step2" data-label="NonDD Production"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">NonDD Production</span></li>
                    <li id="step3" data-label="NonDD Feedback"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">NonDD Feedback</span></li>
                    <li id="step4" data-label="NonDD Attendance"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">NonDD Attendance</span></li>
                    <li id="step5" data-label="Credit Summary"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Credit Summary</span></li>
                    <li id="step6" data-label="Credit Production"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Credit Production</span></li>
                    <li id="step7" data-label="Credit Feedback"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Credit Feedback</span></li>
                    <li id="step8" data-label="Credit Attendance"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Credit Attendance</span></li>
                    <li id="step9" data-label="Servicing Summary"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Servicing Summary</span></li>
                    <li id="step10" data-label="Servicing Production"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Servicing Production</span></li>
                    <li id="step11" data-label="Servicing Feedback"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Servicing Feedback</span></li>
                    <li id="step12" data-label="Servicing Attendance"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Servicing Attendance</span></li>
                    <li id="step13" data-label="Finalizing Excel"><span class="excel-step-marker" aria-hidden="true"></span><span class="excel-step-name">Finalizing Excel</span></li>
                </ul>
            </div>
        </div>
    </div>

    <iframe id="downloadFrame" style="display:none;"></iframe>

</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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
            float: right;
            text-align: right;
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
            margin: 0px 10px;
        }

        table.dataTable thead th {
            white-space: normal !important;
            word-wrap: break-word;
            text-align: left !important;
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

  
    <script>

        $(document).ready(function () {

            $("#hrUser_fromDate").val("2025-03-26");
            $("#hrUser_toDate").val("2025-04-25");

            //$("#hrUser_fromDate").datepicker("setDate", new Date(2026, 0, 26)); // Month is 0-indexed

            //$("#hrUser_fromDate").val("01/26/2026");
            //$("#hrUser_toDate").val("02/25/2026");
        });


        function showData() {

            fromDate = $("#hrUser_fromDate").val();
            toDate = $("#hrUser_toDate").val();

            // fromDate = "26-Jan-2026";
            // toDate = "25-Feb-2026";

            if (!fromDate || !toDate) {
                alert("Select dates");
                return;
            }

            NonDD_summary_bindGrid(fromDate, toDate);
        }

    </script>
   
    <script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <asp:Button ID="btnhr1" runat="server" Style="display: none;" OnClick="btnhr1_Click" />

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Performance HR Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td>
                            <b>From Date :</b>
                        </td>
                        <td>
                            <input type="date" id="hrUser_fromDate" class="form-control">
                        </td>
                        <td>
                            <b>To Date :</b>
                        </td>
                        <td>
                            <input type="date" id="hrUser_toDate" class="form-control">
                        </td>
                        <td>
                            <button type="button" class="btn btn-primary" onclick="showData();">Show</button>
                            <button type="button" class="btn btn-success" onclick="exportAllDataTables()">Export All Excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-main-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-main-nonDD-tab" data-toggle="pill" href="#custom-tabs-main-nonDD" role="tab" aria-controls="custom-tabs-main-nonDD" aria-selected="true">Non-DD</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-profile-tab" data-toggle="pill" onclick="cred_summary_bindGrid();" href="#custom-tabs-main-Crdit" role="tab" aria-controls="custom-tabs-main-Crdit" aria-selected="false">Credit</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-feedback-tab" data-toggle="pill" onclick="serv_summary_bindGrid();" href="#custom-tabs-main-Servicing" role="tab" aria-controls="custom-tabs-main-Servicing" aria-selected="false">Servicing</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-main-nonDD" role="tabpanel" aria-labelledby="custom-tabs-main-nonDD-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_1" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-nonDD-tab-1" onclick="NonDD_summary_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-1" role="tab" aria-controls="custom-tabs-nonDD" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-2" onclick="NonDD_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-2" role="tab" aria-controls="custom-tabs-nonDD_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-3" onclick="NonDD_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-3" role="tab" aria-controls="custom-tabs-nonDD_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-4" onclick="NonDD_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-4" role="tab" aria-controls="custom-tabs-nonDD_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-nonDD">
                                            <div class="tab-pane fade show active" id="custom-tabs-nonDD-sub-1" role="tabpanel" aria-labelledby="custom-tabs-nonDD">
                                                <div class="table-responsive">
                                                    <table class="table" id="table_nondd_Summary" style="width: 100%">
                                                        <thead> </thead>
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-2" role="tabpanel" aria-labelledby="custom-tabs-nonDD-Prod">
                                                <table class="table" id="table_nondd_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-3" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Qual">
                                                <table class="table" id="table_nondd_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-4" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Attn">
                                                <table class="table" id="table_nondd_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-main-Crdit" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_2" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-Crdit-tab-1" data-toggle="pill" href="#custom-tabs-Crdit-sub-1" role="tab" aria-controls="custom-tabs-Crdit" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-2" onclick="cred_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-2" role="tab" aria-controls="custom-tabs-Crdit_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-3" onclick="cred_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-3" role="tab" aria-controls="custom-tabs-Crdit_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-4" onclick="cred_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-4" role="tab" aria-controls="custom-tabs-Crdit_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Crdit">
                                            <div class="tab-pane fade show active" id="custom-tabs-Crdit-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Crdit">
                                                <table class="table" id="table_cred_Summary" style="width: 100%">
                                                    <thead> </thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Prod">
                                                <table class="table" id="table_cred_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Qual">
                                                <table class="table" id="table_cred_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Attn">
                                                <table class="table" id="table_cred_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade show" id="custom-tabs-main-Servicing" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_3" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-Servicing-tab-1" data-toggle="pill" href="#custom-tabs-Servicing-sub-1" role="tab" aria-controls="custom-tabs-Servicing" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-2" onclick="serv_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-2" role="tab" aria-controls="custom-tabs-Servicing_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-3" onclick="serv_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-3" role="tab" aria-controls="custom-tabs-Servicing_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-4" onclick="serv_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-4" role="tab" aria-controls="custom-tabs-Servicingt_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Servicing">
                                            <div class="tab-pane fade show active" id="custom-tabs-Servicing-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Servicing">
                                                <table class="table" id="table_serv_Summary" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Prod">
                                                <table class="table" id="table_serv_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Qual">
                                                <table class="table" id="table_serv_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Attn">
                                                <table class="table" id="table_serv_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-4 waiting-box">

                <div class="text-center mb-3">
                    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;">
                    </div>
                    <h5 class="mt-3">Preparing Excel File<span class="dots"></span></h5>
                    <div class="progress mt-3">
                        <div id="excelProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width: 0%"></div>
                    </div>
                </div>

                <ul id="excelSteps" class="excel-steps">
                    <li id="step1">⬜ NonDD Summary</li>
                    <li id="step2">⬜ NonDD Production</li>
                    <li id="step3">⬜ NonDD Feedback</li>
                    <li id="step4">⬜ NonDD Attendance</li>

                    <li id="step5">⬜ Credit Summary</li>
                    <li id="step6">⬜ Credit Production</li>
                    <li id="step7">⬜ Credit Feedback</li>
                    <li id="step8">⬜ Credit Attendance</li>

                    <li id="step9">⬜ Servicing Summary</li>
                    <li id="step10">⬜ Servicing Production</li>
                    <li id="step11">⬜ Servicing Feedback</li>
                    <li id="step12">⬜ Servicing Attendance</li>

                    <li id="step13">⬜ Finalizing Excel</li>
                </ul>
            </div>
        </div>
    </div>

    <iframe id="downloadFrame" style="display: none;"></iframe>

    <style>
        #excelSteps li {
            padding: 6px;
        }

        .activeStep {
            background-color: #E6FFE6;
            border-left: 4px solid #228B22;
            font-weight: bold;
        }

        .step-done {
            background-color: #d4edda;
            color: #155724;
            border-radius: 5px;
        }

        .dots::after {
            content: '';
            animation: dots 1.5s steps(4, end) infinite;
        }

        @keyframes dots {
            0% {
                content: '';
            }

            25% {
                content: '.';
            }

            50% {
                content: '..';
            }

            75% {
                content: '...';
            }

            100% {
                content: '';
            }
        }

        .waiting-box {
            border-radius: 12px;
        }

        .excel-steps {
            list-style: none;
            padding-left: 0;
            font-size: 14px;
            max-height: 220px;
            overflow-y: auto;
        }

            .excel-steps li {
                padding: 6px 10px;
                border-radius: 6px;
                margin-bottom: 4px;
                transition: all 0.3s ease;
            }

        .step-active {
            background-color: #e9f7ef;
            font-weight: 600;
        }

        .step-done {
            background-color: #d4edda;
            color: #155724;
        }
    </style>

     <link rel="stylesheet" href="dist/css/adminlte.min.css">
 <link rel="stylesheet" href="dist/css/custom-style.css">
</asp:Content>--%>
