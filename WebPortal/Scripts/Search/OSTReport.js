var OSTReport_html = "";
var InvoiceID;
var table_OSTReport;

function OSTReport_InitPage() {
    OSTReport_BindProject();
    OSTReport_BindEmptyTable();
}

function blankForNull(s) {
    return s == null || s === "null" ? "" : s;
}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function OSTReport_PostJson(methodName, payload) {
    return $.ajax({
        type: "POST",
        url: "OSTReport.aspx/" + methodName,
        data: JSON.stringify(payload || {}),
        dataType: "json",
        contentType: "application/json; charset=utf-8"
    }).then(function (response) {
        return OSTReport_ParseRows(response);
    });
}

function OSTReport_ParseRows(response) {
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

function OSTReport_ShowLoader(show) {
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

function OSTReport_SetButtonBusy(selector, busy, busyText) {
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

function OSTReport_Alert(message) {
    alert(message);
}

function OSTReport_AjaxError(error, fallbackMessage) {
    var message = fallbackMessage || "Unable to load report data.";

    if (error && error.responseJSON && error.responseJSON.Message) {
        message = error.responseJSON.Message;
    } else if (error && error.responseText) {
        message = error.responseText;
    }

    OSTReport_Alert(message);
}

function OSTReport_EscapeHtml(value) {
    return String(blankForNull(value))
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}

function OSTReport_TextRenderer(data, type) {
    var value = blankForNull(data);

    if (type !== "display") {
        return value;
    }

    return value === "" ? '<span class="ost-cell-muted">-</span>' : OSTReport_EscapeHtml(value);
}

function OSTReport_WrapRenderer(data, type) {
    var value = blankForNull(data);

    if (type !== "display") {
        return value;
    }

    return value === "" ? '<span class="ost-cell-muted">-</span>' : '<span class="ost-text-wrap">' + OSTReport_EscapeHtml(value) + '</span>';
}

function OSTReport_ChipRenderer(data, type, state) {
    var value = blankForNull(data);
    var chipState = state || "neutral";

    if (type !== "display") {
        return value;
    }

    if (value === "") {
        return '<span class="ost-cell-muted">-</span>';
    }

    return '<span class="ost-chip ost-chip-' + chipState + '">' + OSTReport_EscapeHtml(value) + '</span>';
}

function OSTReport_Lower(value) {
    return blankForNull(value).toLowerCase();
}

function OSTReport_IsBlank(value) {
    return blankForNull(value) === "";
}

function OSTReport_StatusState(status) {
    var value = OSTReport_Lower(status);

    if (value === "cancel") {
        return "danger";
    }

    if (value === "hold") {
        return "warning";
    }

    if (value === "dispatch") {
        return "success";
    }

    if (value === "in-process") {
        return "info";
    }

    return "neutral";
}

function OSTReport_OnlineState(value) {
    var text = OSTReport_Lower(value);

    if (text === "offline" || text === "online-offline") {
        return "warning";
    }

    return "neutral";
}

function OSTReport_PriorityState(value) {
    return OSTReport_Lower(value) === "rush" ? "priority" : "neutral";
}

function OSTReport_WorkState(status, value, kind, row) {
    var state = OSTReport_StatusState(status);
    var processStatus = OSTReport_Lower(status);
    var text = blankForNull(value);
    var missing = OSTReport_IsBlank(text);

    if (processStatus === "cancel") {
        return { text: "X", state: "danger" };
    }

    if (kind === "dispatch") {
        if (missing && processStatus !== "dispatch") {
            return { text: "NA", state: "info" };
        }

        if (missing && processStatus === "dispatch") {
            return { text: "X", state: "success" };
        }

        if (processStatus === "hold") {
            return { text: "X", state: "warning" };
        }

        return { text: text, state: blankForNull(row.DispDate) !== "" ? "success" : "neutral" };
    }

    if (missing && processStatus !== "dispatch") {
        return { text: "X", state: "info" };
    }

    if (missing && processStatus === "dispatch") {
        return { text: "X", state: "success" };
    }

    if (kind === "search" && processStatus === "in-process") {
        return { text: text, state: "info" };
    }

    if (processStatus === "hold") {
        return { text: text, state: "warning" };
    }

    if (state === "success" || kind === "de" || kind === "qa" || kind === "audit" || kind === "research") {
        return { text: text, state: "success" };
    }

    return { text: text, state: state };
}

function OSTReport_NormalizeRows(rows) {
    return $.map(rows || [], function (row, index) {
        var search = OSTReport_WorkState(row.ProcessStatus, row.SearchBy, "search", row);
        var research = OSTReport_WorkState(row.ProcessStatus, row.ReSearchBy, "research", row);
        var typing = OSTReport_WorkState(row.ProcessStatus, row.TypingBy, "de", row);
        var qa = OSTReport_WorkState(row.ProcessStatus, row.QABy, "qa", row);
        var audit = OSTReport_WorkState(row.ProcessStatus, row.AuditBy, "audit", row);
        var dispatch = OSTReport_WorkState(row.ProcessStatus, row.DispBy, "dispatch", row);

        row._SrNo = index + 1;
        row._StatusState = OSTReport_StatusState(row.ProcessStatus);
        row._OnlineState = OSTReport_OnlineState(row.OnOffLine);
        row._PriorityState = OSTReport_PriorityState(row.OrderPriority);
        row._SearchText = search.text;
        row._SearchState = search.state;
        row._ResearchText = research.text;
        row._ResearchState = research.state;
        row._TypingText = typing.text;
        row._TypingState = typing.state;
        row._QAText = qa.text;
        row._QAState = qa.state;
        row._AuditText = audit.text;
        row._AuditState = audit.state;
        row._DispatchText = dispatch.text;
        row._DispatchState = dispatch.state;

        return row;
    });
}

function OSTReport_BindProject() {
    var $project = $("#OSTReport_projectno");

    if (!$project.length) {
        return false;
    }

    $project.empty().append($("<option></option>").val("").text("Select"));

    return OSTReport_PostJson("GetAllProjectNo").done(function (rows) {
        $.each(rows || [], function (_, row) {
            $project.append($("<option></option>").val(blankForNull(row.ProjectID)).text(blankForNull(row.ProjectName)));
        });
    }).fail(function (error) {
        OSTReport_AjaxError(error, "Unable to load projects.");
    });
}

function OSTReport_GetCriteria() {
    var $project = $("#OSTReport_projectno");
    var fromDate = $("#OSTReportFromDate").val();
    var toDate = $("#OSTReportToDate").val();
    var projectValue = $project.val();
    var projectText = $project.find("option:selected").text();

    if (!projectValue) {
        OSTReport_Alert("Please select Project #.");
        return null;
    }

    if (!fromDate) {
        OSTReport_Alert("Please select From Date.");
        return null;
    }

    if (!toDate) {
        OSTReport_Alert("Please select To Date.");
        return null;
    }

    if (fromDate > toDate) {
        OSTReport_Alert("From Date cannot be after To Date.");
        return null;
    }

    return {
        fromDate: fromDate,
        toDate: toDate,
        projectNo: projectText
    };
}

function OSTReportShow() {
    var criteria = OSTReport_GetCriteria();

    if (!criteria) {
        return false;
    }

    var title = "OST Report_" + criteria.projectNo + " ~ " + criteria.fromDate + " ~ " + criteria.toDate;

    OSTReport_ShowLoader(true);
    OSTReport_SetButtonBusy("#OSTReport_Show", true, "Loading");

    OSTReport_PostJson("BindGrid", {
        FromDate: criteria.fromDate,
        ToDate: criteria.toDate,
        ProjectNo: criteria.projectNo
    }).done(function (rows) {
        OSTReport_BindTable(OSTReport_NormalizeRows(rows), title);
    }).fail(function (error) {
        OSTReport_AjaxError(error, "Unable to load report data.");
    }).always(function () {
        OSTReport_ShowLoader(false);
        OSTReport_SetButtonBusy("#OSTReport_Show", false);
    });

    return false;
}

function OSTReport_BindEmptyTable() {
    if ($("#table_OSTReport").length && $.fn.dataTable) {
        OSTReport_BindTable([], "OST Report");
    }
}

function OSTReport_TableColumns() {
    return [
        { data: "_SrNo", className: "text-center", width: "56px" },
        { data: "ProjectNumber", render: OSTReport_TextRenderer },
        { data: "ClientOrderNo", render: OSTReport_TextRenderer },
        { data: "OrderDate", render: OSTReport_TextRenderer },
        {
            data: "OnOffLine",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._OnlineState);
            }
        },
        { data: "ProductType", render: OSTReport_TextRenderer },
        {
            data: "OrderPriority",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._PriorityState);
            }
        },
        { data: "STATE", render: OSTReport_TextRenderer },
        { data: "County", render: OSTReport_TextRenderer },
        {
            data: "ProcessStatus",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._StatusState);
            }
        },
        {
            data: "_SearchText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._SearchState);
            }
        },
        {
            data: "_ResearchText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._ResearchState);
            }
        },
        {
            data: "_TypingText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._TypingState);
            }
        },
        {
            data: "_QAText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._QAState);
            }
        },
        {
            data: "_AuditText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._AuditState);
            }
        },
        {
            data: "_DispatchText",
            render: function (data, type, row) {
                return OSTReport_ChipRenderer(data, type, row._DispatchState);
            }
        },
        { data: "Remark", className: "ost-text-wrap", render: OSTReport_WrapRenderer },
        { data: "ClientIdNew", render: OSTReport_TextRenderer },
        { data: "CustomerType", render: OSTReport_TextRenderer },
        { data: "LegalDescription", className: "ost-text-wrap", render: OSTReport_WrapRenderer },
        { data: "Instruction", className: "ost-text-wrap", render: OSTReport_WrapRenderer },
        { data: "APNNo", render: OSTReport_TextRenderer },
        { data: "TransactionType", render: OSTReport_TextRenderer }
    ];
}

