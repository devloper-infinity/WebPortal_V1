<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssetTransfer.aspx.cs" Inherits="WebPortal.Assets.AssetTransfer" MasterPageFile="~/Assets/Admin.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="asset-common.css" rel="stylesheet" />
    <style>
    .asset-multi {
        position: relative
    }

    .asset-multi-toggle {
        min-height: 38px;
        text-align: left;
        background: #fff;
        white-space: normal
    }

    .asset-multi-menu {
        display: none;
        position: absolute;
        z-index: 1050;
        top: 100%;
        left: 0;
        right: 0;
        background: #fff;
        border: 1px solid #ced4da;
        border-radius: 0 0 4px 4px;
        box-shadow: 0 5px 15px rgba(0,0,0,.15);
        padding: 8px
    }

    .asset-multi.open .asset-multi-menu {
        display: block
    }

    .asset-multi-list {
        max-height: 240px;
        overflow: auto;
        margin-top: 8px;
        border-top: 1px solid #eee
    }

    .asset-option {
        display: block;
        padding: 7px 5px;
        margin: 0;
        font-weight: 400;
        cursor: pointer
    }

        .asset-option:hover {
            background: #f5f7fa
        }

        .asset-option input {
            margin-right: 8px
        }

    .selected-assets {
        margin-top: 6px;
        font-size: 12px;
        color: #6c757d
    }
