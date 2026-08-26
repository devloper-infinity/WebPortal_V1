var pmatt_table;
var selfatt_table;
var selfatt_html;
var attnEmpReasonType;
var attnUserReason;

//Self Attendance - START
function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function attendanceValue(id) {
    var element = document.getElementById(id);
    if (!element) return "";
    return ((element.value !== undefined ? element.value : element.innerHTML) || "").trim();
}

function attendanceText(id) {
    var element = document.getElementById(id);
    if (!element) return "";
    if (element.options && element.selectedIndex >= 0) {
        return (element.options[element.selectedIndex].text || "").trim();
    }
    return attendanceValue(id);
}

function isAttendanceEmpty(value) {
    value = (value || "").trim();
    return value === "" || value.toLowerCase() === "select";
}

function setAttendanceValue(id, value) {
    var element = document.getElementById(id);
    if (!element) return;
    if (element.value !== undefined) {
        element.value = value;
    }
    else {
        element.innerHTML = value;
    }
}

function setAttendanceDisplay(id, display) {
    var element = document.getElementById(id);
    if (element) element.style.display = display;
}

function showAttendanceMessage(icon, title, text, callback) {
    if (window.Swal && Swal.fire) {
        Swal.fire({
            icon: icon,
            title: title,
            text: text,
            confirmButtonText: "OK"
        }).then(function () {
            if (typeof callback === "function") callback();
        });
    }
    else {
        if (window.console && console.error) {
            console.error(title + ": " + text);
        }
        if (typeof callback === "function") callback();
    }
}

function showAttendanceValidation(message) {
    showAttendanceMessage("warning", "Validation", message);
    return false;
}

function attendanceErrorText(error) {
    if (!error) return "Unexpected error occurred. Please try again.";
    if (typeof error.get_message === "function") return error.get_message();
    return error.responseText || error.message || "Unexpected error occurred. Please try again.";
}

function handleAttendanceError(error) {
    $("#waitingpanel").modal("hide");
    showAttendanceMessage("error", "Error", attendanceErrorText(error));
    return false;
}

function attendanceReturnMessage(result) {
    var messages = {
        0: "Request already exists for selected In Date!",
        "-1": "Please select proper logout details!",
        "-2": "Please select Out Date!",
        "-3": "Please select Out Time!",
        "-4": "Please select Out Time Convention!",
        "-5": "Please enter login time in 12 hours format!",
        "-6": "Technical Error. Please contact support department!",
        "-7": "Please select In Date and In Time!"
    };
    return messages[result] || "Unable to process attendance correction request. Please try again.";
}

function handleAttendanceSubmitResult(result, successMessage, successCallback) {
    $("#waitingpanel").modal("hide");
    if (result > 0) {
        showAttendanceMessage("success", "Success", successMessage, successCallback);
        return false;
    }

    showAttendanceMessage("error", "Error", attendanceReturnMessage(result));
    return false;
}

function parseAttendanceDateTime(dateValue, timeValue) {
    if (isAttendanceEmpty(dateValue) || isAttendanceEmpty(timeValue)) return null;

    var isoDate = /^\d{4}-\d{2}-\d{2}$/.test(dateValue);
    var parsed = isoDate ? new Date(dateValue + "T" + timeValue) : new Date(dateValue + " " + timeValue);

    return isNaN(parsed.getTime()) ? null : parsed;
}

function attendanceOutTimeIsAfterInTime(inDate, inTime, outDate, outTime) {
    var inDateTime = parseAttendanceDateTime(inDate, inTime);
    var outDateTime = parseAttendanceDateTime(outDate, outTime);

    if (!inDateTime || !outDateTime) return true;
    return outDateTime > inDateTime;
}

function calculateAttendanceDuration(inDate, inTime, outDate, outTime) {
    var inDateTime = parseAttendanceDateTime(inDate, inTime);
    var outDateTime = parseAttendanceDateTime(outDate, outTime);
    if (!inDateTime || !outDateTime || outDateTime <= inDateTime) return "";

    var totalMinutes = Math.floor((outDateTime - inDateTime) / 60000);
    var hours = Math.floor(totalMinutes / 60);
    var minutes = totalMinutes % 60;
    return hours + ":" + (minutes < 10 ? "0" : "") + minutes;
}

