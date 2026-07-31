<%@ Page Title="Helpdesk Administration" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="Administration.aspx.cs" Inherits="WebPortal.Helpdesk.Administration" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/Helpdesk.css?v=1" rel="stylesheet" /><script src="../Scripts/Functions/HelpdeskModule.js?v=1"></script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="hd-shell" data-helpdesk-page="administration">
    <div class="hd-header"><div><h2>Helpdesk Administration</h2><p>Configure service categories, SLA targets, and support roles.</p></div><div class="hd-nav"><a href="Home.aspx">Requester portal</a><a href="Workbench.aspx">IT workbench</a><a class="active" href="Administration.aspx">Administration</a></div></div>
    <div id="hd-alert" class="hd-alert"></div>
    <div class="hd-grid">
        <section class="hd-card hd-span-12"><h4>Categories and approval routing</h4>
            <input type="hidden" id="hd-category-id" value="0" /><div class="hd-form">
                <div class="hd-field"><label>Category</label><input id="hd-admin-category-name" class="form-control" /></div>
                <div class="hd-field"><label>Department name</label><input id="hd-admin-department-name" class="form-control" value="IT" /></div>
                <div class="hd-field"><label>Department ID</label><input id="hd-admin-department-id" type="number" class="form-control" value="7" /></div>
                <div class="hd-field"><label>Default priority</label><select id="hd-admin-category-priority" class="form-control"><option>Low</option><option selected>Medium</option><option>High</option><option>Critical</option></select></div>
                <div class="hd-field"><label>Approval</label><select id="hd-admin-approval-mode" class="form-control"><option>None</option><option>Manager</option><option>Specific</option></select></div>
                <div class="hd-field"><label>Specific approver Employee ID</label><input id="hd-admin-approver" type="number" class="form-control" value="0" /></div>
            </div><div class="hd-actions"><label><input id="hd-admin-category-active" type="checkbox" checked /> Active</label><button class="hd-btn hd-btn-primary" onclick="Helpdesk.saveCategory()">Save category</button></div>
            <div class="hd-table-wrap"><table class="hd-table"><thead><tr><th>Category</th><th>Department</th><th>Default priority</th><th>Approval</th><th>Approver</th><th>Active</th><th></th></tr></thead><tbody id="hd-admin-categories"></tbody></table></div></section>
        <section class="hd-card hd-span-5"><h4>SLA policies</h4>
            <input type="hidden" id="hd-sla-id" value="0" /><div class="hd-form">
                <div class="hd-field full"><label>Policy name</label><input id="hd-sla-name" class="form-control" /></div>
                <div class="hd-field"><label>Priority</label><select id="hd-sla-priority" class="form-control"><option>Low</option><option>Medium</option><option>High</option><option>Critical</option></select></div>
                <div class="hd-field"><label>First response minutes</label><input id="hd-sla-response" type="number" class="form-control" /></div>
                <div class="hd-field"><label>Resolution minutes</label><input id="hd-sla-resolution" type="number" class="form-control" /></div>
            </div><div class="hd-actions"><label><input id="hd-sla-active" type="checkbox" checked /> Active</label><button class="hd-btn hd-btn-primary" onclick="Helpdesk.saveSla()">Save SLA</button></div>
            <div class="hd-table-wrap"><table class="hd-table"><thead><tr><th>Priority</th><th>Response</th><th>Resolution</th><th>Active</th><th></th></tr></thead><tbody id="hd-admin-sla"></tbody></table></div></section>
        <section class="hd-card hd-span-7"><h4>Agents and roles</h4>
            <input type="hidden" id="hd-agent-id" value="0" /><div class="hd-form">
                <div class="hd-field"><label>Employee ID</label><input id="hd-agent-employee" type="number" class="form-control" /></div>
                <div class="hd-field"><label>Display name</label><input id="hd-agent-name" class="form-control" /></div>
                <div class="hd-field"><label>Department ID (0 for all)</label><input id="hd-agent-department" type="number" class="form-control" value="7" /></div>
                <div class="hd-field"><label>Role</label><select id="hd-agent-role" class="form-control"><option>Agent</option><option>Supervisor</option><option>Admin</option></select></div>
            </div><div class="hd-actions"><label><input id="hd-agent-active" type="checkbox" checked /> Active</label><button class="hd-btn hd-btn-primary" onclick="Helpdesk.saveAgent()">Save agent</button></div>
            <div class="hd-table-wrap"><table class="hd-table"><thead><tr><th>Employee</th><th>Name</th><th>Department</th><th>Role</th><th>Active</th><th></th></tr></thead><tbody id="hd-admin-agents"></tbody></table></div></section>
    </div>
</div>
</asp:Content>
