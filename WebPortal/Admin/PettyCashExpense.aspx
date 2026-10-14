<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashExpense.aspx.cs" Inherits="WebPortal.Admin.PettyCashExpense" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<style>
.pc-hero{background:linear-gradient(120deg,#1d4ed8,#2563eb,#22c1dc);color:#fff;border-radius:12px;padding:16px 20px;margin-bottom:16px} .pc-card{border:0;border-radius:12px;box-shadow:0 3px 14px rgba(15,23,42,.08)} .pc-label{font-weight:600;margin-bottom:5px} .pc-stat{border-radius:12px;padding:16px;background:#fff;box-shadow:0 3px 12px rgba(15,23,42,.08)} .pc-stat .n{font-size:24px;font-weight:700} .pc-actions .btn{margin-right:5px;margin-bottom:4px}
</style>
<div class="container-fluid py-3"><div class="pc-hero"><h4 class="mb-1">Petty Cash Expense Entry</h4><small>Petty Cash Management</small></div>
<div class="card pc-card"><div class="card-body"><div class="row"><div class="col-md-4"><label class="pc-label">Cash Issued Request *</label><select id="pc_expRequest" class="form-control"><option value="">Select</option></select></div><div class="col-md-2"><label class="pc-label">Expense Date *</label><input id="pc_expDate" type="date" class="form-control"/></div><div class="col-md-3"><label class="pc-label">Category *</label><select id="pc_expCategory" class="form-control"><option value="">Select</option></select></div><div class="col-md-3"><label class="pc-label">Vendor</label><input id="pc_expVendor" maxlength="200" class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-3"><label class="pc-label">Invoice No</label><input id="pc_expInvoice" maxlength="100" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Expense Amount *</label><input id="pc_expAmount" type="number" min="0.01" step="0.01" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Tax Amount</label><input id="pc_expTax" type="number" min="0" step="0.01" value="0" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Payment Mode</label><select id="pc_expMode" class="form-control"><option>Cash</option><option>Bank</option><option>UPI</option><option>Other</option></select></div><div class="col-md-3"><label class="pc-label">Description *</label><input id="pc_expDescription" maxlength="1000" class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-12"><label class="pc-label">Remark</label><input id="pc_expRemark" maxlength="1000" class="form-control"/></div></div><div class="mt-3"><button class="btn btn-primary" onclick="pc_expenseSave()">Save Expense</button></div></div></div>
<div class="card pc-card mt-3"><div class="card-body"><table id="pc_ExpenseTable" class="table table-bordered table-striped w-100"><thead><tr><th>Date</th><th>Request No</th><th>Vendor</th><th>Invoice</th><th>Description</th><th>Expense</th><th>Tax</th><th>Status</th></tr></thead></table></div></div></div>

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
<script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js") %>"></script>
</asp:Content>
