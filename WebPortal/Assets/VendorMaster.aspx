<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorMaster.aspx.cs" Inherits="WebPortal.Assets.VendorMaster" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server"><link href="asset-common.css" rel="stylesheet" /></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="asset-page">
    <div class="asset-hero"><h2>Vendor Master</h2><small>Assets / Vendor Master</small></div>
    <div class="erp-panel">
        <div class="erp-panel-title">Add Vendor</div>
        <div class="erp-panel-body">
            <p class="text-muted mb-4">Enter vendor profile, communication details, and account information.</p>
            <div class="row entry-form">
                <input id="id" type="hidden" />
                <div class="col-md-3 form-group"><label class="required">Vendor Name</label><input id="name" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>GST No</label><input id="gst" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Contact Person</label><input id="contact" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Phone Number</label><input id="phone" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Email Address</label><input id="email" type="email" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Fax</label><input id="fax" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Web URL</label><input id="website" type="url" class="form-control" placeholder="https://" /></div>
                <div class="col-md-3 form-group"><label>PAN</label><input id="pan" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Account Holder</label><input id="accountHolder" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Bank Name</label><input id="bankName" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Branch Address</label><input id="bankBranch" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Account Type</label><input id="accountType" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>Account #</label><input id="accountNumber" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>MICR Code</label><input id="micr" type="text" class="form-control" /></div>
                <div class="col-md-3 form-group"><label>IFSC Code</label><input id="ifsc" type="text" class="form-control" /></div>
                <div class="col-md-6 form-group"><label>Description</label><textarea id="description" class="form-control" rows="3"></textarea></div>
                <div class="col-md-6 form-group"><label>Address</label><textarea id="address" class="form-control" rows="3"></textarea></div>
                <div class="col-md-3 form-group"><div><input id="active" type="checkbox" /> <span>Active</span></div></div>
            </div>
            <button class="btn btn-primary" onclick="save();return false;">Save Vendor</button>
            <button class="btn btn-secondary" onclick="clearForm();return false;">Clear</button>
        </div>
    </div>
    <div class="erp-panel"><div class="erp-panel-title">Existing Vendors</div><div class="erp-panel-body"><div style="position:relative"><table id="grid" class="table table-bordered table-sm"></table></div></div></div>
</div>
<script>
function load(){AssetUI.post('VendorMaster.aspx/List',{},function(rows){AssetUI.table('#grid',rows,[{data:'ID',title:'ID'},{data:'Name',title:'Vendor Name'},{data:'GSTNumber',title:'GST No'},{data:'ContactPerson',title:'Contact Person'},{data:'PhoneNumber',title:'Phone Number'},{data:'EmailAddress',title:'Email'},{data:'BankName',title:'Bank Name'},{data:'IsActive',title:'Active'}],[{text:'Edit',fn:'editRow',id:'ID'}]);});}
function save(){var x={ID:+$('#id').val()||0,Name:$('#name').val(),Description:$('#description').val(),Address:$('#address').val(),ContactPerson:$('#contact').val(),PhoneNumber:$('#phone').val(),EmailAddress:$('#email').val(),GSTNumber:$('#gst').val(),PANNumber:$('#pan').val(),FaxNumber:$('#fax').val(),WebsiteURL:$('#website').val(),AccountHolderName:$('#accountHolder').val(),BankName:$('#bankName').val(),BankBranchAddress:$('#bankBranch').val(),AccountType:$('#accountType').val(),AccountNumber:$('#accountNumber').val(),MICRCode:$('#micr').val(),IFSCCode:$('#ifsc').val(),IsActive:$('#active').is(':checked')};AssetUI.post('VendorMaster.aspx/Save',{x:x},function(){clearForm();load();});}
function clearForm(){AssetUI.clear();$('#id').val('');$('#active').prop('checked',true);$('.erp-panel').first().removeClass('editing');}
$(function(){clearForm();load();});
</script>
<script src="asset-common.js"></script>
</asp:Content>
