var costingState = {
    orders: [],
    selectedOrderId: 0,
    selectedData: null,
    productionTable: null,
    abstractorTable: null,
    initialized: false
};

function Costing_InitPage(orderId) {
    if (costingState.initialized) {
        return;
    }

    costingState.initialized = true;
    bindCostingEvents(orderId);
    initializeCostingTables();
    resetCostingPage();
    loadCostingOrders();
}


function bindCostingEvents(orderId) {

    costingState.selectedOrderId = parseInt(orderId, 10) || 0;

    if (costingState.selectedOrderId > 0) {
        loadOrderCosting(costingState.selectedOrderId);
    } else {
        resetCostingPage();
    }

    $(document)
        .off('.costing')
        .on('change.costing', '#ddlSearchCopyPagesDocs', function () {
            updatePageDocLabel('#ddlSearchCopyPagesDocs', '#lblSearchCopyCostPageDoc');
        })
        .on('change.costing', '#ddlVarySearchCopyPagesDocs', function () {
            updatePageDocLabel('#ddlVarySearchCopyPagesDocs', '#lblVarySearchCopyCostPageDoc');
        })
        .on('change.costing', '#ddlJudgementCopyPagesDocs', function () {
            updatePageDocLabel('#ddlJudgementCopyPagesDocs', '#lblJudjementCopyPageDoc');
        })
        .on('change.costing', '#ddlVaryJudgementCopyPagesDocs', function () {
            updatePageDocLabel('#ddlVaryJudgementCopyPagesDocs', '#lblVaryJudjementCopyPageDoc');
        })
        .on('change.costing', '#ddlSearchCopyCostPattern,#ddlJudjementCopyCostPattern', function () {
            updateCostingVarySections();
            calculateProductionTotals();
        })
        .on('input.costing', '.costing-number', function () {
            this.value = this.value.replace(/[^\d]/g, '');
            calculateProductionTotals();
            calculateAbstractorTotals();
        })
        .on('input.costing', '.costing-money-input', function () {
            this.value = this.value.replace(/[^\d.]/g, '').replace(/(\..*)\./g, '$1');
            calculateProductionTotals();
            calculateAbstractorTotals();
        })
        .on('blur.costing', '.costing-money-input', function () {
            if ($.trim(this.value) !== '') {
                this.value = formatMoney(decimalValue(this.value));
            }
        })
        .on('click.costing', '#btnAddProductionCosting', function () {
            saveProductionCosting();
        })
        .on('click.costing', '#btnResetProductionCosting', function () {
            clearProductionEntryFields(true);
            calculateProductionTotals();
        })
        .on('click.costing', '#btnAddAbstractor', function () {
            saveAbstractorCosting();
        })
        .on('click.costing', '#btnAddManualCosting', function () {
            saveCreditCardInfo();
        });
}

function core_bindCostingEvents(orderId) {
    $(document)
        .off('.costing')
        .on('change.costing', '#ddlOrder', function () {
            var orderId = parseInt($(this).val(), 10) || 0;
            costingState.selectedOrderId = orderId;

            if (orderId > 0) {
                loadOrderCosting(orderId);
            } else {
                resetCostingPage();
            }
        })
        .on('change.costing', '#ddlSearchCopyPagesDocs', function () {
            updatePageDocLabel('#ddlSearchCopyPagesDocs', '#lblSearchCopyCostPageDoc');
        })
        .on('change.costing', '#ddlVarySearchCopyPagesDocs', function () {
            updatePageDocLabel('#ddlVarySearchCopyPagesDocs', '#lblVarySearchCopyCostPageDoc');
        })
        .on('change.costing', '#ddlJudgementCopyPagesDocs', function () {
            updatePageDocLabel('#ddlJudgementCopyPagesDocs', '#lblJudjementCopyPageDoc');
        })
        .on('change.costing', '#ddlVaryJudgementCopyPagesDocs', function () {
            updatePageDocLabel('#ddlVaryJudgementCopyPagesDocs', '#lblVaryJudjementCopyPageDoc');
        })
        .on('change.costing', '#ddlSearchCopyCostPattern,#ddlJudjementCopyCostPattern', function () {
            updateCostingVarySections();
            calculateProductionTotals();
        })
        .on('input.costing', '.costing-number', function () {
            this.value = this.value.replace(/[^\d]/g, '');
            calculateProductionTotals();
            calculateAbstractorTotals();
        })
        .on('input.costing', '.costing-money-input', function () {
            this.value = this.value.replace(/[^\d.]/g, '').replace(/(\..*)\./g, '$1');
            calculateProductionTotals();
            calculateAbstractorTotals();
        })
        .on('blur.costing', '.costing-money-input', function () {
            if ($.trim(this.value) !== '') {
                this.value = formatMoney(decimalValue(this.value));
            }
        })
        .on('click.costing', '#btnAddProductionCosting', function () {
            saveProductionCosting();
        })
        .on('click.costing', '#btnResetProductionCosting', function () {
            clearProductionEntryFields(true);
            calculateProductionTotals();
        })
        .on('click.costing', '#btnAddAbstractor', function () {
            saveAbstractorCosting();
        })
        .on('click.costing', '#btnAddManualCosting', function () {
            saveCreditCardInfo();
        });
}

