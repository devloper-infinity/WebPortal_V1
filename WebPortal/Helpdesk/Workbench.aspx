<%@ Page Title="IT Workbench" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="Workbench.aspx.cs" Inherits="WebPortal.Helpdesk.Workbench" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/Helpdesk.css?v=1" rel="stylesheet" /><script src="../Scripts/Functions/HelpdeskModule.js?v=1"></script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="hd-shell" data-helpdesk-page="workbench">
    <div class="hd-header"><div><h2>IT Workbench</h2><p>Triage, assign, and manage service tickets.</p></div><div class="hd-nav"><a href="Home.aspx">Requester portal</a><a class="active" href="Workbench.aspx">IT workbench</a><a href="Administration.aspx">Administration</a></div></div>
    <div id="hd-alert" class="hd-alert"></div>
    <div class="hd-summary"><div class="hd-stat"><strong id="hd-stat-total">0</strong><span>Visible tickets</span></div><div class="hd-stat"><strong id="hd-stat-unassigned">0</strong><span>Unassigned</span></div><div class="hd-stat"><strong id="hd-stat-overdue">0</strong><span>SLA overdue</span></div><div class="hd-stat"><strong id="hd-stat-critical">0</strong><span>Critical</span></div></div>
    <section class="hd-card">
        <div class="hd-filter">
            <div><label>Queue</label><select id="hd-scope" class="form-control" onchange="Helpdesk.loadQueue()"><option value="All">Department queue</option><option value="Mine">My tickets</option><option value="Unassigned">Unassigned</option></select></div>
            <div><label>Status</label><select id="hd-queue-status" class="form-control" onchange="Helpdesk.loadQueue()"><option value="">All active statuses</option><option>New</option><option>Assigned</option><option>In Progress</option><option>Waiting for User</option><option>Waiting for Vendor</option><option>Resolved</option></select></div>
            <div><label>Priority</label><select id="hd-queue-priority" class="form-control" onchange="Helpdesk.loadQueue()"><option value="">All priorities</option><option>Critical</option><option>High</option><option>Medium</option><option>Low</option></select></div>
        </div>
        <div class="hd-table-wrap"><table class="hd-table"><thead><tr><th>Ticket</th><th>Category / subject</th><th>Priority</th><th>Status</th><th>SLA</th><th>Assigned to</th><th></th></tr></thead><tbody id="hd-queue"></tbody></table></div>
    </section>
</div>
</asp:Content>
