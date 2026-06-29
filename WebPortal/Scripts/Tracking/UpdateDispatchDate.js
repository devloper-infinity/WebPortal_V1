(function () {
    "use strict";

    var currentLoanRows = [];
    var currentLoanColumns = [];
    var currentMeta = null;

    function pageMethod(method, payload) {
        return $.ajax({
            type: "POST",
            url: "UpdateDispatchDate.aspx/" + method,
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

    function setBusy(isBusy) {
        $("#udd_btn_show,#udd_btn_send,#udd_btn_import").prop("disabled", isBusy);
    }

    function loadProjects() {
        pageMethod("GetProjects").done(function (res) {
            var $project = $("#udd_project");
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

    function loadDeals() {
        var projectId = parseInt($("#udd_project").val(), 10) || 0;
        var $deal = $("#udd_deal");
        $deal.empty().append($("<option/>").val("").text("Select Deal"));
        clearLoans();

        if (!projectId) {
            return;
        }

        pageMethod("GetDeals", { projectId: projectId }).done(function (res) {
            if (!res.Success) {
                notify("error", "Deals", res.Message || "Unable to load deals.");
                return;
            }
            $.each(res.Rows || [], function (_, item) {
                var deal = item.DealNo || item.DealNumber || item.OrderNo || item.Value;
                if (deal !== undefined && deal !== null && String(deal) !== "" && String(deal) !== "0") {
                    $deal.append($("<option/>").val(deal).text(deal));
                }
            });
        }).fail(function () {
            notify("error", "Deals", "Unable to load deals.");
        });
    }

    function loadHistory() {
        pageMethod("GetDispatchHistory").done(function (res) {
            renderObjectTable("#udd_history_table", res.Success ? res.Rows : []);
        }).fail(function () {
            renderObjectTable("#udd_history_table", []);
        });
    }

    function loadLoans() {
        var projectId = parseInt($("#udd_project").val(), 10) || 0;
        var projectNo = $("#udd_project option:selected").text();
        var dealNo = $("#udd_deal").val();

        if (!projectId) {
            notify("warning", "Validation", "Please select Project.");
            return;
        }
        if (!dealNo) {
            notify("warning", "Validation", "Please select DealNo.");
            return;
        }

        setBusy(true);
        pageMethod("GetDispatchLoans", {
            request: {
                ProjectId: projectId,
                ProjectNo: projectNo,
                DealNo: dealNo
            }
        }).done(function (res) {
            if (!res.Success) {
                notify("error", "Loans", res.Message || "Unable to load loans.");
                clearLoans();
                return;
            }
            currentLoanRows = res.Rows || [];
            currentLoanColumns = res.Columns || [];
            currentMeta = res.Meta || null;
            renderLoanTable();
            $("#udd_loaded_count").text(currentLoanRows.length);
            $("#udd_grid_note").text(currentLoanRows.length ? "Loaded " + currentLoanRows.length + " loan(s)" : "No records found");
        }).fail(function () {
            notify("error", "Loans", "Unable to load loans.");
        }).always(function () {
            setBusy(false);
        });
    }

    function renderLoanTable() {
        var selector = "#udd_loans_table";
        if ($.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().destroy();
        }
        $(selector).empty();

        var columns = [{
            title: '<input type="checkbox" id="udd_select_all" />',
            data: null,
            orderable: false,
            width: "34px",
            render: function () {
                return '<input type="checkbox" class="udd-row-check" />';
            }
        }];

        $.each(currentLoanColumns, function (_, col) {
            columns.push({
                title: escapeHtml(col.Title || col.Data),
                data: col.Data,
                render: function (value) { return escapeHtml(value); }
            });
        });

        $(selector).DataTable({
            data: currentLoanRows,
            columns: columns,
            destroy: true,
            scrollX: true,
            autoWidth: false,
            pageLength: 10,
            dom: "Bfrtip",
            buttons: ["excel", "csv"],
            order: []
        });

        updateSelectedCount();
    }

    function clearLoans() {
        currentLoanRows = [];
        currentLoanColumns = [];
        currentMeta = null;
        $("#udd_loaded_count,#udd_selected_count").text("0");
        $("#udd_grid_note").text("No deal loaded");
        renderLoanTable();
    }

    function selectedRows() {
        var table = $("#udd_loans_table").DataTable();
        var rows = [];
        $("#udd_loans_table tbody .udd-row-check:checked").each(function () {
            var data = table.row($(this).closest("tr")).data();
            if (data) {
                rows.push(data);
            }
        });
        return rows;
    }

    function updateSelectedCount() {
        $("#udd_selected_count").text(selectedRows().length);
    }

    function saveDispatch() {
        var projectId = parseInt($("#udd_project").val(), 10) || 0;
        var projectNo = $("#udd_project option:selected").text();
        var dealNo = $("#udd_deal").val();
        var dispatchDate = $("#udd_dispatch_date").val();
        var rows = selectedRows();

        if (!projectId) {
            notify("warning", "Validation", "Please select Project.");
            return;
        }
        if (!dealNo) {
            notify("warning", "Validation", "Please select DealNo.");
            return;
        }
        if (!dispatchDate) {
            notify("warning", "Validation", "Please select Dispatch date.");
            return;
        }
        if (!rows.length) {
            notify("warning", "Validation", "Please select at least one loan.");
            return;
        }

        Swal.fire({
            icon: "question",
            title: "Send to Onshore?",
            text: "Selected loan(s) will be updated with the dispatch date.",
            showCancelButton: true,
            confirmButtonText: "Yes, Send"
        }).then(function (result) {
            if (!result.isConfirmed) {
                return;
            }
            setBusy(true);
            pageMethod("SaveDispatchDate", {
                request: {
                    ProjectId: projectId,
                    ProjectNo: projectNo,
                    DealNo: dealNo,
                    DispatchDate: dispatchDate,
                    Meta: currentMeta,
                    Rows: rows
                }
            }).done(function (res) {
                notify(res.Success ? "success" : "error", "Dispatch", res.Message || "Dispatch update completed.");
                if (res.Success) {
                    loadHistory();
                    loadLoans();
                }
            }).fail(function () {
                notify("error", "Dispatch", "Unable to update dispatch date.");
            }).always(function () {
                setBusy(false);
            });
        });
    }

    function importDispatch() {
        var fileInput = $("#udd_import_file")[0];
        if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
            notify("warning", "Validation", "Please select import file.");
            return;
        }

        var file = fileInput.files[0];
        setBusy(true);
        readFile(file).done(function (content) {
            pageMethod("ImportDispatchDates", {
                request: {
                    FileName: file.name,
                    ContentBase64: content
                }
            }).done(function (res) {
                $("#udd_failed_count").text(res.FailedRows || 0);
                renderObjectTable("#udd_failed_table", res.NotAddedRows || []);
                $("#udd_failed_panel").toggle((res.NotAddedRows || []).length > 0);
                notify(res.Success && !res.FailedRows ? "success" : "warning", "Import", res.Message || "Import completed.");
                loadHistory();
            }).fail(function () {
                notify("error", "Import", "Import failed.");
            }).always(function () {
                setBusy(false);
            });
        }).fail(function () {
            setBusy(false);
            notify("error", "File", "Unable to read selected file.");
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

    function renderObjectTable(selector, rows) {
        if ($.fn.DataTable.isDataTable(selector)) {
            $(selector).DataTable().destroy();
        }
        $(selector).empty();

        if (!rows || rows.length === 0) {
            $(selector).append("<thead><tr><th>Status</th></tr></thead><tbody><tr><td>No records found.</td></tr></tbody>");
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

    function downloadTemplate() {
        var csv = "DealNo,LoanNo,ProjectNo,DispatchDate\r\nSampleDeal,SampleLoan,561,01/31/2026";
        var blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
        var link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = "Dispatch_Date_Template.csv";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    function escapeHtml(value) {
        return $("<div/>").text(value === null || value === undefined ? "" : value).html();
    }

    $(function () {
        loadProjects();
        loadHistory();
        clearLoans();

        $("#udd_project").on("change", loadDeals);
        $("#udd_deal").on("change", clearLoans);
        $("#udd_btn_show").on("click", loadLoans);
        $("#udd_btn_send").on("click", saveDispatch);
        $("#udd_btn_import").on("click", importDispatch);
        $("#udd_btn_template").on("click", downloadTemplate);

        $("#udd_loans_table").on("change", ".udd-row-check", updateSelectedCount);
        $("#udd_loans_table").on("change", "#udd_select_all", function () {
            $("#udd_loans_table tbody .udd-row-check").prop("checked", this.checked);
            updateSelectedCount();
        });
    });
})();