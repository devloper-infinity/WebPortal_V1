var ProcessOrders_html;
var InvoiceID;
var invrec_SearchProcess;
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
    $('#' + prefix + 'OrderNo').html('<b>OrderNo # Production Cost Information Detail: </b>' + htmlEncode(getOrderValue(order, 'ClientOrderNo')));
    $('#' + prefix + 'Process').html('<b>Process : </b>' + htmlEncode(getOrderValue(order, 'Process', 'ProcessName')));
    $('#' + prefix + 'Online').html('<b>OnOffline : </b>' + htmlEncode(getOrderValue(order, 'OnOffLine')));
}

function resetCompleteOrderModal() {
    $('#Approval_Status').val('Complete');
    $('#Approval_remark').val('');
    $('#dashboard_attachment_upload').val('');
    $('#ProcessOrders_DispatchOrder,#ProcessOrders_NoFeedback,#ProcessOrders_TaxCalling,#ProcessOrders_Audit,#ProcessOrders_Offline').prop('checked', false);
}

function resetCostingModal() {
    $('#ProcessOrders_SearchEType').val('');
    $('#ProcessOrders_SearchEnginelink').val('');
    $('#ProcessOrders_txtNoOfSearchesMade').val('');
    $('#ProcessOrders_txtCostSearches').val('');
    $('#ProcessOrders_Total').val('');
    $('#ProcessOrders_CostRemark').val('');
}

function CompleteOrderProcessCosting(InvoiceId, selected) {

    selectedProcessOrder = processOrdersData[selected] || null;
    if (!selectedProcessOrder) {
        showProcessOrderMessage('danger', 'Unable to find selected order details.');
        return false;
    }

    InvoiceID = InvoiceId;
    fillOrderSummary('costing', selectedProcessOrder);
    resetCostingModal();
    $('#OrderCosting').modal('show');



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
