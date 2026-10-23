<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashDashboard.aspx.cs" Inherits="WebPortal.Admin.PettyCashDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261022-4") %>" rel="stylesheet" />
<div class="container-fluid py-3 pc-page"><div class="pc-hero"><div class="pc-hero-copy"><h4 class="mb-1">Petty Cash Dashboard</h4><small>Petty Cash Management</small></div><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-chart-pie"></i></span></div>
<div class="row"><div class="col-md-3 mb-3"><div class="pc-stat"><div>Current Balance</div><div class="n" id="pc_dashBalance">0.00</div></div></div><div class="col-md-3 mb-3"><div class="pc-stat"><div>Total Issued</div><div class="n" id="pc_dashIssued">0.00</div></div></div><div class="col-md-3 mb-3"><div class="pc-stat"><div>Total Expense</div><div class="n" id="pc_dashExpense">0.00</div></div></div><div class="col-md-3 mb-3"><div class="pc-stat"><div>Pending Approvals</div><div class="n" id="pc_dashPending">0</div></div></div></div>
<div class="card pc-card"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Latest activity</span><h5>Recent requests</h5><p>Track the most recent petty cash activity.</p></div><span class="pc-context-badge"><i class="fas fa-clock" aria-hidden="true"></i>Live overview</span></div><table id="pc_DashboardTable" class="table table-bordered table-striped w-100"><thead><tr><th>Request No</th><th>Date</th><th>Employee</th><th>Purpose</th><th>Amount</th><th>Status</th></tr></thead></table></div></div></div>

<div class="modal fade" id="pcMessageModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title" id="pcMessageTitle">Message</h5><button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div>
    <div class="modal-body" id="pcMessageBody"></div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">OK</button></div>
  </div></div>
</div>
<div class="modal fade" id="pcConfirmModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title" id="pcConfirmTitle">Confirmation</h5><button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div>
    <div class="modal-body" id="pcConfirmMessage"></div><div class="modal-footer"><button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary" id="pcConfirmYes">Yes</button></div>
  </div></div>
</div>
<div id="load1" style="display:none;position:fixed;z-index:20000;left:50%;top:50%;transform:translate(-50%,-50%);background:#fff;padding:14px 18px;border-radius:8px;box-shadow:0 4px 24px rgba(0,0,0,.2)"><span class="spinner-border spinner-border-sm mr-2"></span>Processing...</div>
<script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js?v=20261022-6") %>"></script>
</asp:Content>
