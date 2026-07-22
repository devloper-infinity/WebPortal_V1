<%@ Page Title="" Language="C#" MasterPageFile="~/Production/Production.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingFieldConfiguration.aspx.cs" Inherits="WebPortal.TrackingSheet.ProjectTrackingFieldConfiguration" %>

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

        .field-config-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #f8fafc;
        }

        .field-config-grid label {
            font-weight: 600 !important;
            margin-bottom: 4px;
            color: #334155;
            font-size: 12px;
        }

        .field-config-checks {
            display: flex;
            gap: 18px;
            align-items: center;
            min-height: 38px;
        }

        .field-config-checks label {
            margin-bottom: 0;
            font-weight: 500 !important;
        }

        .field-config-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .field-config-replica {
            display: grid;
            grid-template-columns: minmax(220px, 1fr) minmax(220px, 1fr) auto;
            gap: 12px;
            align-items: end;
            padding: 14px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: #ffffff;
        }

        .field-config-replica label {
            font-weight: 600 !important;
            margin-bottom: 4px;
            color: #334155;
            font-size: 12px;
        }

        .field-config-status {
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

        #table_ProjectTrackingFields {
            border-collapse: separate;
            border-spacing: 0;
            font-size: 13px;
            background: #ffffff;
        }

        #table_ProjectTrackingFields th {
            background: #eef2f7;
            border-color: #d8e2ef;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            vertical-align: middle;
            white-space: nowrap;
        }

        #table_ProjectTrackingFields td {
            border-color: #e2e8f0;
            color: #334155;
            vertical-align: middle;
        }

        #table_ProjectTrackingFields tbody tr:hover {
            background: #f8fafc;
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
            .field-config-grid,
            .field-config-replica {
                grid-template-columns: 1fr;
            }
        }

        .pt-config-page {
            max-width: 100%;
            padding: 14px 18px 24px;
            background: #f4f7fb;
            min-height: calc(100vh - 120px);
        }

        .pt-config-shell {
            max-width: 1380px;
            margin: 0 auto;
        }

        .pt-config-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 14px;
            padding: 16px 18px;
            border: 1px solid #d8e2ef;
            border-left: 5px solid #2563eb;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.07);
        }

        .pt-config-title {
            margin: 0;
            color: #0f172a;
            font-size: 18px;
            font-weight: 700;
            line-height: 1.2;
        }

        .pt-config-subtitle {
            margin-top: 4px;
            color: #64748b;
            font-size: 12px;
            font-weight: 500;
        }

        .pt-config-panel {
            margin-bottom: 14px;
            border: 1px solid #d8e2ef;
            border-radius: 6px;
            background: #ffffff;
            box-shadow: 0 8px 22px rgba(15, 23, 42, 0.06);
        }

        .pt-config-panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
            background: #f8fafc;
        }

        .pt-config-panel-title {
            margin: 0;
            color: #1e293b;
            font-size: 14px;
            font-weight: 700;
        }

        .pt-config-panel-body {
            padding: 14px;
        }

        .pt-config-table-wrap {
            width: 100%;
            overflow: auto;
            padding: 0;
        }

        .pt-config-page .field-config-grid,
        .pt-config-page .field-config-replica {
            border: 0;
            padding: 0;
            background: transparent;
        }

        .pt-config-page .form-control {
            height: 36px;
        }

        .pt-config-page textarea.form-control {
            height: auto;
        }

        .pt-config-page #table_ProjectTrackingFields {
            margin-bottom: 0;
            border: 0;
        }

        .pt-config-page #table_ProjectTrackingFields th {
            position: sticky;
            top: 0;
            z-index: 1;
            padding: 10px 8px;
        }

        .pt-config-page #table_ProjectTrackingFields td {
            padding: 9px 8px;
        }

        @media (max-width: 768px) {
            .pt-config-hero {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        .pt-config-page {
            color: #172033;
            background: linear-gradient(180deg, #edf5fb 0%, #f7f9fc 48%, #f4f7fb 100%);
            padding: 18px 22px 30px;
        }

        .pt-config-shell {
            max-width: 1420px;
        }

        .pt-config-hero {
            min-height: 82px;
            margin-bottom: 16px;
            padding: 18px 20px;
            border: 1px solid #cad8e6;
            border-left: 6px solid #0f6b8f;
            background: #ffffff;
            box-shadow: 0 14px 34px rgba(31, 45, 61, 0.10);
        }

        .pt-config-title {
            color: #102033;
            font-size: 20px;
            letter-spacing: 0;
        }

        .pt-config-title i {
            color: #0f6b8f;
        }

        .pt-config-subtitle {
            color: #64748b;
            font-size: 13px;
        }

        .pt-config-quick-link {
            min-width: 138px;
            border-color: #0f6b8f;
            color: #0f6b8f;
            background: #f2fbfd;
        }

        .pt-config-quick-link:hover {
            color: #ffffff;
            background: #0f6b8f;
            border-color: #0f6b8f;
        }

        .pt-config-panel {
            overflow: hidden;
            margin-bottom: 16px;
            border: 1px solid #d3dfeb;
            background: #ffffff;
            box-shadow: 0 12px 28px rgba(31, 45, 61, 0.08);
        }

        .pt-config-panel-header {
            min-height: 50px;
            padding: 12px 16px;
            background: #f6f9fc;
        }

        .pt-config-panel-title {
            display: flex;
            align-items: center;
            gap: 9px;
            color: #1f2d3d;
            font-size: 15px;
        }

        .pt-panel-icon {
            display: inline-flex;
            width: 30px;
            height: 30px;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            color: #0f6b8f;
            background: #e8f6f8;
        }

        .pt-config-panel-body {
            padding: 16px;
        }

        .pt-config-page .field-config-grid {
            grid-template-columns: 1.1fr 1.15fr 0.85fr 0.85fr;
            gap: 14px 16px;
        }

        .pt-config-page .field-config-replica {
            grid-template-columns: minmax(240px, 1fr) minmax(240px, 1fr) auto;
            gap: 14px 16px;
        }

        .pt-config-page label {
            color: #384860;
            font-size: 12px;
            font-weight: 700 !important;
            letter-spacing: 0;
        }

        .pt-config-page .form-control {
            height: 38px;
            border: 1px solid #bfccd9;
            border-radius: 6px;
            color: #1f2d3d;
            background: #ffffff;
        }

        .pt-config-page textarea.form-control {
            min-height: 76px;
            resize: vertical;
        }

        .pt-config-page .field-config-checks {
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
            padding-top: 19px;
        }

        .pt-config-page .field-config-checks label {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #334155;
            font-weight: 600 !important;
        }

        .pt-config-page input[type="checkbox"] {
            width: 15px;
            height: 15px;
            accent-color: #0f6b8f;
        }

        .pt-config-page .field-config-actions {
            align-items: end;
            padding-top: 18px;
        }

        .pt-config-page .btn {
            border-radius: 6px;
            letter-spacing: 0;
        }

        .pt-config-page .btn-primary {
            border-color: #0f6b8f;
            background: #0f6b8f;
            box-shadow: 0 8px 16px rgba(15, 107, 143, 0.20);
        }

        .pt-config-page .btn-primary:hover {
            border-color: #0b526e;
            background: #0b526e;
        }

        .pt-config-page .btn-outline-secondary {
            border-color: #b8c6d4;
            color: #405166;
            background: #ffffff;
        }

        .pt-config-page .btn-outline-success {
            border-color: #198754;
            color: #14784a;
            background: #f3fbf7;
        }

        .pt-config-page .btn-outline-success:hover {
            color: #ffffff;
            background: #198754;
        }

        .pt-config-page .field-config-status {
            min-height: 22px;
            padding-left: 0;
            font-size: 12px;
        }

        .pt-config-table-wrap {
            max-height: 460px;
            border-top: 1px solid #e2e8f0;
        }

        .pt-config-page #table_ProjectTrackingFields th {
            color: #26384d;
            background: #e8eef5;
        }

        .pt-config-page #table_ProjectTrackingFields td {
            color: #2f3e52;
            background: #ffffff;
        }

        .pt-config-page #table_ProjectTrackingFields tbody tr:nth-child(even) td {
            background: #fbfdff;
        }

        .pt-config-page #table_ProjectTrackingFields tbody tr:hover td {
            background: #eef8fa;
        }

        .pt-config-page .pt-generated-row td {
            background: #f8fafc;
            color: #516173;
        }

        .pt-config-page .pt-process-row td {
            border-top: 1px solid #b9dce5;
            background: #f4fbfd;
        }

        .pt-icon-button {
            width: 30px;
            height: 30px;
            padding: 0;
            line-height: 1;
        }

        .pt-field-title {
            color: #172033;
            font-weight: 700;
        }

        .pt-field-subnote {
            margin-top: 2px;
            color: #7a8797;
            font-size: 11px;
        }

        .pt-options-text {
            color: #64748b;
            white-space: pre-line;
        }

        .pt-type-pill,
        .pt-pill,
        .pt-lock-pill {
            display: inline-flex;
            min-height: 24px;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 3px 9px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0;
            white-space: nowrap;
        }

        .pt-type-pill {
            color: #0f526b;
            background: #e7f6fa;
            border: 1px solid #bddfeb;
        }

        .pt-pill-yes {
            color: #146c43;
            background: #eaf8ef;
            border: 1px solid #bfe8cf;
        }

        .pt-pill-no {
            color: #7a4d14;
            background: #fff7e7;
            border: 1px solid #f2d69b;
        }

        .pt-lock-pill {
            color: #516173;
            background: #eef2f7;
            border: 1px solid #d6dee8;
        }

        @media (max-width: 992px) {
            .pt-config-page .field-config-grid,
            .pt-config-page .field-config-replica {
                grid-template-columns: 1fr;
            }

            .pt-config-page .field-config-checks,
            .pt-config-page .field-config-actions {
                padding-top: 0;
            }
        }
    </style>

    <script>
        var fieldConfigRows = [];

        $(document).ready(function () {
            bindProjectTrackingProjects();
            toggleProcessOptions();

            $("#ddlFieldConfigProject").on("change", function () {
                fieldConfigRows = [];
                clearFieldForm();
                loadFieldConfigurations();
            });

            $("#ddlFieldDataType").on("change", function () {
                toggleOptions();
            });

            $("#chkActualProcess").on("change", function () {
                toggleProcessOptions();
            });

            $("#btnSaveFieldConfig").on("click", function () {
                saveFieldConfiguration();
            });

            $("#btnNewFieldConfig").on("click", function () {
                clearFieldForm();
            });

            $("#btnCreateReplica").on("click", function () {
                createProjectReplica();
            });
        });

        function showConfigStatus(message, isError) {
            $("#fieldConfigStatus").text(message || "").css("color", isError ? "#dc3545" : "#198754");
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

        function callFieldConfig(methodName, payload, success) {
            $.ajax({
                type: "POST",
                url: "ProjectTrackingFieldConfiguration.aspx/" + methodName,
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
                    showConfigStatus(xhr.responseText || "Request failed.", true);
                },
                complete: function () {
                    hideLoader();
                }
            });
        }

        function bindProjectTrackingProjects() {
            callFieldConfig("GetProjects", {}, function (projects) {
                fillProjectDropdown("#ddlFieldConfigProject", projects);
                fillProjectDropdown("#ddlReplicaSourceProject", projects);
                fillProjectDropdown("#ddlReplicaTargetProject", projects);
            });
        }

        function fillProjectDropdown(selector, projects) {
            var $project = $(selector);
            $project.empty().append($("<option></option>").val("").text("Select"));

            $.each(projects, function (_, project) {
                $project.append($("<option></option>").val(project.ProjectID).text(project.ProjectName));
            });
        }

        function loadFieldConfigurations() {
            var projectId = $("#ddlFieldConfigProject").val();

            if (!projectId) {
                renderFieldTable([]);
                return;
            }

            showConfigStatus("Loading...", false);
            callFieldConfig("GetFields", { projectId: parseInt(projectId) }, function (fields) {
                fieldConfigRows = fields || [];
                renderFieldTable(fieldConfigRows);
                setNextDisplayOrder();
                showConfigStatus("Loaded " + fieldConfigRows.length + " field(s).", false);
            });
        }

        function renderFieldTable(fields) {
            var html = "";

            $.each(fields, function (index, field) {
                var isGenerated = isTrue(field.IsSystemGenerated);
                var isProcess = isTrue(field.IsProcessColumn) || field.DataType === "Process";

                html += "<tr" + (isGenerated ? " class='pt-generated-row'" : (isProcess ? " class='pt-process-row'" : "")) + ">";
                html += "<td style='text-align:center; white-space:nowrap;'>";

                html += "<button type='button' class='btn btn-sm btn-outline-secondary pt-icon-button' title='Move up' onclick='moveFieldConfig(" + field.FieldConfigId + ", \"up\");'><i class='fas fa-arrow-up'></i></button> ";
                html += "<button type='button' class='btn btn-sm btn-outline-secondary pt-icon-button' title='Move down' onclick='moveFieldConfig(" + field.FieldConfigId + ", \"down\");'><i class='fas fa-arrow-down'></i></button> ";

                if (!isGenerated) {
                    html += "<button type='button' class='btn btn-sm btn-outline-primary pt-icon-button' title='Edit' onclick='editFieldConfig(" + index + ");'><i class='fas fa-pen'></i></button> ";
                    html += "<button type='button' class='btn btn-sm btn-outline-danger pt-icon-button' title='Delete' onclick='deleteFieldConfig(" + field.FieldConfigId + ");'><i class='fas fa-trash'></i></button>";
                }
                else {
                    if (isGeneratedStatusField(field)) {
                        html += "<button type='button' class='btn btn-sm btn-outline-primary pt-icon-button' title='Edit status dropdown values' onclick='editStatusOptions(" + index + ");'><i class='fas fa-pen'></i></button> ";
                    }

                    html += "<span class='pt-lock-pill'>Auto</span>";
                }

                html += "</td>";
                html += "<td style='text-align:center;'>" + htmlEncode(field.DisplayOrder) + "</td>";
                html += "<td><div class='pt-field-title'>" + htmlEncode(field.FieldName) + "</div>" + fieldRowNote(field, isProcess, isGenerated) + "</td>";
                html += "<td>" + typePill(field.DataType) + "</td>";
                html += "<td>" + htmlEncode(field.DateFormat || "-") + "</td>";
                html += "<td><span class='pt-options-text'>" + htmlEncode(field.OptionsText || "-") + "</span></td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsRequired) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsVisible) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsEditable) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsForBilling) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsForImport) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsProcessColumn) + "</td>";
                html += "<td style='text-align:center;'>" + boolPill(field.IsSystemGenerated) + "</td>";
                html += "</tr>";
            });

            $("#table_ProjectTrackingFields tbody").html(html || "<tr><td colspan='13' class='text-center'>No fields configured.</td></tr>");
        }

        function isTrue(value) {
            return value === true || value === "True" || value === "true" || value === 1;
        }

        function yesNo(value) {
            return isTrue(value) ? "Yes" : "No";
        }

        function isGeneratedStatusField(field) {
            return isTrue(field.IsSystemGenerated) && (field.ProcessChildType || "") === "Status";
        }

        function boolPill(value) {
            var text = yesNo(value);
            return "<span class='pt-pill " + (text === "Yes" ? "pt-pill-yes" : "pt-pill-no") + "'>" + text + "</span>";
        }

        function typePill(value) {
            return "<span class='pt-type-pill'>" + htmlEncode(value || "-") + "</span>";
        }

        function fieldRowNote(field, isProcess, isGenerated) {
            if (isProcess && !isGenerated) {
                return "<div class='pt-field-subnote'>Process owner/user column</div>";
            }

            if (isGenerated) {
                if (isGeneratedStatusField(field)) {
                    return "<div class='pt-field-subnote'>Auto generated status dropdown</div>";
                }

                return "<div class='pt-field-subnote'>Auto generated process field</div>";
            }

            return "";
        }

        function toggleOptions() {
            var isProcess = $("#chkActualProcess").is(":checked");
            var dataType = $("#ddlFieldDataType").val();
            $("#txtFieldOptions").prop("disabled", isProcess || dataType !== "Dropdown");
            $("#ddlDateFormat").prop("disabled", isProcess || dataType !== "Date");

            if (dataType !== "Date") {
                $("#ddlDateFormat").val("dd/MM/yyyy");
            }
        }

        function toggleProcessOptions() {
            var isProcess = $("#chkActualProcess").is(":checked");

            if (isProcess) {
                $("#ddlFieldDataType").val("Process").prop("disabled", true);
                $("#txtFieldOptions").val("").prop("disabled", true);
                $("#chkFieldRequired").prop("checked", false).prop("disabled", true);
                $("#chkFieldVisible").prop("checked", true).prop("disabled", true);
                $("#chkFieldEditable").prop("checked", true).prop("disabled", true);
                $("#ddlDateFormat").val("dd/MM/yyyy").prop("disabled", true);
                return;
            }

            $("#ddlFieldDataType").prop("disabled", false);

            if ($("#ddlFieldDataType").val() === "Process") {
                $("#ddlFieldDataType").val("Text");
            }

            $("#chkFieldRequired").prop("disabled", false);
            $("#chkFieldVisible").prop("disabled", false);
            $("#chkFieldEditable").prop("disabled", false);
            toggleOptions();
        }

        function clearFieldForm() {
            $("#hdnFieldConfigId").val("0");
            $("#hdnStatusOptionsFieldConfigId").val("0");
            $("#txtFieldName").val("");
            $("#chkActualProcess").prop("checked", false);
            $("#ddlFieldDataType").val("Text");
            $("#txtFieldOptions").val("");
            $("#chkFieldRequired").prop("checked", false);
            $("#chkFieldVisible").prop("checked", true);
            $("#chkFieldEditable").prop("checked", true);
            $("#chkForBilling").prop("checked", false);
            $("#chkForImport").prop("checked", false);
            $("#ddlDateFormat").val("dd/MM/yyyy");
            $("#txtDisplayOrder").val("");
            setStatusOptionsMode(false);
            setNextDisplayOrder();
            showConfigStatus("", false);
        }

        function setNextDisplayOrder() {
            if ($("#hdnFieldConfigId").val() !== "0" || !$("#ddlFieldConfigProject").val()) {
                return;
            }

            var maxOrder = 0;

            $.each(fieldConfigRows, function (_, field) {
                var displayOrder = parseInt(field.DisplayOrder || "0");

                if (!isNaN(displayOrder) && displayOrder > maxOrder) {
                    maxOrder = displayOrder;
                }
            });

            $("#txtDisplayOrder").val(maxOrder + 1);
        }

        function editFieldConfig(index) {
            var field = fieldConfigRows[index];
            var isGenerated = isTrue(field.IsSystemGenerated);

            if (isGenerated) {
                if (isGeneratedStatusField(field)) {
                    editStatusOptions(index);
                    return;
                }

                showConfigStatus("Only auto generated Status dropdown values can be edited. Other generated fields can only be reordered.", true);
                return;
            }

            $("#hdnFieldConfigId").val(field.FieldConfigId);
            $("#hdnStatusOptionsFieldConfigId").val("0");
            $("#txtFieldName").val(field.FieldName);
            $("#chkActualProcess").prop("checked", isTrue(field.IsProcessColumn) || field.DataType === "Process");
            $("#ddlFieldDataType").val(field.DataType);
            $("#txtFieldOptions").val(field.OptionsText || "");
            $("#chkFieldRequired").prop("checked", yesNo(field.IsRequired) === "Yes");
            $("#chkFieldVisible").prop("checked", yesNo(field.IsVisible) === "Yes");
            $("#chkFieldEditable").prop("checked", yesNo(field.IsEditable) === "Yes");
            $("#chkForBilling").prop("checked", yesNo(field.IsForBilling) === "Yes");
            $("#chkForImport").prop("checked", yesNo(field.IsForImport) === "Yes");
            $("#ddlDateFormat").val(field.DateFormat || "dd/MM/yyyy");
            $("#txtDisplayOrder").val(field.DisplayOrder);
            setStatusOptionsMode(false);
            showConfigStatus("Editing selected field.", false);
        }

        function editStatusOptions(index) {
            var field = fieldConfigRows[index];

            if (!isGeneratedStatusField(field)) {
                showConfigStatus("Only auto generated Status dropdown values can be edited.", true);
                return;
            }

            $("#hdnFieldConfigId").val("0");
            $("#hdnStatusOptionsFieldConfigId").val(field.FieldConfigId);
            $("#txtFieldName").val(field.FieldName);
            $("#chkActualProcess").prop("checked", false);
            $("#ddlFieldDataType").val("Dropdown");
            $("#txtFieldOptions").val(field.OptionsText || "");
            $("#chkFieldRequired").prop("checked", false);
            $("#chkFieldVisible").prop("checked", true);
            $("#chkFieldEditable").prop("checked", true);
            $("#chkForBilling").prop("checked", false);
            $("#chkForImport").prop("checked", false);
            $("#ddlDateFormat").val("dd/MM/yyyy");
            $("#txtDisplayOrder").val(field.DisplayOrder);
            setStatusOptionsMode(true);
            showConfigStatus("Editing Status dropdown values only.", false);
        }

        function setStatusOptionsMode(isStatusOptionsMode) {
            if (isStatusOptionsMode) {
                $("#txtFieldName, #ddlFieldDataType, #chkActualProcess, #txtDisplayOrder, #chkFieldRequired, #chkFieldVisible, #chkFieldEditable, #chkForBilling, #chkForImport, #ddlDateFormat").prop("disabled", true);
                $("#txtFieldOptions").prop("disabled", false).focus();
                $("#btnSaveFieldConfig").html("<i class='fas fa-save'></i>&nbsp;Save Status Options");
                return;
            }

            $("#txtFieldName, #ddlFieldDataType, #chkActualProcess, #txtDisplayOrder, #chkFieldRequired, #chkFieldVisible, #chkFieldEditable, #chkForBilling, #chkForImport").prop("disabled", false);
            $("#btnSaveFieldConfig").html("<i class='fas fa-save'></i>&nbsp;Save Field");
            toggleProcessOptions();
        }

        function saveFieldConfiguration() {
            var projectId = $("#ddlFieldConfigProject").val();
            var fieldName = $.trim($("#txtFieldName").val());
            var dataType = $("#ddlFieldDataType").val();
            var displayOrder = $("#txtDisplayOrder").val();
            var isProcess = $("#chkActualProcess").is(":checked");
            var statusOptionsFieldConfigId = parseInt($("#hdnStatusOptionsFieldConfigId").val() || "0");

            if (statusOptionsFieldConfigId > 0) {
                saveStatusOptions(statusOptionsFieldConfigId);
                return;
            }

            if (!projectId) {
                showConfigStatus("Please select project.", true);
                return;
            }

            if (fieldName === "") {
                showConfigStatus("Please enter field name.", true);
                $("#txtFieldName").focus();
                return;
            }

            callFieldConfig("SaveField", {
                fieldConfigId: parseInt($("#hdnFieldConfigId").val() || "0"),
                projectId: parseInt(projectId),
                fieldName: fieldName,
                dataType: isProcess ? "Process" : dataType,
                optionsText: $("#txtFieldOptions").val(),
                isRequired: $("#chkFieldRequired").is(":checked"),
                isVisible: $("#chkFieldVisible").is(":checked"),
                isEditable: $("#chkFieldEditable").is(":checked"),
                isForBilling: $("#chkForBilling").is(":checked"),
                isForImport: $("#chkForImport").is(":checked"),
                displayOrder: displayOrder === "" ? 0 : parseInt(displayOrder),
                isProcessColumn: isProcess,
                dateFormat: dataType === "Date" && !isProcess ? $("#ddlDateFormat").val() : ""
            }, function (result) {
                if (result === -1) {
                    showConfigStatus("This field already exists, is generated by a process, or is reserved for billing.", true);
                    return;
                }

                if (result > 0) {
                    clearFieldForm();
                    loadFieldConfigurations();
                    showConfigStatus("Field saved successfully.", false);
                }
                else {
                    showConfigStatus("Unable to save field.", true);
                }
            });
        }

        function saveStatusOptions(fieldConfigId) {
            var optionsText = $.trim($("#txtFieldOptions").val());

            if (optionsText === "") {
                showConfigStatus("Please enter status dropdown values.", true);
                $("#txtFieldOptions").focus();
                return;
            }

            callFieldConfig("SaveStatusOptions", {
                fieldConfigId: fieldConfigId,
                optionsText: optionsText
            }, function (result) {
                if (result > 0) {
                    clearFieldForm();
                    loadFieldConfigurations();
                    showConfigStatus("Status dropdown values saved successfully.", false);
                }
                else {
                    showConfigStatus("Unable to save Status dropdown values.", true);
                }
            });
        }

        function moveFieldConfig(fieldConfigId, direction) {
            var projectId = $("#ddlFieldConfigProject").val();

            if (!projectId) {
                showConfigStatus("Please select project.", true);
                return;
            }

            callFieldConfig("MoveField", {
                projectId: parseInt(projectId),
                fieldConfigId: fieldConfigId,
                direction: direction
            }, function (result) {
                if (result > 0) {
                    loadFieldConfigurations();
                    showConfigStatus("Sequence updated.", false);
                }
                else {
                    showConfigStatus("No sequence change available.", true);
                }
            });
        }

        function deleteFieldConfig(fieldConfigId) {
            if (!confirm("Delete this field from project tracking configuration? Process child fields will also be deleted.")) {
                return;
            }

            callFieldConfig("DeleteField", { fieldConfigId: fieldConfigId }, function (result) {
                if (result > 0) {
                    loadFieldConfigurations();
                    showConfigStatus("Field deleted successfully.", false);
                }
                else {
                    showConfigStatus("Unable to delete field.", true);
                }
            });
        }

        function createProjectReplica() {
            var sourceProjectId = $("#ddlReplicaSourceProject").val();
            var targetProjectId = $("#ddlReplicaTargetProject").val();

            if (!sourceProjectId) {
                showConfigStatus("Please select replica source project.", true);
                return;
            }

            if (!targetProjectId) {
                showConfigStatus("Please select replica target project.", true);
                return;
            }

            if (sourceProjectId === targetProjectId) {
                showConfigStatus("Source and target project cannot be same.", true);
                return;
            }

            if (!confirm("Create field configuration replica in selected target project?")) {
                return;
            }

            showConfigStatus("Creating replica...", false);
            callFieldConfig("CreateReplica", {
                sourceProjectId: parseInt(sourceProjectId),
                targetProjectId: parseInt(targetProjectId)
            }, function (result) {
                if (result === -1) {
                    showConfigStatus("Target project already has field configuration. Please choose a blank project.", true);
                    return;
                }

                if (result > 0) {
                    $("#ddlFieldConfigProject").val(targetProjectId);
                    clearFieldForm();
                    loadFieldConfigurations();
                    showConfigStatus("Replica created with " + result + " field(s).", false);
                }
                else {
                    showConfigStatus("Unable to create replica. Please check source project configuration.", true);
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

    <div class="pt-config-page">
        <div class="pt-config-shell">
            <div class="pt-config-hero">
                <div>
                    <h4 class="pt-config-title"><i class="fas fa-sliders-h"></i>&nbsp;Project Tracking Field Configuration</h4>
                    <div class="pt-config-subtitle">Configure project-wise tracking fields, process columns, sequence, and replica setup.</div>
                </div>
               <%-- <div>
                    <a href="ImportData.aspx" class="btn btn-sm btn-outline-success pt-config-quick-link">
                        <i class="fas fa-file-import"></i>&nbsp;Import Data
                    </a>
                    <a href="TrackingSheet.aspx" class="btn btn-sm btn-outline-primary pt-config-quick-link">
                        <i class="fas fa-table"></i>&nbsp;Tracking Sheet
                    </a>
                </div>--%>
            </div>

            <input type="hidden" id="hdnFieldConfigId" value="0" />
            <input type="hidden" id="hdnStatusOptionsFieldConfigId" value="0" />

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-cog"></i></span>Field Setup</h5>
                    <div id="fieldConfigStatus" class="field-config-status"></div>
                </div>
                <div class="pt-config-panel-body">
                    <div class="field-config-grid">
                        <div>
                            <label for="ddlFieldConfigProject">Project</label>
                            <select id="ddlFieldConfigProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <label for="txtFieldName">Field Name</label>
                            <input type="text" id="txtFieldName" class="form-control" />
                        </div>
                        <div>
                            <label for="ddlFieldDataType">Data Type</label>
                            <select id="ddlFieldDataType" class="form-control">
                                <option value="Text">Text</option>
                                <option value="Number">Number</option>
                                <option value="Date">Date</option>
                                <option value="DateTime">DateTime</option>
                                <option value="Dropdown">Dropdown</option>
                                <option value="Checkbox">Checkbox</option>
                                <option value="Process">Process</option>
                            </select>
                        </div>
                        <div class="field-config-checks">
                            <label><input type="checkbox" id="chkActualProcess" /> Actual Process</label>
                        </div>
                        <div>
                            <label for="txtDisplayOrder">Display Order</label>
                            <input type="number" id="txtDisplayOrder" class="form-control" min="0" />
                        </div>
                        <div>
                            <label for="ddlDateFormat">Date Format</label>
                            <select id="ddlDateFormat" class="form-control" disabled>
                                <option value="dd/MM/yyyy">dd/MM/yyyy</option>
                                <option value="MM/dd/yyyy">MM/dd/yyyy</option>
                                <option value="yyyy-MM-dd">yyyy-MM-dd</option>
                                <option value="dd-MMM-yyyy">dd-MMM-yyyy</option>
                                <option value="MMM dd yyyy">MMM dd yyyy</option>
                            </select>
                        </div>
                        <div style="grid-column: span 2;">
                            <label for="txtFieldOptions">Dropdown Options</label>
                            <textarea id="txtFieldOptions" class="form-control" rows="2" placeholder="One option per line"></textarea>
                        </div>
                        <div class="field-config-checks">
                            <label><input type="checkbox" id="chkFieldRequired" /> Required</label>
                            <label><input type="checkbox" id="chkFieldVisible" checked /> Visible</label>
                            <label><input type="checkbox" id="chkFieldEditable" checked /> Editable</label>
                            <label><input type="checkbox" id="chkForBilling" /> For Billing</label>
                            <label><input type="checkbox" id="chkForImport" /> For Import</label>
                        </div>
                        <div class="field-config-actions">
                            <button type="button" id="btnSaveFieldConfig" class="btn btn-primary">
                                <i class="fas fa-save"></i>&nbsp;Save Field
                            </button>
                            <button type="button" id="btnNewFieldConfig" class="btn btn-outline-secondary">
                                <i class="fas fa-plus"></i>&nbsp;New
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-clone"></i></span>Create Project Replica</h5>
                </div>
                <div class="pt-config-panel-body">
                    <div class="field-config-replica">
                        <div>
                            <label for="ddlReplicaSourceProject">Replica From Project</label>
                            <select id="ddlReplicaSourceProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <label for="ddlReplicaTargetProject">Replica To Project</label>
                            <select id="ddlReplicaTargetProject" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <button type="button" id="btnCreateReplica" class="btn btn-outline-success">
                                <i class="fas fa-clone"></i>&nbsp;Create Replica
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-config-panel">
                <div class="pt-config-panel-header">
                    <h5 class="pt-config-panel-title"><span class="pt-panel-icon"><i class="fas fa-list-ul"></i></span>Configured Fields</h5>
                </div>
                <div class="pt-config-table-wrap">
                    <table class="table table-bordered table-sm pt-config-table" id="table_ProjectTrackingFields">
                        <thead>
                            <tr>
                                <th style="width:190px; text-align:center;">Action</th>
                                <th style="width:80px; text-align:center;">Order</th>
                                <th>Field</th>
                                <th>Type</th>
                                <th style="width:120px;">Date Format</th>
                                <th>Options</th>
                                <th style="width:90px; text-align:center;">Required</th>
                                <th style="width:90px; text-align:center;">Visible</th>
                                <th style="width:90px; text-align:center;">Editable</th>
                                <th style="width:100px; text-align:center;">For Billing</th>
                                <th style="width:100px; text-align:center;">For Import</th>
                                <th style="width:90px; text-align:center;">Process</th>
                                <th style="width:100px; text-align:center;">Generated</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="13" class="text-center">Select a project.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
