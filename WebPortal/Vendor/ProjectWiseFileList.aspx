<%@ Page Title="" Language="C#" MasterPageFile="~/Vendor/VendorMaster.Master" AutoEventWireup="true" CodeBehind="ProjectWiseFileList.aspx.cs" Inherits="WebPortal.Vendor.ProjectWiseFileList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
     .erp-page { padding: 16px 20px 24px; background:#f4f7fb; min-height:calc(100vh - 110px); }
     .erp-hero { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; margin-bottom:14px; border-radius:7px; background:linear-gradient(135deg,#123f70,#276da8); color:#fff; }
     .erp-hero h2 { margin:0; font-size:21px; font-weight:600; }
     .erp-hero .crumb { margin-top:4px; font-size:12px; opacity:.9; }
     .erp-panel { background:#fff; border:1px solid #dce5ef; border-radius:7px; margin-bottom:14px; overflow:hidden; }
     .erp-panel-head { display:flex; align-items:center; justify-content:space-between; padding:13px 18px; border-bottom:1px solid #e2e8f0; background:#f8fafc; }
     .erp-panel-head h3 { margin:0; font-size:17px; color:#14263d; }
     .erp-panel-body { padding:14px 18px; }
     .erp-summary-bar { display:flex; flex-wrap:wrap; align-items:center; gap:0; padding:10px 14px; background:#fff; border:1px solid #dce5ef; border-radius:7px; margin-bottom:14px; }
     .summary-item { display:flex; align-items:center; gap:6px; padding:5px 16px; border-right:1px solid #e2e8f0; min-height:30px; }
     .summary-item:first-child { padding-left:4px; }
     .summary-item:last-child { border-right:0; }
     .summary-label { font-size:12px; color:#64748b; white-space:nowrap; }
     .summary-value { font-size:15px; font-weight:700; color:#102a49; white-space:nowrap; }
     .status-badge { display:inline-block; padding:3px 10px; border-radius:14px; font-size:12px; font-weight:700; }
     .status-pending { background:#fff1c2; color:#8a5a00; }
     .status-completed { background:#d9f4e3; color:#17653a; }
     .status-inprocess { background:#dceeff; color:#145483; }
     .toolbar { display:flex; flex-wrap:wrap; align-items:end; gap:14px; }
     .field-group label { display:block; margin-bottom:5px; color:#334155; font-size:13px; font-weight:600; }
     .radio-line { display:flex; gap:18px; align-items:center; min-height:38px; }
     .radio-line label { font-weight:500; margin:0; cursor:pointer; }
     .count-pill { display:inline-block; min-width:28px; padding:2px 8px; margin-left:4px; text-align:center; background:#e9f2fb; color:#15588d; border-radius:12px; font-size:12px; font-weight:700; }
     .erp-btn { border:0; border-radius:5px; padding:9px 16px; font-size:13px; font-weight:600; cursor:pointer; }
     .erp-btn-primary { background:#1f6fae; color:#fff; }
     .erp-btn-light { background:#e7edf4; color:#21364d; }
     .erp-btn-success { background:#198754; color:#fff; }
     .erp-btn:disabled { opacity:.55; cursor:not-allowed; }
     .grid-wrap { position:relative; overflow:hidden; }
     .grid-loader { position:absolute; inset:0; z-index:10; display:none; align-items:center; justify-content:center; background:rgba(255,255,255,.78); font-weight:600; color:#1f5e91; }
     table.dataTable { width:100%!important; border-collapse:collapse!important; }
     table.dataTable thead th { white-space:nowrap; background:#e8f1f8; color:#163d61; border:1px solid #cad8e5!important; font-size:12px; font-weight:700; padding:10px 9px!important; }
     table.dataTable tbody td { white-space:nowrap; border:1px solid #e0e7ef!important; color:#334155; font-size:12px; padding:8px 9px!important; }
     table.dataTable tbody tr:nth-child(even) { background:#f8fafc; }
     table.dataTable tbody tr:hover { background:#eef6fc; }
     .dataTables_wrapper .dataTables_filter { margin-bottom:10px; }
     .dataTables_wrapper .dataTables_filter input { border:1px solid #cbd7e3; border-radius:5px; padding:7px 9px; outline:none; }
     .select-cell { text-align:center; }
     .message { display:none; margin-bottom:12px; padding:10px 12px; border-radius:5px; font-size:13px; }
     .message.success { display:block; background:#dff3e7; color:#185c37; }
     .message.error { display:block; background:#fde5e7; color:#8b1e2b; }
     @media(max-width:900px){ .summary-item { border-right:0; border-bottom:1px solid #edf1f5; width:50%; } }
 </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="erp-page">
    <div class="erp-hero">
        <div><h2>Project Wise File List</h2><div class="crumb">Vendor Billing / Project Wise Summary / File List</div></div>
        <button type="button" id="btnBack" class="erp-btn erp-btn-light">Back</button>
    </div>

    <div id="message" class="message"></div>

    <div class="erp-summary-bar">
        <div class="summary-item"><span class="summary-label">Vendor</span><strong id="sumVendor" class="summary-value">-</strong></div>
        <div class="summary-item"><span class="summary-label">Project</span><strong id="sumProject" class="summary-value">-</strong></div>
        <div class="summary-item"><span class="summary-label">Total Files</span><strong id="sumTotal" class="summary-value">0</strong></div>
        <div class="summary-item"><span class="summary-label">Completed</span><strong id="sumCompleted" class="summary-value">0</strong></div>
        <div class="summary-item"><span class="summary-label">Pending</span><strong id="sumPending" class="summary-value">0</strong></div>
        <div class="summary-item"><span class="summary-label">Calculated Cost</span><strong id="sumCost" class="summary-value">0.00</strong></div>
        <div class="summary-item"><span class="summary-label">Billed</span><strong id="sumBilled" class="summary-value">0</strong></div>
        <div class="summary-item"><span class="summary-label">Unbilled</span><strong id="sumUnbilled" class="summary-value">0</strong></div>
        <div class="summary-item"><span class="summary-label">Status</span><span id="sumStatus" class="status-badge status-pending">-</span></div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-head"><h3>File Verification</h3></div>
        <div class="erp-panel-body">
            <div class="toolbar">
                <div class="field-group"><label>File Type</label><div class="radio-line">
                    <label><input type="radio" name="fileType" value="Verify" /> Verified <span id="verifyCount" class="count-pill">0</span></label>
                    <label><input type="radio" name="fileType" value="UnVerify" checked /> Unverified <span id="unverifyCount" class="count-pill">0</span></label>
                </div></div>
                <div class="field-group" id="statusGroup"><label>Action Status</label><div class="radio-line">
                    <label><input type="radio" name="actionStatus" value="Complete" checked /> Verify selected</label>
                    <label><input type="radio" name="actionStatus" value="InProcess" /> Complete project</label>
                </div></div>
                <button type="button" id="btnAction" class="erp-btn erp-btn-primary">Verify Selected</button>
                <button type="button" id="btnExport" class="erp-btn erp-btn-light">Export to Excel</button>
                <button type="button" id="btnPayment" class="erp-btn erp-btn-success">Send to Payment</button>
            </div>
        </div>
    </div>

    <div class="erp-panel">
        <div class="erp-panel-head"><h3>Files | Total Count: <span id="totalCount">0</span></h3></div>
        <div class="erp-panel-body grid-wrap">
            <div id="gridLoader" class="grid-loader">Loading...</div>
            <table id="fileTable" class="display nowrap" style="width:100%">
                <thead><tr>
                    <th><input type="checkbox" id="selectAll" /></th><th>Sr. #</th><th>Order Date</th><th>Process Type</th><th>Work Content No.</th><th>File Name</th><th>Compare Date</th><th>Total Chars</th><th>Chars After Penalty</th><th>Accuracy</th><th>Records</th><th>ISP</th><th>MRW</th><th>MRL</th><th>MRP</th><th>MRD</th><th>MRT</th><th>Added By</th><th>Rate</th><th>Record Wise Rate</th><th>Per Error Wise</th><th>Per Penalty Wise</th><th>Total Amount</th><th>100% Amount</th><th>Vendor Remark</th><th>Infinity Remark</th><th>Shift</th><th>Rate Remark</th><th>Error In Records</th><th>Job Type</th>
                </tr></thead><tbody></tbody>
            </table>
        </div>
    </div>
</div>

<script src="../bootstrap/js/jquery.dataTables.min.js"></script>
<script>
(function(){
    var pageUrl = '<%= ResolveUrl("~/Vendor/ProjectWiseFileList.aspx") %>';
    var qs = new URLSearchParams(window.location.search);
    var context = {
        vendorCode: qs.get('VendorCode') || '', invoiceId: parseInt(qs.get('InvoiceId') || '0',10), projectNumber: qs.get('ProjectNumber') || '',
        verifiedFiles: parseInt(qs.get('VerifiedFiles') || '0',10), unverifiedFiles: parseInt(qs.get('UnVerifiedFiles') || '0',10), status: qs.get('Status') || ''
    };
    var table;
    var columns = ['OrderDate','ProcessType','WorkContentNo','FileName','CompareDate','TotalChars','CharsAfterPenalty','Accuracy','Records','ISP','MRW','MRL','MRP','MRD','MRT','AddedBy','Rate','RecordWiseRate','PerErrorWise','PerPenaltyWise','Total','AccuracyAmt','RemarkVendor','RemarkInhouse','Shift','RateRemark','ErrorInRecords','JobType'];
    function formatAmount(value) {

        value = parseFloat(value || 0);

        return value.toLocaleString('en-IN', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }
    $(function(){
        table = $('#fileTable').DataTable({ paging:false, searching:true, ordering:true, info:false, scrollX:true, scrollY:'55vh', scrollCollapse:true, autoWidth:false, order:[] });
        loadCounts(); loadFiles('UnVerify');
        $('input[name=fileType]').on('change', function(){ var t=this.value; $('#statusGroup,#btnAction').toggle(t==='UnVerify'); $('#selectAll').prop('checked',false); loadFiles(t); });
        $('input[name=actionStatus]').on('change', function(){ $('#btnAction').text(this.value==='InProcess'?'Complete Project':'Verify Selected'); });
        $('#selectAll').on('change', function(){ $('.row-check').prop('checked',this.checked); });
        $('#btnBack').on('click', goBack);
        $('#btnExport').on('click', function(){ table.button && table.button('.buttons-excel').trigger(); exportCsv(); });
        $('#btnPayment').on('click', function(){ showMessage('Send to Payment requires the corresponding existing database method.',false); });
        $('#btnAction').on('click', executeAction);
    });

    function bindSummary(data) {

        data = data || {};

        $('#sumVendor').text(data.VendorCode || context.vendorCode);
        $('#sumProject').text(data.ProjectNumber || context.projectNumber);

        $('#sumTotal').text(data.TotalFiles || 0);
        $('#sumCompleted').text(data.CompletedFiles || 0);
        $('#sumPending').text(data.PendingFiles || 0);

        $('#sumCost').text(formatAmount(data.CalculatedCost || 0));

        $('#sumBilled').text(data.BilledFiles || 0);
        $('#sumUnbilled').text(data.UnBilledFiles || 0);

        $('#sumStatus')
            .text(data.Status || '-')
            .attr('class', 'status-badge ' + statusClass(data.Status));
    }
    function loadCounts() {

        call('GetCounts', {
            vendorCode: context.vendorCode,
            invoiceId: context.invoiceId,
            projectNumber: context.projectNumber
        }).done(function (r) {

            var x = unwrap(r);

            if (!x.Success) {
                showMessage(x.Message, false);
                return;
            }

            bindSummary(x.Data);

            $('#verifyCount').text(x.Data.VerifyCount || 0);
            $('#unverifyCount').text(x.Data.UnVerifyCount || 0);

        }).fail(ajaxFail);
    }
    function loadFiles(type) { showLoader(true); call('GetFiles', { vendorCode: context.vendorCode, invoiceId: context.invoiceId, projectNumber: context.projectNumber, fileType: type }).done(function (r) { var x = unwrap(r); if (!x.Success) { showMessage(x.Message, false); return; } bindRows(x.Data || []); }).fail(ajaxFail).always(function () { showLoader(false); }); }

    function bindRows(rows){ table.clear(); $.each(rows,function(i,row){ var cells=['<input type="checkbox" class="row-check" value="'+html(val(row,'InvoiceDetailID'))+'" />',i+1]; $.each(columns,function(_,c){ var v=val(row,c); if(c==='OrderDate'||c==='CompareDate') v=formatDotNetDate(v); cells.push(html(v)); }); table.row.add(cells); }); table.draw(false); $('#totalCount').text(rows.length); }
    function executeAction(){
        var action=$('input[name=actionStatus]:checked').val();
        if(action==='InProcess'){
            if(!confirm('Complete all pending files for this project?')) return;
            showLoader(true); call('CompleteProject',{vendorCode:context.vendorCode,invoiceId:context.invoiceId,projectNumber:context.projectNumber}).done(function(r){var x=unwrap(r);showMessage(x.Message,x.Success);if(x.Success){loadCounts();loadFiles('UnVerify');}}).fail(ajaxFail).always(function(){showLoader(false);});
            return;
        }
        var ids=[]; $('.row-check:checked').each(function(){ids.push(parseInt(this.value,10));});
        if(!ids.length){showMessage('Please select at least one file.',false);return;}
        showMessage('The legacy page collected selected InvoiceDetailID values but did not save them. Add the existing verification procedure/method before enabling this action.',false);
    }
    function goBack(){ window.location.href='<%= ResolveUrl("ProjectWiseSummary.aspx") %>?VendorCode='+encodeURIComponent(context.vendorCode)+'&InvoiceId='+context.invoiceId; }
    function call(method,data){ return $.ajax({type:'POST',url:pageUrl+'/'+method,data:JSON.stringify(data),contentType:'application/json; charset=utf-8',dataType:'json'}); }
    function unwrap(r){return r.d||r;} function val(o,k){return o&&o[k]!=null?o[k]:'';} function html(v){return $('<div/>').text(v==null?'':v).html();}
    function formatDotNetDate(v){ if(!v)return''; var m=/\/Date\((-?\d+)/.exec(v); if(!m)return v; var d=new Date(parseInt(m[1],10)),mon=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']; return ('0'+d.getDate()).slice(-2)+'-'+mon[d.getMonth()]+'-'+d.getFullYear(); }
    function statusClass(s){s=(s||'').toLowerCase();return s==='completed'?'status-completed':s==='inprocess'?'status-inprocess':'status-pending';}
    function showLoader(v){$('#gridLoader').css('display',v?'flex':'none');} function showMessage(m,ok){$('#message').removeClass('success error').addClass(ok?'success':'error').text(m||'').show();}
    function ajaxFail(xhr){showMessage('Request failed: '+(xhr.responseJSON&&xhr.responseJSON.Message?xhr.responseJSON.Message:xhr.statusText),false);}
    function exportCsv(){ var csv=[]; $('#fileTable tr').each(function(){var row=[];$(this).find('th,td').each(function(i){if(i>0)row.push('"'+$(this).text().replace(/"/g,'""')+'"');});csv.push(row.join(','));}); var b=new Blob([csv.join('\r\n')],{type:'text/csv'}),a=document.createElement('a');a.href=URL.createObjectURL(b);a.download='ProjectWiseFileList.csv';a.click();URL.revokeObjectURL(a.href); }
})();
</script>
</asp:Content>
