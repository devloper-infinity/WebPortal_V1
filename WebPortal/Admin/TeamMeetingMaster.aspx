<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="TeamMeetingMaster.aspx.cs" Inherits="WebPortal.Admin.TeamMeetingMaster" %>

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
                            <h1>Team Meeting Management</h1>
                            <p>Record daily and weekly team meetings</p>
                        </div>
                        <button type="button" class="tmm-btn tmm-btn-primary" id="tmmNew">New Meeting</button></header>
                    <div id="tmmMessage" class="tmm-message"></div>
                    <section class="tmm-section">
                        <h2>Meeting Details</h2>
                        <input type="hidden" id="tmmMeetingId" value="0" /><input type="hidden" id="tmmRowVersion" />
                        <div class="tmm-row">
                            <div class="tmm-field">
                                <label class="tmm-label">Meeting Host <span class="tmm-required">*</span></label><select id="tmmHost" class="tmm-control"></select></div>
                            <div class="tmm-field">
                                <label class="tmm-label">Meeting Type <span class="tmm-required">*</span></label><select id="tmmType" class="tmm-control"><option value="">Select...</option>
                                    <option>Daily Meeting</option>
                                    <option>Weekly Meeting</option>
                                </select></div>
                        </div>
                        <div class="tmm-field">
                            <label class="tmm-label">Teams Included <span class="tmm-required">*</span></label><div id="tmmTeams" class="tmm-checks"></div>
                        </div>
                        <div class="tmm-row">
                            <div class="tmm-field">
                                <label class="tmm-label">Meeting Date <span class="tmm-required">*</span></label><input id="tmmDate" type="date" class="tmm-control" /></div>
                            <div class="tmm-field">
                                <label class="tmm-label">Meeting Time <span class="tmm-required">*</span></label><input id="tmmTime" type="time" class="tmm-control" /></div>
                        </div>
                        <div class="tmm-field">
                            <label class="tmm-label">Meeting Channel <span class="tmm-required">*</span></label><div class="tmm-radios">
                                <label class="tmm-radio">
                                    <input type="radio" name="tmmChannel" value="Teams" />Teams</label><label class="tmm-radio"><input type="radio" name="tmmChannel" value="In-Person" />In-Person</label><label class="tmm-radio"><input type="radio" name="tmmChannel" value="Other" />Other</label><input id="tmmOtherChannel" class="tmm-control" maxlength="100" placeholder="Specify other channel" style="display: none; max-width: 250px; height: 34px" /></div>
                        </div>
                        <div class="tmm-field">
                            <label class="tmm-label">Meeting Agenda <span class="tmm-required">*</span></label><textarea id="tmmAgenda" class="tmm-control" maxlength="4000" placeholder="Enter meeting agenda and discussion points..."></textarea></div>
                    </section>
                    <section class="tmm-section">
                        <h2>Attendance &amp; Outcomes</h2>
                        <div class="tmm-attendance-head">
                            <label class="tmm-label">Meeting Attendance <span class="tmm-required">*</span></label><div style="display: flex; gap: 8px; align-items: center">
                                <select id="tmmManualEmployee" class="tmm-control" style="display: none; width: 260px"></select>
                                <button type="button" class="tmm-btn" id="tmmAddEmployees"><i class="fas fa-user-plus"></i>Add Employees</button></div>
                        </div>0
                        <div id="tmmAttendance" class="tmm-attendance">
                            <div class="tmm-empty">Employee selection will be populated from the selected teams, with an option to mark Present or Absent.</div>
                        </div>
                        <div class="tmm-field" style="margin-top: 14px">
                            <label class="tmm-label">Meeting Conclusion / Key Outcomes <span class="tmm-required">*</span></label><textarea id="tmmConclusion" class="tmm-control" maxlength="4000" placeholder="Summarize decisions, conclusions and outcomes..."></textarea></div>
                        <div class="tmm-field">
                            <div class="tmm-attendance-head">
                                <label class="tmm-label">Action Items (Optional)</label>
                                <button type="button" class="tmm-btn" id="tmmAddAction"><i class="fas fa-plus"></i>Add Item</button></div>
                            <div id="tmmActions">
                                <div class="tmm-empty">Enter follow-up actions...</div>
                            </div>
                        </div>
                        <div class="tmm-field" style="max-width: 420px; margin-left: auto">
                            <label class="tmm-label">Test Email (Optional)</label><input id="tmmTestEmail" type="email" class="tmm-control" maxlength="250" placeholder="Overrides recipients for testing only" /></div>
                    </section>
                    <div class="tmm-actions">
                        <button type="button" class="tmm-btn" id="tmmCancel">Cancel</button>
                        <button type="button" class="tmm-btn tmm-btn-dark" id="tmmSave"><i class="far fa-save"></i>Save Meeting</button></div>
                </div>
            </section>
        </div>
    </main>
    <div id="tmmLoading" class="tmm-loading"><span class="tmm-spinner"></span></div>
    <script src="TeamMeeting.js?v=1"></script>
</asp:Content>
