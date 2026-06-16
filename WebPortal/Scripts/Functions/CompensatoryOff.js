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
    var compoff_remark = document.getElementById("compoff_remark").value;

    if (holidaydate == "Select") {
        alert("Please select Worked Holiday Date.");
        document.getElementById("compoff_holidaydate").focus();
        return false;
    }

    if (compoff_date == "") {
        alert("Please enter Comp Off Date");
        document.getElementById("compoff_date").focus();
        return false;
    }

    if (compoff_remark == "") {
        alert("Please enter remark");
        document.getElementById("compoff_remark").focus();
        return false;
    }

    PageMethods.InsertUserCompOff(holidaydate, compoff_date, compoff_remark, compoff_OnSuccess, compoff_OnError);
    return false;
}

function compoff_OnSuccess(result) {

    if (result > 0) {
        document.getElementById("compoff_errmsg").innerHTML = "Compensatory off added successfully!";
        $('#compoff_dverror').modal('show');

    }
    else {
        document.getElementById("compoff_errmsg").innerHTML = "Oops! Error occured while adding compensatory off. Please contact administrator!";
        document.getElementById("compoff_errmsg").style.color = 'red';
        $('#compoff_dverror').modal('show');

    }

    clearCompOffFields();
    $('#teamCompOffadd_details').modal('hide');

    return false;
}

function compoff_OnError(error) {
    alert(error);
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
    var compoff_remark = document.getElementById("teamCompOff_remark").value;

    var IsApproved;

    if (global_status == "Approved")
        IsApproved = true;
    else
        IsApproved = false;

    if (global_status == "Select") {
        alert("Please select Status.");
        document.getElementById("compoff_holidaydate").focus();
        return false;
    }

    if (compoff_remark == "") {
        alert("Please enter remark");
        document.getElementById("teamCompOff_remark").focus();
        return false;
    }

    PageMethods.ApproveRejectCompOff(global_compoffID, IsApproved, compoff_remark, teamcompoff_OnSuccess, teamcompoff_OnError)
    return false;
}

function teamcompoff_OnSuccess(result) {

    if (global_status == "Approved" || global_status == "Rejected")
        msg_status = "Compensatory off " + global_status + " successfully";
    else
        msg_status = "Oops! Error occured while " + global_status.substring(0, 6) + "ing compensatory off. Please contact administrator!";;

    if (result > 0) {
        document.getElementById("compoff_errmsg").innerHTML = msg_status;
        $('#compoff_dverror').modal('show');
    }
    else {
        document.getElementById("compoff_errmsg").innerHTML = msg_status;
        document.getElementById("compoff_errmsg").style.color = 'red';
        $('#compoff_dverror').modal('show');
    }

    clearCompOffFields();
    msg_status = "";
    global_status = "";
    $('#teamCompOff_details').modal('hide');
    return false;
}

function teamcompoff_OnError(error) {
    alert(error.get_message());
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
    var compoff_remark = document.getElementById("teamCompOffadd_remark").value;

    if (user == "Select") {
        alert("Please select user.");
        document.getElementById("teamCompOffadd_user").focus();
        return false;
    }

    if (holidaydate == "Select") {
        alert("Please select Worked Holiday Date.");
        document.getElementById("temcompoffadd_holidaydate").focus();
        return false;
    }

    if (compoff_date == "") {
        alert("Please enter Comp Off Date");
        document.getElementById("teamcompoffadd_date").focus();
        return false;
    }

    if (compoff_remark == "") {
        alert("Please enter remark");
        document.getElementById("teamCompOffadd_remark").focus();
        return false;
    }

    PageMethods.InsertUserCompOff_byPM(user, holidaydate, compoff_date, compoff_remark, compoff_OnSuccess, compoff_OnError);
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


