<%@ Page Title="Pending Employee Approvals" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="ProfileApproval.aspx.cs" Inherits="WebPortal.Accounts.ProfileApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .pa-page{padding:12px 15px 30px}.pa-card{background:#fff;border:1px solid #e3e8ef;border-radius:8px;box-shadow:0 1px 4px rgba(0,0,0,.05)}
        .pa-card-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:12px 16px;border-bottom:1px solid #e8edf3;background:#f8fafc;color:#33445c}.pa-card-body{padding:16px}
        .pa-count{font-size:12px;color:#69778a}.pa-table-wrap{width:100%;overflow-x:auto}.pa-table thead th{white-space:nowrap;background:#5a78a8;color:#fff;font-size:12px;text-align:center}.pa-table tbody td{white-space:nowrap;font-size:12px;vertical-align:middle}
        .pa-empty{text-align:center;padding:35px;color:#778397}.pa-loading{display:none;position:fixed;inset:0;background:rgba(255,255,255,.72);z-index:99999}.pa-loading div{position:absolute;left:50%;top:50%;transform:translate(-50%,-50%);font-weight:600;color:#33445c}
        .dt-buttons .btn{font-size:12px;margin-right:5px}.dataTables_filter input{margin-left:6px}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="paLoading" class="pa-loading"><div><i class="fas fa-spinner fa-spin mr-2"></i>Loading pending profiles...</div></div>
    <div class="pa-page">
        <div class="content-header px-0"><div class="container-fluid px-0"><div class="callout callout-info mb-3"><h6 class="m-0"><i class="fas fa-user-clock mr-2"></i><b>Pending Employee Profile Approvals</b></h6></div></div></div>
        <div id="paAlert" class="alert alert-danger" style="display:none" role="alert"></div>
        <div class="pa-card">
            <div class="pa-card-head"><b>Employees Pending Approval</b><span id="paCount" class="pa-count"></span></div>
            <div class="pa-card-body"><div class="pa-table-wrap"><table id="paTable" class="table table-bordered table-hover pa-table" style="width:100%"><thead><tr><th>Code</th><th>Name</th><th>Joining Date</th><th>Company</th><th>Branch</th><th>Department</th><th>Reporting Manager</th><th>Action</th></tr></thead><tbody></tbody></table></div></div>
        </div>
    </div>
    <script>
        var paGrid;
        $(function(){paLoad();});
        function paCall(method,data){return $.ajax({type:'POST',url:'ProfileApproval.aspx/'+method,data:JSON.stringify(data||{}),contentType:'application/json; charset=utf-8',dataType:'json'}).then(function(r){return r.d;});}
        function paLoad(){$('#paLoading').show();paCall('GetPendingProfiles',{}).done(function(rows){rows=rows||[];$('#paCount').text(rows.length+' pending');paRender(rows);}).fail(paError).always(function(){$('#paLoading').hide();});}
        function paRender(rows){if($.fn.DataTable.isDataTable('#paTable'))$('#paTable').DataTable().clear().destroy();paGrid=$('#paTable').DataTable({data:rows,columns:[{data:'Code'},{data:'EmployeeName'},{data:'JoiningDate'},{data:'CompanyName'},{data:'BranchName'},{data:'DepartmentName'},{data:'ReportingManager'},{data:'Code',orderable:false,searchable:false,className:'text-center',render:function(v){return '<a class="btn btn-sm btn-primary" href="ApprovedEmployee.aspx?Code='+encodeURIComponent(v||'')+'"><i class="fas fa-user-check mr-1"></i>Review</a>';}}],order:[[2,'asc'],[1,'asc']],pageLength:25,lengthMenu:[[10,25,50,100,-1],[10,25,50,100,'All']],responsive:false,scrollX:true,autoWidth:false,columnDefs:[{targets:'_all',defaultContent:''}],dom:'<"row mb-2"<"col-md-7"B><"col-md-5"f>>rt<"row mt-2"<"col-md-5"l><"col-md-7"p>>',buttons:[{extend:'excelHtml5',text:'<i class="fas fa-file-excel mr-1"></i>Export Excel',className:'btn btn-outline-success btn-sm',title:'Pending Employee Profile Approvals',exportOptions:{columns:[0,1,2,3,4,5,6]}},{extend:'print',text:'<i class="fas fa-print mr-1"></i>Print',className:'btn btn-outline-secondary btn-sm',title:'Pending Employee Profile Approvals',exportOptions:{columns:[0,1,2,3,4,5,6]}}],language:{emptyTable:'No employee profiles are pending approval',search:'Search:'}});}
        function paError(x){var m=x.responseJSON&&x.responseJSON.Message?x.responseJSON.Message:'Unable to load pending employee profiles.';$('#paAlert').text(m).show();}
    </script>
</asp:Content>