function initializeCostingTables() {
    renderProductionGrid([]);
    renderAbstractorGrid([]);
}

function loadCostingOrders() {
    showCostingLoader(true);
    clearCostingMessage();

    costingAjax('GetOrders', {})
        .done(function (result) {
            var response = parseCostingResponse(result);
            if (!response.Success) {
                showCostingMessage('danger', response.Message || 'Unable to load orders.');
                return;
            }

            costingState.orders = response.Orders || [];
            fillOrderDropDown(costingState.orders);
        })
        .fail(function (error) {
            showCostingAjaxError(error, 'Unable to load orders.');
        })
        .always(function () {
            showCostingLoader(false);
        });
}

function loadOrderCosting(orderId) {
    showCostingLoader(true);
    clearCostingMessage();

    costingAjax('LoadOrderCosting', { OrderID: orderId })
        .done(function (result) {
            var response = parseCostingResponse(result);
            if (!response.Success) {
                showCostingMessage('danger', response.Message || 'Unable to load costing details.');
                resetCostingPage(false);
                return;
            }

            applyCostingData(response.Data);
        })
        .fail(function (error) {
            showCostingAjaxError(error, 'Unable to load costing details.');
        })
        .always(function () {
            showCostingLoader(false);
        });
}

function saveProductionCosting() {
    clearCostingMessage();

    var validationMessage = validateProductionCosting();
    if (validationMessage) {
        showCostingMessage('warning', validationMessage);
        return false;
    }

    showCostingLoader(true);
    setCostingButtonBusy('#btnAddProductionCosting', true, '<i class="fas fa-spinner fa-spin"></i><span>Saving...</span>');

    uploadInvoiceIfNeeded()
        .done(function (attachmentPath) {
            var request = buildProductionRequest();
            request.AttachmentPath = attachmentPath || '';

            costingAjax('SaveProductionCosting', { request: request })
                .done(function (result) {
                    var response = parseCostingResponse(result);
                    if (!response.Success) {
                        showCostingMessage('danger', response.Message || 'Order costing not added.');
                        return;
                    }

                    showCostingMessage('success', response.Message || 'Production costing added successfully.');
                    if (response.Data) {
                        applyCostingData(response.Data, { skipProductionForm: true });
                    }

                    clearProductionEntryFields(true);
                    calculateProductionTotals();
                })
                .fail(function (error) {
                    showCostingAjaxError(error, 'Order costing not added.');
                })
                .always(function () {
                    showCostingLoader(false);
                    setCostingButtonBusy('#btnAddProductionCosting', false);
                });
        })
        .fail(function (message) {
            showCostingLoader(false);
            setCostingButtonBusy('#btnAddProductionCosting', false);
            showCostingMessage('danger', message || 'Unable to upload invoice.');
        });

    return false;
}

function saveAbstractorCosting() {
    clearCostingMessage();

    var validationMessage = validateAbstractorCosting();
    if (validationMessage) {
        showCostingMessage('warning', validationMessage);
        return false;
    }

    showCostingLoader(true);
    setCostingButtonBusy('#btnAddAbstractor', true, '<i class="fas fa-spinner fa-spin"></i><span>Saving...</span>');

    costingAjax('SaveAbstractorCosting', { request: buildAbstractorRequest() })
        .done(function (result) {
            var response = parseCostingResponse(result);
            if (!response.Success) {
                showCostingMessage('danger', response.Message || 'Abstractor costing not added.');
                return;
            }

            showCostingMessage('success', response.Message || 'Abstractor costing added successfully.');
            if (response.Data) {
                applyCostingData(response.Data, { skipProductionForm: true });
            }

            clearAbstractorFields();
            calculateAbstractorTotals();
        })
        .fail(function (error) {
            showCostingAjaxError(error, 'Abstractor costing not added.');
        })
        .always(function () {
            showCostingLoader(false);
            setCostingButtonBusy('#btnAddAbstractor', false);
        });

    return false;
}

function saveCreditCardInfo() {
    clearCostingMessage();

    var validationMessage = validateCreditCardInfo();
    if (validationMessage) {
        showCostingMessage('warning', validationMessage);
        return false;
    }

    showCostingLoader(true);
    setCostingButtonBusy('#btnAddManualCosting', true, '<i class="fas fa-spinner fa-spin"></i><span>Saving...</span>');

    costingAjax('SaveCreditCardInfo', { request: buildCreditCardRequest() })
        .done(function (result) {
            var response = parseCostingResponse(result);
            if (!response.Success) {
                showCostingMessage('danger', response.Message || 'Order costing not added.');
                return;
            }

            showCostingMessage('success', response.Message || 'Order costing added successfully.');
            if (response.RedirectUrl) {
                window.setTimeout(function () {
                    window.location.href = response.RedirectUrl;
                }, 650);
            }
        })
        .fail(function (error) {
            showCostingAjaxError(error, 'Order costing not added.');
        })
        .always(function () {
            showCostingLoader(false);
            setCostingButtonBusy('#btnAddManualCosting', false);
        });

    return false;
}

