(function ($) {
    "use strict";

    var mode = "current";
    var reportTable = null;
    var detailTable = null;
    var lastCriteria = null;

    var modes = {
        template: { title: "Template-wise Order Details", project: true, template: true, dates: true, method: "GetTemplateWiseReport" },
        performance: { title: "Project and Date Performance", project: true, dates: true, method: "GetProjectPerformanceReport" },
        project: { title: "Project Summary", dates: true, method: "GetProjectSummaryReport" },
        user: { title: "User Summary", dates: true, method: "GetUserSummaryReport" },
        status: { title: "Order Status", project: true, dates: true, status: true, method: "GetOrderStatusReport" },
        current: { title: "Current Order Status", method: "GetCurrentStatusReport" }
    };

    function post(method, data) {
        return $.ajax({
            type: "POST",
            url: "SummaryReport.aspx/" + method,
            data: JSON.stringify(data || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).then(function (response) {
            var value = response && response.d !== undefined ? response.d : response;
            return typeof value === "string" ? JSON.parse(value || "[]") : (value || []);
        });
    }

    function text(value) {
        return value === null || value === undefined || value === "null" ? "" : String(value);
    }

    function escapeHtml(value) {
        return text(value).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
    }

    function errorMessage(xhr, fallback) {
        var message = fallback;
        if (xhr && xhr.responseJSON && xhr.responseJSON.Message) message = xhr.responseJSON.Message;
        return text(message).replace(/^.*Exception:\s*/i, "");
    }

    function showMessage(message, type) {
        var $message = $("#summaryMessage");
        if (!message) return $message.removeClass("error info").hide().text("");
        $message.removeClass("error info").addClass(type || "error").text(message).show();
    }

    function loader(show) {
        $("#summaryLoader").toggleClass("show", show).attr("aria-hidden", show ? "false" : "true");
        $("#summaryShow, #summaryClear, .sr-tab").prop("disabled", show);
    }

    function localIso(date) {
        var year = date.getFullYear();
        var month = (date.getMonth() + 1).toString().padStart(2, "0");
        var day = date.getDate().toString().padStart(2, "0");
        return year + "-" + month + "-" + day;
    }

    function initializeDates() {
        var today = new Date();
        $("#summaryFromDate").val(localIso(new Date(today.getFullYear(), today.getMonth(), 1)));
        $("#summaryToDate").val(localIso(today));
    }

    function loadLists() {
        $.when(post("GetProjects"), post("GetStatuses"))
            .done(function (projects, statuses) {
                var $project = $("#summaryProject").empty().append('<option value="">Select Project</option>');
                $.each(projects || [], function (_, item) {
                    $("<option>").val(text(item.ProjectName)).text(text(item.ProjectName)).attr("data-id", text(item.ProjectID)).appendTo($project);
                });
                var $status = $("#summaryStatus").empty().append('<option value="">Select Status</option>');
                $.each(statuses || [], function (_, item) {
                    var value = text(item.StatusName || item.Status || item.Id);
                    $("<option>").val(value).text(text(item.StatusName || item.Status || value)).appendTo($status);
                });
            })
            .fail(function (xhr) { showMessage(errorMessage(xhr, "Unable to load report filters.")); });
    }

    function loadTemplates() {
        var $selected = $("#summaryProject option:selected");
        var projectId = parseInt($selected.attr("data-id"), 10) || 0;
        var $template = $("#summaryTemplate").empty().append('<option value="">Select Template</option>').prop("disabled", true);
        if (!projectId) return;
        post("GetTemplates", { projectId: projectId }).done(function (rows) {
            $.each(rows || [], function (_, item) {
                $("<option>").val(text(item.TemplateId)).text(text(item.Template)).appendTo($template);
            });
            $template.prop("disabled", false);
        }).fail(function (xhr) { showMessage(errorMessage(xhr, "Unable to load templates.")); });
    }

    function applyMode(nextMode, autoLoad) {
        mode = nextMode;
        var config = modes[mode];
        $(".sr-tab").removeClass("active").filter('[data-mode="' + mode + '"]').addClass("active");
        $(".sr-filter-project").toggle(!!config.project);
        $(".sr-filter-template").toggle(!!config.template);
        $(".sr-filter-from, .sr-filter-to").toggle(!!config.dates);
        $(".sr-filter-status").toggle(!!config.status);
        $("#summaryGridTitle").text(config.title);
        $("#summaryShow").html(config.method === "GetCurrentStatusReport" ? '<i class="fas fa-sync-alt"></i> Refresh' : '<i class="fas fa-search"></i> Show Report');
        clearTable();
        showMessage("");
        if (autoLoad && mode === "current") runReport();
    }

    function criteria() {
        var config = modes[mode];
        var result = { fromDate: $("#summaryFromDate").val(), toDate: $("#summaryToDate").val(), projectNo: $("#summaryProject").val(), status: $("#summaryStatus").val() };
        result.templateId = parseInt($("#summaryTemplate").val(), 10) || 0;
        if (config.project && !result.projectNo) return showMessage("Select a project."), null;
        if (config.template && !result.templateId) return showMessage("Select a template."), null;
        if (config.dates && (!result.fromDate || !result.toDate)) return showMessage("Select both From Date and To Date."), null;
        if (config.dates && result.fromDate > result.toDate) return showMessage("From Date cannot be later than To Date."), null;
        if (config.status && !result.status) return showMessage("Select a status."), null;
        return result;
    }

    function payload(values) {
        if (mode === "template") return { fromDate: values.fromDate, toDate: values.toDate, projectNo: values.projectNo, templateId: values.templateId };
        if (mode === "performance") return { fromDate: values.fromDate, toDate: values.toDate, projectNo: values.projectNo };
        if (mode === "project" || mode === "user") return { fromDate: values.fromDate, toDate: values.toDate };
        if (mode === "status") return { fromDate: values.fromDate, toDate: values.toDate, projectNo: values.projectNo, status: values.status };
        return {};
    }

    function runReport() {
        var values = criteria();
        if (!values) return;
        lastCriteria = values;
        showMessage("");
        loader(true);
        post(modes[mode].method, payload(values)).done(function (rows) {
            renderReport(rows || [], values);
        }).fail(function (xhr) {
            clearTable();
            showMessage(errorMessage(xhr, "Unable to load the report."));
        }).always(function () { loader(false); });
    }

    function column(title, key, options) {
        return $.extend({ title: title, data: key, defaultContent: "", render: function (data, type) { return type === "display" ? (text(data) ? escapeHtml(data) : "-") : text(data); } }, options || {});
    }

    function processColumn(title, key, dateKey, emptyText) {
        return column(title, key, {
            render: function (data, type) { var value = text(data) || emptyText || "X"; return type === "display" ? escapeHtml(value) : value; },
            createdCell: function (cell, data, row) {
                var status = text(row.ProcessStatus).toLowerCase();
                if (status === "cancel") $(cell).addClass("sr-cell-cancel");
                else if (status === "hold") $(cell).addClass("sr-cell-hold");
                else if (status === "dispatch" || text(row[dateKey])) $(cell).addClass("sr-cell-done");
                else $(cell).addClass("sr-cell-wait");
            }
        });
    }

    function templateColumns(projectNo) {
        var columns = [column("Sr.", "_sr", { className: "text-center" }), column("Project", "ProjectNumber"), column("Order #", "ClientOrderNo"), column("Order Date", "OrderDate"), column("Online / Offline", "OnOffLine", { createdCell: function (cell, value) { if (/offline/i.test(text(value))) $(cell).addClass("sr-cell-hold"); } }), column("Product Type", "ProductType"), column("Priority", "OrderPriority", { createdCell: function (cell, value) { if (text(value).toLowerCase() === "rush") $(cell).addClass("sr-cell-priority"); } }), column("State", "STATE"), column("County", "County"), column("Status", "ProcessStatus", { createdCell: function (cell, value) { var s=text(value).toLowerCase(); $(cell).addClass(s === "hold" ? "sr-cell-hold" : s === "cancel" ? "sr-cell-cancel" : s === "dispatch" ? "sr-cell-dispatch" : ""); } }), processColumn("Search", "SearchBy", "SearchDate"), processColumn("Research", "ReSearchBy", "ReSearchDate")];
        if (projectNo === "379-009" || projectNo === "380-001") columns.push(processColumn("Tax", "TaxBy", "TaxDate", "NA"));
        if (projectNo !== "379-009") columns.push(processColumn("DE", "TypingBy", "TypingDate"), processColumn("QA", "QABy", "QADate"));
        columns.push(processColumn("Audit", "AuditBy", "AuditDate", "NA"), processColumn("Dispatch", "DispBy", "DispDate", "NA"), column("Remark", "Remark"), column("Client ID", "ClientIdNew"), column("Customer Type", "CustomerType"), column("Legal Description", "LegalDescription"), column("Instruction", "Instruction"), column("APN No", "APNNo"), column("Transaction Type", "TransactionType"));
        return columns;
    }

    function userLink(type) {
        return function (data, renderType, row) {
            var value = text(data);
            if (renderType !== "display") return value;
            if (!value || value === "0") return escapeHtml(value || "0");
            return '<button type="button" class="sr-link js-user-detail" data-type="' + escapeHtml(type) + '" data-user="' + escapeHtml(row.EmpId) + '" data-code="' + escapeHtml(row.UserCode) + '">' + escapeHtml(value) + '</button>';
        };
    }

    function reportColumns(values) {
        if (mode === "template") return templateColumns(values.projectNo);
        if (mode === "performance") return [column("Sr.", "_sr"), column("Project", "ProjectNumber"), column("Order Date", "OrderDate"), column("Received", "Received", { sum:true }), column("Dispatch", "Dispatch", { sum:true }), column("Cancel", "Cancel", { sum:true }), column("Hold", "Hold", { sum:true }), column("Pending", "Pending", { sum:true })];
        if (mode === "project") return [column("Sr.", "_sr"), column("Project #", "ProjectNumber"), column("Received", "Received", { sum:true }), column("Dispatched", "Dispatch", { sum:true }), column("In Process", "Pending", { sum:true }), column("Hold", "Hold", { sum:true }), column("Cancelled", "Cancel", { sum:true }), column("Previous In Process", "PreviousPending", { sum:true })];
        if (mode === "user") return [column("Sr.", "_sr"), column("User Code", "UserCode"), column("Working Branch", "WorkingBranch"), column("Search", "Search", { render:userLink("Search"), sum:true }), column("Research", "ReSearch", { render:userLink("ReSearch"), sum:true }), column("Typing", "Typing", { render:userLink("Typing"), sum:true }), column("QA", "QA", { render:userLink("QA"), sum:true }), column("Dispatch", "Dispatch", { render:userLink("Dispatch"), sum:true }), column("Total", "Total", { sum:true })];
        if (mode === "status") return [column("Sr.", "_sr"), column("Project No", "ProjectNumber"), column("Order No", "OrderNo"), column("Order Date", "OrderDate"), column("Product Type", "ProductType"), column("Borrower Name", "BName"), column("Property Address", "PropertyAddress"), column("State", "STATE"), column("County", "County"), column("Status", "ProcessStatus"), column("Remark", "Remark")];
        return [column("Sr.", "_sr"), column("Code", "Code"), column("Project No", "ProjectNumber"), column("Process", "Process"), column("Order No", "ClientOrderNo"), column("Order Date", "OrderDate"), column("Product Type", "ProductType"), column("Process Status", "ProcessStatus"), column("Online / Offline", "OnOffLine"), column("Assigned Date", "AssignedDate"), column("TAT", "TAT")];
    }

    function renderReport(rows, values) {
        $.each(rows, function (index, row) { row._sr = index + 1; });
        if (!rows.length) { clearTable(); $("#summaryEmpty").html('<i class="fas fa-info-circle fa-2x mb-2"></i><br />No records found for the selected filters.').show(); $("#summaryGridHint").text("0 records"); return; }
        if (reportTable) { reportTable.destroy(); reportTable = null; }
        $("#summaryReportTable thead, #summaryReportTable tbody, #summaryReportTable tfoot").empty();
        $("#summaryEmpty").hide(); $("#summaryTableWrap").show();
        var columns = reportColumns(values);
        var hasTotals = $.grep(columns, function (item) { return item.sum; }).length > 0;
        if (hasTotals) $("#summaryReportTable").append("<tfoot><tr>" + $.map(columns, function () { return "<th></th>"; }).join("") + "</tr></tfoot>");
        reportTable = $("#summaryReportTable").DataTable({ data:rows, columns:columns, destroy:true, deferRender:true, pageLength:25, lengthMenu:[[25,50,100,-1],[25,50,100,"All"]], order:[], autoWidth:false, scrollX:true, dom:"<'row mb-2'<'col-sm-6'B><'col-sm-6'f>>rt<'row mt-2'<'col-sm-5'i><'col-sm-7'p>>", buttons:[{ extend:"excelHtml5", text:'<i class="fas fa-file-excel"></i> Excel', className:"btn btn-sm btn-success", title:"OST " + modes[mode].title }], language:{ emptyTable:"No records found" }, footerCallback:function(){ if(!hasTotals) return; var api=this.api(); $.each(columns,function(index,item){ if(index===0) $(api.column(index).footer()).html("Total"); else if(item.sum){ var total=api.column(index,{search:"applied"}).data().reduce(function(sum,value){ var number=parseFloat(String(value || 0).replace(/,/g,"")); return sum + (isNaN(number) ? 0 : number); },0); $(api.column(index).footer()).html(total.toLocaleString()); } }); } });
        $("#summaryGridHint").text(rows.length + (rows.length === 1 ? " record" : " records"));
    }

    function clearTable() {
        if (reportTable) { reportTable.destroy(); reportTable = null; }
        $("#summaryReportTable thead, #summaryReportTable tbody, #summaryReportTable tfoot").empty();
        $("#summaryTableWrap").hide();
        $("#summaryEmpty").html('<i class="far fa-chart-bar fa-2x mb-2"></i><br />No report has been loaded.').show();
        $("#summaryGridHint").text("Select filters and click Show Report.");
    }

    function openUserDetail(button) {
        var $button = $(button);
        if (!lastCriteria) return;
        loader(true);
        post("GetUserDetailReport", { fromDate:lastCriteria.fromDate, toDate:lastCriteria.toDate, type:$button.data("type"), userId:String($button.data("user")) }).done(function (rows) {
            $.each(rows, function (index, row) { row._sr = index + 1; });
            if (detailTable) { detailTable.destroy(); detailTable = null; }
            $("#summaryDetailTable thead, #summaryDetailTable tbody").empty();
            detailTable = $("#summaryDetailTable").DataTable({ data:rows, destroy:true, scrollX:true, pageLength:10, order:[], columns:[column("Sr.", "_sr"), column("Project Number", "ProjectNumber"), column("Order Number", "ClientOrderNo"), column("Order Date", "OrderDate"), column("Assigned Date", "AssignedDate"), column("Completion Date", "CompletionDate"), column("Status", "Status"), column("Remark", "Remark"), column("Attached Document", "Path", { render:function(data,type,row){ var path=text(data), name=path.split(/[/\\]/).pop(); if(type!=="display") return name; return path && row.AttachmentToken ? '<a class="sr-link" href="../Handler/SummaryReportDownload.ashx?token=' + encodeURIComponent(row.AttachmentToken) + '"><i class="fas fa-download"></i> ' + escapeHtml(name) + '</a>' : "-"; } })], dom:"<'row mb-2'<'col-sm-6'B><'col-sm-6'f>>rtip", buttons:[{extend:"excelHtml5", text:'<i class="fas fa-file-excel"></i> Excel', className:"btn btn-sm btn-success", title:"OST User Detail"}] });
            $("#summaryDetailTitle").text($button.data("code") + " - " + $button.data("type") + " Details");
            $("#summaryDetailModal").modal("show");
        }).fail(function(xhr){ showMessage(errorMessage(xhr,"Unable to load user details.")); }).always(function(){ loader(false); });
    }

    function resetFilters() {
        $("#summaryProject, #summaryStatus").val("");
        $("#summaryTemplate").empty().append('<option value="">Select Template</option>').prop("disabled", true);
        initializeDates(); clearTable(); showMessage("");
    }

    $(function () {
        if (!$("#summaryReportTable").length) return;
        initializeDates(); loadLists(); applyMode("current", true);
        $(document).on("click", ".sr-tab", function () { applyMode($(this).data("mode"), true); });
        $("#summaryProject").on("change", loadTemplates);
        $("#summaryShow").on("click", runReport);
        $("#summaryClear").on("click", resetFilters);
        $("#summaryReportTable").on("click", ".js-user-detail", function () { openUserDetail(this); });
    });
})(jQuery);
