let log_table;
let dailyLoginClockTimer = null;
let dailyLoginServerUtcBase = null;
let dailyLoginClockSyncedAt = 0;
let dailyLoginLiveUptoActive = false;
let dailyLoginLiveUptoBaseSeconds = null;
let dailyLoginLiveUptoSyncedAt = null;

function DailyLogin_Init() {
    if (!$("#loginout_main").length) {
        return;
    }

    $("#loginout_btnRefresh").off("click.dailylogin").on("click.dailylogin", function () {
        loginout_BindWorkingDetails(true);
    });

    $("#loginout_tableSearch").off("input.dailylogin").on("input.dailylogin", function () {
        if (log_table) {
            log_table.search(this.value).draw();
        }
    });

    loginout_BindWorkingDetails();
    updateTime();

    if (dailyLoginClockTimer) {
        clearInterval(dailyLoginClockTimer);
    }
    dailyLoginClockTimer = setInterval(updateTime, 1000);
}

function loginout_BindLogDetails(options) {
    const settings = options || {};

    if (!settings.silent) {
        setDailyLoginLoader(true);
    }

    return $.ajax({
        url: "DailyLogin.aspx/GetDailyLogs",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            const dataArray = parseServiceJson(data.d, []);
            renderLoginLogTable(dataArray);
            updateRecordCount(dataArray.length);
        },
        error: function (xhr) {
            showDailyLoginMessage("error", "Unable to load attendance history", getAjaxErrorMessage(xhr));
        },
        complete: function () {
            if (!settings.silent) {
                setDailyLoginLoader(false);
            }
        }
    });
}

function loginout_BindWorkingDetails(isManualRefresh) {
    setDailyLoginLoader(true);
    hideInlineMessage();

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/GetDashboardData",
        data: "{}",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (res) {
            const data = res.d || {};

            syncDailyLoginClock(data.serverUtc);

            if (!data.authorized) {
                $("#loginout_main").hide();
                showDailyLoginMessage("warning", "Access restricted", "You are not authorised to login from ERP.");
                setDailyLoginLoader(false);
                return;
            }

            $("#loginout_main").show();
            populateSummary(data.summary || []);
            handleLoginStatus(data.login || []);

            loginout_BindLogDetails({ silent: true }).always(function () {
                updateLastSync();
                setDailyLoginLoader(false);

                if (isManualRefresh) {
                    showDailyLoginToast("success", "Attendance refreshed");
                }
            });
        },
        error: function (xhr) {
            setDailyLoginLoader(false);
            showDailyLoginMessage("error", "Unable to load attendance", getAjaxErrorMessage(xhr));
        }
    });

    return false;
}

function populateSummary(summary) {
    const item = Array.isArray(summary) && summary.length > 0 ? summary[0] : {};

    setStatValue("#spnTotalDays", item.TotalHours);
    setStatValue("#spnWorking", item.WorkingHours);
    setStatValue("#spnHolidays", item.Holidays);
    setStatValue("#spnPartial", item.Partial);
    setStatValue("#spnLateMark", item.LateMark);
    setStatValue("#spnAbsent", item.Absent);
    setStatValue("#spnWorkingHoliday", item.WorkingHoliday);
}

function updateTime() {
    const currentClock = getDailyLoginClockNow();
    $("#currentTime").text(formatIstTime(currentClock));
    $("#dlClockDate").text(formatIstDate(currentClock) + " IST");
    updateLiveUptoTime(currentClock);
}

