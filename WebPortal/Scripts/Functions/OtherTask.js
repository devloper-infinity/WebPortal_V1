
console.log('Other Task');

var error_count = 0;
var dateerror_count = 0;
var projectId;
var processId;
var projectName;
var processName;


function otherTask_Project(empID) {

    $.ajax({
        type: "POST",
        url: "DailyProductivity.aspx/GetProjects",
        dataType: "json",
        data: JSON.stringify({ EmpID: empID }),
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            var ddl = $("#otherTask_project");

            ddl.empty(); // clear first

            // ✅ Add default option at index 0
            ddl.append('<option value="">-- Select Project --</option>');

            // ✅ Bind data
            $.each(res.d, function (i, item) {
                ddl.append(
                    $("<option></option>").val(item.ProjectID).text(item.ProjectName)
                );
            });
        },
        error: function (err) {
            console.log(err);
        }
    });

}

function core_otherTask_bindProcess(el) {

    var projectId = $(el).val(); // get selected value

    /* projectId = 15;*/

    $.ajax({
        type: "POST",
        url: "OtherTask.aspx/GetProcessForOtherTask",
        data: JSON.stringify({ ProjectID: projectId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (response) {

            var data = response.d;

            var ddl = $('#otherTask_process');

            ddl.empty();
            ddl.append('<option value="">-- Select Process --</option>');

            $.each(data, function (i, item) {

                alert('message');

                ddl.append('<option value="' + item.ProcessID + '">' + item.ProcessName + '</option>');
            });
        },
        error: function (err) {
            console.log(err);
        }
    });
}

function otherTask_bindProcess(el) {
    const projectId = $(el).val();
    const $processDropdown = $('#otherTask_process');

    $processDropdown
        .empty()
        .append('<option value="">-- Select Process --</option>');

    if (!projectId) {
        return;
    }

    $.ajax({
        type: 'POST',
        url: 'OtherTask.aspx/GetProcessForOtherTask',
        data: JSON.stringify({
            ProjectID: parseInt(projectId, 10)
        }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',

        success: function (response) {
            let processes = response.d;

            // ASP.NET may return serialized JSON inside response.d
            if (typeof processes === 'string') {
                try {
                    processes = JSON.parse(processes);
                } catch (error) {
                    console.error('Invalid JSON returned:', processes);
                    return;
                }
            }

            if (!Array.isArray(processes)) {
                console.error('Expected an array but received:', processes);
                return;
            }

            const options = processes.map(function (item) {
                return $('<option>', {
                    value: item.ProcessID,
                    text: item.ProcessName
                });
            });

            $processDropdown.append(options);
        },

        error: function (xhr, status, error) {
            console.error('Request failed:', status, error);
            console.error(xhr.responseText);
        }
    });
}

/* ================= UPLOAD ================= */

function otherTask_uploadData() {

    var projectId = $('#otherTask_project').val();
    var projectName = $('#otherTask_project option:selected').text();

    var processId = $('#otherTask_process').val();
    var processName = $('#otherTask_process option:selected').text();

    var fileInput = document.getElementById("otherTask_fileUploads");

    if (!projectId) {
        Swal.fire("Warning", "Please select project.", "warning");
        return false;
    }

    if (!processId || processId === "0") {
        Swal.fire("Warning", "Please select process.", "warning");
        return false;
    }

    if (!fileInput || fileInput.files.length === 0) {
        Swal.fire("Warning", "Please select file.", "warning");
        return false;
    }

    $('#load1').show();

    PageMethods.GetExcelDataToBindGrid(
        function (response) {

            $('#load1').hide();

            var data = response || [];

            if (data.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Warning',
                    text: 'No records found in uploaded excel.'
                });
                return;
            }

            PageMethods.CheckOtherTaskExistsOrNot(
                projectName,
                processName,

                function (existsResponse) {

                    if (existsResponse === "Process") {
                        processExcelData(data);
                        Swal.fire("Success", "Data imported successfully.", "success");
                        return;
                    }

                    Swal.fire({
                        icon: 'warning',
                        title: 'Duplicate Loans',
                        text: existsResponse,
                        showCancelButton: true,
                        confirmButtonText: 'OK'
                    }).then(function (result) {
                        bindDuplicateLoans_Grid();
                        if (!result.isConfirmed) {
                            return;
                        }
                    });
                },

                function (error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: error.get_message()
                    });
                }
            );
        },

        function (error) {
            $('#load1').hide();

            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}


function otherTask_clearData() {

    $('#otherTask_project').prop('selectedIndex', 0).trigger('change');
    $('#otherTask_process').empty();

    // PageMethod Call
    PageMethods.ClearData(
        function (response) {

            var data = response;

            if (response == 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Warning',
                    text: "Error in clearing data.",
                    zIndex: 999999
                });
            } else {

                var error_count = 0;
                var dateerror_count = 0;

                // Destroy old table
                if ($.fn.DataTable.isDataTable('#table_otherTask')) {
                    $('#table_otherTask').DataTable().clear().destroy();
                }

                document.getElementById("otherTask_verify").disabled = false;
                document.getElementById("otherTask_alert").innerText = "";

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: "Data deleted successfully.",
                }).then(function () {
                    location.reload();
                });
            }
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}


