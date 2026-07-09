/************** Order Entry **************/

var edit_OrderID = 0;
var edit_projectID = 0;
var orderentry_table;
var ORDERENTRY_DEFAULT_PROJECT_ID = 90;

function OrderEntry_InitPage() {
    if (!$("#table_orderentry").length) {
        return;
    }

    $(".order-entry-page")
        .off("input.orderEntry change.orderEntry", ".form-control")
        .on("input.orderEntry change.orderEntry", ".form-control", function () {
            $(this).removeClass("is-invalid");
        });

    orderEntryPopulateSelect("#orderentry_county", [], "County", "County");
    orderEntryPopulateSelect("#orderentry_county_662", [], "County", "County");
    orderEntryPopulateSelect("#orderentry_producttype", [], "ProductType", "ProductType");
    orderEntryPopulateSelect("#orderentry_template", [], "TemplateId", "Template");

    $.when(
        OrderEntry_BindProjects(),
        OrderEntry_BindState(),
        OrderEntry_BindUsers()
    ).always(function () {
        OrderEntry_BindGrid(ORDERENTRY_DEFAULT_PROJECT_ID);
    });
}

function orderEntryPostJson(methodName, payload) {
    return $.ajax({
        type: "POST",
        url: "OrderEntry.aspx/" + methodName,
        data: JSON.stringify(payload || {}),
        dataType: "json",
        contentType: "application/json; charset=utf-8"
    }).then(function (response) {
        return orderEntryParseRows(response);
    });
}

