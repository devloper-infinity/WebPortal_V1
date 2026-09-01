<%@ Page Title="Bulk Order Allocation" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="BulkOrderAllocation.aspx.cs" Inherits="WebPortal.US.BulkOrderAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/US/BulkOrderAllocation.js?v=1.9"></script>
    <style>
        .content .container { max-width: 1500px; }
        .tracking-page { color: #1f2937; padding-top: 18px; }
        .tracking-hero {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            min-height: 94px;
            height: 94px;
            margin: 0 0 18px 0;
            padding: 22px 28px;
            border: 0;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 18px;
            background: linear-gradient(101deg, #2854df 0%, #285fe2 45%, #2ec1cf 100%);
            color: #ffffff;
        }
        .tracking-hero::before {
            content: "";
            position: absolute;
            z-index: 0;
            right: 70px;
            top: -94px;
            width: 210px;
            height: 210px;
            border-radius: 50%;
            background: rgba(255,255,255,.13);
            pointer-events: none;
        }
        .tracking-hero::after {
            content: "";
            position: absolute;
            z-index: 0;
            right: -22px;
            top: -54px;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(255,255,255,.12);
            pointer-events: none;
        }
        .tracking-hero > * { position: relative; z-index: 1; }
        .tracking-hero-badge {
            order: -1;
            width: 50px;
            height: 50px;
            min-width: 50px;
            padding: 0;
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 16px;
            background: rgba(255,255,255,.14);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.06);
        }
        .tracking-hero-badge i { color: #ffffff; font-size: 21px; line-height: 1; margin: 0; }
        .tracking-title {
            color: #ffffff;
            font-size: 18px;
            font-weight: 800;
            line-height: 1.2;
            margin: 0;
            text-shadow: 0 1px 1px rgba(3, 48, 120, .35);
        }
        .tracking-subtitle {
            color: rgba(255,255,255,.94);
            font-size: 11px;
            font-weight: 700;
            line-height: 1.45;
            margin: 8px 0 0;
            max-width: 760px;
            text-shadow: 0 1px 1px rgba(3, 48, 120, .28);
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
        .tracking-tabs .nav-link.active {
            color: #0f172a;
            background: #eff6ff;
            border-bottom: 3px solid #2563eb;
        }
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
        .tracking-field label {
            display: block;
            margin-bottom: 7px;
            color: #475569;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }
        .tracking-field .form-control {
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            min-height: 40px;
            font-size: 13px;
            color: #0f172a;
        }
        .tracking-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
        }
        .tracking-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            justify-content: flex-end;
            margin-top: 12px;
        }
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
        .tracking-btn.neutral { color: #334155; background: #e2e8f0; }
        .tracking-btn:disabled { opacity: .6; cursor: not-allowed; }
        .tracking-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-top: 16px;
        }
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
        .badge-soft { border-radius: 7px; padding: 7px 10px; background: #e0f2fe; color: #0369a1 !important; font-weight: 800; }
        @media (max-width: 768px) {
            .tracking-hero { height: auto; min-height: 94px; padding: 18px; border-radius: 18px; }
            .tracking-hero-badge { width: 46px; height: 46px; min-width: 46px; }
            .tracking-title { font-size: 16px; }
            .tracking-subtitle { font-size: 10px; }
            .tracking-panel-head { align-items: flex-start; flex-direction: column; }
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
                <h1 class="tracking-title">Bulk Order Allocation</h1>
                <p class="tracking-subtitle">Import allocation files using the Tracking Sheet validations.</p>
            </div>
            <div class="tracking-hero-badge"><i class="fas fa-layer-group"></i></div>
        </section>

        <section class="tracking-tabs">
            <ul class="nav nav-tabs" id="boa_tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="boa_allocation_tab" data-toggle="tab" href="#boa_allocation" role="tab">
                        <i class="fas fa-upload mr-1"></i>Bulk Allocation
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="boa_status_tab" data-toggle="tab" href="#boa_status" role="tab">
                        <i class="fas fa-list-alt mr-1"></i>Allocated Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="boa_loan_status_tab" data-toggle="tab" href="#boa_loan_status" role="tab">
                        <i class="fas fa-chart-line mr-1"></i>Loan Status
                    </a>
                </li>
            </ul>
        </section>

        <div class="tab-content" id="boa_tab_content">
        <section class="tab-pane fade show active" id="boa_allocation" role="tabpanel">
        <div class="tracking-panel" data-mode="allocation">
            <div class="tracking-panel-head">
                <div>
                    <h2>Allocate Orders</h2>
                    <span>Required columns: Project, Deal #, Loan #, Employee, Process</span>
                </div>
                <span class="badge-soft">Pending allocation</span>
            </div>
            <div class="tracking-panel-body">
                <div class="row">
                    <div class="col-md-12 tracking-field">
                        <label for="oa_file_allocation">Import File</label>
                        <input type="file" class="form-control" id="oa_file_allocation" accept=".xls,.xlsx,.csv" />
                    </div>
                </div>
                <div class="tracking-actions">
                    <button type="button" class="tracking-btn neutral" id="oa_template_allocation"><i class="fas fa-file-download"></i>Template</button>
                    <button type="button" class="tracking-btn primary" id="oa_import_allocation"><i class="fas fa-upload"></i>Import Allocation File</button>
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

        <section class="tab-pane fade" id="boa_status" role="tabpanel">
            <div class="tracking-panel">
                <div class="tracking-panel-head">
                    <div>
                        <h2>Allocated Orders</h2>
                        <span>Orders allocated to PH ReQC or ATR Review, including their current status.</span>
                    </div>
                    <button type="button" class="tracking-btn neutral" id="oa_refresh_status">
                        <i class="fas fa-sync-alt"></i>Refresh
                    </button>
                </div>
                <div class="tracking-panel-body">
                    <div class="tracking-table-wrap">
                        <table id="oa_allocated_orders" class="table table-bordered table-hover table-sm"></table>
                    </div>
                </div>
            </div>
        </section>

        <section class="tab-pane fade" id="boa_loan_status" role="tabpanel">
            <div class="tracking-panel">
                <div class="tracking-panel-head">
                    <div>
                        <h2>Bulk Allocation Loan Status</h2>
                        <span>Track assigned, in-process and completed bulk-uploaded loans.</span>
                    </div>
                </div>
                <div class="tracking-panel-body">
                    <div class="row">
                        <div class="col-md-4 tracking-field">
                            <label for="oa_status_employee">Employee</label>
                            <select id="oa_status_employee" class="form-control"><option value="">All Employees</option></select>
                        </div>
                        <div class="col-md-3 tracking-field">
                            <label for="oa_status_from">From Date</label>
                            <input type="date" id="oa_status_from" class="form-control" />
                        </div>
                        <div class="col-md-3 tracking-field">
                            <label for="oa_status_to">To Date</label>
                            <input type="date" id="oa_status_to" class="form-control" />
                        </div>
                        <div class="col-md-2 tracking-field d-flex align-items-end">
                            <button type="button" class="tracking-btn primary w-100 justify-content-center" id="oa_search_loan_status">
                                <i class="fas fa-search"></i>Search
                            </button>
                        </div>
                    </div>
                    <div id="oa_loan_status_loading" class="text-center py-4" style="display:none;">
                        <i class="fas fa-spinner fa-spin mr-2"></i>Loading report...
                    </div>
                    <div class="tracking-table-wrap">
                        <table id="oa_loan_status" class="table table-bordered table-hover table-sm"></table>
                    </div>
                </div>
            </div>
        </section>
        </div>
    </main>
</asp:Content>