function validateAttendanceForm(prefix, requireUser) {
    if (requireUser && isAttendanceEmpty(attendanceValue(prefix + "_user"))) {
        return showAttendanceValidation("Please select user.");
    }

    if (isAttendanceEmpty(attendanceValue(prefix + "_reason"))) {
        return showAttendanceValidation("Please select reason type.");
    }

    var indate = attendanceValue(prefix + "_indate");
    var intime = attendanceValue(prefix + "_intime");
    var outdate = attendanceValue(prefix + "_outdate");
    var outtime = attendanceValue(prefix + "_outtime");
    var userreason = attendanceValue(prefix + "_userreason");

    if (isAttendanceEmpty(indate)) {
        return showAttendanceValidation("Please select In Date.");
    }

    if (isAttendanceEmpty(intime)) {
        return showAttendanceValidation("Please select In Time.");
    }

    if (!isAttendanceEmpty(outtime) && isAttendanceEmpty(outdate)) {
        return showAttendanceValidation("Please select Out Date.");
    }

    if (!isAttendanceEmpty(outdate) && isAttendanceEmpty(outtime)) {
        return showAttendanceValidation("Please select Out Time.");
    }

    if (!isAttendanceEmpty(outdate) && !isAttendanceEmpty(outtime) && !attendanceOutTimeIsAfterInTime(indate, intime, outdate, outtime)) {
        return showAttendanceValidation("Out Date/Time must be greater than In Date/Time.");
    }

    if (isAttendanceEmpty(userreason)) {
        return showAttendanceValidation("Please enter reason.");
    }

    if (userreason.length < 10) {
        return showAttendanceValidation("Reason must be more than 10 characters.");
    }

    return true;
}

function handleAttendanceTotalHours(prefix, result) {
    var totalHoursId = prefix + "_totaltime";
    var weeklyLabelId = prefix === "pmatt" ? "pmweeklyofflabel" : "weeklyofflabel";
    var weeklyContainerId = prefix === "pmatt" ? "pmweeklyofflabel" : "weeklyoffContainer";
    var weeklyTextId = prefix === "pmatt" ? "pmweeklyofftext" : "weeklyofftext";
    result = (result || "").toString();

    setAttendanceDisplay(weeklyLabelId, "none");
    setAttendanceDisplay(weeklyContainerId, "none");
    setAttendanceDisplay(weeklyTextId, "none");

    if (result.length < 6) {
        setAttendanceValue(totalHoursId, result);
        var totalHoursElement = document.getElementById(totalHoursId);
        if (totalHoursElement) totalHoursElement.disabled = true;
        return false;
    }

    if (result.indexOf("Weekly Off") >= 0) {
        var totalHours = result.split("~");
        setAttendanceValue(totalHoursId, totalHours[0]);
        setAttendanceDisplay(weeklyLabelId, "");
        setAttendanceDisplay(weeklyContainerId, "");
        setAttendanceDisplay(weeklyTextId, "");
        setAttendanceValue(weeklyTextId, totalHours[2] || "");
        return false;
    }

    showAttendanceMessage("warning", "Validation", result.replace(/~/g, " ").trim());
    return false;
}

function selfatt_bindReasons() {
    var select = document.getElementById("selfatt_reason");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#selfatt_reason").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/BindAttendanceReasons", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#selfatt_reason").append($("<option></option>").val(value.ReasonId).html(value.Reasons));
            })
        }
    });
}

function selfatt_getIndates(ddl) {

    var value = ddl.options[ddl.selectedIndex].value;
    document.getElementById("selfatt_intime").value = '';
    document.getElementById("selfatt_intime").disabled = false;
    document.getElementById("selfatt_outdate").selectedIndex = '';
    document.getElementById("selfatt_outtime").value = '';
    document.getElementById("selfatt_totaltime").value = '';

    if (value == "1" || value == "3" || value == "4" || value == "15") {
        BindInDates();
        BindOutDatesForConnectivity();
    }
    else if (value == "2") {

        BindInDatesForLogoutRequest();
        BindOutDatesForLogoutRequest();
    }
}

function BindInDates() {
    var select = document.getElementById("selfatt_indate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#selfatt_indate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/GetInDates", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#selfatt_indate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function BindInDatesForLogoutRequest() {
    var select = document.getElementById("selfatt_indate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#selfatt_indate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/GetInDateForLogout", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#selfatt_indate").append($("<option></option>").val(value.Dates).html(value.Dates));
            })
        }
    });
}

