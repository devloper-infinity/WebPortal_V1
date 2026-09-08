<%@ Page Title="Branchwise Salary Analysis" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="BranchwiseSalaryAnalysis.aspx.cs" Inherits="WebPortal.Accounts.BranchwiseSalaryAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .bsa-page { padding: 12px 15px 25px; }
        .bsa-panel { background:#fff; border:1px solid #e4e8ee; border-radius:7px; margin-bottom:15px; box-shadow:0 1px 4px rgba(0,0,0,.05); }
        .bsa-panel-title { padding:11px 15px; border-bottom:1px solid #e8ebef; font-weight:600; color:#33445c; background:#f8fafc; }
        .bsa-panel-body { padding:15px; }
        .bsa-label { display:block; font-size:12px; font-weight:600; color:#536174; margin-bottom:5px; }
        .bsa-btn { min-width:100px; }
        .bsa-table-wrap { width:100%; overflow-x:auto; }
        .bsa-table thead th { white-space:nowrap; background:#5a78a8; color:#fff; font-size:12px; text-align:center; }
        .bsa-table tbody td, .bsa-table tfoot th { white-space:nowrap; font-size:12px; text-align:center; vertical-align:middle; }
        .bsa-summary tbody th { background:#f3f6fa; color:#40526a; }
        .bsa-summary tfoot th { background:#eaf0f8; font-weight:700; }
        .bsa-empty { padding:24px; text-align:center; color:#778397; }
        #bsaLoader { display:none; position:fixed; inset:0; z-index:99999; background:rgba(255,255,255,.72); }
        #bsaLoader div { position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); text-align:center; font-size:12px; font-weight:600; color:#33445c; }
        #bsaLoader img { display:block; width:70px; margin:0 auto 8px; }
        @media(max-width:767px) { .bsa-actions { margin-top:10px; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="bsaLoader"><div><img src="../images/Load_1.gif" alt="Loading" />One moment, please...</div></div>
    <div class="bsa-page">
        <div class="content-header">
            <div class="container">
                <div class="row mb-2 callout callout-info">
                    <div class="col-sm-6">
                        <h6 class="m-0"><i class="fas fa-chart-bar"></i>&nbsp;&nbsp;<b>Branchwise Salary Analysis</b></h6>
                    </div>
                </div>
            </div>
        </div>
        <div class="bsa-panel"><div class="bsa-panel-title">Report Filter</div><div class="bsa-panel-body">
            <div class="row align-items-end"><div class="col-md-4"><label class="bsa-label" for="bsaBranch">Branch</label><select id="bsaBranch" class="form-control"><option value="">Select</option></select></div>
            <div class="col-md-6 bsa-actions"><button type="button" id="bsaShow" class="btn btn-primary bsa-btn"><i class="fas fa-search mr-1"></i>Submit</button>
            <button type="button" id="bsaExport" class="btn btn-success bsa-btn ml-1"><i class="fas fa-file-excel mr-1"></i>Export Excel</button></div></div>
        </div></div>
        <div id="bsaResults" style="display:none;">
            <ul class="nav nav-tabs" role="tablist"><li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#bsaSummary">Summary</a></li><li class="nav-item"><a class="nav-link" data-toggle="tab" href="#bsaNonDD">Non-DD</a></li><li class="nav-item"><a class="nav-link" data-toggle="tab" href="#bsaDD">DD</a></li></ul>
            <div class="tab-content bsa-panel">
                <div id="bsaSummary" class="tab-pane fade show active bsa-panel-body"><div class="row"><div class="col-lg-6 mb-3"><div class="bsa-panel-title">Domain Summary</div><div class="bsa-table-wrap" id="bsaDomainSummary"></div></div><div class="col-lg-6 mb-3"><div class="bsa-panel-title">Underwriting Subdomain Summary</div><div class="bsa-table-wrap" id="bsaCreditSummary"></div></div></div></div>
                <div id="bsaNonDD" class="tab-pane fade bsa-panel-body"><div class="bsa-table-wrap"><table id="bsaNonDDTable" class="table table-bordered bsa-table" style="width:100%"></table></div></div>
                <div id="bsaDD" class="tab-pane fade bsa-panel-body"><div class="bsa-table-wrap"><table id="bsaDDTable" class="table table-bordered bsa-table" style="width:100%"></table></div></div>
            </div>
        </div>
    </div>
    <script>
        var bsaTables = [];
        $(function () {
            bsaCall('GetBranches', {}).done(function (rows) { $.each(rows || [], function (_, x) { $('#bsaBranch').append($('<option/>').val(x.BranchID).text(x.BranchName)); }); }).fail(bsaAjaxError);
            $('#bsaShow').on('click', bsaLoad); $('#bsaExport').on('click', bsaExport);
            $('a[data-toggle="tab"]').on('shown.bs.tab', function () { $.each(bsaTables, function (_, t) { t.columns.adjust(); }); });
        });
        function bsaCall(method, payload) { return $.ajax({ type:'POST', url:'BranchwiseSalaryAnalysis.aspx/' + method, data:JSON.stringify(payload), contentType:'application/json; charset=utf-8', dataType:'json' }).then(function(r){ return r.d; }); }
        function bsaNotify(message, type) { if (window.toastr) toastr[type || 'warning'](message); else alert(message); }
        function bsaAjaxError(xhr) { var message = xhr.responseJSON && xhr.responseJSON.Message ? xhr.responseJSON.Message : 'Unable to load the report.'; bsaNotify(message, 'error'); }
        function bsaLoad() {
            var branchId = parseInt($('#bsaBranch').val(), 10); if (!branchId) { bsaNotify('Please select a branch.'); return; }
            $('#bsaLoader').show(); bsaCall('GetAnalysis', { branchId:branchId }).done(function(result) {
                bsaPivot('#bsaDomainSummary', result.Summary || [], 'Domain'); bsaPivot('#bsaCreditSummary', result.CreditSummary || [], 'Subdomain');
                bsaDetail('#bsaNonDDTable', result.NonDD || []); bsaDetail('#bsaDDTable', result.DD || []); $('#bsaResults').show();
            }).fail(bsaAjaxError).always(function(){ $('#bsaLoader').hide(); });
        }
        function bsaDetail(selector, rows) {
            if ($.fn.DataTable.isDataTable(selector)) $(selector).DataTable().clear().destroy(); $(selector).empty();
            var columns = [{title:'Sr. No.',data:null,render:function(_,__,___,m){return m.row+1;}},{title:'Code',data:'Code'},{title:'Employee Name',data:'Name'},{title:'Domain',data:'Domain'},{title:'Subdomain',data:'Subdomain'},{title:'Designation',data:'Designation'},{title:'Reporting Manager',data:'Reporting Manager'},{title:'Joining Date',data:'Joining Date'},{title:'Tenure',data:'Tenure'},{title:'Salary',data:'Salary'},{title:'Salary Range',data:'SalaryRange'}];
            var table = $(selector).DataTable({data:rows,columns:columns,pageLength:10,lengthMenu:[[10,25,50,100],[10,25,50,100]],searching:true,paging:true,ordering:true,autoWidth:false,scrollX:true,columnDefs:[{targets:'_all',defaultContent:'',className:'text-center'}]}); bsaTables.push(table);
        }
        function bsaPivot(target, rows, rowField) {
            var ranges=[], names=[], values={}; $.each(rows,function(_,r){var range=String(r.SalaryRange||''), name=String(r[rowField]||''); if(ranges.indexOf(range)<0)ranges.push(range); if(names.indexOf(name)<0)names.push(name); values[name+'\u0000'+range]=(values[name+'\u0000'+range]||0)+(parseFloat(r.EmpCount)||0);});
            if(!rows.length){$(target).html('<div class="bsa-empty">No data available</div>');return;} var html='<table class="table table-bordered bsa-table bsa-summary"><thead><tr><th>'+rowField+'</th>'; $.each(ranges,function(_,x){html+='<th>'+bsaHtml(x)+'</th>';}); html+='<th>Grand Total</th></tr></thead><tbody>'; var totals={},grand=0;
            $.each(names,function(_,name){var rt=0;html+='<tr><th>'+bsaHtml(name)+'</th>';$.each(ranges,function(_,range){var v=values[name+'\u0000'+range]||0;rt+=v;totals[range]=(totals[range]||0)+v;html+='<td>'+v+'</td>';});grand+=rt;html+='<th>'+rt+'</th></tr>';}); html+='</tbody><tfoot><tr><th>Grand Total</th>';$.each(ranges,function(_,r){html+='<th>'+(totals[r]||0)+'</th>';});html+='<th>'+grand+'</th></tr></tfoot></table>';$(target).html(html);
        }
        function bsaHtml(v){ return $('<div/>').text(v == null ? '' : v).html(); }
        function bsaExport(){var id=parseInt($('#bsaBranch').val(),10);if(!id){bsaNotify('Please select a branch.');return;}window.location='BranchwiseSalaryAnalysis.aspx?export=1&branchId='+encodeURIComponent(id);}
    </script>
</asp:Content>
