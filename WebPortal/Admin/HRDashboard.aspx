<%@ Page Title="HR Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRDashboard.aspx.cs" Inherits="WebPortal.Admin.HRDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../plugins/chart.js/Chart.bundle.min.js"></script>
    <style>
        .hr-dashboard {
            color: #243041;
            font-family: "Source Sans Pro", Arial, sans-serif;
        }

            .hr-dashboard .dashboard-shell {
                max-width: 1480px;
                margin: 0 auto;
            }

            .hr-dashboard .dashboard-header {
                background: #ffffff;
                border: 1px solid #e5e9f0;
                border-left: 4px solid #0f8f8c;
                border-radius: 8px;
                padding: 18px 20px;
                margin-bottom: 16px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
            }

            .hr-dashboard .dashboard-title {
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                color: #182334;
            }

            .hr-dashboard .dashboard-subtitle {
                margin: 4px 0 0;
                color: #667085;
                font-size: 14px;
            }

            .hr-dashboard .period-tools {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: flex-end;
                flex-wrap: wrap;
            }

                .hr-dashboard .period-tools .form-control {
                    width: auto;
                    min-width: 132px;
                    border-radius: 6px;
                    border-color: #d8dee8;
                    font-size: 13px;
                }

            .hr-dashboard .btn-dashboard {
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                padding: 8px 12px;
            }

            .hr-dashboard .kpi-grid {
                display: grid;
                grid-template-columns: repeat(6, minmax(150px, 1fr));
                gap: 14px;
                margin-bottom: 16px;
            }

            .hr-dashboard .kpi-card {
                background: #ffffff;
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                padding: 16px;
                min-height: 132px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
            }

            .hr-dashboard .kpi-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
            }

            .hr-dashboard .kpi-icon {
                width: 38px;
                height: 38px;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                font-size: 16px;
            }

            .hr-dashboard .kpi-card:nth-child(1) .kpi-icon {
                background: #2563eb;
            }

            .hr-dashboard .kpi-card:nth-child(2) .kpi-icon {
                background: #0f8f8c;
            }

            .hr-dashboard .kpi-card:nth-child(3) .kpi-icon {
                background: #f97316;
            }

            .hr-dashboard .kpi-card:nth-child(4) .kpi-icon {
                background: #7c3aed;
            }

            .hr-dashboard .kpi-card:nth-child(5) .kpi-icon {
                background: #16a34a;
            }

            .hr-dashboard .kpi-card:nth-child(6) .kpi-icon {
                background: #dc2626;
            }

            .hr-dashboard .kpi-label {
                color: #667085;
                font-size: 13px;
                margin: 0;
            }

            .hr-dashboard .kpi-value {
                font-size: 28px;
                line-height: 1;
                font-weight: 800;
                margin: 0 0 8px;
                color: #182334;
            }

            .hr-dashboard .kpi-note {
                font-size: 12px;
                color: #7b8798;
                margin: 0;
            }

            .hr-dashboard .dashboard-card {
                background: #ffffff;
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                box-shadow: 0 8px 22px rgba(35, 48, 65, 0.06);
                margin-bottom: 16px;
                overflow: hidden;
            }

            .hr-dashboard .dashboard-card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 16px;
                border-bottom: 1px solid #eef1f6;
                min-height: 58px;
            }

            .hr-dashboard .dashboard-card-title {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #182334;
            }

            .hr-dashboard .dashboard-card-body {
                padding: 16px;
            }

            .hr-dashboard .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border-radius: 999px;
                padding: 5px 9px;
                font-size: 12px;
                font-weight: 600;
                background: #eef9f8;
                color: #0f766e;
            }

            .hr-dashboard .chart-box {
                position: relative;
                min-height: 290px;
                height: 290px;
            }

            .hr-dashboard .chart-box-small {
                min-height: 235px;
                height: 235px;
            }

            .hr-dashboard .link-grid {
                display: grid;
                grid-template-columns: repeat(4, minmax(180px, 1fr));
                gap: 12px;
            }

            .hr-dashboard .workbench-section {
                margin-bottom: 16px;
            }

            .hr-dashboard .workbench-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .hr-dashboard .workbench-title {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #182334;
            }

            .hr-dashboard .work-card {
                border: 1px solid #e7ebf2;
                border-radius: 8px;
                padding: 14px;
                min-height: 146px;
                background: #fbfcfe;
            }

            .hr-dashboard .work-card-top {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .hr-dashboard .work-card h4 {
                font-size: 15px;
                font-weight: 700;
                margin: 0;
                color: #182334;
            }

            .hr-dashboard .work-card p {
                color: #667085;
                font-size: 13px;
                min-height: 38px;
                margin: 0 0 12px;
            }

            .hr-dashboard .work-card a {
                font-size: 13px;
                font-weight: 700;
                color: #0f8f8c;
            }

            .hr-dashboard .work-count {
                min-width: 34px;
                height: 28px;
                border-radius: 6px;
                background: #ffffff;
                border: 1px solid #dfe5ee;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #182334;
                font-weight: 800;
            }

            .hr-dashboard .insight-list {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 12px;
            }

            .hr-dashboard .insight-item {
                border-left: 3px solid #0f8f8c;
                padding: 4px 0 4px 12px;
            }

            .hr-dashboard .insight-label {
                font-size: 12px;
                text-transform: uppercase;
                color: #7b8798;
                font-weight: 700;
                margin-bottom: 5px;
            }

            .hr-dashboard .insight-value {
                font-size: 18px;
                font-weight: 800;
                color: #182334;
                margin-bottom: 4px;
            }

            .hr-dashboard .insight-copy {
                color: #667085;
                font-size: 13px;
                margin: 0;
            }

            .hr-dashboard .table {
                margin-bottom: 0;
                font-size: 13px;
            }

                .hr-dashboard .table thead th {
                    background: #f5f7fb;
                    border-bottom: 1px solid #e7ebf2;
                    color: #344054;
                    font-weight: 700;
                    white-space: nowrap;
                }

                .hr-dashboard .table td {
                    vertical-align: middle;
                }

            .hr-dashboard .progress {
                height: 8px;
                border-radius: 6px;
                background: #edf1f6;
            }

            .hr-dashboard .progress-bar {
                border-radius: 6px;
            }

            .hr-dashboard .loading-state {
                min-height: 190px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #667085;
                font-weight: 600;
                gap: 8px;
            }

            .hr-dashboard .data-alert {
                display: none;
                border-radius: 8px;
                border: 1px solid #fde2bf;
                background: #fff8ed;
                color: #9a4b00;
                padding: 10px 12px;
                margin-bottom: 16px;
                font-size: 13px;
            }

        @media (max-width: 1200px) {
            .hr-dashboard .kpi-grid {
                grid-template-columns: repeat(3, minmax(160px, 1fr));
            }

            .hr-dashboard .link-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .hr-dashboard .dashboard-title {
                font-size: 21px;
            }

            .hr-dashboard .period-tools {
                justify-content: flex-start;
                margin-top: 12px;
            }

            .hr-dashboard .kpi-grid,
            .hr-dashboard .link-grid,
            .hr-dashboard .insight-list {
                grid-template-columns: 1fr;
            }

            .hr-dashboard .chart-box,
            .hr-dashboard .chart-box-small {
                height: 250px;
            }
        }
    </style>
    <style>
    .hr-loader {
        position: fixed;
        inset: 0;
        background: rgba(255,255,255,0.92);
        z-index: 99999;
        display: flex;
        align-items: center;
        justify-content: center;
        backdrop-filter: blur(3px);
    }

    .hr-loader-box {
        text-align: center;
        padding: 35px 45px;
        border-radius: 24px;
        background: #fff;
        box-shadow: 0 15px 50px rgba(0,0,0,0.12);
        max-width: 420px;
    }

    .hr-loader-box h4 {
        margin-top: 20px;
        margin-bottom: 10px;
        font-weight: 700;
        color: #111827;
    }

    .hr-loader-box p {
        color: #6b7280;
        margin: 0;
        font-size: 14px;
    }

    .hr-spinner {
        width: 70px;
        height: 70px;
        margin: auto;
        border: 6px solid #dbeafe;
        border-top: 6px solid #2563eb;
        border-radius: 50%;
        animation: spin 0.9s linear infinite;
    }

    @keyframes spin {
        100% {
            transform: rotate(360deg);
        }
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="hrLoader" class="hr-loader">
        <div class="hr-loader-box">
            <div class="hr-spinner"></div>

            <h4>Loading HR Dashboard</h4>

            <p>
                Please wait while analytics and manpower data are being prepared...
       
            </p>
        </div>
    </div>
    <div class="hr-dashboard">
        <div class="dashboard-shell">
            <div id="hrDataAlert" class="data-alert">
                <i class="fas fa-exclamation-triangle mr-1"></i>
                Some live HR data could not be loaded. The dashboard is showing the available sections.
           
            </div>

            <div class="dashboard-header">
                <div class="row align-items-center">
                    <div class="col-lg-7">
                        <h1 class="dashboard-title">HR Dashboard</h1>
                        <p class="dashboard-subtitle">Workforce, hiring, onboarding, attendance, and exit indicators in one view.</p>
                    </div>
                    <div class="col-lg-5">
                        <div class="period-tools">
                            <select id="hrDashboardMonth" class="form-control" title="Select month"></select>
                            <select id="hrDashboardYear" class="form-control" title="Select year"></select>
                            <button type="button" id="btnHrDashboardRefresh" class="btn btn-primary btn-dashboard" title="Refresh dashboard">
                                <i class="fas fa-sync-alt mr-1"></i>Refresh
                           
                            </button>
                            <a href="HRReport.aspx" class="btn btn-outline-secondary btn-dashboard" title="Open HR report">
                                <i class="fas fa-file-excel mr-1"></i>HR Report
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Total Manpower</p>
                        <span class="kpi-icon"><i class="fas fa-users"></i></span>
                    </div>
                    <p id="kpiTotalEmployees" class="kpi-value">0</p>
                    <p class="kpi-note">Current employee strength</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Present Today</p>
                        <span class="kpi-icon"><i class="fas fa-user-check"></i></span>
                    </div>
                    <p id="kpiPresentToday" class="kpi-value">0</p>
                    <p id="kpiAttendanceRate" class="kpi-note">Attendance rate 0%</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">On Leave</p>
                        <span class="kpi-icon"><i class="fas fa-calendar-minus"></i></span>
                    </div>
                    <p id="kpiOnLeave" class="kpi-value">0</p>
                    <p id="kpiLeaveRate" class="kpi-note">Leave load 0%</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Hiring Pipeline</p>
                        <span class="kpi-icon"><i class="fas fa-user-plus"></i></span>
                    </div>
                    <p id="kpiHiringPipeline" class="kpi-value">0</p>
                    <p class="kpi-note">Recruitment records this period</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">New Joinees</p>
                        <span class="kpi-icon"><i class="fas fa-id-badge"></i></span>
                    </div>
                    <p id="kpiNewJoinees" class="kpi-value">0</p>
                    <p id="kpiFollowups" class="kpi-note">0 follow-ups open</p>
                </div>

                <div class="kpi-card">
                    <div class="kpi-top">
                        <p class="kpi-label">Exit Cases</p>
                        <span class="kpi-icon"><i class="fas fa-sign-out-alt"></i></span>
                    </div>
                    <p id="kpiAttrition" class="kpi-value">0</p>
                    <p id="kpiAttritionRate" class="kpi-note">Attrition signal 0%</p>
                </div>
            </div>

            <div class="row">
                <div class="col-xl-4">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Workforce Mix</h2>
                            <span id="hrDashboardPeriod" class="status-pill"><i class="fas fa-calendar-alt"></i>Current</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box chart-box-small">
                                <canvas id="workforceMixChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-8">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Manpower by Domain</h2>
                            <span id="hrDashboardGenerated" class="status-pill"><i class="fas fa-clock"></i>Loading</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div class="chart-box">
                                <canvas id="domainChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="workbench-section">
                <div class="workbench-header">
                    <h2 class="workbench-title">HR Workbench</h2>
                    <span class="status-pill"><i class="fas fa-layer-group"></i>Priority areas</span>
                </div>
                <div id="hrWorkbench" class="link-grid">
                    <div class="loading-state"><i class="fas fa-circle-notch fa-spin"></i>Loading dashboard</div>
                </div>
            </div>

            <div class="row">
                <div class="col-xl-7">
                    <div class="dashboard-card">
                        <div class="dashboard-card-header">
                            <h2 class="dashboard-card-title">Branch Strength</h2>
                            <span class="status-pill"><i class="fas fa-building"></i>Top branches</span>
                        </div>
                        <div class="dashboard-card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Branch</th>
                                            <th class="text-center">Total</th>
                                            <th class="text-center">On Floor</th>
                                            <th class="text-center">Resigned</th>
                                            <th style="min-width: 140px;">Utilization</th>
                                        </tr>
                                    </thead>
                                    <tbody id="branchStrengthBody">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted p-4">Loading branch strength</td>
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
                            <span class="status-pill"><i class="fas fa-chart-line"></i>Live indicators</span>
                        </div>
                        <div class="dashboard-card-body">
                            <div id="hrSignals" class="insight-list">
                                <div class="loading-state"><i class="fas fa-circle-notch fa-spin"></i>Loading insights</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var workforceMixChart = null;
        var domainChart = null;

        $(document).ready(function () {
            bindHrDashboardFilters();
            loadHrDashboard();

            $("#btnHrDashboardRefresh").on("click", function () {
                loadHrDashboard();
            });
        });

        function bindHrDashboardFilters() {
            var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            var today = new Date();
            var monthSelect = $("#hrDashboardMonth");
            var yearSelect = $("#hrDashboardYear");

            monthSelect.empty();
            $.each(months, function (index, month) {
                monthSelect.append($("<option></option>").val(month).html(month));
            });
            monthSelect.val(months[today.getMonth()]);

            yearSelect.empty();
            for (var year = today.getFullYear(); year >= today.getFullYear() - 5; year--) {
                yearSelect.append($("<option></option>").val(year).html(year));
            }
            yearSelect.val(today.getFullYear());
        }

        function loadHrDashboard() {
            $("#btnHrDashboardRefresh").prop("disabled", true).html('<i class="fas fa-circle-notch fa-spin mr-1"></i> Loading');
            $("#hrDataAlert").hide();

            $.ajax({
                url: "HRDashboard.aspx/GetDashboardSnapshot",
                type: "POST",
                data: JSON.stringify({
                    Month: $("#hrDashboardMonth").val(),
                    Year: $("#hrDashboardYear").val()
                }),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var snapshot = JSON.parse(response.d || "{}");
                    renderHrDashboard(snapshot);
                },
                error: function () {
                    $("#hrDataAlert").show();
                },
                complete: function () {
                    $("#btnHrDashboardRefresh").prop("disabled", false).html('<i class="fas fa-sync-alt mr-1"></i> Refresh');
                }
            });
        }

        function renderHrDashboard(snapshot) {
            var kpis = snapshot.Kpis || {};
            var errors = snapshot.Errors || [];

            if (errors.length > 0) {
                $("#hrDataAlert").show();
            }

            $("#hrDashboardPeriod").html('<i class="fas fa-calendar-alt"></i> ' + safe(snapshot.Month) + " " + safe(snapshot.Year));
            $("#hrDashboardGenerated").html('<i class="fas fa-clock"></i> ' + safe(snapshot.GeneratedOn));

            setText("kpiTotalEmployees", formatNumber(kpis.TotalEmployees));
            setText("kpiPresentToday", formatNumber(kpis.PresentToday));
            setText("kpiOnLeave", formatNumber(kpis.OnLeave));
            setText("kpiHiringPipeline", formatNumber(kpis.HiringPipeline));
            setText("kpiNewJoinees", formatNumber(kpis.NewJoinees));
            setText("kpiAttrition", formatNumber(kpis.AttritionCases));
            setText("kpiAttendanceRate", "Attendance rate " + formatDecimal(kpis.AttendanceRate) + "%");
            setText("kpiLeaveRate", "Leave load " + formatDecimal(kpis.LeaveRate) + "%");
            setText("kpiFollowups", formatNumber(kpis.NewJoineeFollowups) + " follow-ups open");
            setText("kpiAttritionRate", "Attrition signal " + formatDecimal(kpis.AttritionRate) + "%");

            renderWorkforceMix(kpis);
            renderDomainChart(snapshot.DomainBreakdown || []);
            renderWorkbench(snapshot.ActionQueue || []);
            renderBranchStrength(snapshot.BranchBreakdown || []);
            renderSignals(kpis);

            $("#hrLoader").fadeOut(300);
        }

        function renderWorkforceMix(kpis) {
            var ctx = document.getElementById("workforceMixChart").getContext("2d");
            var data = [
                toNumber(kpis.PresentToday),
                toNumber(kpis.OnLeave),
                toNumber(kpis.ResignedEmployees),
                toNumber(kpis.AbscondingEmployees)
            ];

            if (workforceMixChart) {
                workforceMixChart.destroy();
            }

            workforceMixChart = new Chart(ctx, {
                type: "doughnut",
                data: {
                    labels: ["Present", "On Leave", "Resigned", "Absconding"],
                    datasets: [{
                        data: data,
                        backgroundColor: ["#0f8f8c", "#f97316", "#dc2626", "#7c3aed"],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { position: "bottom" },
                    cutoutPercentage: 68
                }
            });
        }

        function renderDomainChart(rows) {
            var ctx = document.getElementById("domainChart").getContext("2d");
            var labels = [];
            var values = [];

            $.each(rows, function (_, row) {
                labels.push(safe(row.Name));
                values.push(toNumber(row.Total));
            });

            if (labels.length === 0) {
                labels = ["No data"];
                values = [0];
            }

            if (domainChart) {
                domainChart.destroy();
            }

            domainChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Employees",
                        data: values,
                        backgroundColor: ["#2563eb", "#0f8f8c", "#f97316", "#7c3aed", "#16a34a", "#dc2626", "#0891b2", "#475569"],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { display: false },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                precision: 0
                            },
                            gridLines: {
                                color: "#eef1f6"
                            }
                        }],
                        xAxes: [{
                            gridLines: {
                                display: false
                            },
                            ticks: {
                                autoSkip: false,
                                maxRotation: 35,
                                minRotation: 0
                            }
                        }]
                    },
                    animation: {
                        duration: 1,
                        onComplete: function () {
                            var chartInstance = this.chart;
                            var ctx = chartInstance.ctx;

                            ctx.font = Chart.helpers.fontString(
                                12,
                                'bold',
                                Chart.defaults.global.defaultFontFamily
                            );

                            ctx.fillStyle = "#111827";
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';

                            this.data.datasets.forEach(function (dataset, i) {
                                var meta = chartInstance.controller.getDatasetMeta(i);

                                meta.data.forEach(function (bar, index) {
                                    var data = dataset.data[index];

                                    ctx.fillText(data, bar._model.x, bar._model.y - 5);
                                });
                            });
                        }
                    }
                }
            });
        }

        function renderWorkbench(rows) {
            var html = "";
            if (!rows.length) {
                $("#hrWorkbench").html('<div class="text-muted">No HR workbench data available.</div>');
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

            $("#hrWorkbench").html(html);
        }

        function renderBranchStrength(rows) {
            var html = "";
            if (!rows.length) {
                $("#branchStrengthBody").html('<tr><td colspan="5" class="text-center text-muted p-4">No branch data available.</td></tr>');
                return;
            }

            $.each(rows, function (_, row) {
                var total = toNumber(row.Total);
                var onFloor = toNumber(row.OnFloor);
                var utilization = total > 0 ? Math.round((onFloor / total) * 100) : 0;

                html += '<tr>' +
                    '<td>' + safe(row.Name) + '</td>' +
                    '<td class="text-center font-weight-bold">' + formatNumber(total) + '</td>' +
                    '<td class="text-center">' + formatNumber(onFloor) + '</td>' +
                    '<td class="text-center">' + formatNumber(row.Resigned) + '</td>' +
                   /* '<td><div class="progress"><div class="progress-bar bg-info" style="width:' + utilization + '%"></div></div><small>' + utilization + '% on floor</small></td>' +*/
                    '<td>' +

                    '<div style="font-size:11px;font-weight:600;margin-bottom:4px;color:#374151;">' +
                    formatDecimal(utilization) + '% achieved' +
                    '</div>' +

                    '<div style="' +
                    'width:100%;' +
                    'height:10px;' +
                    'background:#e5e7eb;' +
                    'border-radius:20px;' +
                    'overflow:hidden;">' +

                    '<div style="' +
                    'width:' + clampPercent(utilization) + '%;' +
                    'height:100%;' +
                    'background:' + getQualityColor(utilization) + ';' +
                    'border-radius:20px;' +
                    'transition:all .5s;">' +
                    '</div>' +

                    '</div>' +

                    '</td>' +
                    '</tr>';
            });

            $("#branchStrengthBody").html(html);
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

        function renderSignals(kpis) {
            var signals = [
                {
                    label: "Attendance",
                    value: formatDecimal(kpis.AttendanceRate) + "%",
                    copy: "Present against total manpower."
                },
                {
                    label: "Leave Load",
                    value: formatDecimal(kpis.LeaveRate) + "%",
                    copy: formatNumber(kpis.OnLeave) + " employees currently marked on leave."
                },
                {
                    label: "Onboarding",
                    value: formatNumber(kpis.NewJoineeFollowups),
                    copy: "Follow-ups pending for new joinee experience."
                }
            ];

            var html = "";
            $.each(signals, function (_, item) {
                html += '<div class="insight-item">' +
                    '<div class="insight-label">' + item.label + '</div>' +
                    '<div class="insight-value">' + item.value + '</div>' +
                    '<p class="insight-copy">' + item.copy + '</p>' +
                    '</div>';
            });

            $("#hrSignals").html(html);
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
    </script>
</asp:Content>
