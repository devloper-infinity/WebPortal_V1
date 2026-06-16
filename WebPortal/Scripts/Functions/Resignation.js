(function (window, document, $) {
    "use strict";

    var state = {
        employeesLoaded: false,
        projectsLoaded: false,
        loadedTabs: {},
        tables: {},
        lastEditRow: null,
        lastExtendRow: null
    };

    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    function ready(fn) {
        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", fn);
        } else {
            window.setTimeout(fn, 0);
        }
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

    function blank(value) {
        if (value === null || value === undefined || value === "null") { return ""; }
        return String(value);
    }

    function escapeHtml(value) {
        return blank(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function setValue(selector, value) {
        $(selector).val(blank(value));
    }

    function setText(selector, value) {
        $(selector).text(blank(value));
    }

    function show(selector, visible) {
        $(selector).toggle(!!visible);
    }

    function selectedText(selector) {
        var option = $(selector).find("option:selected");
        return option.length ? option.text() : "Select";
    }

    function post(method, payload, onSuccess, onError) {
        $.ajax({
            type: "POST",
            url: "Resignation.aspx/" + method,
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
                    alert("Unable to complete request.");
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

    function showTableLoader(visible) {
        $("#load1").toggle(!!visible);
    }

    function runModal(selector, action) {
        var element = document.querySelector(selector);
        var jq = window.jQuery;

        if (jq && jq.fn && jq.fn.modal) {
            jq(element).modal(action);
            return;
        }

        if (window.bootstrap && window.bootstrap.Modal && element) {
            var instance = window.bootstrap.Modal.getOrCreateInstance ?
                window.bootstrap.Modal.getOrCreateInstance(element) :
                new window.bootstrap.Modal(element);
            if (action === "show") {
                instance.show();
            } else {
                instance.hide();
            }
            return;
        }

        if (element) {
            element.style.display = action === "show" ? "block" : "none";
            element.classList.toggle("show", action === "show");
        }
    }

    function showWait(visible) {
        if (visible) {
            runModal("#waitingpanel", "show");
        } else {
            runModal("#waitingpanel", "hide");
        }
    }

    function reloadPage() {
        window.location.reload();
    }

    function parseDate(value) {
        var text = blank(value).trim();
        var match;
        var parts;

        if (!text) { return null; }

        match = /\/Date\((\d+)\)\//.exec(text);
        if (match) { return new Date(parseInt(match[1], 10)); }

        if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
            parts = text.split("-");
            return new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
        }

        match = /^(\d{1,2})-([A-Za-z]{3})-(\d{4})$/.exec(text);
        if (match) {
            var monthIndex = $.inArray(match[2].substr(0, 1).toUpperCase() + match[2].substr(1, 2).toLowerCase(), months);
            if (monthIndex >= 0) {
                return new Date(parseInt(match[3], 10), monthIndex, parseInt(match[1], 10));
            }
        }

        match = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(text);
        if (match) {
            return new Date(parseInt(match[3], 10), parseInt(match[1], 10) - 1, parseInt(match[2], 10));
        }

        var parsed = new Date(text);
        if (isNaN(parsed.getTime())) { return null; }
        return parsed;
    }

    function pad2(value) {
        value = String(value);
        return value.length === 1 ? "0" + value : value;
    }

    function formatServerDate(date) {
        if (!date || isNaN(date.getTime())) { return ""; }
        return pad2(date.getDate()) + "-" + months[date.getMonth()] + "-" + date.getFullYear();
    }

    function formatIsoDate(date) {
        if (!date || isNaN(date.getTime())) { return ""; }
        return date.getFullYear() + "-" + pad2(date.getMonth() + 1) + "-" + pad2(date.getDate());
    }

    function displayDate(value) {
        var date = parseDate(value);
        return date ? formatServerDate(date) : blank(value);
    }

    function setDateInput(selector, value) {
        $(selector).val(formatIsoDate(parseDate(value)));
    }

    function serverDateFromInput(selector) {
        var value = $(selector).val();
        var date = parseDate(value);
        return date ? formatServerDate(date) : blank(value);
    }

    function daysBetween(startValue, endValue) {
        var start = parseDate(startValue);
        var end = parseDate(endValue);
        if (!start || !end) { return 0; }
        return Math.ceil(Math.abs(end.getTime() - start.getTime()) / (1000 * 3600 * 24));
    }

    function validateRemark(selector, messagePrefix) {
        var value = $(selector).val();
        if ($.trim(value) === "") {
            alert("Please enter " + messagePrefix + " remark.");
            $(selector).focus();
            return false;
        }
        if (value.length < 10) {
            alert("Remark should be more than 10 charaters long.");
            $(selector).focus();
            return false;
        }
        return true;
    }

    function textCell(value) {
        return escapeHtml(blank(value));
    }

    function dateCell(value) {
        return escapeHtml(displayDate(value));
    }

    function actionButton(action, icon, title, cssClass) {
        return '<button type="button" class="btn btn-link p-0 ' + (cssClass || "") + '" data-action="' + action + '" title="' + escapeHtml(title) + '">' +
            '<i class="' + icon + '"></i>' +
            '</button>';
    }

    function actionMenu(items) {
        var html = '<div class="dropdown action-menu">' +
            '<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><i class="fas fa-cog"></i></button>' +
            '<div class="dropdown-menu">';
        $.each(items, function (_, item) {
            html += '<button type="button" class="dropdown-item" data-action="' + item.action + '">' +
                '<i class="' + item.icon + '" style="color:' + item.color + ';"></i>&nbsp;&nbsp;' + escapeHtml(item.text) +
                '</button>';
        });
        html += '</div></div>';
        return html;
    }

    function buildTable(selector, key, rows, columns, exportColumns, title) {
        if (!$.fn.DataTable) {
            alert("DataTable plugin is not loaded.");
            return null;
        }

        if ($.fn.dataTable.isDataTable(selector)) {
            $(selector).DataTable().clear().destroy();
            $(selector + " tbody").empty();
        }

        state.tables[key] = $(selector).DataTable({
            data: rows,
            columns: columns,
            destroy: true,
            paging: true,
            processing: true,
            autoWidth: false,
            scrollX: true,
            order: [],
            dom: "lBfrtip",
            buttons: [
                {
                    extend: "excelHtml5",
                    title: title,
                    autoFilter: true,
                    exportOptions: { columns: exportColumns }
                },
                {
                    extend: "pdfHtml5",
                    title: title,
                    orientation: "landscape",
                    exportOptions: { columns: exportColumns }
                }
            ],
            language: {
                emptyTable: "No records found"
            }
        });

        return state.tables[key];
    }

    function employeeName(row, nameKey) {
        return blank(safe(row, "Code")) + " : " + blank(safe(row, nameKey || "Name", "FullName"));
    }

    function finalizedKey(row) {
        return safe(row, "EmployeeID", "ResignationId", "ResignationID");
    }

    function resignationId(row) {
        return safe(row, "ResignationId", "ResignationID");
    }

    function loadEmployees() {
        if (state.employeesLoaded) { return; }
        post("GetEmployeeCodes", {}, function (rows) {
            var $select = $("#resgEmployeeCode");
            $select.empty().append($("<option></option>").val("").text("Select"));
            $.each(rows || [], function (_, item) {
                $("<option></option>")
                    .val(safe(item, "EmployeeID"))
                    .text(safe(item, "Text"))
                    .attr("data-code", safe(item, "Code"))
                    .appendTo($select);
            });
            state.employeesLoaded = true;
        });
    }

    function loadProjects() {
        if (state.projectsLoaded) { return; }
        post("GetProjects", {}, function (rows) {
            var $select = $("#resgProject");
            $select.empty().append($("<option></option>").val("").text("Select"));
            $.each(rows || [], function (_, item) {
                $("<option></option>")
                    .val(safe(item, "ProjectID"))
                    .text(safe(item, "ProjectName"))
                    .appendTo($select);
            });
            state.projectsLoaded = true;
        });
    }

    function resetEmployeeDetails() {
        setValue("#resgName", "");
        setValue("#resgJoiningDate", "");
        setValue("#resgDepartment", "");
        setValue("#resgDesignation", "");
        show("#resgProjectField", false);
        show("#resgProcessField", false);
    }

    function onEmployeeChanged() {
        var code = $("#resgEmployeeCode option:selected").attr("data-code") || "";
        if (!code) {
            resetEmployeeDetails();
            return;
        }

        post("getDetailsOnCheckList", { UserCode: code }, function (result) {
            if (!result) {
                resetEmployeeDetails();
                return;
            }

            var parts = String(result).split("~");
            setValue("#resgName", parts[0] || "");
            setValue("#resgJoiningDate", parts[1] || "");
            setValue("#resgDesignation", parts[2] || "");
            setValue("#resgDepartment", parts[3] || "");

            var isProduction = parts[3] === "Production";
            show("#resgProjectField", isProduction);
            show("#resgProcessField", isProduction);
        });
    }

    function onProjectChanged() {
        var projectId = $("#resgProject").val();
        var $process = $("#resgProcess");
        $process.empty().append($("<option></option>").val("").text("Select"));

        if (!projectId) { return; }

        post("GetProcess", { ProjectID: parseInt(projectId, 10) }, function (rows) {
            $.each(rows || [], function (_, item) {
                $("<option></option>")
                    .val(safe(item, "ProcessID"))
                    .text(safe(item, "ProcessName"))
                    .appendTo($process);
            });
        });
    }

    function selectedEmployeeCode() {
        return $("#resgEmployeeCode option:selected").attr("data-code") || "";
    }

    function getLastLoginForInitiate() {
        var code = selectedEmployeeCode();
        if (!code) { return; }

        post("GetLastLoginDate1", { Code: code }, function (result) {
            var parts = String(result || "").split("~");
            var lastLogin = parts[0] || "";
            setDateInput("#resgDate", lastLogin);
            setValue("#resgLastLoginDate", displayDate(lastLogin));
            setValue("#resgDays", "0");
        });
    }

    function onResignationTypeChanged() {
        var type = $("#resgType").val();
        var terminal = type === "Absconding" || type === "Termination";

        show("#resgLastWorkingField", !terminal);
        show("#resgLastLoginField", terminal);
        show("#resgTerminationReasonField", type === "Termination");
        $("#resgDate").prop("disabled", terminal);
        $("#resgLastWorkingDate").prop("readonly", type === "Normal");

        setDateInput("#resgLastWorkingDate", "");
        setValue("#resgLastLoginDate", "");
        setValue("#resgDays", "0");

        if (terminal) {
            getLastLoginForInitiate();
        } else if (type === "Normal" && $("#resgDate").val()) {
            getLastWorkingDateForInitiate();
        }
    }

    function getLastWorkingDateForInitiate() {
        var type = $("#resgType").val();
        var resignationDate = serverDateFromInput("#resgDate");
        var lastWorkingDate = serverDateFromInput("#resgLastWorkingDate");

        if (!type || !resignationDate) { return; }

        post("GetLastWorkingDate", {
            FormDate: resignationDate,
            LastWorkinDate: lastWorkingDate,
            ResignationType: type
        }, function (result) {
            var parts = String(result || "").split("~");
            if (parseInt(parts[1], 10) < 0) {
                setDateInput("#resgLastWorkingDate", "");
                setValue("#resgDays", "0");
                alert("Last Working Date must be greater than Resignation Date!!");
                return;
            }

            if (parts[0]) { setDateInput("#resgLastWorkingDate", parts[0]); }
            if (parts[1] !== undefined) { setValue("#resgDays", parts[1]); }
        });
    }

    function calculateInitiateDays() {
        var joining = parseDate($("#resgJoiningDate").val());
        var resignation = parseDate(serverDateFromInput("#resgDate"));
        var lastWorking = parseDate(serverDateFromInput("#resgLastWorkingDate"));

        if (joining && resignation && joining > resignation) {
            setDateInput("#resgDate", "");
            setDateInput("#resgLastWorkingDate", "");
            alert("Resignation Date must be greater than Joining Date!!");
            return;
        }

        if (resignation && lastWorking && resignation > lastWorking) {
            setDateInput("#resgLastWorkingDate", "");
            alert("Last Working Date must be greater than Resignation Date!!");
            return;
        }

        setValue("#resgDays", daysBetween(serverDateFromInput("#resgDate"), serverDateFromInput("#resgLastWorkingDate")));
    }

    function uploadAttachment(input) {
        if (!input.files || !input.files.length) { return; }

        var file = input.files[0];
        var data = new FormData();
        data.append(input.name, file, file.name);

        var xhr = new XMLHttpRequest();
        xhr.open("POST", window.location.href, true);
        xhr.send(data);

        $("#resgFileName").text(file.name).show();
    }

    function submitInitiate() {
        var employeeId = $("#resgEmployeeCode").val();
        var code = selectedEmployeeCode();
        var contact = $("#resgContact").val();
        var type = $("#resgType").val();
        var resignationDate = serverDateFromInput("#resgDate");
        var lastWorkingDate = serverDateFromInput("#resgLastWorkingDate");
        var lastLoginDate = $("#resgLastLoginDate").val();
        var remark = $("#resgRemark").val();

        if (!employeeId) { alert("Please select code"); return; }
        if (!contact) { alert("Please enter contact #"); $("#resgContact").focus(); return; }
        if (!type) { alert("Please select resignation type"); $("#resgType").focus(); return; }
        if (!resignationDate) { alert("Please select resignation date"); return; }
        if ((type === "Normal" || type === "Immediate" || type === "Special") && !lastWorkingDate) {
            alert("Please select last working date");
            return;
        }
        if ($.trim(remark) === "") { alert("Please enter remark"); $("#resgRemark").focus(); return; }

        showWait(true);
        post("InitiateResignation", {
            EmployeeID: parseInt(employeeId, 10),
            Code: code,
            ContactNo: contact,
            Project: selectedText("#resgProject"),
            Process: selectedText("#resgProcess"),
            ResignationType: type,
            ResignationDate: resignationDate,
            LastWorkingDate: lastWorkingDate,
            ReasonToTerminate: $("#resgTerminationReason").val(),
            Remark: remark,
            LastLoginDate: lastLoginDate,
            NoOfDays: $("#resgDays").val()
        }, function (result) {
            showWait(false);
            if (parseInt(result, 10) > 0) {
                alert("Resignation initiated successfully!");
            } else {
                alert("Record already exists for selected employee!");
            }
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to initiate resignation.");
        });
    }

    function loadFinalize(force) {
        if (state.loadedTabs.finalize && !force) { return; }
        showTableLoader(true);
        post("GetRsignedEmployeesStep2", {}, function (payload) {
            var rows = parseRows(payload);
            buildTable("#tblFinalize", "finalize", rows, [
                { data: null, orderable: false, render: function () { return actionButton("open-step2", "fas fa-pen", "Approve / Reject"); } },
                { data: "Code", render: textCell },
                { data: "Name", render: textCell },
                { data: "JoiningDate", render: dateCell },
                { data: "ReportingManger", render: function (_, __, row) { return textCell(safe(row, "ReportingManger", "ReportingManager")); } },
                { data: "ResignationType", render: textCell },
                { data: "ResignationDate", render: dateCell },
                { data: "LastWorkingDate", render: dateCell },
                { data: "Remark", render: textCell },
                { data: "status", render: function (_, __, row) { return '<span class="status-pill">' + textCell(safe(row, "status", "Status")) + '</span>'; } },
                { data: "AddedDate", render: dateCell }
            ], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Resigned Employees");
            state.loadedTabs.finalize = true;
            showTableLoader(false);
        }, function () {
            showTableLoader(false);
            alert("Unable to load finalize data.");
        });
    }

    function loadFinalizedTable(key, selector, force, actionRenderer) {
        if (state.loadedTabs[key] && !force) { return; }
        showTableLoader(true);
        post("GetFinalizedStep3", {}, function (payload) {
            var rows = parseRows(payload);
            buildTable(selector, key, rows, [
                { data: null, orderable: false, render: actionRenderer },
                { data: "Code", render: textCell },
                { data: "FullName", render: textCell },
                { data: "JoiningDate", render: dateCell },
                { data: "BranchName", render: textCell },
                { data: "ResignedType", render: textCell },
                { data: "ResignedDate", render: dateCell },
                { data: "LastWorkingDate", render: dateCell },
                { data: "PMRemark", render: textCell },
                { data: "UHRemark", render: textCell }
            ], [1, 2, 3, 4, 5, 6, 7, 8, 9], "Resigned Employees");
            state.loadedTabs[key] = true;
            showTableLoader(false);
        }, function () {
            showTableLoader(false);
            alert("Unable to load resigned employees.");
        });
    }

    function loadDropout(force) {
        loadFinalizedTable("dropout", "#tblDropout", force, function () {
            return actionMenu([
                { action: "open-exit", icon: "fas fa-envelope", color: "#059669", text: "Send Exit Formality Email", resignationId: row.ResignationId },
                { action: "open-dropout", icon: "fas fa-trash", color: "#dc2626", text: "Delete User", resignationId: row.ResignationId },

            ]);
        });
    }

    function loadEdit(force) {
        loadFinalizedTable("edit", "#tblEdit", force, function () {
            return actionMenu([
                { action: "open-change", icon: "fas fa-exchange-alt", color: "#059669", text: "Change Resignation Type" },
                { action: "open-change", icon: "fas fa-exchange-alt", color: "#059669", text: "Change Resignation Type" },
                { action: "open-extend", icon: "fas fa-calendar-alt", color: "#2563eb", text: "Extend / Shorten Notice Period" },
                { action: "open-cancel", icon: "fas fa-times", color: "#dc2626", text: "Cancel Resignation" }
            ]);
        });
    }

    function loadDirect(force) {
        if (state.loadedTabs.direct && !force) { return; }
        showTableLoader(true);
        post("GetDirectDropoutEmployees", {}, function (payload) {
            var rows = parseRows(payload);
            buildTable("#tblDirectDropout", "direct", rows, [
                { data: null, orderable: false, render: function () { return actionButton("open-direct", "fas fa-user-slash", "Delete User"); } },
                { data: "Code", render: textCell },
                { data: "Name", render: textCell },
                { data: "JoiningDate", render: dateCell },
                { data: "DateOfBirth", render: dateCell },
                { data: "ProjectManagerName", render: textCell },
                { data: "ResignationType", render: textCell },
                { data: "ResignationDate", render: dateCell },
                { data: "LastWorkingDate", render: dateCell },
                { data: "CurrentLogin", render: dateCell },
                { data: "Remark", render: textCell }
            ], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Direct Dropout Employees");
            state.loadedTabs.direct = true;
            showTableLoader(false);
        }, function () {
            showTableLoader(false);
            alert("Unable to load direct dropout data.");
        });
    }

    function rowForButton(tableKey, button) {
        var table = state.tables[tableKey];
        if (!table) { return null; }
        return table.row($(button).closest("tr")).data();
    }

    function resetSelectAndRemark(modalSelector) {
        $(modalSelector).find("select").prop("selectedIndex", 0);
        $(modalSelector).find("textarea").val("");
    }

    function openStep2(row) {
        if (!row) { return; }
        setValue("#step2ResignationId", resignationId(row));
        setText("#step2Employee", employeeName(row, "Name"));
        setText("#step2Joining", safe(row, "JoiningDate"));
        setText("#step2Manager", safe(row, "ReportingManger", "ReportingManager"));
        setText("#step2Type", safe(row, "ResignationType"));
        setText("#step2Date", safe(row, "ResignationDate"));
        setText("#step2LastWorking", safe(row, "LastWorkingDate"));
        setText("#step2Step1Remark", safe(row, "Remark"));
        resetSelectAndRemark("#step2Modal");
        $("#btnStep2Submit").text("Okay");
        runModal("#step2Modal", "show");
    }

    function submitStep2() {
        var status = $("#step2Status").val();
        var attrition = $("#step2AttritionCategory").val();
        var receivedThrough = $("#step2ReceivedThrough").val();

        if (!attrition) { alert("Please select attrition category"); $("#step2AttritionCategory").focus(); return; }
        if (!status) { alert("Please select appropriate status."); $("#step2Status").focus(); return; }
        if (!receivedThrough) { alert("Please select resignation received through option."); $("#step2ReceivedThrough").focus(); return; }
        if (!validateRemark("#step2Remark", "step 2")) { return; }

        runModal("#step2Modal", "hide");
        showWait(true);
        post("SubmitStep2", {
            resgnationid: parseInt($("#step2ResignationId").val(), 10),
            status: status,
            unitheadremark: $("#step2Remark").val(),
            attritioncategory: attrition,
            resignationreceivedthrough: receivedThrough
        }, function () {
            showWait(false);
            alert("Record updated successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to update record.");
        });
    }

    function fillFinalizedDetails(prefix, row) {
        setText("#" + prefix + "Employee", employeeName(row, "FullName"));
        setText("#" + prefix + "Joining", safe(row, "JoiningDate"));
        setText("#" + prefix + "Branch", safe(row, "BranchName"));
        setText("#" + prefix + "Type", safe(row, "ResignedType", "ResignationType"));
        setText("#" + prefix + "Date", safe(row, "ResignedDate", "ResignationDate"));
        setText("#" + prefix + "LastWorking", safe(row, "LastWorkingDate"));
        setText("#" + prefix + "Step1Remark", safe(row, "PMRemark", "Remark"));
        setText("#" + prefix + "Step2Remark", safe(row, "UHRemark", "UnitHeadRemark"));
    }

    function openDropout(row) {
        var lastDate = parseDate(safe(row, "LastWorkingDate"));
        if (lastDate && new Date() < lastDate) {
            alert("Notice period of selected employee is not completed. Please contact domain head for further clarification.");
            return;
        }
        setValue("#dropoutResignationId", resignationId(row));
        fillFinalizedDetails("dropout", row);
        setValue("#dropoutRemark", "");
        runModal("#dropoutModal", "show");
    }

    function core_submitDropout() {
        if (!validateRemark("#dropoutRemark", "step 3")) { return; }
        runModal("#dropoutModal", "hide");
        showWait(true);
        post("DeleteUser", {
            ResignationId: parseInt($("#dropoutResignationId").val(), 10),
            Remark: $("#dropoutRemark").val()
        }, function () {
            showWait(false);
            alert("Employee dropped out successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to delete user.");
        });
    }

    function submitDropout() {
        if (!validateRemark("#dropoutRemark", "step 3")) {
            return;
        }

        runModal("#dropoutModal", "hide");

        alert($("#resignationId").val());

        showWait(true);

        PageMethods.DeleteUser(
            parseInt($("#dropoutResignationId").val(), 10),
            $("#dropoutRemark").val(),

            function (response) { // success
                showWait(false);

                if (response > 0) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success',
                        text: 'Employee dropped out successfully!'
                    }).then(() => {
                        reloadPage();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Failed',
                        text: 'Unable to delete user.'
                    });
                }
            },

            function (error) { // failure
                showWait(false);

                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: error.get_message()
                });
            }
        );
    }

    function openExit(row) {
        setValue("#exitResignationId", resignationId(row));
        fillFinalizedDetails("exit", row);
        setValue("#exitRemark", "");
        runModal("#exitFormalityModal", "show");
    }

    function submitExit() {
        if (!validateRemark("#exitRemark", "exit formality")) { return; }
        runModal("#exitFormalityModal", "hide");
        showWait(true);
        post("UpdateExitFormality", {
            ResignationID: parseInt($("#exitResignationId").val(), 10),
            Remark: $("#exitRemark").val()
        }, function () {
            showWait(false);
            alert("Exit formalities completed successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to update exit formality.");
        });
    }

    function openChange(row) {
        state.lastEditRow = row;
        setValue("#changeResignationKey", finalizedKey(row));
        setText("#changeEmployee", employeeName(row, "FullName"));
        setText("#changeJoining", safe(row, "JoiningDate"));
        setText("#changeBranch", safe(row, "BranchName"));
        setText("#changeStep1Remark", safe(row, "PMRemark", "Remark"));
        setText("#changeStep2Remark", safe(row, "UHRemark", "UnitHeadRemark"));
        setValue("#changeType", safe(row, "ResignedType", "ResignationType"));
        setDateInput("#changeResignationDate", safe(row, "ResignedDate", "ResignationDate"));
        setDateInput("#changeLastWorkingDate", safe(row, "LastWorkingDate"));
        setValue("#changeDays", daysBetween(safe(row, "ResignedDate", "ResignationDate"), safe(row, "LastWorkingDate")));
        setValue("#changeTerminationReason", "");
        setValue("#changeRemark", "");
        onChangeTypeChanged();
        runModal("#changeTypeModal", "show");
    }

    function getLastLoginForChange() {
        var code = blank($("#changeEmployee").text()).substring(0, 3);
        if (!code) { return; }
        post("GetLastLoginDate1", { Code: code }, function (result) {
            var lastLogin = String(result || "").split("~")[0] || "";
            setDateInput("#changeResignationDate", lastLogin);
            setDateInput("#changeLastWorkingDate", lastLogin);
            setValue("#changeDays", "0");
        });
    }

    function onChangeTypeChanged() {
        var type = $("#changeType").val();
        var terminal = type === "Absconding" || type === "Termination";
        show("#changeTerminationReasonField", type === "Termination");
        $("#changeResignationDate").prop("disabled", terminal);
        $("#changeLastWorkingDate").prop("disabled", terminal || type === "Normal");

        if (terminal) {
            getLastLoginForChange();
        } else if (type === "Normal") {
            getLastWorkingDateForChange();
        }
    }

    function getLastWorkingDateForChange() {
        var type = $("#changeType").val();
        var resignationDate = serverDateFromInput("#changeResignationDate");
        var lastWorkingDate = serverDateFromInput("#changeLastWorkingDate");
        if (!type || !resignationDate) { return; }

        post("GetLastWorkingDate", {
            FormDate: resignationDate,
            LastWorkinDate: lastWorkingDate,
            ResignationType: type
        }, function (result) {
            var parts = String(result || "").split("~");
            if (parseInt(parts[1], 10) < 0) {
                setDateInput("#changeLastWorkingDate", "");
                setValue("#changeDays", "0");
                alert("Last Working Date must be greater than Resignation Date!!");
                return;
            }
            if (parts[0]) { setDateInput("#changeLastWorkingDate", parts[0]); }
            if (parts[1] !== undefined) { setValue("#changeDays", parts[1]); }
        });
    }

    function calculateChangeDays() {
        var joining = parseDate($("#changeJoining").text());
        var resignation = parseDate(serverDateFromInput("#changeResignationDate"));
        var lastWorking = parseDate(serverDateFromInput("#changeLastWorkingDate"));

        if (joining && resignation && joining > resignation) {
            setDateInput("#changeResignationDate", "");
            setDateInput("#changeLastWorkingDate", "");
            alert("Resignation Date must be greater than Joining Date!!");
            return;
        }

        if (resignation && lastWorking && resignation > lastWorking) {
            setDateInput("#changeLastWorkingDate", "");
            alert("Last Working Date must be greater than Resignation Date!!");
            return;
        }

        setValue("#changeDays", daysBetween(serverDateFromInput("#changeResignationDate"), serverDateFromInput("#changeLastWorkingDate")));
    }

    function submitChange() {
        var type = $("#changeType").val();
        var resignationDate = serverDateFromInput("#changeResignationDate");
        var lastWorkingDate = serverDateFromInput("#changeLastWorkingDate");

        if (!type) { alert("Please select resignation type."); $("#changeType").focus(); return; }
        if (!resignationDate) { alert("Please select resignation date."); return; }
        if (!lastWorkingDate) { alert("Please select last working date."); return; }
        if (!validateRemark("#changeRemark", "")) { return; }

        runModal("#changeTypeModal", "hide");
        showWait(true);
        post("ChangeResignationType", {
            resgnationid: parseInt($("#changeResignationKey").val(), 10),
            resignationType: type,
            resignationDate: resignationDate,
            lastWorkingDate: lastWorkingDate,
            Reasontoterminate: $("#changeTerminationReason").val(),
            ReasonType: "Change Resignation Type",
            Remark: $("#changeRemark").val(),
            NoofDays: $("#changeDays").val()
        }, function () {
            showWait(false);
            alert("Resignation type changed successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to change resignation type.");
        });
    }

    function openExtend(row) {
        var type = safe(row, "ResignedType", "ResignationType");
        if (type === "Absconding" || type === "Termination") {
            alert("You cannot extend/shorten notice period as employee is in " + type + " phase.");
            return;
        }

        state.lastExtendRow = row;
        setValue("#extendResignationKey", finalizedKey(row));
        setText("#extendEmployee", employeeName(row, "FullName"));
        setText("#extendJoining", safe(row, "JoiningDate"));
        setText("#extendBranch", safe(row, "BranchName"));
        setText("#extendTypeCurrent", type);
        setText("#extendResignationDate", safe(row, "ResignedDate", "ResignationDate"));
        setText("#extendLastWorkingDate", safe(row, "LastWorkingDate"));
        setText("#extendStep1Remark", safe(row, "PMRemark", "Remark"));
        setText("#extendStep2Remark", safe(row, "UHRemark", "UnitHeadRemark"));
        setValue("#extendType", "");
        setDateInput("#extendRevisedDate", "");
        setValue("#extendDays", "");
        setValue("#extendRemark", "");
        runModal("#extendModal", "show");
    }

    function validateRevisedDate() {
        var actionType = $("#extendType").val();
        var selected = parseDate(serverDateFromInput("#extendRevisedDate"));
        var existing = parseDate($("#extendLastWorkingDate").text());
        var resignation = parseDate($("#extendResignationDate").text());

        if (!actionType) {
            alert("Please select type.");
            setDateInput("#extendRevisedDate", "");
            return;
        }
        if (!selected || !existing || !resignation) { return; }

        if (actionType === "Shorten") {
            if (resignation.getTime() > selected.getTime()) {
                alert("Selected date must be greater than existing resignation date");
                setDateInput("#extendRevisedDate", existing);
                return;
            }
            if (existing.getTime() < selected.getTime()) {
                alert("Selected date must be less than existing last working date");
                setDateInput("#extendRevisedDate", existing);
                return;
            }
        } else if (actionType === "Extend") {
            if (resignation.getTime() > selected.getTime()) {
                alert("Selected date must be greater than existing resignation date");
                setDateInput("#extendRevisedDate", existing);
                return;
            }
            if (existing.getTime() > selected.getTime()) {
                alert("Selected date must be greater than existing last working date");
                setDateInput("#extendRevisedDate", existing);
                return;
            }
        }

        setValue("#extendDays", daysBetween($("#extendResignationDate").text(), serverDateFromInput("#extendRevisedDate")));
    }

    function submitExtend() {
        var actionType = $("#extendType").val();
        var revisedDate = serverDateFromInput("#extendRevisedDate");

        if (!actionType) { alert("Please select type."); $("#extendType").focus(); return; }
        if (!revisedDate) { alert("Please select revised date."); return; }
        if (!validateRemark("#extendRemark", "")) { return; }

        runModal("#extendModal", "hide");
        showWait(true);
        post("ExtendShortenResignation", {
            resgnationid: parseInt($("#extendResignationKey").val(), 10),
            resignationType: $("#extendTypeCurrent").text(),
            resignationDate: $("#extendResignationDate").text(),
            lastWorkingDate: $("#extendLastWorkingDate").text(),
            RevisedDate: revisedDate,
            Remark: $("#extendRemark").val(),
            NoofDays: $("#extendDays").val(),
            Type: actionType
        }, function () {
            showWait(false);
            alert("Changes made successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to update notice period.");
        });
    }

    function openCancel(row) {
        setValue("#cancelResignationKey", finalizedKey(row));
        fillFinalizedDetails("cancel", row);
        setValue("#cancelRemark", "");
        runModal("#cancelModal", "show");
    }

    function submitCancel() {
        if (!validateRemark("#cancelRemark", "")) { return; }
        runModal("#cancelModal", "hide");
        showWait(true);
        post("CancelResignation", {
            resgnationid: parseInt($("#cancelResignationKey").val(), 10),
            Remark: $("#cancelRemark").val()
        }, function () {
            showWait(false);
            alert("Resignation cancelled successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to cancel resignation.");
        });
    }

    function openDirect(row) {
        setValue("#directResignationId", resignationId(row));
        setText("#directEmployee", employeeName(row, "Name"));
        setText("#directJoining", safe(row, "JoiningDate"));
        setText("#directManager", safe(row, "ProjectManagerName"));
        setText("#directType", safe(row, "ResignationType"));
        setText("#directDate", safe(row, "ResignationDate"));
        setText("#directLastWorking", safe(row, "LastWorkingDate"));
        setText("#directStep1Remark", safe(row, "Remark"));
        setText("#directStep2Remark", safe(row, "Remark"));
        setValue("#directRemark", "");
        runModal("#directDropoutModal", "show");
    }

    function submitDirect() {
        if (!validateRemark("#directRemark", "step 3")) { return; }
        runModal("#directDropoutModal", "hide");
        showWait(true);
        post("DirectDropoutUser", {
            ResignationId: parseInt($("#directResignationId").val(), 10),
            Remark: $("#directRemark").val()
        }, function () {
            showWait(false);
            alert("Employee dropped out successfully!");
            reloadPage();
        }, function () {
            showWait(false);
            alert("Unable to drop out employee.");
        });
    }

    function bindEvents() {
        $("#resgEmployeeCode").on("change", onEmployeeChanged);
        $("#resgProject").on("change", onProjectChanged);
        $("#resgType").on("change", onResignationTypeChanged);
        $("#resgDate").on("change", function () {
            if ($("#resgType").val() === "Normal") {
                getLastWorkingDateForInitiate();
            } else {
                calculateInitiateDays();
            }
        });
        $("#resgLastWorkingDate").on("change", calculateInitiateDays);
        $("#fpAttachment").on("change", function () { uploadAttachment(this); });
        $("#btnInitiateResignation").on("click", submitInitiate);

        $("#step2Status").on("change", function () {
            $("#btnStep2Submit").text($(this).val() || "Okay");
        });
        $("#btnStep2Submit").on("click", submitStep2);
        $("#btnDropoutSubmit").on("click", submitDropout);
        $("#btnExitSubmit").on("click", submitExit);
        $("#btnChangeSubmit").on("click", submitChange);
        $("#btnExtendSubmit").on("click", submitExtend);
        $("#btnCancelSubmit").on("click", submitCancel);
        $("#btnDirectSubmit").on("click", submitDirect);

        $("#changeType").on("change", onChangeTypeChanged);
        $("#changeResignationDate").on("change", function () {
            if ($("#changeType").val() === "Normal") {
                getLastWorkingDateForChange();
            } else {
                calculateChangeDays();
            }
        });
        $("#changeLastWorkingDate").on("change", calculateChangeDays);
        $("#extendRevisedDate").on("change", validateRevisedDate);

        $("#tblFinalize").on("click", "[data-action='open-step2']", function () {
            openStep2(rowForButton("finalize", this));
        });
        $("#tblDropout").on("click", "[data-action='open-dropout']", function () {
            openDropout(rowForButton("dropout", this));
        });
        $("#tblDropout").on("click", "[data-action='open-exit']", function () {
            openExit(rowForButton("dropout", this));
        });
        $("#tblEdit").on("click", "[data-action='open-change']", function () {
            openChange(rowForButton("edit", this));
        });
        $("#tblEdit").on("click", "[data-action='open-extend']", function () {
            openExtend(rowForButton("edit", this));
        });
        $("#tblEdit").on("click", "[data-action='open-cancel']", function () {
            openCancel(rowForButton("edit", this));
        });
        $("#tblDirectDropout").on("click", "[data-action='open-direct']", function () {
            openDirect(rowForButton("direct", this));
        });

        $("[data-resg-refresh]").on("click", function () {
            loadTab($(this).attr("data-resg-refresh"), true);
        });

        $("[data-resg-load]").on("shown.bs.tab click", function () {
            loadTab($(this).attr("data-resg-load"), false);
        });
    }

    function loadTab(tab, force) {
        if (tab === "finalize") { loadFinalize(force); }
        if (tab === "dropout") { loadDropout(force); }
        if (tab === "edit") { loadEdit(force); }
        if (tab === "direct") { loadDirect(force); }
    }

    function init() {
        bindEvents();
        loadEmployees();
        loadProjects();
    }

    window.onsecondclick = function () { loadFinalize(true); };
    window.onthirdclick = function () { loadDropout(true); };
    window.onForthclick = function () { loadEdit(true); };
    window.onFifthclick = function () { loadDirect(true); };

    ready(init);

})(window, document, window.jQuery);
