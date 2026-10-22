(function () {
    $(document).ready(function () {
        var lmsearch_busySelector = window.location.pathname.toLowerCase().indexOf("lmsearchdetails.aspx") >= 0
            ? "#lmsearchdetails_load1" : "#lmsearch_loading";
        var lmsearch_busyElement = $(lmsearch_busySelector).appendTo(document.documentElement)[0];
        if (lmsearch_busyElement) {
            lmsearch_busyElement.style.setProperty("position", "fixed", "important");
            lmsearch_busyElement.style.setProperty("top", "0", "important");
            lmsearch_busyElement.style.setProperty("left", "0", "important");
            lmsearch_busyElement.style.setProperty("align-items", "center", "important");
            lmsearch_busyElement.style.setProperty("justify-content", "center", "important");
            lmsearch_busyElement.style.setProperty("z-index", "2147483647", "important");
        }
        function lmsearch_fitLoader() {
            if (!lmsearch_busyElement) return;
            lmsearch_busyElement.style.setProperty("width", "150vw", "important");
            lmsearch_busyElement.style.setProperty("height", "150vh", "important");
            var box = lmsearch_busyElement.querySelector(".lmsearch-loading-box");
            if (!box) return;
            box.style.setProperty("position", "fixed", "important");
            box.style.setProperty("left", "0", "important");
            box.style.setProperty("top", "0", "important");
            function centerBox(attempt) {
                var rect = box.getBoundingClientRect();
                box.style.setProperty("left", ((parseFloat(box.style.left) || 0) + window.innerWidth / 2 - rect.left - rect.width / 2) + "px", "important");
                box.style.setProperty("top", ((parseFloat(box.style.top) || 0) + window.innerHeight / 2 - rect.top - rect.height / 2) + "px", "important");
                if (attempt < 3) requestAnimationFrame(function () { centerBox(attempt + 1); });
            }
            centerBox(0);
        }
        $(window).on("resize", lmsearch_fitLoader);
        $(document).ajaxStart(function () {
            $(lmsearch_busySelector).addClass("lmsearch-loading-active");
            lmsearch_fitLoader();
        });
        $(document).ajaxStop(function () { $(lmsearch_busySelector).removeClass("lmsearch-loading-active"); });
    });
}());

