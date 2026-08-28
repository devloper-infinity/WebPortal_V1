
/*--------------- Loan Details Functions--------------- */

var USLoanDetails_html;
var USLoanDetails_table;
var usfeedbackLoanStarted = false;
var usfeedbackStartDatetime = "";
var usfeedbackLastProcessID = "";
var usfeedbackLastProcessName = "";
var usfeedbackRecordCount = 0;
var canopyfeedbackGridRows = [];
var feedbackdetailsGridRows = [];

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function us_getValueByKeys(rowData, keys) {
    for (var i = 0; i < keys.length; i++) {
        if (rowData.hasOwnProperty(keys[i]) && rowData[keys[i]] !== null && rowData[keys[i]] !== undefined) {
            return $.trim(String(rowData[keys[i]]));
        }
    }

    return "";
}

function us_getFeedbackPayload() {
    const params = new URLSearchParams(window.location.search);
    const encoded = params.get('data');

    if (!encoded) {
        return null;
    }

    try {
        return JSON.parse(atob(encoded));
    }
    catch (e) {
        return null;
    }
}

function us_getFeedbackReturnUrl(defaultUrl) {
    const payload = us_getFeedbackPayload();

    if (payload && payload.src == "GlobalSearch") {
        return "GlobalSearch.aspx";
    }

    if (payload && payload.src == "CanopySearch") {
        return "CanopySearch.aspx";
    }

    if (payload && payload.src == "MyQueue") {
        return "MyQueue.aspx";
    }

    if (payload && payload.src == "Dashboard") {
        return "Dashboard.aspx";
    }

    return defaultUrl;
}

function us_getFeedbackDetailsEndpoint(methodName) {
    var currentPage = window.location.pathname.split('/').pop();
    var detailsPage = currentPage === "FeedbackCanopyDetails.aspx"
        ? "FeedbackCanopyDetails.aspx"
        : "FeedbackDetails.aspx";

    return detailsPage + "/" + methodName;
}

function usfeedback_isCanopyPage() {
    return window.location.pathname.split('/').pop() === "FeedbackCanopyDetails.aspx";
}

function usfeedback_pageId(id) {
    if (!usfeedback_isCanopyPage()) return id;

    if (id.indexOf("usfeedback_") === 0) {
        return id.replace("usfeedback_", "canopyfeedback_");
    }

    return "canopyfeedback_" + id;
}

function usfeedback_getElement(id) {
    return document.getElementById(usfeedback_pageId(id));
}

function usfeedback_select(id) {
    return $("#" + usfeedback_pageId(id));
}

function canopyfeedback_getLoggedInUserDetails() {
    return GetLoggedInUserDetails();
}

function canopyfeedback_bindLoanDetails() {
    return bindloanDetails_feedback();
}

function canopyfeedback_getTaskwiseDetails(ddl) {
    return getTaskwiseDetails(ddl);
}

function canopyfeedback_submit() {
    return canopyfeedback_submitFeedback();
}

function canopyfeedback_completeLoan() {
    return usfeedback_completeLoan();
}

function BindUSLoanDetails_Grid() {

    $('#load1').show();

    USLoanDetails_html = '';
    $.ajax({
        url: "LoanDetails.aspx/GetLoanDetails_RemoteUW_REQC",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                USLoanDetails_html += '<tr>';
                USLoanDetails_html += '<td style="text-align:center; display:none;"></td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; text-align:center;"><button type="button" class="my-btn success btn-start-loan" id="us_start_loan_' + blankForNull(value.ProcessID) + '" onclick="return start_Loan(this,\'' + blankForNull(value.ProcessID) + '\');">Start</button></td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;"></td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;" class="processid">' + blankForNull(value.ProcessID1) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="client">' + blankForNull(value.ProjectNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="deal">' + blankForNull(value.DealNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="loan">' + blankForNull(value.LoanNo) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="recdate">' + blankForNull(value.OrderDate) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap;" class="process">' + blankForNull(value.Process) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;" class="uwname">' + blankForNull(value.RemoteUW) + '</td>';
                USLoanDetails_html += '<td style="text-wrap: nowrap; display:none;">' + blankForNull(value.ProcessDate) + '</td>';
                USLoanDetails_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_USLoanDetails')) {
                USLoanDetails_table.destroy();
            }
            $('#table_USLoanDetails tbody').html(USLoanDetails_html);

            USLoanDetails_table = $('#table_USLoanDetails').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();

                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function start_Loan(button, ProcessID) {
    var $button = $(button);
    var $row = $button.closest('tr');
    var processName = $row.find('.process').text().trim();
    var startDatetime = usfeedback_getNowDateTime();

    if (!ProcessID) {
        Swal.fire('Warning', 'Loan details are not available for this row.', 'warning');
        return false;
    }

    if ($button.data('saving')) {
        return false;
    }

    ProcessFeedbackID = ProcessID;
    $button.data('saving', true).prop('disabled', true);

    Swal.fire({
        title: 'Starting loan...',
        text: 'Please wait while the start time is saved.',
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.StartLoan(
        parseInt(ProcessID, 10) || 0,
        $row.find('.client').text().trim(),
        $row.find('.deal').text().trim(),
        $row.find('.loan').text().trim(),
        $row.find('.recdate').text().trim(),
        $row.find('.process').text().trim(),
        $row.find('.uwname').text().trim(),

        function (result) {
            if (result > 0) {
                if (processName.toLowerCase() === "atr review") {
                    GetFeedbackPage(
                        $row.find('.loan').text().trim(),
                        $row.find('.deal').text().trim(),
                        parseInt($row.find('.processid').text().trim(), 10) || 0,
                        "MyTask",
                        $row.find('.client').text().trim(),
                        $row.find('.recdate').text().trim(),
                        processName,
                        $row.find('.uwname').text().trim(),
                        startDatetime,
                        true
                    );
                    return false;
                }

                window.location.href = "AddFeedback.aspx?ProcessID=" + ProcessFeedbackID;
                return false;
            }

            $button.data('saving', false).prop('disabled', false);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Oops! Error occurred while starting the loan.'
            });
        },

        function (error) {
            $button.data('saving', false).prop('disabled', false);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message ? error.get_message() : error.responseText
            });
        }
    );

    return false;
}

function complete_Loan(ProcessID, index) {
    var rowNode = USLoanDetails_table.row(index).node();
    var button = $(rowNode).find('.btn-start-loan').get(0);

    return start_Loan(button, ProcessID);
}


/*--------------- Add Feedback Functions--------------- */

var LoanNo = "";
var usfeedback_html;
var usfeedback_table;
var ProcessFeedbackID = 0;
var feedbackRows = [];
var isCollectionCommentsReQC = false;

function BindInfinityFeedback_US(ProcessID) {

    ProcessFeedbackID = parseInt(ProcessID, 10) || 0;

    $.ajax({
        url: "AddFeedback.aspx/GetLoanDetails_RemoteUW_ByID",
        type: "POST",
        dataType: "json",
        data: "{ProcessID:" + ProcessID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                LoanNo = value.LoanNo;
                var taskName = $.trim(value.Process || value.Task || '');
                document.getElementById("USLoanDetails_Task").value = taskName;
                configureAddFeedbackTask(taskName);

                BindUSFeedbackDetails_Grid(LoanNo);

                document.getElementById("USLoanDetails_LoanNo").value = value.LoanNo;
                document.getElementById("USLoanDetails_Client").value = value.ProjectNo;
                document.getElementById("USLoanDetails_UWName").value = value.RemoteUW.toUpperCase();


                var date = new Date();
                var day = date.getDate();
                if (day < 10)
                    day = '0' + day
                var month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                var year = date.getFullYear();

                var actualdate = (month) + "/" + (day) + "/" + year;

                $("#USLoanDetails_QcDate").val(actualdate);
                $("#USLoanDetails_DateReviewed").val(actualdate);
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function OnClickAddFeedback() {

    var LoanNo = document.getElementById("USLoanDetails_LoanNo").value;
    var Client = document.getElementById("USLoanDetails_Client").value;
    var UWName = document.getElementById("USLoanDetails_UWName").value;
    var DateReviewed = document.getElementById("USLoanDetails_DateReviewed").value;
    var Finding = $.trim(document.getElementById("USLoanDetails_Finding").value);
    var inf_Severity = document.getElementById("USLoanDetails_Severity");
    var Severity = inf_Severity.options[inf_Severity.selectedIndex].value;

    var FeedbackRecDate = document.getElementById("USLoanDetails_DateReviewed").value;
    var QcDate = document.getElementById("USLoanDetails_QcDate").value;
    var Source = "ReQC";
    var FeedbackID = parseInt(document.getElementById("USFeedback_EditId").value, 10) || 0;

    var Task = document.getElementById("USLoanDetails_Task").value;
    var DataField = isCollectionCommentsReQC ? $('#USLoanDetails_DataField').val() : '';
    var IsError = isCollectionCommentsReQC ? $('#USLoanDetails_IsError').val() : '';
    if (isCollectionCommentsReQC) {
        Finding = $.trim($('#USLoanDetails_CollectionFinding').val());
        Severity = '';
        if (!DataField) { Swal.fire('Validation', 'Please select Data Field.', 'warning'); $('#USLoanDetails_DataField').focus(); return false; }
        if (DataField === 'No Error') { IsError = 'No'; Finding = 'No Error'; }
        if (!IsError) { Swal.fire('Validation', 'Please select Is Error.', 'warning'); $('#USLoanDetails_IsError').focus(); return false; }
        if (!Finding) { Swal.fire('Validation', 'Please enter Finding.', 'warning'); $('#USLoanDetails_CollectionFinding').focus(); return false; }
    }

    if (!isCollectionCommentsReQC && Severity == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please select Severity.'
        });
        document.getElementById("USLoanDetails_Severity").focus();
        return false;
    }

    if (Severity == "No Error") {
        Finding = "No Error";
        document.getElementById("USLoanDetails_Finding").value = Finding;
    } else if (Finding == "") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Please enter Finding for Critical or Non-Critical severity.'
        });
        document.getElementById("USLoanDetails_Finding").focus();
        return false;
    }

    if (FeedbackID > 0) {
        PageMethods.UpdateUSImportedFeedback_NewERP(
            FeedbackID,
            LoanNo,
            Client,
            Finding,
            Severity,
            Task,
            ProcessFeedbackID,
            DataField,
            IsError,
            function (result) {
                if (result > 0) {
                    CancelFeedbackEdit();
                    BindUSFeedbackDetails_Grid(LoanNo);
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'Feedback updated successfully.'
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Not updated',
                        text: 'The feedback was not found or you do not have permission to update it.'
                    });
                }
            },
            showFeedbackRequestError
        );
        return false;
    }

    PageMethods.InsertUSImportedFeedback_NewERP(
        LoanNo,
        Client,
        UWName,
        DateReviewed,
        QcDate,
        Finding,
        Severity,
        Source,
        FeedbackRecDate,
        Task,
        ProcessFeedbackID,
        DataField,
        IsError,

        function (result) {

            if (result > 0) {

                BindUSFeedbackDetails_Grid(LoanNo);

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Feedback added successfully.'
                }).then(() => {
                    location.reload();
                });

            } else {

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occurred while adding feedback. Please contact administrator.'
                }).then(() => {
                    location.reload();
                });
            }
        },

        showFeedbackRequestError
    );

    return false;
}

