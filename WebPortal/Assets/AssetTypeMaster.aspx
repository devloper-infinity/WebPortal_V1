<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssetTypeMaster.aspx.cs" Inherits="WebPortal.Assets.AssetTypeMaster" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server"><link href="asset-common.css" rel="stylesheet" /></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="asset-page">
    <div class="asset-hero"><h2>Asset Type Master</h2><small>Assets / Asset Type Master</small></div>
    <div class="erp-panel">
        <div class="erp-panel-title">Master Details</div>
        <div class="erp-panel-body">
            <div class="row entry-form">
                <input id="id" type="hidden" />
                <div class="col-md-3 form-group"><label class="required">Category</label><select id="category" class="form-control"><option value="">-- Select --</option></select></div>
                <div class="col-md-3 form-group"><label class="required">Asset Type Name</label><input id="name" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Type Code</label><input id="code" type="text" class="form-control" /></div>
                <div class="col-md-6 form-group"><label>Description</label><textarea id="description" class="form-control" rows="2"></textarea></div>
                <div class="col-md-3 form-group"><div><input id="serial" type="checkbox" /> <span>Requires Serial Number</span></div></div>
                <div class="col-md-3 form-group"><div><input id="tag" type="checkbox" /> <span>Requires Asset Tag</span></div></div>
                <div class="col-md-3 form-group"><div><input id="consumable" type="checkbox" /> <span>Consumable</span></div></div>
                <div class="col-md-3 form-group"><div><input id="active" type="checkbox" /> <span>Active</span></div></div>
            </div>
            <button class="btn btn-primary" onclick="save();return false;">Save</button>
            <button class="btn btn-secondary" onclick="clearForm();return false;">Clear</button>
        </div>
    </div>
    <div class="erp-panel"><div class="erp-panel-title">Existing Records</div><div class="erp-panel-body"><div style="position:relative"><table id="grid" class="table table-bordered table-sm"></table></div></div></div>
</div>
<script>
function look(){AssetUI.post('AssetTypeMaster.aspx/Lookup',{type:'Category',parentID:null},function(rows){AssetUI.fill('#category',rows,'ID','Name');});}
function load(){AssetUI.post('AssetTypeMaster.aspx/List',{},function(rows){AssetUI.table('#grid',rows,[{data:'ID',title:'ID'},{data:'CategoryName',title:'Category'},{data:'Name',title:'Name'},{data:'Code',title:'Code'},{data:'Description',title:'Description'},{data:'IsActive',title:'Active'}],[{text:'Edit',fn:'editRow',id:'ID'}]);});}
function save(){AssetUI.post('AssetTypeMaster.aspx/Save',{x:{ID:+$('#id').val()||0,ParentID:AssetUI.num('#category'),Name:$('#name').val(),Code:$('#code').val(),Description:$('#description').val(),IsActive:$('#active').is(':checked'),Flag1:$('#serial').is(':checked'),Flag2:$('#tag').is(':checked'),Flag3:$('#consumable').is(':checked')}},function(){clearForm();load();});}
function editRow(id){AssetUI.post('AssetTypeMaster.aspx/Get',{id:id},function(rows){if(!rows||!rows.length)return;var x=rows[0];$('#id').val(x.ID);$('#category').val(x.ParentID);$('#name').val(x.Name);$('#code').val(x.Code);$('#description').val(x.Description);$('#serial').prop('checked',x.RequiresSerialNumber);$('#tag').prop('checked',x.RequiresAssetTag);$('#consumable').prop('checked',x.IsConsumable);$('#active').prop('checked',x.IsActive);window.scrollTo(0,0);});}
function clearForm(){AssetUI.clear();$('#id').val('');$('#active').prop('checked',true);}
$(function(){look();clearForm();load();});
</script>
<script src="asset-common.js"></script>
</asp:Content>
