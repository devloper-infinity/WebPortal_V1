var teamCompOff_table;
var global_compoffID = 0;
var msg_status = "";
var global_status = "";

/*--------- Self Compensatory Off ---------*/

function compoff_Message() {
    $('#compoff_dverror').modal('hide');
    document.getElementById("compoff_name").value = '';
    compoff_Binddata();
}

function bindworkedholiday(currentUser) {
    var select = document.getElementById("compoff_holidaydate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#compoff_holidaydate").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "CompensatoryOff.aspx/GetAllWorkedHolidayDates", dataType: "json", contentType: "application/json", data: "{currentUser:" + currentUser + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#compoff_holidaydate").append($("<option></option>").val(value.Dates).html(value.Dates));
            })
        }
    });
}

function compoff_btnsubmit() {

    var ddlholidaydate = document.getElementById("compoff_holidaydate");
    var holidaydate = ddlholidaydate.options[ddlholidaydate.selectedIndex].value;

    var compoff_date = document.getElementById("compoff_date").value;
    var compoff_remark = document.getElementById("compoff_remark").value.trim();

    if (holidaydate === "Select") {
        Swal.fire("Validation", "Please select Worked Holiday Date.", "warning").then(function () {
            document.getElementById("compoff_holidaydate").focus();
        });
        return false;
    }

    if (compoff_date === "") {
        Swal.fire("Validation", "Please enter Comp Off Date.", "warning").then(function () {
            document.getElementById("compoff_date").focus();
        });
        return false;
    }

    if (compoff_remark === "") {
        Swal.fire("Validation", "Please enter remark.", "warning").then(function () {
            document.getElementById("compoff_remark").focus();
        });
        return false;
    }

    Swal.fire({
        title: "Please Wait",
        text: "Submitting compensatory off request...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.InsertUserCompOff(
        holidaydate,
        compoff_date,
        compoff_remark,

        function (result) {

            Swal.close();

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Compensatory off added successfully!"
                }).then(function () {
                    clearCompOffFields();
                    $('#teamCompOffadd_details').modal('hide');
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Oops! Error occurred while adding compensatory off. Please contact administrator!"
                });
            }

            return false;
        },

        function (error) {

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: error.get_message
                    ? error.get_message()
                    : "Unexpected error occurred."
            });
        }
    );

    return false;
}

