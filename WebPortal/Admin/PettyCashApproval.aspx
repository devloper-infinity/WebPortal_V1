<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashApproval.aspx.cs" Inherits="WebPortal.Admin.PettyCashApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="<%= ResolveUrl("~/Content/PettyCashTheme.css?v=20261023-1") %>" rel="stylesheet" />
    <div class="container-fluid py-3 pc-page">
        <div class="pc-hero"><span class="pc-hero-mark" aria-hidden="true"><i class="fas fa-clipboard-check"></i></span>
            <div class="pc-hero-copy">
                <h4 class="mb-1">Petty Cash Approval</h4>
                <small>Petty Cash Management</small></div>
        </div>
        <div class="card pc-card">
            <div class="card-body">
                <div class="pc-card-heading">
                    <div><span class="pc-kicker">Decision center</span><h5>Approval queue</h5>
                        <p>Filter requests and review their current status.</p>
                    </div>
                    <span class="pc-context-badge"><i class="fas fa-clipboard-check" aria-hidden="true"></i>Review requests</span></div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pc-label" for="pc_apStatus">Status</label>
                        <select id="pc_apStatus" class="form-control">
                            <option value="All">All statuses</option>
                            <option value="Draft">Draft</option>
                            <option value="Submitted" selected="selected">Submitted</option>
                            <option value="Pending For Approval">Pending For Approval</option>
                            <option value="Approved">Approved</option>
                            <option value="Rejected">Rejected</option>
                            <option value="Sent Back">Sent Back</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="button" class="btn btn-primary" onclick="pc_approvalBind()"><i class="fas fa-search" aria-hidden="true"></i>Search</button></div>
                </div>
            </div>
        </div>
        <div class="card pc-card mt-3">
            <div class="card-body">
                <div class="pc-card-heading">
                    <div><span class="pc-kicker">Pending workflow</span><h5>Requests for review</h5>
                        <p>Submitted requests can be approved, rejected, or returned. Drafts must be submitted by the requester first.</p>
                    </div>
                </div>
                <table id="pc_ApprovalTable" class="table table-bordered table-striped w-100">
                    <thead>
                        <tr>
                            <th>Request No</th>
                            <th>Date</th>
                            <th>Employee</th>
                            <th>Category</th>
                            <th>Purpose</th>
                            <th>Requested</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="pcApprovalModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Request Action</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button></div>
                <div class="modal-body">
                    <input type="hidden" id="pc_apRequestId" /><div class="row">
                        <div class="col-md-4">
                            <label class="pc-label">Request No</label><input id="pc_apRequestNo" class="form-control" readonly /></div>
                        <div class="col-md-4">
                            <label class="pc-label">Requested Amount</label><input id="pc_apRequestedAmount" class="form-control" readonly /></div>
                        <div class="col-md-4">
                            <label class="pc-label">Approved Amount</label><input id="pc_apApprovedAmount" type="number" min="0.01" step="0.01" class="form-control" /></div>
                    </div>
                    <div class="mt-3">
                        <label class="pc-label">Remark</label><textarea id="pc_apRemark" maxlength="1000" class="form-control"></textarea></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="pc_approvalAction('Approve')">Approve</button>
                    <button type="button" class="btn btn-danger" onclick="pc_approvalAction('Reject')">Reject</button>
                    <button type="button" class="btn btn-warning" onclick="pc_approvalAction('SendBack')">Send Back</button></div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="pcMessageModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pcMessageTitle">Message</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div>
                <div class="modal-body" id="pcMessageBody"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button></div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="pcConfirmModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="pcConfirmTitle">Confirmation</h5>
                    <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div>
                <div class="modal-body" id="pcConfirmMessage"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="pcConfirmYes">Yes</button></div>
            </div>
        </div>
    </div>
    <div id="load1" style="display: none; position: fixed; z-index: 20000; left: 50%; top: 50%; transform: translate(-50%,-50%); background: #fff; padding: 14px 18px; border-radius: 8px; box-shadow: 0 4px 24px rgba(0,0,0,.2)"><span class="spinner-border spinner-border-sm mr-2"></span>Processing...</div>
<script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js?v=20261023-5") %>"></script>
</asp:Content>
