(function ($, window) {
    "use strict";

    var api = "SearchDashboard.aspx/";
    var tables = {};
    var state = { projects: [], refreshTimer: null, modules: { allocation: false, queue: false, process: false, upload: false, costing: false } };

    function busy(show) { $("#sdLoader").toggleClass("active", !!show); }
    function alertUser(message, kind) {
        $("#sdAlert").removeClass("alert-success alert-danger alert-warning alert-info")
            .addClass("alert-" + (kind || "info")).text(message).stop(true, true).fadeIn(120);
        window.scrollTo(0, 0);
        if (kind === "success") { window.setTimeout(function () { $("#sdAlert").fadeOut(200); }, 4500); }
    }
    function value(row, names, fallback) {
        var i;
        for (i = 0; i < names.length; i += 1) {
            if (row && row[names[i]] !== undefined && row[names[i]] !== null) { return row[names[i]]; }
        }
        return fallback === undefined ? "" : fallback;
    }
    function parseRows(result) {
        var payload = result && result.d !== undefined ? result.d : result;
        if (typeof payload === "string") {
            try { payload = JSON.parse(payload); } catch (ignore) { payload = []; }
        }
        return $.isArray(payload) ? payload : (payload && $.isArray(payload.Data) ? payload.Data : []);
    }
    function call(method, data, options) {
        options = options || {};
        if (!options.quiet) { busy(true); }
        return $.ajax({
            type: "POST", url: api + method, data: JSON.stringify(data || {}),
            contentType: "application/json; charset=utf-8", dataType: "json"
        }).fail(function (xhr) {
            var message = "The requested operation could not be completed.";
            try { message = JSON.parse(xhr.responseText).Message || message; } catch (ignore) { }
            alertUser(message, "danger");
        }).always(function () { if (!options.quiet) { busy(false); } });
    }
    function destroyTable(id) {
        if (tables[id]) { tables[id].destroy(); delete tables[id]; }
        $("#" + id).empty();
    }
    function encode(text) { return $("<div/>").text(text === null || text === undefined ? "" : text).html(); }
    function checkboxMarkup(id, className, labelText, checked) {
        return "<div class='checkbox-wrapper-24 compact'>" +
            "<input type='checkbox' id='" + encode(id) + "' class='" + encode(className || "") + "'" + (checked ? " checked" : "") + " />" +
            "<label for='" + encode(id) + "'><span></span>" + encode(labelText || "") + "</label></div>";
    }
    function label(name) {
        return String(name).replace(/([a-z])([A-Z])/g, "$1 $2").replace(/_/g, " ")
            .replace(/\bId\b/g, "ID").replace(/\bNo\b/g, "No.");
    }
    function isHiddenKey(key) {
        return /^(OrderID|OrderId|Taskid|TaskId|ProcessId|ProcessID|TemplateId|TaskTemplateId|TransferAssignedId)$/i.test(key);
    }
    function bandFor(key) {
        var k = key.toLowerCase();
        if (k.indexOf("judgmentcopy") >= 0 || k.indexOf("judgementcopy") >= 0) { return "Judgment Copy Cost"; }
        if (k.indexOf("judgmentsearch") >= 0 || k.indexOf("judgementsearch") >= 0) { return "Judgment Search Cost"; }
        if (k.indexOf("searchcopy") >= 0) { return "Search Copy Cost"; }
        if (k.indexOf("search") >= 0) { return "Search Cost"; }
        if (k.indexOf("abstract") >= 0) { return "Abstractor Cost"; }
        if (k.indexOf("tax") >= 0) { return "Tax"; }
        if (k.indexOf("other") >= 0) { return "Other Cost"; }
        return "Order / Production";
    }
    function addBandHeader($table, columns, specialCount) {
        var groups = [], current = null, i, band;
        for (i = specialCount; i < columns.length; i += 1) {
            band = bandFor(columns[i]);
            if (!current || current.name !== band) {
                current = { name: band, count: 1 }; groups.push(current);
            } else { current.count += 1; }
        }
        var html = "<tr>";
        if (specialCount) { html += "<th class='sd-band' colspan='" + specialCount + "'>Action</th>"; }
        $.each(groups, function (_, group) { html += "<th class='sd-band' colspan='" + group.count + "'>" + encode(group.name) + "</th>"; });
        html += "</tr>";
        $table.find("thead").prepend(html);
    }
    function renderTable(id, rows, options) {
        options = options || {};
        destroyTable(id);
        var $table = $("#" + id), keys = [], columns = [], special = options.special || [];
        if (rows.length) { keys = Object.keys(rows[0]); }
        if (options.endAtColumn) {
            var endColumn = String(options.endAtColumn).replace(/[^a-z0-9]/gi, "").toLowerCase();
            var endIndex = keys.findIndex(function (key) {
                return String(key).replace(/[^a-z0-9]/gi, "").toLowerCase() === endColumn;
            });
            if (endIndex >= 0) { keys = keys.slice(0, endIndex + 1); }
        }
        $.each(special, function (_, item) { columns.push({ title: item.title, data: null, orderable: false, searchable: false, render: item.render }); });
        $.each(keys, function (_, key) {
            if (!options.includeHidden && isHiddenKey(key)) { return; }
            columns.push({ title: label(key), data: key, defaultContent: "", visible: !(options.hidden || []).some(function (x) { return x.toLowerCase() === key.toLowerCase(); }) });
        });
        if (!columns.length) { $table.html("<tbody><tr><td class='sd-empty'>No records found.</td></tr></tbody>"); return null; }
        tables[id] = $table.DataTable({
            data: rows, columns: columns, scrollX: true, autoWidth: false, pageLength: options.pageLength || 10,
            lengthMenu: [10, 25, 50, 100], order: [], deferRender: true,
            dom: options.buttons ? "Bfrtip" : "lfrtip", buttons: options.buttons || [],
            language: { emptyTable: "No records found." }
        });
        if (options.bands) { addBandHeader($table, keys.filter(function (k) { return options.includeHidden || !isHiddenKey(k); }), special.length); }
        return tables[id];
    }
    function fillSelect(selector, rows, valueNames, textNames) {
        var $select = $(selector), selected = $select.val();
        $select.empty().append($("<option/>", { value: "", text: "Select" }));
        $.each(rows, function (_, row) {
            var v = value(row, valueNames), t = value(row, textNames, v);
            if (v !== "") { $select.append($("<option/>", { value: v, text: t })); }
        });
        if ($select.find("option[value='" + String(selected).replace(/'/g, "\\'") + "']").length) { $select.val(selected); }
    }
    function requireFields(items) {
        var missing = [];
        $.each(items, function (_, item) { if (!$.trim($(item.selector).val())) { missing.push(item.label); } });
        if (missing.length) { alertUser("Please select/enter: " + missing.join(", ") + ".", "warning"); return false; }
        return true;
    }
    function dateInput(selector, initial) {
        $(selector).val(initial).daterangepicker({ singleDatePicker: true, autoApply: true, locale: { format: "DD-MMM-YYYY" } });
    }
    function loadProjects() {
        return call("GetProjects", {}, { quiet: true }).done(function (r) {
            state.projects = parseRows(r);
            fillSelect(".sd-project", state.projects, ["ProjectID", "ProjectId", "ID"], ["ProjectName", "ProjectNumber", "Project", "Name"]);
        });
    }
    function loadProcesses(projectId, selector) {

        fillSelect(selector, [], ["Processid"], ["ProcessName"]);

        if (!projectId) { return $.Deferred().resolve().promise(); }

        return call("GetProjectProcesses", { projectId: parseInt(projectId, 10) || 0 }, { quiet: true })
            .done(function (r) {
                fillSelect(selector, parseRows(r), ["Processid", "ProcessId", "ProcessID", "TaskProcessid", "TaskProcessID", "ID"], ["ProcessName", "Process", "Name"]);
            });
    }

    function loadAllocationUsers() {
        call("GetAllocationUsers", { userType: $("#allocType").val() }, { quiet: true })
            .done(function (r) {
                var rows = parseRows(r);
                $.each(rows, function (_, row) {
                    var code = $.trim(value(row, ["Code", "UserCode"]));
                    var name = $.trim([value(row, ["EmpName"])].join(" ").replace(/\s+/g, " "));
                    row.DashboardUserName = code && name ?  name : (name || code || value(row, ["EmployeeName", "UserName", "Name"]));
                });
                fillSelect("#allocUser", rows, ["EmployeeID", "EmployeeId", "UserId", "ID"], ["DashboardUserName", "EmployeeName", "UserName", "Name", "Code"]);
            });
    }


    function allocationSummary() {
        if (!requireFields([{ selector: "#allocProject", label: "Project" }, { selector: "#allocProcess", label: "Process" }])) { return; }
        var $p = $("#allocProcess"), prev = $p.prop("selectedIndex") > 1 ? parseInt($p.find("option:selected").prev().val(), 10) : -1;
        call("GetAllocationSummary", { projectNumber: $("#allocProject option:selected").text(), processId: parseInt($p.val(), 10), previousProcessId: prev })
            .done(function (r) {
                var dt = renderTable("allocSummaryTable", parseRows(r), {
                    special: [{
                        title: "Get Orders",
                        render: function () {
                            return "<button type='button' class='sd-get-orders alloc-get-orders' title='Get orders' aria-label='Get orders'>" +
                                "<i class='fas fa-arrow-down'></i></button>";
                        }
                    }]
                });
                if (dt) {
                    $("#allocSummaryTable tbody").off("click.searchDashboard").on("click.searchDashboard", "tr", function () {
                        var row = dt.row(this).data(); $("#allocSummaryTable tbody tr").removeClass("sd-selected"); $(this).addClass("sd-selected");
                        loadAllocationOrders(row);
                    });
                    $("#allocSummaryTable tbody").on("click.searchDashboard", ".alloc-get-orders", function (event) {
                        event.preventDefault();
                        event.stopPropagation();
                        var tableRow = $(this).closest("tr");
                        var row = dt.row(tableRow).data();
                        $("#allocSummaryTable tbody tr").removeClass("sd-selected");
                        tableRow.addClass("sd-selected");
                        loadAllocationOrders(row).done(focusAllocationOrders);
                    });
                }
            });
    }
    function focusAllocationOrders() {
        var section = document.getElementById("allocOrdersSection");
        if (!section) { return; }
        try { section.focus({ preventScroll: true }); } catch (ignore) { section.focus(); }
        section.scrollIntoView({ behavior: "smooth", block: "start" });
    }
    function loadAllocationOrders(summary) {
        var $p = $("#allocProcess"), prev = $p.prop("selectedIndex") > 1 ? parseInt($p.find("option:selected").prev().val(), 10) : -1;
        return call("GetAllocationOrders", {
            projectNumber: $("#allocProject option:selected").text(), processId: parseInt($p.val(), 10), previousProcessId: prev,
            productType: value(summary, ["ProductType", "Product"]), orderDate: value(summary, ["OrderDate", "OrderDateTime", "Date"])
        }).done(function (r) {
            renderTable("allocOrdersTable", parseRows(r), {
                special: [{
                    title: checkboxMarkup("allocCheckAll", "", "", false),
                    render: function (d, t, row, meta) {
                        return checkboxMarkup("allocOrderCheck_" + meta.row, "alloc-order-check", "", false);
                    }
                }]
            });
        });
    }
    function allocateOrders() {
        if (!requireFields([{ selector: "#allocProject", label: "Project" }, { selector: "#allocProcess", label: "Process" }, { selector: "#allocUser", label: "Assignee" }])) { return; }
        var dt = tables.allocOrdersTable, orders = [];
        if (dt) {
            $("#allocOrdersTable tbody .alloc-order-check:checked").each(function () {
                var row = dt.row($(this).closest("tr")).data();
                orders.push({ OrderId: parseInt(value(row, ["OrderID", "OrderId"]), 10), ProductType: value(row, ["ProductType", "Product"]) });
            });
        }
        if (!orders.length) { alertUser("Select at least one order to allocate.", "warning"); return; }
        call("AllocateOrders", {
            projectId: parseInt($("#allocProject").val(), 10), processId: parseInt($("#allocProcess").val(), 10),
            assignedTo: parseInt($("#allocUser").val(), 10), allocateTo: $("#allocType").val(), orders: orders
        }).done(function (r) {
            var result = r.d || {}; alertUser(result.Message || "Allocation completed.", result.Success ? "success" : "warning");
            if (result.Success) { allocationSummary(); destroyTable("allocOrdersTable"); }
        });
    }
    function loadQueue() {
        call("GetOrderQueue", {}).done(function (r) { renderTable("queueTable", parseRows(r)); state.modules.queue = true; });
    }

    function loadProjectOrders(projectSelector, orderSelector, dateSelector) {
        var projectText = $(projectSelector + " option:selected").text(), data = { projectNumber: projectText };
        if (dateSelector) { data.orderDate = $(dateSelector).val(); }
        if (!$(projectSelector).val()) { fillSelect(orderSelector, [], ["OrderId"], ["ClientOrderNo"]); return; }
        call(dateSelector ? "GetUploadOrders" : "GetPmOrders", data, { quiet: true }).done(function (r) {
            fillSelect(orderSelector, parseRows(r), ["OrderID", "OrderId", "ID"], ["ClientOrderNo", "OrderNo", "ClientOrderNumber"]);
        });
    }
    function loadPmOrder() {
        var orderId = parseInt($("#pmOrder").val(), 10);
        destroyTable("pmTaskTable"); $("#pmProcess,#pmAssignedUser").val(""); $("#pmProcessId,#pmAssignedId").val("");
        if (!orderId) { return; }
        call("GetPmOrderContext", { orderId: orderId }).done(function (r) {
            var payload = r.d || {}, context = payload.Context || {}, tasks = payload.Tasks || [];
            $("#pmProcess").val(value(context, ["ProcessName", "Process"]));
            $("#pmProcessId").val(value(context, ["ProcessId", "ProcessID"]));
            $("#pmAssignedUser").val(value(context, ["EmployeeName", "AssignedUser", "UserName", "Code"]));
            $("#pmAssignedId").val(value(context, ["TaskAssignedId", "EmployeeID", "EmployeeId"]));
            renderTable("pmTaskTable", tasks, {
                special: [
                    {
                        title: checkboxMarkup("pmCheckAll", "", "", true),
                        render: function (d, t, row, meta) {
                            return value(row, ["TransferAssignedId"], 0) ? "" : checkboxMarkup("pmTaskCheck_" + meta.row, "pm-task-check", "", true);
                        }
                    },
                    { title: "Status", render: function (d, t, row) { return "<button type='button' class='btn btn-xs btn-outline-success pm-status' data-task='" + encode(value(row, ["Taskid", "TaskId"])) + "'>Status</button>"; } }
                ]
            });
        });
    }
    function completePmOrder() {
        var required = [{ selector: "#pmProject", label: "Project" }, { selector: "#pmOrder", label: "Order" }, { selector: "#pmProcessId", label: "Current Process" }];
        if (!requireFields(required)) { return; }
        var file = $("#pmFile")[0].files[0];
        if (!file) { alertUser("Please choose the completion attachment.", "warning"); return; }
        var dt = tables.pmTaskTable, taskIds = [];
        $("#pmTaskTable tbody .pm-task-check:checked").each(function () { taskIds.push(parseInt(value(dt.row($(this).closest("tr")).data(), ["Taskid", "TaskId"]), 10)); });
        if (!taskIds.length) { alertUser("Select at least one task.", "warning"); return; }
        var form = new FormData();
        form.append("file", file); form.append("orderId", $("#pmOrder").val()); form.append("clientOrderNo", $("#pmOrder option:selected").text());
        form.append("projectNumber", $("#pmProject option:selected").text()); form.append("processId", $("#pmProcessId").val()); form.append("processName", $("#pmProcess").val());
        form.append("assignedUserId", $("#pmAssignedId").val() || "0"); form.append("actionStatus", $("#pmAction").val()); form.append("remark", $("#pmRemark").val());
        form.append("cancelledBy", $("#pmCancelledBy").val()); form.append("cancelReason", $("#pmCancelReason").val()); form.append("taskIds", taskIds.join(","));
        form.append("dispatch", $("#pmDispatch").prop("checked")); form.append("noFeedback", $("#pmNoFeedback").prop("checked"));
        form.append("taxCalling", $("#pmTax").prop("checked")); form.append("audit", $("#pmAudit").prop("checked")); form.append("offline", $("#pmOffline").prop("checked"));
        busy(true);
        $.ajax({ url: "SearchDashboard.aspx?action=completePm", type: "POST", data: form, processData: false, contentType: false, dataType: "json" })
            .done(function (r) { alertUser(r.Message, r.Success ? "success" : "warning"); if (r.Success) { loadPmOrder(); } })
            .fail(function () { alertUser("Process completion failed.", "danger"); }).always(function () { busy(false); });
    }
    function showTaskStatus(button) {
        var dt = tables.pmTaskTable, row = dt.row($(button).closest("tr")).data();
        $("#statusTaskId").val(value(row, ["Taskid", "TaskId"])); $("#statusDocumentType").val(value(row, ["DocumentType", "ProductType"]));
        $("#statusValue,#statusCaller").val(""); $("#statusTransferBox").hide(); $("#pmStatusModal").modal("show");
    }
    function saveTaskStatus() {
        if (!$("#statusValue").val()) { alertUser("Select task status.", "warning"); return; }
        if ($("#statusValue").val() === "Transfer" && !$("#statusCaller").val()) { alertUser("Select the caller to transfer the task.", "warning"); return; }
        call("UpdateIndividualTask", {
            taskId: parseInt($("#statusTaskId").val(), 10), status: $("#statusValue").val(), assignedTo: parseInt($("#statusCaller").val(), 10) || 0,
            documentType: $("#statusDocumentType").val(), assignedToName: $("#statusCaller option:selected").text()
        }).done(function (r) { var x = r.d || {}; alertUser(x.Message, x.Success ? "success" : "warning"); if (x.Success) { $("#pmStatusModal").modal("hide"); loadPmOrder(); } });
    }
    function orderDetails() {
        if (!$("#pmOrder").val()) { alertUser("Select an order.", "warning"); return; }
        call("GetOrderDetails", { orderId: parseInt($("#pmOrder").val(), 10) }).done(function (r) {
            renderTable("pmDetailsTable", parseRows(r), {
                special: [{
                    title: "Attachment", render: function (d, t, row) {
                        var p = value(row, ["Path", "OrdersheetPath", "Attachment"]);
                        return p ? "<a class='btn btn-xs btn-outline-primary' href='SearchDashboard.aspx?action=download&path=" + encodeURIComponent(p) + "'>Download</a>" : "";
                    }
                }]
            }); $("#pmDetailsModal").modal("show");
        });
    }

    function loadUploadDocs() {
        if (!$("#upOrder").val()) { destroyTable("upTable"); return; }
        call("GetUploadedDocuments", { orderId: parseInt($("#upOrder").val(), 10) }).done(function (r) {
            renderTable("upTable", parseRows(r), {
                endAtColumn: "AddedDate",
                special: [{
                    title: "Download", render: function (d, t, row) {
                        var p = value(row, ["Path", "FilePath"]);
                        return p ? "<a class='btn btn-xs btn-outline-primary' href='SearchDashboard.aspx?action=download&path=" + encodeURIComponent(p) + "'><i class='fas fa-download'></i></a>" : "";
                    }
                }]
            });
        });
    }
    function uploadDocument() {
        if (!requireFields([{ selector: "#upDate", label: "Date" }, { selector: "#upProject", label: "Project" }, { selector: "#upOrder", label: "Order" }, { selector: "#upProcess", label: "Process" }])) { return; }
        var file = $("#upFile")[0].files[0]; if (!file) { alertUser("Please choose an attachment.", "warning"); return; }
        var form = new FormData(); form.append("file", file); form.append("orderId", $("#upOrder").val()); form.append("clientOrderNo", $("#upOrder option:selected").text());
        form.append("processId", $("#upProcess").val()); form.append("processName", $("#upProcess option:selected").text());
        busy(true);
        $.ajax({ url: "SearchDashboard.aspx?action=uploadDocument", type: "POST", data: form, processData: false, contentType: false, dataType: "json" })
            .done(function (r) { alertUser(r.Message, r.Success ? "success" : "warning"); if (r.Success) { $("#upFile").val(""); loadUploadDocs(); } })
            .fail(function () { alertUser("Document upload failed.", "danger"); }).always(function () { busy(false); });
    }
    function loadCosting() {
        if (!requireFields([{ selector: "#costProject", label: "Project" }, { selector: "#costFrom", label: "From Date" }, { selector: "#costTo", label: "To Date" }])) { return; }
        call("GetCostingReport", { projectNumber: $("#costProject option:selected").text(), fromDate: $("#costFrom").val(), toDate: $("#costTo").val() })
            .done(function (r) {
                renderTable("costTable", parseRows(r), {
                    bands: true, special: [{
                        title: "Edit", render: function (d, t, row) {
                            var id = value(row, ["OrderID", "OrderId"]);
                            return "<a class='btn btn-xs btn-outline-success' href='Costing.aspx?OrderID=" + encodeURIComponent(id) + "&ddl=" + encodeURIComponent($("#costProject option:selected").text()) + "&fd=" + encodeURIComponent($("#costFrom").val()) + "&td=" + encodeURIComponent($("#costTo").val()) + "'><i class='fas fa-edit'></i> Edit</a>";
                        }
                    }], buttons: [{ extend: "excelHtml5", title: "Production Costing Report", className: "d-none sd-excel-button" }], pageLength: 25
                });
            });
    }
    function refreshActive() {
        var module = $("#sdMainTabs .nav-link.active").data("module");
        if (module === "allocation") { allocationSummary(); } else if (module === "queue") { loadQueue(); }
        else if (module === "process") { loadPmOrder(); } else if (module === "upload") { loadUploadDocs(); }
        else if (module === "costing") { loadCosting(); }
    }
    function startAllocationAutoRefresh() {
        if (state.refreshTimer) { window.clearInterval(state.refreshTimer); }
        state.refreshTimer = window.setInterval(function () {
            var module = $("#sdMainTabs .nav-link.active").data("module");
            if (module === "allocation" || module === "queue") { refreshActive(); }
        }, 300000);
    }
    function initializeModule(module) {
        if (state.modules[module]) { return; } state.modules[module] = true;
        if (module === "queue") { loadQueue(); }
        if (module === "process") { call("GetCallers", {}, { quiet: true }).done(function (r) { fillSelect("#statusCaller", parseRows(r), ["EmployeeID", "EmployeeId", "UserId", "ID"], ["EmployeeName", "Name", "Code"]); }); }
    }
    function bind() {
        $(document).off(".searchDashboard");
        $(document).on("shown.bs.tab.searchDashboard", "#sdMainTabs a[data-toggle='tab']", function () { initializeModule($(this).data("module")); $.fn.dataTable.tables({ visible: true, api: true }).columns.adjust(); });
        $(document).on("click.searchDashboard", "#sdRefresh", refreshActive);
        $(document).on("change.searchDashboard", "#allocProject", function () { loadProcesses(this.value, "#allocProcess"); });
        $(document).on("change.searchDashboard", "#allocType", loadAllocationUsers);
        $(document).on("click.searchDashboard", "#allocShowSummary", allocationSummary);
        $(document).on("click.searchDashboard", "#allocSubmit", allocateOrders);
        $(document).on("change.searchDashboard", "#allocCheckAll", function () { $(".alloc-order-check").prop("checked", this.checked); });
        $(document).on("change.searchDashboard", "#pmProject", function () { loadProjectOrders("#pmProject", "#pmOrder"); });
        $(document).on("change.searchDashboard", "#pmOrder", loadPmOrder);
        $(document).on("change.searchDashboard", "#pmAction", function () {
            var cancel = this.value === "Cancel", complete = this.value === "Complete";
            $("#pmCancelledBy,#pmCancelReason").prop("disabled", !cancel);
            $("#pmDispatch,#pmNoFeedback").prop("disabled", !complete);
            if (!complete) { $("#pmDispatch,#pmNoFeedback").prop("checked", false); }
        });
        $(document).on("click.searchDashboard", "#pmComplete", completePmOrder);
        $(document).on("click.searchDashboard", "#pmViewDetails", orderDetails);
        $(document).on("click.searchDashboard", ".pm-status", function () { showTaskStatus(this); });
        $(document).on("change.searchDashboard", "#pmCheckAll", function () { $(".pm-task-check").prop("checked", this.checked); });
        $(document).on("change.searchDashboard", "#statusValue", function () { $("#statusTransferBox").toggle(this.value === "Transfer"); });
        $(document).on("click.searchDashboard", "#statusSave", saveTaskStatus);
        $(document).on("change.searchDashboard", "#upProject", function () { loadProcesses(this.value, "#upProcess"); loadProjectOrders("#upProject", "#upOrder", "#upDate"); });
        $(document).on("change.searchDashboard", "#upDate", function () { loadProjectOrders("#upProject", "#upOrder", "#upDate"); });
        $(document).on("change.searchDashboard", "#upOrder", loadUploadDocs);
        $(document).on("click.searchDashboard", "#upLoad", loadUploadDocs);
        $(document).on("click.searchDashboard", "#upSubmit", uploadDocument);
        $(document).on("click.searchDashboard", "#costShow", loadCosting);
        $(document).on("click.searchDashboard", "#costExport", function () { $("#costTable_wrapper .sd-excel-button").trigger("click"); });
    }
    $(function () {
        var today = moment().format("DD-MMM-YYYY"), monthStart = moment().startOf("month").format("DD-MMM-YYYY");
        dateInput("#upDate", today); dateInput("#costFrom", monthStart); dateInput("#costTo", today);
        bind();
        startAllocationAutoRefresh();
        loadProjects().done(function () { loadAllocationUsers(); state.modules.allocation = true; });
    });
}(jQuery, window));
