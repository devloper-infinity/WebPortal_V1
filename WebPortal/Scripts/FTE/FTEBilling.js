var fteBillingTable;
var fteBillingRows = [];
var fteBillingLoadingDepth = 0;
var fteBillingLoadingGuard = null;

function BindBillingProject() {
    if (!document.getElementById("fte_billingProject") || typeof PageMethods === "undefined" || !PageMethods.GetAllProjects) {
        return;
    }

    setFteBillingLoading(true);
    PageMethods.GetAllProjects(function (result) {
        try {
            var projects = parseFteBillingPayload(result);
            var $project = $("#fte_billingProject");
            $project.empty().append($("<option></option>").val("Select").html("Select"));

            $.each(projects, function (_index, value) {
                var projectId = getFteBillingValue(value, ["ProjectID", "ProjectId"]);
                var projectName = getFteBillingValue(value, ["ProjectName", "Project"]);
                if (projectId && projectName) {
                    $project.append($("<option></option>").val(projectId).html(projectName));
                }
            });
        }
        catch (ex) {
            showFteBillingMessage("Unable to load projects. " + ex.message, "danger");
        }
        finally {
            setFteBillingLoading(false);
        }
    }, function (error) {
        setFteBillingLoading(false);
        showFteBillingMessage(error.get_message ? error.get_message() : error.responseText, "danger");
    });
}

function getBillingCycle(project) {
    var projectId = project.options[project.selectedIndex].value;
    $("#fte_billingCycle").html('<option value="Select">Select</option>');
    $("#fte_BillingPeriod").html('<option value="Select">Select</option>');
    resetFteBillingReport();

    if (projectId === "Select") {
        return false;
    }

    setFteBillingLoading(true);
    PageMethods.getBillingPeriodByProject(parseInt(projectId, 10), function (cycle) {
        $("#fte_billingCycle").html('<option value="Select">Select</option>');
        if (cycle) {
            $("#fte_billingCycle").append($("<option></option>").val(cycle).html(cycle));
            $("#fte_billingCycle").val(cycle);
            BindBillingPeriod(cycle);
        }
        setFteBillingLoading(false);
    }, function (error) {
        setFteBillingLoading(false);
        showFteBillingMessage(error.get_message ? error.get_message() : error.responseText, "danger");
    });

    return false;
}

function getBillingPeriod(billingCycle) {
    var cycle = billingCycle.options[billingCycle.selectedIndex].value;
    $("#fte_BillingPeriod").html('<option value="Select">Select</option>');
    resetFteBillingReport();

    if (cycle !== "Select") {
        BindBillingPeriod(cycle);
    }

    return false;
}

function BindBillingPeriod(billingCycle) {
    setFteBillingLoading(true);
    PageMethods.GetBillingPeriod(billingCycle, function (result) {
        try {
            var periods = parseFteBillingPayload(result);
            var $period = $("#fte_BillingPeriod");
            $period.empty().append($("<option></option>").val("Select").html("Select"));

            $.each(periods, function (_index, value) {
                var billingPeriod = getFteBillingValue(value, ["BillingPeriod", "Period", "DateRange"]);
                if (billingPeriod) {
                    var formattedPeriod = formatFteBillingPeriod(billingPeriod);
                    $period.append($("<option></option>").val(formattedPeriod).html(formattedPeriod));
                }
            });
        }
        catch (ex) {
            showFteBillingMessage("Unable to load billing periods. " + ex.message, "danger");
        }
        finally {
            setFteBillingLoading(false);
        }
    }, function (error) {
        setFteBillingLoading(false);
        showFteBillingMessage(error.get_message ? error.get_message() : error.responseText, "danger");
    });
}

function btnShowFteBilling() {
    var selection = getFteBillingSelection();
    if (!selection) {
        return false;
    }

    setFteBillingLoading(true);
    PageMethods.GetBillingReport(selection.projectId, selection.billingPeriod, function (result) {
        try {
            var report = parseFteBillingPayload(result);
            fteBillingRows = report.Rows || [];
            renderFteBillingSummary(report.Summary || {});
            initializeFteBillingTable(fteBillingRows);
            showFteBillingMessage("Billing report loaded.", "success");
        }
        catch (ex) {
            showFteBillingMessage("Unable to load billing report. " + ex.message, "danger");
        }
        finally {
            setFteBillingLoading(false);
        }
    }, function (error) {
        setFteBillingLoading(false);
        showFteBillingMessage(error.get_message ? error.get_message() : error.responseText, "danger");
    });

    return false;
}

