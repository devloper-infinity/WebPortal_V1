<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewPurchaseOrders.aspx.cs" Inherits="WebPortal.Assets.ViewPurchaseOrders" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
        <div class="asset-hero">
            <h2>View Purchase Orders</h2>
            <small>Assets / View Purchase Orders</small>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Purchase Order Filters</div>
            <div class="erp-panel-body">
                <div class="row">
                    <div class="col-md-3 form-group">
                        <label class="">Branch</label><select id="branch" class="form-control"><option value="">-- Select --</option>
                        </select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="">Status</label><input id="status" type="text" class="form-control" />
                    </div>
                </div>
                <button class="btn btn-primary" onclick="load();return false;">Search</button>
                <a href="PurchaseOrder.aspx" class="btn btn-success">Create PO</a>
            </div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Purchase Orders</div>
            <div class="erp-panel-body">
                <div style="position: relative">
                    <table id="grid" class="table table-bordered table-sm"></table>
                </div>
            </div>
        </div>
            <script>
                function loadLookup() {
                    AssetUI.post('ViewPurchaseOrders.aspx/Lookup', { type: 'Branch', parentID: null }, function (rows) {
                        AssetUI.fill('#branch', rows, 'ID', 'Name');
                    });
                }

                function loadPurchaseOrders() {
                    AssetUI.post('ViewPurchaseOrders.aspx/List', {
                        branchID: AssetUI.num('#branch'),
                        status: $.trim($('#status').val()) || null
                    }, function (rows) {
                        AssetUI.table('#grid', rows,
                            [{ data: 'PurchaseOrderNumber', title: 'PO No.' }, { data: 'PurchaseOrderDate', title: 'Date' }, { data: 'VendorName', title: 'Vendor' }, { data: 'BranchName', title: 'Branch' }, { data: 'GrandTotal', title: 'Grand Total' }, { data: 'ApprovalStatus', title: 'Approval' }, { data: 'Status', title: 'Status' }],
                            [{ text: 'View', fn: 'viewPo', id: 'PurchaseOrderID' }, { text: 'Edit', fn: 'editPo', id: 'PurchaseOrderID' }, { text: 'Download PDF', fn: 'downloadPo', id: 'PurchaseOrderID' }]);
                    });
                }

                function clearFilters() {
                    $('#branch').val('');
                    $('#status').val('');
                    loadPurchaseOrders();
                }

                function viewPo(id) { location.href = 'PurchaseOrder.aspx?id=' + id + '&mode=view'; }
                function editPo(id) { location.href = 'PurchaseOrder.aspx?id=' + id + '&mode=edit'; }
                function downloadPo(id) { AssetUI.downloadPurchaseOrder(id); }

                $(function () { loadLookup(); loadPurchaseOrders(); });
</script>
    </div>
    <script src="asset-common.js"></script>
</asp:Content>
