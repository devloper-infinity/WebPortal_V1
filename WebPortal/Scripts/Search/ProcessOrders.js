var ProcessOrders_html;
var InvoiceID;
var invrec_SearchProcess;
var processOrderDetailsTable;
var currentProcessTasksTable;
var processOrdersData = [];
var selectedProcessOrder = null;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function getFirstDayOfMonth(date) {
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function htmlEncode(value) {
    return $('<div/>').text(blankForNull(value)).html();
}

function getOrderValue(order, primaryName, fallbackName) {
    if (!order) {
        return "";
    }

    if (order[primaryName] !== undefined && order[primaryName] !== null) {
        return order[primaryName];
    }

    if (fallbackName && order[fallbackName] !== undefined && order[fallbackName] !== null) {
        return order[fallbackName];
    }

    return "";
}

function showProcessOrderMessage(type, message) {
    if ($('.modal.show').length && window.Swal && typeof window.Swal.fire === 'function') {
        clearProcessOrderMessage();
        window.Swal.fire({
            icon: type === 'success' ? 'success' : (type === 'warning' ? 'warning' : (type === 'info' ? 'info' : 'error')),
            title: type === 'success' ? 'Success' : (type === 'warning' ? 'Validation' : (type === 'info' ? 'Information' : 'Error')),
            text: message,
            confirmButtonColor: '#0f766e',
            allowOutsideClick: false
        });
        return;
    }

    var $alert = $('#processOrderAlert');
    if (!$alert.length) {
        alert(message);
        return;
    }

    $alert
        .removeClass('alert-success alert-danger alert-warning alert-info')
        .addClass('alert-' + type)
        .text(message)
        .show();
}

function clearProcessOrderMessage() {
    $('#processOrderAlert').hide().text('');
}

function setProcessOrderButtonBusy(selector, isBusy, text) {
    var $button = $(selector);
    if (!$button.length) {
        return;
    }

    if (isBusy) {
        $button.data('original-text', $button.html());
        $button.prop('disabled', true).html(text || 'Saving...');
    } else {
        $button.prop('disabled', false).html($button.data('original-text') || 'Submit');
    }
}

function parseServerResponse(result) {
    var payload = result && result.d !== undefined ? result.d : result;
    if (typeof payload === 'string') {
        try {
            payload = JSON.parse(payload);
        } catch (e) {
            payload = { Success: false, Message: payload };
        }
    }

    return payload || { Success: false, Message: 'No response received from server.' };
}

function processOrdersAjaxError(error, fallbackMessage) {
    $('#load1').hide();
    var message = fallbackMessage || 'Something went wrong. Please contact administrator.';

    if (error && error.responseJSON && error.responseJSON.Message) {
        message = error.responseJSON.Message;
    } else if (error && error.responseText) {
        message = error.responseText;
    }

    showProcessOrderMessage('danger', message);
}

function BindGrid_PendingOrders() {
    $('#load1').show();
    clearProcessOrderMessage();
    ProcessOrders_html = '';

    $.ajax({
        url: "ProcessOrders.aspx/GetAllPendingOrders",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d || '[]');
            processOrdersData = dataArray;

            $.each(dataArray, function (index, value) {
                ProcessOrders_html += '<tr>';
                ProcessOrders_html += '<td class="ost-actions-cell"><div class="btn-group">';
                ProcessOrders_html += '<button type="button" class="btn btn-link btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Actions"><i class="fas fa-cog"></i><span class="sr-only">Actions</span></button>';
                ProcessOrders_html += '<div class="dropdown-menu" role="menu">';
                ProcessOrders_html += '<a class="dropdown-item" href="#!" onclick="return CompleteOrderProcess(\'' + htmlEncode(value.OrderID) + '\',' + index + ');"><i class="fas fa-check-circle text-success"></i><span>Complete Order</span></a>';
                ProcessOrders_html += '<a class="dropdown-item" href="#!" onclick="return CompleteOrderProcessCosting(\'' + htmlEncode(value.OrderID) + '\',' + index + ');"><i class="fas fa-file-invoice-dollar text-primary"></i><span>Order Costing</span></a>';
                ProcessOrders_html += '<a class="dropdown-item" href="#!" onclick="return CompleteOrderTaxDetails(\'' + htmlEncode(value.OrderID) + '\',' + index + ');"><i class="fas fa-receipt text-warning"></i><span>Tax Details</span></a>';
                ProcessOrders_html += '</div></div></td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;text-align:center;">' + htmlEncode(index + 1) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.OrderID) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.ProjectNumber || value.Project) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.ClientOrderNo) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.OnOffLine) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.OrderDate) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.ProductType) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.Process || value.ProcessName) + '</td>';
                ProcessOrders_html += '<td style="text-wrap: nowrap;">' + htmlEncode(value.AssignedDate) + '</td>';
                ProcessOrders_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#invrec_SearchProcess')) {
                invrec_SearchProcess.destroy();
            }

            $('#invrec_SearchProcess tbody').html(ProcessOrders_html);
            invrec_SearchProcess = $('#invrec_SearchProcess').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },
                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },
        error: function (error) {
            processOrdersAjaxError(error, 'Unable to load pending orders.');
        }
    });

    return false;
}

