<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssetPurchaseRequest.aspx.cs" Inherits="WebPortal.Assets.AssetPurchaseRequest" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
    <div class="asset-hero">
        <h2>Asset Purchase Request</h2>
        <small>Assets / Asset Purchase Request</small></div>
    <div class="erp-panel">
        <div class="erp-panel-title">Purchase Request</div>
        <div class="erp-panel-body">
            <div class="row entry-form">
                <div class="hidden-id form-group">
                    <label class="">ID</label><input id="prId" type="hidden" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="">Request Number</label><input id="number" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="required">Request Date</label><input id="date" type="date" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="required">Requested By</label><select id="requester" class="form-control"><option value="">-- Select Employee --</option>
                    </select></div>
                <div class="col-md-3 form-group">
                    <label class="required">Branch</label><select id="branch" class="form-control"><option value="">-- Select --</option>
                    </select></div>
                <div class="col-md-3 form-group">
                    <label class="">Priority</label><select id="priority" class="form-control"><option value="">-- Select --</option>
                        <option value="Low">Low</option>
                        <option value="Normal">Normal</option>
                        <option value="High">High</option>
                        <option value="Urgent">Urgent</option>
                    </select></div>
                <div class="col-md-3 form-group">
                    <label class="">Required By</label><input id="requiredDate" type="date" class="form-control" /></div>
                <div class="col-md-6 form-group">
                    <label class="required">Business Justification</label><textarea id="justification" class="form-control" rows="2"></textarea></div>
                <div class="col-md-6 form-group">
                    <label class="">Remarks</label><textarea id="remarks" class="form-control" rows="2"></textarea></div>
            </div>
        </div>
    </div>
    <div class="erp-panel">
        <div class="erp-panel-title">Requested Items</div>
        <div class="erp-panel-body">
            <table class="table table-bordered item-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Preferred Brand</th>
                        <th>Description</th>
                        <th>Specification</th>
                        <th>Qty</th>
                        <th>Est. Unit Cost</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="items"></tbody>
            </table>
            <button class="btn btn-outline-primary" onclick="addItem();return false;">Add Item</button>
            <button class="btn btn-primary" onclick="save();return false;">Submit Request</button></div>
    </div>
    <div class="erp-panel">
        <div class="erp-panel-title">My Requests</div>
        <div class="erp-panel-body">
            <div style="position: relative">
                <table id="grid" class="table table-bordered table-sm"></table>
            </div>
        </div>
    </div>
    <script>var itemTemplate = "<tr><td><select class=\"form-control i-category\"></select></td><td><select class=\"form-control i-type\"></select></td><td><select class=\"form-control i-brand\"></select></td><td><input class=\"form-control i-description\" /></td><td><input class=\"form-control i-spec\" /></td><td><input type=\"number\" class=\"form-control i-qty\" value=\"1\" /></td><td><input type=\"number\" class=\"form-control i-cost\" value=\"0\" /></td><td><button class=\"btn btn-sm btn-danger\" onclick=\"$(this).closest('tr').remove();return false;\">Remove</button></td></tr>"; function look() { [['Branch', '#branch'], ['Employee', '#requester']].forEach(function (x) { AssetUI.post('AssetPurchaseRequest.aspx/Lookup', { type: x[0], parentID: null }, r => AssetUI.fill(x[1], r, 'ID', 'Name')); }); } function addItem() { $('#items').append(itemTemplate); var tr = $('#items tr:last');[['Category', '.i-category'], ['Type', '.i-type'], ['Brand', '.i-brand']].forEach(function (x) { AssetUI.post('AssetPurchaseRequest.aspx/Lookup', { type: x[0], parentID: null }, r => AssetUI.fill(tr.find(x[1]), r, 'ID', 'Name')); }); } function save() { var items = []; $('#items tr').each(function () { items.push({ AssetCategoryID: +$(this).find('.i-category').val() || null, AssetTypeID: +$(this).find('.i-type').val() || null, PreferredBrandID: +$(this).find('.i-brand').val() || null, ItemDescription: $(this).find('.i-description').val(), TechnicalSpecification: $(this).find('.i-spec').val(), RequiredQuantity: +$(this).find('.i-qty').val(), EstimatedUnitCost: +$(this).find('.i-cost').val() }); }); var x = { PurchaseRequestID: +$('#prId').val() || 0, RequestNumber: $('#number').val(), RequestDate: $('#date').val(), RequestedBy: +$('#requester').val(), DepartmentID: null, BranchID: +$('#branch').val(), Priority: $('#priority').val(), RequiredByDate: $('#requiredDate').val() || null, BusinessJustification: $('#justification').val(), Remarks: $('#remarks').val(), Items: items }; AssetUI.post('AssetPurchaseRequest.aspx/Save', { x: x }, function () { load(); }); } function load() { AssetUI.post('AssetPurchaseRequest.aspx/List', {}, r => AssetUI.table('#grid', r, [{ data: 'RequestNumber', title: 'Request No.' }, { data: 'RequestDate', title: 'Date' }, { data: 'BranchName', title: 'Branch' }, { data: 'Priority', title: 'Priority' }, { data: 'EstimatedAmount', title: 'Estimated Amount' }, { data: 'ApprovalStatus', title: 'Approval' }, { data: 'Status', title: 'Status' }], [{ text: 'View', fn: 'view', id: 'PurchaseRequestID' }])); } function view(id) { location.href = 'AssetPurchaseRequest.aspx?id=' + id; } $(function () { look(); addItem(); load(); });</script>
</div>
    <script src="asset-common.js"></script>
</asp:Content>
