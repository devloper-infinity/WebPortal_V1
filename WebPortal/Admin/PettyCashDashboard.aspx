<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PettyCashDashboard.aspx.cs" Inherits="WebPortal.Admin.PettyCashDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container-fluid py-3"><div class="p-3 mb-3 text-white rounded" style="background:linear-gradient(120deg,#1d4ed8,#2563eb,#22c1dc)"><h4>PettyCashDashboard</h4></div><div class="card"><div class="card-body"><p>This page is part of the Petty Cash Management module. Wire employee/rights helpers to your existing WebPortal implementation as described in README.md.</p><div id="pc_PettyCashDashboard_content"></div></div></div></div>
<script src="<%= ResolveUrl("~/Scripts/jquery-3.6.0.min.js") %>"></script>
<script src="<%= ResolveUrl("~/Scripts/bootstrap.min.js") %>"></script>
<script src="<%= ResolveUrl("~/Scripts/Functions/PettyCash.js") %>"></script>
</asp:Content>
