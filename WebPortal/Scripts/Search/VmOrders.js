(function ($) {
    'use strict';

    var state = {
        currentUserId: 0,
        isPM: false,
        allocationRows: [],
        selectedOrder: null,
        documents: [],
        allocationTable: null,
        queueTable: null,
        coverageTable: null,
        importTable: null,
        queueLoaded: false,
        pendingRequests: 0,
        processOrder: null,
        statusOrder: null,
        product_Type: null
    };

    $(initialize);

    function initialize() {
        enhanceFileUploads();
        wireEvents();
        setDefaultDates();
        loadBootstrap();
    }

    function wireEvents() {
        $('#vmRefreshActive').on('click', refreshActiveTab);
        $('#vmQueueTab').on('shown.bs.tab', function () {
            if (!state.queueLoaded) loadQueue();
            else adjustTables();
        });
        $('#vmAllocationTab').on('shown.bs.tab', adjustTables);
        $('#vmOpenImport').on('click', function () {
            $('#vmImportMessage').empty();
            $('#vmImportFile').val('');
            updateImportFileName();
            $('#vmImportModal').modal('show');
        });
        $('#vmImportFile').on('change', updateImportFileName);
        $('#vmImportUpload').on('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                $('#vmImportFile').trigger('click');
            }
        });
        $('.vm-file-upload-input').on('change', function () { updateFileUpload(this); });
        $('.vm-file-upload').on('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                $(this).find('.vm-file-upload-input').trigger('click');
            }
        });
        $('#vmImportOrders').on('click', importOrders);
        $('#vmBackToAllocation').on('click', showAllocationList);
        $('#vmViewCoverage').on('click', openCoverage);
        $('#vmAllocateOrder').on('click', allocateOrder);
        $('#vmShowQueue').on('click', loadQueue);
        $('#vmExportQueue').on('click', function () {
            if (state.queueTable) state.queueTable.button('.buttons-excel').trigger();
        });
        $('#vmSaveComment').on('click', saveComment);
        $('#vmCompleteOrder').on('click', completeVendorOrder);
        $('#vmAllocateStatusOrder').on('click', updateVendorOrderStatus);
        $('#vmSubmitProcess').on('click', submitQueueProcess);
        $('#vmProcessAction').on('change', function () {
            $('#vmCancelFields').toggle($(this).val() === 'Cancel');
        });
        $('input[name="vmAllocationMode"]').on('change', toggleAllocationMode);
        $('#vmSearchCost,#vmCopyCost').on('input change blur', calculateTotal);
        $('.vm-number').on('input', function () { this.value = this.value.replace(/\D/g, ''); });
        $('.vm-money').on('focus', function () { $(this).val(stripMoney($(this).val())); })
            .on('blur', function () { $(this).val(money($(this).val())); calculateTotal(); });

        $('#vmAllocationTable').on('click', '[data-vm-select]', function () {
            openAllocation(Number($(this).attr('data-vm-select')));
        }).on('click', '[data-vm-coverage]', function () {
            state.selectedOrder = findOrder(Number($(this).attr('data-vm-coverage')));
            openCoverage();
        });

        $('#vmQueueTable').on('click', '[data-vm-detail]', function () {
            openDetail($(this).attr('data-vm-detail'), Number($(this).attr('data-order-id')));
        }).on('click', '[data-vm-process-order]', function () {
            openVendorProcess($(this).attr('data-vm-process-order'));
        }).on('click', '[data-vm-update-status]', function () {
            openVendorStatus($(this).attr('data-vm-update-status'));
        }).on('click', '[data-vm-comments]', function () {
            openComments(Number($(this).attr('data-vm-comments')));
        }).on('click', '[data-vm-process]', function () {
            if (!$(this).hasClass('disabled')) openQueueProcess(Number($(this).attr('data-vm-process')));
        });
    }

    function loadBootstrap() {
        busy(true);
        pageMethod('GetBootstrap', {}).done(function (data) {
            state.currentUserId = Number(data.CurrentUserId || 0);
            state.isPM = data.IsPM === true;
            state.allocationRows = data.AllocationOrders || [];
            bindProjects(data.Projects || []);
            bindAbstractors(data.Abstractors || []);
            bindAllocationTable(state.allocationRows);
            // if (!state.isPM) {
            //     $('#vmAllOrdersOption,#vmAllProjectsOption').hide();
            //     $('input[name="vmQueueView"][value="mine"]').prop('checked', true);
            // }
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function bindProjects(rows) {
        var select = $('#vmQueueProject').empty().append('<option value="">Select</option><option value="All">All</option>');
        $.each(rows, function (_, row) {
            var value = pick(row, 'ProjectName', 'ProjectNumber', 'Project');
            if (value) select.append($('<option/>').val(value).text(value));
        });
    }

    function bindAbstractors(rows) {
        var selects = $('#vmFullAbstractor,#vmPartialAbstractor1,#vmPartialAbstractor2');
        selects.empty().append('<option value="">Select</option>');
        $.each(rows, function (_, row) {
            var id = pick(row, 'AbstractorID', 'AbstractorId', 'ID');
            var text = pick(row, 'AbstractorCode', 'AbstractorName', 'CompanyCode');
            if (id) selects.append($('<option/>').val(id).text(text || id));
        });
    }

    function bindAllocationTable(rows) {
        var preferred = ['OrderID', 'ProjectNumber', 'ClientOrderNo', 'OrderDate', 'ProductType', 'BName', 'State', 'County', 'OnOffLine'];
        var keys = orderedKeys(rows, preferred);
        var columns = [{
            title: 'Action', data: null, orderable: false, searchable: false,
            render: function (_, type, row) {
                if (type !== 'display') return '';
                var id = orderId(row);
                return '<div class="vm-actions">' +
                    actionButton('fas fa-user-check', 'Allocate', 'data-vm-select="' + id + '"', 'vm-btn-primary') +
                    actionButton('fas fa-map-marked-alt', 'Coverage', 'data-vm-coverage="' + id + '"', 'vm-btn-light') + '</div>';
            }
        }];
        $.each(keys, function (_, key) {
            columns.push({ title: displayName(key), data: key, defaultContent: '', render: renderValue });
        });
        state.allocationTable = resetDataTable(state.allocationTable, '#vmAllocationTable', rows, columns, 'VM Orders Available For Allocation', false);
        $('#vmAllocationCount').text(rows.length + ' records');
    }

    function openAllocation(id) {

        var row = findOrder(id);
        if (!row) return;
        busy(true);
        pageMethod('GetAllocationContext', { orderId: id }).done(function (data) {
            state.selectedOrder = $.extend({}, row, data.Order || {});
            state.documents = data.Documents || [];
            renderOrderSummary(state.selectedOrder);
            renderDocumentLists(state.documents);
            resetAllocationForm();
            $('#vmAllocationList').hide();
            $('#vmAllocationEditor').show();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function showAllocationList() {
        state.selectedOrder = null;
        state.product_Type = null;
        $('#vmAllocationEditor').hide();
        $('#vmAllocationList').show();
        adjustTables();
    }

    function renderOrderSummary(row) {
        state.product_Type = pick(row, 'ProductType');

        var fields = [
            ['Project #', pick(row, 'ProjectNumber')],
            ['Product Type', state.product_Type],
            ['Client Order #', pick(row, 'ClientOrderNo', 'OrderNumber')],
            ['Borrower Name', pick(row, 'BName', 'BorrowerName')],
            ['Order Date', formatValue(pick(row, 'OrderDate'))],
            ['State', pick(row, 'State')],
            ['County', pick(row, 'County')],
            ['On/Offline Suggestion', pick(row, 'OnOffLine')]
        ];
        $('#vmOrderSummary').html($.map(fields, function (field) {
            return '<div class="vm-summary-item"><div class="vm-summary-label">' + escapeHtml(field[0]) +
                '</div><div class="vm-summary-value">' + escapeHtml(field[1]) + '</div></div>';
        }).join(''));

    }

    function renderDocumentLists(rows) {
        var html = rows.length ? $.map(rows, function (row) {
            var id = pick(row, 'ID', 'DocId', 'DocumentID');
            var text = pick(row, 'DocType', 'DocumentType', 'Name');
            return '<label><input type="checkbox" value="' + escapeAttr(id) + '" /> ' + escapeHtml(text) + '</label>';
        }).join('') : '<span class="text-muted">No documents configured.</span>';
        $('#vmPartialDocs1,#vmPartialDocs2,#vmPartialDocs3').html(html);
    }

    function resetAllocationForm() {
        $('input[name="vmAllocationMode"][value="Offline"]').prop('checked', true);
        $('#vmFullAbstractor,#vmPartialAbstractor1,#vmPartialAbstractor2').val('');
        $('#vmFullEta,#vmPartialEta1,#vmPartialEta2').val('');
        $('input[name="vmDeliveryMethod"]').prop('checked', false);
        $('#vmFullAttachment,#vmPartialAttachment').val('').trigger('change');
        $('#vmSearchCost,#vmCopyCost,#vmTotalCost').val('0.00');
        $('#vmPartialPanel input[type="checkbox"],#vmFullOfflinePanel input[type="checkbox"]').prop('checked', false);
        toggleAllocationMode();
    }

    function toggleAllocationMode() {
        var partial = $('input[name="vmAllocationMode"]:checked').val() === 'Partial';
        $('#vmFullOfflinePanel').toggle(!partial);
        $('#vmPartialPanel').toggle(partial);
    }

    function calculateTotal() {
        $('#vmTotalCost').val(money(number($('#vmSearchCost').val()) + number($('#vmCopyCost').val())));
    }

    function allocateOrder() {

        if (!state.selectedOrder) {
            notify('Select an order first.');
            return;
        }

        var mode = $('input[name="vmAllocationMode"]:checked').val();
        if (mode !== 'Offline' && mode !== 'Partial') {
            notify('Select an allocation mode.');
            return;
        }

        var form = new FormData();
        form.append('orderId', orderId(state.selectedOrder));
        form.append('mode', mode);
        form.append('searchCost', stripMoney($('#vmSearchCost').val()));
        form.append('copyCost', stripMoney($('#vmCopyCost').val()));
        form.append('total', stripMoney($('#vmTotalCost').val()));
        form.append('ProductType', state.product_Type || '');

        if (mode === 'Offline') {
            if (!$('#vmFullAbstractor').val()) {
                notify('Please select company name.');
                $('#vmFullAbstractor').focus();
                return;
            }

            form.append('abstractorId', $('#vmFullAbstractor').val());
            form.append('abstractorName', $('#vmFullAbstractor option:selected').text());
            form.append('eta', $('#vmFullEta').val());
            form.append('deliveryMethod', $('input[name="vmDeliveryMethod"]:checked').val() || '');
            appendFile(form, $('#vmFullAttachment')[0]);
        }
        else {
            var docs1 = checkedValues('#vmPartialDocs1');
            var docs2 = checkedValues('#vmPartialDocs2');
            var docs3 = checkedValues('#vmPartialDocs3');
            if (!docs1.length && !docs2.length && !docs3.length) {
                notify('Please select at least one document.');
                return;
            }
            if (docs1.length && !$('#vmPartialAbstractor1').val()) {
                notify('Please select Searcher 1.');
                $('#vmPartialAbstractor1').focus();
                return;
            }
            if (docs2.length && !$('#vmPartialAbstractor2').val()) {
                notify('Please select Searcher 2.');
                $('#vmPartialAbstractor2').focus();
                return;
            }

            form.append('abstractor1', $('#vmPartialAbstractor1').val());
            form.append('abstractor2', $('#vmPartialAbstractor2').val());
            form.append('eta1', $('#vmPartialEta1').val());
            form.append('eta2', $('#vmPartialEta2').val());
            form.append('docs1', docs1.join(','));
            form.append('docs2', docs2.join(','));
            form.append('docs3', docs3.join(','));
            appendFile(form, $('#vmPartialAttachment')[0]);
        }

        confirmAction(
            'Allocate this order?',
            'The order will be allocated to the configured abstractor and an email notification will be sent.',
            'Yes, allocate order'
        ).then(function (result) {
            if (!(result.isConfirmed || result.value)) return;

            busy(true, 'Allocating order and sending email...');
            uploadAction('allocate', form).done(function (response) {
                if (!response || !response.Success) {
                    notify(response && response.Message ? response.Message : 'Order allocation was not saved.', 'error', 'Allocation failed');
                    return;
                }
                notify(response.Message, 'success', 'Order allocated');
                showAllocationList();
                reloadAllocationOrders();
            }).fail(showAjaxError).always(function () { busy(false); });
        });
    }

    function reloadAllocationOrders() {
        pageMethod('GetBootstrap', {}).done(function (data) {
            state.allocationRows = data.AllocationOrders || [];
            bindAllocationTable(state.allocationRows);
        }).fail(showAjaxError);
    }

    function openCoverage() {
        if (!state.selectedOrder) return notify('Select an order first.');
        busy(true);
        pageMethod('GetAbstractorCoverage', { orderId: orderId(state.selectedOrder) }).done(function (rows) {
            rows = rows || [];
            var columns = dynamicColumns(rows, ['AbstractorName', 'Expiry', 'State', 'County', 'Online', 'CurrentOwner', 'TwoOwner', 'FullSearch', '[30Yr]', '[40Yr]', '[50Yr]', '[60Yr]', 'DocRequest', 'LandV', '[Update]', 'Judgment', '[Copy]']);
            state.coverageTable = resetDataTable(state.coverageTable, '#vmCoverageTable', rows, columns, 'Abstractor Coverage', false, function (row, data) {
                var expiry = parseDate(pick(data, 'Expiry'));
                if (expiry && expiry <= new Date()) $(row).addClass('table-danger');
            });
            $('#vmCoverageModal').modal('show');
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function importOrders() {
        var input = $('#vmImportFile')[0];
        if (!input.files || !input.files.length) return notify('Please choose Excel file.');
        var form = new FormData();
        form.append('file', input.files[0]);
        busy(true);
        uploadAction('import', form).done(function (result) {
            $('#vmImportMessage').attr('class', result.Success ? 'alert alert-success mt-3' : 'alert alert-warning mt-3').text(result.Message || '');
            var rows = result.Rows || [];
            var columns = dynamicColumns(rows, ['ProjectNumber', 'OrderNumber', 'OrderDate', 'ProductType', 'OnOffline', 'Abstractor', 'Status', 'Message']);
            state.importTable = resetDataTable(state.importTable, '#vmImportResultTable', rows, columns, 'VM Import Result', false);
            if (result.ReturnValue > 0) reloadAllocationOrders();
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function loadQueue() {
        var from = $('#vmQueueFromDate').val();
        var to = $('#vmQueueToDate').val();
        if (!from || !to) return notify('Please select From Date and To Date.');
        if (from > to) return notify('From Date should be less than or equal to To Date.');
        var view = $('input[name="vmQueueView"]:checked').val();
        var project = $('#vmQueueProject').val();

        if (view === 'all' && (!project || project === 'Select')) {
            $('#vmQueueProject').trigger('focus');
            return notify('Please select a project.', 'warning', 'Validation');
        }
        busy(true);
        pageMethod('GetQueueOrders', {
            // fromDate: from, toDate: to, project: project || (view === 'mine' ? 'All' : ''), view: view
            fromDate: from, toDate: to, project: project || (view === 'All' ? 'All' : ''), view: view
        }).done(function (rows) {

            rows = rows || [];
            bindQueueTable(rows);
            state.queueLoaded = true;
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function bindQueueTable(rows) {
        $.each(rows || [], function (_, row) {
            row.ClientOrderNo = pick(row, 'ClientOrderNo', 'OrderNo', 'OrderNumber', 'ClientOrderNumber');
        });
        var keys = orderedKeys(rows, ['OrderId', 'ProjectNumber', 'ClientOrderNo', 'OrderDate', 'ProductType', 'BName', 'State', 'County', 'OnOffLine', 'ProcessStatus', 'SearchBy', 'SearchDate', 'ReSearchBy', 'ReSearchDate', 'TypingBy', 'TypingDate', 'QABy', 'QADate', 'DispBy', 'DispDate', 'Remark']);
        keys = $.grep(keys, function (key) {
            return key !== 'TaskAssignedId' && key !== 'OrderNo' && key !== 'OrderNumber' && key !== 'ClientOrderNumber';
        });
        var columns = [{
            title: 'Actions', data: null, orderable: false, searchable: false,
            render: function (_, type, row) { return type === 'display' ? queueActions(row) : ''; }
        }];
        $.each(keys, function (_, key) {
            columns.push({
                title: displayName(key), data: key, defaultContent: '',
                render: function (value, type, row) {
                    if (type === 'display' && $.inArray(key, ['SearchBy', 'ReSearchBy', 'TypingBy', 'QABy', 'DispBy']) >= 0)
                        return renderProcessLink(key, value, row);
                    if (type === 'display' && key === 'Remark') return '<span class="vm-remark">' + escapeHtml(formatValue(value)) + '</span>';
                    if (type === 'display' && key === 'SalesPurchaseAmount') return money(value);
                    return renderValue(value, type);
                }
            });
        });
        state.queueTable = resetDataTable(state.queueTable, '#vmQueueTable', rows, columns, 'VM Order Queue', true, function (row, data) {
            var status = String(pick(data, 'ProcessStatus')).toLowerCase();
            if (status === 'hold') $(row).addClass('vm-row-hold');
            if (status === 'cancel') $(row).addClass('vm-row-cancel');
            if (String(pick(data, 'LegalDescription')) === '3422') $(row).addClass('vm-row-purple');
        });
        $('#vmQueueCount').text(rows.length + ' records');
    }

    function queueActions(row) {
        var id = orderId(row);
        return '<div class="vm-actions">' +
            actionButton('fas fa-play', 'Process Order', 'data-vm-process-order="' + escapeAttr(id) + '"', 'vm-action-process') +
            actionButton('fas fa-exchange-alt', 'Update Status', 'data-vm-update-status="' + escapeAttr(id) + '"', 'vm-action-status') +
            actionButton('fas fa-comment', 'Comments', 'data-vm-comments="' + id + '"', 'vm-action-comments') + '</div>';
    }

    function renderProcessLink(key, value, row) {
        var text = formatValue(value);
        if (!text) return '';
        var endField = { SearchBy: 'SearchDate', ReSearchBy: 'ReSearchDate', TypingBy: 'TypingDate', QABy: 'QADate', DispBy: 'DispDate' }[key];
        var allowed = !pick(row, endField) &&
            (Number(pick(row, 'TaskAssignedId')) === state.currentUserId || state.isPM) &&
            String(pick(row, 'ProcessStatus')) === 'In-Process';
        return '<a href="javascript:void(0)" class="vm-process-link ' + (allowed ? '' : 'disabled') +
            '" data-vm-process="' + orderId(row) + '">' + escapeHtml(text) + '</a>';
    }

    function openDetail(type, id) {
        $('#vmDetailTitle').text(type);
        $('#vmDetailContent').html('<div class="vm-empty"><i class="fas fa-spinner fa-spin mr-1"></i>Loading...</div>');
        $('#vmDetailModal').modal('show');
        pageMethod('GetQueueDetail', { orderId: id, detailType: type }).done(function (rows) {
            $('#vmDetailContent').html(detailTable(rows || [], type));
        }).fail(showAjaxError);
    }

    function openComments(id) {
        $('#vmCommentOrderId').val(id);
        $('#vmCommentText').val('');
        $('#vmCommentType').val('Select');
        $('#vmCommentModal').modal('show');
        pageMethod('GetCommentData', { orderId: id }).done(function (data) {
            bindFollowUpData(data);
        }).fail(showAjaxError);
    }

    function updateImportFileName() {
        var input = $('#vmImportFile')[0];
        var hasFile = !!(input && input.files && input.files.length);
        $('#vmImportFileName').text(hasFile ? input.files[0].name : 'Choose an Excel file');
        $('#vmImportUpload').toggleClass('is-selected', hasFile);
    }

    function enhanceFileUploads() {
        $('.vm-file').each(function () {
            var input = $(this);
            var id = input.attr('id');
            if (!id || input.parent().hasClass('vm-file-upload')) return;

            input.removeClass('vm-file w-100').addClass('vm-import-file-input vm-file-upload-input');
            input.wrap('<label class="vm-import-upload vm-file-upload" for="' + escapeAttr(id) + '" tabindex="0"></label>');
            input.after(
                '<span class="vm-import-upload-icon"><i class="fas fa-paperclip"></i></span>' +
                '<span class="vm-import-upload-copy">' +
                    '<span class="vm-import-file-name">Choose a file</span>' +
                    '<span class="vm-import-file-hint">Any required attachment format is allowed</span>' +
                '</span>' +
                '<span class="vm-import-browse">Browse</span>'
            );
            updateFileUpload(this);
        });
    }

    function updateFileUpload(input) {
        var wrapper = $(input).closest('.vm-file-upload');
        var hasFile = !!(input && input.files && input.files.length);
        var fileName = hasFile ? input.files[0].name : 'Choose a file';
        wrapper.toggleClass('is-selected', hasFile);
        wrapper.find('.vm-import-file-name').text(fileName).attr('title', fileName);
    }

    function bindFollowUpData(data) {
        data = data || {};
        $('#vmCommentOrderNo').val(data.OrderNo || '');
        $('#vmCommentOrderDate').val(data.OrderDate || '');
        $('#vmCommentVm').val(data.VM || '');
        $('#vmCommentAbstractor').val(data.Abstractor || '');
        $('#vmCommentRecordCount').text('Total No of Records: ' + Number(data.CommentCount || 0));
        $('#vmCommentsContent').html(commentHistoryTable(data.Comments || []));
    }

    function saveComment() {
        var type = $('#vmCommentType').val();
        var text = $.trim($('#vmCommentText').val());
        if (!type || type === 'Select') return notify('Please select Type.', 'warning', 'Validation');
        if (!text) return notify('Please Enter Remark.', 'warning', 'Validation');
        busy(true, 'Saving follow-up comment...');
        pageMethod('SaveComment', {
            orderId: Number($('#vmCommentOrderId').val()), type: type, comment: text
        }).done(function (data) {
            $('#vmCommentText').val('');
            $('#vmCommentType').val('Connect With Abstractor');
            bindFollowUpData(data);
            if (state.queueLoaded) loadQueue();
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function commentHistoryTable(rows) {
        var html = '<table class="vm-modal-table"><thead><tr>' +
            '<th>Sr.#</th><th>OrderNo</th><th>Type</th><th>Process</th>' +
            '<th>Remark</th><th>AddedBy</th><th>AddedDate</th></tr></thead><tbody>';
        if (!rows.length)
            return html + '<tr><td colspan="7" class="vm-comment-history-empty">No data to display</td></tr></tbody></table>';

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

    function openVendorProcess(orderId) {
        state.processOrder = null;
        $('#vmOrderProcessTaskId').val('');
        $('#vmOrderProcessProject,#vmOrderProcessOrderNo,#vmOrderProcessDate,#vmOrderProcessName,#vmOrderProcessVm,#vmOrderProcessAbstractor,#vmOrderProcessRemark').val('');
        $('#vmOrderProcessFile').val('').trigger('change');
        busy(true);
        pageMethod('GetOrderDetails', { orderId: String(orderId) }).done(function (order) {
            if (!order) return notify('Order details were not found.', 'warning', 'Validation');
            state.processOrder = order;
            $('#vmOrderProcessTaskId').val(order.TaskId || '');
            $('#vmOrderProcessProject').val(order.ProjectNumber || '');
            $('#vmOrderProcessOrderNo').val(order.OrderNo || '');
            $('#vmOrderProcessDate').val(order.OrderDate || '');
            $('#vmOrderProcessName').val(order.Process || '');
            $('#vmOrderProcessVm').val(order.VM || '');
            $('#vmOrderProcessAbstractor').val(order.Vendor || '');
            $('#vmOrderProcessModal').modal('show');
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function completeVendorOrder() {
        if (!state.processOrder) return notify('Order details are not loaded.', 'warning', 'Validation');
        var fileInput = $('#vmOrderProcessFile')[0];
        var remark = $.trim($('#vmOrderProcessRemark').val());
        if (!fileInput.files || !fileInput.files.length)
            return notify('Please select the completed file.', 'warning', 'Validation');
        if (!remark) return notify('Please enter remark.', 'warning', 'Validation');

        var file = fileInput.files[0];

        var reader = new FileReader();
        reader.onload = function (event) {
            busy(true, 'Completing order and saving attachment...');
            pageMethod('CompleteOrder', {
                request: {
                    OrderId: state.processOrder.OrderId,
                    OrderNo: state.processOrder.OrderNo,
                    ProjectNumber: state.processOrder.ProjectNumber,
                    OrderDate: state.processOrder.OrderDate,
                    Process: state.processOrder.Process,
                    VendorName: state.processOrder.Vendor,
                    Remark: remark,
                    FileName: file.name,
                    FileBase64: String(event.target.result).split(',')[1]
                }
            }).done(function (result) {
                notify(result.Message, result.Success ? 'success' : 'error', result.Success ? 'Success' : 'Error');
                if (result.Success) {
                    $('#vmOrderProcessModal').modal('hide');
                    loadQueue();
                }
            }).fail(showAjaxError).always(function () { busy(false); });
        };
        reader.onerror = function () { notify('Unable to read the selected file.', 'error', 'Error'); };
        reader.readAsDataURL(file);
    }

    function openVendorStatus(orderId) {
        state.statusOrder = null;
        $('#vmOrderStatusTaskId').val('');
        $('#vmOrderStatusProject,#vmOrderStatusOrderNo,#vmOrderStatusDate,#vmOrderStatusAbstractor,#vmOrderStatusRemark').val('');
        $('#vmOrderStatusAction').val('Re-Allocate');
        $('#vmOrderStatusVendor').empty().append('<option value="">Select</option>');
        busy(true);
        $.when(
            pageMethod('GetOrderDetails', { orderId: String(orderId) }),
            pageMethod('GetVendors', {})
        ).done(function (order, vendors) {
            if (!order) return notify('Order details were not found.', 'warning', 'Validation');
            state.statusOrder = order;
            $('#vmOrderStatusTaskId').val(order.TaskId || '');
            $('#vmOrderStatusProject').val(order.ProjectNumber || '');
            $('#vmOrderStatusOrderNo').val(order.OrderNo || '');
            $('#vmOrderStatusDate').val(order.OrderDate || '');
            $('#vmOrderStatusAbstractor').val(order.Vendor || '');
            var select = $('#vmOrderStatusVendor');
            $.each(vendors || [], function (_, vendor) {
                select.append($('<option/>').val(vendor.EmployeeID).text(vendor.FullName));
            });
            $('#vmOrderStatusModal').modal('show');
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function updateVendorOrderStatus() {
        if (!state.statusOrder) return notify('Order details are not loaded.', 'warning', 'Validation');
        var vendorId = $('#vmOrderStatusVendor').val();
        var action = $('#vmOrderStatusAction').val();
        var remark = $.trim($('#vmOrderStatusRemark').val());
        if (!action) return notify('Please select the status action.', 'warning', 'Validation');
        if (!vendorId) return notify('Please select the new vendor.', 'warning', 'Validation');
        if (!remark) return notify('Please enter remark.', 'warning', 'Validation');

        busy(true, 'Updating order status and sending email...');
        pageMethod('ChangeOrderStatus', {
            request: {
                OrderId: state.statusOrder.OrderId,
                Action: action,
                ProjectNumber: state.statusOrder.ProjectNumber,
                OrderNumber: state.statusOrder.OrderNo,
                OrderDate: state.statusOrder.OrderDate,
                Process: state.statusOrder.Process,
                VM: state.statusOrder.VM,
                CurrentVendor: state.statusOrder.Vendor,
                NewVendorId: vendorId,
                NewVendorName: $('#vmOrderStatusVendor option:selected').text(),
                Remark: remark
            }
        }).done(function (result) {
            notify(result.Message, result.Success ? 'success' : 'error', result.Success ? 'Success' : 'Error');
            if (result.Success) {
                $('#vmOrderStatusModal').modal('hide');
                loadQueue();
            }
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function openQueueProcess(id) {
        busy(true);
        pageMethod('GetQueueProcessContext', { orderId: id }).done(function (data) {
            var context = data.Context || {};
            var processId = Number(pick(context, 'Processid', 'ProcessId', 'TaskProcessid') || 0);
            if (!processId) return notify('Current process was not found for this order.');
            $('#vmProcessOrderId').val(id);
            $('#vmProcessId').val(processId);
            $('#vmProcessAssignedId').val(pick(context, 'TaskAssignedId', 'EmployeeID') || state.currentUserId);
            $('#vmProcessModal').data('context', context);
            renderProcessSummary(context);
            renderProcessTasks(data.Tasks || []);
            $('#vmProcessAction').val('Complete').trigger('change');
            $('#vmProcessRemark,#vmCancelledBy,#vmCancelReason').val('');
            $('#vmProcessFile').val('').trigger('change');
            $('#vmTaxCalling,#vmAudit,#vmOffline,#vmDispatch,#vmNoFeedback').prop('checked', false);
            $('#vmProcessModal').modal('show');
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function renderProcessSummary(context) {
        var fields = [
            ['Order No', pick(context, 'ClientOrderNo', 'OrderNumber')],
            ['Project', pick(context, 'ProjectNumber', 'Project')],
            ['Process', pick(context, 'ProcessName', 'Process')],
            ['Assigned User', pick(context, 'AssignedUser', 'EmployeeName', 'TaskAssignedTo')]
        ];
        $('#vmProcessSummary').html($.map(fields, function (item) {
            return '<div class="vm-summary-item"><div class="vm-summary-label">' + escapeHtml(item[0]) +
                '</div><div class="vm-summary-value">' + escapeHtml(formatValue(item[1])) + '</div></div>';
        }).join(''));
    }

    function renderProcessTasks(rows) {
        if (!rows.length) return $('#vmProcessTasks').html('<div class="alert alert-info">No process tasks found.</div>');
        var keys = orderedKeys(rows, ['TaskId', 'DocumentType', 'TaskStatus', 'Remark']);
        var html = '<table class="vm-modal-table"><thead><tr><th><input id="vmProcessCheckAll" type="checkbox" checked /></th>';
        $.each(keys, function (_, key) { html += '<th>' + escapeHtml(displayName(key)) + '</th>'; });
        html += '</tr></thead><tbody>';
        $.each(rows, function (_, row) {
            var id = pick(row, 'TaskId', 'TaskID', 'ID');
            html += '<tr><td><input class="vm-process-task" type="checkbox" value="' + escapeAttr(id) + '" checked /></td>';
            $.each(keys, function (_, key) { html += '<td>' + escapeHtml(formatValue(row[key])) + '</td>'; });
            html += '</tr>';
        });
        $('#vmProcessTasks').html(html + '</tbody></table>');
        $('#vmProcessCheckAll').on('change', function () { $('.vm-process-task').prop('checked', this.checked); });
    }

    function submitQueueProcess() {
        var tasks = $('.vm-process-task:checked').map(function () { return this.value; }).get();
        if (!tasks.length) return notify('Select at least one task.');
        var action = $('#vmProcessAction').val();
        if ((action === 'Hold' || action === 'Cancel') && !$.trim($('#vmProcessRemark').val())) return notify('Please enter task remark.');
        if (action === 'Cancel' && !$.trim($('#vmCancelReason').val())) return notify('Please enter cancellation reason.');
        var file = $('#vmProcessFile')[0];
        if (!file.files || !file.files.length) return notify('Please choose completion attachment.');
        var context = $('#vmProcessModal').data('context') || {};
        var form = new FormData();
        form.append('orderId', $('#vmProcessOrderId').val());
        form.append('processId', $('#vmProcessId').val());
        form.append('assignedUserId', $('#vmProcessAssignedId').val());
        form.append('taskIds', tasks.join(','));
        form.append('actionStatus', action);
        form.append('remark', $('#vmProcessRemark').val());
        form.append('cancelledBy', $('#vmCancelledBy').val());
        form.append('cancelReason', $('#vmCancelReason').val());
        form.append('taxCalling', $('#vmTaxCalling').is(':checked'));
        form.append('audit', $('#vmAudit').is(':checked'));
        form.append('offline', $('#vmOffline').is(':checked'));
        form.append('dispatch', $('#vmDispatch').is(':checked'));
        form.append('noFeedback', $('#vmNoFeedback').is(':checked'));
        form.append('clientOrderNo', pick(context, 'ClientOrderNo', 'OrderNumber'));
        form.append('projectNumber', pick(context, 'ProjectNumber', 'Project'));
        form.append('processName', pick(context, 'ProcessName', 'Process'));
        form.append('file', file.files[0]);
        busy(true);
        uploadAction('completeQueue', form).done(function (result) {
            notify(result.Message);
            if (result.Success) {
                $('#vmProcessModal').modal('hide');
                loadQueue();
            }
        }).fail(showAjaxError).always(function () { busy(false); });
    }

    function resetDataTable(instance, selector, rows, columns, title, excel, createdRow) {

        if (instance) instance.destroy();
        var table = $(selector);

        var header = table.find('thead tr').empty();
        table.find('tbody').empty();

        $.each(columns, function (_, column) { header.append($('<th/>').text(column.title || '')); });

        return table.DataTable({
            data: rows,
            columns: columns,
            destroy: true,
            processing: false,
            searching: true,
            paging: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            ordering: true,
            autoWidth: true,
            scrollX: true,
            scrollCollapse: true,
            dom: excel ? "B<'d-flex justify-content-between align-items-center flex-wrap mb-2'lf>rt<'d-flex justify-content-between align-items-center flex-wrap mt-2'ip>" : "<'d-flex justify-content-between align-items-center flex-wrap mb-2'lf>rt<'d-flex justify-content-between align-items-center flex-wrap mt-2'ip>",

            buttons: excel ? [{ extend: 'excelHtml5', title: title, className: 'buttons-excel d-none', exportOptions: { columns: ':not(:first-child)' } }] : [],

            language: { search: '', searchPlaceholder: 'Search records...', emptyTable: 'No records found', zeroRecords: 'No matching records found' },

            createdRow: createdRow,

            drawCallback: function () {
                var api = this.api();
                $(api.table().container()).find('.dataTables_paginate').toggle(api.page.info().pages > 1);
            }
        });
    }

    function dynamicColumns(rows, preferred) {
        var keys = orderedKeys(rows, preferred || []);
        return $.map(keys, function (key) {
            return { title: displayName(key), data: key, defaultContent: '', render: renderValue };
        });
    }

    function orderedKeys(rows, preferred) {
        var found = [];
        $.each(rows || [], function (_, row) {
            $.each(row, function (key) { if ($.inArray(key, found) < 0) found.push(key); });
        });
        var result = [];
        $.each(preferred || [], function (_, key) {
            if ($.inArray(key, found) >= 0 && $.inArray(key, result) < 0) result.push(key);
        });
        $.each(found, function (_, key) { if ($.inArray(key, result) < 0) result.push(key); });
        return result;
    }

    function detailTable(rows, type) {
        if (!rows.length) return '<div class="alert alert-info mb-0">No records found.</div>';
        var keys = orderedKeys(rows, []);
        var html = '<table class="vm-modal-table"><thead><tr><th>Sr. #</th>';
        $.each(keys, function (_, key) { if (key !== 'Path') html += '<th>' + escapeHtml(displayName(key)) + '</th>'; });
        if (type === 'Attachments') html += '<th>Download</th>';
        html += '</tr></thead><tbody>';
        $.each(rows, function (index, row) {
            html += '<tr><td>' + (index + 1) + '</td>';
            $.each(keys, function (_, key) { if (key !== 'Path') html += '<td>' + escapeHtml(formatValue(row[key])) + '</td>'; });
            if (type === 'Attachments') {
                var path = pick(row, 'Path');
                html += '<td>' + (path ? '<a class="vm-btn vm-btn-light vm-btn-xs" href="../Search/VMOrders.aspx?action=download&amp;path=' +
                    encodeURIComponent(path) + '"><i class="fas fa-download"></i></a>' : '') + '</td>';
            }
            html += '</tr>';
        });
        return html + '</tbody></table>';
    }

    function refreshActiveTab() {
        if ($('#vmQueueTab').hasClass('active')) loadQueue();
        else reloadAllocationOrders();
    }

    function pageMethod(method, data) {

        return $.ajax({
            type: 'POST',
            url: '../Search/VMOrders.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json'
        }).then(function (response) { return response.d; });
    }

    function uploadAction(action, form) {
        return $.ajax({
            type: 'POST',
            url: '../Search/VMOrders.aspx?action=' + encodeURIComponent(action),
            data: form,
            processData: false,
            contentType: false,
            dataType: 'json'
        });
    }

    function busy(show, message) {
        state.pendingRequests += show ? 1 : -1;
        if (state.pendingRequests < 0) state.pendingRequests = 0;
        if (show) $('#vmLoaderMessage').text(message || 'Please wait while your request is being processed...');
        $('#vmLoader').toggleClass('active', state.pendingRequests > 0);
    }

    function setDefaultDates() {
        var today = new Date();
        var text = today.getFullYear() + '-' + pad(today.getMonth() + 1) + '-' + pad(today.getDate());
        $('#vmQueueFromDate,#vmQueueToDate').val(text);
    }

    function adjustTables() {
        window.setTimeout(function () {
            $.each([state.allocationTable, state.queueTable, state.coverageTable, state.importTable], function (_, table) {
                if (table) table.columns.adjust();
            });
        }, 50);
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

    function displayName(key) {
        var map = {
            OrderID: 'Order ID', OrderId: 'Order ID', ClientOrderNo: 'Order No', OrderDate: 'Order Date',
            ProjectNumber: 'Project Number', ProductType: 'Product Type', BName: 'Borrower Name',
            OnOffLine: 'On / Offline', ProcessStatus: 'Process Status', SalesPurchaseAmount: 'Sales Price',
            SearchBy: 'Search By', SearchDate: 'Search End Date', ReSearchBy: 'Re-Search By',
            ReSearchDate: 'Re-Search End Date', TypingBy: 'Typing By', TypingDate: 'Typing End Date',
            QABy: 'QA By', QADate: 'QA End Date', DispBy: 'Dispatch By', DispDate: 'Dispatch End Date',
            '[30Yr]': '10 Year', '[40Yr]': '20 Year', '[50Yr]': '30 Year', '[60Yr]': '60 Year',
            '[Update]': 'Update Cost', '[Copy]': 'Copy'
        };
        return map[key] || String(key).replace(/[\[\]]/g, '').replace(/_/g, ' ').replace(/([a-z])([A-Z])/g, '$1 $2');
    }

    function orderId(row) { return Number(pick(row, 'OrderID', 'OrderId', 'TaskId') || 0); }
    function findOrder(id) {
        var found = null;
        $.each(state.allocationRows, function (_, row) { if (orderId(row) === id) { found = row; return false; } });
        return found;
    }
    function pick(row) {
        var names = Array.prototype.slice.call(arguments, 1);
        for (var i = 0; i < names.length; i++) {
            if (row && Object.prototype.hasOwnProperty.call(row, names[i]) && row[names[i]] != null) return row[names[i]];
        }
        return '';
    }
    function checkedValues(container) {
        return $(container + ' input[type="checkbox"]:checked').map(function () { return this.value; }).get();
    }
    function appendFile(form, input) {
        if (input && input.files && input.files.length) form.append('file', input.files[0]);
    }
    function actionButton(icon, title, attributes, style) {
        return '<button type="button" class="vm-btn ' + (style || 'vm-btn-light') + ' vm-btn-xs" title="' +
            escapeAttr(title) + '" aria-label="' + escapeAttr(title) + '" ' + attributes +
            '><i class="' + icon + '"></i></button>';
    }
    function parseDate(value) {
        if (!value) return null;
        var match = /\/Date\((\d+)\)\//.exec(String(value));
        var date = match ? new Date(Number(match[1])) : new Date(value);
        return isNaN(date.getTime()) ? null : date;
    }
    function number(value) {
        var parsed = parseFloat(stripMoney(value));
        return isNaN(parsed) ? 0 : parsed;
    }
    function stripMoney(value) { return String(value == null ? '' : value).replace(/[$,\s]/g, ''); }
    function money(value) { return number(value).toFixed(2); }
    function pad(value) { return ('0' + value).slice(-2); }
    function monthName(index) { return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index]; }
    function notify(message, icon, title) {
        var text = message || 'Unable to process request.';
        return window.Swal.fire({
            icon: icon || 'info',
            title: title || (icon === 'warning' ? 'Validation' : icon === 'error' ? 'Error' : 'Information'),
            text: text,
            confirmButtonColor: '#0f766e'
        });
    }
    function confirmAction(title, text, confirmText) {
        return window.Swal.fire({
            icon: 'question',
            title: title,
            text: text,
            showCancelButton: true,
            confirmButtonText: confirmText || 'Confirm',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#0f766e',
            cancelButtonColor: '#64748b',
            reverseButtons: true,
            focusCancel: true
        });
    }
    function showAjaxError(xhr) {
        var message = 'Unable to process request.';
        try {
            var json = xhr.responseJSON || {};
            message = json.Message || json.ExceptionMessage || (json.d && json.d.Message) || message;
        } catch (ignore) { }
        notify(message, 'error', 'Error');
    }
    function escapeHtml(value) { return $('<div/>').text(value == null ? '' : String(value)).html(); }
    function escapeAttr(value) { return escapeHtml(value).replace(/"/g, '&quot;'); }
}(jQuery));
