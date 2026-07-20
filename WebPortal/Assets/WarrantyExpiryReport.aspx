<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WarrantyExpiryReport.aspx.cs" Inherits="WebPortal.Assets.WarrantyExpiryReport" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
        <div class="asset-hero">
            <h2>Warranty Expiry Report</h2>
            <small>Assets / Warranty Expiry Report</small></div>
        <div class="erp-panel">
            <div class="erp-panel-title">Filters</div>
            <div class="erp-panel-body">
                <div class="row">
                    <div class="col-md-3 form-group">
                        <label class="">Branch</label><select id="branch" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">From Date</label><input id="from" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">To Date</label><input id="to" type="date" class="form-control" /></div>
                </div>
                <button class="btn btn-primary" onclick="load();return false;">Generate</button>
                <button class="btn btn-success" onclick="exportExcel();return false;">Export Excel</button></div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Warranty Expiry Report</div>
            <div class="erp-panel-body">
                <div style="position: relative">
                    <table id="grid" class="table table-bordered table-sm"></table>
                </div>
            </div>
        </div>
        <script>function look() { AssetUI.post('WarrantyExpiryReport.aspx/Lookup', { type: 'Branch', parentID: null }, r => AssetUI.fill('#branch', r, 'ID', 'Name')); } function load() { AssetUI.post('WarrantyExpiryReport.aspx/List', { branchID: AssetUI.num('#branch'), fromDate: $('#from').val() || null, toDate: $('#to').val() || null }, r => AssetUI.table('#grid', r, [{ data: 'AssetTagNumber', title: 'Asset Tag' }, { data: 'AssetTypeName', title: 'Asset Type' }, { data: 'BrandName', title: 'Brand' }, { data: 'ModelName', title: 'Model' }, { data: 'BranchName', title: 'Branch' }, { data: 'PurchaseDate', title: 'Purchase Date' }, { data: 'WarrantyEndDate', title: 'Warranty End' }, { data: 'DaysRemaining', title: 'Days Remaining' }, { data: 'WarrantyStatus', title: 'Status' }], [{ text: 'View', fn: 'view', id: 'AssetID' }])); } function view(id) { if (id) location.href = 'AssetDetails.aspx?id=' + id; } function exportExcel() { $('#grid').DataTable().button && $('#grid').DataTable().button('.buttons-excel').trigger(); } $(function () { look(); load(); });</script>
    </div>
    <script src="asset-common.js"></script>
</asp:Content>
