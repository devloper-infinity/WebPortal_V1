(function ($) {
    "use strict";
    var pageUrl = "TrackingSheetReport.aspx", reportTable = null;

    function popup(icon, title, message) { Swal.fire({ icon: icon, title: title, text: message, confirmButtonText: "OK" }); }
    function webMethod(name, data) { return $.ajax({ url: pageUrl + "/" + name, type: "POST", contentType: "application/json; charset=utf-8", dataType: "json", data: JSON.stringify(data || {}) }); }
    function errorMessage(xhr) { try { return JSON.parse(xhr.responseText).Message || "A system error occurred."; } catch (e) { return "A system error occurred."; } }

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
            reportTable = $("#trTable").DataTable({
                data: result.Rows,
                columns: $.map(result.Columns, function (name) { return { data: name, title: name, defaultContent: "", className: "text-nowrap" }; }),
                scrollX: true, scrollY: "58vh", scrollCollapse: true, responsive: false, autoWidth: false,
                pageLength: 25, lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]], ordering: true,
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
                    exportOptions: { columns: ":visible", modifier: { search: "applied", order: "applied", page: "all" } }
                }]
            });
            $("#trSummary").text(result.RowCount + " record(s) | " + result.Columns.length + " column(s)");
            $("#trResults").show(); reportTable.columns.adjust();
            if (!result.RowCount) popup("info", "No Records", "No records were found for the selected project and date range.");
        }).fail(function (xhr) { popup("error", "Report Failed", errorMessage(xhr)); }).always(function () { $("#trShow").prop("disabled", false); $("#trLoading").hide(); });
    }

    $(function () {
        var today = new Date(), first = new Date(today.getFullYear(), today.getMonth(), 1), iso = function (d) { return d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + String(d.getDate()).padStart(2, "0"); };
        $("#trFromDate").val(iso(first)); $("#trToDate").val(iso(today)); loadProjects(); $("#trShow").on("click", showReport);
    });
})(jQuery);
