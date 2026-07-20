(function (window, $) {
    'use strict';

    function encode(value) {
        return $('<div>').text(value == null ? '' : value).html();
    }

    function dateValue(value) {
        if (!value) return '';
        var ms = /\/Date\((\d+)/.exec(String(value));
        var d = ms ? new Date(+ms[1]) : new Date(value);
        if (isNaN(d.getTime())) return String(value).substring(0, 10);
        function two(n) { return n < 10 ? '0' + n : String(n); }
        return d.getFullYear() + '-' + two(d.getMonth() + 1) + '-' + two(d.getDate());
    }

    function displayValue(value) {
        if (value == null) return '';
        if (typeof value === 'string' && (/^\/Date\(/.test(value) || /^\d{4}-\d{2}-\d{2}T/.test(value))) return dateValue(value);
        if (typeof value === 'boolean') return value ? 'Yes' : 'No';
        return value;
    }

    function message(text, type) {
        var box = $('#asset-message');
        if (!box.length) box = $('<div id="asset-message" class="asset-message" role="alert"/>').prependTo('.asset-page');
        box.removeClass('success error').addClass(type || 'success').text(text).stop(true, true).fadeIn();
        window.setTimeout(function () { box.fadeOut(); }, 4500);
    }

    function errorText(xhr) {
        var json = xhr && xhr.responseJSON;
        return (json && (json.Message || (json.ExceptionMessage))) || (xhr && xhr.statusText) || 'The request could not be completed.';
    }

    function actionMeta(action) {
        var name = String(action.text || '').toLowerCase();
        if (name.indexOf('view') >= 0) return { icon: 'fa-eye', style: 'info' };
        if (name.indexOf('edit') >= 0) return { icon: 'fa-pen', style: 'primary' };
        if (name.indexOf('print') >= 0) return { icon: 'fa-print', style: 'secondary' };
        if (name.indexOf('download') >= 0 || name.indexOf('pdf') >= 0) return { icon: 'fa-file-pdf', style: 'danger' };
        if (name.indexOf('approve') >= 0 || name === 'select') return { icon: 'fa-check', style: 'success' };
        if (name.indexOf('complete') >= 0) return { icon: 'fa-check-circle', style: 'success' };
        if (name.indexOf('receive') >= 0) return { icon: 'fa-box-open', style: 'success' };
        if (name.indexOf('dispatch') >= 0) return { icon: 'fa-shipping-fast', style: 'warning' };
        if (name.indexOf('return') >= 0) return { icon: 'fa-undo', style: 'warning' };
        if (name.indexOf('delete') >= 0 || name.indexOf('reject') >= 0) return { icon: 'fa-times', style: 'danger' };
        return { icon: 'fa-ellipsis-h', style: 'secondary' };
    }

    function statusClass(value) {
        var text = String(value == null ? '' : value).toLowerCase();
        if (/active|available|approved|completed|received|selected|success|yes|good/.test(text)) return 'success';
        if (/pending|open|requested|submitted|dispatch|progress|warning|fair/.test(text)) return 'warning';
        if (/reject|inactive|cancel|damage|failed|expired|no/.test(text)) return 'danger';
        return 'neutral';
    }

    function tableValue(row, column) {
        var value = displayValue(row[column.data]);
        var title = String(column.title || '').toLowerCase();
        if (/status|approval|active|selected|condition/.test(title) && value !== '') {
            return '<span class="asset-status asset-status-' + statusClass(value) + '">' + encode(value) + '</span>';
        }
        if (/value|cost|amount|price|total|recovery/.test(title) && value !== '' && !isNaN(value)) {
            return '<span class="asset-money">' + encode(Number(value).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })) + '</span>';
        }
        return encode(value);
    }

    var AssetUI = {
        post: function (url, data, ok) {
            if (/\/Save$/.test(url)) {
                var invalid = null;
                $('.asset-page label.required').each(function () {
                    var field = $(this).closest('.form-group').find('input,select,textarea').first();
                    field.removeClass('is-invalid');
                    if (!invalid && field.length && $.trim(field.val() || '') === '') invalid = field.addClass('is-invalid');
                });
                if (invalid) {
                    message('Please complete all required fields.', 'error');
                    invalid.focus();
                    return $.Deferred().reject().promise();
                }
            }
            $('.asset-page').addClass('is-loading');
            return $.ajax({
                url: url,
                type: 'POST',
                data: JSON.stringify(data || {}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json'
            }).done(function (response) {
                var result = response.d;
                if (result && result.Success === false) {
                    message(result.Message || 'The operation failed.', 'error');
                    return;
                }
                if (result && result.Success === true && result.Message) message(result.Message, 'success');
                if (ok) ok(result && result.Data !== undefined ? result.Data : result);
            }).fail(function (xhr) {
                message(errorText(xhr), 'error');
            }).always(function () {
                $('.asset-page').removeClass('is-loading');
            });
        },

        fill: function (selector, rows, value, text, blank) {
            var element = $(selector).empty();
            if (blank !== false) element.append($('<option>').val('').text('-- Select --'));
            $.each(rows || [], function (_, row) {
                element.append($('<option>').val(row[value]).text(row[text]));
            });
        },

        table: function (selector, rows, columns, actions) {
            rows = rows || [];
            var table = $(selector);
            if ($.fn.DataTable && $.fn.DataTable.isDataTable(selector)) table.DataTable().destroy();
            var html = '<thead><tr>';
            $.each(columns, function (_, column) { html += '<th>' + encode(column.title) + '</th>'; });
            if (actions && actions.length) html += '<th>Actions</th>';
            html += '</tr></thead><tbody>';
            $.each(rows, function (rowIndex, row) {
                html += '<tr>';
                $.each(columns, function (_, column) { html += '<td>' + tableValue(row, column) + '</td>'; });
                if (actions && actions.length) {
                    html += '<td class="asset-actions">';
                    $.each(actions, function (actionIndex, action) {
                        var meta = actionMeta(action);
                        var enabled = typeof action.enabled === 'function' ? action.enabled(row) : action.enabled !== false;
                        html += '<button type="button" data-row="' + rowIndex + '" data-action="' + actionIndex + '" data-disabled="' + (enabled ? '0' : '1') + '" class="asset-action asset-action-' + meta.style + (enabled ? '' : ' is-disabled') + '" title="' + encode(enabled ? action.text : (action.disabledMessage || action.text)) + '" aria-label="' + encode(action.text) + '" aria-disabled="' + (enabled ? 'false' : 'true') + '" data-toggle="tooltip"><i class="fas ' + meta.icon + '" aria-hidden="true"></i><span class="sr-only">' + encode(action.text) + '</span></button>';
                    });
                    html += '</td>';
                }
                html += '</tr>';
            });
            html += '</tbody>';
            table.html(html).off('click.assetActions').on('click.assetActions', 'button[data-action]', function () {
                var button = $(this), action = actions[+button.attr('data-action')], row = rows[+button.attr('data-row')];
                if (button.attr('data-disabled') === '1') { message(action.disabledMessage || 'This action is not currently available.', 'error'); return; }
                var handler = window[action.fn];
                var actionId = row[action.id || 'ID'];
                if (actionId == null || actionId === '') { message('This record does not contain the identifier required for that action.', 'error'); return; }
                if (typeof handler === 'function') handler(actionId, row);
            });
            if ($.fn.DataTable) {
                var options = { scrollX: true, responsive: false, pageLength: 25, order: [], autoWidth: false };
                if ($.fn.dataTable.Buttons) { options.dom = 'Bfrtip'; options.buttons = [{ extend: 'excelHtml5', className: 'd-none', title: $('.asset-hero h2').text() || 'Assets' }]; }
                table.DataTable(options);
            }
            if ($.fn.tooltip) table.find('[data-toggle="tooltip"]').tooltip({ container: 'body', trigger: 'hover' });
        },

        downloadPurchaseOrder: function (id) {
            if (!id) return;
            if (!window.pdfMake) { message('PDF component is not available. Please refresh the page.', 'error'); return; }
            AssetUI.post('PurchaseOrder.aspx/Get', { id: id }, function (sets) {
                var header = sets && sets[0] && sets[0][0];
                var items = sets && sets[1] || [];
                var terms = sets && sets[2] || [];
                if (!header) { message('Purchase order was not found.', 'error'); return; }
                function text(value) { return value == null ? '' : String(displayValue(value)); }
                function money(value) { return (Number(value) || 0).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
                function line(label, value) { return [{ text: label, bold: true, color: '#1f3c88' }, text(value)]; }
                var currency = text(header.CurrencyCode) || 'INR';
                var body = [[
                    { text: '#', bold: true }, { text: 'Description', bold: true }, { text: 'Qty', bold: true, alignment: 'right' },
                    { text: 'Unit Price', bold: true, alignment: 'right' }, { text: 'Discount', bold: true, alignment: 'right' },
                    { text: 'Tax %', bold: true, alignment: 'right' }, { text: 'Amount', bold: true, alignment: 'right' }
                ]];
                $.each(items, function (index, item) {
                    body.push([text(index + 1), text(item.ItemDescription), { text: text(item.OrderedQuantity), alignment: 'right' },
                        { text: money(item.UnitPrice), alignment: 'right' }, { text: money(item.DiscountAmount), alignment: 'right' },
                        { text: money(item.TaxPercentage), alignment: 'right' }, { text: money(item.TotalAmount), alignment: 'right' }]);
                });
                var content = [
                    { text: 'INFINITY IPS', style: 'company' },
                    { text: 'PURCHASE ORDER', style: 'title' },
                    { columns: [[line('PO Number', header.PurchaseOrderNumber), line('PO Date', dateValue(header.PurchaseOrderDate)), line('Status', header.Status)],
                                [line('Vendor', header.VendorName || header.VendorID), line('Delivery Branch', header.BranchName || header.BranchID), line('Expected Delivery', dateValue(header.ExpectedDeliveryDate))]], margin: [0, 8, 0, 14] },
                    { columns: [[{ text: 'Billing Address', bold: true }, { text: text(header.BillingAddress) || '-' }],
                                [{ text: 'Shipping Address', bold: true }, { text: text(header.ShippingAddress) || '-' }]], columnGap: 24, margin: [0, 0, 0, 14] },
                    { table: { headerRows: 1, widths: [22, '*', 35, 60, 55, 40, 65], body: body }, layout: 'lightHorizontalLines' },
                    { table: { widths: ['*', 95], body: [
                        [{ text: 'Subtotal', alignment: 'right' }, { text: currency + ' ' + money(header.SubTotal), alignment: 'right' }],
                        [{ text: 'Discount', alignment: 'right' }, { text: currency + ' ' + money(header.DiscountAmount), alignment: 'right' }],
                        [{ text: 'Tax', alignment: 'right' }, { text: currency + ' ' + money(header.TaxAmount), alignment: 'right' }],
                        [{ text: 'Freight / Other', alignment: 'right' }, { text: currency + ' ' + money((Number(header.FreightCharges) || 0) + (Number(header.OtherCharges) || 0)), alignment: 'right' }],
                        [{ text: 'Grand Total', bold: true, alignment: 'right' }, { text: currency + ' ' + money(header.GrandTotal), bold: true, alignment: 'right' }]
                    ] }, layout: 'noBorders', margin: [280, 12, 0, 14] },
                    { text: 'Payment Terms', bold: true, color: '#1f3c88' }, { text: text(header.PaymentTerms) || '-', margin: [0, 2, 0, 10] }
                ];
                if (terms.length) {
                    content.push({ text: 'Terms and Conditions', bold: true, color: '#1f3c88' });
                    content.push({ ol: $.map(terms, function (term) { return text(term.TermDescription); }), margin: [0, 4, 0, 12] });
                }
                content.push({ columns: [{ text: 'Prepared By', margin: [0, 28, 0, 0] }, { text: 'Authorized Signatory', alignment: 'right', margin: [0, 28, 0, 0] }] });
                var definition = { pageSize: 'A4', pageMargins: [34, 35, 34, 38], content: content, defaultStyle: { fontSize: 9, color: '#263238' }, styles: { company: { fontSize: 15, bold: true, color: '#1f3c88', alignment: 'center' }, title: { fontSize: 18, bold: true, alignment: 'center', margin: [0, 4, 0, 10] } }, footer: function (page, pages) { return { text: 'Page ' + page + ' of ' + pages, alignment: 'center', fontSize: 8, color: '#777' }; } };
                var fileName = ('PO-' + text(header.PurchaseOrderNumber || id)).replace(/[^a-z0-9_.-]+/gi, '-') + '.pdf';
                window.pdfMake.createPdf(definition).download(fileName);
            });
        },
        val: function (id) { return $(id).val(); },
        num: function (id) { var value = $(id).val(); return value === '' || value == null ? null : +value; },
        query: function (name) { return new URLSearchParams(window.location.search).get(name); },
        date: dateValue,
        escape: encode,
        clear: function (scope) {
            var root = $(scope || '.entry-form');
            root.find('input:not([type=checkbox]),textarea').val('');
            root.find('select').val('');
            root.find('input[type=checkbox]').prop('checked', false);
        },
        message: message
    };

    window.AssetUI = AssetUI;

    var editConfigs = {
        'AddAsset.aspx': {
            fields: { AssetID: 'assetId', AssetCode: 'assetCode', AssetTagNumber: 'tag', SerialNumber: 'serial', Barcode: 'barcode', QRCode: 'qr', IMEINumber: 'imei', HostName: 'host', AssetCategoryID: 'category', AssetTypeID: 'type', AssetBrandID: 'brand', AssetModelID: 'model', CurrentBranchID: 'branch', AssetStatusID: 'status', AssetCondition: 'condition', VendorID: 'vendor', PurchaseDate: 'purchaseDate', PurchaseValue: 'purchaseValue', InvoiceNumber: 'invoice', InvoiceDate: 'invoiceDate', WarrantyStartDate: 'warrantyStart', WarrantyEndDate: 'warrantyEnd', Processor: 'processor', RAM: 'ram', Storage: 'storage', OperatingSystem: 'os', IPAddress: 'ip', MACAddress: 'mac', Accessories: 'accessories', AssetDescription: 'description', Remarks: 'remarks' }
        },
        'AssetDisposal.aspx': {
            fields: { DisposalID: 'did', AssetID: 'asset', DisposalRequestDate: 'date', DisposalReasonID: 'reason', ProposedDisposalMethod: 'method', CurrentBookValue: 'bookValue', SaleValue: 'saleValue', BuyerName: 'buyer', ScrapVendor: 'scrapVendor', Remarks: 'remarks' }
        },
        'AssetMaintenance.aspx': {
            fields: { MaintenanceID: 'mid', AssetID: 'asset', ComplaintDate: 'date', ProblemDescription: 'problem', Priority: 'priority', AssignedTo: 'assigned', VendorID: 'vendor', ExpectedCompletionDate: 'expected', Diagnosis: 'diagnosis', RepairAction: 'action', PartsReplaced: 'parts', RepairCost: 'repairCost', ServiceCharge: 'serviceCharge', WarrantyClaimed: 'warranty', Remarks: 'remarks' }
        },
        'AssetPurchaseRequest.aspx': {
            fields: { PurchaseRequestID: 'prId', RequestNumber: 'number', RequestDate: 'date', RequestedBy: 'requester', BranchID: 'branch', Priority: 'priority', RequiredByDate: 'requiredDate', BusinessJustification: 'justification', Remarks: 'remarks' },
            items: { table: 'items', add: 'addItem', fields: { AssetCategoryID: 'i-category', AssetTypeID: 'i-type', PreferredBrandID: 'i-brand', ItemDescription: 'i-description', TechnicalSpecification: 'i-spec', RequiredQuantity: 'i-qty', EstimatedUnitCost: 'i-cost', Remarks: 'i-remarks' } }
        },
        'AssetReceipt.aspx': {
            fields: { ReceiptID: 'rid', ReceiptNumber: 'rnumber', PurchaseOrderID: 'po', VendorID: 'vendor', BranchID: 'branch', ReceiptDate: 'rdate', InvoiceNumber: 'invoice', InvoiceDate: 'invoiceDate', DeliveryChallanNumber: 'challan', Remarks: 'remarks' },
            items: { table: 'items', add: 'addItem', fields: { PurchaseOrderItemID: 'i-poitem', OrderedQuantity: 'i-ordered', PreviouslyReceivedQuantity: 'i-previous', CurrentReceivedQuantity: 'i-current', RejectedQuantity: 'i-rejected', ConditionOnReceipt: 'i-condition', SerialNumbers: 'i-serials', Remarks: 'i-remarks' } }
        },
        'PurchaseOrder.aspx': {
            fields: { PurchaseOrderID: 'poid', PurchaseOrderNumber: 'ponumber', PurchaseOrderDate: 'podate', VendorID: 'vendor', QuotationID: 'quotation', PurchaseRequestID: 'request', BranchID: 'branch', BillingAddress: 'billing', ShippingAddress: 'shipping', ExpectedDeliveryDate: 'delivery', PaymentTerms: 'payment', CurrencyCode: 'currency', FreightCharges: 'freight', OtherCharges: 'other', Remarks: 'remarks' },
            items: { table: 'items', add: 'addItem', fields: { AssetCategoryID: 'i-category', AssetTypeID: 'i-type', AssetBrandID: 'i-brand', AssetModelID: 'i-model', ItemDescription: 'i-description', OrderedQuantity: 'i-qty', UnitPrice: 'i-price', DiscountAmount: 'i-discount', TaxPercentage: 'i-tax', WarrantyPeriod: 'i-warranty' } },
            terms: true
        },
        'VendorQuotation.aspx': {
            fields: { QuotationID: 'qid', QuotationNumber: 'qnumber', VendorID: 'vendor', PurchaseRequestID: 'request', QuotationDate: 'qdate', ValidUntilDate: 'valid', ReferenceNumber: 'reference', DeliveryPeriod: 'delivery', PaymentTerms: 'payment', WarrantyTerms: 'warranty', Remarks: 'remarks' },
            items: { table: 'items', add: 'addItem', fields: { AssetCategoryID: 'i-category', AssetTypeID: 'i-type', AssetBrandID: 'i-brand', ItemDescription: 'i-description', Quantity: 'i-qty', UnitPrice: 'i-price', DiscountAmount: 'i-discount', TaxPercentage: 'i-tax', WarrantyPeriod: 'i-warranty', DeliveryTime: 'i-delivery' } }
        }
    };

    var masterConfigs = {
        'AssetBrandMaster.aspx': { ID: 'id', Name: 'name', Code: 'code', Description: 'description', IsActive: 'active' },
        'AssetCategoryMaster.aspx': { ID: 'id', CompanyID: 'company', Name: 'name', Code: 'code', Description: 'description', DefaultUsefulLifeInMonths: 'life', DepreciationApplicable: 'dep', IsActive: 'active' },
        'AssetModelMaster.aspx': { ID: 'id', Name: 'name', Code: 'code', Description: 'description', ParentID: 'type', Extra1: 'brand', Extra2: 'number', IsActive: 'active' },
        'AssetStatusMaster.aspx': { ID: 'id', Name: 'name', Code: 'code', Description: 'description', IsAvailableForAllocation: 'alloc', IsActive: 'active' },
        'AssetTypeMaster.aspx': { ID: 'id', Name: 'name', Code: 'code', Description: 'description', ParentID: 'category', RequiresSerialNumber: 'serial', RequiresAssetTag: 'tag', IsConsumable: 'consumable', IsActive: 'active' },
        'DisposalReasonMaster.aspx': { ID: 'id', Name: 'name', Code: 'code', Description: 'description', IsActive: 'active' },
        'VendorMaster.aspx': { ID: 'id', Name: 'name', Description: 'description', Address: 'address', ContactPerson: 'contact', PhoneNumber: 'phone', EmailAddress: 'email', GSTNumber: 'gst', PANNumber: 'pan', FaxNumber: 'fax', WebsiteURL: 'website', AccountHolderName: 'accountHolder', BankName: 'bankName', BankBranchAddress: 'bankBranch', AccountType: 'accountType', AccountNumber: 'accountNumber', MICRCode: 'micr', IFSCCode: 'ifsc', IsActive: 'active' }
    };

    function setField(id, value) {
        var field = $('#' + id);
        if (!field.length) return;
        if (field.is(':checkbox')) field.prop('checked', value === true || value === 1 || value === '1');
        else field.val(field.is('[type=date]') ? dateValue(value) : (value == null ? '' : value));
    }

    function fillHeader(row, fields) {
        $.each(fields, function (property, id) { setField(id, row[property]); });
    }

    function fillItemRows(rows, config) {
        if (!config || !rows) return;
        $('#' + config.table).empty();
        $.each(rows, function () { if (typeof window[config.add] === 'function') window[config.add](); });
        var apply = function () {
            $('#' + config.table + ' tr').each(function (index) {
                var tr = $(this), row = rows[index] || {};
                $.each(config.fields, function (property, className) {
                    var field = tr.find('.' + className), value = row[property];
                    if (field.is(':checkbox')) field.prop('checked', !!value);
                    else field.val(field.is('[type=date]') ? dateValue(value) : (value == null ? '' : value));
                });
            });
        };
        apply();
        $(document).one('ajaxStop.assetItems', apply);
    }

    function initialiseEdit() {
        var page = window.location.pathname.split('/').pop(), config = editConfigs[page], id = AssetUI.query('id');
        if (!config || !id || !/^\d+$/.test(id)) return;
        AssetUI.post(page + '/Get', { id: +id }, function (sets) {
            var header = sets && sets[0] && sets[0][0];
            if (!header) { message('The requested record was not found.', 'error'); return; }
            fillHeader(header, config.fields);
            fillItemRows(sets[1], config.items);
            if (config.terms && sets[2]) {
                $('#terms').empty();
                $.each(sets[2], function (_, term) {
                    if (typeof window.addTerm === 'function') window.addTerm();
                    var value = typeof term === 'string' ? term : (term.TermText || term.Term || term.Description || '');
                    $('#terms .po-term').last().val(value);
                });
            }
            $('.asset-hero h2').each(function () { if (!/^Edit /.test($(this).text())) $(this).text('Edit ' + $(this).text().replace(/^Add |^Create /, '')); });
            window.scrollTo(0, 0);
            if (AssetUI.query('print') === '1') window.setTimeout(function () { window.print(); }, 250);
        });
    }

    function installMasterEditor() {
        var page = window.location.pathname.split('/').pop(), fields = masterConfigs[page];
        if (!fields) return;
        window.editRow = function (id) {
            AssetUI.post(page + '/Get', { id: id }, function (rows) {
                var row = rows && rows[0];
                if (!row) { message('The requested record was not found.', 'error'); return; }
                fillHeader(row, fields);
                $('.erp-panel').first().addClass('editing');
                window.scrollTo(0, 0);
            });
        };
    }

    function enhanceLayout() {
        var page = window.location.pathname.split('/').pop().toLowerCase();
        var heroIcon = /dashboard/.test(page) ? 'fa-chart-pie' : /report|history/.test(page) ? 'fa-chart-bar' : /master/.test(page) ? 'fa-cogs' : /purchase|quotation|receipt/.test(page) ? 'fa-shopping-cart' : /maintenance/.test(page) ? 'fa-tools' : /transfer|allocation|return/.test(page) ? 'fa-exchange-alt' : /disposal/.test(page) ? 'fa-recycle' : 'fa-boxes';
        var pageType = /report|history/.test(page) ? 'report' : /master/.test(page) ? 'master' : /dashboard/.test(page) ? 'dashboard' : 'transaction';
        $('.asset-page').addClass('asset-page-' + pageType);
        $('.main-header a[href]').each(function () {
            var link = $(this), href = link.attr('href');
            if (href && /^[^#/.][^/]*\.aspx(?:[?#].*)?$/i.test(href)) link.attr('href', '../Admin/' + href);
        });
        $('.asset-hero').each(function () {
            var hero = $(this);
            if (hero.children('.asset-hero-icon').length) return;
            hero.wrapInner('<div class="asset-hero-copy"></div>');
            hero.prepend('<div class="asset-hero-icon"><i class="fas ' + heroIcon + '" aria-hidden="true"></i></div>');
        });
        $('.erp-panel-title').each(function () {
            var title = $(this), text = title.text().toLowerCase(), icon = /filter|search/.test(text) ? 'fa-filter' : /list|record|history|report|request|order|quotation|receipt/.test(text) ? 'fa-list-ul' : /item|detail|registration|header/.test(text) ? 'fa-clipboard-list' : 'fa-box';
            if (!title.children('i').length) title.prepend('<i class="fas ' + icon + '" aria-hidden="true"></i>');
        });
        $('.asset-page .btn').not('.asset-actions .btn,.asset-action').each(function () {
            var button = $(this), text = $.trim(button.text()).toLowerCase(), icon = '';
            if (/save/.test(text)) icon = 'fa-save';
            else if (/clear|reset/.test(text)) icon = 'fa-eraser';
            else if (/search|generate|compare/.test(text)) icon = 'fa-search';
            else if (/add|create/.test(text)) icon = 'fa-plus';
            else if (/export/.test(text)) icon = 'fa-file-excel';
            else if (/download/.test(text)) icon = 'fa-download';
            else if (/submit/.test(text)) icon = 'fa-paper-plane';
            else if (/import/.test(text)) icon = 'fa-file-import';
            else if (/approve/.test(text)) icon = 'fa-check';
            if (icon && !button.children('i').length) button.prepend('<i class="fas ' + icon + ' mr-1" aria-hidden="true"></i>');
        });
        $('.entry-form input, .entry-form select, .entry-form textarea').on('input change', function () { $(this).removeClass('is-invalid'); });
    }

    $(function () {
        enhanceLayout();
        installMasterEditor();
        var started = false;
        function start() { if (!started) { started = true; initialiseEdit(); } }
        $(document).one('ajaxStop.assetEdit', start);
        window.setTimeout(start, 800);
    });
})(window, window.jQuery);
