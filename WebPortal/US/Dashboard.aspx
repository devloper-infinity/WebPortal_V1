<%@ Page Title="US Dashboard" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebPortal.US.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dash-page {
            color: #172033;
            padding-bottom: 24px;
        }

        .dash-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 20px 22px;
            margin-bottom: 16px;
            border-radius: 8px;
            color: #fff;
            background: linear-gradient(135deg, #0f766e 0%, #2563eb 55%, #334155 100%);
            box-shadow: 0 14px 34px rgba(15, 23, 42, .16);
        }

        .dash-title-wrap {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .dash-title-icon {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: rgba(255, 255, 255, .16);
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .22);
            flex: 0 0 auto;
            font-size: 20px;
        }

        .dash-title {
            margin: 0;
            font-size: 24px;
            line-height: 1.15;
            font-weight: 800;
        }

        .dash-subtitle {
            margin: 5px 0 0;
            color: rgba(255, 255, 255, .86);
            font-size: 13px;
        }

        .dash-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .dash-chip,
        .dash-refresh {
            min-height: 36px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .dash-chip {
            color: #f8fafc;
            background: rgba(255, 255, 255, .14);
            border: 1px solid rgba(255, 255, 255, .18);
        }

        .dash-refresh {
            border: 0;
            color: #0f172a;
            background: #fff;
            box-shadow: 0 8px 18px rgba(15, 23, 42, .15);
        }

        .dash-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(160px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .dash-card {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            min-height: 116px;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            color: #172033;
            text-decoration: none;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .07);
        }

        .dash-card:hover {
            color: #172033;
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 14px 30px rgba(15, 23, 42, .11);
        }

        .dash-card-icon {
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            flex: 0 0 auto;
            color: #fff;
            background: #2563eb;
        }

        .dash-card.teal .dash-card-icon {
            background: #0f766e;
        }

        .dash-card.slate .dash-card-icon {
            background: #475569;
        }

        .dash-card-label {
            margin: 0;
            color: #64748b;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .dash-card-value {
            margin: 5px 0 3px;
            font-size: 26px;
            line-height: 1.05;
            font-weight: 850;
            color: #0f172a;
        }

        .dash-card-note {
            margin: 0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.35;
        }

        .dash-panel {
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .dash-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid #e2e8f0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .dash-panel-title {
            margin: 0;
            font-size: 15px;
            font-weight: 850;
            color: #0f172a;
        }

        .dash-panel-link {
            color: #2563eb;
            font-size: 12px;
            font-weight: 800;
        }

        .dash-table {
            margin-bottom: 0 !important;
            font-size: 12px;
        }

        .dash-table th {
            white-space: nowrap;
            color: #334155;
            background: #f8fafc;
        }

        .dash-table td {
            vertical-align: middle;
            white-space: nowrap;
        }

        .dash-empty {
            padding: 18px;
            color: #64748b;
            font-size: 13px;
            text-align: center;
            background: #f8fafc;
        }

        .dash-continue {
            border: 0;
            border-radius: 8px;
            padding: 6px 10px;
            color: #fff;
            background: #2563eb;
            font-size: 12px;
            font-weight: 800;
        }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        @media (max-width: 900px) {
            .dash-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .dash-actions {
                justify-content: flex-start;
            }

            .dash-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        var dashboardQueueRows = [];

        $(document).ready(function () {
            $("#dash-refresh").on("click", function () {
                return dashboard_loadQueue();
            });

            $("#dash-queue-body").on("click", ".dash-continue", function () {
                var index = parseInt($(this).data("index"), 10);
                return dashboard_continue(index);
            });

            dashboard_loadQueue();
        });

        function dashboard_loadQueue() {
            $("#load1").show();
            PageMethods.GetMyQueueDashboard(
                function (data) {
                    $("#load1").hide();
                    dashboardQueueRows = data.Rows || [];
                    dashboard_render(data || {});
                },
                function (error) {
                    $("#load1").hide();
                    $("#dash-queue-body").html("<tr><td colspan=\"6\"><div class=\"dash-empty\">" + safeHtml(error.get_message ? error.get_message() : error.responseText) + "</div></td></tr>");
                }
            );

            return false;
        }

        function dashboard_render(data) {
            $("#dash-generated").text(data.GeneratedOn || "");
            $("#dash-open-count").text(data.QueueCount || 0);
            $("#dash-card-count").text(data.QueueCount || 0);
            $("#dash-card-oldest").text(data.OldestElapsed || "0 min");
            $("#dash-card-latest").text(data.LatestStarted || "-");

            if (!dashboardQueueRows.length) {
                $("#dash-queue-body").html("<tr><td colspan=\"6\"><div class=\"dash-empty\">No in-process loans found.</div></td></tr>");
                return;
            }

            var html = dashboardQueueRows.slice(0, 8).map(function (row, index) {
                return "" +
                    "<tr>" +
                    "  <td><button type=\"button\" class=\"dash-continue\" data-index=\"" + index + "\"><i class=\"fas fa-play\"></i> Continue</button></td>" +
                    "  <td title=\"" + safeAttr(row.Client) + "\">" + safeHtml(row.Client) + "</td>" +
                    "  <td title=\"" + safeAttr(row.DealNo) + "\">" + safeHtml(row.DealNo) + "</td>" +
                    "  <td title=\"" + safeAttr(row.LoanNo) + "\">" + safeHtml(row.LoanNo) + "</td>" +
                    "  <td title=\"" + safeAttr(row.StartDatetime) + "\">" + safeHtml(row.StartDatetime) + "</td>" +
                    "  <td>" + safeHtml(formatElapsed(row.ElapsedMinutes)) + "</td>" +
                    "</tr>";
            }).join("");

            $("#dash-queue-body").html(html);
        }

        function dashboard_continue(index) {
            var row = dashboardQueueRows[index];
            if (!row) {
                return false;
            }

            var payload = {
                ln: row.LoanNo || "",
                dn: row.DealNo || "",
                tp: row.ProcessID || "",
                src: "Dashboard",
                client: row.Client || "",
                od: row.OrderDate || "",
                process: row.Process || "",
                review: row.Review || "",
                sd: row.StartDatetime || "",
                started: true
            };

            var encoded = btoa(JSON.stringify(payload));
            window.location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
            return false;
        }

        function formatElapsed(value) {
            var minutes = Math.max(0, parseInt(value || 0, 10) || 0);
            if (minutes < 60) {
                return minutes + " min";
            }

            var hours = Math.floor(minutes / 60);
            var remaining = minutes % 60;
            return hours + " hr " + remaining + " min";
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
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dash-page">
        <section class="dash-hero">
            <div class="dash-title-wrap">
                <span class="dash-title-icon"><i class="fas fa-chart-line"></i></span>
                <div>
                    <h1 class="dash-title">US Dashboard</h1>
                    <p class="dash-subtitle">Focused view of started loans and active feedback work.</p>
                </div>
            </div>
            <div class="dash-actions">
                <span class="dash-chip"><i class="fas fa-spinner"></i><span id="dash-open-count">0</span><span>In Process</span></span>
                <span class="dash-chip"><i class="far fa-clock"></i><span id="dash-generated"></span></span>
                <button type="button" id="dash-refresh" class="dash-refresh">
                    <i class="fas fa-sync-alt"></i>
                    <span>Refresh</span>
                </button>
            </div>
        </section>

        <div class="dash-grid">
            <a class="dash-card teal" href="MyQueue.aspx">
                <span class="dash-card-icon"><i class="fas fa-stream"></i></span>
                <span>
                    <p class="dash-card-label">My Queue</p>
                    <p class="dash-card-value" id="dash-card-count">0</p>
                    <p class="dash-card-note">Started loans waiting for completion</p>
                </span>
            </a>
            <a class="dash-card" href="LoanDetails.aspx">
                <span class="dash-card-icon"><i class="fas fa-clipboard-list"></i></span>
                <span>
                    <p class="dash-card-label">My Task</p>
                    <p class="dash-card-value" id="dash-card-oldest">0 min</p>
                    <p class="dash-card-note">Oldest in-process elapsed time</p>
                </span>
            </a>
            <a class="dash-card slate" href="GlobalSearch.aspx">
                <span class="dash-card-icon"><i class="fas fa-search"></i></span>
                <span>
                    <p class="dash-card-label">Global Search</p>
                    <p class="dash-card-value" id="dash-card-latest">-</p>
                    <p class="dash-card-note">Latest started loan timestamp</p>
                </span>
            </a>
        </div>

        <section class="dash-panel">
            <div class="dash-panel-header">
                <h2 class="dash-panel-title">In-Process Loans</h2>
                <a class="dash-panel-link" href="MyQueue.aspx">View My Queue</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover dash-table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th style="width: 100px;">Action</th>
                            <th>Client</th>
                            <th>Deal #</th>
                            <th>Loan #</th>
                            <th>Start DateTime</th>
                            <th>Elapsed</th>
                        </tr>
                    </thead>
                    <tbody id="dash-queue-body"></tbody>
                </table>
            </div>
        </section>
    </div>
</asp:Content>
