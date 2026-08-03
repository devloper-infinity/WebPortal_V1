
/*--------------- Loan Details Functions--------------- */

var USLoanDetails_html;
var USLoanDetails_table;
var usfeedbackLoanStarted = false;
var usfeedbackStartDatetime = "";
var usfeedbackLastProcessID = "";
var usfeedbackLastProcessName = "";
var usfeedbackRecordCount = 0;

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

    if (payload && payload.src == "MyQueue") {
        return "MyQueue.aspx";
    }

    if (payload && payload.src == "Dashboard") {
        return "Dashboard.aspx";
    }

    return defaultUrl;
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

    if (Severity == "") {
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
    syncAddFeedbackFindingRequirement();
    $('#btnAddFeedback').html('<i class="fas fa-save"></i>&nbsp; Update Feedback');
    $('#btnCancelEdit').show();
    $('#USLoanDetails_Severity').focus();
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

function us_getGlobalSearchLoanData(rowData) {
    return {
        processID: us_getValueByKeys(rowData, ["ProcessID", "ProcessID1", "Process ID", "Process Id"]),
        projectNumber: us_getValueByKeys(rowData, ["Client", "ProjectNumber", "ProjectNo", "Project No", "Project #"]),
        dealNo: us_getValueByKeys(rowData, ["Deal #", "DealNo", "Deal No"]),
        loanNo: us_getValueByKeys(rowData, ["Loan #", "LoanNo", "Loan No", "OrderNumber", "Order Number"]),
        orderDate: us_getValueByKeys(rowData, ["Order Date", "OrderDate", "Received Date", "RecDate"]),
        process: us_getValueByKeys(rowData, ["Process", "ProcessName", "Process Name"]),
        review: us_getValueByKeys(rowData, ["RemoteUW", "Reviewer", "Review", "UW Name"])
    };
}

function us_startGlobalSearchLoan(button, rowData) {
    var $button = $(button);
    var loanData = us_getGlobalSearchLoanData(rowData || {});

    if (!loanData.loanNo || !loanData.dealNo) {
        Swal.fire('Warning', 'Loan details are not available for this row.', 'warning');
        return false;
    }

    if ($button.data('saving')) {
        return false;
    }

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

    PageMethods.StartLoan(
        parseInt(loanData.processID, 10) || 0,
        loanData.projectNumber || "",
        loanData.dealNo || "",
        loanData.loanNo || "",
        loanData.orderDate || "",
        loanData.process || "",
        loanData.review || "",
        loanData.startDatetime,

        function (result) {
            if (result > 0) {
                GetFeedbackPage(
                    loanData.loanNo,
                    loanData.dealNo,
                    loanData.processID,
                    "GlobalSearch",
                    loanData.projectNumber,
                    loanData.orderDate,
                    loanData.process,
                    loanData.review,
                    loanData.startDatetime,
                    true
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

function GetFeedbackPage(loanno, dealno, processid, source, client, orderDate, process, review, startDatetime, started) {
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
    location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
}

function GetLoggedInUserDetails() {
    $.ajax({
        type: "POST", url: "FeedbackDetails.aspx/GetLoggedInUser", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                document.getElementById("usfeedback_reviewer").value = blankForNull(value.FullName);
                document.getElementById("usfeedback_reviewer").readonly = true;

            })
        }
    });
}

function bindloanDetails_feedback() {
    const decoded = us_getFeedbackPayload();
    if (!decoded) return;

    usfeedbackLoanStarted = decoded.started === true || decoded.started === "true";
    usfeedbackStartDatetime = decoded.sd || decoded.startDatetime || "";
    if (document.getElementById("usfeedback_back")) {
        document.getElementById("usfeedback_back").href = us_getFeedbackReturnUrl("LoanDetails.aspx");
    }

    $.ajax({
        url: "FeedbackDetails.aspx/GetLoanDetailsbyLoanNo",
        type: "POST",
        dataType: "json",
        data: "{DealNo:'" + decoded.dn + "',LoanNo:'" + decoded.ln + "'}",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                document.getElementById("usfeedback_projectno").value = value.ProjectName;
                document.getElementById("usfeedback_dealno").value = value.DealNo;
                document.getElementById("usfeedback_loanno").value = value.LoanNo;
                document.getElementById("usfeedback_projectid").value = value.ProjectID;


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

    $("#usfeedback_task").empty()
        .append('<option value="">Select</option>');

    $.ajax({
        type: "POST",
        url: "FeedbackDetails.aspx/GetUSProcessTask",
        dataType: "json",
        contentType: "application/json",
        data: JSON.stringify({ ProjectID: Projectid }),

        success: function (res) {

            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (index, value) {

                // Prevent duplicate option
                if ($("#usfeedback_task option[value='" + value.ProcessID + "']").length === 0) {
                    $("#usfeedback_task").append(
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

            if (decoded.tp) {

                $("#usfeedback_task").val(decoded.tp);

                // Call only once
                getTaskwiseDetails(document.getElementById("usfeedback_task"));

                document.getElementById("usfeedback_back").href = us_getFeedbackReturnUrl("LoanDetails.aspx");
            }
        }
    });
}

function getTaskwiseDetails(ddl) {

    var value = ddl.options[ddl.selectedIndex].text;
    var id = ddl.options[ddl.selectedIndex].value;

    if (value == "" || value == "Select") {
        document.getElementById("trOther").style.display = 'none';
        document.getElementById("tratr1").style.display = 'none';
        document.getElementById("tratr2").style.display = 'none';
        document.getElementById("tratr3").style.display = 'none';
        document.getElementById("tratr4").style.display = 'none';
        document.getElementById("tratr5").style.display = 'none';
    }
    else if (value == "ATR Review") {
        document.getElementById("trOther").style.display = 'none';
        document.getElementById("tratr1").style.display = '';
        document.getElementById("tratr2").style.display = '';
        document.getElementById("tratr3").style.display = '';
        document.getElementById("tratr4").style.display = '';
        document.getElementById("tratr5").style.display = '';
        var date = new Date();
        var day = String(date.getDate()).padStart(2, '0');
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var year = date.getFullYear();

        var actualdate = year + "-" + month + "-" + day;

        document.getElementById("usfeedback_reviewdate").value = actualdate;

        usfeedback_startLoanIfNeeded(id, value);
        usfeedback_atr_bindgrid("ATR", id);
    }
    else {
        document.getElementById("trOther").style.display = '';
        document.getElementById("tratr1").style.display = 'none';
        document.getElementById("tratr2").style.display = 'none';
        document.getElementById("tratr3").style.display = 'none';
        document.getElementById("tratr4").style.display = 'none';
        document.getElementById("tratr5").style.display = 'none';
        usfeedback_startLoanIfNeeded(id, value);
        usfeedback_atr_bindgrid("Other", id);

    }
}

function usfeedback_atr_bindgrid(type, processid) {
    $('#load1').show();
    usfeedbackRecordCount = 0;
    var columns = [];
    var dealno = document.getElementById("usfeedback_dealno").value;
    var loanno = document.getElementById("usfeedback_loanno").value;

    $.ajax({
        url: "FeedbackDetails.aspx/GetATRDetails",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{DealNo:'" + dealno + "', LoanNo:'" + loanno + "', Type:'" + type + "', ProcessID:" + processid + "}",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            usfeedbackRecordCount = dataArray ? dataArray.length : 0;
            if ($.fn.DataTable.isDataTable('#usfeedback_table')) {
                $('#usfeedback_table').DataTable().clear().destroy();
            }
            if (dataArray != '') {
                $.each(dataArray[0], function (key, value) {

                    var my_item = {};
                    my_item.data = key;
                    my_item.title = key;
                    columns.push(my_item);
                });
                $('#usfeedback_table').DataTable({
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

            }
            else {
                $('#load1').hide();
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

    return {
        processID: parseInt(processid, 10) || 0,
        projectNumber: document.getElementById("usfeedback_projectno").value || payload.client || "",
        dealNo: document.getElementById("usfeedback_dealno").value || payload.dn || "",
        loanNo: document.getElementById("usfeedback_loanno").value || payload.ln || "",
        orderDate: payload.od || "",
        process: processName || payload.process || "",
        review: document.getElementById("usfeedback_reviewer").value || payload.review || "",
        startDatetime: usfeedbackStartDatetime || payload.sd || payload.startDatetime || usfeedback_getNowDateTime()
    };
}

function usfeedback_startLoanIfNeeded(processid, processName) {
    const payload = us_getFeedbackPayload();

    if (!payload || payload.src != "GlobalSearch" || usfeedbackLoanStarted || !processid) {
        return false;
    }

    var loanData = usfeedback_getLoanProcessData(processid, processName);
    usfeedbackStartDatetime = loanData.startDatetime;

    PageMethods.StartLoan(
        loanData.processID,
        loanData.projectNumber,
        loanData.dealNo,
        loanData.loanNo,
        loanData.orderDate,
        loanData.process,
        loanData.review,
        loanData.startDatetime,

        function (result) {
            if (result > 0) {
                usfeedbackLoanStarted = true;
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

    var ddl = document.getElementById("usfeedback_task");
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

        PageMethods.CompleteLoan(
            loanData.processID,
            loanData.projectNumber,
            loanData.dealNo,
            loanData.loanNo,
            loanData.orderDate,
            loanData.process,
            loanData.review,
            loanData.startDatetime,

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

function usfeedback_submit() {

    var projectid = document.getElementById("usfeedback_projectid").value;
    var dealno = document.getElementById("usfeedback_dealno").value;
    var loanno = document.getElementById("usfeedback_loanno").value;
    var ddl = document.getElementById("usfeedback_task");
    var processid = ddl.options[ddl.selectedIndex].value;
    var value = ddl.options[ddl.selectedIndex].text;

    if (value == "" || value == "Select") {
        Swal.fire('Validation', 'Please select task.', 'warning');
        return false;
    }

    else if (value == "ATR Review") {
        var reviewer = document.getElementById("usfeedback_reviewer").value;
        var reviewdate = document.getElementById("usfeedback_reviewdate").value;
        var ddlatrsupported = document.getElementById("usfeedback_atrsupported");
        var atrsupported = ddlatrsupported.options[ddlatrsupported.selectedIndex].value;

        if (atrsupported == "") {
            Swal.fire('Validation', "Please select 'ATR Supported?'", 'warning');
            document.getElementById("usfeedback_atrsupported").focus();
            return false;
        }

        if (noofbwr == "") {
            Swal.fire('Validation', "Please enter '# of Borrowers'", 'warning');
            document.getElementById("usfeedback_noofbwr").focus();
            return false;
        }

        if (reviewfinding == "") {
            Swal.fire('Validation', "Please enter 'Review Findings'", 'warning');
            document.getElementById("usfeedback_reviewfindings").focus();
            return false;
        }

        if (sebusiness == "") {
            Swal.fire('Validation', "Please enter '# SE businesses'", 'warning');
            document.getElementById("usfeedback_noofsebus").focus();
            return false;
        }

        if (rental == "") {
            Swal.fire('Validation', "Please enter '# Rental Properties'", 'warning');
            document.getElementById("usfeedback_noofrental").focus();
            return false;
        }

        var comments = document.getElementById("usfeedback_comments").value;

        PageMethods.InsertATRFeedbacks(projectid, processid, dealno, loanno, reviewer, reviewdate, atrsupported, reviewfinding, dtiissue, noofbwr,
            incometype, sebusiness, rental, comments,

            function (result) {
                if (result > 0) {
                    usfeedback_setLastProcess(processid, value);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(() => {
                        // location.reload();
                        if (value == "ATR Review")
                            usfeedback_atr_bindgrid("ATR", processid);
                        else
                            usfeedback_atr_bindgrid("Other", processid);

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
        var ddlseverity = document.getElementById("usfeedback_severity");
        var severity = ddlseverity.options[ddlseverity.selectedIndex].value;
        var findings = $.trim(document.getElementById("usfeedback_finding").value);

        if (severity == "") {
            Swal.fire('Validation', 'Please select Severity.', 'warning');
            document.getElementById("usfeedback_severity").focus();
            return false;
        }

        if (findings == "") {
            Swal.fire('Validation', 'Please enter Findings.', 'warning');
            document.getElementById("usfeedback_finding").focus();
            return false;
        }

        PageMethods.InsertOtherFeedbacks(projectid, processid, dealno, loanno, findings, severity,

            function (result) {
                if (result > 0) {
                    usfeedback_setLastProcess(processid, value);
                    Swal.fire({ icon: 'success', title: 'Success', text: 'Feedback submitted successfully.' }).then(() => {
                        // location.reload();
                        if (value == "ATR Review")
                            usfeedback_atr_bindgrid("ATR", processid);
                        else
                            usfeedback_atr_bindgrid("Other", processid);

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
    return false;
}


function clearusfeedbackForm() {

    // Textboxes
    // $('#usfeedback_projectno').val('');
    // $('#usfeedback_dealno').val('');
    // $('#usfeedback_loanno').val('');
    $('#usfeedback_reviewer').val('');
    $('#usfeedback_reviewdate').val('');
    $('#usfeedback_noofbwr').val('');
    $('#usfeedback_incometype').val('');
    $('#usfeedback_noofsebus').val('');
    $('#usfeedback_noofrental').val('');

    // Dropdowns
    //$('#usfeedback_task').prop('selectedIndex', 0);
    $('#usfeedback_severity').prop('selectedIndex', 0);
    $('#usfeedback_atrsupported').prop('selectedIndex', 0);

    // Textareas
    $('#usfeedback_finding').val('');
    $('#usfeedback_reviewfindings').val('');
    $('#usfeedback_dtiissue').val('');
    $('#usfeedback_comments').val('');

    // File Upload
    $('#usfeedback_fileUploads').val('');
    $('#usfeedback_selectedFile').text('');

    // Hide conditional sections
    //$('#trOther').hide();
    $('#tratr1').hide();
    $('#tratr2').hide();
    $('#tratr3').hide();
    $('#tratr4').hide();
    $('#tratr5').hide();
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
                    { targets: [1,2,15, 17, 18], visible: false }
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
                    { targets: [15,16, 17], visible: false }
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