function bindWorkedHoliday_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'CompensatoryOff.aspx/GetUserAllCompOff',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = typeof data.d === "string" ? JSON.parse(data.d) : data.d;

            if ($.fn.DataTable.isDataTable('#table_compoff')) {
                $('#table_compoff').DataTable().clear().destroy();
            }

            $('#table_compoff').DataTable({
                dom: 'lBftp',
                data: dataArray,
                scrollX: false,
                paging: true,
                processing: true,
                ordering: false,
                serverSide: false,

                columns: [
                    { data: 'SrNo', className: 'text-center' },
                    { data: 'WorkedHolidayDate', className: 'text-center' },
                    { data: 'CompOffDate', className: 'text-center' },
                    { data: 'Remark' },
                    { data: 'AddedDate' },
                    { data: 'ApprovalStatus' },
                    { data: 'ApprovalRemark' },
                    { data: 'ApprovedByName' },
                    { data: 'ApprovedDate' }
                ],

                initComplete: function () {

                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: "Worked-Holiday Mapping"
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


/*--------- Team Compensatory Off ---------*/

function teambindWorkedHoliday_Grid() {

    $('#load1').show();

    $.ajax({
        url: 'CompensatoryOff.aspx/GetUserCompOff_forApproval',
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = typeof data.d === "string" ? JSON.parse(data.d) : data.d;

            if ($.fn.DataTable.isDataTable('#table_pmcompoff')) {
                $('#table_pmcompoff').DataTable().clear().destroy();
            }

            $('#table_pmcompoff').DataTable({
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
                        render: function (data, type, row, meta) {
                            return '<a class="dropdown-item" href="#!" ' + 'data-bs-toggle="tooltip" data-bs-placement="top" title="Approve Reject Holiday" ' + 'onclick="Approved_WorkedHoliday(' + row.CompOffID + ',' + meta.row + ');">' + '<span style="color: forestgreen;">' + '<i class="uil-edit-alt"></i>' + '</span></a>';
                        }
                    },
                    { data: 'SrNo', className: 'text-center' },
                    { data: 'Code' },
                    { data: 'EmpName' },
                    { data: 'Branch' },
                    { data: 'DepartmentName' },
                    { data: 'DesignationName' },
                    { data: 'DomainName' },
                    { data: 'Subdomain' },
                    { data: 'ReportingManager' },
                    { data: 'WorkedHolidayDate', className: 'text-center' },
                    { data: 'CompOffDate', className: 'text-center' },
                    { data: 'Remark' },
                    { data: 'AddedDate' },
                    { data: 'ApprovalStatus' },
                    { data: 'ApprovalRemark' },
                    { data: 'ApprovedByName' },
                    { data: 'ApprovedDate' }
                ],

                initComplete: function () {
                    teamCompOff_table = $('#table_pmcompoff').DataTable();
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
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


/*---- Approve Reject ----*/
function Approved_WorkedHoliday(id, index) {

    global_compoffID = id;

    var row = teamCompOff_table.row(index).data();

    document.getElementById('temcompoff_holidaydate').value = row["WorkedHolidayDate"];
    document.getElementById('teamcompoff_date').value = row["CompOffDate"];

    document.getElementById('teamCompOff_lbldetails').innerHTML = "Compensatory Off - " + row["Code"] + " : " + row["EmpName"];

    $('#teamCompOff_details').modal('show');
}

function teamCompOff_btnSubmit() {

    var ddlStatus = document.getElementById("teamCompOff_Status");
    global_status = ddlStatus.options[ddlStatus.selectedIndex].value;

    var compoff_remark = document.getElementById("teamCompOff_remark").value.trim();

    var IsApproved = global_status === "Approved";

    if (global_status === "Select") {
        Swal.fire("Validation", "Please select Status.", "warning").then(function () {
            document.getElementById("teamCompOff_Status").focus();
        });
        return false;
    }

    if (compoff_remark === "") {
        Swal.fire("Validation", "Please enter remark.", "warning").then(function () {
            document.getElementById("teamCompOff_remark").focus();
        });
        return false;
    }

    Swal.fire({
        title: "Please Wait",
        text: "Processing compensatory off request...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.ApproveRejectCompOff(
        global_compoffID,
        IsApproved,
        compoff_remark,

        function (result) {

            Swal.close();

            var msg_status = "";

            if (global_status === "Approved" || global_status === "Rejected") {
                msg_status = "Compensatory off " + global_status.toLowerCase() + " successfully.";
            } else {
                msg_status = "Oops! Error occurred while processing compensatory off. Please contact administrator!";
            }

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: msg_status
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Oops! Error occurred while processing compensatory off. Please contact administrator!"
                });
            }

            clearCompOffFields();
            msg_status = "";
            global_status = "";
            $('#teamCompOff_details').modal('hide');

            return false;
        },

        function (error) {

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: error.get_message
                    ? error.get_message()
                    : "Unexpected error occurred."
            });
        }
    );

    return false;
}


/*-------- Add New --------*/
function addNewCompesatoryOff() {

    $('#teamCompOffadd_details').modal('show');
    teamcompoff_bindusers();
}

function bindTeamtHoliday(id) {

    var currentUser = id.options[id.selectedIndex].value;

    var select = document.getElementById("temcompoffadd_holidaydate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#temcompoffadd_holidaydate").append($("<option></option>").val("Select").html("Select"));

    $.ajax({
        type: "POST", url: "CompensatoryOff.aspx/GetAllWorkedHolidayDates", dataType: "json", contentType: "application/json", data: "{currentUser:" + currentUser + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#temcompoffadd_holidaydate").append($("<option></option>").val(value.Dates).html(value.Dates));
            })
        }
    });
}

function teamcompoff_bindusers() {
    var select = document.getElementById("teamCompOffadd_user");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#teamCompOffadd_user").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GteAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#teamCompOffadd_user").append($("<option></option>").val(value.EmployeeID).html(value.Code + ' : ' + value.Name));
            })
        }
    });
}

