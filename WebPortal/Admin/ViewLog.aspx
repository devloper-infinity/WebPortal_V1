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
     background: #d9ead3  !important;
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


    <script type="text/javascript">
        var logTable = null;

        function getQueryStringValue(name) {
            var params = new URLSearchParams(window.location.search);
            return params.get(name) || "";
        }

        function displayValue(data) {
            return data === null || data === undefined ? "" : data;
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
            var request = {
                Code: getQueryStringValue("Code"),
                Month: $("#<%= ddlMonth.ClientID %>").val(),
                Year: $("#<%= ddlYear.ClientID %>").val()
            };

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
            $("#btnLoadLogs").on("click", bindLogTable);
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
                    <h1 class="vl-title"><i class="fas fa-calendar-check"></i> &nbsp; &nbsp;Employee Daily Log Details</h1>
                    <p class="vl-subtitle">
                        View monthly attendance logs, break hours, extra hours and day status.
                    </p>
                </div>
            </div>

            <div class="vl-hero-action">
                <a href="ProposedSalaryReport.aspx"
                    id="aProposed"
                    runat="server"
                    class="vl-btn vl-btn-primary" style=" background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%)!important;">
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

