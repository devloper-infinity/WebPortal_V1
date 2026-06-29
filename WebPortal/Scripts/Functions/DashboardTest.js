
(function (window, $) {
    "use strict";

    if (!$ || !/DashboardTest\.aspx/i.test(window.location.pathname)) {
        return;
    }

    var dashboardTestPage = "DashboardTest.aspx";

    function rewriteDashboardUrl(url) {
        if (typeof url !== "string") {
            return url;
        }

        return url.replace(/(^|\/)DashboardEmployee\.aspx\//i, "$1" + dashboardTestPage + "/");
    }

    $.ajaxPrefilter(function (options) {
        if (options && options.url) {
            options.url = rewriteDashboardUrl(options.url);
        }
    });

    function cleanText(value) {
        if (value === null || typeof value === "undefined" || value === "null") {
            return "";
        }

        return String(value);
    }

    function htmlEncode(value) {
        return $("<div/>").text(cleanText(value)).html();
    }

    function jsString(value) {
        return cleanText(value)
            .replace(/\\/g, "\\\\")
            .replace(/'/g, "\\'")
            .replace(/\r?\n/g, " ");
    }

    function safeKey(value, fallback) {
        var key = cleanText(value || fallback || "item");
        return key.replace(/[^A-Za-z0-9_-]/g, "_");
    }

    function notify(icon, title, text) {
        if (window.Swal && typeof window.Swal.fire === "function") {
            window.Swal.fire({
                icon: icon,
                title: title,
                text: text || "",
                timer: icon === "success" ? 1700 : undefined,
                showConfirmButton: icon !== "success"
            });
            return;
        }

        window.alert(text ? title + "\n" + text : title);
    }

    function celebrationBurst() {
        if (typeof window.confetti !== "function") {
            return;
        }

        window.confetti({
            particleCount: 70,
            spread: 64,
            origin: { y: 0.62 }
        });
    }

    var projectAlerts = [];
    var projectAlertIndex = 0;
    var projectAlertCallback = null;

    function completeProjectAlerts() {
        var callback = projectAlertCallback;
        projectAlertCallback = null;

        $("#dash_projectNotifications")
            .off("hidden.bs.modal.dashboardTestProject")
            .modal("hide");

        if (typeof callback === "function") {
            callback();
        }
    }

    function showProjectAlert() {
        if (projectAlertIndex >= projectAlerts.length) {
            completeProjectAlerts();
            return;
        }

        var item = projectAlerts[projectAlertIndex] || {};
        var $modal = $("#dash_projectNotifications");

        $("#prjN_alertTitle").text(item.Subject || "Project Alert");
        $("#prjN_alertMessage").text(item.Message || "");

        if (item.Attachment && String(item.Attachment).trim() !== "") {
            $("#prjN_attachmentDiv").show();
            $("#prjN_downloadFile").attr("href", item.Attachment);
        }
        else {
            $("#prjN_attachmentDiv").hide();
        }

        $modal
            .off("hidden.bs.modal.dashboardTestProject")
            .one("hidden.bs.modal.dashboardTestProject", completeProjectAlerts)
            .modal("show");
    }

    function markProjectAlertRead(alertId) {
        if (!alertId) {
            return;
        }

        $.ajax({
            type: "POST",
            url: "DashboardEmployee.aspx/UpdateProjectReadAlertStatus",
            data: JSON.stringify({ AlertID: alertId }),
            contentType: "application/json; charset=utf-8"
        });
    }

    window.dash_loadUserProjectNotifications = function (callback) {
        projectAlertCallback = callback;

        $.ajax({
            type: "POST",
            url: "DashboardEmployee.aspx/GetDashboardProjectAlerts",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                try {
                    projectAlerts = typeof res.d === "string" ? JSON.parse(res.d || "[]") : (res.d || []);
                }
                catch (ex) {
                    projectAlerts = [];
                }

                projectAlertIndex = 0;

                if (projectAlerts.length === 0) {
                    completeProjectAlerts();
                    return;
                }

                showProjectAlert();
            },
            error: function () {
                completeProjectAlerts();
            }
        });
    };

    window.showNextAlert = showProjectAlert;
    window.test_showNextAlert = showProjectAlert;

    window.goToNextAlert = function (e) {
        if (e && typeof e.preventDefault === "function") {
            e.preventDefault();
        }

        var item = projectAlerts[projectAlertIndex] || {};
        markProjectAlertRead(item.AlertId);
        projectAlertIndex++;
        showProjectAlert();
        return false;
    };

    $(function () {
        document.body.classList.add("dashboard-test-body");
        $(".dashboard-main-page").addClass("dashboard-test-shell");

        $("#birthdayModal, #dash_birthdayModal_all, #dash_anniversaryModal")
            .off("shown.bs.modal.dashboardTest")
            .on("shown.bs.modal.dashboardTest", celebrationBurst);
    });

    window.dash_ownBirthday = function (callback) {
        $.ajax({
            type: "POST",
            url: "DashboardEmployee.aspx/CheckBirthday",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                var data = res && res.d ? res.d : {};

                if (!data || data.IsBirthday !== true) {
                    callback();
                    return;
                }

                $("#lblBirthdayName").text(data.FirstName || data.Name || "");

                $("#birthdayModal")
                    .modal("show")
                    .off("hidden.bs.modal.dashboardTest")
                    .one("hidden.bs.modal.dashboardTest", function () {
                        callback();
                    });
            },
            error: function () {
                callback();
            }
        });
    };

    window.dash_renderBirthdayPopup = function (data) {
        if (!data || data.length === 0) {
            return;
        }

        var html = "";

        $.each(data, function (index, emp) {
            var employeeId = cleanText(emp.EmployeeID || emp.Code || index);
            var code = cleanText(emp.Code || employeeId);
            var key = safeKey(employeeId, index);
            var name = cleanText(emp.Name || emp.EmpName || "Team Member");
            var metaParts = [emp.Code, emp.BranchName, emp.DepartmentName].filter(function (item) {
                return cleanText(item) !== "";
            });

            html += "<div class=\"birthday-card dashboard-test-birthday-card d-flex flex-column mb-3\">";
            html += "  <div class=\"d-flex align-items-center justify-content-between flex-wrap\" style=\"gap:12px;\">";
            html += "    <div class=\"d-flex align-items-center\" style=\"min-width:0;\">";
            html += "      <div class=\"cake-avatar dashboard-test-birthday-avatar mr-3\"><i class=\"fas fa-birthday-cake\"></i></div>";
            html += "      <div style=\"min-width:0;\">";
            html += "        <div class=\"emp-name\">" + htmlEncode(name) + "</div>";
            html += "        <div class=\"emp-meta dashboard-test-birthday-meta\">" + htmlEncode(metaParts.join(" | ")) + "</div>";
            html += "      </div>";
            html += "    </div>";
            html += "    <button type=\"button\" class=\"btn btn-wish dashboard-test-wish-btn\" onclick=\"return dash_toggleWishBox('" + jsString(key) + "')\">";
            html += "      <i class=\"fas fa-pen-nib mr-1\"></i> Wish";
            html += "    </button>";
            html += "  </div>";
            html += "  <div id=\"wishBox_" + htmlEncode(key) + "\" class=\"wish-box mt-3\" style=\"display:none;\">";
            html += "    <input type=\"text\" class=\"form-control mb-2\" maxlength=\"250\" placeholder=\"Write your birthday wish\" id=\"msg_" + htmlEncode(key) + "\" />";
            html += "    <button type=\"button\" class=\"btn btn-sm btn-success\" onclick=\"return dash_sendWish('" + jsString(code) + "', '" + jsString(key) + "', this)\">Send Wish</button>";
            html += "  </div>";
            html += "</div>";
        });

        $("#dash_birthdayList").html(html);
    };

    window.dash_toggleWishBox = function (empId) {
        $(".wish-box").not("#wishBox_" + empId).slideUp(140);
        $("#wishBox_" + empId).slideToggle(140);
        return false;
    };

    window.dash_sendWish = function (empId, keyOrButton, maybeButton) {
        var key = typeof keyOrButton === "string" ? keyOrButton : safeKey(empId);
        var button = maybeButton || keyOrButton;
        var message = cleanText($("#msg_" + key).val()).trim();

        if (!message) {
            notify("warning", "Message required", "Please enter a birthday wish.");
            return false;
        }

        $.ajax({
            type: "POST",
            url: "DashboardEmployee.aspx/SendWish",
            data: JSON.stringify({ toUserId: empId, message: message }),
            contentType: "application/json; charset=utf-8",
            success: function () {
                $(button).html("<i class=\"fas fa-check mr-1\"></i> Sent").prop("disabled", true);
                $("#wishBox_" + key).slideUp(140);
                notify("success", "Wish sent", "Your birthday wish has been saved.");
            },
            error: function () {
                notify("error", "Unable to send", "Please try again.");
            }
        });

        return false;
    };

    window.renderWorkAnniversary = function (data, callback) {
        if (!data || data.length === 0) {
            callback();
            return;
        }

        var firstYears = parseInt(data[0].YearsCompleted, 10) || 0;
        var firstJubilee = typeof window.getJubileeDetails === "function" ? window.getJubileeDetails(firstYears) : null;
        var header = firstJubilee && firstJubilee.title ? "Work Anniversary - " + firstJubilee.title : "Work Anniversary";
        var html = "";

        $("#workAnn_header").html("<i class=\"fas fa-award mr-2\"></i>" + htmlEncode(header));

        $.each(data, function (index, emp) {
            var years = parseInt(emp.YearsCompleted, 10) || 0;
            var jubilee = typeof window.getJubileeDetails === "function" ? window.getJubileeDetails(years) : null;
            var message = jubilee && jubilee.message
                ? jubilee.message
                : (typeof window.getAnniversaryMessage === "function" ? window.getAnniversaryMessage(years) : "Thank you for your dedication and contribution.");

            html += "<div class=\"employees-card premium-card\">";
            html += "  <div class=\"company-logo\"><i class=\"fas fa-medal\"></i></div>";
            html += "  <div class=\"emps-name\">" + htmlEncode(emp.EmpName) + "</div>";
            html += "  <div class=\"emp-designation\">" + htmlEncode(emp.Designation) + "</div>";
            html += "  <div class=\"emp-years\">" + htmlEncode(years) + " Years of Excellence</div>";
            html += "  <div class=\"anniversary-msg\">" + htmlEncode(message) + "</div>";
            html += "</div>";
        });

        $("#dash_anniversaryContainer").html(html);
        $("#dash_anniversaryModal")
            .modal("show")
            .off("hidden.bs.modal.dashboardTest")
            .one("hidden.bs.modal.dashboardTest", function () {
                callback();
            });

        if (typeof window.startConfetti === "function") {
            window.startConfetti();
        }
        else {
            celebrationBurst();
        }
    };
}(window, window.jQuery));
