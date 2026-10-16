<%@ Page Title="Access Denied" Language="C#" MasterPageFile="~/Admin/Admin.Master" %>
<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
<style>.ob-denied{max-width:680px;margin:70px auto;padding:42px;text-align:center;background:#fff;border:1px solid #dce3ed;border-radius:14px;box-shadow:0 12px 32px rgba(24,45,78,.1)}.ob-denied i{font-size:48px;color:#e0a800}.ob-denied h2{margin:18px 0 10px;color:#24334b}.ob-denied p{color:#65758b}</style>
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="ob-denied"><i class="fas fa-lock"></i><h2>You don't have access</h2><p>Your ERP login could not be verified. Please sign in again or contact your ERP administrator.</p><a href="../Admin/DashboardEmployee.aspx" class="btn btn-primary">Back to Dashboard</a></div>
</asp:Content>