function BindOutDatesForLogoutRequest() {

    var select = document.getElementById("selfatt_outdate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#selfatt_outdate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/GetOutDateForLogout", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);

            $.each(dataArray, function (data, value) {
                $("#selfatt_outdate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function BindOutDatesForConnectivity() {
    var select = document.getElementById("selfatt_outdate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#selfatt_outdate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/GetOutDateForConnectivity", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#selfatt_outdate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function selfatt_getInTime(dates) {
    var date = dates.value;
    $.ajax({
        type: "POST", url: "AttendanceCorrectionSelf.aspx/GetInTime", dataType: "json", contentType: "application/json",
        data: "{Date:'" + date + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            if (dataArray == null || dataArray == undefined || dataArray == '') {
                document.getElementById("selfatt_intime").value = '';
                document.getElementById("selfatt_intime").disabled = false;
                document.getElementById("selfatt_outdate").selectedIndex = '';
                document.getElementById("selfatt_outtime").value = '';
                document.getElementById("selfatt_totaltime").value = '';
            }
            $.each(dataArray, function (data, value) {
                if (value.InTime.length > 3) {
                    const times = value.newInTime.split(':');
                    var hours = times[0].trim();
                    if (hours.length == 1)
                        hours = "0" + hours;
                    var minutes = times[1].trim();
                    if (minutes.length == 1)
                        minutes = "0" + minutes;
                    //$("#selfatt_intime").text(hours + ":" + minutes + " " + value.IN1);
                    document.getElementById("selfatt_intime").value = hours + ":" + minutes;
                    document.getElementById("selfatt_intime").disabled = true;
                    //document.getElementById("selfatt_intime").value = hours + ":" + minutes + " " + value.IN1;
                }
            })
        }
    });
}

function selfatt_GetTotalHours() {

    var indate = attendanceValue("selfatt_indate");
    var outdate = attendanceValue("selfatt_outdate");
    var intime = attendanceValue("selfatt_intime");
    var outtime = attendanceValue("selfatt_outtime");

    if (isAttendanceEmpty(indate) || isAttendanceEmpty(intime) || isAttendanceEmpty(outdate) || isAttendanceEmpty(outtime)) {
        return false;
    }

    PageMethods.UserLoginGetTotalHours(
        intime,
        outtime,
        indate,
        outdate,
        function (result) {
            handleAttendanceTotalHours("selfatt", result);
        },
        handleAttendanceError
    );

    return false;
}

function selfatt_submit() {
    if (!validateAttendanceForm("selfatt", false)) {
        return false;
    }

    var userreason = attendanceValue("selfatt_userreason");
    var indate = attendanceValue("selfatt_indate");
    var intime = attendanceValue("selfatt_intime");
    var outdate = attendanceValue("selfatt_outdate");
    var outtime = attendanceValue("selfatt_outtime");
    var reasontext = attendanceText("selfatt_reason");
    var reasonvalue = attendanceValue("selfatt_reason");
    var totaltime = attendanceValue("selfatt_totaltime");
    $('#waitingpanel').modal('show');
    PageMethods.InsertAttendance(
        intime,
        outtime,
        indate,
        outdate,
        totaltime,
        reasonvalue,
        reasontext,
        userreason,
        function (result) {
            handleAttendanceSubmitResult(result, "Attendance correction request raised successfully!", function () {
                location.reload();
            });
        },
        handleAttendanceError
    );

    return false;
}



function selfatt_BindGrid() {
    $('#load1').show();

    $.ajax({
        url: "AttendanceCorrectionSelf.aspx/GetAllAttendanceRequest",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {

            var dataArray = JSON.parse(data.d || "[]");

            var total = dataArray.length;
            var pending = 0, approved = 0, rejected = 0;

            dataArray.forEach(function (row, index) {
                row.SrNo = index + 1;

                var status = (row.Approved || "").toString().trim().toLowerCase();

                if (status === "approved" || status === "approve" || status === "yes") {
                    approved++;
                } else if (status === "rejected" || status === "reject" || status === "no") {
                    rejected++;
                } else {
                    pending++;
                }
            });

            if ($.fn.dataTable.isDataTable('#selfatt_table')) {
                selfatt_table.clear().rows.add(dataArray).draw();
            } else {
                selfatt_table = $('#selfatt_table').DataTable({
                    dom: 'tip',
                    data: dataArray,
                    scrollX: true,
                    paging: true,
                    autoWidth: false,
                    ordering: false,
                    processing: true,
                    deferRender: true,
                    pageLength: 10,
                    select: {
                        style: 'single'
                    },
                    columns: [
                        { data: 'SrNo', className: 'text-center nowrap' },
                        { data: 'InDate', defaultContent: '', className: 'nowrap' },
                        { data: 'InTime', defaultContent: '', className: 'nowrap' },
                        { data: 'OutDate', defaultContent: '', className: 'nowrap' },
                        { data: 'OutTime', defaultContent: '', className: 'nowrap' },
                        { data: 'Reason', defaultContent: '', className: 'nowrap' },
                        { data: 'AddedDate', defaultContent: '', className: 'nowrap' },
                        { data: 'Approved', defaultContent: '', className: 'nowrap' },
                        { data: 'ApprovedByName', defaultContent: '', className: 'nowrap' },
                        { data: 'ApprovedDate', defaultContent: '', className: 'nowrap' },
                        { data: 'RequestRemark', defaultContent: '', className: 'nowrap' }
                    ],
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            title: 'Attendance Correction Report',
                            autoFilter: true
                        }
                    ]
                });
            }

            $("#acTotalRequests").text(total);
            $("#acPendingRequests").text(pending);
            $("#acApprovedRequests").text(approved);
            $("#acRejectedRequests").text(rejected);

            $('#load1').hide();
        },
        error: function (error) {
            $('#load1').hide();
            showAttendanceMessage("error", "Error", attendanceErrorText(error));
        }
    });

    return false;
}


//Self Attendance - END



// PM Attendance - START


function getattendancecount(ddl) {
    var code = ddl.options[ddl.selectedIndex].value;
    PageMethods.getAttendanceCount(
        code,
        function (result) {
            if (result >= 4) {
                showAttendanceMessage("warning", "Validation", "User has already exceeded maximum number of attendance correction request limit.!");
            }
        },
        handleAttendanceError
    );
    return false;
}

function pmatt_bindusers() {
    var select = document.getElementById("pmatt_user");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#pmatt_user").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GteAllUsers", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_user").append($("<option></option>").val(value.Code).html(value.Code + ' : ' + value.Name));
            })
        }
    });
}

