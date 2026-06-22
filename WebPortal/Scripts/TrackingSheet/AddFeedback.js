var AddFeedback = (function () {
    function pageMethod(method, data, success, error) {
        $.ajax({
            type: 'POST',
            url: 'AddFeedback.aspx/' + method,
            data: JSON.stringify(data || {}),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (res) { if (success) success(res.d); },
            error: function (xhr) {
                var msg = 'Unexpected error occurred.';
                try { msg = xhr.responseJSON.Message || xhr.responseText || msg; } catch (e) { }
                if (error) error(msg); else showMessage('error', msg);
            }
        });
    }

    function showMessage(type, message) {
        if (window.Swal) {
            Swal.fire({ icon: type, title: type === 'success' ? 'Success' : 'Information', text: message });
        } else {
            alert(message);
        }
    }

    function fillSelect(selector, rows, valueKey, textKey, selectedValue) {
        var $ddl = $(selector);
        $ddl.empty();
        $.each(rows || [], function (_, r) {
            var value = r[valueKey] == null ? '' : r[valueKey];
            var text = r[textKey] == null ? '' : r[textKey];
            $('<option/>').val(value).text(text).appendTo($ddl);
        });
        if (selectedValue !== undefined && selectedValue !== null && selectedValue !== '') {
            $ddl.val(selectedValue);
            if ($ddl.val() === null) $ddl.append($('<option/>').val(selectedValue).text(selectedValue)).val(selectedValue);
        }
    }

    function init() {
        bindDefaults();
        bindCategories();
        onErrorTypeChanged();
    }

    function bindDefaults() {
        $('#af_stat_project').text($('#hdnProjectNo').val() || '-');
        $('#af_stat_deal').text($('#hdnDealNo').val() || '-');
        $('#af_stat_loan').text($('#hdnLoanNo').val() || '-');
        $('#af_stat_orderdate').text($('#hdnOrderDate').val() || '-');

        pageMethod('GetPageDefaults', {}, function (data) {
            data = data || {};
            $('#hdnProjectNo').val(data.ProjectNo || $('#hdnProjectNo').val());
            $('#hdnDealNo').val(data.DealNo || $('#hdnDealNo').val());
            $('#hdnLoanNo').val(data.LoanNo || $('#hdnLoanNo').val());
            $('#hdnOrderDate').val(data.OrderDate || $('#hdnOrderDate').val());
            $('#hdnProjectId').val(data.ProjectId || $('#hdnProjectId').val());
            $('#hdnProcess').val(data.Process || $('#hdnProcess').val());
            $('#hdnErrorBy').val(data.ErrorBy || $('#hdnErrorBy').val());

            $('#af_stat_project').text($('#hdnProjectNo').val() || '-');
            $('#af_stat_deal').text($('#hdnDealNo').val() || '-');
            $('#af_stat_loan').text($('#hdnLoanNo').val() || '-');
            $('#af_stat_orderdate').text($('#hdnOrderDate').val() || '-');
            $('#ddlMarkedTo').val(data.Process || $('#hdnProcess').val());
            $('#txtFeedbackBy').val(data.FeedbackBy || '');
            fillSelect('#ddlErrorBy', data.ErrorByList, 'Value', 'Text', data.ErrorBy);
        });
    }

    function bindCategories() {
        pageMethod('GetCategories', {}, function (rows) {
            fillSelect('#ddlCategory', rows, 'ErrorId', 'Type');
            bindSubCategories();
        });
    }

    function bindSubCategories() {
        var categoryId = parseInt($('#ddlCategory').val() || '0', 10);
        pageMethod('GetSubCategories', { categoryId: categoryId }, function (rows) {
            fillSelect('#ddlSubCategory', rows, 'ErrorSubId', 'SubType');
        });
    }

    function onMarkedToChanged() {
        pageMethod('GetErrorByForProcess', { process: $('#ddlMarkedTo').val() }, function (data) {
            data = data || {};
            fillSelect('#ddlErrorBy', data.ErrorByList, 'Value', 'Text', data.ErrorBy);
        });
    }

    function setNoFeedbackState(isNoFeedback) {
        var fields = '#ddlSeverity,#txtErrorField,#txtError,#txtShouldBe,#txtRemark,#ddlFeedbackType';
        $(fields).prop('disabled', isNoFeedback);
        if (isNoFeedback) {
            $('#ddlSeverity').val('');
            $('#txtErrorField').val('NA');
            $('#txtError').val('NA');
            $('#txtShouldBe').val('NA');
            $('#txtRemark').val('NA');
            $('#ddlFeedbackType').val('Internal');
            setSelectToText('#ddlCategory', 'NA');
            setSelectToText('#ddlSubCategory', 'NA');
        } else {
            $(fields).prop('disabled', false);
            $('#ddlFeedbackType').val('Internal');
            if ($('#txtErrorField').val() === 'NA') $('#txtErrorField').val('');
            if ($('#txtError').val() === 'NA') $('#txtError').val('');
            if ($('#txtShouldBe').val() === 'NA') $('#txtShouldBe').val('');
            if ($('#txtRemark').val() === 'NA') $('#txtRemark').val('');
        }
    }

    function setSelectToText(selector, text) {
        var $ddl = $(selector);
        var found = false;
        $ddl.find('option').each(function () {
            if ($(this).text().toUpperCase() === text.toUpperCase()) {
                $ddl.val($(this).val());
                found = true;
                return false;
            }
        });
        if (!found) $ddl.append($('<option/>').val(text).text(text)).val(text);
    }

    function onErrorTypeChanged() {
        setNoFeedbackState($('#ddlErrorType').val() === 'NoFeedback');
    }

    function getModel() {
        return {
            ProjectNo: $('#hdnProjectNo').val(),
            ProjectId: $('#hdnProjectId').val(),
            DealNo: $('#hdnDealNo').val(),
            LoanNo: $('#hdnLoanNo').val(),
            OrderDate: $('#hdnOrderDate').val(),
            MarkedTo: $('#ddlMarkedTo').val(),
            ErrorBy: $('#ddlErrorBy option:selected').text(),
            FeedbackBy: $('#txtFeedbackBy').val(),
            ErrorType: $('#ddlErrorType').val(),
            Category: $('#ddlCategory option:selected').text(),
            SubCategory: $('#ddlSubCategory option:selected').text(),
            Severity: $('#ddlSeverity').val(),
            ErrorField: $('#txtErrorField').val(),
            Error: $('#txtError').val(),
            ShouldBe: $('#txtShouldBe').val(),
            Remark: $('#txtRemark').val(),
            FeedbackType: $('#ddlFeedbackType').val()
        };
    }

    function validate(model) {
        var noFeedback = model.ErrorType === 'NoFeedback';
        if (!model.MarkedTo) return 'Please Select Marked to.';
        if (!model.ErrorBy) return 'Please Select Error By.';
        if (!model.ErrorType || model.ErrorType === 'Select') return 'Please Select Error Type.';
        if (!model.Category || model.Category === 'Select') return 'Please Select Error Category.';
        if (!model.SubCategory || model.SubCategory === 'Select') return 'Please Select Error Sub Category.';
        if (!noFeedback && (!model.Severity || model.Severity === 'Select')) return 'Please Select Severity.';
        if (!noFeedback && !$.trim(model.ErrorField)) return 'Please Enter Error Field.';
        if (!model.FeedbackType || model.FeedbackType === 'Select') return 'Please Select Feedback Type.';
        if (!noFeedback && !$.trim(model.Error)) return 'Please Enter Error.';
        if (!noFeedback && !$.trim(model.ShouldBe)) return 'Please Enter Should Be.';
        if ($.trim(model.FeedbackBy).toUpperCase() === $.trim(model.ErrorBy).toUpperCase()) return 'Feedback Given By and Error Done By both are same is not valid, please check!!.';
        return '';
    }

    function saveFeedback() {
        var model = getModel();
        var message = validate(model);
        if (message) { showMessage('warning', message); return false; }
        $('#btnAddFeedback').prop('disabled', true);
        pageMethod('SaveFeedback', { model: model }, function (res) {
            $('#btnAddFeedback').prop('disabled', false);
            showMessage(res.Success ? 'success' : 'warning', res.Message);
            if (res.Success) clearFeedbackFields();
        }, function (msg) {
            $('#btnAddFeedback').prop('disabled', false);
            showMessage('error', msg);
        });
        return false;
    }

    function clearFeedbackFields() {
        $('#txtErrorField,#txtError,#txtShouldBe,#txtRemark').val('');
        $('#ddlErrorType').val('Select');
        $('#ddlSeverity').val('Select');
        $('#ddlFeedbackType').val('Internal');
        $('#ddlCategory').prop('selectedIndex', 0);
        bindSubCategories();
        onErrorTypeChanged();
    }

    function onFileSelected() {
        var file = $('#fuFeedbackExcel')[0].files[0];
        if (!file) return;
        var ok = /\.(xls|xlsx)$/i.test(file.name);
        if (!ok) {
            clearImportFile();
            showMessage('warning', 'Please select Excel file only (.xls or .xlsx).');
        }
    }

    function clearImportFile() { $('#fuFeedbackExcel').val(''); }

    function uploadFeedbackExcel() {
        var file = $('#fuFeedbackExcel')[0].files[0];
        if (!file) { showMessage('warning', 'Please browse feedback Excel file.'); return false; }
        showMessage('info', 'Excel upload requires wiring to your existing server upload handler. UI and validation are ready.');
        return false;
    }

    function downloadFormat() {
        var headers = ['Deal No', 'Loan 1 #', 'Process', 'Error Field', 'Error Category', 'Error Subcategory', 'Error', 'Should be', 'Error Type', 'Severity', 'Feedback Type', 'Remark'];
        var csv = headers.join(',') + '\n';
        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'ImportFeedbackFormat.csv';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    function closeWindow() { window.close(); }

    return {
        init: init,
        bindCategories: bindCategories,
        bindSubCategories: bindSubCategories,
        onMarkedToChanged: onMarkedToChanged,
        onErrorTypeChanged: onErrorTypeChanged,
        saveFeedback: saveFeedback,
        clearFeedbackFields: clearFeedbackFields,
        onFileSelected: onFileSelected,
        clearImportFile: clearImportFile,
        uploadFeedbackExcel: uploadFeedbackExcel,
        downloadFormat: downloadFormat,
        closeWindow: closeWindow
    };
})();

$(document).ready(function () { AddFeedback.init(); });
