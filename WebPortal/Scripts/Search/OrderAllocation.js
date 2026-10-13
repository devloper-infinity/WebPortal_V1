var OrderAllocation_table;
var OrderAllocationLoan_table;
var InvoiceID;
var product_type = "";
var project_id = 0;
var project_name = "";
var process_id = 0;
var process_name = "";
var selectedOrderMap = {};
var allocationRefreshTimer;
var ORDER_ALLOCATION_USER_ID = 235;

function OrderAllocation_InitPage() {
    if (!$("#OrdreAllocation_projectno").length) {
        return;
    }

    orderAllocationPopulateSelect("#OrdreAllocation_process", [], "Processid", "ProcessName");
    OrderAllocation_BindProject();

    if (allocationRefreshTimer) {
        clearInterval(allocationRefreshTimer);
    }

    allocationRefreshTimer = setInterval(function () {
        window.location.reload();
    }, 300000);
}

function blankForNull(s) {
    return s == null || s === "null" ? "" : s;
}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function orderAllocationPostJson(methodName, payload) {
    return $.ajax({
        type: "POST",
        url: "OrderAllocation.aspx/" + methodName,
        data: JSON.stringify(payload || {}),
        dataType: "json",
        contentType: "application/json; charset=utf-8"
    }).then(function (response) {
        return orderAllocationParseRows(response);
    });
}

function orderAllocationParseRows(response) {
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

function orderAllocationPopulateSelect(selector, rows, valueField, textField, selectedValue) {
    var $select = $(selector);

    if (!$select.length) {
        return;
    }

    $select.empty().append($("<option></option>").val("").text("Select"));

    $.each(rows || [], function (_, row) {
        var value = row[valueField];
        var text = row[textField];
        $select.append($("<option></option>").val(value == null ? "" : value).text(text == null ? "" : text));
    });

    if (selectedValue !== undefined && selectedValue !== null) {
        $select.val(String(selectedValue));
    }
}

function orderAllocationShowLoader(show) {
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

function orderAllocationAlert(icon, title, text, callback) {
    if (window.Swal && typeof Swal.fire === "function") {
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            zIndex: 999999
        }).then(function () {
            if (typeof callback === "function") {
                callback();
            }
        });
        return;
    }

    alert(text || title);

    if (typeof callback === "function") {
        callback();
    }
}

function orderAllocationAjaxError(error, fallbackMessage) {
    var message = fallbackMessage || "Something went wrong. Please contact administrator.";

    if (error) {
        if (typeof error.get_message === "function") {
            message = error.get_message();
        } else if (error.responseJSON && error.responseJSON.Message) {
            message = error.responseJSON.Message;
        } else if (error.responseText) {
            message = error.responseText;
        }
    }

    orderAllocationAlert("error", "Error", message);
}

function orderAllocationSetButtonBusy(selector, busy, busyText) {
    var $button = $(selector);

    if (!$button.length) {
        return;
    }

    if (busy) {
        if (!$button.data("original-html")) {
            $button.data("original-html", $button.html());
        }

        $button.prop("disabled", true).html('<i class="fas fa-spinner fa-spin"></i><span>' + busyText + "</span>");
        return;
    }

    $button.prop("disabled", false);

    if ($button.data("original-html")) {
        $button.html($button.data("original-html"));
    }
}

function orderAllocationSafeText(value) {
    return $("<div></div>").text(blankForNull(value)).html();
}

function orderAllocationDisplayRenderer(data, type) {
    if (type === "display") {
        return orderAllocationSafeText(data);
    }

    return blankForNull(data);
}

function orderAllocationWrapRenderer(data, type) {
    if (type !== "display") {
        return blankForNull(data);
    }

    return '<div class="text-wrap-cell">' + orderAllocationSafeText(data) + "</div>";
}

function orderAllocationCountRenderer(data, type) {
    if (type !== "display") {
        return blankForNull(data);
    }

    return '<span class="allocation-count-pill">' + orderAllocationSafeText(data) + "</span>";
}

function orderAllocationToInt(value) {
    var parsed = parseInt(value, 10);
    return isNaN(parsed) ? 0 : parsed;
}

function orderAllocationSelectedOption(id) {
    var element = document.getElementById(id);

    if (!element || !element.options || element.selectedIndex < 0) {
        return { value: "", text: "" };
    }

    return {
        value: $.trim(element.options[element.selectedIndex].value),
        text: $.trim(element.options[element.selectedIndex].text)
    };
}

function orderAllocationPreviousProcessId(processId) {
    var id = orderAllocationToInt(processId);
    return id <= 1 ? 1 : id - 1;
}