function pmatt_bindReasons() {
    var select = document.getElementById("pmatt_reason");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#pmatt_reason").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/BindAttendanceReasons", dataType: "json", contentType: "application/json",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_reason").append($("<option></option>").val(value.ReasonId).html(value.Reasons));
            })
        }
    });
}

function pmatt_getIndates(ddl) {
    var value = ddl.options[ddl.selectedIndex].value;
    document.getElementById("pmatt_intime").value = '';
    document.getElementById("pmatt_intime").disabled = false;
    document.getElementById("pmatt_outdate").selectedIndex = '';
    document.getElementById("pmatt_outtime").value = '';
    document.getElementById("pmatt_totaltime").value = '';
    if (value == "1" || value == "3" || value == "4") {
        PM_BindInDates();
        PM_BindOutDatesForConnectivity();
    }
    else if (value == "2") {
        PM_BindInDatesForLogoutRequest();
        PM_BindOutDatesForLogoutRequest();
    }
    else if (value == "7") {
        PM_BindInDatesForDelete();
        PM_BindOutDatesForDelete();
    }
}

function PM_BindInDates() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_indate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#pmatt_indate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetInDates", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_indate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function PM_BindInDatesForLogoutRequest() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_indate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#pmatt_indate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetInDateForLogout", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_indate").append($("<option></option>").val(value.Dates).html(value.Dates));
            })
        }
    });
}

function PM_BindOutDatesForLogoutRequest() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_outdate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#pmatt_outdate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetOutDateForLogout", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_outdate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function PM_BindInDatesForDelete() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_indate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#pmatt_indate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetAllDateForDelete", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_indate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function PM_BindOutDatesForDelete() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_outdate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#pmatt_outdate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetAllDateForDelete", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_outdate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function PM_BindOutDatesForConnectivity() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var select = document.getElementById("pmatt_outdate");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#pmatt_outdate").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetOutDateForConnectivity", dataType: "json", contentType: "application/json",
        data: "{Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                $("#pmatt_outdate").append($("<option></option>").val(value.dates).html(value.dates));
            })
        }
    });
}

