<%@ Page Title="Today Status" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="TodaySatus.aspx.cs" Inherits="WebPortal.Tracking.TodaySatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Tracking/TodaySatus.js?v=1.0"></script>
    <style>
        .content .container { max-width: 1500px; }
        .status-page { color: #1f2937; padding: 18px 0 30px; }
        .status-hero, .status-panel {
            border: 1px solid #dbe7f4;
            border-radius: 8px;
            background: #ffffff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .06);
        }
        .status-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 20px 22px;
            border-left: 5px solid #7c3aed;
            margin-bottom: 16px;
        }
        .status-hero h1 { margin: 0; font-size: 25px; font-weight: 800; color: #0f172a; letter-spacing: 0; }
        .status-hero p { margin: 6px 0 0; color: #64748b; font-size: 13px; }
        .status-badge { display: inline-flex; align-items: center; gap: 8px; padding: 10px 12px; border-radius: 8px; background: #f5f3ff; border: 1px solid #ddd6fe; color: #6d28d9; font-weight: 800; white-space: nowrap; }
        .status-panel { margin-bottom: 16px; overflow: hidden; }
        .status-panel-head { padding: 15px 18px; border-bottom: 1px solid #e5edf6; background: #f8fafc; display: flex; justify-content: space-between; align-items: center; gap: 12px; }
        .status-panel-head h2 { margin: 0; color: #0f172a; font-size: 18px; font-weight: 800; }
        .status-panel-head span { color: #64748b; font-size: 12px; }
        .status-panel-body { padding: 18px; }
        .status-field label { display: block; margin-bottom: 7px; color: #475569; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .status-field .form-control { border: 1px solid #cbd5e1; border-radius: 7px; min-height: 40px; font-size: 13px; color: #0f172a; }
        .status-field .form-control:focus { border-color: #7c3aed; box-shadow: 0 0 0 3px rgba(124, 58, 237, .12); }
        .status-actions { display: flex; flex-wrap: wrap; justify-content: flex-end; align-items: center; gap: 10px; margin-top: 12px; }
        .status-btn { border: 0; border-radius: 7px; padding: 10px 14px; font-weight: 800; font-size: 13px; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; }
        .status-btn.primary { color: #ffffff; background: #7c3aed; }
        .status-btn.neutral { color: #334155; background: #e2e8f0; }
        .status-stats { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; margin-bottom: 16px; }
        .status-stat { border: 1px solid #e2e8f0; border-top: 4px solid #7c3aed; border-radius: 8px; background: #ffffff; padding: 13px; min-height: 74px; }
        .status-stat strong { display: block; font-size: 22px; color: #0f172a; line-height: 1.1; }
        .status-stat span { color: #64748b; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .status-stat.pending { border-top-color: #f59e0b; }
        .status-stat.done { border-top-color: #047857; }
        table.dataTable { width: 100% !important; }
        @media (max-width: 768px) {
            .status-hero, .status-panel-head { flex-direction: column; align-items: flex-start; }
            .status-actions { justify-content: stretch; }
            .status-btn { flex: 1 1 auto; justify-content: center; }
            .status-stats { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="status-page">
        <section class="status-hero">
            <div>
                <h1>Today Status</h1>
                <p>View pending, hold, dashboard pending, and completed order status using the original Tracking Sheet queries.</p>
            </div>
            <div class="status-badge"><i class="fas fa-clipboard-list"></i><span>User Order Status</span></div>
        </section>

        <section class="status-panel">
            <div class="status-panel-head">
                <div>
                    <h2>Status Filters</h2>
                    <span>Use process and deal filters for dashboard-style drilldowns.</span>
                </div>
            </div>
            <div class="status-panel-body">
                <div class="row">
                    <div class="col-lg-2 col-md-4 status-field">
                        <label for="ts_status">Status</label>
                        <select class="form-control" id="ts_status">
                            <option value="Pending">Pending</option>
                            <option value="Hold">Hold</option>
                            <option value="DPending">Dashboard Pending</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </div>
                    <div class="col-lg-2 col-md-4 status-field">
                        <label for="ts_from_date">From Date</label>
                        <input type="date" class="form-control" id="ts_from_date" />
                    </div>
                    <div class="col-lg-2 col-md-4 status-field">
                        <label for="ts_to_date">To Date</label>
                        <input type="date" class="form-control" id="ts_to_date" />
                    </div>
                    <div class="col-lg-3 col-md-6 status-field">
                        <label for="ts_project">Project</label>
                        <select class="form-control" id="ts_project"></select>
                    </div>
                    <div class="col-lg-3 col-md-6 status-field">
                        <label for="ts_process">Process</label>
                        <select class="form-control" id="ts_process"></select>
                    </div>
                    <div class="col-lg-3 col-md-6 status-field mt-3">
                        <label for="ts_deal">Deal No</label>
                        <input type="text" class="form-control" id="ts_deal" maxlength="80" />
                    </div>
                </div>
                <div class="status-actions">
                    <button type="button" class="status-btn neutral" id="ts_btn_reset"><i class="fas fa-undo"></i>Reset</button>
                    <button type="button" class="status-btn primary" id="ts_btn_show"><i class="fas fa-search"></i>Show Status</button>
                </div>
            </div>
        </section>

        <section class="status-stats">
            <article class="status-stat"><span>Total Records</span><strong id="ts_total_count">0</strong></article>
            <article class="status-stat pending"><span>Current Status</span><strong id="ts_status_name">Pending</strong></article>
            <article class="status-stat done"><span>Date Range</span><strong id="ts_range_label">Today</strong></article>
        </section>

        <section class="status-panel">
            <div class="status-panel-head">
                <div>
                    <h2>Order Status</h2>
                    <span id="ts_table_note">No records loaded</span>
                </div>
            </div>
            <div class="status-panel-body">
                <table id="ts_status_table" class="table table-bordered table-hover table-sm"></table>
            </div>
        </section>
    </main>
</asp:Content>