(function () {
    "use strict";

    var modes = ["allocation", "reallocation", "complete"];
    var importHeaders = ["ProjectNo", "DealNo", "Date", "LoanNo", "Pseudo Name", "Process"];

    function pageMethod(method, payload) {
        return $.ajax({
            type: "POST",
            url: "OrderAllocation.aspx/" + method,
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

    function setBusy(mode, isBusy) {
        $('.oa-import[data-mode="' + mode + '"]').prop("disabled", isBusy);
    }

    function fillProjects(rows) {
        modes.forEach(function (mode) {
            var $project = $("#oa_project_" + mode);
            $project.empty().append($("<option/>").val("").text("Select Project"));
            $.each(rows || [], function (_, item) {
                var id = item.ProjectId || item.ProjectID || item.ProjectID1 || item.ID || item.ProjectID;
                var name = item.ProjectName || item.Project || item.Name || id;
                if (id !== undefined && id !== null && String(id) !== "") {
                    $project.append($("<option/>").val(id).text(name));
                }
            });
            $("#oa_process_" + mode).empty().append($("<option/>").val("").text("Select Process"));
        });
    }

    function loadProjects() {
        pageMethod("GetProjects").done(function (res) {
            if (!res.Success) {
                notify("error", "Projects", res.Message || "Unable to load projects.");
                return;
            }
            fillProjects(res.Rows);
        }).fail(function () {
            notify("error", "Projects", "Unable to load projects.");
        });
    }

    function loadProcesses(mode) {
        var projectId = parseInt($("#oa_project_" + mode).val(), 10) || 0;
        var $process = $("#oa_process_" + mode);
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

    function readFile(file) {
        var deferred = $.Deferred();
        var reader = new FileReader();
        reader.onload = function (event) { deferred.resolve(event.target.result); };
        reader.onerror = function () { deferred.reject(); };
        reader.readAsDataURL(file);
        return deferred.promise();
    }

    function importMode(mode) {
        var projectId = parseInt($("#oa_project_" + mode).val(), 10) || 0;
        var projectName = $("#oa_project_" + mode + " option:selected").text();
        var process = $("#oa_process_" + mode).val();
        var fileInput = $("#oa_file_" + mode)[0];

        if (!projectId) {
            notify("warning", "Validation", "Please select Project.");
            return;
        }
        if (!process) {
            notify("warning", "Validation", "Please select Process.");
            return;
        }
        if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
            notify("warning", "Validation", "Please select import file.");
            return;
        }

        var file = fileInput.files[0];
        setBusy(mode, true);
        readFile(file).done(function (content) {
            pageMethod("ImportOrders", {
                request: {
                    ProjectId: projectId,
                    ProjectName: projectName,
                    ProcessName: process,
                    Mode: mode,
                    FileName: file.name,
                    ContentBase64: content
                }
            }).done(function (res) {
                renderResult(mode, res);
                if (res.Success) {
                    notify(res.FailedRows > 0 ? "warning" : "success", "Import", res.Message || "Import completed.");
                } else {
                    notify("error", "Import", res.Message || "Import failed.");
                }
            }).fail(function () {
                notify("error", "Import", "Import failed.");
            }).always(function () {
                setBusy(mode, false);
            });
        }).fail(function () {
            setBusy(mode, false);
            notify("error", "File", "Unable to read selected file.");
        });
    }

    function renderResult(mode, res) {
        $("#oa_total_" + mode).text(res && res.TotalRows ? res.TotalRows : 0);
        $("#oa_success_" + mode).text(res && res.SuccessRows ? res.SuccessRows : 0);
        $("#oa_failed_count_" + mode).text(res && res.FailedRows ? res.FailedRows : 0);
        renderTable("#oa_failed_" + mode, res && res.NotAddedRows ? res.NotAddedRows : []);
    }

    function renderTable(selector, rows) {
        if ($.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().destroy();
        }

        $(selector).empty();
        if (!rows || rows.length === 0) {
            $(selector).append("<thead><tr><th>Status</th></tr></thead><tbody><tr><td>No failed rows.</td></tr></tbody>");
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
            pageLength: 10,
            dom: "Bfrtip",
            buttons: ["excel", "csv"],
            order: []
        });
    }

    function downloadTemplate(mode) {
        var sample = [
            importHeaders.join(","),
            "561,SampleDeal,01/31/2026,SampleLoan,PSEUDO1,Loan Setup"
        ].join("\r\n");
        var blob = new Blob([sample], { type: "text/csv;charset=utf-8;" });
        var link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "Order_" + mode + "_Template.csv";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    function escapeHtml(value) {
        return $("<div/>").text(value === null || value === undefined ? "" : value).html();
    }

    $(function () {
        loadProjects();

        $(".oa-project").on("change", function () {
            loadProcesses($(this).data("mode"));
        });

        $(".oa-import").on("click", function () {
            importMode($(this).data("mode"));
        });

        $(".oa-template").on("click", function () {
            downloadTemplate($(this).data("mode"));
        });

        modes.forEach(function (mode) {
            renderResult(mode, { TotalRows: 0, SuccessRows: 0, FailedRows: 0, NotAddedRows: [] });
        });
    });
})();