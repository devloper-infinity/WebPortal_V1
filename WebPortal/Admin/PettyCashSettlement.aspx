<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashSettlement.aspx.cs" Inherits="WebPortal.Admin.PettyCashSettlement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261023-1") %>" rel="stylesheet" />
<div class="container-fluid py-3 pc-page"><div class="pc-hero"><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-balance-scale"></i></span><div class="pc-hero-copy"><h4 class="mb-1">Petty Cash Settlement</h4><small>Petty Cash Management</small></div></div>
<div class="card pc-card"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Closeout</span><h5>Settle a request</h5><p>Review the amounts and submit the final settlement.</p></div><span class="pc-context-badge"><i class="fas fa-balance-scale" aria-hidden="true"></i>Settlement</span></div><div class="row"><div class="col-md-4"><label class="pc-label">Request *</label><select id="pc_setRequest" class="form-control"><option value="">Select</option></select></div><div class="col-md-2"><label class="pc-label">Paid Amount</label><input id="pc_setPaid" readonly class="form-control"/></div><div class="col-md-2"><label class="pc-label">Expense Total</label><input id="pc_setExpense" readonly class="form-control"/></div><div class="col-md-2"><label class="pc-label">Refund</label><input id="pc_setRefund" readonly class="form-control"/></div><div class="col-md-2"><label class="pc-label">Reimbursement</label><input id="pc_setReimburse" readonly class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-3"><label class="pc-label">Settlement Date *</label><input id="pc_setDate" type="date" class="form-control"/></div><div class="col-md-9"><label class="pc-label">Remark</label><input id="pc_setRemark" maxlength="1000" class="form-control"/></div></div><div class="mt-3"><button class="btn btn-primary" onclick="pc_settlementConfirm()">Submit Settlement</button></div></div></div>
<div class="card pc-card mt-3"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">History</span><h5>Completed settlements</h5><p>Browse past settlements and amounts.</p></div></div><table id="pc_SettlementTable" class="table table-bordered table-striped w-100"><thead><tr><th>Request No</th><th>Employee</th><th>Paid</th><th>Expense</th><th>Refund</th><th>Reimbursement</th><th>Date</th><th>Status</th></tr></thead></table></div></div></div>

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
