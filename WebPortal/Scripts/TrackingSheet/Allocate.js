

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
    UserName = 'VPC';

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
                    { data: "ProjectStatus" },
                    { data: "DomainName" },
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
                        data: "Remark",
                        render: function (data, type, row) {
                            return `<textarea class="form-control Remark" style="min-width:400px;">${data || ""}</textarea>`;
                        }
                    },
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
                    },
                    { data: "AddedByName" }
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