function otherTask_VerifyData() {

    /*$('#othertask_waitingpanel').modal('show');*/

    projectId = $('#otherTask_project').val();      // ID
    projectName = $('#otherTask_project option:selected').text(); // Text

    processId = $('#otherTask_process').val();      // ID
    processName = $('#otherTask_process option:selected').text(); // Text

    // PageMethod Call
    PageMethods.VerifyAndSubmitData(projectId, projectName, processId, processName,
        function (response) {

            var data = response;

            if (response == 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Warning',
                    text: "Error in verifying data.",
                    zIndex: 999999
                });
            } else {

                Swal.fire({
                    icon: 'success',
                    title: 'Success',
                    text: "Data verified successfully.",
                }).then(function () {

                    location.reload();
                });
            }
        },

        function (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: error.get_message()
            });
        }
    );

    return false;
}


// ✅ Format Date (MM/DD/YYYY)
function formatMMDDYYYY(data) {
    if (!data) return '';
    let date = new Date(data);
    return (date.getMonth() + 1) + '/' +
        date.getDate() + '/' +
        date.getFullYear();
}

// ✅ Validation Function
function validateRow(row) {

    let errors = [];

    // Today (remove time)
    let today = new Date();
    today.setHours(0, 0, 0, 0);

    // Allowed min date (today - 2 days)
    let minDate = new Date(today);
    minDate.setDate(today.getDate() - 2);

    // 🔹 Completion Date Validation
    if (row["ComplitionDate"]) {
        let compDate = new Date(row["ComplitionDate"]);
        compDate.setHours(0, 0, 0, 0);

        if (compDate < minDate || compDate > today) {
            dateerror_count++;
            errors.push("Please check complition date.");
        }
    }

    // 🔹 Remark + Reason Validation
    if (row["Remark"] != "Completed" && !row["Reason"]) {
        errors.push("please spacify reason.");
    }

    // 🔹 Combine Errors
    if (errors.length > 0) {
        error_count++;

        return errors.map((e, i) => `${e}`).join("<br>");
    }

    return "";
}


// ✅ Process Excel Data
function core_processExcelData(data) {

    error_count = 0;

    var dataArray = data.d || data;

    if (typeof dataArray === "string") {
        dataArray = JSON.parse(dataArray);
    }

    dataArray.forEach(row => {

        row["Error in excel column"] = validateRow(row);
    });

    if (error_count > 0) {
        document.getElementById("otherTask_verify").disabled = true;

        // ✅ Prepare date range
        let todayDate = new Date();
        let minAllowedDate = new Date();
        minAllowedDate.setDate(todayDate.getDate() - 2);

        const alertBox = document.getElementById("otherTask_alert");

        if (dateerror_count > 0)
            alertBox.innerHTML = `
        <div style="background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; padding: 12px 16px; border-radius: 6px; font-weight: 500;">
            ⚠️ Please clear <b>${error_count}</b> error(s) listed in <b>'Error In Excel'</b> Column before clicking <b>Verify & Submit</b>.<br>
            <small> <b>Note:</b> Completion date must be between <b>${formatMMDDYYYY(minAllowedDate)}</b> and <b>${formatMMDDYYYY(todayDate)}</b>.</small>
        </div>`;
        else
            alertBox.innerHTML = `
    <div style="background-color: #fff3cd; color: #856404;border: 1px solid #ffeeba;padding: 12px 16px;border-radius: 6px;font-weight: 500;">
        ⚠️ Please clear <b>${error_count}</b> error(s) listed in <b>'Error In Excel'</b> Column before clicking <b>Verify & Submit</b>.</div>`;
    }
    else {
        document.getElementById("otherTask_verify").disabled = false;
        document.getElementById("otherTask_alert").innerText = "";
    }

    otherTask_bindgrid(dataArray);
}


