<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashLedger.aspx.cs" Inherits="WebPortal.Admin.PettyCashLedger" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261023-1") %>" rel="stylesheet" />
<div class="container-fluid py-3 pc-page"><div class="pc-hero"><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-book"></i></span><div class="pc-hero-copy"><h4 class="mb-1">Petty Cash Ledger</h4><small>Petty Cash Management</small></div></div>
<div class="card pc-card"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Account activity</span><h5>Ledger filters</h5><p>Choose a date range to review transactions.</p></div><span class="pc-context-badge"><i class="fas fa-filter" aria-hidden="true"></i>Optional date range</span></div><div class="row"><div class="col-md-3"><label class="pc-label">From Date</label><input id="pc_ledFrom" type="date" class="form-control"/></div><div class="col-md-3"><label class="pc-label">To Date</label><input id="pc_ledTo" type="date" class="form-control"/></div><div class="col-md-2 d-flex align-items-end"><button class="btn btn-primary" onclick="pc_ledgerBind()"><i class="fas fa-search" aria-hidden="true"></i> Search</button></div></div></div></div>
<div class="card pc-card mt-3"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Financial history</span><h5>Petty cash transactions</h5><p>Review debits, credits, and running balance.</p></div></div><table id="pc_LedgerTable" class="table table-bordered table-striped w-100"><thead><tr><th>Date</th><th>Transaction No</th><th>Type</th><th>Request No</th><th>Employee</th><th>Description</th><th>Debit</th><th>Credit</th><th>Running Balance</th></tr></thead></table></div></div></div>

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
