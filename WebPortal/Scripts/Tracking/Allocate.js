
console.log('Allocate');
var commaSeparatedSrNo;
var OrderAllocate_table = null;
var global_AlloccationID = 0;

/*---------------- Tab 1 - Order Allocation ----------------*/

var selectedRows = [];

function getOrderRowValue(row, keys) {
    row = row || {};

    for (var i = 0; i < keys.length; i++) {
        var value = row[keys[i]];

        if (value !== undefined && value !== null && $.trim(String(value)) !== '') {
            return $.trim(String(value));
        }
    }

    return '';
}

function escapeOrderHtml(value) {
    return $('<div></div>').text(value === undefined || value === null ? '' : String(value)).html();
}

function renderOrderText(value, emptyText) {
    var text = $.trim(value === undefined || value === null ? '' : String(value));

    if (!text) {
        return '<span class="alloc-table-empty">' + escapeOrderHtml(emptyText || '-') + '</span>';
    }

    return escapeOrderHtml(text);
}

function setOrderRowValue(row, keys, fallbackKey, value) {
    row = row || {};

    for (var i = 0; i < keys.length; i++) {
        if (Object.prototype.hasOwnProperty.call(row, keys[i])) {
            row[keys[i]] = value;
            return;
        }
    }

    row[fallbackKey] = value;
}

function getCompletedOrderDataTableRow(element) {
    var table = $('#table_OrderComplete').DataTable();
    var $tr = $(element).closest('tr');

    if ($tr.hasClass('child')) {
        $tr = $tr.prev();
    }

    return table.row($tr);
}

function allocate_bindProject() {

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetAllProjectByUser",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var ddl = $("#allocate_project");

            ddl.empty().append($("<option></option>").val("0").text("Select Project"));

            var data = response.d;

            if (typeof data === "string") {
                data = JSON.parse(data || "[]");
            }

            $.each(data, function (i, item) {
                ddl.append($("<option></option>").val(item.ProjectID).text(item.ProjectName));
            });
        },

        error: function (xhr) {
            console.log(xhr.responseText);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load project list."
            });
        }
    });

    return false;
}

function allocate_bindProcess(id) {

    var prjId = id.options[id.selectedIndex].value;

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
                ddl.append($("<option></option>").val(item.ProcessID).text(item.Process));
            });
        },
        error: function (xhr, status, error) {
            console.log(error);
            alert("Unable to load process list.");
        }
    });
}

