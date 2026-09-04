<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewLog.aspx.cs" Inherits="WebPortal.Admin.ViewLog" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />

    <style>
        :root {
            --vl-primary: #2563eb;
            --vl-primary-dark: #172554;
            --vl-accent: #22c1dc;
            --vl-bg: #f5f7fb;
            --vl-card: #ffffff;
            --vl-text: #0f172a;
            --vl-muted: #64748b;
            --vl-border: #e2e8f0;
            --vl-soft: #eff6ff;
            --vl-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--vl-bg);
        }

        .vl-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 19px 25px;
            border-radius: 15px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 48%, #22c1dc 100%);
            box-shadow: var(--vl-shadow);
        }

            .vl-hero:before,
            .vl-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .vl-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .vl-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .vl-hero-icon {
            position: relative;
            z-index: 1;
            width: 56px;
            height: 56px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
            flex-shrink: 0;
        }

        .vl-hero-content {
            position: relative;
            z-index: 1;
        }

        .vl-title {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .vl-subtitle {
            margin: 8px 0 0;
            font-size: 13px;
            opacity: .9;
        }

        /* Button right side */
        .vl-hero > div:last-child {
            position: relative;
            z-index: 2;
            margin-left: auto;
            text-align: right;
        }

        /* Stylish Proposed Salary button */
        .vl-hero .vl-btn-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 46px;
            padding: 0 22px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, .28);
            background: rgba(15, 23, 42, .88);
            color: #fff !important;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .01em;
            text-decoration: none;
            box-shadow: 0 12px 28px rgba(15, 23, 42, .28);
            transition: all .25s ease;
            white-space: nowrap;
        }

            .vl-hero .vl-btn-primary i {
                background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 48%, #22c1dc 100%);
                color: white !important;
                font-size: 16px;
            }

            .vl-hero .vl-btn-primary:hover {
                background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 48%, #22c1dc 100%);
                transform: translateY(-2px);
                background: #fff;
                color: white !important;
                box-shadow: 0 18px 36px rgba(15, 23, 42, .32);
            }

            .vl-hero .vl-btn-primary:active {
                transform: translateY(0);
            }

        .vl-filter-card,
        .vl-table-card {
            margin-top: 24px;
            padding: 24px;
            border: 1px solid var(--vl-border);
            border-radius: 22px;
            background: var(--vl-card);
            box-shadow: var(--vl-shadow);
        }

        .vl-filter-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(140px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .vl-field label {
            display: block;
            margin-bottom: 9px;
            color: var(--vl-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
        }

        .vl-field .form-control {
            width: 100%;
            height: 46px;
            border: 1px solid var(--vl-border);
            border-radius: 14px;
            background: #fff;
            color: var(--vl-text);
            box-shadow: none;
            font-size: 13px;
            font-weight: 700;
            padding: 9px 14px;
            transition: border-color .18s ease, box-shadow .18s ease;
        }

            .vl-field .form-control:focus {
                border-color: var(--vl-primary);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
            }

        .vl-btn {
            width: 100%;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: 0;
            border-radius: 14px;
            color: #fff;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .vl-btn:hover {
                color: #fff;
                text-decoration: none;
                transform: translateY(-1px);
            }

        .vl-btn-primary {
            background: linear-gradient(135deg, var(--vl-primary), var(--vl-accent));
            box-shadow: 0 12px 22px rgba(37, 99, 235, .22);
        }

        .vl-btn-dark {
            background: var(--vl-primary-dark);
            box-shadow: 0 12px 22px rgba(15, 23, 42, .2);
        }

        .vl-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--vl-border);
            border-radius: 16px;
        }

        #tblLog {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

            #tblLog thead th {
                position: sticky;
                top: 0;
                z-index: 2;
                padding: 14px 12px !important;
                border: 0 !important;
                border-bottom: 1px solid var(--vl-border) !important;
                background: var(--vl-soft);
                color: var(--vl-text);
                font-size: 12px;
                font-weight: 900;
                text-align: center;
            }

            #tblLog tbody td {
                /* padding: 10px 8px !important;*/
                border-color: var(--vl-border) !important;
                color: #1e293b;
                font-size: 13px;
                /* font-weight: 500 !important;*/
                text-align: center;
                vertical-align: middle;
            }

            #tblLog tbody tr:hover td {
                background: #f8fafc;
            }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            display: none;
        }

        .row-holiday td {
            background: #e8f4ff !important;
            color: #1d4ed8 !important;
        }

        .row-leave td {
            background: #ecfdf5 !important;
            color: #047857 !important;
        }

        .row-worked td {
            background: #fff7ed !important;
            color: #c2410c !important;
        }

        .row-absent td {
            background: #fef2f2 !important;
            color: #b91c1c !important;
        }

        .row-current td {
            background: #d9ead3 !important;
            color: #274e13 !important;
        }

        .vl-loader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .75);
            backdrop-filter: blur(4px);
        }

        .vl-loader-box {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 190px;
            min-height: 150px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 14px;
            border-radius: 22px;
            background: #fff;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .18);
            color: var(--vl-text);
            font-weight: 800;
        }

        .vl-spinner {
            width: 44px;
            height: 44px;
            border: 4px solid #dbeafe;
            border-top-color: var(--vl-primary);
            border-radius: 50%;
            animation: vlSpin .8s linear infinite;
        }

        @keyframes vlSpin {
            to {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 1200px) {
            .vl-filter-grid {
                grid-template-columns: repeat(3, minmax(160px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .vl-page {
                padding: 14px;
            }

            .vl-hero {
                padding: 22px;
                align-items: flex-start;
            }

            .vl-title {
                font-size: 21px;
            }

            .vl-filter-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <style>
        .vl-summary-card {
            margin-top: 24px;
            padding: 22px;
            border: 1px solid var(--vl-border);
            border-radius: 22px;
            background: linear-gradient(145deg, #ffffff 0%, #f8fbff 100%);
            box-shadow: var(--vl-shadow);
        }

        .vl-summary-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .vl-summary-title {
            margin: 0;
            color: var(--vl-text);
            font-size: 18px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .vl-summary-subtitle {
            margin: 5px 0 0;
            color: var(--vl-muted);
            font-size: 13px;
            font-weight: 500;
        }

        .vl-summary-period {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-height: 38px;
            padding: 0 14px;
            border: 1px solid #bfdbfe;
            border-radius: 999px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 13px;
            font-weight: 800;
            white-space: nowrap;
        }

        .vl-stat-grid {
            display: grid;
            grid-template-columns: repeat(8, minmax(135px, 1fr));
            gap: 12px;
            overflow-x: auto;
            padding: 2px 2px 8px;
            scrollbar-color: #bfdbfe transparent;
            scrollbar-width: thin;
        }

        .vl-stat-card {
            --stat-accent: #2563eb;
            --stat-soft: #eff6ff;
            position: relative;
            overflow: hidden;
            min-width: 0;
            min-height: 108px;
            padding: 15px;
            border: 1px solid #e7ecf4;
            border-radius: 17px;
            background: rgba(255, 255, 255, .92);
            box-shadow: 0 7px 22px rgba(15, 23, 42, .055);
            transition: transform .2s ease, border-color .2s ease, box-shadow .2s ease;
        }

            .vl-stat-card::after {
                content: "";
                position: absolute;
                right: -24px;
                bottom: -35px;
                width: 88px;
                height: 88px;
                border-radius: 50%;
                background: var(--stat-soft);
                opacity: .7;
                pointer-events: none;
            }

            .vl-stat-card:hover {
                transform: translateY(-2px);
                border-color: var(--stat-accent);
                box-shadow: 0 12px 28px rgba(15, 23, 42, .1);
            }

        .vl-stat-icon {
            position: absolute;
            top: 13px;
            right: 13px;
            z-index: 1;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 11px;
            background: var(--stat-soft);
            color: var(--stat-accent);
            font-size: 15px;
        }

        .vl-stat-content {
            position: relative;
            z-index: 1;
            min-width: 0;
            padding-top: 2px;
        }

        .stat-label {
            display: block;
            min-height: 32px;
            margin: 0 38px 9px 0;
            color: var(--vl-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .025em;
            line-height: 1.3;
            text-transform: uppercase;
        }

        .stat-value {
            display: block;
            overflow: hidden;
            color: var(--vl-text);
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -.035em;
            line-height: 1.05;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .vl-stat-amber { --stat-accent: #d97706; --stat-soft: #fffbeb; }
        .vl-stat-rose { --stat-accent: #e11d48; --stat-soft: #fff1f2; }
        .vl-stat-emerald { --stat-accent: #059669; --stat-soft: #ecfdf5; }
        .vl-stat-violet { --stat-accent: #7c3aed; --stat-soft: #f5f3ff; }
        .vl-stat-cyan { --stat-accent: #0891b2; --stat-soft: #ecfeff; }
        .vl-stat-teal { --stat-accent: #0f766e; --stat-soft: #f0fdfa; }
        .vl-stat-pink { --stat-accent: #db2777; --stat-soft: #fdf2f8; }

        @media (max-width: 575px) {
            .vl-summary-card {
                padding: 18px;
            }

            .vl-summary-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .vl-stat-grid {
                grid-template-columns: repeat(8, 138px);
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .vl-stat-card {
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        var logTable = null;

        function getQueryStringValue(name) {
            var params = new URLSearchParams(window.location.search);
            return params.get(name) || "";
        }

        function displayValue(data) {
            return data === null || data === undefined ? "" : data;
        }

        function getSelectedFilters() {
            return {
                Code: getQueryStringValue("Code"),
                Month: $("#<%= ddlMonth.ClientID %>").val(),
                Year: $("#<%= ddlYear.ClientID %>").val()
            };
        }

        function getSalaryValue(data, fieldName) {
            var value = data && data[fieldName];
            return value === null || value === undefined || value === "" ? "0" : value;
        }

        function resetSalaryInfo() {
            $("#<%= lblFullDays.ClientID %>, #<%= lblPartialDays.ClientID %>, #<%= lblLatemarkCount.ClientID %>, " +
                "#<%= lblTotalDays.ClientID %>, #<%= lblTotalDaysWithExtra.ClientID %>, #<%= lblExtraDays.ClientID %>, " +
                "#<%= lblExtraDaysSalary.ClientID %>, #<%= lblIncentive.ClientID %>").text("0");
        }

        function bindSalaryInfo() {
            resetSalaryInfo();

            var request = getSelectedFilters();
            $("#salarySummaryPeriod").text(request.Month + " " + request.Year);

            $.ajax({
                type: "POST",
                url: "ViewLog.aspx/BindSalaryInfo",
                data: JSON.stringify(request),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response && response.d ? response.d : {};
                    data = typeof data === "string" ? JSON.parse(data) : data;

                    $("#<%= lblFullDays.ClientID %>").text(getSalaryValue(data, "FullDay"));
                    $("#<%= lblPartialDays.ClientID %>").text(getSalaryValue(data, "PartialDay"));
                    $("#<%= lblLatemarkCount.ClientID %>").text(getSalaryValue(data, "LateMark"));
                    $("#<%= lblTotalDays.ClientID %>").text(getSalaryValue(data, "TotalDays"));
                    $("#<%= lblTotalDaysWithExtra.ClientID %>").text(getSalaryValue(data, "TotalDaysWithExtra"));
                    $("#<%= lblExtraDays.ClientID %>").text(getSalaryValue(data, "ExtraDays"));
                    $("#<%= lblExtraDaysSalary.ClientID %>").text(getSalaryValue(data, "ExtraDaysSalary"));
                    $("#<%= lblIncentive.ClientID %>").text(getSalaryValue(data, "Incentive"));
                },
                error: function (xhr, status, error) {
                    console.log("Salary AJAX Status:", status);
                    console.log("Salary AJAX Error:", error);
                    console.log("Salary Response Text:", xhr.responseText);
                }
            });
        }

        function applyStatusClass(row, data) {

            var remark = (data.ShiftRemark || "").toLowerCase().trim();
            $(row).removeClass("row-holiday row-leave row-absent row-worked");

            if (remark === "worked holiday") {
                $(row).addClass("row-worked");
            } else if (remark === "paid leave") {
                $(row).addClass("row-leave");
            } else if (remark === "holiday") {
                $(row).addClass("row-holiday");
            } else if (remark === "absent") {
                $(row).addClass("row-absent");
            }
            else if (remark === "currentlogin") {
                $(row).addClass("row-current");
            }
        }

        function bindLogTable() {
            var request = getSelectedFilters();

            if ($.fn.DataTable.isDataTable("#tblLog")) {
                logTable.clear().destroy();
                $("#tblLog tbody").empty();
            }

            logTable = $("#tblLog").DataTable({
                ajax: {
                    type: "POST",
                    url: "ViewLog.aspx/BindLogDetails",
                    data: function () { return JSON.stringify(request); },
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    dataSrc: function (response) {
                        var data = response && response.d ? response.d : [];
                        return typeof data === "string" ? JSON.parse(data) : data;
                    },
                    error: function (xhr, status, error) {
                        console.log("AJAX Status:", status);
                        console.log("AJAX Error:", error);
                        console.log("Response Text:", xhr.responseText);

                        if (window.Swal) {
                            Swal.fire({ icon: "error", title: "Unable to load logs", text: "Please check console for details." });
                        } else {
                            alert("Unable to load log details.");
                        }
                    }
                },
                processing: true,
                searching: false,
                paging: false,
                info: false,
                autoWidth: false,
                // scrollX: true,
                order: [],
                columns: [
                    { data: "AttendanceDate", defaultContent: "" },
                    { data: "DayName", defaultContent: "" },
                    { data: "InTime", defaultContent: "" },
                    { data: "OutTime", defaultContent: "" },
                    { data: "Hours", defaultContent: "" },
                    { data: "BreakOutTime", defaultContent: "" },
                    { data: "BreakInTime", defaultContent: "" },
                    { data: "TotalBreakHours", defaultContent: "" },
                    { data: "ShiftTime", defaultContent: "" },
                    { data: "ExtraHours", defaultContent: "" },
                    { data: "NoofHours", defaultContent: "" },
                    { data: "LateMark", defaultContent: "" },
                    { data: "Partial", defaultContent: "" },
                    { data: "ShiftRemark", defaultContent: "" },
                    { data: "Remark", defaultContent: "" },
                    { data: "INIP", defaultContent: "" },
                    { data: "OutIP", defaultContent: "" }
                ],
                columnDefs: [{
                    targets: "_all",
                    className: "text-center align-middle",
                    render: displayValue
                }],
                rowCallback: applyStatusClass,
                language: {
                    emptyTable: "No log records found",
                    processing: "Loading logs..."
                }
            });
        }

        $(document).ajaxStart(function () { $("#load1").fadeIn(120); });
        $(document).ajaxStop(function () { $("#load1").fadeOut(120); });

        $(document).ready(function () {
            bindLogTable();
            bindSalaryInfo();
            $("#btnLoadLogs").on("click", function () {
                bindLogTable();
                bindSalaryInfo();
            });
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="vl-loader" id="load1">
        <div class="vl-loader-box">
            <div class="vl-spinner"></div>
            <div>Loading logs...</div>
        </div>
    </div>

    <div class="container-fluid vl-page">
        <section class="vl-hero">
            <div class="vl-hero-left">
                <div class="vl-hero-content">
                    <h1 class="vl-title"><i class="fas fa-calendar-check"></i>&nbsp; &nbsp;Employee Daily Log Details</h1>
                    <p class="vl-subtitle">
                        View monthly attendance logs, break hours, extra hours and day status.
                    </p>
                </div>
            </div>

            <div class="vl-hero-action">
                <a href="ProposedSalaryReport.aspx"
                    id="aProposed"
                    runat="server"
                    class="vl-btn vl-btn-primary" style="background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%)!important;">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <span>Proposed Salary</span>
                </a>
            </div>
        </section>

        <section class="vl-filter-card">
            <div class="vl-filter-grid">
                <div class="vl-field">
                    <label for="txtCode">Code</label>
                    <input type="text" id="txtCode" runat="server" class="form-control" readonly />
                </div>

                <div class="vl-field">
                    <label for="txtName">Name</label>
                    <input type="text" id="txtName" runat="server" class="form-control" readonly />
                </div>

                <div class="vl-field">
                    <label for="txtPseudoname">Pseudo Name</label>
                    <input type="text" id="txtPseudoname" runat="server" class="form-control" readonly />
                </div>

                <div class="vl-field">
                    <label for="<%= ddlMonth.ClientID %>">Month</label>
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-control">
                        <asp:ListItem Value="January">January</asp:ListItem>
                        <asp:ListItem Value="February">February</asp:ListItem>
                        <asp:ListItem Value="March">March</asp:ListItem>
                        <asp:ListItem Value="April">April</asp:ListItem>
                        <asp:ListItem Value="May">May</asp:ListItem>
                        <asp:ListItem Value="June">June</asp:ListItem>
                        <asp:ListItem Value="July">July</asp:ListItem>
                        <asp:ListItem Value="August">August</asp:ListItem>
                        <asp:ListItem Value="September">September</asp:ListItem>
                        <asp:ListItem Value="October">October</asp:ListItem>
                        <asp:ListItem Value="November">November</asp:ListItem>
                        <asp:ListItem Value="December">December</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="vl-field">
                    <label for="<%= ddlYear.ClientID %>">Year</label>
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="vl-field">
                    <label>&nbsp;</label>
                    <button type="button" id="btnLoadLogs" class="vl-btn vl-btn-primary"><i class="fas fa-search"></i>Show</button>
                </div>
            </div>
        </section>

        <section class="vl-summary-card" aria-labelledby="salarySummaryTitle">
            <div class="vl-summary-header">
                <div>
                    <h2 class="vl-summary-title" id="salarySummaryTitle">Attendance &amp; salary summary</h2>
                    <p class="vl-summary-subtitle">Key totals for the selected payroll period</p>
                </div>
                <div class="vl-summary-period">
                    <i class="fas fa-calendar-alt" aria-hidden="true"></i>
                    <span id="salarySummaryPeriod">Current period</span>
                </div>
            </div>

            <div class="vl-stat-grid">
                <article class="vl-stat-card">
                    <span class="vl-stat-icon"><i class="fas fa-calendar-check" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Full days</span>
                        <strong class="stat-value" id="lblFullDays" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-amber">
                    <span class="vl-stat-icon"><i class="fas fa-clock" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Partial days</span>
                        <strong class="stat-value" id="lblPartialDays" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-rose">
                    <span class="vl-stat-icon"><i class="fas fa-user-clock" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Late marks</span>
                        <strong class="stat-value" id="lblLatemarkCount" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-emerald">
                    <span class="vl-stat-icon"><i class="fas fa-calendar-day" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Total days</span>
                        <strong class="stat-value" id="lblTotalDays" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-violet">
                    <span class="vl-stat-icon"><i class="fas fa-calendar-plus" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Total days + extra</span>
                        <strong class="stat-value" id="lblTotalDaysWithExtra" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-cyan">
                    <span class="vl-stat-icon"><i class="fas fa-business-time" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Extra days</span>
                        <strong class="stat-value" id="lblExtraDays" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-teal">
                    <span class="vl-stat-icon"><i class="fas fa-coins" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Extra salary</span>
                        <strong class="stat-value" id="lblExtraDaysSalary" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>

                <article class="vl-stat-card vl-stat-pink">
                    <span class="vl-stat-icon"><i class="fas fa-award" aria-hidden="true"></i></span>
                    <div class="vl-stat-content">
                        <span class="stat-label">Incentive</span>
                        <strong class="stat-value" id="lblIncentive" runat="server" aria-live="polite">0</strong>
                    </div>
                </article>
            </div>
        </section>

        <section class="vl-table-card">
            <div class="vl-table-wrap">
                <table id="tblLog" class="table table-hover table-bordered nowrap">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Day</th>
                            <th>In Time</th>
                            <th>Out Time</th>
                            <th>Hours</th>
                            <th>Break Out</th>
                            <th>Break In</th>
                            <th>Break Time</th>
                            <th>Total Hours</th>
                            <th>Extra Hours</th>
                            <th>Deducted Hours</th>
                            <th>Late Mark</th>
                            <th>Partial</th>
                            <th>Shift Remark</th>
                            <th>Day Status</th>
                            <th>In IP</th>
                            <th>Out IP</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>
    </div>
</asp:Content>

