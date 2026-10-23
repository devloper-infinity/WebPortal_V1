<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashExpense.aspx.cs" Inherits="WebPortal.Admin.PettyCashExpense" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261023-1") %>" rel="stylesheet" />
<div class="container-fluid py-3 pc-page"><div class="pc-hero"><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-receipt"></i></span><div class="pc-hero-copy"><h4 class="mb-1">Petty Cash Expense Entry</h4><small>Petty Cash Management</small></div></div>
<div class="card pc-card"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Expense processing</span><h5>Record an expense</h5><p>Capture expense details against an issued petty cash request.</p></div><span class="pc-context-badge"><i class="fas fa-receipt" aria-hidden="true"></i>Expense entry</span></div><div class="row"><div class="col-md-4"><label class="pc-label">Cash Issued Request *</label><select id="pc_expRequest" class="form-control"><option value="">Select</option></select></div><div class="col-md-2"><label class="pc-label">Expense Date *</label><input id="pc_expDate" type="date" class="form-control"/></div><div class="col-md-3"><label class="pc-label">Category *</label><select id="pc_expCategory" class="form-control"><option value="">Select</option></select></div><div class="col-md-3"><label class="pc-label">Vendor</label><input id="pc_expVendor" maxlength="200" class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-3"><label class="pc-label">Invoice No</label><input id="pc_expInvoice" maxlength="100" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Expense Amount *</label><input id="pc_expAmount" type="number" min="0.01" step="0.01" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Tax Amount</label><input id="pc_expTax" type="number" min="0" step="0.01" value="0" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Payment Mode</label><select id="pc_expMode" class="form-control"><option>Cash</option><option>Bank</option><option>UPI</option><option>Other</option></select></div><div class="col-md-3"><label class="pc-label">Description *</label><input id="pc_expDescription" maxlength="1000" class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-12"><label class="pc-label">Remark</label><input id="pc_expRemark" maxlength="1000" class="form-control"/></div></div><div class="mt-3"><button class="btn btn-primary" onclick="pc_expenseSave()">Save Expense</button></div></div></div>
<div class="card pc-card mt-3"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Activity</span><h5>Expense records</h5><p>Saved expenses for the selected request.</p></div></div><table id="pc_ExpenseTable" class="table table-bordered table-striped w-100"><thead><tr><th>Date</th><th>Request No</th><th>Vendor</th><th>Invoice</th><th>Description</th><th>Expense</th><th>Tax</th><th>Status</th></tr></thead></table></div></div></div>

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