function OnClickCompleteLoan() {

    if (!ProcessFeedbackID) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'Loan details are not available.'
        });
        return false;
    }

    if (!feedbackRows || feedbackRows.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'Feedback Required',
            text: 'Please add at least one feedback record before completing the loan.'
        });
        return false;
    }

    Swal.fire({
        title: 'Complete Loan?',
        text: 'End Date/Time will be saved as current datetime.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Complete Loan',
        cancelButtonText: 'Cancel',
        allowOutsideClick: false,
        allowEscapeKey: false,
        reverseButtons: true
    }).then(function (result) {
        if (!result.isConfirmed) {
            return false;
        }

        Swal.fire({
            title: 'Completing loan...',
            text: 'Please wait while the end time is saved.',
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: function () {
                Swal.showLoading();
            }
        });

        PageMethods.CompleteLoan(
            ProcessFeedbackID,

            function (result) {
                if (result === -2) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Feedback Required',
                        text: 'Please add at least one feedback record before completing the loan.'
                    });
                    return false;
                }

                if (result > 0) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Completed',
                        text: 'Loan completed successfully.',
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        confirmButtonText: 'OK'
                    }).then(function () {
                        window.location.href = 'LoanDetails.aspx';
                    });
                    return false;
                }

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occurred while completing the loan. Please contact administrator.',
                    allowOutsideClick: false,
                    allowEscapeKey: false
                });
            },

            function (error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.get_message ? error.get_message() : error.responseText,
                    allowOutsideClick: false,
                    allowEscapeKey: false
                });
            }
        );
    });

    return false;
}

