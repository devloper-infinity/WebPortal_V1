var global_LeaveID = 0;
var global_code = '';


/*-------------- Employee Leaves --------------*/

function empleave_bindemployee() {
    var select = document.getElementById("empleave_user");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#empleave_user").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "EmployeeLeaves.aspx/BindUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                $("#empleave_user").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.NAME));
            })
        }
    });
}

function empleave_bindgrid() {

    $('#load1').show();

    $.ajax({
        url: "UserLeaves.aspx/BindUserLeaves",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            // Current Date
            var tdate = new Date();
            tdate.setHours(0, 0, 0, 0);

            // destroy only if exists
            if ($.fn.DataTable.isDataTable('#empleaves_table')) {

                empleaves_table.clear().destroy();
                $('#empleaves_table tbody').empty();
            }

            empleaves_table = $('#empleaves_table').DataTable({

                data: dataArray,

                deferRender: true,
                scrollX: true,
                processing: true,
                paging: true,
                autoWidth: false,
                ordering: false,

                select: {
                    style: 'single'
                },

                dom: 'pBfti',

                columns: [

                    {
                        data: null,

                        render: function (data, type, row, meta) {

                            // LeaveTo Date
                            var leaveToDate = new Date(row.LeaveTo);
                            leaveToDate.setHours(0, 0, 0, 0);

                            // Expired Check
                            var isExpired = leaveToDate < tdate;

                            // Approve Button
                            var approveBtn = isExpired
                                ? `<a class="dropdown-item expired-btn"
                                        href="javascript:void(0);"
                                        data-msg="Leave period already completed. Approval action disabled.">

                                        <span style="color:gray;">
                                            <i class="uil fs-0 me-2 uil-pen"></i>
                                        </span>

                                        Approve/ Reject
                                   </a>`

                                : `<a class="dropdown-item approve-btn"
                                        href="javascript:void(0);"
                                        data-id="${row.LeaveId}"
                                        data-index="${meta.row}">

                                        <span style="color:forestgreen;">
                                            <i class="uil fs-0 me-2 uil-pen"></i>
                                        </span>

                                        Approve/ Reject
                                   </a>`;

                            // Extend Button
                            var extendBtn = isExpired
                                ? `<a class="dropdown-item expired-btn"
                                        href="javascript:void(0);"
                                        data-msg="Cannot extend or shorten completed leave.">

                                        <span style="color:gray;">
                                            <i class="uil fs-0 me-2 uil-file"></i>
                                        </span>

                                        Extend/ Shorten
                                   </a>`

                                : `<a class="dropdown-item extend-btn"
                                        href="javascript:void(0);"
                                        data-id="${row.LeaveId}"
                                        data-index="${meta.row}">

                                        <span style="color:dodgerblue;">
                                            <i class="uil fs-0 me-2 uil-file"></i>
                                        </span>

                                        Extend/ Shorten
                                   </a>`;

                            // Cancel Button
                            var cancelBtn = isExpired
                                ? `<a class="dropdown-item expired-btn"
                                        href="javascript:void(0);"
                                        data-msg="Cannot cancel completed leave.">

                                        <span style="color:gray;">
                                            <i class="uil fs-0 me-2 uil-x"></i>
                                        </span>

                                        Cancel Leave
                                   </a>`

                                : `<a class="dropdown-item text-danger cancel-btn"
                                        href="javascript:void(0);"
                                        data-id="${row.LeaveId}"
                                        data-index="${meta.row}">

                                        <i class="uil fs-0 me-2 uil-x"></i>

                                        Cancel Leave
                                   </a>`;

                            return `

                                <div class="btn-group">

                                    <div data-toggle="dropdown">

                                        <i style="color:dodgerblue;font-size:14px;"
                                           class="uil fs-0 me-2 uil-cog"></i>

                                    </div>

                                    <div class="dropdown-menu">

                                        ${approveBtn}

                                        ${extendBtn}

                                        <div class="dropdown-divider"></div>

                                        ${cancelBtn}

                                    </div>

                                </div>
                            `;
                        }
                    },

                    { data: 'Code1', defaultContent: '' },
                    { data: 'LeaveType', defaultContent: '' },
                    { data: 'ForDays', defaultContent: '' },
                    { data: 'LeaveFrom', defaultContent: '' },
                    { data: 'LeaveTo', defaultContent: '' },
                    { data: 'Status', defaultContent: '' },
                    { data: 'ReasonForLeave', defaultContent: '' },
                    { data: 'UpdatedByName', defaultContent: '' },
                    { data: 'ApprovedDate1', defaultContent: '' },
                    { data: 'ApprovalRemark', defaultContent: '' },
                    { data: 'Eligible', defaultContent: '', visible: false }
                ],

                buttons: [

                    {
                        extend: 'excelHtml5',
                        title: 'User Leaves',
                        className: 'btn btn-datatable'
                    },

                    {
                        extend: 'pdfHtml5',
                        orientation: 'landscape',
                        title: 'User Leaves',
                        className: 'btn btn-datatable'
                    }
                ],

                initComplete: function () {

                    $('#load1').hide();
                }
            });

            // Approve
            $('#empleaves_table').off('click', '.approve-btn')
                .on('click', '.approve-btn', function () {

                    EditAction(
                        $(this).data('id'),
                        $(this).data('index')
                    );
                });

            // Extend
            $('#empleaves_table').off('click', '.extend-btn')
                .on('click', '.extend-btn', function () {

                    ExtendAction(
                        $(this).data('id'),
                        $(this).data('index')
                    );
                });

            // Cancel
            $('#empleaves_table').off('click', '.cancel-btn')
                .on('click', '.cancel-btn', function () {

                    CancelLeave(
                        $(this).data('id'),
                        $(this).data('index')
                    );
                });

            // Expired Action
            $('#empleaves_table').off('click', '.expired-btn')
                .on('click', '.expired-btn', function () {

                    alert($(this).data('msg'));
                });
        },

        error: function (error) {

            $('#load1').hide();

            console.log(error);

            alert(error.responseText);
        }
    });
}

