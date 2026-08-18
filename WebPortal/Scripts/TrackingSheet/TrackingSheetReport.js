(function ($) {
    "use strict";
    var pageUrl = "TrackingSheetReport.aspx", reportTable = null;

    function popup(icon, title, message) { Swal.fire({ icon: icon, title: title, text: message, confirmButtonText: "OK" }); }
    function webMethod(name, data) { return $.ajax({ url: pageUrl + "/" + name, type: "POST", contentType: "application/json; charset=utf-8", dataType: "json", data: JSON.stringify(data || {}) }); }
    function errorMessage(xhr) { try { return JSON.parse(xhr.responseText).Message || "A system error occurred."; } catch (e) { return "A system error occurred."; } }
    function escapeHtml(value) { return $("<div>").text(value == null ? "" : value).html(); }
    function flowStats(row) {
        var result = { total: 0, completed: 0, skipped: 0, pending: 0, current: null, currentLabel: '', focus: [], more: 0 };
        $.each(row.Processes || [], function (_, p) { var status = String(p.Status || 'Pending').toLowerCase(); result.total++; if (status === 'completed') result.completed++; else if (status === 'skipped') result.skipped++; else result.pending++; if (p.IsCurrent) result.current = p; });
        result.progress = result.total ? Math.round(((result.completed + result.skipped) * 100) / result.total) : 0;
        if (result.current) {
            var currentStatus = String(result.current.Status || 'Pending').toLowerCase(), candidates = [];
            if (currentStatus === 'in process') {
                result.currentLabel = 'In Process';
                candidates = $.grep(row.Processes || [], function (p) { return String(p.Status || '').toLowerCase() === 'in process'; });
            } else if (currentStatus === 'hold' || currentStatus === 'on hold') {
                result.currentLabel = 'On Hold';
                candidates = $.grep(row.Processes || [], function (p) { var status = String(p.Status || '').toLowerCase(); return status === 'hold' || status === 'on hold'; });
            } else if (result.current.IsMandatory) {
                result.currentLabel = 'Next required';
                candidates = $.grep(row.Processes || [], function (p) { var status = String(p.Status || 'Pending').toLowerCase(); return p.IsMandatory && +p.Sequence === +result.current.Sequence && status !== 'completed' && status !== 'skipped' && status !== 'in process' && status !== 'hold' && status !== 'on hold'; });
            } else {
                result.currentLabel = 'Optional remaining';
                candidates = $.grep(row.Processes || [], function (p) { var status = String(p.Status || 'Pending').toLowerCase(); return !p.IsMandatory && status !== 'completed' && status !== 'skipped' && status !== 'in process' && status !== 'hold' && status !== 'on hold'; });
            }
            result.focus = $.map(candidates, function (p) { return String(p.ProcessID); }); result.more = Math.max(0, candidates.length - 1);
        } else result.currentLabel = result.progress === 100 ? 'Flow complete' : 'Not started';
        return result;
    }
    function processSummary(row) {
        var stats = flowStats(row);
        if (!stats.total) return '<span class="text-muted">No configured process flow</span>';
        return '<div class="tr-process-summary"><div class="tr-progress-head"><strong>' + stats.progress + '% complete</strong><span>' + (stats.completed + stats.skipped) + ' / ' + stats.total + '</span></div>' +
            '<div class="tr-progress-track"><div class="tr-progress-value" style="width:' + stats.progress + '%"></div></div>' +
            '<div class="tr-progress-meta"><span>' + stats.completed + ' completed</span><span>' + stats.pending + ' pending</span><span>' + stats.skipped + ' skipped</span></div>' +
            '<div class="tr-current-process">' + escapeHtml(stats.currentLabel) + (stats.current ? ': ' + escapeHtml(stats.current.ProcessName) + (stats.more ? ' <span class="text-muted">(+' + stats.more + ' more)</span>' : '') : '') + '</div>' +
            '<button type="button" class="tr-flow-toggle">View process flow</button></div>';
    }
    function workedTime(minutes) { minutes = +minutes || 0; return Math.floor(minutes / 60) + ':' + String(minutes % 60).padStart(2, '0'); }
    function processExportSummary(row) { var stats = flowStats(row), hourly = $.map(row.Processes || [], function (p) { return p.ManualDurationMinutes == null ? null : p.ProcessName + ' ' + workedTime(p.ManualDurationMinutes) + ' hours'; }); if (!stats.total) return 'No configured process flow'; return stats.progress + '% complete | ' + stats.completed + ' completed | ' + stats.pending + ' pending | ' + stats.skipped + ' skipped | ' + stats.currentLabel + (stats.current ? ': ' + stats.current.ProcessName + (stats.more ? ' (+' + stats.more + ' more)' : '') : '') + (hourly.length ? ' | Hours worked: ' + hourly.join(', ') : ''); }
    function processDetails(row) {
        var grouped = {}, order = [], stats = flowStats(row);
        $.each(row.Processes || [], function (_, p) { var key = String(p.Sequence); if (!grouped[key]) { grouped[key] = []; order.push(key); } grouped[key].push(p); });
        var stages = $.map(order, function (key) { var current = false, cards = $.map(grouped[key], function (p) { var status = String(p.Status || 'Pending'), normalizedStatus = status.toLowerCase(), css = normalizedStatus.replace(/\s+/g, '-'), userName = p.ProcessUser || p.CompletedBy || '', userLine = '', focused = stats.focus.indexOf(String(p.ProcessID)) >= 0; if (userName && normalizedStatus === 'completed') userLine = '<span class="tr-process-user">Completed by: ' + escapeHtml(userName) + '</span>'; else if (userName && normalizedStatus === 'in process') userLine = '<span class="tr-process-user">In process by: ' + escapeHtml(userName) + '</span>'; else if (userName && (normalizedStatus === 'hold' || normalizedStatus === 'on hold')) userLine = '<span class="tr-process-user">On hold by: ' + escapeHtml(userName) + '</span>'; if (p.ManualDurationMinutes != null) userLine += '<span class="tr-process-user">Hours worked: ' + workedTime(p.ManualDurationMinutes) + '</span>'; current = current || focused; return '<div class="tr-process-step ' + css + (focused ? ' current' : '') + '"><strong>' + escapeHtml(p.ProcessName) + '</strong><small><span class="tr-status-dot"></span>' + escapeHtml(status) + (p.IsMandatory ? ' • Mandatory' : ' • Can skip') + (p.IsFinalProcess ? ' • Final' : '') + '</small>' + userLine + '</div>'; }).join(''); return '<section class="tr-stage' + (current ? ' current' : '') + '"><div class="tr-stage-title"><span>Stage ' + escapeHtml(key) + '</span><span>' + grouped[key].length + ' process' + (grouped[key].length === 1 ? '' : 'es') + '</span></div><div class="tr-stage-processes">' + cards + '</div></section>'; }).join('');
        return '<div class="tr-flow-detail"><div class="tr-flow-detail-head"><h4>Configured process flow</h4><span>' + stats.completed + ' completed · ' + stats.pending + ' pending · ' + stats.skipped + ' skipped</span></div><div class="tr-stage-grid">' + stages + '</div></div>';
    }

    function loadProjects() {
        webMethod("GetProjects").done(function (response) {
            var html = '<option value="">Select Project</option>';
            $.each(response.d || [], function (_, p) { html += '<option value="' + p.ID + '">' + $('<div>').text(p.Name).html() + '</option>'; });
            $("#trProject").html(html);
        }).fail(function (xhr) { popup("error", "System Error", errorMessage(xhr)); });
    }

    function showReport() {
        var projectId = parseInt($("#trProject").val(), 10) || 0, fromDate = $("#trFromDate").val(), toDate = $("#trToDate").val();
        if (!projectId) { popup("warning", "Validation", "Please select a project."); return; }
        if (!fromDate || !toDate) { popup("warning", "Validation", "Please select From and To Order Dates."); return; }
        if (fromDate > toDate) { popup("warning", "Validation", "From Order Date cannot be later than To Order Date."); return; }

        $("#trShow").prop("disabled", true); $("#trLoading").show();
        webMethod("GetReport", { projectId: projectId, fromDate: fromDate, toDate: toDate }).done(function (response) {
            var result = response.d;
            var projectName = $("#trProject option:selected").text();
            var safeProjectName = projectName.replace(/[^a-z0-9_-]+/gi, "_");
            if (reportTable) { reportTable.destroy(); reportTable = null; }
            $("#trTable").empty();
            var reportColumnCount = result.Columns.length + 1, footer = '<tfoot><tr>';
            for (var footerIndex = 0; footerIndex < reportColumnCount; footerIndex++) footer += '<th></th>';
            $("#trTable").html(footer + '</tr></tfoot>');
            reportTable = $("#trTable").DataTable({
                data: result.Rows,
                columns: [{ data: null, title: "Process Progress", width: "300px", orderable: false, searchable: false, render: function (_, type, row) { return type === 'display' ? processSummary(row) : processExportSummary(row); } }].concat($.map(result.Columns, function (name) { return { data: function (row) { return row.Values && row.Values[name] || ''; }, title: name, defaultContent: "", className: "text-nowrap" }; })),
                scrollX: true, scrollY: "58vh", scrollCollapse: true, responsive: false, autoWidth: false,
                pageLength: 25, lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]], ordering: true,
                footerCallback: function () { var api = this.api(), count = api.rows({ search: 'applied' }).count(); $(api.column(0).footer()).text('Total: ' + count + ' record(s)'); },
                dom: "<'row mb-2'<'col-sm-12 col-md-6'B><'col-sm-12 col-md-6'f>>" +
                     "<'row'<'col-sm-12'tr>>" +
                     "<'row mt-2'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
                buttons: [{
                    extend: "excelHtml5",
                    text: '<i class="fas fa-file-excel"></i> Export Excel',
                    className: "btn btn-success",
                    title: "Tracking Sheet Report - " + projectName,
                    filename: "Tracking_Sheet_Report_" + safeProjectName + "_" + fromDate + "_to_" + toDate,
                    messageTop: "Project: " + projectName + " | Order Date: " + fromDate + " to " + toDate,
                    footer: true,
                    exportOptions: { columns: ":visible", modifier: { search: "applied", order: "applied", page: "all" } }
                }]
            });
            $("#trSummary").text(result.RowCount + " record(s) | " + result.Columns.length + " configured tracking column(s) | Deal-wise flow overrides are applied automatically");
            $("#trResults").show(); reportTable.columns.adjust();
            $("#trTable tbody").off("click", ".tr-flow-toggle").on("click", ".tr-flow-toggle", function () { var button = $(this), tableRow = button.closest("tr"), row = reportTable.row(tableRow); if (row.child.isShown()) { row.child.hide(); tableRow.removeClass("shown"); button.text("View process flow"); } else { row.child(processDetails(row.data())).show(); tableRow.addClass("shown"); button.text("Hide process flow"); } });
            if (!result.RowCount) popup("info", "No Records", "No records were found for the selected project and date range.");
        }).fail(function (xhr) { popup("error", "Report Failed", errorMessage(xhr)); }).always(function () { $("#trShow").prop("disabled", false); $("#trLoading").hide(); });
    }

    $(function () {
        var today = new Date(), first = new Date(today.getFullYear(), today.getMonth(), 1), iso = function (d) { return d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0"); };
        $("#trFromDate").val(iso(first)); $("#trToDate").val(iso(today)); loadProjects(); $("#trShow").on("click", showReport);
    });
})(jQuery);
