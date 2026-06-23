

/*---------------- Tab 1 - Order Allocation ----------------*/

function allocate_bindProcess() {

    var prjId = 17;

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetProcessByProject",
        data: JSON.stringify({ ProjectID: prjId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            var ddl = $("#allocate_process");
            ddl.empty();

            ddl.append($("<option></option>").val("").text("Select Process"));

            var data = JSON.parse(response.d);

            $.each(data, function (i, item) {
                ddl.append($("<option></option>").val(item.ProcessName).text(item.ProcessName));
            });
        },
        error: function (xhr, status, error) {
            console.log(error);
            alert("Unable to load process list.");
        }
    });
}

function GetLoansToAllocate() {

    var processName = $('#allocate_process').val();
    processName = 'Loan Setup';
    if (processName == '') {
        Swal.fire({ icon: 'warning', title: 'Validation Error', text: 'Please select an Allocate Process.', confirmButtonText: 'OK' });
        return false;
    }

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetLoansToAllocate",
        data: JSON.stringify({ ProcessName: processName, Type: "Allocation" }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            var dataArray = data.d;

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_OrderAllocate')) {
                $('#table_OrderAllocate').DataTable().destroy();
            }

            $('#table_OrderAllocate').DataTable({

                data: dataArray,

                dom: 'ftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,

                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "ProjectName" },
                    { data: "Process" },
                    { data: "DealNo" },
                    { data: "LoanNo" },
                    { data: "CurrentStatus" },
                    { data: "Remark" },
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            alert("Error loading data");
        }
    });
}



/*---------------- Tab 2 - Order Status ----------------*/

function allocate_bindCompleteOrder_Grid() {

    var UserName = 'SHAWN MITCHELL';
    var UserName = 'VPC';
    var Process = "Loan Setup";



    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetUserLoans",
        data: JSON.stringify({ UserName: UserName }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            var dataArray = data.d;

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_OrderComplete')) {
                $('#table_OrderComplete').DataTable().destroy();
            }

            $('#table_OrderComplete').DataTable({

                data: dataArray,
                dom: 'ftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,

                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "ProjectName" },
                    { data: "ProjectName" },
                    { data: "ProjectName" },
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `
        <select class="form-control Status" style="min-width:150px;" onchange="enableHoldRemark(this)">
            <option value="">Select</option>
            <option value="Completed" ${data === "Completed" ? "selected" : ""}>Completed</option>
            <option value="Hold" ${data === "Hold" ? "selected" : ""}>Hold</option>
        </select>`;
                        }
                    },
                    {
                        data: null,
                        render: function (data, type, row) {

                            var disabled = row.Status === "Hold" ? "" : "disabled";

                            return `
        <select class="form-control HoldReason" ${disabled} style="min-width:270px;">
            <option value="">Select</option>
            <option value="PDF Issue" ${data === "PDF Issue" ? "selected" : ""}>PDF Issue</option>
            <option value="Audit Worksheet Not available in Box" ${data === "Audit Worksheet Not available in Box" ? "selected" : ""}>Audit Worksheet Not available in Box</option>
            <option value="Partially Review in Scienna" ${data === "Partially Review in Scienna" ? "selected" : ""}>Partially Review in Scienna</option>
            <option value="Wrongly pulled in ERP" ${data === "Wrongly pulled in ERP" ? "selected" : ""}>Wrongly pulled in ERP</option>
            <option value="Miscellaneous – Any other issue with comments"
                ${data === "Miscellaneous – Any other issue with comments" ? "selected" : ""}>
                Miscellaneous – Any other issue with comments
            </option>
        </select>`;
                        }
                    },
                    {
                        data: null,
                        render: function (data, type, row) {
                            return `<button type="button" class="alloc-open-feedback openRemarkPopup" title="Add Feedback">
                                <i class="fas fa-comment-dots"></i><span>Add Feedback</span>
                            </button>`;
                        }
                    },
                    {
                        data: "Remark",
                        render: function (data, type, row) {
                            return `<textarea class="form-control Remark" style="min-width:400px;">${data || ""}</textarea>`;
                        }
                    },
                    { data: "ProjectName" },
                    { data: "ProjectName" },
                    {
                        data: null,
                        title: "Action",
                        orderable: false,
                        className: "text-center",
                        render: function (data, type, row, meta) {
                            return `
            <button type="button"
                class="btn btn-sm btn-primary"
                onclick="updateOrderStatus(this)">
                <i class="fas fa-save"></i> Update
            </button>`;
                        }
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            alert("Error loading data");
        }
    });
}

