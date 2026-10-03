<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectBillingDetails.aspx.cs" Inherits="WebPortal.Admin.ProjectBillingDetails" MasterPageFile="~/Admin/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../Content/ProjectBillingDetails.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="project-billing-page">
        <div class="billing-page-header">
            <h3>Project Billing Details</h3>
            <small>Project-wise billing records for the selected month and year</small>
        </div>
        <div class="billing-panel">
            <div class="billing-panel-title">Report Filters</div>
            <div class="billing-panel-body">
                <div class="row align-items-end">
                    <div class="col-md-3 col-sm-6">
                        <label class="billing-label" for="ddlMonth">Month</label>
                        <asp:DropDownList ID="ddlMonth" ClientIDMode="Static" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-3 col-sm-6 billing-filter-field">
                        <label class="billing-label" for="ddlYear">Year</label>
                        <asp:DropDownList ID="ddlYear" ClientIDMode="Static" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-3 col-sm-12 billing-filter-action">
                        <button type="button" id="btnGenerateBilling" class="btn btn-billing">Search / Generate</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="billingMessage" class="billing-message" role="status" aria-live="polite"></div>
        <div id="billingSummary" class="billing-panel billing-summary" style="display:none;">
            <div class="billing-panel-title summary-title-row">
                <span>Billing Readiness Summary</span>
                <span class="summary-hint">Click a project to view deal-wise counts. Action-required counts open the affected loans.</span>
            </div>
            <div id="billingSummaryContent" class="billing-panel-body"></div>
        </div>
        <div id="billingResults" class="billing-panel billing-results" style="display:none;">
            <div class="billing-panel-body">
                <ul id="billingTabs" class="nav nav-tabs" role="tablist"></ul>
                <div id="billingTabContent" class="tab-content"></div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="blankBillingModal" tabindex="-1" role="dialog" aria-labelledby="blankBillingModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document"><div class="modal-content">
            <div class="modal-header"><div><h5 class="modal-title" id="blankBillingModalTitle">Loans With Blank Billing Parameters</h5><small id="blankBillingModalContext"></small></div><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>
            <div class="modal-body">
                <div id="remarkMessage" class="remark-message" role="status"></div>
                <div class="bulk-remark-bar"><label class="select-all-label"><input type="checkbox" id="chkSelectAllLoans" /> Select All for current Deal</label><input type="text" id="txtBulkRemark" class="form-control" maxlength="1000" placeholder="Common remark for selected loans" /><button type="button" id="btnSaveBulkRemark" class="btn btn-billing">Apply to Selected</button></div>
                <div class="blank-loans-wrap"><table class="table table-bordered table-sm blank-loans-table"><thead><tr><th>Select</th><th>Project</th><th>Deal #</th><th>Loan #</th><th>Dispatch Date</th><th>Blank Parameter(s)</th><th>Existing Remark</th><th>Remark</th><th>Action</th></tr></thead><tbody id="blankLoansBody"></tbody></table></div>
            </div>
        </div></div>
    </div>
    <div id="billingLoadingOverlay" class="billing-loading-overlay" aria-hidden="true">
        <div class="billing-loading-box"><span class="billing-spinner" aria-hidden="true"></span><span>Fetching billing details...</span></div>
    </div>
    <script src="../Scripts/Admin/ProjectBillingDetails.js"></script>
</asp:Content>