function BindUSFeedbackDetails_Grid(loanNo) {

    $('#load1').show();

    usfeedback_html = '';
    $.ajax({
        url: "AddFeedback.aspx/GetUSImportedFeedback_ByUser_NewERP",
        type: "POST",
        data: JSON.stringify({ LoanNo: loanNo }),
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            feedbackRows = dataArray || [];

            $.each(feedbackRows, function (index, value) {

                var feedbackId = getFeedbackId(value);

                usfeedback_html += '<tr>';
                usfeedback_html += '<td style="white-space:nowrap;text-align:center;">';
                if (feedbackId > 0) {
                    usfeedback_html += '<button type="button" class="feedback-row-action edit" title="Edit feedback" aria-label="Edit feedback" onclick="return EditFeedback(' + index + ');">' +
                        '<i class="fas fa-edit"></i></button>' +
                        '<button type="button" class="feedback-row-action delete" title="Delete feedback" aria-label="Delete feedback" onclick="return DeleteFeedback(' + index + ');">' +
                        '<i class="fas fa-trash-alt"></i></button>';
                }
                usfeedback_html += '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;text-align: center;">' + feedbackHtml(value.SrNo) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + feedbackHtml(value.LoanNo) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + feedbackHtml(value.Severity) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + feedbackHtml(value.Finding) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + feedbackHtml(value.DataField) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap;">' + feedbackHtml(value.IsError) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap; display:none;">' + feedbackHtml(value.AddedByName) + '</td>';
                usfeedback_html += '<td style="text-wrap: nowrap; display:none;">' + feedbackHtml(value.AddedDate) + '</td>';

                usfeedback_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_usfeedback')) {
                usfeedback_table.destroy();
            }
            $('#table_usfeedback tbody').html(usfeedback_html);

            usfeedback_table = $('#table_usfeedback').DataTable({
                dom: 'lftip',
                destroy: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {

                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function EditFeedback(index) {
    var row = feedbackRows[index];
    if (!row) return false;

    $('#USFeedback_EditId').val(getFeedbackId(row));
    $('#USLoanDetails_Severity').val(row.Severity || '');
    $('#USLoanDetails_Finding').val(row.Finding || '');
    $('#USLoanDetails_DataField').val(row.DataField || '');
    $('#USLoanDetails_IsError').val(row.IsError || '');
    $('#USLoanDetails_CollectionFinding').val(row.Finding || '');
    if (isCollectionCommentsReQC) syncCollectionCommentsFeedback();
    syncAddFeedbackFindingRequirement();
    $('#btnAddFeedback').html('<i class="fas fa-save"></i>&nbsp; Update Feedback');
    $('#btnCancelEdit').show();
    $(isCollectionCommentsReQC ? '#USLoanDetails_DataField' : '#USLoanDetails_Severity').focus();
    $('html, body').animate({ scrollTop: $('.feedback-card').first().offset().top - 15 }, 250);
    return false;
}

function syncAddFeedbackFindingRequirement() {
    var severityElement = document.getElementById("USLoanDetails_Severity");
    var findingElement = document.getElementById("USLoanDetails_Finding");

    if (!severityElement || !findingElement) return false;

    var isNoError = severityElement.value === "No Error";
    findingElement.disabled = isNoError;
    findingElement.required = !isNoError;
    findingElement.setAttribute("aria-required", isNoError ? "false" : "true");

    if (isNoError) {
        findingElement.value = "No Error";
    } else if ($.trim(findingElement.value) === "No Error") {
        findingElement.value = "";
    }

    return false;
}

function configureAddFeedbackTask(taskName) {
    isCollectionCommentsReQC = $.trim(taskName).toLowerCase() === 'collection comments reqc';
    $('#standardSeverityField,#standardFindingField').toggle(!isCollectionCommentsReQC);
    $('#collectionCommentsFields').toggle(isCollectionCommentsReQC);
    if (!isCollectionCommentsReQC) return;
    $.ajax({ url: 'AddFeedback.aspx/GetCollectionCommentsDataFields', type: 'POST', contentType: 'application/json; charset=utf-8', dataType: 'json', data: '{}', success: function (response) { var rows = JSON.parse(response.d || '[]'), ddl = $('#USLoanDetails_DataField').empty().append($('<option/>').val('').text('Select')); $.each(rows, function (_, row) { ddl.append($('<option/>').val(row.DataField).text(row.DataField)); }); } });
}

function syncCollectionCommentsFeedback() {
    var noError = $('#USLoanDetails_DataField').val() === 'No Error';
    $('#USLoanDetails_IsError').val(noError ? 'No' : '').prop('disabled', noError);
    $('#USLoanDetails_CollectionFinding').val(noError ? 'No Error' : '').prop('disabled', noError);
    return false;
}

function DeleteFeedback(index) {
    var row = feedbackRows[index];
    if (!row) return false;

    var feedbackId = getFeedbackId(row);
    if (!feedbackId) return false;

    var loanNo = document.getElementById("USLoanDetails_LoanNo").value;
    var client = document.getElementById("USLoanDetails_Client").value;

    Swal.fire({
        title: 'Delete feedback?',
        text: 'This action cannot be undone.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        confirmButtonText: 'Yes, delete',
        cancelButtonText: 'Cancel'
    }).then(function (result) {
        if (!result.isConfirmed) return;

        PageMethods.DeleteUSImportedFeedback_NewERP(
            feedbackId,
            loanNo,
            client,
            function (deleteResult) {
                if (deleteResult > 0) {
                    if ((parseInt($('#USFeedback_EditId').val(), 10) || 0) === feedbackId) {
                        CancelFeedbackEdit();
                    }
                    BindUSFeedbackDetails_Grid(loanNo);
                    Swal.fire({ icon: 'success', title: 'Deleted', text: 'Feedback deleted successfully.' });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Not deleted',
                        text: 'The feedback was not found or you do not have permission to delete it.'
                    });
                }
            },
            showFeedbackRequestError
        );
    });

    return false;
}

function CancelFeedbackEdit() {
    $('#USFeedback_EditId').val('0');
    $('#USLoanDetails_Severity').val('');
    $('#USLoanDetails_Finding').val('');
    $('#USLoanDetails_DataField').val(''); $('#USLoanDetails_IsError').val('').prop('disabled', false); $('#USLoanDetails_CollectionFinding').val('').prop('disabled', false);
    syncAddFeedbackFindingRequirement();
    $('#btnAddFeedback').html('<i class="fas fa-plus"></i>&nbsp; Add Feedback');
    $('#btnCancelEdit').hide();
    return false;
}

function getFeedbackId(row) {
    return parseInt(row.FeedbackID || row.FeedbackId || row.ID || row.Id, 10) || 0;
}

function feedbackHtml(value) {
    if (value === null || value === undefined) return '';
    return $('<div/>').text(value).html();
}

function showFeedbackRequestError(error) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: error.get_message ? error.get_message() : error.responseText
    });
}


/* ---- Global Search -- */

function us_globalSearchEscape(value) {
    return $('<div/>').text(value == null ? '' : String(value)).html();
}

function us_globalSearchReQcDate(value) {
    var match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value || '');
    if (!match) return value || '';
    var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return match[3] + '-' + months[parseInt(match[2], 10) - 1] + '-' + match[1];
}

function us_globalSearchReQcColumn() {
    return {
        data: null,
        title: 'Re-QC Status',
        className: 'reqc-cell',
        render: function (data, type, row) {
            var status = row._ReQCStatus || 'Not Assigned', process = row._ReQCProcess || '', employee = row._ReQCEmployeeName || '', date = us_globalSearchReQcDate(row._ReQCDate || '');
            if (type !== 'display') return status + (process ? ' - ' + process : '') + (employee ? ' - ' + employee : '') + (date ? ' - ' + date : '');
            if (status === 'Completed') return '<span class="reqc-pill reqc-completed" title="This loan has completed a Re-QC process"><i class="fas fa-check-circle"></i> Completed</span>' + (process || employee || date ? '<span class="reqc-detail">' + (process ? '<strong>' + us_globalSearchEscape(process) + '</strong><br>' : '') + (employee ? 'Completed by ' + us_globalSearchEscape(employee) : 'Completed') + (date ? ' &bull; ' + us_globalSearchEscape(date) : '') + '</span>' : '');
            if (status === 'Assigned') return '<span class="reqc-pill reqc-assigned" title="This loan is assigned to a Re-QC process"><i class="fas fa-user-clock"></i> Assigned</span>' + (process || employee || date ? '<span class="reqc-detail">' + (process ? '<strong>' + us_globalSearchEscape(process) + '</strong><br>' : '') + (employee ? 'Assigned to ' + us_globalSearchEscape(employee) : 'Re-QC assigned') + (date ? ' &bull; ' + us_globalSearchEscape(date) : '') + '</span>' : '');
            return '<span class="reqc-pill reqc-not-assigned" title="No Re-QC assignment or completion was found"><i class="far fa-circle"></i> Not Assigned</span>';
        }
    };
}

function us_canopyProcessStatusColumn() {
    return {
        data: null,
        title: 'Process Status',
        className: 'reqc-cell',
        render: function (data, type, row) {
            var status = row._ProcessStatus || 'Not Started';
            var process = row._ProcessName || row.Process || '';
            var employee = row._ProcessEmployeeName || '';
            var date = us_globalSearchReQcDate(row._ProcessStatusDate || '');
            if (type !== 'display') return status + (process ? ' - ' + process : '') + (employee ? ' - ' + employee : '') + (date ? ' - ' + date : '');
            if (status === 'Completed') return '<span class="reqc-pill reqc-completed" title="This process has been completed"><i class="fas fa-check-circle"></i> Completed</span>' + (process || employee || date ? '<span class="reqc-detail">' + (process ? '<strong>' + us_globalSearchEscape(process) + '</strong><br>' : '') + (employee ? 'Completed by ' + us_globalSearchEscape(employee) : 'Completed') + (date ? ' &bull; ' + us_globalSearchEscape(date) : '') + '</span>' : '');
            if (status === 'Started') return '<span class="reqc-pill reqc-assigned" title="This process has been started"><i class="fas fa-user-clock"></i> Started</span>' + (process || employee || date ? '<span class="reqc-detail">' + (process ? '<strong>' + us_globalSearchEscape(process) + '</strong><br>' : '') + (employee ? 'Started by ' + us_globalSearchEscape(employee) : 'In progress') + (date ? ' &bull; ' + us_globalSearchEscape(date) : '') + '</span>' : '');
            return '<span class="reqc-pill reqc-not-assigned" title="No production tracking record was found"><i class="far fa-circle"></i> Not Started</span>';
        }
    };
}

function us_getloansforglobalsearch() {
    $('#load1').show();
    var columns = [];
    $.ajax({
        url: "GlobalSearch.aspx/getLoansForGlobalSearch",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if (!dataArray || dataArray.length === 0) {
                if ($.fn.DataTable.isDataTable('#usglobalsearch_table')) {
                    $('#usglobalsearch_table').DataTable().clear().destroy();
                }

                $('#load1').hide();
                return false;
            }

            var reQcColumnAdded = false;
            $.each(dataArray[0], function (key, value) {
                if (key.indexOf('_ReQC') === 0) return;
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
                var normalizedKey = key.toLowerCase().replace(/[^a-z0-9]/g, '');
                if (!reQcColumnAdded && (normalizedKey === 'loanno' || normalizedKey === 'loannumber' || normalizedKey === 'ordernumber')) { columns.push(us_globalSearchReQcColumn()); reQcColumnAdded = true; }
            });

            if (!reQcColumnAdded) columns.push(us_globalSearchReQcColumn());

            columns.push({
                data: null,
                title: "Action",
                orderable: false,
                searchable: false,
                render: function () {
                    return '<button type="button" class="btn btn-sm btn-primary view-btn">Start</button>';
                }
            });

            $('#usglobalsearch_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                    },
                ],
            });

            $('#usglobalsearch_table tbody')
                .off('click', '.view-btn')
                .on('click', '.view-btn', function () {
                    var table = $('#usglobalsearch_table').DataTable();
                    var rowData = table.row($(this).closest('tr')).data();

                    return us_startGlobalSearchLoan(this, rowData);
                });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function us_getloansforglobalsearchCanopy_OLD() {
    $('#load1').show();
    var columns = [];
    $.ajax({
        url: "CanopySearch.aspx/getLoansForGlobalSearch",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);

            if (!dataArray || dataArray.length === 0) {
                if ($.fn.DataTable.isDataTable('#usglobalsearchcanopy_table')) {
                    $('#usglobalsearchcanopy_table').DataTable().clear().destroy();
                }

                $('#load1').hide();
                return false;
            }

            var reQcColumnAdded = false;
            $.each(dataArray[0], function (key, value) {
                if (key.indexOf('_ReQC') === 0) return;
                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                console.log(my_item.title);
                columns.push(my_item);
                var normalizedKey = key.toLowerCase().replace(/[^a-z0-9]/g, '');
                //  if (!reQcColumnAdded && (normalizedKey === 'loanno' || normalizedKey === 'loannumber' || normalizedKey === 'ordernumber')) { columns.push(us_globalSearchReQcColumn()); reQcColumnAdded = true; }
            });

            //if (!reQcColumnAdded) columns.push(us_globalSearchReQcColumn());

            columns.push({
                data: null,
                title: "Action",
                orderable: false,
                searchable: false,
                render: function () {
                    return '<button type="button" class="btn btn-sm btn-primary view-btn">Start</button>';
                }
            });

            $('#usglobalsearchcanopy_table').DataTable({
                dom: 'lBftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                    },
                ],
            });

            $('#usglobalsearchcanopy_table tbody')
                .off('click', '.view-btn')
                .on('click', '.view-btn', function () {
                    var table = $('#usglobalsearchcanopy_table').DataTable();
                    var rowData = table.row($(this).closest('tr')).data();

                    return us_startGlobalSearchLoan(this, rowData, "FeedbackCanopyDetails.aspx", "CanopySearch");
                });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function us_getloansforglobalsearchCanopy() {

    $('#load1').show();

    console.time('TotalLoad');

    $.ajax({
        url: "CanopySearch.aspx/getLoansForGlobalSearch",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {


            var dataArray = typeof data.d === "string"
                ? JSON.parse(data.d)
                : data.d;


            if (!dataArray || dataArray.length === 0) {

                if ($.fn.DataTable.isDataTable('#usglobalsearchcanopy_table')) {
                    $('#usglobalsearchcanopy_table')
                        .DataTable()
                        .clear()
                        .destroy();
                }

                $('#load1').hide();


                return false;
            }


            if ($.fn.DataTable.isDataTable('#usglobalsearchcanopy_table')) {
                $('#usglobalsearchcanopy_table')
                    .DataTable()
                    .clear()
                    .destroy();
            }

            $('#usglobalsearchcanopy_table').empty();

            $('#usglobalsearchcanopy_table').DataTable({

                data: dataArray,

                /*
                 * Define ONLY required columns.
                 */
                columns: [
                    {
                        data: 'Client',
                        title: 'Project'
                    },
                    {
                        data: 'ClientName',
                        title: 'Client'
                    },
                    {
                        data: 'Loan #',
                        title: 'Loan #'
                    },
                    {
                        data: 'Order Date',
                        title: 'Order Date'
                    },
                    {
                        data: 'Script',
                        title: 'Script'
                    },
                    us_canopyProcessStatusColumn(),
                    {
                        data: null,
                        title: 'Action',
                        orderable: false,
                        searchable: false,
                        className: 'text-center',
                        render: function (data, type, row) {
                            var isCompleted = String(row._ProcessStatus || '').toLowerCase() === 'completed';
                            var ownershipAllowsStart = row._CanStart === true || row._CanStart === 1 || String(row._CanStart).toLowerCase() === 'true';
                            var canStart = !isCompleted || ownershipAllowsStart;
                            var disabled = canStart ? '' : ' disabled="disabled"';
                            var title = canStart ? 'Start this loan' : 'This process was completed by another user';
                            return `
                                <button type="button"
                                        class="btn btn-sm btn-primary view-btn"${disabled}
                                        title="${title}">
                                    Start
                                </button>
                            `;
                        }
                    }
                ],

                destroy: true,

                processing: true,

                serverSide: false,

                paging: true,

                pageLength: 25,

                lengthMenu: [
                    [25, 50, 100],
                    [25, 50, 100]
                ],

                /*
                 * Very important for large client-side datasets.
                 */
                deferRender: true,

                ordering: false,

                searching: true,

                autoWidth: false,

                scrollX: true,

                select: {
                    style: 'single'
                },

                dom: 'lBftip',

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Canopy Global Search',
                        autoFilter: true
                    }
                ],

                createdRow: function (row, data, dataIndex) {
                    $('td', row).css('white-space', 'nowrap');
                },

                initComplete: function () {

                    console.timeEnd('TotalLoad');

                    $('#load1').hide();
                }
            });


            /*
             * Use delegated event once.
             */
            $('#usglobalsearchcanopy_table tbody')
                .off('click', '.view-btn')
                .on('click', '.view-btn', function () {

                    if (this.disabled) return false;

                    var table =
                        $('#usglobalsearchcanopy_table').DataTable();

                    var rowData =
                        table.row($(this).closest('tr')).data();

                    return us_startGlobalSearchLoan(
                        this,
                        rowData,
                        "FeedbackCanopyDetails.aspx",
                        "CanopySearch"
                    );
                });
        },

        error: function (xhr, status, error) {

            $('#load1').hide();

            console.error('Status:', status);
            console.error('Error:', error);
            console.error('Response:', xhr.responseText);

            alert('Unable to load Canopy loans.');
        }
    });

    return false;
}

function us_getGlobalSearchLoanData(rowData) {
    return {
        processID: us_getValueByKeys(rowData, ["ProcessID", "ProcessID1", "Process ID", "Process Id"]),
        projectNumber: us_getValueByKeys(rowData, ["Client", "ProjectNumber", "ProjectNo", "Project No", "Project #"]),
        dealNo: us_getValueByKeys(rowData, ["Deal #", "DealNo", "Deal No"]),
        loanNo: us_getValueByKeys(rowData, ["Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number"]),
        orderDate: us_getValueByKeys(rowData, ["Order Date", "OrderDate", "Received Date", "RecDate"]),
        script: us_getValueByKeys(rowData, ["Script", "ScriptName", "Script Name"]),
        process: us_getValueByKeys(rowData, ["Process", "ProcessName", "Process Name"]),
        review: us_getValueByKeys(rowData, ["RemoteUW", "Reviewer", "Review", "UW Name"])
    };
}

function us_callStartLoanPageMethod(loanData, includeScript, onSuccess, onError) {
    if (includeScript) {
        return PageMethods.StartLoan(loanData.processID, loanData.projectNumber, loanData.dealNo, loanData.loanNo,
            loanData.orderDate, loanData.process, loanData.review, loanData.startDatetime, loanData.script || "", onSuccess, onError);
    }

    return PageMethods.StartLoan(loanData.processID, loanData.projectNumber, loanData.dealNo, loanData.loanNo,
        loanData.orderDate, loanData.process, loanData.review, loanData.startDatetime, onSuccess, onError);
}

function us_callCompleteLoanPageMethod(loanData, includeScript, onSuccess, onError) {
    if (includeScript) {
        return PageMethods.CompleteLoan(loanData.processID, loanData.projectNumber, loanData.dealNo, loanData.loanNo,
            loanData.orderDate, loanData.process, loanData.review, loanData.startDatetime, loanData.script || "", onSuccess, onError);
    }

    return PageMethods.CompleteLoan(loanData.processID, loanData.projectNumber, loanData.dealNo, loanData.loanNo,
        loanData.orderDate, loanData.process, loanData.review, loanData.startDatetime, onSuccess, onError);
}

function usfeedback_callInsertATRFeedbacks(args, script, onSuccess, onError) {
    if (usfeedback_isCanopyPage()) args.push(script || "");
    args.push(onSuccess, onError);
    return PageMethods.InsertATRFeedbacks.apply(PageMethods, args);
}

function usfeedback_callInsertOtherFeedbacks(args, script, onSuccess, onError) {
    if (usfeedback_isCanopyPage()) args.push(script || "");
    args.push(onSuccess, onError);
    return PageMethods.InsertOtherFeedbacks.apply(PageMethods, args);
}

function usfeedback_getTodayDate() {
    var today = new Date();
    var month = String(today.getMonth() + 1).padStart(2, '0');
    var day = String(today.getDate()).padStart(2, '0');
    return month + "/" + day + "/" + today.getFullYear();
}

function usfeedback_insertExistingFeedback(feedback, onSuccess) {
    var currentDate = usfeedback_getTodayDate();

    PageMethods.InsertUSImportedFeedback_NewERP(
        feedback.loanNo,
        feedback.client,
        feedback.uwName,
        feedback.dateReviewed || currentDate,
        currentDate,
        feedback.finding,
        feedback.severity,
        feedback.source,
        currentDate,
        function (result) {
            // -1 means the record already exists in the legacy feedback table.
            if (result > 0 || result === -1) {
                onSuccess();
                return;
            }

            Swal.fire({
                icon: 'error',
                title: 'Partially saved',
                text: 'Feedback was saved for this process, but could not be added to the existing feedback table. Please contact administrator.'
            });
        },
        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Partially saved',
                text: error.get_message ? error.get_message() : 'Feedback was saved for this process, but could not be added to the existing feedback table.'
            });
        }
    );
}

