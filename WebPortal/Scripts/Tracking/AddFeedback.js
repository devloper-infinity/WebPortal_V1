var AddFeedback = (function () {
    var selectedFile = null;
    var feedbackRows = [];
    var feedbackTable = null;
    var importHeaders = [
        'Deal No',
        'Loan 1 #',
        'Process',
        'Error Field',
        'Error Category',
        'Error Subcategory',
        'Error',
        'Should be',
        'Error Type',
        'Severity',
        'Feedback Type',
        'Remark'
    ];

    function pageMethod(method, data, success, error) {
        $.ajax({
            type: 'POST',
            url: 'AddFeedback.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                if (success) success(response.d);
            },
            error: function (xhr) {
                var message = 'Unexpected error occurred.';
                try {
                    message = (xhr.responseJSON && xhr.responseJSON.Message) || xhr.responseText || message;
                } catch (e) { }

                if (error) error(message);
                else showMessage('error', message);
            }
        });
    }

    function init() {
        bindEvents();
        initFeedbackTable();
        resetImportResults();
        clearFeedbackFields();
        clearStatusFields();
        loadDefaults();
        loadCategories();
    }

    function bindEvents() {
        $('.af-tab-btn').off('click.addfeedback').on('click.addfeedback', function () {
            showPanel($(this).data('panel'));
        });

        $('#af_markedTo').off('change.addfeedback').on('change.addfeedback', loadErrorBy);
        $('#af_category').off('change.addfeedback').on('change.addfeedback', loadSubCategories);
        $('#af_errorType').off('change.addfeedback').on('change.addfeedback', applyNoFeedbackState);
        $('#af_btnClear').off('click.addfeedback').on('click.addfeedback', clearFeedbackFields);
        $('#af_btnSave').off('click.addfeedback').on('click.addfeedback', saveFeedback);
        $('#af_btnRefreshFeedback').off('click.addfeedback').on('click.addfeedback', loadFeedbackRecords);
        $('#af_btnClose').off('click.addfeedback').on('click.addfeedback', closePage);
        $('#af_btnUpload').off('click.addfeedback').on('click.addfeedback', uploadFeedback);
        $('#af_btnFormat').off('click.addfeedback').on('click.addfeedback', downloadFormat);
        $('#af_status').off('change.addfeedback').on('change.addfeedback', toggleHoldReason);
        $('#af_btnClearStatus').off('click.addfeedback').on('click.addfeedback', clearStatusFields);
        $('#af_btnUpdateStatus').off('click.addfeedback').on('click.addfeedback', updateLoanStatus);

        $('#af_dropzone')
            .off('click.addfeedback keydown.addfeedback dragover.addfeedback dragleave.addfeedback drop.addfeedback')
            .on('click.addfeedback', function () {
                $('#af_importFile').trigger('click');
            })
            .on('keydown.addfeedback', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    $('#af_importFile').trigger('click');
                }
            })
            .on('dragover.addfeedback', function (event) {
                event.preventDefault();
                $(this).addClass('is-dragover');
            })
            .on('dragleave.addfeedback', function () {
                $(this).removeClass('is-dragover');
            })
            .on('drop.addfeedback', function (event) {
                event.preventDefault();
                $(this).removeClass('is-dragover');
                var files = event.originalEvent.dataTransfer.files;
                setSelectedFile(files && files.length ? files[0] : null);
            });

        $('#af_importFile').off('change.addfeedback').on('change.addfeedback', function () {
            setSelectedFile(this.files && this.files.length ? this.files[0] : null);
        });
    }

    function showPanel(panelId) {
        $('.af-tab-btn').removeClass('active').attr('aria-selected', 'false');
        $('.af-tab-panel').removeClass('active').attr('hidden', 'hidden');
        $('.af-tab-btn[data-panel="' + panelId + '"]').addClass('active').attr('aria-selected', 'true');
        $('#' + panelId).addClass('active').removeAttr('hidden');
    }

    function loadDefaults() {
        setContextLabels();
        showLoading('Loading feedback details...');

        pageMethod('GetPageDefaults', {}, function (data) {
            hideLoading();
            data = data || {};

            setHiddenValue('#hdnProjectNo', data.ProjectNo);
            setHiddenValue('#hdnProjectId', data.ProjectId);
            setHiddenValue('#hdnDealNo', data.DealNo);
            setHiddenValue('#hdnLoanNo', data.LoanNo);
            setHiddenValue('#hdnOrderDate', data.OrderDate);
            setHiddenValue('#hdnProcess', data.Process);
            setHiddenValue('#hdnErrorBy', data.ErrorBy);

            setContextLabels();
            selectValue($('#af_markedTo'), data.Process || $('#hdnProcess').val());
            fillSelect($('#af_errorBy'), data.ErrorByList || [], 'Value', 'Text', data.ErrorBy);
            $('#af_feedbackBy').val(data.FeedbackBy || '');
            loadFeedbackRecords();
        }, function (message) {
            hideLoading();
            showMessage('error', message || 'Unable to load feedback details.');
        });
    }

    function setHiddenValue(selector, value) {
        if (value !== undefined && value !== null && String(value).trim() !== '') {
            $(selector).val(value);
        }
    }

    function setContextLabels() {
        $('#af_ctxProject').text($('#hdnProjectNo').val() || '-');
        $('#af_ctxDeal').text($('#hdnDealNo').val() || '-');
        $('#af_ctxLoan').text($('#hdnLoanNo').val() || '-');
        $('#af_ctxProcess').text($('#hdnProcess').val() || '-');
        $('#af_ctxOrderDate').text($('#hdnOrderDate').val() || '-');
        $('#af_statusProject').text($('#hdnProjectNo').val() || '-');
        $('#af_statusDeal').text($('#hdnDealNo').val() || '-');
        $('#af_statusLoan').text($('#hdnLoanNo').val() || '-');
        $('#af_statusProcess').text($('#hdnProcess').val() || '-');
    }

    function loadCategories() {
        pageMethod('GetCategories', {}, function (rows) {
            fillSelect($('#af_category'), rows || [], 'ErrorId', 'Type', '');
            fillSelect($('#af_subCategory'), [{ ErrorSubId: '', SubType: 'Select' }], 'ErrorSubId', 'SubType', '');
        });
    }

    function loadSubCategories() {
        var categoryId = parseInt($('#af_category').val() || '0', 10);

        if (!categoryId || categoryId < 0) {
            fillSelect($('#af_subCategory'), [{ ErrorSubId: '', SubType: 'Select' }], 'ErrorSubId', 'SubType', '');
            return;
        }

        pageMethod('GetSubCategories', { categoryId: categoryId }, function (rows) {
            fillSelect($('#af_subCategory'), rows || [], 'ErrorSubId', 'SubType', '');
        });
    }

    function loadErrorBy() {
        var process = $('#af_markedTo').val() || '';
        $('#hdnProcess').val(process);
        setContextLabels();

        pageMethod('GetErrorByForProcess', { process: process }, function (data) {
            data = data || {};
            fillSelect($('#af_errorBy'), data.ErrorByList || [], 'Value', 'Text', data.ErrorBy);
        });
    }

    function fillSelect($select, rows, valueKey, textKey, selectedValue) {
        $select.empty();

        $.each(rows || [], function (_, row) {
            var value = row[valueKey] === undefined || row[valueKey] === null ? '' : String(row[valueKey]);
            var text = row[textKey] === undefined || row[textKey] === null ? '' : String(row[textKey]);
            $select.append($('<option></option>').val(value).text(text));
        });

        if (!$select.children().length) {
            $select.append($('<option></option>').val('').text('Select'));
        }

        selectValue($select, selectedValue);
    }

    function selectValue($select, selectedValue) {
        selectedValue = selectedValue === undefined || selectedValue === null ? '' : String(selectedValue);
        $select.val(selectedValue);

        if (selectedValue && $select.val() === null) {
            $select.append($('<option></option>').val(selectedValue).text(selectedValue)).val(selectedValue);
        }
    }

    function clearFeedbackFields() {
        $('#af_errorType,#af_severity,#af_feedbackType').val('');
        $('#af_errorField,#af_error,#af_shouldBe,#af_remark').val('');
        $('#af_category').val('');
        fillSelect($('#af_subCategory'), [{ ErrorSubId: '', SubType: 'Select' }], 'ErrorSubId', 'SubType', '');
        applyNoFeedbackState();
    }

    function applyNoFeedbackState() {
        var noFeedback = $('#af_errorType').val() === 'NoFeedback';
        var $category = $('#af_category');
        var $subCategory = $('#af_subCategory');
        var $disabledFields = $('#af_severity,#af_errorField,#af_error,#af_shouldBe,#af_remark');

        if (noFeedback) {
            ensureOption($category, 'NA', 'NA');
            ensureOption($subCategory, 'NA', 'NA');
            $category.val('NA').prop('disabled', true);
            $subCategory.val('NA').prop('disabled', true);
            $('#af_severity').val('').prop('disabled', true);
            $('#af_errorField,#af_error,#af_shouldBe,#af_remark').val('NA');
            $('#af_feedbackType').val('Internal');
            $disabledFields.prop('disabled', true);
        } else {
            $category.prop('disabled', false);
            $subCategory.prop('disabled', false);
            $disabledFields.prop('disabled', false);

            if ($('#af_errorField').val() === 'NA') $('#af_errorField').val('');
            if ($('#af_error').val() === 'NA') $('#af_error').val('');
            if ($('#af_shouldBe').val() === 'NA') $('#af_shouldBe').val('');
            if ($('#af_remark').val() === 'NA') $('#af_remark').val('');
        }
    }

    function ensureOption($select, value, text) {
        var exists = $select.find('option').filter(function () {
            return $(this).val() === value;
        }).length > 0;

        if (!exists) {
            $select.append($('<option></option>').val(value).text(text));
        }
    }

    function collectModel() {
        return {
            ProjectNo: $('#hdnProjectNo').val() || '',
            ProjectId: $('#hdnProjectId').val() || '',
            DealNo: $('#hdnDealNo').val() || '',
            LoanNo: $('#hdnLoanNo').val() || '',
            OrderDate: $('#hdnOrderDate').val() || '',
            MarkedTo: $('#af_markedTo').val() || '',
            ErrorBy: $('#af_errorBy option:selected').text() || '',
            FeedbackBy: $('#af_feedbackBy').val() || '',
            ErrorType: $('#af_errorType').val() || '',
            Category: $('#af_category option:selected').text() || '',
            SubCategory: $('#af_subCategory option:selected').text() || '',
            Severity: $('#af_severity').val() || '',
            ErrorField: $('#af_errorField').val() || '',
            Error: $('#af_error').val() || '',
            ShouldBe: $('#af_shouldBe').val() || '',
            Remark: $('#af_remark').val() || '',
            FeedbackType: $('#af_feedbackType').val() || ''
        };
    }

    function validateModel(model) {
        var noFeedback = model.ErrorType === 'NoFeedback';
        if (!model.MarkedTo) return 'Please Select Marked to.';
        if (!model.ErrorBy || model.ErrorBy === 'Select') return 'Please Select Error By.';
        if (!model.ErrorType) return 'Please Select Error Type.';
        if (!model.Category || model.Category === 'Select') return 'Please Select Error Category.';
        if (!model.SubCategory || model.SubCategory === 'Select') return 'Please Select Error Sub Category.';
        if (!noFeedback && !model.Severity) return 'Please Select Severity.';
        if (!noFeedback && !$.trim(model.ErrorField)) return 'Please Enter Error Field.';
        if (!model.FeedbackType) return 'Please Select Feedback Type.';
        if (!noFeedback && !$.trim(model.Error)) return 'Please Enter Error.';
        if (!noFeedback && !$.trim(model.ShouldBe)) return 'Please Enter Should Be.';

        if ($.trim(model.FeedbackBy).toUpperCase() === $.trim(model.ErrorBy).toUpperCase()) {
            return 'Feedback Given By and Error Done By both are same is not valid, please check!!.';
        }

        return '';
    }

    function saveFeedback() {
        var model = collectModel();
        var validation = validateModel(model);

        if (validation) {
            showMessage('warning', validation);
            return false;
        }

        $('#af_btnSave').prop('disabled', true);
        showLoading('Saving feedback...');

        pageMethod('SaveFeedback', { model: model }, function (result) {
            hideLoading();
            $('#af_btnSave').prop('disabled', false);
            result = result || {};
            showMessage(result.Success ? 'success' : 'warning', result.Message || (result.Success ? 'Feedback added successfully.' : 'Unable to add feedback.'));

            if (result.Success) {
                addFeedbackRecord(model);
                clearFeedbackFields();
                loadFeedbackRecords();
            }
        }, function (message) {
            hideLoading();
            $('#af_btnSave').prop('disabled', false);
            showMessage('error', message || 'Something went wrong while adding feedback.');
        });

        return false;
    }

    function initFeedbackTable() {
        if (!$.fn.DataTable || $.fn.DataTable.isDataTable('#af_feedbackTable')) {
            return;
        }

        feedbackTable = $('#af_feedbackTable').DataTable({
            data: [],
            paging: true,
            pageLength: 5,
            lengthChange: false,
            searching: false,
            info: true,
            ordering: false,
            autoWidth: false,
            responsive: false,
            language: {
                emptyTable: 'No feedback has been added for this loan.'
            },
            columns: [
                {
                    data: null,
                    width: '45px',
                    render: function (data, type, row, meta) {
                        return meta.row + 1;
                    }
                },
                { data: 'Process', render: renderTableText },
                { data: 'ErrorBy', render: renderTableText },
                { data: 'ErrorType', render: renderTableText },
                { data: 'Category', render: renderTableText },
                { data: 'SubCategory', render: renderTableText },
                { data: 'Severity', render: renderTableText },
                { data: 'FeedbackType', render: renderTableText },
                { data: 'Remark', render: renderTableText },
                { data: 'AddedOn', render: renderTableText }
            ]
        });
    }

    function renderTableText(value, type) {
        var text = value === undefined || value === null || String(value).trim() === '' ? '-' : String(value);
        return type === 'display' ? escapeHtml(text) : text;
    }

    function escapeHtml(value) {
        return $('<div></div>').text(value === undefined || value === null ? '' : String(value)).html();
    }

    function addFeedbackRecord(model) {
        feedbackRows.unshift(normalizeFeedbackRecord($.extend({}, model, {
            Process: model.MarkedTo,
            AddedOn: new Date().toLocaleString()
        })));
        drawFeedbackTable();
    }

    function loadFeedbackRecords() {
        var request = {
            ProjectId: $('#hdnProjectId').val() || '',
            LoanNo: $('#hdnLoanNo').val() || '',
            Process: $('#hdnProcess').val() || $('#af_markedTo').val() || '',
            FeedbackBy: $('#af_feedbackBy').val() || ''
        };

        if (!request.ProjectId || !request.LoanNo) {
            drawFeedbackTable();
            return false;
        }

        $('#af_btnRefreshFeedback').prop('disabled', true);
        pageMethod('GetFeedbackRecords', { request: request }, function (result) {
            $('#af_btnRefreshFeedback').prop('disabled', false);
            result = result || {};

            if (result.Success && $.isArray(result.Rows)) {
                feedbackRows = $.map(result.Rows, normalizeFeedbackRecord);
                drawFeedbackTable();
            }
        }, function () {
            $('#af_btnRefreshFeedback').prop('disabled', false);
            drawFeedbackTable();
        });

        return false;
    }

    function normalizeFeedbackRecord(row) {
        row = row || {};
        return {
            Process: firstRowValue(row, ['Process', 'ProcessName', 'MarkedTo']),
            ErrorBy: firstRowValue(row, ['ErrorBy', 'ErrorDoneBy', 'ErrorDoneByName', 'Employee']),
            ErrorType: firstRowValue(row, ['ErrorType', 'Type']),
            Category: firstRowValue(row, ['Category', 'Section', 'ErrorCategory']),
            SubCategory: firstRowValue(row, ['SubCategory', 'Subcategory', 'Field', 'ErrorSubcategory']),
            Severity: firstRowValue(row, ['Severity', 'Fatal']),
            FeedbackType: firstRowValue(row, ['FeedbackType']),
            Remark: firstRowValue(row, ['Remark', 'Remarks']),
            AddedOn: firstRowValue(row, ['AddedOn', 'AddedDate', 'CreatedOn', 'FeedbackDate'])
        };
    }

    function firstRowValue(row, keys) {
        for (var i = 0; i < keys.length; i++) {
            var value = row[keys[i]];
            if (value !== undefined && value !== null && String(value).trim() !== '') {
                return String(value).trim();
            }
        }
        return '';
    }

    function drawFeedbackTable() {
        $('#af_feedbackCount').text(feedbackRows.length);

        if (feedbackTable) {
            feedbackTable.clear().rows.add(feedbackRows).draw(false);
            return;
        }

        var $body = $('#af_feedbackTable tbody').empty();
        $.each(feedbackRows, function (index, row) {
            var $tr = $('<tr></tr>');
            $('<td></td>').text(index + 1).appendTo($tr);
            $.each(['Process', 'ErrorBy', 'ErrorType', 'Category', 'SubCategory', 'Severity', 'FeedbackType', 'Remark', 'AddedOn'], function (_, key) {
                $('<td></td>').text(row[key] || '-').appendTo($tr);
            });
            $tr.appendTo($body);
        });
    }

    function toggleHoldReason() {
        var isHold = $('#af_status').val() === 'Hold';
        $('#af_holdReason').prop('disabled', !isHold);

        if (!isHold) {
            $('#af_holdReason').val('');
        }
    }

    function clearStatusFields() {
        $('#af_status,#af_holdReason').val('');
        $('#af_statusRemark').val('');
        $('#af_holdReason').prop('disabled', true);
    }

    function updateLoanStatus() {
        var status = $('#af_status').val() || '';
        var holdReason = $('#af_holdReason').val() || '';
        var remark = $('#af_statusRemark').val() || '';

        if (!status) {
            showMessage('warning', 'Please select Status.');
            return false;
        }

        if (status === 'Hold' && !holdReason) {
            showMessage('warning', 'Hold Reason is mandatory when Status is Hold.');
            return false;
        }

        var request = {
            Project: $('#hdnProjectNo').val() || '',
            ProjectId: $('#hdnProjectId').val() || '',
            DealNo: $('#hdnDealNo').val() || '',
            OrderNo: $('#hdnLoanNo').val() || '',
            Process: $('#hdnProcess').val() || $('#af_markedTo').val() || '',
            Status: status,
            HoldRemark: holdReason,
            Remark: remark,
            ProductType: '',
            UserName: $('#af_feedbackBy').val() || ''
        };

        $('#af_btnUpdateStatus').prop('disabled', true);
        showLoading('Updating loan status...');

        pageMethod('UpdateLoanStatus', { request: request }, function (result) {
            hideLoading();
            $('#af_btnUpdateStatus').prop('disabled', false);
            result = result || {};
            showMessage(result.Success ? 'success' : 'warning', result.Message || (result.Success ? 'Loan status updated successfully.' : 'Unable to update loan status.'));

            if (result.Success) {
                clearStatusFields();
            }
        }, function (message) {
            hideLoading();
            $('#af_btnUpdateStatus').prop('disabled', false);
            showMessage('error', message || 'Something went wrong while updating loan status.');
        });

        return false;
    }

    function setSelectedFile(file) {
        if (file && !/\.(xls|xlsx|csv)$/i.test(file.name)) {
            selectedFile = null;
            $('#af_importFile').val('');
            $('#af_fileName').text('Drop feedback file here or click to browse');
            showMessage('warning', 'Only .xls, .xlsx, and .csv files are supported.');
            return;
        }

        selectedFile = file;
        $('#af_fileName').text(file ? file.name : 'Drop feedback file here or click to browse');
        resetImportResults();
    }

    function uploadFeedback() {
        if (!selectedFile) {
            showMessage('warning', 'Please select a feedback file.');
            return false;
        }

        showMessage('info', 'The import layout is ready. Connect the AddFeedback import WebMethod to process ' + selectedFile.name + '.');
        return false;
    }

    function resetImportResults() {
        $('#af_importTotal,#af_importAdded,#af_importFailed').text('0');
        $('#af_addedTable tbody,#af_failedTable tbody').empty();
    }

    function downloadFormat() {
        var csv = importHeaders.join(',') + '\r\n';
        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var url = URL.createObjectURL(blob);
        var link = document.createElement('a');
        link.href = url;
        link.download = 'Feedback_Import_Format.csv';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    function showLoading(message) {
        $('#af_loadingText').text(message || 'Please wait...');
        $('#af_loading').css('display', 'flex').attr('aria-hidden', 'false');
    }

    function hideLoading() {
        $('#af_loading').hide().attr('aria-hidden', 'true');
    }

    function showMessage(type, message) {
        var title = type === 'success' ? 'Success' : type === 'error' ? 'Error' : type === 'warning' ? 'Validation' : 'Information';

        if (window.Swal) {
            Swal.fire({ icon: type, title: title, text: message });
        } else {
            alert(message);
        }
    }

    function closePage() {
        if (window.parent && window.parent !== window && window.parent.$) {
            try {
                window.parent.$('.ui-dialog-content').dialog('close');
                return false;
            } catch (e) { }
        }

        window.close();
        return false;
    }

    return {
        init: init,
        showPanel: showPanel,
        loadDefaults: loadDefaults,
        loadCategories: loadCategories,
        loadSubCategories: loadSubCategories,
        loadErrorBy: loadErrorBy,
        applyNoFeedbackState: applyNoFeedbackState,
        clearFeedbackFields: clearFeedbackFields,
        saveFeedback: saveFeedback,
        loadFeedbackRecords: loadFeedbackRecords,
        clearStatusFields: clearStatusFields,
        updateLoanStatus: updateLoanStatus,
        uploadFeedback: uploadFeedback,
        downloadFormat: downloadFormat,
        closePage: closePage
    };
})();

$(document).ready(function () {
    AddFeedback.init();
});