function core_otherTask_bindgrid(dataArray) {

    var hasDuplicateColumn = dataArray.length > 0 && dataArray[0].hasOwnProperty("DuplicateStatus");

    var projectName = $('#otherTask_project option:selected').text();
    var processName = $('#otherTask_process option:selected').text();

    // Destroy old table
    if ($.fn.DataTable.isDataTable('#table_otherTask')) {
        $('#table_otherTask').DataTable().clear().destroy();
    }

    if (!dataArray || dataArray.length === 0) {
        $('#table_otherTask tbody').html('<tr><td colspan="8">No Data Found</td></tr>');
        return;
    }

    $('#table_otherTask').DataTable({
        dom: 'ft',
        data: dataArray,
        paging: false,
        processing: true,
        ordering: false,

        columns: [
            /* { data: null, title: '<input type="checkbox" id="taskselect_all" />', orderable: false, render: function () { return '<input type="checkbox" class="row_checkbox">'; } },*/

            { data: null, title: 'Sr. #', render: function (data, type, row, meta) { return meta.row + 1; } },
            { data: null, title: 'Project', render: function () { return projectName; } },
            { data: null, title: 'Process', render: function () { return processName; } },

            // ✅ IMPORTANT: Use EXACT keys with spaces
            { data: 'LoanNo', title: 'Loan #' },
            { data: 'DealNo', title: 'Deal #' },
            { data: 'UserName', title: 'Complete By' },
            {
                data: 'AssignedDate',
                title: 'Assigned Date',
                render: formatMMDDYYYY
            },
            {
                data: 'ProcessDate',
                title: 'Completion Date',
                render: formatMMDDYYYY
            },
            { data: 'Remark', title: 'Remark' },
            { data: 'Reason', title: 'Reason' },
            {
                data: 'Error in excel column',
                title: 'Error in Excel',
                render: function (data) {
                    if (!data) return '';
                    return `<span style="color:red; font-weight:600;">${data}</span>`;
                }
            }
        ]
    });

    // ✅ Select All functionality
    $('#taskselect_all').on('click', function () {
        $('.row_checkbox').prop('checked', this.checked);
    });

    // ✅ Uncheck select all if one unchecked
    $('#table_otherTask tbody').on('change', '.row_checkbox', function () {
        if (!this.checked) {
            $('#taskselect_all').prop('checked', false);
        }
    });
}

function processExcelData(data) {

    error_count = 0;

    var dataArray = data.d || data;

    if (typeof dataArray === "string") {
        dataArray = JSON.parse(dataArray);
    }

    if (!Array.isArray(dataArray)) {
        dataArray = [];
    }

    // Preserve existing validation functionality
    dataArray.forEach(function (row) {
        row["Error in excel column"] = validateRow(row);
    });

    var verifyButton = document.getElementById("otherTask_verify");
    var alertBox = document.getElementById("otherTask_alert");

    /*
     * Duplicate functionality runs only when the
     * DuplicateStatus column exists in the response.
     */
    var hasDuplicateColumn = dataArray.length > 0 && dataArray.some(function (row) { return Object.prototype.hasOwnProperty.call(row, "DuplicateStatus"); });

    var duplicateCount = 0;
    var allRowsDuplicate = false;

    if (hasDuplicateColumn) {

        duplicateCount = dataArray.filter(function (row) { return String(row.DuplicateStatus || "").trim().toLowerCase() === "duplicate"; }).length;

        allRowsDuplicate = dataArray.length > 0 && duplicateCount === dataArray.length;
    }

    /*
     * Preserve the existing validation-error behavior.
     * Also disable the button when duplicate rows are present.
     */
    if (error_count > 0 || duplicateCount > 0) {

        verifyButton.disabled = true;

        var messages = [];

        // Existing validation-error message
        if (error_count > 0) {

            var todayDate = new Date();
            var minAllowedDate = new Date();

            minAllowedDate.setDate(todayDate.getDate() - 2);

            messages.push(`
                Please clear <b>${error_count}</b> error(s) listed in
                <b>'Error In Excel'</b> column before clicking
                <b>Verify & Submit</b>.
            `);

            if (dateerror_count > 0) {
                messages.push(`
                    <small>
                        <b>Note:</b> Completion date must be between
                        <b>${formatMMDDYYYY(minAllowedDate)}</b> and
                        <b>${formatMMDDYYYY(todayDate)}</b>.
                    </small>
                `);
            }
        }

        // Added duplicate message only when the column exists
        if (hasDuplicateColumn && duplicateCount > 0) {

            if (allRowsDuplicate) {
                messages.push(`
                    All <b>${dataArray.length}</b> loan(s) from the
                    uploaded Excel file already exist in the system.
                    Please upload a file containing new loan records.
                `);
            }
            else {
                messages.push(`
                    <b>${duplicateCount}</b> out of
                    <b>${dataArray.length}</b> loan(s) from the uploaded
                    Excel file already exist in the system. Please remove
                    the duplicate loan(s) before proceeding.
                `);
            }
        }

        alertBox.innerHTML = `
            <div style="
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
                padding: 12px 16px;
                border-radius: 6px;
                font-weight: 500;
                line-height: 1.7;
            ">
                ⚠️ ${messages.join("<br><br>")}
            </div>
        `;
    }
    else {

        // Existing success behavior remains unchanged
        verifyButton.disabled = false;
        alertBox.innerHTML = "";
    }

    otherTask_bindgrid(dataArray);
}

