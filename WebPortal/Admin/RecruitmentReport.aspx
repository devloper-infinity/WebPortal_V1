<%@ Page Title="Recruitment Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="RecruitmentReport.aspx.cs" Inherits="WebPortal.Admin.RecruitmentReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css" />
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
    <style>
        .rr-table {
            width: 100% !important;
            white-space: nowrap
        }

        .rr-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 9999;
            background: rgba(248,250,252,.72)
        }

            .rr-loader span {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%,-50%);
                background: #fff;
                padding: 18px 26px;
                border-radius: 10px
            }

        .nav-tabs {
            margin-bottom: 15px
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="rrLoader" class="rr-loader"><span><i class="fas fa-spinner fa-spin"></i>Loading...</span></div>
    <div class="container-fluid">
        <div class="erp-dashboard-header">
            <div class="erp-dashboard-header-content">
                <div class="erp-dashboard-icon"><i class="fas fa-user-plus"></i></div>
                <div>
                    <h1 class="erp-dashboard-title">Recruitment Report</h1>
                    <p class="erp-dashboard-subtitle">Recruitment summaries and candidate details by date, location, or position.</p>
                </div>
            </div>
        </div>
        <section class="erp-section-card erp-modern-form p-3 mb-4">
            <div class="row align-items-end">
                <div class="col-md-3">
                    <label>From Date <span class="text-danger">*</span></label><input id="rrFrom" type="date" class="form-control" /></div>
                <div class="col-md-3">
                    <label>To Date <span class="text-danger">*</span></label><input id="rrTo" type="date" class="form-control" /></div>
                <div class="col-md-3">
                    <label>Report Type</label><select id="rrType" class="form-control"><option>Date wise</option>
                        <option>Location wise</option>
                        <option>Position wise</option>
                    </select></div>
                <div class="col-md-3">
                    <button id="rrShow" type="button" class="btn btn-primary"><i class="fas fa-search"></i>Show</button></div>
            </div>
        </section>
        <section class="erp-section-card p-3">
            <ul class="nav nav-tabs">
                <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#rrSummary">Summary</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#rrDetails">Recruitment Details</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#rrCandidateSummary">Candidate Summary</a></li>
                <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#rrCandidates">Candidate Details</a></li>
            </ul>
            <div class="tab-content">
                <div id="rrSummary" class="tab-pane active erp-table-wrap">
                    <table class="table table-bordered rr-table"></table>
                </div>
                <div id="rrDetails" class="tab-pane erp-table-wrap">
                    <table class="table table-bordered rr-table"></table>
                </div>
                <div id="rrCandidateSummary" class="tab-pane erp-table-wrap">
                    <table class="table table-bordered rr-table"></table>
                </div>
                <div id="rrCandidates" class="tab-pane erp-table-wrap">
                    <table class="table table-bordered rr-table"></table>
                </div>
            </div>
        </section>
    </div>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        (function(){
function col(data,title){return{data:data,title:title,defaultContent:'',render:function(x,t){return t==='display'||t==='filter'? $('<div>').text(x==null?'':x).html():x;}};}
function render(box,data,title,fields){var t=$(box+' table');if($.fn.DataTable.isDataTable(t))t.DataTable().destroy();t.empty();var cols=[{data:null,title:'Sr. #',orderable:false,render:function(d,x,r,m){return m.row+1;}}];$.each(fields,function(_,f){cols.push(col(f[0],f[1]));});t.DataTable({data:data.Rows||[],columns:cols,scrollX:true,scrollCollapse:true,autoWidth:false,pageLength:25,dom:'Bfrtip',buttons:[{extend:'excelHtml5',className:'btn btn-success',text:'<i class="fas fa-file-excel"></i> Export To Excel',title:title}],language:{emptyTable:'No records found'},initComplete:function(){this.api().columns.adjust();}});}
function load(){var f=$('#rrFrom').val(),to=$('#rrTo').val();if(!f||!to){toastr.warning('Please select From Date and To Date.');return;}if(f>to){toastr.warning('To Date must be on or after From Date.');return;}$('#rrLoader').show();$.ajax({type:'POST',url:'RecruitmentReport.aspx/GetReport',data:JSON.stringify({fromDate:f,toDate:to,reportType:$('#rrType').val()}),contentType:'application/json; charset=utf-8',dataType:'json'}).done(function(r){var x=r.d,counts=[['Total','Total Candidates'],['Shortlisted','Shortlisted'],['Selected','Selected'],['Joined','Joined'],['Hold','Hold'],['Rejected','Rejected'],['Other','Other']],type=$('#rrType').val(),summary=(type==='Date wise'?[['Date','Application Date'],['Location','Location']]:type==='Location wise'?[['Location','Location']]:[['PositionApplied','Position Applied'],['Location','Location']]).concat(counts);render('#rrSummary',x.Summary,'Recruitment Summary',summary);render('#rrDetails',x.Details,'Recruitment Details',[['Date','Application Date'],['PositionApplied','Position Applied'],['Location','Location']].concat(counts));render('#rrCandidateSummary',x.CandidateSummary,'Candidate Summary',[['Location','Code'],['Total','Total Count'],['Contacted','Contacted'],['NotConnected','Not Connected'],['NotInterested','Not Interested'],['InvalidNumber','Invalid Number'],['OtherNew','Other']]);render('#rrCandidates',x.CandidateDetails,'Candidate Details',[['Date','Date'],['Location','Code'],['CallingCandidate','Total Calling'],['Total','Total Application'],['Shortlisted','Shortlisted'],['Selected','Selected'],['Joined','Joined'],['Hold','Hold'],['Rejected','Rejected']]);setTimeout(adjust,0);}).fail(function(x){toastr.error(x.responseJSON&&x.responseJSON.Message?x.responseJSON.Message:'Unable to load report.');}).always(function(){$('#rrLoader').hide();});}
function adjust(){$.fn.dataTable.tables({visible:true,api:true}).columns.adjust();}
$(function(){var d=new Date().toISOString().slice(0,10);$('#rrFrom,#rrTo').val(d);$('#rrShow').on('click',load);$('a[data-toggle="tab"]').on('shown.bs.tab',adjust);load();});})();
</script>
</asp:Content>