function EditAction(LeaveID, index) {

    global_LeaveID = LeaveID;

    // Get selected row object
    var row = empleaves_table.row(index).data();

    console.log(row);

    if (!row) {
        alert('Unable to fetch row data');
        return;
    }

    // Store values
    userID = row.LeaveId;

    var status = row.Status;

    document.getElementById("leave_username").innerText = "Approve/Reject Leave - " + row.Code1;
    
    // Bind data to controls
    $('#empleave_approve_code').val(row.Code1 || '');

    $('#empleave_approve_leavetype').val(row.LeaveType || '');

    $('#empleave_approve_fordays').val(row.ForDays || '');

    $('#empleave_approve_daterange').val(
        (row.ForDays || 0) +
        ' day(s) From ' +
        (row.LeaveFrom || '') +
        ' to ' +
        (row.LeaveTo || '')
    );

    $('#empleave_approve_reason').val(row.ReasonForLeave || '');

    // Show / Hide Leave Status Section
    if (row.Eligible === "Eligible") {

        $('#leavestatus').show();
        $('#leavestatusrow').show();

    } else {

        $('#leavestatus').hide();
        $('#leavestatusrow').hide();
    }

    // Open modal only for pending leave
    if (status === "Pending") {

        $('#empleave_approvalrejection').modal('show');

    } else {

        alert('Leave is already ' + status);
    }
}

function ExtendAction(LeaveID, index) {

    global_LeaveID = LeaveID

    // Get selected row data object
    var row = empleaves_table.row(index).data();

    console.log(row);

    if (!row) {
        alert('Unable to fetch row data');
        return;
    }

    // Store User ID
    userID = row.LeaveId;

    var status = row.Status;
    document.getElementById("empleave_extend_username").innerText = "Extend/Reject Leave - " + row.Code1;
    
    // Bind values
    $('#empleave_extend_code').val(row.Code1 || '');

    $('#empleave_extend_lavetype').val(row.LeaveType || '');

    $('#empleave_extend_days_hidden').html(row.ForDays || 0);

    $('#empleave_extend_fromdate').val(row.LeaveFrom || '');

    $('#empleave_extend_todate').val(row.LeaveTo || '');

    $('#empleave_extend_reason').val(row.ReasonForLeave || '');

    // Reset dropdown
    $('#empleave_extend_ddaction').empty();

    // Add dropdown options
    $('#empleave_extend_ddaction').append(
        $("<option></option>").val("").html("Select")
    );

    $('#empleave_extend_ddaction').append(
        $("<option></option>").val("Extend").html("Extend")
    );

    $('#empleave_extend_ddaction').append(
        $("<option></option>").val("Shorten").html("Shorten")
    );

    // Open modal only if leave is approved
    if (status === "Approved") {

        $('#empleave_leaveentendshorten').modal('show');

    } else {

        alert('Leave is not approved.');
    }
}

