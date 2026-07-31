var table_ProjectTracking_Report_html = "";
var prjTrack_OrderID = 0;
var prjTrack_StatusOrderID = 0;
var Search_ProjectTracking;
var table_track_attachment;
var ProjectTracking_ChangeStatusInfo = null;

function ProjectTracking_CanShowActions() {
    var employeeId = parseInt(window.ProjectTracking_CurrentEmployeeId, 10) || 0;
    return employeeId === 369 || employeeId === 375;
}

function ProjectTracking_ApplyActionVisibility() {
    $(".tracking-page")
        .toggleClass("tracking-actions-enabled", ProjectTracking_CanShowActions())
        .toggleClass("tracking-actions-disabled", !ProjectTracking_CanShowActions());
}

function ProjectTracking_InitPage() {
    ProjectTracking_ApplyActionVisibility();
    ProjectTracking_BindProject();
    ProjectTracking_BindReportTable([], "Project Tracking Report");
    ProjectTracking_BindAttachmentTable([], 0);
    ProjectTracking_BindChangeStatusEvents();
}

function blankForNull(s) {
    return s == null || s === "null" ? "" : s;
}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function ProjectTracking_PostJson(url, payload) {
    return $.ajax({
        type: "POST",
        url: url,
        data: JSON.stringify(payload || {}),
        dataType: "json",
        contentType: "application/json; charset=utf-8"
    }).then(function (response) {
        return ProjectTracking_ParseRows(response);
    });
}

function ProjectTracking_ParseRows(response) {
    var payload = response && typeof response.d !== "undefined" ? response.d : response;

    if (!payload) {
        return [];
    }

    if (typeof payload === "string") {
        try {
            return JSON.parse(payload);
        } catch (e) {
            return [];
        }
    }

    return payload;
}

function ProjectTracking_ShowLoader(show) {
    var $loader = $("#load1");

    if (!$loader.length) {
        return;
    }

    if (show) {
        $loader.css("display", "flex");
    } else {
        $loader.hide();
    }
}

function ProjectTracking_SetButtonBusy(selector, busy, busyText) {
    var $button = $(selector);

    if (!$button.length) {
        return;
    }

    if (busy) {
        if (!$button.data("original-html")) {
            $button.data("original-html", $button.html());
        }

        $button.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i><span>' + (busyText || "Loading") + '</span>');
    } else {
        $button.prop("disabled", false);
        if ($button.data("original-html")) {
            $button.html($button.data("original-html"));
        }
    }
}

function ProjectTracking_AjaxError(error, fallbackMessage) {
    var message = fallbackMessage || "Something went wrong.";

    if (error && error.responseJSON && error.responseJSON.Message) {
        message = error.responseJSON.Message;
    } else if (error && error.responseText) {
        message = error.responseText;
    }

    alert(message);
}

function ProjectTracking_EscapeHtml(value) {
    return String(blankForNull(value))
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}

