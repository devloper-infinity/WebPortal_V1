<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Log.aspx.cs" Inherits="WebPortal.Admin.Log" %>

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

        body { background: var(--vl-bg); }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .vl-page { padding-bottom: 24px; }

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
            font-size: 13px;
            font-weight: 800;
        }

        .vl-loader-box img {
            width: 54px;
            height: 54px;
            object-fit: contain;
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

        .vl-hero-left {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .vl-hero-icon {
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

        .vl-hero-actions {
            position: relative;
            z-index: 2;
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .vl-btn {
            min-height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 0 18px;
            border: 0;
            border-radius: 14px;
            color: #fff !important;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none !important;
            cursor: pointer;
            white-space: nowrap;
            transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
        }

        .vl-btn-primary {
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: 0 12px 28px rgba(15, 23, 42, .26);
        }

        .vl-btn-light {
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .30);
            box-shadow: 0 12px 24px rgba(15, 23, 42, .14);
        }

        .vl-btn:hover {
            transform: translateY(-2px);
            background: #fff;
            color: var(--vl-primary) !important;
            box-shadow: 0 18px 36px rgba(15, 23, 42, .28);
        }

        .vl-table-card {
            margin-top: 24px;
            padding: 24px;
            border: 1px solid var(--vl-border);
            border-radius: 22px;
            background: var(--vl-card);
            box-shadow: var(--vl-shadow);
        }

        .vl-table-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
        }

        .vl-table-title h2 {
            margin: 0;
            color: var(--vl-text);
            font-size: 18px;
            font-weight: 900;
        }

        .vl-table-title span {
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

        #log_table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            white-space: nowrap;
        }

        #log_table thead th,
        .table.dataTable#log_table thead th {
            position: sticky;
            top: 0;
            z-index: 2;
         /*   padding: 14px 12px !important;*/
            border: 0 !important;
            border-bottom: 1px solid var(--vl-border) !important;
            background: var(--vl-soft) !important;
            color: var(--vl-text) !important;
            font-size: 12px;
            font-weight: 900;
            text-align: center;
            vertical-align: middle;
        }

        #log_table tbody td,
        .table.dataTable#log_table tbody td {
            padding: 11px 10px !important;
            border-color: var(--vl-border) !important;
            background: #fff;
            color: #1e293b;
            font-size: 13px;
            text-align: center;
            vertical-align: middle;
        }

        #log_table tbody tr:hover td { background: #f8fafc !important; }

        .dataTables_scroll { overflow: auto; }
        .dataTables_paginate { float: left !important; }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            border: 0 !important;
            border-radius: 12px !important;
            background: linear-gradient(135deg, var(--vl-primary), var(--vl-accent)) !important;
            color: #fff !important;
            box-shadow: 0 10px 22px rgba(37, 99, 235, .22) !important;
            font-weight: 800 !important;
            margin: 0 8px !important;
            padding: 8px 15px !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            border: 1px solid var(--vl-border);
            border-radius: 10px;
            padding: 6px 10px;
            outline: none;
        }

        @media (max-width: 768px) {
            .vl-hero { align-items: flex-start; flex-direction: column; }
            .vl-hero-actions { width: 100%; margin-left: 0; justify-content: flex-start; }
            .vl-table-card { padding: 16px; }
        }
    </style>
    
    <style>
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
    </style>
    
    <script>
        $(document).ready(function () {
            log_BindLogDetails();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="vl-loader loading" id="load1">
        <div class="vl-loader-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please...</div>
        </div>
    </div>

    <div class="container-fluid vl-page">
        <section class="vl-hero">
            <div class="vl-hero-left">
                <div class="vl-hero-icon"><i class="fas fa-copy"></i></div>
                <div class="vl-hero-content">
                    <h1 class="vl-title">Daily Log</h1>
                    <p class="vl-subtitle">Track daily attendance, working hours, breaks, extra hours and IP details.</p>
                </div>
            </div>

            <div class="vl-hero-actions">
                <a href="DetailedAttendancePercentage.aspx" id="a1" runat="server" class="vl-btn vl-btn-light">
                    <i class="fas fa-chart-line"></i>
                    <span>Attendance Percentage</span>
                </a>
                <a href="DashboardEmployee.aspx" id="aBack" runat="server" class="vl-btn vl-btn-primary">
                    <i class="fas fa-arrow-left"></i>
                    <span>Go Back</span>
                </a>
            </div>
        </section>

        <section class="vl-table-card">
            <div class="vl-table-title">
                <h2><i class="fas fa-calendar-check"></i>&nbsp; Daily Log Details</h2>
                <span>All times are shown in 24-hour format</span>
            </div>

            <div class="vl-table-wrap">
                <table class="table table-hover table-bordered nowrap" id="log_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Out</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break In</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Extra Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deducted Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Late mark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Partial</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Shift Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Day Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In IP</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out IP</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </section>
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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_scroll {
            overflow: auto;
        }

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
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
            log_BindLogDetails();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Daily Log</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="DetailedAttendancePercentage.aspx" id="a1" runat="server" style="color: saddlebrown"> Detailed Attendance Percentage </a></li>
                        <li class="breadcrumb-item"><a href="DashboardEmployee.aspx" id="aBack" runat="server" style="color: saddlebrown"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table" id="log_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Out</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break In</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Extra Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deducted Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Late mark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Partial</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Shift Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Day Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In IP</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out IP</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                    </tbody>
                </table>

                 </div>
        </div>
    </div>
</asp:Content>--%>