function fillOrderSummary(prefix, order) {
    $('#' + prefix + 'Project').html('<b>Project No : </b>' + htmlEncode(getOrderValue(order, 'ProjectNumber', 'Project')));
    $('#' + prefix + 'OrderDate').html('<b>Order Date : </b>' + htmlEncode(getOrderValue(order, 'OrderDate')));
    $('#' + prefix + 'OrderNo').html('<b>OrderNo # : </b>' + htmlEncode(getOrderValue(order, 'ClientOrderNo')));
    $('#' + prefix + 'Process').html('<b>Process : </b>' + htmlEncode(getOrderValue(order, 'Process', 'ProcessName')));
    $('#' + prefix + 'Online').html('<b>OnOffline : </b>' + htmlEncode(getOrderValue(order, 'OnOffLine')));
}

function resetCompleteOrderModal() {
    $('#Approval_Status').val('');
    $('#Approval_remark').val('');
    $('#dashboard_attachment_upload').val('');
    $('#ProcessOrders_DispatchOrder,#ProcessOrders_NoFeedback,#ProcessOrders_TaxCalling,#ProcessOrders_Audit,#ProcessOrders_SPQA,#ProcessOrders_Offline')
        .prop('checked', false)
        .prop('disabled', false);
    resetOrderDetailsReport();
    resetCurrentProcessTasksTable();
}

function resetOrderDetailsReport() {
    if ($.fn.dataTable.isDataTable('#ProcessOrders_OrderDetails')) {
        $('#ProcessOrders_OrderDetails').DataTable().clear().destroy();
    }

    processOrderDetailsTable = null;
    $('#ProcessOrders_OrderDetails tbody').html(
        '<tr><td colspan="13" class="text-center text-muted">Loading order details...</td></tr>'
    );
}

function orderDetailFileName(path) {
    var parts = String(path || '').replace(/\\/g, '/').split('/');
    return parts.length ? parts[parts.length - 1] : '';
}

function orderDetailDownloadLink(orderId, columnName, path) {
    if (!path) {
        return '';
    }

    var url = 'ProcessOrders.aspx?action=downloadOrderDetail' +
        '&amp;orderId=' + encodeURIComponent(orderId) +
        '&amp;column=' + encodeURIComponent(columnName) +
        '&amp;path=' + encodeURIComponent(path);

    return '<a class="ost-document-link" href="' + url + '">' +
        '<i class="fas fa-download"></i><span>' +
        htmlEncode(orderDetailFileName(path) || 'Download') +
        '</span></a>';
}

