<%@ Page Title="Update Dispatch Date" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="UpdateDispatchDate.aspx.cs" Inherits="WebPortal.Tracking.UpdateDispatchDate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Tracking/UpdateDispatchDate.js?v=1.0"></script>
    <style>
        .content .container { max-width: 1500px; }
        .dispatch-page { color: #1f2937; padding: 18px 0 30px; }
        .dispatch-hero, .dispatch-panel {
            border: 1px solid #dbe7f4;
            border-radius: 8px;
            background: #ffffff;
            box-shadow: 0 10px 26px rgba(15, 23, 42, .06);
        }
        .dispatch-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 20px 22px;
            border-left: 5px solid #047857;
            margin-bottom: 16px;
        }
        .dispatch-hero h1 { margin: 0; font-size: 25px; font-weight: 800; color: #0f172a; letter-spacing: 0; }
        .dispatch-hero p { margin: 6px 0 0; color: #64748b; font-size: 13px; }
        .dispatch-badge { display: inline-flex; align-items: center; gap: 8px; padding: 10px 12px; border-radius: 8px; background: #ecfdf5; border: 1px solid #bbf7d0; color: #047857; font-weight: 800; white-space: nowrap; }
        .dispatch-panel { margin-bottom: 16px; overflow: hidden; }
        .dispatch-panel-head { padding: 15px 18px; border-bottom: 1px solid #e5edf6; background: #f8fafc; display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .dispatch-panel-head h2 { margin: 0; color: #0f172a; font-size: 18px; font-weight: 800; }
        .dispatch-panel-head span { color: #64748b; font-size: 12px; }
        .dispatch-panel-body { padding: 18px; }
        .dispatch-field label { display: block; margin-bottom: 7px; color: #475569; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .dispatch-field .form-control { border: 1px solid #cbd5e1; border-radius: 7px; min-height: 40px; font-size: 13px; color: #0f172a; }
        .dispatch-field .form-control:focus { border-color: #047857; box-shadow: 0 0 0 3px rgba(4, 120, 87, .12); }
        .dispatch-actions { display: flex; flex-wrap: wrap; gap: 10px; justify-content: flex-end; align-items: center; margin-top: 12px; }
        .dispatch-btn { border: 0; border-radius: 7px; padding: 10px 14px; font-weight: 800; font-size: 13px; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; }
        .dispatch-btn.primary { color: #ffffff; background: #047857; }
        .dispatch-btn.blue { color: #ffffff; background: #2563eb; }
        .dispatch-btn.neutral { color: #334155; background: #e2e8f0; }
        .dispatch-btn:disabled { opacity: .6; cursor: not-allowed; }
        .dispatch-stats { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; margin-bottom: 16px; }
        .dispatch-stat { border: 1px solid #e2e8f0; border-top: 4px solid #047857; border-radius: 8px; background: #ffffff; padding: 13px; min-height: 74px; }
        .dispatch-stat strong { display: block; font-size: 22px; line-height: 1.1; color: #0f172a; }
        .dispatch-stat span { color: #64748b; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .dispatch-stat.info { border-top-color: #2563eb; }
        .dispatch-stat.warn { border-top-color: #f59e0b; }
        table.dataTable { width: 100% !important; }
        .table-toolbar { display: flex; justify-content: space-between; align-items: center; gap: 12px; margin-bottom: 10px; }
        .table-toolbar .mini-note { color: #64748b; font-size: 12px; font-weight: 700; }
        @media (max-width: 768px) {
            .dispatch-hero, .dispatch-panel-head, .table-toolbar { align-items: flex-start; flex-direction: column; }
            .dispatch-actions { justify-content: stretch; }
            .dispatch-btn { flex: 1 1 auto; justify-content: center; }
            .dispatch-stats { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="dispatch-page">
        <section class="dispatch-hero">
            <div>
                <h1>Update Dispatch Date</h1>
                <p>Review deal loans, select the rows to send onshore, or import dispatch dates in bulk.</p>
            </div>
            <div class="dispatch-badge"><i class="fas fa-paper-plane"></i><span>Onshore Dispatch</span></div>
        </section>

        <section class="dispatch-panel">
            <div class="dispatch-panel-head">
                <div>
                    <h2>Dispatch Selection</h2>
                    <span>Dynamic columns are loaded from the project tracking-sheet configuration.</span>
                </div>
            </div>
            <div class="dispatch-panel-body">
                <div class="row">
                    <div class="col-lg-3 col-md-6 dispatch-field">
                        <label for="udd_project">Project</label>
                        <select class="form-control" id="udd_project"></select>
                    </div>
                    <div class="col-lg-3 col-md-6 dispatch-field">
                        <label for="udd_deal">Deal No</label>
                        <select class="form-control" id="udd_deal"></select>
                    </div>
                    <div class="col-lg-3 col-md-6 dispatch-field">
                        <label for="udd_dispatch_date">Dispatch Date</label>
                        <input type="date" class="form-control" id="udd_dispatch_date" />
                    </div>
                    <div class="col-lg-3 col-md-6 dispatch-field">
                        <label for="udd_import_file">Import Dispatch File</label>
                        <input type="file" class="form-control" id="udd_import_file" accept=".xls,.xlsx,.csv" />
                    </div>
                </div>
                <div class="dispatch-actions">
                    <button type="button" class="dispatch-btn neutral" id="udd_btn_template"><i class="fas fa-file-download"></i>Template</button>
                    <button type="button" class="dispatch-btn blue" id="udd_btn_import"><i class="fas fa-upload"></i>Import File</button>
                    <button type="button" class="dispatch-btn neutral" id="udd_btn_show"><i class="fas fa-search"></i>Show Loans</button>
                    <button type="button" class="dispatch-btn primary" id="udd_btn_send"><i class="fas fa-paper-plane"></i>Send To Onshore</button>
                </div>
            </div>
        </section>

        <section class="dispatch-stats">
            <article class="dispatch-stat info"><span>Loaded Loans</span><strong id="udd_loaded_count">0</strong></article>
            <article class="dispatch-stat"><span>Selected Loans</span><strong id="udd_selected_count">0</strong></article>
            <article class="dispatch-stat warn"><span>Import Failed</span><strong id="udd_failed_count">0</strong></article>
        </section>

        <section class="dispatch-panel">
            <div class="dispatch-panel-head">
                <div>
                    <h2>Loans</h2>
                    <span>Select rows and send them to onshore with the selected dispatch date.</span>
                </div>
            </div>
            <div class="dispatch-panel-body">
                <div class="table-toolbar">
                    <span class="mini-note" id="udd_grid_note">No deal loaded</span>
                </div>
                <table id="udd_loans_table" class="table table-bordered table-hover table-sm"></table>
            </div>
        </section>

        <section class="dispatch-panel">
            <div class="dispatch-panel-head">
                <div>
                    <h2>Dispatch History</h2>
                    <span>Recent dispatch-date updates from the Tracking Sheet.</span>
                </div>
            </div>
            <div class="dispatch-panel-body">
                <table id="udd_history_table" class="table table-bordered table-hover table-sm"></table>
            </div>
        </section>

        <section class="dispatch-panel" id="udd_failed_panel" style="display:none;">
            <div class="dispatch-panel-head">
                <div>
                    <h2>Import Issues</h2>
                    <span>Rows that were not updated are listed here.</span>
                </div>
            </div>
            <div class="dispatch-panel-body">
                <table id="udd_failed_table" class="table table-bordered table-hover table-sm"></table>
            </div>
        </section>
    </main>
</asp:Content>