function pmatt_getInTime(dates) {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var date = dates.value;
    $.ajax({
        type: "POST", url: "AttendanceCorrectionpm.aspx/GetInTime", dataType: "json", contentType: "application/json",
        data: "{Date:'" + date + "',Code:'" + code + "'}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            if (dataArray == null || dataArray == undefined || dataArray == '') {
                document.getElementById("pmatt_intime").value = '';
                document.getElementById("pmatt_intime").disabled = false;
                document.getElementById("pmatt_outdate").selectedIndex = '';
                document.getElementById("pmatt_outtime").value = '';
                document.getElementById("pmatt_totaltime").value = '';
            }
            var ddlreason = document.getElementById("pmatt_reason");
            var val = ddlreason.options[ddlreason.selectedIndex].value;
            $.each(dataArray, function (data, value) {
                if (value.InTime.length > 3) {
                    const times = value.newInTime.split(':');
                    var hours = times[0].trim();
                    if (hours.length == 1)
                        hours = "0" + hours;
                    var minutes = times[1].trim();
                    if (minutes.length == 1)
                        minutes = "0" + minutes;
                    //$("#selfatt_intime").text(hours + ":" + minutes + " " + value.IN1);
                    document.getElementById("pmatt_intime").value = hours + ":" + minutes;
                    document.getElementById("pmatt_intime").disabled = true;
                    //document.getElementById("selfatt_intime").value = hours + ":" + minutes + " " + value.IN1;

                    if (val == "7") {
                        if (blankForNull(value.OutDate) != "") {
                            const outtimes = value.newOutTime.split(':');
                            var outhours = outtimes[0].trim();
                            if (outhours.length == 1)
                                outhours = "0" + outhours;
                            var outminutes = outtimes[1].trim();
                            if (outminutes.length == 1)
                                outminutes = "0" + outminutes;

                            var ddluser = document.getElementById("pmatt_user");
                            var code = ddluser.options[ddluser.selectedIndex].value;
                            var select = document.getElementById("pmatt_outdate");
                            let options = select.getElementsByTagName('option');

                            for (var i = options.length; i--;) {
                                select.removeChild(options[i]);
                            }
                            $("#pmatt_outdate").append($("<option></option>").val("").html("Select"));
                            $.ajax({
                                type: "POST", url: "AttendanceCorrectionpm.aspx/GetAllDateForDelete", dataType: "json", contentType: "application/json",
                                data: "{Code:'" + code + "'}",
                                success: function (res1) {
                                    var dataArray1 = JSON.parse(res1.d);
                                    $.each(dataArray1, function (data1, value1) {
                                        $("#pmatt_outdate").append($("<option></option>").val(value1.dates).html(value1.dates));
                                    })
                                    $("#pmatt_outdate").val(value.OutDate);
                                }
                            });
                            document.getElementById("pmatt_outtime").value = outhours + ":" + outminutes;
                            document.getElementById("pmatt_totaltime").value = value.TotalHours;
                            document.getElementById("pmatt_outdate").disabled = true;
                            document.getElementById("pmatt_outtime").disabled = true;
                            document.getElementById("pmatt_totaltime").disabled = true;
                        }
                    }
                }


            })
        }
    });
}

function pmatt_GetTotalHours() {
    var code = attendanceValue("pmatt_user");
    var indate = attendanceValue("pmatt_indate");
    var outdate = attendanceValue("pmatt_outdate");
    var intime = attendanceValue("pmatt_intime");
    var outtime = attendanceValue("pmatt_outtime");

    if (isAttendanceEmpty(code) || isAttendanceEmpty(indate) || isAttendanceEmpty(intime) || isAttendanceEmpty(outdate) || isAttendanceEmpty(outtime)) {
        return false;
    }

    PageMethods.UserLoginGetTotalHours_PM(
        code,
        intime,
        outtime,
        indate,
        outdate,
        function (result) {
            handleAttendanceTotalHours("pmatt", result);
        },
        handleAttendanceError
    );

    return false;
}