function loadOrderDetailsReport(orderId) {
    $.ajax({
        url: 'ProcessOrders.aspx/GetOrderDetailsReport',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ OrderID: parseInt(orderId, 10) }),
        success: function (result) {
            var rows = JSON.parse((result && result.d) || '[]');
            var html = '';

            $.each(rows, function (index, row) {
                var attachmentPath = getOrderValue(row, 'Path');
                var orderSheetPath = getOrderValue(row, 'OrdersheetPath');
                html += '<tr>' +
                    '<td class="text-center">' + (index + 1) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'Process')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'OrderPriority')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ClientOrderNo')) + '</td>' +
                    '<td class="ost-detail-text">' +
                        htmlEncode(getOrderValue(row, 'Remark')) + '</td>' +
                    '<td>' + orderDetailDownloadLink(orderId, 'Path', attachmentPath) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ClientIdNew')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'CustomerType')) + '</td>' +
                    '<td class="ost-detail-text">' +
                        htmlEncode(getOrderValue(row, 'LegalDescription')) + '</td>' +
                    '<td class="ost-detail-text">' +
                        htmlEncode(getOrderValue(row, 'Instruction')) + '</td>' +
                    '<td>' + orderDetailDownloadLink(orderId, 'OrdersheetPath', orderSheetPath) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'AddedBy')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'AddedDate')) + '</td>' +
                    '</tr>';
            });

            $('#ProcessOrders_OrderDetails tbody').html(html);
            processOrderDetailsTable = $('#ProcessOrders_OrderDetails').DataTable({
                dom: 't',
                destroy: true,
                paging: true,
                pageLength: 5,
                lengthChange: false,
                autoWidth: false,
                ordering: false,
                processing: false,
                language: {
                    emptyTable: 'No order process details found.'
                }
            });

            processOrderDetailsTable.columns.adjust();
        },
        error: function (error) {
            $('#ProcessOrders_OrderDetails tbody').html(
                '<tr><td colspan="13" class="text-center text-danger">Unable to load order details.</td></tr>'
            );
            processOrdersAjaxError(error, 'Unable to load order process details.');
        }
    });
}

function resetCurrentProcessTasksTable() {
    if ($.fn.dataTable.isDataTable('#ProcessOrders_CurrentProcessTasks')) {
        $('#ProcessOrders_CurrentProcessTasks').DataTable().clear().destroy();
    }

    currentProcessTasksTable = null;
    $('#ProcessOrders_SelectAllTasks').prop({ checked: true, indeterminate: false });
    $('#ProcessOrders_CurrentProcessTasks tbody').html(
        '<tr><td colspan="19" class="text-center text-muted">Loading current process orders...</td></tr>'
    );
}

function loadOrdersOnCurrentProcess(orderId) {
    $.ajax({
        url: 'ProcessOrders.aspx/GetOrdersOnProcessForUser',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ OrderID: parseInt(orderId, 10) }),
        success: function (result) {
            var rows = JSON.parse((result && result.d) || '[]');
            var html = '';

            $.each(rows, function (index, row) {
                var taskId = parseInt(getOrderValue(row, 'Taskid', 'TaskId'), 10) || 0;
                html += '<tr>' +
                    '<td class="text-center"><input type="checkbox" class="ost-task-select" value="' + taskId + '" checked aria-label="Select task ' + taskId + '" /></td>' +
                    '<td class="text-center">' + (index + 1) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'OrderDate')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'Project', 'ProjectNumber')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ClientOrderNo')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ProductType')) + '</td>' +
                    '<td class="ost-task-text">' + htmlEncode(getOrderValue(row, 'BName', 'BorrowerName')) + '</td>' +
                    '<td class="ost-task-text">' + htmlEncode(getOrderValue(row, 'PropertyAddress')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'State')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'County')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ProcessName', 'Process')) + '</td>' +
                    '<td class="ost-task-text">' + htmlEncode(getOrderValue(row, 'LegalDescription')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'ClientIdNew', 'ClientId')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'CustomerType')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'TransactionType')) + '</td>' +
                    '<td class="ost-task-text">' + htmlEncode(getOrderValue(row, 'Instruction')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'SellerName')) + '</td>' +
                    '<td>' + htmlEncode(getOrderValue(row, 'APNNo')) + '</td>' +
                    '<td class="text-center"><button type="button" class="ost-attachment-action" data-task-id="' + taskId + '">' +
                    '<i class="fas fa-paperclip"></i><span>Attachment</span></button></td>' +
                    '</tr>';
            });

            $('#ProcessOrders_CurrentProcessTasks tbody').html(html);
            currentProcessTasksTable = $('#ProcessOrders_CurrentProcessTasks').DataTable({
                dom: 't',
                destroy: true,
                paging: false,
                autoWidth: false,
                ordering: false,
                processing: false,
                language: {
                    emptyTable: 'No orders found for the current process.'
                }
            });

            $('#ProcessOrders_SelectAllTasks').prop({
                checked: rows.length > 0,
                indeterminate: false
            });
            currentProcessTasksTable.columns.adjust();
        },
        error: function (error) {
            $('#ProcessOrders_CurrentProcessTasks tbody').html(
                '<tr><td colspan="19" class="text-center text-danger">Unable to load current process orders.</td></tr>'
            );
            $('#ProcessOrders_SelectAllTasks').prop({ checked: false, indeterminate: false });
            processOrdersAjaxError(error, 'Unable to load orders for the current process.');
        }
    });
}

