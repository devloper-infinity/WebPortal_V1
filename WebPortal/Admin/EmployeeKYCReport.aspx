<%@ Page Title="Employee KYC Report" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeKYCReport.aspx.cs" Inherits="WebPortal.Admin.EmployeeKYCReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css" />
    <link rel="stylesheet" href="../Content/erp-modern-common.css" />
    <style>
        #ekrTable{width:100%!important;white-space:nowrap}.ekr-pending{color:#dc2626!important;font-weight:700}.ekr-loader{display:none;position:fixed;inset:0;z-index:9999;background:rgba(248,250,252,.72)}.ekr-loader>div{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);padding:18px 26px;border-radius:10px;background:#fff;box-shadow:0 12px 30px rgba(15,23,42,.18);font-weight:600}.dt-buttons{margin-bottom:10px}.dt-button.btn{margin-right:6px}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="ekrLoader" class="ekr-loader"><div><i class="fas fa-spinner fa-spin"></i>&nbsp; Loading report...</div></div>
    <div class="container-fluid">
        <div class="erp-dashboard-header"><div class="erp-dashboard-header-content"><div class="erp-dashboard-icon"><i class="fas fa-id-card"></i></div><div><h1 class="erp-dashboard-title">Employee KYC Report</h1><p class="erp-dashboard-subtitle">Review and export employee KYC, bank, document, and nominee information.</p></div></div></div>
        <section class="erp-section-card">
            <div class="erp-table-wrap">
                <table id="ekrTable" class="table table-bordered table-hover">
                    <thead><tr><th>Sr. #</th><th>Status</th><th>Company</th><th>Branch</th><th>Code</th><th>UAN</th><th>Employee Full Name</th><th>Gender</th><th>Marital Status</th><th>Member Contact #</th><th>Father/Husband Name</th><th>DOJ</th><th>DOB</th><th>Educational Qualification</th><th>Bank Name</th><th>Bank Account No.</th><th>Bank IFSC No.</th><th>Document Name</th><th>Document No.</th><th>Expiry Date</th><th>PAN Card</th><th>Aadhar Card</th><th>Physically Handicap</th><th>Handicap Category</th><th>Nominee Name</th><th>Nominee Address</th><th>Nominee Relation</th><th>Nominee DOB</th><th>Nominee Contact #</th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>
    </div>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        (function(){
            function value(data,type,row,meta){return type==='display'||type==='filter'?$('<div>').text(data==null?'':data).html():(data==null?'':data);}
            function loadReport(){
                $('#ekrLoader').show();
                $.ajax({type:'POST',url:'EmployeeKYCReport.aspx/GetReport',data:'{}',contentType:'application/json; charset=utf-8',dataType:'json'})
                .done(function(response){
                    var rows=response&&response.d?response.d:[];
                    $('#ekrTable').DataTable({data:rows,destroy:true,scrollX:true,pageLength:25,searching:true,paging:true,ordering:true,autoWidth:false,dom:'Bfrtip',buttons:[{extend:'excelHtml5',text:'<i class="fas fa-file-excel"></i> Export To Excel',className:'btn btn-success',title:'EmployeeKYCReport',exportOptions:{columns:':visible'}}],columns:[
                        {data:null,render:function(d,t,r,m){return m.row+1;}},{data:'ReportStatus',render:value},{data:'Company',render:value},{data:'Branch',render:value},{data:'Code',render:value},{data:'UAN',render:value,createdCell:function(td,x){if(String(x||'').toLowerCase()==='pending')$(td).addClass('ekr-pending');}},{data:'FullName',render:value},{data:'Gender',render:value},{data:'MStatus',render:value},{data:'ContactNo',render:value},{data:'FahterName',render:value},{data:'DOJ',render:value},{data:'DOB',render:value},{data:'Qual',render:value},{data:'BankName',render:value},{data:'BankAccNO',render:value},{data:'IFSCCode',render:value},{data:'DocName',render:value},{data:'DocNumber',render:value},{data:'ExpDate',render:value},{data:'PAN',render:value},{data:'AadharCardNo',render:value},{data:'PH',render:value},{data:'PHC',render:value},{data:'Nominee',render:value},{data:'NAddress',render:value},{data:'NRelation',render:value},{data:'NDOB',render:value},{data:'NContactNo',render:value}
                    ],columnDefs:[{targets:'_all',defaultContent:''}],language:{emptyTable:'No KYC records found'}});
                }).fail(function(xhr){toastr.error(xhr.responseJSON&&xhr.responseJSON.Message?xhr.responseJSON.Message:'Unable to load Employee KYC report.');}).always(function(){$('#ekrLoader').hide();});
            }
            $(loadReport);
        })();
    </script>
</asp:Content>