function orderEntryParseRows(response) {
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

function orderEntryPopulateSelect(selector, rows, valueField, textField, selectedValue) {
    var $select = $(selector);

    if (!$select.length) {
        return $.Deferred().resolve().promise();
    }

    $select.empty();
    $select.append($("<option></option>").val("").text("Select"));

    $.each(rows || [], function (_, row) {
        var value = typeof valueField === "function" ? valueField(row) : row[valueField];
        var text = typeof textField === "function" ? textField(row) : row[textField];

        $select.append($("<option></option>").val(value == null ? "" : value).text(text == null ? "" : text));
    });

    if (selectedValue !== undefined && selectedValue !== null) {
        $select.val(String(selectedValue));
    }

    return $.Deferred().resolve().promise();
}

function orderEntryAjaxError(error, fallbackMessage) {
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

    orderEntryAlert("error", "Error", message);
}

function orderEntryAlert(icon, title, text, callback) {
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

function orderEntryShowLoader(show) {
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

function orderEntrySetButtonBusy(selector, busy, busyText) {
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

function orderEntryElement(id) {
    return document.getElementById(id);
}

function orderEntryValue(id) {
    var element = orderEntryElement(id);
    return element ? $.trim($(element).val()) : "";
}

function orderEntrySelectText(id) {
    var element = orderEntryElement(id);

    if (!element || !element.options || element.selectedIndex < 0) {
        return "";
    }

    return $.trim(element.options[element.selectedIndex].text);
}

function orderEntrySetValue(id, value) {
    var element = orderEntryElement(id);

    if (element) {
        $(element).val(value == null ? "" : value);
    }
}

function orderEntryToInt(value) {
    var parsed = parseInt(value, 10);
    return isNaN(parsed) ? 0 : parsed;
}

function orderEntrySafeText(value) {
    return $("<div></div>").text(value == null ? "" : value).html();
}

function orderEntryDisplayRenderer(data, type) {
    if (type === "display") {
        return orderEntrySafeText(data);
    }

    return data == null ? "" : data;
}

function orderEntryLongTextRenderer(data, type) {
    if (type !== "display") {
        return data == null ? "" : data;
    }

    return '<div style="min-width:220px; white-space:normal;">' + orderEntrySafeText(data) + "</div>";
}

function orderEntryDateValue(value) {
    var date = orderEntryBuildDate(value);

    if (!date) {
        return "";
    }

    return [
        date.getFullYear(),
        orderEntryPad2(date.getMonth() + 1),
        orderEntryPad2(date.getDate())
    ].join("-");
}

function orderEntryDateTimeValue(value) {
    var date = orderEntryBuildDate(value);

    if (!date) {
        return "";
    }

    return [
        date.getFullYear(),
        orderEntryPad2(date.getMonth() + 1),
        orderEntryPad2(date.getDate())
    ].join("-") + "T" + [orderEntryPad2(date.getHours()), orderEntryPad2(date.getMinutes())].join(":");
}

function orderEntryBuildDate(value) {
    if (!value) {
        return null;
    }

    if (value instanceof Date && !isNaN(value.getTime())) {
        return value;
    }

    var raw = String(value);
    var match = /\/Date\((\d+)\)\//.exec(raw);
    var date = match ? new Date(parseInt(match[1], 10)) : new Date(raw);

    if (isNaN(date.getTime())) {
        return null;
    }

    return date;
}

function orderEntryPad2(value) {
    return value < 10 ? "0" + value : String(value);
}

function formatdate(prv_date) {
    return orderEntryDateValue(prv_date);
}

function OrderEntry_BindState(selectedState, selectedState662) {
    return orderEntryPostJson("GetAllState").done(function (rows) {
        orderEntryPopulateSelect("#orderentry_state", rows, "StateCode", "StateCode", selectedState);
        orderEntryPopulateSelect("#orderentry_state_662", rows, "StateCode", "StateCode", selectedState662);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load states.");
    });
}

function OrderEntry_BindCounty(ddlstate) {
    var state = ddlstate ? ddlstate.value : orderEntryValue("orderentry_state");
    return orderEntryBindCountySelect("#orderentry_county", state);
}

function orderEntryBindCountySelect(selector, state, selectedCounty) {
    orderEntryPopulateSelect(selector, [], "County", "County");

    if (!state) {
        return $.Deferred().resolve().promise();
    }

    return orderEntryPostJson("GetCountyByState", { State: state }).done(function (rows) {
        orderEntryPopulateSelect(selector, rows, "County", "County", selectedCounty);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load counties.");
    });
}

function OrderEntry_BindTemplate(ddlproject) {
    var projectId = ddlproject ? ddlproject.value : orderEntryValue("orderentry_projectno");
    var projectName = ddlproject && ddlproject.options ? ddlproject.options[ddlproject.selectedIndex].text : orderEntrySelectText("orderentry_projectno");

    edit_projectID = orderEntryToInt(projectId);

    OrderEntry_BindProductType(projectName);
    OrderEntry_BindGrid(projectId || ORDERENTRY_DEFAULT_PROJECT_ID);

    return orderEntryBindTemplates(projectId);
}

function orderEntryBindTemplates(projectId, selectedTemplate) {
    orderEntryPopulateSelect("#orderentry_template", [], "TemplateId", "Template");

    if (!orderEntryToInt(projectId)) {
        return $.Deferred().resolve().promise();
    }

    return orderEntryPostJson("GetAllTemplateProject", { ProjectID: orderEntryToInt(projectId) }).done(function (rows) {
        orderEntryPopulateSelect("#orderentry_template", rows, "TemplateId", "Template", selectedTemplate);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load templates.");
    });
}

function OrderEntry_BindUsers(selectedUser) {
    return orderEntryPostJson("GetAllUsers").done(function (rows) {
        orderEntryPopulateSelect("#orderentry_searcher", rows, "EmployeeID", "EmpName", selectedUser);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load users.");
    });
}

function OrderEntry_BindProjects(selectedProject) {
    return orderEntryPostJson("GetUserWiseProject").done(function (rows) {
        orderEntryPopulateSelect("#orderentry_projectno", rows, "ProjectID", "ProjectName", selectedProject);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load projects.");
    });
}

function OrderEntry_BindProductType(projectname, selectedProductType) {
    orderEntryPopulateSelect("#orderentry_producttype", [], "ProductType", "ProductType");

    if (!projectname || projectname === "Select") {
        return $.Deferred().resolve().promise();
    }

    return orderEntryPostJson("GetAllProductRelatedToProject", { ProjectNo: projectname }).done(function (rows) {
        orderEntryPopulateSelect("#orderentry_producttype", rows, "ProductType", "ProductType", selectedProductType);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load product types.");
    });
}

function OrderEntry_BindGrid(project) {
    var projectId = orderEntryToInt(project || ORDERENTRY_DEFAULT_PROJECT_ID);

    if (!$("#table_orderentry").length) {
        return false;
    }

    orderEntryShowLoader(true);

    orderEntryPostJson("GetAllInfinityOrderByProjectAndUser", { ProjectID: projectId }).done(function (rows) {
        var tableSelector = "#table_orderentry";
        var hasButtons = $.fn.dataTable && $.fn.dataTable.Buttons;
        var tableOptions;

        if ($.fn.DataTable.isDataTable(tableSelector)) {
            $(tableSelector).DataTable().clear().destroy();
            $(tableSelector + " tbody").empty();
        }

        tableOptions = {
            dom: hasButtons
                ? "<'order-table-toolbar'<'order-table-filter'f><'order-table-export'B>>rt<'row align-items-center'<'col-md-5'i><'col-md-7'p>>"
                : "<'order-table-toolbar'<'order-table-filter'f>>rt<'row align-items-center'<'col-md-5'i><'col-md-7'p>>",
            data: rows || [],
            scrollX: true,
            autoWidth: false,
            paging: true,
            pageLength: 10,
            lengthChange: false,
            processing: true,
            ordering: false,
            serverSide: false,
            responsive: false,
            language: {
                search: "Search:",
                emptyTable: "No orders found.",
                zeroRecords: "No matching orders found."
            },
            columns: [
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        if (type !== "display") {
                            return "";
                        }

                        return '<button type="button" class="btn btn-sm btn-outline-primary order-icon-btn" title="Edit Order" onclick="return edit_order('
                            + orderEntryToInt(row.OrderID) + ", " + meta.row + ');">'
                            + '<i class="fas fa-edit"></i>'
                            + "</button>";
                    }
                },
                { data: "SrNo", render: orderEntryDisplayRenderer },
                { data: "OrderDateTime", render: orderEntryDisplayRenderer },
                { data: "ProjectNumber", render: orderEntryDisplayRenderer },
                { data: "ClientOrderNo", render: orderEntryDisplayRenderer },
                { data: "ProductType", render: orderEntryDisplayRenderer },
                { data: "BName", render: orderEntryDisplayRenderer },
                { data: "PropertyAddress", render: orderEntryLongTextRenderer },
                { data: "State", render: orderEntryDisplayRenderer },
                { data: "County", render: orderEntryDisplayRenderer },
                { data: "CreatedBy", render: orderEntryDisplayRenderer },
                { data: "AddedDate", render: orderEntryDisplayRenderer },
                { data: "OrderID", render: orderEntryDisplayRenderer }
            ],
            columnDefs: [
                { targets: 0, orderable: false, className: "text-center" },
                { targets: 12, visible: false }
            ],
            initComplete: function () {
                orderentry_table = $(tableSelector).DataTable();
            }
        };

        if (hasButtons) {
            tableOptions.buttons = [
                {
                    extend: "excelHtml5",
                    text: '<i class="fas fa-file-excel"></i><span>Excel</span>',
                    className: "btn btn-sm"
                }
            ];
        }

        orderentry_table = $(tableSelector).DataTable(tableOptions);
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load orders.");
    }).always(function () {
        orderEntryShowLoader(false);
    });

    return false;
}

function edit_order(orderid, index) {
    edit_OrderID = orderEntryToInt(orderid);

    if (orderentry_table) {
        orderentry_table.$("tr").removeClass("selected-row");

        var rowNode = orderentry_table.row(index).node();
        if (rowNode) {
            $(rowNode).addClass("selected-row");
        }
    }

    $("#orderentry_btnreset").show();
    $("#orderentry_orderdate").focus();
    OrderEntry_BindOrderDetails(edit_OrderID);

    var formPanel = document.querySelector(".order-form-panel");
    if (formPanel && typeof formPanel.scrollIntoView === "function") {
        formPanel.scrollIntoView({ behavior: "smooth", block: "start" });
    }

    return false;
}

function orderentry_reset() {
    orderEntryResetForm();
    return false;
}

function orderEntryResetForm() {
    edit_OrderID = 0;

    [
        "orderentry_orderdate",
        "orderentry_receiveddate",
        "orderentry_clientorderno",
        "orderentry_borrowername",
        "orderentry_salesprice",
        "orderentry_sellername",
        "orderentry_clientid",
        "orderentry_pinno",
        "orderentry_propertyaddress",
        "orderentry_instruction",
        "orderentry_legaldescription",
        "orderentry_attachment"
    ].forEach(function (id) {
        orderEntrySetValue(id, "");
    });

    [
        "orderentry_orderpriority",
        "orderentry_projectno",
        "orderentry_state",
        "orderentry_county",
        "orderentry_producttype",
        "orderentry_template",
        "orderentry_expectedtat",
        "orderentry_onoffline",
        "orderentry_exhibit",
        "orderentry_transaction",
        "orderentry_customertype",
        "orderentry_searcher"
    ].forEach(function (id) {
        orderEntrySetValue(id, "");
    });

    $(".order-entry-page .is-invalid").removeClass("is-invalid");
    $("#orderentry_btnsubmit").html('<i class="fas fa-save"></i><span>Submit</span>').prop("disabled", false);
    $("#orderentry_btnreset").hide();

    if (orderentry_table) {
        orderentry_table.$("tr").removeClass("selected-row");
    }

    $("#orderentry_orderdate").focus();
}

function OrderEntry_BindOrderDetails(orderid) {
    if (!orderEntryToInt(orderid)) {
        return false;
    }

    orderEntryShowLoader(true);
    $("#orderentry_btnsubmit").html('<i class="fas fa-save"></i><span>Update</span>');

    orderEntryPostJson("GetOrderByID", { OrderID: orderEntryToInt(orderid) }).done(function (rows) {
        if (!rows || !rows.length) {
            orderEntryAlert("warning", "Order Not Found", "Unable to locate the selected order.");
            return;
        }

        var d = rows[0];

        orderEntrySetValue("orderentry_orderdate", orderEntryDateValue(d.OrderDate));
        orderEntrySetValue("orderentry_receiveddate", orderEntryDateTimeValue(d.ReceivedDate || d.OrderDateTime));
        orderEntrySetValue("orderentry_clientorderno", d.ClientOrderNo);
        orderEntrySetValue("orderentry_borrowername", d.BName);
        orderEntrySetValue("orderentry_propertyaddress", d.PropertyAddress);
        orderEntrySetValue("orderentry_salesprice", d.SalesPurchaseAmount);
        orderEntrySetValue("orderentry_sellername", d.SellerName);
        orderEntrySetValue("orderentry_clientid", d.ClientIDNew);
        orderEntrySetValue("orderentry_pinno", d.APNNo);
        orderEntrySetValue("orderentry_instruction", d.Instruction);
        orderEntrySetValue("orderentry_legaldescription", d.LegalDescription);
        orderEntrySetValue("orderentry_orderpriority", d.OrderPriority);
        orderEntrySetValue("orderentry_expectedtat", d.ExpectedTime);
        orderEntrySetValue("orderentry_onoffline", d.OnOffLine);
        orderEntrySetValue("orderentry_exhibit", d.Exhibit);
        orderEntrySetValue("orderentry_transaction", d.TransactionType);
        orderEntrySetValue("orderentry_customertype", d.CustomerType);

        $.when(
            OrderEntry_BindProjects(d.ProjectID),
            OrderEntry_BindState(d.State),
            orderEntryBindCountySelect("#orderentry_county", d.State, d.County),
            OrderEntry_BindUsers(d.TaskAssignedId),
            orderEntryBindTemplates(d.ProjectID, d.OrderTemplateId),
            OrderEntry_BindProductType(d.ProjectNumber, d.ProductType)
        ).always(function () {
            orderEntryShowLoader(false);
        });
    }).fail(function (error) {
        orderEntryAjaxError(error, "Unable to load order details.");
        orderEntryShowLoader(false);
    });

    return false;
}

function orderEntryCollectOrder() {
    return {
        orderid: edit_OrderID || 0,
        projectid: orderEntryToInt(orderEntryValue("orderentry_projectno")),
        projectno: orderEntrySelectText("orderentry_projectno"),
        orderpriority: orderEntryValue("orderentry_orderpriority"),
        expectedtat: orderEntryValue("orderentry_expectedtat"),
        onoffline: orderEntryValue("orderentry_onoffline"),
        exhibit: orderEntryValue("orderentry_exhibit"),
        transaction: orderEntryValue("orderentry_transaction"),
        customertype: orderEntryValue("orderentry_customertype"),
        state: orderEntryValue("orderentry_state"),
        county: orderEntryValue("orderentry_county"),
        searcher: orderEntryToInt(orderEntryValue("orderentry_searcher")),
        template: orderEntryToInt(orderEntryValue("orderentry_template")),
        producttype: orderEntryValue("orderentry_producttype"),
        orderdate: orderEntryValue("orderentry_orderdate"),
        receiveddate: orderEntryValue("orderentry_receiveddate"),
        clientorderno: orderEntryValue("orderentry_clientorderno"),
        borrowername: orderEntryValue("orderentry_borrowername"),
        propertyaddress: orderEntryValue("orderentry_propertyaddress"),
        salesprice: orderEntryValue("orderentry_salesprice"),
        sellername: orderEntryValue("orderentry_sellername"),
        clientid: orderEntryValue("orderentry_clientid"),
        pinno: orderEntryValue("orderentry_pinno"),
        instruction: orderEntryValue("orderentry_instruction"),
        legaldescription: orderEntryValue("orderentry_legaldescription")
    };
}

function orderEntryValidateOrder(order) {
    var requiredFields = [
        { id: "orderentry_orderdate", value: order.orderdate, message: "Please enter order date." },
        { id: "orderentry_receiveddate", value: order.receiveddate, message: "Please enter received order date." },
        { id: "orderentry_projectno", value: order.projectid, message: "Please select project #." },
        { id: "orderentry_clientorderno", value: order.clientorderno, message: "Please enter client order no." },
        { id: "orderentry_borrowername", value: order.borrowername, message: "Please enter Borrower Name." },
        { id: "orderentry_propertyaddress", value: order.propertyaddress, message: "Please enter property address." },
        { id: "orderentry_state", value: order.state, message: "Please select state." },
        { id: "orderentry_county", value: order.county, message: "Please select county." },
        { id: "orderentry_producttype", value: order.producttype, message: "Please select Product Type." },
        { id: "orderentry_expectedtat", value: order.expectedtat, message: "Please select expected TAT." },
        { id: "orderentry_onoffline", value: order.onoffline, message: "Please select On/Offline." },
        { id: "orderentry_transaction", value: order.transaction, message: "Please select Transaction." },
        { id: "orderentry_clientid", value: order.clientid, message: "Please enter Client ID." },
        { id: "orderentry_customertype", value: order.customertype, message: "Please select Customer Type." }
    ];

    for (var i = 0; i < requiredFields.length; i++) {
        if (!requiredFields[i].value) {
            orderEntryMarkInvalid(requiredFields[i].id, requiredFields[i].message);
            return false;
        }
    }

    return true;
}

function orderEntryMarkInvalid(id, message) {
    $("#" + id).addClass("is-invalid").focus();
    orderEntryAlert("warning", "Required Field", message);
}

function orderentry_submit() {
    var order = orderEntryCollectOrder();

    if (!orderEntryValidateOrder(order)) {
        return false;
    }

    if (!window.PageMethods || typeof PageMethods.core_InsertOrder !== "function") {
        orderEntryAlert("error", "Error", "Order save method is not available.");
        return false;
    }

    edit_projectID = order.projectid;
    orderEntrySetButtonBusy("#orderentry_btnsubmit", true, order.orderid > 0 ? "Updating" : "Saving");

    PageMethods.core_InsertOrder(
        order.orderid,
        order.projectid,
        order.projectno,
        order.orderpriority,
        order.expectedtat,
        order.onoffline,
        order.exhibit,
        order.transaction,
        order.customertype,
        order.state,
        order.county,
        order.searcher,
        order.template,
        order.producttype,
        order.orderdate,
        order.receiveddate,
        order.clientorderno,
        order.borrowername,
        order.propertyaddress,
        order.salesprice,
        order.sellername,
        order.clientid,
        order.pinno,
        order.instruction,
        order.legaldescription,
        OnSuccess_InsertOrder,
        OnError_InsertOrder
    );

    return false;
}

function OnSuccess_InsertOrder(result) {
    var wasUpdate = edit_OrderID > 0;
    var projectToRefresh = edit_projectID || orderEntryToInt(orderEntryValue("orderentry_projectno")) || ORDERENTRY_DEFAULT_PROJECT_ID;

    orderEntrySetButtonBusy("#orderentry_btnsubmit", false);

    if (result > 0) {
        orderEntryAlert(
            "success",
            "Success",
            wasUpdate ? "Order updated successfully." : "Order created successfully.",
            function () {
                orderEntryResetForm();
                OrderEntry_BindGrid(projectToRefresh);
            }
        );
    } else if (result == -1) {
        orderEntryAlert("warning", "Duplicate Order", "Order already exists.");
    } else {
        orderEntryAlert("error", "Error", wasUpdate ? "Error updating order." : "Error creating order.");
    }

    return false;
}

function OnError_InsertOrder(error) {
    orderEntrySetButtonBusy("#orderentry_btnsubmit", false);
    orderEntryAjaxError(error, "Error saving order.");
    return false;
}

function delete_order(orderid, index) {
    if (orderentry_table) {
        orderentry_table.$("tr").removeClass("selected-row");

        var rowNode = orderentry_table.row(index).node();
        if (rowNode) {
            $(rowNode).addClass("selected-row");
        }
    }

    edit_OrderID = orderEntryToInt(orderid);
    $("#orderentry_deleteOrder").modal("show");
    return false;
}

function orderentry_deleteOrder() {
    if (!window.PageMethods || typeof PageMethods.DeleteOrder !== "function") {
        orderEntryAlert("error", "Error", "Delete method is not available.");
        return false;
    }

    PageMethods.DeleteOrder(edit_OrderID, orderentry_DeleteOnSuccess, orderentry_DeleteOnError);
    return false;
}

function orderentry_DeleteOnSuccess(result) {
    $("#orderentry_deleteOrder").modal("hide");

    if (result > 0) {
        edit_OrderID = 0;
        orderEntryAlert("success", "Success", "Order deleted successfully.", function () {
            OrderEntry_BindGrid(edit_projectID || ORDERENTRY_DEFAULT_PROJECT_ID);
        });
    } else {
        orderEntryAlert("error", "Error", "Error occurred while deleting order. Please contact administrator.");
    }

    return false;
}

function orderentry_DeleteOnError(error) {
    orderEntryAjaxError(error, "Error deleting order.");
    return false;
}

$("#importorder_attachment").on("change", function () {

    if (this.files.length === 0)
        return;

    var file = this.files[0];

    $("#selectedFile").show();

    $("#fileName").text(file.name);

    $("#fileSize").text(formatFileSize(file.size));

});

function clearUpload() {

    $("#importorder_attachment").val("");

    $("#selectedFile").hide();

    $("#fileName").text("");

    $("#fileSize").text("");

}

function formatFileSize(bytes) {

    if (bytes < 1024)
        return bytes + " Bytes";

    if (bytes < 1024 * 1024)
        return (bytes / 1024).toFixed(2) + " KB";

    return (bytes / (1024 * 1024)).toFixed(2) + " MB";

}

$("#orderentry_receiveddate").on("paste", function (e) {

    e.preventDefault();

    var pastedText = (e.originalEvent || e).clipboardData.getData("text").trim();

    // Expected format: M/D/YYYY HH:MM AM/PM
    var match = pastedText.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})\s+(\d{1,2}):(\d{2})\s*(AM|PM)$/i);

    if (!match) {
        alert("Invalid date format.");
        return;
    }

    var month = match[1].padStart(2, '0');
    var day = match[2].padStart(2, '0');
    var year = match[3];
    var hour = parseInt(match[4], 10);
    var minute = match[5];
    var ampm = match[6].toUpperCase();

    if (ampm === "PM" && hour < 12)
        hour += 12;

    if (ampm === "AM" && hour === 12)
        hour = 0;

    hour = hour.toString().padStart(2, '0');

    $(this).val(year + "-" + month + "-" + day + "T" + hour + ":" + minute);
});

