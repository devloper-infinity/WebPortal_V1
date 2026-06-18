(function (window, document, $) {
    "use strict";

    var state = {
        employeeId: 0,
        employeeText: "",
        tables: {}
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

    function safe(row) {
        if (!row) { return ""; }
        for (var i = 1; i < arguments.length; i++) {
            var key = arguments[i];
            if (Object.prototype.hasOwnProperty.call(row, key) && row[key] !== null && row[key] !== undefined) {
                return row[key];
            }
        }
        return "";
    }

    function escapeHtml(value) {
        return blank(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function queryValue(name) {
        var lowerName = name.toLowerCase();
        var pairs = window.location.search.replace(/^\?/, "").split("&");

        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i].split("=");
            var key = decodeURIComponent(pair[0] || "").toLowerCase();
            if (key === lowerName) {
                return decodeURIComponent((pair[1] || "").replace(/\+/g, " "));
            }
        }

        return "";
    }

    function post(method, payload, onSuccess, onError) {
        $.ajax({
            type: "POST",
            url: "UsersAppreciationDisplinaryAction.aspx/" + method,
            data: JSON.stringify(payload || {}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                if (onSuccess) { onSuccess(parseRows(response.d)); }
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

    function parseRows(payload) {
        if (!payload) { return []; }
        if ($.isArray(payload)) { return payload; }
        if (typeof payload === "string") {
            try {
                return JSON.parse(payload);
            } catch (e) {
                return [];
            }
        }
        return [];
    }

    function setLoading(show) {
        $("#adLoader")
            .toggleClass("is-visible", !!show)
            .attr("aria-hidden", show ? "false" : "true");
    }

    function showMessage(message, type) {
        $("#adMessage")
            .removeClass("success error")
            .addClass(type || "success")
            .text(message)
            .show();

        window.setTimeout(function () {
            $("#adMessage").fadeOut(150);
        }, 4500);
    }

    function parseDate(value) {
        var text = blank(value).trim();
        var match;

        if (!text) { return null; }

        match = /\/Date\((-?\d+)\)\//.exec(text);
        if (match) { return new Date(parseInt(match[1], 10)); }

        var parsed = new Date(text);
        if (isNaN(parsed.getTime())) { return null; }
        return parsed;
    }

    function formatDate(value) {
        var date = parseDate(value);
        if (!date) { return blank(value); }
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var day = String(date.getDate());
        if (day.length === 1) { day = "0" + day; }
        return day + "-" + months[date.getMonth()] + "-" + date.getFullYear();
    }

    function getActionId(row) {
        return safe(row, "ActionID", "ActionId");
    }

    function titleForType(type) {
        if (type === "Appreciation") { return "Appreciation"; }
        if (type === "PerformanceImprovementPlan") { return "PIP"; }
        return "Warning";
    }

    function statusPill(value) {
        var status = blank(value) || "Open";
        var css = "";
        if (/close/i.test(status)) { css = " closed"; }
        if (/extend/i.test(status)) { css = " extended"; }
        return '<span class="status-pill' + css + '">' + escapeHtml(status) + '</span>';
    }

    function actionButtons(row, allowUpdate) {
        var id = getActionId(row);
        var employee = escapeHtml(safe(row, "Code")) + " : " + escapeHtml(safe(row, "EmployeeName", "Name"));
        var html = '<button type="button" class="btn-ad btn-ad-soft" data-ad-view="' + escapeHtml(id) + '"><i class="fas fa-eye"></i>View</button>';

        if (allowUpdate) {
            html += ' <button type="button" class="btn-ad btn-ad-primary" data-ad-action="' + escapeHtml(id) + '" data-ad-employee="' + employee + '"><i class="fas fa-tasks"></i>Action</button>';
        }

        return html;
    }

    function buildTable(selector, key, rows, type, allowUpdate) {
        var columns = [
            { data: null, orderable: false, render: function (_, __, row) { return actionButtons(row, allowUpdate); } },
            { data: null, render: function (_, __, ___, meta) { return meta.row + 1; } },
            { data: "Code", render: function (value) { return escapeHtml(value); } },
            { data: null, render: function (_, __, row) { return escapeHtml(safe(row, "EmployeeName", "Name")); } },
            { data: "Title", render: function (value) { return escapeHtml(value); } },
            { data: "AddedByName", render: function (value) { return escapeHtml(value); } },
            { data: "AddedDate", render: function (value) { return escapeHtml(formatDate(value)); } }
        ];

        if (allowUpdate) {
            columns.push({ data: "Period", render: function (value) { return escapeHtml(value); } });
            columns.push({ data: "WarningStatus", render: function (value) { return statusPill(value); } });
            columns.push({ data: "PMRemark", className: "wrap", render: function (value) { return escapeHtml(value); } });
        }

        if ($.fn.dataTable.isDataTable(selector)) {
            $(selector).DataTable().clear().destroy();
            $(selector + " tbody").empty();
        }

        state.tables[key] = $(selector).DataTable({
            data: rows,
            columns: columns,
            destroy: true,
            autoWidth: false,
            paging: true,
            processing: true,
            order: [],
            dom: "Bfrtip",
            buttons: [
                {
                    extend: "excelHtml5",
                    title: titleForType(type)
                },
                {
                    extend: "print",
                    title: titleForType(type)
                }
            ],
            language: {
                emptyTable: "No records found"
            }
        });
    }

    function loadProfile() {
        post("GetEmployeeProfile", { EmployeeID: state.employeeId }, function (rows) {
            var row = rows.length ? rows[0] : {};
            var name = safe(row, "FullName", "Name");
            var code = safe(row, "Code");
            state.employeeText = code && name ? code + " : " + name : (name || code);

            $("#adEmployeeName").text(state.employeeText || "-");
            $("#adHeroSubtitle").text(state.employeeText || "Employee action history and warning status management.");
            $("#adJoiningDate").text(formatDate(safe(row, "JoiningDate")) || "-");
            $("#adDepartment").text(safe(row, "DepartmentName") || "-");
            $("#adManager").text(safe(row, "ReportingManager") || "-");
        });
    }

    function loadActions(type, selector, key, countSelector, allowUpdate) {
        post("GetActions", { EmployeeID: state.employeeId, Type: type }, function (rows) {
            $(countSelector).text(rows.length);
            buildTable(selector, key, rows, type, allowUpdate);
        });
    }

    function loadAll() {
        setLoading(true);
        loadProfile();
        loadActions("Appreciation", "#tblAppreciation", "appreciation", "#countAppreciation", false);
        loadActions("DisciplinaryAction", "#tblDisciplinary", "disciplinary", "#countDisciplinary", true);
        loadActions("PerformanceImprovementPlan", "#tblPip", "pip", "#countPip", true);
        window.setTimeout(function () { setLoading(false); }, 500);
    }

    function openActionModal(actionId, employeeText) {
        $("#adActionId").val(actionId);
        $("#adActionEmployee").text(employeeText || state.employeeText || "-");
        $("#adWarningStatus").val("");
        $("#adPeriod").val("");
        $("#adActionRemark").val("");
        $("#adPeriodWrap").hide();
        $("#adActionModal").modal("show");
    }

    function submitAction() {
        var status = $("#adWarningStatus").val();
        var period = $("#adPeriod").val();

        if (!status) {
            showMessage("Please select action.", "error");
            $("#adWarningStatus").focus();
            return;
        }

        if (status === "Extend" && !period) {
            showMessage("Please select period.", "error");
            $("#adPeriod").focus();
            return;
        }

        setLoading(true);
        postRaw("UpdateWarningStatus", {
            ActionID: parseInt($("#adActionId").val(), 10),
            WarningStatus: status,
            Period: status === "Extend" ? period : "",
            Remark: $("#adActionRemark").val()
        }, function (result) {
            setLoading(false);
            $("#adActionModal").modal("hide");
            if (parseInt(result, 10) > 0) {
                showMessage("Data saved successfully.", "success");
                loadActions("DisciplinaryAction", "#tblDisciplinary", "disciplinary", "#countDisciplinary", true);
                loadActions("PerformanceImprovementPlan", "#tblPip", "pip", "#countPip", true);
            } else {
                showMessage("Error saving data.", "error");
            }
        }, function () {
            setLoading(false);
            showMessage("Error saving data.", "error");
        });
    }

    function postRaw(method, payload, onSuccess, onError) {
        $.ajax({
            type: "POST",
            url: "UsersAppreciationDisplinaryAction.aspx/" + method,
            data: JSON.stringify(payload || {}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                if (onSuccess) { onSuccess(response.d); }
            },
            error: onError
        });
    }

    function openDetails(actionId) {
        setLoading(true);
        post("GetActionDescription", { ActionID: parseInt(actionId, 10) }, function (rows) {
            setLoading(false);
            if (!rows.length) {
                showMessage("Details not found.", "error");
                return;
            }

            var row = rows[0];
            $("#adLetterCode").text(safe(row, "Code", "ReceipentCode") || "-");
            $("#adLetterName").text(safe(row, "Name", "Receipent") || "-");
            $("#adLetterJoining").text(formatDate(safe(row, "JoiningDate")) || "-");
            $("#adLetterLocation").text(safe(row, "BranchName") || "-");
            $("#adLetterDate").html("<strong>Date:</strong> " + escapeHtml(safe(row, "dateOnly", "AddedDate")));
            $("#adLetterSubject").text("Subject : " + safe(row, "Type1", "Type") + " - " + safe(row, "Title"));
            $("#adLetterRecipient").text("Hello " + safe(row, "Receipent", "Name") + ",");
            $("#adLetterDescription").html(blank(safe(row, "Remark", "Description")));
            $("#adDetailModal").modal("show");
        }, function () {
            setLoading(false);
            showMessage("Unable to load details.", "error");
        });
    }

    function printDetails() {
        var content = document.getElementById("adLetter").innerHTML;
        var printWindow = window.open("", "", "height=800,width=900");
        printWindow.document.write("<html><head><title>Action Details</title></head><body>");
        printWindow.document.write(content);
        printWindow.document.write("</body></html>");
        printWindow.document.close();
        window.setTimeout(function () {
            printWindow.print();
        }, 300);
    }

    function bindEvents() {
        $("#adWarningStatus").on("change", function () {
            $("#adPeriodWrap").toggle($(this).val() === "Extend");
        });

        $("#btnAdActionSubmit").on("click", submitAction);
        $("#btnAdPrint").on("click", printDetails);

        $("#tblAppreciation, #tblDisciplinary, #tblPip").on("click", "[data-ad-view]", function () {
            openDetails($(this).attr("data-ad-view"));
        });

        $("#tblDisciplinary, #tblPip").on("click", "[data-ad-action]", function () {
            openActionModal($(this).attr("data-ad-action"), $(this).attr("data-ad-employee"));
        });
    }

    function activateInitialTab() {
        var hash = window.location.hash;
        var link;

        if (!hash) { return; }

        link = $("#adTabs a").filter(function () {
            return this.getAttribute("href") === hash;
        });

        if (link.length && $.fn.tab) {
            link.tab("show");
        }
    }

    function init() {
        state.employeeId = parseInt(queryValue("EmployeeID"), 10) || 0;
        bindEvents();
        activateInitialTab();

        if (!state.employeeId) {
            showMessage("Employee record was not supplied.", "error");
            return;
        }

        loadAll();
    }

    ready(init);
})(window, document, window.jQuery);
