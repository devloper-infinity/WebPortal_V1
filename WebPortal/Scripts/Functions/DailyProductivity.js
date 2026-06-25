
var prod_table;
var prod_html;
var edittable;
var html;
var Code;
var Applicable;
var UserDomain;
var TempProdID = 0;
var productionAuto_table;
var html_autoProd;
var table_prosMissing;
var detailProd_table;
var dailyProdClockTimer = null;
var dailyProdServerUtcBase = null;
var dailyProdClockSyncedAt = 0;
var dailyProdLiveUptoActive = false;
var dailyProdLiveUptoBaseSeconds = null;
var dailyProdLiveUptoSyncedAt = null;

const prodchkIds = [];
var prodID = 0;


/*----------- Button Submit ----------- */

function submitTempProductivity() {

    var clientorderdate = document.getElementById("clientorderdate").value;
    var date = document.getElementById("date").value;
    var ddlproject = document.getElementById("projects");
    var project = ddlproject.options[ddlproject.selectedIndex].value;
    var ddlprocess = document.getElementById("process");
    var process = ddlprocess.options[ddlprocess.selectedIndex].value;
    var ddlproduct = document.getElementById("producttype");
    var producttype = ddlproduct.options[ddlproduct.selectedIndex].value;
    var production = document.getElementById("production").value;
    var target = document.getElementById("target").value;
    var ddlproductiontype = document.getElementById("productiontype");
    var productiontype = ddlproductiontype.options[ddlproductiontype.selectedIndex].value;

    var ddlhours = document.getElementById("hours");
    var hours = ddlhours.options[ddlhours.selectedIndex].value;

    var ddlminutes = document.getElementById("minutes");
    var minutes = ddlminutes.options[ddlminutes.selectedIndex].value;

    var timespent = hours + '.' + minutes;
    var remark = document.getElementById("remark").value;

    if (clientorderdate == "") {
        alert("Please enter Client Order Date.");
        document.getElementById("clientorderdate").focus();
        return false;
    }
    if (project == "Select") {
        alert("Please enter Date.");
        document.getElementById("date").focus();
        return false;
    }
    if (process == "") {
        alert("Please select Process.");
        document.getElementById("process").focus();
        return false;
    }
    if (producttype == "" && UserDomain == 1) {
        alert("Please enter Product Type.");
        document.getElementById("producttype").focus();
        return false;
    }
    else {
        producttype = 0;
    }

    if (production == "") {
        alert("Please enter Production.");
        document.getElementById("production").focus();
        return false;
    }
    if (hours == "Select") {
        alert("Please select hours from Time Spent.");
        document.getElementById("hours").focus();
        return false;
    }
    if (minutes == "Select") {
        alert("Please select minutes from Time Spent.");
        document.getElementById("minutes").focus();
        return false;
    }
    if (remark == "") {
        alert("Please enter Remark.");
        document.getElementById("remark").focus();
        return false;
    }

    PageMethods.InsertTempProductivity(Code, Applicable, clientorderdate, date, project, process, producttype, production, target, productiontype, timespent, remark, OnSucceed, OnError);
    return false;
}