</style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="asset-page">
        <div class="asset-hero">
            <h2>Asset Transfer</h2>
            <small>Assets / Asset Transfer</small></div>
        <div class="erp-panel">
            <div class="erp-panel-title">Asset Transfer Request</div>
            <div class="erp-panel-body">
                <div class="row entry-form">
                    <div class="hidden-id form-group">
                        <input id="tid" type="hidden" /></div>
                    <div class="col-md-6 form-group">
                        <label class="required">Available Assets</label><div id="assetMulti" class="asset-multi">
                            <button id="assetToggle" type="button" class="form-control asset-multi-toggle">-- Select Assets --</button><div class="asset-multi-menu">
                                <input id="assetSearch" type="text" class="form-control" placeholder="Search asset type, serial number or barcode..." autocomplete="off" /><div id="assetList" class="asset-multi-list"></div>
                            </div>
                        </div>
                        <div id="assetCount" class="selected-assets">No assets selected</div>
                    </div>
                    <div class="col-md-3 form-group">
                        <label class="required">From Branch</label><select id="fromBranch" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="required">To Branch</label><select id="toBranch" class="form-control"><option value="">-- Select --</option>
                        </select></div>
                    <div class="col-md-3 form-group">
                        <label class="required">Transfer Date</label><input id="date" type="date" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label>Expected Receipt Date</label><input id="expected" type="date" class="form-control" /></div>
                    <div class="col-md-6 form-group">
                        <label class="required">Transfer Reason</label><textarea id="reason" class="form-control" rows="2"></textarea></div>
                    <div class="col-md-3 form-group">
                        <label>Courier Name</label><input id="courier" type="text" class="form-control" /></div>
                    <div class="col-md-3 form-group">
                        <label>Tracking Number</label><input id="tracking" type="text" class="form-control" /></div>
                    <div class="col-md-6 form-group">
                        <label>Remarks</label><textarea id="remarks" class="form-control" rows="2"></textarea></div>
                </div>
                <button class="btn btn-primary" onclick="save();return false;">Create Transfers</button>
            </div>
        </div>
        <div class="erp-panel">
            <div class="erp-panel-title">Transfers</div>
            <div class="erp-panel-body">
                <div style="position: relative">
                    <table id="grid" class="table table-bordered table-sm"></table>
                </div>
            </div>
        </div>
        <script>
            var availableAssets = [], selectedAssets = {};
            function look() { AssetUI.post('AssetTransfer.aspx/Lookup', { type: 'TransferAvailableAsset', parentID: null }, function (r) { availableAssets = r || []; renderAssets(); });[['Branch', '#fromBranch'], ['Branch', '#toBranch']].forEach(function (x) { AssetUI.post('AssetTransfer.aspx/Lookup', { type: x[0], parentID: null }, function (r) { AssetUI.fill(x[1], r, 'ID', 'Name'); }); }); }
            function renderAssets() { var q = ($('#assetSearch').val() || '').toLowerCase(); var branchID = +$('#fromBranch').val() || 0; var html = ''; $.each(availableAssets, function (_, a) { var id=String(a.ID),name = a.Name || ''; if (branchID && +a.BranchID !== branchID) return; if (q && name.toLowerCase().indexOf(q) < 0) return; html += '<label class="asset-option"><input type="checkbox" class="asset-check" value="' + AssetUI.escape(id) + '"' + (selectedAssets[id]?' checked':'') + '>' + AssetUI.escape(name) + '</label>'; }); $('#assetList').html(html || '<div class="text-muted p-2">No matching available assets for the selected branch.</div>'); updateAssetCount(); }
            function selectedAssetIDs() { return Object.keys(selectedAssets).map(function(id){return +id;}); }
            function updateAssetCount() { var count = Object.keys(selectedAssets).length; $('#assetCount').text(count ? count + ' asset(s) selected' : 'No assets selected'); $('#assetToggle').text(count ? count + ' asset(s) selected' : '-- Select Assets --'); }
            function required(selector,message){var field=$(selector).removeClass('is-invalid');if($.trim(field.val()||''))return true;field.addClass('is-invalid').focus();AssetUI.message(message,'error');return false;}
            function save() { var ids = selectedAssetIDs(); if (!required('#fromBranch','From Branch is required.'))return;if(!required('#toBranch','To Branch is required.'))return;if(+$('#fromBranch').val()===+$('#toBranch').val()){AssetUI.message('From Branch and To Branch must be different.','error');return;}if(!required('#date','Transfer Date is required.'))return;if(!required('#reason','Transfer Reason is required.'))return;if (!ids.length) { AssetUI.message('Please select at least one available asset.','error'); $('#assetToggle').focus();return; } var x = { TransferID: 0, AssetID: 0, FromBranchID: +$('#fromBranch').val(), ToBranchID: +$('#toBranch').val(), TransferDate: $('#date').val(), ExpectedReceiptDate: $('#expected').val() || null, TransferReason: $('#reason').val(), CourierName: $('#courier').val(), TrackingNumber: $('#tracking').val(), Remarks: $('#remarks').val() }; AssetUI.post('AssetTransfer.aspx/SaveBatch', { assetIDs: ids, x: x }, function () { selectedAssets={};look();load();AssetUI.clear('.entry-form'); }); }
            function isApproved(row){var s=String(row.TransferStatus||'').toLowerCase();return s==='approved'||s==='approve';}
            function load() { AssetUI.post('AssetTransfer.aspx/List', {}, function (r) { AssetUI.table('#grid', r, [{ data: 'TransferNumber', title: 'Transfer No.' }, { data: 'AssetTagNumber', title: 'Asset Tag' }, { data: 'FromBranchName', title: 'From' }, { data: 'ToBranchName', title: 'To' }, { data: 'TransferDate', title: 'Date' }, { data: 'ExpectedReceiptDate', title: 'Expected Receipt' }, { data: 'TransferStatus', title: 'Status' }, { data: 'TrackingNumber', title: 'Tracking No.' }], [{ text: 'View', fn: 'view', id: 'TransferID' }, { text: 'Dispatch', fn: 'dispatch', id: 'TransferID', enabled: isApproved, disabledMessage: 'Asset transfer is not approved.' }]); }); }
            function view(id) { location.href = 'AssetTransferHistory.aspx?id=' + id; } function dispatch(id,row) { if(!isApproved(row)){AssetUI.message('Asset transfer is not approved.','error');return;}AssetUI.post('AssetTransfer.aspx/Action', { id: id, action: 'Dispatched', remarks: '' }, load); }
            $(function () { look(); load(); $('#assetToggle').on('click', function (e) { e.stopPropagation(); $('#assetMulti').toggleClass('open'); if ($('#assetMulti').hasClass('open')) $('#assetSearch').focus(); }); $('#assetSearch').on('input', renderAssets); $('#fromBranch').on('change', function () { selectedAssets={};renderAssets(); }); $('#assetList').on('change', '.asset-check', function(){if(this.checked)selectedAssets[this.value]=true;else delete selectedAssets[this.value];updateAssetCount();}); $(document).on('click', function (e) { if (!$(e.target).closest('#assetMulti').length) $('#assetMulti').removeClass('open'); }); });
</script>
    </div>
    <script src="asset-common.js"></script>
</asp:Content>