function us_startGlobalSearchLoan(button, rowData, detailsPage, source) {
    var $button = $(button);
    var loanData = us_getGlobalSearchLoanData(rowData || {});

    if (!loanData.loanNo || !loanData.dealNo) {
        Swal.fire('Warning', 'Loan details are not available for this row.', 'warning');
        return false;
    }

    if ($button.data('saving')) {
        return false;
    }
    console.log(loanData);
    $button.data('saving', true).prop('disabled', true);

    loanData.startDatetime = usfeedback_getNowDateTime();

    Swal.fire({
        title: 'Starting loan...',
        text: 'Please wait while the start time is saved.',
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    loanData.processID = parseInt(loanData.processID, 10) || 0;
    us_callStartLoanPageMethod(loanData, source === "CanopySearch",
        function (result) {
            if (result > 0) {
                GetFeedbackPage(
                    loanData.loanNo,
                    loanData.dealNo,
                    loanData.processID,
                    source || "GlobalSearch",
                    loanData.projectNumber,
                    loanData.orderDate,
                    loanData.process,
                    loanData.review,
                    loanData.startDatetime,
                    true,
                    loanData.script,
                    detailsPage
                );
                return false;
            }

            $button.data('saving', false).prop('disabled', false);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Oops! Error occurred while starting the loan. Please contact administrator.'
            });
        },

        function (error) {
            $button.data('saving', false).prop('disabled', false);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message ? error.get_message() : error.responseText
            });
        }
    );

    return false;
}

function GetFeedbackPage(loanno, dealno, processid, source, client, orderDate, process, review, startDatetime, started, script, detailsPage) {
    const payload = {
        ln: loanno,
        dn: dealno
    };

    if (processid) {
        payload.tp = processid;
    }

    if (source) {
        payload.src = source;
    }

    if (client) {
        payload.client = client;
    }

    if (orderDate) {
        payload.od = orderDate;
    }

    if (process) {
        payload.process = process;
    }

    if (script) {
        payload.script = script;
    }

    if (review) {
        payload.review = review;
    }

    if (startDatetime) {
        payload.sd = startDatetime;
    }

    if (started) {
        payload.started = true;
    }

    const encoded = btoa(JSON.stringify(payload));
    location.href = (detailsPage || "FeedbackDetails.aspx") + "?data=" + encodeURIComponent(encoded);
}

function GetLoggedInUserDetails() {
    $.ajax({
        type: "POST", url: us_getFeedbackDetailsEndpoint("GetLoggedInUser"), dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                usfeedback_getElement("usfeedback_reviewer").value = blankForNull(value.FullName);
                usfeedback_getElement("usfeedback_reviewer").readOnly = true;

            })
        }
    });
}

function bindloanDetails_feedback() {
    const decoded = us_getFeedbackPayload();
    if (!decoded) return;
    console.log(decoded);
    usfeedbackLoanStarted = decoded.started === true || decoded.started === "true";
    usfeedbackStartDatetime = decoded.sd || decoded.startDatetime || "";
    if (usfeedback_getElement("usfeedback_back")) {
        usfeedback_getElement("usfeedback_back").href = us_getFeedbackReturnUrl("LoanDetails.aspx");
    }

    $.ajax({
        url: us_getFeedbackDetailsEndpoint(usfeedback_isCanopyPage()
            ? "GetLoanDetailsbyLoanNo_Canopy"
            : "GetLoanDetailsbyLoanNo"),
        type: "POST",
        dataType: "json",
        data: JSON.stringify({
            DealNo: decoded.dn,
            LoanNo: decoded.ln,
            Script: decoded.script || decoded.process || ""
        }),
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                usfeedback_getElement("usfeedback_projectno").value = value.ProjectName;
                usfeedback_getElement("usfeedback_dealno").value = value.DealNo;
                usfeedback_getElement("usfeedback_loanno").value = value.LoanNo;
                usfeedback_getElement("usfeedback_projectid").value = value.ProjectID;
                var qcerName = usfeedback_getElement("usfeedback_qcername");
                var qcerDate = usfeedback_getElement("usfeedback_qcerdate");
                if (qcerName) {
                    qcerName.value = blankForNull(value.taskAssignedUser);
                    document.getElementById("clientinfocanopy").innerHTML = "Feedback Information for - <b style='color:green;'>" + value.ClientName + "</b>";
                }
                if (qcerDate) qcerDate.value = blankForNull(value.completedDate);


                usfeedback_bindProcessTask(value.ProjectID);


            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;

}

function usfeedback_bindProcessTask(Projectid) {

    usfeedback_select("usfeedback_task").empty()
        .append('<option value="">Select</option>');

    $.ajax({
        type: "POST",
        url: us_getFeedbackDetailsEndpoint("GetUSProcessTask"),
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ ProjectID: Projectid }),

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (index, value) {

                // Prevent duplicate option
                if (usfeedback_select("usfeedback_task").find("option[value='" + value.ProcessID + "']").length === 0) {
                    usfeedback_select("usfeedback_task").append(
                        $("<option></option>")
                            .val(value.ProcessID)
                            .text(value.ProcessName)
                    );
                }
            });

            const params = new URLSearchParams(window.location.search);
            const encoded = params.get('data');

            if (!encoded) return;

            const decoded = JSON.parse(atob(encoded));

            if (decoded.tp || decoded.process) {
                var $task = usfeedback_select("usfeedback_task");
                var selectedProcessId = decoded.tp || "";

                if (!$task.find("option[value='" + selectedProcessId + "']").length && decoded.process) {
                    $task.find("option").each(function () {
                        if ($.trim($(this).text()).toLowerCase() === $.trim(decoded.process).toLowerCase()) {
                            selectedProcessId = $(this).val();
                            return false;
                        }
                    });
                }

                $task.val(selectedProcessId);

                if (!$task.val()) return;

                // Call only once
                getTaskwiseDetails(usfeedback_getElement("usfeedback_task"));

                usfeedback_getElement("usfeedback_back").href = us_getFeedbackReturnUrl("LoanDetails.aspx");
            }
        }
    });
}

