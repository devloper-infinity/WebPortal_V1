var pmatt_table;
var pmatt_html;
var selfatt_table;
var selfatt_html;
var attnEmpReasonType;
var attnUserReason;

//****************** Self Attendance - START ******************//

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
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

function checkcutofftimetovalidate(reqIn) {

    var ddl = document.getElementById("selfatt_reason");
    var value = ddl.options[ddl.selectedIndex].value;

    var ddl1 = document.getElementById("selfatt_indate");
    var self_intime = ddl1.options[ddl1.selectedIndex].value;

    if (value == "1" || value == "3" || value == "4") {

        PageMethods.CheckCutOffTimeValidation("", reqIn.value, self_intime, cutoffval_OnSuccess, cutoffval_OnError);
    }

    return false;
}

function cutoffval_OnSuccess(result) {

    if (result <= 0) {
        alert("Login is allowed only up to 30 minutes before the cut-off time! Please contact your reporting manager.");
        location.reload();
    }
    return false;
}

function cutoffval_OnError(error) {
    alert(error.get_message());
}

function checkcutofftimetovalidate_pm(reqIn) {

    var ddl = document.getElementById("pmatt_reason");
    var value = ddl.options[ddl.selectedIndex].value;
    var ddlcode = document.getElementById("pmatt_user");
    var code = ddlcode.options[ddlcode.selectedIndex].value;
    var ddlIndatePm = document.getElementById("pmatt_indate");
    var inPmDate = ddlIndatePm.options[ddlIndatePm.selectedIndex].value;

    if (value == "1" || value == "3" || value == "4") {
        PageMethods.CheckCutOffTimeValidation(code, reqIn.value, inPmDate, cutoffval_pm_OnSuccess, cutoffval_pm_OnError);
    }

    return false;
}

function cutoffval_pm_OnSuccess(result) {

    if (result <= 0) {
        alert("Login is allowed only up to 30 minutes before the cut-off time!");
        location.reload();
    }
    return false;
}

function cutoffval_pm_OnError(error) {
    alert(error.get_message());
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

    var ddlInDate = document.getElementById("selfatt_indate");
    var indate = ddlInDate.options[ddlInDate.selectedIndex].value;
    var ddlOutDate = document.getElementById("selfatt_outdate");
    var outdate = ddlOutDate.options[ddlOutDate.selectedIndex].value;
    var intime = document.getElementById("selfatt_intime").value;
    var outtime = document.getElementById("selfatt_outtime").value;

    PageMethods.UserLoginGetTotalHours(intime, outtime, indate, outdate, totalhour_onsuccess, totalhour_onerror);
}

function totalhour_onsuccess(result) {
    if (result.length < 6) {
        document.getElementById("selfatt_totaltime").value = result;
        document.getElementById("selfatt_totaltime").disabled = true;
    }
    else if (result.includes('Weekly Off')) {
        var strTotalHours = result.split('~');
        document.getElementById("selfatt_totaltime").value = strTotalHours[0];
        document.getElementById("weeklyofflabel").style.display = '';
        document.getElementById("weeklyofftext").style.display = '';
        document.getElementById("weeklyofftext").innerHTML = strTotalHours[2];
    }
    else
        alert(result);
}

function totalhour_onerror(error) {
    alert(error.responseText);
}

function selfatt_submit() {
    var userreason = document.getElementById("selfatt_userreason").value;
    if (userreason == "") {
        alert("Please enter reason");
        return false;
    }
    if (userreason.length < 10) {
        alert("Reason must be more than 10 characters.");
        return false;
    }

    var ddlindate = document.getElementById("selfatt_indate");
    var indate = ddlindate.options[ddlindate.selectedIndex].value;
    var intime = document.getElementById("selfatt_intime").value;
    var ddloutdate = document.getElementById("selfatt_outdate");
    var outdate = ddloutdate.options[ddloutdate.selectedIndex].value;
    var outtime = document.getElementById("selfatt_outtime").value;
    var ddlreason = document.getElementById("selfatt_reason");
    var reasontext = ddlreason.options[ddlreason.selectedIndex].text;
    var reasonvalue = ddlreason.options[ddlreason.selectedIndex].value;
    var totaltime = document.getElementById("selfatt_totaltime").value;
    $('#waitingpanel').modal('show');
    PageMethods.InsertAttendance(intime, outtime, indate, outdate, totaltime, reasonvalue, reasontext, userreason, selfattsubmit_onsuccess, selfattsubmit_onerror);
    return false;
}