(function () {
    "use strict";

    function lmsearch_formatDateTime(value) {
        var match = typeof value === "string" && /\/Date\((-?\d+)(?:[+-]\d+)?\)\//.exec(value);
        if (!match) return value == null ? "" : value;

        var date = new Date(parseInt(match[1], 10));
        var pad = function (number) { return String(number).padStart(2, "0"); };
        return pad(date.getMonth() + 1) + "/" + pad(date.getDate()) + "/" + date.getFullYear() +
            " " + pad(date.getHours()) + ":" + pad(date.getMinutes()) + ":" + pad(date.getSeconds());
    }

    function lmsearch_escape(value) {
        return $("<div/>").text(value == null ? "" : String(value)).html();
    }

    function lmsearch_statusColumn() {
        function lmsearch_statusDate(value) {
            var match = /^(\d{4})-(\d{2})-(\d{2})/.exec(value || "");
            return match ? match[3] + "-" + ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][parseInt(match[2], 10) - 1] + "-" + match[1] : value;
        }
        function lmsearch_statusMarkup(status, process, employee, date) {
            var completed = status === "Completed";
            var started = status === "Started";
            var css = completed ? "reqc-completed" : (started ? "reqc-assigned" : "reqc-not-assigned");
            var icon = completed ? "fas fa-check-circle" : (started ? "fas fa-user-clock" : "far fa-circle");
            var detail = process ? "<strong>" + lmsearch_escape(process) + "</strong><br>" : "";
            if (employee) detail += (completed ? "Completed by " : "Started by ") + lmsearch_escape(employee);
            if (date) detail += (employee ? " &bull; " : "") + lmsearch_escape(lmsearch_statusDate(date));
            return '<div class="reqc-status-item"><span class="reqc-pill ' + css + '"><i class="' + icon + '"></i> ' + lmsearch_escape(status) + '</span>' +
                (detail ? '<span class="reqc-detail">' + detail + '</span>' : '') + '</div>';
        }
        return {
            data: null,
            title: "Process Status",
            className: "reqc-cell",
            render: function (data, type, row) {
                var summary = row._ProcessSummary || "";
                if (summary) {
                    if (type !== "display") return summary.replace(/\|\|/g, " ");
                    return summary.split("||").map(function (item) {
                        var parts = item.split(" - "), head = parts.shift(), marker = head.lastIndexOf(": ");
                        return lmsearch_statusMarkup(head.substring(marker + 2), head.substring(0, marker), parts[0] || "", parts[1] || "");
                    }).join("");
                }
                var status = row._ProcessStatus || "Not Started";
                var process = row._ProcessName || row.Process || "";
                var employee = row._ProcessEmployeeName || "";
                var date = lmsearch_formatDateTime(row._ProcessStatusDate || "");
                if (type !== "display") return status + " " + process + " " + employee;
                return lmsearch_statusMarkup(status, process, employee, date);
            }
        };
    }

    function lmsearch_openDetails(lmsearch_row, lmsearch_trackId) {
        var lmsearch_payload = {
            client: lmsearch_row.Client || "",
            recordID: lmsearch_row.Id || "",
            loanID: lmsearch_row["Loan #"] || lmsearch_row.LoanID || lmsearch_row.LoanNo || "",
            process: lmsearch_row.Process || "",
            script: lmsearch_row.Script || "",
            orderDate: lmsearch_formatDateTime(lmsearch_row["Order Date"] || lmsearch_row.OrderDate || ""),
            trackID: parseInt(lmsearch_trackId, 10) || 0,
            started: true
        };
        window.location.href = "LMSearchDetails.aspx?data=" + encodeURIComponent(btoa(JSON.stringify(lmsearch_payload)));
    }

    function lmsearch_loadLoans() {
        var tableSelector = "#lmsearch_table";
        $("#lmsearch_loading").addClass("lmsearch-loading-active");

        $.ajax({
            url: "LMSearch.aspx/getLoansForGlobalSearch",
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                var rows = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
                rows = rows || [];
                var columns = [];

                if (rows.length) {
                    Object.keys(rows[0]).forEach(function (columnName) {
                        if (columnName.toLowerCase() !== "status" && columnName.indexOf("_Process") !== 0 && columnName !== "_CanStart") {
                            columns.push({
                                data: columnName,
                                title: columnName,
                                visible: columnName.toLowerCase() !== "id",
                                defaultContent: "",
                                render: function (value, type) {
                                    if (type === "display" || type === "filter") return lmsearch_formatDateTime(value);
                                    return value;
                                }
                            });
                        }
                    });
                }

                columns.push(lmsearch_statusColumn());
                columns.push({
                    data: null,
                    title: "Action",
                    orderable: false,
                    searchable: false,
                    className: "text-center",
                    render: function (data, type, row) {
                        var disabled = row._CanStart === false || String(row._CanStart).toLowerCase() === "false";
                        return '<button type="button" class="btn btn-sm btn-primary lmsearch_start"' +
                            (disabled ? ' disabled="disabled"' : "") + '>Start</button>';
                    }
                });

                if ($.fn.DataTable.isDataTable(tableSelector)) {
                    $(tableSelector).DataTable().clear().destroy();
                }

                $(tableSelector).empty().DataTable({
                    data: rows,
                    columns: columns,
                    paging: true,
                    pageLength: 25,
                    ordering: false,
                    searching: true,
                    autoWidth: false,
                    scrollX: true,
                    deferRender: true,
                    initComplete: function () { $("#lmsearch_loading").hide(); }
                });

                $(tableSelector + " tbody").off("click", ".lmsearch_start").on("click", ".lmsearch_start", function () {
                    var row = $(tableSelector).DataTable().row($(this).closest("tr")).data();
                    $.ajax({
                        url: "LMSearch.aspx/StartLoan",
                        type: "POST",
                        data: JSON.stringify({
                            ProcessID: parseInt(row.ProcessID, 10) || 0,
                            Client: row.Client || "",
                            LoanNo: row["Loan #"] || row.LoanID || row.LoanNo || "",
                            OrderDate: lmsearch_formatDateTime(row["Order Date"] || row.OrderDate || ""),
                            Process: row.Process || "",
                            Script: row.Script || ""
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (lmsearch_result) { lmsearch_openDetails(row, lmsearch_result.d); }
                    });
                });
            },
            error: function (xhr) {
                $("#lmsearch_loading").hide();
                console.error(xhr.responseText);
                alert("Unable to load LauraMac loans.");
            }
        });
    }

    $(document).ready(lmsearch_loadLoans);
}());