function GetLoansToAllocate_bindGrid() {

    var processName = $.trim($("#allocate_process").val() || "");

    if (!processName) {
        Swal.fire({
            icon: "warning",
            title: "Validation Error",
            text: "Please select an Allocate Process.",
            confirmButtonText: "OK"
        }).then(function () {
            $("#allocate_process").focus();
        });

        return false;
    }

    $("#load1").show();

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetLoansToAllocate",
        data: JSON.stringify({
            ProcessName: processName,
            Type: "Allocation"
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            try {
                var dataArray = response.d;

                // WebMethod may return JSON as a string
                if (typeof dataArray === "string") {
                    dataArray = JSON.parse(dataArray || "[]");
                }

                // Ensure DataTables receives an array
                if (!Array.isArray(dataArray)) {
                    dataArray = [];
                }

                console.log("Loan allocation response:", dataArray);
                console.table(dataArray);

                if ($.fn.DataTable.isDataTable("#table_OrderAllocate")) {
                    $("#table_OrderAllocate").DataTable().clear().destroy();
                    $("#table_OrderAllocate tbody").empty();
                }

                OrderAllocate_table = $("#table_OrderAllocate").DataTable({
                    data: dataArray,
                    destroy: true,
                    dom: "ftip",
                    scrollX: true,
                    scrollCollapse: true,
                    paging: true,
                    autoWidth: false,
                    ordering: false,
                    processing: true,
                    language: {
                        emptyTable: "No loans available for allocation."
                    },

                    columns: [
                        {
                            data: null,
                            title: "Sr. No.",
                            render: function (data, type, row, meta) {
                                return meta.row + meta.settings._iDisplayStart + 1;
                            }
                        },
                        {
                            data: null,
                            title: "Select",
                            orderable: false,
                            searchable: false,
                            className: "text-center",
                            render: function () {
                                return '<input type="checkbox" class="loan-checkbox" />';
                            }
                        },
                        {
                            data: "ProjectName",
                            title: "Project",
                            defaultContent: "-"
                        },
                        {
                            data: "DealNo",
                            title: "Deal No",
                            defaultContent: "-"
                        },
                        {
                            data: "LoanNo",
                            title: "Loan No",
                            defaultContent: "-"
                        },
                        {
                            data: "Process",
                            title: "Process",
                            defaultContent: "-"
                        },
                        {
                            data: "CurrentStatus",
                            title: "Current Status",
                            defaultContent: "-"
                        },
                        {
                            data: "Remark",
                            title: "Remark",
                            defaultContent: "-"
                        }
                    ],

                    initComplete: function () {
                        $("#load1").hide();

                        if (typeof adjustAllocateDataTables === "function") {
                            adjustAllocateDataTables();
                        }
                    },

                    drawCallback: function () {
                        if (typeof adjustAllocateDataTables === "function") {
                            adjustAllocateDataTables();
                        }
                    }
                });

                if (dataArray.length > 0) {
                    $("html, body").animate({
                        scrollTop: $("#table_OrderAllocate").offset().top - 100
                    }, 300);
                }
            }
            catch (ex) {
                $("#load1").hide();

                console.error("Data binding error:", ex);
                console.error("Raw response:", response.d);

                Swal.fire({
                    icon: "error",
                    title: "Binding Error",
                    text: "The server returned data in an invalid format.",
                    confirmButtonText: "OK"
                });
            }

            $('#table_OrderAllocate tbody').off('change', '.loan-checkbox').on('change', '.loan-checkbox', function () {

                var checkedCount = $('#table_OrderAllocate tbody .loan-checkbox:checked').length;

                if (checkedCount > 2) {
                    $(this).prop('checked', false);

                    Swal.fire({
                        icon: 'warning',
                        title: 'Limit Exceeded',
                        text: 'You can select only 2 loans at a time.'
                    });
                }

                var srNoList = [];

                $('#table_OrderAllocate tbody .loan-checkbox:checked').each(function () {
                    var rowData = OrderAllocate_table.row($(this).closest('tr')).data();

                    if (rowData) {

                        srNoList.push(rowData.SrNo);   // database SrNo
                        //srNoList.push(OrderAllocate_table.row($(this).closest('tr')).index() + 1); // table SrNo
                    }
                });

                commaSeparatedSrNo = srNoList.join(',');

                console.log(commaSeparatedSrNo);
            });
        },

        error: function (xhr, status, error) {

            $("#load1").hide();

            console.error("Status:", status);
            console.error("Error:", error);
            console.error("Response:", xhr.responseText);

            Swal.fire({
                icon: "error",
                title: "Unable to Load Loans",
                text: "An error occurred while loading loan details.",
                confirmButtonText: "OK"
            });
        }
    });

    return false;
}