function pmatt_submit() {
    if (!validateAttendanceForm("pmatt", true)) {
        return false;
    }

    var code = attendanceValue("pmatt_user");
    var userreason = attendanceValue("pmatt_userreason");
    var indate = attendanceValue("pmatt_indate");
    var intime = attendanceValue("pmatt_intime");
    var outdate = attendanceValue("pmatt_outdate");
    var outtime = attendanceValue("pmatt_outtime");
    var reasontext = attendanceText("pmatt_reason");
    var reasonvalue = attendanceValue("pmatt_reason");
    var totaltime = attendanceValue("pmatt_totaltime");
    $('#waitingpanel').modal('show');
    PageMethods.InsertAttendance_PM(
        code,
        intime,
        outtime,
        indate,
        outdate,
        totaltime,
        reasonvalue,
        reasontext,
        userreason,
        function (result) {
            handleAttendanceSubmitResult(result, "Attendance correction request raised successfully!", function () {
                location.reload();
            });
        },
        handleAttendanceError
    );

    return false;
}

function parseAttendanceJsonDate(value) {
    var match = /\/Date\((\d+)(?:[+-]\d+)?\)\//.exec(blankForNull(value));
    if (!match) return null;

    var date = new Date(parseInt(match[1], 10));
    return isNaN(date.getTime()) ? null : date;
}

function formatAttendanceJsonDate(value) {
    var date = parseAttendanceJsonDate(value);
    return date ? date.toLocaleDateString("en-US") : "";
}

function attendanceDaysSinceJsonDate(value) {
    var addedDate = parseAttendanceJsonDate(value);
    if (!addedDate) return null;

    var today = new Date();
    var todayUtc = Date.UTC(today.getFullYear(), today.getMonth(), today.getDate());
    var addedDateUtc = Date.UTC(addedDate.getFullYear(), addedDate.getMonth(), addedDate.getDate());

    return Math.floor((todayUtc - addedDateUtc) / 86400000);
}

function pmatt_showApprovalUnavailable(daysSinceAddedDate) {
    var message = "Approval is unavailable because the Added Date is invalid.";

    if (daysSinceAddedDate > 7) {
        message = "Approval period has expired. This request must be approved within 7 days from the Added Date.";
    }
    else if (daysSinceAddedDate < 0) {
        message = "Approval is unavailable because the Added Date is in the future.";
    }

    showAttendanceMessage("warning", "Approval unavailable", message);
    return false;
}

function pmatt_BindGrid() {
    $('#load1').show();

    $.ajax({
        url: "AttendanceCorrectionpm.aspx/GetAllAttendanceRequest",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d || "[]");
            var loginId = attendanceValue("attlbl_loginID");
            var rows = [];

            $.each(dataArray, function (index, value) {
                var pmId = String(blankForNull(value.Pm)).trim();
                var approved = blankForNull(value.Approved);
                var isPendingApproval = approved === "Pending for approval";
                var daysSinceAddedDate = isPendingApproval ? attendanceDaysSinceJsonDate(value.AddedDate) : null;
                var isWithinApprovalPeriod = isPendingApproval && daysSinceAddedDate !== null && daysSinceAddedDate >= 0 && daysSinceAddedDate <= 7;
                var rowClasses = [];
                var cells = [];

                if (loginId !== "" && loginId === pmId) {
                    rowClasses.push("pmatt-current-manager-row");
                }
                if (isPendingApproval && !isWithinApprovalPeriod) {
                    rowClasses.push("pmatt-approval-disabled-row");
                }

                if (isWithinApprovalPeriod) {
                    cells.push('<td style="text-wrap: nowrap;text-align:center;"><a class="dropdown-item" href="EditAttendanceCorrectionRequest.aspx?AttendanceCorrectRequestID=' + blankForNull(value.AttendanceCorrectRequestID) + '"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>');
                }
                else if (isPendingApproval) {
                    var unavailableDays = daysSinceAddedDate === null ? "null" : daysSinceAddedDate;
                    cells.push('<td style="text-wrap: nowrap;text-align:center;"><a class="dropdown-item pmatt-approval-disabled-action" href="#!" role="button" aria-disabled="true" title="Approval period over" onclick="return pmatt_showApprovalUnavailable(' + unavailableDays + ');"><span><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>');
                }
                else {
                    cells.push('<td style="text-wrap: nowrap;text-align:center;"><a class="dropdown-item isDisabled" href="#!" onclick="AddRemark(' + value.VerID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>');
                }

                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.EmpName) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.InDate) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.InTime) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.OutDate) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.OutTime) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.Reason) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + formatAttendanceJsonDate(value.AddedDate) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + approved + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.ApprovedByName) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + formatAttendanceJsonDate(value.ApprovedDate) + '</td>');
                cells.push('<td style="text-wrap: nowrap;">' + blankForNull(value.RequestRemark) + '</td>');

                var rowClass = rowClasses.length ? ' class="' + rowClasses.join(" ") + '"' : "";
                rows.push('<tr' + rowClass + '>' + cells.join("") + '</tr>');
            });

            if ($.fn.dataTable.isDataTable('#pmatt_table')) {
                pmatt_table.destroy();
            }
            $('#pmatt_table tbody').html(rows.join(""));

            pmatt_table = $('#pmatt_table').DataTable({
                dom: 'ftipl',
                scrollX: true,
                paging: true,
                autoWidth: true,
                ordering: false,
                processing: true,
                select: {
                    style: 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'Attendance Correction Report',
                        autoFilter: true
                    }
                ]
            });

            $('#pmatt_table').off('user-select.dt.pmattApproval');
            pmatt_table.on('user-select.pmattApproval', function (event, dataTable, type, cell) {
                var row = dataTable.row(cell.index().row).node();
                if ($(row).hasClass('pmatt-approval-disabled-row')) {
                    event.preventDefault();
                }
            });
        },
        error: function (error) {
            $('#load1').hide();
            showAttendanceMessage("error", "Error", attendanceErrorText(error));
        }
    });
    return false;
}