function fillOrderDropDown(orders) {
    var html = '<option value="">Select</option>';


    $.each(orders, function (_, order) {
        html += '<option value="' + htmlEncode(order.Value) + '">' + htmlEncode(order.Text) + '</option>';
    });
    $('#ddlOrder').html(html);
}

function applyCostingData(data, options) {
    options = options || {};
    costingState.selectedData = data || {};

    fillOrderSummary(costingState.selectedData.Order || {}, costingState.selectedData.Process || {});
    fillCreditCard(costingState.selectedData.CreditCard || {});

    if (!options.skipProductionForm) {
        fillProductionForm(costingState.selectedData.ProductionForm || {});
    }

    setAbstractorEnabled(!!costingState.selectedData.AbstractorEnabled);
    renderProductionGrid(costingState.selectedData.ProductionRows || []);
    renderAbstractorGrid(costingState.selectedData.AbstractorRows || []);
    calculateProductionTotals();
    calculateAbstractorTotals();
}

function fillOrderSummary(order, process) {
    setText('#lblProjectNumber', getValue(order, 'ProjectNumber', 'Project'));
    setText('#lblProductType', getValue(order, 'ProductType'));
    setText('#lblProcess', getValue(process, 'ProcessName', 'Process'));
    setText('#Label2', getValue(order, 'OrderDate'));
    setText('#lblState', getValue(order, 'State'));
    setText('#lblCounty', getValue(order, 'County'));
    setText('#lblPlant', getValue(order, 'Plant'));
    setText('#lblJudgment', getValue(order, 'Judgment'));
    setText('#lblAvgCost', getValue(order, 'AvgCost'));
    setText('#lblplantSDate', getValue(order, 'PIDate', 'PlantStartDate'));
    setText('#lblImageSDate', getValue(order, 'PIDate1', 'ImageStartDate'));
    $('#hdnCounty').val(getValue(order, 'CountyID'));
}

function fillProductionForm(row) {
    setSelectValue('#ddlCostSearchEngine', getValue(row, 'SearchEngineType'), 'Select');
    setValue('#txtCostSearchType', getValue(row, 'SearchEngineLink'));
    setValue('#txtNoOfSearchesMade', getValue(row, 'SearchCostNoOfSearches'));
    setMoneyValue('#txtCostSearches', getValue(row, 'SearchCostCost'));
    setMoneyValue('#txtSearchCostTotal', getValue(row, 'SearchCostTotal'));
    setSelectValue('#ddlSearchCopyCostPattern', getValue(row, 'SearchCopyCostPattern'), 'Similar');
    setSelectValue('#ddlSearchCopyPagesDocs', getValue(row, 'SearchCopyCostDocsType'), 'NoOfPages');
    setValue('#txtNoOfPagesAndDocs', getValue(row, 'SearchCopyCostPagesDocsMain'));
    setMoneyValue('#txtNoOfPagesAndDocsCost', getValue(row, 'SearchCopyCostCostMain'));
    setMoneyValue('#txtNoOfPagesAndDocsTotalCost', getValue(row, 'SearchCopyCostTotalMain'));
    setSelectValue('#ddlVarySearchCopyPagesDocs', getValue(row, 'SearchCopyCostDocsType'), 'NoOfPages');
    setValue('#txtVaryNoOfPagesAndDocs', getValue(row, 'SearchCopyCostPagesDocs'));
    setMoneyValue('#txtVarySearchPageCost', getValue(row, 'SearchCopyCostCost'));
    setMoneyValue('#txtVarySearhCopyCostTotal', getValue(row, 'SearchCopyCostTotal'));
    setValue('#txtJudgementSearchCostLink', getValue(row, 'JudgementSearchLink'));
    setValue('#txtJudgementNoOfSearches', getValue(row, 'JudgmentSearchCostNoOfSeraches'));
    setMoneyValue('#txtJudgementNoOfSearchesCost', getValue(row, 'JudgmentSearchCostCost'));
    setMoneyValue('#txtJudgementNoOfSearchesTotalCost', getValue(row, 'JudgmentSearchCostTotal'));
    setSelectValue('#ddlJudjementCopyCostPattern', getValue(row, 'JudgmentCopyCostPattern'), 'Similar');
    setSelectValue('#ddlJudgementCopyPagesDocs', getValue(row, 'JudgmentCopyCostDocsType'), 'NoOfPages');
    setValue('#txtJudjementCopyNoOfPages', getValue(row, 'JudgmentCopyCostPagesDocsMain'));
    setMoneyValue('#txtJudjementCopyNoOfPagesCost', getValue(row, 'JudgmentCopyCostCostMain'));
    setMoneyValue('#txtJudjementCopyNoOfPagesTotalCost', getValue(row, 'JudgmentCopyCostTotalMain'));
    setSelectValue('#ddlVaryJudgementCopyPagesDocs', getValue(row, 'JudgmentCopyCostDocsType'), 'NoOfPages');
    setValue('#txtVaryJudjementCopyNoOfPages', getValue(row, 'JudgmentCopyCostPagesDocs'));
    setMoneyValue('#txtVaryJudgmentPageCost', getValue(row, 'JudgmentCopyCostCost'));
    setMoneyValue('#txtVaryJudjementCopyNoOfPagesTotalCost', getValue(row, 'JudgmentCopyCostTotal'));
    setValue('#txtCostRemark', getValue(row, 'CostingRemark', 'Remark'));
    setMoneyValue('#lblManualTotalSearchEngineCost', getValue(row, 'ProductionCost'));
    setValue('#txtTaxDescription', getValue(row, 'TaxChargesDescription'));
    setMoneyValue('#txtTaxTotalAmount', getValue(row, 'TaxAmount'));
    setValue('#txtOtherCharges', getValue(row, 'OtherChargesDescription'));
    setMoneyValue('#txtOtherChargesAmount', getValue(row, 'OtherChargesAmount'));
    setValue('#txtNoOfDoc', getValue(row, 'NoOfDocuments'));
    setValue('#txtNoOfPages', getValue(row, 'NoOfPages'));
    setSelectValue('#ddlTaxInfo', getValue(row, 'TaxInformation'), 'Select');
    setSelectValue('#ddlTaxesYN', getValue(row, 'CalledTaxes'), 'Select');
    setSelectValue('#ddlSnippingTools', getValue(row, 'SnippingTools'), 'Select');
    setValue('#txtPagesDeliverToClient', getValue(row, 'PagesDeliverToClient'));
    setMoneyValue('#txtOrderCost', getValue(row, 'TotalCost', 'ProductionCost'));
    $('#FlInVoice').val('');
    updateCostingVarySections();
    updateAllPageDocLabels();
}

