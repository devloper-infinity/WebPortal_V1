function loginout_BindLogDetails() {
    $('#load1').show();

    html = '';
    $.ajax({
        url: "DailyLogin.aspx/GetDailyLogs",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {

            var dataArray = JSON.parse(data.d);//  

            $.each(dataArray, function (index, value) {
                html += '<tr>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Date) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.InTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OutTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShiftTime) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Hours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ExtraHours) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LateMark) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.Partial) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.ShiftRemark) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.LeaveType) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.INIP) + '</td>';
                html += '<td style="text-wrap: nowrap;">' + blankForNull(value.OutIP) + '</td>';
                html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#loginout_table')) {
                log_table.destroy();
            }
            $('#loginout_table tbody').html(html);
            //else
            log_table = $('#loginout_table').DataTable({
                dom: 't',
                scrollX: true,
                destroy: true,
                "paging": false,
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
            });

            //$('#fnalize tbody').on('click', 'tr', function () {
            //    row = table.row(this).data();
            //});
        },
        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}


function loginout_BindWorkingDetails() {

   // $('#load1').show();

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/GetDashboardData",
        data: '{}',
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (res) {

            // console.log(res);

            var data = res.d;

            if (!data.authorized) {
                $("#loginout_main").hide();
                alert("You are not authorised to login from ERP.");

                return;
            }
            $("#loginout_main").show();
            populateSummary(data.summary);
            handleLoginStatus(data.login);
            loginout_BindLogDetails();

            $('#load1').hide();
        },

        error: function (err) {
            console.log(err);
            $('#load1').hide();
        }
    });

    return false;
}


function populateSummary(summary) {

    if (summary.length > 0) {

        $("#spnTotalDays").text(summary[0].TotalHours);
        $("#spnWorking").text(summary[0].WorkingHours);
        $("#spnHolidays").text(summary[0].Holidays);
        $("#spnPartial").text(summary[0].Partial);
        $("#spnLateMark").text(summary[0].LateMark);
        $("#spnAbsent").text(summary[0].Absent);
        $("#spnWorkingHoliday").text(summary[0].WorkingHoliday);

    }

}

function updateTime() {
    var now = new Date();

    var hours = now.getHours().toString().padStart(2, '0');
    var minutes = now.getMinutes().toString().padStart(2, '0');
    var seconds = now.getSeconds().toString().padStart(2, '0');

    document.getElementById("currentTime").innerHTML =
        hours + ":" + minutes + ":" + seconds;
}


function handleLoginStatus(login) {
    if (login.length == 0) return;

    var CurrentLogin = login[0].CurrentLogin;
    var CurrentLogout = login[0].CurrentLogOut;
    var UptoTime = login[0].UptoTime;

    if (!CurrentLogin) {

        $("#trBefore").show();
        $("#trAfter").hide();

        $("#loginout_btnlogin").show();
        $("#loginout_btnlogout").hide();

    }
    else {

        $("#trBefore").hide();
        $("#trAfter").show();

        $("#SpnCurrentLogin").text(CurrentLogin);
        $("#SpnUptoTime").text(UptoTime);

        $("#loginout_btnlogin").hide();
        $("#loginout_btnlogout").show();
    }

    if (CurrentLogout) {

        $("#bUptoTime").text("Logout time : ");
        $("#SpnUptoTime").text(CurrentLogout);

        $("#loginout_btnlogin").hide();
        $("#loginout_btnlogout").hide();

    }
}

function checkLogoutTime(uptoTime) {

    if (!uptoTime) uptoTime = "00:00";

    var hours = parseInt(uptoTime.split(":")[0]);

    if (hours > 16) {

        $("#spnNotLoggedOut").show();

        $("#trBefore").show();
        $("#trAfter").hide();

        $("#btnLogin").show();
        $("#btnLogout").hide();
        $("#btnDashboard").hide();
    }
    else {

        $("#spnNotLoggedOut").hide();

    }

}

function loginout_login() {
    $("#waitingpanel").modal("show");
    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/LoginUser",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            var data = JSON.parse(res.d);

            if (data.success) {

                location.reload();

            } else {
                $("#waitingpanel").modal("hide");

                $("#dvError").show();
                $("#lblError").text(data.message);
            }
        }
    });
    return false;
}

function loginout_logout() {
    $("#waitingpanel").modal("show");

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/LogoutUser",
        data: '{}',
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {

            var data = JSON.parse(res.d);

            if (data.success) {

                $("#dvError").show();
                $("#lblError").text(data.message).css("color", "green");

                $("#SpnCurrentLogin").text(data.currentLogin || "NA");
                $("#SpnUptoTime").text(data.currentLogout || data.uptoTime || "NA");

                $("#loginout_btnlogin").hide();
                $("#loginout_btnlogout").hide();

                if (data.currentLogout != "")
                    $("#bUptoTime").text("Logout time : ");
                else
                    $("#bUptoTime").text("Upto time : ");
                loginout_BindLogDetails();
                $("#waitingpanel").modal("hide");

            }
            else {

                $("#dvError").show();
                $("#lblError").text(data.message).css("color", "red");

            }

            setTimeout(function () {
                $("#dvError").fadeOut();
            }, 5000);
        },

        error: function (err) {
            console.log(err);
        }
    });

    return false;
}