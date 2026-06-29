(function () {
    "use strict";

    function pageMethod(method, payload) {
        return $.ajax({
            type: "POST",
            url: "TodaySatus.aspx/" + method,
            data: JSON.stringify(payload || {}),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        }).then(function (response) {
            return response.d || response;
        });
    }

    function notify(icon, title, text) {
        if (window.Swal) {
            Swal.fire({ icon: icon, title: title, text: text, confirmButtonText: "OK" });
        } else {
            console.log(title + ": " + text);
        }
    }

    function todayIso() {
        var d = new Date();
        var month = String(d.getMonth() + 1).padStart(2, "0");
        var day = String(d.getDate()).padStart(2, "0");
        return d.getFullYear() + "-" + month + "-" + day;
    }

    function loadProjects() {
        pageMethod("GetProjects").done(function (res) {
            var $project = $("#ts_project");
            $project.empty().append($("<option/>").val("").text("Select Project"));
            if (!res.Success) {
                notify("error", "Projects", res.Message || "Unable to load projects.");
                return;
            }
            $.each(res.Rows || [], function (_, item) {
                var id = item.ProjectId || item.ProjectID || item.ID;
                var name = item.ProjectName || item.Project || item.Name || id;
                if (id !== undefined && id !== null && String(id) !== "") {
                    $project.append($("<option/>").val(id).text(name));
                }
            });
        }).fail(function () {
            notify("error", "Projects", "Unable to load projects.");
        });
    }

    function loadProcesses() {
        var projectId = parseInt($("#ts_project").val(), 10) || 0;
        var $process = $("#ts_process");
        $process.empty().append($("<option/>").val("").text("Select Process"));

        if (!projectId) {
            return;
        }

        pageMethod("GetProcesses", { projectId: projectId }).done(function (res) {
            if (!res.Success) {
                notify("error", "Process", res.Message || "Unable to load process list.");
                return;
            }
            $.each(res.Rows || [], function (_, item) {
                var value = item.ProcessName || item.Process || item.Name || item.ProcessID;
                var text = item.ProcessName || item.Process || value;
                if (value !== undefined && value !== null && String(value) !== "") {
                    $process.append($("<option/>").val(value).text(text));
                }
            });
        }).fail(function () {
            notify("error", "Process", "Unable to load process list.");
        });
    }

    function showStatus() {
        var status = $("#ts_status").val();
        var fromDate = $("#ts_from_date").val();
        var toDate = $("#ts_to_date").val();
        var process = $("#ts_process").val();
        var dealNo = $.trim($("#ts_deal").val());

        if (!fromDate || !toDate) {
            notify("warning", "Validation", "Please select date range.");
            return;
        }

        if (status === "DPending" && (!process || !dealNo)) {
            notify("warning", "Validation", "Please select Process and enter Deal No for Dashboard Pending.");
            return;
        }

        pageMethod("GetTodayStatus", {
            request: {
                Status: status,
                FromDate: fromDate,
                ToDate: toDate,
                ProjectId: parseInt($("#ts_project").val(), 10) || 0,
                Process: process,
                DealNo: dealNo
            }
        }).done(function (res) {
            if (!res.Success) {
                notify("error", "Status", res.Message || "Unable to load status.");
                renderStatusTable([]);
                return;
            }
            renderStatusTable(res.Rows || []);
            $("#ts_total_count").text((res.Rows || []).length);
            $("#ts_status_name").text($("#ts_status option:selected").text());
            $("#ts_range_label").text(fromDate === toDate ? fromDate : fromDate + " to " + toDate);
            $("#ts_table_note").text((res.Rows || []).length ? "Loaded " + (res.Rows || []).length + " record(s)" : "No records found");
        }).fail(function () {
            notify("error", "Status", "Unable to load status.");
        });
    }

    function renderStatusTable(rows) {
        var selector = "#ts_status_table";
        if ($.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().destroy();
        }
        $(selector).empty();

        if (!rows || rows.length === 0) {
            $(selector).append("<thead><tr><th>Status</th></tr></thead><tbody><tr><td>No records found.</td></tr></tbody>");
            $("#ts_total_count").text("0");
            return;
        }

        var keys = Object.keys(rows[0]);
        var columns = keys.map(function (key) {
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
            pageLength: 15,
            dom: "Bfrtip",
            buttons: ["excel", "csv", "print"],
            order: []
        });
    }

    function resetFilters() {
        $("#ts_status").val("Pending");
        $("#ts_from_date,#ts_to_date").val(todayIso());
        $("#ts_project").val("");
        $("#ts_process").empty().append($("<option/>").val("").text("Select Process"));
        $("#ts_deal").val("");
        $("#ts_status_name").text("Pending");
        $("#ts_range_label").text("Today");
        $("#ts_table_note").text("No records loaded");
        renderStatusTable([]);
    }

    function escapeHtml(value) {
        return $("<div/>").text(value === null || value === undefined ? "" : value).html();
    }

    $(function () {
        $("#ts_from_date,#ts_to_date").val(todayIso());
        loadProjects();
        renderStatusTable([]);

        $("#ts_project").on("change", loadProcesses);
        $("#ts_btn_show").on("click", showStatus);
        $("#ts_btn_reset").on("click", resetFilters);
    });
})();