

var USLoanDetails_html;
var USLoanDetails_table;

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function htmlForCell(value) {
    return $('<div />').text(blankForNull(value)).html();
}

function idForCell(value) {
    return String(blankForNull(value)).replace(/[^A-Za-z0-9_-]/g, '_');
}

function getUSLoanLoader() {
    return $('#usload1, #load1').first();
}

function showUSLoanLoader() {
    getUSLoanLoader().show();
}

function hideUSLoanLoader() {
    getUSLoanLoader().hide();
}

function updateUSLoanDetailsCount(total) {
    var count = Number(total) || 0;
    $('#usLoanTaskCount').text(count);
    $('#usLoanTaskCountLabel').text(count + (count === 1 ? ' task' : ' tasks'));
}

function refreshUSLoanDateInputs() {
    if (typeof refreshLoanDateInputs === 'function') {
        refreshLoanDateInputs();
    }
}

function BindUSLoanDetails_Grid() {

    showUSLoanLoader();

    USLoanDetails_html = '';
    $.ajax({
        url: "LoanDetails.aspx/GetLoanDetails_RemoteUW_REQC",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                var processId = idForCell(value.ProcessID);
                var processIdForAction = parseInt(blankForNull(value.ProcessID), 10) || 0;
                var processIdForCompletion = htmlForCell(value.ProcessID1);

                USLoanDetails_html += '<tr class="loan-task-row">';
                USLoanDetails_html += '<td class="loan-hidden text-center" style="display:none;"><a title="Complete Loan" class="dropdown-item" href="#!" id="Actions" onclick="complete_Loan(' + processIdForAction + ',' + index + ');"><span class="text-success"><i class="uil uil-stop-circle" style="font-size:16px;"></i></span></a></td>';
                USLoanDetails_html += '<td class="loan-time-cell"><input type="datetime-local" id="us_add_date_start_' + processId + '" class="start-dt form-control form-control-sm loan-date-input" autocomplete="off" /></td>';
                USLoanDetails_html += '<td class="loan-time-cell"><input type="datetime-local" id="us_add_date_end_' + processId + '" class="end-dt form-control form-control-sm loan-date-input" autocomplete="off" disabled="disabled" /></td>';
                USLoanDetails_html += '<td class="processid loan-hidden" style="display:none;">' + processIdForCompletion + '</td>';
                USLoanDetails_html += '<td class="client">' + htmlForCell(value.ProjectNo) + '</td>';
                USLoanDetails_html += '<td class="deal">' + htmlForCell(value.DealNo) + '</td>';
                USLoanDetails_html += '<td class="loan">' + htmlForCell(value.LoanNo) + '</td>';
                USLoanDetails_html += '<td class="recdate">' + htmlForCell(value.OrderDate) + '</td>';
                USLoanDetails_html += '<td class="process">' + htmlForCell(value.Process) + '</td>';
                USLoanDetails_html += '<td class="uwname loan-hidden" style="display:none;">' + htmlForCell(value.RemoteUW) + '</td>';
                USLoanDetails_html += '<td class="loan-hidden" style="display:none;">' + htmlForCell(value.ProcessDate) + '</td>';
                USLoanDetails_html += '</tr>';

            });

            if ($.fn.dataTable.isDataTable('#table_USLoanDetails')) {
                USLoanDetails_table.destroy();
            }
            $('#table_USLoanDetails tbody').html(USLoanDetails_html);

            USLoanDetails_table = $('#table_USLoanDetails').DataTable({
                dom: '<"row mb-2"<"col-sm-12 col-md-5"l><"col-sm-12 col-md-7"f>>rt<"row mt-2"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                destroy: true,
                scrollX: true,
                "paging": true,
                "pageLength": 10,
                "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                "autoWidth": false,
                select: true,
                "ordering": false,
                processing: true,
                language: {
                    search: "",
                    searchPlaceholder: "Search tasks..."
                },
                'select': {
                    'style': 'single'
                },

                drawCallback: function () {
                    refreshUSLoanDateInputs();
                },

                initComplete: function () {
                    hideUSLoanLoader();
                    updateUSLoanDetailsCount(dataArray.length);
                    refreshUSLoanDateInputs();
                },
            });
        },

        error: function (error) {
            hideUSLoanLoader();
            updateUSLoanDetailsCount(0);
            alert('Error loading loan details. ' + (error.responseText || 'Please contact administrator.'));
        }
    });
    return false;
}

function complete_Loan(ProcessID, index) {

    ProcessFeedbackID = ProcessID;

    if (!USLoanDetails_table) {
        return false;
    }

    var rowNode = USLoanDetails_table.row(index).node();
    var $row = $(rowNode);

    if (typeof handleEndDateChange === 'function') {
        return handleEndDateChange($row.find('.end-dt'));
    }

    if (typeof completeOrder === 'function') {
        return completeOrder($row);
    }

    return false;
}

function completeLoan_OnSuccess(result) {
    if (result > 0) {
        $('#us_completeLoan').modal('show');
        return false;
    }
    else {
        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }
}

function completeLoan_OnError(error) {
    alert(error.responseText);
}

function us_redirectAddFeedback() {

    window.location.href = "AddFeedback.aspx?ProcessID=" + ProcessFeedbackID;
}


var ProcessFeedbackID_1 = 0;
var dealno_cons;
var loanno_cons;
var process_cons;

