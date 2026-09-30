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
        <div id="billingResults" class="billing-panel billing-results" style="display:none;">
            <div class="billing-panel-body">
                <ul id="billingTabs" class="nav nav-tabs" role="tablist"></ul>
                <div id="billingTabContent" class="tab-content"></div>
            </div>
        </div>
    </div>
    <div id="billingLoadingOverlay" class="billing-loading-overlay" aria-hidden="true">
        <div class="billing-loading-box"><span class="billing-spinner" aria-hidden="true"></span><span>Fetching billing details...</span></div>
    </div>
    <script src="../Scripts/Admin/ProjectBillingDetails.js"></script>
</asp:Content>