function CancelLeave(LeaveID, index) {

    // Get selected row object
    var row = empleaves_table.row(index).data();

    console.log(row);

    if (!row) {
        alert('Unable to fetch row data');
        return;
    }

    // Store Leave ID
    userID = row.LeaveId;

    var status = row.Status;

    // Bind values
    $('#empleave_extend_code').val(row.Code1 || '');

    $('#empleave_extend_lavetype').val(row.LeaveType || '');

    $('#empleave_extend_days_hidden').html(row.ForDays || 0);

    $('#empleave_extend_fromdate').val(row.LeaveFrom || '');

    $('#empleave_extend_todate').val(row.LeaveTo || '');

    $('#empleave_extend_reason').val(row.ReasonForLeave || '');

    // Reset dropdown
    $('#empleave_extend_ddaction').empty();

    // Add Cancel option
    $('#empleave_extend_ddaction').append(
        $("<option></option>").val("").html("Select")
    );

    $('#empleave_extend_ddaction').append(
        $("<option></option>").val("Cancel").html("Cancel")
    );

    // Open modal only if leave is approved
    if (status === "Approved") {

        $('#empleave_leaveentendshorten').modal('show');

    } else {

        alert('Leave is not approved');
    }
}


/* Submit Functions*/

function empleave_submit() {

    const code = document.getElementById("empleave_user").value;
    const type = document.getElementById("empleave_informtype").value;

    const fromdate = document.getElementById("empleave_fromdate").value;
    const todate = document.getElementById("empleave_todate").value;

    const daysDropdown = document.getElementById("empleave_days");
    const noofdays = parseInt(daysDropdown.options[daysDropdown.selectedIndex].text, 10);

    const paidDropdown = document.getElementById("empleave_paidunpaid");
    const paidstatus = paidDropdown.options[paidDropdown.selectedIndex].text;

    const remark = document.getElementById("empleave_reason").value.trim();

    // Mandatory field validation
    if (
        !code ||
        !type ||
        !fromdate ||
        !todate ||
        !noofdays ||
        !paidstatus ||
        !remark
    ) {

        Swal.fire({
            icon: 'warning',
            title: 'Mandatory Fields',
            text: 'All fields are mandatory.'
        });

        return false;
    }

    // Validate paid leaves
    if (paidstatus === "Paid") {

        const currentPendingLeave = parseInt(document.getElementById("empleave_pendingleaves").innerHTML, 10);

        if (currentPendingLeave < noofdays) {

            Swal.fire({
                icon: 'warning',
                title: 'Insufficient Paid Leaves',
                text: 'Selected employee does not have sufficient paid leaves.'
            });

            return false;
        }
    }

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
        code,
        noofdays,
        fromdate,
        todate,
        remark,
        type,
        paidstatus,

        // Success Callback
        function (response) {

            Swal.close();

            if (parseInt(response) > 0) {

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: 'Leave request submitted successfully.',
                    confirmButtonText: 'OK'
                }).then((result) => {

                    if (result.isConfirmed) {

                        empleave_bindgrid();
                    }
                });

            } else {

                Swal.fire({
                    icon: 'error',
                    title: 'Failed',
                    text: 'Unable to submit leave request.'
                });
            }
        },

        // Error Callback
        function (error) {

            Swal.close();

            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: error.get_message
                    ? error.get_message()
                    : 'Something went wrong.'
            });
        }
    );

    return false;
}

