var selfleave_table;
var selfleave_empId;
var selfleave_branch;
var html;
var userID;



//Self Leave - START
function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function selfleave_bindgrid() {
    $('#load1').css('display', 'flex');

    $.ajax({
        url: "SelfLeaves.aspx/GetUserleavesbyCode",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d || "[]");

            var rows = dataArray.map(function (value) {
                return '<tr>' +
                    '<td>' + safeText(value.LeaveType) + '</td>' +
                    '<td>' + safeText(value.ForDays) + '</td>' +
                    '<td>' + safeText(value.LeaveFrom) + '</td>' +
                    '<td>' + safeText(value.LeaveTo) + '</td>' +
                    '<td>' + safeText(value.ReasonForLeave) + '</td>' +
                    '<td>' + safeText(value.AddedDate) + '</td>' +
                    '<td>' + safeText(value.Status) + '</td>' +
                    '<td>' + safeText(value.AddedByName) + '</td>' +
                    '<td>' + safeText(value.ApprovedDate) + '</td>' +
                    '<td>' + safeText(value.ApprovalRemark) + '</td>' +
                    '</tr>';
            }).join('');

            if ($.fn.dataTable.isDataTable('#selfleave_table')) {
                $('#selfleave_table').DataTable().clear().destroy();
            }

            $('#selfleave_table tbody').html(rows);

            selfleave_table = $('#selfleave_table').DataTable({
                dom: 'pBfti',
                scrollX: true,
                paging: true,
                autoWidth: true,
                processing: true,
                select: {
                    style: 'single'
                },
                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Leaves Details',
                        autoFilter: true,
                        exportOptions: {
                            columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
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
            alert('Error: ' + xhr.responseText);
        }
    });
}

function formatDotNetDate(dateValue) {
    if (!dateValue) return '';

    var match = /\/Date\((\d+)\)\//.exec(dateValue);
    if (!match) return '';

    return new Date(parseInt(match[1], 10)).toLocaleDateString("en-US");
}

function safeText(value) {
    if (value === null || value === undefined) return '';

    return $('<div>').text(value).html();
}

function selfleave_loadPaidEligibility(domain, workingBranch) {
    var eligible = String(domain) === "9" || String(workingBranch) === "11" || String(workingBranch) === "3";
    var details = document.getElementById("selfleave_paid_details");

    if (!details) return;

    details.classList.toggle("is-visible", eligible);

    if (!eligible) {
        return;
    }

    $.ajax({
        type: "POST",
        url: "SelfLeaves.aspx/GetLeaveDetails",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: "{}",
        success: function (res) {
            var leaveDetails = JSON.parse(res.d || "[]");
            if (leaveDetails.length === 0) return;

            var value = leaveDetails[0];
            document.getElementById("selfleave_totalleaves").textContent = blankForNull(value.TotalLeaves) || "0";
            document.getElementById("selfleave_appliedleaves").textContent = blankForNull(value.AppliedLeaves) || "0";
            document.getElementById("selfleave_pendingleaves").textContent = blankForNull(value.PendingLeaves) || "0";
        },
        error: function () {
            Swal.fire("Error", "Unable to load paid-leave balance.", "error");
        }
    });
}

function selfleave_validatedates() {

    var fromDate = $("#selfleave_fromdate").val();
    var days = parseInt($("#selfleave_days").val());

    if (days === 0) {
        $("#selfleave_todate").val("");
        return true;
    }

    if (fromDate && days) {

        var date = new Date(fromDate);

        // If 1 day leave, To Date = From Date
        // If 2 days leave, add 1 day, etc.
        date.setDate(date.getDate() + (days - 1));

        var toDate = date.toISOString().split("T")[0];

        $("#selfleave_todate").val(toDate);
    }

    return true;
}

function selfleave_Submit() {

    var selfleave_leavetype = $("#selfleave_leavetype").val();
    var selfleave_days = $("#selfleave_days").val();
    var selfleave_fromdate = $("#selfleave_fromdate").val();
    var selfleave_todate = $("#selfleave_todate").val();
    var selfleave_reason = $("#selfleave_reason").val().trim();
    var paidDetailsVisible = $("#selfleave_paid_details").hasClass("is-visible");
    var selfleave_paidstatus = paidDetailsVisible ? "Paid" : "Unpaid";

    if (selfleave_leavetype === "") {
        Swal.fire("Validation", "Please select leave type", "warning");
        return false;
    }

    if (selfleave_days === "" || selfleave_days === "0") {
        Swal.fire("Validation", "Please select days", "warning");
        return false;
    }

    if (selfleave_paidstatus === "Paid") {
        var pendingLeaves = parseFloat($("#selfleave_pendingleaves").text()) || 0;
        if (pendingLeaves < parseFloat(selfleave_days)) {
            Swal.fire("Insufficient Paid Leaves", "You do not have sufficient paid leaves for the selected duration.", "warning");
            return false;
        }
    }

    if (selfleave_fromdate === "") {
        Swal.fire("Validation", "Please select From date", "warning");
        return false;
    }

    if (selfleave_todate === "") {
        Swal.fire("Validation", "Please select To date", "warning");
        return false;
    }

    if (selfleave_reason === "") {
        Swal.fire("Validation", "Please enter reason", "warning");
        return false;
    }

    // $("#slefleave_waitingpanel").modal("show");

    Swal.fire({
        title: 'Please Wait',
        text: 'System is submitting leave request and sending email...',
        icon: 'info',
        allowOutsideClick: false,
        showConfirmButton: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    PageMethods.InsertLeave(
        selfleave_leavetype,
        selfleave_days,
        selfleave_fromdate,
        selfleave_todate,
        selfleave_reason,
        selfleave_paidstatus,
        function (result) {
            $("#slefleave_waitingpanel").modal("hide");

            if (result > 0) {
                Swal.fire({
                    title: "Success",
                    text: "Leave applied successfully!",
                    icon: "success"
                }).then(function () {
                    location.reload();
                });
            } else if (result === -2) {
                Swal.fire({
                    title: "Insufficient Paid Leaves",
                    text: "You do not have sufficient paid leaves for the selected duration.",
                    icon: "warning"
                });
            } else {
                Swal.fire({
                    title: "Already Exists",
                    text: "Leave already exists for the selected date.",
                    icon: "error"
                });
            }
        },
        function (error) {
            $("#slefleave_waitingpanel").modal("hide");

            Swal.fire({
                title: "Error",
                text: error.get_message ? error.get_message() : "Something went wrong.",
                icon: "error"
            });
        }
    );

    return false;
}

function selfleave_Message() {
    selfleave_bindgrid();
    document.getElementById("selfleave_leavetype").selectedIndex = 0;
    document.getElementById("selfleave_days").selectedIndex = 0;
    document.getElementById("selfleave_fromdate").value = '';
    document.getElementById("selfleave_todate").value = '';
    document.getElementById("selfleave_reason").value = '';
    $('#selfleave_dverror').modal('hide');
}

//Self Leave - END

/*------------ Leave Report ------------*/

function BindLeaveReport_Grid() {

    var l_FromDate = document.getElementById("leaveReport_FromDate").value;
    var l_ToDate = document.getElementById("leaveReport_ToDate").value;

    if (l_FromDate != "" && l_ToDate != "") {

        $('#load1').show();

        var title = "Leave Report_" + l_FromDate + "_" + l_ToDate;

        $.ajax({
            url: 'LeaveReport.aspx/GetLeaveReport',
            type: "POST",
            dataType: "json",
            data: "{FromDate:'" + l_FromDate + "',ToDate:'" + l_ToDate + "'}",
            contentType: "application/json; charset=utf-8",

            success: function (data) {

                var dataArray = JSON.parse(data.d);

                if ($.fn.DataTable.isDataTable('#table_leaveReport')) {
                    $('#table_leaveReport').DataTable().clear().destroy();
                }

                table = $('#table_leaveReport').DataTable({
                    dom: 'lBftp',
                    data: dataArray,
                    scrollX: true,
                    paging: true,
                    autoWidth: true,
                    processing: true,
                    ordering: false,
                    serverSide: false,

                    columns: [
                        {
                            data: null,
                            className: 'text-center',
                            orderable: false,
                            render: function (data, type, row, meta) {

                                var code = row.Code ? row.Code.replace(/'/g, "\\'") : "";
                                var name = row.FullName ? row.FullName.replace(/'/g, "\\'") : "";

                                return '<a href="#" class="dropdown-item fw-bold" ' +
                                    'onclick="view_leavedetails(\'' +
                                    code + '\',\'' +
                                    name + '\',\'' +
                                    l_FromDate + '\',\'' +
                                    l_ToDate + '\')">' +
                                    '<span style="color: #1e90ff;">' +
                                    '<i class="uil uil-search-plus"></i></span></a>';
                            }
                        },
                        { data: 'SrNo', className: 'text-center' },
                        { data: 'Code' },
                        { data: 'LeaveType' },
                        { data: 'ForDays' },
                        { data: 'LeaveFrom' },
                        { data: 'LeaveTo' },
                        { data: 'ReasonForLeave' },
                        /*{ data: 'LeaveStatus' },
                        { data: 'PaidStatus' },*/
                        { data: 'ApprovalRemark' },
                        { data: 'ApprovedByName' },
                        { data: 'ApprovedDate1' }
                    ],

                    initComplete: function () {

                        $('#load1').hide();
                    },

                    buttons: [
                        {
                            extend: 'excelHtml5', title: title,
                        },
                    ],
                });
            },

            error: function (error) {
                alert('Error: ' + error.responseText);
            }
        });
    }
    else {

        if (!FromDate) {
            alert("Please select From Date.");
            return false;
        }
        if (!ToDate) {
            alert("Please select To Date.");
            return false;
        }
    }
    return false;
}

function view_leavedetails(code, Name, fromdate, todate) {

    document.getElementById("leaveReport_empInfo").innerHTML = "Leave Details : " + code + " : " + Name + " _ " + fromdate + " To " + todate;

    $('#popUpViewLeaveDetails').modal('show');

    BindViewLeaveDetails_Grid();
}

function BindViewLeaveDetails_Grid() {

    var fromdate = document.getElementById("leaveReport_FromDate").value;
    var todate = document.getElementById("leaveReport_ToDate").value;

    //fromdate = "26-Dec-2024";
    //todate = "31-Dec-2025";
    $('#load1').show();

    $.ajax({
        url: 'LeaveReport.aspx/GetLeaveReport',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ FromDate: fromdate, ToDate: todate }),

        success: function (data) {

            var dataArray = typeof data.d === "string" ? JSON.parse(data.d) : data.d;

            if ($.fn.DataTable.isDataTable('#table_leaveDetails')) {
                $('#table_leaveDetails').DataTable().clear().destroy();
            }

            $('#table_leaveDetails').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [

                    {
                        data: null,
                        className: 'text-center',
                        orderable: false,
                        searchable: false,
                        width: "60px",
                        render: function (data, type, row, meta) {
                            /*  return meta.row + meta.settings._iDisplayStart + 1;*/

                            // For display in table
                            if (type === 'display') {
                                return meta.row + meta.settings._iDisplayStart + 1;
                            }

                            // For Excel export
                            return meta.row + 1;
                        }
                    },
                    { data: 'Code', width: "60px" },
                    { data: 'EmpName' },
                    { data: 'BranchName' },
                    { data: 'DepartmentName' },
                    { data: 'DesignationName' },
                    { data: 'DomainName' },
                    { data: 'ReportingManager' },
                    { data: 'LeaveType' },
                    { data: 'ForDays', className: 'text-center' },
                    { data: 'LeaveFrom' },
                    { data: 'LeaveTo' },
                    { data: 'LeaveStatus', className: 'text-center' },
                    { data: 'ActualDays', className: 'text-center' },
                    { data: 'PaidLeaves', className: 'text-center' },
                    { data: 'UnpaidLeaves', className: 'text-center' },
                    { data: 'ReasonForLeave', width: "400px" },
                    { data: 'ApprovalRemark' },
                    { data: 'ApprovedByName' },
                    { data: 'ApprovedDate1' }
                ],

                footerCallback: function (row, data, start, end, display) {

                    var api = this.api();

                    function intVal(i) {
                        return typeof i === 'string' ? parseFloat(i.replace(/[^0-9.-]/g, '')) || 0 : typeof i === 'number' ? i : 0;
                    }

                    var totalDays = 0;
                    var actualTotal = 0;
                    var paidTotal = 0;
                    var unpaidTotal = 0;

                    api.rows({ search: 'applied' }).every(function () {

                        var d = this.data();

                        totalDays += intVal(d.ForDays);
                        actualTotal += intVal(d.ActualDays);
                        paidTotal += intVal(d.PaidLeaves);
                        unpaidTotal += intVal(d.UnpaidLeaves);
                    });

                    // Set footer values (adjust index if needed)
                    $(api.column(9).footer()).html(totalDays);      // Days
                    $(api.column(13).footer()).html(actualTotal);  // Actual Days
                    $(api.column(14).footer()).html(paidTotal);    // Paid
                    $(api.column(15).footer()).html(unpaidTotal);  // Unpaid
                },

                initComplete: function () {

                    var api = this.api();

                    $('#table_leaveDetails thead tr.filters th').each(function (i) {

                        if (i === 0) return;

                        var input = $('input', this);

                        // Columns that need 60px width
                        var smallColumns = [1, 3, 4, 5, 7, 8, 9, 10];

                        if (smallColumns.includes(i)) {
                            input.css('width', '60px');
                        } else {
                            input.css('width', '100px');
                        }

                        input.on('keyup change', function () {
                            if (api.column(i).search() !== this.value) {
                                api.column(i).search(this.value).draw();
                            }
                        });

                    });

                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        footer: true,

                        exportOptions: {
                            columns: ':visible',
                            format: {
                                header: function (data, columnIdx) {
                                    return $('#table_leaveDetails thead th')
                                        .eq(columnIdx).text();
                                },
                                body: function (data, row, column, node) {
                                    if (column === 0) {
                                        return row + 1;
                                    }
                                    return data;
                                }
                            }
                        },

                        filename: function () {
                            // Get Code filter value
                            var code = $('#table_leaveDetails thead tr.filters th').eq(1).find('input').val() || "AllCodes";

                            // Get from and to dates
                            var fromdate = $('#leaveReport_FromDate').val() || "";
                            var todate = $('#leaveReport_ToDate').val() || "";

                            // Build filename
                            return 'Leave Report_' + code + '_' + fromdate + '_to_' + todate;
                        },

                        customize: function (xlsx) {

                            var sheet = xlsx.xl.worksheets['sheet1.xml'];

                            /* ===== STYLE HEADER ROW ===== */
                            $('row[r="2"] c', sheet).attr('s', '7');  // grey + bold

                            /* ===== CENTER ALIGN DATA ROWS ONLY ===== */
                            $('row', sheet).each(function () {

                                var rowIndex = parseInt($(this).attr('r'));

                                // Skip header row
                                if (rowIndex > 2) {

                                    $(this).find('c[r^="A"]').attr('s', '51'); // Sr. #
                                    $(this).find('c[r^="E"]').attr('s', '51'); // Days
                                    $(this).find('c[r^="J"]').attr('s', '51'); // Actual Days
                                    $(this).find('c[r^="K"]').attr('s', '51'); // Paid
                                    $(this).find('c[r^="L"]').attr('s', '51'); // Unpaid
                                }
                            });

                            /* ===== STYLE FOOTER ROW ===== */
                            var lastRow = $('row', sheet).last().attr('r');
                            $('row[r="' + lastRow + '"] c', sheet).attr('s', '22'); // light blue
                        }
                    }
                ],
            });
        },

        error: function (error) {
            alert('Error: ' + error.responseText);
        }
    });

    return false;
}


