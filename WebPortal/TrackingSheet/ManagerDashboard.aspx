<%@ Page Title="Tracking Manager Dashboard" Language="C#" MasterPageFile="~/TrackingSheet/TrackingSheetMaster.Master" AutoEventWireup="true" CodeBehind="ManagerDashboard.aspx.cs" Inherits="WebPortal.TrackingSheet.ManagerDashboardPage" %>

<asp:Content ID="Head" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="OLTracking.css" />
    <style>
    .mgr-tabs {
        display: flex;
        gap: 6px;
        margin: 15px 0;
        border-bottom: 1px solid #d7e2ee
    }

    .mgr-tab {
        padding: 11px 17px;
        border: 0;
        border-bottom: 3px solid transparent;
        background: transparent;
        color: #496078;
        font-weight: 800;
        cursor: pointer
    }

        .mgr-tab.active {
            border-bottom-color: #0f6b8f;
            color: #0f6b8f
        }

    .mgr-panel {
        display: none
    }

        .mgr-panel.active {
            display: block
        }

    .mgr-kpis {
        display: grid;
        grid-template-columns: repeat(5,1fr);
        gap: 12px;
        margin: 14px 0
    }

    .mgr-kpi {
        padding: 14px;
        border: 1px solid #d7e2ee;
        border-radius: 7px;
        background: #fff
    }

        .mgr-kpi span {
            display: block;
            color: #64748b;
            font-size: 12px
        }

        .mgr-kpi strong {
            font-size: 25px;
            color: #0f6b8f
        }

    .mgr-section {
        margin-top: 15px
    }

    .mgr-duration {
        font-variant-numeric: tabular-nums
    }

    .mgr-orders {
        margin-top: 14px
    }

    .mgr-select {
        width: 17px;
        height: 17px
    }

    .ol-message {
        display: block;
        margin: 0 0 18px;
        padding: 12px 16px;
        border-radius: 6px;
        font-weight: 600;
    }

    .ol-success {
        background: #e8f7ef;
        color: #176b41;
        border: 1px solid #a8dfc1;
    }

    .ol-error {
        background: #fff0f0;
        color: #9f2424;
        border: 1px solid #efb8b8;
        white-space: pre-line;
    }

    .import-button-wrap {
        /*justify-content: flex-end;*/
    }

    .olt-field input.import-action-button {
        width: auto;
        min-height: 40px;
        padding: 8px 16px;
        border-radius: 8px;
        color: #fff;
        font-weight: 700;
        cursor: pointer;
    }

    .olt-field input.import-download-button {
        border-color: #11c7b7;
        background: linear-gradient(90deg,#00c7b1,#82dcd7);
        box-shadow: 0 8px 18px rgba(17,199,183,.22);
    }

    .olt-field input.import-upload-button {
        border-color: #28a745;
        background: #28a745;
    }

    .pma-loans {
        display: grid;
        grid-template-columns: repeat(3,1fr);
        gap: 9px;
        margin-top: 10px
    }

    .pma-loan {
        display: flex;
        gap: 8px;
        align-items: center;
        padding: 10px;
        border: 1px solid #d7e2ee;
        border-radius: 6px
    }

        .pma-loan input {
            width: 17px;
            height: 17px
        }

    .pma-user-note {
        margin-top: 6px;
        color: #64748b;
        font-size: 12px
    }

    @media(max-width:900px) {
        .mgr-kpis {
            grid-template-columns: repeat(2,1fr)
        }

        .mgr-tabs {
            overflow: auto
        }
    }

    @media(max-width:800px) {
        .pma-loans {
            grid-template-columns: 1fr
        }
    }

    .olt-table-wrap {
        padding: 1%;
    }
    .mgr-kpis.extended { grid-template-columns:repeat(5,minmax(130px,1fr)); }
    .mgr-charts { display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;margin:18px 0; }
    .mgr-chart { min-height:330px;padding:16px;background:#fff;border:1px solid #d7e2ee;border-radius:10px; }
    .mgr-chart h4 { margin:0 0 12px;color:#17324d;font-size:15px; }
    .mgr-chart canvas { width:100%!important;height:270px!important; }
    @media(max-width:1000px) { .mgr-kpis.extended { grid-template-columns:repeat(2,1fr); } .mgr-charts { grid-template-columns:1fr; } }

    .snd-filter { border-top:4px solid #173b61; }
    .snd-title { display:flex;align-items:center;justify-content:space-between;gap:12px;padding:15px 18px;background:#173b61;color:#fff;border-radius:8px 8px 0 0; }
    .snd-title h3 { margin:0;color:#fff;font-size:18px;letter-spacing:.2px; }
    .snd-title span { font-size:12px;color:#dce9f5; }
    .snd-process-kpis { display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:12px;margin:16px 0; }
    .snd-process-card { overflow:hidden;border:1px solid #d5e0eb;border-radius:9px;background:#fff;box-shadow:0 3px 12px rgba(26,55,82,.06); }
    .snd-process-card h4 { margin:0;padding:10px 13px;background:#236a91;color:#fff;font-size:14px; }
    .snd-process-values { display:grid;grid-template-columns:repeat(3,1fr); }
    .snd-process-values div { padding:12px 8px;text-align:center;border-right:1px solid #e5edf4; }
    .snd-process-values div:last-child { border-right:0; }
    .snd-process-values span { display:block;color:#718096;font-size:11px;text-transform:uppercase; }
    .snd-process-values strong { display:block;margin-top:3px;color:#17324d;font-size:21px; }
    .snd-grand { display:grid;grid-template-columns:repeat(4,minmax(130px,1fr));gap:12px;margin-bottom:16px; }
    .snd-grand .mgr-kpi { border-top:4px solid #1b9a83; }
    .snd-overview-grid { display:grid;grid-template-columns:minmax(0,1.05fr) minmax(0,.95fr);gap:16px;align-items:start; }
    .snd-stack { display:grid;gap:16px; }
    .snd-table-card { overflow:hidden;border:1px solid #d5e0eb;border-radius:9px;background:#fff; }
    .snd-table-card .olt-card-head { background:#edf3f8;color:#17324d; }
    .snd-rank { width:42px;text-align:center;font-weight:800;color:#236a91; }
    .snd-delta.up { color:#16815e; } .snd-delta.down { color:#b34040; } .snd-delta.same { color:#718096; }
    .snd-progress { min-width:130px; }
    .snd-progress-track { height:8px;overflow:hidden;background:#e6edf3;border-radius:10px; }
    .snd-progress-fill { height:100%;background:linear-gradient(90deg,#1b9a83,#4ac8ad);border-radius:10px; }
    .snd-progress-label { display:block;margin-top:4px;font-size:11px;color:#526a81;text-align:right; }
    .snd-empty { padding:28px;text-align:center;color:#718096;background:#fff; }
    .snd-productivity-wrap { overflow:auto;max-height:68vh;border:1px solid #d5e0eb;border-radius:9px;background:#fff; }
    .snd-productivity-table { min-width:850px; }
    .snd-productivity-table thead th { position:sticky;top:0;z-index:2;background:#17614e;color:#fff; }
    .snd-productivity-table tbody tr:nth-child(even) { background:#f4faf7; }
    .snd-achievement { font-weight:800;white-space:nowrap; }
    .snd-achievement.good { color:#16815e; } .snd-achievement.watch { color:#b8770b; } .snd-achievement.low { color:#b34040; }
    .snd-process-sections { display:grid;grid-template-columns:repeat(2,minmax(480px,1fr));gap:16px; }
    .snd-process-section { overflow:hidden;border:1px solid #ccd9e5;border-radius:9px;background:#fff;box-shadow:0 3px 12px rgba(26,55,82,.05); }
    .snd-process-section h4 { margin:0;padding:12px 15px;background:#173b61;color:#fff;font-size:15px; }
    .snd-process-section .olt-table-wrap { max-height:420px;overflow:auto;padding:0; }
    .snd-process-section thead th { position:sticky;top:0;background:#eaf1f7;z-index:1; }
    .snd-process-section tfoot td { position:sticky;bottom:0;background:#dce8f2;font-weight:800; }
    .snd-report-note { margin:10px 0 0;color:#64748b;font-size:12px; }
    .hold-status { display:inline-block;padding:4px 9px;border-radius:20px;font-size:11px;font-weight:800; }
    .hold-status.active { background:#dcf5e9;color:#176b41; } .hold-status.inactive { background:#edf1f5;color:#66788a; }
    .olt-table tfoot td,.olt-table tfoot th { background:#dce8f2;color:#17324d;font-weight:800; }
    @media(max-width:1100px) { .snd-overview-grid,.snd-process-sections { grid-template-columns:1fr; } }
    @media(max-width:700px) { .snd-grand { grid-template-columns:repeat(2,1fr); } .snd-title { align-items:flex-start;flex-direction:column; } }

    </style>

    <script src="OLTracking.js"></script>
    <script src="../plugins/chart.js/Chart.min.js"></script>
    <script src="../Scripts/TrackingSheet/ManagerDashboard.js?v=20260818.1"></script>
    <script src="ManagerDashboard.Snd.js?v=20260818.1"></script>

</asp:Content>


<asp:Content ID="Body" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="olt-page">
        <div class="olt-hero">
            <div>
                <h2>Manager Tracking Dashboard</h2>
                <p>Project, process, user, status and date-wise tracking reports.</p>
            </div>
          <%--  <div class="olt-links">
                <a href="TrackingSheet.aspx">Tracking sheet</a>
                <a href="ManagerAllocation.aspx">PM allocation</a>
            </div>--%>
        </div>
        <div id="oltAlert" class="olt-alert"></div>
        <div style="display:none" aria-hidden="true">
            <select id="mgrProject"></select><select id="mgrDeal"></select><select id="mgrProcess"></select><select id="mgrUser"></select>
            <select id="mgrStatus"></select><select id="mgrProductivityType"></select><select id="dealProject"></select><select id="dealNumber"></select>
            <select id="hourlyProject"></select><select id="hourlyDeal"></select><input id="mgrFrom" type="date" /><input id="mgrTo" type="date" /><input id="hourlyDate" type="date" />
        </div>
        <asp:HiddenField ID="mgrActivePanel" runat="server" ClientIDMode="Static" Value="overviewTab" />
        <div class="mgr-tabs">
            <button type="button" class="mgr-tab active" data-panel="overviewTab">Executive Overview</button>
            <button type="button" class="mgr-tab" data-panel="productivityTab">Productivity</button>
            <button type="button" class="mgr-tab" data-panel="dailyProductionTab">Daily Production</button>
            <button type="button" class="mgr-tab" data-panel="holdReasonsTab">Hold Reasons</button>
            <button type="button" class="mgr-tab" data-panel="importDataTab">Import Data</button>
            <button type="button" class="mgr-tab" data-panel="allocationTab">Allocation</button>
            <button type="button" class="mgr-tab" data-panel="reallocationTab">Re-Allocation</button>
        </div>

        <section id="overviewTab" class="mgr-panel active">
            <div class="snd-title"><h3>SND Tracker -- Executive Overview</h3><span>Live Tracking Sheet data</span></div>
            <div class="olt-card snd-filter">
                <div class="olt-card-body"><div class="olt-form">
                    <div class="olt-field"><label>Project #</label><select id="overviewProject"><option value="">Select project</option></select></div>
                    <div class="olt-field"><label>From Date</label><input id="overviewFrom" type="date" /></div>
                    <div class="olt-field"><label>To Date</label><input id="overviewTo" type="date" /></div>
                    <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="loadOverview()">Apply Filter</button><button type="button" class="olt-btn secondary" onclick="resetSndFilter('overview')">Reset</button></div>
                </div></div>
            </div>
            <div id="overviewProcessKpis" class="snd-process-kpis"><div class="snd-empty">Select a project to view the report.</div></div>
            <div class="snd-grand">
                <div class="mgr-kpi"><span>Total Assigned</span><strong id="overviewAssigned">0</strong></div>
                <div class="mgr-kpi"><span>Done</span><strong id="overviewDone">0</strong></div>
                <div class="mgr-kpi"><span>In Process</span><strong id="overviewInProcess">0</strong></div>
                <div class="mgr-kpi"><span>% Completion</span><strong id="overviewPercent">0%</strong></div>
            </div>
            <div class="snd-overview-grid">
                <div class="snd-stack">
                    <div class="snd-table-card"><div class="olt-card-head">Top 10 Contributors</div><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>Rank</th><th>Reviewer Name</th><th>Current</th><th>Last Month</th><th>Rank Change</th></tr></thead><tbody id="topContributorRows"><tr><td colspan="5" class="olt-empty">No data loaded.</td></tr></tbody><tfoot><tr><td colspan="2">Total</td><td id="topCurrentTotal">0</td><td id="topPreviousTotal">0</td><td>--</td></tr></tfoot></table></div></div>
                    <div class="snd-table-card"><div class="olt-card-head">Needs Attention -- Lowest Active Producers</div><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>Rank</th><th>Reviewer Name</th><th>Current</th><th>Last Month</th></tr></thead><tbody id="attentionRows"><tr><td colspan="4" class="olt-empty">No data loaded.</td></tr></tbody><tfoot><tr><td colspan="2">Total</td><td id="attentionCurrentTotal">0</td><td id="attentionPreviousTotal">0</td></tr></tfoot></table></div></div>
                </div>
                <div class="snd-stack">
                    <div class="snd-table-card"><div class="olt-card-head">Project Progress -- All Deals</div><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>Deal #</th><th>Loans (Done / Total)</th><th>% Complete</th></tr></thead><tbody id="dealProgressRows"><tr><td colspan="3" class="olt-empty">No data loaded.</td></tr></tbody><tfoot><tr><td>Total</td><td id="dealProgressTotal">0 / 0</td><td id="dealProgressPercent">0%</td></tr></tfoot></table></div></div>
                    <div class="snd-table-card"><div class="olt-card-head">Not Assigned for Selected Period</div><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>#</th><th>Reviewer Name</th><th>Recent Activity</th></tr></thead><tbody id="notAssignedRows"><tr><td colspan="3" class="olt-empty">No data loaded.</td></tr></tbody><tfoot><tr><td colspan="2">Total</td><td id="notAssignedTotal">0</td></tr></tfoot></table></div></div>
                </div>
            </div>
        </section>

        <section id="productivityTab" class="mgr-panel">
            <div class="snd-title" style="background:#17614e"><h3>Productivity -- Achieved vs Target</h3><span>Daily target calculation from ERP configuration</span></div>
            <div class="olt-card snd-filter" style="border-top-color:#17614e"><div class="olt-card-body"><div class="olt-form">
                <div class="olt-field"><label>Project #</label><select id="productivityProject"><option value="">Select project</option></select></div>
                <div class="olt-field"><label>From Date</label><input id="productivityFrom" type="date" /></div>
                <div class="olt-field"><label>To Date</label><input id="productivityTo" type="date" /></div>
                <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="loadProductivity()">Apply Filter</button><button type="button" class="olt-btn secondary" onclick="resetSndFilter('productivity')">Reset</button></div>
            </div><p class="snd-report-note">% Target = completed loans ÷ (days worked × configured daily targets for processes worked).</p></div></div>
            <div class="snd-productivity-wrap"><table id="productivityTable" class="olt-table snd-productivity-table"><thead id="productivityHead"><tr><th>Rank</th><th>Reviewer</th><th>Days Worked</th><th>% Target</th></tr></thead><tbody id="productivityRows"><tr><td colspan="4" class="olt-empty">Select a project to view productivity.</td></tr></tbody><tfoot id="productivityFoot"><tr><td colspan="3">Total</td><td>--</td></tr></tfoot></table></div>
        </section>

        <section id="dailyProductionTab" class="mgr-panel">
            <div class="snd-title"><h3>Daily Production Per Reviewer</h3><span>Process-wise production sections</span></div>
            <div class="olt-card snd-filter"><div class="olt-card-body"><div class="olt-form">
                <div class="olt-field"><label>Project #</label><select id="dailyProject"><option value="">Select project</option></select></div>
                <div class="olt-field"><label>From Date</label><input id="dailyFrom" type="date" /></div>
                <div class="olt-field"><label>To Date</label><input id="dailyTo" type="date" /></div>
                <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="loadDailyProduction()">Apply Filter</button><button type="button" class="olt-btn secondary" onclick="resetSndFilter('daily')">Reset</button></div>
            </div><p class="snd-report-note">All configured loan-based processes are displayed. Hourly Production processes are excluded.</p></div></div>
            <div id="dailyProcessSections" class="snd-process-sections"><div class="snd-empty">Select a project to view daily production.</div></div>
        </section>

        <section id="holdReasonsTab" class="mgr-panel">
            <div class="snd-title"><h3>Hold Reasons</h3><span>Standard reasons used throughout Tracking Sheet processing</span></div>
            <div class="olt-card snd-filter"><div class="olt-card-body"><div class="olt-form">
                <div class="olt-field wide"><label>New Hold Reason</label><input id="newHoldReason" maxlength="400" placeholder="Enter a clear standardized reason" /></div>
                <div class="olt-field full olt-actions"><button type="button" class="olt-btn" onclick="saveHoldReason()">Add Hold Reason</button><button type="button" class="olt-btn secondary" onclick="loadHoldReasonsManager()">Refresh</button></div>
            </div><p class="snd-report-note">Inactive reasons remain available for audit history but are removed from user Hold Reason dropdowns.</p></div></div>
            <div class="snd-table-card mgr-section"><div class="olt-card-head">Configured Hold Reasons</div><div class="olt-table-wrap"><table class="olt-table"><thead><tr><th>#</th><th>Hold Reason</th><th>Status</th><th>Action</th></tr></thead><tbody id="holdReasonRows"><tr><td colspan="4" class="olt-empty">Loading Hold Reasons...</td></tr></tbody><tfoot><tr><td colspan="3">Total Reasons</td><td id="holdReasonTotal">0</td></tr></tfoot></table></div></div>
        </section>

        <section id="importDataTab" class="mgr-panel">
            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <div class="olt-card">
                <div class="olt-card-head">1. Download Template</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide" style="        text-align: left;">
                            <label for="ddlProject">Project</label>
                            <asp:DropDownList ID="ddlProject" runat="server" AutoPostBack="true" onchange="OLT.showLoading('Loading project import configuration...');" OnSelectedIndexChanged="ddlProject_SelectedIndexChanged" />
                        </div>
                        <div class="olt-field wide" style="        text-align: left;">
                            <label>&nbsp;</label>
                            <div class="olt-actions import-button-wrap">
                                <asp:Button ID="btnDownloadTemplate" runat="server" Text="Download Import Template" CssClass="btn btn-primary import-action-button import-download-button" OnClientClick="OLT.showLoading('Preparing import template...'); window.setTimeout(function(){ OLT.hideLoading(true); }, 5000);" OnClick="btnDownloadTemplate_Click" />
                            </div>
                        </div>
                        <div class="olt-field full">
                            <asp:Label ID="lblConfiguredFields" runat="server" CssClass="olt-muted" />
                        </div>
                        <div class="olt-field full olt-muted">The template contains only fields marked <strong>For Import</strong>. Its hidden identity sheet lets the upload recognize the project automatically.</div>
                    </div>
                </div>
            </div>

            <div class="olt-card mgr-section">
                <div class="olt-card-head">2. Import Completed Template</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field full">
                            <asp:Label ID="lblImportProject" runat="server" CssClass="olt-muted" />
                        </div>
                        <div class="olt-field wide">
                            <label for="fuImportFile">Excel file (.xlsx)</label>
                            <asp:FileUpload ID="fuImportFile" runat="server" accept=".xlsx" />
                        </div>
                        <div class="olt-field wide">
                            <label>&nbsp;</label>
                            <div class="olt-actions import-button-wrap">
                                <asp:Button ID="btnImport" runat="server" Text="Import into Selected Project" CssClass="btn btn-success import-action-button import-upload-button" OnClientClick="OLT.showLoading('Validating and importing data...');" OnClick="btnImport_Click" />
                            </div>
                        </div>
                        <div class="olt-field full olt-muted">The selected project must match the project identified inside the template. A mismatch is rejected before any data is saved.</div>
                    </div>
                </div>
            </div>

            <div class="olt-card mgr-section">
                <div class="olt-card-head">Recent Imports</div>
                <div class="olt-table-wrap" style="        padding: 1%;">
                    <table class="olt-table">
                        <thead>
                            <tr>
                                <th>Batch #</th>
                                <th>Project</th>
                                <th>File</th>
                                <th>Rows</th>
                                <th>Status</th>
                                <th>Imported On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="gvRecentImports" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%#: Eval("ImportBatchId") %></td>
                                        <td><%#: Eval("ProjectName") %></td>
                                        <td><%#: Eval("OriginalFileName") %></td>
                                        <td><%#: Eval("TotalRows") %></td>
                                        <td><%#: Eval("ImportStatus") %></td>
                                        <td><%#: Eval("ImportedDate") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                            <% if (gvRecentImports.Items.Count == 0) { %>
                            <tr>
                                <td colspan="6" class="olt-empty">No imports completed yet.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section id="allocationTab" class="mgr-panel">
            <div class="olt-card">
                <div class="olt-card-head">Allocation details</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field wide">
                            <label>Project #</label><select id="pmaProject"><option value="">Select project</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Deal #</label><select id="pmaDeal" disabled><option value="">Select project first</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Process</label><select id="pmaProcess" disabled><option value="">Select deal first</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>User</label><select id="pmaUser" disabled><option value="">Select project first</option>
                            </select><div id="pmaUserNote" class="pma-user-note"></div>
                        </div>
                    </div>
                    <div class="ots-note">Select a maximum of two orders. The selected user can have no more than two Pending/In Process orders after allocation.</div>
                    <div class="olt-table-wrap mgr-orders">
                        <table class="olt-table"><thead><tr><th>Select</th><th>Project</th><th>Deal #</th><th>Process</th><th>Loan #</th><th>Current User</th><th>Status</th><th>Remark</th><th>Assigned Date</th></tr></thead>
                            <tbody id="pmaRows"><tr><td colspan="9" class="olt-empty">Select project, deal and process.</td></tr></tbody>
                        </table>
                    </div>
                    <div class="olt-actions" style="        margin-top: 14px">
                        <button type="button" class="olt-btn" onclick="allocateSelected()">Allocate Selected Orders</button>
                    </div>
                </div>
            </div>
        </section>
        <section id="reallocationTab" class="mgr-panel">
            <div class="olt-card">
                <div class="olt-card-head">Re-allocation flow</div>
                <div class="olt-card-body">
                    <div class="olt-form">
                        <div class="olt-field">
                            <label>Project #</label><select id="reProject"><option value="">Select project</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Deal #</label><select id="reDeal" disabled><option value="">Select project first</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Process</label><select id="reProcess" disabled><option value="">Select deal first</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>Current User</label><select id="reFromUser" disabled><option value="">Select process first</option>
                            </select>
                        </div>
                        <div class="olt-field">
                            <label>New User</label><select id="reToUser" disabled><option value="">Select project first</option>
                            </select>
                        </div>
                        <div class="olt-field wide">
                            <label>Remark</label><input id="reRemark" maxlength="1000" />
                        </div>
                    </div>
                    <div class="ots-note">Select a maximum of two already allocated orders. The new user cannot exceed two Pending/In Process orders.</div>
                    <div class="olt-table-wrap mgr-orders">
                        <table class="olt-table">
                            <thead>
                                <tr>
                                    <th>Select</th>
                                    <th>Project</th>
                                    <th>Deal #</th>
                                    <th>Process</th>
                                    <th>Loan #</th>
                                    <th>Current User</th>
                                    <th>Status</th>
                                    <th>Remark</th>
                                    <th>Assigned Date</th>
                                </tr>
                            </thead>
                            <tbody id="reRows">
                                <tr>
                                    <td colspan="9" class="olt-empty">Select project, deal, process and current user.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="olt-actions" style="        margin-top: 14px">
                        <button type="button" class="olt-btn" onclick="reallocateSelected()">Re-Allocate Selected Orders</button>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <script>
    //     var page = 'ManagerDashboard.aspx', reAllUsers = []; document.addEventListener('DOMContentLoaded', function () { bindManagerTabs(); setDates(); OLT.call(page, 'GetProjects').then(function (r) { [mgrProject, dealProject, hourlyProject, reProject].forEach(function (s) { OLT.options(s, r, ['ProjectID'], ['ProjectName'], 'Select project'); }); }); mgrProject.onchange = function () { clearReport(); if (mgrProject.value) loadFilters(); else clearFilters(); }; dealProject.onchange = function () { loadDeals(dealProject, dealNumber, 'All deals'); }; hourlyProject.onchange = function () { loadDeals(hourlyProject, hourlyDeal, 'All deals'); }; reProject.onchange = loadReProject; reDeal.onchange = enableReProcess; reProcess.onchange = loadReUsers; reFromUser.onchange = function () { renderReTargets(); loadReOrders(); }; });
    //     var pmaUsers = []; document.addEventListener('DOMContentLoaded', function () { OLT.call(page, 'GetProjects').then(function (r) { OLT.options(pmaProject, r, ['ProjectID'], ['ProjectName'], 'Select project'); }); pmaProject.onchange = loadProjectData; pmaDeal.onchange = enableProcess; pmaProcess.onchange = loadLoans; pmaUser.onchange = showUserCount; });
    //     function loadProjectData() { pmaDeal.disabled = true; pmaProcess.disabled = true; pmaUser.disabled = true; pmaLoans.innerHTML = '<div class="olt-empty">Loading...</div>'; if (!pmaProject.value) return; Promise.all([OLT.call(page, 'GetDeals', { projectId: +pmaProject.value }), OLT.call(page, 'GetFlow', { projectId: +pmaProject.value }), OLT.call(page, 'GetUsers', { projectId: +pmaProject.value })]).then(function (r) { OLT.options(pmaDeal, r[0], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); pmaDeal.disabled = false; OLT.options(pmaProcess, r[1], ['ProcessID'], ['ProcessName'], 'Select deal first'); pmaUsers = r[2]; pmaUser.innerHTML = '<option value="">Select user</option>'; pmaUsers.forEach(function (x) { var o = document.createElement('option'); o.value = x.UserID; o.textContent = x.UserName + ' (' + x.ActiveCount + ' active)'; pmaUser.appendChild(o); }); pmaUser.disabled = false; pmaLoans.innerHTML = '<div class="olt-empty">Select deal and process.</div>'; }).catch(showAllocationError); }
    //     function enableProcess() { pmaProcess.disabled = !pmaDeal.value; pmaProcess.value = ''; if (pmaProcess.options.length) pmaProcess.options[0].text = pmaDeal.value ? 'Select process' : 'Select deal first'; pmaLoans.innerHTML = '<div class="olt-empty">Select process.</div>'; }
    //     function loadLoans() { if (!pmaProject.value || !pmaDeal.value || !pmaProcess.value) return; pmaLoans.innerHTML = '<div class="olt-empty">Loading eligible orders...</div>'; OLT.call(page, 'GetEligibleLoans', { projectId: +pmaProject.value, dealNumber: pmaDeal.value, processId: +pmaProcess.value }).then(function (r) { pmaLoans.innerHTML = r.length ? r.map(function (x) { return '<label class="pma-loan"><input type="checkbox" class="pma-check" value="' + OLT.esc(x.LoanNumber) + '" onchange="limitSelection(this)"/><span>' + OLT.esc(x.LoanNumber) + '</span></label>'; }).join('') : '<div class="olt-empty">No eligible orders found.</div>'; }).catch(showAllocationError); }
    //     function limitSelection(changed) { var selected = document.querySelectorAll('.pma-check:checked'); if (selected.length > 2) { changed.checked = false; OLT.alert('Select a maximum of two orders.', true); } }
    //     function showUserCount() { var u = pmaUsers.filter(function (x) { return String(x.UserID) === String(pmaUser.value); })[0]; pmaUserNote.textContent = u ? u.ActiveCount + ' active Pending/In Process order(s).' : ''; }
    //     function allocateSelected() { var loans = [].slice.call(document.querySelectorAll('.pma-check:checked')).map(function (x) { return x.value; }); if (!pmaUser.value) { OLT.alert('Please select a user.', true); return; } if (!loans.length || loans.length > 2) { OLT.alert('Select one or two orders.', true); return; } OLT.call(page, 'AllocateOrders', { projectId: +pmaProject.value, dealNumber: pmaDeal.value, processId: +pmaProcess.value, targetUserId: +pmaUser.value, loanNumbers: loans }).then(function (r) { if (!r || r.Success !== true) { OLT.alert(r && r.Message ? r.Message : 'Allocation failed.', true); return; } OLT.alert(r.Message); loadProjectData(); }).catch(showAllocationError); }
    //     function showAllocationError() { OLT.alert('The requested action could not be completed. Please try again.', true); }
    //     function bindManagerTabs() { function activate(b) { document.querySelector('.mgr-tab.active').classList.remove('active'); document.querySelector('.mgr-panel.active').classList.remove('active'); b.classList.add('active'); document.getElementById(b.dataset.panel).classList.add('active'); mgrActivePanel.value = b.dataset.panel; } [].slice.call(document.querySelectorAll('.mgr-tab')).forEach(function (b) { b.onclick = function () { activate(b); }; }); var saved = document.querySelector('.mgr-tab[data-panel="' + mgrActivePanel.value + '"]'); if (saved && !saved.classList.contains('active')) activate(saved); }
    //     function setDates() { var e = new Date(), s = new Date(); s.setDate(e.getDate() - 30); mgrFrom.value = iso(s); mgrTo.value = iso(e); hourlyDate.value = iso(e); } function iso(d) { return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }
    //     function clearFilters() { mgrProcess.innerHTML = '<option value="0">All processes</option>'; mgrUser.innerHTML = '<option value="0">All users</option>'; }
    //     function clearReport() { renderSummary([]); renderDetails([]); }
    //     function loadFilters() { var id = +mgrProject.value; if (!id) return; Promise.all([OLT.call(page, 'GetProcesses', { projectId: id }), OLT.call(page, 'GetUsers', { projectId: id })]).then(function (r) { OLT.options(mgrProcess, r[0], ['ProcessID'], ['ProcessName'], 'All processes'); mgrProcess.options[0].value = '0'; OLT.options(mgrUser, r[1], ['UserID'], ['UserName'], 'All users'); mgrUser.options[0].value = '0'; }).catch(showError); }
    //     function loadManagerReport() { var projectId = +mgrProject.value; if (!projectId) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetReport', { projectId: projectId, processId: +mgrProcess.value || 0, userId: +mgrUser.value || 0, status: mgrStatus.value, fromDate: mgrFrom.value, toDate: mgrTo.value }).then(function (r) { if (typeof r === 'string') r = JSON.parse(r); renderSummary(r.table0 || []); renderDetails(r.table1 || []); }).catch(showError); }
    //     function renderSummary(rows) { summaryRows.innerHTML = rows.length ? rows.map(function (x) { return '<tr><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.UserName) + '</td><td>' + x.TotalOrders + '</td><td>' + x.PendingOrders + '</td><td>' + x.InProcessOrders + '</td><td>' + x.HoldOrders + '</td><td>' + x.CompletedOrders + '</td><td class="mgr-duration">' + duration(x.AverageTATSeconds) + '</td><td class="mgr-duration">' + duration(x.TotalHoldTATSeconds) + '</td></tr>'; }).join('') : '<tr><td colspan="10" class="olt-empty">No summary records found.</td></tr>'; }
    //     function renderDetails(rows) { var counts = { total: rows.length, pending: 0, process: 0, hold: 0, completed: 0 }; rows.forEach(function (x) { if (x.AssignmentStatus === 'Pending') counts.pending++; else if (x.AssignmentStatus === 'In Process') counts.process++; else if (x.AssignmentStatus === 'Hold') counts.hold++; else if (x.AssignmentStatus === 'Completed') counts.completed++; }); kTotal.textContent = counts.total; kPending.textContent = counts.pending; kProcess.textContent = counts.process; kHold.textContent = counts.hold; kCompleted.textContent = counts.completed; detailRows.innerHTML = rows.length ? rows.map(function (x) { return '<tr><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.LoanNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.UserName) + '</td><td>' + esc(x.AssignmentStatus) + '</td><td>' + fmt(x.AssignedDate) + '</td><td>' + fmt(x.StartedDate) + '</td><td>' + fmt(x.CompletedDate) + '</td><td>' + duration(x.HoldTATSeconds) + '</td><td>' + duration(x.TotalTATSeconds) + '</td><td>' + esc(x.LastRemark) + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No detail records found.</td></tr>'; }
    //     function loadDeals(projectSelect, dealSelect, placeholder) { dealSelect.disabled = true; dealSelect.innerHTML = '<option value="">' + placeholder + '</option>'; if (!projectSelect.value) return; OLT.call(page, 'GetDeals', { projectId: +projectSelect.value }).then(function (r) { OLT.options(dealSelect, r, ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], placeholder); dealSelect.disabled = false; }).catch(showError); }
    //     function loadDealDashboard() { if (!dealProject.value) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetDealDashboard', { projectId: +dealProject.value, dealNumber: dealNumber.value }).then(function (r) { dealRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td>' + esc(x.DealNumber) + '</td><td>' + x.DealCount + '</td><td>' + fmtDate(x.ReceivedDate) + '</td><td>' + fmtDate(x.DueDate) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + x.PendingOrders + '</td><td>' + x.CompletedOrders + '</td><td>' + x.HoldOrders + '</td><td>' + x.SkippedOrders + '</td><td>' + x.TodayInProcess + '</td><td>' + x.TodayCompleted + '</td><td>' + x.TodayHold + '</td></tr>'; }).join('') : '<tr><td colspan="12" class="olt-empty">No deal records found.</td></tr>'; }).catch(showError); }
    //     function loadHourly() { if (!hourlyProject.value) { OLT.alert('Please select Project #.', true); return; } OLT.call(page, 'GetHourlyProduction', { projectId: +hourlyProject.value, reportDate: hourlyDate.value, dealNumber: hourlyDeal.value }).then(function (r) { hourlyRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + x.H10AM + '</td><td>' + x.H12PM + '</td><td>' + x.H02PM + '</td><td>' + x.H04PM + '</td><td>' + x.H06PM + '</td><td>' + x.H08PM + '</td><td>' + x.H10PM + '</td><td>' + x.H12AM + '</td><td>' + x.H02AM + '</td><td>' + x.H04AM + '</td><td>' + x.H06AM + '</td><td>' + x.H08AM + '</td><td>' + x.TotalCompleted + '</td></tr>'; }).join('') : '<tr><td colspan="15" class="olt-empty">No completed orders found for this production date.</td></tr>'; }).catch(showError); }
    //     function loadReProject() { reDeal.disabled = true; reProcess.disabled = true; reFromUser.disabled = true; reToUser.disabled = true; reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select project, deal, process and current user.</td></tr>'; if (!reProject.value) return; Promise.all([OLT.call(page, 'GetDeals', { projectId: +reProject.value }), OLT.call(page, 'GetProcesses', { projectId: +reProject.value }), OLT.call(page, 'GetUsers', { projectId: +reProject.value })]).then(function (r) { OLT.options(reDeal, r[0], ['DealNo', 'DealNumber', 'Deal'], ['DealNo', 'DealNumber', 'Deal'], 'Select deal'); reDeal.disabled = false; OLT.options(reProcess, r[1], ['ProcessID'], ['ProcessName'], 'Select deal first'); reAllUsers = r[2] || []; renderReTargets(); }).catch(showError); }
    //     function enableReProcess() { reProcess.disabled = !reDeal.value; reProcess.value = ''; if (reProcess.options.length) reProcess.options[0].text = reDeal.value ? 'Select process' : 'Select deal first'; reFromUser.disabled = true; reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select process and current user.</td></tr>'; }
    //     function loadReUsers() { reFromUser.disabled = true; if (!reProject.value || !reDeal.value || !reProcess.value) return; OLT.call(page, 'GetReallocationUsers', { projectId: +reProject.value, dealNumber: reDeal.value, processId: +reProcess.value }).then(function (r) { OLT.options(reFromUser, r, ['UserID'], ['UserName'], 'Select current user'); reFromUser.disabled = false; renderReTargets(); }).catch(showError); }
    //     function renderReTargets() { reToUser.innerHTML = '<option value="">Select new user</option>'; reAllUsers.filter(function (x) { return String(x.UserID) !== String(reFromUser.value); }).forEach(function (x) { var o = document.createElement('option'); o.value = x.UserID; o.textContent = x.UserName + ' (' + x.ActiveCount + ' active)'; reToUser.appendChild(o); }); reToUser.disabled = !reProject.value; }
    //     function loadReOrders() { if (!reFromUser.value) return; OLT.call(page, 'GetReallocationOrders', { projectId: +reProject.value, dealNumber: reDeal.value, processId: +reProcess.value, fromUserId: +reFromUser.value }).then(function (r) { reRows.innerHTML = r.length ? r.map(function (x) { return '<tr><td><input type="checkbox" class="mgr-select re-check" value="' + x.AssignmentID + '" onchange="limitReSelection(this)"/></td><td>' + esc(x.ProjectName) + '</td><td>' + esc(x.DealNumber) + '</td><td>' + esc(x.ProcessName) + '</td><td>' + esc(x.LoanNumber) + '</td><td>' + esc(x.UserName) + '</td><td>' + esc(x.AssignmentStatus) + '</td><td>' + esc(x.LastRemark) + '</td><td>' + fmt(x.AssignedDate) + '</td></tr>'; }).join('') : '<tr><td colspan="9" class="olt-empty">No allocated orders found for this user.</td></tr>'; }).catch(showError); }
    //     function limitReSelection(changed) { if (document.querySelectorAll('.re-check:checked').length > 2) { changed.checked = false; OLT.alert('Select a maximum of two orders.', true); } }

    //     function reallocateSelected() { var ids = [].slice.call(document.querySelectorAll('.re-check:checked')).map(function (x) { return +x.value; }); if (!reFromUser.value) { OLT.alert('Please select Current User.', true); return; } if (!reToUser.value) { OLT.alert('Please select New User.', true); return; } if (!reRemark.value.trim()) { OLT.alert('Re-allocation remark is required.', true); return; } if (!ids.length || ids.length > 2) { OLT.alert('Select one or two orders.', true); return; } OLT.call(page, 'ReallocateOrders', { projectId: +reProject.value, fromUserId: +reFromUser.value, toUserId: +reToUser.value, assignmentIds: ids, remark: reRemark.value }).then(function (r) { if (!r || r.Success !== true) { OLT.alert(r && r.Message ? r.Message : 'Re-allocation failed.', true); return; } OLT.alert(r.Message); reRemark.value = ''; loadReUsers(); reRows.innerHTML = '<tr><td colspan="9" class="olt-empty">Select current user to refresh orders.</td></tr>'; }).catch(showError); }

    //     function exportTable(tableId, fileName) { var rows = [].slice.call(document.querySelectorAll('#' + tableId + ' tr')), csv = rows.map(function (row) { return [].slice.call(row.querySelectorAll('th,td')).map(function (cell) { return '"' + cell.textContent.trim().replace(/"/g, '""') + '"'; }).join(','); }).join('\r\n'), blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' }), a = document.createElement('a'); a.href = URL.createObjectURL(blob); a.download = fileName; document.body.appendChild(a); a.click(); a.remove(); URL.revokeObjectURL(a.href); }
    //     function fmtDate(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleDateString() : ''; }
    //     function duration(v) { var s = Math.max(0, +v || 0), d = Math.floor(s / 86400); s %= 86400; var h = Math.floor(s / 3600); s %= 3600; var m = Math.floor(s / 60); return (d ? d + 'd ' : '') + String(h).padStart(2, '0') + ':' + String(m).padStart(2, '0'); } function fmt(v) { var n = parseInt(String(v || '').replace(/\D/g, ''), 10); return n ? new Date(n).toLocaleString() : ''; } function esc(v) { return OLT.esc(v); } function showError() { OLT.alert('The report could not be loaded. Please try again.', true); }
    </script>


</asp:Content>