function SaveProductivity() {

    $.ajax({

        url: "DailyProductivity.aspx/GetActualAndUptoTime", type: "POST", dataType: "json", data: "{Code:'" + Code + "'}", contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                if (value.Eligibility = 1) {

                    var msg = "Productivity for remaining time " + blankForNull(value.ElapsedHours) + " Hours and " + blankForNull(value.ElapsedMinutes) + " Minutes is pending. Would you like to proceed?";

                    if (confirm(msg)) {

                        PageMethods.InsertProductivity(Code, OnSucceed, OnError);
                        BindProdGrid();
                        return false;
                    }
                    else {

                    }
                }
                else {
                    var msg = "Your productivity time and total working hours have exceeded the limit by " + blankForNull(value.ElapsedHours1) + " Hours and " + blankForNull(value.ElapsedMinutes1) + " Minutes";
                }
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    return false;
}

function OnSucceed(result) {

    if (result == 0) {
        document.getElementById("productivity_errmsg").innerHTML = "Daily productivity entry already exists!";
        $('#productivity_dverror').modal('show');
    }
    if (result == 1) {
        document.getElementById("productivity_errmsg").innerHTML = "Productivity added successfully!";
        $('#productivity_dverror').modal('show');
    }
    else if (result == 2) {
        document.getElementById("productivity_errmsg").innerHTML = "Error, Please contact administrator!";
        $('#productivity_dverror').modal('show');
    }
    else if (result == 3) {
        document.getElementById("productivity_errmsg").innerHTML = "Please review your entry — the time logged exceeds the permitted limit.";
        $('#productivity_dverror').modal('show');
    }
    else if (result == 4) {
        document.getElementById("productivity_errmsg").innerHTML = "Productivity for the selected project, process, and date already exists in tracking. Please approve or reject it from the Daily Productivity (Auto) tab.!";
        $('#productivity_dverror').modal('show');
    }
    else if (result == 11) {
        document.getElementById("productivity_errmsg").innerHTML = "All productivity records have been saved successfully!";
        $('#productivity_dverror').modal('show');
    }
    else if (result == 99 || result == -10) {

        document.getElementById("You have not logged in for date '" + document.getElementById("date").value + "' !");
        $('#productivity_dverror').modal('show');
    }
    else {
        document.getElementById("productivity_errmsg").innerHTML = "Error, Please contact administrator!";
        $('#productivity_dverror').modal('show');
    }
    BindTempGrid();
    return false;
}

function OnError(error) {
    alert(error.responseText);
}

function blankForNull(s) {
    return s == "null" || s == null ? "" : s;
}

function syncDailyProdClock(serverUtc) {
    if (!serverUtc) {
        return;
    }

    var parsed = new Date(serverUtc);
    if (isNaN(parsed.getTime())) {
        return;
    }

    dailyProdServerUtcBase = parsed;
    dailyProdClockSyncedAt = Date.now();
}

function getDailyProdClockNow() {
    if (dailyProdServerUtcBase) {
        return new Date(dailyProdServerUtcBase.getTime() + (Date.now() - dailyProdClockSyncedAt));
    }

    return new Date();
}

function ensureDailyProdClockTimer() {
    if (dailyProdClockTimer) {
        return;
    }

    dailyProdClockTimer = setInterval(function () {
        updateDailyProdLiveUptoTime(getDailyProdClockNow());
    }, 1000);
}

function startDailyProdLiveUptoTimer(uptoTime, currentLogin, currentClock) {
    var clock = currentClock || getDailyProdClockNow();
    var baseSeconds = parseDailyProdDurationSeconds(uptoTime);

    if (baseSeconds === null) {
        var loginClock = parseDailyProdIstLoginClock(currentLogin, clock);
        if (loginClock) {
            baseSeconds = Math.max(0, Math.floor((clock.getTime() - loginClock.getTime()) / 1000));
        }
    }

    dailyProdLiveUptoActive = true;
    dailyProdLiveUptoBaseSeconds = baseSeconds === null ? 0 : baseSeconds;
    dailyProdLiveUptoSyncedAt = clock;
    ensureDailyProdClockTimer();
    updateDailyProdLiveUptoTime(clock);
}

function resetDailyProdLiveUptoTimer() {
    dailyProdLiveUptoActive = false;
    dailyProdLiveUptoBaseSeconds = null;
    dailyProdLiveUptoSyncedAt = null;
}

function updateDailyProdLiveUptoTime(currentClock) {
    if (!dailyProdLiveUptoActive || dailyProdLiveUptoBaseSeconds === null || !dailyProdLiveUptoSyncedAt) {
        return;
    }

    var elapsedSeconds = Math.max(0, Math.floor((currentClock.getTime() - dailyProdLiveUptoSyncedAt.getTime()) / 1000));
    var totalSeconds = dailyProdLiveUptoBaseSeconds + elapsedSeconds;
    document.getElementById("dailyprod_tilltimedisplay").innerHTML = formatDailyProdDurationSecondsHtml(totalSeconds);
}

function parseDailyProdDurationSeconds(value) {
    var text = blankForNull(value).toString().trim();
    if (!text || text.toUpperCase() === "NA") {
        return null;
    }

    var dayTimeMatch = text.match(/^(\d+)\.(\d{1,2}):(\d{1,2}):(\d{1,2})$/);
    if (dayTimeMatch) {
        return (parseInt(dayTimeMatch[1], 10) * 24 * 60 * 60)
            + (parseInt(dayTimeMatch[2], 10) * 60 * 60)
            + (parseInt(dayTimeMatch[3], 10) * 60)
            + parseInt(dayTimeMatch[4], 10);
    }

    var timeMatch = text.match(/^(\d{1,4})[:.](\d{1,2})(?:[:.](\d{1,2}))?$/);
    if (timeMatch) {
        return (parseInt(timeMatch[1], 10) * 60 * 60)
            + (parseInt(timeMatch[2], 10) * 60)
            + parseInt(timeMatch[3] || "0", 10);
    }

    var wordsMatch = text.match(/(\d+)\D+(\d{1,2})/);
    if (wordsMatch) {
        return (parseInt(wordsMatch[1], 10) * 60 * 60)
            + (parseInt(wordsMatch[2], 10) * 60);
    }

    return null;
}

function formatDailyProdDurationSecondsHtml(totalSeconds) {
    var safeSeconds = Math.max(0, Math.floor(totalSeconds || 0));
    var hours = Math.floor(safeSeconds / 3600);
    var minutes = Math.floor((safeSeconds % 3600) / 60);
    var seconds = safeSeconds % 60;

    return String(hours).padStart(2, "0") + ":"
        + String(minutes).padStart(2, "0") + ":"
        + '<span class="dp-live-seconds">' + String(seconds).padStart(2, "0") + '</span>';
}

function parseDailyProdIstLoginClock(currentLogin, currentClock) {
    var text = blankForNull(currentLogin).toString().trim();
    var match = text.match(/(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)?/i);

    if (!match) {
        return null;
    }

    var istParts = getDailyProdIstDateParts(currentClock);
    if (!istParts) {
        return null;
    }

    var hours = parseInt(match[1], 10);
    var minutes = parseInt(match[2], 10);
    var seconds = parseInt(match[3] || "0", 10);
    var meridiem = blankForNull(match[4]).toString().toUpperCase();

    if (meridiem === "PM" && hours < 12) {
        hours += 12;
    }
    else if (meridiem === "AM" && hours === 12) {
        hours = 0;
    }

    var loginUtc = new Date(Date.UTC(istParts.year, istParts.month - 1, istParts.day, hours, minutes, seconds) - (330 * 60 * 1000));

    if (loginUtc.getTime() > currentClock.getTime()) {
        loginUtc = new Date(loginUtc.getTime() - (24 * 60 * 60 * 1000));
    }

    return loginUtc;
}

function getDailyProdIstDateParts(date) {
    try {
        var parts = new Intl.DateTimeFormat("en-GB", {
            timeZone: "Asia/Kolkata",
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }).formatToParts(date);

        var valueByType = {};
        parts.forEach(function (part) {
            valueByType[part.type] = part.value;
        });

        return {
            year: parseInt(valueByType.year, 10),
            month: parseInt(valueByType.month, 10),
            day: parseInt(valueByType.day, 10)
        };
    }
    catch (ex) {
        return null;
    }
}

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break;
        }
    }
}


