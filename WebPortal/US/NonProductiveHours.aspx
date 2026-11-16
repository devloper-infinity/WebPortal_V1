<%@ Page Title="Non-Productive Hours" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="NonProductiveHours.aspx.cs" Inherits="WebPortal.US.NonProductiveHours" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
    --ca-primary: #2563eb;
    --ca-primary-dark: #1d4ed8;
    --ca-primary-soft: #eff6ff;
    --ca-success: #16a34a;
    --ca-success-dark: #15803d;
    --ca-bg: #f5f7fb;
    --ca-surface: #ffffff;
    --ca-text: #111827;
    --ca-muted: #6b7280;
    --ca-border: #e5e7eb;
    --ca-ring: rgba(37, 99, 235, .18);
    --ca-shadow: 0 18px 45px rgba(15, 23, 42, .10);
    --ca-radius-lg: 20px;
    --ca-radius-md: 12px;
}

.nph-page {
    padding: 6px 0 28px;
    color: #172033;
}

.nph-hero,
.nph-panel {
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    background: #fff;
    box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
}

.nph-hero {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 20px 22px;
    margin-bottom: 16px;
    border-left: 4px solid #2563eb;
}

.nph-hero h1 {
    margin: 0 0 5px;
    font-size: 23px;
    font-weight: 800;
}

.nph-hero p {
    margin: 0;
    color: #64748b;
    font-size: 13px;
}

.nph-refresh {
    height: 38px;
    padding: 0 15px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    color: #334155;
    background: #fff;
    font-size: 12px;
    font-weight: 800;
    cursor: pointer;
    white-space: nowrap;
}

.nph-refresh:hover {
    color: #1d4ed8;
    border-color: #93c5fd;
    background: #eff6ff;
}

.nph-panel {
    padding: 20px 22px;
    margin-bottom: 16px;
}

.nph-panel-title {
    margin: 0 0 18px;
    font-size: 16px;
    font-weight: 800;
}

.nph-form-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    align-items: start;
}

.nph-field {
    min-width: 0;
}

.nph-label {
    display: block;
    height: 18px;
    margin: 0 0 7px;
    color: #334155;
    font-size: 12px;
    font-weight: 700;
}

.nph-required {
    color: #dc2626;
}

.nph-input,
.nph-select {
    width: 100%;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    background: #fff;
    color: #172033;
    font-size: 14px;
    box-sizing: border-box;
    height: 42px;
    padding: 8px 11px;
}

.nph-textarea {
    width: 100%;
    height: 90px;
    padding: 10px 11px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    background: #fff;
    color: #172033;
    font-size: 14px;
    box-sizing: border-box;
    resize: none;
}

.nph-field-full {
    grid-column: 1 / -1;
}

.nph-input:focus,
.nph-select:focus,
.nph-textarea:focus {
    outline: none;
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
}

.nph-duration {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}

.nph-duration small {
    display: block;
    margin-top: 5px;
    color: #64748b;
    font-size: 11px;
}

.nph-actions {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 16px;
}

.nph-save {
    height: 40px;
    min-width: 122px;
    padding: 0 18px;
    border: 0;
    border-radius: 7px;
    color: #fff;
    background: #2563eb;
    font-size: 13px;
    font-weight: 800;
    cursor: pointer;
}

.nph-save:hover {
    background: #1d4ed8;
}

.nph-save:disabled,
.nph-refresh:disabled {
    opacity: .65;
    cursor: not-allowed;
}

.nph-message {
    display: none;
    margin-bottom: 15px;
    padding: 10px 12px;
    border-radius: 7px;
    font-size: 13px;
    font-weight: 600;
}

.nph-message.success {
    display: block;
    color: #166534;
    background: #dcfce7;
    border: 1px solid #86efac;
}

.nph-message.error {
    display: block;
    color: #991b1b;
    background: #fee2e2;
    border: 1px solid #fca5a5;
}

.nph-table-wrap {
    overflow-x: auto;
}

.nph-table {
    width: 100% !important;
    border-collapse: collapse;
}

.nph-table thead th {
    padding: 12px 14px;
    border-bottom: 2px solid #dbeafe;
    color: #334155;
    background: #eff6ff;
    text-align: left;
    font-size: 12px;
    font-weight: 800;
}

.nph-table tbody td {
    padding: 12px 14px;
    border-bottom: 1px solid #e2e8f0;
    color: #334155;
    font-size: 13px;
    vertical-align: top;
}

