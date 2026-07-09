<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceHrReport.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceHrReport" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --upr-primary: #1d4ed8;
            --upr-primary-2: #2563eb;
            --upr-cyan: #22c1dc;
            --upr-dark: #0f172a;
            --upr-muted: #64748b;
            --upr-border: #e2e8f0;
            --upr-soft: #f8fafc;
            --upr-white: #ffffff;
        }

        .upr-hero {
            position: relative;
            overflow: hidden;
            border-radius: 18px;
            padding: 22px 24px;
            margin-bottom: 16px;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            color: #fff;
            box-shadow: 0 14px 35px rgba(37, 99, 235, .22);
        }

        .upr-hero:before,
        .upr-hero:after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255,255,255,.14);
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
            width: 58px;
            height: 58px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.18);
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.24);
            font-size: 26px;
        }

        .upr-hero h4 {
            margin: 0;
            font-size: 21px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .upr-hero p {
            margin: 4px 0 0;
            opacity: .92;
            font-size: 13px;
        }

        .upr-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.22);
            font-weight: 700;
            font-size: 12px;
            white-space: nowrap;
        }

        .upr-filter-card,
        .upr-report-card {
            background: var(--upr-white);
            border: 1px solid var(--upr-border);
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(15,23,42,.07);
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
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: linear-gradient(135deg, var(--upr-primary-2), var(--upr-cyan));
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
            border-radius: 12px;
            box-shadow: none !important;
            font-size: 13px;
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
            border-radius: 12px;
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
            background: linear-gradient(135deg, var(--upr-primary), var(--upr-cyan));
            box-shadow: 0 10px 22px rgba(37,99,235,.22);
        }

        .upr-btn-success {
            color: #fff;
            background: linear-gradient(135deg, #16a34a, #22c55e);
            box-shadow: 0 10px 22px rgba(34,197,94,.20);
        }

        .upr-btn:hover {
            transform: translateY(-2px);
            color: #fff;
        }

        .upr-tabs-card {
            border: 0;
            box-shadow: none;
            margin-bottom: 0;
        }

        .upr-tabs-card > .card-header {
            background: #f8fafc;
            border: 1px solid var(--upr-border);
            border-bottom: 0;
            border-radius: 16px 16px 0 0;
            padding: 10px 10px 0 !important;
        }

        .upr-tabs-card > .card-body {
            border: 1px solid var(--upr-border);
            border-radius: 0 0 16px 16px;
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
            border-radius: 12px 12px 0 0;
            font-weight: 800;
            font-size: 13px;
            padding: 10px 14px;
            transition: all .22s ease;
        }

        .upr-sub-tabs .nav-link {
            border-radius: 999px !important;
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
            background: linear-gradient(135deg, var(--upr-primary), var(--upr-cyan)) !important;
            color: #fff !important;
            border-color: transparent !important;
            box-shadow: 0 8px 18px rgba(37,99,235,.18);
        }

        .upr-data-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--upr-border);
            border-radius: 14px;
            background: #fff;
            padding: 8px;
        }

        .upr-data-wrap .table {
            margin-bottom: 0 !important;
            width: 100% !important;
        }

        table.dataTable thead th,
        .upr-data-wrap table thead th {
            white-space: nowrap !important;
            text-align: center !important;
            background: #edf3f6 !important;
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
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid #dbe3ef;
            border-radius: 10px;
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
            background: linear-gradient(135deg, #16a34a, #22c55e) !important;
            border: 0 !important;
            border-radius: 10px !important;
            font-weight: 800 !important;
            margin: 0 8px 8px 0 !important;
            box-shadow: 0 8px 16px rgba(34,197,94,.18) !important;
        }

        .dataTables_paginate {
            float: right;
            text-align: right;
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
            border-radius: 18px;
            box-shadow: 0 16px 45px rgba(15,23,42,.20);
            font-size: 13px !important;
            font-weight: 800 !important;
            color: #334155;
        }

        .waiting-box {
            border-radius: 18px;
            border: 0;
            box-shadow: 0 18px 50px rgba(15,23,42,.20);
        }

        .excel-steps {
            list-style: none;
            padding-left: 0;
            font-size: 14px;
            max-height: 250px;
            overflow-y: auto;
            margin-bottom: 0;
        }

        .excel-steps li,
        #excelSteps li {
            padding: 8px 10px;
            border-radius: 10px;
            margin-bottom: 6px;
            transition: all .3s ease;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .step-active,
        .activeStep {
            background-color: #eff6ff !important;
            border-left: 4px solid #2563eb !important;
            font-weight: 800;
        }

        .step-done {
            background-color: #dcfce7 !important;
            color: #166534 !important;
            border-color: #bbf7d0 !important;
            font-weight: 800;
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
            .upr-hero { padding: 18px; border-radius: 14px; }
            .upr-hero-left { align-items: flex-start; }
            .upr-hero-icon { width: 48px; height: 48px; font-size: 21px; }
            .upr-hero h4 { font-size: 17px; }
            .upr-card-body { padding: 14px; }
            .upr-actions { justify-content: stretch; }
            .upr-btn { width: 100%; }
            .upr-main-tabs .nav-link,
            .upr-sub-tabs .nav-link { width: 100%; text-align: center; border-radius: 12px !important; }
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
            <div class="modal-content p-4 waiting-box">
                <div class="text-center mb-3">
                    <div class="spinner-border text-success" role="status" style="width:3rem;height:3rem;"></div>
                    <h5 class="mt-3">Preparing Excel File<span class="dots"></span></h5>
                    <div class="progress mt-3" style="height:10px;border-radius:20px;">
                        <div id="excelProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width:0%"></div>
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
