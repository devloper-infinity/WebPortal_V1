(function (window, $) {
    "use strict";

    var state = {
        lookups: {},
        automation: {},
        tables: {},
        currentEntity: "",
        currentRecords: []
    };

    var serviceUrl = "CRMService.aspx/";

    var entityConfig = {
        Lead: {
            id: "LeadID",
            title: "Lead",
            fields: [
                { name: "LeadID", type: "hidden" },
                { name: "FirstName", label: "First name", required: true },
                { name: "LastName", label: "Last name", required: true },
                { name: "CompanyName", label: "Company", required: true },
                { name: "Title", label: "Title" },
                { name: "Email", label: "Email", type: "email" },
                { name: "Phone", label: "Phone" },
                { name: "Mobile", label: "Mobile" },
                { name: "Website", label: "Website" },
                { name: "City", label: "City" },
                { name: "State", label: "State" },
                { name: "Country", label: "Country" },
                { name: "LeadSourceID", label: "Source", type: "select", lookup: "LeadSources", value: "LeadSourceID", text: "SourceName" },
                { name: "LeadStatusID", label: "Status", type: "select", lookup: "LeadStatuses", value: "LeadStatusID", text: "StatusName" },
                { name: "AssignedToEmployeeID", label: "Owner", type: "select", lookup: "Owners", value: "EmployeeID", text: "DisplayName" },
                { name: "EstimatedValue", label: "Estimated value", type: "number" },
                { name: "Rating", label: "Rating", type: "selectStatic", options: ["Hot", "Warm", "Cold"] },
                { name: "NextFollowUpDate", label: "Next follow-up", type: "date" },
                { name: "Description", label: "Description", type: "textarea", full: true }
            ]
        },
        Account: {
            id: "AccountID",
            title: "Account",
            fields: [
                { name: "AccountID", type: "hidden" },
                { name: "AccountName", label: "Account name", required: true, wide: true },
                { name: "AccountType", label: "Type", type: "selectStatic", options: ["Prospect", "Customer", "Partner", "Vendor", "Competitor"] },
                { name: "Industry", label: "Industry" },
                { name: "Website", label: "Website" },
                { name: "Phone", label: "Phone" },
                { name: "Email", label: "Email", type: "email" },
                { name: "BillingCity", label: "City" },
                { name: "BillingState", label: "State" },
                { name: "BillingCountry", label: "Country" },
                { name: "AnnualRevenue", label: "Annual revenue", type: "number" },
                { name: "AssignedToEmployeeID", label: "Owner", type: "select", lookup: "Owners", value: "EmployeeID", text: "DisplayName" },
                { name: "Description", label: "Description", type: "textarea", full: true }
            ]
        },
        Contact: {
            id: "ContactID",
            title: "Contact",
            fields: [
                { name: "ContactID", type: "hidden" },
                { name: "AccountID", label: "Account", type: "select", lookup: "Accounts", value: "AccountID", text: "AccountName", wide: true },
                { name: "FirstName", label: "First name", required: true },
                { name: "LastName", label: "Last name", required: true },
                { name: "Title", label: "Title" },
                { name: "Email", label: "Email", type: "email" },
                { name: "Phone", label: "Phone" },
                { name: "Mobile", label: "Mobile" },
                { name: "Department", label: "Department" },
                { name: "PreferredContactMethod", label: "Preferred contact", type: "selectStatic", options: ["Email", "Phone", "Mobile", "Meeting"] },
                { name: "LastContactedDate", label: "Last contacted", type: "date" },
                { name: "AssignedToEmployeeID", label: "Owner", type: "select", lookup: "Owners", value: "EmployeeID", text: "DisplayName" },
                { name: "Description", label: "Description", type: "textarea", full: true }
            ]
        },
        Deal: {
            id: "DealID",
            title: "Deal",
            fields: [
                { name: "DealID", type: "hidden" },
                { name: "DealName", label: "Deal name", required: true, wide: true },
                { name: "AccountID", label: "Account", type: "select", lookup: "Accounts", value: "AccountID", text: "AccountName" },
                { name: "ContactID", label: "Contact", type: "select", lookup: "Contacts", value: "ContactID", text: "ContactName" },
                { name: "LeadID", label: "Source lead", type: "select", lookup: "Leads", value: "LeadID", text: "LeadName" },
                { name: "DealStageID", label: "Stage", type: "select", lookup: "DealStages", value: "DealStageID", text: "StageName", required: true },
                { name: "Amount", label: "Amount", type: "number" },
                { name: "Probability", label: "Probability", type: "number" },
                { name: "ExpectedCloseDate", label: "Expected close", type: "date" },
                { name: "AssignedToEmployeeID", label: "Owner", type: "select", lookup: "Owners", value: "EmployeeID", text: "DisplayName" },
                { name: "LostReason", label: "Lost reason", wide: true },
                { name: "Description", label: "Description", type: "textarea", full: true }
            ]
        },
        Activity: {
            id: "ActivityID",
            title: "Activity",
            fields: [
                { name: "ActivityID", type: "hidden" },
                { name: "ActivityTypeID", label: "Type", type: "select", lookup: "ActivityTypes", value: "ActivityTypeID", text: "ActivityTypeName", required: true },
                { name: "Subject", label: "Subject", required: true, wide: true },
                { name: "RelatedEntity", label: "Related module", type: "selectStatic", options: ["Lead", "Account", "Contact", "Deal"] },
                { name: "RelatedRecordID", label: "Related record ID", type: "number" },
                { name: "ActivityStatusID", label: "Status", type: "select", lookup: "ActivityStatuses", value: "ActivityStatusID", text: "StatusName" },
                { name: "Priority", label: "Priority", type: "selectStatic", options: ["Low", "Normal", "High", "Critical"] },
                { name: "DueDate", label: "Due date", type: "date" },
                { name: "StartDateTime", label: "Start", type: "datetime-local" },
                { name: "EndDateTime", label: "End", type: "datetime-local" },
                { name: "Outcome", label: "Outcome", wide: true },
                { name: "AssignedToEmployeeID", label: "Owner", type: "select", lookup: "Owners", value: "EmployeeID", text: "DisplayName" },
                { name: "Description", label: "Description", type: "textarea", full: true }
            ]
        }
    };

    $(function () {
        if ($(".crm-page").length === 0) {
            return;
        }

        markActiveNav();
        ensureEditor();
        loadLookups().always(initPage);
        bindEvents();
    });

    function bindEvents() {
        $(document).on("click", ".crm-open-editor", function () {
            openEditor($(this).data("entity"), null);
        });

        $(document).on("click", ".crm-edit-record", function () {
            openEditor($(this).data("entity"), $(this).data("id"));
        });

        $(document).on("click", ".crm-delete-record", function () {
            deleteRecord($(this).data("entity"), $(this).data("id"));
        });

        $(document).on("click", ".crm-convert-lead", function () {
            convertLead($(this).data("id"), $(this).data("name"));
        });

        $(document).on("click", "#crmSaveRecord", saveRecord);
        $(document).on("click", "#crmRefreshReports", loadReports);
        $(document).on("click", "#crmRefreshAutomation", loadAutomationCenter);
        $(document).on("click", "#crmRunAutomationNow", runAutomationNow);
        $(document).on("click", ".crm-tab-btn", switchSettingsTab);
        $(document).on("click", ".crm-save-settings,.crm-save-automation", saveAutomationItem);
        $(document).on("click", ".crm-edit-automation", editAutomationItem);
        $(document).on("click", ".crm-delete-automation", deleteAutomationItem);
        $(document).on("click", "#crmMarkAllRead,#crmMarkNotificationsRead", markNotificationsRead);

        var searchTimer = null;
        $(document).on("keyup", ".crm-search-input", function () {
            clearTimeout(searchTimer);
            searchTimer = setTimeout(loadCurrentRecords, 300);
        });

        $(document).on("change", ".crm-status-filter,.crm-owner-filter", loadCurrentRecords);
    }

    function initPage() {
        var page = $(".crm-page").data("crm-page");
        if (page === "dashboard") {
            loadDashboard();
        } else if (page === "reports") {
            loadReports();
        } else if (page === "settings") {
            loadAutomationCenter();
        } else {
            initListPage();
        }
    }

    function initListPage() {
        state.currentEntity = $(".crm-page").data("crm-entity");
        bindFilters(state.currentEntity);
        loadCurrentRecords();
    }

    function loadLookups() {
        return callService("GetLookups", {}).done(function (data) {
            state.lookups = data || {};
            loadNotificationPanel();
        });
    }

    function loadDashboard() {
        callService("GetDashboard", {}).done(function (data) {
            var summary = (data.Summary || [])[0] || {};
            setKpi("OpenLeads", summary.OpenLeads || 0);
            setKpi("WonDeals", summary.WonDeals || 0);
            setKpi("PipelineValue", formatMoney(summary.PipelineValue || 0));
            setKpi("DueActivities", summary.DueActivities || 0);
            renderPipelineSummary(data.Pipeline || []);
            renderMiniList("#crmTodayList", data.Today || [], "Subject", "DueText", "StatusName");
            renderMiniList("#crmFreshLeads", data.FreshLeads || [], "LeadName", "CompanyName", "StatusName");
            renderRecent(data.Recent || []);
            renderReminderPanel(data.Reminders || []);
            loadAutomationSnapshot();
        });
    }

    function loadReports() {
        callService("GetReports", {}).done(function (data) {
            renderMetricStack("#crmForecastReport", data.Forecast || [], "StageName", "WeightedValue", "DealCount");
            renderMetricStack("#crmLeadFunnelReport", data.LeadFunnel || [], "StatusName", "LeadCount", "ConversionHint");
            renderOwnerActivity(data.OwnerActivity || []);
        });
    }

    function loadAutomationCenter() {
        callService("GetAutomationCenter", {}).done(function (data) {
            state.automation = data || {};
            renderAutomationCenter(state.automation);
            renderAutomationSnapshot(state.automation);
            renderReminderPanel(state.automation.Notifications || []);
        });
    }

    function loadAutomationSnapshot() {
        if ($("#crmAutomationStats").length === 0 && $("#crmReminderPanel").length === 0) {
            return;
        }

        callService("GetAutomationCenter", {}, true).done(function (data) {
            state.automation = data || {};
            renderAutomationSnapshot(state.automation);
            renderReminderPanel(state.automation.Notifications || []);
        });
    }

    function loadNotificationPanel() {
        if ($("#crmReminderPanel").length === 0) {
            return;
        }

        callService("GetNotifications", {}, true).done(function (data) {
            renderReminderPanel(data.Notifications || []);
        });
    }

    function switchSettingsTab() {
        var tab = $(this).data("crm-tab");
        $(".crm-tab-btn").removeClass("active");
        $(this).addClass("active");
        $(".crm-settings-panel").removeClass("active");
        $('[data-crm-panel="' + tab + '"]').addClass("active");
    }

    function renderAutomationCenter(data) {
        fillForm("#crmEmailSettingsForm", (data.EmailSettings || [])[0] || {});
        fillForm("#crmNotificationSettingsForm", (data.NotificationSettings || [])[0] || {});
        renderTemplateTable(data.EmailTemplates || []);
        renderAssignmentTable(data.AssignmentRules || []);
        renderSlaTable(data.SlaPolicies || []);
        renderNotificationList(data.Notifications || []);
        renderOutboxTable(data.EmailOutbox || []);

        if ((data.EmailTemplates || []).length === 0) {
            fillForm("#crmEmailTemplateForm", {
                TemplateID: 0,
                TemplateName: "Lead follow-up",
                TriggerEvent: "Lead Saved",
                Subject: "Thanks for your interest, {{LeadName}}",
                BodyHtml: "Hi {{LeadName}},<br><br>Thank you for connecting with us. Our team will follow up shortly.",
                IsEnabled: 1
            });
        } else {
            fillForm("#crmEmailTemplateForm", { TemplateID: 0, IsEnabled: 1 });
        }

        if ((data.AssignmentRules || []).length === 0) {
            fillForm("#crmAssignmentRuleForm", {
                RuleID: 0,
                RuleName: "Hot leads rotation",
                ApplyOn: "Lead",
                ConditionField: "Rating",
                ConditionOperator: "equals",
                ConditionValue: "Hot",
                RoutingMethod: "Auto-rotate",
                ActiveDays: "Mon,Tue,Wed,Thu,Fri",
                Priority: 1,
                IsEnabled: 1
            });
        } else {
            fillForm("#crmAssignmentRuleForm", { RuleID: 0, ApplyOn: "Lead", RoutingMethod: "Auto-rotate", Priority: 1, IsEnabled: 1 });
        }

        if ((data.SlaPolicies || []).length === 0) {
            fillForm("#crmSlaPolicyForm", {
                SLAPolicyID: 0,
                PolicyName: "Default lead response",
                ApplyOn: "Lead",
                FirstResponseMinutes: 60,
                FollowUpMinutes: 1440,
                WorkingHourStart: "09:30",
                WorkingHourEnd: "18:30",
                IsDefault: 1,
                IsEnabled: 1
            });
        } else {
            fillForm("#crmSlaPolicyForm", { SLAPolicyID: 0, ApplyOn: "Lead", FirstResponseMinutes: 60, FollowUpMinutes: 1440, WorkingHourStart: "09:30", WorkingHourEnd: "18:30", IsDefault: 0, IsEnabled: 1 });
        }
    }

    function renderAutomationSnapshot(data) {
        var stats = (data.AutomationStats || [])[0] || {};
        setAutoKpi("QueuedEmails", (stats.QueuedEmails || 0) + " queued");
        setAutoKpi("EmailStatus", stats.EmailStatus || "Ready");
        setAutoKpi("UnreadNotifications", (stats.UnreadNotifications || 0) + " unread");
        setAutoKpi("ActiveAssignmentRules", (stats.ActiveAssignmentRules || 0) + " active");
        setAutoKpi("ActiveSlaPolicies", (stats.ActiveSlaPolicies || 0) + " active");
        renderMiniList("#crmEmailQueueList", (data.EmailOutbox || []).slice(0, 5), "Subject", "ToEmail", "Status");
    }

    function saveAutomationItem() {
        var entity = $(this).data("settings-type");
        var selector = formSelectorForAutomation(entity);
        var payload = readForm(selector);

        callService("SaveAutomationItem", { entity: entity, payloadJson: JSON.stringify(payload) }).done(function (result) {
            if (result.Success) {
                loadAutomationCenter();
            } else {
                alert("Unable to save automation settings. Result: " + result.Result);
            }
        });
    }

    function editAutomationItem() {
        var entity = $(this).data("entity");
        var index = parseInt($(this).data("index"), 10);
        var rows = automationRows(entity);
        var row = rows[index] || {};
        fillForm(formSelectorForAutomation(entity), row);
        $(".crm-tab-btn[data-crm-tab='" + tabForAutomation(entity) + "']").trigger("click");
    }

    function deleteAutomationItem() {
        var entity = $(this).data("entity");
        var id = parseInt($(this).data("id"), 10);
        if (!confirm("Delete this automation item?")) {
            return;
        }

        callService("DeleteAutomationItem", { entity: entity, recordId: id }).done(function (result) {
            if (result.Success) {
                loadAutomationCenter();
            } else {
                alert("Unable to delete automation item. Result: " + result.Result);
            }
        });
    }

    function markNotificationsRead() {
        callService("MarkNotificationsRead", {}).done(function () {
            if ($(".crm-page").data("crm-page") === "settings") {
                loadAutomationCenter();
            } else {
                loadNotificationPanel();
            }
        });
    }

    function runAutomationNow() {
        var button = $("#crmRunAutomationNow");
        button.prop("disabled", true).addClass("disabled");
        $.ajax({
            type: "GET",
            url: "AutomationRunner.aspx?batch=25",
            dataType: "json"
        }).done(function (result) {
            var generated = result.Generated && result.Generated.length ? result.Generated[0] : {};
            loadAutomationCenter();
            alert("Automation completed. Emails sent: " + (result.EmailSent || 0) + ", failed: " + (result.EmailFailed || 0) + ", queued: " + (generated.QueuedEmails || 0) + ".");
        }).fail(function (xhr) {
            var message = xhr && xhr.responseText ? xhr.responseText : "Unable to run CRM automation.";
            alert(message);
        }).always(function () {
            button.prop("disabled", false).removeClass("disabled");
        });
    }

    function loadCurrentRecords() {
        var entity = state.currentEntity || $(".crm-page").data("crm-entity");
        if (!entity) {
            return;
        }

        var args = {
            entity: entity,
            searchText: $(".crm-search-input").val() || "",
            filterValue: $(".crm-status-filter").val() || "",
            ownerId: parseInt($(".crm-owner-filter").val() || "0", 10)
        };

        callService("GetRecords", args).done(function (rows) {
            state.currentRecords = rows || [];
            renderRecordTable(entity, state.currentRecords);
            if (entity === "Deal") {
                renderDealKanban(state.currentRecords);
            }
        });
    }

    function bindFilters(entity) {
        var statusSelect = $(".crm-status-filter");
        var ownerSelect = $(".crm-owner-filter");
        statusSelect.empty().append('<option value="">All</option>');
        ownerSelect.empty().append('<option value="0">All owners</option>');

        var statusLookup = [];
        var valueField = "FilterValue";
        var textField = "FilterText";

        if (entity === "Lead") {
            statusLookup = state.lookups.LeadStatuses || [];
            valueField = "LeadStatusID";
            textField = "StatusName";
        } else if (entity === "Deal") {
            statusLookup = state.lookups.DealStages || [];
            valueField = "DealStageID";
            textField = "StageName";
        } else if (entity === "Activity") {
            statusLookup = state.lookups.ActivityStatuses || [];
            valueField = "ActivityStatusID";
            textField = "StatusName";
        }

        $.each(statusLookup, function (_, item) {
            statusSelect.append($("<option/>").val(item[valueField]).text(item[textField]));
        });

        $.each(state.lookups.Owners || [], function (_, owner) {
            ownerSelect.append($("<option/>").val(owner.EmployeeID).text(owner.DisplayName));
        });
    }

    function renderRecordTable(entity, rows) {
        var table = $(".crm-record-table");
        var tableId = table.attr("id");
        if (state.tables[tableId]) {
            state.tables[tableId].destroy();
            state.tables[tableId] = null;
        }

        var html = "";
        $.each(rows, function (_, row) {
            html += renderRecordRow(entity, row);
        });
        table.find("tbody").html(html || '<tr><td colspan="7" class="crm-empty">No records found</td></tr>');

        if ($.fn.DataTable && rows.length > 0) {
            state.tables[tableId] = table.DataTable({
                responsive: true,
                pageLength: 25,
                order: [],
                dom: "Bfrtip",
                buttons: ["copy", "excel", "print"],
                language: { search: "Filter:" }
            });
        }
    }

    function renderRecordRow(entity, row) {
        var id = row.RecordID || row.LeadID || row.AccountID || row.ContactID || row.DealID || row.ActivityID || 0;
        var actions = '<span class="crm-row-actions">' +
            '<button type="button" class="crm-icon-btn crm-edit-record" title="Edit" data-entity="' + entity + '" data-id="' + id + '"><i class="fas fa-pen"></i></button>' +
            deleteButton(entity, id) +
            convertButton(entity, id, row.Name || row.LeadName) +
            '</span>';

        if (entity === "Lead") {
            return "<tr><td>" + titleCell(row.Name || row.LeadName, row.Email || row.Phone) + "</td><td>" + e(row.CompanyName) + "</td><td>" + badge(row.StatusName, row.StatusColor) + "</td><td>" + e(row.SourceName) + "</td><td>" + e(row.OwnerName) + "</td><td>" + e(formatDate(row.NextFollowUpDate || row.FollowUpText)) + "</td><td>" + actions + "</td></tr>";
        }

        if (entity === "Account") {
            return "<tr><td>" + titleCell(row.AccountName || row.Name, row.Website || row.Email) + "</td><td>" + e(row.Industry) + "</td><td>" + badge(row.AccountType || "Account") + "</td><td>" + e(row.OwnerName) + "</td><td>" + formatMoney(row.AnnualRevenue || 0) + "</td><td>" + e(formatDate(row.UpdatedOn)) + "</td><td>" + actions + "</td></tr>";
        }

        if (entity === "Contact") {
            return "<tr><td>" + titleCell(row.ContactName || row.Name, row.Phone || row.Mobile) + "</td><td>" + e(row.AccountName) + "</td><td>" + e(row.Title) + "</td><td>" + e(row.Email) + "</td><td>" + e(row.OwnerName) + "</td><td>" + e(formatDate(row.LastContactedDate)) + "</td><td>" + actions + "</td></tr>";
        }

        if (entity === "Deal") {
            return "<tr><td>" + titleCell(row.DealName || row.Name, row.ContactName) + "</td><td>" + e(row.AccountName) + "</td><td>" + badge(row.StageName, row.StatusColor) + "</td><td>" + formatMoney(row.Amount || 0) + "</td><td>" + e(formatDate(row.ExpectedCloseDate)) + "</td><td>" + e(row.OwnerName) + "</td><td>" + actions + "</td></tr>";
        }

        return "<tr><td>" + titleCell(row.Subject || row.Name, row.Description) + "</td><td>" + e(row.ActivityTypeName) + "</td><td>" + e(row.RelatedName || row.RelatedEntity) + "</td><td>" + badge(row.StatusName, row.StatusColor) + "</td><td>" + e(formatDate(row.DueDate)) + "</td><td>" + e(row.OwnerName) + "</td><td>" + actions + "</td></tr>";
    }

    function deleteButton(entity, id) {
        return '<button type="button" class="crm-icon-btn crm-delete-record" title="Delete" data-entity="' + entity + '" data-id="' + id + '"><i class="fas fa-trash"></i></button>';
    }

    function convertButton(entity, id, name) {
        if (entity !== "Lead") {
            return "";
        }

        return '<button type="button" class="crm-icon-btn crm-convert-lead" title="Convert lead" data-id="' + id + '" data-name="' + e(name) + '"><i class="fas fa-random"></i></button>';
    }

    function openEditor(entity, id) {
        var config = entityConfig[entity];
        if (!config) {
            return;
        }

        state.currentEntity = entity;
        $("#crmEditorTitle").text((id ? "Edit " : "New ") + config.title);
        $("#crmEditorEntity").val(entity);
        renderEditorFields(config, {});
        $("#crmEditorModal").modal("show");

        if (id) {
            callService("GetRecord", { entity: entity, recordId: parseInt(id, 10) }).done(function (data) {
                var row = (data.Record || [])[0] || {};
                renderEditorFields(config, row);
            });
        }
    }

    function renderEditorFields(config, values) {
        var grid = $("#crmEditorFields");
        grid.empty();

        $.each(config.fields, function (_, field) {
            var value = values[field.name] == null ? "" : values[field.name];
            if (field.type === "hidden") {
                grid.append('<input type="hidden" name="' + field.name + '" value="' + e(value) + '">');
                return;
            }

            var css = "crm-field" + (field.full ? " full" : "") + (field.wide ? " wide" : "");
            var input = buildInput(field, value);
            var required = field.required ? ' <span class="text-danger">*</span>' : "";
            grid.append('<div class="' + css + '"><label>' + field.label + required + '</label>' + input + '</div>');
        });
    }

    function buildInput(field, value) {
        if (field.type === "textarea") {
            return '<textarea class="form-control" name="' + field.name + '">' + e(value) + '</textarea>';
        }

        if (field.type === "select") {
            var html = '<select class="form-control" name="' + field.name + '"><option value="">Select</option>';
            $.each(state.lookups[field.lookup] || [], function (_, item) {
                var optionValue = item[field.value];
                var selected = String(optionValue) === String(value) ? " selected" : "";
                html += '<option value="' + e(optionValue) + '"' + selected + '>' + e(item[field.text]) + '</option>';
            });
            return html + '</select>';
        }

        if (field.type === "selectStatic") {
            var staticHtml = '<select class="form-control" name="' + field.name + '"><option value="">Select</option>';
            $.each(field.options || [], function (_, item) {
                var selected = String(item) === String(value) ? " selected" : "";
                staticHtml += '<option value="' + e(item) + '"' + selected + '>' + e(item) + '</option>';
            });
            return staticHtml + '</select>';
        }

        var type = field.type || "text";
        return '<input type="' + type + '" class="form-control" name="' + field.name + '" value="' + e(formatInputDate(value, type)) + '">';
    }

    function saveRecord() {
        var entity = $("#crmEditorEntity").val();
        var config = entityConfig[entity];
        var values = {};
        var isValid = true;

        $.each(config.fields, function (_, field) {
            values[field.name] = $('#crmEditorFields [name="' + field.name + '"]').val() || "";
            if (field.required && values[field.name] === "") {
                isValid = false;
            }
        });

        if (!isValid) {
            alert("Please fill all required fields.");
            return;
        }

        callService("SaveRecord", { entity: entity, payloadJson: JSON.stringify(values) }).done(function (result) {
            if (result.Success) {
                $("#crmEditorModal").modal("hide");
                loadLookups().always(loadCurrentRecords);
                if ($(".crm-page").data("crm-page") === "dashboard") {
                    loadDashboard();
                }
            } else {
                alert("Unable to save this record. Result: " + result.Result);
            }
        });
    }

    function deleteRecord(entity, id) {
        if (!confirm("Delete this " + entity.toLowerCase() + "?")) {
            return;
        }

        callService("DeleteRecord", { entity: entity, recordId: parseInt(id, 10) }).done(function (result) {
            if (result.Success) {
                loadLookups().always(loadCurrentRecords);
            } else {
                alert("Unable to delete this record. Result: " + result.Result);
            }
        });
    }

    function convertLead(id, name) {
        var dealName = prompt("Deal name", name ? name + " opportunity" : "New opportunity");
        if (!dealName) {
            return;
        }

        var amount = prompt("Expected amount", "0") || "0";
        var closeDate = prompt("Expected close date (yyyy-mm-dd)", "") || "";
        callService("ConvertLead", { leadId: parseInt(id, 10), dealName: dealName, amount: amount, closeDate: closeDate }).done(function (result) {
            if (result.Success) {
                loadLookups().always(loadCurrentRecords);
            } else {
                alert("Unable to convert this lead. Result: " + result.Result);
            }
        });
    }

    function renderDealKanban(rows) {
        var stages = state.lookups.DealStages || [];
        var html = "";

        $.each(stages, function (_, stage) {
            var stageRows = $.grep(rows, function (row) {
                return String(row.DealStageID) === String(stage.DealStageID);
            });
            var total = 0;
            $.each(stageRows, function (_, row) { total += numberValue(row.Amount); });

            html += '<div class="crm-kanban-column"><div class="crm-kanban-head"><span>' + e(stage.StageName) + '</span><span>' + formatMoney(total) + '</span></div><div class="crm-kanban-body">';
            $.each(stageRows.slice(0, 5), function (_, row) {
                html += '<div class="crm-deal-card"><strong>' + e(row.DealName || row.Name) + '</strong><span>' + e(row.AccountName) + '</span><span>' + formatMoney(row.Amount || 0) + ' | ' + e(formatDate(row.ExpectedCloseDate)) + '</span></div>';
            });
            html += stageRows.length === 0 ? '<div class="crm-empty">No deals</div>' : "";
            html += '</div></div>';
        });

        $("#crmDealKanban").html(html);
    }

    function renderPipelineSummary(rows) {
        var maxValue = 1;
        $.each(rows, function (_, row) {
            maxValue = Math.max(maxValue, numberValue(row.WeightedValue || row.Amount));
        });

        var html = "";
        $.each(rows, function (_, row) {
            var value = numberValue(row.WeightedValue || row.Amount);
            var width = Math.max(4, Math.round((value / maxValue) * 100));
            html += '<div class="crm-stage-row"><div class="crm-stage-name">' + e(row.StageName) + '</div><div class="crm-stage-bar"><div class="crm-stage-fill" style="width:' + width + '%"></div></div><div class="crm-stage-value">' + formatMoney(value) + '</div></div>';
        });

        $("#crmPipelineSummary").html(html || '<div class="crm-empty">No open pipeline</div>');
    }

    function renderMetricStack(selector, rows, labelField, valueField, subField) {
        var html = "";
        $.each(rows, function (_, row) {
            html += '<div class="crm-metric-row"><div class="crm-metric-label"><strong>' + e(row[labelField]) + '</strong><span>' + e(row[subField]) + '</span></div><div class="crm-stage-value">' + formatSmart(row[valueField]) + '</div></div>';
        });
        $(selector).html(html || '<div class="crm-empty">No data</div>');
    }

    function renderOwnerActivity(rows) {
        var html = "";
        $.each(rows, function (_, row) {
            html += '<tr><td>' + e(row.OwnerName) + '</td><td>' + e(row.OpenLeads) + '</td><td>' + e(row.OpenDeals) + '</td><td>' + e(row.DueActivities) + '</td><td>' + badge(row.OverdueActivities, row.OverdueActivities > 0 ? "red" : "green") + '</td></tr>';
        });
        $("#crmOwnerActivityReport tbody").html(html || '<tr><td colspan="5" class="crm-empty">No data</td></tr>');
    }

    function renderTemplateTable(rows) {
        var html = "";
        $.each(rows, function (index, row) {
            var enabled = isOn(row.IsEnabled);
            html += "<tr><td>" + e(row.TemplateName) + "</td><td>" + e(row.TriggerEvent) + "</td><td>" + e(row.Subject) + "</td><td>" + badge(enabled ? "Enabled" : "Disabled", enabled ? "green" : "red") + "</td><td>" + automationActions("EmailTemplate", row.TemplateID, index) + "</td></tr>";
        });
        $("#crmTemplateTable tbody").html(html || '<tr><td colspan="5" class="crm-empty">No templates</td></tr>');
    }

    function renderAssignmentTable(rows) {
        var html = "";
        $.each(rows, function (index, row) {
            var condition = [row.ConditionField, row.ConditionOperator, row.ConditionValue].join(" ");
            var enabled = isOn(row.IsEnabled);
            html += "<tr><td>" + titleCell(row.RuleName, row.Description) + "</td><td>" + e(row.ApplyOn) + "</td><td>" + e(condition) + "</td><td>" + e(row.RoutingMethod) + "</td><td>" + badge(enabled ? "Enabled" : "Disabled", enabled ? "green" : "red") + "</td><td>" + automationActions("AssignmentRule", row.RuleID, index) + "</td></tr>";
        });
        $("#crmAssignmentTable tbody").html(html || '<tr><td colspan="6" class="crm-empty">No assignment rules</td></tr>');
    }

    function renderSlaTable(rows) {
        var html = "";
        $.each(rows, function (index, row) {
            var enabled = isOn(row.IsEnabled);
            html += "<tr><td>" + titleCell(row.PolicyName, row.ConditionsText) + "</td><td>" + e(row.ApplyOn) + "</td><td>" + e(row.FirstResponseMinutes) + " min</td><td>" + e(row.FollowUpMinutes) + " min</td><td>" + badge(enabled ? "Enabled" : "Disabled", enabled ? "green" : "red") + "</td><td>" + automationActions("SlaPolicy", row.SLAPolicyID, index) + "</td></tr>";
        });
        $("#crmSlaTable tbody").html(html || '<tr><td colspan="6" class="crm-empty">No SLA policies</td></tr>');
    }

    function renderNotificationList(rows) {
        var html = "";
        $.each(rows, function (_, row) {
            var read = isOn(row.IsRead);
            html += '<div class="crm-mini-item"><div><strong>' + e(row.Title || row.Subject) + '</strong><span>' + e(row.Message || row.DueText || formatDate(row.CreatedOn)) + '</span></div>' + badge(read ? "Read" : "Unread", read ? "green" : "amber") + '</div>';
        });
        $("#crmNotificationList").html(html || '<div class="crm-empty">No notifications</div>');
    }

    function renderOutboxTable(rows) {
        var html = "";
        $.each(rows, function (_, row) {
            html += '<tr><td>' + e(row.ToEmail) + '</td><td>' + e(row.Subject) + '</td><td>' + e(row.RelatedEntity) + " #" + e(row.RelatedRecordID) + '</td><td>' + badge(row.Status) + '</td><td>' + e(formatDate(row.CreatedOn)) + '</td></tr>';
        });
        $("#crmOutboxTable tbody").html(html || '<tr><td colspan="5" class="crm-empty">No email queue records</td></tr>');
    }

    function automationActions(entity, id, index) {
        return '<span class="crm-row-actions">' +
            '<button type="button" class="crm-icon-btn crm-edit-automation" title="Edit" data-entity="' + entity + '" data-index="' + index + '"><i class="fas fa-pen"></i></button>' +
            '<button type="button" class="crm-icon-btn crm-delete-automation" title="Delete" data-entity="' + entity + '" data-id="' + e(id) + '"><i class="fas fa-trash"></i></button>' +
            '</span>';
    }

    function fillForm(selector, values) {
        var form = $(selector);
        if (form.length === 0) {
            return;
        }

        form.find("[name]").each(function () {
            var input = $(this);
            var name = input.attr("name");
            var value = values && values[name] != null ? values[name] : "";
            if (input.is("select") && (value === true || value === false)) {
                value = value ? "1" : "0";
            }
            if (input.attr("type") === "time" && value) {
                value = String(value).substring(0, 5);
            }
            input.val(value);
        });
    }

    function readForm(selector) {
        var values = {};
        $(selector).find("[name]").each(function () {
            values[$(this).attr("name")] = $(this).val() || "";
        });
        return values;
    }

    function formSelectorForAutomation(entity) {
        if (entity === "EmailSettings") {
            return "#crmEmailSettingsForm";
        }
        if (entity === "NotificationSettings") {
            return "#crmNotificationSettingsForm";
        }
        if (entity === "EmailTemplate") {
            return "#crmEmailTemplateForm";
        }
        if (entity === "AssignmentRule") {
            return "#crmAssignmentRuleForm";
        }
        return "#crmSlaPolicyForm";
    }

    function tabForAutomation(entity) {
        if (entity === "EmailTemplate") {
            return "templates";
        }
        if (entity === "AssignmentRule") {
            return "assignment";
        }
        if (entity === "SlaPolicy") {
            return "sla";
        }
        if (entity === "NotificationSettings") {
            return "notifications";
        }
        return "email";
    }

    function automationRows(entity) {
        if (entity === "EmailTemplate") {
            return state.automation.EmailTemplates || [];
        }
        if (entity === "AssignmentRule") {
            return state.automation.AssignmentRules || [];
        }
        if (entity === "SlaPolicy") {
            return state.automation.SlaPolicies || [];
        }
        return [];
    }

    function renderMiniList(selector, rows, titleField, subField, badgeField) {
        var html = "";
        $.each(rows, function (_, row) {
            html += '<div class="crm-mini-item"><div><strong>' + e(row[titleField]) + '</strong><span>' + e(row[subField]) + '</span></div><div>' + badge(row[badgeField]) + '</div></div>';
        });
        $(selector).html(html || '<div class="crm-empty">Nothing pending</div>');
    }

    function renderRecent(rows) {
        var html = "";
        $.each(rows, function (_, row) {
            html += '<tr><td>' + badge(row.RecordType) + '</td><td>' + titleCell(row.RecordName, row.Subtitle) + '</td><td>' + e(row.OwnerName) + '</td><td>' + e(row.StatusName) + '</td><td>' + e(formatDate(row.UpdatedOn)) + '</td></tr>';
        });
        $("#crmRecentTable tbody").html(html || '<tr><td colspan="5" class="crm-empty">No recent CRM movement</td></tr>');
    }

    function renderReminderPanel(rows) {
        var html = "";
        $.each(rows || [], function (_, row) {
            var title = row.Title || row.Subject || row.NotificationType || "CRM notification";
            var detail = row.Message || row.DueText || formatDate(row.DueDate) || formatDate(row.CreatedOn);
            var read = isOn(row.IsRead);
            var status = row.StatusName || (read ? "Read" : "Unread");
            var color = row.StatusColor || (read ? "green" : "amber");
            html += '<div class="crm-mini-item"><div><strong>' + e(title) + '</strong><span>' + e(detail) + '</span></div>' + badge(status, color) + '</div>';
        });
        $("#crmReminderPanel").html(html || '<div class="crm-empty">No reminders</div>');
        $("#crm_pendingtask").text(rows && rows.length ? rows.length : "");
    }

    function ensureEditor() {
        if ($("#crmEditorModal").length > 0) {
            return;
        }

        $("body").append(
            '<div class="modal fade crm-editor-modal" id="crmEditorModal" tabindex="-1" role="dialog" aria-hidden="true">' +
            '<div class="modal-dialog modal-lg" role="document"><div class="modal-content">' +
            '<div class="modal-header"><h5 class="modal-title" id="crmEditorTitle">CRM record</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>' +
            '<div class="modal-body"><input type="hidden" id="crmEditorEntity"><div class="crm-editor-grid" id="crmEditorFields"></div></div>' +
            '<div class="modal-footer"><button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancel</button><button type="button" class="btn btn-primary" id="crmSaveRecord"><i class="fas fa-save"></i> Save</button></div>' +
            '</div></div></div>'
        );
    }

    function callService(method, data, silent) {
        return $.ajax({
            type: "POST",
            url: serviceUrl + method,
            data: JSON.stringify(data || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).then(function (res) {
            if (!res || res.d == null || res.d === "") {
                return {};
            }
            return typeof res.d === "string" ? JSON.parse(res.d) : res.d;
        }, function (xhr) {
            var message = xhr && xhr.responseText ? xhr.responseText : "CRM service request failed.";
            if (!silent) {
                alert(message);
            }
            return $.Deferred().reject(xhr);
        });
    }

    function setKpi(name, value) {
        $('[data-kpi="' + name + '"]').text(value);
    }

    function setAutoKpi(name, value) {
        $('[data-auto-kpi="' + name + '"]').text(value);
    }

    function titleCell(title, subtitle) {
        return '<span class="crm-record-title">' + e(title || "") + '</span><span class="crm-record-subtitle">' + e(subtitle || "") + '</span>';
    }

    function badge(value, color) {
        var text = value == null || value === "" ? "-" : value;
        var css = color || "";
        if (!css && /won|complete|active/i.test(text)) {
            css = "green";
        } else if (!css && /lost|overdue|critical/i.test(text)) {
            css = "red";
        } else if (!css && /new|open|pending|proposal/i.test(text)) {
            css = "amber";
        }
        return '<span class="crm-badge ' + css + '">' + e(text) + '</span>';
    }

    function formatMoney(value) {
        var number = numberValue(value);
        return number.toLocaleString("en-IN", { style: "currency", currency: "INR", maximumFractionDigits: 0 });
    }

    function formatSmart(value) {
        if ($.isNumeric(value)) {
            return numberValue(value).toLocaleString("en-IN");
        }
        return e(value);
    }

    function numberValue(value) {
        var number = parseFloat(value || 0);
        return isNaN(number) ? 0 : number;
    }

    function isOn(value) {
        return value === true || value === 1 || value === "1" || String(value).toLowerCase() === "true" || String(value).toLowerCase() === "yes";
    }

    function formatDate(value) {
        if (!value) {
            return "";
        }

        var date = parseDate(value);
        if (!date) {
            return String(value);
        }

        return date.toLocaleDateString("en-IN", { day: "2-digit", month: "short", year: "numeric" });
    }

    function formatInputDate(value, type) {
        if (!value || (type !== "date" && type !== "datetime-local")) {
            return value || "";
        }

        var date = parseDate(value);
        if (!date) {
            return value || "";
        }

        var yyyy = date.getFullYear();
        var mm = pad(date.getMonth() + 1);
        var dd = pad(date.getDate());
        if (type === "datetime-local") {
            return yyyy + "-" + mm + "-" + dd + "T" + pad(date.getHours()) + ":" + pad(date.getMinutes());
        }
        return yyyy + "-" + mm + "-" + dd;
    }

    function parseDate(value) {
        if (value instanceof Date) {
            return value;
        }

        var match = /\/Date\((\d+)\)\//.exec(value);
        if (match) {
            return new Date(parseInt(match[1], 10));
        }

        var date = new Date(value);
        return isNaN(date.getTime()) ? null : date;
    }

    function pad(value) {
        return value < 10 ? "0" + value : String(value);
    }

    function markActiveNav() {
        var page = (window.location.pathname.split("/").pop() || "Dashboard.aspx").toLowerCase();
        $(".crm-local-nav a").each(function () {
            var href = ($(this).attr("href") || "").toLowerCase();
            $(this).toggleClass("active", href === page);
        });
    }

    function e(value) {
        return $("<div/>").text(value == null ? "" : value).html();
    }
})(window, jQuery);