function processAttachmentDownloadLink(taskId, path) {
    if (!path) {
        return '<span class="text-muted">-</span>';
    }

    var url = 'ProcessOrders.aspx?action=downloadProcessAttachment' +
        '&amp;taskId=' + encodeURIComponent(taskId) +
        '&amp;path=' + encodeURIComponent(path);

    return '<a class="attachment-download-btn" href="' + url + '" title="Download ' +
        htmlEncode(orderDetailFileName(path) || 'attachment') + '">' +
        '<i class="fas fa-download"></i><span>Download file</span></a>';
}

function processAttachmentFileIcon(path) {
    var extension = (orderDetailFileName(path).split('.').pop() || '').toLowerCase();
    if (extension === 'pdf') {
        return 'fa-file-pdf';
    }
    if (['doc', 'docx'].indexOf(extension) >= 0) {
        return 'fa-file-word';
    }
    if (['xls', 'xlsx', 'csv'].indexOf(extension) >= 0) {
        return 'fa-file-excel';
    }
    if (['zip', 'rar', '7z'].indexOf(extension) >= 0) {
        return 'fa-file-archive';
    }
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].indexOf(extension) >= 0) {
        return 'fa-file-image';
    }
    return 'fa-file-alt';
}

function openProcessOrderAttachments(taskId) {
    if (!taskId) {
        showProcessOrderMessage('warning', 'Invalid task selected.');
        return;
    }

    $('#ProcessOrders_AttachmentCount').text('0 files');
    $('#ProcessOrders_TaskAttachments').html(
        '<div class="attachment-loading-state"><i class="fas fa-circle-notch fa-spin"></i>Loading attachments...</div>'
    );
    $('#ProcessOrderAttachments').modal('show');

    $.ajax({
        url: 'ProcessOrders.aspx/GetProcessOrderAttachments',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ TaskID: parseInt(taskId, 10) }),
        success: function (result) {
            var rows = JSON.parse((result && result.d) || '[]');
            var html = '';

            $.each(rows, function (index, row) {
                var path = getOrderValue(row, 'Path');
                var fileName = orderDetailFileName(path) || 'No attachment available';
                var status = getOrderValue(row, 'Status') || 'Unknown';
                var remark = getOrderValue(row, 'Remark') || 'No remark added.';
                html += '<article class="attachment-file-card">' +
                    '<div class="attachment-card-top">' +
                    '<span class="attachment-file-icon"><i class="fas ' + processAttachmentFileIcon(path) + '"></i></span>' +
                    '<div class="attachment-file-main">' +
                    '<div class="attachment-file-name" title="' + htmlEncode(fileName) + '">' + htmlEncode(fileName) + '</div>' +
                    '<div class="attachment-order-no">Attachment ' + String(index + 1).padStart(2, '0') +
                    ' &bull; Order ' + htmlEncode(getOrderValue(row, 'ClientOrderNo') || '-') + '</div>' +
                    '</div>' +
                    '<span class="attachment-status">' + htmlEncode(status) + '</span>' +
                    '</div>' +
                    '<div class="attachment-meta-grid">' +
                    '<div class="attachment-meta-item"><small>Process</small><span>' + htmlEncode(getOrderValue(row, 'Process') || '-') + '</span></div>' +
                    '<div class="attachment-meta-item"><small>Added By</small><span>' + htmlEncode(getOrderValue(row, 'AddedBy') || '-') + '</span></div>' +
                    '<div class="attachment-meta-item"><small>Added Date</small><span>' + htmlEncode(getOrderValue(row, 'AddedDate') || '-') + '</span></div>' +
                    '</div>' +
                    '<div class="attachment-remark"><small>Remark</small>' + htmlEncode(remark) + '</div>' +
                    '<div class="attachment-card-actions">' + processAttachmentDownloadLink(taskId, path) + '</div>' +
                    '</article>';
            });

            $('#ProcessOrders_AttachmentCount').text(rows.length + (rows.length === 1 ? ' file' : ' files'));
            $('#ProcessOrders_TaskAttachments').html(html ||
                '<div class="attachment-empty-state"><i class="far fa-folder-open"></i>No attachments found for this order.</div>');
        },
        error: function (error) {
            $('#ProcessOrders_AttachmentCount').text('0 files');
            $('#ProcessOrders_TaskAttachments').html(
                '<div class="attachment-empty-state text-danger"><i class="fas fa-exclamation-circle"></i>Unable to load attachments.</div>');
            processOrdersAjaxError(error, 'Unable to load order attachments.');
        }
    });
}