function updateOrderStatus(btn) {

    var table = $('#table_OrderComplete').DataTable();
    var tr = $(btn).closest('tr');
    var row = table.row(tr).data();

    var status = tr.find('.Status').val();

    var holdReason = tr.find('.HoldReason').val();
    var remark = tr.find('.Remark').val();

    if (!status) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Status.'
        });
        return;
    }

    if (status === "Hold" && !holdReason) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Hold Reason is mandatory when Status is Hold.'
        });
        return;
    }

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/UpdateLoanStatus",
        data: JSON.stringify({
            Project: row.ProjectName || "",
            DealNo: row.DealNo || "",
            OrderNo: row.OrderNo || "",
            Process: row.DomainName || "",
            ProjectID: row.ProjectID || "",
            Status: status,
            HoldRemark: holdReason || "",
            Remark: remark || "",
            ProductType: row.ProductType || "",
            UserName: "VPC"
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        beforeSend: function () {
            Swal.fire({
                title: 'Saving...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: function () {
                    Swal.showLoading();
                }
            });
        },

        success: function (response) {
            Swal.close();

            if (response.d > 0) {
                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Loan status updated successfully.',
                    timer: 2000,
                    showConfirmButton: false
                });

                $(btn)
                    .removeClass('btn-primary')
                    .addClass('btn-success')
                    .html('<i class="fas fa-check"></i> Updated');
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Failed',
                    text: 'Unable to update loan status.'
                });
            }
        },

        error: function (xhr) {
            Swal.close();

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Something went wrong while saving data.'
            });

            console.log(xhr.responseText);
        }
    });
}

function enableHoldRemark(obj) {

    var tr = $(obj).closest('tr');
    var holdReason = tr.find('.HoldReason');

    if ($(obj).val() === 'Hold') {
        holdReason.prop('disabled', false);
    }
    else {
        holdReason.val('');
        holdReason.prop('disabled', true);
    }
}



$(document).on('click', '.openRemarkPopup', function () {
    var table = $('#table_OrderComplete').DataTable();
    var row = table.row($(this).closest('tr')).data() || {};
    AllocateFeedbackPopup.open(row);
});

/*---------------- Tab 3 - Order Allocation ----------------*/

function allocate_GetLoanReport() {

    var fromDate = $("#allocate_FromDate").val();
    var toDate = $("#allocate_ToDate").val();

    if (fromDate == "") {
        Swal.fire('Validation', 'Please select From Date.', 'warning');
        return false;
    }

    if (toDate == "") {
        Swal.fire('Validation', 'Please select To Date.', 'warning');
        return false;
    }

    // $('#load1').show();

    allocate_GetLoanReport_Grid(fromDate, toDate);
}

function allocate_GetLoanReport_Grid(fromDate, toDate) {

    var UserName = '';

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetUserOrders",
        data: JSON.stringify({ UserName: UserName, FromDate: fromDate, ToDate: toDate }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            var dataArray = data.d;

            // Destroy existing DataTable
            if ($.fn.DataTable.isDataTable('#table_Orderreport')) {
                $('#table_Orderreport').DataTable().destroy();
            }

            $('#table_Orderreport').DataTable({

                data: dataArray,
                dom: 'ftip',
                scrollX: true,
                paging: true,
                autoWidth: false,
                ordering: false,
                processing: true,

                select: {
                    style: 'single'
                },

                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "ProjectName" },
                    { data: "DealNo" },
                    { data: "OrderNumber" },
                    { data: "OrderStatus" },
                    { data: "Remark" },/* "HoldReason" */
                    { data: "Remark" },
                    { data: "StartDate" },
                    { data: "ProcessDate" },
                    { data: "TAT" }
                ],

                initComplete: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr) {

            $('#load1').hide();

            console.error(xhr.responseText);

            alert("Error loading data");
        }
    });
}