function handleLoginStatus(login) {
    const item = Array.isArray(login) && login.length > 0 ? login[0] : {};
    const currentLogin = normalizeDisplayValue(item.CurrentLogin);
    const currentLogout = normalizeDisplayValue(item.CurrentLogOut);
    const uptoTime = normalizeDisplayValue(item.UptoTime);
    const currentClock = getDailyLoginClockNow();

    resetLiveUptoTimer();
    $("#bUptoTime").html('<i class="fas fa-hourglass-half"></i> Upto Time');
    $("#SpnCurrentLogin").text(currentLogin || "NA");
    $("#SpnUptoTime").text(uptoTime || "NA");
    $("#spnNotLoggedOut").hide();

    if (!currentLogin) {
        $("#trBefore").show();
        $("#trAfter, #trAfter2").hide();
        $("#loginout_btnlogin").show();
        $("#loginout_btnlogout").hide();
        setStatusBadge("Ready to login", "closed", "fas fa-circle");
        return;
    }

    $("#trBefore").hide();
    $("#trAfter, #trAfter2").show();
    $("#loginout_btnlogin").hide();
    $("#loginout_btnlogout").show();
    setStatusBadge("Logged in", "in", "fas fa-check-circle");

    if (currentLogout) {
        resetLiveUptoTimer();
        $("#bUptoTime").html('<i class="fas fa-sign-out-alt"></i> Logout Time');
        $("#SpnUptoTime").text(currentLogout);
        $("#loginout_btnlogin").hide();
        $("#loginout_btnlogout").hide();
        setStatusBadge("Logged out", "out", "fas fa-check-double");
        return;
    }

    startLiveUptoTimer(uptoTime, currentLogin, currentClock);
    checkLogoutTime(uptoTime);
}

function checkLogoutTime(uptoTime) {
    const hours = parseDurationHours(uptoTime);

    if (hours > 16) {
        $("#spnNotLoggedOut").show();
        $("#trBefore").show();
        $("#trAfter, #trAfter2").hide();
        $("#loginout_btnlogin").show();
        $("#loginout_btnlogout").hide();
        setStatusBadge("Logout pending", "out", "fas fa-exclamation-circle");
        return true;
    }

    $("#spnNotLoggedOut").hide();
    return false;
}

//--- Login
function loginout_login() {

    Swal.fire({
        title: "Please wait...", text: "Processing your login.", allowOutsideClick: false, allowEscapeKey: false, didOpen: function () {
            Swal.showLoading();
        }
    });

    setActionBusy(true);
    hideInlineMessage();

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/LoginUser",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            const data = parseServiceJson(res.d, {});
            Swal.close();

            if (data.success) {

                showDailyLoginMessage("success", "Login successful", data.message || "You have successfully logged in.",
                    {
                        showConfirmButton: true,
                        confirmButtonText: "OK"
                    }
                ).then(function () {
                  
                    location.reload();
                });

                return;
            }

            setActionBusy(false);
            showInlineMessage(data.message || "Unable to complete login.", "error");
            showDailyLoginMessage("error", "Login failed", data.message || "Unable to complete login.");
        },
        error: function (xhr) {
            Swal.close();
            setActionBusy(false);
            showDailyLoginMessage("error", "Login failed", getAjaxErrorMessage(xhr));
        }
    });

    return false;
}