/************** Import Excel **************/

function importorder_submit() {
    var input = orderEntryElement("importorder_attachment");
    var file = input && input.files && input.files.length ? input.files[0] : null;

    if (!file) {
        orderEntryMarkInvalid("importorder_attachment", "Please select an Excel file.");
        return false;
    }

    if (!/\.xlsx$/i.test(file.name)) {
        orderEntryMarkInvalid("importorder_attachment", "Please select an Excel file with the .xlsx extension.");
        return false;
    }

    if (!window.FormData) {
        orderEntryAlert("error", "Error", "File upload is not supported in this browser.");
        return false;
    }

    if (!window.PageMethods || typeof PageMethods.ImportData !== "function") {
        orderEntryAlert("error", "Error", "Import method is not available.");
        return false;
    }

    var formData = new FormData();
    formData.append(input.name || "importorder_attachment", file);

    orderEntryShowLoader(true);
    orderEntrySetButtonBusy("#importorder_btnsubmit", true, "Importing");

    $.ajax({
        url: window.location.pathname,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false
    }).done(function () {
        PageMethods.ImportData(importorder_OnSuccess, importorder_OnError);
    }).fail(function (error) {
        importorder_OnError(error);
    });

    return false;
}

function importorder_OnSuccess(result) {
    orderEntryShowLoader(false);
    orderEntrySetButtonBusy("#importorder_btnsubmit", false);

    if (result > 0) {
        orderEntryAlert("success", "Success", "Excel imported successfully.");
        orderEntrySetValue("importorder_attachment", "");
    } else if (result == -1) {
        orderEntryAlert("warning", "Invalid Data", "Unable to read the selected Excel file.");
    } else if (result == -2) {
        orderEntryAlert("warning", "Invalid File", "Please select an Excel file with the .xlsx extension.");
    } else {
        orderEntryAlert("error", "Error", "Something went wrong. Please contact administrator.");
    }

    return false;
}

