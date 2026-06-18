<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DetailedAttendancePercentage.aspx.cs" Inherits="WebPortal.Admin.DetailedAttendancePercentage" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        .vl-hero-action {
            position: relative;
            z-index: 2;
            margin-left: auto;
            text-align: right;
        }

        .vl-btn-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 44px;
            padding: 0 20px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, .28);
          /*  background: rgba(15, 23, 42, .88);*/
            color: #fff !important;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            box-shadow: 0 12px 28px rgba(15, 23, 42, .28);
            transition: all .25s ease;
            white-space: nowrap;
        }

        .vl-btn-back:hover {
            transform: translateY(-2px);
            background: #fff;
            color: #1d4ed8 !important;
            text-decoration: none;
            box-shadow: 0 18px 36px rgba(15, 23, 42, .32);
        }

        .vl-table-card {
            margin-top: 24px;
            padding: 24px;
            border: 1px solid var(--vl-border);
            border-radius: 22px;
            background: var(--vl-card);
            box-shadow: var(--vl-shadow);
        }

        .vl-card-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 18px;
        }

        .vl-card-title h2 {
            margin: 0;
            color: var(--vl-text);
            font-size: 17px;
            font-weight: 900;
        }

        .vl-card-title span {
            color: var(--vl-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .vl-table-wrap {
            width: 100%;
            overflow-x: auto;
            border: 1px solid var(--vl-border);
            border-radius: 16px;
        }

        #grdAttendancePerMonthwise {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

        #grdAttendancePerMonthwise thead th {
            position: sticky;
            top: 0;
            z-index: 2;
            padding: 14px 12px !important;
            border: 0 !important;
            border-bottom: 1px solid var(--vl-border) !important;
            background: var(--vl-soft) !important;
            color: var(--vl-text) !important;
            font-size: 12px;
            font-weight: 900;
            text-align: center;
            vertical-align: middle;
        }

        #grdAttendancePerMonthwise tbody td {
            padding: 11px 10px !important;
            border-color: var(--vl-border) !important;
            background: #fff;
            color: #1e293b;
            font-size: 13px;
            text-align: center;
            vertical-align: middle;
        }

        #grdAttendancePerMonthwise tbody tr:hover td {
            background: #f8fafc !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 14px;
            color: var(--vl-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .dataTables_wrapper .dataTables_filter {
            float: right;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            min-height: 38px;
            border: 1px solid var(--vl-border);
            border-radius: 12px;
            background: #fff;
            color: var(--vl-text);
            padding: 7px 12px;
            outline: none;
        }

        .dataTables_wrapper .dataTables_filter input:focus,
        .dataTables_wrapper .dataTables_length select:focus {
            border-color: var(--vl-primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .12);
        }

        .buttons-excel,
        .dt-button.buttons-excel {
            display: inline-flex !important;
            align-items: center;
            justify-content: center;
            min-height: 38px;
            padding: 0 16px !important;
            border: 0 !important;
            border-radius: 12px !important;
            background: linear-gradient(135deg, #16a34a, #22c55e) !important;
            color: #fff !important;
            box-shadow: 0 10px 20px rgba(22, 163, 74, .22) !important;
            font-size: 12px !important;
            font-weight: 900 !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .75);
            backdrop-filter: blur(4px);
            text-align: center;
        }

        .loading img {
            position: absolute;
            top: calc(50% - 42px);
            left: 50%;
            transform: translate(-50%, -50%);
            max-width: 70px;
        }

        .loading div {
            position: absolute;
            top: calc(50% + 25px);
            left: 50%;
            transform: translateX(-50%);
            padding: 14px 20px;
            border-radius: 16px;
            background: #fff;
            color: var(--vl-text);
            box-shadow: 0 24px 60px rgba(15, 23, 42, .18);
            font-size: 12px;
            font-weight: 900;
        }

        @media (max-width: 768px) {
            .vl-page {
                padding: 14px 8px 22px;
            }

            .vl-hero {
                align-items: flex-start;
                flex-wrap: wrap;
                padding: 22px;
            }

            .vl-hero-action {
                width: 100%;
                margin-left: 74px;
                text-align: left;
            }

            .vl-table-card {
                padding: 16px;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            GetDashboardAttendanceDetails();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div>One moment, please . . . .</div>
    </div>

    <div class="container-fluid vl-page">
        <section class="vl-hero">
            <div class="vl-hero-icon"><i class="fas fa-chart-pie"></i></div>
            <div class="vl-hero-content">
                <h1 class="vl-title">Detailed Attendance Percentage</h1>
                <p class="vl-subtitle">Review month-wise attendance percentage, absents, partial days and latemark summary.</p>
            </div>
            <div class="vl-hero-action">
                <a href="Log.aspx" id="aBack" runat="server" class="vl-btn-back"><i class="fas fa-arrow-left"></i> Go Back</a>
            </div>
        </section>

        <div class="vl-table-card">
            <div class="vl-card-title">
                <div>
                    <h2>Attendance Percentage Details</h2>
                    <span>Monthly attendance calculation report</span>
                </div>
            </div>

            <div class="vl-table-wrap">
                <table id="grdAttendancePerMonthwise" class="table table-bordered table-striped" style="width: 100%">
                    <thead>
                        <tr>
                         <%--   <th>Sr. No.</th>--%>
                            <th>Code</th>
                            <th>Month</th>
                            <th>Year</th>
                            <th>Total Days (Calendar Days)</th>
                            <th>Absent Days (Full days)</th>
                            <th>Partial Days</th>
                            <th>Partial days (equivalent full days)</th>
                            <th>Total Absents (Full day + Partial Days)</th>
                            <th>Present Days (as per Final Salary Calculation)</th>
                            <th>Attendance % on Total Days</th>
                            <th>Latemarks</th>
                            <th>Latemarks Removed</th>
                            <th>Total Latemarks</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>



<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_paginate {
            float: left !important;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
    font-size: 11px !important;
}*/
    </style>
    <script>
        $(document).ready(function () {
            GetDashboardAttendanceDetails();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Detailed Attendnce Percentage</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="Log.aspx" id="aBack" runat="server" style="color: saddlebrown" ><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table id="grdAttendancePerMonthwise" class="table table-bordered table-striped" style="width: 100%">
                    <thead>
                        <tr>
                            <th>Sr. No.</th>
                            <th>Code</th>
                            <th>Month</th>
                            <th>Year</th>
                            <th>Total Days (Calendar Days)</th>
                            <th>Absent Days (Full days)</th>
                            <th>Partial Days</th>
                            <th>Partial days (equivalent full days)</th>
                            <th>Total Absents (Full day + Partial Days)</th>
                            <th>Present Days (as per Final Salary Calculation)</th>
                            <th>Attendance % on Total Days</th>
                            <th>Latemarks</th>
                            <th>Latemarks Removed</th>
                            <th>Total Latemarks</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>--%>
