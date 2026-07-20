<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssetCategoryMaster.aspx.cs" Inherits="WebPortal.Assets.AssetCategoryMaster" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server"><link href="asset-common.css" rel="stylesheet" /></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="asset-page">
    <div class="asset-hero"><h2>Asset Category Master</h2><small>Assets / Asset Category Master</small></div>
    <div class="erp-panel">
        <div class="erp-panel-title">Master Details</div>
        <div class="erp-panel-body">
            <div class="row entry-form">
                <div class="hidden-id form-group"><input id="id" type="hidden" /></div>
                <div class="col-md-3 form-group"><label class="required">Company</label><select id="company" class="form-control"><option value="">-- Select Company --</option></select></div>
                <div class="col-md-3 form-group"><label class="required">Category Name</label><input id="name" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Category Code</label><input id="code" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Useful Life (Months)</label><input id="life" type="number" class="form-control" /></div>
                <div class="col-md-6 form-group"><label>Description</label><textarea id="description" class="form-control" rows="2"></textarea></div>
                <div class="col-md-3 form-group"><div><input id="dep" type="checkbox" /> <span>Depreciation Applicable</span></div></div>
                <div class="col-md-3 form-group"><div><input id="active" type="checkbox" /> <span>Active</span></div></div>
            </div>
            <button class="btn btn-primary" onclick="save();return false;">Save</button>
            <button class="btn btn-secondary" onclick="clearForm();return false;">Clear</button>
        </div>
    </div>
    <div class="erp-panel"><div class="erp-panel-title">Existing Records</div><div class="erp-panel-body"><div style="position:relative"><table id="grid" class="table table-bordered table-sm"></table></div></div></div>
</div>
<script>
function look(){AssetUI.post('AssetCategoryMaster.aspx/Lookup',{type:'Company',parentID:null},function(rows){AssetUI.fill('#company',rows,'ID','Name');});}
function load(){AssetUI.post('AssetCategoryMaster.aspx/List',{},function(rows){AssetUI.table('#grid',rows,[{data:'ID',title:'ID'},{data:'CompanyName',title:'Company'},{data:'Name',title:'Category Name'},{data:'Code',title:'Code'},{data:'DefaultUsefulLifeInMonths',title:'Useful Life (Months)'},{data:'Description',title:'Description'},{data:'IsActive',title:'Active'}],[{text:'Edit',fn:'editRow',id:'ID'}]);});}
function save(){AssetUI.post('AssetCategoryMaster.aspx/Save',{x:{ID:+$('#id').val()||0,CompanyID:AssetUI.num('#company'),Name:$('#name').val(),Code:$('#code').val(),Description:$('#description').val(),IsActive:$('#active').is(':checked'),Flag1:$('#dep').is(':checked'),Number1:AssetUI.num('#life')}},function(){clearForm();load();});}
function editRow(id){AssetUI.post('AssetCategoryMaster.aspx/Get',{id:id},function(rows){if(!rows||!rows.length)return;var x=rows[0];$('#id').val(x.ID);$('#company').val(x.CompanyID);$('#name').val(x.Name);$('#code').val(x.Code);$('#life').val(x.DefaultUsefulLifeInMonths);$('#description').val(x.Description);$('#dep').prop('checked',x.DepreciationApplicable);$('#active').prop('checked',x.IsActive);window.scrollTo(0,0);});}
function clearForm(){AssetUI.clear();$('#id').val('');$('#active').prop('checked',true);}
$(function(){look();clearForm();load();});
</script>
<script src="asset-common.js"></script>
</asp:Content>
