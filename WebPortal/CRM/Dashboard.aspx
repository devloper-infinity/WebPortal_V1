<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebPortal.CRM.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="dashboard">
        <div class="crm-hero">
            <div>
                <span class="crm-eyebrow">CRM workspace</span>
                <h1>Sales command center</h1>
                <p>Lead capture, deal pipeline, customer follow-ups, account history, and sales activity in one operating view.</p>
            </div>
            <div class="crm-hero-actions">
                <a href="Leads.aspx" class="btn btn-light"><i class="fas fa-plus-circle"></i> New lead</a>
                <a href="Deals.aspx" class="btn btn-outline-light"><i class="fas fa-stream"></i> Pipeline</a>
            </div>
        </div>

        <div class="crm-kpi-grid" id="crmKpiGrid">
            <div class="crm-kpi"><span>Open leads</span><strong data-kpi="OpenLeads">0</strong><small>Ready for qualification</small></div>
            <div class="crm-kpi"><span>Won this month</span><strong data-kpi="WonDeals">0</strong><small>Closed business</small></div>
            <div class="crm-kpi"><span>Pipeline value</span><strong data-kpi="PipelineValue">0</strong><small>Weighted open value</small></div>
            <div class="crm-kpi"><span>Due activities</span><strong data-kpi="DueActivities">0</strong><small>Calls, meetings, tasks</small></div>
        </div>

        <div class="crm-dashboard-grid">
            <section class="crm-panel crm-panel-wide">
                <div class="crm-panel-head">
                    <div>
                        <h2>Pipeline by stage</h2>
                        <p>Open deals grouped by current sales stage.</p>
                    </div>
                    <a href="Deals.aspx" class="crm-link">View deals</a>
                </div>
                <div class="crm-pipeline" id="crmPipelineSummary"></div>
            </section>

            <section class="crm-panel">
                <div class="crm-panel-head">
                    <div>
                        <h2>Today</h2>
                        <p>Work that needs attention.</p>
                    </div>
                    <a href="Activities.aspx" class="crm-link">Open queue</a>
                </div>
                <div class="crm-mini-list" id="crmTodayList"></div>
            </section>

            <section class="crm-panel">
                <div class="crm-panel-head">
                    <div>
                        <h2>Fresh leads</h2>
                        <p>Newest prospects assigned to the team.</p>
                    </div>
                    <a href="Leads.aspx" class="crm-link">Manage</a>
                </div>
                <div class="crm-mini-list" id="crmFreshLeads"></div>
            </section>

            <section class="crm-panel crm-panel-wide">
                <div class="crm-panel-head">
                    <div>
                        <h2>Recently touched customers</h2>
                        <p>Latest account and contact movement.</p>
                    </div>
                    <a href="Contacts.aspx" class="crm-link">View contacts</a>
                </div>
                <div class="crm-table-wrap">
                    <table class="table table-sm table-hover crm-table" id="crmRecentTable">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Name</th>
                                <th>Owner</th>
                                <th>Status</th>
                                <th>Updated</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </section>
        </div>
    </div>
</asp:Content>
