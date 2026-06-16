var ProcessFeedbackID = 0;
var USLoanDetails_html = "";

function BindUSLoanDetails_Grid() {
    $.ajax({
        url: "LoanDetails.aspx/GetLoanDetails_RemoteUW_REQC",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            let dataArray = [];

            try {
                dataArray = JSON.parse(data.d || "[]");
            } catch (e) {
                alert("Error reading loan details. Please contact administrator.");
                return;
            }

            console.log("Loan Data:", dataArray);

            if ($.fn.DataTable.isDataTable("#table_USLoanDetails")) {
                $("#table_USLoanDetails").DataTable().clear().destroy();
            }

            $("#table_USLoanDetails tbody").empty();

            USLoanDetails_table = $("#table_USLoanDetails").DataTable({
                destroy: true,
                data: dataArray,

                columns: [
                    // {
                    //     data: null,
                    //     visible: false,
                    //     className: "loan-hidden text-center",
                    //     defaultContent: "",
                    //     render: function (data, type, row, meta) {
                    //         const processId = parseInt(blankForNull(row.ProcessID), 10) || 0;

                    //         return `
                    //             <a title="Complete Loan" class="dropdown-item" href="#!"
                    //                onclick="complete_Loan(${processId}, ${meta.row});">
                    //                 <span class="text-success">
                    //                     <i class="uil uil-stop-circle" style="font-size:16px;"></i>
                    //                 </span>
                    //             </a>`;
                    //     }
                    // },
                    // {
                    //     data: "ProcessID",
                    //     className: "loan-time-cell",
                    //     defaultContent: "",
                    //     render: function (data) {
                    //         return `<input type="text"
                    //             id="us_add_date_start_${idForCell(data)}"
                    //             class="start-dt form-control form-control-sm loan-date-input"
                    //             placeholder="Select date & time"
                    //             autocomplete="off" />`;
                    //     }
                    // },
                    // {
                    //     data: "ProcessID",
                    //     className: "loan-time-cell",
                    //     defaultContent: "",
                    //     render: function (data) {
                    //         return `<input type="text"
                    //             id="us_add_date_end_${idForCell(data)}"
                    //             class="end-dt form-control form-control-sm loan-date-input"
                    //             placeholder="Select date & time"
                    //             autocomplete="off"
                    //             disabled />`;
                    //     }
                    // },

                    {
                        data: null,
                        className: "loan-hidden text-center",
                        visible: false,
                        defaultContent: "",
                        render: function (data, type, row, meta) {

                            var processIdForAction =
                                parseInt(blankForNull(row.ProcessID), 10) || 0;

                            return `
            <a title="Complete Loan"
               class="dropdown-item"
               href="#!"
               id="Actions"
               onclick="complete_Loan(${processIdForAction}, ${meta.row});">
                <span class="text-success">
                    <i class="uil uil-stop-circle" style="font-size:16px;"></i>
                </span>
            </a>`;
                        }
                    },

                    {
                        data: "ProcessID",
                        className: "loan-time-cell",
                        defaultContent: "",
                        render: function (data) {

                            var processId = idForCell(data);

                            return `
            <input type="datetime-local"
                   id="us_add_date_start_${processId}"
                   class="start-dt form-control form-control-sm loan-date-input"
                   autocomplete="off" />
        `;
                        }
                    },
                    {
                        data: "ProcessID",
                        className: "loan-time-cell",
                        defaultContent: "",
                        render: function (data) {

                            var processId = idForCell(data);

                            return `
            <input type="datetime-local"
                   id="us_add_date_end_${processId}"
                   class="end-dt form-control form-control-sm loan-date-input"
                   autocomplete="off" disabled
                  />
        `;
                        }
                    },

                    {
                        data: "ProcessID1",
                        visible: false,
                        className: "processid loan-hidden",
                        defaultContent: "",
                        render: function (data) {
                            return htmlForCell(data);
                        }
                    },
                    { data: "ProjectNo", className: "client", defaultContent: "", render: htmlForCell },
                    { data: "DealNo", className: "deal", defaultContent: "", render: htmlForCell },
                    { data: "LoanNo", className: "loan", defaultContent: "", render: htmlForCell },
                    { data: "OrderDate", className: "recdate", defaultContent: "", render: htmlForCell },
                    { data: "Process", className: "process", defaultContent: "", render: htmlForCell },
                    {
                        data: "RemoteUW",
                        visible: false,
                        className: "uwname loan-hidden",
                        defaultContent: "",
                        render: htmlForCell
                    },
                    {
                        data: "ProcessDate",
                        visible: false,
                        className: "loan-hidden",
                        defaultContent: "",
                        render: htmlForCell
                    }
                ],

                dom: '<"row mb-2"<"col-sm-12 col-md-5"l><"col-sm-12 col-md-7"f>>rt<"row mt-2"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
                scrollX: true,
                paging: true,
                pageLength: 10,
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
                autoWidth: false,
                ordering: false,
                processing: true,
                select: {
                    style: "single"
                },
                language: {
                    search: "",
                    searchPlaceholder: "Search tasks..."
                },

                createdRow: function (row) {
                    $(row).addClass("loan-task-row");
                },

                drawCallback: function () {
                    refreshUSLoanDateInputs();
                    bindUSLoanDateTimeValidation();
                },

                initComplete: function () {
                    // updateUSLoanDetailsCount(dataArray.length);
                    bindUSLoanDateTimeValidation();
                    refreshUSLoanDateInputs();
                }
            });
        },

        error: function (error) {
            alert("Error loading loan details. " + (error.responseText || "Please contact administrator."));
        }
    });

    return false;
}

