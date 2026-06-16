<%@ Page Title="Production Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProductionDashboard.aspx.cs" Inherits="WebPortal.Admin.ProductionDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../plugins/chart.js/Chart.bundle.min.js"></script>
    <style>
        .production-dashboard {
            color: #243041;
            font-family: "Source Sans Pro", Arial, sans-serif;
        }

            .production-dashboard .dashboard-shell {
                max-width: 1480px;
                margin: 0 auto;
            }

            .production-dashboard .dashboard-header {
                background: #ffffff;
                border: 1px solid #e5e9f0;
                border-left: 4px solid #2563eb;
                border-radius: 8px;
                padding: 18px 20px;
                margin-bottom: 16px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
            }

            .production-dashboard .dashboard-title {
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                color: #182334;
            }

            .production-dashboard .dashboard-subtitle {
                margin: 4px 0 0;
                color: #667085;
                font-size: 14px;
            }

            .production-dashboard .period-tools {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: flex-end;
                flex-wrap: wrap;
            }

                .production-dashboard .period-tools .form-control {
                    width: auto;
                    min-width: 146px;
                    border-radius: 6px;
                    border-color: #d8dee8;
                    font-size: 13px;
                }

            .production-dashboard .btn-dashboard {
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                padding: 8px 12px;
            }

            .production-dashboard .data-alert {
                display: none;
                border-radius: 8px;
                border: 1px solid #fde2bf;
                background: #fff8ed;
                color: #9a4b00;
                padding: 10px 12px;
                margin-bottom: 16px;
                font-size: 13px;
            }

            .production-dashboard .kpi-grid {
                display: grid;
                grid-template-columns: repeat(6, minmax(150px, 1fr));
                gap: 14px;
                margin-bottom: 16px;
            }

            .production-dashboard .kpi-card {
                background: #ffffff;
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                padding: 16px;
                min-height: 132px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
            }

            .production-dashboard .kpi-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
            }

            .production-dashboard .kpi-icon {
                width: 38px;
                height: 38px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                font-size: 16px;
            }

            .production-dashboard .kpi-card:nth-child(1) .kpi-icon {
                background: #2563eb;
            }

            .production-dashboard .kpi-card:nth-child(2) .kpi-icon {
                background: #0f8f8c;
            }

            .production-dashboard .kpi-card:nth-child(3) .kpi-icon {
                background: #f97316;
            }

            .production-dashboard .kpi-card:nth-child(4) .kpi-icon {
                background: #16a34a;
            }

            .production-dashboard .kpi-card:nth-child(5) .kpi-icon {
                background: #dc2626;
            }

            .production-dashboard .kpi-card:nth-child(6) .kpi-icon {
                background: #7c3aed;
            }

            .production-dashboard .kpi-label {
                color: #667085;
                font-size: 13px;
                margin: 0;
            }

            .production-dashboard .kpi-value {
                font-size: 28px;
                line-height: 1;
                font-weight: 800;
                margin: 0 0 8px;
                color: #182334;
            }

            .production-dashboard .kpi-note {
                font-size: 12px;
                color: #7b8798;
                margin: 0;
            }

            .production-dashboard .dashboard-card {
                background: #ffffff;
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
                margin-bottom: 16px;
                overflow: hidden;
            }

            .production-dashboard .dashboard-card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 16px;
                border-bottom: 1px solid #eef1f6;
                min-height: 58px;
            }

            .production-dashboard .dashboard-card-title {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #182334;
            }

            .production-dashboard .dashboard-card-body {
                padding: 16px;
            }

            .production-dashboard .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border-radius: 999px;
                padding: 5px 9px;
                font-size: 12px;
                font-weight: 600;
                background: #eef4ff;
                color: #1d4ed8;
            }

            .production-dashboard .chart-box {
                position: relative;
                min-height: 310px;
                height: 310px;
            }

            .production-dashboard .chart-box-small {
                min-height: 255px;
                height: 255px;
            }

            .production-dashboard .workbench-section {
                margin-bottom: 16px;
            }

            .production-dashboard .workbench-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .production-dashboard .workbench-title {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #182334;
            }

            .production-dashboard .link-grid {
                display: grid;
                grid-template-columns: repeat(4, minmax(180px, 1fr));
                gap: 12px;
            }

            .production-dashboard .work-card {
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                padding: 14px;
                min-height: 146px;
                background: #ffffff;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
            }

            .production-dashboard .work-card-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .production-dashboard .work-card h4 {
                font-size: 15px;
                font-weight: 700;
                margin: 0;
                color: #182334;
            }

            .production-dashboard .work-card p {
                color: #667085;
                font-size: 13px;
                min-height: 38px;
                margin: 0 0 12px;
            }

            .production-dashboard .work-card a {
                font-size: 13px;
                font-weight: 700;
                color: #2563eb;
            }

            .production-dashboard .work-count {
                min-width: 34px;
                height: 28px;
                border-radius: 6px;
                background: #f8fafc;
                border: 1px solid #dfe5ee;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #182334;
                font-weight: 800;
            }

            .production-dashboard .table {
                margin-bottom: 0;
                font-size: 13px;
            }

                .production-dashboard .table thead th {
                    background: #f5f7fb;
                    border-bottom: 1px solid #e7ebf2;
                    color: #344054;
                    font-weight: 700;
                    white-space: nowrap;
                }

                .production-dashboard .table td {
                    vertical-align: middle;
                }

            .production-dashboard .report-grid {
                display: grid;
                grid-template-columns: minmax(0, 1.15fr) minmax(360px, 0.85fr);
                gap: 16px;
                margin-bottom: 16px;
            }

            .production-dashboard .compact-table-wrap {
                max-height: 320px;
                overflow: auto;
            }

            .production-dashboard .report-table {
                min-width: 720px;
            }

                .production-dashboard .report-table th,
                .production-dashboard .report-table td {
                    white-space: nowrap;
                    font-size: 12px;
                }

            .production-dashboard .matrix-scroll {
                max-height: 440px;
                overflow: auto;
                border-top: 1px solid #e7ebf2;
            }

            .production-dashboard .matrix-table {
                min-width: 980px;
                border-collapse: separate;
                border-spacing: 0;
            }

                .production-dashboard .matrix-table thead th {
                    position: sticky;
                    top: 0;
                    z-index: 3;
                    background: #a9d8ff;
                    color: #0f2237;
                    border-color: #6eaee6;
                    text-align: right;
                    font-size: 13px;
                }

                .production-dashboard .matrix-table tbody td {
                    text-align: right;
                    white-space: nowrap;
                    min-width: 78px;
                    font-size: 13px;
                    color: #111827;
                }

                .production-dashboard .matrix-table .matrix-client {
                    position: sticky;
                    left: 0;
                    z-index: 2;
                    min-width: 150px;
                    text-align: left;
                    font-weight: 700;
                    background: #ffffff;
                    box-shadow: 1px 0 0 #e5e9f0;
                }

                .production-dashboard .matrix-table thead .matrix-client {
                    background: #a9d8ff;
                    z-index: 5;
                }

                .production-dashboard .matrix-table .matrix-total {
                    font-weight: 800;
                    color: #182334;
                    background: #f8fafc;
                }

            .production-dashboard .section-note {
                color: #667085;
                font-size: 12px;
                margin: 0;
            }

            .production-dashboard .progress {
                height: 8px;
                border-radius: 6px;
                background: #edf1f6;
            }

            .production-dashboard .progress-bar {
                border-radius: 6px;
            }

            .production-dashboard .signal-list {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
            }

            .production-dashboard .signal-item {
                border-left: 3px solid #2563eb;
                padding: 4px 0 4px 12px;
            }

            .production-dashboard .signal-label {
                font-size: 12px;
                text-transform: uppercase;
                color: #7b8798;
                font-weight: 700;
                margin-bottom: 5px;
            }

            .production-dashboard .signal-value {
                font-size: 18px;
                font-weight: 800;
                color: #182334;
                margin-bottom: 4px;
            }

            .production-dashboard .signal-copy {
                color: #667085;
                font-size: 13px;
                margin: 0;
            }

            .production-dashboard .loading-state {
                min-height: 190px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #667085;
                font-weight: 600;
                gap: 8px;
            }

        @media (max-width: 1200px) {
            .production-dashboard .kpi-grid {
                grid-template-columns: repeat(3, minmax(160px, 1fr));
            }

            .production-dashboard .link-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .production-dashboard .dashboard-title {
                font-size: 21px;
            }

            .production-dashboard .period-tools {
                justify-content: flex-start;
                margin-top: 12px;
            }

            .production-dashboard .kpi-grid,
            .production-dashboard .link-grid,
            .production-dashboard .report-grid,
            .production-dashboard .signal-list {
                grid-template-columns: 1fr;
            }

            .production-dashboard .chart-box,
            .production-dashboard .chart-box-small {
                height: 260px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="production-dashboard">
        <div class="dashboard-shell">
            <div id="productionDataAlert" class="data-alert">
                <i class="fas fa-exclamation-triangle mr-1"></i>
                Some live production data could not be loaded. The dashboard is showing the available sections.
           
            </div>

            <div class="dashboard-header">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h1 class="dashboard-title">Production Dashboard</h1>
                        <p class="dashboard-subtitle">Performance-report driven view of production count, target, productivity, quality, attendance, and feedback signals.</p>
                    </div>
                    <div class="col-lg-6">
                        <div class="period-tools">
                            <input type="date" id="productionFromDate" class="form-control" title="From date" />
                            <input type="date" id="productionToDate" class="form-control" title="To date" />
                            <button type="button" id="btnProductionRefresh" class="btn btn-primary btn-dashboard" title="Refresh dashboard">
                                <i class="fas fa-sync-alt mr-1"></i>Refresh
                           
                            </button>
                            <a href="ProductionSummary.aspx" class="btn btn-outline-secondary btn-dashboard" title="Open production summary">
                                <i class="fas fa-chart-bar mr-1"></i>Summary
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Active Employees</p>
                        <span class="kpi-icon"><i class="fas fa-users-cog"></i></span>
                    </div>
                    <p id="kpiProductionEmployees" class="kpi-value">0</p>
                    <p class="kpi-note">Employees in performance report</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Total Production</p>
                        <span class="kpi-icon"><i class="fas fa-layer-group"></i></span>
                    </div>
                    <p id="kpiTotalProduction" class="kpi-value">0</p>
                    <p id="kpiProductionDays" class="kpi-note">0 productive days</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Avg Productivity</p>
                        <span class="kpi-icon"><i class="fas fa-tachometer-alt"></i></span>
                    </div>
                    <p id="kpiAvgProductivity" class="kpi-value">0%</p>
                    <p id="kpiBestProductivity" class="kpi-note">Best day 0%</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Avg Quality</p>
                        <span class="kpi-icon"><i class="fas fa-check-circle"></i></span>
                    </div>
                    <p id="kpiAvgQuality" class="kpi-value">0%</p>
                    <p id="kpiBestQuality" class="kpi-note">Best quality 0%</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Total Errors</p>
                        <span class="kpi-icon"><i class="fas fa-exclamation-circle"></i></span>
                    </div>
                    <p id="kpiTotalErrors" class="kpi-value">0</p>
                    <p id="kpiErrorRate" class="kpi-note">Error rate 0%</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Avg Attendance</p>
                        <span class="kpi-icon"><i class="fas fa-calendar-check"></i></span>
                    </div>
                    <p id="kpiAvgAttendance" class="kpi-value">0%</p>
                    <p id="kpiProcessCount" class="kpi-note">0 process groups</p>
                </div>
            </div>

            <div class="row" style="display:none;">
                <div class="col-xl-8">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Daily Production and Target</h2>
                            <span id="productionPeriod" class="status-pill"><i class="fas fa-calendar-alt"></i>Loading</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box">
                                <canvas id="productionTrendChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Quality vs Productivity</h2>
                            <span id="productionGenerated" class="status-pill"><i class="fas fa-clock"></i>Loading</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box chart-box-small">
                                <canvas id="qualityProductivityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xl-6">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Process Production and Target</h2>
                            <span class="status-pill"><i class="fas fa-stream"></i>Process mix</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box">
                                <canvas id="processVolumeChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Employee Performance Ranking</h2>
                            <span class="status-pill"><i class="fas fa-sort-amount-up"></i>Top 12</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box">
                                <canvas id="employeeRankingChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="report-grid">
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <div>
                            <h2 class="dashboard-card-title">Weekly Graphical View</h2>
                            <p class="section-note">Volume and error-per-loan trend from the Detailed Feedback report.</p>
                        </div>
                        <span class="status-pill"><i class="fas fa-chart-area"></i>QC view</span>
                    </div>
                    <div class="dashboard-card-body">
                        <div class="chart-box chart-box-small">
                            <canvas id="weeklyGraphicalChart"></canvas>
                        </div>
                        <div class="compact-table-wrap mt-3">
                            <table class="table table-hover report-table">
                                <thead id="weeklyGraphicalHead">
                                    <tr>
                                        <th>Week</th>
                                        <th class="text-center">Loan Qced</th>
                                        <th class="text-center">Error/Loan</th>
                                    </tr>
                                </thead>
                                <tbody id="weeklyGraphicalBody">
                                    <tr>
                                        <td colspan="3" class="text-center text-muted p-4">Loading weekly graphical view</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <div>
                            <h2 class="dashboard-card-title">Individual Performance</h2>
                            <p id="individualPerformancePeriod" class="section-note">Loading report period</p>
                        </div>
                        <span class="status-pill"><i class="fas fa-user-chart"></i>Credit report</span>
                    </div>
                    <div class="dashboard-card-body">
                        <div class="chart-box chart-box-small">
                            <canvas id="individualPerformanceChart"></canvas>
                        </div>
                        <div class="compact-table-wrap mt-3">
                            <table class="table table-hover report-table">
                                <thead id="individualPerformanceHead">
                                    <tr>
                                        <th>Employee</th>
                                        <th class="text-center">Production</th>
                                        <th class="text-center">Utilisation %</th>
                                        <th class="text-center">Quality %</th>
                                    </tr>
                                </thead>
                                <tbody id="individualPerformanceBody">
                                    <tr>
                                        <td colspan="4" class="text-center text-muted p-4">Loading individual performance</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="dashboard-card">
                <div class="dashboard-card-header">
                    <div>
                        <h2 class="dashboard-card-title">Project Volume - Last 12 Months</h2>
                        <p id="monthlyProjectVolumePeriod" class="section-note">Loading latest OrderData period</p>
                    </div>
                    <span class="status-pill"><i class="fas fa-calendar"></i>Monthly format</span>
                </div>
                <div class="matrix-scroll">
                    <table class="table table-bordered matrix-table">
                        <thead id="monthlyProjectVolumeHead">
                            <tr>
                                <th class="matrix-client">Client No</th>
                            </tr>
                        </thead>
                        <tbody id="monthlyProjectVolumeBody">
                            <tr>
                                <td class="text-center text-muted p-4">Loading monthly project volume</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="dashboard-card">
                <div class="dashboard-card-header">
                    <div>
                        <h2 class="dashboard-card-title">Project Volume - Current Month Daily</h2>
                        <p id="dailyProjectVolumePeriod" class="section-note">Loading latest OrderData period</p>
                    </div>
                    <span class="status-pill"><i class="fas fa-calendar-day"></i>Daily format</span>
                </div>
                <div class="matrix-scroll">
                    <table class="table table-bordered matrix-table">
                        <thead id="dailyProjectVolumeHead">
                            <tr>
                                <th class="matrix-client">Client No</th>
                            </tr>
                        </thead>
                        <tbody id="dailyProjectVolumeBody">
                            <tr>
                                <td class="text-center text-muted p-4">Loading daily project volume</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="workbench-section">
                <div class="workbench-header">
                    <h2 class="workbench-title">Production Workbench</h2>
                    <span class="status-pill"><i class="fas fa-tools"></i>Quick actions</span>
                </div>
                <div id="productionWorkbench" class="link-grid">
                    <div class="loading-state"><i class="fas fa-circle-notch fa-spin"></i>Loading dashboard</div>
                </div>
            </div>

            <div class="row">
                <div class="col-xl-7">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Top Processes</h2>
                            <span class="status-pill"><i class="fas fa-list-ol"></i>Volume leaders</span>
                        </div>
                        <div class="dashboard-card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Process</th>
                                            <th class="text-center">Production</th>
                                            <th class="text-center">Target</th>
                                            <th style="min-width: 150px;">Achievement</th>
                                        </tr>
                                    </thead>
                                    <tbody id="topProcessBody">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted p-4">Loading process data</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-5">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Signals to Watch</h2>
                            <span class="status-pill"><i class="fas fa-chart-line"></i>Operating signals</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div id="productionSignals" class="signal-list">
                                <div class="loading-state"><i class="fas fa-circle-notch fa-spin"></i>Loading insights</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="dashboard-card">
                <div class="dashboard-card-header">
                    <h2 class="dashboard-card-title">Top Performers</h2>
                    <span class="status-pill"><i class="fas fa-user-check"></i>Employee view</span>
                </div>
                <div class="dashboard-card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th class="text-center">Code</th>
                                    <th class="text-center">Production</th>
                                    <th class="text-center">Productivity</th>
                                    <th class="text-center">Quality</th>
                                    <th class="text-center">Attendance</th>
                                    <th class="text-center">Grades</th>
                                    <th class="text-center">Details</th>
                                </tr>
                            </thead>
                            <tbody id="topEmployeeBody">
                                <tr>
                                    <td colspan="8" class="text-center text-muted p-4">Loading employee ranking</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var productionTrendChart = null;
        var processVolumeChart = null;
        var employeeRankingChart = null;
        var qualityProductivityChart = null;
        var weeklyGraphicalChart = null;
        var individualPerformanceChart = null;
        var latestProductionData = {};

        $(document).ready(function () {
            bindProductionDefaultDates();
            loadProductionDashboard();

            $("#btnProductionRefresh").on("click", function () {
                loadProductionDashboard();
            });
        });

        function bindProductionDefaultDates() {
            var today = new Date();
            var fromDate;
            var toDate;

            if (today.getDate() >= 26) {
                fromDate = new Date(today.getFullYear(), today.getMonth(), 26);
                toDate = new Date(today.getFullYear(), today.getMonth() + 1, 25);
            }
            else {
                fromDate = new Date(today.getFullYear(), today.getMonth() - 1, 26);
                toDate = new Date(today.getFullYear(), today.getMonth(), 25);
            }

            $("#productionFromDate").val(toInputDate(fromDate));
            $("#productionToDate").val(toInputDate(toDate));
        }

        function loadProductionDashboard() {
            $("#btnProductionRefresh").prop("disabled", true).html('<i class="fas fa-circle-notch fa-spin mr-1"></i> Loading');
            $("#productionDataAlert").hide();

            $.ajax({
                url: "ProductionDashboard.aspx/GetDashboardSnapshot",
                type: "POST",
                data: JSON.stringify({
                    FromDate: $("#productionFromDate").val(),
                    ToDate: $("#productionToDate").val()
                }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    latestProductionData = JSON.parse(response.d || "{}");
                    renderProductionDashboard(latestProductionData);
                },
                error: function () {
                    $("#productionDataAlert").show();
                },
                complete: function () {
                    $("#btnProductionRefresh").prop("disabled", false).html('<i class="fas fa-sync-alt mr-1"></i> Refresh');
                }
            });
        }

        function renderProductionDashboard(snapshot) {
            var kpis = snapshot.Kpis || {};
            var errors = snapshot.Errors || [];

            if (errors.length > 0) {
                $("#productionDataAlert").show();
            }

            $("#productionPeriod").html('<i class="fas fa-calendar-alt"></i> ' + safe(snapshot.FromDateText) + ' to ' + safe(snapshot.ToDateText));
            $("#productionGenerated").html('<i class="fas fa-clock"></i> ' + safe(snapshot.GeneratedOn));

            setText("kpiProductionEmployees", formatNumber(kpis.TotalEmployees));
            setText("kpiTotalProduction", formatNumber(kpis.TotalProduction));
            setText("kpiAvgProductivity", formatDecimal(kpis.AvgProductivity) + "%");
            setText("kpiAvgQuality", formatDecimal(kpis.AvgQuality) + "%");
            setText("kpiAvgAttendance", formatDecimal(kpis.AvgAttendance) + "%");
            setText("kpiTotalErrors", formatNumber(kpis.TotalErrors));
            setText("kpiProcessCount", formatNumber(kpis.ProcessCount) + " process groups");
            setText("kpiProductionDays", formatNumber(kpis.ProductiveDays) + " productive days");
            setText("kpiBestProductivity", "Best day " + formatDecimal(kpis.BestProductivity) + "%");
            setText("kpiBestQuality", "Best quality " + formatDecimal(kpis.BestQuality) + "%");
            setText("kpiErrorRate", "Error rate " + formatDecimal(kpis.ErrorRate) + "%");

            renderProductionTrend(snapshot.DateWise || []);
            renderProcessVolume(snapshot.ProcessWise || []);
            renderEmployeeRanking(snapshot.EmployeeWise || []);
            renderQualityProductivity(snapshot.QualityVsProductivity || []);
            renderWeeklyGraphicalView(snapshot.WeeklyGraphicalView || []);
            renderIndividualPerformance(snapshot.IndividualPerformance || [], snapshot.IndividualPerformancePeriod);
            renderProjectVolumeMatrix(snapshot.ProjectMonthlyVolume || {}, "#monthlyProjectVolumeHead", "#monthlyProjectVolumeBody", "#monthlyProjectVolumePeriod", "No monthly project volume available.");
            renderProjectVolumeMatrix(snapshot.ProjectDailyVolume || {}, "#dailyProjectVolumeHead", "#dailyProjectVolumeBody", "#dailyProjectVolumePeriod", "No daily project volume available.");
            renderProductionWorkbench(snapshot.Workbench || []);
            renderTopProcesses(snapshot.ProcessWise || []);
            renderTopEmployees(snapshot.EmployeeWise || []);
            renderProductionSignals(kpis);
        }

        function renderProductionTrend(rows) {
            var ctx = document.getElementById("productionTrendChart").getContext("2d");
            var labels = rows.map(function (row) { return safe(row.ProcessDate); });
            var production = rows.map(function (row) { return toNumber(row.LoanCount); });
            var target = rows.map(function (row) { return toNumber(row.Target); });

            if (!labels.length) {
                labels = ["No data"];
                production = [0];
                target = [0];
            }

            if (productionTrendChart) {
                productionTrendChart.destroy();
            }

            productionTrendChart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Production",
                            data: production,
                            borderColor: "#2563eb",
                            backgroundColor: "rgba(37, 99, 235, 0.08)",
                            pointBackgroundColor: "#2563eb",
                            borderWidth: 2,
                            fill: true,
                            lineTension: 0.25
                        },
                        {
                            label: "Target",
                            data: target,
                            borderColor: "#16a34a",
                            backgroundColor: "rgba(22, 163, 74, 0.08)",
                            pointBackgroundColor: "#16a34a",
                            borderWidth: 2,
                            fill: true,
                            lineTension: 0.25
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { position: "bottom" },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                callback: function (value) { return formatNumber(value); }
                            },
                            gridLines: { color: "#eef1f6" }
                        }],
                        xAxes: [{ gridLines: { display: false } }]
                    },
                    onClick: function (event, elements) {
                        if (elements.length > 0) {
                            var index = elements[0]._index;
                            var selectedDate = rows[index] ? rows[index].ProcessDate : "";
                            if (selectedDate) {
                                window.location.href = "ProductionDetail.aspx?type=date&date=" + encodeURIComponent(selectedDate);
                            }
                        }
                    }
                }
            });
        }

        function renderProcessVolume(rows) {
            var ctx = document.getElementById("processVolumeChart").getContext("2d");
            var topRows = rows.slice(0, 10);
            var labels = topRows.map(function (row) { return safe(row.Process); });
            var volume = topRows.map(function (row) { return toNumber(row.LoanCount); });
            var target = topRows.map(function (row) { return toNumber(row.Target); });

            if (!labels.length) {
                labels = ["No data"];
                volume = [0];
                target = [0];
            }

            if (processVolumeChart) {
                processVolumeChart.destroy();
            }

            processVolumeChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Production",
                            data: volume,
                            backgroundColor: "#0f8f8c"
                        },
                        {
                            label: "Target",
                            data: target,
                            backgroundColor: "#f97316"
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { position: "bottom" },
                    scales: {
                        yAxes: [{ ticks: { beginAtZero: true, precision: 0 }, gridLines: { color: "#eef1f6" } }],
                        xAxes: [{ gridLines: { display: false } }]
                    },
                    onClick: function (event, elements) {
                        if (elements.length > 0) {
                            var index = elements[0]._index;
                            var selectedProcess = topRows[index] ? topRows[index].Process : "";
                            if (selectedProcess) {
                                window.location.href = "ProductionDetail.aspx?type=process&process=" + encodeURIComponent(selectedProcess);
                            }
                        }
                    }
                }
            });
        }

        function renderEmployeeRanking(rows) {
            var ctx = document.getElementById("employeeRankingChart").getContext("2d");
            var topRows = rows.slice(0, 12);
            var labels = topRows.map(function (row) { return safe(row.EmployeeName); });
            var productivity = topRows.map(function (row) { return toNumber(row.ProdPerc); });

            if (!labels.length) {
                labels = ["No data"];
                productivity = [0];
            }

            if (employeeRankingChart) {
                employeeRankingChart.destroy();
            }

            employeeRankingChart = new Chart(ctx, {
                type: "horizontalBar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Productivity %",
                        data: productivity,
                        backgroundColor: "#f97316"
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { display: false },
                    scales: {
                        xAxes: [{
                            ticks: {
                                beginAtZero: true,
                                callback: function (value) { return value + "%"; }
                            },
                            gridLines: { color: "#eef1f6" }
                        }],
                        yAxes: [{ gridLines: { display: false } }]
                    },
                    onClick: function (event, elements) {
                        if (elements.length > 0) {
                            var index = elements[0]._index;
                            var row = topRows[index];
                            if (row && row.Code) {
                                window.location.href = "ProductionDetail.aspx?type=employee&code=" + encodeURIComponent(row.Code);
                            }
                        }
                    }
                }
            });
        }

        function renderQualityProductivity(rows) {
            var ctx = document.getElementById("qualityProductivityChart").getContext("2d");
            var points = rows.map(function (row) {
                return {
                    x: toNumber(row.ProdPerc),
                    y: toNumber(row.QualityPerc),
                    employee: safe(row.EmployeeName),
                    code: safe(row.Code),
                    volume: toNumber(row.LoanCount)
                };
            });

            if (!points.length) {
                points = [{ x: 0, y: 0, employee: "No data", code: "", volume: 0 }];
            }

            if (qualityProductivityChart) {
                qualityProductivityChart.destroy();
            }

            qualityProductivityChart = new Chart(ctx, {
                type: "scatter",
                data: {
                    datasets: [{
                        label: "Employees",
                        data: points,
                        backgroundColor: "#7c3aed"
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { display: false },
                    tooltips: {
                        callbacks: {
                            label: function (tooltipItem, data) {
                                var item = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                                return item.employee + " | Prod: " + item.x + "% | Quality: " + item.y + "% | Volume: " + item.volume;
                            }
                        }
                    },
                    scales: {
                        xAxes: [{
                            scaleLabel: { display: true, labelString: "Productivity %" },
                            ticks: { beginAtZero: true },
                            gridLines: { color: "#eef1f6" }
                        }],
                        yAxes: [{
                            scaleLabel: { display: true, labelString: "Quality %" },
                            ticks: { beginAtZero: true },
                            gridLines: { color: "#eef1f6" }
                        }]
                    },
                    onClick: function (event, elements) {
                        if (elements.length > 0) {
                            var point = points[elements[0]._index];
                            if (point && point.code) {
                                window.location.href = "ProductionDetail.aspx?type=employee&code=" + encodeURIComponent(point.code);
                            }
                        }
                    }
                }
            });
        }

        function renderWeeklyGraphicalView(rows) {
            rows = rows || [];
            var sampleRow = rows[0] || {};
            var weekColumn = firstExistingColumn(sampleRow, ["Week", "WeekDate", "QC Week", "QCDate", "Date"], 0);
            var volumeColumn = firstExistingColumn(sampleRow, ["Loan Qced", "Loan Qc'd", "Loan QCed", "Volume", "Production"], 1);
            var errorColumn = firstExistingColumn(sampleRow, ["Error/Loan", "Errors/Loan", "Total Error/Loan"], 10);
            var chartRows = rows.filter(function (row) {
                return safe(firstValue(row, [weekColumn])) !== "Average";
            }).slice(-14);

            var labels = chartRows.map(function (row) { return safe(firstValue(row, [weekColumn])); });
            var volume = chartRows.map(function (row) { return toNumber(firstValue(row, [volumeColumn])); });
            var errorPerLoan = chartRows.map(function (row) { return toNumber(firstValue(row, [errorColumn])); });

            if (!labels.length) {
                labels = ["No data"];
                volume = [0];
                errorPerLoan = [0];
            }

            if (weeklyGraphicalChart) {
                weeklyGraphicalChart.destroy();
            }

            weeklyGraphicalChart = new Chart(document.getElementById("weeklyGraphicalChart").getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Loan Qced",
                            data: volume,
                            backgroundColor: "#2563eb",
                            yAxisID: "volumeAxis"
                        },
                        {
                            label: "Error/Loan",
                            type: "line",
                            data: errorPerLoan,
                            borderColor: "#dc2626",
                            backgroundColor: "rgba(220, 38, 38, 0.08)",
                            pointBackgroundColor: "#dc2626",
                            fill: false,
                            lineTension: 0.25,
                            yAxisID: "errorAxis"
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { position: "bottom" },
                    scales: {
                        yAxes: [
                            {
                                id: "volumeAxis",
                                position: "left",
                                ticks: { beginAtZero: true, precision: 0 },
                                gridLines: { color: "#eef1f6" }
                            },
                            {
                                id: "errorAxis",
                                position: "right",
                                ticks: { beginAtZero: true },
                                gridLines: { display: false }
                            }
                        ],
                        xAxes: [{ gridLines: { display: false } }]
                    }
                }
            });

            renderDynamicReportTable(rows, "#weeklyGraphicalHead", "#weeklyGraphicalBody", [weekColumn, volumeColumn, errorColumn, "% No Error Files"], 8, "No weekly graphical view data available.");
        }

        function renderIndividualPerformance(rows, periodText) {
            rows = rows || [];
            $("#individualPerformancePeriod").text(periodText ? "Report period: " + periodText : "Report period unavailable");

            var topRows = rows.slice(0, 10);
            var labels = topRows.map(function (row) { return safe(firstValue(row, ["Name", "Employee", "EmployeeName", "Pseudoname", "Code"])); });
            var productivity = topRows.map(function (row) { return toNumber(firstValue(row, ["Utilization %", "Utilisation %", "ProductivityPercentage", "ProdPerc", "Production %"])); });
            var quality = topRows.map(function (row) { return qualityPercent(row); });

            if (!labels.length) {
                labels = ["No data"];
                productivity = [0];
                quality = [0];
            }

            if (individualPerformanceChart) {
                individualPerformanceChart.destroy();
            }

            individualPerformanceChart = new Chart(document.getElementById("individualPerformanceChart").getContext("2d"), {
                type: "horizontalBar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "Utilisation %",
                            data: productivity,
                            backgroundColor: "#0f8f8c"
                        },
                        {
                            label: "Quality %",
                            data: quality,
                            backgroundColor: "#f97316"
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { position: "bottom" },
                    scales: {
                        xAxes: [{
                            ticks: {
                                beginAtZero: true,
                                callback: function (value) { return value + "%"; }
                            },
                            gridLines: { color: "#eef1f6" }
                        }],
                        yAxes: [{ gridLines: { display: false } }]
                    }
                }
            });

            renderDynamicReportTable(rows, "#individualPerformanceHead", "#individualPerformanceBody", ["Segment", "Stage", "Code", "Name", "Production", "Utilization %", "Utilisation %", "Quality %", "QualPerc", "Error/Loan", "Attendance %", "Quality Grade", "Attendance Grade"], 10, "No individual performance data available.");
        }

        function renderDynamicReportTable(rows, headSelector, bodySelector, preferredColumns, limit, emptyMessage) {
            rows = rows || [];
            if (!rows.length) {
                $(headSelector).html("<tr><th>Details</th></tr>");
                $(bodySelector).html('<tr><td class="text-center text-muted p-4">' + htmlEncode(emptyMessage) + '</td></tr>');
                return;
            }

            var columns = [];
            $.each(preferredColumns, function (_, column) {
                if (column && rows[0].hasOwnProperty(column) && $.inArray(column, columns) === -1) {
                    columns.push(column);
                }
            });

            if (!columns.length) {
                $.each(rows[0], function (column) {
                    if (columns.length < 6) {
                        columns.push(column);
                    }
                });
            }

            var headHtml = "<tr>";
            $.each(columns, function (_, column) {
                headHtml += '<th' + (isNumericColumn(column) ? ' class="text-center"' : '') + '>' + htmlEncode(humanizeColumn(column)) + '</th>';
            });
            headHtml += "</tr>";

            var bodyHtml = "";
            $.each(rows.slice(0, limit || rows.length), function (_, row) {
                bodyHtml += "<tr>";
                $.each(columns, function (_, column) {
                    var value = row[column];
                    bodyHtml += '<td' + (isNumericColumn(column) ? ' class="text-center"' : '') + '>' + htmlEncode(formatReportValue(value, column)) + '</td>';
                });
                bodyHtml += "</tr>";
            });

            $(headSelector).html(headHtml);
            $(bodySelector).html(bodyHtml);
        }

        function renderProjectVolumeMatrix(matrix, headSelector, bodySelector, periodSelector, emptyMessage) {
            var columns = matrix.Columns || [];
            var rows = matrix.Rows || [];
            $(periodSelector).text(matrix.PeriodText ? matrix.PeriodText + " | latest OrderData date: " + safe(matrix.LatestDateText) : "Latest OrderData period unavailable");

            var colSpan = columns.length + 2;
            if (!columns.length || !rows.length) {
                $(headSelector).html('<tr><th class="matrix-client">Client No</th></tr>');
                $(bodySelector).html('<tr><td colspan="' + colSpan + '" class="text-center text-muted p-4">' + htmlEncode(emptyMessage) + '</td></tr>');
                return;
            }

            var headHtml = '<tr><th class="matrix-client">Client No</th>';
            $.each(columns, function (_, column) {
                headHtml += '<th>' + htmlEncode(column.Label) + '</th>';
            });
            headHtml += '<th class="matrix-total">Total</th></tr>';

            var bodyHtml = "";
            $.each(rows, function (_, row) {
                var values = row.Values || {};
                bodyHtml += '<tr><td class="matrix-client">' + htmlEncode(row.ClientNo || row.ProjectName || "NA") + '</td>';
                $.each(columns, function (_, column) {
                    bodyHtml += '<td>' + formatNumber(values[column.Key]) + '</td>';
                });
                bodyHtml += '<td class="matrix-total">' + formatNumber(row.Total) + '</td></tr>';
            });

            $(headSelector).html(headHtml);
            $(bodySelector).html(bodyHtml);
        }

        function firstExistingColumn(row, preferredColumns, fallbackIndex) {
            var columnName = "";
            $.each(preferredColumns, function (_, preferredColumn) {
                if (!columnName && row.hasOwnProperty(preferredColumn)) {
                    columnName = preferredColumn;
                }
            });

            if (columnName) {
                return columnName;
            }

            var index = 0;
            $.each(row, function (column) {
                if (!columnName && index === fallbackIndex) {
                    columnName = column;
                }
                index++;
            });

            return columnName;
        }

        function firstValue(row, columns) {
            for (var index = 0; index < columns.length; index++) {
                if (columns[index] && row.hasOwnProperty(columns[index]) && row[columns[index]] !== null && row[columns[index]] !== undefined && row[columns[index]] !== "") {
                    return row[columns[index]];
                }
            }
            return "";
        }

        function qualityPercent(row) {
            var explicitQuality = firstValue(row, ["Quality %", "QualPerc", "QualityPerc"]);
            if (explicitQuality !== "") {
                return toNumber(explicitQuality);
            }

            var errorPerLoan = firstValue(row, ["Error/Loan", "Errors/Loan"]);
            if (errorPerLoan !== "") {
                return Math.max(0, Math.min(100, 100 - (toNumber(errorPerLoan) * 100)));
            }

            return 0;
        }

        function humanizeColumn(column) {
            var names = {
                "ProductivityPercentage": "Utilisation %",
                "QualPerc": "Quality %",
                "LoanCount": "Production",
                "AttPerc": "Attendance %",
                "EmployeeName": "Employee"
            };

            if (names[column]) {
                return names[column];
            }

            return String(column).replace(/([a-z])([A-Z])/g, "$1 $2");
        }

        function isNumericColumn(column) {
            return /count|volume|perc|percentage|quality|utilisation|utilization|loan|error|target|attendance|production/i.test(column);
        }

        function formatReportValue(value, column) {
            if (value === null || value === undefined || value === "null") {
                return "";
            }

            if (isNumericColumn(column)) {
                if (/error\/loan|errors\/loan/i.test(column)) {
                    return toNumber(value).toFixed(2);
                }
                if (/perc|percentage|quality|utilisation|utilization|attendance/i.test(column)) {
                    return formatDecimal(value) + "%";
                }
                return formatNumber(value);
            }

            return safe(value);
        }

        function htmlEncode(value) {
            return $("<div/>").text(safe(value)).html();
        }

        function renderProductionWorkbench(rows) {
            var html = "";
            if (!rows.length) {
                $("#productionWorkbench").html('<div class="text-muted">No workbench data available.</div>');
                return;
            }

            $.each(rows, function (_, item) {
                html += '<div class="work-card">' +
                    '<div class="work-card-top">' +
                    '<h4><i class="' + safe(item.Icon) + ' mr-1"></i>' + safe(item.Title) + '</h4>' +
                    '<span class="work-count">' + formatNumber(item.Count) + '</span>' +
                    '</div>' +
                    '<p>' + safe(item.Description) + '</p>' +
                    '<a href="' + safe(item.Url) + '">Open section <i class="fas fa-arrow-right ml-1"></i></a>' +
                    '</div>';
            });

            $("#productionWorkbench").html(html);
        }

        function renderTopProcesses(rows) {
            var html = "";
            var topRows = rows.slice(0, 8);

            if (!topRows.length) {
                $("#topProcessBody").html('<tr><td colspan="4" class="text-center text-muted p-4">No process data available.</td></tr>');
                return;
            }

            $.each(topRows, function (_, row) {
                var achievement = toNumber(row.ProdPerc);
                html += '<tr>' +
                    '<td>' + safe(row.Process) + '</td>' +
                    '<td class="text-center font-weight-bold">' + formatNumber(row.LoanCount) + '</td>' +
                    '<td class="text-center">' + formatNumber(row.Target) + '</td>' +
                    '<td>' +

                    '<div style="font-size:11px;font-weight:600;margin-bottom:4px;color:#374151;">' +
                    formatDecimal(achievement) + '% achieved' +
                    '</div>' +

                    '<div style="' +
                    'width:100%;' +
                    'height:10px;' +
                    'background:#e5e7eb;' +
                    'border-radius:20px;' +
                    'overflow:hidden;">' +

                    '<div style="' +
                    'width:' + clampPercent(achievement) + '%;' +
                    'height:100%;' +
                    'background:' + getQualityColor(achievement) + ';' +
                    'border-radius:20px;' +
                    'transition:all .5s;">' +
                    '</div>' +

                    '</div>' +

                    '</td>' +
                    '</tr>';
            });

            $("#topProcessBody").html(html);
        }

        function getQualityColor(quality) {

            quality = parseFloat(quality || 0);

            if (quality >= 95) {
                return '#10b981';
            }

            if (quality >= 85) {
                return '#f59e0b';
            }

            return '#ef4444';
        }

        function renderTopEmployees(rows) {
            var html = "";
            var topRows = rows.slice(0, 10);

            if (!topRows.length) {
                $("#topEmployeeBody").html('<tr><td colspan="8" class="text-center text-muted p-4">No employee data available.</td></tr>');
                return;
            }

            $.each(topRows, function (_, row) {
                html += '<tr>' +
                    '<td>' + safe(row.EmployeeName) + '</td>' +
                    '<td class="text-center">' + safe(row.Code) + '</td>' +
                    '<td class="text-center font-weight-bold">' + formatNumber(row.LoanCount) + '</td>' +
                    '<td class="text-center">' + formatDecimal(row.ProdPerc) + '%</td>' +
                    '<td class="text-center">' + formatDecimal(row.QualityPerc) + '%</td>' +
                    '<td class="text-center">' + formatDecimal(row.AttPerc) + '%</td>' +
                    '<td class="text-center">' + safe(row.ProdGrade) + ' / ' + safe(row.QualGrade) + ' / ' + safe(row.AttnGrade) + '</td>' +
                    '<td class="text-center"><a href="ProductionDetail.aspx?type=employee&code=' + encodeURIComponent(safe(row.Code)) + '" title="View details"><i class="fas fa-search"></i></a></td>' +
                    '</tr>';
            });

            $("#topEmployeeBody").html(html);
        }

        function renderProductionSignals(kpis) {
            var signals = [
                {
                    label: "Output Per Employee",
                    value: formatDecimal(kpis.OutputPerEmployee),
                    copy: "Average production volume across active employees."
                },
                {
                    label: "Error Rate",
                    value: formatDecimal(kpis.ErrorRate) + "%",
                    copy: "Total errors measured against production volume."
                },
                {
                    label: "Avg Attendance",
                    value: formatDecimal(kpis.AvgAttendance) + "%",
                    copy: "Attendance percentage from the performance report."
                },
                {
                    label: "Quality Gap",
                    value: formatDecimal(kpis.QualityGap) + "%",
                    copy: "Distance from 100% quality for the selected period."
                }
            ];

            var html = "";
            $.each(signals, function (_, item) {
                html += '<div class="signal-item">' +
                    '<div class="signal-label">' + item.label + '</div>' +
                    '<div class="signal-value">' + item.value + '</div>' +
                    '<p class="signal-copy">' + item.copy + '</p>' +
                    '</div>';
            });

            $("#productionSignals").html(html);
        }

        function setText(id, value) {
            $("#" + id).text(value);
        }

        function safe(value) {
            if (value === null || value === undefined || value === "null") {
                return "";
            }
            return String(value);
        }

        function toNumber(value) {
            var parsed = parseFloat(value);
            return isNaN(parsed) ? 0 : parsed;
        }

        function formatNumber(value) {
            return Math.round(toNumber(value)).toLocaleString("en-IN");
        }

        function formatDecimal(value) {
            return toNumber(value).toFixed(1);
        }

        function clampPercent(value) {
            value = toNumber(value);
            if (value < 0) {
                return 0;
            }
            if (value > 100) {
                return 100;
            }
            return value;
        }

        function toInputDate(date) {
            var year = date.getFullYear();
            var month = ("0" + (date.getMonth() + 1)).slice(-2);
            var day = ("0" + date.getDate()).slice(-2);
            return year + "-" + month + "-" + day;
        }
    </script>
</asp:Content>
