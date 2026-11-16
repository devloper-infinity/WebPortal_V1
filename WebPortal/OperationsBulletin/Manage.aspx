<%@ Page Title="Create Bulletin & Teams" Language="C#" MasterPageFile="~/OperationsBulletin/OperationsBulletin.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="WebPortal.OperationsBulletin.Manage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link href="Bulletin.css?v=2" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="obLoading">
        <div class="spinner-border text-primary"></div>
        <span>Working...</span></div>
    <div class="ob-shell">
        <header class="ob-header">
            <div>
                <h1>Create Bulletin & Teams</h1>
                <p>Underwriting-Servicing communication setup</p>
            </div>
            <a href="Dashboard.aspx" class="btn btn-light">Back</a></header>
        <nav class="ob-nav nav nav-pills"><a class="nav-link active" data-toggle="pill" href="#createBulletin">Create Bulletin</a><a class="nav-link" data-toggle="pill" href="#manageTeams">Manage Teams</a></nav>
        <div class="tab-content">
            <section id="createBulletin" class="tab-pane fade show active">
                <div class="ob-panel">
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label>Title</label><input id="bTitle" class="form-control" maxlength="250"></div>
                    </div>
                    <input id="bCategory" type="hidden" value="Operations">
                    <input id="bPriority" type="hidden" value="Normal">
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label>Issue Date</label><input id="bSchedule" type="datetime-local" class="form-control"></div>
                        <div class="form-group col-md-4">
                            <label>Folder</label><select id="bFolder" class="form-control"></select></div>
                        <div class="form-group col-md-4">
                            <label>Teams</label><select id="bTeams" class="form-control" multiple></select></div>
                    </div>
                    <div class="form-group">
                        <label>Summary</label><div id="bSummary" class="form-control ob-rich-summary" contenteditable="true" data-placeholder="Paste or enter formatted bulletin content"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Word/PDF Attachment</label><input id="bFile" type="file" accept=".docx,.pdf" class="form-control-file"></div>
                        <div class="form-group col-md-6 pt-4">
                            <label>
                                <input id="bAck" type="checkbox">
                                Acknowledgement required</label></div>
                    </div>
                    <button type="button" id="saveDraft" class="btn btn-secondary">Save Draft</button>
                    <button type="button" id="publish" class="btn btn-primary">Publish / Schedule</button>
                </div>
            </section>
            <section id="manageTeams" class="tab-pane fade">
                <div class="ob-panel">
                    <h5>Create / Edit Team</h5>
                    <input id="tId" type="hidden"><div class="form-row">
                        <div class="form-group col-md-4">
                            <label>Team Name</label><input id="tName" class="form-control" maxlength="150"></div>
                        <div class="form-group col-md-4">
                            <label>Domain</label><select id="tDomain" class="form-control"></select></div>
                        <div class="form-group col-md-4">
                            <label>Subdomain</label><select id="tSubdomain" class="form-control"></select></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label>Location</label><select id="tLocation" class="form-control"></select></div>
                        <div class="form-group col-md-6">
                            <label>Project</label><select id="tProject" class="form-control"></select></div>
                    </div>
                    <label>Team Members</label><div class="form-row align-items-center">
                        <div class="col-md-5">
                            <input id="employeeSearch" class="form-control mb-2" placeholder="Search available employees"><label>Available</label><select id="tAvailable" class="form-control" multiple size="10"></select></div>
                        <div class="col-md-2 text-center">
                            <button type="button" id="addMembers" class="btn btn-outline-primary btn-block mb-2">Add &gt;</button>
                            <button type="button" id="removeMembers" class="btn btn-outline-secondary btn-block">&lt; Remove</button></div>
                        <div class="col-md-5">
                            <label>Selected Team Members</label><select id="tMembers" class="form-control" multiple size="12"></select></div>
                    </div>
                    <div class="mt-3">
                        <button type="button" id="saveTeam" class="btn btn-primary">Save Team</button>
                        <button type="button" id="cancelTeam" class="btn btn-light">Cancel</button></div>
                    <hr>
                    <table id="teamTable" class="table table-striped table-bordered w-100"></table>
                </div>
            </section>
        </div>
    </div>
    <div id="teamMembersModal" class="modal fade">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="teamMembersTitle" class="modal-title">Team Members</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button></div>
                <div class="modal-body">
                    <table id="teamMembersTable" class="table table-striped table-bordered w-100"></table>
                </div>
            </div>
        </div>
    </div>
    <script src="Manage.js?v=6"></script>
</asp:Content>
