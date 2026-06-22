<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingReport.aspx.cs" Inherits="WebPortal.Production.ProjectTrackingReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .content-header .callout {
            border: 1px solid #d8e2ef;
            border-left: 4px solid #2563eb;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
            align-items: center;
        }

        .content-header h6 {
            font-size: 15px;
            color: #1f2937;
            letter-spacing: 0;
        }

        .card {
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
        }

        .card-body {
            padding: 18px;
        }

        .tracking-report-toolbar {
            display: grid;
            grid-template-columns: minmax(220px, 2fr) minmax(150px, 1fr) minmax(150px, 1fr) minmax(150px, 1fr) minmax(150px, 1fr) auto;
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #f8fafc;
        }

        .tracking-report-toolbar label,
        .tracking-report-columns label {
            font-weight: 600 !important;
            margin-bottom: 4px;
            color: #334155;
            font-size: 12px;
        }

        .tracking-report-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .tracking-report-columns {
            border: 1px solid #dee2e6;
            padding: 12px;
            max-height: 210px;
            overflow: auto;
            border-radius: 6px;
            background: #ffffff;
        }

        .tracking-report-column-list {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 8px 14px;
        }

        .tracking-report-column-list label {
            font-weight: 500 !important;
            margin: 0;
            color: #334155;
        }

        .tracking-report-table-wrap {
            width: 100%;
            overflow: auto;
        }

        #table_ProjectTrackingReport,
        #table_ProjectTrackingSummary {
            min-width: 900px;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
            background: #ffffff;
        }

        #table_ProjectTrackingReport th,
        #table_ProjectTrackingSummary th {
            white-space: nowrap;
            background: #eef2f7 !important;
            border-color: #d8e2ef;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            vertical-align: middle;
        }

        #table_ProjectTrackingReport td,
        #table_ProjectTrackingSummary td {
            min-width: 150px;
            border-color: #e2e8f0;
            color: #334155;
            vertical-align: middle;
        }

        #table_ProjectTrackingReport tbody tr:hover,
        #table_ProjectTrackingSummary tbody tr:hover {
            background: #f8fafc;
        }

        .tracking-report-status {
            min-height: 24px;
            font-weight: 600;
            padding-left: 2px;
        }

        .form-control {
            border-color: #cbd5e1;
            border-radius: 5px;
            font-size: 13px;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 0.12rem rgba(37, 99, 235, 0.18);
        }

        .btn {
            border-radius: 5px;
            font-weight: 600;
        }

        .project-tracking-loader-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 1060;
            align-items: center;
            justify-content: center;
            background: rgba(15, 23, 42, 0.32);
        }

        .project-tracking-loader-box {
            min-width: 190px;
            padding: 18px 22px;
            border-radius: 6px;
            background: #fff;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.24);
            text-align: center;
            font-weight: 600;
            color: #1f2937;
        }

        .project-tracking-loader-spinner {
            width: 30px;
            height: 30px;
            margin: 0 auto 10px;
            border: 3px solid #d9e2ef;
            border-top-color: #007bff;
            border-radius: 50%;
            animation: projectTrackingSpin 0.8s linear infinite;
        }

        @keyframes projectTrackingSpin {
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 992px) {
            .tracking-report-toolbar,
            .tracking-report-column-list {
                grid-template-columns: 1fr;
            }

            .tracking-report-actions {
                justify-content: flex-start;
            }
        }
    </style>

    <script>
        var reportColumns = [];
        var reportRows = [];
        var summaryColumns = [];
        var summaryRows = [];

        $(document).ready(function () {
            setReportDefaultDates();
            bindReportProjects();
            toggleReportMode();

            $("#ddlReportProject").on("change", function () {
                loadReportFields();
            });

            $("#ddlReportMode").on("change", function () {
                toggleReportMode();
            });

            $("#btnReportSelectAll").on("click", function () {
                $(".tracking-report-field").prop("checked", true);
            });

            $("#btnReportClearColumns").on("click", function () {
                $(".tracking-report-field").prop("checked", false);
            });

            $("#btnGenerateTrackingReport").on("click", function () {
                generateTrackingReport();
            });

            $("#btnExportTrackingReport").on("click", function () {
                exportTrackingReportCsv();
            });
        });

        function callReport(methodName, payload, success) {
            $.ajax({
                type: "POST",
                url: "ProjectTrackingReport.aspx/" + methodName,
                data: JSON.stringify(payload || {}),
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () {
                    showLoader();
                },
                success: function (response) {
                    var data = response.d;
                    if (typeof data === "string") {
                        data = JSON.parse(data);
                    }
                    success(data);
                },
                error: function (xhr) {
                    showReportStatus(xhr.responseText || "Request failed.", true);
                },
                complete: function () {
                    hideLoader();
                }
            });
        }

        function setReportDefaultDates() {
            var today = new Date();
            var yyyy = today.getFullYear();
            var mm = pad2(today.getMonth() + 1);
            var dd = pad2(today.getDate());

            $("#txtReportFromDate").val(yyyy + "-" + mm + "-01");
            $("#txtReportToDate").val(yyyy + "-" + mm + "-" + dd);
            $("#txtReportMonth").val(yyyy + "-" + mm);
        }

        function pad2(value) {
            value = String(value);
            return value.length === 1 ? "0" + value : value;
        }

        function showReportStatus(message, isError) {
            $("#trackingReportStatus").text(message || "").css("color", isError ? "#dc3545" : "#198754");
        }

        function showLoader(message) {
            $("#projectTrackingLoaderText").text(message || "Please wait...");
            $("#projectTrackingLoader").css("display", "flex");
        }

        function hideLoader() {
            $("#projectTrackingLoader").hide();
        }

        function htmlEncode(value) {
            return $("<div/>").text(value == null ? "" : value).html();
        }

        function bindReportProjects() {
            callReport("GetProjects", {}, function (projects) {
                var $project = $("#ddlReportProject");
                $project.empty().append($("<option></option>").val("0").text("All Projects"));

                $.each(projects, function (_, project) {
                    $project.append($("<option></option>").val(project.ProjectID).text(project.ProjectName));
                });

                loadReportFields();
            });
        }

        function loadReportFields() {
            var projectId = parseInt($("#ddlReportProject").val() || "0");

            callReport("GetReportFields", { projectId: projectId }, function (fields) {
                renderReportFields(fields || []);
            });
        }

        function renderReportFields(fields) {
            var html = "";

            $.each(fields, function (_, field) {
                html += "<label><input type='checkbox' class='tracking-report-field' value='" + htmlEncode(field.FieldName) + "' checked /> " + htmlEncode(field.FieldName) + "</label>";
            });

            $("#trackingReportColumnList").html(html || "<span>No configured columns found.</span>");
        }

        function toggleReportMode() {
            var mode = $("#ddlReportMode").val();
            var isMonthWise = mode === "MonthWise";

            $("#reportMonthBox").toggle(isMonthWise);
            $("#reportFromDateBox").toggle(!isMonthWise);
            $("#reportToDateBox").toggle(!isMonthWise);
        }

        function getSelectedColumns() {
            var columns = [];

            $(".tracking-report-field:checked").each(function () {
                columns.push($(this).val());
            });

            return columns;
        }

        function getSelectedSummaryGroups() {
            var groups = [];

            $(".tracking-summary-group:checked").each(function () {
                groups.push($(this).val());
            });

            return groups;
        }

        function generateTrackingReport() {
            var selectedColumns = getSelectedColumns();
            var summaryGroupBy = getSelectedSummaryGroups();

            if (selectedColumns.length === 0) {
                showReportStatus("Please select at least one column.", true);
                return;
            }

            showReportStatus("Generating...", false);

            callReport("GenerateReport", {
                projectId: parseInt($("#ddlReportProject").val() || "0"),
                reportMode: $("#ddlReportMode").val(),
                fromDate: $("#txtReportFromDate").val(),
                toDate: $("#txtReportToDate").val(),
                reportMonth: $("#txtReportMonth").val(),
                selectedColumns: selectedColumns,
                summaryGroupBy: summaryGroupBy
            }, function (result) {
                reportColumns = result.Columns || [];
                reportRows = result.Rows || [];
                summaryColumns = result.SummaryColumns || [];
                summaryRows = result.SummaryRows || [];
                renderTrackingReportTable();
                renderTrackingSummaryTable();
                showReportStatus("Generated " + reportRows.length + " row(s) and " + summaryRows.length + " summary row(s).", false);
            });
        }

        function renderTrackingReportTable() {
            var headerHtml = "<tr>";
            var bodyHtml = "";

            $.each(reportColumns, function (_, column) {
                headerHtml += "<th>" + htmlEncode(column) + "</th>";
            });

            headerHtml += "</tr>";
            $("#table_ProjectTrackingReport thead").html(headerHtml);

            $.each(reportRows, function (_, row) {
                bodyHtml += "<tr>";
                $.each(reportColumns, function (_, column) {
                    bodyHtml += "<td>" + htmlEncode(row[column]) + "</td>";
                });
                bodyHtml += "</tr>";
            });

            $("#table_ProjectTrackingReport tbody").html(bodyHtml || "<tr><td colspan='" + Math.max(reportColumns.length, 1) + "' class='text-center'>No data found.</td></tr>");
        }

        function renderTrackingSummaryTable() {
            var headerHtml = "<tr>";
            var bodyHtml = "";

            $.each(summaryColumns, function (_, column) {
                headerHtml += "<th>" + htmlEncode(column) + "</th>";
            });

            headerHtml += "</tr>";
            $("#table_ProjectTrackingSummary thead").html(headerHtml);

            $.each(summaryRows, function (_, row) {
                bodyHtml += "<tr>";
                $.each(summaryColumns, function (_, column) {
                    bodyHtml += "<td>" + htmlEncode(row[column]) + "</td>";
                });
                bodyHtml += "</tr>";
            });

            $("#table_ProjectTrackingSummary tbody").html(bodyHtml || "<tr><td colspan='" + Math.max(summaryColumns.length, 1) + "' class='text-center'>No summary found.</td></tr>");
        }

        function exportTrackingReportCsv() {
            if (reportColumns.length === 0 || reportRows.length === 0) {
                showReportStatus("Please generate report first.", true);
                return;
            }

            showLoader("Exporting...");

            var csv = [];
            csv.push(reportColumns.map(csvEscape).join(","));

            $.each(reportRows, function (_, row) {
                csv.push(reportColumns.map(function (column) {
                    return csvEscape(row[column]);
                }).join(","));
            });

            var blob = new Blob([csv.join("\r\n")], { type: "text/csv;charset=utf-8;" });
            var url = URL.createObjectURL(blob);
            var link = document.createElement("a");
            link.href = url;
            link.download = "ProjectTrackingReport.csv";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
            hideLoader();
        }

        function csvEscape(value) {
            value = value == null ? "" : String(value);
            return "\"" + value.replace(/"/g, "\"\"") + "\"";
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="projectTrackingLoader" class="project-tracking-loader-backdrop">
        <div class="project-tracking-loader-box">
            <div class="project-tracking-loader-spinner"></div>
            <div id="projectTrackingLoaderText">Please wait...</div>
        </div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-chart-bar"></i>&nbsp;&nbsp;<b>Project Tracking Report</b></h6>
                </div>
                <div class="col-sm-6 text-right">
                    <a href="ProjectTrackingFieldConfiguration.aspx" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-cog"></i>&nbsp;Field Configuration
                    </a>
                    <a href="ProjectTrackingSheet.aspx" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-table"></i>&nbsp;Tracking Sheet
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="tracking-report-toolbar">
                <div>
                    <label for="ddlReportProject">Project</label>
                    <select id="ddlReportProject" class="form-control"></select>
                </div>
                <div>
                    <label for="ddlReportMode">Report Type</label>
                    <select id="ddlReportMode" class="form-control">
                        <option value="DateWise">Date Wise</option>
                        <option value="MonthWise">Month Wise</option>
                        <option value="ProjectWise">Project Wise</option>
                    </select>
                </div>
                <div id="reportFromDateBox">
                    <label for="txtReportFromDate">From Date</label>
                    <input type="date" id="txtReportFromDate" class="form-control" />
                </div>
                <div id="reportToDateBox">
                    <label for="txtReportToDate">To Date</label>
                    <input type="date" id="txtReportToDate" class="form-control" />
                </div>
                <div id="reportMonthBox">
                    <label for="txtReportMonth">Month</label>
                    <input type="month" id="txtReportMonth" class="form-control" />
                </div>
                <div class="tracking-report-actions">
                    <button type="button" id="btnGenerateTrackingReport" class="btn btn-primary">
                        <i class="fas fa-search"></i>&nbsp;Generate
                    </button>
                    <button type="button" id="btnExportTrackingReport" class="btn btn-outline-success">
                        <i class="fas fa-file-export"></i>&nbsp;CSV
                    </button>
                </div>
            </div>

            <div id="trackingReportStatus" class="tracking-report-status mt-3"></div>

            <hr />

            <div class="tracking-report-columns">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <label class="mb-0">Columns</label>
                    <div class="tracking-report-actions">
                        <button type="button" id="btnReportSelectAll" class="btn btn-sm btn-outline-primary">Select All</button>
                        <button type="button" id="btnReportClearColumns" class="btn btn-sm btn-outline-secondary">Clear</button>
                    </div>
                </div>
                <div id="trackingReportColumnList" class="tracking-report-column-list"></div>
            </div>

            <hr />

            <div class="tracking-report-columns">
                <label>Summary Group By</label>
                <div class="tracking-report-column-list">
                    <label><input type="checkbox" class="tracking-summary-group" value="User" checked /> User Wise</label>
                    <label><input type="checkbox" class="tracking-summary-group" value="Date" checked /> Date Wise</label>
                    <label><input type="checkbox" class="tracking-summary-group" value="Process" checked /> Process Wise</label>
                </div>
            </div>

            <hr />

            <div class="tracking-report-table-wrap">
                <table class="table table-bordered table-sm" id="table_ProjectTrackingSummary">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Entry Date</th>
                            <th>Process</th>
                            <th>Loan Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="4" class="text-center">Generate report to view summary.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <hr />

            <div class="tracking-report-table-wrap">
                <table class="table table-bordered table-sm" id="table_ProjectTrackingReport">
                    <thead>
                        <tr>
                            <th>Project</th>
                            <th>Entry Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="2" class="text-center">Select columns and generate report.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