function btnSubmitSendToAccounts() {
    var selection = getFteBillingSelection();
    if (!selection) {
        return false;
    }

    if (!window.confirm("Send this FTE billing to Accounts?")) {
        return false;
    }

    setFteBillingLoading(true);
    PageMethods.SendToAccounts(selection.projectId, selection.projectName, selection.billingCycle, selection.billingPeriod, $("#fte_billingRemark").val(), function (result) {
        try {
            var response = parseFteBillingPayload(result);
            showFteBillingMessage(response.Message || "Billing submitted.", response.Success ? "success" : "danger");
        }
        catch (ex) {
            showFteBillingMessage("Unable to send billing. " + ex.message, "danger");
        }
        finally {
            setFteBillingLoading(false);
        }
    }, function (error) {
        setFteBillingLoading(false);
        showFteBillingMessage(error.get_message ? error.get_message() : error.responseText, "danger");
    });

    return false;
}

function initializeFteBillingTable(rows) {
    var columns = rows && rows.length ? Object.keys(rows[0]) : [];
    var $table = $("#tableFteBilling");

    if ($.fn.dataTable.isDataTable("#tableFteBilling")) {
        fteBillingTable.destroy();
    }

    if (!columns.length) {
        $table.find("thead").html("<tr><th>Billing Details</th></tr>");
        $table.find("tbody").html('<tr><td class="text-center text-muted">No billing data available</td></tr>');
        $("#billingRecordLabel").text("Current records");
        return;
    }

    var thead = "<tr>";
    $.each(columns, function (_index, column) {
        thead += "<th>" + escapeFteBillingHtml(column) + "</th>";
    });
    thead += "</tr>";

    var tbody = "";
    $.each(rows, function (_rowIndex, row) {
        tbody += "<tr>";
        $.each(columns, function (_index, column) {
            tbody += "<td>" + escapeFteBillingHtml(formatFteBillingValue(row[column])) + "</td>";
        });
        tbody += "</tr>";
    });

    $table.find("thead").html(thead);
    $table.find("tbody").html(tbody);
    $("#billingRecordLabel").text(rows.length + " records");

    fteBillingTable = $table.DataTable({
        destroy: true,
        pageLength: 50,
        ordering: false,
        autoWidth: false,
        dom: "<'row align-items-center mb-2'<'col-md-4'l><'col-md-4 text-center'B><'col-md-4'f>>" +
            "rt<'row align-items-center mt-2'<'col-md-5'i><'col-md-7'p>>",
        buttons: [
            { extend: "excelHtml5", text: '<i class="fas fa-file-excel"></i> Excel', className: "btn btn-sm" },
            { extend: "print", text: '<i class="fas fa-print"></i> Print', className: "btn btn-sm" }
        ]
    });
}

function renderFteBillingSummary(summary) {
    $("#metricBillingRows").text(getFteBillingValue(summary, ["RecordCount"]) || 0);
    $("#metricAverageFte").text(getFteBillingValue(summary, ["AverageBilledFTE"]) || "-");
    $("#metricBillableHours").text(getFteBillingValue(summary, ["BillableHours"]) || "-");
    $("#metricTotalFteHours").text(getFteBillingValue(summary, ["TotalFTEHours"]) || "-");
    $("#metricWorkingHours").text(getFteBillingValue(summary, ["WorkingHours"]) || "-");
    $("#metricInvoiceCount").text(getFteBillingValue(summary, ["InvoiceCount"]) || "-");
    $("#metricTimeMins").text(getFteBillingValue(summary, ["TimeMins"]) || "-");
    $("#metricTimeHrs").text(getFteBillingValue(summary, ["TimeHrs"]) || "-");
}

function resetFteBilling() {
    $("#fte_billingProject").val("Select");
    $("#fte_billingCycle").html('<option value="Select">Select</option>');
    $("#fte_BillingPeriod").html('<option value="Select">Select</option>');
    $("#fte_billingRemark").val("");
    resetFteBillingReport();
    return false;
}

function resetFteBillingReport() {
    fteBillingRows = [];
    renderFteBillingSummary({});
    initializeFteBillingTable([]);
}