var AllocateFeedbackPopup = (function () {
    var selectedContext = {};
    var selectedFile = null;
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

    function init() {
        bindEvents();
    }

    function bindEvents() {
        $('#allocfb_markedTo').off('change.allocfb').on('change.allocfb', function () {
            selectedContext.Process = $(this).val();
            setContextLabels(selectedContext);
            loadDefaults(selectedContext, false);
        });

        $('#allocfb_category').off('change.allocfb').on('change.allocfb', function () {
            loadSubCategories($(this).val());
        });

        $('#allocfb_errorType').off('change.allocfb').on('change.allocfb', applyNoFeedbackState);
        $('#allocfb_btnClear').off('click.allocfb').on('click.allocfb', clearAddFeedbackForm);
        $('#allocfb_btnSave').off('click.allocfb').on('click.allocfb', saveFeedback);
        $('#allocfb_btnUpload').off('click.allocfb').on('click.allocfb', uploadFeedback);
        $('#allocfb_btnFormat').off('click.allocfb').on('click.allocfb', downloadFormat);

        $('#allocfb_dropzone')
            .off('click.allocfb dragover.allocfb dragleave.allocfb drop.allocfb')
            .on('click.allocfb', function () {
                $('#allocfb_importFile').trigger('click');
            })
            .on('dragover.allocfb', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).addClass('is-dragover');
            })
            .on('dragleave.allocfb', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).removeClass('is-dragover');
            })
            .on('drop.allocfb', function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(this).removeClass('is-dragover');
                var files = e.originalEvent.dataTransfer.files;
                setSelectedFile(files && files.length ? files[0] : null);
            });

        $('#allocfb_importFile').off('change.allocfb').on('change.allocfb', function () {
            setSelectedFile(this.files && this.files.length ? this.files[0] : null);
        });

        $('#popUp_addTrackingFeedback').off('hidden.bs.modal.allocfb').on('hidden.bs.modal.allocfb', function () {
            selectedFile = null;
            $('#allocfb_importFile').val('');
            $('#allocfb_fileName').text('Drop feedback file here or click to browse');
        });
    }

    function open(row) {
        selectedContext = buildContext(row);
        setContextLabels(selectedContext);
        resetImportResults();
        clearAddFeedbackForm();
        $('#allocfb-add-tab').tab('show');
        $('#popUp_addTrackingFeedback').modal('show');
        loadDefaults(selectedContext, true);
    }

    function buildContext(row) {
        row = row || {};

        return {
            ProjectNo: firstValue(row, ['ProjectNo', 'ProjectName', 'Project', 'ProjectNumber']),
            ProjectId: firstValue(row, ['ProjectID', 'ProjectId']) || '17',
            DealNo: firstValue(row, ['DealNo', 'Deal', 'DealNumber', 'UniqueCol1']),
            LoanNo: firstValue(row, ['LoanNo', 'OrderNo', 'OrderNumber', 'Loan1No', 'UniqueCol2']),
            OrderDate: normalizeDate(firstValue(row, ['OrderDate', 'AllocatedDate', 'StartDate', 'ProcessDate'])),
            Process: firstValue(row, ['Process', 'DomainName', 'ProcessName']) || $('#allocate_process').val() || 'Loan Setup',
            ErrorBy: firstValue(row, ['Employee', 'ErrorBy', 'UserName', 'UserCode']),
            FeedbackBy: ''
        };
    }

    function firstValue(row, keys) {
        for (var i = 0; i < keys.length; i++) {
            var value = row[keys[i]];
            if (value !== undefined && value !== null && String(value).trim() !== '') {
                return String(value).trim();
            }
        }
        return '';
    }

    function normalizeDate(value) {
        if (!value) return '';
        var text = String(value);
        var aspDate = /\/Date\((\d+)\)\//.exec(text);
        if (aspDate) {
            var date = new Date(parseInt(aspDate[1], 10));
            if (!isNaN(date.getTime())) {
                return formatDate(date);
            }
        }
        return text;
    }

    function formatDate(date) {
        var month = zeroPad(date.getMonth() + 1);
        var day = zeroPad(date.getDate());
        return month + '/' + day + '/' + date.getFullYear();
    }

    function zeroPad(value) {
        value = String(value);
        return value.length === 1 ? '0' + value : value;
    }

    function setContextLabels(context) {
        $('#allocfb_ctxProject').text(context.ProjectNo || '-');
        $('#allocfb_ctxDeal').text(context.DealNo || '-');
        $('#allocfb_ctxLoan').text(context.LoanNo || '-');
        $('#allocfb_ctxProcess').text(context.Process || '-');
        $('#allocfb_ctxOrderDate').text(context.OrderDate || '-');
    }

    function loadDefaults(context, refreshCategories) {
        $.ajax({
            type: 'POST',
            url: 'Allocate.aspx/GetTrackingFeedbackDefaults',
            data: JSON.stringify({ context: context }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                var result = response.d || {};
                if (!result.Success) {
                    Swal.fire('Error', result.Message || 'Unable to load feedback details.', 'error');
                    return;
                }

                selectedContext = $.extend({}, selectedContext, result.Context || {});
                setContextLabels(selectedContext);

                bindSelect($('#allocfb_markedTo'), result.Processes || [], selectedContext.Process || selectedContext.MarkedTo);
                bindSelect($('#allocfb_errorBy'), result.ErrorByList || [], selectedContext.ErrorBy);
                $('#allocfb_feedbackBy').val(selectedContext.FeedbackBy || '');

                if (refreshCategories) {
                    bindSelect($('#allocfb_category'), result.Categories || [], '');
                    bindSelect($('#allocfb_subCategory'), [{ Value: '', Text: 'Select' }], '');
                }

                applyNoFeedbackState();
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                Swal.fire('Error', 'Unable to load feedback details.', 'error');
            }
        });
    }

    function loadSubCategories(categoryId) {
        if (!categoryId || categoryId === 'NA') {
            bindSelect($('#allocfb_subCategory'), [{ Value: '', Text: 'Select' }], '');
            return;
        }

        $.ajax({
            type: 'POST',
            url: 'Allocate.aspx/GetTrackingFeedbackSubCategories',
            data: JSON.stringify({ categoryId: parseInt(categoryId, 10) || 0 }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function (response) {
                bindSelect($('#allocfb_subCategory'), response.d || [], '');
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                Swal.fire('Error', 'Unable to load subcategory list.', 'error');
            }
        });
    }

    function bindSelect($select, items, selectedValue) {
        $select.empty();
        $.each(items || [], function (_, item) {
            var value = item.Value !== undefined ? item.Value : item.value;
            var text = item.Text !== undefined ? item.Text : item.text;
            $select.append($('<option></option>').val(value || '').text(text || ''));
        });

        if (selectedValue !== undefined && selectedValue !== null && selectedValue !== '') {
            var matched = false;
            $select.find('option').each(function () {
                if ($(this).val().toLowerCase() === String(selectedValue).toLowerCase() ||
                    $(this).text().toLowerCase() === String(selectedValue).toLowerCase()) {
                    $select.val($(this).val());
                    matched = true;
                    return false;
                }
            });

            if (!matched) {
                $select.append($('<option></option>').val(selectedValue).text(selectedValue));
                $select.val(selectedValue);
            }
        }
    }

    function clearAddFeedbackForm() {
        $('#allocfb_errorType,#allocfb_severity,#allocfb_feedbackType').val('');
        $('#allocfb_errorField,#allocfb_error,#allocfb_shouldBe,#allocfb_remark').val('');
        $('#allocfb_category').val('');
        bindSelect($('#allocfb_subCategory'), [{ Value: '', Text: 'Select' }], '');
        applyNoFeedbackState();
    }

    function applyNoFeedbackState() {
        var noFeedback = $('#allocfb_errorType').val() === 'NoFeedback';
        var $category = $('#allocfb_category');
        var $subCategory = $('#allocfb_subCategory');
        var $disabledFields = $('#allocfb_severity,#allocfb_errorField,#allocfb_error,#allocfb_shouldBe,#allocfb_remark');

        if (noFeedback) {
            ensureOption($category, 'NA', 'NA');
            ensureOption($subCategory, 'NA', 'NA');
            $category.val('NA').prop('disabled', true);
            $subCategory.val('NA').prop('disabled', true);
            $('#allocfb_severity').val('').prop('disabled', true);
            $('#allocfb_errorField').val('NA');
            $('#allocfb_error').val('NA');
            $('#allocfb_shouldBe').val('NA');
            $('#allocfb_remark').val('NA');
            $('#allocfb_feedbackType').val('Internal');
            $disabledFields.prop('disabled', true);
        } else {
            $category.prop('disabled', false);
            $subCategory.prop('disabled', false);
            $disabledFields.prop('disabled', false);
            if ($('#allocfb_errorField').val() === 'NA') $('#allocfb_errorField').val('');
            if ($('#allocfb_error').val() === 'NA') $('#allocfb_error').val('');
            if ($('#allocfb_shouldBe').val() === 'NA') $('#allocfb_shouldBe').val('');
            if ($('#allocfb_remark').val() === 'NA') $('#allocfb_remark').val('');
        }
    }

    function ensureOption($select, value, text) {
        var exists = false;
        $select.find('option').each(function () {
            if ($(this).val() === value) {
                exists = true;
                return false;
            }
        });
        if (!exists) {
            $select.append($('<option></option>').val(value).text(text));
        }
    }

    function collectFeedbackModel() {
        return {
            ProjectNo: selectedContext.ProjectNo || '',
            ProjectId: selectedContext.ProjectId || '',
            DealNo: selectedContext.DealNo || '',
            LoanNo: selectedContext.LoanNo || '',
            OrderDate: selectedContext.OrderDate || '',
            Process: selectedContext.Process || '',
            MarkedTo: $('#allocfb_markedTo').val() || '',
            ErrorBy: $('#allocfb_errorBy').val() || '',
            FeedbackBy: $('#allocfb_feedbackBy').val() || selectedContext.FeedbackBy || '',
            ErrorType: $('#allocfb_errorType').val() || '',
            Category: $('#allocfb_category option:selected').text() || '',
            SubCategory: $('#allocfb_subCategory option:selected').text() || '',
            Severity: $('#allocfb_severity').val() || '',
            ErrorField: $('#allocfb_errorField').val() || '',
            Error: $('#allocfb_error').val() || '',
            ShouldBe: $('#allocfb_shouldBe').val() || '',
            Remark: $('#allocfb_remark').val() || '',
            FeedbackType: $('#allocfb_feedbackType').val() || ''
        };
    }

    function validateFeedback(model) {
        var noFeedback = model.ErrorType === 'NoFeedback';
        if (!model.MarkedTo) return 'Please Select Marked to.';
        if (!model.ErrorBy) return 'Please Select Error By.';
        if (!model.ErrorType) return 'Please Select Error Type.';
        if (!model.Category || model.Category === 'Select') return 'Please Select Error Category.';
        if (!model.SubCategory || model.SubCategory === 'Select') return 'Please Select Error Sub Category.';
        if (!noFeedback && !model.Severity) return 'Please Select Severity.';
        if (!noFeedback && !model.ErrorField) return 'Please Enter Error Field.';
        if (!model.FeedbackType) return 'Please Select Feedback Type.';
        if (!noFeedback && !model.Error) return 'Please Enter Error.';
        if (!noFeedback && !model.ShouldBe) return 'Please Enter Should Be.';
        if (model.FeedbackBy && model.ErrorBy && model.FeedbackBy.toLowerCase() === model.ErrorBy.toLowerCase()) {
            return 'Feedback Given By and Error Done By both are same is not valid, please check!!.';
        }
        return '';
    }

    function saveFeedback() {
        var model = collectFeedbackModel();
        var validation = validateFeedback(model);
        if (validation) {
            Swal.fire('Validation', validation, 'warning');
            return;
        }

        $.ajax({
            type: 'POST',
            url: 'Allocate.aspx/SaveTrackingFeedback',
            data: JSON.stringify({ model: model }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            beforeSend: function () {
                Swal.fire({
                    title: 'Saving feedback...',
                    text: 'Please wait',
                    allowOutsideClick: false,
                    didOpen: function () {
                        Swal.showLoading();
                    }
                });
            },
            success: function (response) {
                Swal.close();
                var result = response.d || {};
                if (result.Success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: result.Message || 'Feedback added successfully.',
                        timer: 1800,
                        showConfirmButton: false
                    });
                    clearAddFeedbackForm();
                } else {
                    Swal.fire('Failed', result.Message || 'Unable to add feedback.', 'error');
                }
            },
            error: function (xhr) {
                Swal.close();
                console.log(xhr.responseText);
                Swal.fire('Error', 'Something went wrong while adding feedback.', 'error');
            }
        });
    }

    function setSelectedFile(file) {
        selectedFile = file;
        $('#allocfb_fileName').text(file ? file.name : 'Drop feedback file here or click to browse');
        resetImportResults();
    }

    function uploadFeedback() {
        if (!selectedFile) {
            Swal.fire('Validation', 'Please select feedback file.', 'warning');
            return;
        }

        var validExtensions = ['.xls', '.xlsx', '.csv'];
        var extension = selectedFile.name.substring(selectedFile.name.lastIndexOf('.')).toLowerCase();
        if (validExtensions.indexOf(extension) === -1) {
            Swal.fire('Validation', 'Only .xls, .xlsx and .csv files are supported.', 'warning');
            return;
        }

        var reader = new FileReader();
        reader.onload = function (event) {
            importFeedbackFile(event.target.result);
        };
        reader.onerror = function () {
            Swal.fire('Error', 'Unable to read selected file.', 'error');
        };
        reader.readAsDataURL(selectedFile);
    }

    function importFeedbackFile(contentBase64) {
        $.ajax({
            type: 'POST',
            url: 'Allocate.aspx/ImportTrackingFeedback',
            data: JSON.stringify({
                request: {
                    Context: selectedContext,
                    FileName: selectedFile.name,
                    ContentBase64: contentBase64
                }
            }),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            beforeSend: function () {
                Swal.fire({
                    title: 'Importing feedback...',
                    text: 'Please wait',
                    allowOutsideClick: false,
                    didOpen: function () {
                        Swal.showLoading();
                    }
                });
            },
            success: function (response) {
                Swal.close();
                var result = response.d || {};
                renderImportResults(result);

                if (result.Success) {
                    Swal.fire('Import Complete', result.Message || 'Feedback import completed.', result.NotAddedCount > 0 ? 'warning' : 'success');
                } else {
                    Swal.fire('Import Failed', result.Message || 'Unable to import feedback.', 'error');
                }
            },
            error: function (xhr) {
                Swal.close();
                console.log(xhr.responseText);
                Swal.fire('Error', 'Something went wrong while importing feedback.', 'error');
            }
        });
    }

    function resetImportResults() {
        $('#allocfb_importTotal,#allocfb_importAdded,#allocfb_importFailed').text('0');
        $('#allocfb_addedTable tbody,#allocfb_failedTable tbody').empty();
    }

    function renderImportResults(result) {
        result = result || {};
        $('#allocfb_importTotal').text(result.TotalRows || 0);
        $('#allocfb_importAdded').text(result.AddedCount || 0);
        $('#allocfb_importFailed').text(result.NotAddedCount || 0);

        renderRows($('#allocfb_addedTable tbody'), result.AddedRows || [], false);
        renderRows($('#allocfb_failedTable tbody'), result.NotAddedRows || [], true);
    }

    function renderRows($tbody, rows, showMessage) {
        $tbody.empty();
        if (!rows.length) {
            $tbody.append('<tr><td colspan="4" class="text-muted">No records</td></tr>');
            return;
        }

        $.each(rows, function (_, row) {
            $tbody.append(
                '<tr>' +
                '<td>' + escapeHtml(row.DealNo || '') + '</td>' +
                '<td>' + escapeHtml(row.LoanNo || '') + '</td>' +
                '<td>' + escapeHtml(row.Process || '') + '</td>' +
                '<td>' + escapeHtml(showMessage ? (row.Message || '') : (row.ErrorType || '')) + '</td>' +
                '</tr>'
            );
        });
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

    function escapeHtml(value) {
        return $('<div></div>').text(value).html();
    }

    return {
        init: init,
        open: open
    };
})();

$(document).ready(function () {
    AllocateFeedbackPopup.init();
});