function orderAllocationDataTableDom(includeButtons) {
    return includeButtons
        ? "<'allocation-toolbar'<'allocation-table-filter'f><'allocation-table-buttons'B>>rt<'row align-items-center'<'col-md-5'i><'col-md-7'p>>"
        : "<'allocation-toolbar'<'allocation-table-filter'f>>rt<'row align-items-center'<'col-md-5'i><'col-md-7'p>>";
}

function orderAllocationDefaultTableOptions(data, columns, extraOptions) {
    var hasButtons = $.fn.dataTable && $.fn.dataTable.Buttons;
    var options = $.extend(true, {
        dom: orderAllocationDataTableDom(hasButtons),
        data: data || [],
        columns: columns || [],
        destroy: true,
        scrollX: true,
        autoWidth: false,
        paging: true,
        pageLength: 10,
        lengthChange: false,
        ordering: false,
        processing: true,
        serverSide: false,
        responsive: false,
        language: {
            search: "Search:",
            emptyTable: "No records found.",
            zeroRecords: "No matching records found."
        }
    }, extraOptions || {});

    if (hasButtons && !options.buttons) {
        options.buttons = [
            {
                extend: "excelHtml5",
                text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                className: "btn btn-sm"
            }
        ];
    }

    return options;
}

function OrderAllocation_BindProject(selectedProject) {
    orderAllocationPopulateSelect("#OrdreAllocation_projectno", [], "ProjectID", "ProjectName");

    return orderAllocationPostJson("GetAllProjectNo").done(function (rows) {
        orderAllocationPopulateSelect("#OrdreAllocation_projectno", rows, "ProjectID", "ProjectName", selectedProject);
    }).fail(function (error) {
        orderAllocationAjaxError(error, "Unable to load projects.");
    });
}

function core_orderAllocation_BindProcess(Project) {
    return orderAllocation_BindProcess(Project);
}

function orderAllocation_BindProcess(Project) {
    var projectId = Project && Project.value ? Project.value : orderAllocationSelectedOption("OrdreAllocation_projectno").value;

    orderAllocationPopulateSelect("#OrdreAllocation_process", [], "Processid", "ProcessName");
    $("#OrdreAllocation_Date").val("");

    if (OrderAllocation_table) {
        OrderAllocation_table.clear().draw();
    }

    if (!projectId) {
        return false;
    }

    orderAllocationShowLoader(true);

    orderAllocationPostJson("GetProjectProcess", { ProjectId: projectId }).done(function (rows) {
        orderAllocationPopulateSelect("#OrdreAllocation_process", rows, "Processid", "ProcessName");
    }).fail(function (error) {
        orderAllocationAjaxError(error, "Unable to load processes.");
    }).always(function () {
        orderAllocationShowLoader(false);
    });

    return false;
}

function orderAllocationSummary() {
    var project = orderAllocationSelectedOption("OrdreAllocation_projectno");
    var process = orderAllocationSelectedOption("OrdreAllocation_process");
    var previousProcessId = orderAllocationPreviousProcessId(process.value);

    project_id = orderAllocationToInt(project.value);
    project_name = project.text;
    process_id = orderAllocationToInt(process.value);
    process_name = process.text;

    if (!project_id) {
        orderAllocationAlert("warning", "Required Field", "Please select Project.");
        $("#OrdreAllocation_projectno").focus();
        return false;
    }

    if (!process_id) {
        orderAllocationAlert("warning", "Required Field", "Please select Process.");
        $("#OrdreAllocation_process").focus();
        return false;
    }

    orderAllocationShowLoader(true);
    orderAllocationSetButtonBusy("#OrdreAllocation_btnRefresh", true, "Loading");

    orderAllocationPostJson("OrderSummary", {
        ProjectNumber: project.text,
        TaskProcessid: process_id,
        UserId: ORDER_ALLOCATION_USER_ID,
        PrevProcessId: previousProcessId
    }).done(function (rows) {
        $("#OrdreAllocation_Date").val(rows && rows.length ? blankForNull(rows[0].OrderDate) : "");
        orderAllocationBindSummaryTable(rows || []);
    }).fail(function (error) {
        orderAllocationAjaxError(error, "Unable to load allocation summary.");
    }).always(function () {
        orderAllocationSetButtonBusy("#OrdreAllocation_btnRefresh", false);
        orderAllocationShowLoader(false);
    });

    return false;
}