function empleave_approve_SubmitAction() {

    const code = document.getElementById('empleave_approve_code').value.substring(0, 3);
    const leaveStatus = document.getElementById('empleave_approve_leavestatus');
    const actionDD = document.getElementById('empleave_approve_ddaction');
    const comments = document.getElementById('empleave_approve_comments');
    const forDays = parseFloat(document.getElementById("empleave_approve_fordays").value);

    const approveReject = actionDD.options[actionDD.selectedIndex].text;
    const paidUnpaid = leaveStatus.options[leaveStatus.selectedIndex].text;

    // Validate Leave Status
    if (document.getElementById("leavestatus").style.display === '' && leaveStatus.selectedIndex === 0) {

        Swal.fire({ icon: 'warning', title: 'Mandatory', text: 'Leave status is mandatory' });
        leaveStatus.focus();
        return false;
    }

    // Common Validation
    function validateForm() {

        // Action Mandatory
        if (actionDD.selectedIndex === 0) {

            Swal.fire({ icon: 'warning', title: 'Mandatory', text: 'Action is mandatory' });
            actionDD.focus();
            return false;
        }

        // Comments Mandatory
        if (comments.value.trim() === '') {

            Swal.fire({ icon: 'warning', title: 'Mandatory', text: 'Comments are mandatory' });
            comments.focus();
            return false;
        }

        // Minimum Length
        if (comments.value.trim().length < 10) {

            Swal.fire({ icon: 'warning', title: 'Validation', text: 'Comments should be at least 10 characters long' });
            comments.focus();
            return false;
        }

        return true;
    }

    // If status = Paid Leave
    if (leaveStatus.selectedIndex === 1) {

        $.ajax({
            type: "POST",
            url: "EmployeeLeaves.aspx/getPendingLeaveCount",
            data: JSON.stringify({ Code: code }),
            dataType: "json",
            contentType: "application/json; charset=utf-8",

            success: function (msg) {

                if (forDays <= parseFloat(msg.d)) {

                    if (validateForm()) {

                        approverejectleave(global_LeaveID, code, approveReject, paidUnpaid, comments.value.trim());
                    }

                } else {

                    Swal.fire({ icon: 'warning', title: 'Insufficient Leave Balance', text: 'Applied leave count is greater than actual pending leaves. Please change status to Unpaid.' });
                }
            },

            error: function () {

                Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to fetch pending leave count' });
            }
        });

    } else {

        if (validateForm()) {

            approverejectleave(global_LeaveID, code, approveReject, paidUnpaid, comments.value.trim());
        }
    }

    return false;
}

