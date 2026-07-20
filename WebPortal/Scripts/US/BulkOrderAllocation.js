(function () {
    "use strict";

    var importHeaders = ["Project", "Deal #", "Loan #", "Employee"];
    var allocationDefaults = {
        projectId: 70,
        projectName: "561",
        processId: 2506,
        processName: "PH RecQC"
    };
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
                    ProjectId: allocationDefaults.projectId,
                    ProjectName: allocationDefaults.projectName,
                    ProcessId: allocationDefaults.processId,
                    ProcessName: allocationDefaults.processName,
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
        var totalCount = successCount + failedCount;

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
            "561,SampleDeal,SampleLoan,EMPLOYEE1"
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

    function escapeHtml(value) {
        return $("<div/>").text(value === null || value === undefined ? "" : value).html();
    }

    $(function () {
        $("#oa_import_allocation").on("click", importOrders);
        $("#oa_template_allocation").on("click", downloadTemplate);
        $("#oa_refresh_status").on("click", loadAllocatedOrders);
        $("#boa_status_tab").on("shown.bs.tab", function () {
            loadAllocatedOrders();
        });
        renderResult({ TotalRows: 0, SuccessRows: 0, FailedRows: 0, NotAddedRows: [] });
    });
})();
