<%@ Page Title="My Queue" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="MyQueue.aspx.cs" Inherits="WebPortal.US.MyQueue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .queue-page {
            color: #172033;
            padding-bottom: 24px;
        }

        .queue-hero {
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

        .queue-title-wrap {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .queue-title-icon {
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

        .queue-title {
            margin: 0;
            font-size: 24px;
            line-height: 1.15;
            font-weight: 800;
        }

        .queue-subtitle {
            margin: 5px 0 0;
            color: rgba(255, 255, 255, .86);
            font-size: 13px;
        }

        .queue-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .queue-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 36px;
            padding: 8px 11px;
            border-radius: 8px;
            color: #f8fafc;
            background: rgba(255, 255, 255, .14);
            border: 1px solid rgba(255, 255, 255, .18);
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .queue-btn {
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

        .queue-panel {
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .queue-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 14px 16px;
            border-bottom: 1px solid #e2e8f0;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .queue-panel-title {
            margin: 0;
            font-size: 15px;
            font-weight: 850;
            color: #0f172a;
        }

        .queue-panel-meta {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
        }

        .queue-empty {
            display: none;
            padding: 18px;
            color: #64748b;
            font-size: 13px;
            text-align: center;
            border-top: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .queue-table {
            margin-bottom: 0 !important;
            font-size: 12px;
        }

        .queue-table th {
            white-space: nowrap;
            color: #334155;
            background: #f8fafc;
        }

        .queue-table td {
            vertical-align: middle;
            white-space: nowrap;
        }

        .queue-continue {
            border: 0;
            border-radius: 8px;
            padding: 6px 10px;
            color: #fff;
            background: #2563eb;
            font-size: 12px;
            font-weight: 800;
        }

        .queue-status {
            display: inline-flex;
            align-items: center;
            min-height: 24px;
            padding: 4px 8px;
            border-radius: 999px;
            color: #0f766e;
            background: #ccfbf1;
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
    </style>

    <script>
        var myQueueRows = [];
        var myQueueTable = null;

        $(document).ready(function () {
            $("#myqueue_refresh").on("click", function () {
                return myqueue_load();
            });

            $("#myqueue_table tbody").on("click", ".queue-continue", function () {
                var index = parseInt($(this).data("index"), 10);
                return myqueue_continue(index);
            });

            myqueue_load();
        });

        function myqueue_load() {
            $("#load1").show();
            PageMethods.GetStartedLoans(
                function (result) {
                    $("#load1").hide();
                    myQueueRows = JSON.parse(result || "[]");
                    myqueue_render(myQueueRows);
                },
                function (error) {
                    $("#load1").hide();
                    alert(error.get_message ? error.get_message() : error.responseText);
                }
            );

            return false;
        }

        function myqueue_render(rows) {
            if ($.fn.DataTable.isDataTable("#myqueue_table")) {
                $("#myqueue_table").DataTable().clear().destroy();
            }

            var html = rows.map(function (row, index) {
                return "" +
                    "<tr>" +
                    "  <td><button type=\"button\" class=\"queue-continue\" data-index=\"" + index + "\"><i class=\"fas fa-play\"></i> Continue</button></td>" +
                    "  <td title=\"" + safeAttr(row.Client) + "\">" + safeHtml(row.Client) + "</td>" +
                    "  <td title=\"" + safeAttr(row.DealNo) + "\">" + safeHtml(row.DealNo) + "</td>" +
                    "  <td title=\"" + safeAttr(row.LoanNo) + "\">" + safeHtml(row.LoanNo) + "</td>" +
                    "  <td title=\"" + safeAttr(row.OrderDate) + "\">" + safeHtml(row.OrderDate) + "</td>" +
                    "  <td title=\"" + safeAttr(row.Review) + "\">" + safeHtml(row.Review) + "</td>" +
                    "  <td title=\"" + safeAttr(row.StartDatetime) + "\">" + safeHtml(row.StartDatetime) + "</td>" +
                    "  <td>" + safeHtml(formatElapsed(row.ElapsedMinutes)) + "</td>" +
                    "  <td><span class=\"queue-status\">" + safeHtml(row.Status || "Started") + "</span></td>" +
                    "</tr>";
            }).join("");

            $("#myqueue_table tbody").html(html);
            $("#myqueue_count").text(rows.length);
            $("#myqueue_empty").toggle(rows.length === 0);

            if (rows.length > 0) {
                myQueueTable = $("#myqueue_table").DataTable({
                    dom: "lBftip",
                    destroy: true,
                    scrollX: true,
                    ordering: true,
                    order: [[6, "desc"]],
                    pageLength: 25,
                    buttons: [
                        { extend: "excelHtml5", title: "My Queue", autoFilter: true }
                    ]
                });
            }
        }

        function myqueue_continue(index) {
            var row = myQueueRows[index];
            if (!row) {
                return false;
            }

            var payload = {
                ln: row.LoanNo || "",
                dn: row.DealNo || "",
                tp: row.ProcessID || "",
                src: "MyQueue",
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

    <div class="queue-page">
        <section class="queue-hero">
            <div class="queue-title-wrap">
                <span class="queue-title-icon"><i class="fas fa-stream"></i></span>
                <div>
                    <h1 class="queue-title">My Queue</h1>
                    <p class="queue-subtitle">Loans already started and waiting for completion.</p>
                </div>
            </div>
            <div class="queue-actions">
                <span class="queue-chip"><i class="fas fa-spinner"></i><span id="myqueue_count">0</span><span>In Process</span></span>
                <button type="button" id="myqueue_refresh" class="queue-btn">
                    <i class="fas fa-sync-alt"></i>
                    <span>Refresh</span>
                </button>
            </div>
        </section>

        <section class="queue-panel">
            <div class="queue-panel-header">
                <h2 class="queue-panel-title">Started Loans</h2>
                <span class="queue-panel-meta">Current logged-in user</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover queue-table" id="myqueue_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th style="width: 100px;">Action</th>
                            <th>Client</th>
                            <th>Deal #</th>
                            <th>Loan #</th>
                            <th>Order Date</th>
                            <th>Reviewer</th>
                            <th>Start DateTime</th>
                            <th>Elapsed</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <div id="myqueue_empty" class="queue-empty">No in-process loans found.</div>
        </section>
    </div>
</asp:Content>
