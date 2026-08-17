(function (window, document, $) {
    "use strict";

    var state = { table: null, details: null };

    function api(method, payload) {
        return $.ajax({
            type: "POST",
            url: "ApproveSalaryStructure.aspx/" + method,
            data: JSON.stringify(payload || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).then(function (response) { return response.d; });
    }

    function loading(visible) {
        $("#salaryLoading").toggleClass("is-visible", !!visible);
    }

    function safe(row) {
        if (!row) { return ""; }
        for (var i = 1; i < arguments.length; i++) {
            var key = arguments[i];
            if (row[key] !== null && row[key] !== undefined) { return row[key]; }
        }
        return "";
    }

    function escapeHtml(value) {
        return String(value === null || value === undefined ? "" : value)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;").replace(/'/g, "&#39;");
    }

    function number(value) {
        var parsed = parseFloat(value);
        return isNaN(parsed) ? 0 : parsed;
    }

    function integer(value) {
        var parsed = number(value);
        return parsed < 0 ? Math.ceil(parsed) : Math.floor(parsed);
    }

    function money(value) {
        //return "₹" + integer(value).toLocaleString("en-IN");
        return integer(value).toLocaleString("en-IN");
    }

    function displayDate(value) {
        if (!value) { return "--"; }
        var match = /\/Date\((\d+)\)\//.exec(String(value));
        var date = match ? new Date(parseInt(match[1], 10)) : new Date(value);
        if (isNaN(date.getTime())) { return escapeHtml(value); }
        return date.toLocaleDateString("en-GB", { day: "2-digit", month: "short", year: "numeric" });
    }

    function alertError(message) {
        return Swal.fire({ icon: "error", title: "Unable to continue", text: message, confirmButtonColor: "#2563eb" });
    }

    function alertWarning(message) {
        return Swal.fire({ icon: "warning", title: "Check the details", text: message, confirmButtonColor: "#2563eb" });
    }

    function loadPendingApprovals() {
        loading(true);
        api("GetPendingSalaryApprovals").done(function (rows) {
            rows = rows || [];
            $("#pendingCount").text(rows.length);
            renderTable(rows);
        }).fail(function () {
            alertError("Pending salary approvals could not be loaded.");
        }).always(function () { loading(false); });
    }

    function renderTable(rows) {
        if (state.table) {
            state.table.destroy();
            $("#salaryApprovalTable tbody").empty();
        }

        state.table = $("#salaryApprovalTable").DataTable({
            data: rows,
            responsive: false,
            autoWidth: false,
            pageLength: 10,
            order: [[2, "asc"]],
            language: { emptyTable: "No employee profiles are pending for salary approval." },
            columns: [
                { data: null, render: function (d, t, row) { return '<span class="salary-code">' + escapeHtml(safe(row, "Code")) + '</span>'; } },
                { data: null, render: function (d, t, row) { return escapeHtml(safe(row, "EmployeeName", "Name")); } },
                { data: null, render: function (d, t, row) { return displayDate(safe(row, "JoiningDate")); } },
                { data: null, render: function (d, t, row) { return '<span class="salary-money">' + money(safe(row, "Salary")) + '</span>'; } },
                { data: null, render: function (d, t, row) { return escapeHtml(safe(row, "CompanyName", "Company")); } },
                { data: null, render: function (d, t, row) { return escapeHtml(safe(row, "BranchName", "WorkingBranchName")); } },
                { data: null, render: function (d, t, row) { return escapeHtml(safe(row, "DepartmentName", "Department")); } },
                { data: null, render: function (d, t, row) { return escapeHtml(safe(row, "ReportingManager")); } },
                { data: null, orderable: false, searchable: false, render: function (d, t, row) { return '<button type="button" class="salary-btn salary-btn-primary salary-btn-sm js-review-salary" data-code="' + escapeHtml(safe(row, "Code")) + '"><i class="fas fa-calculator"></i> Review</button>'; } }
            ]
        });
    }

    function openReview(code) {
        loading(true);
        api("GetSalaryApprovalDetails", { code: code }).done(function (details) {
            if (!details || !details.Success) {
                alertError(details && details.Message ? details.Message : "Salary details could not be calculated.");
                return;
            }
            state.details = details;
            populateReview(details);
            $("#salaryReviewWorkspace").addClass("is-open");
            window.setTimeout(function () {
                document.getElementById("salaryReviewWorkspace").scrollIntoView({ behavior: "smooth", block: "start" });
            }, 50);
        }).fail(function () {
            alertError("Employee salary details could not be loaded.");
        }).always(function () { loading(false); });
    }

    function populateReview(details) {
        var parts = String(details.Name || "").trim().split(/\s+/);
        var initials = parts.length > 1 ? parts[0].charAt(0) + parts[parts.length - 1].charAt(0) : String(details.Code || "--").substring(0, 2);
        $("#employeeInitials").text(details.Code); /* text(initials.toUpperCase()); */
        $("#employeeName").text(details.Name || "--");
        // $("#employeeCode").text(details.Code || "--");
        $("#employeeType").text(details.EmployeeType || "--");
        $("#employeeGross").text(money(details.GrossSalary) + (details.OriginalSalary < 7911 ? " (original " + money(details.OriginalSalary) + ")" : ""));
        $("#employeeBranch").text(details.Branch || "--");
        $("#employeeDepartment").text(details.Department || "--");
        $("#employeeManager").text(details.ReportingManager || "--");
        $("#employeeCutoff").text(details.CutOffTime || "--");
        $("#valueBasic").text(money(details.Basic));
        $("#valueESI").text(money(details.ESI));
        $("#valuePF").text(money(details.PF));
        $("#valuePT").text(money(details.ProfessionalTax));
        $("#valueTotalDeduction").text(money(details.TotalDeduction));
        $("#valueDays").text(details.DaysInMonth || "--");

        $("#attendanceApplicable,#attendanceType,#qualityApplicable").val("Select");
        $("#attendanceAmount,#qualityAmount").val("");
        $("#extraDays").val("No");
        $("#esiApplicable").val(details.ESIApplicable ? "Yes" : "No").prop("disabled", !details.ESIApplicable);
        $("#pfApplicable").val(details.PFApplicable ? "Yes" : "No").prop("disabled", !details.PFApplicable);
        $("#nightApplicable").val(details.NightBonusApplicable ? "Yes" : "No");
        $("#nightAmount").val(details.NightBonus);
        toggleConditionalFields();
        recalculate();
    }

    function toggleConditionalFields() {
        var attendance = $("#attendanceApplicable").val() === "Yes";
        var attendanceType = attendance && $("#attendanceType").val() !== "Select";
        $("#attendanceTypeField").toggleClass("is-visible", attendance);
        $("#attendanceAmountField").toggleClass("is-visible", attendanceType);
        $("#qualityAmountField").toggleClass("is-visible", $("#qualityApplicable").val() === "Yes");
        $("#nightAmountField").toggleClass("is-visible", $("#nightApplicable").val() === "Yes");
        $("#attendanceAmountLabel").text($("#attendanceType").val() === "Percentage" ? "Attendance Bonus Percentage" : "Attendance Bonus Amount");
    }

    function attendanceActual() {
        if ($("#attendanceApplicable").val() !== "Yes") { return 0; }
        var value = number($("#attendanceAmount").val());
        return $("#attendanceType").val() === "Percentage" ? (value * number(state.details.GrossSalary)) / 100 : value;
    }

    function recalculate() {
        if (!state.details) { return; }
        var attendance = attendanceActual();
        var quality = $("#qualityApplicable").val() === "Yes" ? number($("#qualityAmount").val()) : 0;
        var hra = number(state.details.HRA) - attendance - quality;
        var night = $("#nightApplicable").val() === "Yes" ? number($("#nightAmount").val()) : 0;
        $("#attendanceActual").text("Actual allocation: " + money(attendance));
        $("#valueHRA").text(money(hra)).data("value", integer(hra));
        $("#valueNetSalary").text(money(number(state.details.NetSalary) + night));
    }

    function validateReview() {
        if ($("#attendanceApplicable").val() === "Yes") {
            if ($("#attendanceType").val() === "Select") { alertWarning("Select the attendance bonus type."); return false; }
            if ($("#attendanceAmount").val() === "" || number($("#attendanceAmount").val()) < 0) { alertWarning("Enter a valid attendance bonus value."); return false; }
        }
        if ($("#qualityApplicable").val() === "Yes" && ($("#qualityAmount").val() === "" || number($("#qualityAmount").val()) < 0)) { alertWarning("Enter a valid quality bonus amount."); return false; }
        if ($("#nightApplicable").val() === "Yes" && ($("#nightAmount").val() === "" || number($("#nightAmount").val()) < 0)) { alertWarning("Enter a valid night bonus amount."); return false; }
        if (number($("#valueHRA").data("value")) < 0) { alertWarning("The selected bonuses exceed the available HRA amount."); return false; }
        return true;
    }

    function requestModel() {
        var details = state.details;
        return {
            Code: details.Code, Salary: integer(details.GrossSalary), Basic: integer(details.Basic), DA: integer(details.DA),
            MR: integer(details.MR), TA: integer(details.TA), EA: integer(details.EA), HA: integer(details.HA),
            HRA: integer($("#valueHRA").data("value")), Other: 0, ProfTax: integer(details.ProfessionalTax),
            IsESIC: $("#esiApplicable").val() === "Yes", ESIC: integer(details.ESI),
            IsPF: $("#pfApplicable").val() === "Yes", PF: integer(details.PF),
            IsNightBonus: $("#nightApplicable").val() === "Yes", NightBonus: integer($("#nightAmount").val()),
            IsExtra: $("#extraDays").val() === "Yes",
            IsAttendanceBonusApplicable: $("#attendanceApplicable").val() === "Yes",
            AttendanceBonusType: $("#attendanceType").val() === "Select" ? "" : $("#attendanceType").val(),
            AttendanceBonus: integer($("#attendanceAmount").val()),
            IsQualityBonusApplicable: $("#qualityApplicable").val() === "Yes", QualityBonus: integer($("#qualityAmount").val())
        };
    }

    function approveSalary() {
        if (!state.details || !validateReview()) { return; }
        Swal.fire({ icon: "question", title: "Approve salary structure?", text: "This will finalize the salary structure for " + state.details.Name + ".", showCancelButton: true, confirmButtonText: "Approve", confirmButtonColor: "#059669" })
            .then(function (confirmation) {
                if (!confirmation.isConfirmed) { return; }
                loading(true);
                api("SaveSalaryStructure", { request: requestModel() }).done(function (result) {
                    if (!result || !result.Success) { alertError(result && result.Message ? result.Message : "Salary approval failed."); return; }
                    Swal.fire({ icon: "success", title: "Approved", text: result.Message, confirmButtonColor: "#2563eb" }).then(function () {
                        closeReview();
                        loadPendingApprovals();
                    });
                }).fail(function () { alertError("Salary approval could not be completed."); }).always(function () { loading(false); });
            });
    }

    function closeReview() {
        state.details = null;
        $("#salaryReviewWorkspace").removeClass("is-open");
    }

    function bindEvents() {
        $(document).on("click", ".js-review-salary", function () { openReview($(this).data("code")); });
        $("#btnRefreshApprovals").on("click", loadPendingApprovals);
        $("#btnCloseReview,#btnCancelReview").on("click", closeReview);
        $("#btnApproveSalary").on("click", approveSalary);
        $("#attendanceApplicable,#attendanceType,#qualityApplicable,#nightApplicable").on("change", function () { toggleConditionalFields(); recalculate(); });
        $("#attendanceAmount,#qualityAmount,#nightAmount").on("input", recalculate);
    }

    $(function () { bindEvents(); loadPendingApprovals(); });
})(window, document, window.jQuery);