function fillCreditCard(row) {
    setValue('#txtCostNameOfTheCard', getValue(row, 'NameOfTheCard'));
    setValue('#txtCreditCardNo', getValue(row, 'CreditCardNo'));
    setValue('#txtCostValidUpTO', getValue(row, 'ValidUpTo'));
    setValue('#txtCostNameOfThePlant', getValue(row, 'NameOfThePlant'));
    setMoneyValue('#txtCostSearchingAmount', getValue(row, 'SearchingAmount'));
    setMoneyValue('#txtCostDownloadingAmount', getValue(row, 'DownloadingAmount'));
}

function renderProductionGrid(rows) {
    destroyDataTable('#grdManualCostingReport');

    var html = '';
    $.each(rows || [], function (index, row) {
        html += '<tr>';
        html += gridCell(getValue(row, 'Number') || (index + 1));
        html += gridCell(getValue(row, 'ClientOrderNo'));
        html += gridCell(getValue(row, 'SearchEngineType'));
        html += gridCell(getValue(row, 'SearchEngineLink'));
        html += gridCell(getValue(row, 'SearchCostNoOfSearches'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCostCost')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCostTotal')));
        html += gridCell(getValue(row, 'SearchCopyCostPattern'));
        html += gridCell(getValue(row, 'SearchCopyCostMainNo', 'SearchCopyCostPagesDocsMain'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCopyCostCostMain')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCopyCostTotalMain')));
        html += gridCell(getValue(row, 'SearchCopyCostNo', 'SearchCopyCostPagesDocs'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCopyCostCost')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'SearchCopyCostTotal')));
        html += gridCell(getValue(row, 'JudgementSearchLink'));
        html += gridCell(getValue(row, 'JudgmentSearchCostNoOfSeraches'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentSearchCostCost')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentSearchCostTotal')));
        html += gridCell(getValue(row, 'JudgmentCopyCostPattern'));
        html += gridCell(getValue(row, 'JudgmentCopyCostMainNo', 'JudgmentCopyCostPagesDocsMain'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentCopyCostCostMain')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentCopyCostTotalMain')));
        html += gridCell(getValue(row, 'JudgmentCopyCostNo', 'JudgmentCopyCostPagesDocs'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentCopyCostCost')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'JudgmentCopyCostTotal')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'TaxAmount')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'OtherChargesAmount')));
        html += gridCell(getValue(row, 'CostingRemark', 'Remark'));
        html += gridCell(getValue(row, 'NoOfDocuments'));
        html += gridCell(getValue(row, 'NoOfPages'));
        html += gridCell(getValue(row, 'TaxInformation'));
        html += gridCell(getValue(row, 'CalledTaxes'));
        html += gridCell(getValue(row, 'SnippingTools'));
        html += gridCell(getValue(row, 'PagesDeliverToClient'));
        html += gridCellRaw(buildAttachmentLink(getValue(row, 'Attachment')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'ProductionCost')));
        html += '</tr>';
    });

    $('#grdManualCostingReport tbody').html(html);
    $('#productionGridCount').text((rows || []).length + ' records');
    costingState.productionTable = $('#grdManualCostingReport').DataTable({
        destroy: true,
        scrollX: true,
        paging: true,
        pageLength: 10,
        ordering: false,
        autoWidth: false,
        dom: 'lftip'
    });
}

