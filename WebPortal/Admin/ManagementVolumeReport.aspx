<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManagementVolumeReport.aspx.cs" Inherits="WebPortal.Admin.ManagementVolumeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../plugins/chart.js/Chart.min.js"></script>

    <style>
        .mvr-page {
            color: #243041;
            padding: 12px;
        }

        .mvr-header {
            margin-bottom: 12px;
        }

        .mvr-panel,
        .mvr-card,
        .mvr-table-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.05);
        }

        .mvr-panel {
            margin-bottom: 12px;
            padding: 14px;
        }

        .mvr-panel-title {
            color: #1f2937;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .mvr-label {
            color: #4b5563;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .mvr-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .mvr-card {
            border-left: 4px solid #2f80ed;
            min-height: 96px;
            padding: 12px 14px;
        }

        .mvr-card.green {
            border-left-color: #219653;
        }

        .mvr-card.orange {
            border-left-color: #f2994a;
        }

        .mvr-card.red {
            border-left-color: #d64550;
        }

        .mvr-card.teal {
            border-left-color: #00a3a3;
        }

        .mvr-card.gray {
            border-left-color: #64748b;
        }

        .mvr-card span {
            color: #64748b;
            display: block;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0;
            text-transform: uppercase;
        }

        .mvr-card strong {
            color: #111827;
            display: block;
            font-size: 24px;
            line-height: 1.2;
            margin-top: 8px;
            word-break: break-word;
        }

        .mvr-chart-wrap {
            height: 285px;
            position: relative;
        }

        .mvr-format-grid {
            display: grid;
            gap: 8px;
            grid-template-columns: repeat(6, minmax(120px, 1fr));
        }

        .mvr-format {
            align-items: center;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            color: #1f2937;
            cursor: pointer;
            display: flex;
            font-size: 12px;
            font-weight: 700;
            gap: 7px;
            justify-content: center;
            min-height: 40px;
            padding: 8px;
            text-align: center;
            width: 100%;
        }

        .mvr-format:hover {
            background: #eef6ff;
            border-color: #9cc9ff;
        }

        .mvr-table-card {
            margin-top: 12px;
        }

        .mvr-table-card .card-header {
            align-items: center;
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            padding: 10px 14px;
        }

        .mvr-table-card h6 {
            font-size: 14px;
            font-weight: 700;
            margin: 0;
        }

        .mvr-table-wrap {
            padding: 12px;
        }

        .mvr-table {
            font-size: 11px;
            width: 100%;
        }

        .mvr-table th,
        .mvr-table td {
            text-align: center;
            white-space: nowrap;
            vertical-align: middle !important;
        }

        .mvr-table th {
            vertical-align: middle !important;
        }

        .mvr-table-card .dataTables_scrollHeadInner,
        .mvr-table-card .dataTables_scrollHeadInner table,
        .mvr-table-card .dataTables_scrollBody table {
            width: 100% !important;
        }

        .mvr-table-card .dataTables_scrollBody {
            border-bottom: 1px solid #e2e8f0;
        }

        .mvr-table-card table.dataTable {
            margin-bottom: 0 !important;
        }

        .mvr-loading {
            align-items: center;
            background: rgba(255, 255, 255, 0.86);
            display: none;
            inset: 0;
            justify-content: center;
            position: fixed;
            z-index: 99999;
        }

        .mvr-loading-box {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.16);
            color: #334155;
            font-size: 13px;
            padding: 22px 28px;
            text-align: center;
        }

        .mvr-access {
            display: none;
            margin: 20px;
        }

        .mvr-custom-grid {
            align-items: end;
            display: grid;
            gap: 10px;
            grid-template-columns: minmax(180px, 280px) auto;
            margin-bottom: 10px;
        }

        .buttons-excel,
        .buttons-html5 {
            background: #2f80ed !important;
            border: 0 !important;
            border-radius: 6px !important;
            color: #fff !important;
            font-weight: 700 !important;
            margin-right: 6px;
        }

        @media (max-width: 1199px) {
            .mvr-format-grid {
                grid-template-columns: repeat(3, minmax(120px, 1fr));
            }
        }

        @media (max-width: 767px) {
            .mvr-format-grid,
            .mvr-custom-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        var mvrTables = {};
        var mvrDailyChart = null;
        var mvrProjectChart = null;
        var mvrCostChart = null;
        var mvrDetailLoaded = false;
        var mvrProjectLoaded = false;
        var mvrUserQualityLoaded = false;
        var mvrCostLoaded = false;
        var mvrProjectDatewiseLoaded = false;
        var mvrLargeTableThreshold = 1000;
        var mvrSearchThreshold = 1500;

        $(document).ready(function () {
            mvrSetDefaultDates();
            mvrBindEvents();
            mvrLoadFilters();
        });

        function mvrAjax(method, payload, success) {
            $.ajax({
                url: "ManagementVolumeReport.aspx/" + method,
                type: "POST",
                data: JSON.stringify(payload || {}),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    try {
                        var data = response && response.d ? JSON.parse(response.d) : {};
                        success(data);
                    }
                    catch (ex) {
                        mvrShowLoading(false);
                        alert(ex.message || "Unable to render report.");
                    }
                },
                error: function (xhr) {
                    mvrShowLoading(false);
                    alert(xhr.responseText || "Unable to load report.");
                }
            });
        }

        function mvrSetDefaultDates() {
            var today = new Date();
            var sixMonthsAgo = new Date(today.getFullYear(), today.getMonth() - 6, today.getDate());
            var first = new Date(sixMonthsAgo.getFullYear(), sixMonthsAgo.getMonth(), 1);
            $("#mvr_from_date").val(mvrDateValue(first));
            $("#mvr_to_date").val(mvrDateValue(today));
        }

        function mvrDateValue(date) {
            var month = String(date.getMonth() + 1).padStart(2, "0");
            var day = String(date.getDate()).padStart(2, "0");
            return date.getFullYear() + "-" + month + "-" + day;
        }

        function mvrBindEvents() {
            $("#mvr_run_report").on("click", function () {
                mvrRunDashboard();
            });

            $("#mvr_run_custom").on("click", function () {
                mvrRunCustomReport();
            });

            $(".mvr-format").on("click", function () {
                var tab = $(this).data("tab");
                var custom = $(this).data("custom");

                if (custom) {
                    $("#mvr_group_by").val(custom);
                    $("#mvr_tabs a[href='#mvr_custom']").tab("show");
                    mvrRunCustomReport();
                    return;
                }

                if (tab) {
                    $("#mvr_tabs a[href='" + tab + "']").tab("show");
                }
            });

            $("#mvr_tabs a[data-toggle='pill']").on("shown.bs.tab", function (event) {
                mvrAdjustTablesInPane($(event.target).attr("href"));
            });

            $("#mvr_tabs a[href='#mvr_project']").on("shown.bs.tab", function () {
                if (!mvrProjectLoaded) {
                    mvrRunProjectPerformance();
                }
            });

            $("#mvr_tabs a[href='#mvr_project_datewise']").on("shown.bs.tab", function () {
                if (!mvrProjectDatewiseLoaded) {
                    mvrRunProjectDatewiseVolumeDetails();
                }
            });

            $("#mvr_tabs a[href='#mvr_user_quality']").on("shown.bs.tab", function () {
                if (!mvrUserQualityLoaded) {
                    mvrRunUserQualityReport();
                }
            });

            $("#mvr_tabs a[href='#mvr_cost']").on("shown.bs.tab", function () {
                if (!mvrCostLoaded) {
                    mvrRunCostPerLoanReport();
                }
            });

            $("#mvr_tabs a[href='#mvr_detail']").on("shown.bs.tab", function () {
                if (!mvrDetailLoaded) {
                    mvrRunLoanDetails();
                }
            });
        }

        function mvrLoadFilters() {
            mvrShowLoading(true);
            mvrAjax("GetFilterOptions", {}, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrFillOptions("#mvr_status", data.Statuses, "All Statuses");
                mvrRunDashboard();
            });
        }

        function mvrFillOptions(selector, rows, defaultText) {
            var $select = $(selector);
            $select.empty();
            $select.append($("<option></option>").val("").text(defaultText));

            $.each(rows || [], function (_, row) {
                var value = row.Value || row.Text || "";
                if (value) {
                    $select.append($("<option></option>").val(value).text(row.Text || value));
                }
            });
        }

        function mvrPayload() {
            return {
                FromDate: $("#mvr_from_date").val(),
                ToDate: $("#mvr_to_date").val(),
                Status: $("#mvr_status").val()
            };
        }

        function mvrRunDashboard() {
            var payload = mvrPayload();
            if (!payload.FromDate || !payload.ToDate) {
                alert("Please select both dates.");
                return;
            }

            mvrShowLoading(true);
            mvrAjax("RunDashboard", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                $("#mvr_generated_on").text(data.GeneratedOn || "");
                mvrRenderCards(data.Summary || []);
                mvrRenderChart(data.DailySummary || []);
                mvrBindTable("#mvr_daily_table", data.DailySummary || [], "Daily Volume Production");
                mvrBindTable("#mvr_user_table", data.UserProduction || [], "User Production");
                mvrBindTable("#mvr_status_table", data.StatusSummary || [], "Status Pipeline");
                mvrBindTable("#mvr_process_table", data.ProcessSummary || [], "Process Summary");
                mvrDetailLoaded = false;
                mvrProjectLoaded = false;
                mvrProjectDatewiseLoaded = false;
                mvrUserQualityLoaded = false;
                mvrCostLoaded = false;
                mvrBindTable("#mvr_project_table", [], "Project Performance");
                mvrBindTable("#mvr_project_datewise_table", [], "Projectwise Datewise Volume Details");
                mvrBindTable("#mvr_user_quality_table", [], "User Quality Productivity");
                mvrBindTable("#mvr_cost_user_table", [], "User Cost Per Loan");
                mvrBindTable("#mvr_cost_process_table", [], "Process Cost Per Loan");
                mvrBindTable("#mvr_cost_detail_table", [], "Cost Per Loan Detail");
                mvrBindTable("#mvr_detail_table", [], "Loan Drilldown");
                mvrShowLoading(false);
            });
        }

        function mvrRunProjectPerformance() {
            var payload = mvrPayload();

            mvrShowLoading(true);
            mvrAjax("RunProjectPerformance", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrBindTable("#mvr_project_table", data.Rows || [], "Project Performance", { large: true });
                mvrRenderProjectChart(data.Rows || []);
                mvrProjectLoaded = true;
                mvrShowLoading(false);
            });
        }

        function mvrRunProjectDatewiseVolumeDetails() {
            var payload = mvrPayload();

            mvrShowLoading(true);
            mvrAjax("RunProjectDatewiseVolumeDetails", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrBindTable("#mvr_project_datewise_table", data.Rows || [], "Projectwise Datewise Volume Details", { large: true });
                mvrProjectDatewiseLoaded = true;
                mvrShowLoading(false);
            });
        }

        function mvrRunUserQualityReport() {
            var payload = mvrPayload();

            mvrShowLoading(true);
            mvrAjax("RunUserQualityReport", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrBindTable("#mvr_user_quality_table", data.Rows || [], "User Quality Productivity", { large: true });
                mvrUserQualityLoaded = true;
                mvrShowLoading(false);
            });
        }

        function mvrRunCostPerLoanReport() {
            var payload = mvrPayload();

            mvrShowLoading(true);
            mvrAjax("RunCostPerLoanReport", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrBindTable("#mvr_cost_user_table", data.UserRows || [], "User Cost Per Loan", { large: true });
                mvrBindTable("#mvr_cost_process_table", data.ProcessRows || [], "Process Cost Per Loan", { large: true });
                mvrBindTable("#mvr_cost_detail_table", data.DetailRows || [], "Cost Per Loan Detail", { large: true });
                mvrRenderCostChart(data.UserRows || []);
                mvrCostLoaded = true;
                mvrShowLoading(false);
            });
        }

        function mvrRunLoanDetails() {
            var payload = mvrPayload();

            mvrShowLoading(true);
            mvrAjax("RunLoanDetails", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                mvrBindTable("#mvr_detail_table", data.Rows || [], "Loan Drilldown", { large: true });
                mvrDetailLoaded = true;
                mvrShowLoading(false);
            });
        }

        function mvrRunCustomReport() {
            var payload = mvrPayload();
            payload.GroupBy = $("#mvr_group_by").val();

            mvrShowLoading(true);
            mvrAjax("RunCustomReport", payload, function (data) {
                if (data.HasAccess === false) {
                    $(".mvr-page").hide();
                    $(".mvr-access").show();
                    mvrShowLoading(false);
                    return;
                }

                $("#mvr_custom_title").text(data.Title || "Custom Analysis");
                mvrBindTable("#mvr_custom_table", data.Rows || [], data.Title || "Custom Analysis");
                mvrShowLoading(false);
            });
        }

        function mvrRenderCards(cards) {
            var $wrap = $("#mvr_cards");
            $wrap.empty();

            $.each(cards, function (_, card) {
                var color = card.Color || "gray";
                var html = [
                    "<div class='col-xl-3 col-lg-4 col-md-6 mb-3'>",
                    "<div class='mvr-card " + color + "'>",
                    "<span>" + mvrEncode(card.Label) + "</span>",
                    "<strong>" + mvrEncode(card.Value) + "</strong>",
                    "</div>",
                    "</div>"
                ].join("");
                $wrap.append(html);
            });
        }

        function mvrRenderChart(rows) {
            var labels = [];
            var received = [];
            var produced = [];
            var dispatched = [];
            var inProcess = [];

            $.each(rows, function (_, row) {
                labels.push(row.ReportDate || "");
                received.push(mvrNumber(row.ReceivedVolume));
                produced.push(mvrNumber(row.ProductionCount));
                dispatched.push(mvrNumber(row.DispatchedVolume));
                inProcess.push(mvrNumber(row.LoansInProcess));
            });

            var ctx = document.getElementById("mvr_daily_chart").getContext("2d");
            if (mvrDailyChart) {
                mvrDailyChart.destroy();
            }

            mvrDailyChart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: labels,
                    datasets: [
                        { label: "Received", data: received, borderColor: "#2f80ed", backgroundColor: "rgba(47,128,237,0.08)", fill: false, lineTension: 0.2 },
                        { label: "Production", data: produced, borderColor: "#219653", backgroundColor: "rgba(33,150,83,0.08)", fill: false, lineTension: 0.2 },
                        { label: "Dispatched", data: dispatched, borderColor: "#f2994a", backgroundColor: "rgba(242,153,74,0.08)", fill: false, lineTension: 0.2 },
                        { label: "In Process", data: inProcess, borderColor: "#d64550", backgroundColor: "rgba(214,69,80,0.08)", fill: false, lineTension: 0.2 }
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    legend: { position: "bottom" },
                    tooltips: { mode: "index", intersect: false },
                    scales: {
                        yAxes: [{ ticks: { beginAtZero: true, precision: 0 } }],
                        xAxes: [{ ticks: { autoSkip: true, maxTicksLimit: 12 } }]
                    }
                }
            });
        }

        function mvrRenderProjectChart(rows) {
            var chartRows = (rows || []).slice(0, 12);
            var labels = [];
            var received = [];
            var delivered = [];
            var wip = [];

            $.each(chartRows, function (_, row) {
                labels.push(row.ProjectName || row.ProjectID || "");
                received.push(mvrNumber(row.ReceivedVolume));
                delivered.push(mvrNumber(row.DeliveredVolume));
                wip.push(mvrNumber(row.LoansInProcess));
            });

            var canvas = document.getElementById("mvr_project_chart");
            if (!canvas) {
                return;
            }

            if (mvrProjectChart) {
                mvrProjectChart.destroy();
            }

            mvrProjectChart = new Chart(canvas.getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        { label: "Received", data: received, backgroundColor: "#2f80ed" },
                        { label: "Delivered", data: delivered, backgroundColor: "#219653" },
                        { label: "In Process", data: wip, backgroundColor: "#d64550" }
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    legend: { position: "bottom" },
                    scales: {
                        yAxes: [{ ticks: { beginAtZero: true, precision: 0 } }],
                        xAxes: [{ ticks: { autoSkip: false } }]
                    }
                }
            });
        }

        function mvrRenderCostChart(rows) {
            var chartRows = (rows || []).slice(0, 12);
            var labels = [];
            var costs = [];

            $.each(chartRows, function (_, row) {
                labels.push(row.Employee || row.Code || "");
                costs.push(mvrNumber(row.CostPerLoanByTimeSpent));
            });

            var canvas = document.getElementById("mvr_cost_chart");
            if (!canvas) {
                return;
            }

            if (mvrCostChart) {
                mvrCostChart.destroy();
            }

            mvrCostChart = new Chart(canvas.getContext("2d"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        { label: "Cost / Loan By Time", data: costs, backgroundColor: "#00a3a3" }
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    legend: { position: "bottom" },
                    scales: {
                        yAxes: [{ ticks: { beginAtZero: true } }],
                        xAxes: [{ ticks: { autoSkip: false } }]
                    }
                }
            });
        }

        function mvrBindTable(selector, rows, title, options) {
            options = options || {};
            rows = rows || [];

            if ($.fn.DataTable.isDataTable(selector)) {
                $(selector).DataTable().destroy();
            }

            var $table = $(selector);
            $table.empty();
            delete mvrTables[selector];

            if (rows.length === 0) {
                $table.html("<thead><tr><th>No Records</th></tr></thead><tbody><tr><td>No records found</td></tr></tbody>");
                mvrScheduleAdjustTable(selector);
                return;
            }

            var keys = Object.keys(rows[0]);
            var columns = [];
            var thead = "<thead><tr>";

            $.each(keys, function (_, key) {
                columns.push({ data: key, title: mvrHeader(key), defaultContent: "" });
                thead += "<th>" + mvrHeader(key) + "</th>";
            });

            thead += "</tr></thead><tbody></tbody>";
            $table.html(thead);

            var isLarge = options.large === true || rows.length >= mvrLargeTableThreshold;
            var allowSearch = rows.length <= mvrSearchThreshold;

            mvrTables[selector] = $table.DataTable({
                data: rows,
                columns: columns,
                destroy: true,
                dom: "Blfrtip",
                scrollX: true,
                scrollCollapse: true,
                paging: true,
                deferRender: true,
                processing: true,
                pageLength: 25,
                lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                ordering: !isLarge,
                searching: allowSearch,
                autoWidth: false,
                buttons: [
                    { extend: "excelHtml5", title: title || "Management Report", autoFilter: true }
                ],
                columnDefs: [
                    { className: "dt-center", targets: "_all" }
                ],
                initComplete: function () {
                    mvrScheduleAdjustTable(selector);
                }
            });

            mvrScheduleAdjustTable(selector);
        }

        function mvrScheduleAdjustTable(selector) {
            window.setTimeout(function () {
                mvrAdjustTable(selector);
            }, 80);
        }

        function mvrAdjustTable(selector) {
            if ($.fn.DataTable.isDataTable(selector)) {
                $(selector).DataTable().columns.adjust().draw(false);
            }
        }

        function mvrAdjustTablesInPane(tabSelector) {
            window.setTimeout(function () {
                $(tabSelector).find("table").each(function () {
                    mvrAdjustTable("#" + this.id);
                });
            }, 120);
        }

        function mvrHeader(key) {
            return String(key || "")
                .replace(/([A-Z])/g, " $1")
                .replace(/^./, function (text) { return text.toUpperCase(); })
                .replace(" Pct", " %")
                .replace(/ T A T/g, " TAT")
                .replace(/ I D/g, " ID")
                .replace(" Tat", " TAT")
                .replace(" Id", " ID")
                .trim();
        }

        function mvrNumber(value) {
            var text = String(value || "0").replace(/,/g, "");
            var number = parseFloat(text);
            return isNaN(number) ? 0 : number;
        }

        function mvrEncode(value) {
            return $("<div/>").text(value == null ? "" : value).html();
        }

        function mvrShowLoading(show) {
            $("#mvr_loading").css("display", show ? "flex" : "none");
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alert alert-warning mvr-access">
        You do not have rights to use Management Volume Reports.
    </div>

    <div class="mvr-page">
        <div class="content-header mvr-header">
            <div class="container">
                <div class="row mb-2 callout callout-info">
                    <div class="col-sm-8">
                        <h6 class="m-0"><i class="fas fa-chart-line"></i>&nbsp;&nbsp;<b>Management Volume Report</b></h6>
                    </div>
                    <div class="col-sm-4 text-sm-right">
                        <span id="mvr_generated_on" style="font-size: 12px; color: #64748b;"></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="mvr-panel">
            <div class="mvr-panel-title">Report Controls</div>
            <div class="form-row">
                <div class="form-group col-lg-2 col-md-4">
                    <label class="mvr-label" for="mvr_from_date">From Date</label>
                    <input type="date" id="mvr_from_date" class="form-control" />
                </div>
                <div class="form-group col-lg-2 col-md-4">
                    <label class="mvr-label" for="mvr_to_date">To Date</label>
                    <input type="date" id="mvr_to_date" class="form-control" />
                </div>
                <div class="form-group col-lg-3 col-md-4">
                    <label class="mvr-label" for="mvr_status">Final Status</label>
                    <select id="mvr_status" class="form-control"></select>
                </div>
                <div class="form-group col-lg-2 col-md-4">
                    <label class="mvr-label">&nbsp;</label>
                    <button type="button" id="mvr_run_report" class="btn btn-primary btn-block">
                        <i class="fas fa-play"></i> Run
                    </button>
                </div>
            </div>
        </div>

        <div class="mvr-panel">
            <div class="mvr-panel-title">Report Formats</div>
            <div class="mvr-format-grid">
                <button type="button" class="mvr-format" data-tab="#mvr_daily"><i class="fas fa-calendar-day"></i>Daily Control</button>
                <button type="button" class="mvr-format" data-tab="#mvr_user"><i class="fas fa-users"></i>User Productivity</button>
                <button type="button" class="mvr-format" data-tab="#mvr_status_pipeline"><i class="fas fa-stream"></i>WIP & Dispatch</button>
                <button type="button" class="mvr-format" data-tab="#mvr_process"><i class="fas fa-tasks"></i>Process Mix</button>
                <button type="button" class="mvr-format" data-tab="#mvr_project"><i class="fas fa-project-diagram"></i>Project Performance</button>
                <button type="button" class="mvr-format" data-tab="#mvr_user_quality"><i class="fas fa-user-check"></i>User Quality</button>
                <button type="button" class="mvr-format" data-tab="#mvr_cost"><i class="fas fa-rupee-sign"></i>Cost Per Loan</button>
                <button type="button" class="mvr-format" data-tab="#mvr_detail"><i class="fas fa-search"></i>Loan Drilldown</button>
            </div>
        </div>

        <div class="row" id="mvr_cards"></div>

        <div class="row">
            <div class="col-lg-8">
                <div class="mvr-panel">
                    <div class="mvr-panel-title">Daily Trend</div>
                    <div class="mvr-chart-wrap">
                        <canvas id="mvr_daily_chart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="mvr-panel">
                    <div class="mvr-panel-title">Custom Analysis</div>
                    <div class="mvr-custom-grid">
                        <div>
                            <label class="mvr-label" for="mvr_group_by">Group By</label>
                            <select id="mvr_group_by" class="form-control">
                                <option value="ReportDate">Report Date</option>
                                <option value="FinalStatus">Final Status</option>
                                <option value="ProjectID">Project ID</option>
                                <option value="DealNo">Deal No</option>
                                <option value="User">User</option>
                                <option value="Process">Process</option>
                            </select>
                        </div>
                        <button type="button" id="mvr_run_custom" class="btn btn-outline-primary">
                            <i class="fas fa-filter"></i> Analyze
                        </button>
                    </div>
                    <div style="font-size: 12px; color: #64748b;">
                        <span id="mvr_custom_title">Custom Analysis</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="mvr-table-card card card-tabs">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="mvr_tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="pill" href="#mvr_daily" role="tab">Daily Summary</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_user" role="tab">User Production</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_status_pipeline" role="tab">Status Pipeline</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_process" role="tab">Process Summary</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_project" role="tab">Project Performance</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_project_datewise" role="tab">Projectwise Datewise Volume Details</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_user_quality" role="tab">User Quality</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_cost" role="tab">Cost Per Loan</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_custom" role="tab">Custom Analysis</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="pill" href="#mvr_detail" role="tab">Loan Details</a>
                    </li>
                </ul>
            </div>
            <div class="card-body">
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="mvr_daily" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_daily_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_user" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_user_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_status_pipeline" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_status_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_process" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_process_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_project" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <div class="mvr-chart-wrap mb-3">
                                <canvas id="mvr_project_chart"></canvas>
                            </div>
                            <table class="table table-bordered mvr-table" id="mvr_project_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_project_datewise" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_project_datewise_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_user_quality" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_user_quality_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_cost" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <div class="mvr-chart-wrap mb-3">
                                <canvas id="mvr_cost_chart"></canvas>
                            </div>
                            <div class="mvr-panel-title">Userwise Cost Per Loan</div>
                            <table class="table table-bordered mvr-table" id="mvr_cost_user_table"></table>
                            <div class="mvr-panel-title mt-3">Processwise Cost Per Loan</div>
                            <table class="table table-bordered mvr-table" id="mvr_cost_process_table"></table>
                            <div class="mvr-panel-title mt-3">Process Detail</div>
                            <table class="table table-bordered mvr-table" id="mvr_cost_detail_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_custom" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_custom_table"></table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="mvr_detail" role="tabpanel">
                        <div class="mvr-table-wrap">
                            <table class="table table-bordered mvr-table" id="mvr_detail_table"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="mvr-loading" id="mvr_loading">
        <div class="mvr-loading-box">
            <img src="../images/Load_1.gif" alt="Loading" style="height: 56px;" />
            <div>Loading report...</div>
        </div>
    </div>
</asp:Content>