//--- Logout
function loginout_logout() {

    Swal.fire({
        title: "Please wait...", text: "Processing your logout.", allowOutsideClick: false, allowEscapeKey: false, didOpen: function () {
            Swal.showLoading();
        }
    });

    setActionBusy(true);
    hideInlineMessage();

    $.ajax({
        type: "POST",
        url: "DailyLogin.aspx/LogoutUser",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",

        success: function (res) {
            const data = parseServiceJson(res.d, {});
            Swal.close();
            setActionBusy(false);

            if (data.success) {
                showInlineMessage(data.message || "You have logged out successfully.", "success");
                resetLiveUptoTimer();

                $("#SpnCurrentLogin").text(data.currentLogin || "NA");
                $("#SpnUptoTime").text(data.currentLogout || data.uptoTime || "NA");
                $("#loginout_btnlogin").hide();
                $("#loginout_btnlogout").hide();

                if (data.currentLogout) {
                    $("#bUptoTime").html('<i class="fas fa-sign-out-alt"></i> Logout Time');
                } else {
                    $("#bUptoTime").html('<i class="fas fa-hourglass-half"></i> Upto Time');
                }

                setStatusBadge("Logged out", "out", "fas fa-check-double");

                showDailyLoginMessage(
                    "success",
                    "Logout Successful",
                    data.message || "You have logged out successfully.",
                    {
                        showConfirmButton: true,
                        confirmButtonText: "OK"
                    }
                ).then(function () {
                    loginout_BindWorkingDetails();
                });

                return;
            }

            showInlineMessage(data.message || "Unable to complete logout.", "error");

            showDailyLoginMessage(
                "error",
                "Logout Failed",
                data.message || "Unable to complete logout.",
                {
                    showConfirmButton: true,
                    confirmButtonText: "OK"
                }
            );
        },
        error: function (xhr) {
            Swal.close();
            setActionBusy(false);

            showDailyLoginMessage(
                "error",
                "Logout Failed",
                getAjaxErrorMessage(xhr),
                {
                    showConfirmButton: true,
                    confirmButtonText: "OK"
                }
            );
        }
    });

    return false;
}

function showDailyLoginMessage(icon, title, text, options) {
    return Swal.fire(Object.assign({
        icon: icon,
        title: title,
        text: text,
        confirmButtonText: "OK"
    }, options));
}


/*-------------- Render Function --------------*/
function renderLoginLogTable(dataArray) {
    if ($.fn.DataTable.isDataTable("#loginout_table")) {
        log_table.clear().rows.add(dataArray).draw();
        return;
    }

    const excelButtons = $.fn.dataTable && $.fn.dataTable.Buttons
        ? [{
            extend: "excelHtml5",
            text: '<i class="fas fa-file-excel"></i> Export',
            title: "Daily_Login_Attendance"
        }]
        : [];

    log_table = $("#loginout_table").DataTable({

        data: dataArray,
        dom: "t",
        buttons: excelButtons,
        scrollX: true,
        paging: false,      // Disable pagination
        info: false,        // Optional: Hide "Showing X to Y..."
        autoWidth: false,
        ordering: false,
        processing: true,
        deferRender: true,
        language: {
            emptyTable: "No attendance records found."
        },
        columns: [
            { data: "Date", render: renderPlainText },
            { data: "DayName", render: renderPlainText },
            { data: "InTime", render: renderPlainText },
            { data: "OutTime", render: renderPlainText },
            { data: "ShiftTime", render: renderPlainText },
            { data: "Hours", render: renderPlainText },
            { data: "ExtraHours", render: renderExtraHours },
            { data: "LateMark", render: renderLateMark },
            { data: "Partial", render: renderPartial },
            { data: "ShiftRemark" },
            { data: "LeaveType" },
            { data: "INIP", render: renderPlainText },
            { data: "OutIP", render: renderPlainText }
        ],
        columnDefs: [{
            targets: "_all",
            className: "text-nowrap"
        }],
        rowCallback: function (row, data) {
            log_applyStatusClass(row, data.ShiftRemark);
        },

        drawCallback: function () {
            // updateRecordCount(this.api().rows({ search: "applied" }).count());
        }
    });
}

function renderPlainText(data) {
    return escapeHtml(normalizeDisplayValue(data) || "");
}

function renderExtraHours(data) {
    const value = normalizeDisplayValue(data);

    if (!value || value === "00:00" || value === "0") {
        return "";
    }

    return escapeHtml(value);
}

function renderLateMark(data) {
    const value = normalizeDisplayValue(data);
    const lower = value.toLowerCase();
    const isLate = lower === "yes" || lower === "y" || lower === "true" || lower === "late" || lower === "1";
    const css = isLate ? "dl-badge-warning" : "dl-badge-success";
    // return '<span class="dl-badge ' + css + '">' + escapeHtml(value || "No") + '</span>';
    return escapeHtml(value || "");
}