function orderAllocationBindSummaryTable(rows) {
    var $table = $("#table_OrderAllocation");

    if ($.fn.DataTable.isDataTable($table)) {
        $table.DataTable().clear().destroy();
        $table.find("tbody").empty();
    }

    OrderAllocation_table = $table.DataTable(orderAllocationDefaultTableOptions(rows, [
        {
            data: null,
            className: "text-center",
            orderable: false,
            render: function (data, type, row) {
                if (type !== "display") {
                    return "";
                }

                return '<button type="button" class="btn btn-sm btn-outline-primary allocation-icon-btn allocation-get-loans" title="Get Loans"'
                    + ' data-order-date="' + orderAllocationSafeText(row.OrderDate) + '"'
                    + ' data-project-number="' + orderAllocationSafeText(row.ProjectNumber) + '"'
                    + ' data-product-type="' + orderAllocationSafeText(row.ProductType) + '">'
                    + '<i class="fas fa-search"></i></button>';
            }
        },
        {
            data: null,
            className: "text-center",
            render: function (data, type, row, meta) {
                return meta.row + 1;
            }
        },
        { data: "OrderDate", render: orderAllocationDisplayRenderer },
        { data: "ProjectNumber", render: orderAllocationDisplayRenderer },
        { data: "ProductType", render: orderAllocationDisplayRenderer },
        { data: "Count", className: "text-center", render: orderAllocationCountRenderer }
    ], {
        buttons: [
            {
                extend: "excelHtml5",
                title: "Order Allocation Summary",
                text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                className: "btn btn-sm"
            }
        ]
    }));

    $table.find("tbody")
        .off("click.orderAllocation", ".allocation-get-loans")
        .on("click.orderAllocation", ".allocation-get-loans", function () {
            return showLoansToAllocate(
                $(this).attr("data-order-date"),
                $(this).attr("data-project-number"),
                $(this).attr("data-product-type")
            );
        });
}

function showLoansToAllocate(order_date, prj_no, prodType) {
    product_type = prodType;
    selectedOrderMap = {};
    $("#chkAll_Order").prop("checked", false);
    $("#invApp_ViewLoan").text("Loan Details : " + prj_no + " - " + prodType);
    $("#popUpViewLoanDetails").modal("show");

    BindViewLoanDetails(order_date, prj_no, prodType);
    return false;
}

function BindViewLoanDetails(OrderDate, ProjectNo, ProductType) {
    var process = orderAllocationSelectedOption("OrdreAllocation_process");
    var processId = orderAllocationToInt(process.value);
    var previousProcessId = orderAllocationPreviousProcessId(processId);

    if (!processId) {
        orderAllocationAlert("warning", "Required Field", "Please select Process.");
        return false;
    }

    orderAllocationShowLoader(true);

    orderAllocationPostJson("GetAllOrderbyProcessNew", {
        ProcessId: processId,
        UserId: ORDER_ALLOCATION_USER_ID,
        ProjectNumber: ProjectNo,
        prevProcessId: previousProcessId,
        ProductType: ProductType,
        OrderDate: OrderDate
    }).done(function (rows) {
        orderAllocationBindLoanTable(rows || [], ProjectNo, ProductType);
    }).fail(function (error) {
        orderAllocationAjaxError(error, "Unable to load loan details.");
    }).always(function () {
        orderAllocationShowLoader(false);
    });

    return false;
}