function importorder_OnError(error) {
    orderEntryShowLoader(false);
    orderEntrySetButtonBusy("#importorder_btnsubmit", false);
    orderEntryAjaxError(error, "Error importing Excel.");
    return false;
}

/************** 662-002 **************/

function OrderEntry662_BindCounty(ddlstate) {
    var state = ddlstate ? ddlstate.value : orderEntryValue("orderentry_state_662");
    return orderEntryBindCountySelect("#orderentry_county_662", state);
}

function orderentry_submit_662() {
    var data = {
        receiveddate: orderEntryValue("orderentry_receiveddate_662"),
        clientorderno: orderEntryValue("orderentry_clientorderno_662"),
        borrowername: orderEntryValue("orderentry_borrowername_662"),
        propertyaddress: orderEntryValue("orderentry_propertyaddress_662"),
        sellername: orderEntryValue("orderentry_sellername_662"),
        instruction: orderEntryValue("orderentry_instruction_662"),
        state: orderEntryValue("orderentry_state_662"),
        county: orderEntryValue("orderentry_county_662"),
        transaction: orderEntryValue("orderentry_loantype_662")
    };

    var requiredFields = [
        { id: "orderentry_receiveddate_662", value: data.receiveddate, message: "Please enter received date." },
        { id: "orderentry_clientorderno_662", value: data.clientorderno, message: "Please enter client order no." },
        { id: "orderentry_borrowername_662", value: data.borrowername, message: "Please enter Borrower Name." },
        { id: "orderentry_propertyaddress_662", value: data.propertyaddress, message: "Please enter property address." },
        { id: "orderentry_state_662", value: data.state, message: "Please select state." },
        { id: "orderentry_county_662", value: data.county, message: "Please select county." },
        { id: "orderentry_loantype_662", value: data.transaction, message: "Please select Transaction." }
    ];

    for (var i = 0; i < requiredFields.length; i++) {
        if (!requiredFields[i].value) {
            orderEntryMarkInvalid(requiredFields[i].id, requiredFields[i].message);
            return false;
        }
    }

    if (!window.PageMethods || typeof PageMethods.InsertOrder_662 !== "function") {
        orderEntryAlert("error", "Error", "662-002 save method is not available.");
        return false;
    }

    orderEntrySetButtonBusy("#orderentry_btnsubmit_662", true, "Saving");

    PageMethods.InsertOrder_662(
        data.receiveddate,
        data.clientorderno,
        data.borrowername,
        data.propertyaddress,
        data.sellername,
        data.instruction,
        data.state,
        data.county,
        data.transaction,
        orderentry662_OnSuccess,
        orderentry662_OnError
    );

    return false;
}

