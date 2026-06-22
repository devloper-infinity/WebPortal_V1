<%@ Page Title="" Language="C#" MasterPageFile="~/CRM/CRM.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="WebPortal.CRM.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="crm-page" data-crm-page="reports">
        <div class="crm-module-header">
            <div>
                <span class="crm-eyebrow">Sales intelligence</span>
                <h1>Reports</h1>
                <p>Pipeline health, lead conversion, owner activity, overdue follow-ups, and forecast movement.</p>
            </div>
            <button type="button" class="btn btn-outline-primary" id="crmRefreshReports"><i class="fas fa-sync"></i> Refresh</button>
        </div>
        <div class="crm-report-grid">
            <section class="crm-panel">
                <div class="crm-panel-head">
                    <div>
                        <h2>Forecast</h2>
                        <p>Weighted open pipeline by stage.</p>
                    </div>
                </div>
                <div class="crm-metric-stack" id="crmForecastReport"></div>
            </section>
            <section class="crm-panel">
                <div class="crm-panel-head">
                    <div>
                        <h2>Lead funnel</h2>
                        <p>Lead status distribution and conversion flow.</p>
                    </div>
                </div>
                <div class="crm-metric-stack" id="crmLeadFunnelReport"></div>
            </section>
            <section class="crm-panel crm-panel-wide">
                <div class="crm-panel-head">
                    <div>
                        <h2>Owner activity</h2>
                        <p>Follow-ups, overdue items, and recent customer touches by owner.</p>
                    </div>
                </div>
                <div class="crm-table-wrap">
                    <table class="table table-sm table-hover crm-table" id="crmOwnerActivityReport">
                        <thead>
                            <tr>
                                <th>Owner</th>
                                <th>Open leads</th>
                                <th>Open deals</th>
                                <th>Due activities</th>
                                <th>Overdue</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </section>
        </div>
    </div>
</asp:Content>