function selfattsubmit_onsuccess(result) {
    $("#waitingpanel").modal('hide');
    if (result > 0) {
        document.getElementById("selfatt_errmsg").innerHTML = "Attendance correction request raised successfully!";
        $("#selfatt_dverror").modal("show");
    }
    else if (result == 0) {
        document.getElementById("selfatt_errmsg").innerHTML = "Request already exist for selected In Date!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -1) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please select proper logout details!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -2) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please select Out Date!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -3) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please select Out Time!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -4) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please select Out Time Convention!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -5) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please enter login time in 12 hours format!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("selfatt_errmsg").innerHTML = "Technical Error. Please contact support department!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("selfatt_errmsg").innerHTML = "Please select In Time Convention!";
        document.getElementById("selfatt_errmsg").style.color = 'red';
        $('#selfatt_dverror').modal('show');
        return false;
    }
    return false;
}

function selfattsubmit_onerror(error) {
    alert(error.responseText);
}

function selfatt_BindGrid() {
    $('#load1').show();

    selfatt_html = '';
    $.ajax({
        url: "AttendanceCorrectionSelf.aspx/GetAllAttendanceRequest",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {

                selfatt_html += '<tr>';
                selfatt_html += '<td style="text-wrap: nowrap;text-align:center;">' + blankForNull((index + 1)) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InDate) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InTime) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.OutDate) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.OutTime) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Reason) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.AddedDate) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Approved) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.ApprovedByName) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.ApprovedDate) + '</td>';
                selfatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.RequestRemark) + '</td>';
                selfatt_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#selfatt_table')) {
                selfatt_table.destroy();
            }
            $('#selfatt_table tbody').html(selfatt_html);
            //else
            selfatt_table = $('#selfatt_table').DataTable({
                dom: 'tip',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Attendance Correction Report', autoFilter: true,
                    },
                ],

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

//****************** Self Attendance - END ******************//


//****************** PM Attendance - START ******************//

function getattendancecount(ddl) {
    var code = ddl.options[ddl.selectedIndex].value;
    PageMethods.getAttendanceCount(code, attcount_OnSuccess, attcount_OnError);
    return false;
}

function attcount_OnSuccess(result) {
    if (result >= 4) {
        document.getElementById("pmatt_errmsg").innerHTML = "User has already exceeded maximum number of attendance correction request limit.!";
        $("#pmatt_dverror").modal("show");
    }

    return false;
}

function attcount_OnError(error) {
    alert(error.get_message());
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
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var ddlInDate = document.getElementById("pmatt_indate");
    var indate = ddlInDate.options[ddlInDate.selectedIndex].value;
    var ddlOutDate = document.getElementById("pmatt_outdate");
    var outdate = ddlOutDate.options[ddlOutDate.selectedIndex].value;
    var intime = document.getElementById("pmatt_intime").value;
    var outtime = document.getElementById("pmatt_outtime").value;
    PageMethods.UserLoginGetTotalHours_PM(code, intime, outtime, indate, outdate, pmtotalhour_onsuccess, pmtotalhour_onerror);
}

function pmtotalhour_onsuccess(result) {
    if (result.length < 6) {
        document.getElementById("pmatt_totaltime").value = result;
        document.getElementById("pmatt_totaltime").disabled = true;
    }
    else if (result.includes('Weekly Off')) {
        var strTotalHours = result.split('~');
        document.getElementById("pmatt_totaltime").value = strTotalHours[0];
        document.getElementById("pmweeklyofflabel").style.display = '';
        document.getElementById("pmweeklyofftext").style.display = '';
        document.getElementById("pmweeklyofftext").innerHTML = strTotalHours[2];
    }
    else
        alert(result);
}