function getTaskwiseDetails(ddl) {

    if (usfeedback_isCanopyPage()) canopyfeedback_cancelEdit();
    else feedbackdetails_cancelEdit();

    var value = ddl.options[ddl.selectedIndex].text;
    var id = ddl.options[ddl.selectedIndex].value;

    if (value == "" || value == "Select") {
        usfeedback_getElement("trOther").style.display = 'none';
        usfeedback_getElement("tratr1").style.display = 'none';
        usfeedback_getElement("tratr2").style.display = 'none';
        usfeedback_getElement("tratr3").style.display = 'none';
        usfeedback_getElement("tratr4").style.display = 'none';
        usfeedback_getElement("tratr5").style.display = 'none';
    }
    else if (value == "ATR Review") {
        usfeedback_getElement("trOther").style.display = 'none';
        usfeedback_getElement("tratr1").style.display = '';
        usfeedback_getElement("tratr2").style.display = '';
        usfeedback_getElement("tratr3").style.display = '';
        usfeedback_getElement("tratr4").style.display = '';
        usfeedback_getElement("tratr5").style.display = '';
        var date = new Date();
        var day = String(date.getDate()).padStart(2, '0');
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var year = date.getFullYear();

        var actualdate = year + "-" + month + "-" + day;

        usfeedback_getElement("usfeedback_reviewdate").value = actualdate;

        usfeedback_startLoanIfNeeded(id, value);
        usfeedback_atr_bindgrid("ATR", id);
    }
    else {
        usfeedback_getElement("trOther").style.display = '';
        usfeedback_getElement("tratr1").style.display = 'none';
        usfeedback_getElement("tratr2").style.display = 'none';
        usfeedback_getElement("tratr3").style.display = 'none';
        usfeedback_getElement("tratr4").style.display = 'none';
        usfeedback_getElement("tratr5").style.display = 'none';
        usfeedback_startLoanIfNeeded(id, value);
        usfeedback_atr_bindgrid("Other", id);

    }
}

function usfeedback_atr_bindgrid(type, processid) {
    usfeedback_select("load1").show();
    usfeedbackRecordCount = 0;
    var columns = [];
    var dealno = usfeedback_getElement("usfeedback_dealno").value;
    var loanno = usfeedback_getElement("usfeedback_loanno").value;
    var payload = us_getFeedbackPayload() || {};
    var feedbackRequest = { DealNo: dealno, LoanNo: loanno, Type: type, ProcessID: processid };
    if (usfeedback_isCanopyPage()) feedbackRequest.Script = payload.script || "";

    $.ajax({
        url: us_getFeedbackDetailsEndpoint("GetATRDetails"),
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify(feedbackRequest),
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            canopyfeedbackGridRows = type === "Other" ? (dataArray || []) : [];
            feedbackdetailsGridRows = !usfeedback_isCanopyPage() && type === "Other" ? (dataArray || []) : [];
            usfeedbackRecordCount = dataArray ? dataArray.length : 0;
            var feedbackTableSelector = "#" + usfeedback_pageId("usfeedback_table");
            if ($.fn.DataTable.isDataTable(feedbackTableSelector)) {
                $(feedbackTableSelector).DataTable().clear().destroy();
            }
            if (dataArray != '') {
                $.each(dataArray[0], function (key, value) {

                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });
                if (usfeedback_isCanopyPage() && type === "Other") {
                    columns.unshift({
                        data: null,
                        title: "Actions",
                        orderable: false,
                        searchable: false,
                        render: function (data, renderType, row, meta) {
                            return '<button type="button" class="feedback-row-action" title="Edit feedback" aria-label="Edit feedback" onclick="return canopyfeedback_editFeedback(' + meta.row + ');"><i class="fas fa-edit"></i></button>' +
                                '<button type="button" class="feedback-row-action delete" title="Delete feedback" aria-label="Delete feedback" onclick="return canopyfeedback_deleteFeedback(' + meta.row + ');"><i class="fas fa-trash-alt"></i></button>';
                        }
                    });
                }
                else if (type === "Other") {
                    columns.unshift({
                        data: null,
                        title: "Actions",
                        orderable: false,
                        searchable: false,
                        render: function (data, renderType, row, meta) {
                            return '<button type="button" class="feedback-row-action" title="Edit feedback" aria-label="Edit feedback" onclick="return feedbackdetails_editFeedback(' + meta.row + ');"><i class="fas fa-edit"></i></button>' +
                                '<button type="button" class="feedback-row-action delete" title="Delete feedback" aria-label="Delete feedback" onclick="return feedbackdetails_deleteFeedback(' + meta.row + ');"><i class="fas fa-trash-alt"></i></button>';
                        }
                    });
                }
                $(feedbackTableSelector).DataTable({
                    dom: 'lBftip',
                    destroy: true,
                    orderCellsTop: true,
                    fixedHeader: true,
                    scrollX: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
                    "ordering": false,
                    processing: true,
                    filter: true,
                    'select': {
                        'style': 'single'
                    },
                    "serverSide": false,
                    "data": dataArray,
                    columns: columns,
                    columnDefs: usfeedback_isCanopyPage() && type === "Other"
                        ? [{ targets: 1, visible: false, searchable: false }]
                        : [],
                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    initComplete: function () {
                        usfeedback_select("load1").hide();
                    },
                    buttons: [
                        {
                            extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                        },
                    ],
                });

            }
            else {
                usfeedback_select("load1").hide();
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });


    return false;
}

function usfeedback_setLastProcess(processid, processName) {
    if (processid && processName && processName != "Select") {
        usfeedbackLastProcessID = processid;
        usfeedbackLastProcessName = processName;
    }
}

function usfeedback_getNowDateTime() {
    var now = new Date();
    var mm = String(now.getMonth() + 1).padStart(2, '0');
    var dd = String(now.getDate()).padStart(2, '0');
    var yyyy = now.getFullYear();
    var hh = String(now.getHours()).padStart(2, '0');
    var min = String(now.getMinutes()).padStart(2, '0');
    var sec = String(now.getSeconds()).padStart(2, '0');

    return mm + "/" + dd + "/" + yyyy + " " + hh + ":" + min + ":" + sec;
}

function usfeedback_getLoanProcessData(processid, processName) {
    const payload = us_getFeedbackPayload() || {};
    console.log(payload);
    return {
        processID: parseInt(processid, 10) || 0,
        projectNumber: usfeedback_getElement("usfeedback_projectno").value || payload.client || "",
        dealNo: usfeedback_getElement("usfeedback_dealno").value || payload.dn || "",
        loanNo: usfeedback_getElement("usfeedback_loanno").value || payload.ln || "",
        orderDate: payload.od || "",
        process: processName || payload.process || "",
        script: payload.script || "",
        review: usfeedback_getElement("usfeedback_reviewer").value || payload.review || "",
        startDatetime: usfeedbackStartDatetime || payload.sd || payload.startDatetime || usfeedback_getNowDateTime()
    };
}

function usfeedback_startLoanIfNeeded(processid, processName) {
    const payload = us_getFeedbackPayload();

    var isCanopy = usfeedback_isCanopyPage();
    if (!payload || (payload.src != "GlobalSearch" && !isCanopy) || !processid || (!isCanopy && usfeedbackLoanStarted) || (isCanopy && usfeedbackLastProcessID == processid)) {
        return false;
    }

    var loanData = usfeedback_getLoanProcessData(processid, processName);
    usfeedbackStartDatetime = loanData.startDatetime;

    us_callStartLoanPageMethod(loanData, isCanopy,
        function (result) {
            if (result > 0) {
                usfeedbackLoanStarted = true;
                if (isCanopy) usfeedbackLastProcessID = processid;
                return false;
            }

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Oops! Error occurred while starting the loan.'
            });
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message ? error.get_message() : error.responseText
            });
        }
    );

    return false;
}