.nph-empty {
    display: none;
    padding: 28px 12px;
    color: #64748b;
    text-align: center;
    font-size: 13px;
}

@media (max-width: 950px) {
    .nph-form-grid {
        grid-template-columns: 1fr;
    }

    .nph-hero {
        align-items: flex-start;
    }
}

.card-header, .box-header, .modal-header {
    background: linear-gradient(271deg, #143961 0%, #0d67cd 100%) !important;
    border-bottom: 1px solid var(--dash-border) !important;
    color: var(--dash-text) !important;
    border-radius: 18px 18px 0 0 !important;
}

#editNonProductiveModal .modal-title,
#editNonProductiveModal .card-title {
    color: #ffffff !important;
    font-weight: 700 !important;
    font-size: 17px !important;
    display: flex !important;
    align-items: center !important;
    gap: 10px !important;
}

.condition-hero {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    padding: 22px 24px;
    margin-bottom: 18px;
    color: #fff;
    background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
    border-radius: var(--ca-radius-lg);
    box-shadow: var(--ca-shadow);
    overflow: hidden;
    position: relative;
}

.condition-hero:after {
    content: "";
    position: absolute;
    right: -64px;
    top: -64px;
    width: 190px;
    height: 190px;
    border-radius: 999px;
    background: rgba(255, 255, 255, .15);
}

.condition-title-wrap {
    position: relative;
    z-index: 1;
    display: flex;
    align-items: center;
    gap: 14px;
}

.condition-title-icon {
    width: 46px;
    height: 46px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 16px;
    background: rgba(255, 255, 255, .18);
    box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .20);
    font-size: 20px;
}

.condition-title {
    margin: 0;
    font-size: 24px;
    line-height: 1.2;
    font-weight: 800;
    letter-spacing: -.02em;
}

.condition-subtitle {
    margin: 4px 0 0;
    color: rgba(255, 255, 255, .82);
    font-size: 13px;
}

.condition-card {
    width: 100%;
    border: 1px solid var(--ca-border);
    border-radius: var(--ca-radius-lg);
    background: var(--ca-surface);
    box-shadow: 0 14px 35px rgba(15, 23, 42, .07);
    overflow: hidden;
}

.condition-card-header {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 18px 20px;
    border-bottom: 1px solid var(--ca-border);
    background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
}

.condition-card-title {
    margin: 0;
    font-size: 16px;
    font-weight: 750;
    color: var(--ca-text);
}

.condition-card-hint {
    margin: 3px 0 0;
    color: var(--ca-muted);
    font-size: 12px;
}

.condition-card-body {
    padding: 18px 20px 22px;
}

.nph-time-input-container {
    position: relative;
    display: block;
    width: 100% !important; 
}

.nph-time-input-container .nph-select {
    width: 100% !important;
    height: 42px;
    padding: 8px 35px 8px 11px; 
    background-color: #ffffff; 
    color: #172033;         
    border: 1px solid #cbd5e1; 
    border-radius: 7px;
    cursor: pointer;
    font-size: 14px;
    box-sizing: border-box;
    outline: none;
}

.nph-time-input-container .nph-select:focus {
    border-color: #2563eb;     
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
}

.nph-time-picker-panel {
    display: none;
    position: absolute;
    top: 105%;
    left: 0;
    background-color: #ffffff;
    border: 1px solid #d0d7de;
    border-radius: 6px;
    box-shadow: 0 8px 24px rgba(140, 149, 159, 0.2); 
    z-index: 999;
    width: 100%;
    height: 180px;
    box-sizing: border-box;
}

.nph-time-picker-panel.active {
    display: flex;
}

.nph-time-column {
    flex: 1;
    overflow-y: auto;
    height: 100%;
    text-align: center;
    padding: 5px 0;
}

.nph-time-column:first-child {
    border-right: 1px solid #d0d7de;
}

.nph-time-column::-webkit-scrollbar {
    width: 4px;
}

.nph-time-column::-webkit-scrollbar-thumb {
    background: #d0d7de;
    border-radius: 4px;
}

.nph-time-option {
    padding: 8px 0;
    color: #24292e;            
    cursor: pointer;
    font-family: monospace;
    font-size: 1rem;
    user-select: none;
}

.nph-time-option:hover {
    background-color: #f3f4f6; 
    color: #0969da;
}

.nph-time-option.selected {
    background-color: #0969da; 
    color: #ffffff;            
    font-weight: bold;
}

