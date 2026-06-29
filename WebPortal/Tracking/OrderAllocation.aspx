<%@ Page Title="Order Allocation" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="OrderAllocation.aspx.cs" Inherits="WebPortal.Tracking.OrderAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Tracking/OrderAllocation.js?v=1.0"></script>
    <style>
        .content .container { max-width: 1500px; }
        .tracking-page { color: #1f2937; padding: 18px 0 30px; }
        .tracking-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 20px 22px;
            border: 1px solid #dbe7f4;
            border-left: 5px solid #2563eb;
            border-radius: 8px;
            background: #ffffff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .06);
            margin-bottom: 16px;
        }
        .tracking-title { margin: 0; font-size: 25px; font-weight: 700; color: #0f172a; letter-spacing: 0; }
        .tracking-subtitle { margin: 6px 0 0; color: #64748b; font-size: 13px; }
        .tracking-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #c7d2fe;
            background: #eef2ff;
            color: #3730a3;
            border-radius: 8px;
            padding: 10px 12px;
            font-weight: 700;
            white-space: nowrap;
        }
        .tracking-tabs {
            border: 1px solid #dbe7f4;
            border-radius: 8px;
            background: #ffffff;
            padding: 10px 10px 0;
            margin-bottom: 16px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, .05);
        }
        .tracking-tabs .nav-link {
            border: 0;
            color: #475569;
            font-weight: 700;
            border-radius: 6px 6px 0 0;
            padding: 11px 15px;
        }
        .tracking-tabs .nav-link.active { color: #0f172a; background: #eff6ff; border-bottom: 3px solid #2563eb; }
        .tracking-panel {
            border: 1px solid #dbe7f4;
            border-radius: 8px;
            background: #ffffff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .06);
            overflow: hidden;
            margin-bottom: 18px;
        }
        .tracking-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf6;
            background: #f8fafc;
        }
        .tracking-panel-head h2 { margin: 0; font-size: 18px; font-weight: 800; color: #0f172a; }
        .tracking-panel-head span { color: #64748b; font-size: 12px; }
        .tracking-panel-body { padding: 18px; }
        .tracking-field label { display: block; margin-bottom: 7px; color: #475569; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .tracking-field .form-control {
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            min-height: 40px;
            font-size: 13px;
            color: #0f172a;
        }
        .tracking-field .form-control:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37, 99, 235, .12); }
        .tracking-actions { display: flex; flex-wrap: wrap; gap: 10px; align-items: center; justify-content: flex-end; margin-top: 12px; }
        .tracking-btn {
            border: 0;
            border-radius: 7px;
            padding: 10px 14px;
            font-weight: 800;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        .tracking-btn.primary { color: #ffffff; background: #2563eb; }
        .tracking-btn.success { color: #ffffff; background: #047857; }
        .tracking-btn.warning { color: #111827; background: #fbbf24; }
        .tracking-btn.neutral { color: #334155; background: #e2e8f0; }
        .tracking-btn:disabled { opacity: .6; cursor: not-allowed; }
        .tracking-stats { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; margin-top: 16px; }
        .tracking-stat {
            border: 1px solid #e2e8f0;
            border-top: 4px solid #2563eb;
            border-radius: 8px;
            padding: 13px;
            background: #ffffff;
            min-height: 74px;
        }
        .tracking-stat strong { display: block; font-size: 22px; color: #0f172a; line-height: 1.1; }
        .tracking-stat span { color: #64748b; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .tracking-stat.good { border-top-color: #047857; }
        .tracking-stat.bad { border-top-color: #dc2626; }
        .tracking-table-wrap { padding-top: 10px; }
        table.dataTable { width: 100% !important; }
        .badge-soft { border-radius: 7px; padding: 7px 10px; background: #e0f2fe; color: #0369a1; font-weight: 800; }
        @media (max-width: 768px) {
            .tracking-hero, .tracking-panel-head { align-items: flex-start; flex-direction: column; }
            .tracking-actions { justify-content: stretch; }
            .tracking-btn { justify-content: center; flex: 1 1 auto; }
            .tracking-stats { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="tracking-page">
        <section class="tracking-hero">
            <div>
                <h1 class="tracking-title">Order Allocation</h1>
                <p class="tracking-subtitle">Import allocation, reallocation, and completed order files with the original Tracking Sheet validations.</p>
            </div>
            <div class="tracking-hero-badge"><i class="fas fa-layer-group"></i><span>Tracking Operations</span></div>
        </section>

        <section class="tracking-tabs">
            <ul class="nav nav-tabs" id="oa_tabs" role="tablist">
                <li class="nav-item"><a class="nav-link active" id="oa_allocation_tab" data-toggle="tab" href="#oa_allocation" role="tab"><i class="fas fa-user-plus mr-1"></i>Order Allocation</a></li>
                <li class="nav-item"><a class="nav-link" id="oa_reallocation_tab" data-toggle="tab" href="#oa_reallocation" role="tab"><i class="fas fa-random mr-1"></i>Order Reallocation</a></li>
                <li class="nav-item"><a class="nav-link" id="oa_complete_tab" data-toggle="tab" href="#oa_complete" role="tab"><i class="fas fa-check-circle mr-1"></i>Order Complete</a></li>
            </ul>
        </section>

        <div class="tab-content" id="oa_tab_content">
            <section class="tab-pane fade show active" id="oa_allocation" role="tabpanel">
                <div class="tracking-panel" data-mode="allocation">
                    <div class="tracking-panel-head">
                        <div>
                            <h2>Allocate Orders</h2>
                            <span>Required columns: ProjectNo, DealNo, Date, LoanNo, Pseudo Name, Process</span>
                        </div>
                        <span class="badge-soft">Pending allocation</span>
                    </div>
                    <div class="tracking-panel-body">
                        <div class="row">
                            <div class="col-md-4 tracking-field">
                                <label for="oa_project_allocation">Project</label>
                                <select class="form-control oa-project" id="oa_project_allocation" data-mode="allocation"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_process_allocation">Process</label>
                                <select class="form-control oa-process" id="oa_process_allocation" data-mode="allocation"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_file_allocation">Import File</label>
                                <input type="file" class="form-control oa-file" id="oa_file_allocation" accept=".xls,.xlsx,.csv" data-mode="allocation" />
                            </div>
                        </div>
                        <div class="tracking-actions">
                            <button type="button" class="tracking-btn neutral oa-template" data-mode="allocation"><i class="fas fa-file-download"></i>Template</button>
                            <button type="button" class="tracking-btn primary oa-import" data-mode="allocation"><i class="fas fa-upload"></i>Import Allocation</button>
                        </div>
                        <div class="tracking-stats">
                            <article class="tracking-stat"><span>Total Rows</span><strong id="oa_total_allocation">0</strong></article>
                            <article class="tracking-stat good"><span>Imported</span><strong id="oa_success_allocation">0</strong></article>
                            <article class="tracking-stat bad"><span>Failed</span><strong id="oa_failed_count_allocation">0</strong></article>
                        </div>
                        <div class="tracking-table-wrap">
                            <table id="oa_failed_allocation" class="table table-bordered table-hover table-sm"></table>
                        </div>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="oa_reallocation" role="tabpanel">
                <div class="tracking-panel" data-mode="reallocation">
                    <div class="tracking-panel-head">
                        <div>
                            <h2>Reallocate Orders</h2>
                            <span>Uses the same import format and pseudo-name validation as the original screen.</span>
                        </div>
                        <span class="badge-soft">Reallocation</span>
                    </div>
                    <div class="tracking-panel-body">
                        <div class="row">
                            <div class="col-md-4 tracking-field">
                                <label for="oa_project_reallocation">Project</label>
                                <select class="form-control oa-project" id="oa_project_reallocation" data-mode="reallocation"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_process_reallocation">Process</label>
                                <select class="form-control oa-process" id="oa_process_reallocation" data-mode="reallocation"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_file_reallocation">Import File</label>
                                <input type="file" class="form-control oa-file" id="oa_file_reallocation" accept=".xls,.xlsx,.csv" data-mode="reallocation" />
                            </div>
                        </div>
                        <div class="tracking-actions">
                            <button type="button" class="tracking-btn neutral oa-template" data-mode="reallocation"><i class="fas fa-file-download"></i>Template</button>
                            <button type="button" class="tracking-btn warning oa-import" data-mode="reallocation"><i class="fas fa-sync-alt"></i>Import Reallocation</button>
                        </div>
                        <div class="tracking-stats">
                            <article class="tracking-stat"><span>Total Rows</span><strong id="oa_total_reallocation">0</strong></article>
                            <article class="tracking-stat good"><span>Imported</span><strong id="oa_success_reallocation">0</strong></article>
                            <article class="tracking-stat bad"><span>Failed</span><strong id="oa_failed_count_reallocation">0</strong></article>
                        </div>
                        <div class="tracking-table-wrap">
                            <table id="oa_failed_reallocation" class="table table-bordered table-hover table-sm"></table>
                        </div>
                    </div>
                </div>
            </section>

            <section class="tab-pane fade" id="oa_complete" role="tabpanel">
                <div class="tracking-panel" data-mode="complete">
                    <div class="tracking-panel-head">
                        <div>
                            <h2>Complete Orders</h2>
                            <span>Marks imported orders as completed using the original complete-order flow.</span>
                        </div>
                        <span class="badge-soft">Completed status</span>
                    </div>
                    <div class="tracking-panel-body">
                        <div class="row">
                            <div class="col-md-4 tracking-field">
                                <label for="oa_project_complete">Project</label>
                                <select class="form-control oa-project" id="oa_project_complete" data-mode="complete"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_process_complete">Process</label>
                                <select class="form-control oa-process" id="oa_process_complete" data-mode="complete"></select>
                            </div>
                            <div class="col-md-4 tracking-field">
                                <label for="oa_file_complete">Import File</label>
                                <input type="file" class="form-control oa-file" id="oa_file_complete" accept=".xls,.xlsx,.csv" data-mode="complete" />
                            </div>
                        </div>
                        <div class="tracking-actions">
                            <button type="button" class="tracking-btn neutral oa-template" data-mode="complete"><i class="fas fa-file-download"></i>Template</button>
                            <button type="button" class="tracking-btn success oa-import" data-mode="complete"><i class="fas fa-check"></i>Import Complete</button>
                        </div>
                        <div class="tracking-stats">
                            <article class="tracking-stat"><span>Total Rows</span><strong id="oa_total_complete">0</strong></article>
                            <article class="tracking-stat good"><span>Imported</span><strong id="oa_success_complete">0</strong></article>
                            <article class="tracking-stat bad"><span>Failed</span><strong id="oa_failed_count_complete">0</strong></article>
                        </div>
                        <div class="tracking-table-wrap">
                            <table id="oa_failed_complete" class="table table-bordered table-hover table-sm"></table>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</asp:Content>