/*----------- Bind Method----------- */

function BindProdInfo() {

    $.ajax({
        url: "DailyProductivity.aspx/GetProdInformation",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            $.each(dataArray, function (index, value) {

                Code = value.Code;
                UserDomain = value.Domain;
                Applicable = value.Applicable;

                var currentLogin = blankForNull(value.CurrentLogin).replace('AM', ' AM').replace('PM', ' PM');
                var currentLogout = blankForNull(value.CurrentLogOut);
                var uptoTime = blankForNull(value.UptoTime);

                syncDailyProdClock(value._ServerUtc);
                document.getElementById("dailyprod_logtinimedisplay").innerHTML = currentLogin;
                document.getElementById("dailyprod_tilltimedisplay").innerHTML = currentLogout || uptoTime;
                document.getElementById("prodCode").innerHTML = value.Code;

                if (currentLogin && !currentLogout) {
                    startDailyProdLiveUptoTimer(uptoTime, currentLogin, getDailyProdClockNow());
                }
                else {
                    resetDailyProdLiveUptoTimer();
                }

                if (value.BreakOut != '')
                    document.getElementById("dailyprod_breakouttimedisplay").innerHTML = 'N/A';
                else
                    document.getElementById("dailyprod_breakouttimedisplay").innerHTML = value.BreakOut;
                if (value.BreakIn != '')
                    document.getElementById("dailyprod_breakintimedisplay").innerHTML = 'N/A';
                else
                    document.getElementById("dailyprod_breakintimedisplay").innerHTML = value.BreakIn;
                if (value.TotalTime != '')
                    document.getElementById("dailyprod_breaktimedisplay").innerHTML = 'N/A';
                else
                    document.getElementById("dailyprod_breaktimedisplay").innerHTML = value.TotalTime;
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function BindProjects(EmpID) {

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProjects", dataType: "json", data: "{EmpID:" + EmpID + "}", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#projects").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })
        }
    });
}