.nph-clock-icon {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 14px;
    color: #888;
    pointer-events: none;
    z-index: 2;
}
    </style>

    <script>
        var nphTable = null;

        $(document).ready(function () {
            nphSetDefaultDate();

            $("#nph-save").on("click", nphSave);
            $("#nph-refresh").on("click", function () {
                nphLoadEntries();
                nphUpdateLoadEntries();
            });

            nphLoadEntries();
            nphUpdateLoadEntries();
        });

        function nphSetDefaultDate() {
            var today = new Date();
            var localDate = new Date(today.getTime() - (today.getTimezoneOffset() * 60000))
                .toISOString().slice(0, 10);
            $("#nph-date").val(localDate).attr("max", localDate);
        }

        function nphSave() {
            var entryDate = $("#nph-date").val();
            var starttime = $("#nph-starttime").val();
            var endtime = $("#nph-endtime").val();
            var Totalduration = $("#nph-Totalduration").val();
            var reason = $.trim($("#nph-reason").val());

            nphClearMessage();

            if (!entryDate) {
                nphSwalAlert("Error", "Please select a date.", "error");
                return;
                
            }

            if (Totalduration === 'Invalid time') {
                nphSwalAlert("Error", "End time must be later than start time.", "error");
                return;
               
            }
            if (starttime == "") {
                nphSwalAlert("Error", "Please select start time.", "error");
                return;
            }
            if (endtime == "") {
                nphSwalAlert("Error", "Please select end time.", "error");
                return;
            }
            if (!reason) {
                nphSwalAlert("Error", "Please enter a reason.", "error");
                return;
               
            }

            if (reason.length > 1000) {
                nphSwalAlert("Error", "Reason cannot exceed 1000 characters.", "error");
                return;

              
            }

            nphSetBusy(true);
            $.ajax({
                type: "POST",
                url: "NonProductiveHours.aspx/SaveEntry",
                data: JSON.stringify({
                    entryDate: entryDate,
                    starttime: starttime,
                    endtime: endtime,
                    Totalduration: Totalduration,
                    reason: reason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d || {};
                    if (!result.Success) {
                        nphSwalAlert("Error", result.Message || "The entry could not be saved.", "error");
                        return;
                    }

                    document.getElementById('nph-starttime').value = '';
                    document.getElementById('nph-endtime').value = '';
                    document.getElementById('nph-Totalduration').value = '';
                    document.getElementById('nph-reason').value = '';
                    nphSetDefaultDate();
                    nphShowMessage(result.Message, true);
                    setTimeout(function () {
                        nphClearMessage();
                    }, 3000);
                    nphRenderEntries(result.Entries || []);
                    nphUpdateLoadEntries();
                },
                error: function () {
                    nphSwalAlert("Error", result.Message || "The entry could not be saved. Please try again.", "error");
                    return;
                },
                complete: function () {
                    nphSetBusy(false);
                }
            });

            return false;
        }

        //Get Data For User
        function nphLoadEntries() {
            nphSetBusy(true);
            $.ajax({
                type: "POST",
                url: "NonProductiveHours.aspx/GetEntries",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d || {};
                    if (!result.Success) {
                        nphShowMessage(result.Message || "Entries could not be loaded.", false);
                        nphRenderEntries([]);
                        return;
                    }

                    nphRenderEntries(result.Entries || []);
                },
                error: function () {
                    nphShowMessage("Entries could not be loaded. Please try again.", false);
                    nphRenderEntries([]);
                },
                complete: function () {
                    nphSetBusy(false);
                }
            });

            return false;
        }

        function nphRenderEntries(rows) {
            if ($.fn.DataTable.isDataTable("#nph-table")) {
                $("#nph-table").DataTable().clear().destroy();
            }

            var html = rows.map(function (row) {
                return "<tr>" +
                    "<td>" + nphSafeHtml(row.EntryDate) + "</td>" +
                    "<td>" + nphSafeHtml(row.StartTime) + "</td>" +
                    "<td>" + nphSafeHtml(row.EndTime) + "</td>" +
                    "<td>" + nphSafeHtml(row.TotalDuration) + "</td>" +
                    "<td>" + nphSafeHtml(row.Reason) + "</td>" +
                    "<td>" + nphSafeHtml(row.CreatedOn) + "</td>" +
                    "</tr>";
            }).join("");

            $("#nph-table tbody").html(html);
            $("#nph-table-wrap").toggle(rows.length > 0);
            $("#nph-empty").toggle(rows.length === 0);

            if (rows.length > 0) {
                $("#nph-table").DataTable({
                    dom: "lBftip",
                    destroy: true,
                    pageLength: 25,
                    ordering: true,
                    order: [[0, "desc"], [3, "desc"]],
                    buttons: [
                        { extend: "excelHtml5", title: "Non Productive Hours", autoFilter: true }
                    ]
                });
            }
        }

        function nphSetBusy(isBusy) {
            $("#nph-save, #nph-refresh").prop("disabled", isBusy);
            $("#load1").toggle(isBusy);
        }

        function nphShowMessage(message, success) {
            $("#nph-message")
                .removeClass("success error")
                .addClass(success ? "success" : "error")
                .text(message);
        }

        function nphClearMessage() {
            $("#nph-message").removeClass("success error").text("");
        }

        function nphSafeHtml(value) {
            return $("<div/>").text(value === null || value === undefined ? "" : value).html();
        }

        function calculateDuration() {
            var a = $("#nph-starttime").val(),
                b = $("#nph-endtime").val();

            if (!a || !b || a === "--:--" || b === "--:--") {
                return $("#nph-Totalduration").val("");
            }

            var x = a.split(":"),
                y = b.split(":"),
                startMins = +x[0] * 60 + +x[1],
                endMins = +y[0] * 60 + +y[1];

            var m = endMins - startMins;

            if (m < 0) {
                return $("#nph-Totalduration").val("Invalid time");
            }

            $("#nph-Totalduration").val(Math.floor(m / 60) + "h " + (m % 60) + "m");
        }

        $(document).on("change", "#nph-starttime, #nph-endtime", function () {
            calculateDuration();
        });
   
        //Admin Update  

        function nphUpdateLoadEntries() {
            nphSetBusy(true);
            $.ajax({
                type: "POST",
                url: "NonProductiveHours.aspx/UpdateLoadEntries",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d || {};
                    if (!result.Success) {
                        nphSwalAlert("Error", result.Message || "Entries could not be loaded.", "error");
                       
                        nphUpdateRenderEntries([]);
                        return;
                    }
                    nphUpdateRenderEntries(result.Entries || []);
                },
                error: function () {
                    nphSwalAlert("Error", "Entries could not be loaded. Please try again.", "error");
                    nphUpdateRenderEntries([]);
                },
                complete: function () {
                    nphSetBusy(false);
                }
            });
            return false;
        }

        function nphUpdateRenderEntries(rows) {
            if ($.fn.DataTable.isDataTable("#nphupdate-table")) {
                $("#nphupdate-table").DataTable().clear().destroy();
            }

            var html = rows.map(function (row) {
                var entryId = nphSafeHtml(row.NonProductiveHoursID);
                return "<tr>" +
                    "<td style='display:none;'>" + entryId + "</td>" +
                    "<td>" +
                    "<a href='javascript:void(0);' class='nph-update-btn' " +
                    "data-id='" + entryId + "' " +
                    "data-date='" + nphSafeHtml(row.EntryDate) + "' " +
                    "data-starttime='" + nphSafeHtml(row.StartTime) + "' " +
                    "data-endtime='" + nphSafeHtml(row.EndTime) + "' " +
                    "data-duration='" + nphSafeHtml(row.TotalDuration) + "' " +
                    "data-reason='" + nphSafeHtml(row.Reason) + "' " +
                    "data-employeename='" + nphSafeHtml(row.EmployeeName) + "' " +

                    "title='Update'><i class='fas fa-edit text-primary'></i></a>" +
                    " &nbsp; " +
                    "<a href='javascript:void(0);' class='nph-delete-btn' " +
                    "data-id='" + entryId + "' " +
                    "title='Delete'><i class='fas fa-trash text-danger'></i></a>" +
                    "</td>" +
                    "<td>" + nphSafeHtml(row.EntryDate) + "</td>" +
                    "<td>" + nphSafeHtml(row.StartTime) + "</td>" +
                    "<td>" + nphSafeHtml(row.EndTime) + "</td>" +
                    "<td>" + nphSafeHtml(row.TotalDuration) + "</td>" +
                    "<td>" + nphSafeHtml(row.Reason) + "</td>" +
                    "<td>" + nphSafeHtml(row.EmployeeName) + "</td>" +
                    "<td>" + nphSafeHtml(row.CreatedOn) + "</td>" +
                    "</tr>";
            }).join("");

            $("#nphupdate-table tbody").html(html);
            $("#nph-table-update").toggle(rows.length > 0);
            $("#nphupdate-empty").toggle(rows.length === 0);

            if (rows.length > 0) {
                $("#nphupdate-table").DataTable({
                    dom: "lBftip",
                    destroy: true,
                    pageLength: 25,
                    ordering: true,
                    order: [[0, "desc"], [3, "desc"]],
                    columnDefs: [{ orderable: false, targets: 1 }],
                    buttons: [{
                        extend: "excelHtml5",
                        title: "Non Productive Hours",
                        autoFilter: true,
                        exportOptions: { columns: [2, 3, 4, 5, 6, 7, 8] }
                    }]
                });
            }
        }

        $(document).on("click", ".nph-update-btn", function () {
            var $btn = $(this);
            var rawDate = $btn.data("date");
            var formattedDate = "";

            if (rawDate) {
                var d = new Date(rawDate);
                if (!isNaN(d.getTime())) {
                    formattedDate = d.getFullYear() + "-" +
                        String(d.getMonth() + 1).padStart(2, '0') + "-" +
                        String(d.getDate()).padStart(2, '0');
                }
            }

            $("#nph_modal_rowid").val($btn.data("id"));
            $("#nph_modal_date").val(formattedDate);
            $("#nph_modal_starttime").val($btn.data("starttime"));
            $("#nph_modal_endtime").val($btn.data("endtime"));
            $("#nph_modal_totalduration").val($btn.data("duration"));
            $("#nph_modal_reason").val($btn.data("reason"));
            $("#nph_modal_empname").val($btn.data("employeename"));

            $("#editNonProductiveModal").modal("show");
        });


        $(document).on("change", "#nph_modal_starttime, #nph_modal_endtime", function () {
            calculateDurationnphmodelpopup();
        });
        function calculateDurationnphmodelpopup() {
            var a = $("#nph_modal_starttime").val(),
                b = $("#nph_modal_endtime").val();

            if (!a || !b) return $("#nph_modal_totalduration").val("");

            var x = a.split(":"),
                y = b.split(":"),
                m = +y[0] * 60 + +y[1] - (+x[0] * 60 + +x[1]);

            $("#nph_modal_totalduration").val(m > 0 ? Math.floor(m / 60) + "h " + m % 60 + "m" : "Invalid time");
        }
        function UpdateNonProductiveData() {
            var entryId = $("#nph_modal_rowid").val();
            var entryDate = $("#nph_modal_date").val();
            var starttime = $("#nph_modal_starttime").val();
            var endtime = $("#nph_modal_endtime").val();
            var Totalduration = $("#nph_modal_totalduration").val();
            var reason = $.trim($("#nph_modal_reason").val());

            if (!entryId) {
                nphSwalAlert("Error", "Invalid record ID.", "error");
                return;
            }

            if (!entryDate) {
                nphSwalAlert("Error", "Please select a date.", "error");
                return;
            }

            if (Totalduration === 'Invalid time' || !Totalduration) {
                nphSwalAlert("Error", "Please provide valid start and end times.", "error");
                return;
            }
            if (starttime == "") {
                nphSwalAlert("Error", "Please select start time.", "error");
                return;
            }
            if (endtime == "") {
                nphSwalAlert("Error", "Please select end time.", "error");
                return;
            }
            if (!reason) {
                nphSwalAlert("Error", "Please enter a reason.", "error");
                return;
            }

            if (reason.length > 1000) {
                nphSwalAlert("Error", "Reason cannot exceed 1000 characters.", "error");
                return;
            }

            nphSetBusy(true);
            $.ajax({
                type: "POST",
                url: "NonProductiveHours.aspx/UpdateEntry",
                data: JSON.stringify({
                    entryId: entryId,
                    entryDate: entryDate,
                    starttime: starttime,
                    endtime: endtime,
                    Totalduration: Totalduration,
                    reason: reason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d || {};
                    if (!result.Success) {
                        nphSwalAlert("Error", result.Message || "Failed to update entry.", "error");
                        return;
                        
                    }
                    nphSwalAlert("Success", result.Message || "Entry updated successfully.", "success");
                    $("#editNonProductiveModal").modal("hide");

                    nphUpdateLoadEntries();
                },
                error: function () {
                    nphSwalAlert("Error",  "An error occurred while updating. Please try again.", "error");

                },
                complete: function () {
                    nphSetBusy(false);
                }
            });
        }

        //Admin Delete 
        $(document).on("click", ".nph-delete-btn", function () {
            var entryId = $(this).data("id");

            Swal.fire({
                title: "Are you sure?",
                text: "Are you sure you want to delete this entry?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST",
                        url: "NonProductiveHours.aspx/DeleteEntry",
                        data: JSON.stringify({ entryId: entryId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var res = response.d || {};
                            nphSwalAlert("Success", res.Message || "Operation completed.", "success");

                            if (res.Success) {
                                nphUpdateLoadEntries();
                            }
                        },
                        error: function (xhr, status, error) {
                            nphSwalAlert("Error", "Something went wrong. Please try again.", "error");
                        }
                    });
                }
            });
        });

        function nphSwalAlert(title, text, icon) {
            Swal.fire({
                title: title,
                text: text,
                icon: icon,
                confirmButtonText: 'OK'
            });
        }


        var loggedInEmployeeId = '<%= Session["EmployeeID"] != null ? Session["EmployeeID"].ToString() : (Page.User.Identity.IsAuthenticated ? Page.User.Identity.Name : "0") %>';

        console.log("Logged-in Employee ID: " + loggedInEmployeeId);

        document.addEventListener("DOMContentLoaded", function () {
            if (loggedInEmployeeId === "10491") {
                $('#custom-tabs-one-profile-tab').parent('li').show();
                $('#custom-tabs-one-profile').show();
            }
            else {
                $('#custom-tabs-one-profile-tab').parent('li').hide();
                $('#custom-tabs-one-profile').hide();
            }

        });

        document.addEventListener('DOMContentLoaded', function () {
            function createTimePicker(inputId, panelId, hoursColId, minsColId) {
                const input = document.getElementById(inputId);
                const panel = document.getElementById(panelId);
                const hoursCol = document.getElementById(hoursColId);
                const minsCol = document.getElementById(minsColId);

                if (!input || !panel || !hoursCol || !minsCol) return;

                let selectedHour = "--";
                let selectedMin = "--";

                for (let h = 0; h < 24; h++) {
                    const hh = String(h).padStart(2, '0');
                    const div = document.createElement('div');
                    div.className = 'nph-time-option';
                    div.textContent = hh;

                    div.onclick = (e) => {
                        e.stopPropagation();
                        hoursCol.querySelectorAll('.nph-time-option').forEach(el => el.classList.remove('selected'));
                        div.classList.add('selected');
                        selectedHour = hh;
                        if (selectedMin === "--") selectedMin = "00";
                        input.value = `${selectedHour}:${selectedMin}`;
                        $(input).trigger('change');
                    };
                    hoursCol.appendChild(div);
                }

                for (let m = 0; m < 60; m++) {
                    const mm = String(m).padStart(2, '0');
                    const div = document.createElement('div');
                    div.className = 'nph-time-option';
                    div.textContent = mm;

                    div.onclick = (e) => {
                        e.stopPropagation();
                        minsCol.querySelectorAll('.nph-time-option').forEach(el => el.classList.remove('selected'));
                        div.classList.add('selected');
                        selectedMin = mm;
                        if (selectedHour === "--") selectedHour = "00";
                        input.value = `${selectedHour}:${selectedMin}`;
                        $(input).trigger('change');
                    };
                    minsCol.appendChild(div);
                }

                input.addEventListener('click', (e) => {
                    e.stopPropagation();
                    document.querySelectorAll('.nph-time-picker-panel').forEach(p => {
                        if (p !== panel) p.classList.remove('active');
                    });
                    panel.classList.toggle('active');
                });

                panel.addEventListener('click', (e) => {
                    e.stopPropagation();
                });
            }

            createTimePicker('nph-starttime', 'nph-start-panel', 'nph-start-hours', 'nph-start-minutes');
            createTimePicker('nph-endtime', 'nph-end-panel', 'nph-end-hours', 'nph-end-minutes');
            createTimePicker('nph_modal_starttime', 'nph_modal_start_panel', 'nph_modal_start_hours', 'nph_modal_start_minutes');
            createTimePicker('nph_modal_endtime', 'nph_modal_end_panel', 'nph_modal_end_hours', 'nph_modal_end_minutes');
            document.addEventListener('click', () => {
                document.querySelectorAll('.nph-time-picker-panel').forEach(p => p.classList.remove('active'));
            });
        });
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="nph-page">
        <div class="condition-hero">
            <div class="condition-title-wrap" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span class="condition-title-icon"><i class="fa-solid fa-user-clock"></i></span>
                    <div>
                        <h1 class="condition-title">Non-Productive Hours</h1>
                        <p class="condition-subtitle">Record time spent on non-productive activities against your Employee ID.</p>
                    </div>
                </div>
                <button type="button" id="nph-refresh" class="nph-refresh">
                    <i class="fas fa-sync-alt"></i>&nbsp; Refresh
                </button>
            </div>
        </div>
        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs dp-tabs" id="custom-tabs-one-tab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Add Non-Productive Hours</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Edit Non-Productive Hours</a>
            </li>
        </ul>

        <div class="tab-content" id="custom-tabs-one-tabContent">
            <!-- Tab 1: Add Entry -->
            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                <section class="nph-panel">
                    <h2 class="nph-panel-title">Add Entry</h2>
                    <div id="nph-message" class="nph-message"></div>

                    <div class="nph-form-grid">
                       <div class="nph-field">
        <label class="nph-label" for="nph-date">Date <span class="nph-required">*</span></label>
        <input type="date" id="nph-date" class="nph-input" />
    </div>

    <!-- Start Time -->
    <div class="nph-field">
        <label class="nph-label" for="nph-starttime">Start Time <span class="nph-required">*</span></label>
        <div class="nph-time-input-container">
            <input type="text" id="nph-starttime" class="nph-select" placeholder="--:--" readonly>
            <span class="fas fa-clock nph-clock-icon"></span>
            
            <div class="nph-time-picker-panel" id="nph-start-panel">
                <div class="nph-time-column" id="nph-start-hours"></div>
                <div class="nph-time-column" id="nph-start-minutes"></div>
            </div>
        </div>
    </div>

    <!-- End Time -->
    <div class="nph-field">
        <label class="nph-label" for="nph-endtime">End Time <span class="nph-required">*</span></label>
        <div class="nph-time-input-container">
            <input type="text" id="nph-endtime" class="nph-select" placeholder="--:--" readonly>
            <span class="fas fa-clock nph-clock-icon"></span>
            
            <div class="nph-time-picker-panel" id="nph-end-panel">
                <div class="nph-time-column" id="nph-end-hours"></div>
                <div class="nph-time-column" id="nph-end-minutes"></div>
            </div>
        </div>
    </div>

    <!-- Total Duration -->
    <div class="nph-field">
        <label class="nph-label" for="nph-Totalduration">Total Duration <span class="nph-required">*</span></label>
        <input type="text" id="nph-Totalduration" class="nph-input" value="" disabled />
    </div>

                        <div class="nph-field nph-field-full">
                            <label class="nph-label" for="nph-reason">Reason <span class="nph-required">*</span></label>
                            <textarea id="nph-reason" class="nph-textarea" maxlength="1000"></textarea>
                        </div>
                    </div>

                    <div class="nph-actions">
                        <button type="button" id="nph-save" class="nph-save">
                            <i class="fas fa-save"></i>&nbsp; Save Entry
                       
                        </button>
                    </div>
                </section>

                <section class="nph-panel">
                    <h2 class="nph-panel-title">My Entries</h2>
                    <div id="nph-table-wrap" class="nph-table-wrap">
                        <table id="nph-table" class="table table-hover nph-table">
                            <thead>
                                <tr>
                                    <th style="width: 130px;">Date</th>
                                    <th style="width: 100px;">Start Time</th>
                                    <th style="width: 100px;">End Time</th>
                                    <th style="width: 100px;">Total Duration</th>
                                    <th>Reason</th>
                                    <th style="width: 180px;">Added On</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div id="nph-empty" class="nph-empty">No non-productive hour entries found.</div>
                </section>
            </div>

            <!-- Tab 2: Edit/Update Entries -->
            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                <section class="nph-panel">
                    <h2 class="nph-panel-title">Update Entries</h2>
                    <div id="nph-table-update" class="nph-table-wrap">
                        <table id="nphupdate-table" class="table table-hover nph-table">
                            <thead>
                                <tr>
                                    <th style="display: none;">NonProductiveHoursID</th>
                                    <th style="width: 10px;">Action</th>
                                    <th style="width: 120px;">Date</th>
                                    <th style="width: 100px;">Start Time</th>
                                    <th style="width: 100px;">End Time</th>
                                    <th style="width: 100px;">Total Duration</th>
                                    <th style="width: 100px;">Reason</th>
                                    <th style="width: 100px;">Employee Name</th>
                                    <th style="width: 110px;">Added On</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div id="nphupdate-empty" class="nph-empty">No non-productive hour entries found.</div>
                </section>
            </div>
        </div>
    </div>

    
        
    <div class="modal fade" id="editNonProductiveModal" tabindex="-1" role="dialog" aria-labelledby="editNonProductiveModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
            <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 12px 32px rgba(15, 23, 42, 0.18); overflow: hidden;">
                <!-- Header (Dark Blue Gradient) -->
                <div class="modal-header" style="background: #1e3a8a; color: #ffffff; padding: 18px 24px; border-bottom: none; border-top-left-radius: 12px; border-top-right-radius: 12px;">
                    <h5 class="modal-title" id="editNonProductiveModalLabel" style="font-weight: 700; font-size: 17px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-edit" style="color: #93c5fd;"></i>Edit Non-Productive Hours Details
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close" style="opacity: 0.85; font-size: 22px; outline: none; text-shadow: none;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-body" style="background: #f8fafc; padding: 26px 28px;">
                    <div class="row">
                        <input type="hidden" id="nph_modal_rowid" />

                        <div class="col-md-6 form-group">
                            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">Date <span style="color: #dc2626;">*</span></label>
                            <input type="date" id="nph_modal_date" class="form-control" style="height: 42px; border-radius: 7px; border: 1px solid #cbd5e1; font-size: 14px;" readonly />
                        </div>

                        <div class="col-md-6 form-group">
                            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">Employee Name <span style="color: #dc2626;">*</span></label>
                            <input type="text" id="nph_modal_empname" class="form-control" readonly style="height: 42px; border-radius: 7px; border: 1px solid #cbd5e1; background-color: #f1f5f9; color: #475569; font-size: 14px; font-weight: 600;" />
                        </div>


                       <div class="col-md-6 form-group mt-2">
            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">Start Time <span style="color: #dc2626;">*</span></label>
            <div class="nph-time-input-container">
                <input type="text" id="nph_modal_starttime" class="form-control nph-select" placeholder="--:--" readonly style="height: 42px; border-radius: 7px; border: 1px solid #cbd5e1; font-size: 14px;" />
                <span class="fas fa-clock nph-clock-icon" style="position: absolute; right: 25px; top: 14px; color: #64748b;"></span>
                
                <div class="nph-time-picker-panel" id="nph_modal_start_panel">
                    <div class="nph-time-column" id="nph_modal_start_hours"></div>
                    <div class="nph-time-column" id="nph_modal_start_minutes"></div>
                </div>
            </div>
        </div>

        <!-- End Time with Custom Time Picker -->
        <div class="col-md-6 form-group mt-2">
            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">End Time <span style="color: #dc2626;">*</span></label>
            <div class="nph-time-input-container">
                <input type="text" id="nph_modal_endtime" class="form-control nph-select" placeholder="--:--" readonly style="height: 42px; border-radius: 7px; border: 1px solid #cbd5e1; font-size: 14px;" />
                <span class="fas fa-clock nph-clock-icon" style="position: absolute; right: 25px; top: 14px; color: #64748b;"></span>
                
                <div class="nph-time-picker-panel" id="nph_modal_end_panel">
                    <div class="nph-time-column" id="nph_modal_end_hours"></div>
                    <div class="nph-time-column" id="nph_modal_end_minutes"></div>
                </div>
            </div>
        </div>
                        <div class="col-md-6 form-group">
                            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">Total Duration <span style="color: #dc2626;">*</span></label>
                            <input type="text" id="nph_modal_totalduration" class="form-control" readonly style="height: 42px; border-radius: 7px; border: 1px solid #cbd5e1; background-color: #f1f5f9; color: #475569; font-size: 14px; font-weight: 600;" />
                        </div>
                        <div class="col-md-6 form-group">
                            <label style="color: #334155; font-weight: 700; font-size: 12px; margin-bottom: 6px; display: block;">Reason <span style="color: #dc2626;">*</span></label>
                            <textarea id="nph_modal_reason" class="form-control" rows="3" placeholder="Enter reason..." style="border-radius: 7px; border: 1px solid #cbd5e1; font-size: 14px; padding: 10px 12px; resize: none;"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="modal-footer" style="background: #ffffff; border-top: 1px solid #e2e8f0; padding: 14px 24px; display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" style="border-radius: 7px; font-weight: 600; font-size: 13px; padding: 8px 18px; border: 1px solid #cbd5e1; background: #fff; color: #334155;">
                        <i class="fas fa-times"></i>Close
                    </button>
                    <button type="button" class="btn btn-primary" id="btnUpdateNonProductive" onclick="UpdateNonProductiveData();" style="border-radius: 7px; font-weight: 700; font-size: 13px; padding: 8px 20px; background: #2563eb; border: none; color: #fff;">
                        <i class="fas fa-save"></i>Update
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