function usfeedback_completeLoan() {

    var ddl = usfeedback_getElement("usfeedback_task");
    var processid = "";
    var processName = "";

    if (ddl && ddl.selectedIndex >= 0) {
        processid = ddl.options[ddl.selectedIndex].value;
        processName = ddl.options[ddl.selectedIndex].text;
    }

    if ((!processid || processName == "" || processName == "Select") && usfeedbackLastProcessID) {
        processid = usfeedbackLastProcessID;
        processName = usfeedbackLastProcessName;
    }

    if (!processid || processName == "" || processName == "Select") {
        Swal.fire({
            icon: 'warning',
            title: 'Validation',
            text: 'No saved feedback process is available to complete.'
        });
        return false;
    }

    if (usfeedbackRecordCount === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'Feedback Required',
            text: 'Please add at least one feedback record before completing the loan.'
        });
        return false;
    }

    var loanData = usfeedback_getLoanProcessData(processid, processName);

    Swal.fire({
        title: 'Complete Loan?',
        text: 'End Date/Time will be saved as current datetime.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Complete Loan',
        cancelButtonText: 'Cancel',
        allowOutsideClick: false,
        allowEscapeKey: false,
        reverseButtons: true
    }).then(function (result) {
        if (!result.isConfirmed) {
            return false;
        }

        Swal.fire({
            title: 'Completing loan...',
            text: 'Please wait while the end time is saved.',
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: function () {
                Swal.showLoading();
            }
        });

        us_callCompleteLoanPageMethod(loanData, usfeedback_isCanopyPage(),
            function (result) {
                if (result === -2) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Feedback Required',
                        text: 'Please add at least one feedback record before completing the loan.'
                    });
                    return false;
                }

                if (result > 0) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Completed',
                        text: 'Loan completed successfully.',
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        confirmButtonText: 'OK'
                    }).then(function () {
                        window.location.href = us_getFeedbackReturnUrl('LoanDetails.aspx');
                    });
                    return false;
                }

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Oops! Error occurred while completing the loan. Please contact administrator.',
                    allowOutsideClick: false,
                    allowEscapeKey: false
                });
            },

            function (error) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.get_message ? error.get_message() : error.responseText,
                    allowOutsideClick: false,
                    allowEscapeKey: false
                });
            }
        );
    });

    return false;
}

function canopyfeedback_submitFeedback() {

    var projectid = usfeedback_getElement("usfeedback_projectid").value;
    var dealno = usfeedback_getElement("usfeedback_dealno").value;
    var loanno = usfeedback_getElement("usfeedback_loanno").value;
    var ddl = usfeedback_getElement("usfeedback_task");
    var processid = ddl.options[ddl.selectedIndex].value;
    var value = ddl.options[ddl.selectedIndex].text;
    var payload = us_getFeedbackPayload() || {};
    var script = payload.script || "";

    if (value == "" || value == "Select") {
        Swal.fire('Validation', 'Please select task.', 'warning');
        return false;
    }

    if (value == "ATR Review") {
        var reviewer = usfeedback_getElement("usfeedback_reviewer").value;
        var reviewdate = usfeedback_getElement("usfeedback_reviewdate").value;
        var ddlatrsupported = usfeedback_getElement("usfeedback_atrsupported");
        var atrsupported = ddlatrsupported.options[ddlatrsupported.selectedIndex].value;
        var noofbwr = $.trim(usfeedback_getElement("usfeedback_noofbwr").value);
        var reviewfinding = $.trim(usfeedback_getElement("usfeedback_reviewfindings").value);
        var dtiissue = $.trim(usfeedback_getElement("usfeedback_dtiissue").value);
        var incometype = $.trim(usfeedback_getElement("usfeedback_incometype").value);
        var sebusiness = $.trim(usfeedback_getElement("usfeedback_noofsebus").value);
        var rental = $.trim(usfeedback_getElement("usfeedback_noofrental").value);

        if (atrsupported == "") {
            Swal.fire('Validation', "Please select 'ATR Supported?'", 'warning');
            usfeedback_getElement("usfeedback_atrsupported").focus();
            return false;
        }

        if (noofbwr == "") {
            Swal.fire('Validation', "Please enter '# of Borrowers'", 'warning');
            usfeedback_getElement("usfeedback_noofbwr").focus();
            return false;
        }

        if (reviewfinding == "") {
            Swal.fire('Validation', "Please enter 'Review Findings'", 'warning');
            usfeedback_getElement("usfeedback_reviewfindings").focus();
            return false;
        }

        if (sebusiness == "") {
            Swal.fire('Validation', "Please enter '# SE businesses'", 'warning');
            usfeedback_getElement("usfeedback_noofsebus").focus();
            return false;
        }

        if (rental == "") {
            Swal.fire('Validation', "Please enter '# Rental Properties'", 'warning');
            usfeedback_getElement("usfeedback_noofrental").focus();
            return false;
        }

        var comments = usfeedback_getElement("usfeedback_comments").value;

        usfeedback_callInsertATRFeedbacks(
            [projectid, processid, dealno, loanno, reviewer, reviewdate, atrsupported, reviewfinding, dtiissue, noofbwr,
                incometype, sebusiness, rental, comments], script,
            function (result) {
                if (result > 0) {
                    usfeedback_setLastProcess(processid, value);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(function () {
                        usfeedback_atr_bindgrid("ATR", processid);
                        clearusfeedbackForm();
                    });
                } else {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Oops! Error occurred while saving feedback. Please contact administrator.' });
                }
            },
            function (error) {
                Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
            }
        );

        return false;
    }

    var ddlseverity = usfeedback_getElement("usfeedback_severity");
    var severity = ddlseverity.options[ddlseverity.selectedIndex].value;
    var findings = $.trim(usfeedback_getElement("usfeedback_finding").value);

    if (severity == "") {
        Swal.fire('Validation', 'Please select Severity.', 'warning');
        usfeedback_getElement("usfeedback_severity").focus();
        return false;
    }

    if (findings == "") {
        Swal.fire('Validation', 'Please enter Findings.', 'warning');
        usfeedback_getElement("usfeedback_finding").focus();
        return false;
    }

    var feedbackKey = usfeedback_getElement("editkey").value;
    if (feedbackKey) {
        PageMethods.UpdateOtherFeedback(
            feedbackKey,
            parseInt(projectid, 10) || 0,
            parseInt(processid, 10) || 0,
            dealno,
            loanno,
            findings,
            severity,
            script,
            function (result) {
                if (result > 0) {
                    canopyfeedback_cancelEdit();
                    usfeedback_atr_bindgrid("Other", processid);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback updated successfully.' });
                } else {
                    Swal.fire({ icon: 'error', title: 'Not updated', text: 'The feedback was not found or you do not have permission to update it.' });
                }
            },
            function (error) {
                Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
            }
        );
        return false;
    }

    usfeedback_callInsertOtherFeedbacks([projectid, processid, dealno, loanno, findings, severity], script,
        function (result) {
            if (result > 0) {
                usfeedback_insertExistingFeedback({
                    loanNo: loanno,
                    client: usfeedback_getElement("usfeedback_projectno").value,
                    uwName: document.getElementById("canopyfeedback_qcername").value,
                    dateReviewed: document.getElementById("canopyfeedback_qcerdate").value,
                    finding: findings,
                    severity: severity,
                    source: "ReQC"
                }, function () {
                    usfeedback_setLastProcess(processid, value);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(function () {
                        usfeedback_atr_bindgrid("Other", processid);
                        clearusfeedbackForm();
                    });
                });
            } else {
                Swal.fire({ icon: 'error', title: 'Error', text: 'Oops! Error occurred while saving feedback. Please contact administrator.' });
            }
        },
        function (error) {
            Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
        }
    );

    return false;
}

function canopyfeedback_editFeedback(index) {
    var row = canopyfeedbackGridRows[index];
    if (!row) return false;
    usfeedback_getElement("editkey").value = row["Feedback Key"] || "";
    usfeedback_select("usfeedback_severity").val(row.Severity || "");
    usfeedback_select("usfeedback_finding").val(row.Finding || "");
    usfeedback_select("btnsubmit").html('<i class="fas fa-save"></i>&nbsp; Update');
    usfeedback_select("btncanceledit").show();
    usfeedback_getElement("usfeedback_severity").focus();
    $('html, body').animate({ scrollTop: usfeedback_select("trOther").offset().top - 20 }, 250);
    return false;
}

function canopyfeedback_cancelEdit() {
    var key = usfeedback_getElement("editkey");
    if (!key) return false;
    key.value = "";
    usfeedback_select("usfeedback_severity").val("");
    usfeedback_select("usfeedback_finding").val("");
    usfeedback_select("btnsubmit").html('<i class="fas fa-plus"></i>&nbsp; Add');
    usfeedback_select("btncanceledit").hide();
    return false;
}

function canopyfeedback_deleteFeedback(index) {
    var row = canopyfeedbackGridRows[index], ddl = usfeedback_getElement("usfeedback_task"), payload = us_getFeedbackPayload() || {};
    if (!row || !ddl) return false;
    Swal.fire({ title: 'Delete Feedback?', text: 'This feedback will be permanently deleted.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Yes, Delete', confirmButtonColor: '#dc2626' }).then(function (choice) {
        if (!choice.isConfirmed) return;
        PageMethods.DeleteOtherFeedback(row["Feedback Key"] || "", parseInt(usfeedback_getElement("usfeedback_projectid").value, 10) || 0,
            parseInt(ddl.value, 10) || 0, usfeedback_getElement("usfeedback_dealno").value, usfeedback_getElement("usfeedback_loanno").value, payload.script || "",
            function (result) { if (result > 0) { canopyfeedback_cancelEdit(); usfeedback_atr_bindgrid("Other", ddl.value); Swal.fire('Deleted', 'Feedback deleted successfully.', 'success'); } else Swal.fire('Not deleted', 'The feedback was not found or you do not have permission to delete it.', 'error'); },
            function (error) { Swal.fire('Error', error.get_message ? error.get_message() : 'Unexpected error occurred.', 'error'); });
    });
    return false;
}

