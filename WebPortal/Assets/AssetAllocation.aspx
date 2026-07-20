<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssetAllocation.aspx.cs" Inherits="WebPortal.Assets.AssetAllocation" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
    <style>
        .asset-picker { border: 1px solid #d7e0ed; border-radius: 8px; background: #fff; overflow: hidden; }
        .asset-picker-search { padding: 10px; border-bottom: 1px solid #e5eaf1; background: #f8fafc; }
        .asset-picker-search input { margin: 0; }
        .asset-picker-list { max-height: 245px; overflow-y: auto; padding: 5px 10px; }
        .asset-picker-item { display: flex; align-items: center; gap: 9px; margin: 0; padding: 8px 5px; cursor: pointer; border-bottom: 1px solid #f0f3f7; font-weight: 400; }
        .asset-picker-item:last-child { border-bottom: 0; }
        .asset-picker-item:hover { background: #f4f8ff; }
        .asset-picker-item input { margin: 0; }
        .asset-picker-empty { padding: 25px 10px; color: #718096; text-align: center; }
        .asset-picker-footer { padding: 8px 14px; color: #315580; background: #f4f8ff; border-top: 1px solid #dce7f5; font-weight: 600; }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="asset-page">
        <div class="asset-hero">
            <h2>Asset Allocation</h2>
            <small>Assets / Asset Allocation</small>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Allocate Assets to Employee</div>
            <div class="erp-panel-body">
                <div class="row entry-form">
                    <div class="col-md-3 form-group">
                        <label class="required">Employee</label>
                        <select id="employee" class="form-control"><option value="">-- Select Employee --</option></select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="required">Shift</label>
                        <select id="shift" class="form-control"><option value="">-- Select Shift --</option><option value="1">Day</option><option value="2">Night</option></select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="required">Branch</label>
                        <select id="branch" class="form-control"><option value="">-- Select Branch --</option></select>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="required">Allocation Date</label>
                        <input id="date" type="date" class="form-control" />
                    </div>
                    <div class="col-md-4 form-group">
                        <label>Expected Return</label>
                        <input id="expected" type="date" class="form-control" />
                    </div>
                    <div class="col-md-4 form-group">
                        <label>Condition at Allocation</label>
                        <select id="condition" class="form-control">
                            <option value="">-- Select Condition --</option>
                            <option value="New">New</option>
                            <option value="Excellent">Excellent</option>
                            <option value="Good">Good</option>
                            <option value="Fair">Fair</option>
                            <option value="Refurbished">Refurbished</option>
                            <option value="Damaged">Damaged</option>
                        </select>
                    </div>
                    <div class="col-md-4 form-group">
                        <label>Asset Status after Allocation</label>
                        <select id="status" class="form-control"><option value="">-- Keep Current Status --</option></select>
                        <small class="text-muted">Select a WFH or other configured status when required.</small>
                    </div>
                    <div class="col-md-12 form-group">
                        <label class="required">Available Assets</label>
                        <div class="asset-picker">
                            <div class="asset-picker-search"><input id="assetSearch" type="search" class="form-control" placeholder="Search by asset tag, type, serial number or description..." autocomplete="off" /></div>
                            <div id="assetOptions" class="asset-picker-list"></div>
                            <div class="asset-picker-footer"><span id="selectedCount">0</span> asset(s) selected</div>
                        </div>
                    </div>
                    <div class="col-md-6 form-group">
                        <label>Accessories Issued</label>
                        <textarea id="accessories" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="col-md-6 form-group">
                        <label>Purpose</label>
                        <textarea id="purpose" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="col-md-12 form-group">
                        <label>Remarks</label>
                        <textarea id="remarks" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                <button id="allocateButton" class="btn btn-primary" onclick="saveBatch();return false;"><i class="fa fa-check"></i> Allocate Selected Assets</button>
                <button class="btn btn-secondary" onclick="clearForm();return false;"><i class="fa fa-eraser"></i> Clear</button>
            </div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Active Employee Allocations</div>
            <div class="erp-panel-body"><div style="position:relative"><table id="grid" class="table table-bordered table-sm"></table></div></div>
        </div>
    </div>
    <script src="asset-common.js"></script>
    <script>
        var availableAssets = [], selectedAssets = {};

        function textOf(asset) {
            return String(asset.Name || asset.AssetTagNumber || asset.ID || '');
        }

        function renderAssets() {
            var term = $.trim($('#assetSearch').val()).toLowerCase();
            var rows = availableAssets.filter(function (asset) { return !term || textOf(asset).toLowerCase().indexOf(term) >= 0; });
            var html = rows.map(function (asset) {
                var id = String(asset.ID), checked = selectedAssets[id] ? ' checked' : '';
                return '<label class="asset-picker-item"><input class="asset-check" type="checkbox" value="' + AssetUI.escape(id) + '"' + checked + ' /><span>' + AssetUI.escape(textOf(asset)) + '</span></label>';
            }).join('');
            $('#assetOptions').html(html || '<div class="asset-picker-empty">No available assets match your search.</div>');
            $('#selectedCount').text(Object.keys(selectedAssets).length);
        }

        function loadLookups() {
            AssetUI.post('AssetAllocation.aspx/Lookup', { type: 'Employee', parentID: null }, function (r) { AssetUI.fill('#employee', r, 'ID', 'Name', '-- Select Employee --'); });
            AssetUI.post('AssetAllocation.aspx/Lookup', { type: 'Branch', parentID: null }, function (r) { AssetUI.fill('#branch', r, 'ID', 'Name', '-- Select Branch --'); });
            AssetUI.post('AssetAllocation.aspx/Lookup', { type: 'Status', parentID: null }, function (r) {
                AssetUI.fill('#status', r, 'ID', 'Name', '-- Keep Current Status --');
                $.each(r || [], function (_, item) { if (String(item.Name).toLowerCase() === 'allocated') $('#status').val(item.ID); });
            });
        }

        function loadAvailableAssets() {
            var shiftID = +$('#shift').val() || 0;
            selectedAssets = {};
            if (!shiftID) { availableAssets = []; renderAssets(); return; }
            AssetUI.post('AssetAllocation.aspx/Lookup', { type: 'AvailableAssetByShift', parentID: shiftID }, function (r) { availableAssets = r || []; renderAssets(); });
        }

        function requireValue(selector, message) {
            var field = $(selector).removeClass('is-invalid');
            if ($.trim(field.val() || '') !== '') return true;
            field.addClass('is-invalid').focus(); AssetUI.message(message, 'error'); return false;
        }

        function saveBatch() {
            var ids = Object.keys(selectedAssets).map(function (id) { return +id; });
            if (!requireValue('#employee', 'Employee is required.')) return;
            if (!requireValue('#shift', 'Shift is required.')) return;
            if (!requireValue('#branch', 'Branch is required.')) return;
            if (!requireValue('#date', 'Allocation date is required.')) return;
            if (!ids.length) { AssetUI.message('Select at least one available asset.', 'error'); $('#assetSearch').focus(); return; }
            var x = {
                AssetIDs: ids, EmployeeID: +$('#employee').val(), ShiftID: +$('#shift').val(), ShiftName: $('#shift option:selected').text(), BranchID: +$('#branch').val(),
                AllocationDate: $('#date').val(), ExpectedReturnDate: $('#expected').val() || null,
                AssetConditionAtAllocation: $('#condition').val(), AccessoriesIssued: $('#accessories').val(),
                Purpose: $('#purpose').val(), Remarks: $('#remarks').val(), AssetStatusID: +$('#status').val() || null
            };
            $('#allocateButton').prop('disabled', true);
            AssetUI.post('AssetAllocation.aspx/SaveBatch', { x: x }, function () { clearForm(); loadLookups(); load(); })
                .always(function () { $('#allocateButton').prop('disabled', false); });
        }

        function clearForm() {
            selectedAssets = {}; $('#employee,#shift,#branch,#condition,#status').val(''); $('#expected,#accessories,#purpose,#remarks,#assetSearch').val(''); availableAssets = [];
            $('#date').val(AssetUI.date(new Date())); renderAssets();
        }

        function load() {
            AssetUI.post('AssetAllocation.aspx/List', {}, function (r) {
                AssetUI.table('#grid', r, [
                    { data: 'AllocationNumber', title: 'Allocation No.' }, { data: 'AssetTagNumber', title: 'Asset Tag' },
                    { data: 'AssetTypeName', title: 'Asset Type' }, { data: 'EmployeeName', title: 'Employee' },
                    { data: 'ShiftName', title: 'Shift' }, { data: 'BranchName', title: 'Branch' }, { data: 'AllocationDate', title: 'Allocation Date' },
                    { data: 'ExpectedReturnDate', title: 'Expected Return' }, { data: 'AssetStatusName', title: 'Asset Status' },
                    { data: 'AllocationStatus', title: 'Allocation Status' }
                ], [{ text: 'View', fn: 'viewAllocation', id: 'AllocationID' }, { text: 'Return', fn: 'returnAsset', id: 'AllocationID', cls: 'btn-warning' }]);
            });
        }

        function viewAllocation(id) { location.href = 'AssetAllocationHistory.aspx?id=' + id; }
        function returnAsset(id) { location.href = 'AssetReturn.aspx?id=' + id; }

        $(document).on('change', '#shift', loadAvailableAssets).on('input', '#assetSearch', renderAssets).on('change', '.asset-check', function () {
            if (this.checked) selectedAssets[this.value] = true; else delete selectedAssets[this.value];
            $('#selectedCount').text(Object.keys(selectedAssets).length);
        });
        $(function () { $('#date').val(AssetUI.date(new Date())); loadLookups(); load(); });
    </script>
</asp:Content>