function ProjectTracking_EscapeAttr(value) {
    return ProjectTracking_EscapeHtml(value).replace(/`/g, "&#96;");
}

function ProjectTracking_TextRenderer(data, type) {
    var value = blankForNull(data);

    if (type !== "display") {
        return value;
    }

    return value === "" ? '<span class="tracking-cell-muted">-</span>' : ProjectTracking_EscapeHtml(value);
}

function ProjectTracking_WrapRenderer(data, type) {
    var value = blankForNull(data);

    if (type !== "display") {
        return value;
    }

    return value === "" ? '<span class="tracking-cell-muted">-</span>' : '<span class="tracking-text-wrap">' + ProjectTracking_EscapeHtml(value) + '</span>';
}

function ProjectTracking_Lower(value) {
    return blankForNull(value).toLowerCase();
}

function ProjectTracking_ChipRenderer(data, type, state) {
    var value = blankForNull(data);

    if (type !== "display") {
        return value;
    }

    if (value === "") {
        return '<span class="tracking-cell-muted">-</span>';
    }

    return '<span class="tracking-chip tracking-chip-' + (state || "neutral") + '">' + ProjectTracking_EscapeHtml(value) + '</span>';
}

function ProjectTracking_StatusState(status) {
    var value = ProjectTracking_Lower(status);

    if (value === "cancel" || value === "cancelled") {
        return "danger";
    }

    if (value === "hold") {
        return "warning";
    }

    if (value === "dispatch" || value === "dispatched") {
        return "success";
    }

    if (value === "in-process") {
        return "info";
    }

    return "neutral";
}

function ProjectTracking_OnlineState(value) {
    var text = ProjectTracking_Lower(value);

    if (text.indexOf("offline") >= 0) {
        return "warning";
    }

    if (text.indexOf("online") >= 0) {
        return "info";
    }

    return "neutral";
}

function ProjectTracking_PriorityState(value) {
    return ProjectTracking_Lower(value) === "rush" ? "warning" : "neutral";
}

function ProjectTracking_NormalizeRows(rows) {
    return $.map(rows || [], function (row, index) {
        row._SrNo = index + 1;
        row._OrderId = blankForNull(row.OrderId || row.OrderID);
        row._StatusState = ProjectTracking_StatusState(row.ProcessStatus);
        row._OnlineState = ProjectTracking_OnlineState(row.OnOffLine);
        row._PriorityState = ProjectTracking_PriorityState(row.OrderPriority);
        return row;
    });
}

function ProjectTracking_BindProject() {
    var $project = $("#ProjectTracking_projectno");

    if (!$project.length) {
        return false;
    }

    $project.empty().append($("<option></option>").val("").text("Select"));

    return ProjectTracking_PostJson("ProjectTrackingReport.aspx/GetAllProjectNo").done(function (rows) {
        $.each(rows || [], function (_, row) {
            $project.append($("<option></option>").val(blankForNull(row.ProjectID)).text(blankForNull(row.ProjectName)));
        });
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load projects.");
    });
}

function ProjectTracking_GetCriteria() {
    var $project = $("#ProjectTracking_projectno");
    var projectValue = $project.val();
    var projectText = $project.find("option:selected").text();
    var fromDate = $("#ProjectTracking_FromDate").val();
    var toDate = $("#ProjectTracking_ToDate").val();

    if (!projectValue) {
        alert("Please select Project #.");
        return null;
    }

    if (!fromDate) {
        alert("Please select From Date.");
        return null;
    }

    if (!toDate) {
        alert("Please select To Date.");
        return null;
    }

    if (fromDate > toDate) {
        alert("From Date cannot be after To Date.");
        return null;
    }

    return {
        fromDate: fromDate,
        toDate: toDate,
        projectNo: projectText
    };
}

function ProjectTrackingg_btnShowDetails() {
    var criteria = ProjectTracking_GetCriteria();

    if (!criteria) {
        return false;
    }

    BindProjectTracking_Report(criteria.fromDate, criteria.toDate, criteria.projectNo);
    return false;
}

function ProjectTracking_ClearReport() {
    $("#ProjectTracking_projectno").val("");
    $("#ProjectTracking_FromDate").val("");
    $("#ProjectTracking_ToDate").val("");
    ProjectTracking_BindReportTable([], "Project Tracking Report");
    return false;
}

function ia_getloans(OrderId) {
    return prjTrack_EditOrder(OrderId);
}

function BindProjectTracking_Report(FromDateNew, ToDateNew, ProjectNoNew) {
    var title = "Project Tracking Report_" + blankForNull(ProjectNoNew) + " ~ " + blankForNull(FromDateNew) + " ~ " + blankForNull(ToDateNew);

    table_ProjectTracking_Report_html = "";
    ProjectTracking_ShowLoader(true);
    ProjectTracking_SetButtonBusy("#ProjectTracking_btnShow", true, "Loading");

    ProjectTracking_PostJson("ProjectTrackingReport.aspx/GetAllOrderDetails", {
        FromDate: FromDateNew,
        ToDate: ToDateNew,
        ProjectNo: ProjectNoNew
    }).done(function (rows) {
        ProjectTracking_BindReportTable(ProjectTracking_NormalizeRows(rows), title);
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load project tracking data.");
    }).always(function () {
        ProjectTracking_ShowLoader(false);
        ProjectTracking_SetButtonBusy("#ProjectTracking_btnShow", false);
    });

    return false;
}

function ProjectTracking_ActionRenderer(data, type, row, meta) {
    if (type !== "display" || !ProjectTracking_CanShowActions()) {
        return "";
    }

    var orderId = blankForNull(row._OrderId);
    var rowIndex = meta && typeof meta.row !== "undefined" ? meta.row : "";

    return '' +
        '<div class="tracking-action-buttons" role="group" aria-label="Order actions">' +
        '<button type="button" class="tracking-action-btn tracking-action-edit tracking-edit-order" data-order-id="' + ProjectTracking_EscapeAttr(orderId) + '" data-row-index="' + ProjectTracking_EscapeAttr(rowIndex) + '" title="Edit Order" aria-label="Edit Order">' +
        '<i class="fas fa-pen" aria-hidden="true"></i>' +
        '</button>' +
        '<button type="button" class="tracking-action-btn tracking-action-status tracking-change-status" data-order-id="' + ProjectTracking_EscapeAttr(orderId) + '" data-row-index="' + ProjectTracking_EscapeAttr(rowIndex) + '" title="Change Order Status" aria-label="Change Order Status">' +
        '<i class="fas fa-exchange-alt" aria-hidden="true"></i>' +
        '</button>' +
        '<button type="button" class="tracking-action-btn tracking-action-attachment tracking-show-attachment" data-order-id="' + ProjectTracking_EscapeAttr(orderId) + '" title="Show Attachment" aria-label="Show Attachment">' +
        '<i class="fas fa-paperclip" aria-hidden="true"></i>' +
        '</button>' +
        '</div>';
}

function ProjectTracking_ReportColumns() {
    return [
        {
            data: null,
            render: ProjectTracking_ActionRenderer,
            orderable: false,
            searchable: false,
            visible: ProjectTracking_CanShowActions(),
            width: "132px",
            className: "tracking-action-column"
        },
        { data: "_SrNo", width: "58px", className: "text-center" },
        { data: "_OrderId", visible: false },
        { data: "ProjectNumber", render: ProjectTracking_TextRenderer },
        { data: "OrderNo", render: ProjectTracking_TextRenderer },
        { data: "OrderDate", render: ProjectTracking_TextRenderer },
        { data: "OrderDateTime", render: ProjectTracking_TextRenderer },
        {
            data: "ProcessStatus",
            render: function (data, type, row) {
                return ProjectTracking_ChipRenderer(data, type, row._StatusState);
            }
        },
        { data: "ProductType", render: ProjectTracking_TextRenderer },
        { data: "BName", render: ProjectTracking_TextRenderer },
        { data: "TransactionType", render: ProjectTracking_TextRenderer },
        { data: "PropertyAddress", className: "tracking-text-wrap", render: ProjectTracking_WrapRenderer },
        { data: "STATE", render: ProjectTracking_TextRenderer },
        { data: "County", render: ProjectTracking_TextRenderer },
        {
            data: "OnOffLine",
            render: function (data, type, row) {
                return ProjectTracking_ChipRenderer(data, type, row._OnlineState);
            }
        },
        { data: "SearchBy", render: ProjectTracking_TextRenderer },
        { data: "Process", render: ProjectTracking_TextRenderer },
        { data: "SearchDate", render: ProjectTracking_TextRenderer },
        { data: "ReSearchBy", render: ProjectTracking_TextRenderer },
        { data: "Process1", render: ProjectTracking_TextRenderer },
        { data: "ReSearchDate", render: ProjectTracking_TextRenderer },
        { data: "AuditBy", render: ProjectTracking_TextRenderer },
        { data: "Process5", render: ProjectTracking_TextRenderer },
        { data: "AuditDate", render: ProjectTracking_TextRenderer },
        { data: "TaxBy", render: ProjectTracking_TextRenderer },
        { data: "Process6", render: ProjectTracking_TextRenderer },
        { data: "TaxDate", render: ProjectTracking_TextRenderer },
        { data: "TypingBy", render: ProjectTracking_TextRenderer },
        { data: "Process2", render: ProjectTracking_TextRenderer },
        { data: "TypingDate", render: ProjectTracking_TextRenderer },
        { data: "QABy", render: ProjectTracking_TextRenderer },
        { data: "Process3", render: ProjectTracking_TextRenderer },
        { data: "QADate", render: ProjectTracking_TextRenderer },
        { data: "DispBy", render: ProjectTracking_TextRenderer },
        { data: "Process4", render: ProjectTracking_TextRenderer },
        { data: "DispDate", render: ProjectTracking_TextRenderer },
        { data: "LegalDescription", className: "tracking-text-wrap", render: ProjectTracking_WrapRenderer },
        { data: "ClientIdNew", render: ProjectTracking_TextRenderer },
        { data: "CustomerType", render: ProjectTracking_TextRenderer },
        {
            data: "OrderPriority",
            render: function (data, type, row) {
                return ProjectTracking_ChipRenderer(data, type, row._PriorityState);
            }
        },
        { data: "APNNo", render: ProjectTracking_TextRenderer },
        { data: "Instruction", className: "tracking-text-wrap", render: ProjectTracking_WrapRenderer },
        { data: "Remark", className: "tracking-text-wrap", render: ProjectTracking_WrapRenderer }
    ];
}

function ProjectTracking_BindReportTable(rows, title) {
    var $table = $("#Search_ProjectTracking");

    if (!$table.length || !$.fn.dataTable) {
        return;
    }

    if ($.fn.dataTable.isDataTable($table[0])) {
        $table.DataTable().clear().destroy();
    }

    $table.find("tbody").empty();

    Search_ProjectTracking = $table.DataTable({
        data: rows || [],
        columns: ProjectTracking_ReportColumns(),
        dom: '<"tracking-toolbar"<"tracking-toolbar-left"B><"tracking-toolbar-right"f>>rt<"row align-items-center mt-2"<"col-sm-6"i><"col-sm-6"p>>',
        destroy: true,
        deferRender: true,
        scrollX: true,
        scrollCollapse: true,
        autoWidth: false,
        ordering: false,
        paging: true,
        pageLength: 10,
        lengthChange: false,
        processing: true,
        language: {
            emptyTable: "No tracking data available",
            search: "Search:",
            info: "Showing _START_ to _END_ of _TOTAL_ orders",
            infoEmpty: "Showing 0 orders"
        },
        columnDefs: [
            { targets: [1, 5, 7, 12, 13, 14, 39], className: "text-center" }
        ],
        rowCallback: function (row, data) {
            var status = ProjectTracking_Lower(data && data.ProcessStatus);
            $(row).removeClass("tracking-row-hold tracking-row-dispatch");

            if (status === "hold") {
                $(row).addClass("tracking-row-hold");
            } else if (status === "dispatch" || status === "dispatched") {
                $(row).addClass("tracking-row-dispatch");
            }
        },
        buttons: [
            {
                extend: "excelHtml5",
                title: title || "Project Tracking Report",
                text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                exportOptions: {
                    columns: [1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42],
                    stripHtml: true
                }
            }
        ],
        initComplete: function () {
            this.api().columns.adjust().draw(false);
        }
    });

    $table
        .off("click.projectTracking", ".tracking-edit-order")
        .on("click.projectTracking", ".tracking-edit-order", function () {
            prjTrack_EditOrder($(this).data("order-id"), $(this).data("row-index"));
        })
        .off("click.projectTrackingStatus", ".tracking-change-status")
        .on("click.projectTrackingStatus", ".tracking-change-status", function () {
            prjTrack_ChangeOrderStatus($(this).data("order-id"), $(this).data("row-index"));
        })
        .off("click.projectTrackingAttachment", ".tracking-show-attachment")
        .on("click.projectTrackingAttachment", ".tracking-show-attachment", function () {
            prjTrack_showAttachment($(this).data("order-id"));
        });
}

function ProjectTracking_BindChangeStatusEvents() {
    $(document)
        .off("change.projectTrackingStatusSelect", "#ChangeStatus_OrderStatus")
        .on("change.projectTrackingStatusSelect", "#ChangeStatus_OrderStatus", function () {
            ProjectTracking_ToggleChangeStatusFields();
        })
        .off("change.projectTrackingCancelDecision", "input[name='ChangeStatus_CancelDecision']")
        .on("change.projectTrackingCancelDecision", "input[name='ChangeStatus_CancelDecision']", function () {
            ProjectTracking_ToggleCancelReasonType();
        });
}

function ProjectTracking_FindReportRow(orderid, selected) {
    var rowData = null;

    if (Search_ProjectTracking && selected !== undefined && selected !== null && selected !== "") {
        rowData = Search_ProjectTracking.row(selected).data();
    }

    if (!rowData && Search_ProjectTracking) {
        Search_ProjectTracking.rows().every(function () {
            var row = this.data();
            if (String(row._OrderId) === String(orderid)) {
                rowData = row;
            }
        });
    }

    return rowData;
}

function prjTrack_ChangeOrderStatus(orderid, selected) {
    var rowData = ProjectTracking_FindReportRow(orderid, selected);
    var project = rowData ? blankForNull(rowData.ProjectNumber) : "";
    var orderNo = rowData ? blankForNull(rowData.OrderNo) : "";

    prjTrack_StatusOrderID = parseInt(orderid, 10) || 0;
    ProjectTracking_ResetChangeStatusModal();

    $("#searchChangeStatus_lbl").text("Change Order Status" + (project || orderNo ? " : " + project + " ~ " + orderNo : ""));
    $("#PrjTracking_ChangeOrderStatus").modal("show");
    ProjectTracking_LoadChangeStatusInfo(prjTrack_StatusOrderID);
    return false;
}

function ProjectTracking_ResetChangeStatusModal() {
    ProjectTracking_ChangeStatusInfo = null;
    $("#ChangeStatus_ProjectNumber,#ChangeStatus_OrderNumber,#ChangeStatus_CurrentStatus").text("-");
    $("#ChangeStatus_OrderStatus").empty().append($("<option></option>").val("").text("Select"));
    $("#ChangeStatus_ReallocateTo").empty().append($("<option></option>").val("").text("Select"));
    $("#ChangeStatus_ReallocateRemark,#ChangeStatus_CancelReason,#ChangeStatus_Remark").val("");
    $("#ChangeStatus_CancelType").val("Cancelled by Client");
    $("input[name='ChangeStatus_CancelDecision'][value='Approve']").prop("checked", true);
    $("#ChangeStatus_ReallocateSection,#ChangeStatus_CancelSection,#ChangeStatus_CommonSection").hide();
    $("#btnChangeOrderStatus").prop("disabled", true);
    ProjectTracking_SetChangeStatusButtonLabel("");
    ProjectTracking_SetButtonBusy("#btnChangeOrderStatus", false);
}

function ProjectTracking_LoadChangeStatusInfo(orderid) {
    if (!orderid) {
        return;
    }

    ProjectTracking_ShowLoader(true);

    ProjectTracking_PostJson("ProjectTrackingReport.aspx/GetChangeOrderStatusInfo", {
        OrderID: parseInt(orderid, 10) || 0
    }).done(function (info) {
        ProjectTracking_BindChangeStatusInfo(info || {});
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load change order status details.");
    }).always(function () {
        ProjectTracking_ShowLoader(false);
    });
}

function ProjectTracking_BindChangeStatusInfo(info) {
    ProjectTracking_ChangeStatusInfo = info || {};

    if (info.Message && info.Success === false) {
        alert(info.Message);
    }

    $("#ChangeStatus_ProjectNumber").text(blankForNull(info.ProjectNumber) || "-");
    $("#ChangeStatus_OrderNumber").text(blankForNull(info.OrderNumber) || "-");
    $("#ChangeStatus_CurrentStatus").text(blankForNull(info.ProcessStatus) || "-");

    ProjectTracking_BindStatusOptions(info.Statuses || []);
    ProjectTracking_BindReallocateUsers(info.Users || []);
    $("#btnChangeOrderStatus").prop("disabled", !(info.Statuses && info.Statuses.length));
    ProjectTracking_ToggleChangeStatusFields();
}

function ProjectTracking_BindStatusOptions(statuses) {
    var $ddl = $("#ChangeStatus_OrderStatus");
    $ddl.empty().append($("<option></option>").val("").text("Select"));

    $.each(statuses || [], function (_, item) {
        var value = blankForNull(item.Value || item.value);
        var text = blankForNull(item.Text || item.text || value);
        $ddl.append($("<option></option>").val(value).text(text));
    });
}

function ProjectTracking_BindReallocateUsers(users) {
    var $ddl = $("#ChangeStatus_ReallocateTo");
    $ddl.empty().append($("<option></option>").val("").text("Select"));

    $.each(users || [], function (_, item) {
        var value = blankForNull(item.EmployeeID || item.EmployeeId || item.Value);
        var text = blankForNull(item.DisplayName || item.Text || item.Code || value);
        $ddl.append($("<option></option>").val(value).text(text));
    });
}

function ProjectTracking_ToggleChangeStatusFields() {
    var action = $("#ChangeStatus_OrderStatus").val();
    $("#ChangeStatus_ReallocateSection,#ChangeStatus_CancelSection,#ChangeStatus_CommonSection").hide();
    ProjectTracking_SetChangeStatusButtonLabel(action);

    if (action === "Re-Allocate Order") {
        $("#ChangeStatus_ReallocateSection").show();
    } else if (action === "Cancel Order") {
        $("#ChangeStatus_CancelSection").show();
        ProjectTracking_ToggleCancelReasonType();
    } else if (action) {
        $("#ChangeStatus_RemarkLabel").text(action === "Re-Open Hold Order" ? "Remark" : "Remark");
        $("#ChangeStatus_CommonSection").show();
    }
}

function ProjectTracking_SetChangeStatusButtonLabel(action) {
    var $button = $("#btnChangeOrderStatus");
    var label = blankForNull(action) || "Submit";

    if (!$button.length) {
        return;
    }

    $button.removeData("original-html");
    $button.html('<i class="fas fa-save"></i><span>' + ProjectTracking_EscapeHtml(label) + '</span>');
}

function ProjectTracking_ToggleCancelReasonType() {
    var decision = $("input[name='ChangeStatus_CancelDecision']:checked").val();
    $("#ChangeStatus_CancelTypeWrap").toggle(decision !== "Reject");
}

function ProjectTracking_RequireChangeStatus(value, message, selector) {
    var normalized = $.trim(String(blankForNull(value)));

    if (normalized === "" || normalized === "0") {
        alert(message);
        if (selector) {
            $(selector).focus();
        }
        return false;
    }

    return true;
}

function prjTrack_SubmitChangeStatus() {
    var action = $("#ChangeStatus_OrderStatus").val();
    var remark = $.trim($("#ChangeStatus_Remark").val());
    var reallocateTo = parseInt($("#ChangeStatus_ReallocateTo").val(), 10) || 0;
    var reallocateRemark = $.trim($("#ChangeStatus_ReallocateRemark").val());
    var cancelReason = $.trim($("#ChangeStatus_CancelReason").val());
    var cancelDecision = $("input[name='ChangeStatus_CancelDecision']:checked").val() || "Approve";

    if (!ProjectTracking_RequireChangeStatus(prjTrack_StatusOrderID, "Order is not selected.")) return false;
    if (!ProjectTracking_RequireChangeStatus(action, "Please select change order status.", "#ChangeStatus_OrderStatus")) return false;

    if (action === "Re-Allocate Order") {
        if (!ProjectTracking_RequireChangeStatus(reallocateTo, "Please select user.", "#ChangeStatus_ReallocateTo")) return false;
        if (!ProjectTracking_RequireChangeStatus(reallocateRemark, "Please enter remark.", "#ChangeStatus_ReallocateRemark")) return false;
        remark = reallocateRemark;
    } else if (action === "Cancel Order") {
        if (!ProjectTracking_RequireChangeStatus(cancelReason, "Please enter reason.", "#ChangeStatus_CancelReason")) return false;
        remark = cancelReason;
    } else if (!ProjectTracking_RequireChangeStatus(remark, "Please enter remark.", "#ChangeStatus_Remark")) {
        return false;
    }

    ProjectTracking_SetButtonBusy("#btnChangeOrderStatus", true, "Saving");

    ProjectTracking_PostJson("ProjectTrackingReport.aspx/ChangeOrderStatus", {
        OrderID: prjTrack_StatusOrderID,
        StatusAction: action,
        ReallocateTo: reallocateTo,
        Remark: remark,
        CancelDecision: cancelDecision,
        CancelType: $("#ChangeStatus_CancelType").val()
    }).done(function (response) {
        response = response || {};

        if (response.Success) {
            alert(response.Message || "Order status changed successfully.");
            $("#PrjTracking_ChangeOrderStatus").modal("hide");
            ProjectTrackingg_btnShowDetails();
        } else {
            alert(response.Message || "Order status was not changed.");
        }
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to change order status.");
    }).always(function () {
        ProjectTracking_SetButtonBusy("#btnChangeOrderStatus", false);
    });

    return false;
}

function prjTrack_showAttachment(orderid) {
    $("#popUp_prjTrack_Attachment").modal("show");
    bindPrjTrackAttachment(orderid);
    return false;
}

function bindPrjTrackAttachment(orderid) {
    if (!orderid) {
        ProjectTracking_BindAttachmentTable([], 0);
        return false;
    }

    ProjectTracking_ShowLoader(true);

    ProjectTracking_PostJson("ProjectTrackingReport.aspx/GetOrderDetailsProcesswise", {
        OrderID: parseInt(orderid, 10) || 0
    }).done(function (rows) {
        ProjectTracking_BindAttachmentTable(rows || [], orderid);
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load attachments.");
    }).always(function () {
        ProjectTracking_ShowLoader(false);
    });

    return false;
}

function ProjectTracking_DownloadRenderer(kind) {
    return function (data, type, row) {
        if (type !== "display") {
            return "";
        }

        var processId = blankForNull(row.ProcessId);
        var orderId = blankForNull(row._AttachmentOrderId);

        if (!orderId || !processId) {
            return '<span class="tracking-cell-muted">-</span>';
        }

        var orderIds = encodeURIComponent(orderId + "," + kind + "," + processId);
        var url = "DownloadFiles.aspx?OrderIds=" + orderIds;
        return '<a class="tracking-download-link" href="' + url + '" title="Download"><i class="fas fa-download"></i></a>';
    };
}

function ProjectTracking_BindAttachmentTable(rows, orderid) {
    var $table = $("#table_track_attachment");

    if (!$table.length || !$.fn.dataTable) {
        return;
    }

    rows = $.map(rows || [], function (row) {
        row._AttachmentOrderId = orderid;
        return row;
    });

    if ($.fn.dataTable.isDataTable($table[0])) {
        $table.DataTable().clear().destroy();
    }

    table_track_attachment = $table.DataTable({
        data: rows,
        dom: "tip",
        destroy: true,
        scrollX: true,
        paging: true,
        pageLength: 8,
        autoWidth: false,
        processing: true,
        ordering: false,
        language: {
            emptyTable: "No attachments available"
        },
        columns: [
            { data: null, orderable: false, render: ProjectTracking_DownloadRenderer("C"), className: "text-center" },
            { data: null, orderable: false, render: ProjectTracking_DownloadRenderer("O"), className: "text-center" },
            { data: "ClientOrderNo", render: ProjectTracking_TextRenderer },
            { data: "Status", render: ProjectTracking_TextRenderer },
            { data: "Process", render: ProjectTracking_TextRenderer },
            { data: "Remark", className: "tracking-text-wrap", render: ProjectTracking_WrapRenderer },
            { data: "AddedBy", render: ProjectTracking_TextRenderer },
            { data: "AddedDate", render: ProjectTracking_TextRenderer }
        ],
        initComplete: function () {
            this.api().columns.adjust().draw(false);
        }
    });
}

function prjTrack_EditOrder(orderid, selected) {
    var rowData = null;

    if (Search_ProjectTracking && selected !== undefined && selected !== null && selected !== "") {
        rowData = Search_ProjectTracking.row(selected).data();
    }

    if (!rowData && Search_ProjectTracking) {
        Search_ProjectTracking.rows().every(function () {
            var row = this.data();
            if (String(row._OrderId) === String(orderid)) {
                rowData = row;
            }
        });
    }

    prjTrack_OrderID = parseInt(orderid, 10) || 0;

    var project = rowData ? blankForNull(rowData.ProjectNumber) : "";
    var orderNo = rowData ? blankForNull(rowData.OrderNo) : "";
    $("#searchEditOrder_lbl").text("Edit Order" + (project || orderNo ? " : " + project + " ~ " + orderNo : ""));
    $("#PrjTracking_EditOrder").modal("show");

    prjTracking_BindOrderDetails(prjTrack_OrderID);
    return false;
}

function prjTracking_BindOrderDetails(orderid) {
    ProjectTracking_ShowLoader(true);

    ProjectTracking_PostJson("OrderEntry.aspx/GetOrderByID", {
        OrderID: parseInt(orderid, 10) || 0
    }).done(function (rows) {
        if (!rows || rows.length === 0) {
            return;
        }

        var d = rows[0];

        $("#Edit_OrderDate").val(prj_Trackformatdate(d.OrderDateTime));
        $("#Edit_receiveddate").val(prj_Trackformatdate(d.ReceivedDate3));
        $("#Edit_ClientOrder").val(blankForNull(d.ClientOrderNo));
        $("#Edit_BorrowerName").val(blankForNull(d.BName));
        $("#Edit_PropertyAddress").val(blankForNull(d.PropertyAddress));
        $("#Edit_salesprice").val(blankForNull(d.SalesPurchaseAmount));
        $("#Edit_sellername").val(blankForNull(d.SellerName));
        $("#Edit_clientId").val(blankForNull(d.ClientIDNew || d.ClientIdNew));
        $("#Edit_pin").val(blankForNull(d.APNNo));
        $("#Edit_instruction").val(blankForNull(d.Instruction));
        $("#Edit_legaldescription").val(blankForNull(d.LegalDescription));
        $("#Edit_searcher").val(blankForNull(d.TaskAssignName));
        $("#lbl_searcher").text(blankForNull(d.TaskAssignedId));

        $("#Edit_orderpriority").val(blankForNull(d.OrderPriority));
        $("#Edit_expTAT").val(blankForNull(d.ExpectedTime));
        $("#Edit_onoffline").val(blankForNull(d.OnOffLine));
        $("#Edit_exhibit").val(blankForNull(d.Exhibit));
        $("#Edit_transaction").val(blankForNull(d.TransactionType));
        $("#Edit_customerType").val(blankForNull(d.CustomerType));

        Bind_Project(d.ProjectID);
        Bind_State(d.State || d.STATE);
        Bind_County(d.State || d.STATE, d.County);
        Bind_ProductType(d.ProjectNumber, d.ProductType);
        Bind_Template(d.ProjectID, d.OrderTemplateId);
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load order details.");
    }).always(function () {
        ProjectTracking_ShowLoader(false);
    });
}

function ProjectTracking_PopulateSelect(selector, rows, valueField, textField, selectedVal) {
    var $ddl = $(selector);

    if (!$ddl.length) {
        return;
    }

    $ddl.empty().append($("<option></option>").val("").text("Select"));

    $.each(rows || [], function (_, row) {
        var value = blankForNull(row[valueField]);
        var text = blankForNull(row[textField]);
        $ddl.append($("<option></option>").val(value).text(text));
    });

    if (selectedVal !== undefined && selectedVal !== null && selectedVal !== "") {
        $ddl.val($.trim(String(selectedVal)));
    }
}

function Bind_Project(selectedVal, callback) {
    return ProjectTracking_PostJson("OrderEntry.aspx/GetUserWiseProject").done(function (rows) {
        ProjectTracking_PopulateSelect("#Edit_projectno", rows, "ProjectID", "ProjectName", selectedVal);
        if (callback) callback($("#Edit_projectno").val());
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load edit projects.");
    });
}

function Bind_State(selectedVal, callback) {
    return ProjectTracking_PostJson("OrderEntry.aspx/GetAllState").done(function (rows) {
        ProjectTracking_PopulateSelect("#Edit_State", rows, "StateCode", "StateCode", selectedVal);
        if (callback) callback($("#Edit_State").val());
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load states.");
    });
}

function Bind_County(state, selectedVal, callback) {
    return ProjectTracking_PostJson("OrderEntry.aspx/GetCountyByState", {
        State: blankForNull(state)
    }).done(function (rows) {
        ProjectTracking_PopulateSelect("#Edit_County", rows, "County", "County", selectedVal);
        if (callback) callback($("#Edit_County").val());
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load counties.");
    });
}

function Bind_ProductType(ProjectNumber, selectedVal, callback) {
    return ProjectTracking_PostJson("OrderEntry.aspx/GetAllProductRelatedToProject", {
        ProjectNo: blankForNull(ProjectNumber)
    }).done(function (rows) {
        ProjectTracking_PopulateSelect("#Edit_Producttype", rows, "ProductType", "ProductType", selectedVal);
        if (callback) callback($("#Edit_Producttype").val());
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load product types.");
    });
}

function Bind_Template(ProjectID, selectedVal, callback) {
    return ProjectTracking_PostJson("OrderEntry.aspx/GetAllTemplateProject", {
        ProjectID: blankForNull(ProjectID)
    }).done(function (rows) {
        ProjectTracking_PopulateSelect("#Edit_template", rows, "TemplateId", "Template", selectedVal);
        if (callback) callback($("#Edit_template").val());
    }).fail(function (error) {
        ProjectTracking_AjaxError(error, "Unable to load templates.");
    });
}

function prjTrack_BindTemplate(Project) {
    var $project = $(Project || "#Edit_projectno");
    var projectId = $project.val();
    var projectNumber = $project.find("option:selected").text();

    Bind_Template(projectId);
    if (projectNumber && projectNumber !== "Select") {
        Bind_ProductType(projectNumber);
    }

    return false;
}

function prjTrack_BindCounty(State) {
    var state = $(State || "#Edit_State").val();
    Bind_County(state);
    return false;
}

function prj_Trackformatdate(prv_date) {
    var value = blankForNull(prv_date);

    if (!value) {
        return "";
    }

    var jsonDate = /\/Date\((\d+)\)\//.exec(value);
    var date = jsonDate ? new Date(parseInt(jsonDate[1], 10)) : new Date(value);

    if (isNaN(date.getTime())) {
        return "";
    }

    var day = String(date.getDate()).padStart(2, "0");
    var month = String(date.getMonth() + 1).padStart(2, "0");
    var year = date.getFullYear();

    return year + "-" + month + "-" + day;
}

function ProjectTracking_FieldValue(id) {
    return blankForNull($("#" + id).val());
}

function ProjectTracking_SelectValue(id) {
    return blankForNull($("#" + id).val());
}

function ProjectTracking_SelectText(id) {
    return blankForNull($("#" + id + " option:selected").text());
}

function ProjectTracking_Require(value, message, selector) {
    var normalized = blankForNull(value);

    if (normalized === "" || normalized === 0 || normalized === "0") {
        alert(message);
        $(selector).focus();
        return false;
    }

    return true;
}

function prjTrack_UpdateOrder() {
    var projectid = parseInt(ProjectTracking_SelectValue("Edit_projectno"), 10) || 0;
    var projectno = ProjectTracking_SelectText("Edit_projectno");
    var orderpriority = ProjectTracking_SelectValue("Edit_orderpriority");
    var expectedtat = ProjectTracking_SelectValue("Edit_expTAT");
    var onoffline = ProjectTracking_SelectValue("Edit_onoffline");
    var exhibit = ProjectTracking_SelectValue("Edit_exhibit");
    var transaction = ProjectTracking_SelectValue("Edit_transaction");
    var customertype = ProjectTracking_SelectValue("Edit_customerType");
    var state = ProjectTracking_SelectValue("Edit_State");
    var county = ProjectTracking_SelectValue("Edit_County");
    var template = parseInt(ProjectTracking_SelectValue("Edit_template"), 10) || 0;
    var producttype = ProjectTracking_SelectValue("Edit_Producttype");
    var searcher = parseInt($("#lbl_searcher").text(), 10) || 0;

    var orderdate = ProjectTracking_FieldValue("Edit_OrderDate");
    var receiveddate = ProjectTracking_FieldValue("Edit_receiveddate");
    var clientorderno = ProjectTracking_FieldValue("Edit_ClientOrder");
    var borrowername = ProjectTracking_FieldValue("Edit_BorrowerName");
    var propertyaddress = ProjectTracking_FieldValue("Edit_PropertyAddress");
    var salesprice = ProjectTracking_FieldValue("Edit_salesprice");
    var sellername = ProjectTracking_FieldValue("Edit_sellername");
    var clientid = ProjectTracking_FieldValue("Edit_clientId");
    var pinno = ProjectTracking_FieldValue("Edit_pin");
    var instruction = ProjectTracking_FieldValue("Edit_instruction");
    var legaldescription = ProjectTracking_FieldValue("Edit_legaldescription");

    if (!ProjectTracking_Require(orderdate, "Please enter order date.", "#Edit_OrderDate")) return false;
    if (!ProjectTracking_Require(receiveddate, "Please enter received date.", "#Edit_receiveddate")) return false;
    if (!ProjectTracking_Require(projectid, "Please select project #.", "#Edit_projectno")) return false;
    if (!ProjectTracking_Require(clientorderno, "Please enter client order no.", "#Edit_ClientOrder")) return false;
    if (!ProjectTracking_Require(borrowername, "Please enter Borrower Name.", "#Edit_BorrowerName")) return false;
    if (!ProjectTracking_Require(propertyaddress, "Please enter property address.", "#Edit_PropertyAddress")) return false;
    if (!ProjectTracking_Require(state, "Please select state.", "#Edit_State")) return false;
    if (!ProjectTracking_Require(county, "Please select county.", "#Edit_County")) return false;
    if (!ProjectTracking_Require(producttype, "Please select Product Type.", "#Edit_Producttype")) return false;
    if (!ProjectTracking_Require(expectedtat, "Please select expected TAT.", "#Edit_expTAT")) return false;
    if (!ProjectTracking_Require(onoffline, "Please select On/Offline.", "#Edit_onoffline")) return false;
    if (!ProjectTracking_Require(transaction, "Please select Transaction.", "#Edit_transaction")) return false;
    if (!ProjectTracking_Require(clientid, "Please enter Client ID.", "#Edit_clientId")) return false;
    if (!ProjectTracking_Require(customertype, "Please select Customer Type.", "#Edit_customerType")) return false;

    if (!window.PageMethods || typeof PageMethods.InsertOrder !== "function") {
        alert("Page method is not available. Please reload the page.");
        return false;
    }

    ProjectTracking_SetButtonBusy("#btnStep5", true, "Updating");

    PageMethods.InsertOrder(
        prjTrack_OrderID, projectid, projectno, orderpriority, expectedtat, onoffline, exhibit,
        transaction, customertype, state, county, searcher, template, producttype,
        orderdate, receiveddate, clientorderno, borrowername.trim(), propertyaddress.trim(),
        salesprice, sellername.trim(), clientid, pinno.trim(), instruction.trim(), legaldescription.trim(),
        OnSuccess_prjTrackUpdateOrder, OnError_prjTrackUpdateOrder
    );

    return false;
}

function OnSuccess_prjTrackUpdateOrder(result) {
    ProjectTracking_SetButtonBusy("#btnStep5", false);

    if (result > 0) {
        prjTrack_OrderID = 0;
        alert("Data entered successfully.");
        $("#PrjTracking_EditOrder").modal("hide");
        ProjectTrackingg_btnShowDetails();
    } else if (result == -1) {
        alert("Order already exists.");
    } else {
        alert("Error saving order.");
    }
}

function OnError_prjTrackUpdateOrder(error) {
    ProjectTracking_SetButtonBusy("#btnStep5", false);
    ProjectTracking_AjaxError(error, "Error saving order.");
    return false;
}