function renderPartial(data) {
    const value = normalizeDisplayValue(data);
    const lower = value.toLowerCase();
    const isPartial = lower === "yes" || lower === "y" || lower === "true" || lower === "partial" || lower === "1";
    const css = isPartial ? "dl-badge-warning" : "dl-badge-success";
    // return '<span class="dl-badge ' + css + '">' + escapeHtml(value || "No") + '</span>';
    return escapeHtml(value || "");

}

function renderDayStatus(data) {
    const value = normalizeDisplayValue(data);
    const lower = value.toLowerCase();
    let css = "dl-badge-muted";

    if (lower.indexOf("present") >= 0 || lower.indexOf("working") >= 0) {
        css = "dl-badge-success";
    } else if (lower.indexOf("holiday") >= 0 || lower.indexOf("leave") >= 0) {
        css = "dl-badge-info";
    } else if (lower.indexOf("absent") >= 0) {
        css = "dl-badge-danger";
    }

    return '<span class="dl-badge ' + css + '">' + escapeHtml(value || "") + '</span>';
}

function syncDailyLoginClock(serverUtc) {
    if (!serverUtc) {
        return;
    }

    const parsed = new Date(serverUtc);
    if (isNaN(parsed.getTime())) {
        return;
    }

    dailyLoginServerUtcBase = parsed;
    dailyLoginClockSyncedAt = Date.now();
    updateTime();
}

function getDailyLoginClockNow() {
    if (dailyLoginServerUtcBase) {
        return new Date(dailyLoginServerUtcBase.getTime() + (Date.now() - dailyLoginClockSyncedAt));
    }

    return new Date();
}

function formatIstTime(date) {
    try {
        return new Intl.DateTimeFormat("en-GB", {
            timeZone: "Asia/Kolkata",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
            hour12: false
        }).format(date);
    } catch (ex) {
        return date.toTimeString().slice(0, 8);
    }
}

function formatIstDate(date) {
    try {
        return new Intl.DateTimeFormat("en-GB", {
            timeZone: "Asia/Kolkata",
            weekday: "short",
            day: "2-digit",
            month: "short",
            year: "numeric"
        }).format(date);
    } catch (ex) {
        return date.toDateString();
    }
}

function updateLastSync() {
    $("#loginout_lastUpdated").text("Updated " + formatIstTime(getDailyLoginClockNow()) + " IST");
}

function startLiveUptoTimer(uptoTime, currentLogin, currentClock) {
    let baseSeconds = parseDurationSeconds(uptoTime);
    const clock = currentClock || getDailyLoginClockNow();

    if (baseSeconds === null) {
        const loginClock = parseIstLoginClock(currentLogin, clock);
        if (loginClock) {
            baseSeconds = Math.max(0, Math.floor((clock.getTime() - loginClock.getTime()) / 1000));
        }
    }

    dailyLoginLiveUptoActive = true;
    dailyLoginLiveUptoBaseSeconds = baseSeconds === null ? 0 : baseSeconds;
    dailyLoginLiveUptoSyncedAt = clock;
    updateLiveUptoTime(clock);
}

function resetLiveUptoTimer() {
    dailyLoginLiveUptoActive = false;
    dailyLoginLiveUptoBaseSeconds = null;
    dailyLoginLiveUptoSyncedAt = null;
}

function updateLiveUptoTime(currentClock) {
    if (!dailyLoginLiveUptoActive || dailyLoginLiveUptoBaseSeconds === null || !dailyLoginLiveUptoSyncedAt) {
        return;
    }

    const elapsedSeconds = Math.max(0, Math.floor((currentClock.getTime() - dailyLoginLiveUptoSyncedAt.getTime()) / 1000));
    const totalSeconds = dailyLoginLiveUptoBaseSeconds + elapsedSeconds;

    $("#SpnUptoTime").html(formatDurationSecondsHtml(totalSeconds));

    if (totalSeconds > 16 * 60 * 60) {
        $("#spnNotLoggedOut").show();
        setStatusBadge("Logout pending", "out", "fas fa-exclamation-circle");
    }
}