function otherTask_bindgrid(dataArray) {


    var projectName = $('#otherTask_project option:selected').text();
    var processName = $('#otherTask_process option:selected').text();

    // Destroy old table
    if ($.fn.DataTable.isDataTable('#table_otherTask')) {
        $('#table_otherTask').DataTable().clear().destroy();
    }

    if (!dataArray || dataArray.length === 0) {
        $('#table_otherTask tbody').html('<tr><td colspan="8">No Data Found</td></tr>');
        return;
    }

    var hasDuplicateColumn = dataArray.length > 0 && dataArray[0].hasOwnProperty("DuplicateStatus");

    $('#table_otherTask').DataTable({
        dom: 'ft',
        data: dataArray,
        paging: false,
        processing: true,
        ordering: false,

        createdRow: function (row, data) {

            if (hasDuplicateColumn &&
                data.DuplicateStatus &&
                data.DuplicateStatus.toString().trim().toLowerCase() === "duplicate") {

                $(row).addClass("row-duplicate");
            }
        },

        // Apply nowrap to all columns except Remark & Reason
        columnDefs: [
            {
                targets: "_all",
                className: "dt-nowrap"
            }
            // ,{
            //     targets: [8, 9],   // Remark, Reason
            //     className: "dt-wrap"
            // }
        ],

        columns: [
            { data: null, title: 'Sr. #', render: function (data, type, row, meta) { return meta.row + 1; } },
            { data: null, title: 'Project', render: function () { return projectName; } },
            { data: null, title: 'Process', render: function () { return processName; } },
            { data: 'LoanNo', title: 'Loan #' },
            { data: 'DealNo', title: 'Deal #' },
            { data: 'UserName', title: 'Complete By' },
            {
                data: 'AssignedDate',
                title: 'Assigned Date',
                render: formatMMDDYYYY
            },
            {
                data: 'ProcessDate',
                title: 'Completion Date',
                render: formatMMDDYYYY
            },
            { data: 'Remark', title: 'Remark' },
            { data: 'Reason', title: 'Reason' },
            {
                data: 'Error in excel column',
                title: 'Error in Excel',
                render: function (data) {
                    if (!data) return '';
                    return `<span style="color:red;font-weight:600;">${data}</span>`;
                }
            }
        ],
        initComplete: function () {
            $('#table_otherTask').attr('tabindex', '-1').focus();
        }
    });

    // ✅ Select All functionality
    $('#taskselect_all').on('click', function () {
        $('.row_checkbox').prop('checked', this.checked);
    });

    // ✅ Uncheck select all if one unchecked
    $('#table_otherTask tbody').on('change', '.row_checkbox', function () {
        if (!this.checked) {
            $('#taskselect_all').prop('checked', false);
        }
    });
}


/*------------ Other Task Report -------------*/

function loadOtherTaskReport() {

    let fromDate = $('#othertaskreport_fromDate').val();
    let toDate = $('#othertaskreport_toDate').val();

    if (!fromDate || !toDate) {
        alert("Please select From Date and To Date");
        return;
    }

    if (new Date(fromDate) > new Date(toDate)) {
        alert("From Date cannot be greater than To Date");
        return;
    }

    otherTaskReport_bindgrid(fromDate, toDate);
}