function BindDomain() {

    select = document.getElementById("autoDomain");
    options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }
    $("#autoDomain").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "CreateProfile.aspx/GetAllDomains", dataType: "json", contentType: "application/json",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#autoDomain").append($("<option></option>").val(value.DomainID).html(value.DomainName));
            })
            $("#autoDomain").val(UserDomain);
        }
    });
}

function BindTempGrid() {

    html = '';

    $('#load1').show();

    $.ajax({
        url: "DailyProductivity.aspx/GetTempProductivity", type: "POST", dataType: "json", contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {
                html += '<tr>';
                html += '<td style="text-align:center;font-size:15px;"><a class="dropdown-item" href="#!" id="Actions" onclick="delete_prod(' + blankForNull(value.TempDailyProducvityID) + ');"><span style="color: dodgerblue;"><i class="uil fs-0 me-2 uil-trash"></i></span></a></td>';
                html += '<td>' + value.Date + '</td>';
                html += '<td>' + value.ProjectName + '</td>';
                html += '<td>' + blankForNull(value.ProcessName) + '</td>';
                html += '<td>' + blankForNull(value.ProductType) + '</td>';
                html += '<td>' + blankForNull(value.Target) + '</td>';
                html += '<td>' + blankForNull(value.Production) + '</td>';
                html += '<td>' + blankForNull(value.TimeSpent) + '</td>';
                html += '<td>' + blankForNull(value.ProductionType) + '</td>';
                html += '<td>' + blankForNull(value.ProductionBy) + '</td>';
                html += '<td>' + blankForNull(value.Remark) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Project) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Process) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.ProdcutId) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.ClientOrderDate) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.EmployeeID) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Hours) + '</td>';
                html += '<td style="display:none;">' + blankForNull(value.Minutes) + '</td>';
                html += '</tr>';
            });
            if ($.fn.dataTable.isDataTable('#tempprod')) {
                edittable.destroy();
            }
            $('#tempprod tbody').html(html);

            {
                edittable = $('#tempprod').DataTable({
                    dom: 'RSQr',
                    scrollX: true,
                    destroy: true,
                    paging: false,
                    "autoWidth": true,
                    select: true,
                    processing: true,
                    'select': {
                        'style': 'single'
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    },

                    "rowCallback": function (row, data) {
                        // Cell at index 5 in the row is 'Active'.
                        var val = data[3];
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function BindProdGrid1() {

    prod_html = '';

    $('#load1').show();

    $.ajax({
        url: "DailyProductivity.aspx/GetDailyProductivity", type: "POST", dataType: "json", contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);
            var i = 0;

            $.each(dataArray, function (index, value) {
                i++;
                prod_html += '<tr>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(i) + '</td>';
                /* prod_html += '<td style="text-wrap:nowrap;">' + value.Code + '</td>';*/
                prod_html += '<td style="text-wrap:nowrap;">' + value.Date + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.ClientOrderDate) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + value.ProjectName + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.ProcessName) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.ProductType) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;text-align:center;">' + blankForNull(value.Production) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;text-align:center;">' + blankForNull(value.Target) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.ProductionType) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;text-align:center;">' + blankForNull(value.TimeSpent) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.ProductionBy) + '</td>';
                prod_html += '<td style="text-wrap:nowrap;">' + blankForNull(value.Remark) + '</td>';
                prod_html += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#prod_table')) {
                prod_table.destroy();
            }
            $('#prod_table tbody').html(prod_html);

            {
                prod_table = $('#prod_table').DataTable({
                    dom: 'pt',
                    scrollX: true,
                    destroy: true,
                    paging: true,
                    "autoWidth": true,
                    select: true,
                    processing: true,
                    'select': {
                        'style': 'single'
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    },

                    "rowCallback": function (row, data) {
                        // Cell at index 5 in the row is 'Active'.
                        var val = data[3];
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
}

function BindHoursMinutes() {
    var zeros;
    for (let i = 0; i < 13; i++) {
        if (i < 10) {
            zeros = '0' + i;
        }
        else
            zeros = i;
        $("#hours").append($("<option></option>").val(zeros).html(zeros));
    }

    for (let i = 0; i < 60; i++) {
        if (i < 10) {
            zeros = '0' + i;
        }
        else
            zeros = i;
        $("#minutes").append($("<option></option>").val(zeros).html(zeros));
    }

}

function BindProdGrid() {

    $('#load1').show();

    $.ajax({

        url: "DailyProductivity.aspx/GetDailyProductivity", type: "POST", dataType: "json", contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            detailProd_table_table = $('#table_detailProd').DataTable({
                dom: 'Bftip',
                destroy: true,
                orderCellsTop: true,
                fixedHeader: true,
                scrollX: true,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                filter: true,
                'select': {
                    'style': 'single'
                },
                "serverSide": false,
                "data": dataArray,
                columns: [
                    { data: 'SrNo' },
                    { data: 'Date' },
                    { data: 'ClientOrderDate' },
                    { data: 'ProjectName' },
                    { data: 'ProcessName' },
                    { data: 'ProductType' },
                    { data: 'Production' },
                    { data: 'Target' },
                    { data: 'ProductionType' },
                    { data: 'TimeSpent' },
                    { data: 'ProductionBy' },
                    { data: 'Remark' }
                ],
                fnCreatedRow: function (nRow, aData, iDataIndex) {
                    $(nRow).children("td").css("text-wrap", "nowrap");
                },

                initComplete: function () {
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}


/*----------- On Change ----------- */

function onprojectclick() {
    var select = document.getElementById("process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    var ddlProject = document.getElementById('projects');
    var index = ddlProject.selectedIndex;
    var ProjectID = ddlProject.options[index].value;

    $("#process").append($("<option></option>").val("").html("Select"));

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProcess", dataType: "json", contentType: "application/json",
        data: "{ProjectID:" + ProjectID + "}",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
            })
        }
    });

    var selectprod = document.getElementById("producttype");
    let optionsprod = selectprod.getElementsByTagName('option');

    for (var i = optionsprod.length; i--;) {
        selectprod.removeChild(optionsprod[i]);
    }

    var ProjectName = ddlProject.options[index].text;
    $("#producttype").append($("<option></option>").val("").html("Select"));
    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProductType", dataType: "json", contentType: "application/json",
        data: "{ProjectName:" + ProjectName + "}",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#producttype").append($("<option></option>").val(value.ProductID).html(value.ProductType));
            })
        }
    });

}

function onprocessclick() {
    var ddlproject = document.getElementById("projects");
    var project = ddlproject.options[ddlproject.selectedIndex].value;
    var ddlprocess = document.getElementById("process");
    var process = ddlprocess.options[ddlprocess.selectedIndex].value;

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetTarget", dataType: "json", contentType: "application/json",
        data: "{ProjectId:" + project + ", ProcessId:" + process + "}",
        success: function (res) {

            var target = res.d;
            document.getElementById("target").value = target.substring(0, 5); // parseFloat(res.d).toFixed(2);
        }
    });
}