function AllocateOrders() {

    var project = $("#allocate_project").val();
    // var process = $("#allocate_process").val();

    var ddlp = document.getElementById("allocate_process");

    var processID = ddlp.value;
    var process = ddl.options[ddl.selectedIndex].text;

    var table = $('#table_OrderAllocate').DataTable();
    var selectedSrNo = [];

    $('#table_OrderAllocate tbody .loan-checkbox:checked').each(function () {

        var rowData = table.row($(this).closest('tr')).data();

        if (rowData && rowData.SrNo != null) {
            selectedSrNo.push(rowData.SrNo);
        }
    });

    if (selectedSrNo.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'Validation Error',
            text: 'Please select at least one loan.',
            confirmButtonText: 'OK'
        });
        return false;
    }

    // Example: "101,102"
    var commaSeparatedSrNo = selectedSrNo.join(',');

    Swal.fire({
        title: 'Are you sure?',
        text: 'Do you want to allocate ' + selectedSrNo.length + ' selected loan(s)?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, Allocate',
        cancelButtonText: 'Cancel'
    }).then(function (result) {

        if (!result.isConfirmed) {
            return;
        }

        $('#load1').show();

        $.ajax({
            type: "POST",
            url: "Allocate.aspx/AllocateOrders_Self",
            data: JSON.stringify({ Loans: commaSeparatedSrNo, Project: project, Process: process, ProcessID: processID }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (response) {

                $('#load1').hide();

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Selected loan(s) allocated successfully.',
                    confirmButtonText: 'OK'
                }).then(function () {
                    GetLoansToAllocate_bindGrid();
                });

                $("#sectrack_stat_deals").text(selectedSrNo.length);
            },

            error: function (xhr) {

                $('#load1').hide();

                console.error(xhr.responseText);

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Error while allocating selected loan(s).',
                    confirmButtonText: 'OK'
                });
            }
        });
    });

    return false;
}


/*---------------- Tab 2 - Order Status ----------------*/

function allocate_CompleteOrder_bindGrid() {

    $('#load1').show();

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/GetUserLoans",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var dataArray = [];

            try {
                dataArray = typeof response.d === "string"
                    ? JSON.parse(response.d || "[]")
                    : (response.d || []);
            }
            catch (e) {
                console.error("Invalid JSON response:", e);
                dataArray = [];
            }

            if ($.fn.DataTable.isDataTable('#table_OrderComplete')) {
                $('#table_OrderComplete').DataTable().clear().destroy();
            }

            $('#table_OrderComplete').DataTable({
                data: dataArray,
                destroy: true,
                paging: false,
                ordering: true,
                searching: true,
                autoWidth: false,
                scrollX: true,

                columns: [
                    {
                        data: null,
                        title: "Update Status",
                        orderable: false,
                        searchable: false,
                        className: "text-center action-column",
                        width: "65px",

                        render: function (data, type, row, meta) {

                            return `
            <button type="button"
                    class="alloc-icon-btn status-icon"
                    title="Update Status"
                    aria-label="Update Status"
                    onclick="openStatusPopup(${meta.row})">
                <i class="fas fa-edit"></i>
            </button>`;
                        }
                    },
                    {
                        data: "AllocationID",
                        title: "Add Feedback",
                        orderable: false,
                        searchable: false,
                        className: "text-center action-column",
                        width: "65px",

                        render: function (data, type, row) {

                            if (!row.PrevID || parseInt(row.PrevID, 10) === 0) {
                                return "";
                            }

                            if (!data) {
                                return "";
                            }

                            return `
                                <a href="AddFeedback.aspx?ProcessID=${encodeURIComponent(data)}"
                                   class="alloc-icon-btn feedback-icon"
                                   title="Add Feedback"
                                   aria-label="Add Feedback">
                                    <i class="fas fa-comment-dots"></i>
                                </a>`;
                        }
                    },

                    {
                        data: "ProjectName",
                        title: "Project",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "DealNo",
                        title: "Deal #",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "LoanNo",
                        title: "Loan #",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "Pstatus",
                        title: "Status",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "HoldReason",
                        title: "Hold Reason",
                        defaultContent: "-"
                    },
                    {
                        data: "Remark",
                        title: "Remark",
                        defaultContent: "-"
                    },
                    {
                        data: "AllocatedDate",
                        title: "Allocated Date",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "CompletedDate",
                        title: "Completion Date",
                        className: "text-nowrap",
                        defaultContent: "-"
                    },
                    {
                        data: "PrevID",
                        title: "PrevID",
                        visible: false,
                        searchable: false,
                        orderable: false,
                        defaultContent: "0"
                    }
                ],

                columnDefs: [
                    {
                        targets: [0, 1],
                        width: "65px"
                    }
                ],

                initComplete: function () {
                    $('#load1').hide();
                    this.api().columns.adjust();
                },

                drawCallback: function () {
                    $('#load1').hide();
                }
            });
        },

        error: function (xhr, status, error) {

            $('#load1').hide();

            console.error("Status:", status);
            console.error("Error:", error);
            console.error("Response:", xhr.responseText);

            Swal.fire({
                icon: "error",
                title: "Error",
                text: "Unable to load completed orders."
            });
        }
    });
}