function approverejectleave(leaveid, code, status, paidstatus, comment) {

    Swal.fire({
        title: 'Please Wait',
        text: 'System is processing leave request and sending email...',
        icon: 'info',
        allowOutsideClick: false,
        showConfirmButton: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    PageMethods.UpdateLeaveStatus(leaveid, code, status, paidstatus, comment,

        function (result) {

            Swal.close();

            if (parseInt(result) > 0) {

                $('#empleave_approvalrejection').modal('hide');

                Swal.fire({
                    icon: 'success', title: 'Success', text: 'Leave has been ' + status + 'ed successfully', confirmButtonText: 'OK'
                }).then((res) => {

                    if (res.isConfirmed) {

                        // bind grid
                        global_LeaveID = 0;

                        document.getElementById('empleave_approve_leavestatus').selectedIndex = 0;
                        document.getElementById('empleave_approve_ddaction').selectedIndex = 0;
                        document.getElementById('empleave_approve_comments').value = '';

                        empleave_bindgrid()();
                    }
                });

            } else {

                Swal.fire({ icon: 'error', title: 'Failed', text: 'No record was updated' });
            }
        },

        function () {

            Swal.close();

            Swal.fire({ icon: 'error', title: 'Error', text: 'Something went wrong while processing request' });
        }
    );
}

function empleave_extend_submit() {

    const code = document.getElementById('empleave_extend_code').value.substring(0, 3);
    const dd = document.getElementById('empleave_extend_ddaction');
    const textarea = document.getElementById('empleave_extend_comments');
    const fromdate = document.getElementById("empleave_extend_fromdate").value;
    const todate = document.getElementById("empleave_extend_todate").value;
    const daysDD = document.getElementById('empleave_extend_days');

    const LeaveID = userID;
    const status = dd.options[dd.selectedIndex].text;
    const valdays = daysDD.options[daysDD.selectedIndex].text;
    const comment = textarea.value.trim();

    // SweetAlert helper
    const showMsg = (icon, text) => {
        Swal.fire({ icon: icon, title: 'Validation', text: text });
    };

    // Validation
    if (dd.selectedIndex === 0) {
        showMsg('warning', 'Please select proper action.');
        dd.focus();
        return false;
    }

    if (comment.length < 10) {
        showMsg('warning', 'Comments should be more than 10 characters long.');
        textarea.focus();
        return false;
    }

    Swal.fire({
        title: 'Processing...', text: 'Please wait while updating leave extension',
        allowOutsideClick: false,
        showConfirmButton: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });

    PageMethods.ExtendShortenLeaves(LeaveID, code, status, fromdate, todate, valdays, comment,
        function (result) {

            Swal.close();

            if (parseInt(result) > 0) {

                $('#empleave_leaveentendshorten').modal('hide');

                Swal.fire({
                    icon: 'success', title: 'Success', text: 'Leave has been updated successfully', confirmButtonText: 'OK'
                }).then((res) => {

                    if (res.isConfirmed) {

                        // bind grid
                        global_LeaveID = 0;

                        document.getElementById('empleave_extend_ddaction').selectedIndex = 0;
                        document.getElementById('empleave_extend_days').selectedIndex = 0;

                        document.getElementById('empleave_extend_comments').value = '';
                        document.getElementById('empleave_extend_fromdate').value = '';
                        document.getElementById('empleave_extend_todate').value = '';

                        empleave_bindgrid()();
                    }
                });


            } else {

                Swal.fire({ icon: 'error', title: 'Failed', text: 'No record was updated' });
            }
        },
        function () {

            Swal.close();

            Swal.fire({ icon: 'error', title: 'Error', text: 'Something went wrong while processing request' });
        }
    );
}

function empleave_cancel_Submit() {

}



/* Supportive Functions*/

function getPaidEligibility(ddluser) {
    var code = ddluser.options[ddluser.selectedIndex].value;
    $.ajax({
        type: "POST", url: "EmployeeLeaves.aspx/GetUserInformation", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {

                $.ajax({
                    type: "POST", url: "EmployeeLeaves.aspx/GetLeaveDetails", dataType: "json", contentType: "application/json",
                    data: "{Code:'" + code + "'}",
                    success: function (res1) {
                        var dataArray1 = JSON.parse(res1.d);
                        $.each(dataArray1, function (data1, value1) {
                            document.getElementById("empleave_totalleaves").innerHTML = blankForNull(value1.TotalLeaves);
                            document.getElementById("empleave_appliedleaves").innerHTML = blankForNull(value1.AppliedLeaves);
                            document.getElementById("empleave_pendingleaves").innerHTML = blankForNull(value1.PendingLeaves);
                        })
                    }
                });


                if (blankForNull(value.Domain) == "9") {
                    document.getElementById("paidunpid").style.display = "";
                    document.getElementById("empleave_leavedetails").style.display = "";

                }
                else if (blankForNull(value.WorkingBranch) == 11 || blankForNull(value.WorkingBranch) == 3) {
                    document.getElementById("paidunpid").style.display = "";
                    document.getElementById("empleave_leavedetails").style.display = "";
                }
                else {
                    document.getElementById("paidunpid").style.display = "none";
                    document.getElementById("empleave_leavedetails").style.display = "none";
                }
            })
        }
    });
}

function empleave_Message() {
    empleave_bindgrid();
    document.getElementById("empleave_user").selectedIndex = 0;
    document.getElementById("empleave_informtype").selectedIndex = 0;
    document.getElementById("empleave_paidunpaid").selectedIndex = 0;
    document.getElementById("empleave_days").selectedIndex = 0;
    document.getElementById("empleave_fromdate").value = '';
    document.getElementById("empleave_todate").value = '';
    document.getElementById("empleave_reason").value = '';
    $('#empleave_dverror').modal('hide');
}

function changebuttontext() {
    var dd = document.getElementById('empleave_approve_ddaction');
    if (dd.selectedIndex == 1) {
        document.getElementById('empleave_approve_btnApprove').innerHTML = "Approve";
    }
    else if (dd.selectedIndex == 2) {
        document.getElementById('empleave_approve_btnApprove').innerHTML = "Reject";
    }
    else
        document.getElementById('empleave_approve_btnApprove').innerHTML = "Okay";
}

