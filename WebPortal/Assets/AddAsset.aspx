<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAsset.aspx.cs" Inherits="WebPortal.Assets.AddAsset" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
        <div class="asset-hero">
            <h2>Add Asset</h2>
            <small>Assets / Add Asset</small></div>
        <div class="erp-panel">
            <div class="erp-panel-title">Asset Registration</div>
            <div class="erp-panel-body">
                <div class="row entry-form">
                    <div class="hidden-id form-group">
                        <label class="">Asset ID</label><input id="assetId" type="hidden" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Asset Code</label><input id="assetCode" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="required">Asset Tag</label><input id="tag" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Serial Number</label><input id="serial" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Barcode</label><input id="barcode" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">QR Code</label><input id="qr" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">IMEI Number</label><input id="imei" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Host Name</label><input id="host" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="required">Category</label><select id="category" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="required">Asset Type</label><select id="type" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Brand</label><select id="brand" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Model</label><select id="model" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="required">Branch</label><select id="branch" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Status</label><select id="status" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Condition</label><select id="condition" class="form-control"><option value="">-- Select --</option>
                            <option value="New">New</option>
                            <option value="Good">Good</option>
                            <option value="Fair">Fair</option>
                            <option value="Damaged">Damaged</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Vendor</label><select id="vendor" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="">Purchase Date</label><input id="purchaseDate" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Purchase Value</label><input id="purchaseValue" type="number" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Invoice Number</label><input id="invoice" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Invoice Date</label><input id="invoiceDate" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Warranty Start</label><input id="warrantyStart" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Warranty End</label><input id="warrantyEnd" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Processor</label><input id="processor" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">RAM</label><input id="ram" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Storage</label><input id="storage" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">Operating System</label><input id="os" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">IP Address</label><input id="ip" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label class="">MAC Address</label><input id="mac" type="text" class="form-control" /></div>
                    <div class="col-md-6 form-group">
                        <label class="">Accessories</label><textarea id="accessories" class="form-control" rows="2"></textarea></div>
                    <div class="col-md-6 form-group">
                        <label class="">Asset Description</label><textarea id="description" class="form-control" rows="2"></textarea></div>
                    <div class="col-md-6 form-group">
                        <label class="">Remarks</label><textarea id="remarks" class="form-control" rows="2"></textarea></div>
                </div>
                <button class="btn btn-primary" onclick="saveAsset();return false;">Save Asset</button>
                <button class="btn btn-secondary" onclick="AssetUI.clear();return false;">Clear</button></div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Recently Added Assets</div>
            <div class="erp-panel-body">
                <div style="position: relative">
                    <table id="grid" class="table table-bordered table-sm"></table>
                </div>
            </div>
        </div>
        <script>
            function look() { [['Category', '#category'], ['Type', '#type'], ['Brand', '#brand'], ['Model', '#model'], ['Branch', '#branch'], ['Status', '#status'], ['Vendor', '#vendor']].forEach(function (x) { AssetUI.post('AddAsset.aspx/Lookup', { type: x[0], parentID: null }, r => AssetUI.fill(x[1], r, 'ID', 'Name')); }); }
            function load() { var c = [{ data: 'AssetID', title: 'ID' }, { data: 'AssetCode', title: 'Asset Code' }, { data: 'AssetTagNumber', title: 'Asset Tag' }, { data: 'SerialNumber', title: 'Serial No.' }, { data: 'CategoryName', title: 'Category' }, { data: 'AssetTypeName', title: 'Type' }, { data: 'BrandName', title: 'Brand' }, { data: 'ModelName', title: 'Model' }, { data: 'BranchName', title: 'Branch' }, { data: 'StatusName', title: 'Status' }, { data: 'PurchaseValue', title: 'Purchase Value' }]; AssetUI.post('AddAsset.aspx/List', {}, r => AssetUI.table('#grid', r, c, [{ text: 'Edit', fn: 'editAsset', id: 'AssetID' }, { text: 'View', fn: 'viewAsset', id: 'AssetID', cls: 'btn-outline-secondary' }])); }
            function saveAsset() { var x = { AssetID: +$('#assetId').val() || 0, AssetCode: $('#assetCode').val(), AssetTagNumber: $('#tag').val(), Barcode: $('#barcode').val(), QRCode: $('#qr').val(), SerialNumber: $('#serial').val(), IMEINumber: $('#imei').val(), HostName: $('#host').val(), AssetCategoryID: +$('#category').val(), AssetTypeID: +$('#type').val(), AssetBrandID: AssetUI.num('#brand'), AssetModelID: AssetUI.num('#model'), AssetDescription: $('#description').val(), VendorID: AssetUI.num('#vendor'), InvoiceNumber: $('#invoice').val(), InvoiceDate: $('#invoiceDate').val() || null, PurchaseDate: $('#purchaseDate').val() || null, PurchaseValue: +$('#purchaseValue').val() || 0, WarrantyStartDate: $('#warrantyStart').val() || null, WarrantyEndDate: $('#warrantyEnd').val() || null, CurrentBranchID: +$('#branch').val(), AssetStatusID: AssetUI.num('#status'), AssetCondition: $('#condition').val(), Processor: $('#processor').val(), RAM: $('#ram').val(), Storage: $('#storage').val(), OperatingSystem: $('#os').val(), IPAddress: $('#ip').val(), MACAddress: $('#mac').val(), Accessories: $('#accessories').val(), Remarks: $('#remarks').val() }; AssetUI.post('AddAsset.aspx/Save', { x: x }, function () { AssetUI.clear(); load(); }); }
            function editAsset(id) { location.href = 'AddAsset.aspx?id=' + id; } function viewAsset(id) { location.href = 'AssetDetails.aspx?id=' + id; } $(function () { look(); load(); });</script>
    </div>
    <script src="asset-common.js"></script>
</asp:Content>
