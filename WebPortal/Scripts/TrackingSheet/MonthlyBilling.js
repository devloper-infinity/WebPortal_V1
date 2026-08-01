(function ($) {
    "use strict";
    var pageUrl = "MonthlyBilling.aspx", billingTable = null, historyTable = null;

    function popup(icon, title, message) { return Swal.fire({ icon: icon, title: title, text: message, confirmButtonText: "OK" }); }
    function webMethod(name, data) { return $.ajax({ url: pageUrl + "/" + name, type: "POST", contentType: "application/json; charset=utf-8", dataType: "json", data: JSON.stringify(data || {}) }); }
    function errorMessage(xhr) { try { return JSON.parse(xhr.responseText).Message || "A system error occurred."; } catch (e) { return "A system error occurred."; } }
    function period(prefix) { return { projectId: parseInt($("#" + prefix + "Project").val(), 10) || 0, billingMonth: parseInt($("#" + prefix + "Month").val(), 10) || 0, billingYear: parseInt($("#" + prefix + "Year").val(), 10) || 0 }; }
    function validPeriod(p) { if (!p.projectId) { popup("warning", "Validation", "Please select a project."); return false; } if (!p.billingMonth || !p.billingYear) { popup("warning", "Validation", "Please select a billing month and year."); return false; } return true; }

    function populatePeriods() {
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], now = new Date(), monthHtml = "", yearHtml = "";
        $.each(months, function (i, name) { monthHtml += '<option value="' + (i + 1) + '"' + (i === now.getMonth() ? ' selected' : '') + '>' + name + '</option>'; });
        for (var year = now.getFullYear() + 2; year >= 2015; year--) yearHtml += '<option value="' + year + '"' + (year === now.getFullYear() ? ' selected' : '') + '>' + year + '</option>';
        $("#mbMonth,#mbHistoryMonth").html(monthHtml); $("#mbYear,#mbHistoryYear").html(yearHtml);
    }

    function loadProjects() {
        webMethod("GetProjects").done(function (response) {
            var html = '<option value="">Select Project</option>';
            $.each(response.d || [], function (_, p) { html += '<option value="' + p.ID + '">' + $('<div>').text(p.Name).html() + '</option>'; });
            $("#mbProject,#mbHistoryProject").html(html);
        }).fail(function (xhr) { popup("error", "System Error", errorMessage(xhr)); });
    }

    function statusRenderer(data, type) {
        if (type !== "display") return data;
        var cls = data === "Sent" ? "mb-sent" : data === "Verified" ? "mb-verified" : "mb-pending";
        return '<span class="mb-status ' + cls + '">' + data + '</span>';
    }

    function tableColumns(result, selectable) {
        var columns = [];
        if (selectable) columns.push({ data: null, title: '<input type="checkbox" id="mbSelectAll" title="Select all eligible records" />', orderable: false, searchable: false, className: "text-center", render: function (_, type, row) { return type === "display" ? '<input type="checkbox" class="mb-row-check" data-item="' + row._ItemID + '" data-date="' + row._OrderDate + '"' + (row._CanVerify ? '' : ' disabled') + ' />' : ""; } });
        $.each(result.Columns, function (_, name) {
            var column = { data: name, title: name, defaultContent: "", className: "text-nowrap", render: $.fn.dataTable.render.text() };
            if (name === "Verification Status" || name === "Accounts Status") column.render = statusRenderer;
            columns.push(column);
        });
        return columns;
    }

    function createTable(selector, existing, result, selectable, fileName, title) {
        if (existing) existing.destroy(); $(selector).empty();
        return $(selector).DataTable({
            data: result.Rows, columns: tableColumns(result, selectable), scrollX: true, scrollY: "55vh", scrollCollapse: true, responsive: false, autoWidth: false,
            pageLength: 25, lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]], order: selectable ? [[5, "asc"]] : [[4, "asc"]],
            dom: "<'row mb-2'<'col-sm-12 col-md-6'B><'col-sm-12 col-md-6'f>><'row'<'col-sm-12'tr>><'row mt-2'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            buttons: [{ extend: "excelHtml5", text: '<i class="fas fa-file-excel"></i> Export Excel', className: "btn btn-success", title: title, filename: fileName,
                exportOptions: { columns: function (index) { return !(selectable && index === 0); }, modifier: { search: "applied", order: "applied", page: "all" } } }]
        });
    }

    function loadBilling() {
        var p = period("mb"); if (!validPeriod(p)) return;
        $("#mbShow").prop("disabled", true); $("#mbLoading").show();
        webMethod("GetBillingRecords", $.extend({}, p, { history: false })).done(function (response) {
            var result = response.d, project = $("#mbProject option:selected").text().replace(/[^a-z0-9_-]+/gi, "_");
            billingTable = createTable("#mbTable", billingTable, result, true, "Monthly_Billing_" + project + "_" + p.billingYear + "_" + p.billingMonth, "Monthly Billing");
            $("#mbSummary").text(result.RowCount + " dispatched record(s)"); $("#mbResult").show();
            $("#mbVerify").prop("disabled", true); $("#mbSend").prop("disabled", !result.CanSendToAccounts); billingTable.columns.adjust();
            if (!result.RowCount) popup("info", "No Records", "No dispatched records were found for the selected billing period.");
        }).fail(function (xhr) { popup("error", "Billing Load Failed", errorMessage(xhr)); }).always(function () { $("#mbShow").prop("disabled", false); $("#mbLoading").hide(); });
    }

    function selectedRecords() {
        return $("#mbTable .mb-row-check:checked").map(function () { return { ItemID: parseInt($(this).attr("data-item"), 10), OrderDate: $(this).attr("data-date") }; }).get();
    }

    function verifyRecords() {
        var p = period("mb"), records = selectedRecords(); if (!validPeriod(p)) return; if (!records.length) { popup("warning", "Validation", "Select at least one eligible record to verify."); return; }
        Swal.fire({ icon: "question", title: "Verify selected records?", text: "Verified records will be locked for this billing period.", showCancelButton: true, confirmButtonText: "Verify", confirmButtonColor: "#28a745" }).then(function (answer) {
            if (!answer.isConfirmed) return; $("#mbVerify,#mbSend").prop("disabled", true);
            webMethod("VerifyRecords", $.extend({}, p, { records: records })).done(function (response) { popup("success", "Verification Successful", response.d.Message).then(loadBilling); })
                .fail(function (xhr) { popup("error", "Verification Failed", errorMessage(xhr)); }).always(function () { $("#mbVerify").prop("disabled", false); });
        });
    }

    function sendToAccounts() {
        var p = period("mb"); if (!validPeriod(p)) return;
        Swal.fire({ icon: "warning", title: "Send verified billing to Accounts?", text: "All verified, unsent records in this billing period will be locked and sent to Accounts.", showCancelButton: true, confirmButtonText: "Send to Accounts", confirmButtonColor: "#17a2b8" }).then(function (answer) {
            if (!answer.isConfirmed) return; $("#mbVerify,#mbSend").prop("disabled", true);
            webMethod("SendToAccounts", p).done(function (response) { popup("success", "Sent to Accounts", response.d.Message).then(loadBilling); })
                .fail(function (xhr) { popup("error", "Send Failed", errorMessage(xhr)); }).always(function () { $("#mbSend").prop("disabled", false); });
        });
    }

    function loadHistory() {
        var p = period("mbHistory"); if (!validPeriod(p)) return;
        $("#mbHistoryShow").prop("disabled", true); $("#mbHistoryLoading").show();
        webMethod("GetBillingRecords", $.extend({}, p, { history: true })).done(function (response) {
            var result = response.d, project = $("#mbHistoryProject option:selected").text().replace(/[^a-z0-9_-]+/gi, "_");
            historyTable = createTable("#mbHistoryTable", historyTable, result, false, "Billing_History_" + project + "_" + p.billingYear + "_" + p.billingMonth, "Billing History");
            $("#mbHistorySummary").text(result.RowCount + " record(s) sent to Accounts"); $("#mbHistoryResult").show(); historyTable.columns.adjust();
            if (!result.RowCount) popup("info", "No History", "No records were sent to Accounts for the selected billing period.");
        }).fail(function (xhr) { popup("error", "History Load Failed", errorMessage(xhr)); }).always(function () { $("#mbHistoryShow").prop("disabled", false); $("#mbHistoryLoading").hide(); });
    }

    $(function () {
        populatePeriods(); loadProjects(); $("#mbShow").on("click", loadBilling); $("#mbHistoryShow").on("click", loadHistory); $("#mbVerify").on("click", verifyRecords); $("#mbSend").on("click", sendToAccounts);
        $(document).on("change", "#mbSelectAll", function () { $("#mbTable .mb-row-check:not(:disabled)").prop("checked", this.checked).trigger("change"); });
        $(document).on("change", "#mbTable .mb-row-check", function () { $("#mbVerify").prop("disabled", selectedRecords().length === 0); });
    });
})(jQuery);