$(document).on('click', '#ProcessOrders_CurrentProcessTasks .ost-attachment-action', function () {
    openProcessOrderAttachments(parseInt($(this).attr('data-task-id'), 10));
});

$(document).on('hidden.bs.modal', '#ProcessOrderAttachments', function () {
    if ($('#CompleteOrder').hasClass('show')) {
        $('body').addClass('modal-open');
    }
});

function getSelectedProcessTaskIds() {
    return $('#ProcessOrders_CurrentProcessTasks tbody .ost-task-select:checked').map(function () {
        return parseInt(this.value, 10);
    }).get().filter(function (taskId) {
        return taskId > 0;
    });
}

$(document).on('change', '#ProcessOrders_SelectAllTasks', function () {
    $('#ProcessOrders_CurrentProcessTasks tbody .ost-task-select').prop('checked', this.checked);
    this.indeterminate = false;
});

$(document).on('change', '#ProcessOrders_CurrentProcessTasks tbody .ost-task-select', function () {
    var total = $('#ProcessOrders_CurrentProcessTasks tbody .ost-task-select').length;
    var selected = $('#ProcessOrders_CurrentProcessTasks tbody .ost-task-select:checked').length;
    $('#ProcessOrders_SelectAllTasks').prop({
        checked: total > 0 && selected === total,
        indeterminate: selected > 0 && selected < total
    });
});

$(document).on('shown.bs.modal', '#CompleteOrder', function () {
    if (processOrderDetailsTable) {
        processOrderDetailsTable.columns.adjust();
    }
    if (currentProcessTasksTable) {
        currentProcessTasksTable.columns.adjust();
    }
});

function resetCostingModal() {
    $('#ProcessOrders_SearchEType').val('');
    $('#ProcessOrders_SearchEnginelink').val('');
    $('#ProcessOrders_txtNoOfSearchesMade').val('');
    $('#ProcessOrders_txtCostSearches').val('');
    $('#ProcessOrders_Total').val('');
    $('#ProcessOrders_CostRemark').val('');
}

var taxInstallments = ['First', 'Second', 'Third', 'Fourth'];
var taxAmountFields = ['BaseAmount', 'PaidAmount', 'DueAmount', 'Penalty'];
var taxDateFields = ['PaidDate', 'DueDate'];
var taxMonthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

function taxDateToInput(value) {
    var text = $.trim(blankForNull(value));
    if (!text) {
        return '';
    }

    if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
        return taxDateForServer(text);
    }

    var match = /^(\d{1,2})-([A-Za-z]{3})-(\d{4})$/.exec(text);
    if (match) {
        var monthIndex = taxMonthNames.map(function (month) {
            return month.toLowerCase();
        }).indexOf(match[2].toLowerCase());

        if (monthIndex >= 0) {
            return String(parseInt(match[1], 10)).padStart(2, '0') + '-' +
                taxMonthNames[monthIndex] + '-' + match[3];
        }
    }

    return '';
}

function taxDateForServer(value) {
    var text = $.trim(value || '');
    var match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(text);
    if (!match) {
        return text;
    }

    var monthIndex = parseInt(match[2], 10) - 1;
    if (monthIndex < 0 || monthIndex > 11) {
        return text;
    }

    return match[3] + '-' + taxMonthNames[monthIndex] + '-' + match[1];
}

function initializeTaxDatePickers() {
    if (!$.fn.datepicker) {
        return;
    }

    $('.tax-date-picker').each(function () {
        var $input = $(this);
        if ($input.hasClass('hasDatepicker')) {
            return;
        }

        $input.datepicker({
            dateFormat: 'dd-M-yy',
            changeMonth: true,
            changeYear: true,
            yearRange: '1900:+20',
            showOn: 'both',
            buttonText: 'Select date'
        });

        $input.next('.ui-datepicker-trigger')
            .attr({
                title: 'Select date',
                'aria-label': 'Select date'
            })
            .html('<i class="fas fa-calendar-alt" aria-hidden="true"></i>');
    });
}

function showTaxDetailsMessage(icon, title, message) {
    if (window.Swal && typeof window.Swal.fire === 'function') {
        return window.Swal.fire({
            icon: icon,
            title: title,
            text: message,
            confirmButtonColor: '#0f766e'
        });
    }

    showProcessOrderMessage(
        icon === 'success' ? 'success' : (icon === 'warning' ? 'warning' : 'danger'),
        message
    );
    return $.Deferred().resolve().promise();
}