(function (lmsearchdetails_global) {
    "use strict";

    var lmsearchdetails_payload = null;
    var lmsearchdetails_rows = [];

    function lmsearchdetails_element(lmsearchdetails_name) {
        return document.getElementById("lmsearchdetails_" + lmsearchdetails_name);
    }

    function lmsearchdetails_value(lmsearchdetails_name) {
        var lmsearchdetails_control = lmsearchdetails_element(lmsearchdetails_name);
        return lmsearchdetails_control ? $.trim(lmsearchdetails_control.value || "") : "";
    }

    function lmsearchdetails_decodePayload() {
        var lmsearchdetails_encoded = new URLSearchParams(window.location.search).get("data");
        if (!lmsearchdetails_encoded) return {};
        try { return JSON.parse(atob(lmsearchdetails_encoded)); } catch (lmsearchdetails_error) { return {}; }
    }

    function lmsearchdetails_post(lmsearchdetails_method, lmsearchdetails_data, lmsearchdetails_success) {
        $.ajax({
            url: "LMSearchDetails.aspx/" + lmsearchdetails_method,
            type: "POST",
            data: JSON.stringify(lmsearchdetails_data || {}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: lmsearchdetails_success,
            error: function (lmsearchdetails_xhr) {
                NativePopup.fire("Error", lmsearchdetails_xhr.responseText || "Unexpected error occurred.", "error");
            }
        });
    }

    function lmsearchdetails_parse(lmsearchdetails_result) {
        var lmsearchdetails_data = lmsearchdetails_result && lmsearchdetails_result.d;
        return typeof lmsearchdetails_data === "string" ? JSON.parse(lmsearchdetails_data || "[]") : (lmsearchdetails_data || []);
    }

    function lmsearchdetails_formatDate(lmsearchdetails_value) {
        var lmsearchdetails_match = typeof lmsearchdetails_value === "string" && /\/Date\((-?\d+)(?:[+-]\d+)?\)\//.exec(lmsearchdetails_value);
        var lmsearchdetails_date = lmsearchdetails_match ? new Date(parseInt(lmsearchdetails_match[1], 10)) : new Date(lmsearchdetails_value);
        if (isNaN(lmsearchdetails_date.getTime())) return "";
        var lmsearchdetails_pad = function (lmsearchdetails_number) { return String(lmsearchdetails_number).padStart(2, "0"); };
        return lmsearchdetails_pad(lmsearchdetails_date.getMonth() + 1) + "/" + lmsearchdetails_pad(lmsearchdetails_date.getDate()) + "/" + lmsearchdetails_date.getFullYear();
    }

    function lmsearchdetails_bindUser() {
        lmsearchdetails_post("GetLoggedInUser", {}, function (lmsearchdetails_result) {
            var lmsearchdetails_data = lmsearchdetails_parse(lmsearchdetails_result);
            if (lmsearchdetails_data.length) {
                lmsearchdetails_element("reviewer").value = lmsearchdetails_data[0].FullName || "";
                lmsearchdetails_element("reviewer").readOnly = true;
            }
        });
    }

    function lmsearchdetails_bindLoan() {
        lmsearchdetails_post("GetLoanDetailsbyLoanID_LauraMac", {
            RecordID: parseInt(lmsearchdetails_payload.recordID || lmsearchdetails_payload.loanID, 10) || 0,
            Process: lmsearchdetails_payload.process || lmsearchdetails_payload.script || "",
            TaskName: ""
        }, function (lmsearchdetails_result) {
            var lmsearchdetails_data = lmsearchdetails_parse(lmsearchdetails_result);
            if (!lmsearchdetails_data.length) return;
            var lmsearchdetails_loan = lmsearchdetails_data[0];
            var lmsearchdetails_client = lmsearchdetails_loan.Client || lmsearchdetails_payload.client || "";
            var lmsearchdetails_loanID = lmsearchdetails_payload.loanID || lmsearchdetails_loan.LoanID || "";
            lmsearchdetails_element("client").value = lmsearchdetails_client;
            lmsearchdetails_element("loanid").value = lmsearchdetails_loanID;
            lmsearchdetails_element("qcername").value = lmsearchdetails_loan.taskAssignedUser || "";
            lmsearchdetails_element("qcerdate").value = lmsearchdetails_formatDate(lmsearchdetails_loan.completedDate);
            lmsearchdetails_element("clientinfo").innerHTML = "Feedback Information for - <b style='color:green;'>" + lmsearchdetails_escape(lmsearchdetails_client) + "</b>";
            lmsearchdetails_bindTasks();
        });
    }

    function lmsearchdetails_escape(lmsearchdetails_text) {
        return $("<div/>").text(lmsearchdetails_text == null ? "" : String(lmsearchdetails_text)).html();
    }

    function lmsearchdetails_bindTasks() {
        var lmsearchdetails_task = $(lmsearchdetails_element("task")).empty().append('<option value="">Select</option>');
        lmsearchdetails_post("GetUSProcessTask", {
            Client: lmsearchdetails_value("client"),
            LoanID: lmsearchdetails_value("loanid"),
            Process: lmsearchdetails_payload.process || "",
            Script: lmsearchdetails_payload.script || "",
            FromMyQueue: !!lmsearchdetails_payload.started
        }, function (lmsearchdetails_result) {
            $.each(lmsearchdetails_parse(lmsearchdetails_result), function (_, lmsearchdetails_process) {
                lmsearchdetails_task.append($("<option></option>").val(lmsearchdetails_process.ProcessID).text(lmsearchdetails_process.ProcessName));
            });
            lmsearchdetails_task.find("option").each(function () {
                if ($.trim($(this).text()).toLowerCase() === $.trim(lmsearchdetails_payload.process || "").toLowerCase()) {
                    lmsearchdetails_task.val(this.value);
                    return false;
                }
            });
            if (!lmsearchdetails_task.val() && lmsearchdetails_task.find("option").length === 2) lmsearchdetails_task.prop("selectedIndex", 1);
            if (lmsearchdetails_task.val()) lmsearchdetails_taskChanged(lmsearchdetails_task[0]);
        });
    }

    function lmsearchdetails_toggle(lmsearchdetails_name, lmsearchdetails_show) {
        var lmsearchdetails_control = lmsearchdetails_element(lmsearchdetails_name);
        if (lmsearchdetails_control) lmsearchdetails_control.style.display = lmsearchdetails_show ? "" : "none";
    }

    function lmsearchdetails_taskChanged(lmsearchdetails_select) {
        var lmsearchdetails_taskName = lmsearchdetails_select.options[lmsearchdetails_select.selectedIndex].text;
        var lmsearchdetails_isAtr = lmsearchdetails_taskName === "ATR Review";
        lmsearchdetails_toggle("trOther", !!lmsearchdetails_select.value && !lmsearchdetails_isAtr);
        ["tratr1", "tratr2", "tratr3", "tratr4", "tratr5"].forEach(function (lmsearchdetails_name) {
            lmsearchdetails_toggle(lmsearchdetails_name, lmsearchdetails_isAtr);
        });
        if (lmsearchdetails_isAtr && !lmsearchdetails_value("reviewdate")) lmsearchdetails_element("reviewdate").value = new Date().toISOString().slice(0, 10);
        if (lmsearchdetails_select.value) {
            lmsearchdetails_post("StartLoan", {
                ProcessID: parseInt(lmsearchdetails_select.value, 10), Client: lmsearchdetails_value("client"), LoanID: lmsearchdetails_value("loanid"),
                OrderDate: lmsearchdetails_payload.orderDate || "", Process: lmsearchdetails_taskName, Review: lmsearchdetails_value("reviewer"),
                StartDatetime: "", Script: lmsearchdetails_payload.script || ""
            }, function () {
                lmsearchdetails_bindTaskReviewer(lmsearchdetails_taskName);
                lmsearchdetails_bindFeedback(lmsearchdetails_isAtr ? "ATR" : "Other", lmsearchdetails_select.value);
            });
        }
        return false;
    }

    function lmsearchdetails_bindTaskReviewer(lmsearchdetails_taskName) {
        lmsearchdetails_post("GetLoanDetailsbyLoanID_LauraMac", {
            RecordID: parseInt(lmsearchdetails_payload.recordID || lmsearchdetails_payload.loanID, 10) || 0,
            Process: lmsearchdetails_payload.process || lmsearchdetails_payload.script || "",
            TaskName: lmsearchdetails_taskName
        }, function (lmsearchdetails_result) {
            var lmsearchdetails_data = lmsearchdetails_parse(lmsearchdetails_result);
            if (!lmsearchdetails_data.length) return;
            lmsearchdetails_element("qcername").value = lmsearchdetails_data[0].taskAssignedUser || "";
            lmsearchdetails_element("qcerdate").value = lmsearchdetails_formatDate(lmsearchdetails_data[0].completedDate);
        });
    }

    function lmsearchdetails_feedbackRequest(lmsearchdetails_type, lmsearchdetails_processID) {
        return { LoanID: lmsearchdetails_value("loanid"), Type: lmsearchdetails_type, ProcessID: parseInt(lmsearchdetails_processID, 10) || 0, Script: lmsearchdetails_payload.script || "" };
    }

    function lmsearchdetails_bindFeedback(lmsearchdetails_type, lmsearchdetails_processID) {
        lmsearchdetails_post("GetATRDetails", lmsearchdetails_feedbackRequest(lmsearchdetails_type, lmsearchdetails_processID), function (lmsearchdetails_result) {
            lmsearchdetails_rows = lmsearchdetails_parse(lmsearchdetails_result);
            var lmsearchdetails_columns = [];
            if (lmsearchdetails_rows.length) {
                Object.keys(lmsearchdetails_rows[0]).forEach(function (lmsearchdetails_key) {
                    if (lmsearchdetails_key !== "Deal #" && lmsearchdetails_key !== "Client Deal #") lmsearchdetails_columns.push({ data: lmsearchdetails_key, title: lmsearchdetails_key, defaultContent: "" });
                });
            }
            if (lmsearchdetails_type === "Other") lmsearchdetails_columns.push({
                data: null, title: "Action", orderable: false, searchable: false,
                render: function (lmsearchdetails_data, lmsearchdetails_typeName, lmsearchdetails_rowData, lmsearchdetails_meta) {
                    return '<button type="button" class="btn btn-sm btn-primary lmsearchdetails_edit" data-index="' + lmsearchdetails_meta.row + '">Edit</button> ' +
                        '<button type="button" class="btn btn-sm btn-danger lmsearchdetails_delete" data-index="' + lmsearchdetails_meta.row + '">Delete</button>';
                }
            });
            var lmsearchdetails_table = "#lmsearchdetails_table";
            if ($.fn.DataTable.isDataTable(lmsearchdetails_table)) $(lmsearchdetails_table).DataTable().destroy();
            $(lmsearchdetails_table).empty().DataTable({ data: lmsearchdetails_rows, columns: lmsearchdetails_columns, paging: true, searching: true, scrollX: true, autoWidth: false });
            $(lmsearchdetails_table).off("click", ".lmsearchdetails_edit").on("click", ".lmsearchdetails_edit", function () { lmsearchdetails_edit(parseInt($(this).attr("data-index"), 10)); });
            $(lmsearchdetails_table).off("click", ".lmsearchdetails_delete").on("click", ".lmsearchdetails_delete", function () { lmsearchdetails_delete(parseInt($(this).attr("data-index"), 10), lmsearchdetails_processID); });
        });
    }

    function lmsearchdetails_submit() {
        var lmsearchdetails_task = lmsearchdetails_element("task");
        var lmsearchdetails_processID = parseInt(lmsearchdetails_task.value, 10) || 0;
        var lmsearchdetails_taskName = lmsearchdetails_task.options[lmsearchdetails_task.selectedIndex].text;
        if (!lmsearchdetails_task.value) { NativePopup.fire("Validation", "Please select task.", "warning"); return false; }

        if (lmsearchdetails_taskName === "ATR Review") {
            var lmsearchdetails_atr = {
                ProcessID: lmsearchdetails_processID,
                LoanID: lmsearchdetails_value("loanid"), Reviewer: lmsearchdetails_value("reviewer"), ReviewDate: lmsearchdetails_value("reviewdate"),
                ATRSupported: lmsearchdetails_value("atrsupported"), ReviewFindings: lmsearchdetails_value("reviewfindings"),
                SellerDisclosedDTIIssue: lmsearchdetails_value("dtiissue"), NoOfBorrowers: lmsearchdetails_value("noofbwr"),
                HighestBorrowerIncomeType: lmsearchdetails_value("incometype"), NoOfSEBusiness: lmsearchdetails_value("noofsebus"),
                NoOfRentalProperties: lmsearchdetails_value("noofrental"), Comments: lmsearchdetails_value("comments"), Script: lmsearchdetails_payload.script || ""
            };
            if (!lmsearchdetails_atr.ATRSupported || !lmsearchdetails_atr.NoOfBorrowers || !lmsearchdetails_atr.ReviewFindings || !lmsearchdetails_atr.NoOfSEBusiness || !lmsearchdetails_atr.NoOfRentalProperties) {
                NativePopup.fire("Validation", "Complete all required ATR fields.", "warning"); return false;
            }
            lmsearchdetails_post("InsertATRFeedbacks", lmsearchdetails_atr, function (lmsearchdetails_result) { lmsearchdetails_saved(lmsearchdetails_result.d, "ATR", lmsearchdetails_processID); });
            return false;
        }

        var lmsearchdetails_severity = lmsearchdetails_value("severity");
        var lmsearchdetails_finding = lmsearchdetails_value("finding");
        if (!lmsearchdetails_severity || !lmsearchdetails_finding) { NativePopup.fire("Validation", "Severity and Findings are required.", "warning"); return false; }
        var lmsearchdetails_editKey = lmsearchdetails_value("editkey");
        var lmsearchdetails_saveMethod = lmsearchdetails_editKey ? "UpdateOtherFeedback" : "InsertOtherFeedbacks";
        var lmsearchdetails_saveData = {
            ProcessID: lmsearchdetails_processID,
            LoanID: lmsearchdetails_value("loanid"), Finding: lmsearchdetails_finding, Severity: lmsearchdetails_severity, Script: lmsearchdetails_payload.script || ""
        };
        if (lmsearchdetails_editKey) lmsearchdetails_saveData.FeedbackKey = lmsearchdetails_editKey;
        lmsearchdetails_post(lmsearchdetails_saveMethod, lmsearchdetails_saveData, function (lmsearchdetails_result) {
            if (lmsearchdetails_result.d > 0) {
                if (lmsearchdetails_editKey) { lmsearchdetails_cancelEdit(); lmsearchdetails_saved(1, "Other", lmsearchdetails_processID); return; }
                lmsearchdetails_post("InsertUSImportedFeedback_NewERP", {
                    LoanID: lmsearchdetails_value("loanid"), Client: lmsearchdetails_value("client"), UWName: lmsearchdetails_value("qcername"),
                    DateReviewed: lmsearchdetails_value("qcerdate"), QCDate: new Date().toLocaleDateString("en-US"), Finding: lmsearchdetails_finding,
                    Severity: lmsearchdetails_severity, Source: "ReQC", FeedbackReceivedDate: new Date().toLocaleDateString("en-US"),
                    ProcessID: lmsearchdetails_processID
                }, function () { lmsearchdetails_saved(1, "Other", lmsearchdetails_processID); });
            } else lmsearchdetails_saved(lmsearchdetails_result.d, "Other", lmsearchdetails_processID);
        });
        return false;
    }

    function lmsearchdetails_edit(lmsearchdetails_index) {
        var lmsearchdetails_row = lmsearchdetails_rows[lmsearchdetails_index];
        if (!lmsearchdetails_row) return false;
        lmsearchdetails_element("editkey").value = lmsearchdetails_row["Feedback Key"] || "";
        lmsearchdetails_element("severity").value = lmsearchdetails_row.Severity || "";
        lmsearchdetails_element("finding").value = lmsearchdetails_row.Finding || "";
        $(lmsearchdetails_element("btncanceledit")).show();
        return false;
    }

    function lmsearchdetails_delete(lmsearchdetails_index, lmsearchdetails_processID) {
        var lmsearchdetails_row = lmsearchdetails_rows[lmsearchdetails_index];
        if (!lmsearchdetails_row) return false;
        lmsearchdetails_post("DeleteOtherFeedback", {
            FeedbackKey: lmsearchdetails_row["Feedback Key"] || "",
            ProcessID: parseInt(lmsearchdetails_processID, 10) || 0, LoanID: lmsearchdetails_value("loanid"), Client: lmsearchdetails_value("client"),
            Finding: lmsearchdetails_row.Finding || "", Severity: lmsearchdetails_row.Severity || "", Script: lmsearchdetails_payload.script || ""
        }, function (lmsearchdetails_result) {
            if (lmsearchdetails_result.d > 0) lmsearchdetails_bindFeedback("Other", lmsearchdetails_processID);
            else NativePopup.fire("Error", "Unable to delete feedback.", "error");
        });
        return false;
    }

    function lmsearchdetails_saved(lmsearchdetails_result, lmsearchdetails_type, lmsearchdetails_processID) {
        if (lmsearchdetails_result > 0) {
            NativePopup.fire("Success", "Feedback submitted successfully.", "success");
            lmsearchdetails_bindFeedback(lmsearchdetails_type, lmsearchdetails_processID);
        } else NativePopup.fire("Error", "Unable to save feedback.", "error");
    }

    function lmsearchdetails_complete() {
        var lmsearchdetails_task = lmsearchdetails_element("task");
        if (!lmsearchdetails_task.value) { NativePopup.fire("Validation", "Please select task.", "warning"); return false; }
        lmsearchdetails_post("CompleteLoan", {
            ProcessID: parseInt(lmsearchdetails_task.value, 10) || 0, Client: lmsearchdetails_value("client"), LoanID: lmsearchdetails_value("loanid"),
            OrderDate: lmsearchdetails_payload.orderDate || "", Process: lmsearchdetails_task.options[lmsearchdetails_task.selectedIndex].text,
            Review: lmsearchdetails_value("reviewer"), StartDatetime: "", Script: lmsearchdetails_payload.script || ""
        }, function (lmsearchdetails_result) {
            if (lmsearchdetails_result.d > 0) window.location.href = "LMSearch.aspx";
            else NativePopup.fire("Error", lmsearchdetails_result.d === -2 ? "Please add feedback before completing." : "Unable to complete loan.", "error");
        });
        return false;
    }

    function lmsearchdetails_syncNoError() {
        if (lmsearchdetails_value("severity") === "No Error") lmsearchdetails_element("finding").value = "No Error";
        return false;
    }

    function lmsearchdetails_cancelEdit() {
        lmsearchdetails_element("editkey").value = "";
        lmsearchdetails_element("severity").value = "";
        lmsearchdetails_element("finding").value = "";
        $(lmsearchdetails_element("btncanceledit")).hide();
        return false;
    }

    function lmsearchdetails_initialize() {
        lmsearchdetails_payload = lmsearchdetails_decodePayload();
        var lmsearchdetails_back = lmsearchdetails_element("back");
        if (lmsearchdetails_back) lmsearchdetails_back.href = lmsearchdetails_payload.src === "Dashboard" ? "Dashboard.aspx" : (lmsearchdetails_payload.src === "MyQueue" ? "MyQueue.aspx" : "LMSearch.aspx");
        lmsearchdetails_bindUser();
        lmsearchdetails_bindLoan();
    }

    lmsearchdetails_global.LMSearchDetails = {
        initializeDetails: lmsearchdetails_initialize,
        taskChanged: lmsearchdetails_taskChanged,
        submit: lmsearchdetails_submit,
        complete: lmsearchdetails_complete,
        syncNoError: lmsearchdetails_syncNoError,
        cancelEdit: lmsearchdetails_cancelEdit
    };
}(window));