function usfeedback_submit() {

    var projectid = usfeedback_getElement("usfeedback_projectid").value;
    var dealno = usfeedback_getElement("usfeedback_dealno").value;
    var loanno = usfeedback_getElement("usfeedback_loanno").value;
    var ddl = usfeedback_getElement("usfeedback_task");
    var processid = ddl.options[ddl.selectedIndex].value;
    var value = ddl.options[ddl.selectedIndex].text;
    var payload = us_getFeedbackPayload() || {};
    var script = payload.script || "";

    if (value == "" || value == "Select") {
        Swal.fire('Validation', 'Please select task.', 'warning');
        return false;
    }

    else if (value == "ATR Review") {
        var reviewer = usfeedback_getElement("usfeedback_reviewer").value;
        var reviewdate = usfeedback_getElement("usfeedback_reviewdate").value;
        var ddlatrsupported = usfeedback_getElement("usfeedback_atrsupported");
        var atrsupported = ddlatrsupported.options[ddlatrsupported.selectedIndex].value;
        var noofbwr = $.trim(usfeedback_getElement("usfeedback_noofbwr").value);
        var reviewfinding = $.trim(usfeedback_getElement("usfeedback_reviewfindings").value);
        var dtiissue = $.trim(usfeedback_getElement("usfeedback_dtiissue").value);
        var incometype = $.trim(usfeedback_getElement("usfeedback_incometype").value);
        var sebusiness = $.trim(usfeedback_getElement("usfeedback_noofsebus").value);
        var rental = $.trim(usfeedback_getElement("usfeedback_noofrental").value);

        if (atrsupported == "") {
            Swal.fire('Validation', "Please select 'ATR Supported?'", 'warning');
            usfeedback_getElement("usfeedback_atrsupported").focus();
            return false;
        }

        if (noofbwr == "") {
            Swal.fire('Validation', "Please enter '# of Borrowers'", 'warning');
            usfeedback_getElement("usfeedback_noofbwr").focus();
            return false;
        }

        if (reviewfinding == "") {
            Swal.fire('Validation', "Please enter 'Review Findings'", 'warning');
            usfeedback_getElement("usfeedback_reviewfindings").focus();
            return false;
        }

        if (sebusiness == "") {
            Swal.fire('Validation', "Please enter '# SE businesses'", 'warning');
            usfeedback_getElement("usfeedback_noofsebus").focus();
            return false;
        }

        if (rental == "") {
            Swal.fire('Validation', "Please enter '# Rental Properties'", 'warning');
            usfeedback_getElement("usfeedback_noofrental").focus();
            return false;
        }

        var comments = usfeedback_getElement("usfeedback_comments").value;

        usfeedback_callInsertATRFeedbacks(
            [projectid, processid, dealno, loanno, reviewer, reviewdate, atrsupported, reviewfinding, dtiissue, noofbwr,
                incometype, sebusiness, rental, comments], script,
            function (result) {
                if (result > 0) {
                    usfeedback_setLastProcess(processid, value);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(function () {
                        usfeedback_atr_bindgrid("ATR", processid);
                        clearusfeedbackForm();
                    });
                } else {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Oops! Error occurred while saving feedback. Please contact administrator.' });
                }
            },

            function (error) {
                Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
            }
        );
    }
    else {
        var ddlseverity = usfeedback_getElement("usfeedback_severity");
        var severity = ddlseverity.options[ddlseverity.selectedIndex].value;
        var findings = $.trim(usfeedback_getElement("usfeedback_finding").value);

        if (severity == "") {
            Swal.fire('Validation', 'Please select Severity.', 'warning');
            usfeedback_getElement("usfeedback_severity").focus();
            return false;
        }

        if (findings == "") {
            Swal.fire('Validation', 'Please enter Findings.', 'warning');
            usfeedback_getElement("usfeedback_finding").focus();
            return false;
        }

        var originalFinding = usfeedback_getElement("editfinding").value;
        var originalSeverity = usfeedback_getElement("editseverity").value;
        if (originalFinding || originalSeverity) {
            PageMethods.UpdateOtherFeedback(
                parseInt(processid, 10) || 0,
                dealno,
                loanno,
                findings,
                severity,
                originalFinding,
                originalSeverity,
                function (result) {
                    if (result > 0) {
                        feedbackdetails_cancelEdit();
                        usfeedback_atr_bindgrid("Other", processid);
                        Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback updated successfully.' });
                    } else {
                        Swal.fire({ icon: 'error', title: 'Not updated', text: 'The feedback was not found or you do not have permission to update it.' });
                    }
                },
                function (error) {
                    Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
                }
            );
            return false;
        }

        usfeedback_callInsertOtherFeedbacks([projectid, processid, dealno, loanno, findings, severity], script,
            function (result) {
                if (result > 0) {
                    usfeedback_insertExistingFeedback({
                        loanNo: loanno,
                        client: usfeedback_getElement("usfeedback_projectno").value,
                        uwName: usfeedback_getElement("usfeedback_reviewer").value,
                        dateReviewed: usfeedback_getTodayDate(),
                        finding: findings,
                        severity: severity,
                        source: "ReQC"
                    }, function () {
                        usfeedback_setLastProcess(processid, value);
                        Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(function () {
                            usfeedback_atr_bindgrid("Other", processid);
                            clearusfeedbackForm();
                        });
                    });
                } else {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Oops! Error occurred while saving feedback. Please contact administrator.' });
                }
            },

            function (error) {
                Swal.fire({ icon: 'error', title: 'Error', text: error.get_message ? error.get_message() : 'Unexpected error occurred.' });
            }
        );

        return false;

    }
    return false;
}

function feedbackdetails_editFeedback(index) {
    var row = feedbackdetailsGridRows[index];
    if (!row) return false;
    usfeedback_getElement("editfinding").value = row.Finding || "";
    usfeedback_getElement("editseverity").value = row.Severity || "";
    usfeedback_select("usfeedback_severity").val(row.Severity || "");
    usfeedback_select("usfeedback_finding").val(row.Finding || "");
    usfeedback_select("btnsubmit").html('<i class="fas fa-save"></i>&nbsp; Update');
    usfeedback_select("btncanceledit").show();
    usfeedback_getElement("usfeedback_severity").focus();
    $('html, body').animate({ scrollTop: usfeedback_select("trOther").offset().top - 20 }, 250);
    return false;
}

function feedbackdetails_cancelEdit() {
    var finding = usfeedback_getElement("editfinding");
    var severity = usfeedback_getElement("editseverity");
    if (!finding || !severity) return false;
    finding.value = ""; severity.value = "";
    usfeedback_select("usfeedback_severity").val("");
    usfeedback_select("usfeedback_finding").val("");
    usfeedback_select("btnsubmit").html('<i class="fas fa-plus"></i>&nbsp; Add');
    usfeedback_select("btncanceledit").hide();
    return false;
}

function feedbackdetails_deleteFeedback(index) {
    var row = feedbackdetailsGridRows[index], ddl = usfeedback_getElement("usfeedback_task");
    if (!row || !ddl) return false;
    Swal.fire({ title: 'Delete Feedback?', text: 'This feedback will be permanently deleted.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Yes, Delete', confirmButtonColor: '#dc2626' }).then(function (choice) {
        if (!choice.isConfirmed) return;
        PageMethods.DeleteOtherFeedback(parseInt(ddl.value, 10) || 0, usfeedback_getElement("usfeedback_dealno").value,
            usfeedback_getElement("usfeedback_loanno").value, row.Finding || "", row.Severity || "",
            function (result) { if (result > 0) { feedbackdetails_cancelEdit(); usfeedback_atr_bindgrid("Other", ddl.value); Swal.fire('Deleted', 'Feedback deleted successfully.', 'success'); } else Swal.fire('Not deleted', 'The feedback was not found or you do not have permission to delete it.', 'error'); },
            function (error) { Swal.fire('Error', error.get_message ? error.get_message() : 'Unexpected error occurred.', 'error'); });
    });
    return false;
}

function usfeedback_syncNoErrorFinding() {
    var severity = usfeedback_getElement("usfeedback_severity"), finding = usfeedback_getElement("usfeedback_finding");
    if (!severity || !finding) return false;
    if (severity.value === "No Error") finding.value = "No Error";
    else if ($.trim(finding.value) === "No Error") finding.value = "";
    return false;
}


function clearusfeedbackForm() {

    // Textboxes
    // $('#usfeedback_projectno').val('');
    // $('#usfeedback_dealno').val('');
    // $('#usfeedback_loanno').val('');
    usfeedback_select('usfeedback_reviewer').val('');
    usfeedback_select('usfeedback_reviewdate').val('');
    usfeedback_select('usfeedback_noofbwr').val('');
    usfeedback_select('usfeedback_incometype').val('');
    usfeedback_select('usfeedback_noofsebus').val('');
    usfeedback_select('usfeedback_noofrental').val('');

    // Dropdowns
    //$('#usfeedback_task').prop('selectedIndex', 0);
    usfeedback_select('usfeedback_severity').prop('selectedIndex', 0);
    usfeedback_select('usfeedback_atrsupported').prop('selectedIndex', 0);

    // Textareas
    usfeedback_select('usfeedback_finding').val('');
    usfeedback_select('usfeedback_reviewfindings').val('');
    usfeedback_select('usfeedback_dtiissue').val('');
    usfeedback_select('usfeedback_comments').val('');

    // File Upload
    usfeedback_select('usfeedback_fileUploads').val('');
    usfeedback_select('usfeedback_selectedFile').text('');

    // Hide conditional sections
    //$('#trOther').hide();
    usfeedback_select('tratr1').hide();
    usfeedback_select('tratr2').hide();
    usfeedback_select('tratr3').hide();
    usfeedback_select('tratr4').hide();
    usfeedback_select('tratr5').hide();
}


// ----------- Production Summary

var maindate, startIdx, endIdx, totalTimeIdx, TargetIdx, LoanIdx, ProductionIdx, ErrorPerLoanIdx, TotalErrorIdx, CommentsIdx;