function changebuttontextEx() {

    const state = {
        maxDays: 20,
        days: Array.from({ length: 20 }, (_, i) => (i + 1).toString()),
        hiddenDays: parseInt(document.getElementById("empleave_extend_days_hidden").innerHTML, 10),
        action: document.getElementById('empleave_extend_ddaction').value
    };

    const els = {
        daysSelect: document.getElementById("empleave_extend_days"),
        fromDate: document.getElementById("empleave_extend_fromdate"),
        toDate: document.getElementById("empleave_extend_todate"),
        btn: document.getElementById('empleave_extend_btnApprove')
    };

    // store original date range once (important for restore)
    if (!window.__leaveOriginalState) {
        window.__leaveOriginalState = {
            from: els.fromDate.value,
            to: els.toDate.value
        };
    }

    function restoreDates() {
        els.fromDate.value = window.__leaveOriginalState.from;
        els.toDate.value = window.__leaveOriginalState.to;
    }

    function bindDays(limit) {
        els.daysSelect.innerHTML = "";

        for (let i = 0; i < limit; i++) {
            const opt = document.createElement("option");
            opt.value = state.days[i];
            opt.textContent = state.days[i];
            els.daysSelect.appendChild(opt);
        }

        // restore selected day safely
        if (state.hiddenDays <= limit) {
            els.daysSelect.value = state.hiddenDays.toString();
        } else {
            els.daysSelect.selectedIndex = 0;
        }
    }

    // reset always on action change
    restoreDates();

    els.fromDate.disabled = false;
    els.toDate.disabled = false;
    els.daysSelect.disabled = false;

    switch (state.action) {

        case "Extend":
            bindDays(state.maxDays);
            els.btn.innerHTML = "Extend";
            break;

        case "Shorten":
            bindDays(state.hiddenDays);
            els.btn.innerHTML = "Shorten";
            break;

        case "Cancel":
            bindDays(state.hiddenDays);

            els.daysSelect.disabled = true;
            els.fromDate.disabled = true;
            els.toDate.disabled = true;

            els.btn.innerHTML = "Cancel";
            break;

        default:
            els.btn.innerHTML = "Okay";
            break;
    }
}

function GetLeavesToDate() {

    const fromDateInput = document.getElementById("empleave_fromdate");
    const toDateInput = document.getElementById("empleave_todate");
    const daysSelect = document.getElementById("empleave_days");

    const fromDateValue = fromDateInput.value;
    const daysValue = parseInt(daysSelect.value, 10);

    if (!fromDateValue || isNaN(daysValue)) {
        toDateInput.value = "";
        return false;
    }

    const date = new Date(fromDateValue);

    // If 1 day leave → same date
    if (daysValue === 1) {
        toDateInput.value = fromDateValue;
        return false;
    }

    // Add (days - 1)
    date.setDate(date.getDate() + (daysValue - 1));

    const toDate = date.toISOString().split("T")[0];
    toDateInput.value = toDate;

    return false;
}

function GetLeavesToDateEx() {

    const fromDateInput = document.getElementById('empleave_extend_fromdate');
    const daysDropdown = document.getElementById('empleave_extend_days');

    const fromDateValue = fromDateInput.value;
    if (!fromDateValue) {
        fromDateInput.value = '';
        return false;
    }

    const days = parseInt(daysDropdown.options[daysDropdown.selectedIndex].text, 10);

    if (isNaN(days)) {
        console.error("Invalid days value");
        return false;
    }

    const fromDate = new Date(fromDateValue);

    // Calculate ToDate
    const toDate = new Date(fromDate);
    toDate.setDate(toDate.getDate() + days - 1);

    // Format: 29-May-2026
    const formattedToDate = formatDate_DDMMMYYYY(toDate);

    console.log("ToDate:", formattedToDate);

    // Example: assign to input if needed
    document.getElementById('empleave_extend_todate').value = formattedToDate;

    return formattedToDate;
}

function formatDate_DDMMMYYYY(date) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    const day = String(date.getDate()).padStart(2, '0');
    const month = months[date.getMonth()];
    const year = date.getFullYear();

    return `${day}-${month}-${year}`;
}