function otherTaskReport_bindgrid(fromDate, toDate) {

    if ($.fn.DataTable.isDataTable('#table_otherTaskReport')) {
        $('#table_otherTaskReport').DataTable().clear().destroy();
        $('#table_otherTaskReport').empty();
    }

    $('#table_otherTaskReport').DataTable({

        dom: 'Bftrip', // ✅ REQUIRED

        ajax: {
            url: "OtherTaskReport.aspx/BindOtherTaskReport",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: function () {
                return JSON.stringify({ FromDate: fromDate, ToDate: toDate });
            },
            dataSrc: function (response) {
                return JSON.parse(response.d);
            }
        },

        columns: [
            { data: 'SrNo', title: 'Sr. #' },
            { data: 'ProjectNo', title: 'Project' },
            { data: 'Process', title: 'Process' },
            { data: 'DealNo', title: 'Deal #' },
            { data: 'LoanNo', title: 'Loan #' },
            { data: 'UserName', title: 'Completed By <br> (Pseudo Name)' },
            { data: 'AssignedDate', title: 'Assigned Date' },
            { data: 'ProcessDate', title: 'Completion Date' },
            { data: 'Remark', title: 'Remark' },
            { data: 'Reason', title: 'Reason' },
            { data: 'EmpName', title: 'Added By' },
            { data: 'AddedDate', title: 'Added Date' },
        ],

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Export to Excel',
                className: 'btn btn-success',
                filename: `OtherTask_Report_${fromDate}_to_${toDate}`,
                title: `OtherTask Report (${fromDate} to ${toDate})`,
            }
        ]
    });
}




/*------------ PM Other Task Report -------------*/

function pm_loadOtherTaskReport() {

    let fromDate = $('#pmothertaskreport_fromDate').val();
    let toDate = $('#pmothertaskreport_toDate').val();

    if (!fromDate || !toDate) {
        alert("Please select From Date and To Date");
        return;
    }

    if (new Date(fromDate) > new Date(toDate)) {
        alert("From Date cannot be greater than To Date");
        return;
    }

    PMotherTaskReport_bindgrid(fromDate, toDate);
}

function PMotherTaskReport_bindgrid(fromDate, toDate) {

    if ($.fn.DataTable.isDataTable('#table_PMotherTaskReport')) {
        $('#table_PMotherTaskReport').DataTable().clear().destroy();
        $('#table_PMotherTaskReport').empty();
    }

    $('#table_PMotherTaskReport').DataTable({

        dom: 'Bftrip', // ✅ REQUIRED

        ajax: {
            url: window.otherTaskReportServiceUrl || "OtherTaskReport.aspx/BindOtherTaskReport",
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: function () {
                return JSON.stringify({ FromDate: fromDate, ToDate: toDate });
            },
            dataSrc: function (response) {
                return JSON.parse(response.d);
            }
        },

        columns: [
            { data: 'SrNo', title: 'Sr. #' },
            { data: 'ProjectNo', title: 'Project' },
            { data: 'Process', title: 'Process' },
            { data: 'DealNo', title: 'Deal #' },
            { data: 'LoanNo', title: 'Loan #' },
            { data: 'UserName', title: 'Completed By <br> (Pseudo Name)' },
            { data: 'AssignedDate', title: 'Assigned Date' },
            { data: 'ProcessDate', title: 'Completion Date' },
            { data: 'Remark', title: 'Remark' },
            { data: 'Reason', title: 'Reason' },
            { data: 'EmpName', title: 'Added By' },
            { data: 'AddedDate', title: 'Added Date' },
        ],

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Export to Excel',
                className: 'btn btn-success',
                filename: `OtherTask_Report_${fromDate}_to_${toDate}`,
                title: `OtherTask Report (${fromDate} to ${toDate})`,
            }
        ]
    });
}



function bindDuplicateLoans_Grid() {

    $('#load1').show();

    PageMethods.CheckDuplicate(
        function (response) {

            $('#load1').hide();

            var data = response ? JSON.parse(response) : [];

            processExcelData(data);
        },
        function (error) {

            $('#load1').hide();

            Swal.fire({
                icon: "error",
                title: "Error",
                text: error.get_message()
            });
        }
    );
}