<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="LMSearch.aspx.cs" Inherits="WebPortal.US.LMSearch" %>

<asp:Content ID="lmsearch_head" ContentPlaceHolderID="head" runat="server">
    <style>
        body, .content-wrapper { background: #f8fafc !important; }
        .dashboard-header { background: linear-gradient(135deg, #2563eb, #7c3aed); border-radius: 15px; padding: 12px; color: #fff; margin-bottom: 25px; box-shadow: 0 8px 20px rgba(0,0,0,.12); }
        .dashboard-title { font-size: 20px; font-weight: 600; }
        .dashboard-subtitle { font-size: 12px; opacity: .9; }
        .card { border: 1px solid #e2e8f0; border-radius: 16px; box-shadow: 0 10px 30px rgba(15,23,42,.08); }
        .loading { display:none; position:fixed; inset:0; z-index:200000; align-items:center; justify-content:center; flex-direction:column; background:rgba(15,23,42,.35); backdrop-filter:blur(3px); text-align:center; }
        #lmsearch_loading.lmsearch-loading-active { display:flex !important; }
        #lmsearch_loading .lmsearch-loading-box { display:flex; flex-direction:column; align-items:center; gap:10px; padding:16px 20px; border-radius:12px; background:#fff; box-shadow:0 12px 30px rgba(15,23,42,.22); }
        #lmsearch_loading .lmsearch-loading-box img { width:56px; height:56px; }
        .reqc-pill{display:inline-flex;align-items:center;gap:6px;border-radius:999px;padding:5px 10px;font-size:11px;font-weight:800;letter-spacing:.02em;white-space:nowrap;border:1px solid transparent}.reqc-pill i{font-size:10px}.reqc-not-assigned{background:#f1f5f9;color:#64748b;border-color:#e2e8f0}.reqc-assigned{background:#fff7ed;color:#b45309;border-color:#fed7aa}.reqc-completed{background:#ecfdf5;color:#047857;border-color:#a7f3d0}.reqc-cell{min-width:220px}.reqc-status-item+.reqc-status-item{margin-top:9px}.reqc-detail{display:block;margin-top:5px;color:#64748b;font-size:11px;line-height:1.35;white-space:normal;max-width:260px}.reqc-detail strong{color:#334155;font-weight:700}
    </style>
    <script src="../Scripts/US/LMSearch.js?v=20261019.17"></script>
</asp:Content>

<asp:Content ID="lmsearch_content" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="lmsearch_loading">
        <div class="lmsearch-loading-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <span style="font-size:12px;font-weight:bold;">One moment, please . . . .</span>
        </div>
    </div>
    <div class="dashboard-header">
        <div class="dashboard-title"><i class="fas fa-hand-holding-usd mr-2"></i>Loan Details</div>
        <div class="dashboard-subtitle">View and manage LauraMac loan procedures.</div>
    </div>
    <div class="col-lg-12">
        <div class="card"><div class="card-body">
            <table class="table table-bordered" style="width:100%;" id="lmsearch_table"></table>
        </div></div>
    </div>
</asp:Content>
