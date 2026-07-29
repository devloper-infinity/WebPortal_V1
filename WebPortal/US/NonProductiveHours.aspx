<%@ Page Title="Non-Productive Hours" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="NonProductiveHours.aspx.cs" Inherits="WebPortal.US.NonProductiveHours" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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
            grid-template-columns: minmax(190px, .9fr) minmax(250px, 1fr) minmax(320px, 1.8fr);
            gap: 18px;
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
        .nph-select,
        .nph-textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            background: #fff;
            color: #172033;
            font-size: 14px;
            box-sizing: border-box;
        }

        .nph-input,
        .nph-select {
            height: 42px;
            padding: 8px 11px;
        }

        .nph-textarea {
            height: 76px;
            min-height: 76px;
            padding: 10px 11px;
            resize: vertical;
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
    </style>

    <script>
        var nphTable = null;

        $(document).ready(function () {
            nphPopulateTimeOptions();
            nphSetDefaultDate();

            $("#nph-save").on("click", nphSave);
            $("#nph-refresh").on("click", nphLoadEntries);

            nphLoadEntries();
        });

        function nphPopulateTimeOptions() {
            var hours = "";
            var minutes = "";
            var value;

            for (var hour = 0; hour <= 23; hour++) {
                value = hour < 10 ? "0" + hour : hour;
                hours += "<option value=\"" + hour + "\">" + value + "</option>";
            }

            for (var minute = 0; minute <= 59; minute++) {
                value = minute < 10 ? "0" + minute : minute;
                minutes += "<option value=\"" + minute + "\">" + value + "</option>";
            }

            $("#nph-hours").html(hours);
            $("#nph-minutes").html(minutes);
        }

        function nphSetDefaultDate() {
            var today = new Date();
            var localDate = new Date(today.getTime() - (today.getTimezoneOffset() * 60000))
                .toISOString().slice(0, 10);
            $("#nph-date").val(localDate).attr("max", localDate);
        }

        function nphSave() {
            var entryDate = $("#nph-date").val();
            var hours = parseInt($("#nph-hours").val(), 10) || 0;
            var minutes = parseInt($("#nph-minutes").val(), 10) || 0;
            var reason = $.trim($("#nph-reason").val());

            nphClearMessage();

            if (!entryDate) {
                nphShowMessage("Please select a date.", false);
                return false;
            }

            if ((hours * 60) + minutes <= 0) {
                nphShowMessage("Duration must be greater than 00:00.", false);
                return false;
            }

            if (!reason) {
                nphShowMessage("Please enter a reason.", false);
                return false;
            }

            if (reason.length > 1000) {
                nphShowMessage("Reason cannot exceed 1000 characters.", false);
                return false;
            }

            nphSetBusy(true);
            $.ajax({
                type: "POST",
                url: "NonProductiveHours.aspx/SaveEntry",
                data: JSON.stringify({
                    entryDate: entryDate,
                    hours: hours,
                    minutes: minutes,
                    reason: reason
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d || {};
                    if (!result.Success) {
                        nphShowMessage(result.Message || "The entry could not be saved.", false);
                        return;
                    }

                    $("#nph-hours").val("0");
                    $("#nph-minutes").val("0");
                    $("#nph-reason").val("");
                    nphSetDefaultDate();
                    nphShowMessage(result.Message, true);
                    nphRenderEntries(result.Entries || []);
                },
                error: function () {
                    nphShowMessage("The entry could not be saved. Please try again.", false);
                },
                complete: function () {
                    nphSetBusy(false);
                }
            });

            return false;
        }

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
                    "<td>" + nphSafeHtml(row.Duration) + "</td>" +
                    "<td>" + nphSafeHtml(row.Reason) + "</td>" +
                    "<td>" + nphSafeHtml(row.CreatedOn) + "</td>" +
                    "</tr>";
            }).join("");

            $("#nph-table tbody").html(html);
            $("#nph-table-wrap").toggle(rows.length > 0);
            $("#nph-empty").toggle(rows.length === 0);

            if (rows.length > 0) {
                nphTable = $("#nph-table").DataTable({
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
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="nph-page">
        <section class="nph-hero">
            <div>
                <h1>Non-Productive Hours</h1>
                <p>Record time spent on non-productive activities against your Employee ID.</p>
            </div>
            <button type="button" id="nph-refresh" class="nph-refresh">
                <i class="fas fa-sync-alt"></i>&nbsp; Refresh
            </button>
        </section>

        <section class="nph-panel">
            <h2 class="nph-panel-title">Add Entry</h2>
            <div id="nph-message" class="nph-message"></div>

            <div class="nph-form-grid">
                <div class="nph-field">
                    <label class="nph-label" for="nph-date">Date <span class="nph-required">*</span></label>
                    <input type="date" id="nph-date" class="nph-input" />
                </div>

                <div class="nph-field">
                    <label class="nph-label">Hours <span class="nph-required">*</span></label>
                    <div class="nph-duration">
                        <div>
                            <select id="nph-hours" class="nph-select"></select>
                            <small>Hours</small>
                        </div>
                        <div>
                            <select id="nph-minutes" class="nph-select"></select>
                            <small>Minutes</small>
                        </div>
                    </div>
                </div>

                <div class="nph-field">
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
                            <th style="width: 100px;">Hours</th>
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
</asp:Content>