function resetTaxDetailsModal() {
    taxInstallments.forEach(function (installment) {
        taxAmountFields.concat(taxDateFields).forEach(function (field) {
            $('#ProcessOrders_Tax' + installment + field).val('');
        });
        $('#ProcessOrders_Tax' + installment + 'Delinquency').val('Select');
    });

    $('#ProcessOrders_TaxRemark').val('');
    $('#ProcessOrders_TaxOrderID').val('');
    $('#ProcessOrders_TaxSave').prop('disabled', false);
}

function setTaxDetailsValues(row) {
    if (!row) {
        return;
    }

    taxInstallments.forEach(function (installment) {
        taxAmountFields.concat(taxDateFields).forEach(function (field) {
            var value = blankForNull(row[installment + field]);
            if (taxDateFields.indexOf(field) >= 0) {
                value = taxDateToInput(value);
            }

            $('#ProcessOrders_Tax' + installment + field)
                .val(value);
        });

        var delinquency = blankForNull(row[installment + 'Delinquency']) || 'Select';
        $('#ProcessOrders_Tax' + installment + 'Delinquency').val(delinquency);
    });

    $('#ProcessOrders_TaxRemark').val(blankForNull(row.Remark));
}

function CompleteOrderTaxDetails(orderId, selected) {
    selectedProcessOrder = processOrdersData[selected] || null;
    if (!selectedProcessOrder) {
        showTaxDetailsMessage('error', 'Unable to Open', 'Unable to find selected order details.');
        return false;
    }

    resetTaxDetailsModal();
    InvoiceID = orderId;
    $('#ProcessOrders_TaxOrderID').val(orderId);
    $('#TaxDetails').modal('show');
    $('#ProcessOrders_TaxSave').prop('disabled', true);
    $('#load1').css('display', 'flex');

    $.ajax({
        url: 'ProcessOrders.aspx/GetTaxDetails',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ OrderID: parseInt(orderId, 10) }),
        success: function (result) {
            var rows = JSON.parse((result && result.d) || '[]');
            if (rows.length) {
                setTaxDetailsValues(rows[0]);
            }
        },
        error: function () {
            showTaxDetailsMessage('error', 'Unable to Load', 'Tax details could not be loaded.');
        },
        complete: function () {
            $('#load1').hide();
            $('#ProcessOrders_TaxSave').prop('disabled', false);
        }
    });

    return false;
}

function getTaxDetailsRequest() {
    var request = {
        OrderID: parseInt($('#ProcessOrders_TaxOrderID').val(), 10) || 0,
        Remark: $.trim($('#ProcessOrders_TaxRemark').val())
    };

    taxInstallments.forEach(function (installment) {
        taxAmountFields.concat(taxDateFields).forEach(function (field) {
            var value = $.trim($('#ProcessOrders_Tax' + installment + field).val());
            request[installment + field] =
                taxDateFields.indexOf(field) >= 0 ? taxDateForServer(value) : value;
        });
        request[installment + 'Delinquency'] =
            $('#ProcessOrders_Tax' + installment + 'Delinquency').val();
    });

    return request;
}

function validateTaxDetails(request) {
    if (!request.OrderID) {
        return 'Please select a valid order.';
    }

    if (!request.Remark) {
        $('#ProcessOrders_TaxRemark').trigger('focus');
        return 'Please enter remark.';
    }

    var datePattern = /^(0[1-9]|[12][0-9]|3[01])-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d{4}$/;
    var error = '';

    taxInstallments.some(function (installment) {
        return taxDateFields.some(function (field) {
            var value = request[installment + field];
            if (value && !datePattern.test(value)) {
                $('#ProcessOrders_Tax' + installment + field).trigger('focus');
                error = 'Please enter ' + installment.toLowerCase() + ' ' +
                    (field === 'PaidDate' ? 'paid date' : 'due date') +
                    ' in DD-MMM-YYYY format.';
                return true;
            }
            return false;
        });
    });

    return error;
}

