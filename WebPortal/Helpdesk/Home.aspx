<%@ Page Title="Helpdesk" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="WebPortal.Helpdesk.Home" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/Helpdesk.css?v=1" rel="stylesheet" />
    <script src="../Scripts/Functions/HelpdeskModule.js?v=1"></script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="hd-shell" data-helpdesk-page="home">
    <div class="hd-header">
        <div><h2>Helpdesk</h2><p>Raise a request, follow progress, and confirm resolution.</p></div>
        <div class="hd-nav"><a class="active" href="Home.aspx">My tickets</a><a id="hd-workbench-link" style="display:none" href="Workbench.aspx">IT workbench</a><a id="hd-admin-link" style="display:none" href="Administration.aspx">Administration</a></div>
    </div>
    <div id="hd-alert" class="hd-alert"></div>
    <div class="hd-grid">
        <section class="hd-card hd-span-5">
            <h4>Raise a ticket</h4>
            <div class="hd-form">
                <div class="hd-field full"><label>Category *</label><select id="hd-category" class="form-control"><option value="">Select category</option></select></div>
                <div class="hd-field full"><label>Subject *</label><input id="hd-subject" maxlength="300" class="form-control" /></div>
                <div class="hd-field"><label>Impact *</label><select id="hd-impact" class="form-control"><option>Individual</option><option>Team</option><option>Department</option><option>Company</option></select></div>
                <div class="hd-field"><label>Urgency *</label><select id="hd-urgency" class="form-control"><option>Low</option><option selected>Medium</option><option>High</option><option>Critical</option></select></div>
                <div class="hd-field"><label>Location / desk</label><input id="hd-location" maxlength="150" class="form-control" /></div>
                <div class="hd-field"><label>Asset reference</label><input id="hd-asset" maxlength="150" class="form-control" placeholder="Asset tag, hostname..." /></div>
                <div class="hd-field full"><label>Description *</label><textarea id="hd-description" class="form-control" placeholder="What happened, when it started, and any error message"></textarea></div>
            </div>
            <div class="hd-actions"><button type="button" class="hd-btn hd-btn-primary" onclick="Helpdesk.createTicket()">Submit ticket</button></div>
        </section>
        <section class="hd-card hd-span-7">
            <h4>My tickets</h4>
            <div class="hd-filter"><div><label>Status</label><select id="hd-my-status" class="form-control" onchange="Helpdesk.loadMyTickets()"><option value="">All</option><option>New</option><option>Pending Approval</option><option>Assigned</option><option>In Progress</option><option>Waiting for User</option><option>Resolved</option><option>Closed</option></select></div></div>
            <div class="hd-table-wrap"><table class="hd-table"><thead><tr><th>Ticket</th><th>Subject</th><th>Priority</th><th>Status</th><th>Updated</th></tr></thead><tbody id="hd-my-tickets"></tbody></table></div>
        </section>
    </div>
</div>
</asp:Content>
