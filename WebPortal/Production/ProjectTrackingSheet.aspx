<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingSheet.aspx.cs" Inherits="WebPortal.Production.ProjectTrackingSheet" %>

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

        .tracking-toolbar {
            display: grid;
            grid-template-columns: minmax(220px, 2fr) minmax(150px, 1fr) minmax(150px, 1fr) auto auto;
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #f8fafc;
        }

        .tracking-toolbar label {
            font-weight: 600 !important;
            margin-bottom: 4px;
            color: #334155;
            font-size: 12px;
        }

        .tracking-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .tracking-table-wrap {
            width: 100%;
            overflow: auto;
        }

        #table_ProjectTrackingSheet {
            min-width: 900px;
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
            background: #ffffff;
        }

        #table_ProjectTrackingSheet th {
            white-space: nowrap;
            background: #eef2f7 !important;
            border-color: #d8e2ef;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            vertical-align: middle;
        }

        #table_ProjectTrackingSheet td {
            min-width: 170px;
            border-color: #e2e8f0;
            color: #334155;
            vertical-align: middle;
        }

        #table_ProjectTrackingSheet tbody tr:hover {
            background: #f8fafc;
        }

        #table_ProjectTrackingSheet td.tracking-action-cell {
            min-width: 80px;
            text-align: center;
        }

        .tracking-cell {
            min-width: 150px;
        }

        .tracking-status {
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

        .tracking-cell[readonly] {
            background: #eef2f7;
            color: #475569;
            font-weight: 600;
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
            .tracking-toolbar {
                grid-template-columns: 1fr;
            }

            .tracking-actions {
                justify-content: flex-start;
            }
        }
    </style>

    <script>
        var trackingFields = [];
        var trackingRows = [];

        $(document).ready(function () {
            setDefaultDates();
            loadTrackingProjects();

            $("#btnLoadTrackingSheet").on("click", function () {
                loadTrackingSheet();
            });

            $("#btnAddTrackingRow").on("click", function () {
                addTrackingRow();
            });

            $("#btnSaveTrackingSheet").on("click", function () {
                saveTrackingRows();
            });

            $("#table_ProjectTrackingSheet").on("change input", ".tracking-cell", function () {
                calculateProcessTatForCell(this);
            });
        });

        function setDefaultDates() {
            var today = new Date().toISOString().slice(0, 10);
            $("#txtTrackingFromDate").val(today);
            $("#txtTrackingToDate").val(today);
        }

        function showTrackingStatus(message, isError) {
            $("#trackingStatus").text(message || "").css("color", isError ? "#dc3545" : "#198754");
        }

        function showLoader(message) {
            $("#projectTrackingLoaderText").text(message || "Please wait...");
            $("#projectTrackingLoader").css("display", "flex");
        }

        function hideLoader() {
            $("#projectTrackingLoader").hide();
        }

        function blankForNull(value) {
            return value === null || value === undefined || value === "null" ? "" : value;
        }

        function htmlEncode(value) {
            return $("<div/>").text(blankForNull(value)).html();
        }

        function callTracking(methodName, payload, success) {
            $.ajax({
                type: "POST",
                url: "ProjectTrackingSheet.aspx/" + methodName,
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
                    showTrackingStatus(xhr.responseText || "Request failed.", true);
                },
                complete: function () {
                    hideLoader();
                }
            });
        }

        function loadTrackingProjects() {
            callTracking("GetProjects", {}, function (projects) {
                var $project = $("#ddlTrackingProject");
                $project.empty().append($("<option></option>").val("").text("Select"));

                $.each(projects, function (_, project) {
                    $project.append($("<option></option>").val(project.ProjectID).text(project.ProjectName));
                });
            });
        }

        function loadTrackingSheet() {
            var projectId = $("#ddlTrackingProject").val();
            var fromDate = $("#txtTrackingFromDate").val();
            var toDate = $("#txtTrackingToDate").val();
            
            if (!projectId) {
                showTrackingStatus("Please select project.", true);
                return;
            }

            showTrackingStatus("Loading...", false);
            callTracking("GetSheet", { projectId: parseInt(projectId), fromDate: fromDate, toDate: toDate }, function (sheet) {
                trackingFields = sheet.Fields || [];
                trackingRows = sheet.Rows || [];
                renderTrackingTable();
                showTrackingStatus("Loaded " + trackingRows.length + " row(s).", false);
            });
        }

        function renderTrackingTable() {
            var $head = $("#table_ProjectTrackingSheet thead");
            var $body = $("#table_ProjectTrackingSheet tbody");
            var headerHtml = "<tr><th style='width:80px;text-align:center;'>Action</th><th>Entry Date</th>";

            $.each(trackingFields, function (_, field) {
                headerHtml += "<th>" + htmlEncode(field.FieldName) + "</th>";
            });

            headerHtml += "</tr>";
            $head.html(headerHtml);

            var bodyHtml = "";
            $.each(trackingRows, function (rowIndex, row) {
                bodyHtml += buildRowHtml(rowIndex, row);
            });

            $body.html(bodyHtml || "<tr><td colspan='" + (trackingFields.length + 2) + "' class='text-center'>No rows found.</td></tr>");
            calculateAllProcessTats();
        }

        function buildRowHtml(rowIndex, row) {
            var entryDate = blankForNull(row.EntryDate);
            var values = row.Values || {};
            var html = "<tr data-row-index='" + rowIndex + "' data-row-id='" + blankForNull(row.RowId) + "'>";
            html += "<td class='tracking-action-cell'><button type='button' class='btn btn-sm btn-outline-danger' title='Remove row' onclick='removeTrackingRow(this);'><i class='fas fa-trash'></i></button></td>";
            html += "<td><input type='date' class='form-control form-control-sm tracking-entry-date' value='" + htmlEncode(entryDate) + "' /></td>";

            $.each(trackingFields, function (_, field) {
                var fieldId = field.FieldConfigId;
                var value = blankForNull(values[fieldId]);
                html += "<td>" + buildFieldInput(field, value) + "</td>";
            });

            html += "</tr>";
            return html;
        }

        function buildFieldInput(field, value) {
            var fieldId = field.FieldConfigId;
            var disabled = field.IsEditable === false ? " disabled" : "";
            var required = field.IsRequired === true ? " required" : "";
            var dataType = field.DataType || "Text";
            var fieldAttributes = buildFieldAttributes(field);
            var readonly = field.ProcessChildType === "TAT" ? " readonly" : "";

            if (dataType === "Number") {
                return "<input type='number' class='form-control form-control-sm tracking-cell' " + fieldAttributes + " value='" + htmlEncode(value) + "'" + disabled + required + " />";
            }

            if (dataType === "Date") {
                return "<input type='date' class='form-control form-control-sm tracking-cell' " + fieldAttributes + " value='" + htmlEncode(value) + "'" + disabled + required + " />";
            }

            if (dataType === "DateTime") {
                return "<input type='datetime-local' class='form-control form-control-sm tracking-cell' " + fieldAttributes + " value='" + htmlEncode(normalizeDateTimeValue(value)) + "'" + disabled + required + " />";
            }

            if (dataType === "Checkbox") {
                var checked = value === "true" || value === "True" || value === "1" ? " checked" : "";
                return "<input type='checkbox' class='tracking-cell' " + fieldAttributes + checked + disabled + " />";
            }

            if (dataType === "Dropdown") {
                var options = splitOptions(field.OptionsText);
                var html = "<select class='form-control form-control-sm tracking-cell' " + fieldAttributes + disabled + required + ">";
                html += "<option value=''>Select</option>";
                $.each(options, function (_, option) {
                    var selected = option === value ? " selected" : "";
                    html += "<option value='" + htmlEncode(option) + "'" + selected + ">" + htmlEncode(option) + "</option>";
                });
                html += "</select>";
                return html;
            }

            return "<input type='text' class='form-control form-control-sm tracking-cell' " + fieldAttributes + " value='" + htmlEncode(value) + "'" + disabled + required + readonly + " />";
        }

        function buildFieldAttributes(field) {
            return "data-field-id='" + field.FieldConfigId + "' " +
                "data-process-parent-id='" + htmlEncode(field.ParentProcessFieldConfigId || "") + "' " +
                "data-process-child-type='" + htmlEncode(field.ProcessChildType || "") + "' " +
                "data-is-process-column='" + (field.IsProcessColumn === true ? "1" : "0") + "'";
        }

        function normalizeDateTimeValue(value) {
            value = blankForNull(value);

            if (value.length >= 16) {
                return value.substring(0, 16).replace(" ", "T");
            }

            return value;
        }

        function calculateAllProcessTats() {
            $("#table_ProjectTrackingSheet tbody tr").each(function () {
                var $row = $(this);
                $row.find(".tracking-cell[data-process-child-type='EndDateTime']").each(function () {
                    calculateProcessTatForCell(this);
                });
            });
        }

        function calculateProcessTatForCell(cell) {
            var $cell = $(cell);
            var parentId = $cell.attr("data-process-parent-id");
            var childType = $cell.attr("data-process-child-type");

            if (!parentId || parentId === "0" || (childType !== "StartDateTime" && childType !== "AssignedDateTime" && childType !== "EndDateTime")) {
                return;
            }

            var $row = $cell.closest("tr");
            var $tat = findProcessCell($row, parentId, "TAT");
            var endDate = parseLocalDateTime(findProcessCell($row, parentId, "EndDateTime").val());
            var startValue = findProcessCell($row, parentId, "StartDateTime").val() || findProcessCell($row, parentId, "AssignedDateTime").val();
            var startDate = parseLocalDateTime(startValue);

            if ($tat.length === 0 || !startDate || !endDate) {
                return;
            }

            var seconds = Math.floor((endDate.getTime() - startDate.getTime()) / 1000);

            if (seconds < 0) {
                $tat.val("");
                return;
            }

            $tat.val(formatDuration(seconds));
        }

        function findProcessCell($row, parentId, childType) {
            return $row.find(".tracking-cell[data-process-parent-id='" + parentId + "'][data-process-child-type='" + childType + "']");
        }

        function parseLocalDateTime(value) {
            value = blankForNull(value);

            if (value === "") {
                return null;
            }

            var parts = value.replace("T", " ").split(/[- :]/);

            if (parts.length < 5) {
                return null;
            }

            var year = parseInt(parts[0], 10);
            var month = parseInt(parts[1], 10) - 1;
            var day = parseInt(parts[2], 10);
            var hour = parseInt(parts[3], 10);
            var minute = parseInt(parts[4], 10);
            var second = parts.length > 5 ? parseInt(parts[5], 10) : 0;
            var parsedDate = new Date(year, month, day, hour, minute, second);

            return isNaN(parsedDate.getTime()) ? null : parsedDate;
        }

        function formatDuration(totalSeconds) {
            var hours = Math.floor(totalSeconds / 3600);
            var minutes = Math.floor((totalSeconds % 3600) / 60);
            var seconds = totalSeconds % 60;

            return padDuration(hours) + ":" + padDuration(minutes) + ":" + padDuration(seconds);
        }

        function padDuration(value) {
            return value < 10 ? "0" + value : String(value);
        }

        function splitOptions(optionsText) {
            return (optionsText || "")
                .split(/\r?\n|,/)
                .map(function (option) { return $.trim(option); })
                .filter(function (option) { return option !== ""; });
        }

        function addTrackingRow() {
            if (!$("#ddlTrackingProject").val()) {
                showTrackingStatus("Please select project.", true);
                return;
            }

            if (trackingFields.length === 0) {
                loadTrackingSheet();
                return;
            }

            var row = {
                RowId: 0,
                EntryDate: $("#txtTrackingToDate").val() || new Date().toISOString().slice(0, 10),
                Values: {}
            };

            trackingRows.push(row);
            renderTrackingTable();
        }

        function removeTrackingRow(button) {
            var $row = $(button).closest("tr");
            var rowId = parseInt($row.attr("data-row-id") || "0");
            var rowIndex = parseInt($row.attr("data-row-index") || "-1");

            if (rowId > 0 && !confirm("Delete this saved row?")) {
                return;
            }

            if (rowId > 0) {
                callTracking("DeleteRow", { rowId: rowId }, function (result) {
                    if (result > 0) {
                        loadTrackingSheet();
                    }
                    else {
                        showTrackingStatus("Unable to delete row.", true);
                    }
                });
            }
            else {
                if (rowIndex >= 0) {
                    trackingRows.splice(rowIndex, 1);
                }
                renderTrackingTable();
            }
        }

        function collectRows() {
            var rows = [];

            $("#table_ProjectTrackingSheet tbody tr").each(function () {
                var $row = $(this);
                var cells = [];

                $row.find(".tracking-cell").each(function () {
                    var $cell = $(this);
                    var value = $cell.attr("type") === "checkbox" ? ($cell.is(":checked") ? "true" : "false") : $cell.val();

                    cells.push({
                        FieldConfigId: parseInt($cell.attr("data-field-id")),
                        FieldValue: value
                    });
                });

                if (cells.length > 0) {
                    rows.push({
                        RowId: parseInt($row.attr("data-row-id") || "0"),
                        EntryDate: $row.find(".tracking-entry-date").val(),
                        Values: cells
                    });
                }
            });

            return rows;
        }

        function saveTrackingRows() {
            var projectId = $("#ddlTrackingProject").val();
            var rows = collectRows();

            if (!projectId) {
                showTrackingStatus("Please select project.", true);
                return;
            }

            if (rows.length === 0) {
                showTrackingStatus("Please add at least one row.", true);
                return;
            }

            showTrackingStatus("Saving...", false);
            callTracking("SaveRows", { projectId: parseInt(projectId), rows: rows }, function (result) {
                if (result > 0) {
                    showTrackingStatus("Saved successfully.", false);
                    loadTrackingSheet();
                }
                else {
                    showTrackingStatus("No rows were saved.", true);
                }
            });
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
                    <h6 class="m-0"><i class="fas fa-table"></i>&nbsp;&nbsp;<b>Project Tracking Sheet</b></h6>
                </div>
                <div class="col-sm-6 text-right">
                    <a href="ProjectTrackingFieldConfiguration.aspx" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-cog"></i>&nbsp;Field Configuration
                    </a>
                    <a href="ProjectTrackingReport.aspx" class="btn btn-sm btn-outline-success">
                        <i class="fas fa-chart-bar"></i>&nbsp;Report
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="tracking-toolbar">
                <div>
                    <label for="ddlTrackingProject">Project</label>
                    <select id="ddlTrackingProject" class="form-control">
                        
                    </select>
                </div>
                <div>
                    <label for="txtTrackingFromDate">From Date</label>
                    <input type="date" id="txtTrackingFromDate" class="form-control" />
                </div>
                <div>
                    <label for="txtTrackingToDate">To Date</label>
                    <input type="date" id="txtTrackingToDate" class="form-control" />
                </div>
                <div class="tracking-actions">
                    <button type="button" id="btnLoadTrackingSheet" class="btn btn-primary">
                        <i class="fas fa-search"></i>&nbsp;Load
                    </button>
                    <button type="button" id="btnAddTrackingRow" class="btn btn-outline-primary">
                        <i class="fas fa-plus"></i>&nbsp;Row
                    </button>
                </div>
                <div class="tracking-actions">
                    <button type="button" id="btnSaveTrackingSheet" class="btn btn-success">
                        <i class="fas fa-save"></i>&nbsp;Save
                    </button>
                </div>
            </div>

            <div id="trackingStatus" class="tracking-status mt-3"></div>

            <hr />

            <div class="tracking-table-wrap">
                <table class="table table-bordered table-sm" id="table_ProjectTrackingSheet">
                    <thead>
                        <tr>
                            <th>Action</th>
                            <th>Entry Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="2" class="text-center">Select a project and load data.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