function SaveTaxDetails() {
    var request = getTaxDetailsRequest();
    var validationMessage = validateTaxDetails(request);
    if (validationMessage) {
        showTaxDetailsMessage('warning', 'Validation', validationMessage);
        return false;
    }

    $('#load1').css('display', 'flex');
    setProcessOrderButtonBusy('#ProcessOrders_TaxSave', true, '<i class="fas fa-spinner fa-spin"></i><span>Saving...</span>');

    $.ajax({
        url: 'ProcessOrders.aspx/SaveTaxDetails',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({ request: request }),
        success: function (result) {
            var response = parseServerResponse(result);
            if (!response.Success) {
                showTaxDetailsMessage('error', 'Not Saved', response.Message || 'Tax details were not saved.');
                return;
            }

            $('#TaxDetails').modal('hide');
            resetTaxDetailsModal();
            showTaxDetailsMessage('success', 'Saved', response.Message || 'Tax details saved successfully.');
        },
        error: function () {
            showTaxDetailsMessage('error', 'Not Saved', 'An error occurred while saving tax details.');
        },
        complete: function () {
            $('#load1').hide();
            setProcessOrderButtonBusy('#ProcessOrders_TaxSave', false);
        }
    });

    return false;
}

$(document).on('hidden.bs.modal', '#TaxDetails', function () {
    resetTaxDetailsModal();
});

$(document).on('shown.bs.modal', '#TaxDetails', function () {
    initializeTaxDatePickers();
});

function CompleteOrderProcessCosting(InvoiceId, selected) {

    selectedProcessOrder = processOrdersData[selected] || null;
    if (!selectedProcessOrder) {
        showProcessOrderMessage('danger', 'Unable to find selected order details.');
        return false;
    }
    window.location.href = 'Costing.aspx?OrderID=' + encodeURIComponent(InvoiceId);
    // InvoiceID = InvoiceId;
    // fillOrderSummary('costing', selectedProcessOrder);
    // resetCostingModal();
    // $('#OrderCosting').modal('show');

    return false;
}

function CompleteOrderProcess(InvoiceId, selected) {
    selectedProcessOrder = processOrdersData[selected] || null;
    if (!selectedProcessOrder) {
        showProcessOrderMessage('danger', 'Unable to find selected order details.');
        return false;
    }

    InvoiceID = InvoiceId;
    fillOrderSummary('complete', selectedProcessOrder);
    resetCompleteOrderModal();
    loadOrderDetailsReport(getOrderValue(selectedProcessOrder, 'OrderID'));
    loadOrdersOnCurrentProcess(getOrderValue(selectedProcessOrder, 'OrderID'));
    $('#CompleteOrder').modal('show');

    return false;
}

function calculateProcessOrderCostTotal() {
    var searches = parseFloat($('#ProcessOrders_txtNoOfSearchesMade').val()) || 0;
    var cost = parseFloat(String($('#ProcessOrders_txtCostSearches').val()).replace('$', '')) || 0;
    var total = searches * cost;
    $('#ProcessOrders_Total').val(total ? total.toFixed(2) : '');
}

$(document).on('input', '#ProcessOrders_txtNoOfSearchesMade,#ProcessOrders_txtCostSearches', calculateProcessOrderCostTotal);

function OrderCosting() {
    if (!selectedProcessOrder) {
        showProcessOrderMessage('danger', 'Please select an order.');
        return false;
    }

    var searchEngineType = $('#ProcessOrders_SearchEType').val();
    var searchEngineLink = $.trim($('#ProcessOrders_SearchEnginelink').val());
    var noOfSearches = parseInt($('#ProcessOrders_txtNoOfSearchesMade').val(), 10) || 0;
    var costPerSearch = parseFloat(String($('#ProcessOrders_txtCostSearches').val()).replace('$', '')) || 0;
    var totalCost = parseFloat(String($('#ProcessOrders_Total').val()).replace('$', '')) || 0;

    if (!searchEngineType) {
        showProcessOrderMessage('warning', 'Please select search engine type.');
        return false;
    }

    if (!searchEngineLink) {
        showProcessOrderMessage('warning', 'Please enter search engine link.');
        return false;
    }

    $('#load1').show();
    setProcessOrderButtonBusy('#btnStep51', true, 'Saving...');

    $.ajax({
        url: 'ProcessOrders.aspx/AddOrderCosting',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({
            OrderID: parseInt(getOrderValue(selectedProcessOrder, 'OrderID'), 10),
            SearchEngineType: searchEngineType,
            SearchEngineLink: searchEngineLink,
            NoOfSearches: noOfSearches,
            CostPerSearch: costPerSearch,
            TotalCost: totalCost,
            Remark: $.trim($('#ProcessOrders_CostRemark').val())
        }),
        success: function (result) {
            $('#load1').hide();
            setProcessOrderButtonBusy('#btnStep51', false);

            var response = parseServerResponse(result);
            if (response.Success) {
                $('#OrderCosting').modal('hide');
                showProcessOrderMessage('success', response.Message || 'Order costing added successfully.');
                BindGrid_PendingOrders();
            } else {
                showProcessOrderMessage('danger', response.Message || 'Order costing not added.');
            }
        },
        error: function (error) {
            setProcessOrderButtonBusy('#btnStep51', false);
            processOrdersAjaxError(error, 'Error saving order costing.');
        }
    });

    return false;
}