function renderAbstractorGrid(rows) {
    destroyDataTable('#grdAbstarctor');

    var html = '';
    $.each(rows || [], function (index, row) {
        html += '<tr>';
        html += gridCell(getValue(row, 'Number') || (index + 1));
        html += gridCell(getValue(row, 'ClientOrderNo'));
        html += gridCell(getValue(row, 'SearchEngine'));
        html += gridCell(getValue(row, 'SearchType', 'SearchEngineType'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'AbstractorSearchCost')));
        html += gridCell(getValue(row, 'AbstractorCopyCostPages'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'AbstractorCopyCostCost', 'AbstractorCopyCostCostTotal')));
        html += gridCell(getValue(row, 'OtherCostDescription'));
        html += gridCell(formatMoneyDisplay(getValue(row, 'OtherCost')));
        html += gridCell(formatMoneyDisplay(getValue(row, 'AbstractorTotalCost')));
        html += '</tr>';
    });

    $('#grdAbstarctor tbody').html(html);
    $('#abstractorGridCount').text((rows || []).length + ' records');
    costingState.abstractorTable = $('#grdAbstarctor').DataTable({
        destroy: true,
        scrollX: true,
        paging: true,
        pageLength: 10,
        ordering: false,
        autoWidth: false,
        dom: 'lftip'
    });
}

function calculateProductionTotals() {
    var searchTotal = intValue('#txtNoOfSearchesMade') * decimalValue('#txtCostSearches');
    var searchCopyTotal = intValue('#txtNoOfPagesAndDocs') * decimalValue('#txtNoOfPagesAndDocsCost');
    var searchCopyVaryTotal = intValue('#txtVaryNoOfPagesAndDocs') * decimalValue('#txtVarySearchPageCost');
    var judgmentSearchTotal = intValue('#txtJudgementNoOfSearches') * decimalValue('#txtJudgementNoOfSearchesCost');
    var judgmentCopyTotal = intValue('#txtJudjementCopyNoOfPages') * decimalValue('#txtJudjementCopyNoOfPagesCost');
    var judgmentCopyVaryTotal = intValue('#txtVaryJudjementCopyNoOfPages') * decimalValue('#txtVaryJudgmentPageCost');
    var taxAmount = decimalValue('#txtTaxTotalAmount');
    var otherAmount = decimalValue('#txtOtherChargesAmount');

    setMoneyValue('#txtSearchCostTotal', searchTotal);
    setMoneyValue('#txtNoOfPagesAndDocsTotalCost', searchCopyTotal);
    setMoneyValue('#txtVarySearhCopyCostTotal', isVary('#ddlSearchCopyCostPattern') ? searchCopyVaryTotal : 0);
    setMoneyValue('#txtJudgementNoOfSearchesTotalCost', judgmentSearchTotal);
    setMoneyValue('#txtJudjementCopyNoOfPagesTotalCost', judgmentCopyTotal);
    setMoneyValue('#txtVaryJudjementCopyNoOfPagesTotalCost', isVary('#ddlJudjementCopyCostPattern') ? judgmentCopyVaryTotal : 0);

    var productionTotal = searchTotal + searchCopyTotal + judgmentSearchTotal + judgmentCopyTotal + taxAmount + otherAmount;
    if (isVary('#ddlSearchCopyCostPattern')) {
        productionTotal += searchCopyVaryTotal;
    }
    if (isVary('#ddlJudjementCopyCostPattern')) {
        productionTotal += judgmentCopyVaryTotal;
    }

    setMoneyValue('#lblManualTotalSearchEngineCost', productionTotal);
    updateOrderCostTotal();
}

function calculateAbstractorTotals() {
    var total = decimalValue('#txtAbstractorSearchCost') + decimalValue('#txtAbstractorPagesCopyCostTotal') + decimalValue('#txtAbstractorOtherCost');
    setMoneyValue('#txtTotalAbstractorCost', total);
    updateOrderCostTotal();
}

function updateOrderCostTotal() {
    var total = decimalValue('#lblManualTotalSearchEngineCost') + decimalValue('#txtTotalAbstractorCost');
    setMoneyValue('#txtOrderCost', total);
}

function updateCostingVarySections() {
    var showSearchCopyVary = isVary('#ddlSearchCopyCostPattern');
    var showJudgmentCopyVary = isVary('#ddlJudjementCopyCostPattern');

    $('#trVarySearchCopyCost').toggle(showSearchCopyVary);
    $('#trVaryJudjementCopyCost').toggle(showJudgmentCopyVary);

    if (!showSearchCopyVary) {
        $('#txtVaryNoOfPagesAndDocs,#txtVarySearchPageCost,#txtVarySearhCopyCostTotal').val('');
    }

    if (!showJudgmentCopyVary) {
        $('#txtVaryJudjementCopyNoOfPages,#txtVaryJudgmentPageCost,#txtVaryJudjementCopyNoOfPagesTotalCost').val('');
    }
}

function updateAllPageDocLabels() {
    updatePageDocLabel('#ddlSearchCopyPagesDocs', '#lblSearchCopyCostPageDoc');
    updatePageDocLabel('#ddlVarySearchCopyPagesDocs', '#lblVarySearchCopyCostPageDoc');
    updatePageDocLabel('#ddlJudgementCopyPagesDocs', '#lblJudjementCopyPageDoc');
    updatePageDocLabel('#ddlVaryJudgementCopyPagesDocs', '#lblVaryJudjementCopyPageDoc');
}

