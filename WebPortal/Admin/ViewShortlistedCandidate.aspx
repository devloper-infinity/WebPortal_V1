<%@ Page Title="Shortlisted Candidates" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewShortlistedCandidate.aspx.cs" Inherits="WebPortal.Admin.ViewShortlistedCandidate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css" />
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
    <style>
        #vscTable,#vscTable_wrapper,.vsc-table-host,.vsc-table-host .dataTables_scroll,.vsc-table-host .dataTables_scrollHead,.vsc-table-host .dataTables_scrollBody{width:100%!important;max-width:100%}
        #vscTable{white-space:nowrap}.vsc-table-host{overflow:hidden}.vsc-table-host .dataTables_scrollBody{overflow-x:auto!important}
        #vscTable thead th{vertical-align:middle;text-align:center}.vsc-filter{width:100%;min-width:90px;padding:5px 7px;border:1px solid #dbe4f0;border-radius:6px;font-size:11px}
        .vsc-actions{display:flex;justify-content:center;gap:6px}.vsc-action{width:32px;height:32px;display:inline-flex;align-items:center;justify-content:center;border:0;border-radius:8px;color:#fff;cursor:pointer}.vsc-view{background:#2563eb}.vsc-remark{background:#0f9f76}
        .vsc-loader{display:none;position:fixed;inset:0;z-index:9999;background:rgba(248,250,252,.72)}.vsc-loader>div{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);padding:18px 26px;border-radius:10px;background:#fff;box-shadow:0 12px 30px rgba(15,23,42,.18);font-weight:600}
        #vscTable_wrapper .dt-buttons{margin-bottom:10px}#vscTable_wrapper .dt-button.btn{margin-right:6px}
        @media(max-width:767px){.vsc-card-body{padding:12px!important}}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="vscLoader" class="vsc-loader" role="status" aria-live="polite"><div><i class="fas fa-spinner fa-spin"></i>&nbsp; Loading shortlisted candidates...</div></div>
    <div class="container-fluid">
        <div class="erp-dashboard-header">
            <div class="erp-dashboard-header-content"><div class="erp-dashboard-icon"><i class="fas fa-user-check"></i></div><div><h1 class="erp-dashboard-title">View Shortlisted Candidates</h1><p class="erp-dashboard-subtitle">Search shortlisted applications, review candidate details, and maintain recruitment remarks.</p></div></div>
        </div>
        <section class="erp-section-card">
            <div class="card-header"><h2 class="card-title mb-0"><i class="fas fa-list mr-2"></i>Candidate List</h2></div>
            <div id="vscTableHost" class="erp-table-wrap vsc-table-host vsc-card-body p-3">
                <table id="vscTable" class="table table-bordered table-hover" aria-label="Shortlisted candidates">
                    <thead><tr><th>Sr. #</th><th>Position Applied</th><th>Applied Date</th><th>Status</th><th>Full Name</th><th>Date Of Birth</th><th>Contact No.</th><th>Domain</th><th>Process</th><th>Actions</th></tr></thead>
                    <tfoot><tr><th></th><th>Position Applied</th><th>Applied Date</th><th>Status</th><th>Full Name</th><th>Date Of Birth</th><th>Contact No.</th><th>Domain</th><th>Process</th><th></th></tr></tfoot>
                    <tbody></tbody>
                </table>
            </div>
        </section>
    </div>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        (function(){
            var candidateTable, resizeObserver, resizeTimer;
            function text(value,type){var result=value==null?'':value;return type==='display'||type==='filter'?$('<div>').text(result).html():result;}
            function dateValue(value,type){if(!value)return '';var match=/\/Date\((\d+)\)\//.exec(String(value)),date=match?new Date(parseInt(match[1],10)):new Date(value);if(isNaN(date.getTime()))return text(value,type);var display=('0'+date.getDate()).slice(-2)+'-'+('0'+(date.getMonth()+1)).slice(-2)+'-'+date.getFullYear();return type==='sort'?date.getTime():display;}
            function adjust(){if(candidateTable){candidateTable.columns.adjust();if(candidateTable.responsive)candidateTable.responsive.recalc();}}
            function scheduleAdjust(){clearTimeout(resizeTimer);resizeTimer=setTimeout(adjust,80);}
            function actionButtons(data){var id=encodeURIComponent(data.AppID==null?'':data.AppID);return '<div class="vsc-actions"><button type="button" class="vsc-action vsc-view" data-id="'+id+'" title="View record" aria-label="View record"><i class="fas fa-eye"></i></button><button type="button" class="vsc-action vsc-remark" data-id="'+id+'" title="Add or view remark" aria-label="Add or view remark"><i class="fas fa-comment-alt"></i></button></div>';}
            function addColumnFilters(table){table.columns().every(function(index){if(index===0||index===9)return;var column=this,input=$('<input type="text" class="vsc-filter" aria-label="Filter '+$(column.footer()).text()+'" placeholder="Filter" />').appendTo($(column.footer()).empty());input.on('keyup change clear',function(){if(column.search()!==this.value)column.search(this.value).draw();});});}
            function loadCandidates(){
                $('#vscLoader').show();
                $.ajax({type:'POST',url:'ViewShortlistedCandidate.aspx/GetCandidates',data:'{}',contentType:'application/json; charset=utf-8',dataType:'json'})
                .done(function(response){var rows=response&&response.d?response.d:[];candidateTable=$('#vscTable').DataTable({data:rows,destroy:true,scrollX:true,scrollCollapse:true,autoWidth:false,processing:true,searching:true,paging:true,ordering:true,pageLength:25,lengthMenu:[[10,25,50,100,-1],[10,25,50,100,'All']],order:[[2,'desc']],dom:'lBfrtip',buttons:[{extend:'copyHtml5',text:'<i class="fas fa-copy"></i> Copy',className:'btn btn-secondary',exportOptions:{columns:':not(:last-child)'}},{extend:'excelHtml5',text:'<i class="fas fa-file-excel"></i> Excel',className:'btn btn-success',title:'ShortlistedCandidates',exportOptions:{columns:':not(:last-child)'}},{extend:'csvHtml5',text:'<i class="fas fa-file-csv"></i> CSV',className:'btn btn-info',title:'ShortlistedCandidates',exportOptions:{columns:':not(:last-child)'}},{extend:'print',text:'<i class="fas fa-print"></i> Print',className:'btn btn-primary',title:'Shortlisted Candidates',exportOptions:{columns:':not(:last-child)'}}],columns:[{data:null,orderable:false,searchable:false,render:function(d,t,r,m){return m.row+m.settings._iDisplayStart+1;}},{data:'PositionAppliedName',render:text},{data:'ApplicationDate',render:dateValue},{data:'Status',render:text},{data:'FullName',render:text},{data:'DateOfBirth',render:dateValue},{data:'CellPhoneNo',render:text},{data:'Domain',render:text},{data:'Process',render:text},{data:null,orderable:false,searchable:false,render:function(d,t,row){return t==='display'?actionButtons(row):'';}}],columnDefs:[{targets:'_all',defaultContent:''}],language:{emptyTable:'No shortlisted candidates found',processing:'Loading candidates...'},initComplete:function(){addColumnFilters(this.api());$('#vscLoader').hide();setTimeout(function(){this.columns.adjust();}.bind(this.api()),0);}});candidateTable.on('draw.dt column-sizing.dt',scheduleAdjust);})
                .fail(function(xhr){toastr.error(xhr.responseJSON&&xhr.responseJSON.Message?xhr.responseJSON.Message:'Unable to load shortlisted candidates.');})
                .always(function(){$('#vscLoader').hide();scheduleAdjust();});
            }
            $(function(){loadCandidates();$('#vscTable').on('click','.vsc-view',function(){window.location.href='ApplicationForm.aspx?AppId='+$(this).data('id');}).on('click','.vsc-remark',function(){window.location.href='AddApplicantRemark.aspx?ShortlistedRemark='+$(this).data('id');});$(window).on('load resize',scheduleAdjust);$('a[data-toggle="tab"]').on('shown.bs.tab',scheduleAdjust);if(window.ResizeObserver){resizeObserver=new ResizeObserver(scheduleAdjust);resizeObserver.observe(document.getElementById('vscTableHost'));}});
        })();
    </script>
</asp:Content>
