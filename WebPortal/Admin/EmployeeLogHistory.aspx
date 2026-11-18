<%@ Page Title="Employee Log History" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeLogHistory.aspx.cs" Inherits="WebPortal.Admin.EmployeeLogHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <style>
  .elh-page{padding:18px}.elh-hero{color:#fff;padding:22px 26px;border-radius:18px;background:linear-gradient(120deg,#2457e6,#25bfd4);box-shadow:0 18px 40px rgba(36,87,230,.2)}
  .elh-hero h1{margin:0 0 5px;font-size:23px;font-weight:800}.elh-hero p{margin:0;opacity:.9}.elh-card,.elh-table-card{margin-top:18px;padding:20px;border:1px solid #e4eaf3;border-radius:16px;background:#fff;box-shadow:0 10px 28px rgba(17,24,39,.07)}
  .elh-filters{display:grid;grid-template-columns:repeat(4,minmax(180px,1fr));gap:14px;align-items:end}.elh-field label{display:block;margin-bottom:6px;font-size:12px;font-weight:750;color:#475467}.elh-field .form-control{min-height:40px}
  .elh-btn{min-height:40px;border:0;border-radius:9px;padding:0 18px;color:#fff;font-weight:750;background:linear-gradient(135deg,#2457e6,#25bfd4)}.elh-note{margin:14px 0 0;color:#667085;font-size:12px}
  #employeeLogHistory th{white-space:nowrap;background:#f5f8fc}#employeeLogHistory td{white-space:nowrap;vertical-align:middle}@media(max-width:900px){.elh-filters{grid-template-columns:1fr 1fr}}@media(max-width:560px){.elh-filters{grid-template-columns:1fr}}
 </style>
 <script type="text/javascript">
  var employeeLogTable;
  function bindEmployeeLogHistory(){
   var request={Code:new URLSearchParams(window.location.search).get("Code")||"",Cycle:$("#<%= ddlSalaryCycle.ClientID %>").val()||""};
   if($.fn.DataTable.isDataTable("#employeeLogHistory"))employeeLogTable.destroy();
   employeeLogTable=$("#employeeLogHistory").DataTable({ajax:{type:"POST",url:"EmployeeLogHistory.aspx/GetLogs",data:function(){return JSON.stringify(request);},contentType:"application/json; charset=utf-8",dataType:"json",dataSrc:function(r){return typeof r.d==="string"?JSON.parse(r.d):r.d;}},paging:false,searching:false,info:false,ordering:false,scrollX:true,processing:true,columns:[{data:"Code",defaultContent:""},{data:"Date",defaultContent:""},{data:"In Time",defaultContent:""},{data:"Out Time",defaultContent:""},{data:"Total Hours",defaultContent:""},{data:"Extra Hours",defaultContent:""},{data:"Latemark",defaultContent:""},{data:"Partial",defaultContent:""},{data:"Shift Remark",defaultContent:""},{data:"PM/ System Remark",defaultContent:""}],language:{emptyTable:"No log records found for this salary cycle",processing:"Loading logs..."}});
  }
  $(document).ready(function(){bindEmployeeLogHistory();$("#btnShowLogs").on("click",bindEmployeeLogHistory);});
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <div class="container-fluid elh-page">
  <section class="elh-hero"><h1><i class="fa fa-calendar-check-o"></i> Employee Log History</h1><p>Daily attendance records grouped by the 26th-to-25th salary cycle.</p></section>
  <section class="elh-card"><div class="elh-filters">
   <div class="elh-field"><label>Employee Code</label><asp:TextBox ID="txtCode" runat="server" CssClass="form-control" ReadOnly="true" /></div>
   <div class="elh-field"><label>Employee Name</label><asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true" /></div>
   <div class="elh-field"><label>Salary Cycle</label><asp:DropDownList ID="ddlSalaryCycle" runat="server" CssClass="form-control" /></div>
   <div class="elh-field"><label>&nbsp;</label><button type="button" id="btnShowLogs" class="elh-btn"><i class="fa fa-search"></i> Show Logs</button></div>
  </div><p class="elh-note">For dropout employees, the latest cycle containing a present day is selected automatically.</p></section>
  <section class="elh-table-card"><div class="table-responsive"><table id="employeeLogHistory" class="table table-bordered table-hover" style="width:100%"><thead><tr><th>Code</th><th>Date</th><th>In Time</th><th>Out Time</th><th>Total Hours</th><th>Extra Hours</th><th>Latemark</th><th>Partial</th><th>Shift Remark</th><th>PM/ System Remark</th></tr></thead><tbody></tbody></table></div></section>
 </div>
</asp:Content>
