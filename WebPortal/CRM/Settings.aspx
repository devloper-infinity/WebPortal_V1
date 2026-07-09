<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="WebPortal.CRM.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="settings">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">CRM automation</span>
                <h1>Settings</h1>
                <p>Email accounts, templates, notifications, assignment rules, SLA policies, and automation queue control.</p>
            </div>
            <div class="crm-header-actions">
                <button type="button" class="btn btn-outline-primary" id="crmRunAutomationNow"><i class="fas fa-play"></i> Run now</button>
                <button type="button" class="btn btn-outline-primary" id="crmRefreshAutomation"><i class="fas fa-sync"></i> Refresh</button>
            </div>
        </div>

        <div class="crm-settings-tabs">
            <button type="button" class="crm-tab-btn active" data-crm-tab="email"><i class="fas fa-envelope"></i> Email</button>
            <button type="button" class="crm-tab-btn" data-crm-tab="notifications"><i class="fas fa-bell"></i> Notifications</button>
            <button type="button" class="crm-tab-btn" data-crm-tab="templates"><i class="fas fa-file-alt"></i> Templates</button>
            <button type="button" class="crm-tab-btn" data-crm-tab="assignment"><i class="fas fa-route"></i> Assignment</button>
            <button type="button" class="crm-tab-btn" data-crm-tab="sla"><i class="fas fa-stopwatch"></i> SLA</button>
            <button type="button" class="crm-tab-btn" data-crm-tab="queue"><i class="fas fa-paper-plane"></i> Queue</button>
        </div>

        <section class="crm-panel crm-settings-panel active" data-crm-panel="email">
            <div class="crm-panel-head">
                <div>
                    <h2>Outgoing email</h2>
                    <p>Default sender and SMTP account for automated CRM messages.</p>
                </div>
                <button type="button" class="btn btn-primary crm-save-settings" data-settings-type="EmailSettings"><i class="fas fa-save"></i> Save</button>
            </div>
            <div class="crm-editor-grid" id="crmEmailSettingsForm">
                <input type="hidden" name="EmailAccountID" value="0" />
                <div class="crm-field wide"><label>Account name</label><input type="text" class="form-control" name="AccountName" /></div>
                <div class="crm-field"><label>Send queued emails</label><select class="form-control" name="AutoSendEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Account active</label><select class="form-control" name="IsEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field wide"><label>From email</label><input type="email" class="form-control" name="FromEmail" /></div>
                <div class="crm-field"><label>From name</label><input type="text" class="form-control" name="FromName" /></div>
                <div class="crm-field"><label>Reply-to email</label><input type="email" class="form-control" name="ReplyToEmail" /></div>
                <div class="crm-field wide"><label>SMTP host</label><input type="text" class="form-control" name="SmtpHost" /></div>
                <div class="crm-field"><label>SMTP port</label><input type="number" class="form-control" name="SmtpPort" /></div>
                <div class="crm-field"><label>SSL</label><select class="form-control" name="EnableSSL"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field wide"><label>SMTP username</label><input type="text" class="form-control" name="SmtpUserName" autocomplete="off" /></div>
                <div class="crm-field wide"><label>SMTP password</label><input type="password" class="form-control" name="SmtpPassword" autocomplete="new-password" /></div>
            </div>
        </section>

        <section class="crm-panel crm-settings-panel" data-crm-panel="notifications">
            <div class="crm-panel-head">
                <div>
                    <h2>Notification rules</h2>
                    <p>In-app and email alerts for CRM activity.</p>
                </div>
                <button type="button" class="btn btn-primary crm-save-settings" data-settings-type="NotificationSettings"><i class="fas fa-save"></i> Save</button>
            </div>
            <div class="crm-editor-grid" id="crmNotificationSettingsForm">
                <input type="hidden" name="PreferenceID" value="0" />
                <div class="crm-field"><label>In-app alerts</label><select class="form-control" name="InAppEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Email alerts</label><select class="form-control" name="EmailEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Assignments</label><select class="form-control" name="AssignmentEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Mentions</label><select class="form-control" name="MentionEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Due activities</label><select class="form-control" name="DueActivityEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>SLA alerts</label><select class="form-control" name="OverdueSLAEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Daily digest</label><select class="form-control" name="DailyDigestEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field"><label>Digest time</label><input type="time" class="form-control" name="DigestTime" /></div>
            </div>
        </section>

        <section class="crm-panel crm-settings-panel" data-crm-panel="templates">
            <div class="crm-panel-head">
                <div>
                    <h2>Email templates</h2>
                    <p>Reusable messages for lead, deal, activity, and SLA events.</p>
                </div>
                <button type="button" class="btn btn-primary crm-save-automation" data-settings-type="EmailTemplate"><i class="fas fa-save"></i> Save template</button>
            </div>
            <div class="crm-editor-grid" id="crmEmailTemplateForm">
                <input type="hidden" name="TemplateID" value="0" />
                <div class="crm-field"><label>Template name</label><input type="text" class="form-control" name="TemplateName" /></div>
                <div class="crm-field"><label>Trigger</label><select class="form-control" name="TriggerEvent"><option>Lead Saved</option><option>Deal Saved</option><option>Activity Due</option><option>SLA Breach</option><option>Daily Digest</option></select></div>
                <div class="crm-field"><label>Template active</label><select class="form-control" name="IsEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field full"><label>Subject</label><input type="text" class="form-control" name="Subject" /></div>
                <div class="crm-field full"><label>Body</label><textarea class="form-control" name="BodyHtml"></textarea></div>
            </div>
            <div class="crm-table-wrap mt-3">
                <table class="table table-sm table-hover crm-table" id="crmTemplateTable">
                    <thead><tr><th>Name</th><th>Trigger</th><th>Subject</th><th>Status</th><th></th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>

        <section class="crm-panel crm-settings-panel" data-crm-panel="assignment">
            <div class="crm-panel-head">
                <div>
                    <h2>Assignment rules</h2>
                    <p>Route leads and deals by condition, rotation, or workload.</p>
                </div>
                <button type="button" class="btn btn-primary crm-save-automation" data-settings-type="AssignmentRule"><i class="fas fa-save"></i> Save rule</button>
            </div>
            <div class="crm-editor-grid" id="crmAssignmentRuleForm">
                <input type="hidden" name="RuleID" value="0" />
                <div class="crm-field"><label>Rule name</label><input type="text" class="form-control" name="RuleName" /></div>
                <div class="crm-field"><label>Apply on</label><select class="form-control" name="ApplyOn"><option>Lead</option><option>Deal</option></select></div>
                <div class="crm-field"><label>Routing</label><select class="form-control" name="RoutingMethod"><option>Auto-rotate</option><option>Least workload</option></select></div>
                <div class="crm-field"><label>Condition field</label><input type="text" class="form-control" name="ConditionField" /></div>
                <div class="crm-field"><label>Operator</label><select class="form-control" name="ConditionOperator"><option>equals</option><option>contains</option><option>greater than</option><option>less than</option><option>is empty</option></select></div>
                <div class="crm-field"><label>Condition value</label><input type="text" class="form-control" name="ConditionValue" /></div>
                <div class="crm-field wide"><label>User employee IDs</label><input type="text" class="form-control" name="UserEmployeeIDs" /></div>
                <div class="crm-field"><label>Active days</label><input type="text" class="form-control" name="ActiveDays" /></div>
                <div class="crm-field"><label>Priority</label><input type="number" class="form-control" name="Priority" /></div>
                <div class="crm-field"><label>Rule active</label><select class="form-control" name="IsEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field full"><label>Description</label><textarea class="form-control" name="Description"></textarea></div>
            </div>
            <div class="crm-table-wrap mt-3">
                <table class="table table-sm table-hover crm-table" id="crmAssignmentTable">
                    <thead><tr><th>Rule</th><th>Apply on</th><th>Condition</th><th>Routing</th><th>Status</th><th></th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>

        <section class="crm-panel crm-settings-panel" data-crm-panel="sla">
            <div class="crm-panel-head">
                <div>
                    <h2>SLA policies</h2>
                    <p>Response and follow-up targets for leads and deals.</p>
                </div>
                <button type="button" class="btn btn-primary crm-save-automation" data-settings-type="SlaPolicy"><i class="fas fa-save"></i> Save policy</button>
            </div>
            <div class="crm-editor-grid" id="crmSlaPolicyForm">
                <input type="hidden" name="SLAPolicyID" value="0" />
                <div class="crm-field"><label>Policy name</label><input type="text" class="form-control" name="PolicyName" /></div>
                <div class="crm-field"><label>Apply on</label><select class="form-control" name="ApplyOn"><option>Lead</option><option>Deal</option></select></div>
                <div class="crm-field"><label>First response minutes</label><input type="number" class="form-control" name="FirstResponseMinutes" /></div>
                <div class="crm-field"><label>Follow-up minutes</label><input type="number" class="form-control" name="FollowUpMinutes" /></div>
                <div class="crm-field"><label>Working start</label><input type="time" class="form-control" name="WorkingHourStart" /></div>
                <div class="crm-field"><label>Working end</label><input type="time" class="form-control" name="WorkingHourEnd" /></div>
                <div class="crm-field"><label>Default</label><select class="form-control" name="IsDefault"><option value="0">No</option><option value="1">Yes</option></select></div>
                <div class="crm-field"><label>Policy active</label><select class="form-control" name="IsEnabled"><option value="1">Enabled</option><option value="0">Disabled</option></select></div>
                <div class="crm-field full"><label>Conditions</label><textarea class="form-control" name="ConditionsText"></textarea></div>
            </div>
            <div class="crm-table-wrap mt-3">
                <table class="table table-sm table-hover crm-table" id="crmSlaTable">
                    <thead><tr><th>Policy</th><th>Apply on</th><th>First response</th><th>Follow-up</th><th>Status</th><th></th></tr></thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>

        <section class="crm-panel crm-settings-panel" data-crm-panel="queue">
            <div class="crm-panel-head">
                <div>
                    <h2>Automation queue</h2>
                    <p>Generated notifications and email outbox records.</p>
                </div>
                <button type="button" class="btn btn-outline-primary" id="crmMarkAllRead"><i class="fas fa-check-double"></i> Mark notifications read</button>
            </div>
            <div class="crm-dashboard-grid crm-settings-queue-grid">
                <div>
                    <h2 class="crm-subhead">Notifications</h2>
                    <div class="crm-mini-list" id="crmNotificationList"></div>
                </div>
                <div class="crm-panel-wide">
                    <h2 class="crm-subhead">Email outbox</h2>
                    <div class="crm-table-wrap">
                        <table class="table table-sm table-hover crm-table" id="crmOutboxTable">
                            <thead><tr><th>To</th><th>Subject</th><th>Related</th><th>Status</th><th>Created</th></tr></thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </div>
</asp:Content>