function getFteBillingSelection() {
    var $project = $("#fte_billingProject");
    var projectId = $project.val();
    var billingCycle = $("#fte_billingCycle").val();
    var billingPeriod = $("#fte_BillingPeriod").val();

    if (!projectId || projectId === "Select") {
        showFteBillingMessage("Please select project.", "warning");
        return null;
    }

    if (!billingCycle || billingCycle === "Select") {
        showFteBillingMessage("Please select billing cycle.", "warning");
        return null;
    }

    if (!billingPeriod || billingPeriod === "Select") {
        showFteBillingMessage("Please select billing period.", "warning");
        return null;
    }

    return {
        projectId: parseInt(projectId, 10),
        projectName: $project.find("option:selected").text(),
        billingCycle: billingCycle,
        billingPeriod: billingPeriod
    };
}

function setFteBillingLoading(isLoading) {
    if (isLoading) {
        fteBillingLoadingDepth += 1;
        toggleFteBillingLoader(true);

        if (!fteBillingLoadingGuard) {
            fteBillingLoadingGuard = window.setTimeout(function () {
                fteBillingLoadingDepth = 0;
                toggleFteBillingLoader(false);
                fteBillingLoadingGuard = null;
            }, 30000);
        }
    }
    else {
        fteBillingLoadingDepth = Math.max(0, fteBillingLoadingDepth - 1);

        if (fteBillingLoadingDepth === 0) {
            toggleFteBillingLoader(false);
            if (fteBillingLoadingGuard) {
                window.clearTimeout(fteBillingLoadingGuard);
                fteBillingLoadingGuard = null;
            }
        }
    }

    $("#btnBillingShow, #btnSendToAccounts, #btnBillingReset").prop("disabled", fteBillingLoadingDepth > 0);
}

function toggleFteBillingLoader(show) {
    $("#load1")
        .toggleClass("is-visible", show)
        .attr("aria-hidden", show ? "false" : "true");
}

function showFteBillingMessage(message, type) {
    var css = "alert alert-" + (type || "info");
    $("#billingMessage").removeClass().addClass(css).text(message).show();

    window.setTimeout(function () {
        $("#billingMessage").fadeOut(150);
    }, 5000);
}

function parseFteBillingPayload(result) {
    var payload = result && result.d ? result.d : result;

    if (!payload) {
        return [];
    }

    if ($.isArray(payload) || typeof payload === "object") {
        return payload;
    }

    return JSON.parse(payload);
}

function getFteBillingValue(row, keys) {
    for (var index = 0; index < keys.length; index++) {
        if (row && row[keys[index]] !== undefined && row[keys[index]] !== null) {
            return row[keys[index]];
        }
    }

    return "";
}

function formatFteBillingValue(value) {
    if (value === undefined || value === null) {
        return "";
    }

    var text = String(value);
    var dotNetDate = /\/Date\((\d+)(?:[+-]\d+)?\)\//.exec(text);
    if (dotNetDate) {
        var date = new Date(parseInt(dotNetDate[1], 10));
        if (!isNaN(date.getTime())) {
            return date.toLocaleDateString("en-GB", { day: "2-digit", month: "short", year: "numeric" }).replace(/ /g, "-");
        }
    }

    return text;
}

function formatFteBillingPeriod(value) {
    var monthNames = {
        jan: "Jan", january: "Jan",
        feb: "Feb", february: "Feb",
        mar: "Mar", march: "Mar",
        apr: "Apr", april: "Apr",
        may: "May",
        jun: "Jun", june: "Jun",
        jul: "Jul", july: "Jul",
        aug: "Aug", august: "Aug",
        sep: "Sep", sept: "Sep", september: "Sep",
        oct: "Oct", october: "Oct",
        nov: "Nov", november: "Nov",
        dec: "Dec", december: "Dec"
    };
    var parts = String(value).trim().split(/\s+(?:to|~)\s+/i);

    if (parts.length !== 2) {
        return String(value);
    }

    function formatDatePart(dateText, fallbackYear) {
        var match = dateText.trim().match(/^(\d{1,2})[-\/]([A-Za-z]+)[-\/](\d{2}|\d{4})$/);
        if (!match) {
            return null;
        }

        var month = monthNames[match[2].toLowerCase()];
        var year = match[3].length === 4 ? match[3] : fallbackYear;
        return month && year ? ("0" + match[1]).slice(-2) + "-" + month + "-" + year : null;
    }

    var fromYearMatch = parts[0].match(/(\d{4})\s*$/);
    var fromYear = fromYearMatch ? fromYearMatch[1] : null;
    var fromDate = formatDatePart(parts[0], null);
    var toDate = formatDatePart(parts[1], fromYear);
    return fromDate && toDate ? fromDate + " ~ " + toDate : String(value);
}

function escapeFteBillingHtml(value) {
    return $("<div/>").text(value === undefined || value === null ? "" : value).html();
}