function pmtotalhour_onerror(error) {
    alert(error.responseText);
}

function pmatt_submit() {
    var ddluser = document.getElementById("pmatt_user");
    var code = ddluser.options[ddluser.selectedIndex].value;
    var userreason = document.getElementById("pmatt_userreason").value;
    if (userreason == "") {
        alert("Please enter reason");
        return false;
    }
    if (userreason.length < 10) {
        alert("Reason must be more than 10 characters.");
        return false;
    }

    var ddlindate = document.getElementById("pmatt_indate");
    var indate = ddlindate.options[ddlindate.selectedIndex].value;
    var intime = document.getElementById("pmatt_intime").value;
    var ddloutdate = document.getElementById("pmatt_outdate");
    var outdate = ddloutdate.options[ddloutdate.selectedIndex].value;
    var outtime = document.getElementById("pmatt_outtime").value;
    var ddlreason = document.getElementById("pmatt_reason");
    var reasontext = ddlreason.options[ddlreason.selectedIndex].text;
    var reasonvalue = ddlreason.options[ddlreason.selectedIndex].value;
    var totaltime = document.getElementById("pmatt_totaltime").value;
    $('#waitingpanel').modal('show');
    PageMethods.InsertAttendance_PM(code, intime, outtime, indate, outdate, totaltime, reasonvalue, reasontext, userreason, pmattsubmit_onsuccess, pmattsubmit_onerror);
    return false;
}

function pmattsubmit_onsuccess(result) {
    $("#waitingpanel").modal('hide');
    if (result > 0) {
        document.getElementById("pmatt_errmsg").innerHTML = "Attendance correction request raised successfully!";
        $("#pmatt_dverror").modal("show");
    }
    else if (result == 0) {
        document.getElementById("pmatt_errmsg").innerHTML = "Request already exist for selected In Date!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -1) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please select proper logout details!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -2) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please select Out Date!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -3) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please select Out Time!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -4) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please select Out Time Convention!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -5) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please enter login time in 12 hours format!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("pmatt_errmsg").innerHTML = "Technical Error. Please contact support department!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("pmatt_errmsg").innerHTML = "Please select In Time Convention!";
        document.getElementById("pmatt_errmsg").style.color = 'red';
        $('#pmatt_dverror').modal('show');
        return false;
    }
    return false;
}

function pmattsubmit_onerror(error) {
    alert(error.responseText);
}

function pmatt_BindGrid() {
    $('#load1').show();

    pmatt_html = '';
    $.ajax({
        url: "AttendanceCorrectionpm.aspx/GetAllAttendanceRequest",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            var dataArray = JSON.parse(data.d);//
            $.each(dataArray, function (index, value) {
                var addeddate = eval(value.AddedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                var appdate = '';
                if (blankForNull(value.ApprovedDate) != '' && blankForNull(value.ApprovedDate) != null)
                    appdate = eval(value.ApprovedDate.replace(/\/Date\((\d+)\)\//gi, "new Date($1).toLocaleDateString(\"en-US\")"));
                pmatt_html += '<tr>';
                if (blankForNull(value.Approved) == "Pending for approval")
                    pmatt_html += '<td style="text-wrap: nowrap;text-align:center;"><a class="dropdown-item" href="EditAttendanceCorrectionRequest.aspx?AttendanceCorrectRequestID=' + blankForNull(value.AttendanceCorrectRequestID) + '" id="Actions"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                else
                    pmatt_html += '<td style="text-wrap: nowrap;text-align:center;"><a class="dropdown-item isDisabled" href="#!" id="Actions" onclick="AddRemark(' + value.VerID + ',' + index + ',1);"><span style="color: forestgreen;"><i class="uil fs-0 me-2 uil-pen"></i></span></a></td>';
                pmatt_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Code) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InDate) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InTime) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.OutDate) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.OutTime) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Reason) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.AddedDate) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.Approved) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.ApprovedByName) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.ApprovedDate) + '</td>';
                pmatt_html += '<td style="text-wrap: nowrap; ">' + blankForNull(value.RequestRemark) + '</td>';

                pmatt_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#pmatt_table')) {
                pmatt_table.destroy();
            }
            $('#pmatt_table tbody').html(pmatt_html);
            //else
            pmatt_table = $('#pmatt_table').DataTable({
                dom: 'ftipl',
                scrollX: true,
                destroy: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {
                    $('#load1').hide();
                },

                buttons: [
                    {
                        extend: 'excelHtml5', title: 'Attendance Correction Report', autoFilter: true,
                    },


                ],

            });
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
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
                document.getElementById("editatt_user").innerHTML = blankForNull(value.EmpName);
                var date = new Date(value.InDate);
                day = date.getDate();
                if (day < 10)
                    day = '0' + day
                month = date.getMonth() + 1;
                if (month < 10)
                    month = '0' + month
                year = date.getFullYear();
                actualdate = year + "-" + (month) + "-" + (day);
                document.getElementById("editatt_indate").value = blankForNull(actualdate);
                document.getElementById("editatt_intime").value = blankForNull(value.InTime);
                document.getElementById("editatt_reason").innerHTML = blankForNull(value.Reason);
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
                    document.getElementById("editatt_outdate").value = blankForNull(actualdate);
                    document.getElementById("editatt_outtime").value = blankForNull(value.OutTime);
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



                    document.getElementById("editatt_totalhours").innerHTML = getTimeDifference(new Date(0, 0, 0, hours1, minutes1), new Date(0, 0, 0, hours2, minutes2));
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