function us_prodsum_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_prodsum_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_prodsum_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_prodsum_year").append($("<option></option>").val(i).html(i));
    }
}

function getColumnIndex(columns, name) {
    return columns.findIndex(c => c.data === name);
}

function getprodsummary() {
    //var date = document.getElementById("us_prodsum_date").value;
    //if (date != "")
    var ddlmonth = document.getElementById("us_prodsum_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_prodsum_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;
    us_getproductionSummary(month, year);
    return false;
}

function us_getproductionSummary(month, year) {
    if ($.fn.DataTable.isDataTable('#usprodsum_table')) {
        $('#usprodsum_table').DataTable().clear().destroy();
        $('#usprodsum_table tbody').empty();
    }
    $('#load1').show();

    var columns = [];
    $.ajax({
        url: "ProductionSummary.aspx/GetDatewiseOnShoreProduction_Monthly",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        /*data: "{Date:'" + date + "'}",*/
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if (!dataArray || dataArray.length === 0) {
                $('#load1').hide();
                return;
            }
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#usprodsum_table').DataTable({
                dom: 'ft',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                columnDefs: [
                    { targets: [1, 2, 15, 17, 18], visible: false }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                    if (startIdx === undefined) {
                        maindate = getColumnIndex(columns, 'Date');
                        // startIdx = getColumnIndex(columns, 'StartTime');
                        // endIdx = getColumnIndex(columns, 'EndTime');
                        totalTimeIdx = getColumnIndex(columns, 'TotalTime');
                        TargetIdx = getColumnIndex(columns, 'Target');
                        LoanIdx = getColumnIndex(columns, '# Loans Reviewed');
                        ProductionIdx = getColumnIndex(columns, 'Target vs Production');
                        ErrorPerLoanIdx = getColumnIndex(columns, 'Error Finding Rate');
                        TotalErrorIdx = getColumnIndex(columns, 'Total Errors');
                        CommentsIdx = getColumnIndex(columns, 'Comments');
                    }

                    // Date
                    //if (!aData.maindate) {
                    //    $('td', nRow).eq(maindate).html(
                    //        '<label>' + document.getElementById("us_prodsum_date").value + '</label>'
                    //    );
                    //}

                    // START TIME
                    // if (!aData.StartTime) {
                    //     $('td', nRow).eq(startIdx).html(
                    //         `<input type="time" class="start-time form-control" />`
                    //     );
                    // }

                    // // END TIME
                    // if (!aData.EndTime) {
                    //     $('td', nRow).eq(endIdx).html(
                    //         `<input type="time" class="end-time form-control" />`
                    //     );
                    // }

                    // Comments
                    if (!aData.StartTime) {
                        $('td', nRow).eq(CommentsIdx).html(
                            `<input type="text" class="comment form-control" style="width:350px;" />`
                        );
                    }

                    $(nRow).children("td").css("white-space", "nowrap");
                    setTimeout(toggleSaveButton, 0);
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Summary Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    toggleSaveButton();

    return false;
}

function toggleSaveButton() {
    const hasInputs =
        $('#usprodsum_table tbody')
            .find('input.start-time, input.end-time')
            .length > 0;

    if (hasInputs) {
        $('#us_prodsum_btnsubmit').show();
    } else {
        $('#us_prodsum_btnsubmit').hide();
    }
}

$(document).on('change', '.end-time', function () {
    const $row = $(this).closest('tr');
    const start = $row.find('.start-time').val();
    const end = $(this).val();

    if (!start) {
        alert('Please select Start Time first');
        $(this).val('');
        return;
    }

    const startMin = toMinutes(start);
    const endMin = toMinutes(end);

    if (endMin <= startMin) {
        alert('End Time must be greater than Start Time');
        $(this).val('');
        return;
    }

    const totalMinutes = endMin - startMin;
    // Fill Total Time
    $row.find('td').eq(totalTimeIdx)
        .text(formatMinutes(totalMinutes));

    // Auto-fill remaining columns
    calculateRowValues($row, totalMinutes);
});


function toMinutes(time) {
    const [h, m] = time.split(':').map(Number);
    return h * 60 + m;
}

function formatMinutes(min) {
    const h = Math.floor(min / 60);
    const m = min % 60;
    return `${h}:${String(m).padStart(2, '0')}`;
}

function calculateRowValues($row, totalMinutes) {

    const totalHours = totalMinutes / 60;

    const target = parseFloat(
        $row.find('td').eq(TargetIdx).text().trim()
    ) || 0;

    const loans = parseInt(
        $row.find('td').eq(LoanIdx).text().trim()
    ) || 0;

    // Target vs Production
    let prod = 0;
    if (target > 0 && totalHours > 0) {
        prod = ((loans / (target * totalHours)) * 100).toFixed(0);
    }

    $row.find('td').eq(ProductionIdx).text(prod + '%');

    // Example: Error Rate
    const errors = parseInt($row.find('td').eq(TotalErrorIdx).text()) || 0;
    const errorRate = loans > 0 ? (errors / loans).toFixed(2) : 0;

    $row.find('td').eq(ErrorPerLoanIdx).text(errorRate);
}


$(document).on('focus', '.end-time', function () {
    const $row = $(this).closest('tr');
    if (!$row.find('.start-time').val()) {
        alert('Select Start Time first');
        $row.find('.start-time').focus();
    }
});

function us_prodsum_submit() {
    const table = $('#usprodsum_table').DataTable();
    let records = [];

    table.rows().every(function () {

        const $row = $(this.node());

        const start = $row.find('.start-time').val();
        const end = $row.find('.end-time').val();
        if (start || end) {

            const rowData = this.data();
            //alert(rowData.ProjectID);
            //alert(rowData.ProcessID);
            //alert(document.getElementById("us_prodsum_date").value);
            //alert($row.find('td').eq(totalTimeIdx).text());
            //alert(rowData.DealNo);
            //alert(rowData["Task Performed"]);
            //alert(rowData.Target);
            //alert(rowData['# Loans Reviewed']);
            //alert($row.find('td').eq(ProductionIdx).text().replace('%', ''));
            //alert(rowData['Total Errors']);
            //alert(rowData['Total Crtical Errors']);
            //alert(rowData['Total Non-Crtical Errors']);
            //alert(rowData['Incorrect Errors']);
            //alert($row.find('td').eq(ErrorPerLoanIdx).text());
            //alert(rowData['Cost/Loan']);
            //alert($row.find('.comment').val());
            //alert(start);
            //alert(end);
            records.push({
                ProjectID: rowData.ProjectID,
                ProcessID: rowData.ProcessID,
                Date: rowData.Date,
                TotalTime: $row.find('td').eq(totalTimeIdx).text(),
                DealNo: rowData.DealNo,
                TaskPerformed: rowData["Task Performed"],
                Target: rowData.Target,
                LoansReviewed: rowData['# Loans Reviewed'],
                TargetvsProduction: $row.find('td').eq(ProductionIdx).text().replace('%', ''),
                TotalErrors: rowData['Total Errors'],
                TotalCriticalErrors: rowData['Total Crtical Errors'],
                TotalNonCriticalErrors: rowData['Total Non-Crtical Errors'],
                IncorrectErrors: rowData['Incorrect Errors'] === null ? 0 : rowData['Incorrect Errors'],
                ErrorFindingRate: $row.find('td').eq(ErrorPerLoanIdx).text(),
                CostPerLoan: rowData['Cost/Loan'] === null ? 0 : rowData['Cost/Loan'],
                Comments: $row.find('.comment').val(),
                StartTime: start,
                EndTime: end

            });
        }
    });

    if (records.length === 0) {
        alert('No records to save');
        return;
    }

    saveRecords(records);
    return false;
}

function saveRecords(data) {
    $.ajax({
        url: 'ProductionSummary.aspx/SaveProductionSummary',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        data: JSON.stringify({ records: data }),
        success: function (res) {
            alert('Records saved successfully');
            $('#btnSave').hide();
        },
        error: function (err) {
            alert('Error while saving data');
            console.error(err);
        }
    });
    getprodsummary();
    return false;
}

// ----- Production Report

function us_prodsum_rpt_bindyear() {
    var start = new Date().getFullYear();

    var select = document.getElementById("us_prodsum_rpt_year");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#us_prodsum_rpt_year").append($("<option></option>").val("").html("Select"));
    for (var i = start; i > start - 5; i--) {
        $("#us_prodsum_rpt_year").append($("<option></option>").val(i).html(i));
    }
}

function us_rpt_getproductionSummary() {
    var ddlmonth = document.getElementById("us_prodsum_rpt_month");
    var month = ddlmonth.options[ddlmonth.selectedIndex].value;
    var ddlyear = document.getElementById("us_prodsum_rpt_year");
    var year = ddlyear.options[ddlyear.selectedIndex].value;

    if ($.fn.DataTable.isDataTable('#usprodsum_table')) {
        $('#usprodsum_table').DataTable().clear().destroy();
        $('#usprodsum_table tbody').empty();
    }
    $('#load1').show();

    var columns = [];
    $.ajax({
        url: "ProductionReport.aspx/GetDatewiseOnShoreProduction_Monthly",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{Month:'" + month + "', Year:'" + year + "'}",
        /*data: "{Date:'" + date + "'}",*/
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            if (!dataArray || dataArray.length === 0) {
                $('#load1').hide();
                return;
            }
            $.each(dataArray[0], function (key, value) {

                var my_item = {};
                my_item.data = key;
                my_item.title = key;
                columns.push(my_item);
            });

            $('#usprodsum_rpt_table').DataTable({
                dom: 'ft',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": false,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: columns,
                columnDefs: [
                    { targets: [15, 16, 17], visible: false }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Production Report', autoFilter: true,
                    },
                ],
            });

        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    toggleSaveButton();

    return false;
}
