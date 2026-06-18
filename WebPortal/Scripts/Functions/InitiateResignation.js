(function (window, document, $) {
    "use strict";

    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    var state = {
        resignationType: ""
    };

    function ready(fn) {
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", fn);
        } else {
            window.setTimeout(fn, 0);
        }
    }

    function blank(value) {
        if (value === null || value === undefined || value === "null") { return ""; }
        return String(value);
    }

    function safe(obj) {
        if (!obj) { return ""; }
        for (var i = 1; i < arguments.length; i++) {
            var key = arguments[i];
            if (Object.prototype.hasOwnProperty.call(obj, key) && obj[key] !== null && obj[key] !== undefined) {
                return obj[key];
            }
        }
        return "";
    }

    function post(method, payload, onSuccess, onError) {
        $.ajax({
            type: "POST",
            url: "InitiateResignation.aspx/" + method,
            data: JSON.stringify(payload || {}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                if (onSuccess) { onSuccess(response.d); }
            },
            error: function (xhr) {
                if (onError) {
                    onError(xhr);
                } else {
                    showMessage("Unable to complete request.", "error");
                }
            }
        });
    }

    function setLoading(show) {
        $("#initiateLoader")
            .toggleClass("is-visible", !!show)
            .attr("aria-hidden", show ? "false" : "true");
        $("#btnStep2Submit").prop("disabled", !!show);
    }

    function showMessage(message, type) {
        $("#initiateMessage")
            .removeClass("success error")
            .addClass(type || "success")
            .text(message)
            .show();
    }

    function parseDate(value) {
        var text = blank(value).trim();
        var match;
        var parts;

        if (!text) { return null; }

        match = /\/Date\((-?\d+)\)\//.exec(text);
        if (match) { return new Date(parseInt(match[1], 10)); }

        if (/^\d{4}-\d{2}-\d{2}/.test(text)) {
            parts = text.substr(0, 10).split("-");
            return new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
        }

        match = /^(\d{1,2})-([A-Za-z]{3})-(\d{4})/.exec(text);
        if (match) {
            var monthName = match[2].substr(0, 1).toUpperCase() + match[2].substr(1, 2).toLowerCase();
            var monthIndex = $.inArray(monthName, months);
            if (monthIndex >= 0) {
                return new Date(parseInt(match[3], 10), monthIndex, parseInt(match[1], 10));
            }
        }

        var parsed = new Date(text);
        if (isNaN(parsed.getTime())) { return null; }
        return parsed;
    }

    function pad2(value) {
        value = String(value);
        return value.length === 1 ? "0" + value : value;
    }

    function displayDate(value) {
        var date = parseDate(value);
        if (!date) { return blank(value); }
        return pad2(date.getDate()) + "-" + months[date.getMonth()] + "-" + date.getFullYear();
    }

    function setText(selector, value) {
        $(selector).text(blank(value) || "-");
    }

    function queryValue(name) {
        var params = new URLSearchParams(window.location.search);
        return params.get(name) || params.get(name.toLowerCase()) || "";
    }

    function resignationIdFromQuery() {
        return queryValue("Resigned") || queryValue("ResignationId") || queryValue("resgnationid") || queryValue("id");
    }

    function normalizeStatus(value) {
        value = blank(value);
        if (value === "Accept" || value === "Accepted" || value === "Approve" || value === "Approved") {
            return "Approve";
        }
        if (value === "Reject" || value === "Rejected") {
            return "Reject";
        }
        return "";
    }

    function fillDetails(row) {
        var name = safe(row, "Name", "FullName");
        var code = safe(row, "Code");
        var employeeText = code && name ? code + " : " + name : (name || code);

        state.resignationType = safe(row, "ResignationType", "ResignedType");

        $("#step2ResignationId").val(safe(row, "ResignationId", "ResignationID"));
        setText("#step2Employee", employeeText);
        setText("#step2Joining", displayDate(safe(row, "JoiningDate")));
        setText("#step2Manager", safe(row, "ReportingManger", "ReportingManager"));
        setText("#step2Department", safe(row, "DepartmentName", "Department"));
        setText("#step2Designation", safe(row, "DesignationName", "Designation"));
        setText("#step2Type", state.resignationType);
        setText("#step2Date", displayDate(safe(row, "ResignationDate", "ResignedDate")));
        setText("#step2LastWorking", displayDate(safe(row, "LastWorkingDate")));
        setText("#step2LastLogin", displayDate(safe(row, "LastLoginDate", "CurrentLogin")));
        setText("#step2Step1Remark", safe(row, "Remark", "PMRemark"));

        $("#step2AttritionCategory").val(safe(row, "AttritionCategory"));
        $("#step2ReceivedThrough").val(safe(row, "ResignationReceivedThrough", "ResignationRecivedTrough"));
        $("#step2Status").val(normalizeStatus(safe(row, "status", "Status")));
        $("#step2Remark").val("");

        toggleDecisionRequirements();
    }

    function loadFinalizeDetails() {
        var resignationId = resignationIdFromQuery();

        if (!resignationId) {
            showMessage("Open this page from a Step 2 resignation record. Missing Resigned query string.", "error");
            $("#btnStep2Submit").prop("disabled", true);
            return;
        }

        setLoading(true);
        post("GetFinalizeDetails", { resignationId: parseInt(resignationId, 10) }, function (row) {
            setLoading(false);
            if (!row || row.Found === false) {
                showMessage("Resignation record was not found.", "error");
                $("#btnStep2Submit").prop("disabled", true);
                return;
            }

            fillDetails(row);
        }, function () {
            setLoading(false);
            showMessage("Unable to load resignation details.", "error");
            $("#btnStep2Submit").prop("disabled", true);
        });
    }

    function isTerminalType() {
        return state.resignationType === "Absconding" || state.resignationType === "Termination";
    }

    function toggleDecisionRequirements() {
        var status = $("#step2Status").val();
        var requiresAttrition = status === "Approve";
        var showReceivedThrough = !isTerminalType();

        $("#step2AttritionCategory").prop("disabled", !requiresAttrition);
        $("#attritionRequired").toggle(requiresAttrition);

        if (!requiresAttrition) {
            $("#step2AttritionCategory").val("");
        }

        $("#step2ReceivedWrap").toggle(showReceivedThrough);
        if (!showReceivedThrough) {
            $("#step2ReceivedThrough").val("");
        }

        $("#btnStep2Submit").html(status === "Reject"
            ? '<i class="fas fa-ban"></i>Reject Resignation'
            : '<i class="fas fa-paper-plane"></i>Submit Decision');
    }

    function submitStep2() {
        var resignationId = $("#step2ResignationId").val();
        var status = $("#step2Status").val();
        var attrition = $("#step2AttritionCategory").val();
        var receivedThrough = $("#step2ReceivedThrough").val();
        var remark = $.trim($("#step2Remark").val());

        if (!resignationId) { showMessage("Resignation record is not loaded.", "error"); return; }
        if (!status) { showMessage("Please select action.", "error"); $("#step2Status").focus(); return; }
        if (status === "Approve" && !attrition) { showMessage("Please select attrition category.", "error"); $("#step2AttritionCategory").focus(); return; }
        if (!isTerminalType() && !receivedThrough) { showMessage("Please select resignation received through.", "error"); $("#step2ReceivedThrough").focus(); return; }
        if (!remark) { showMessage("Please enter Step 2 remark.", "error"); $("#step2Remark").focus(); return; }

        setLoading(true);
        post("SubmitStep2", {
            resgnationid: parseInt(resignationId, 10),
            status: status,
            unitheadremark: remark,
            attritioncategory: attrition,
            resignationreceivedthrough: receivedThrough
        }, function (result) {
            setLoading(false);
            if (parseInt(result, 10) > 0) {
                showMessage("Step 2 decision saved and email sent successfully.", "success");
                window.setTimeout(function () {
                    window.location.href = "Resignation.aspx";
                }, 900);
            } else if (parseInt(result, 10) === -5) {
                showMessage("You have no rights to reject absconding user's resignation. Please contact HR department.", "error");
            } else {
                showMessage("Unable to save Step 2 decision.", "error");
            }
        }, function () {
            setLoading(false);
            showMessage("Unable to save Step 2 decision.", "error");
        });
    }

    function bindEvents() {
        $("#step2Status").on("change", toggleDecisionRequirements);
        $("#btnStep2Submit").on("click", submitStep2);
    }

    function init() {
        bindEvents();
        loadFinalizeDetails();
    }

    ready(init);
})(window, document, window.jQuery);