function bindUSLoanDateTimeValidation() {

    $(document)
        .off("change", ".start-dt")
        .on("change", ".start-dt", function () {

            var $row = $(this).closest("tr");
            var startValue = $(this).val();
            var $endInput = $row.find(".end-dt");

            $endInput.val("");

            if (!startValue) {
                $endInput.prop("disabled", true);
                $endInput.removeAttr("min");
                return;
            }

            $endInput.prop("disabled", false);
            $endInput.attr("min", startValue);
        });

    $(document)
        .off("change", ".end-dt")
        .on("change", ".end-dt", function () {

            var $row = $(this).closest("tr");
            var startValue = $row.find(".start-dt").val();
            var endValue = $(this).val();

            if (!startValue) {
                $(this).val("").prop("disabled", true);

                Swal.fire({
                    icon: "warning",
                    title: "Start Time Required",
                    text: "Please select Start Date/Time first."
                });

                return;
            }

            if (endValue && new Date(endValue) <= new Date(startValue)) {
                $(this).val("");

                Swal.fire({
                    icon: "warning",
                    title: "Invalid Time",
                    text: "End Date/Time must be greater than Start Date/Time."
                });
            }
        });
}                                                                                  

function complete_Loan(ProcessID, index) {

    ProcessFeedbackID = ProcessID;

    if (!USLoanDetails_table) {
        return false;
    }

    var rowNode = USLoanDetails_table.row(index).node();
    var $row = $(rowNode);

    // if (typeof handleEndDateChange === 'function') {
    //     return handleEndDateChange($row.find('.end-dt'));
    // }

    if (typeof completeOrder === 'function') {
        return completeOrder($row);
    }

    return false;
}

function completeOrder($row) {
    const table = $("#table_USLoanDetails").DataTable();

    const data = {
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

    dealno_cons = data.dealNo;
    loanno_cons = data.loanNo;
    process_cons = data.processid;
    ProcessFeedbackID_1 = data.processid;

    const startTime = data.startDt;
    const endTime = data.endDt;

    if (!startTime) {
        Swal.fire({
            icon: "warning",
            title: "Start Time Required",
            text: "Please select Start Date/Time."
        });
        return false;
    }

    if (!endTime) {
        Swal.fire({
            icon: "warning",
            title: "End Time Required",
            text: "Please select End Date/Time."
        });
        return false;
    }

    // Swal.fire({
    //     title: "Complete Loan?",
    //     text: "Are you sure you want to complete this loan?",
    //     icon: "question",
    //     showCancelButton: true,
    //     confirmButtonColor: "#28a745",
    //     cancelButtonColor: "#dc3545",
    //     confirmButtonText: "Yes, Complete"
    // }).then(function (result) {
    //     if (!result.isConfirmed) return;

    //     Swal.fire({
    //         title: "Processing...",
    //         allowOutsideClick: false,
    //         didOpen: function () {
    //             Swal.showLoading();
    //         }
    //     });

    $.ajax({
        url: "LoanDetails.aspx/InsertModifyUWOrderOC22Servicing",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            ProjectNumber: data.clientId || "",
            DealNo: data.dealNo || "",
            OrderNumber: data.loanNo || "",
            Process: data.process || "",
            Review: data.uwname || "",
            StartTime: startTime,
            EndTime: endTime
        }),

        success: function (response) {
            const resultValue = parseInt(response.d, 10) || 0;

            if (resultValue > 0) {
                table.row($row).remove().draw(false);

                Swal.fire({
                    icon: "success",
                    title: "Completed",
                    text: "Loan completed successfully.",
                    timer: 2000,
                    showConfirmButton: false
                });
                $('#us_completeLoan').modal('show');
                // updateUSLoanDetailsCount(table.rows().count());
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Failed",
                    text: "Loan completion failed."
                });
            }
        },

        error: function (xhr) {
            Swal.fire({
                icon: "error",
                title: "Error",
                text: xhr.responseText || "Something went wrong. Please contact administrator."
            });
        }
    });

    // });

    return false;
}

function refreshUSLoanDateInputs() {
    $(".loan-date-input").each(function () {
        if (this._flatpickr) return;

        flatpickr(this, {
            enableTime: true,
            dateFormat: "d-m-Y h:i K",
            time_24hr: false,
            minuteIncrement: 1,
            allowInput: true,
            disableMobile: true,

            onReady: function (selectedDates, dateStr, instance) {
                addFlatpickrOkButton(instance);
            }
        });
    });
}

function addFlatpickrOkButton(instance) {

    if (instance.calendarContainer.querySelector(".flatpickr-confirm")) return;

    const okBtn = document.createElement("button");
    okBtn.type = "button";
    okBtn.className = "flatpickr-confirm";
    okBtn.textContent = "OK";

    okBtn.addEventListener("click", function () {
        instance.close();
    });

    instance.calendarContainer.appendChild(okBtn);
}


function htmlForCell(value) {
    if (value === null || value === undefined || value === "") {
        return "";
    }

    return $("<div>").text(value).html();
}

function blankForNull(value) {
    return value === null || value === undefined ? "" : value;
}

function idForCell(value) {
    return String(blankForNull(value)).replace(/[^a-zA-Z0-9_-]/g, "");
}


// function refreshUSLoanDateInputs() {
//     $(".loan-date-input").each(function () {
//         if (this._flatpickr) return;

//         flatpickr(this, {
//             enableTime: true,
//             dateFormat: "d-m-Y h:i K",
//             time_24hr: false,
//             minuteIncrement: 1,
//             allowInput: true,
//             disableMobile: true
//         });
//     });
// }



function core_handleStartDateChange($input) {
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

function core_handleEndDateChange($input) {
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

function core_normalizeLoanDateInput($input) {
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