function OSTReport_BindTable(rows, title) {
    var $table = $("#table_OSTReport");

    if (!$table.length || !$.fn.dataTable) {
        return;
    }

    if ($.fn.dataTable.isDataTable($table[0])) {
        $table.DataTable().clear().destroy();
    }

    $table.find("tbody").empty();
    OSTReport_ClearFilterOptions();

    table_OSTReport = $table.DataTable({
        data: rows || [],
        columns: OSTReport_TableColumns(),
        dom: '<"ost-toolbar"<"ost-toolbar-left"B><"ost-toolbar-right"f>>rt<"row align-items-center mt-2"<"col-sm-6"i><"col-sm-6"p>>',
        destroy: true,
        deferRender: true,
        scrollX: true,
        scrollCollapse: true,
        autoWidth: false,
        ordering: false,
        paging: true,
        pageLength: 25,
        lengthChange: false,
        processing: true,
        orderCellsTop: true,
        language: {
            emptyTable: "No report data available",
            search: "Search:",
            info: "Showing _START_ to _END_ of _TOTAL_ orders",
            infoEmpty: "Showing 0 orders"
        },
        columnDefs: [
            { targets: [0, 3, 4, 6, 9, 10, 11, 12, 13, 14, 15], className: "text-center" }
        ],
        buttons: [
            {
                extend: "excelHtml5",
                title: title || "OST Report",
                text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                exportOptions: {
                    columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22],
                    stripHtml: true,
                    format: {
                        header: function (data, columnIdx) {
                            return $("#table_OSTReport thead tr:eq(0) th").eq(columnIdx).text();
                        }
                    }
                }
            }
        ],
        initComplete: function () {
            var api = this.api();

            populateDropdown(api, 9, "#filterStatus");
            populateDropdown(api, 10, "#filterSearch");
            populateDropdown(api, 11, "#filterResearch");
            OSTReport_BindColumnFilters(api);
            api.columns.adjust().draw(false);
        }
    });
}

