<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorQuotation.aspx.cs" Inherits="WebPortal.Assets.VendorQuotation" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
    <div class="asset-hero">
        <h2>Vendor Quotation</h2>
        <small>Assets / Vendor Quotation</small></div>
    <div class="erp-panel">
        <div class="erp-panel-title">Quotation Header</div>
        <div class="erp-panel-body">
            <div class="row entry-form">
                <div class="hidden-id form-group">
                    <label class="">ID</label><input id="qid" type="hidden" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="required">Quotation Number</label><input id="qnumber" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="required">Vendor</label><select id="vendor" class="form-control"><option value="">-- Select --</option>
                    </select></div>
                <div class="col-md-3 form-group">
                    <label class="">Purchase Request</label><select id="request" class="form-control"><option value="">-- Select --</option>
                    </select></div>
                <div class="col-md-3 form-group">
                    <label class="required">Quotation Date</label><input id="qdate" type="date" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="">Valid Until</label><input id="valid" type="date" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="">Reference Number</label><input id="reference" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group">
                    <label class="">Delivery Period</label><input id="delivery" type="text" class="form-control" /></div>
                <div class="col-md-6 form-group">
                    <label class="">Payment Terms</label><textarea id="payment" class="form-control" rows="2"></textarea></div>
                <div class="col-md-6 form-group">
                    <label class="">Warranty Terms</label><textarea id="warranty" class="form-control" rows="2"></textarea></div>
                <div class="col-md-6 form-group">
                    <label class="">Remarks</label><textarea id="remarks" class="form-control" rows="2"></textarea></div>
            </div>
        </div>
    </div>
    <div class="erp-panel">
        <div class="erp-panel-title">Quotation Items</div>
        <div class="erp-panel-body">
            <table class="table table-bordered item-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Brand</th>
                        <th>Description</th>
                        <th>Qty</th>
                        <th>Unit Price</th>
                        <th>Discount</th>
                        <th>Tax %</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="items"></tbody>
            </table>
            <button class="btn btn-outline-primary" onclick="addItem();return false;">Add Item</button>
            <button class="btn btn-primary" onclick="save();return false;">Save Quotation</button></div>
    </div>
    <div class="erp-panel">
        <div class="erp-panel-title">Quotations</div>
        <div class="erp-panel-body">
            <div style="position: relative">
                <table id="grid" class="table table-bordered table-sm"></table>
            </div>
        </div>
    </div>
    <script>var itemTemplate = "<tr><td><select class=\"form-control i-category\"></select></td><td><select class=\"form-control i-type\"></select></td><td><select class=\"form-control i-brand\"></select></td><td><input class=\"form-control i-description\" /></td><td><input type=\"number\" class=\"form-control i-qty\" value=\"1\" /></td><td><input type=\"number\" class=\"form-control i-price\" value=\"0\" /></td><td><input type=\"number\" class=\"form-control i-discount\" value=\"0\" /></td><td><input type=\"number\" class=\"form-control i-tax\" value=\"18\" /></td><td><button class=\"btn btn-sm btn-danger\" onclick=\"$(this).closest('tr').remove();return false;\">Remove</button></td></tr>"; function look() { [['Vendor', '#vendor'], ['PurchaseRequest', '#request']].forEach(function (x) { AssetUI.post('VendorQuotation.aspx/Lookup', { type: x[0], parentID: null }, r => AssetUI.fill(x[1], r, 'ID', 'Name')); }); } function addItem() { $('#items').append(itemTemplate); var tr = $('#items tr:last');[['Category', '.i-category'], ['Type', '.i-type'], ['Brand', '.i-brand']].forEach(function (x) { AssetUI.post('VendorQuotation.aspx/Lookup', { type: x[0], parentID: null }, r => AssetUI.fill(tr.find(x[1]), r, 'ID', 'Name')); }); } function save() { var items = []; $('#items tr').each(function () { items.push({ AssetCategoryID: +$(this).find('.i-category').val() || null, AssetTypeID: +$(this).find('.i-type').val() || null, AssetBrandID: +$(this).find('.i-brand').val() || null, AssetModelID: null, ItemDescription: $(this).find('.i-description').val(), Quantity: +$(this).find('.i-qty').val(), UnitPrice: +$(this).find('.i-price').val(), DiscountAmount: +$(this).find('.i-discount').val(), TaxPercentage: +$(this).find('.i-tax').val() }); }); var x = { QuotationID: +$('#qid').val() || 0, QuotationNumber: $('#qnumber').val(), VendorID: +$('#vendor').val(), PurchaseRequestID: AssetUI.num('#request'), QuotationDate: $('#qdate').val(), ValidUntilDate: $('#valid').val() || null, ReferenceNumber: $('#reference').val(), DeliveryPeriod: $('#delivery').val(), PaymentTerms: $('#payment').val(), WarrantyTerms: $('#warranty').val(), Remarks: $('#remarks').val(), Items: items }; AssetUI.post('VendorQuotation.aspx/Save', { x: x }, load); } function load() { AssetUI.post('VendorQuotation.aspx/List', {}, r => AssetUI.table('#grid', r, [{ data: 'QuotationNumber', title: 'Quotation No.' }, { data: 'VendorName', title: 'Vendor' }, { data: 'RequestNumber', title: 'Request No.' }, { data: 'QuotationDate', title: 'Date' }, { data: 'ValidUntilDate', title: 'Valid Until' }, { data: 'TotalQuotationValue', title: 'Total' }, { data: 'Status', title: 'Status' }, { data: 'IsSelected', title: 'Selected' }], [{ text: 'View', fn: 'view', id: 'QuotationID' }])); } function view(id) { location.href = 'VendorQuotation.aspx?id=' + id; } $(function () { look(); addItem(); load(); });</script>
</div>
    <script src="asset-common.js"></script>
</asp:Content>
