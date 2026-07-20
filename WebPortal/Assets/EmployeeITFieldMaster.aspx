<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeITFieldMaster.aspx.cs" Inherits="WebPortal.Assets.EmployeeITFieldMaster" MasterPageFile="~/Assets/Admin.Master" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server"><link href="asset-common.css" rel="stylesheet" /></asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="asset-page"><div class="asset-hero"><h2>Employee IT Field Master</h2><small>Assets / Employee IT Field Master</small></div>
<div class="erp-panel"><div class="erp-panel-title">Field Definition</div><div class="erp-panel-body"><div class="row entry-form">
<input id="fieldId" type="hidden" />
<div class="col-md-4 form-group"><label class="required">Label (Header)</label><input id="label" class="form-control" maxlength="150" /></div>
<div class="col-md-3 form-group"><label class="required">Field Code</label><input id="code" class="form-control" maxlength="100" placeholder="Example: VPN_ACCESS" /></div>
<div class="col-md-2 form-group"><label class="required">Field Type</label><select id="type" class="form-control"><option value="Text">Text</option><option value="YesNo">Yes / No</option><option value="LongText">Long Text</option></select></div>
<div class="col-md-2 form-group"><label>Display Order</label><input id="order" type="number" class="form-control" value="100" /></div>
<div class="col-md-4 form-group"><label>Depends On Field</label><select id="dependsOn" class="form-control"><option value="">-- Always Show --</option></select><small class="text-muted">Only Yes / No fields can be selected.</small></div>
<div class="col-md-3 form-group"><label>Show When Value Is</label><select id="dependsValue" class="form-control" disabled><option value="">-- Select --</option><option value="Yes">Yes</option><option value="No">No</option></select></div>
<div class="col-md-1 form-group"><label>Required</label><input id="required" type="checkbox" class="form-control" /></div>
<div class="col-md-2 form-group"><label>Active</label><input id="active" type="checkbox" class="form-control" checked /></div>
</div><button class="btn btn-primary" onclick="saveField();return false;">Save Field</button> <button class="btn btn-secondary" onclick="clearField();return false;">Clear</button></div></div>
<div class="erp-panel"><div class="erp-panel-title">Configured Fields</div><div class="erp-panel-body"><table id="grid" class="table table-bordered table-sm"></table></div></div></div>
<script src="asset-common.js"></script><script>
var fieldRows=[];
function normalCode(v){return String(v||'').toUpperCase().replace(/[^A-Z0-9]+/g,'_').replace(/^_+|_+$/g,'');}
function bindDependencies(currentId){var selected=$('#dependsOn').val();$('#dependsOn').html('<option value="">-- Always Show --</option>');fieldRows.filter(function(r){return r.FieldType==='YesNo'&&r.IsActive&&+r.FieldID!==+(currentId||0);}).forEach(function(r){$('#dependsOn').append($('<option>').val(r.FieldCode).text(r.FieldLabel));});$('#dependsOn').val(selected);toggleDependency();}
function toggleDependency(){var enabled=!!$('#dependsOn').val();$('#dependsValue').prop('disabled',!enabled);if(!enabled)$('#dependsValue').val('');}
function load(){AssetUI.post('EmployeeITFieldMaster.aspx/List',{},function(r){fieldRows=r||[];bindDependencies(+$('#fieldId').val()||0);AssetUI.table('#grid',fieldRows,[{data:'FieldLabel',title:'Label'},{data:'FieldCode',title:'Code'},{data:'FieldType',title:'Type'},{data:'DependsOnFieldCode',title:'Depends On'},{data:'DependsOnValue',title:'Show When'},{data:'DisplayOrder',title:'Order'},{data:'IsRequired',title:'Required'},{data:'IsActive',title:'Active'}],[{text:'Edit',fn:'editField',id:'FieldID'}]);});}
function saveField(){if($('#dependsOn').val()&&!$('#dependsValue').val()){AssetUI.message('Select the dependency value.','error');return;}var x={FieldID:+$('#fieldId').val()||0,FieldLabel:$('#label').val(),FieldCode:normalCode($('#code').val()),FieldType:$('#type').val(),DisplayOrder:+$('#order').val()||100,IsRequired:$('#required').prop('checked'),IsActive:$('#active').prop('checked'),DependsOnFieldCode:$('#dependsOn').val()||null,DependsOnValue:$('#dependsValue').val()||null};AssetUI.post('EmployeeITFieldMaster.aspx/Save',{x:x},function(){clearField();load();});}
function editField(id){var x=fieldRows.find(function(r){return +r.FieldID===+id;});if(!x)return;$('#fieldId').val(x.FieldID);$('#label').val(x.FieldLabel);$('#code').val(x.FieldCode).prop('disabled',!!x.IsSystem);$('#type').val(x.FieldType).prop('disabled',!!x.IsSystem);$('#order').val(x.DisplayOrder);$('#required').prop('checked',x.IsRequired);$('#active').prop('checked',x.IsActive);bindDependencies(x.FieldID);$('#dependsOn').val(x.DependsOnFieldCode||'');$('#dependsValue').val(x.DependsOnValue||'');toggleDependency();window.scrollTo(0,0);}
function clearField(){AssetUI.clear('.entry-form');$('#fieldId').val('');$('#order').val(100);$('#active').prop('checked',true);$('#code,#type').prop('disabled',false);$('#type').val('Text');bindDependencies(0);}
$('#label').on('blur',function(){if(!$('#code').val())$('#code').val(normalCode(this.value));});$('#dependsOn').on('change',toggleDependency);$(load);
</script></asp:Content>
