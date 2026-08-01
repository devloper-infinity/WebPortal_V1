(function ($) {
    "use strict";
    var pageUrl = "UpdateBillingParameters.aspx";

    function popup(icon, title, message) {
        Swal.fire({ icon: icon, title: title, text: message, confirmButtonText: "OK" });
    }

    function webMethod(name, data) {
        return $.ajax({ url: pageUrl + "/" + name, type: "POST", contentType: "application/json; charset=utf-8", dataType: "json", data: JSON.stringify(data || {}) });
    }

    function errorMessage(xhr) {
        try { return JSON.parse(xhr.responseText).Message || "A system error occurred."; }
        catch (e) { return "A system error occurred."; }
    }

    function loadProjects() {
        webMethod("GetProjects").done(function (response) {
            var projects = response.d || [], html = '<option value="">Select Project</option>';
            $.each(projects, function (_, p) { html += '<option value="' + p.ID + '">' + $('<div>').text(p.Name).html() + '</option>'; });
            $("#bpProject").html(html);
        }).fail(function (xhr) { popup("error", "System Error", errorMessage(xhr)); });
    }

    function loadFields() {
        var projectId = parseInt($("#bpProject").val(), 10) || 0;
        if (!projectId) { $("#bpFields").text("Select a project to view its billing parameter columns."); return; }
        webMethod("GetBillingFields", { projectId: projectId }).done(function (response) {
            var fields = response.d || [];
            $("#bpFields").text(fields.length ? "Dynamic billing parameter columns: " + fields.join(", ") : "No additional billing parameters are configured. Dispatch Date only will be updated.");
        }).fail(function (xhr) { popup("error", "System Error", errorMessage(xhr)); });
    }

    function downloadTemplate() {
        var projectId = parseInt($("#bpProject").val(), 10) || 0;
        if (!projectId) { popup("warning", "Validation", "Please select a project."); return; }
        $("#bpDownload").prop("disabled", true);
        fetch(pageUrl + "?action=download&projectId=" + projectId, { credentials: "same-origin" })
            .then(function (response) {
                if (!response.ok) return response.json().then(function (x) { throw new Error(x.Message); });
                var disposition = response.headers.get("content-disposition") || "";
                var match = /filename=([^;]+)/i.exec(disposition);
                return response.blob().then(function (blob) { return { blob: blob, name: match ? match[1].replace(/[\"']/g, "") : "Update_Billing_Parameters.xlsx" }; });
            })
            .then(function (file) {
                var url = URL.createObjectURL(file.blob), link = document.createElement("a");
                link.href = url; link.download = file.name; document.body.appendChild(link); link.click(); link.remove(); URL.revokeObjectURL(url);
                popup("success", "Template Ready", "The billing parameter template was downloaded successfully.");
            })
            .catch(function (error) { popup("error", "Download Failed", error.message || "Unable to download the template."); })
            .finally(function () { $("#bpDownload").prop("disabled", false); });
    }

    function importTemplate() {
        var projectId = parseInt($("#bpProject").val(), 10) || 0, file = $("#bpFile")[0].files[0];
        if (!projectId) { popup("warning", "Validation", "Please select a project."); return; }
        if (!file) { popup("warning", "Validation", "Please select an Excel template."); return; }
        if (!/\.xlsx$/i.test(file.name)) { popup("warning", "Invalid File", "Only .xlsx files are accepted."); return; }
        if (file.size > 10 * 1024 * 1024) { popup("warning", "Invalid File", "The selected file exceeds the 10 MB limit."); return; }

        var form = new FormData(); form.append("file", file);
        $("#bpImport").prop("disabled", true); $("#bpLoading").show();
        fetch(pageUrl + "?action=import&projectId=" + projectId, { method: "POST", body: form, credentials: "same-origin" })
            .then(function (response) { return response.json().then(function (x) { if (!response.ok || !x.Success) throw new Error(x.Message); return x; }); })
            .then(function (result) { $("#bpFile").val(""); popup(result.HasWarnings ? "warning" : "success", result.HasWarnings ? "Import Completed with Warnings" : "Import Successful", result.Message); })
            .catch(function (error) { popup("error", "Import Failed", error.message || "Import failure or system error."); })
            .finally(function () { $("#bpImport").prop("disabled", false); $("#bpLoading").hide(); });
    }

    $(function () { loadProjects(); $("#bpProject").on("change", loadFields); $("#bpDownload").on("click", downloadTemplate); $("#bpImport").on("click", importTemplate); });
})(jQuery);
