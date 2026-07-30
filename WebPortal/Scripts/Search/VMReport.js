(function ($) {
    'use strict';

    var state = {
        isPM: false,
        billingView: 'summary',
        billingLoaded: false,
        billingDetailsLoaded: false,
        trackingLoaded: false,
        billingTable: null,
        billingDetailsTable: null,
        trackingTable: null,
        pendingRequests: 0
    };

    var billingSummaryOrder = [
        'ProjectNumber', 'ClientOrderNo', 'OrderDateTime', 'FileNumber',
        'PropertyAddress', 'State', 'County', 'OnOffLine', 'ProductType',
        'Equity', 'AbstractorSearchCost', 'AbstractorCopyCostCostTotal',
        'AbstractorTotalCost', 'Abstractor'
    ];
    var billingDetailsOrder = [
        'ProjectNumber', 'ClientOrderNo', 'State', 'County', 'OrderDate',
        'CompletionDate', 'NoOfDocuments', 'NoOfPages', 'TaxInformation',
        'CalledTaxes', 'PropertyType', 'ProductType', 'ProcessDone',
        'ProcessStatus', 'OnOffLine', 'LegalTyping', 'ProductionRemark',
        'SearchCost', 'CopyCost'
    ];
    var trackingOrder = [
        'ProjectNumber', 'OrderNo', 'ClientOrderNo', 'OrderDate', 'OnOffLine',
        'ProductType', 'BName', 'STATE', 'State', 'County', 'ProcessStatus',
        'VM', 'Search', 'AssignedDate', 'CompletedDate', 'CompletedBy',
        'TAT', 'ETAT', 'Remark', 'SearchBy', 'SearchDate', 'ReSearchBy',
        'ReSearchDate', 'TypingBy', 'TypingDate', 'QABy', 'QADate',
        'DispBy', 'DispDate', 'LegalDescription', 'ClientIdNew',
        'CustomerType', 'OrderPriority', 'Instruction'
    ];

    $(initialize);

    function initialize() {
        setDefaultDates();
        wireEvents();
        loadBootstrap();
    }

    function wireEvents() {
        $('#vmrRefreshActive').on('click', refreshActive);
        $('#vmrTrackingTab').on('shown.bs.tab', function () {
            if (!state.trackingLoaded) loadTracking();
            else adjustTables();
        });
        $('#vmrBillingTab').on('shown.bs.tab', adjustTables);
        $('[data-billing-view]').on('click', function () {
            switchBillingView($(this).attr('data-billing-view'));
        });
        $('#vmrShowBilling').on('click', loadBilling);
        $('#vmrShowBillingDetails').on('click', loadBillingDetails);
        $('#vmrShowTracking').on('click', loadTracking);
        $('#vmrExportBilling').on('click', function () { exportTable(state.billingTable); });
        $('#vmrExportBillingDetails').on('click', function () { exportTable(state.billingDetailsTable); });
        $('#vmrExportTracking').on('click', function () { exportTable(state.trackingTable); });
        $('#vmrSaveComment').on('click', saveComment);
        $('input[name="vmrTrackingView"]').on('change', updateTrackingProjectOptions);

        $('#vmrTrackingTable').on('click', '[data-vmr-detail]', function () {
            openDetail($(this).attr('data-vmr-detail'), Number($(this).attr('data-order-id')));
        }).on('click', '[data-vmr-comments]', function () {
            openComments(Number($(this).attr('data-vmr-comments')));
        });
    }

    function loadBootstrap() {
        busy(true);
        pageMethod('GetBootstrap', {}).done(function (data) {
            state.isPM = data.IsPM === true;
            bindProjects(data.Projects || []);
            if (!state.isPM) {
                $('#vmrAllOrdersOption').hide();
                $('input[name="vmrTrackingView"][value="mine"]').prop('checked', true);
            } else {
                $('input[name="vmrTrackingView"][value="all"]').prop('checked', true);
            }
            updateTrackingProjectOptions();
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function bindProjects(rows) {
        var selectors = ['#vmrBillingProject', '#vmrBillingDetailsProject', '#vmrTrackingProject'];
        $.each(selectors, function (_, selector) {
            $(selector).empty().append('<option value="">Select</option>');
        });
        $.each(rows, function (_, row) {
            var project = pick(row, 'ProjectName', 'ProjectNumber', 'Project');
            if (!project) return;
            $.each(selectors, function (__, selector) {
                $(selector).append($('<option/>').val(project).text(project));
            });
        });
        updateTrackingProjectOptions();
    }

    function updateTrackingProjectOptions() {
        var select = $('#vmrTrackingProject');
        var showAll = $('input[name="vmrTrackingView"]:checked').val() === 'all';
        select.find('option[value="All"]').remove();
        if (!showAll) select.find('option:first').after('<option value="All">All</option>');
        if (!showAll && !select.val()) select.val('All');
        if (showAll && select.val() === 'All') select.val('');
    }

    function switchBillingView(view) {
        state.billingView = view === 'details' ? 'details' : 'summary';
        $('[data-billing-view]').removeClass('active')
            .filter('[data-billing-view="' + state.billingView + '"]').addClass('active');
        $('#vmrBillingSummaryView').toggle(state.billingView === 'summary');
        $('#vmrBillingDetailsView').toggle(state.billingView === 'details');
        setTimeout(adjustTables, 40);
    }

    function loadBilling() {
        var filters = reportFilters('#vmrBillingProject', '#vmrBillingFrom', '#vmrBillingTo');
        if (!filters) return;
        busy(true);
        pageMethod('GetBillingSummary', filters).done(function (rows) {
            rows = rows || [];
            state.billingTable = bindBillingTable(
                state.billingTable,
                '#vmrBillingTable',
                rows,
                billingSummaryOrder,
                'VM Billing Report',
                true);
            $('#vmrBillingCount').text(rows.length + ' records');
            state.billingLoaded = true;
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function loadBillingDetails() {
        var filters = reportFilters(
            '#vmrBillingDetailsProject',
            '#vmrBillingDetailsFrom',
            '#vmrBillingDetailsTo');
        if (!filters) return;
        busy(true);
        pageMethod('GetBillingDetails', filters).done(function (rows) {
            rows = rows || [];
            state.billingDetailsTable = bindBillingTable(
                state.billingDetailsTable,
                '#vmrBillingDetailsTable',
                rows,
                billingDetailsOrder,
                'VM Billing Report Details',
                false);
            $('#vmrBillingDetailsCount').text(rows.length + ' records');
            state.billingDetailsLoaded = true;
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function reportFilters(projectSelector, fromSelector, toSelector) {
        var project = $(projectSelector).val();
        var from = $(fromSelector).val();
        var to = $(toSelector).val();
        if (!project) {
            $(projectSelector).trigger('focus');
            notify('Please select a project.', 'warning', 'Validation');
            return null;
        }
        if (!from || !to) {
            notify('Please select From Date and To Date.', 'warning', 'Validation');
            return null;
        }
        if (from > to) {
            notify('From Date should be less than or equal to To Date.', 'warning', 'Validation');
            return null;
        }
        return { project: project, fromDate: from, toDate: to };
    }

    function bindBillingTable(instance, selector, rows, preferred, title, includeDownload) {
        var excluded = ['OrderId', 'OrderID', 'Attachment', 'Number'];
        var keys = orderedKeys(rows, preferred, excluded);
        var columns = [];
        if (includeDownload) {
            columns.push({
                title: 'Attached Document', data: null, orderable: false, searchable: false,
                render: function (_, type, row) {
                    if (type !== 'display') return '';
                    return downloadButton(pick(row, 'Attachment', 'Path'));
                }
            });
        }
        columns.push({
            title: 'Sr.#', data: null, orderable: false, searchable: false,
            render: function (_, type, row, meta) { return type === 'display' ? meta.row + 1 : meta.row + 1; }
        });
        $.each(keys, function (_, key) {
            columns.push({
                title: displayName(key),
                data: key,
                defaultContent: '',
                render: function (value, type) {
                    if (isMoneyKey(key) && type === 'display') return escapeHtml(money(value));
                    return renderValue(value, type);
                }
            });
        });
        return resetDataTable(instance, selector, rows, columns, title, null);
    }

    function loadTracking() {
        var from = $('#vmrTrackingFrom').val();
        var to = $('#vmrTrackingTo').val();
        var project = $('#vmrTrackingProject').val();
        var showAll = $('input[name="vmrTrackingView"]:checked').val() === 'all';
        if (!from || !to) return notify('Please select From Date and To Date.', 'warning', 'Validation');
        if (from > to) return notify('From Date should be less than or equal to To Date.', 'warning', 'Validation');
        if (showAll && (!project || project === 'All'))
            return notify('Please select a project.', 'warning', 'Validation');
        if (!project) project = 'All';

        busy(true);
        pageMethod('GetTrackingOrders', {
            fromDate: from,
            toDate: to,
            project: project,
            showAll: showAll
        }).done(function (rows) {
            rows = rows || [];
            bindTrackingTable(rows);
            $('#vmrTrackingCount').text(rows.length + ' records');
            state.trackingLoaded = true;
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function bindTrackingTable(rows) {
        var excluded = ['TaskAssignedId', 'Number'];
        var keys = orderedKeys(rows, trackingOrder, excluded);
        var columns = [{
            title: 'Actions', data: null, orderable: false, searchable: false,
            render: function (_, type, row) { return type === 'display' ? trackingActions(row) : ''; }
        }, {
            title: 'Sr.#', data: null, orderable: false, searchable: false,
            render: function (_, type, row, meta) { return meta.row + 1; }
        }];
        $.each(keys, function (_, key) {
            columns.push({
                title: displayName(key), data: key, defaultContent: '',
                render: function (value, type) {
                    if (key === 'Remark' && type === 'display')
                        return '<span class="vmr-remark">' + escapeHtml(formatValue(value)) + '</span>';
                    if (key === 'SalesPurchaseAmount' && type === 'display') return escapeHtml(money(value));
                    return renderValue(value, type);
                }
            });
        });
        state.trackingTable = resetDataTable(
            state.trackingTable,
            '#vmrTrackingTable',
            rows,
            columns,
            'VM Tracking Sheet',
            function (row, data) {
                var status = String(pick(data, 'ProcessStatus')).toLowerCase();
                if (status === 'hold') $(row).addClass('vmr-row-hold');
                if (status === 'cancel') $(row).addClass('vmr-row-cancel');
                if (String(pick(data, 'LegalDescription')) === '3422')
                    $(row).addClass('vmr-row-purple');
            });
    }

    function trackingActions(row) {
        var id = orderId(row);
        return '<div class="vmr-actions">' +
            actionButton('fas fa-paperclip', 'Attachments',
                'data-vmr-detail="Attachments" data-order-id="' + id + '"', 'vmr-action-attachment') +
            actionButton('fas fa-comment', 'Comments',
                'data-vmr-comments="' + id + '"', 'vmr-action-comment') +
            actionButton('fas fa-comments', 'Feedback',
                'data-vmr-detail="Feedback" data-order-id="' + id + '"', 'vmr-action-feedback') +
            '</div>';
    }

    function openDetail(type, orderIdValue) {
        $('#vmrDetailTitle').text(type);
        $('#vmrDetailContent').html('<div class="vmr-empty"><i class="fas fa-spinner fa-spin mr-1"></i>Loading...</div>');
        $('#vmrDetailModal').modal('show');
        pageMethod('GetTrackingDetail', {
            orderId: orderIdValue,
            detailType: type
        }).done(function (rows) {
            $('#vmrDetailContent').html(detailTable(rows || [], type, orderIdValue));
        }).fail(showAjaxError);
    }

    function openComments(orderIdValue) {
        $('#vmrCommentOrderId').val(orderIdValue);
        $('#vmrCommentText').val('');
        $('#vmrCommentType').val('Select');
        $('#vmrCommentModal').modal('show');
        pageMethod('GetCommentData', { orderId: orderIdValue }).done(function (data) {
            $('#vmrCommentOrderNo').val(data.OrderNo || '');
            $('#vmrCommentOrderDate').val(data.OrderDate || '');
            $('#vmrCommentVm').val(data.VM || '');
            $('#vmrCommentAbstractor').val(data.Abstractor || '');
            $('#vmrCommentsContent').html(commentHistoryTable(data.Comments || []));
        }).fail(showAjaxError);
    }

    function saveComment() {
        var type = $('#vmrCommentType').val();
        var comment = $.trim($('#vmrCommentText').val());
        if (!type || type === 'Select') return notify('Please select Type.', 'warning', 'Validation');
        if (!comment) return notify('Please Enter Remark.', 'warning', 'Validation');

        busy(true);
        pageMethod('SaveComment', {
            orderId: Number($('#vmrCommentOrderId').val()),
            type: type,
            comment: comment
        }).done(function (rows) {
            $('#vmrCommentText').val('');
            $('#vmrCommentType').val('Connect With Abstractor');
            $('#vmrCommentsContent').html(commentHistoryTable(rows || []));
            if (state.trackingLoaded) loadTracking();
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function resetDataTable(instance, selector, rows, columns, title, createdRow) {
        if (instance) instance.destroy();
        var table = $(selector);
        var header = table.find('thead tr').empty();
        table.find('tbody').empty();
        $.each(columns, function (_, column) { header.append($('<th/>').text(column.title)); });
        var config = {
            data: rows,
            columns: columns,
            processing: false,
            deferRender: true,
            paging: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, 'All']],
            searching: true,
            ordering: true,
            info: true,
            autoWidth: false,
            scrollX: true,
            scrollCollapse: true,
            dom: 'lBfrtip',
            buttons: [{
                extend: 'excelHtml5',
                title: title,
                className: 'buttons-excel',
                exportOptions: { columns: ':visible' }
            }],
            language: {
                search: '',
                searchPlaceholder: 'Search records...',
                emptyTable: 'No records found.'
            },
            initComplete: function () { $(this.api().buttons().container()).hide(); }
        };
        if (createdRow) config.createdRow = createdRow;
        return table.DataTable(config);
    }

    function detailTable(rows, type, orderIdValue) {
        if (String(type).toLowerCase() === 'attachments')
            return attachmentTable(rows, orderIdValue);

        var keys = orderedKeys(rows, [], ['Path']);
        var html = '<table class="vmr-modal-table"><thead><tr><th>Sr.#</th>';
        $.each(keys, function (_, key) { html += '<th>' + escapeHtml(displayName(key)) + '</th>'; });
        html += '</tr></thead><tbody>';
        if (!rows.length)
            return html + '<tr><td colspan="' + (keys.length + 1) +
                '" class="vmr-empty">No data to display</td></tr></tbody></table>';
        $.each(rows, function (index, row) {
            html += '<tr><td>' + (index + 1) + '</td>';
            $.each(keys, function (_, key) {
                html += '<td>' + escapeHtml(formatValue(row[key])) + '</td>';
            });
            html += '</tr>';
        });
        return html + '</tbody></table>';
    }

    function attachmentTable(rows, orderIdValue) {
        var html = '<table class="vmr-modal-table"><thead><tr>' +
            '<th>Sr.#</th><th>Order No</th><th>Status</th><th>Process</th>' +
            '<th>Remark</th><th>Attached</th><th>Added By</th><th>Added Date</th>' +
            '</tr></thead><tbody>';

        if (!rows.length)
            return html + '<tr><td colspan="8" class="vmr-empty">No data to display</td></tr></tbody></table>';

        $.each(rows, function (index, row) {
            html += '<tr>' +
                '<td>' + (index + 1) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'ClientOrderNo', 'OrderNo'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Status'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Process', 'ProcessName'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Remark'))) + '</td>' +
                '<td>' + trackingAttachmentDownloadButton(orderIdValue, index) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'AddedBy', 'Code'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'AddedDate'))) + '</td>' +
                '</tr>';
        });
        return html + '</tbody></table>';
    }

    function trackingAttachmentDownloadButton(orderIdValue, attachmentIndex) {
        return '<a class="vmr-btn vmr-btn-light vmr-btn-xs" title="Download attachment" ' +
            'href="../Search/VMReport.aspx?action=download&amp;orderId=' +
            encodeURIComponent(orderIdValue) + '&amp;attachmentIndex=' +
            encodeURIComponent(attachmentIndex) + '">' +
            '<i class="fas fa-download mr-1"></i>Download</a>';
    }

    function commentHistoryTable(rows) {
        var html = '<table class="vmr-modal-table"><thead><tr>' +
            '<th>Sr.#</th><th>OrderNo</th><th>Type</th><th>Process</th>' +
            '<th>Remark</th><th>AddedBy</th><th>AddedDate</th></tr></thead><tbody>';
        if (!rows.length)
            return html + '<tr><td colspan="7" class="vmr-empty">No data to display</td></tr></tbody></table>';
        $.each(rows, function (index, row) {
            html += '<tr><td>' + (index + 1) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'ClientOrderNo', 'OrderNo'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Type'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'ProcessName', 'Process'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Comment', 'Remark'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'Code', 'AddedBy'))) + '</td>' +
                '<td>' + escapeHtml(formatValue(pick(row, 'AddedDate'))) + '</td></tr>';
        });
        return html + '</tbody></table>';
    }

    function orderedKeys(rows, preferred, excluded) {
        var found = [];
        $.each(rows || [], function (_, row) {
            $.each(row, function (key) {
                if ($.inArray(key, found) < 0 && $.inArray(key, excluded || []) < 0) found.push(key);
            });
        });
        var result = [];
        $.each(preferred || [], function (_, key) {
            if ($.inArray(key, found) >= 0 && $.inArray(key, result) < 0) result.push(key);
        });
        $.each(found, function (_, key) {
            if ($.inArray(key, result) < 0) result.push(key);
        });
        return result;
    }

    function downloadButton(path) {
        if (!path) return '<span class="text-muted">-</span>';
        return '<a class="vmr-download-icon" title="Download attached document" aria-label="Download attached document" href="../Search/VMReport.aspx?action=download&amp;path=' +
            encodeURIComponent(path) + '"><i class="fas fa-cloud-download-alt"></i><span class="sr-only">Download</span></a>';
    }

    function actionButton(icon, title, attributes, style) {
        return '<button type="button" class="vmr-btn vmr-btn-xs ' + style + '" title="' +
            escapeAttr(title) + '" aria-label="' + escapeAttr(title) + '" ' + attributes +
            '><i class="' + icon + '"></i></button>';
    }

    function displayName(key) {
        var map = {
            OrderID: 'Order ID', OrderId: 'Order ID', ProjectNumber: 'Project Number',
            ClientOrderNo: 'Order No', OrderNo: 'Order No', OrderDateTime: 'Order Date/Time',
            OrderDate: 'Order Date', PropertyAddress: 'Property Address',
            OnOffLine: 'Online / Offline', ProductType: 'Product Type',
            AbstractorSearchCost: 'Search Cost',
            AbstractorCopyCostCostTotal: 'Copy Cost',
            AbstractorTotalCost: 'Total Cost', NoOfDocuments: 'No. of Documents Provided to Client',
            NoOfPages: 'No. of Pages', TaxInformation: 'Tax Information Provided',
            CalledTaxes: 'Taxes Calling (Y/N)', ProcessDone: 'Process Done',
            ProcessStatus: 'Status', LegalTyping: 'Legal Typing',
            ProductionRemark: 'Remarks from Production',
            SearchCost: 'Abstractor Search Cost', CopyCost: 'Abstractor Copy Cost',
            BName: 'Borrower Name', STATE: 'State', AssignedDate: 'Assigned',
            CompletedDate: 'Completed', CompletedBy: 'Completed By',
            ReSearchBy: 'Re-Search By', ReSearchDate: 'Re-Search End Date',
            SearchDate: 'Search End Date', TypingDate: 'Typing End Date',
            QADate: 'QA End Date', DispBy: 'Dispatch By', DispDate: 'Dispatch End Date',
            ClientIdNew: 'Client ID', CustomerType: 'Customer Type',
            OrderPriority: 'Order Priority', LegalDescription: 'Legal Description'
        };
        return map[key] || String(key).replace(/[\[\]]/g, '').replace(/_/g, ' ')
            .replace(/([a-z])([A-Z])/g, '$1 $2');
    }

    function isMoneyKey(key) {
        return $.inArray(key, [
            'AbstractorSearchCost', 'AbstractorCopyCostCostTotal',
            'AbstractorTotalCost', 'SearchCost', 'CopyCost', 'SalesPurchaseAmount'
        ]) >= 0;
    }

    function renderValue(value, type) {
        if (type === 'display') return escapeHtml(formatValue(value));
        return value == null ? '' : value;
    }

    function formatValue(value) {
        if (value == null) return '';
        var text = String(value);
        var match = /\/Date\((\d+)\)\//.exec(text);
        if (match) {
            var date = new Date(Number(match[1]));
            return pad(date.getDate()) + '-' + monthName(date.getMonth()) + '-' + date.getFullYear();
        }
        return text;
    }

    function money(value) {
        var parsed = parseFloat(String(value == null ? '' : value).replace(/[$,\s]/g, ''));
        return isNaN(parsed) ? formatValue(value) : '$' + parsed.toFixed(2);
    }

    function pick(row) {
        for (var i = 1; i < arguments.length; i++) {
            var name = arguments[i];
            if (row && Object.prototype.hasOwnProperty.call(row, name)) return row[name];
        }
        return '';
    }

    function orderId(row) {
        return Number(pick(row, 'OrderId', 'OrderID', 'TaskId') || 0);
    }

    function exportTable(table) {
        if (table) table.button('.buttons-excel').trigger();
        else notify('Please load the report before exporting.', 'warning', 'Validation');
    }

    function refreshActive() {
        if ($('#vmrTrackingTab').hasClass('active')) loadTracking();
        else if (state.billingView === 'details') loadBillingDetails();
        else loadBilling();
    }

    function adjustTables() {
        setTimeout(function () {
            $.each([state.billingTable, state.billingDetailsTable, state.trackingTable], function (_, table) {
                if (table) table.columns.adjust();
            });
        }, 50);
    }

    function setDefaultDates() {
        var now = new Date();
        var value = now.getFullYear() + '-' + pad(now.getMonth() + 1) + '-' + pad(now.getDate());
        $('#vmrBillingFrom,#vmrBillingTo,#vmrBillingDetailsFrom,#vmrBillingDetailsTo,#vmrTrackingFrom,#vmrTrackingTo')
            .val(value).attr('max', value);
    }

    function pageMethod(method, data) {
        return $.ajax({
            type: 'POST',
            url: '../Search/VMReport.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json'
        }).then(function (response) { return response.d; });
    }

    function busy(show) {
        state.pendingRequests += show ? 1 : -1;
        if (state.pendingRequests < 0) state.pendingRequests = 0;
        $('#vmrLoader').toggleClass('active', state.pendingRequests > 0);
    }

    function notify(message, icon, title) {
        var text = message || 'Unable to process request.';
        if (window.Swal && typeof window.Swal.fire === 'function') {
            return window.Swal.fire({
                icon: icon || 'info',
                title: title || (icon === 'warning' ? 'Validation' : icon === 'error' ? 'Error' : 'Information'),
                text: text,
                confirmButtonColor: '#0f766e'
            });
        }
        return window.alert(text);
    }

    function showAjaxError(xhr) {
        var message = 'Unable to process request.';
        try {
            var json = xhr.responseJSON || {};
            message = json.Message || json.ExceptionMessage || (json.d && json.d.Message) || message;
        } catch (ignore) { }
        notify(message, 'error', 'Error');
    }

    function pad(value) { return ('0' + value).slice(-2); }
    function monthName(index) {
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index];
    }
    function escapeHtml(value) {
        return $('<div/>').text(value == null ? '' : String(value)).html();
    }
    function escapeAttr(value) {
        return escapeHtml(value).replace(/"/g, '&quot;');
    }
}(jQuery));