function OSTReport_ClearFilterOptions() {
    $("#filterStatus, #filterSearch, #filterResearch").each(function () {
        $(this).empty().append($("<option></option>").val("").text("All"));
    });
}

function OSTReport_BindColumnFilters(api) {
    $("#filterStatus").off("change.ostReport").on("change.ostReport", function () {
        OSTReport_ApplyColumnFilter(api, 9, this.value);
    });

    $("#filterSearch").off("change.ostReport").on("change.ostReport", function () {
        OSTReport_ApplyColumnFilter(api, 10, this.value);
    });

    $("#filterResearch").off("change.ostReport").on("change.ostReport", function () {
        OSTReport_ApplyColumnFilter(api, 11, this.value);
    });
}

function OSTReport_ApplyColumnFilter(api, columnIndex, value) {
    var query = "";

    if (value) {
        query = "^" + $.fn.dataTable.util.escapeRegex(value) + "$";
    }

    api.column(columnIndex).search(query, true, false).draw();
}

function OSTReport_ClearFilters() {
    $("#OSTReport_projectno").val("");
    $("#OSTReportFromDate").val("");
    $("#OSTReportToDate").val("");

    if (table_OSTReport) {
        table_OSTReport.search("");
        table_OSTReport.columns().search("");
    }

    OSTReport_BindEmptyTable();
    return false;
}

function createColumnFilter(api, columnIndex) {
    var filterRow = $("#table_OSTReport thead tr:eq(1)");
    var th = filterRow.find("th:eq(" + columnIndex + ")");

    if (th.find("select").length) {
        return;
    }

    var select = $('<select class="column-filter"><option value="">All</option></select>').appendTo(th.empty());

    populateDropdown(api, columnIndex, select);
    select.on("change", function () {
        OSTReport_ApplyColumnFilter(api, columnIndex, this.value);
    });
}

function populateDropdown(api, columnIndex, selector) {
    var select = $(selector);

    if (!select.length) {
        return;
    }

    select.find("option:not(:first)").remove();

    api.column(columnIndex).data().unique().sort().each(function (value) {
        value = blankForNull(value);

        if (value) {
            select.append($("<option></option>").val(value).text(value));
        }
    });
}

function colorColumn(colIndex, color) {
    $("#table_OSTReport tbody tr").each(function () {
        var cell = this.cells[colIndex];
        if (cell) {
            cell.style.backgroundColor = color;
            cell.style.color = "#fff";
        }
    });
}