//TPM Attendance - END



//Edit Attendance Request - START
function convertTo12Hour(time24) {
    const [hours, minutes] = time24.split(':');
    let period = 'AM';
    let hours12 = parseInt(hours, 10);

    if (hours12 >= 12) {
        period = 'PM';
        if (hours12 > 12) {
            hours12 -= 12;
        }
    } else if (hours12 === 0) {
        hours12 = 12;
    }

    const formattedTime = `${hours12}:${minutes} ${period}`;
    return formattedTime;
}

function getTimeDifference(startTime, endTime) {
    const difference = endTime - startTime;
    const differenceInMinutes = difference / 1000 / 60;
    let hours = Math.floor(differenceInMinutes / 60);
    if (hours < 0) {
        hours = 24 + hours;
    }
    let minutes = Math.floor(differenceInMinutes % 60);
    if (minutes < 0) {
        minutes = 60 + minutes;
    }
    const hoursAndMinutes = hours + ":" + (minutes < 10 ? '0' : '') + minutes;
    return hoursAndMinutes;
}

function Edit_BindInformation() {
    const urlParams = new URLSearchParams(window.location.search);
    const requestid = urlParams.get('AttendanceCorrectRequestID');
    $('#load1').show();
    $.ajax({
        type: "POST", url: "EditAttendanceCorrectionRequest.aspx/BindEditInformation", dataType: "json", contentType: "application/json",
        data: "{RequestID:" + requestid + "}",
        success: function (res) {
            var dataArray = JSON.parse(res.d);
            $.each(dataArray, function (data, value) {
                setAttendanceValue("editatt_user", blankForNull(value.EmpName));
                var date = new Date(value.InDate);
                day = date.getDate();
                if (day < 10)
                    day = '0' + day
                month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                year = date.getFullYear();
                actualdate = year + "-" + (month) + "-" + (day);
                setAttendanceValue("editatt_indate", blankForNull(actualdate));
                setAttendanceValue("editatt_intime", blankForNull(value.InTime));
                setAttendanceValue("editatt_reason", blankForNull(value.Reason));
                attnEmpReasonType = blankForNull(value.ReasonType);
                attnEmpUserReason = blankForNull(value.Reason);
                if (blankForNull(value.OutDate) != "" && blankForNull(value.OutDate) != "Select") {
                    date = new Date(value.OutDate);
                    day = date.getDate();
                    if (day < 10)
                        day = '0' + day
                    month = date.getMonth() + 1;
                    if (month < 10)
                        month = '0' + month
                    year = date.getFullYear();
                    actualdate = year + "-" + (month) + "-" + (day);
                    setAttendanceValue("editatt_outdate", blankForNull(actualdate));
                    setAttendanceValue("editatt_outtime", blankForNull(value.OutTime));
                    //Time Calculation
                    const times1 = value.InTime.split(':');
                    var hours1 = times1[0].trim();
                    if (hours1.length == 1)
                        hours1 = "0" + hours1;
                    var minutes1 = times1[1].trim();
                    if (minutes1.length == 1)
                        minutes1 = "0" + minutes1;

                    const times2 = value.OutTime.split(':');
                    var hours2 = times2[0].trim();
                    if (hours2.length == 1)
                        hours2 = "0" + hours2;
                    var minutes2 = times2[1].trim();
                    if (minutes2.length == 1)
                        minutes2 = "0" + minutes2;



                    setAttendanceValue("editatt_totalhours", getTimeDifference(new Date(0, 0, 0, hours1, minutes1), new Date(0, 0, 0, hours2, minutes2)));
                }

            })
        }
    });

    $('#load1').hide();
}

