<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashPayment.aspx.cs" Inherits="WebPortal.Admin.PettyCashPayment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261023-1") %>" rel="stylesheet" />
<div class="container-fluid py-3 pc-page"><div class="pc-hero"><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-money-bill-wave"></i></span><div class="pc-hero-copy"><h4 class="mb-1">Petty Cash Payment / Cash Issue</h4><small>Petty Cash Management</small></div></div>
<div class="card pc-card"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Disbursement</span><h5>Issue petty cash</h5><p>Select an approved request and enter the payment details.</p></div><span class="pc-context-badge"><i class="fas fa-money-bill-wave" aria-hidden="true"></i>Payment entry</span></div><div class="row"><div class="col-md-4"><label class="pc-label">Approved Request *</label><select id="pc_payRequest" class="form-control"><option value="">Select</option></select></div><div class="col-md-2"><label class="pc-label">Approved Amount</label><input id="pc_payApproved" class="form-control" readonly/></div><div class="col-md-2"><label class="pc-label">Payment Date *</label><input id="pc_payDate" type="date" class="form-control"/></div><div class="col-md-2"><label class="pc-label">Mode *</label><select id="pc_payMode" class="form-control"><option>Cash</option><option>Bank</option><option>UPI</option><option>Other</option></select></div><div class="col-md-2"><label class="pc-label">Amount Paid *</label><input id="pc_payAmount" type="number" min="0.01" step="0.01" class="form-control"/></div></div>
<div class="row mt-3"><div class="col-md-3"><label class="pc-label">Reference No</label><input id="pc_payReference" maxlength="100" class="form-control"/></div><div class="col-md-3"><label class="pc-label">Receiver *</label><select id="pc_payReceiver" class="form-control"><option value="">Select</option></select></div><div class="col-md-6"><label class="pc-label">Remark</label><input id="pc_payRemark" maxlength="1000" class="form-control"/></div></div><div class="mt-3"><button type="button" class="btn btn-primary" onclick="pc_paymentConfirm()">Issue Payment</button></div></div></div>
<div class="card pc-card mt-3"><div class="card-body"><div class="pc-card-heading"><div><span class="pc-kicker">Payment history</span><h5>Issued payments</h5><p>Review completed petty cash disbursements.</p></div></div><table id="pc_PaymentTable" class="table table-bordered table-striped w-100"><thead><tr><th>Payment No</th><th>Request No</th><th>Date</th><th>Employee</th><th>Mode</th><th>Reference</th><th>Amount</th></tr></thead></table></div></div></div>

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
<script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js?v=20261023-2") %>"></script>
</asp:Content>
