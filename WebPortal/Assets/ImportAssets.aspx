<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImportAssets.aspx.cs" Inherits="WebPortal.Assets.ImportAssets" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
        <div class="asset-hero"><h2>Import Assets</h2><small>Assets / Import Assets</small></div>
        <div class="erp-panel">
            <div class="erp-panel-title">Import Assets from CSV</div>
            <div class="erp-panel-body">
                <div class="row">
                    <div class="col-md-6 form-group"><label class="required">CSV File</label><asp:FileUpload ID="fuAssets" runat="server" CssClass="form-control" accept=".csv,text/csv" /></div>
                    <div class="col-md-3 form-group"><label>Default Branch</label><select id="branch" name="branch" class="form-control"></select></div>
                </div>
                <asp:Button ID="btnImport" runat="server" Text="Validate and Import" CssClass="btn btn-primary" OnClick="btnImport_Click" />
                <a href="Templates/AssetImportTemplate.csv" class="btn btn-outline-secondary">Download Template</a>
                <asp:Label ID="lblMessage" runat="server" CssClass="ml-2"></asp:Label>
            </div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title" id="gridTitle">Import History</div>
            <div class="erp-panel-body"><div style="position:relative"><table id="grid" class="table table-bordered table-sm"></table></div></div>
        </div>
        <script>
            function columns(rows) {
                if (!rows || !rows.length) return [];
                return Object.keys(rows[0]).map(function (key) { return { data: key, title: key.replace(/([A-Z])/g, ' $1').trim() }; });
            }
            function load() {
                AssetUI.post('ImportAssets.aspx/Lookup', { type: 'Branch', parentID: null }, function (rows) { AssetUI.fill('#branch', rows, 'ID', 'Name'); });
                var importId = AssetUI.query('importId');
                if (importId) {
                    AssetUI.post('ImportAssets.aspx/Get', { id: +importId }, function (rows) {
                        rows = rows || [];
                        $('#gridTitle').text('Import Errors');
                        AssetUI.table('#grid', rows, columns(rows));
                    });
                    return;
                }
                AssetUI.post('ImportAssets.aspx/List', {}, function (rows) {
                    AssetUI.table('#grid', rows, [{ data: 'ImportID', title: 'Import ID' }, { data: 'FileName', title: 'File' }, { data: 'TotalRecords', title: 'Total' }, { data: 'SuccessRecords', title: 'Success' }, { data: 'FailedRecords', title: 'Failed' }, { data: 'Status', title: 'Status' }, { data: 'AddedDate', title: 'Date' }], [{ text: 'View Errors', fn: 'viewErrors', id: 'ImportID' }]);
                });
            }
            function viewErrors(id) { location.href = 'ImportAssets.aspx?importId=' + id; }
            $(load);
        </script>
    </div>
    <script src="asset-common.js"></script>
</asp:Content>
