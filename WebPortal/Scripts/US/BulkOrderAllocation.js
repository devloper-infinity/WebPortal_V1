(function () {
    "use strict";

    var importHeaders = ["Project", "Deal #", "Loan #", "Employee", "Process"];
    var allocationProcessingOpen = false;

    function pageMethod(method, payload) {
        return $.ajax({
            type: "POST",
            url: "BulkOrderAllocation.aspx/" + method,
            data: JSON.stringify(payload || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).then(function (response) {
            return response.d || response;
        });
    }

    function notify(icon, title, message) {
        if (window.Swal) {
            Swal.fire({ icon: icon, title: title, text: message, confirmButtonText: "OK" });
        } else {
            window.alert(title + ": " + message);
        }
    }

    function showAllocationProcessing() {
        if (!window.Swal) return;

        allocationProcessingOpen = true;
        Swal.fire({
            title: "Processing allocation",
            text: "Please wait while the orders are validated and allocated.",
            allowOutsideClick: false,
            allowEscapeKey: false,
            showConfirmButton: false,
            didOpen: function () { Swal.showLoading(); }
        });
    }

    function hideAllocationProcessing() {
        if (!allocationProcessingOpen || !window.Swal) return;
        allocationProcessingOpen = false;
        Swal.close();
    }

    function readFile(file) {
        var deferred = $.Deferred();
        var reader = new FileReader();
        reader.onload = function (event) { deferred.resolve(event.target.result); };
        reader.onerror = function () { deferred.reject(); };
        reader.readAsDataURL(file);
        return deferred.promise();
    }

    function importOrders() {
        var fileInput = $("#oa_file_allocation")[0];

        if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
            notify("warning", "Validation", "Please select import file.");
            return;
        }

        var file = fileInput.files[0];
        $("#oa_import_allocation").prop("disabled", true);
        renderResult({ TotalRows: 0, SuccessRows: 0, FailedRows: 0, NotAddedRows: [] });
        showAllocationProcessing();

        readFile(file).done(function (content) {
            pageMethod("ImportOrders", {
                request: {
                    FileName: file.name,
                    ContentBase64: content
                }
            }).done(function (res) {
                hideAllocationProcessing();
                renderResult(res);
                if (res.Success) {
                    notify(res.FailedRows > 0 ? "warning" : "success", "Import", res.Message || "Import completed.");
                    loadAllocatedOrders();
                } else {
                    notify("error", "Import", res.Message || "Import failed.");
                }
            }).fail(function (xhr) {
                hideAllocationProcessing();
                var message = xhr.responseJSON && xhr.responseJSON.Message ? xhr.responseJSON.Message : "Import failed.";
                notify("error", "Import", message);
            }).always(function () {
                $("#oa_import_allocation").prop("disabled", false);
            });
        }).fail(function () {
            hideAllocationProcessing();
            $("#oa_import_allocation").prop("disabled", false);
            notify("error", "File", "Unable to read selected file.");
        });
    }

    function renderResult(res) {
        var failedRows = normalizeRows(res && res.NotAddedRows);
        var successCount = toCount(res && res.SuccessRows);
        var failedCount = failedRows.length;
        var suppliedTotal = toCount(res && res.TotalRows);
        var totalCount = suppliedTotal || (successCount + failedCount);

        $("#oa_total_allocation").text(totalCount);
        $("#oa_success_allocation").text(successCount);
        $("#oa_failed_count_allocation").text(failedCount);
        renderTable(failedRows);
    }

    function normalizeRows(rows) {
        if (typeof rows === "string") {
            try { rows = JSON.parse(rows); }
            catch (_) { rows = []; }
        }
        return Array.isArray(rows) ? rows : [];
    }

    function toCount(value) {
        var count = parseInt(value, 10);
        return isNaN(count) || count < 0 ? 0 : count;
    }

    function renderTable(rows) {
        var selector = "#oa_failed_allocation";
        if ($.fn.DataTable && $.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().destroy();
        }

        $(selector).empty();
        if (!rows || rows.length === 0) {
            $(selector).append("<thead><tr><th>Status</th></tr></thead><tbody><tr><td>No failed rows.</td></tr></tbody>");
            return;
        }

        var columns = Object.keys(rows[0]).map(function (key) {
            return {
                title: key,
                data: key,
                render: function (value) { return escapeHtml(value); }
            };
        });

        $(selector).DataTable({
            data: rows,
            columns: columns,
            destroy: true,
            scrollX: true,
            autoWidth: false,
            pageLength: 10,
            dom: "Bfrtip",
            buttons: ["excel", "csv"],
            order: []
        });
    }

    function downloadTemplate() {
        var sample = [
            importHeaders.join(","),
            "561,SampleDeal,SampleLoan,EMPLOYEE1,PH ReQC"
        ].join("\r\n");
        var blob = new Blob([sample], { type: "text/csv;charset=utf-8;" });
        var url = URL.createObjectURL(blob);
        var link = document.createElement("a");
        link.href = url;
        link.download = "Order_Allocation_Template.csv";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    function loadAllocatedOrders() {
        var $button = $("#oa_refresh_status");
        $button.prop("disabled", true);

        pageMethod("GetAllocatedOrders").done(function (res) {
            if (!res.Success) {
                notify("error", "Allocated Orders", res.Message || "Unable to load allocated orders.");
                return;
            }
            renderAllocatedOrders(res.Rows || []);
        }).fail(function (xhr) {
            var message = xhr.responseJSON && xhr.responseJSON.Message
                ? xhr.responseJSON.Message
                : "Unable to load allocated orders.";
            notify("error", "Allocated Orders", message);
        }).always(function () {
            $button.prop("disabled", false);
        });
    }

    function renderAllocatedOrders(rows) {
        var selector = "#oa_allocated_orders";
        if ($.fn.DataTable && $.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().clear().destroy();
        }

        $(selector).empty();
        $(selector).DataTable({
            data: rows || [],
            destroy: true,
            scrollX: true,
            autoWidth: false,
            pageLength: 25,
            dom: "Bfrtip",
            buttons: ["excel", "csv"],
            order: [],
            language: { emptyTable: "No allocated orders found." },
            columns: [
                { title: "Sr. #", data: "SrNo" },
                { title: "Project", data: "Project" },
                { title: "Deal #", data: "DealNo" },
                { title: "Loan #", data: "LoanNo" },
                { title: "Employee", data: "Employee" },
                { title: "Process", data: "Process" },
                { title: "Status", data: "Status", render: renderStatus }
            ]
        });
    }

    function renderStatus(value, type) {
        var status = value === null || value === undefined ? "" : String(value);
        if (type !== "display") return status;

        var normalized = status.toLowerCase();
        var badgeClass = "badge-secondary";
        if (normalized.indexOf("complete") >= 0) badgeClass = "badge-success";
        else if (normalized.indexOf("pending") >= 0 || normalized.indexOf("allocat") >= 0) badgeClass = "badge-warning";
        else if (normalized.indexOf("cancel") >= 0 || normalized.indexOf("fail") >= 0) badgeClass = "badge-danger";
        else if (normalized.indexOf("progress") >= 0 || normalized.indexOf("start") >= 0) badgeClass = "badge-info";

        return '<span class="badge ' + badgeClass + '">' + escapeHtml(status || "N/A") + "</span>";
    }

    function initializeLoanStatusFilters() {
        var now = new Date();
        var first = new Date(now.getFullYear(), now.getMonth(), 1);
        $("#oa_status_from").val(formatInputDate(first));
        $("#oa_status_to").val(formatInputDate(now));

        pageMethod("GetBulkAllocationEmployees").done(function (employees) {
            var $employee = $("#oa_status_employee").empty().append('<option value="">All Employees</option>');
            $.each(employees || [], function (_, employee) {
                $employee.append($("<option></option>").val(employee).text(employee));
            });
        });
    }

    function formatInputDate(date) {
        return date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, "0") + "-" + String(date.getDate()).padStart(2, "0");
    }

    function loadLoanStatus() {
        var $button = $("#oa_search_loan_status").prop("disabled", true);
        $("#oa_loan_status_loading").show();
        pageMethod("GetBulkAllocationLoanStatus", {
            employee: $("#oa_status_employee").val() || "",
            fromDate: $("#oa_status_from").val() || "",
            toDate: $("#oa_status_to").val() || ""
        }).done(function (res) {
            if (!res.Success) {
                notify("warning", "Loan Status", res.Message || "Unable to load loan status.");
                return;
            }
            renderLoanStatus(res.Rows || []);
        }).fail(function () {
            notify("error", "Loan Status", "Unable to load loan status.");
        }).always(function () {
            $button.prop("disabled", false);
            $("#oa_loan_status_loading").hide();
        });
    }

    function renderLoanStatus(rows) {
        var selector = "#oa_loan_status";
        if ($.fn.DataTable && $.fn.DataTable.isDataTable(selector)) $(selector).DataTable().clear().destroy();
        var table = $(selector).empty().DataTable({
            data: rows || [], destroy: true, scrollX: true, autoWidth: false, pageLength: 25,
            dom: "Bfrtip", buttons: ["excel", "csv"], order: [],
            language: { emptyTable: "No bulk-allocated loans found." },
            columns: [
                { title: "Employee", data: "Employee" },
                { title: "Loan #", data: "LoanNo" },
                { title: "Process", data: "Process" },
                { title: "Process Date", data: "ProcessDate", render: renderDateTime },
                { title: "Status", data: "Status", render: renderStatus }
            ]
        });
        setTimeout(function () { table.columns.adjust().draw(false); }, 0);
    }

    function renderDateTime(value, type) {
        if (!value) return "";
        if (type !== "display") return value;
        var match = /\/Date\((\d+)\)\//.exec(String(value));
        var date = match ? new Date(parseInt(match[1], 10)) : new Date(value);
        return isNaN(date.getTime()) ? escapeHtml(value) : date.toLocaleString();
    }

    function escapeHtml(value) {
        return $("<div/>").text(value === null || value === undefined ? "" : value).html();
    }

    $(function () {
        $("#oa_import_allocation").on("click", importOrders);
        $("#oa_template_allocation").on("click", downloadTemplate);
        $("#oa_refresh_status").on("click", loadAllocatedOrders);
        $("#oa_search_loan_status").on("click", loadLoanStatus);
        $("#boa_status_tab").on("shown.bs.tab", function () {
            loadAllocatedOrders();
        });
        $("#boa_loan_status_tab").on("shown.bs.tab", loadLoanStatus);
        initializeLoanStatusFilters();
        renderResult({ TotalRows: 0, SuccessRows: 0, FailedRows: 0, NotAddedRows: [] });
    });
})();