function onproductclick() {

    var ddlproject = document.getElementById("projects");
    var project = ddlproject.options[ddlproject.selectedIndex].value;
    var ddlprocess = document.getElementById("process");
    var process = ddlprocess.options[ddlprocess.selectedIndex].value;
    var ddlproduct = document.getElementById("producttype");
    var product = ddlproduct.options[ddlproduct.selectedIndex].value;

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetTarget_Search", dataType: "json", contentType: "application/json",
        data: "{ProjectId:" + project + ", ProcessId:" + process + ", Product:" + product + "}",

        success: function (res) {

            var target = res.d;
            document.getElementById("target").value = target.substring(0, 5); // parseFloat(res.d).toFixed(2);
        }
    });
}


/*----------- Delete Productivity ----------- */

function delete_prod(TempDailyProducvityID) {
    TempProdID = TempDailyProducvityID;
    $('#popUpdeletetempProd').modal('show');
}

function deleteProdRecord() {

    if (TempProdID > 0) {
        PageMethods.DeleteTempDailyProductivity(TempProdID, OnSucceed_delete, OnError_Delete);
        return false;
    }
}

function OnSucceed_delete(result) {

    $('#popUpdeletetempProd').modal('hide');

    if (result > 0) {

        alert("Record deleted successfully!");
    }
    else {
        alert("Oops! Error occured while deleting record. Please contact administrator!");
    }

    location.reload();
    return false;
}

function OnError_Delete() {
    alert(error.responseText);
}


