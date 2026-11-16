<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="TeamMeetingReport.aspx.cs" Inherits="WebPortal.Admin.TeamMeetingReport" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css" />
    <link rel="stylesheet" href="TeamMeeting.css?v=1" />
    <link rel="stylesheet" href="TeamMeetingTheme.css?v=1" />
</asp:Content>
<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <main class="tmm-page">
        <div class="tmm-shell">
            <section class="tmm-card">
                <div class="tmm-body">
                    <header class="tmm-header">
                        <div>
                            <h1>Team Meeting History &amp; Reporting</h1>
                            <p>Search meeting history without duplicate meeting counts</p>
                        </div>
                        <button class="tmm-btn tmm-btn-primary" id="trExport" type="button"><i class="fas fa-file-excel"></i>Export Excel</button></header>
                    <div id="tmmMessage" class="tmm-message"></div>
                    <section class="tmm-section">
                        <div class="tmm-toolbar">
                            <div class="tmm-field">
                                <label class="tmm-label">From Date</label><input id="trFrom" type="date" class="tmm-control" /></div>
                            <div class="tmm-field">
                                <label class="tmm-label">To Date</label><input id="trTo" type="date" class="tmm-control" /></div>
                            <div class="tmm-field">
                                <label class="tmm-label">Meeting Type</label><select id="trType" class="tmm-control"><option value="">All</option>
                                    <option>Daily Meeting</option>
                                    <option>Weekly Meeting</option>
                                </select></div>
                            <div class="tmm-field">
                                <label class="tmm-label">Host</label><select id="trHost" class="tmm-control"></select></div>
                            <div class="tmm-field">
                                <label class="tmm-label">Team</label><select id="trTeam" class="tmm-control"></select></div>
                            <button class="tmm-btn tmm-btn-dark" id="trSearch" type="button">Search</button></div>
                    </section>
                    <section class="tmm-section">
                        <div class="tmm-table-wrap">
                            <table id="trTable" class="tmm-table">
                                <thead>
                                    <tr>
                                        <th>Date / Time</th>
                                        <th>Type</th>
                                        <th>Host</th>
                                        <th>Teams</th>
                                        <th>Channel</th>
                                        <th>Attendance</th>
                                        <th>Outcomes</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </section>
                </div>
            </section>
        </div>
    </main>
    <div id="tmmLoading" class="tmm-loading"><span class="tmm-spinner"></span></div>
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <script src="TeamMeetingReport.js?v=1"></script>
</asp:Content>