function updatePageDocLabel(selectSelector, labelSelector) {
    var text = $(selectSelector).val() === 'NoOfDocs' ? 'Cost/Doc' : 'Cost/Page';
    $(labelSelector).text(text);
}

function validateProductionCosting() {
    if (!costingState.selectedOrderId) {
        return 'Please select order.';
    }

    if (isSelectValue('#ddlCostSearchEngine')) {
        return 'Please select search engine.';
    }

    if (!$.trim($('#txtCostSearchType').val())) {
        return 'Please enter search engine link.';
    }

    if ($.trim($('#txtNoOfDoc').val()) === '') {
        return 'Please enter no of documents provided to client.';
    }

    if ($.trim($('#txtNoOfPages').val()) === '') {
        return 'Please enter no of pages provided.';
    }

    if (isSelectValue('#ddlTaxInfo')) {
        return 'Please select tax information provided.';
    }

    if (isSelectValue('#ddlTaxesYN')) {
        return 'Please select called for taxes.';
    }

    if (isSelectValue('#ddlSnippingTools')) {
        return 'Please select snipping tools.';
    }

    return '';
}

function validateAbstractorCosting() {
    if (!costingState.selectedOrderId) {
        return 'Please select order.';
    }

    if (!costingState.selectedData || !costingState.selectedData.AbstractorEnabled) {
        return 'Abstractor costing is only available for Offline or Online to Offline orders.';
    }

    if ($.trim($('#txtAbstractorOtherDescription').val()) === '') {
        return 'Please enter abstractor other cost description.';
    }

    return '';
}

function validateCreditCardInfo() {
    if (!costingState.selectedOrderId) {
        return 'Please select order.';
    }

    var cardNo = $.trim($('#txtCreditCardNo').val());
    if (cardNo && cardNo.length > 4) {
        return 'Please enter last four digits only.';
    }

    return '';
}

function buildProductionRequest() {
    calculateProductionTotals();

    return {
        OrderID: costingState.selectedOrderId,
        SearchEngineType: $('#ddlCostSearchEngine').val(),
        SearchEngineLink: $.trim($('#txtCostSearchType').val()),
        JudgementSearchLink: $.trim($('#txtJudgementSearchCostLink').val()),
        SearchCostNoOfSearches: intValue('#txtNoOfSearchesMade'),
        SearchCostCost: decimalValue('#txtCostSearches'),
        SearchCostTotal: decimalValue('#txtSearchCostTotal'),
        SearchCopyCostPattern: $('#ddlSearchCopyCostPattern').val(),
        SearchCopyCostDocsType: $('#ddlSearchCopyPagesDocs').val(),
        SearchCopyCostPagesDocsMain: intValue('#txtNoOfPagesAndDocs'),
        SearchCopyCostCostMain: decimalValue('#txtNoOfPagesAndDocsCost'),
        SearchCopyCostTotalMain: decimalValue('#txtNoOfPagesAndDocsTotalCost'),
        VarySearchCopyCostDocsType: $('#ddlVarySearchCopyPagesDocs').val(),
        VarySearchCopyCostPagesDocs: intValue('#txtVaryNoOfPagesAndDocs'),
        VarySearchCopyCostCost: decimalValue('#txtVarySearchPageCost'),
        VarySearchCopyCostTotal: decimalValue('#txtVarySearhCopyCostTotal'),
        JudgmentSearchCostNoOfSeraches: intValue('#txtJudgementNoOfSearches'),
        JudgmentSearchCostCost: decimalValue('#txtJudgementNoOfSearchesCost'),
        JudgmentSearchCostTotal: decimalValue('#txtJudgementNoOfSearchesTotalCost'),
        JudgmentCopyCostPattern: $('#ddlJudjementCopyCostPattern').val(),
        JudgmentCopyCostDocsType: $('#ddlJudgementCopyPagesDocs').val(),
        JudgmentCopyCostPagesDocsMain: intValue('#txtJudjementCopyNoOfPages'),
        JudgmentCopyCostCostMain: decimalValue('#txtJudjementCopyNoOfPagesCost'),
        JudgmentCopyCostTotalMain: decimalValue('#txtJudjementCopyNoOfPagesTotalCost'),
        VaryJudgmentCopyCostDocsType: $('#ddlVaryJudgementCopyPagesDocs').val(),
        VaryJudgmentCopyCostPagesDocs: intValue('#txtVaryJudjementCopyNoOfPages'),
        VaryJudgmentCopyCostCost: decimalValue('#txtVaryJudgmentPageCost'),
        VaryJudgmentCopyCostTotal: decimalValue('#txtVaryJudjementCopyNoOfPagesTotalCost'),
        TaxChargesDescription: $.trim($('#txtTaxDescription').val()),
        TaxAmount: decimalValue('#txtTaxTotalAmount'),
        OtherChargesDescription: $.trim($('#txtOtherCharges').val()),
        OtherChargesAmount: decimalValue('#txtOtherChargesAmount'),
        Remark: $.trim($('#txtCostRemark').val()),
        NoOfDocuments: intValue('#txtNoOfDoc'),
        NoOfPages: intValue('#txtNoOfPages'),
        TaxInformation: $('#ddlTaxInfo').val(),
        CalledTaxes: $('#ddlTaxesYN').val(),
        SnippingTools: $('#ddlSnippingTools').val(),
        PagesDeliverToClient: intValue('#txtPagesDeliverToClient'),
        ProductionCost: decimalValue('#lblManualTotalSearchEngineCost'),
        TotalCost: decimalValue('#txtOrderCost'),
        AttachmentPath: ''
    };
}