/*----------- Edit Productivity ----------- */

function edit_prod(Code, index) {

    $("#btnsubmit").html("Update");

    var row = edittable.row(index).data();

    /*--------- Project ---------*/
    var select = document.getElementById("projects");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProjects", dataType: "json", data: "{EmpID:" + row[16] + "}", contentType: "application/json",
        success: function (data) {

            $.each(data.d, function (index, value) {

                $("#projects").append($("<option></option>").val(value.ProjectID).html(value.ProjectName));
            })

            $("#projects").val(row[10]);
        }
    });

    /*--------- Process ---------*/
    select = document.getElementById("process");
    options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProcess", dataType: "json", data: "{ProjectID:" + row[10] + "}", contentType: "application/json",
        success: function (data) {

            $.each(data.d, function (index, value) {
                //$.each(res.d, function (data, value) {
                $("#process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
            })
            $("#process").val(row[11]);
        }
    });

    /*--------- Product Type ---------*/
    select = document.getElementById("producttype");
    options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProductType", dataType: "json",
        data: "{ProjectName:" + row[10] + "}",
        contentType: "application/json",
        success: function (data) {

            $.each(data.d, function (index, value) {
                $("#producttype").append($("<option></option>").val(value.ProductID).html(value.ProductType));
            })

            $("#producttype").val(row[12]);
        }
    });

    date = new Date(row[13]);
    day = date.getDate();
    if (day < 10)
        day = '0' + day
    month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    year = date.getFullYear();
    actualdate = year + "-" + (month) + "-" + (day);
    $("#clientorderdate").val(actualdate);

    document.getElementById("production").value = row[13];
    document.getElementById("target").value = row[14];
    document.getElementById("remark").value = row[15];
    $("#productiontype").val(row[8]);
    $("#hours").val(row[17]);
    $("#minutes").val(row[18]);

    $('#projects').prop('disabled', true);
    $('#process').prop('disabled', true);
    $('#producttype').prop('disabled', true);
    $('#production').prop('disabled', true);
    $('#target').prop('disabled', true);
    $('#remark').prop('disabled', true);
    $('#productiontype').prop('disabled', true);
    $('#clientorderdate').prop('disabled', true);
    $('#date').prop('disabled', true);

    return false;
}

function Edit(Code, Index) {
    $('#load1').show();
    var row = edittable.row(Index).data();
    var date = new Date(row[2]);
    var day = date.getDate();
    if (day < 10)
        day = '0' + day
    var month = date.getMonth() + 1;
    if (month < 10)
        month = '0' + month
    var year = date.getFullYear();
    var actualdate = year + "-" + (month) + "-" + (day);
    $("#date").val(actualdate);

    var Cdate = new Date(row[13]);
    var Cday = Cdate.getDate();
    if (Cday < 10)
        Cday = '0' + Cday
    var Cmonth = Cdate.getMonth() + 1;
    if (Cmonth < 10)
        Cmonth = '0' + Cmonth
    var Cyear = Cdate.getFullYear();
    var Cactualdate = Cyear + "-" + (Cmonth) + "-" + (Cday);
    $("#clientorderdate").val(Cactualdate);


    /////// Project Dropdown Change - Start
    $("#projects").val(row[10]);

    var select = document.getElementById("process");
    let options = select.getElementsByTagName('option');

    for (var i = options.length; i--;) {
        select.removeChild(options[i]);
    }

    $("#process").append($("<option></option>").val("Select").html("Select"));
    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProcess", dataType: "json", contentType: "application/json",
        data: "{ProjectID:" + row[10] + "}",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#process").append($("<option></option>").val(value.ProcessID).html(value.ProcessName));
            });
            $("#process").val(row[11]);
        }

    });

    var selectprod = document.getElementById("producttype");
    let optionsprod = selectprod.getElementsByTagName('option');

    for (var i = optionsprod.length; i--;) {
        selectprod.removeChild(optionsprod[i]);
    }
    $("#producttype").append($("<option></option>").val("Select").html("Select"));
    $.ajax({
        type: "POST", url: "DailyProductivity.aspx/GetProductType", dataType: "json", contentType: "application/json",
        data: "{ProjectName:" + row[3] + "}",
        success: function (res) {
            $.each(res.d, function (data, value) {
                $("#producttype").append($("<option></option>").val(value.ProductID).html(value.ProductType));
            });
            $("#producttype").val(row[12]);
        }
    });
    $("#target").val(row[14]);
    $("#production").val(row[6]);
    const times = row[7].split(".");
    $("#hours").val(times[0]);
    $("#minutes").val(times[1]);
    $("#productiontype").val(row[8]);
    $("#remark").val(row[15]);
    document.getElementById("btnsubmit").innerHTML = "Update";
    document.getElementById("reset").style.display = '';

    ////////Project Dropdown Change - End

    $('#load1').hide();
}


