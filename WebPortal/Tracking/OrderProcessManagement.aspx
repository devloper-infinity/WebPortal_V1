<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderProcessManagement.aspx.cs" Inherits="WebPortal.OrderProcessManagement" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Order Process Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Replace CDN references with your ERP local references when deploying. -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <style>
        body{background:#f3f6fa;font-family:"Segoe UI",Arial,sans-serif;color:#29384a}.page-content{padding:16px 20px 28px}.page-hero{background:linear-gradient(135deg,#355d8a,#527ba8);border-radius:8px;padding:17px 22px;color:#fff;box-shadow:0 3px 12px rgba(36,69,105,.18);margin-bottom:15px}.page-hero h3{font-size:22px;font-weight:600;margin:0 0 3px}.breadcrumb-line{font-size:12px;opacity:.9}.erp-card{background:#fff;border:1px solid #dfe6ee;border-radius:7px;box-shadow:0 2px 8px rgba(30,55,80,.07);margin-bottom:15px}.erp-card-body{padding:18px}.nav-tabs{border-bottom:1px solid #dce4ed;padding:0 15px;background:#f8fafc;border-radius:7px 7px 0 0}.nav-tabs .nav-link{border:0;border-bottom:3px solid transparent;color:#536579;font-weight:600;padding:14px 18px}.nav-tabs .nav-link.active{color:#315f91;background:transparent;border-bottom-color:#315f91}.filter-panel{background:#f8fafc;border:1px solid #e2e8ef;border-radius:6px;padding:14px 14px 4px;margin-bottom:14px}label{font-size:12px;font-weight:600;color:#46596d;margin-bottom:5px}.form-control{height:36px;border-color:#ccd6e1;font-size:13px}.btn{font-size:13px;font-weight:600;border-radius:4px;padding:7px 16px}.btn-erp{background:#315f91;border-color:#315f91;color:#fff}.btn-erp:hover{background:#284f79;color:#fff}.btn-clear{background:#fff;border:1px solid #b8c4d0;color:#536579}.grid-title{display:flex;justify-content:space-between;align-items:center;margin:17px 0 9px}.grid-title h5{font-size:15px;font-weight:600;margin:0}.table-wrap{position:relative;border:1px solid #dde5ed;border-radius:5px;background:#fff;padding:8px}.grid-loader{display:none;position:absolute;inset:0;background:rgba(255,255,255,.76);z-index:20;align-items:center;justify-content:center}.grid-loader.show{display:flex}table.dataTable thead th{background:#eaf0f6;color:#344b63;border-bottom:1px solid #ccd7e2;font-size:12px}table.dataTable tbody td{font-size:12px;vertical-align:middle}.action-btn{margin:1px 3px 1px 0}.status-badge{padding:4px 8px;border-radius:10px;background:#eef3f8;font-weight:600}.mandatory-note{font-size:12px;color:#6b7c8f;margin-top:7px}@media(max-width:768px){.page-content{padding:10px}.nav-tabs .nav-link{padding:11px 9px;font-size:12px}}
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="page-content">
    <div class="page-hero"><h3>Order Process Management</h3><div class="breadcrumb-line">Home / Operations / Order Process Management</div></div>
    <div class="erp-card">
        <ul class="nav nav-tabs" id="mainTabs">
            <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#tabAllocation">Order Allocation</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tabStatus">Update Loan Status</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#tabReport">My Order Report</a></li>
        </ul>
        <div class="tab-content erp-card-body">
            <div class="tab-pane fade show active" id="tabAllocation">
                <div class="filter-panel"><div class="form-row">
                    <div class="form-group col-md-4"><label>Project</label><select id="ddlAllocationProject" class="form-control"></select></div>
                    <div class="form-group col-md-4"><label>Process</label><select id="ddlAllocationProcess" class="form-control"></select></div>
                    <div class="form-group col-md-4"><label>Loan Number</label><input id="txtAllocationLoan" class="form-control" placeholder="Search by loan number" /></div>
                </div></div>
                <button type="button" id="btnLoadAllocation" class="btn btn-erp">Search Loans</button>
                <button type="button" id="btnTakeOrders" class="btn btn-success">Take Selected Loans</button>
                <button type="button" id="btnClearAllocation" class="btn btn-clear">Clear</button>
                <div class="mandatory-note">Optional earlier processes can be skipped. All earlier mandatory processes must be completed.</div>
                <div class="grid-title"><h5>Available Loans</h5><span id="allocationCount" class="text-muted small"></span></div>
                <div class="table-wrap"><div id="allocationLoader" class="grid-loader"><div class="spinner-border text-primary"></div></div>
                    <table id="tblAllocation" class="display nowrap" style="width:100%"><thead><tr><th><input type="checkbox" id="chkAll" /></th><th>Order ID</th><th>Deal No</th><th>Loan No</th><th>Order Date</th><th>Status</th></tr></thead><tbody></tbody></table>
                </div>
            </div>
            <div class="tab-pane fade" id="tabStatus">
                <div class="filter-panel"><div class="form-row">
                    <div class="form-group col-md-3"><label>Project</label><select id="ddlMyProject" class="form-control"></select></div>
                    <div class="form-group col-md-3"><label>Process</label><select id="ddlMyProcess" class="form-control"></select></div>
                    <div class="form-group col-md-3"><label>Status</label><select id="ddlMyStatus" class="form-control"><option value="">All</option><option>Allocated</option><option>InProgress</option><option>OnHold</option></select></div>
                    <div class="form-group col-md-3"><label>Loan Number</label><input id="txtMyLoan" class="form-control" /></div>
                </div></div>
                <button type="button" id="btnLoadMyOrders" class="btn btn-erp">Search</button><button type="button" id="btnClearMy" class="btn btn-clear">Clear</button>
                <div class="grid-title"><h5>My Current Loans</h5></div>
                <div class="table-wrap"><div id="myLoader" class="grid-loader"><div class="spinner-border text-primary"></div></div>
                    <table id="tblMyOrders" class="display nowrap" style="width:100%"><thead><tr><th>Order ID</th><th>Deal No</th><th>Loan No</th><th>Project</th><th>Process</th><th>Allocated</th><th>Started</th><th>Status</th><th>Remarks</th><th>Action</th></tr></thead><tbody></tbody></table>
                </div>
            </div>
            <div class="tab-pane fade" id="tabReport">
                <div class="filter-panel"><div class="form-row">
                    <div class="form-group col-md-2"><label>From Date</label><input id="txtFromDate" type="date" class="form-control" /></div><div class="form-group col-md-2"><label>To Date</label><input id="txtToDate" type="date" class="form-control" /></div>
                    <div class="form-group col-md-2"><label>Project</label><select id="ddlReportProject" class="form-control"></select></div><div class="form-group col-md-2"><label>Process</label><select id="ddlReportProcess" class="form-control"></select></div>
                    <div class="form-group col-md-2"><label>Status</label><select id="ddlReportStatus" class="form-control"><option>All</option><option>Allocated</option><option>InProgress</option><option>Completed</option><option>OnHold</option></select></div><div class="form-group col-md-2"><label>Loan No</label><input id="txtReportLoan" class="form-control" /></div>
                </div></div>
                <button type="button" id="btnLoadReport" class="btn btn-erp">Search</button><button type="button" id="btnClearReport" class="btn btn-clear">Clear</button>
                <div class="grid-title"><h5>My Order Report</h5></div>
                <div class="table-wrap"><div id="reportLoader" class="grid-loader"><div class="spinner-border text-primary"></div></div>
                    <table id="tblReport" class="display nowrap" style="width:100%"><thead><tr><th>Order ID</th><th>Deal No</th><th>Loan No</th><th>Order Date</th><th>Project</th><th>Process</th><th>Sequence</th><th>Status</th><th>Allocated</th><th>Started</th><th>Completed</th><th>TAT</th><th>Remarks</th></tr></thead><tbody></tbody></table>
                </div>
            </div>
        </div>
    </div>
</div>
</form>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script><script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script><script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script>
var allocationTable,myTable,reportTable;
$(function(){initTables();setDefaultDates();loadProjects();
$('#ddlAllocationProject').change(function(){loadProcesses(this.value,'#ddlAllocationProcess');});$('#ddlMyProject').change(function(){loadProcesses(this.value,'#ddlMyProcess');});$('#ddlReportProject').change(function(){loadProcesses(this.value,'#ddlReportProcess');});
$('#btnLoadAllocation').click(loadAllocationOrders);$('#btnTakeOrders').click(takeSelected);$('#btnLoadMyOrders').click(loadMyOrders);$('#btnLoadReport').click(loadReport);$('#chkAll').change(function(){$('.row-check').prop('checked',this.checked);});
$('#btnClearAllocation').click(function(){$('#ddlAllocationProject,#ddlAllocationProcess').val('');$('#txtAllocationLoan').val('');allocationTable.clear().draw();});$('#btnClearMy').click(function(){$('#ddlMyProject,#ddlMyProcess,#ddlMyStatus').val('');$('#txtMyLoan').val('');myTable.clear().draw();});$('#btnClearReport').click(function(){$('#ddlReportProject,#ddlReportProcess').val('');$('#ddlReportStatus').val('All');$('#txtReportLoan').val('');setDefaultDates();reportTable.clear().draw();});
$('a[data-toggle="tab"]').on('shown.bs.tab',function(){setTimeout(function(){$.fn.dataTable.tables({visible:true,api:true}).columns.adjust();},100);});});
function initTables(){var o={paging:false,scrollX:true,autoWidth:false,ordering:true,info:true,searching:false,destroy:true};allocationTable=$('#tblAllocation').DataTable(o);myTable=$('#tblMyOrders').DataTable(o);reportTable=$('#tblReport').DataTable(o);}
function call(method,payload,success,complete){$.ajax({url:'OrderProcessManagement.aspx/'+method,type:'POST',data:JSON.stringify(payload||{}),contentType:'application/json; charset=utf-8',dataType:'json',success:function(r){success(r.d);},error:function(x){alert((x.responseJSON&&x.responseJSON.Message)||'Request failed.');},complete:complete});}
function loadProjects(){call('GetProjects',{},function(rows){var h='<option value="">-- Select Project --</option>';$.each(rows,function(_,r){h+='<option value="'+r.ProjectID+'">'+esc(r.ProjectName)+'</option>';});$('#ddlAllocationProject,#ddlMyProject,#ddlReportProject').html(h);});}
function loadProcesses(projectId,target){$(target).html('<option value="">-- Select Process --</option>');if(!projectId)return;call('GetProcesses',{projectID:parseInt(projectId,10)},function(rows){var h='<option value="">-- Select Process --</option>';$.each(rows,function(_,r){h+='<option value="'+r.ProcessID+'">'+r.SequenceNo+'. '+esc(r.ProcessName)+(r.IsMandatory?'':' (Optional)')+'</option>';});$(target).html(h);});}
function loadAllocationOrders(){var p=$('#ddlAllocationProject').val(),pr=$('#ddlAllocationProcess').val();if(!p||!pr){alert('Select Project and Process.');return;}$('#allocationLoader').addClass('show');call('GetOrdersForAllocation',{projectID:parseInt(p,10),processID:parseInt(pr,10),loanSearch:$('#txtAllocationLoan').val()},function(rows){allocationTable.clear();$.each(rows,function(_,r){allocationTable.row.add(['<input type="checkbox" class="row-check" value="'+r.OrderID+'" />',r.OrderID,esc(r.DealNo),esc(r.LoanNo),fmt(r.OrderDate),'<span class="status-badge">'+esc(r.WorkflowStatus)+'</span>']);});allocationTable.draw();$('#allocationCount').text(rows.length+' loan(s)');$('#chkAll').prop('checked',false);},function(){$('#allocationLoader').removeClass('show');});}
function takeSelected(){var ids=$('.row-check:checked').map(function(){return this.value;}).get().join(',');if(!ids){alert('Select at least one loan.');return;}if(!confirm('Add selected loans to your work queue?'))return;call('TakeOrders',{orderIDs:ids,projectID:parseInt($('#ddlAllocationProject').val(),10),processID:parseInt($('#ddlAllocationProcess').val(),10)},function(r){alert(r.Message);if(r.IsSuccess){loadAllocationOrders();loadMyOrders();}});}
function loadMyOrders(){$('#myLoader').addClass('show');call('GetMyOrders',{projectID:nullable($('#ddlMyProject').val()),processID:nullable($('#ddlMyProcess').val()),status:$('#ddlMyStatus').val(),loanSearch:$('#txtMyLoan').val()},function(rows){myTable.clear();$.each(rows,function(_,r){var a='<button class="btn btn-sm btn-primary action-btn" onclick="startOrder('+r.OrderID+','+r.ProcessID+')">Start</button><button class="btn btn-sm btn-warning action-btn" onclick="holdOrder('+r.OrderID+','+r.ProcessID+')">Hold</button><button class="btn btn-sm btn-success action-btn" onclick="completeOrder('+r.OrderID+','+r.ProcessID+')">Complete</button>';myTable.row.add([r.OrderID,esc(r.DealNo),esc(r.LoanNo),esc(r.ProjectName),esc(r.ProcessName),fmt(r.AllocatedDate),fmt(r.StartedDate),'<span class="status-badge">'+esc(r.ProcessStatus)+'</span>',esc(r.Remarks),a]);});myTable.draw();},function(){$('#myLoader').removeClass('show');});}
function startOrder(o,p){call('StartOrder',{orderID:o,processID:p},function(r){alert(r.Message);if(r.IsSuccess)loadMyOrders();});}function holdOrder(o,p){var x=prompt('Enter hold reason:');if(x===null)return;call('HoldOrder',{orderID:o,processID:p,remarks:x},function(r){alert(r.Message);if(r.IsSuccess)loadMyOrders();});}function completeOrder(o,p){var x=prompt('Enter completion remarks:')||'';if(!confirm('Complete this loan for the selected process?'))return;call('CompleteOrder',{orderID:o,processID:p,remarks:x},function(r){alert(r.Message);if(r.IsSuccess)loadMyOrders();});}
function loadReport(){$('#reportLoader').addClass('show');call('GetReport',{fromDate:$('#txtFromDate').val(),toDate:$('#txtToDate').val(),projectID:nullable($('#ddlReportProject').val()),processID:nullable($('#ddlReportProcess').val()),status:$('#ddlReportStatus').val(),loanNo:$('#txtReportLoan').val()},function(rows){reportTable.clear();$.each(rows,function(_,r){reportTable.row.add([r.OrderID,esc(r.DealNo),esc(r.LoanNo),fmt(r.OrderDate),esc(r.ProjectName),esc(r.ProcessName),r.SequenceNo,'<span class="status-badge">'+esc(r.ProcessStatus)+'</span>',fmt(r.AllocatedDate),fmt(r.StartedDate),fmt(r.CompletedDate),esc(r.TurnaroundTime),esc(r.Remarks)]);});reportTable.draw();},function(){$('#reportLoader').removeClass('show');});}
function setDefaultDates(){var d=new Date(),f=new Date(d.getFullYear(),d.getMonth(),1);$('#txtFromDate').val(f.toISOString().slice(0,10));$('#txtToDate').val(d.toISOString().slice(0,10));}function nullable(v){return v?parseInt(v,10):null;}function fmt(v){if(!v)return'';var d=new Date(v);return isNaN(d)?v:d.toLocaleString();}function esc(v){return $('<div/>').text(v==null?'':v).html();}
</script></body></html>