function editatt_bindbranches() {
    var select = document.getElementById("editatt_location");
    let options = select.getElementsByTagName('option');


    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#editatt_location").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetBranches", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#editatt_location").append($("<option></option>").val(value.BranchID).html(value.BranchName));
            })
        }
    });

}

function validateEditAttendanceForm(requestid, code, indate, intime, outdate, outtime, status, location, remark) {
    if (isAttendanceEmpty(requestid)) {
        return showAttendanceValidation("Invalid attendance correction request.");
    }

    if (isAttendanceEmpty(code)) {
        return showAttendanceValidation("Unable to identify selected user.");
    }

    if (isAttendanceEmpty(indate)) {
        return showAttendanceValidation("Please select In Date.");
    }

    if (isAttendanceEmpty(intime)) {
        return showAttendanceValidation("Please select In Time.");
    }

    if (!isAttendanceEmpty(outtime) && isAttendanceEmpty(outdate)) {
        return showAttendanceValidation("Please select Out Date.");
    }

    if (!isAttendanceEmpty(outdate) && isAttendanceEmpty(outtime)) {
        return showAttendanceValidation("Please select Out Time.");
    }

    if (!isAttendanceEmpty(outdate) && !isAttendanceEmpty(outtime) && !attendanceOutTimeIsAfterInTime(indate, intime, outdate, outtime)) {
        return showAttendanceValidation("Out Date/Time must be greater than In Date/Time.");
    }

    if (isAttendanceEmpty(status)) {
        return showAttendanceValidation("Please select status.");
    }

    if (isAttendanceEmpty(location)) {
        return showAttendanceValidation("Please select location.");
    }

    if (status === "Reject" && isAttendanceEmpty(remark)) {
        return showAttendanceValidation("Please enter remark for rejection.");
    }

    return true;
}

function editatt_submit() {
    const urlParams = new URLSearchParams(window.location.search);
    const requestid = urlParams.get('AttendanceCorrectRequestID');
    var user = attendanceValue("editatt_user");
    var code = user.substring(0, 3);
    var indate = attendanceValue("editatt_indate");
    var intime = attendanceValue("editatt_intime");
    var outdate = attendanceValue("editatt_outdate");
    var outtime = attendanceValue("editatt_outtime");
    var remark = attendanceValue("editatt_remark");
    var status = attendanceValue("editatt_status");
    var location = attendanceValue("editatt_location");

    if (!validateEditAttendanceForm(requestid, code, indate, intime, outdate, outtime, status, location, remark)) {
        return false;
    }

    var totaltime = attendanceValue("editatt_totalhours");
    var calculatedTotalTime = calculateAttendanceDuration(indate, intime, outdate, outtime);
    if (calculatedTotalTime) {
        totaltime = calculatedTotalTime;
        setAttendanceValue("editatt_totalhours", calculatedTotalTime);
    }

    attnEmpUserReason = attendanceValue("editatt_reason");
    $("#waitingpanel").modal('show');
    PageMethods.UpdateAttendance_PM(
        requestid,
        code,
        intime,
        outtime,
        indate,
        outdate,
        totaltime,
        remark,
        status,
        location,
        attnEmpReasonType,
        attnEmpUserReason,
        function (result) {
            handleAttendanceSubmitResult(result, "Attendance correction request updated successfully!", editatt_gotodashboard);
        },
        handleAttendanceError
    );

    return false;
}

function editatt_gotodashboard() {
    location.href = "AttendanceCorrectionpm.aspx";
}


//Edit Attendance Request - END