function buildAbstractorRequest() {
    calculateAbstractorTotals();

    return {
        OrderID: costingState.selectedOrderId,
        SearchEngineType: $('#ddlCostSearchEngine').val(),
        SearchEngineLink: $.trim($('#txtCostSearchType').val()),
        AbstractorSearchCost: decimalValue('#txtAbstractorSearchCost'),
        AbstractorCopyCostPages: intValue('#txtAbstractorPagesCopyCost'),
        AbstractorCopyCostCost: decimalValue('#txtAbstractorPagesCopyCostTotal'),
        AbstractorCopyCostCostTotal: decimalValue('#txtAbstractorPagesCopyCostTotal'),
        OtherCostDescription: $.trim($('#txtAbstractorOtherDescription').val()),
        OtherCost: decimalValue('#txtAbstractorOtherCost'),
        AbstractorTotalCost: decimalValue('#txtTotalAbstractorCost')
    };
}

function buildCreditCardRequest() {
    return {
        OrderID: costingState.selectedOrderId,
        NameOfTheCard: $.trim($('#txtCostNameOfTheCard').val()),
        CreditCardNo: $.trim($('#txtCreditCardNo').val()),
        ValidUpTo: $.trim($('#txtCostValidUpTO').val()),
        NameOfThePlant: $.trim($('#txtCostNameOfThePlant').val()),
        SearchingAmount: decimalValue('#txtCostSearchingAmount'),
        DownloadingAmount: decimalValue('#txtCostDownloadingAmount')
    };
}

function uploadInvoiceIfNeeded() {
    var deferred = $.Deferred();
    var input = $('#FlInVoice')[0];

    if (!input || !input.files || input.files.length === 0) {
        deferred.resolve('');
        return deferred.promise();
    }

    var formData = new FormData();
    formData.append('OrderID', costingState.selectedOrderId);
    formData.append('Invoice', input.files[0]);

    $.ajax({
        url: 'Costing.aspx?uploadInvoice=1',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        dataType: 'json',
        success: function (result) {
            if (result && result.Success) {
                deferred.resolve(result.AttachmentPath || '');
            } else {
                deferred.reject((result && result.Message) || 'Unable to upload invoice.');
            }
        },
        error: function (error) {
            var message = 'Unable to upload invoice.';
            if (error && error.responseJSON && error.responseJSON.Message) {
                message = error.responseJSON.Message;
            } else if (error && error.responseText) {
                message = error.responseText;
            }
            deferred.reject(message);
        }
    });

    return deferred.promise();
}

function clearProductionEntryFields(keepCore) {
    var core = {
        ddlCostSearchEngine: $('#ddlCostSearchEngine').val(),
        txtCostSearchType: $('#txtCostSearchType').val(),
        txtNoOfDoc: $('#txtNoOfDoc').val(),
        txtNoOfPages: $('#txtNoOfPages').val()
    };

    $('#txtNoOfSearchesMade,#txtCostSearches,#txtSearchCostTotal,#txtNoOfPagesAndDocs,#txtNoOfPagesAndDocsCost,#txtNoOfPagesAndDocsTotalCost,#txtVaryNoOfPagesAndDocs,#txtVarySearchPageCost,#txtVarySearhCopyCostTotal,#txtJudgementSearchCostLink,#txtJudgementNoOfSearches,#txtJudgementNoOfSearchesCost,#txtJudgementNoOfSearchesTotalCost,#txtJudjementCopyNoOfPages,#txtJudjementCopyNoOfPagesCost,#txtJudjementCopyNoOfPagesTotalCost,#txtVaryJudjementCopyNoOfPages,#txtVaryJudgmentPageCost,#txtVaryJudjementCopyNoOfPagesTotalCost,#txtTaxDescription,#txtTaxTotalAmount,#txtOtherCharges,#txtOtherChargesAmount,#txtCostRemark,#txtPagesDeliverToClient,#lblManualTotalSearchEngineCost,#txtOrderCost').val('');
    $('#ddlSearchCopyCostPattern,#ddlJudjementCopyCostPattern').val('Similar');
    $('#ddlSearchCopyPagesDocs,#ddlVarySearchCopyPagesDocs,#ddlJudgementCopyPagesDocs,#ddlVaryJudgementCopyPagesDocs').val('NoOfPages');
    $('#ddlTaxInfo,#ddlTaxesYN,#ddlSnippingTools').val('Select');
    $('#FlInVoice').val('');

    if (keepCore) {
        $('#ddlCostSearchEngine').val(core.ddlCostSearchEngine || 'Select');
        $('#txtCostSearchType').val(core.txtCostSearchType || '');
        $('#txtNoOfDoc').val(core.txtNoOfDoc || '');
        $('#txtNoOfPages').val(core.txtNoOfPages || '');
    }

    updateCostingVarySections();
    updateAllPageDocLabels();
}