/*----------- Auto Productivity ----------- */

function BindAutoProd(Date, DomainID) {

    html_autoProd = '';

    $.ajax({
        url: "DailyProductivity.aspx/GetAutoProductivity",
        type: "POST",
        dataType: "json",
        data: "{Date:'" + Date + "',DomainID:" + DomainID + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {

            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                html_autoProd += '<tr>';
                html_autoProd += '<td style="text-align:center;"><input type="checkbox" id=\'' + index + '\'" onchange="return checkProdID(this);"/></td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Date) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Project) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.TrackingProcess) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Process) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Target) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Production) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.TimeSpent) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Approved) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.RejectedRemark) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.TrackingProductionID) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.Code) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.ClientOrderDate) + '</td>';
                html_autoProd += '</tr>';
            });

            if ($.fn.dataTable.isDataTable('#autoProd_table')) {
                productionAuto_table.destroy();
            }
            $('#autoProd_table tbody').html(html_autoProd);

            productionAuto_table = $('#autoProd_table').DataTable({
                dom: 'lfti',
                destroy: true,
                scrollX: false,
                "paging": true,
                "autoWidth": true,
                select: true,
                "ordering": false,
                processing: true,
                'select': {
                    'style': 'single'
                },

                initComplete: function () {

                    jQuery('.dataTable').wrap('<div class="dataTables_scroll" />');
                    $('#load1').hide();
                },
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function BindMissingProcess() {

    $('#load1').show();

    $.ajax({

        url: "DailyProductivity.aspx/GetProcessMissingOrders", type: "POST", dataType: "json", contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);
            if ($.fn.dataTable.isDataTable('#prosMissing_table')) {
                $('#prosMissing_table').DataTable().destroy();



                table_prosMissing = $('#prosMissing_table').DataTable({
                    dom: 'ti',
                    destroy: true,
                    orderCellsTop: true,
                    fixedHeader: true,
                    scrollX: true,
                    "paging": true,
                    "autoWidth": true,
                    select: true,
                    "ordering": false,
                    processing: true,
                    filter: true,
                    'select': {
                        'style': 'single'
                    },
                    "serverSide": false,

                    columns: [
                        { data: 'Date' },
                        { data: 'ClientOrderDate' },
                        { data: 'Project' },
                        { data: 'TrackingProcess' },
                        { data: 'OrderNo' },
                        { data: 'Production' },
                        { data: 'TimeSpent' }
                    ],
                    fnCreatedRow: function (nRow, aData, iDataIndex) {
                        $(nRow).children("td").css("text-wrap", "nowrap");
                    },

                    initComplete: function () {
                        $('#load1').hide();
                    },
                });
            }
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });

    return false;
}

function checkProdID(ID) {

    if (ID.checked) {
        if (!prodchkIds.includes(ID.id)) {

            prodchkIds.push(ID.id);
        }
    }
    else {
        if (prodchkIds.includes(ID.id)) {
            prodchkIds.splice(otherchkIds.indexOf(ID.id), 1);
        }
    }

    return false;
}

function approveProductivity() {

    var Indexes = 0;
    var Code = 0;
    var Date = 0;
    var CDate = 0;
    var Domain = 0;
    var Target = 0;
    var Project = 0;
    var TrackID = 0;
    var Process = 0;
    var TimeSpents = 0;
    var Productions = 0;
    var TrackProcess = 0;
    var prodchk = prodchkIds.length;

    // const timeInputs;
    let totalMinutes = 0;

    var ddlDomain = document.getElementById("autoDomain");
    Domain = ddlDomain.options[ddlDomain.selectedIndex].value;

    if (prodchk > 0) {

        for (let i = 0; i < prodchk; i++) {

            var rows = $('#autoProd_table').DataTable().row(i).data();

            const time = rows[7];

            if (time) {

                const [hours, minutes] = time.split(".").map(Number);
                totalMinutes += (hours * 60) + minutes;
            }

            Indexes = Indexes + ',' + prodchkIds[i];
            Date = Date + "," + rows[1];
            Project = Project + "," + rows[2];
            TrackProcess = TrackProcess + "," + rows[3];
            Process = Process + "," + rows[4];
            Target = Target + "," + rows[5];
            Productions = Productions + "," + rows[6];
            TimeSpents = TimeSpents + "," + rows[7];
            TrackID = TrackID + "," + rows[10];
            Code = Code + "," + rows[11];
            CDate = CDate + "," + rows[12];
        }

        const totalHours = Math.floor(totalMinutes / 60);
        const remainingMinutes = totalMinutes % 60;

        // Format with leading zeros
        const formattedTime = String(totalHours).padStart(2, '0') + ":" + String(remainingMinutes).padStart(2, '0');

        alert(formattedTime);

        $('#Prodwaitingpanel').modal('show');
        document.getElementById("spntext").innerHTML = "System is updating details. Please wait.";

        //PageMethods.ApproveRejectProductivity(Indexes, Domain, Code, Date, CDate, TrackID, Project, TrackProcess, Process, Productions, TimeSpents, Target, OnSuccess_approved, OnError_approved);
        return false;
    }
    else {
        alert("Please select records.");
        return true;
    }
}

function OnSuccess_approved(result) {

    $('#Prodwaitingpanel').modal('hide');

    if (result > 0) {
        alert("Pruductivity approved successfully!");
    }
    else if (result == 2) {
        /*alert("");*/
    }
    else if (result == 3) {
        alert("The total time spent exceeds the specified Upto Time. Please check your inputs.");
    }
    else if (result == -1 || result == -2) {
        alert("The product type  does not match the project. Please contact your reporting manager for clarification.");
    }
    else if (result == -3) {
        alert("Time Spent must be greater than 0.0. Please provide a valid time entry.");
    }
    else if (result == -4) {
        alert("Target not found. Please check the input or selection and try again.");
    }
    else if (result == -5) {
        alert("The process does not match the project. Please contact your reporting manager for clarification.");
    }
    else {
        alert("error approving productivity, Please contact Reporting Manager!");
    }
    location.reload();
    return false;
}

function OnError_approved(error) {

    alert(error.responseText);
}

function showAutoProdData(ID) {

    var autoDate = document.getElementById("autoDate").value;
    var ddlautoDomain = document.getElementById("autoDomain");
    var DomainID = ddlautoDomain.options[ddlautoDomain.selectedIndex].value;

    if (DomainID > 0 && autoDate != "") {
        BindAutoProd(autoDate, DomainID);
    }
}

function BindAutoProductivity1() {

    var autoDate = document.getElementById("autoDate").value;
    var autoDomain = document.getElementById("autoDomain");
    if (autoDomain != "Select") {
        UserDomain = autoDomain.options[autoDomain.selectedIndex].value;
    }

    UserDomain = 1;

    html_autoProd = '';
    productionAuto_table = '';

    $.ajax({
        url: "DailyProductivity.aspx/GetAutoProductivity",
        type: "POST",
        dataType: "json",
        data: "{Date:'" + autoDate + "', DomainID:" + UserDomain + "}",
        contentType: "application/json; charset=utf-8",

        success: function (data) {
            var dataArray = JSON.parse(data.d);

            $.each(dataArray, function (index, value) {

                html_autoProd += '<tr>';
                html_autoProd += '<td style="text-align:center;"><input type="checkbox" id=\'' + index + '\'" onchange="return checkProdID(this);"/></td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Date) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Project) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.TrackingProcess) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Process) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Target) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Production) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.TimeSpent) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.Approved) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;">' + blankForNull(value.RejectedRemark) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.TrackingProductionID) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.Code) + '</td>';
                html_autoProd += '<td style="text-wrap:nowrap;display: none;">' + blankForNull(value.ClientOrderDate) + '</td>';
                html_autoProd += '</tr>';
            });


            if ($.fn.dataTable.isDataTable('#autoProd_table')) {
                /*alert("");*/
                productionAuto_table.destroy();
                //$('#autoProd_table').DataTable().destroy();
            }
            $('#autoProd_table tbody').html(html_autoProd);

            productionAuto_table = $('#autoProd_table').DataTable({
                dom: 'lftip',
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
            });
        },

        error: function (error) {
            alert('error; ' + eval(error));
            alert('error; ' + error.responseText);
        }
    });
    alert(productionAuto_table);

    return false;
}