function teamCompOffAdd_btnSubmit() {

    var ddluser = document.getElementById("teamCompOffadd_user");
    var user = ddluser.options[ddluser.selectedIndex].value;

    var ddlholidaydate = document.getElementById("temcompoffadd_holidaydate");
    var holidaydate = ddlholidaydate.options[ddlholidaydate.selectedIndex].value;

    var compoff_date = document.getElementById("teamcompoffadd_date").value;
    var compoff_remark = document.getElementById("teamCompOffadd_remark").value.trim();

    if (user === "Select") {
        Swal.fire("Validation", "Please select user.", "warning").then(function () {
            document.getElementById("teamCompOffadd_user").focus();
        });
        return false;
    }

    if (holidaydate === "Select") {
        Swal.fire("Validation", "Please select Worked Holiday Date.", "warning").then(function () {
            document.getElementById("temcompoffadd_holidaydate").focus();
        });
        return false;
    }

    if (compoff_date === "") {
        Swal.fire("Validation", "Please enter Comp Off Date.", "warning").then(function () {
            document.getElementById("teamcompoffadd_date").focus();
        });
        return false;
    }

    if (compoff_remark === "") {
        Swal.fire("Validation", "Please enter remark.", "warning").then(function () {
            document.getElementById("teamCompOffadd_remark").focus();
        });
        return false;
    }

    Swal.fire({
        title: "Please Wait",
        text: "Submitting compensatory off request...",
        allowOutsideClick: false,
        allowEscapeKey: false,
        didOpen: function () {
            Swal.showLoading();
        }
    });

    PageMethods.InsertUserCompOff_byPM(
        user,
        holidaydate,
        compoff_date,
        compoff_remark,

        function (result) {

            Swal.close();

            if (result > 0) {
                Swal.fire({
                    icon: "success",
                    title: "Success",
                    text: "Compensatory off request submitted successfully."
                }).then(function () {
                    if (typeof clearCompOffFields === "function") {
                        clearCompOffFields();
                    }

                    $('#teamCompOffadd_details').modal('hide');

                    if (typeof bindCompOffGrid === "function") {
                        bindCompOffGrid();
                    }
                });
            } else {
                Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: "Oops! Error occurred while submitting compensatory off. Please contact administrator."
                });
            }
        },

        function (error) {

            Swal.close();

            Swal.fire({
                icon: "error",
                title: "Server Error",
                text: error.get_message
                    ? error.get_message()
                    : "Unexpected error occurred."
            });
        }
    );

    return false;
}


/*-------- Clear All Fields --------*/
function clearCompOffFields() {

    // -------- First Table --------
    document.getElementById("compoff_holidaydate").selectedIndex = 0;
    document.getElementById("compoff_date").value = "";
    document.getElementById("compoff_remark").value = "";

    // -------- Second Table --------
    document.getElementById("teamCompOffadd_user").selectedIndex = 0;
    document.getElementById("temcompoffadd_holidaydate").selectedIndex = 0;
    document.getElementById("teamcompoffadd_date").value = "";
    document.getElementById("teamCompOffadd_remark").value = "";

    // -------- Third Table --------
    document.getElementById("temcompoff_holidaydate").value = "";
    document.getElementById("teamcompoff_date").value = "";
    document.getElementById("teamCompOff_Status").selectedIndex = 0;
    document.getElementById("teamCompOff_remark").value = "";
}


/*-------- Check User Login --------*/
function setTabVisibility() {

    PageMethods.CheckIfPM(
        function (result) {

            if (result == 1) {
                // User is PM → Show tab
                document.getElementById("liUserCompOff").style.display = "block";
                document.getElementById("liTeamCompOff").style.display = "block";
            }
            else {
                // User is NOT PM → Hide tab
                document.getElementById("liUserCompOff").style.display = "block";
                document.getElementById("liTeamCompOff").style.display = "none";
            }

        },
        function (error) {
            console.log("Error: " + error.get_message());
        }
    );
    bindWorkedHoliday_Grid();
}