function openStatusPopup(index) {

    var table = $('#table_OrderComplete').DataTable();

    // Get row data
    var row = table.row(index).data();

    console.log(row);

    // Bind values
    global_AlloccationID = row.AllocationID;
    $('#allocstatus_ctxProject').text(row.ProjectName || '-');
    $('#allocstatus_ctxDeal').text(row.DealNo || '-');
    $('#allocstatus_ctxLoan').text(row.LoanNo || '-');
    $('#allocstatus_ctxProcess').text(row.ProcessName || row.Process || '-');
    $('#loan_prevID').text(row.PrevID || '-');

    $('#popUp_updateOrderStatus').modal('show');
}

function onclick_allocstatus() {

    var status = $('#allocstatus_status').val() || '';
    var holdReason = $('#allocstatus_holdReason').val() || '';
    var remark = $('#allocstatus_remark').val() || '';

    if (!status) {
        Swal.fire('Validation', 'Please select Status.', 'warning');
        return;
    }

    if (status === 'Hold' && !holdReason) {
        Swal.fire('Validation', 'Hold Reason is mandatory when Status is Hold.', 'warning');
        return;
    }


    if (remark === '' || !status) {
        Swal.fire('Validation', 'Remark is mandatory.', 'warning');
        return;
    }

    $.ajax({
        type: "POST",
        url: "Allocate.aspx/UpdateLoanStatus",
        data: JSON.stringify({ AllocationID: global_AlloccationID, AllocationStatus: status, HoldReason: holdReason, Remark: remark }),
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
                    confirmButtonText: 'OK'
                }).then(function () {
                    resetFields();
                    $('#popUp_updateOrderStatus').modal('hide');
                    allocate_CompleteOrder_bindGrid();
                });

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

function resetFields() {
    global_AlloccationID = 0;
    $('#allocstatus_status,#allocstatus_holdReason').val('');
    $('#allocstatus_holdReason').prop('disabled', true);
    $('#allocstatus_remark').val('');
    $('#allocstatus_ctxProject,#allocstatus_ctxDeal,#allocstatus_ctxLoan,#allocstatus_ctxProcess').text('-');
}

function toggleHoldReason() {

    var isHold = $('#allocstatus_status').val() === 'Hold';

    $('#allocstatus_holdReason').prop('disabled', !isHold);

    if (!isHold) {
        $('#allocstatus_holdReason').val('');
    }
}


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
                destroy: true,
                data: dataArray,

                dom: 'ftip',
                paging: true,
                ordering: false,
                searching: true,
                processing: true,

                autoWidth: false,
                // scrollX: true,
                // scrollCollapse: true,
                // fixedHeader: true,

                columns: [
                    {
                        data: null,
                        width: "60px",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: "ProjectName", width: "120px" },
                    { data: "DealNo", width: "120px" },
                    { data: "OrderNumber", width: "120px" },
                    { data: "OrderStatus", width: "170px" },
                    { data: "Remark", width: "220px" },
                    { data: "Remark", width: "150px" },
                    { data: "StartDate", width: "150px" },
                    { data: "ProcessDate", width: "150px" },
                    { data: "TAT", width: "120px" }
                ],

                initComplete: function () {
                    $('#load1').hide();
                    this.api().columns.adjust();
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