function uploadProcessOrderAttachment(onSuccess, onError) {
    var input = document.getElementById('dashboard_attachment_upload');
    var file = input && input.files && input.files.length ? input.files[0] : null;

    if (!file) {
        onError('Please choose file.');
        return;
    }

    if (!window.FormData) {
        onError('File upload is not supported in this browser.');
        return;
    }

    var formData = new FormData();
    formData.append(input.name || 'dashboard_attachment_upload', file);

    $.ajax({
        url: window.location.pathname,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false
    }).done(function () {
        onSuccess(file.name);
    }).fail(function (error) {
        onError(error && error.responseText ? error.responseText : 'File upload failed.');
    });
}

function CompleteOrder() {
    if (!selectedProcessOrder) {
        showProcessOrderMessage('danger', 'Please select an order.');
        return false;
    }

    var remark = $.trim($('#Approval_remark').val());
    if (!remark) {
        showProcessOrderMessage('warning', 'Please enter remark.');
        return false;
    }

    var selectedTaskIds = getSelectedProcessTaskIds();
    if (!selectedTaskIds.length) {
        showProcessOrderMessage('warning', 'Please select at least one current process order.');
        return false;
    }

    var input = document.getElementById('dashboard_attachment_upload');
    var file = input && input.files && input.files.length ? input.files[0] : null;
    if (!file) {
        showProcessOrderMessage('warning', 'Please choose file.');
        return false;
    }

    $('#load1').show();
    setProcessOrderButtonBusy('#btnStep5', true, 'Submitting...');

    uploadProcessOrderAttachment(function (fileName) {
        $.ajax({
            url: 'ProcessOrders.aspx/CompleteOrder',
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({
                OrderID: parseInt(getOrderValue(selectedProcessOrder, 'OrderID'), 10),
                TaskIDs: selectedTaskIds,
                ClientOrderNo: String(getOrderValue(selectedProcessOrder, 'ClientOrderNo')),
                ProjectNumber: String(getOrderValue(selectedProcessOrder, 'ProjectNumber', 'Project')),
                ProcessName: String(getOrderValue(selectedProcessOrder, 'Process', 'ProcessName')),
                ActionStatus: $('#Approval_Status').val(),
                Remark: remark,
                AttachmentOriginalName: fileName,
                DispatchOrder: $('#ProcessOrders_DispatchOrder').is(':checked'),
                NoFeedback: $('#ProcessOrders_NoFeedback').is(':checked'),
                TaxCalling: $('#ProcessOrders_TaxCalling').is(':checked'),
                Audit: $('#ProcessOrders_Audit').is(':checked'),
                SPQA: $('#ProcessOrders_SPQA').is(':checked'),
                Offline: $('#ProcessOrders_Offline').is(':checked')
            }),
            success: function (result) {
                $('#load1').hide();
                setProcessOrderButtonBusy('#btnStep5', false);

                var response = parseServerResponse(result);
                if (response.Success) {
                    $('#CompleteOrder').modal('hide');
                    showProcessOrderMessage('success', response.Message || 'Process completed successfully.');
                    if (response.RedirectUrl) {
                        window.location.href = response.RedirectUrl;
                    } else {
                        BindGrid_PendingOrders();
                    }
                } else {
                    showProcessOrderMessage('danger', response.Message || 'Unable to complete process.');
                }
            },
            error: function (error) {
                setProcessOrderButtonBusy('#btnStep5', false);
                processOrdersAjaxError(error, 'Error completing order.');
            }
        });
    }, function (message) {
        $('#load1').hide();
        setProcessOrderButtonBusy('#btnStep5', false);
        showProcessOrderMessage('danger', message);
    });

    return false;
}
