<%@ Page Title="US Dashboard" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="USDashboard.aspx.cs" Inherits="WebPortal.US.USDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../plugins/chart.js/Chart.min.js"></script>
    <style>
        .content-wrapper,
        .content {
            background: #f6f8fb !important;
        }

        .content .container {
            max-width: 100% !important;
            width: 100% !important;
        }

        .usd-page {
          /*  padding: 18px 10px 28px;*/
            color: #172033;
        }

        .usd-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            min-height: 118px;
            padding: 22px 24px;
            margin-bottom: 16px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #0f766e 0%, #2563eb 56%, #334155 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .usd-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
            min-width: 0;
        }

        .usd-title-icon {
            width: 48px;
            height: 48px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: rgba(255,255,255,.16);
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.22);
            flex: 0 0 auto;
            font-size: 21px;
        }

        .usd-title {
            margin: 0;
            font-size: 25px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: 0;
        }

        .usd-subtitle {
            margin: 6px 0 0;
            color: rgba(255,255,255,.86);
            font-size: 13px;
            line-height: 1.4;
        }

        .usd-hero-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .usd-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 36px;
            padding: 8px 11px;
            border-radius: 8px;
            color: #f8fafc;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.18);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .usd-refresh-btn {
            min-height: 36px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 0;
            border-radius: 8px;
            padding: 8px 13px;
            color: #0f172a;
            background: #fff;
            font-weight: 800;
            box-shadow: 0 8px 18px rgba(15, 23, 42, .15);
        }

        .usd-refresh-btn:disabled {
            opacity: .72;
            cursor: wait;
        }

        .usd-alert {
            border-radius: 8px;
            border: 1px solid #fde68a;
            background: #fffbeb;
            color: #7c2d12;
            padding: 10px 12px;
            margin-bottom: 14px;
            font-size: 13px;
        }

        .usd-stat-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(150px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .usd-stat-card {
            display: flex;
            min-height: 116px;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            color: #172033;
            text-decoration: none;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .07);
        }

        .usd-stat-card:hover {
            color: #172033;
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 14px 30px rgba(15, 23, 42, .11);
        }

        .usd-stat-icon {
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            margin-right: 12px;
            flex: 0 0 auto;
            color: #fff;
            background: #2563eb;
        }

        .usd-tone-teal .usd-stat-icon { background: #0f766e; }
        .usd-tone-blue .usd-stat-icon { background: #2563eb; }
        .usd-tone-green .usd-stat-icon { background: #16a34a; }
        .usd-tone-amber .usd-stat-icon { background: #d97706; }
        .usd-tone-red .usd-stat-icon { background: #dc2626; }
        .usd-tone-slate .usd-stat-icon { background: #475569; }

        .usd-stat-body {
            min-width: 0;
            flex: 1 1 auto;
        }

        .usd-stat-label {
            margin: 0;
            color: #64748b;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .usd-stat-value {
            margin: 5px 0 3px;
            font-size: 25px;
            line-height: 1.05;
            font-weight: 850;
            color: #0f172a;
        }

        .usd-stat-note {
            margin: 0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.35;
        }

        .usd-panel {
            height: 100%;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .usd-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            min-height: 58px;
            padding: 14px 16px;
            border-bottom: 1px solid #e2e8f0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .usd-panel-title {
            margin: 0;
            font-size: 15px;
            font-weight: 850;
            color: #0f172a;
        }

        .usd-panel-meta {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .usd-panel-body {
            padding: 16px;
        }

        .usd-chart-wrap {
            height: 235px;
            position: relative;
        }

        .usd-metric-list {
            display: grid;
            grid-template-columns: repeat(3, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 14px;
        }

        .usd-metric {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            background: #f8fafc;
        }

        .usd-metric-label {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            color: #475569;
            font-size: 12px;
            font-weight: 800;
        }

        .usd-metric-value {
            margin-top: 8px;
            font-size: 20px;
            font-weight: 850;
            color: #0f172a;
        }

        .usd-progress {
            height: 7px;
            border-radius: 8px;
            background: #e2e8f0;
            overflow: hidden;
            margin-top: 9px;
        }

        .usd-progress span {
            display: block;
            height: 100%;
            border-radius: 8px;
            background: #2563eb;
        }

        .usd-metric.usd-tone-green .usd-progress span { background: #16a34a; }
        .usd-metric.usd-tone-amber .usd-progress span { background: #d97706; }
        .usd-metric.usd-tone-red .usd-progress span { background: #dc2626; }

        .usd-table {
            width: 100%;
            margin: 0;
            table-layout: fixed;
            font-size: 12px;
        }

        .usd-table th {
            border-top: 0 !important;
            color: #334155;
            background: #f1f5f9;
            font-weight: 850;
        }

        .usd-table td,
        .usd-table th {
            padding: 10px 9px !important;
            vertical-align: middle !important;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .usd-badge {
            display: inline-flex;
            align-items: center;
            max-width: 100%;
            min-height: 24px;
            padding: 3px 8px;
            border-radius: 8px;
            background: #eef2ff;
            color: #3730a3;
            font-size: 11px;
            font-weight: 850;
        }

        .usd-empty {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 128px;
            color: #64748b;
            font-size: 13px;
            font-weight: 700;
            text-align: center;
        }

        .usd-module-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
        }

        .usd-module-group {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            background: #fff;
            overflow: hidden;
        }

        .usd-module-title {
            display: flex;
            align-items: center;
            gap: 8px;
            min-height: 40px;
            padding: 10px 12px;
            color: #0f172a;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            font-size: 13px;
            font-weight: 850;
        }

        .usd-module-link {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 9px 12px;
            color: #1e293b;
            text-decoration: none;
            border-bottom: 1px solid #edf2f7;
            font-size: 12px;
            font-weight: 750;
        }

        .usd-module-link:last-child {
            border-bottom: 0;
        }

        .usd-module-link:hover {
            color: #0f766e;
            background: #f0fdfa;
            text-decoration: none;
        }

        .usd-module-link i {
            color: #64748b;
            flex: 0 0 auto;
        }

        @media (max-width: 1199px) {
            .usd-stat-grid {
                grid-template-columns: repeat(3, minmax(150px, 1fr));
            }
        }

        @media (max-width: 767px) {
            .usd-page {
                padding: 12px 0 20px;
            }

            .usd-hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 18px;
            }

            .usd-hero-actions {
                width: 100%;
                justify-content: flex-start;
            }

            .usd-stat-grid,
            .usd-metric-list,
            .usd-module-grid {
                grid-template-columns: 1fr;
            }

            .usd-title {
                font-size: 21px;
            }
        }
    </style>
    <script>
        var usdActivityChart = null;

        $(document).ready(function () {
            loadUSDashboard();
            $("#usd-refresh").on("click", loadUSDashboard);
        });

        function loadUSDashboard() {
            $("#usd-refresh").prop("disabled", true);
            $("#usd-refresh i").addClass("fa-spin");
            $("#usd-alert").addClass("d-none").text("");

            $.ajax({
                type: "POST",
                url: "USDashboard.aspx/GetDashboardSnapshot",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    renderUSDashboard(response.d || {});
                },
                error: function (xhr) {
                    var message = xhr && xhr.responseText ? xhr.responseText : "Dashboard data could not be loaded.";
                    $("#usd-alert").removeClass("d-none").text(message);
                },
                complete: function () {
                    $("#usd-refresh").prop("disabled", false);
                    $("#usd-refresh i").removeClass("fa-spin");
                }
            });
        }

        function renderUSDashboard(data) {
            renderWarnings(data.Warnings || []);
            $("#usd-period").text(data.PeriodLabel || "Current month");
            $("#usd-generated").text(data.GeneratedOn || "");

            var user = data.UserInfo || {};
            $("#usd-user-name").text(firstValue(user, ["EmployeeName", "EmpName", "Name", "FullName", "UserName"]) || "US Dashboard");
            $("#usd-user-role").text(firstValue(user, ["Designation", "Role", "Department", "BranchName"]) || "User activity overview");

            renderTiles(data.Tiles || []);
            renderChart(data.ChartLabels || [], data.ChartValues || []);
            renderMetrics(data.PerformanceMetrics || []);
            renderActivityTable("#usd-activity-body", data.RecentActivity || [], "No current month activity found.");
            renderActivityTable("#usd-task-body", data.PendingTasks || [], "No pending task notifications found.");
            renderModules(data.ModuleGroups || []);
        }

        function renderWarnings(warnings) {
            if (!warnings.length) {
                return;
            }

            $("#usd-alert").removeClass("d-none").text("Some dashboard sections could not load: " + warnings.join("; "));
        }

        function renderTiles(tiles) {
            var html = tiles.map(function (tile) {
                return '' +
                    '<a class="usd-stat-card usd-tone-' + safeAttr(tile.Tone || "blue") + '" href="' + safeAttr(tile.Url || "#") + '">' +
                    '  <span class="usd-stat-icon"><i class="' + safeAttr(tile.Icon || "fas fa-chart-bar") + '"></i></span>' +
                    '  <span class="usd-stat-body">' +
                    '    <p class="usd-stat-label">' + safeHtml(tile.Title) + '</p>' +
                    '    <p class="usd-stat-value">' + safeHtml(tile.Value) + '</p>' +
                    '    <p class="usd-stat-note">' + safeHtml(tile.Subtitle) + '</p>' +
                    '  </span>' +
                    '</a>';
            }).join("");

            $("#usd-stat-grid").html(html);
        }

        function renderChart(labels, values) {
            var canvas = document.getElementById("usd-activity-chart");
            if (!canvas || typeof Chart === "undefined") {
                return;
            }

            if (usdActivityChart) {
                usdActivityChart.destroy();
            }

            usdActivityChart = new Chart(canvas.getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Records",
                        data: values,
                        backgroundColor: ["#2563eb", "#0f766e", "#16a34a", "#d97706", "#475569"],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: { display: false },
                    tooltips: { mode: "index", intersect: false },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                precision: 0
                            },
                            gridLines: {
                                color: "rgba(148, 163, 184, .22)"
                            }
                        }],
                        xAxes: [{
                            gridLines: { display: false }
                        }]
                    }
                }
            });
        }

        function renderMetrics(metrics) {
            var html = metrics.map(function (metric) {
                var percent = parseInt(metric.Percent || 0, 10);
                percent = Math.max(0, Math.min(100, percent));
                return '' +
                    '<div class="usd-metric usd-tone-' + safeAttr(metric.Tone || "blue") + '">' +
                    '  <div class="usd-metric-label"><span>' + safeHtml(metric.Title) + '</span><i class="' + safeAttr(metric.Icon || "fas fa-circle") + '"></i></div>' +
                    '  <div class="usd-metric-value">' + safeHtml(metric.Value) + '</div>' +
                    '  <div class="usd-progress"><span style="width:' + percent + '%"></span></div>' +
                    '</div>';
            }).join("");

            $("#usd-metrics").html(html);
        }

        function renderActivityTable(selector, rows, emptyText) {
            if (!rows.length) {
                $(selector).html('<tr><td colspan="4"><div class="usd-empty">' + safeHtml(emptyText) + '</div></td></tr>');
                return;
            }

            var html = rows.map(function (row) {
                return '' +
                    '<tr>' +
                    '  <td><span class="usd-badge">' + safeHtml(row.Area) + '</span></td>' +
                    '  <td title="' + safeAttr(row.Reference) + '">' + safeHtml(row.Reference) + '</td>' +
                    '  <td title="' + safeAttr(row.Status) + '">' + safeHtml(row.Status) + '</td>' +
                    '  <td title="' + safeAttr(row.ActivityDate) + '">' + safeHtml(row.ActivityDate) + '</td>' +
                    '</tr>';
            }).join("");

            $(selector).html(html);
        }

        function renderModules(groups) {
            var html = groups.map(function (group) {
                var links = (group.Links || []).map(function (link) {
                    return '' +
                        '<a class="usd-module-link" href="' + safeAttr(link.Url || "#") + '">' +
                        '  <span>' + safeHtml(link.Title) + '</span>' +
                        '  <i class="fas fa-arrow-right"></i>' +
                        '</a>';
                }).join("");

                return '' +
                    '<div class="usd-module-group">' +
                    '  <div class="usd-module-title"><i class="' + safeAttr(group.Icon || "fas fa-folder") + '"></i><span>' + safeHtml(group.Title) + '</span></div>' +
                    links +
                    '</div>';
            }).join("");

            $("#usd-module-grid").html(html);
        }

        function firstValue(source, names) {
            for (var i = 0; i < names.length; i++) {
                if (source[names[i]] !== undefined && source[names[i]] !== null && source[names[i]] !== "") {
                    return source[names[i]];
                }
            }
            return "";
        }

        function safeHtml(value) {
            return $("<div/>").text(value === null || value === undefined ? "" : value).html();
        }

        function safeAttr(value) {
            return safeHtml(value).replace(/"/g, "&quot;");
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="usd-page">
        <div id="usd-alert" class="usd-alert d-none"></div>

        <section class="usd-hero">
            <div class="usd-title-wrap">
                <span class="usd-title-icon"><i class="fas fa-chart-line"></i></span>
                <div>
                    <h1 class="usd-title">US Dashboard</h1>
                    <p class="usd-subtitle"><span id="usd-user-name">US Dashboard</span> <span id="usd-user-role"></span></p>
                </div>
            </div>
            <div class="usd-hero-actions">
                <span class="usd-chip"><i class="far fa-calendar-alt"></i><span id="usd-period">Current month</span></span>
                <span class="usd-chip"><i class="far fa-clock"></i><span id="usd-generated"></span></span>
                <button type="button" id="usd-refresh" class="usd-refresh-btn">
                    <i class="fas fa-sync-alt"></i>
                    <span>Refresh</span>
                </button>
            </div>
        </section>

        <div id="usd-stat-grid" class="usd-stat-grid"></div>

        <div class="row">
            <div class="col-lg-7 mb-3">
                <section class="usd-panel">
                    <div class="usd-panel-header">
                        <h2 class="usd-panel-title">Activity Mix</h2>
                        <span class="usd-panel-meta">Current Month</span>
                    </div>
                    <div class="usd-panel-body">
                        <div class="usd-chart-wrap">
                            <canvas id="usd-activity-chart"></canvas>
                        </div>
                        <div id="usd-metrics" class="usd-metric-list"></div>
                    </div>
                </section>
            </div>
            <div class="col-lg-5 mb-3">
                <section class="usd-panel">
                    <div class="usd-panel-header">
                        <h2 class="usd-panel-title">Pending Tasks</h2>
                        <span class="usd-panel-meta">Notifications</span>
                    </div>
                    <div class="usd-panel-body p-0">
                        <table class="table usd-table">
                            <thead>
                                <tr>
                                    <th style="width: 26%;">Area</th>
                                    <th>Reference</th>
                                    <th>Status</th>
                                    <th style="width: 22%;">Date</th>
                                </tr>
                            </thead>
                            <tbody id="usd-task-body"></tbody>
                        </table>
                    </div>
                </section>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-7 mb-3">
                <section class="usd-panel">
                    <div class="usd-panel-header">
                        <h2 class="usd-panel-title">Recent User Activity</h2>
                        <span class="usd-panel-meta">Credit, servicing, production</span>
                    </div>
                    <div class="usd-panel-body p-0">
                        <table class="table usd-table">
                            <thead>
                                <tr>
                                    <th style="width: 22%;">Area</th>
                                    <th>Reference</th>
                                    <th>Status</th>
                                    <th style="width: 23%;">Date</th>
                                </tr>
                            </thead>
                            <tbody id="usd-activity-body"></tbody>
                        </table>
                    </div>
                </section>
            </div>
            <div class="col-lg-5 mb-3">
                <section class="usd-panel">
                    <div class="usd-panel-header">
                        <h2 class="usd-panel-title">US Pages</h2>
                        <span class="usd-panel-meta">Module Map</span>
                    </div>
                    <div class="usd-panel-body">
                        <div id="usd-module-grid" class="usd-module-grid"></div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</asp:Content>
