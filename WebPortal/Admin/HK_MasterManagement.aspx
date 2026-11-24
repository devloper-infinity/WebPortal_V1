<%@ Page Title="Housekeeping Master Management" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HK_MasterManagement.aspx.cs" Inherits="WebPortal.Admin.HK_MasterManagement" %>
<%@ Register TagPrefix="hk" TagName="Shell" Src="~/Admin/HousekeepingShell.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
  <link rel="stylesheet" href="../Content/Housekeeping.css?v=2" />
  <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
  <script src="../Scripts/Functions/HK_MasterManagement.js?v=1"></script>
  <script src="../Scripts/Functions/HK_Common.js?v=17"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <hk:Shell ID="HousekeepingShell1" runat="server" />
</asp:Content>