function clearAbstractorFields() {
    $('#txtAbstractorSearchCost,#txtAbstractorPagesCopyCost,#txtAbstractorPagesCopyCostTotal,#txtAbstractorOtherDescription,#txtAbstractorOtherCost,#txtTotalAbstractorCost').val('');
}

function resetCostingPage(keepOrderSelection) {
    if (!keepOrderSelection) {
        costingState.selectedOrderId = 0;
        costingState.selectedData = null;
    }

    setText('#lblProjectNumber,#lblProductType,#lblProcess,#Label2,#lblState,#lblCounty,#lblPlant,#lblJudgment,#lblAvgCost,#lblplantSDate,#lblImageSDate', '');
    $('#hdnCounty').val('');
    clearProductionEntryFields(false);
    clearAbstractorFields();
    fillCreditCard({});
    setAbstractorEnabled(false);
    renderProductionGrid([]);
    renderAbstractorGrid([]);
}

function setAbstractorEnabled(enabled) {
    $('#abstractorDisabledNote').toggle(!enabled);
    $('#btnAddAbstractor').prop('disabled', !enabled);
    $('#txtAbstractorSearchCost,#ddlAbstractorPagesCopy,#txtAbstractorPagesCopyCost,#txtAbstractorPagesCopyCostTotal,#txtAbstractorOtherDescription,#txtAbstractorOtherCost')
        .prop('disabled', !enabled);
}

function costingAjax(method, data) {
    return $.ajax({
        url: 'Costing.aspx/' + method,
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(data || {})
    });
}

function parseCostingResponse(result) {
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

function showCostingAjaxError(error, fallbackMessage) {
    var message = fallbackMessage || 'Something went wrong. Please contact administrator.';
    if (error && error.responseJSON && error.responseJSON.Message) {
        message = error.responseJSON.Message;
    } else if (error && error.responseText) {
        message = error.responseText;
    }

    showCostingMessage('danger', message);
}

function showCostingMessage(type, message) {
    var $alert = $('#costingAlert');
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

function clearCostingMessage() {
    $('#costingAlert').hide().text('');
}

function showCostingLoader(show) {
    if (show) {
        $('#load1').css('display', 'flex');
    } else {
        $('#load1').hide();
    }
}

function setCostingButtonBusy(selector, busy, busyHtml) {
    var $button = $(selector);
    if (!$button.length) {
        return;
    }

    if (busy) {
        $button.data('original-html', $button.html()).prop('disabled', true).html(busyHtml || 'Saving...');
    } else {
        $button.prop('disabled', false).html($button.data('original-html') || $button.html());
    }
}

function destroyDataTable(selector) {
    if ($.fn.dataTable && $.fn.dataTable.isDataTable(selector)) {
        $(selector).DataTable().clear().destroy();
    }
}

function buildAttachmentLink(attachment) {
    if (!attachment) {
        return '';
    }

    return '<a href="Costing.aspx?downloadAttachment=' + encodeURIComponent(attachment) + '" target="_blank" class="btn btn-link btn-sm">Download</a>';
}

function gridCell(value) {
    return '<td>' + htmlEncode(value) + '</td>';
}

function gridCellRaw(value) {
    return '<td>' + (value || '') + '</td>';
}

function htmlEncode(value) {
    return $('<div/>').text(value == null ? '' : value).html();
}

function getValue(row) {
    if (!row) {
        return '';
    }

    for (var i = 1; i < arguments.length; i++) {
        var name = arguments[i];
        if (row[name] !== undefined && row[name] !== null) {
            return row[name];
        }
    }

    return '';
}

function setText(selector, value) {
    $(selector).text(value == null ? '' : value);
}

function setValue(selector, value) {
    $(selector).val(value == null ? '' : value);
}

function setSelectValue(selector, value, fallback) {
    var $select = $(selector);
    var nextValue = value || fallback || '';
    if ($select.find('option[value="' + nextValue + '"]').length === 0) {
        nextValue = fallback || '';
    }
    $select.val(nextValue);
}

function setMoneyValue(selector, value) {
    if (value === null || value === undefined || value === '') {
        $(selector).val('');
        return;
    }

    $(selector).val(formatMoney(decimalRaw(value)));
}

function intValue(selector) {
    var value = typeof selector === 'string' ? $(selector).val() : selector;
    var parsed = parseInt(String(value || '').replace(/[^\d-]/g, ''), 10);
    return isNaN(parsed) ? 0 : parsed;
}

function decimalValue(selector) {
    var value = typeof selector === 'string' ? $(selector).val() : selector;
    return decimalRaw(value);
}

function decimalRaw(value) {
    var parsed = parseFloat(String(value || '').replace(/[^0-9.-]/g, ''));
    return isNaN(parsed) ? 0 : parsed;
}

function formatMoney(value) {
    return '$' + (decimalRaw(value)).toFixed(2);
}

function formatMoneyDisplay(value) {
    if (value === null || value === undefined || value === '') {
        return '';
    }

    return formatMoney(value);
}

function isVary(selector) {
    return $(selector).val() === 'Vary';
}

function isSelectValue(selector) {
    var value = $.trim($(selector).val());
    return !value || value === 'Select';
}
