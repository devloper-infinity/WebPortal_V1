<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="OrderAllocation.aspx.cs" Inherits="WebPortal.Vendor.OrderAllocation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedheader/3.4.0/css/fixedHeader.dataTables.min.css" />
<link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.3.0/css/fixedColumns.dataTables.min.css" />

<style type="text/css">
    .oa-page { padding: 18px 28px 30px; background: #f4f7fb; min-height: calc(100vh - 75px); }
    .erp-hero { position: relative; display: flex; align-items: center; min-height: 82px; margin-bottom: 18px; padding: 0 22px; overflow: hidden; border-radius: 16px; color: #fff; background: linear-gradient(90deg,#284b9b 0%,#267dec 58%,#37c4df 100%); box-shadow: 0 8px 22px rgba(30,71,143,.17); }
    .erp-hero:after { content:""; position:absolute; right:-35px; top:-75px; width:185px; height:185px; border-radius:50%; background:rgba(255,255,255,.08); }
    .erp-hero-icon { position:relative; z-index:1; margin-right:12px; font-size:24px; }
    .erp-hero h2 { margin:0; font-size:20px; font-weight:700; }
    .erp-hero p { margin:7px 0 0; font-size:12px; font-weight:600; opacity:.96; }
    .erp-panel { margin-bottom:18px; border:1px solid #dce4ee; border-radius:12px; background:#fff; box-shadow:0 4px 14px rgba(25,50,80,.05); overflow:hidden; }
    .erp-panel-title { padding:13px 16px; color:#203858; font-size:14px; font-weight:700; border-bottom:1px solid #e1e7ef; background:#fbfcfe; }
    .erp-panel-body { padding:17px 16px; }
    .oa-grid { display:grid; grid-template-columns:repeat(5,minmax(160px,1fr)); gap:14px; align-items:end; }
    .field label { display:block; margin-bottom:6px; color:#263b58; font-size:12px; font-weight:700; }
    .erp-control { width:100%; height:36px; padding:6px 10px; color:#25364e; border:1px solid #cbd6e3; border-radius:6px; background:#fff; outline:none; box-sizing:border-box; }
    .erp-control:focus { border-color:#2f80ed; box-shadow:0 0 0 3px rgba(47,128,237,.10); }
    .erp-btn { height:36px; padding:0 17px; border:0; border-radius:6px; font-size:12px; font-weight:700; cursor:pointer; }
    .erp-btn-primary { color:#fff; background:#2f80ed; }
    .erp-btn-light { color:#334b68; border:1px solid #cbd6e3; background:#fff; }
    .erp-btn:disabled { opacity:.55; cursor:not-allowed; }
    .count-chip { display:inline-flex; align-items:center; min-height:30px; padding:0 11px; border-radius:15px; color:#24548c; font-size:12px; font-weight:700; background:#eaf4ff; }
    .action-bar { display:flex; gap:9px; justify-content:flex-end; margin-top:15px; }
    .table-wrap { position:relative; padding:14px 15px 18px; }
    table.dataTable { width:100%!important; margin:0!important; border-collapse:separate!important; border-spacing:0; }
    table.dataTable thead th { padding:10px 11px!important; white-space:nowrap; color:#253c5b; font-size:11px; font-weight:700; border-top:1px solid #dfe6ef!important; border-bottom:1px solid #d3dde9!important; background:#f3f6fa!important; }
    table.dataTable tbody td { padding:8px 11px!important; white-space:nowrap; color:#27384f; font-size:11px; border-bottom:1px solid #edf1f5!important; }
    table.dataTable tbody tr:hover td { background:#f2f8ff!important; }
    .dataTables_wrapper .dataTables_filter { margin:0 0 10px; }
    .dataTables_wrapper .dataTables_filter input { width:190px; height:32px; margin-left:7px; padding:5px 12px; border:1px solid #cbd6e3; border-radius:16px; outline:none; }
    .dataTables_scrollHead, .dataTables_scrollBody { border-left:1px solid #dfe6ef; border-right:1px solid #dfe6ef; }
    .row-icon { width:28px; height:28px; display:inline-flex; align-items:center; justify-content:center; border:0; border-radius:5px; color:#fff; background:#2f80ed; cursor:pointer; }
    .row-icon:hover { background:#1f6fda; }
    .check-cell { text-align:center; }
    .check-cell input { width:15px; height:15px; cursor:pointer; }
    .empty-note { padding:18px; color:#6c7d91; text-align:center; }
    .toast-box { position:fixed; z-index:10002; right:24px; top:88px; min-width:310px; max-width:440px; display:none; padding:14px 17px; border-radius:8px; color:#fff; font-size:13px; font-weight:600; box-shadow:0 10px 30px rgba(0,0,0,.22); }
    .toast-success { background:#219653; }
    .toast-error { background:#d64545; }
    .loading-mask { position:fixed; z-index:10000; inset:0; display:none; align-items:center; justify-content:center; background:rgba(12,27,52,.50); }
    .loading-card { min-width:255px; padding:22px 28px; text-align:center; border-radius:12px; background:#fff; box-shadow:0 18px 55px rgba(0,0,0,.28); }
    .loading-card i { color:#2f80ed; font-size:31px; }
    .loading-text { margin-top:10px; color:#263b58; font-size:13px; font-weight:700; }
    @media(max-width:1100px){ .oa-grid{grid-template-columns:repeat(2,minmax(180px,1fr));} }
    @media(max-width:650px){ .oa-page{padding:12px;} .oa-grid{grid-template-columns:1fr;} }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="oa-page">
    <div class="erp-hero">
        <div class="erp-hero-icon"><i class="fa fa-tasks"></i></div>
        <div><h2>Order Allocation</h2><p>Select project, process and order date to allocate orders to the required user.</p></div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Allocation Criteria</div>
        <div class="erp-panel-body">
            <div class="oa-grid">
                <div class="field"><label>Project #</label><select id="drpProjectPM" class="erp-control"><option value="">Select</option></select></div>
                <div class="field"><label>Process</label><select id="drpProcess" class="erp-control"><option value="">Select</option></select></div>
                <div class="field"><label>Order Date</label><input id="txtDate" type="text" class="erp-control" readonly="readonly" placeholder="Select from summary below" /></div>
                <div class="field"><label>Allocate To</label><select id="ddlAllocateTo" class="erp-control"><option value="Vendor">Vendor</option><option value="Searcher">Searcher</option></select></div>
                <div class="field"><label>User / Vendor Code</label><select id="ddlAllocateToPerson" class="erp-control"><option value="">Select</option></select></div>
            </div>
            <div class="action-bar">
                <button type="button" id="btnClear" class="erp-btn erp-btn-light"><i class="fa fa-eraser"></i>&nbsp; Clear</button>
                <button type="button" id="btnPMAllocate" class="erp-btn erp-btn-primary"><i class="fa fa-share-square-o"></i>&nbsp; Allocate Selected</button>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Pending Order Summary</div>
        <div class="table-wrap"><table id="pendingTable" class="display nowrap" style="width:100%"><thead><tr><th>Action</th><th>Sr. #</th><th>Order Date</th><th>Process Name</th><th>Product Type</th><th>Count</th></tr></thead><tbody></tbody></table></div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-title">Orders Available for Allocation &nbsp; <span id="orderCount" class="count-chip">Order Count: 0</span></div>
        <div class="table-wrap"><table id="orderTable" class="display nowrap" style="width:100%"><thead><tr><th class="check-cell"><input type="checkbox" id="chkAll" title="Select all" /></th><th>Sr. #</th><th>Order Date</th><th>Order Number</th><th>Count</th></tr></thead><tbody></tbody></table></div>
    </div>
</div>

<div id="toastBox" class="toast-box"></div>
<div id="loadingMask" class="loading-mask"><div class="loading-card"><i class="fa fa-spinner fa-spin"></i><div id="loadingText" class="loading-text">Please wait...</div></div></div>

<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/fixedheader/3.4.0/js/dataTables.fixedHeader.min.js"></script>
<script src="https://cdn.datatables.net/fixedcolumns/4.3.0/js/dataTables.fixedColumns.min.js"></script>
<script type="text/javascript">
    var pendingData = [], orderData = [], pendingDt = null, orderDt = null;

    $(function () {
        bindEvents();
        loadInitialData();
    });

    function bindEvents() {
        $('#drpProjectPM').on('change', function () {
            $('#txtDate').val('');
            bindProcesses();
            loadPendingOrders();
            bindOrders([]);
        });
        $('#drpProcess').on('change', function () { $('#txtDate').val(''); loadPendingOrders(); bindOrders([]); });
        $('#ddlAllocateTo').on('change', loadUsers);
        $('#btnPMAllocate').on('click', allocateSelected);
        $('#btnClear').on('click', clearPage);
        $('#chkAll').on('change', function(){ $('.order-check').prop('checked', this.checked); });
    }

    function ajax(method, data, loadingMessage) {
        showLoading(loadingMessage || 'Please wait...');
        return $.ajax({
            type:'POST', url:'OrderAllocation.aspx/' + method,
            data:JSON.stringify(data || {}), contentType:'application/json; charset=utf-8', dataType:'json'
        }).always(hideLoading);
    }

    function loadInitialData() {
        ajax('GetInitialData', {}, 'Loading allocation details...').done(function(r){
            var x = r.d || {};
            fillSelect('#drpProjectPM', x.Projects || [], 'Select');
            fillSelect('#ddlAllocateToPerson', x.Users || [], 'Select');
        }).fail(showAjaxError);
    }

    function bindProcesses() {
        var id = $('#drpProjectPM').val(), list = [];
        if (id === '227') list = [{Value:'DE1',Text:'DE1'},{Value:'DE2',Text:'DE2'}];
        else if (id) list = [{Value:'PQA',Text:'PQA'}];
        fillSelect('#drpProcess', list, 'Select');
    }

    function loadUsers() {
        ajax('GetUsers', { userType:$('#ddlAllocateTo').val() }, 'Loading users...').done(function(r){ fillSelect('#ddlAllocateToPerson', r.d || [], 'Select'); }).fail(showAjaxError);
    }

    function loadPendingOrders() {
        var p = selectedProject();
        if (!p || !$('#drpProcess').val()) { bindPending([]); return; }
        ajax('GetPendingOrders', { projectName:p.Text }, 'Loading pending order summary...').done(function(r){ bindPending(r.d || []); }).fail(showAjaxError);
    }

    function selectPending(index) {
        var row = pendingData[index];
        if (!row) return;
        $('#txtDate').val(valueOf(row,['Orderdate','OrderDate']));
        loadOrders();
    }

    function loadOrders() {
        var p = selectedProject(), process = $('#drpProcess').val(), date = $('#txtDate').val();
        if (!p || !process || !date) { bindOrders([]); return; }
        ajax('GetOrders', { projectId:parseInt(p.Value,10), projectName:p.Text, process:process, orderDate:date }, 'Loading orders...').done(function(r){ bindOrders(r.d || []); }).fail(showAjaxError);
    }

    function allocateSelected() {
        var selected = [];
        $('.order-check:checked').each(function(){ var i=parseInt($(this).attr('data-index'),10); if(orderData[i]) selected.push({ OrderNo:valueOf(orderData[i],['OrderNo']), OrderDate:valueOf(orderData[i],['orderdate','OrderDate']) }); });
        var p = selectedProject(), userText = $('#ddlAllocateToPerson option:selected').text();
        if (!p) return showMessage('Please select Project.','error');
        if (!$('#drpProcess').val()) return showMessage('Please select Process.','error');
        if (!$('#txtDate').val()) return showMessage('Please select an Order Date from Pending Order Summary.','error');
        if (!$('#ddlAllocateToPerson').val()) return showMessage('Please select Vendor/User Code.','error');
        if (!selected.length) return showMessage('Please select at least one order.','error');
        $('#btnPMAllocate').prop('disabled',true);
        ajax('AllocateOrders', { request:{ ProjectId:parseInt(p.Value,10), ProjectName:p.Text, Process:$('#drpProcess').val(), VendorDisplay:userText, Orders:selected } }, 'Allocating selected orders...')
            .done(function(r){ var x=r.d||{}; showMessage(x.Message || (x.Success?'Orders allocated successfully.':'Unable to allocate orders.'), x.Success?'success':'error'); if(x.Success){ loadOrders(); loadPendingOrders(); } })
            .fail(showAjaxError).always(function(){ $('#btnPMAllocate').prop('disabled',false); });
    }

    function bindPending(rows) {
        pendingData = rows;
        if (pendingDt) pendingDt.destroy();
        var body=$('#pendingTable tbody').empty();
        $.each(rows,function(i,row){ body.append('<tr><td><button type="button" class="row-icon" title="Select date" onclick="selectPending('+i+')"><i class="fa fa-arrow-right"></i></button></td><td>'+(i+1)+'</td><td>'+esc(valueOf(row,['Orderdate','OrderDate']))+'</td><td>'+esc(valueOf(row,['ProcessName']))+'</td><td>'+esc(valueOf(row,['JobTypeName','ProductType']))+'</td><td>'+esc(valueOf(row,['NoOfRecords','Count']))+'</td></tr>'); });
        pendingDt=$('#pendingTable').DataTable(dtOptions('45vh',1));
    }

    function bindOrders(rows) {
        orderData = rows; $('#chkAll').prop('checked',false); $('#orderCount').text('Order Count: '+rows.length);
        if (orderDt) orderDt.destroy();
        var body=$('#orderTable tbody').empty();
        $.each(rows,function(i,row){ body.append('<tr><td class="check-cell"><input type="checkbox" class="order-check" data-index="'+i+'" /></td><td>'+(i+1)+'</td><td>'+esc(valueOf(row,['orderdate','OrderDate']))+'</td><td>'+esc(valueOf(row,['OrderNo']))+'</td><td>'+esc(valueOf(row,['NoOfRecords','Count']))+'</td></tr>'); });
        orderDt=$('#orderTable').DataTable(dtOptions('52vh',2));
    }

    function dtOptions(height,fixedCols){ return {destroy:true,paging:false,searching:true,ordering:true,info:false,scrollX:true,scrollY:height,scrollCollapse:true,autoWidth:false,fixedHeader:true,fixedColumns:{leftColumns:fixedCols},language:{search:'Search:',emptyTable:'No records found'}}; }
    function fillSelect(sel,rows,placeholder){ var s=$(sel).empty().append($('<option/>').val('').text(placeholder)); $.each(rows,function(_,x){s.append($('<option/>').val(x.Value).text(x.Text));}); }
    function selectedProject(){ var o=$('#drpProjectPM option:selected'); return o.val()?{Value:o.val(),Text:o.text()}:null; }
    function valueOf(o,names){ for(var i=0;i<names.length;i++) if(o && o[names[i]]!==undefined && o[names[i]]!==null) return o[names[i]]; return ''; }
    function esc(v){ return $('<div/>').text(v==null?'':v).html(); }
    function showLoading(t){ $('#loadingText').text(t||'Please wait...'); $('#loadingMask').css('display','flex'); }
    function hideLoading(){ $('#loadingMask').hide(); }
    function showMessage(m,type){ var b=$('#toastBox').removeClass('toast-success toast-error').addClass(type==='success'?'toast-success':'toast-error').html('<i class="fa '+(type==='success'?'fa-check-circle':'fa-exclamation-circle')+'"></i>&nbsp; '+esc(m)).stop(true,true).fadeIn(180); setTimeout(function(){b.fadeOut(250);},4500); }
    function showAjaxError(xhr){ var m='Unexpected error occurred.'; try{m=xhr.responseJSON.Message||xhr.responseJSON.d||m;}catch(e){} showMessage(m,'error'); }
    function clearPage(){ $('#drpProjectPM,#drpProcess,#txtDate,#ddlAllocateToPerson').val(''); bindProcesses(); bindPending([]); bindOrders([]); }
</script>
</asp:Content>