function editatt_submit() {
    const urlParams = new URLSearchParams(window.location.search);
    const requestid = urlParams.get('AttendanceCorrectRequestID');
    var code = document.getElementById("editatt_user").innerHTML.substring(0, 3);
    var indate = document.getElementById("editatt_indate").value;
    var intime = document.getElementById("editatt_intime").value;
    var outdate = document.getElementById("editatt_outdate").value;
    var outtime = document.getElementById("editatt_outtime").value;
    var remark = document.getElementById("editatt_remark").value;
    var totaltime = document.getElementById("editatt_totalhours").innerHTML;
    var ddlstatus = document.getElementById("editatt_status");
    var status = ddlstatus.options[ddlstatus.selectedIndex].value;
    var ddllocation = document.getElementById("editatt_location");
    var location = ddllocation.options[ddllocation.selectedIndex].value;
    attnEmpUserReason = document.getElementById("editatt_reason").innerHTML
    $("#waitingpanel").modal('show');
    PageMethods.UpdateAttendance_PM(requestid, code, intime, outtime, indate, outdate, totaltime, remark, status, location, attnEmpReasonType, attnEmpUserReason, editatt_OnSuccess, editatt_OnError);
    return false;
}

function editatt_OnSuccess(result) {
    $("#waitingpanel").modal('hide');
    if (result > 0) {
        document.getElementById("editatt_errmsg").innerHTML = "Attendance correction request updated successfully!";
        $("#editatt_dverror").modal("show");
    }
    else if (result == 0) {
        document.getElementById("editatt_errmsg").innerHTML = "Request already exist for selected In Date!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -1) {
        document.getElementById("editatt_errmsg").innerHTML = "Please select proper logout details!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -2) {
        document.getElementById("editatt_errmsg").innerHTML = "Please select Out Date!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -3) {
        document.getElementById("editatt_errmsg").innerHTML = "Please select Out Time!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -4) {
        document.getElementById("editatt_errmsg").innerHTML = "Please select Out Time Convention!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -5) {
        document.getElementById("editatt_errmsg").innerHTML = "Please enter login time in 12 hours format!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("editatt_errmsg").innerHTML = "Technical Error. Please contact support department!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    else if (result == -6) {
        document.getElementById("editatt_errmsg").innerHTML = "Please select In Time Convention!";
        document.getElementById("editatt_errmsg").style.color = 'red';
        $('#editatt_dverror').modal('show');
        return false;
    }
    return false;
}

function editatt_OnError(error) {
    alert(error.responseText);
}

function editatt_gotodashboard() {
    location.href = "AttendanceCorrectionpm.aspx";
}


//Edit Attendance Request - END