// $(document).ready(function () {

//     BindUSLoanDetails_Grid();

//     $('#usRefreshLoanDetails').on('click', function () {
//         BindUSLoanDetails_Grid();
//     });

//     $(document).on('focus', '.end-dt', function () {
//         const $row = $(this).closest('tr');
//         const startVal = $row.find('.start-dt').val();

//         if (!startVal) {
//             alert('Select Start Date & Time first');
//             $row.find('.start-dt').focus();
//         }
//     });

//     $(document).on('change', '.start-dt', function () {
//         handleStartDateChange($(this));
//     });

//     $(document).on('change', '.end-dt', function () {
//         handleEndDateChange($(this));
//     });
// });

function handleStartDateChange($input) {
    normalizeLoanDateInput($input);

    const $row = $input.closest('tr');
    const startVal = $input.val();
    const $endInput = $row.find('.end-dt');

    $endInput.prop('disabled', !startVal);
    $endInput.attr('max', getNowForInput());

    if (startVal) {
        $endInput.attr('min', startVal);
    }
    else {
        $endInput.removeAttr('min').val('');
        return false;
    }

    const endVal = $endInput.val();

    if (endVal && new Date(endVal) <= new Date(startVal)) {
        alert('End Date & Time must be greater than Start Date & Time');
        $endInput.val('').focus();
    }

    return false;
}

function handleEndDateChange($input) {
    const $row = $input.closest('tr');
    const startVal = $row.find('.start-dt').val();

    if (!startVal) {
        alert('Please select Start Date & Time first');
        $input.val('');
        $row.find('.start-dt').focus();
        return false;
    }

    normalizeLoanDateInput($input);

    const endVal = $input.val();

    if (!endVal) {
        alert('Please select End Date & Time');
        return false;
    }

    const startDate = new Date(startVal);
    const endDate = new Date(endVal);

    if (endDate <= startDate) {
        alert('End Date & Time must be greater than Start Date & Time');
        $input.val('');
        return false;
    }

    completeOrder($row);
    return false;
}

function normalizeLoanDateInput($input) {
    const value = $input.val();

    if (!value) {
        return false;
    }

    const selected = new Date(value);
    const now = new Date();

    if (selected > now) {
        alert('Future date & time is not allowed');
        $input.val(getNowForInput());
        return true;
    }

    return false;
}

function refreshLoanDateInputs() {
    const maxValue = getNowForInput();

    $('.start-dt, .end-dt').attr('max', maxValue);

    $('.end-dt').each(function () {
        const $endInput = $(this);
        const $row = $endInput.closest('tr');
        const startVal = $row.find('.start-dt').val();

        $endInput.prop('disabled', !startVal);

        if (startVal) {
            $endInput.attr('min', startVal);
        }
        else {
            $endInput.removeAttr('min');
        }
    });
}

function setLoanBusyState(isBusy) {
    if (isBusy) {
        $('#usload1').show();
    }
    else {
        $('#usload1').hide();
    }
}

function getNowForInput() {
    const now = new Date();

    const yyyy = now.getFullYear();
    const mm = String(now.getMonth() + 1).padStart(2, '0');
    const dd = String(now.getDate()).padStart(2, '0');
    const hh = String(now.getHours()).padStart(2, '0');
    const min = String(now.getMinutes()).padStart(2, '0');

    return `${yyyy}-${mm}-${dd}T${hh}:${min}`;
}

function completeOrder($row) {
    const data = {
        clientId: $row.find('.client').text(),
        dealNo: $row.find('.deal').text(),
        loanNo: $row.find('.loan').text(),
        recDate: $row.find('.recdate').text(),
        startDt: $row.find('.start-dt').val(),
        endDt: $row.find('.end-dt').val(),
        process: $row.find('.process').text(),
        uwname: $row.find('.uwname').text(),
        processid: $row.find('.processid').text()
    };
    dealno_cons = data.dealNo;
    loanno_cons = data.loanNo;
    process_cons = data.processid;
    ProcessFeedbackID_1 = data.processid;

    if ($row.data('loan-saving')) {
        return false;
    }

    $row.data('loan-saving', true).addClass('loan-row-saving');
    setLoanBusyState(true);
    PageMethods.InsertModifyUWOrderOC22Servicing(data.clientId, data.dealNo, data.loanNo, data.process, data.uwname, data.startDt, data.endDt, us_completeLoan_OnSuccess, us_completeLoan_OnError);
    return false;
}

function clearLoanSavingState() {
    $('#table_USLoanDetails tbody tr.loan-row-saving').each(function () {
        $(this).removeData('loan-saving').removeClass('loan-row-saving');
    });

    setLoanBusyState(false);
}

function us_completeLoan_OnSuccess(result) {
    clearLoanSavingState();

    if (result > 0) {
        $('#us_completeLoan').modal('show');
        return false;
    }
    else {
        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }
}

function us_completeLoan_OnError(error) {
    clearLoanSavingState();
    alert(error.responseText);
}

function us_redirectAddFeedback_1() {
    const payload = {
        ln: loanno_cons,
        dn: dealno_cons,
        tp: process_cons
    };

    const encoded = btoa(JSON.stringify(payload));
    location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
    //window.location.href = "AddFeedback.aspx?ProcessID=" + ProcessFeedbackID_1;
}