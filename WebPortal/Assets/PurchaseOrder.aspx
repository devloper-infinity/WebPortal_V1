<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PurchaseOrder.aspx.cs" Inherits="WebPortal.Assets.PurchaseOrder" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server"><link href="asset-common.css" rel="stylesheet" /></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="asset-page">
    <div class="asset-hero"><h2>Purchase Order</h2><small>Assets / Purchase Order</small></div>
    <div class="erp-panel"><div class="erp-panel-title">Purchase Order Header</div><div class="erp-panel-body">
        <div class="row entry-form">
            <div class="hidden-id form-group"><input id="poid" type="hidden" /></div>
            <div class="col-md-3 form-group"><label class="required">PO Number</label><input id="ponumber" class="form-control" /></div>
            <div class="col-md-3 form-group"><label class="required">PO Date</label><input id="podate" type="date" class="form-control" /></div>
            <div class="col-md-3 form-group"><label class="required">Vendor</label><select id="vendor" class="form-control"></select></div>
            <div class="col-md-3 form-group"><label>Quotation</label><select id="quotation" class="form-control"></select></div>
            <div class="col-md-3 form-group"><label>Purchase Request</label><select id="request" class="form-control"></select></div>
            <div class="col-md-3 form-group"><label class="required">Delivery Branch</label><select id="branch" class="form-control"></select></div>
            <div class="col-md-3 form-group"><label>Expected Delivery</label><input id="delivery" type="date" class="form-control" /></div>
            <div class="col-md-3 form-group"><label>Currency</label><select id="currency" class="form-control"><option value="">-- Select --</option><option value="INR">INR</option><option value="USD">USD</option></select></div>
            <div class="col-md-6 form-group"><label>Billing Address</label><textarea id="billing" class="form-control" rows="2"></textarea></div>
            <div class="col-md-6 form-group"><label>Shipping Address</label><textarea id="shipping" class="form-control" rows="2"></textarea></div>
            <div class="col-md-6 form-group"><label>Payment Terms</label><textarea id="payment" class="form-control" rows="2"></textarea></div>
            <div class="col-md-3 form-group"><label>Freight Charges</label><input id="freight" type="number" class="form-control" /></div>
            <div class="col-md-3 form-group"><label>Other Charges</label><input id="other" type="number" class="form-control" /></div>
            <div class="col-md-6 form-group"><label>Remarks</label><textarea id="remarks" class="form-control" rows="2"></textarea></div>
        </div>
    </div></div>
    <div class="erp-panel"><div class="erp-panel-title">PO Items</div><div class="erp-panel-body">
        <table class="table table-bordered item-table"><thead><tr><th>Category</th><th>Type</th><th>Brand</th><th>Model</th><th>Description</th><th>Qty</th><th>Price</th><th>Discount</th><th>Tax %</th><th>Warranty</th><th></th></tr></thead><tbody id="items"></tbody></table>
        <button type="button" class="btn btn-outline-primary" onclick="addItem();return false;">Add Item</button>
    </div></div>
    <div class="erp-panel"><div class="erp-panel-title">Terms and Conditions</div><div class="erp-panel-body">
        <div id="terms"></div>
        <button type="button" class="btn btn-outline-primary" onclick="addTerm();return false;">Add Term</button>
        <button type="button" class="btn btn-primary" onclick="save();return false;">Save Purchase Order</button>
    </div></div>
    <div class="erp-panel"><div class="erp-panel-title">Purchase Orders</div><div class="erp-panel-body"><table id="grid" class="table table-bordered table-sm"></table></div></div>
    <script>
        var pageId = +(new URLSearchParams(window.location.search).get('id') || 0);
        var pageMode = (new URLSearchParams(window.location.search).get('mode') || 'edit').toLowerCase();
        var isViewMode = pageMode === 'view';

        var itemTemplate = '<tr>' +
            '<td><select class="form-control i-category"></select></td>' +
            '<td><select class="form-control i-type"></select></td>' +
            '<td><select class="form-control i-brand"></select></td>' +
            '<td><select class="form-control i-model"></select></td>' +
            '<td><input class="form-control i-description" /></td>' +
            '<td><input type="number" class="form-control i-qty" value="1" /></td>' +
            '<td><input type="number" step="0.01" class="form-control i-price" value="0" /></td>' +
            '<td><input type="number" step="0.01" class="form-control i-discount" value="0" /></td>' +
            '<td><input type="number" step="0.01" class="form-control i-tax" value="18" /></td>' +
            '<td><input class="form-control i-warranty" /></td>' +
            '<td class="edit-only"><button type="button" class="btn btn-sm btn-danger remove-item">Remove</button></td></tr>';

        function valueOf(obj, names, fallback) {
            for (var i = 0; i < names.length; i++) {
                if (obj && obj[names[i]] !== undefined && obj[names[i]] !== null) return obj[names[i]];
            }
            return fallback;
        }

        function dateForInput(value) {
            if (!value) return '';
            var match = /\/Date\((\d+)/.exec(String(value));
            var d = match ? new Date(+match[1]) : new Date(value);
            if (isNaN(d.getTime())) return String(value).substring(0, 10);
            var month = ('0' + (d.getMonth() + 1)).slice(-2);
            var day = ('0' + d.getDate()).slice(-2);
            return d.getFullYear() + '-' + month + '-' + day;
        }

        function loadLookups(done) {
            var lookups = [['Vendor', '#vendor'], ['Quotation', '#quotation'], ['PurchaseRequest', '#request'], ['Branch', '#branch']];
            var pending = lookups.length;
            $.each(lookups, function (_, x) {
                AssetUI.post('PurchaseOrder.aspx/Lookup', { type: x[0], parentID: null }, function (rows) {
                    AssetUI.fill(x[1], rows, 'ID', 'Name');
                    pending--;
                    if (pending === 0 && done) done();
                });
            });
        }

        function addItem(data, done) {
            data = data || {};
            var row = $(itemTemplate).appendTo('#items');
            var lookups = [['Category', '.i-category'], ['Type', '.i-type'], ['Brand', '.i-brand'], ['Model', '.i-model']];
            var pending = lookups.length;
            $.each(lookups, function (_, x) {
                AssetUI.post('PurchaseOrder.aspx/Lookup', { type: x[0], parentID: null }, function (rows) {
                    AssetUI.fill(row.find(x[1]), rows, 'ID', 'Name');
                    pending--;
                    if (pending === 0) {
                        row.find('.i-category').val(valueOf(data, ['AssetCategoryID', 'CategoryID'], ''));
                        row.find('.i-type').val(valueOf(data, ['AssetTypeID', 'TypeID'], ''));
                        row.find('.i-brand').val(valueOf(data, ['AssetBrandID', 'BrandID'], ''));
                        row.find('.i-model').val(valueOf(data, ['AssetModelID', 'ModelID'], ''));
                        row.find('.i-description').val(valueOf(data, ['ItemDescription', 'Description'], ''));
                        row.find('.i-qty').val(valueOf(data, ['OrderedQuantity', 'Quantity'], 1));
                        row.find('.i-price').val(valueOf(data, ['UnitPrice'], 0));
                        row.find('.i-discount').val(valueOf(data, ['DiscountAmount'], 0));
                        row.find('.i-tax').val(valueOf(data, ['TaxPercentage', 'TaxPercent'], 0));
                        row.find('.i-warranty').val(valueOf(data, ['WarrantyPeriod'], ''));
                        if (isViewMode) applyViewMode();
                        if (done) done(row);
                    }
                });
            });
            return row;
        }

        function addTerm(value) {
            var group = $('<div class="input-group mb-2"><input class="form-control po-term" placeholder="Term and condition"/><div class="input-group-append edit-only"><button type="button" class="btn btn-danger remove-term">Remove</button></div></div>');
            group.find('.po-term').val(value || '');
            $('#terms').append(group);
            if (isViewMode) applyViewMode();
        }

        function findTable(sets, requiredColumns) {
            for (var i = 0; i < sets.length; i++) {
                if (!sets[i] || !sets[i].length) continue;
                var row = sets[i][0];
                for (var j = 0; j < requiredColumns.length; j++) {
                    if (row[requiredColumns[j]] !== undefined) return sets[i];
                }
            }
            return [];
        }

        function bindPurchaseOrder(sets) {
            sets = sets || [];
            var headers = findTable(sets, ['PurchaseOrderNumber', 'PurchaseOrderDate', 'VendorID', 'BranchID']);
            var items = findTable(sets, ['PurchaseOrderItemID', 'OrderedQuantity', 'UnitPrice', 'AssetCategoryID']);
            var terms = findTable(sets, ['TermDescription', 'TermText', 'TermsAndConditions', 'Term']);
            var h = headers.length ? headers[0] : {};

            $('#poid').val(valueOf(h, ['PurchaseOrderID'], pageId));
            $('#ponumber').val(valueOf(h, ['PurchaseOrderNumber', 'PONumber'], ''));
            $('#podate').val(dateForInput(valueOf(h, ['PurchaseOrderDate', 'PODate'], '')));
            $('#vendor').val(valueOf(h, ['VendorID'], ''));
            $('#quotation').val(valueOf(h, ['QuotationID'], ''));
            $('#request').val(valueOf(h, ['PurchaseRequestID'], ''));
            $('#branch').val(valueOf(h, ['BranchID'], ''));
            $('#delivery').val(dateForInput(valueOf(h, ['ExpectedDeliveryDate'], '')));
            $('#currency').val(valueOf(h, ['CurrencyCode'], ''));
            $('#billing').val(valueOf(h, ['BillingAddress'], ''));
            $('#shipping').val(valueOf(h, ['ShippingAddress'], ''));
            $('#payment').val(valueOf(h, ['PaymentTerms'], ''));
            $('#freight').val(valueOf(h, ['FreightCharges'], 0));
            $('#other').val(valueOf(h, ['OtherCharges'], 0));
            $('#remarks').val(valueOf(h, ['Remarks'], ''));

            $('#items').empty();
            if (items.length) $.each(items, function (_, item) { addItem(item); });
            else addItem();

            $('#terms').empty();
            if (terms.length) {
                $.each(terms, function (_, term) {
                    addTerm(valueOf(term, ['TermDescription', 'TermText', 'TermsAndConditions', 'Term'], ''));
                });
            } else {
                addTerm();
            }
            applyViewMode();
        }

        function getPurchaseOrder() {
            if (!pageId) return;
            AssetUI.post('PurchaseOrder.aspx/Get', { id: pageId }, bindPurchaseOrder);
        }

        function applyViewMode() {
            if (!isViewMode) return;
            $('.edit-only').hide();
            $('.entry-form :input, #items :input, #terms :input').prop('disabled', true);
        }

        function savePurchaseOrder() {
            var items = [];
            $('#items tr').each(function () {
                var row = $(this);
                items.push({
                    AssetCategoryID: +row.find('.i-category').val() || null,
                    AssetTypeID: +row.find('.i-type').val() || null,
                    AssetBrandID: +row.find('.i-brand').val() || null,
                    AssetModelID: +row.find('.i-model').val() || null,
                    ItemDescription: row.find('.i-description').val(),
                    OrderedQuantity: +row.find('.i-qty').val() || 0,
                    UnitPrice: +row.find('.i-price').val() || 0,
                    DiscountAmount: +row.find('.i-discount').val() || 0,
                    TaxPercentage: +row.find('.i-tax').val() || 0,
                    WarrantyPeriod: row.find('.i-warranty').val()
                });
            });

            var terms = [];
            $('.po-term').each(function () { if ($.trim($(this).val())) terms.push($.trim($(this).val())); });

            var x = {
                PurchaseOrderID: +$('#poid').val() || 0,
                PurchaseOrderNumber: $.trim($('#ponumber').val()),
                PurchaseOrderDate: $('#podate').val(),
                VendorID: +$('#vendor').val() || 0,
                QuotationID: AssetUI.num('#quotation'),
                PurchaseRequestID: AssetUI.num('#request'),
                BranchID: +$('#branch').val() || 0,
                BillingAddress: $('#billing').val(),
                ShippingAddress: $('#shipping').val(),
                ExpectedDeliveryDate: $('#delivery').val() || null,
                PaymentTerms: $('#payment').val(),
                CurrencyCode: $('#currency').val(),
                FreightCharges: +$('#freight').val() || 0,
                OtherCharges: +$('#other').val() || 0,
                Remarks: $('#remarks').val(),
                Items: items,
                Terms: terms
            };

            AssetUI.post('PurchaseOrder.aspx/Save', { x: x }, function (result) {
                if (result && result.Success === false) return;
                loadGrid();
                if (result && result.Data) {
                    pageId = +result.Data;
                    $('#poid').val(pageId);
                    history.replaceState(null, '', 'PurchaseOrder.aspx?id=' + pageId + '&mode=edit');
                    getPurchaseOrder();
                }
            });
        }

        function loadGrid() {
            AssetUI.post('PurchaseOrder.aspx/List', {}, function (rows) {
                AssetUI.table('#grid', rows,
                    [{ data: 'PurchaseOrderNumber', title: 'PO No.' }, { data: 'PurchaseOrderDate', title: 'PO Date' }, { data: 'VendorName', title: 'Vendor' }, { data: 'BranchName', title: 'Branch' }, { data: 'ExpectedDeliveryDate', title: 'Expected Delivery' }, { data: 'GrandTotal', title: 'Grand Total' }, { data: 'ApprovalStatus', title: 'Approval' }, { data: 'Status', title: 'Status' }],
                    [{ text: 'View', fn: 'viewPo', id: 'PurchaseOrderID' }, { text: 'Edit', fn: 'editPo', id: 'PurchaseOrderID' }, { text: 'Download PDF', fn: 'downloadPo', id: 'PurchaseOrderID' }]);
            });
        }

        function viewPo(id) { location.href = 'PurchaseOrder.aspx?id=' + id + '&mode=view'; }
        function editPo(id) { location.href = 'PurchaseOrder.aspx?id=' + id + '&mode=edit'; }
        function downloadPo(id) { AssetUI.downloadPurchaseOrder(id); }

        $(document)
            .on('click', '.remove-item', function () { $(this).closest('tr').remove(); })
            .on('click', '.remove-term', function () { $(this).closest('.input-group').remove(); });

        $(function () {
            loadLookups(function () {
                if (pageId) getPurchaseOrder();
                else { addItem(); addTerm(); }
                applyViewMode();
            });
            loadGrid();
        });
</script>
</div>
<script src="asset-common.js"></script>
</asp:Content>