function updateRecordCount(count) {
    const label = count === 1 ? "record" : "records";
    $("#loginout_recordCount").text(count + " attendance " + label);
}

function setStatusBadge(text, state, iconClass) {
    const $badge = $("#loginout_statusBadge");
    $badge
        .removeClass("is-in is-out is-closed")
        .addClass(state === "in" ? "is-in" : state === "out" ? "is-out" : "is-closed")
        .html('<i class="' + iconClass + '"></i><span>' + escapeHtml(text) + '</span>');
}

function setStatValue(selector, value) {
    $(selector).text(normalizeDisplayValue(value) || "0");
}

function setDailyLoginLoader(isVisible) {
    $("#load1").css("display", isVisible ? "flex" : "none");
}

function setActionBusy(isBusy) {
    $("#loginout_btnlogin, #loginout_btnlogout, #loginout_btnRefresh").prop("disabled", isBusy);
}

function showInlineMessage(message, type) {
    const palette = {
        success: { color: "#166534", bg: "#f0fdf4", border: "#bbf7d0", icon: "fas fa-check-circle" },
        error: { color: "#9f1239", bg: "#fff1f2", border: "#fecdd3", icon: "fas fa-exclamation-circle" },
        warning: { color: "#92400e", bg: "#fffbeb", border: "#fde68a", icon: "fas fa-exclamation-triangle" },
        info: { color: "#075985", bg: "#eff6ff", border: "#bfdbfe", icon: "fas fa-info-circle" }
    };
    const style = palette[type] || palette.info;

    $("#dvError")
        .css({ color: style.color, background: style.bg, borderColor: style.border })
        .find("i")
        .attr("class", style.icon);

    $("#lblError").text(message || "");
    $("#dvError").fadeIn(120);
}

function hideInlineMessage() {
    $("#dvError").hide();
    $("#lblError").text("");
}

function showDailyLoginMessage(icon, title, text, options) {
    if (window.Swal && Swal.fire) {
        return Swal.fire($.extend({
            icon: icon || "info",
            title: title || "Information",
            text: text || "",
            confirmButtonText: "OK",
            confirmButtonColor: "#2563eb",
            heightAuto: false
        }, options || {}));
    }

    showInlineMessage(text || title, icon || "info");
    return $.Deferred(function (deferred) {
        deferred.resolve();
    }).promise();
}

function showDailyLoginToast(icon, title) {
    if (window.Swal && Swal.mixin) {
        const toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            timer: 1800,
            timerProgressBar: true,
            heightAuto: false
        });

        toast.fire({
            icon: icon || "info",
            title: title || "Updated"
        });
        return;
    }

    showInlineMessage(title, icon || "info");
}

function parseServiceJson(value, fallback) {
    if (value === null || value === undefined || value === "") {
        return fallback;
    }

    if (typeof value !== "string") {
        return value;
    }

    try {
        return JSON.parse(value);
    } catch (ex) {
        return fallback;
    }
}

function getAjaxErrorMessage(xhr) {
    if (xhr && xhr.responseJSON && xhr.responseJSON.Message) {
        return xhr.responseJSON.Message;
    }

    if (xhr && xhr.responseText) {
        const parsed = parseServiceJson(xhr.responseText, null);
        if (parsed && parsed.Message) {
            return parsed.Message;
        }
    }

    return "Something went wrong. Please try again or contact administrator.";
}

function normalizeDisplayValue(value) {
    if (value === null || value === undefined) {
        return "";
    }

    return String(value).trim();
}

function parseDurationHours(value) {
    const seconds = parseDurationSeconds(value);
    return seconds === null ? 0 : seconds / 3600;
}