function orderentry662_OnSuccess(result) {
    orderEntrySetButtonBusy("#orderentry_btnsubmit_662", false);

    if (result > 0) {
        orderEntryAlert("success", "Success", "Order created successfully.", function () {
            orderentry_reset_662();
            OrderEntry_BindGrid(ORDERENTRY_DEFAULT_PROJECT_ID);
        });
    } else {
        orderEntryAlert("error", "Error", "Error creating order.");
    }

    return false;
}

function orderentry662_OnError(error) {
    orderEntrySetButtonBusy("#orderentry_btnsubmit_662", false);
    orderEntryAjaxError(error, "Error saving order.");
    return false;
}

function orderentry_reset_662() {
    [
        "orderentry_receiveddate_662",
        "orderentry_clientorderno_662",
        "orderentry_borrowername_662",
        "orderentry_sellername_662",
        "orderentry_propertyaddress_662",
        "orderentry_instruction_662"
    ].forEach(function (id) {
        orderEntrySetValue(id, "");
    });

    [
        "orderentry_state_662",
        "orderentry_county_662",
        "orderentry_loantype_662"
    ].forEach(function (id) {
        orderEntrySetValue(id, "");
    });

    $("#orderentry_btnsubmit_662").html('<i class="fas fa-save"></i><span>Submit</span>').prop("disabled", false);
    $(".order-entry-page .is-invalid").removeClass("is-invalid");
    return false;
}