function orderAllocationBindLoanTable(rows, projectNo, productType) {
    var $table = $("#table_viewloanDetails");
    var excelTitle = "Loan Details : " + projectNo + " - " + productType;

    if ($.fn.DataTable.isDataTable($table)) {
        $table.DataTable().clear().destroy();
        $table.find("tbody").empty();
    }

    OrderAllocationLoan_table = $table.DataTable(orderAllocationDefaultTableOptions(rows, [
        {
            data: null,
            className: "text-center",
            orderable: false,
            render: function (data, type, row) {
                var orderId = blankForNull(row.OrderID);

                if (type !== "display") {
                    return orderId;
                }

                return '<input type="checkbox" class="row-checkbox order-checkbox" id="chkInd_' + orderAllocationSafeText(orderId) + '" value="' + orderAllocationSafeText(orderId) + '"/>';
            }
        },
        { data: "ClientOrderNo", render: orderAllocationDisplayRenderer },
        { data: "OnOffLine", render: orderAllocationDisplayRenderer },
        { data: "OrderDateTime", render: orderAllocationDisplayRenderer },
        { data: "OrderPriority", render: orderAllocationDisplayRenderer },
        { data: "BName", render: orderAllocationDisplayRenderer },
        { data: "PropertyAddress", render: orderAllocationWrapRenderer },
        { data: "State", render: orderAllocationDisplayRenderer },
        { data: "County", render: orderAllocationDisplayRenderer },
        { data: "ClientIdNew", render: orderAllocationDisplayRenderer },
        { data: "CustomerType", render: orderAllocationDisplayRenderer },
        { data: "TransactionType", render: orderAllocationDisplayRenderer },
        { data: "LegalDescription", render: orderAllocationWrapRenderer },
        { data: "Instruction", render: orderAllocationWrapRenderer },
        { data: "LastProcess", render: orderAllocationDisplayRenderer },
        {
            data: null,
            render: function (data, type, row) {
                return orderAllocationDisplayRenderer(row.LastUser || row.Assign || row.CreatedBy || row.UserName, type);
            }
        },
        { data: "OrderID", render: orderAllocationDisplayRenderer }
    ], {
        pageLength: 10,
        columnDefs: [
            { targets: 0, orderable: false, className: "text-center" },
            { targets: 16, visible: false }
        ],
        buttons: [
            {
                extend: "excelHtml5",
                title: excelTitle,
                text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                className: "btn btn-sm"
            }
        ],
        drawCallback: function () {
            orderAllocationRestoreSelections();
        }
    }));

    $("#chkAll_Order").off("click.orderAllocation").on("click.orderAllocation", function () {
        var checked = $(this).is(":checked");

        OrderAllocationLoan_table.$("input.row-checkbox").each(function () {
            var value = $(this).val();
            selectedOrderMap[value] = checked;
            $(this).prop("checked", checked);
            $(this).closest("tr").toggleClass("selected-row", checked);
        });

        orderAllocationUpdateHeaderCheckbox();
    });

    $table.find("tbody")
        .off("change.orderAllocation", "input.row-checkbox")
        .on("change.orderAllocation", "input.row-checkbox", function () {
            var value = $(this).val();
            var checked = $(this).is(":checked");

            selectedOrderMap[value] = checked;
            $(this).closest("tr").toggleClass("selected-row", checked);
            orderAllocationUpdateHeaderCheckbox();
        });

    orderAllocationRestoreSelections();
}

function orderAllocationRestoreSelections() {
    if (!OrderAllocationLoan_table) {
        return;
    }

    OrderAllocationLoan_table.$("input.row-checkbox").each(function () {
        var checked = selectedOrderMap[$(this).val()] === true;
        $(this).prop("checked", checked);
        $(this).closest("tr").toggleClass("selected-row", checked);
    });

    orderAllocationUpdateHeaderCheckbox();
}

function orderAllocationUpdateHeaderCheckbox() {
    if (!OrderAllocationLoan_table) {
        $("#chkAll_Order").prop("checked", false);
        return;
    }

    var total = 0;
    var checked = 0;

    OrderAllocationLoan_table.$("input.row-checkbox").each(function () {
        total++;
        if ($(this).is(":checked")) {
            checked++;
        }
    });

    $("#chkAll_Order").prop("checked", total > 0 && total === checked);
}

function orderAllocationSelectedOrderIds() {
    var orderIds = [];

    if (!OrderAllocationLoan_table) {
        return orderIds;
    }

    OrderAllocationLoan_table.$("input.row-checkbox").each(function () {
        if ($(this).is(":checked")) {
            orderIds.push($(this).val());
        }
    });

    return orderIds;
}

function allocateOrder_Submit() {
    var allocatedOrderIDs = orderAllocationSelectedOrderIds();

    if (!allocatedOrderIDs.length) {
        orderAllocationAlert("warning", "Required Selection", "Please select at least one order.");
        return false;
    }

    $("#waitingpanel").modal("show");
    orderAllocationSetButtonBusy("#approveSelectedLoans", true, "Allocating");

    orderAllocationPostJson("OrderAllocation_ToUser", {
        OrderIDs: allocatedOrderIDs.join(","),
        ProjectID: project_id,
        ProcessID: process_id,
        ProductType: product_type
    }).done(function (result) {
        if (result > 0) {
            orderAllocationAlert("success", "Success", "Order allocated successfully.", function () {
                $("#popUpViewLoanDetails").modal("hide");
                orderAllocationSummary();
            });
        } else {
            orderAllocationAlert("warning", "Allocation Failed", "Error occurred while allocating orders. Please contact administrator.");
        }
    }).fail(function (error) {
        orderAllocationAjaxError(error, "Error occurred while allocating orders.");
    }).always(function () {
        $("#waitingpanel").modal("hide");
        orderAllocationSetButtonBusy("#approveSelectedLoans", false);
    });

    return false;
}

function BindViewLoanDetails1(OrderDate, ProjectNo, ProdcutType) {
    return BindViewLoanDetails(OrderDate, ProjectNo, ProdcutType);
}

function getallSelectdeselectOrderAllocation(source) {
    var checked = $(source).is(":checked");
    $(".row-checkbox").prop("checked", checked).closest("tr").toggleClass("selected-row", checked);
    return false;
}
