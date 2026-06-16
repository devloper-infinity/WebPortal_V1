var USLoanDetails_html = "";
var USLoanDetails_table = null;
var ProcessFeedbackID = 0;
var ProcessFeedbackID_1 = 0;
var dealno_cons = "";
var loanno_cons = "";
var process_cons = "";

(function (window, $) {
    "use strict";

    var selectors = {
        loader: "#usload1, #load1",
        table: "#table_USLoanDetails",
        tbody: "#table_USLoanDetails tbody",
        refreshButton: "#usRefreshLoanDetails",
        completeModal: "#us_completeLoan",
        taskCount: "#usLoanTaskCount",
        taskCountLabel: "#usLoanTaskCountLabel"
    };

    var state = {
        table: null,
        isLoading: false
    };

    function blankForNull(value) {
        return value === null || value === undefined || value === "null" ? "" : value;
    }

    function htmlForCell(value) {
        return String(blankForNull(value))
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function idForCell(value) {
        return String(blankForNull(value)).replace(/[^A-Za-z0-9_-]/g, "_");
    }

    function getUSLoanLoader() {
        return $(selectors.loader).first();
    }

    function showUSLoanLoader() {
        getUSLoanLoader().show();
    }

    function hideUSLoanLoader() {
        getUSLoanLoader().hide();
    }

    function updateUSLoanDetailsCount(total) {
        var count = Number(total) || 0;

        $(selectors.taskCount).text(count);
        $(selectors.taskCountLabel).text(count + (count === 1 ? " task" : " tasks"));
    }

    function parseLoanData(response) {
        if (!response || response.d === null || response.d === undefined) {
            return [];
        }

        if ($.isArray(response.d)) {
            return response.d;
        }

        return JSON.parse(response.d || "[]");
    }

    function renderLoanRow(value, index) {
        var processId = idForCell(value.ProcessID);
        var processIdForAction = parseInt(blankForNull(value.ProcessID), 10) || 0;
        var processIdForCompletion = htmlForCell(value.ProcessID1);

        return [
            '<tr class="loan-task-row">',
            '<td class="loan-hidden text-center" style="display:none;">',
            '<a title="Complete Loan" class="dropdown-item" href="#!" onclick="return complete_Loan(' + processIdForAction + "," + index + ');">',
            '<span class="text-success"><i class="uil uil-stop-circle" style="font-size:16px;"></i></span>',
            '</a>',
            '</td>',
            '<td class="loan-time-cell"><input type="datetime-local" id="us_add_date_start_' + processId + '" class="start-dt form-control form-control-sm loan-date-input" autocomplete="off" /></td>',
            '<td class="loan-time-cell"><input type="datetime-local" id="us_add_date_end_' + processId + '" class="end-dt form-control form-control-sm loan-date-input" autocomplete="off" disabled="disabled" /></td>',
            '<td class="processid loan-hidden" style="display:none;">' + processIdForCompletion + '</td>',
            '<td class="client">' + htmlForCell(value.ProjectNo) + '</td>',
            '<td class="deal">' + htmlForCell(value.DealNo) + '</td>',
            '<td class="loan">' + htmlForCell(value.LoanNo) + '</td>',
            '<td class="recdate">' + htmlForCell(value.OrderDate) + '</td>',
            '<td class="process">' + htmlForCell(value.Process) + '</td>',
            '<td class="uwname loan-hidden" style="display:none;">' + htmlForCell(value.RemoteUW) + '</td>',
            '<td class="loan-hidden" style="display:none;">' + htmlForCell(value.ProcessDate) + '</td>',
            '</tr>'
        ].join("");
    }

    function refreshUSLoanDateInputs() {
        refreshLoanDateInputs();
    }

    function destroyLoanDataTable() {
        if ($.fn.dataTable && $.fn.dataTable.isDataTable(selectors.table)) {
            $(selectors.table).DataTable().clear().destroy();
        }

        state.table = null;
        USLoanDetails_table = null;
    }

    function initializeLoanDataTable(totalRows) {
        state.table = $(selectors.table).DataTable({
            dom: '<"row mb-2"<"col-sm-12 col-md-5"l><"col-sm-12 col-md-7"f>>rt<"row mt-2"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
            destroy: true,
            scrollX: true,
            paging: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
            autoWidth: false,
            ordering: false,
            processing: true,
            deferRender: true,
            select: {
                style: "single"
            },
            language: {
                search: "",
                searchPlaceholder: "Search tasks..."
            },
            drawCallback: refreshUSLoanDateInputs,
            initComplete: function () {
                hideUSLoanLoader();
                updateUSLoanDetailsCount(totalRows);
                refreshUSLoanDateInputs();
            }
        });
        USLoanDetails_table = state.table;
    }

    function BindUSLoanDetails_Grid() {
        if (state.isLoading) {
            return false;
        }

        state.isLoading = true;
        showUSLoanLoader();

        $.ajax({
            url: "LoanDetails.aspx/GetLoanDetails_RemoteUW_REQC",
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                var dataArray;
                var rowsHtml;

                try {
                    dataArray = parseLoanData(response);
                    rowsHtml = $.map(dataArray, renderLoanRow).join("");
                }
                catch (error) {
                    hideUSLoanLoader();
                    updateUSLoanDetailsCount(0);
                    alert("Error reading loan details. Please contact administrator.");
                    return;
                }

                USLoanDetails_html = rowsHtml;
                destroyLoanDataTable();
                $(selectors.tbody).html(rowsHtml);
                initializeLoanDataTable(dataArray.length);
            },
            error: function (error) {
                hideUSLoanLoader();
                updateUSLoanDetailsCount(0);
                alert("Error loading loan details. " + (error.responseText || "Please contact administrator."));
            },
            complete: function () {
                state.isLoading = false;
            }
        });

        return false;
    }

    function complete_Loan(ProcessID, index) {
        var rowNode;
        var $row;

        ProcessFeedbackID = ProcessID;

        if (!state.table) {
            return false;
        }

        rowNode = state.table.row(index).node();

        if (!rowNode) {
            return false;
        }

        $row = $(rowNode);
        return handleEndDateChange($row.find(".end-dt"));
    }

    function completeLoan_OnSuccess(result) {
        if (result > 0) {
            $(selectors.completeModal).modal("show");
            return false;
        }

        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }

    function completeLoan_OnError(error) {
        alert(error.responseText || "Unable to complete loan. Please contact administrator.");
    }

    function us_redirectAddFeedback() {
        window.location.href = "AddFeedback.aspx?ProcessID=" + encodeURIComponent(ProcessFeedbackID);
    }

    function handleStartDateChange($input) {
        var $row;
        var startVal;
        var $endInput;
        var endVal;

        normalizeLoanDateInput($input);

        $row = $input.closest("tr");
        startVal = $input.val();
        $endInput = $row.find(".end-dt");

        $endInput.prop("disabled", !startVal);
        $endInput.attr("max", getNowForInput());

        if (!startVal) {
            $endInput.removeAttr("min").val("");
            return false;
        }

        $endInput.attr("min", startVal);
        endVal = $endInput.val();

        if (endVal && new Date(endVal) <= new Date(startVal)) {
            alert("End Date & Time must be greater than Start Date & Time");
            $endInput.val("").focus();
        }

        return false;
    }

    function handleEndDateChange($input) {
        var $row = $input.closest("tr");
        var startVal = $row.find(".start-dt").val();
        var endVal;
        var startDate;
        var endDate;

        if (!startVal) {
            alert("Please select Start Date & Time first");
            $input.val("");
            $row.find(".start-dt").focus();
            return false;
        }

        normalizeLoanDateInput($input);
        endVal = $input.val();

        if (!endVal) {
            alert("Please select End Date & Time");
            return false;
        }

        startDate = new Date(startVal);
        endDate = new Date(endVal);

        if (endDate <= startDate) {
            alert("End Date & Time must be greater than Start Date & Time");
            $input.val("");
            return false;
        }

        return completeOrder($row);
    }

    function normalizeLoanDateInput($input) {
        var value = $input.val();
        var selected;
        var now;

        if (!value) {
            return false;
        }

        selected = new Date(value);
        now = new Date();

        if (selected > now) {
            alert("Future date & time is not allowed");
            $input.val(getNowForInput());
            return true;
        }

        return false;
    }

    function refreshLoanDateInputs() {
        var maxValue = getNowForInput();

        $(".start-dt, .end-dt").attr("max", maxValue);

        $(".end-dt").each(function () {
            var $endInput = $(this);
            var $row = $endInput.closest("tr");
            var startVal = $row.find(".start-dt").val();

            $endInput.prop("disabled", !startVal);

            if (startVal) {
                $endInput.attr("min", startVal);
            }
            else {
                $endInput.removeAttr("min");
            }
        });
    }

    function setLoanBusyState(isBusy) {
        if (isBusy) {
            showUSLoanLoader();
        }
        else {
            hideUSLoanLoader();
        }
    }

    function getNowForInput() {
        var now = new Date();
        var yyyy = now.getFullYear();
        var mm = String(now.getMonth() + 1).padStart(2, "0");
        var dd = String(now.getDate()).padStart(2, "0");
        var hh = String(now.getHours()).padStart(2, "0");
        var min = String(now.getMinutes()).padStart(2, "0");

        return yyyy + "-" + mm + "-" + dd + "T" + hh + ":" + min;
    }

    function getLoanRowData($row) {
        return {
            clientId: $.trim($row.find(".client").text()),
            dealNo: $.trim($row.find(".deal").text()),
            loanNo: $.trim($row.find(".loan").text()),
            recDate: $.trim($row.find(".recdate").text()),
            startDt: $row.find(".start-dt").val(),
            endDt: $row.find(".end-dt").val(),
            process: $.trim($row.find(".process").text()),
            uwname: $.trim($row.find(".uwname").text()),
            processid: $.trim($row.find(".processid").text())
        };
    }

    function syncFeedbackGlobals(data) {
        dealno_cons = data.dealNo;
        loanno_cons = data.loanNo;
        process_cons = data.processid;
        ProcessFeedbackID_1 = data.processid;
    }

    function completeOrder($row) {
        var data = getLoanRowData($row);

        syncFeedbackGlobals(data);

        if ($row.data("loan-saving")) {
            return false;
        }

        if (!window.PageMethods || !window.PageMethods.InsertModifyUWOrderOC22Servicing) {
            alert("Unable to complete loan. Page method is not available.");
            return false;
        }

        $row.data("loan-saving", true).addClass("loan-row-saving");
        setLoanBusyState(true);

        window.PageMethods.InsertModifyUWOrderOC22Servicing(
            data.clientId,
            data.dealNo,
            data.loanNo,
            data.process,
            data.uwname,
            data.startDt,
            data.endDt,
            us_completeLoan_OnSuccess,
            us_completeLoan_OnError
        );

        return false;
    }

    function clearLoanSavingState() {
        $(selectors.tbody + " tr.loan-row-saving").each(function () {
            $(this).removeData("loan-saving").removeClass("loan-row-saving");
        });

        setLoanBusyState(false);
    }

    function us_completeLoan_OnSuccess(result) {
        clearLoanSavingState();

        if (result > 0) {
            $(selectors.completeModal).modal("show");
            return false;
        }

        alert("Oops! Error occured while completing loan. Please contact administrator");
        return false;
    }

    function us_completeLoan_OnError(error) {
        clearLoanSavingState();
        alert(error.responseText || "Unable to complete loan. Please contact administrator.");
    }

    function us_redirectAddFeedback_1() {
        var payload = {
            ln: loanno_cons,
            dn: dealno_cons,
            tp: process_cons
        };
        var encoded = btoa(unescape(encodeURIComponent(JSON.stringify(payload))));

        window.location.href = "FeedbackDetails.aspx?data=" + encodeURIComponent(encoded);
    }

    function bindLoanDetailsEvents() {
        $(selectors.refreshButton)
            .off("click.loanDetails")
            .on("click.loanDetails", BindUSLoanDetails_Grid);

        $(document)
            .off("focus.loanDetails", ".end-dt")
            .on("focus.loanDetails", ".end-dt", function () {
                var $row = $(this).closest("tr");

                if (!$row.find(".start-dt").val()) {
                    alert("Select Start Date & Time first");
                    $row.find(".start-dt").focus();
                }
            })
            .off("change.loanDetails", ".start-dt")
            .on("change.loanDetails", ".start-dt", function () {
                handleStartDateChange($(this));
            })
            .off("change.loanDetails", ".end-dt")
            .on("change.loanDetails", ".end-dt", function () {
                handleEndDateChange($(this));
            });
    }

    function initLoanDetailsPage() {
        if (!$(selectors.table).length) {
            return;
        }

        bindLoanDetailsEvents();
        BindUSLoanDetails_Grid();
    }

    window.blankForNull = blankForNull;
    window.htmlForCell = htmlForCell;
    window.idForCell = idForCell;
    window.getUSLoanLoader = getUSLoanLoader;
    window.showUSLoanLoader = showUSLoanLoader;
    window.hideUSLoanLoader = hideUSLoanLoader;
    window.updateUSLoanDetailsCount = updateUSLoanDetailsCount;
    window.refreshUSLoanDateInputs = refreshUSLoanDateInputs;
    window.BindUSLoanDetails_Grid = BindUSLoanDetails_Grid;
    window.complete_Loan = complete_Loan;
    window.completeLoan_OnSuccess = completeLoan_OnSuccess;
    window.completeLoan_OnError = completeLoan_OnError;
    window.us_redirectAddFeedback = us_redirectAddFeedback;
    window.handleStartDateChange = handleStartDateChange;
    window.handleEndDateChange = handleEndDateChange;
    window.normalizeLoanDateInput = normalizeLoanDateInput;
    window.refreshLoanDateInputs = refreshLoanDateInputs;
    window.setLoanBusyState = setLoanBusyState;
    window.getNowForInput = getNowForInput;
    window.completeOrder = completeOrder;
    window.clearLoanSavingState = clearLoanSavingState;
    window.us_completeLoan_OnSuccess = us_completeLoan_OnSuccess;
    window.us_completeLoan_OnError = us_completeLoan_OnError;
    window.us_redirectAddFeedback_1 = us_redirectAddFeedback_1;

    $(initLoanDetailsPage);
})(window, jQuery);
