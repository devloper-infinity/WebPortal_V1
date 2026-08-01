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
        html += "<td style='text-align:center;'>" + boolPill(field.IsUniqueField) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsVisible) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsEditable) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsForBilling) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsForImport) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsProcessColumn) + "</td>";
        html += "<td style='text-align:center;'>" + boolPill(field.IsSystemGenerated) + "</td>";
        html += "</tr>";
    });

    $("#table_ProjectTrackingFields tbody").html(html || "<tr><td colspan='14' class='text-center'>No fields configured.</td></tr>");
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
    $("#chkUniqueField").prop("checked", false);
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
    $("#chkUniqueField").prop("checked", yesNo(field.IsUniqueField) === "Yes");
    $("#chkFieldVisible").prop("checked", yesNo(field.IsVisible) === "Yes");
    $("#chkFieldEditable").prop("checked", yesNo(field.IsEditable) === "Yes");
    $("#chkForBilling").prop("checked", yesNo(field.IsForBilling) === "Yes");
    $("#chkForImport").prop("checked", yesNo(field.IsForImport) === "Yes");
    $("#ddlDateFormat").val(field.DateFormat || "dd/MM/yyyy");
    $("#txtDisplayOrder").val(field.DisplayOrder);
    setStatusOptionsMode(false);
    showConfigStatus("Editing selected field.", false);
    $("#ddlFieldConfigProject").trigger("focus");
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
    $("#chkUniqueField").prop("checked", false);
    $("#chkFieldVisible").prop("checked", true);
    $("#chkFieldEditable").prop("checked", true);
    $("#chkForBilling").prop("checked", false);
    $("#chkForImport").prop("checked", false);
    $("#ddlDateFormat").val("dd/MM/yyyy");
    $("#txtDisplayOrder").val(field.DisplayOrder);
    setStatusOptionsMode(true);
    showConfigStatus("Editing Status dropdown values only.", false);
    $("#ddlFieldConfigProject").trigger("focus");
}

function setStatusOptionsMode(isStatusOptionsMode) {
    if (isStatusOptionsMode) {
        $("#txtFieldName, #ddlFieldDataType, #chkActualProcess, #txtDisplayOrder, #chkFieldRequired, #chkUniqueField, #chkFieldVisible, #chkFieldEditable, #chkForBilling, #chkForImport, #ddlDateFormat").prop("disabled", true);
        $("#txtFieldOptions").prop("disabled", false).focus();
        $("#btnSaveFieldConfig").html("<i class='fas fa-save'></i>&nbsp;Save Status Options");
        return;
    }

    $("#txtFieldName, #ddlFieldDataType, #chkActualProcess, #txtDisplayOrder, #chkFieldRequired, #chkUniqueField, #chkFieldVisible, #chkFieldEditable, #chkForBilling, #chkForImport").prop("disabled", false);
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
        isUniqueField: $("#chkUniqueField").is(":checked"),
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