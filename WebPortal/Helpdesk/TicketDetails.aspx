<%@ Page Title="Ticket Details" Language="C#" MasterPageFile="~/Helpdesk/IHMSPage.Master" AutoEventWireup="true" CodeBehind="TicketDetails.aspx.cs" Inherits="WebPortal.Helpdesk.TicketDetails" %>
<asp:Content ID="H" ContentPlaceHolderID="HelpdeskHead" runat="server">
  <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
  <link href="ticket-details.css?v=3" rel="stylesheet" />
</asp:Content>
<asp:Content ID="B" ContentPlaceHolderID="HelpdeskBody" runat="server">
  <div class="page-tools"><a href="MyTickets.aspx" class="btn btn-sm btn-outline-secondary"><i class="fas fa-arrow-left"></i> Back to tickets</a></div>
  <section id="ticket" class="ticket-summary panel"></section>
  <section class="panel action-panel">
    <div class="panel-title"><i class="fas fa-sliders-h"></i> Ticket actions <span id="lock" class="lock-note"><i class="fas fa-lock"></i> Locked pending approval</span></div>
    <div class="panel-body">
      <div class="action-grid">
        <div class="action-field action-type"><label>Request type</label><div class="input-action"><select id="type" class="form-control edit"></select><button type="button" class="btn btn-primary edit" onclick="changeType()">Update</button></div></div>
        <div class="action-field action-person"><label>Assign / reassign</label><div class="input-action"><select id="assign" class="form-control employee-select edit"></select><button type="button" class="btn btn-primary edit" onclick="assignTicket()">Assign</button></div></div>
        <div class="action-field action-status"><label>Status</label><div class="input-action"><select id="status" class="form-control edit"></select><button type="button" class="btn btn-primary edit" onclick="transition()">Update</button></div></div>
        <div class="action-field action-branch"><label>Branch / location</label><div class="input-action"><select id="branch" class="form-control employee-select edit"></select><button type="button" class="btn btn-primary edit" onclick="changeLocation()">Update</button></div></div>
        <div class="action-field action-approver"><label>Approver</label><div class="input-action"><select id="approver" class="form-control employee-select edit"></select><button type="button" class="btn btn-secondary edit" onclick="approval()">Send</button></div></div>
      </div>
      <div class="quick-row">
        <div class="remark-box"><label>Remark / internal note</label><textarea id="remark" rows="2" class="form-control edit" placeholder="Enter an update..."></textarea></div>
        <div class="quick-buttons"><button type="button" class="btn btn-info edit" onclick="addRemark(false)"><i class="far fa-comment"></i> Public remark</button><button type="button" class="btn btn-warning edit" onclick="addRemark(true)"><i class="fas fa-user-shield"></i> Internal note</button></div>
        <form id="upload" class="upload-box"><label>Attachment</label><input type="file" name="file" class="form-control-file edit" /><div><label class="internal-check"><input type="checkbox" name="internalNote" value="true" class="edit" /> IT-only</label><button type="submit" class="btn btn-outline-primary btn-sm edit">Upload</button></div></form>
      </div>
    </div>
  </section>
  <div class="detail-columns">
    <section class="panel timeline-panel"><div class="panel-title"><i class="fas fa-history"></i> Activity timeline</div><div class="panel-body"><div id="timeline" class="timeline"></div></div></section>
    <section class="panel attachment-panel"><div class="panel-title"><i class="fas fa-paperclip"></i> Attachments</div><div id="attachments" class="panel-body"></div></section>
  </div>
</asp:Content>
<asp:Content ID="S" ContentPlaceHolderID="HelpdeskScripts" runat="server">
  <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
  <script src="ticket-details.js?v=6"></script>
</asp:Content>
