<%@ Page Title="OST Summary Report" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="SummaryReport.aspx.cs" Inherits="WebPortal.Search.SummaryReport" %>

<asp:Content ID="SummaryHead" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --sr-primary:#0f766e; --sr-dark:#115e59; --sr-ink:#1f2937; --sr-muted:#64748b; --sr-line:#dbe4ea; --sr-soft:#f3f7f8; }
        .sr-page {  color:var(--sr-ink); }
        .sr-header { display:flex; align-items:center; justify-content:space-between; gap:16px; padding:16px 18px; margin-bottom:14px; background:#fff; border:1px solid var(--sr-line); border-left:4px solid var(--sr-primary); border-radius:10px; box-shadow:0 8px 24px rgba(15,23,42,.06); }
        .sr-heading { display:flex; align-items:center; gap:12px; }
        .sr-heading-icon { display:grid; place-items:center; width:40px; height:40px; color:#fff; background:var(--sr-primary); border-radius:9px; }
        .sr-heading h1 { margin:0; font-size:21px; font-weight:700; }
        .sr-heading p { margin:3px 0 0; color:var(--sr-muted); font-size:12px; }
        .sr-card { background:#fff; border:1px solid var(--sr-line); border-radius:10px; box-shadow:0 10px 28px rgba(15,23,42,.06); overflow:hidden; }
        .sr-report-tabs { display:flex; gap:8px; padding:14px 16px; overflow-x:auto; border-bottom:1px solid var(--sr-line); background:#fbfcfd; }
        .sr-tab { flex:0 0 auto; padding:8px 13px; color:#475569; background:#fff; border:1px solid var(--sr-line); border-radius:7px; font-size:12px; font-weight:700; cursor:pointer; }
        .sr-tab.active, .sr-tab:hover { color:#fff; background:var(--sr-primary); border-color:var(--sr-primary); }
        .sr-filters { display:grid; grid-template-columns:repeat(5,minmax(150px,1fr)); gap:14px; align-items:end; padding:16px; border-bottom:1px solid var(--sr-line); }
        .sr-field label { display:block; margin:0 0 5px; font-size:12px; font-weight:700; }
        .sr-field .form-control { height:38px; border-color:#cbd5df; border-radius:7px; box-shadow:none; font-size:13px; }
        .sr-field .form-control:focus { border-color:var(--sr-primary); box-shadow:0 0 0 3px rgba(15,118,110,.12); }
        .sr-actions { display:flex; gap:8px; justify-content:flex-end; }
        .sr-actions .btn { min-height:38px; border-radius:7px; font-size:12px; font-weight:700; }
        .btn-sr-primary { color:#fff; background:var(--sr-primary); border-color:var(--sr-primary); }
        .btn-sr-primary:hover { color:#fff; background:var(--sr-dark); }
        .sr-message { display:none; margin:14px 16px 0; padding:10px 12px; border-radius:7px; font-size:12px; font-weight:600; }
        .sr-message.error { display:block; color:#991b1b; background:#fef2f2; border:1px solid #fecaca; }
        .sr-message.info { display:block; color:#155e75; background:#ecfeff; border:1px solid #a5f3fc; }
        .sr-grid { padding:16px; }
        .sr-grid-title { display:flex; justify-content:space-between; gap:12px; align-items:center; margin-bottom:12px; }
        .sr-grid-title h2 { margin:0; font-size:15px; font-weight:700; }
        .sr-grid-title span { color:var(--sr-muted); font-size:12px; }
        .sr-table-wrap { width:100%; overflow-x:auto; border:1px solid var(--sr-line); border-radius:8px; }
        #summaryReportTable, #summaryDetailTable { width:100%!important; min-width:900px; margin:0!important; }
        #summaryReportTable thead th, #summaryDetailTable thead th { white-space:nowrap; color:#16324a; background:#eaf2f5; border-color:#d4e0e6; font-size:12px; font-weight:700; }
        #summaryReportTable tfoot th { white-space:nowrap; color:#16324a; background:#f1f5f9; border-color:#d4e0e6; font-size:12px; font-weight:800; }
        #summaryReportTable tbody td, #summaryDetailTable tbody td { white-space:nowrap; font-size:12px; vertical-align:middle; }
        .sr-link { padding:0; color:#0369a1; background:none; border:0; font-weight:700; text-decoration:underline; cursor:pointer; }
        .sr-cell-done { background:#dcfce7!important; color:#166534; font-weight:700; }
        .sr-cell-wait { background:#e0f2fe!important; color:#075985; }
        .sr-cell-hold { background:#fef3c7!important; color:#92400e; font-weight:700; }
        .sr-cell-cancel { background:#fee2e2!important; color:#991b1b; font-weight:700; }
        .sr-cell-dispatch { background:#ccfbf1!important; color:#115e59; font-weight:700; }
        .sr-cell-priority { background:#dcfce7!important; color:#166534; font-weight:700; }
        .sr-loader { display:none; position:fixed; inset:0; z-index:99999; align-items:center; justify-content:center; background:rgba(15,23,42,.3); backdrop-filter:blur(3px); }
        .sr-loader.show { display:flex; }
        .sr-loader-box { padding:20px 28px; text-align:center; background:#fff; border-radius:12px; box-shadow:0 20px 50px rgba(15,23,42,.25); font-size:12px; font-weight:700; }
        .sr-loader-box i { display:block; margin-bottom:9px; color:var(--sr-primary); font-size:25px; }
        .sr-empty { padding:42px 16px; color:var(--sr-muted); text-align:center; }
        .modal-xl { max-width:1200px; }
        @media (max-width:1100px) { .sr-filters { grid-template-columns:repeat(3,minmax(160px,1fr)); } }
        @media (max-width:700px) { .sr-page { padding-top:10px; } .sr-header { align-items:flex-start; } .sr-filters { grid-template-columns:1fr; } .sr-actions { justify-content:stretch; } .sr-actions .btn { flex:1; } .sr-grid-title { align-items:flex-start; flex-direction:column; } }
    </style>
</asp:Content>

<asp:Content ID="SummaryBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="sr-page">
        <header class="sr-header">
            <div class="sr-heading">
                <span class="sr-heading-icon"><i class="fas fa-chart-bar"></i></span>
                <div><h1>OST Summary Report</h1><p>Review order activity, performance, status, and user productivity.</p></div>
            </div>
        </header>

        <section class="sr-card">
            <nav class="sr-report-tabs" aria-label="Report type">
                <button type="button" class="sr-tab" data-mode="template">Template-wise Orders</button>
                <button type="button" class="sr-tab" data-mode="performance">Project Performance</button>
                <button type="button" class="sr-tab" data-mode="project">Project Summary</button>
                <button type="button" class="sr-tab" data-mode="user">User Summary</button>
                <button type="button" class="sr-tab" data-mode="status">Order Status</button>
                <button type="button" class="sr-tab active" data-mode="current">Current Status</button>
            </nav>

            <div class="sr-filters" id="summaryFilters">
                <div class="sr-field sr-filter-project"><label for="summaryProject">Project <span class="text-danger">*</span></label><select id="summaryProject" class="form-control"><option value="">Select Project</option></select></div>
                <div class="sr-field sr-filter-template"><label for="summaryTemplate">Template <span class="text-danger">*</span></label><select id="summaryTemplate" class="form-control" disabled><option value="">Select Template</option></select></div>
                <div class="sr-field sr-filter-from"><label for="summaryFromDate">From Date <span class="text-danger">*</span></label><input id="summaryFromDate" type="date" class="form-control" /></div>
                <div class="sr-field sr-filter-to"><label for="summaryToDate">To Date <span class="text-danger">*</span></label><input id="summaryToDate" type="date" class="form-control" /></div>
                <div class="sr-field sr-filter-status"><label for="summaryStatus">Status <span class="text-danger">*</span></label><select id="summaryStatus" class="form-control"><option value="">Select Status</option></select></div>
                <div class="sr-actions"><button type="button" id="summaryClear" class="btn btn-default"><i class="fas fa-undo"></i> Clear</button><button type="button" id="summaryShow" class="btn btn-sr-primary"><i class="fas fa-search"></i> Show Report</button></div>
            </div>

            <div id="summaryMessage" class="sr-message" role="alert"></div>
            <div class="sr-grid">
                <div class="sr-grid-title"><h2 id="summaryGridTitle">Template-wise Order Details</h2><span id="summaryGridHint">Select filters and click Show Report.</span></div>
                <div id="summaryEmpty" class="sr-empty"><i class="far fa-chart-bar fa-2x mb-2"></i><br />No report has been loaded.</div>
                <div id="summaryTableWrap" class="sr-table-wrap" style="display:none"><table id="summaryReportTable" class="table table-bordered table-hover"><thead></thead><tbody></tbody></table></div>
            </div>
        </section>
    </main>

    <div class="modal fade" id="summaryDetailModal" tabindex="-1" role="dialog" aria-labelledby="summaryDetailTitle" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document"><div class="modal-content">
            <div class="modal-header"><h5 class="modal-title" id="summaryDetailTitle">User Order Details</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body"><div class="sr-table-wrap"><table id="summaryDetailTable" class="table table-bordered table-hover"><thead></thead><tbody></tbody></table></div></div>
            <div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>
        </div></div>
    </div>

    <div id="summaryLoader" class="sr-loader" aria-hidden="true"><div class="sr-loader-box"><i class="fas fa-circle-notch fa-spin"></i>Loading report...</div></div>
</asp:Content>
