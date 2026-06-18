<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ProposedSalaryReport.aspx.cs" Inherits="WebPortal.Admin.ProposedSalaryReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
        }

        .stat-box {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 18px;
            padding: 18px;
            height: 100%;
            backdrop-filter: blur(6px);
        }

        .stat-label {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 14px !important;
            font-weight: 700;
            color: white;
        }

        .table-card {
            background: white;
            border-radius: 18px;
            padding: 20px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }

        #tblSalaryLog {
            width: 100% !important;
        }

            #tblSalaryLog thead th {
                background: #1f3c88;
                /* color: white;*/
                border: none;
                font-size: 13px;
                text-align: center;
            }

            #tblSalaryLog tbody td {
                font-size: 11px;
                vertical-align: middle;
                font-weight: normal!important;
            }

        .dataTables_filter input {
            border-radius: 10px !important;
            border: 1px solid #ced4da !important;
            padding: 5px 10px !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            display: none;
        }

        .btn-back {
            border-radius: 10px;
            padding: 7px 18px;
            font-weight: 600;
        }
    </style>

    <style>
        .stat-box {
            background: #ffffff;
            position: relative;
            overflow: hidden;
            border: 1px solid #edf0f5;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.06);
            transition: all 0.3s ease;
            height: 100%;
        }

            .stat-box:hover {
                transform: translateY(-4px);
                box-shadow: 0 10px 24px rgba(15, 23, 42, 0.12);
            }

            .stat-box::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(180deg, #2563eb, #06b6d4);
            }

        .stat-label {
            font-size: 11px;
            font-weight: 600;
            /* color: #6b7280;*/
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 7px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: 700;
            color: #111827;
            line-height: 1;
        }

        /* Different Accent Colors */

        .col-lg:nth-child(1) .stat-box::before {
            background: #2563eb;
        }

        .col-lg:nth-child(2) .stat-box::before {
            background: #f59e0b;
        }

        .col-lg:nth-child(3) .stat-box::before {
            background: #ef4444;
        }

        .col-lg:nth-child(4) .stat-box::before {
            background: #10b981;
        }

        .col-lg:nth-child(5) .stat-box::before {
            background: #8b5cf6;
        }

        .col-lg:nth-child(6) .stat-box::before {
            background: #06b6d4;
        }

        .col-lg:nth-child(7) .stat-box::before {
            background: #14b8a6;
        }

        .col-lg:nth-child(8) .stat-box::before {
            background: #ec4899;
        }

        /* Responsive */

        @media (max-width: 768px) {

            .stat-box {
                padding: 18px;
            }

            .stat-value {
                font-size: 28px;
            }
        }
    </style>

    <style>
        .row-holiday {
            background: #e8f4ff !important;
            color: #1877F2;
        }

        .row-leave {
            background: #eaf7ea !important;
        }

        .row-worked {
            background: #fff7e6 !important;
        }

        .row-absent {
            background: #fdeaea !important;
        }

        #tblSalaryLog tbody td {
            vertical-align: middle;
            font-size: 13px;
        }
    </style>

    <script>

        $(document).ready(function () {
            BindSalaryLogDataTable();
        });


        function BindSalaryLogDataTable() {


            // Destroy existing DataTable if already initialized
            if ($.fn.DataTable.isDataTable('#tblSalaryLog')) {
                $('#tblSalaryLog').DataTable().clear().destroy();
            }

            $('#tblSalaryLog tbody').empty();

            $('#tblSalaryLog').DataTable({
                serverSide: false,
                searching: true,
                autoWidth: false,
                pageLength: 35,
                lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],

                order: [],   // ✅ THIS FIXES YOUR DATE ORDER ISSUE

                ajax: {
                    type: "POST",
                    url: "ProposedSalaryReport.aspx/GetAllSalaryLogs",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    dataSrc: function (response) {
                        let data = response.d;

                        if (typeof data === "string") {
                            data = JSON.parse(data);
                        }

                        return data;
                    }
                },

                columns: [
                    { data: "Date1", defaultContent: "" },
                    { data: "DayName", defaultContent: "", className: "dt-left" },
                    { data: "INTime", defaultContent: "" },
                    { data: "OutTime", defaultContent: "" },
                    { data: "TotalHours", defaultContent: "" },
                    { data: "ExtraHours", defaultContent: "" },
                    { data: "LateMark1", defaultContent: "" },
                    { data: "PartialDay", defaultContent: "" },
                    { data: "Remark", defaultContent: "" }
                ],

                columnDefs: [
                    {
                        targets: "_all",
                        className: "text-center align-middle"
                    }
                ],

                rowCallback: function (row, data) {

                    let remark = (data.Remark || "").toLowerCase().trim();

                    $(row).removeClass("row-holiday row-leave row-absent row-worked");

                    let icon = "";
                    let cssClass = "";

                    if (remark === "worked holiday") {
                        cssClass = "row-worked";
                    }
                    else if (remark === "paid leave") {
                        cssClass = "row-leave";
                    }
                    else if (remark === "holiday") {
                        cssClass = "row-holiday";
                    }
                    else if (remark === "absent") {
                        cssClass = "row-absent";
                    }

                    if (cssClass) {
                        $(row).addClass(cssClass);
                    }

                    if (data.Remark) {
                        $('td:eq(8)', row).html(data.Remark);
                    }

                    $(row).css("font-weight", "500");
                }
            });
        }


    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--<div class="container-fluid mt-4">    </div>--%>

        <!-- Header -->
        <div class="dashboard-header">

            <div class="d-flex justify-content-between align-items-start mb-1">

                <div>
                    <div class="dashboard-title">
                        <i class="fas fa-chart-line mr-2"></i>
                        Proposed Salary Report
                    </div>

                    <div class="dashboard-subtitle">
                        Monitor your attendance and salary logs.
                    </div>
                </div>

                <div>
                    <a href="#" id="aBack" runat="server"
                        class="btn btn-light btn-back"
                        onclick="window.history.go(-1); return false;">
                        <i class="fas fa-arrow-left"></i>
                        Back
                    </a>
                </div>

            </div>

        </div>
        <!-- Summary Cards -->
        <div class="row">

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Full Days</div>
                    <div class="stat-value" id="lblFullDays" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Partial Days</div>
                    <div class="stat-value" id="lblPartialDays" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Late Mark</div>
                    <div class="stat-value" id="lblLatemarkCount" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Total Days</div>
                    <div class="stat-value" id="lblTotalDays" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Total Days+Extra</div>
                    <div class="stat-value" id="lblTotalDaysWithExtra" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Extra Days</div>
                    <div class="stat-value" id="lblExtraDays" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Extra Salary</div>
                    <div class="stat-value" id="lblExtraDaysSalary" runat="server">0</div>
                </div>
            </div>

            <div class="col-lg col-md-4 col-sm-6 mb-3">
                <div class="stat-box">
                    <div class="stat-label">Incentive</div>
                    <div class="stat-value" id="lblIncentive" runat="server">0</div>
                </div>
            </div>

        </div>

        <!-- DataTable -->
        <div class="table-card">
            <table id="tblSalaryLog" class="table table-hover table-bordered nowrap">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Day</th>
                        <th>In Time</th>
                        <th>Out Time</th>
                        <th>Total Hours</th>
                        <th>Extra Hours</th>
                        <th>Late Mark</th>
                        <th>Partial</th>
                        <th>Remark</th>
                    </tr>
                </thead>

                <tbody>
                </tbody>
            </table>
        </div>

</asp:Content>