function parseDurationSeconds(value) {
    const text = normalizeDisplayValue(value);
    if (!text || text.toUpperCase() === "NA") {
        return null;
    }

    const dayTimeMatch = text.match(/^(\d+)\.(\d{1,2}):(\d{1,2}):(\d{1,2})$/);
    if (dayTimeMatch) {
        return (parseInt(dayTimeMatch[1], 10) * 24 * 60 * 60)
            + (parseInt(dayTimeMatch[2], 10) * 60 * 60)
            + (parseInt(dayTimeMatch[3], 10) * 60)
            + parseInt(dayTimeMatch[4], 10);
    }

    const timeMatch = text.match(/^(\d{1,4}):(\d{1,2})(?::(\d{1,2}))?$/);
    if (timeMatch) {
        return (parseInt(timeMatch[1], 10) * 60 * 60)
            + (parseInt(timeMatch[2], 10) * 60)
            + (parseInt(timeMatch[3] || "0", 10));
    }

    const wordsMatch = text.match(/(\d+)\D+(\d{1,2})/);
    if (wordsMatch) {
        return (parseInt(wordsMatch[1], 10) * 60 * 60)
            + (parseInt(wordsMatch[2], 10) * 60);
    }

    return null;
}

function formatDurationSeconds(totalSeconds) {
    const safeSeconds = Math.max(0, Math.floor(totalSeconds || 0));
    const hours = Math.floor(safeSeconds / 3600);
    const minutes = Math.floor((safeSeconds % 3600) / 60);
    const seconds = safeSeconds % 60;

    return String(hours).padStart(2, "0") + ":"
        + String(minutes).padStart(2, "0") + ":"
        + String(seconds).padStart(2, "0");
}

function formatDurationSecondsHtml(totalSeconds) {
    const safeSeconds = Math.max(0, Math.floor(totalSeconds || 0));
    const hours = Math.floor(safeSeconds / 3600);
    const minutes = Math.floor((safeSeconds % 3600) / 60);
    const seconds = safeSeconds % 60;

    return String(hours).padStart(2, "0") + ":"
        + String(minutes).padStart(2, "0") + ":"
        + '<span class="dl-live-seconds">' + String(seconds).padStart(2, "0") + '</span>';
}

function parseIstLoginClock(currentLogin, currentClock) {
    const text = normalizeDisplayValue(currentLogin);
    const match = text.match(/(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)?/i);

    if (!match) {
        return null;
    }

    const istParts = getIstDateParts(currentClock);
    if (!istParts) {
        return null;
    }

    let hours = parseInt(match[1], 10);
    const minutes = parseInt(match[2], 10);
    const seconds = parseInt(match[3] || "0", 10);
    const meridiem = normalizeDisplayValue(match[4]).toUpperCase();

    if (meridiem === "PM" && hours < 12) {
        hours += 12;
    } else if (meridiem === "AM" && hours === 12) {
        hours = 0;
    }

    let loginUtc = new Date(Date.UTC(istParts.year, istParts.month - 1, istParts.day, hours, minutes, seconds) - (330 * 60 * 1000));

    if (loginUtc.getTime() > currentClock.getTime()) {
        loginUtc = new Date(loginUtc.getTime() - (24 * 60 * 60 * 1000));
    }

    return loginUtc;
}

function getIstDateParts(date) {
    try {
        const parts = new Intl.DateTimeFormat("en-GB", {
            timeZone: "Asia/Kolkata",
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
        }).formatToParts(date);

        const valueByType = {};
        parts.forEach(function (part) {
            valueByType[part.type] = part.value;
        });

        return {
            year: parseInt(valueByType.year, 10),
            month: parseInt(valueByType.month, 10),
            day: parseInt(valueByType.day, 10)
        };
    } catch (ex) {
        return null;
    }
}

function escapeHtml(value) {
    return normalizeDisplayValue(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}
