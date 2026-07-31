<%@ Page Title="Helpdesk Ticket" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="Ticket.aspx.cs" Inherits="WebPortal.Helpdesk.Ticket" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/Helpdesk.css?v=1" rel="stylesheet" /><script src="../Scripts/Functions/HelpdeskModule.js?v=1"></script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="hd-shell" data-helpdesk-page="ticket">
    <div class="hd-header"><div><h2 id="hd-ticket-title">Ticket</h2><p id="hd-ticket-subject">Loading...</p></div><div class="hd-nav"><a href="Home.aspx">My tickets</a><a id="hd-ticket-workbench" style="display:none" href="Workbench.aspx">IT workbench</a></div></div>
    <div id="hd-alert" class="hd-alert"></div>
    <div class="hd-grid">
        <section class="hd-card hd-span-8">
            <div id="hd-ticket-meta" class="hd-ticket-meta"></div>
            <hr /><h4>Description</h4><div id="hd-ticket-description"></div>
            <hr /><h4>Conversation</h4><div id="hd-messages"></div>
            <div class="hd-field"><label>Reply</label><textarea id="hd-reply" class="form-control"></textarea></div>
            <label id="hd-internal-wrap" style="display:none;margin-top:8px"><input type="checkbox" id="hd-internal" /> Internal note (hidden from requester)</label>
            <div class="hd-actions"><button type="button" class="hd-btn hd-btn-primary" onclick="Helpdesk.addMessage()">Add reply</button></div>
        </section>
        <aside class="hd-span-4">
            <section class="hd-card" id="hd-actions-card"><h4>Actions</h4><div id="hd-ticket-actions"></div></section>
            <section class="hd-card" style="margin-top:16px"><h4>Audit timeline</h4><div id="hd-audit" class="hd-timeline"></div></section>
        </aside>
    </div>
</div>
</asp:Content>
