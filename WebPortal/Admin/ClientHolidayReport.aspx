<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ClientHolidayReport.aspx.cs" Inherits="WebPortal.Admin.ClientHolidayReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --chr-primary: #1f3c88;
            --chr-blue: #2575fc;
            --chr-cyan: #1bc5e8;
            --chr-bg: #f4f7fb;
            --chr-card: #ffffff;
            --chr-text: #172033;
            --chr-muted: #64748b;
            --chr-border: #dbe3ef;
            --chr-shadow: 0 12px 28px rgba(21, 98, 228, .12);
        }

        body { background: var(--chr-bg); }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(255,255,255,.72);
            backdrop-filter: blur(3px);
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-align: center;
        }

        .loading img { width: 70px; height: 70px; }

        .loading div {
            margin-top: 10px;
            color: var(--chr-text);
            font-size: 12px;
            font-weight: 700;
        }

        .chreport-page {
            background: var(--chr-bg);
            min-height: calc(100vh - 90px);
        }

        .chreport-hero {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 17px 35px;
            margin-bottom: 22px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: var(--chr-shadow);
        }

        .chreport-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 8px;
            border: 2px solid rgba(255,255,255,.75);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
        }

        .chreport-hero-icon i {
            color: #fff;
            font-size: 28px;
        }

        .chreport-title {
            margin: 0;
            color: #fff;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.2;
        }

        .chreport-subtitle {
            margin: 8px 0 0;
            color: rgba(255,255,255,.92);
            font-size: 13px;
            line-height: 1.5;
        }

        .chreport-panel {
            margin-bottom: 18px;
            border: 1px solid var(--chr-border);
            border-radius: 8px;
            background: var(--chr-card);
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .chreport-panel-body { padding: 18px; }

        .chreport-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(190px, 1fr));
            gap: 14px;
            align-items: end;
        }

        .chreport-field label,
        .chreport-dropdown-title {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 700 !important;
        }

        .chreport-field .form-control,
        .chreport-dropdown-toggle {
            min-height: 42px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
            background: #fff;
            color: var(--chr-text);
            font-size: 13px;
            box-shadow: 0 1px 2px rgba(15, 23, 42, .03);
        }

        .chreport-field .form-control:focus,
        .chreport-dropdown-toggle:focus {
            border-color: rgba(37, 117, 252, .68);
            box-shadow: 0 0 0 .15rem rgba(37, 117, 252, .14);
        }

        .chreport-dropdown-toggle {
            width: 100%;
            text-align: left;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .chreport-dropdown-menu {
            max-height: 260px;
            overflow-y: auto;
            width: 100%;
            padding: 10px;
            border: 1px solid var(--chr-border);
            border-radius: 8px;
            box-shadow: 0 16px 32px rgba(15, 23, 42, .14);
        }

        .chreport-dropdown-menu label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 7px;
            color: #374151;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600 !important;
        }

        .chreport-dropdown-menu input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--chr-blue);
        }

        .chreport-actions {
            display: flex;
            gap: 10px;
            align-items: end;
        }

        .chreport-btn {
            min-height: 42px;
            min-width: 122px;
            border: 0;
            border-radius: 8px;
            color: #fff !important;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: .2s ease;
        }

        .chreport-btn:hover {
            color: #fff !important;
            transform: translateY(-1px);
            box-shadow: 0 10px 18px rgba(15, 23, 42, .14);
        }

        .chreport-btn-primary { background: linear-gradient(90deg, #1f3c88 0%, #2575fc 60%, #1bc5e8 100%); }
        .chreport-btn-muted { background: #f1f5f9; color: #334155 !important; border: 1px solid #dbe3ef; }
        .chreport-btn-muted:hover { color: #334155 !important; }

        .chreport-table-panel {
            border: 1px solid var(--chr-border);
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
        }

        .chreport-table-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 14px 16px;
            border-bottom: 1px solid var(--chr-border);
            background: #f8fafc;
        }

        .chreport-table-title {
            margin: 0;
            color: #0f172a;
            font-size: 16px;
            font-weight: 800;
        }

        .chreport-count {
            color: var(--chr-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .chreport-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        #chreport_table {
            width: 100% !important;
            margin-bottom: 0;
        }

        #chreport_table thead th {
            background: #edf3f6 !important;
            color: #0f172a !important;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
            vertical-align: middle;
            border-bottom: 1px solid #dbe3ef !important;
        }

        #chreport_table tbody td {
            color: #334155;
            font-size: 12px;
            vertical-align: middle;
            white-space: nowrap;
        }

        #chreport_table tbody tr:hover td { background: #f8fbff !important; }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            height: 34px;
            border: 1px solid #dbe3ef;
            border-radius: 8px;
            padding: 5px 9px;
        }

        div.dt-buttons { float: left; margin: 0 0 8px 12px; }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: linear-gradient(90deg, #10b981, #22c55e) !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 6px 13px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
        }

        @media (max-width: 1200px) {
            .chreport-filter-grid { grid-template-columns: repeat(3, minmax(190px, 1fr)); }
        }

        @media (max-width: 992px) {
            .chreport-filter-grid { grid-template-columns: repeat(2, minmax(190px, 1fr)); }
            .chreport-actions { grid-column: 1 / -1; }
        }

        @media (max-width: 576px) {
            .chreport-hero { padding: 16px; align-items: flex-start; }
            .chreport-hero-icon { width: 46px; height: 46px; min-width: 46px; }
            .chreport-filter-grid { grid-template-columns: 1fr; }
            .chreport-actions { flex-direction: column; align-items: stretch; }
            .chreport-btn { width: 100%; }
            .chreport-table-head { align-items: flex-start; flex-direction: column; }
        }
    </style>

    <script>
        var chreportTable = null;

        $(document).ready(function () {
            chreportBindHoliday();
            chreportBindYear();
            chreportInitEmptyTable();
        });

        function chreportBindHoliday() {
            $.ajax({
                type: "POST",
                url: "ClientHolidayMaster.aspx/GetHolidayList",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var ddl = $("#chreport_holiday");
                    ddl.empty();
                    ddl.append($("<option></option>").val("").text("All Holidays"));

                    var data = chreportParseResponse(response);
                    $.each(data, function (_i, item) {
                        ddl.append($("<option></option>").val(item.HolidayName).text(item.HolidayName));
                    });
                },
                error: function () {
                    chreportNotify("Unable to load holiday list.");
                }
            });
        }

        function chreportBindYear() {
            var currentYear = new Date().getFullYear();
            var ddl = $("#chreport_year");
            ddl.empty();

            for (var year = currentYear + 1; year >= currentYear - 5; year--) {
                ddl.append($("<option></option>").val(year).text(year));
            }

            ddl.val(currentYear);
        }

        function chreportShowReport() {
            var requestData = {
                HolidayFor: $("#chreport_holiday").val(),
                Year: $("#chreport_year").val()
            };

            if (!requestData.Year) {
                chreportNotify("Please select year.");
                return false;
            }

            $("#load1").css("display", "flex");

            $.ajax({
                type: "POST",
                url: "ClientHolidayReport.aspx/GetClientHolidayReport",
                data: JSON.stringify(requestData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = chreportParseResponse(response);
                    chreportRenderTable(data);
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                    chreportNotify("Unable to load client holiday report.");
                },
                complete: function () {
                    $("#load1").hide();
                }
            });

            return false;
        }

        function chreportInitEmptyTable() {
            chreportRenderTable([]);
        }

        function chreportRenderTable(data) {
            $("#chreport_count").text((data || []).length + " records");

            if ($.fn.DataTable.isDataTable("#chreport_table")) {
                $("#chreport_table").DataTable().clear().destroy();
            }

            var tableOptions = {
                data: data || [],
                destroy: true,
                scrollX: true,
                paging: true,
                ordering: false,
                processing: true,
                autoWidth: false,
                columns: [
                    { data: "SrNo", className: "text-center" },
                    { data: "EmployeeID", className: "text-center", render: chreportRenderText },
                    { data: "HolidayDate", className: "text-center", render: chreportRenderText },
                    { data: "HolidayFor", render: chreportRenderText },
                    { data: "AddedBy", render: chreportRenderText },
                    { data: "AddedDate", className: "text-center", render: chreportRenderText }
                ]
            };

            if ($.fn.dataTable && $.fn.dataTable.Buttons) {
                tableOptions.dom = "lBfrtip";
                tableOptions.buttons = [{ extend: "excelHtml5", title: "Client Holiday Report", text: '<i class="fas fa-file-excel"></i> Export' }];
            }
            else {
                tableOptions.dom = "lfrtip";
            }

            chreportTable = $("#chreport_table").DataTable(tableOptions);
        }

        function chreportRenderText(data) {
            return chreportEscape(data == null ? "" : data);
        }

        function chreportParseResponse(response) {
            if (!response) return [];
            var payload = response.d == null ? response : response.d;
            if (typeof payload === "string") {
                return payload ? JSON.parse(payload) : [];
            }
            return payload || [];
        }

        function chreportEscape(value) {
            return String(value == null ? "" : value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }

        function chreportNotify(message) {
            if (window.Swal) {
                Swal.fire("Validation", message, "warning");
            }
            else {
                alert(message);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please...</div>
    </div>

    <div class="chreport-page">
        <div class="chreport-hero">
            <span class="chreport-hero-icon">
                <i class="fas fa-calendar-check"></i>
            </span>
            <div>
                <h1 class="chreport-title">Client Holiday Report</h1>
                <p class="chreport-subtitle">Review applied client holidays by holiday and year.</p>
            </div>
        </div>

        <div class="chreport-panel">
            <div class="chreport-panel-body">
                <div class="chreport-filter-grid">
                    <div class="chreport-field">
                        <label for="chreport_holiday"><i class="fas fa-calendar-day mr-1"></i>Holiday For</label>
                        <select id="chreport_holiday" class="form-control"></select>
                    </div>

                    <div class="chreport-field">
                        <label for="chreport_year"><i class="far fa-calendar-alt mr-1"></i>Year</label>
                        <select id="chreport_year" class="form-control"></select>
                    </div>

                    <div class="chreport-actions">
                        <button type="button" id="chreport_btnshow" class="chreport-btn chreport-btn-primary" onclick="return chreportShowReport();">
                            <i class="fas fa-search"></i> Show
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="chreport-table-panel">
            <div class="chreport-table-head">
                <h2 class="chreport-table-title"><i class="fas fa-table mr-2"></i>Applied Holiday Details</h2>
                <span class="chreport-count" id="chreport_count">0 records</span>
            </div>
            <div class="chreport-table-wrap">
                <table id="chreport_table" class="table table-hover table-bordered nowrap">
                    <thead>
                        <tr>
                            <th>Sr. #</th>
                            <th>Employee ID</th>
                            <th>Holiday Date</th>
                            <th>Holiday For</th>
                            <th>Added By</th>
                            <th>Added Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
