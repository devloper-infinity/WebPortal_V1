<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="EditDailyLogin.aspx.cs" Inherits="WebPortal.US.EditDailyLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/US/OnshoreDailyLogin.js" type="text/javascript"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .ud-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 28px;
            border-radius: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--ud-shadow);
            margin-bottom: 20px;
        }

            .ud-hero:before,
            .ud-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .ud-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .ud-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
            margin-right: 550px;
        }

        .ud-timezone-pill {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            min-width: 184px;
            padding: 10px 14px;
            border: 1px solid rgba(255, 255, 255, .28);
            border-radius: 999px;
            background: rgba(255, 255, 255, .14);
            color: #fff;
            font-weight: 800;
            white-space: nowrap;
            backdrop-filter: blur(8px);
        }

        .card-header, .box-header, .modal-header {
            background: linear-gradient(271deg, #143961 0%, #0d67cd 100%) !important;
            border-bottom: 1px solid var(--dash-border) !important;
            color: var(--dash-text) !important;
            border-radius: 18px 18px 0 0 !important;
        }

        #osdlBreakModal .modal-title, #osdlBreakModal .card-title {
            color: #ffffff !important;
            font-weight: 700 !important;
            font-size: 17px !important;
            display: flex !important;
            align-items: center !important;
            gap: 10px !important;
        }


        .card-title, .modal-title, .card-header h5, .card-header h3 {
            color: white;
            font-weight: 800 !important;
            letter-spacing: .1px;
        }
    </style>
    <style>
        #osdl_break_popup_table {
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

            #osdl_break_popup_table thead th {
                background: rgba(3 81 149 / 90%) !important;
                color: #ffffff !important;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
                padding: 12px 16px;
                border: none;
            }

            #osdl_break_popup_table tbody td {
                padding: 12px 16px;
                color: #334155;
                vertical-align: middle;
                border-color: #f1f5f9;
                font-size: 0.9rem;
            }
    </style>
    <style>
        :root {
            --dl-ink: #172033;
            --dl-muted: #667085;
            --dl-soft: #f5f7fb;
            --dl-surface: #ffffff;
            --dl-border: #dfe7f2;
            --dl-shadow: 0 18px 42px rgba(23, 32, 51, .09);
            --dl-focus: #2563eb;
            --dl-teal: #0f766e;
            --dl-blue: #2563eb;
            --dl-green: #16803c;
            --dl-amber: #b7791f;
            --dl-cyan: #0e7490;
            --dl-rose: #be123c;
            --dl-slate: #475569;
        }

        body {
            background: var(--dl-soft);
        }

        .daily-login-page {
        }



        .daily-login-card {
            border: 1px solid var(--dl-border);
            border-radius: 8px;
            background: var(--dl-surface);
            box-shadow: var(--dl-shadow);
        }

        #loginout_main {
            padding: 22px;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            z-index: 200000;
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .loading-card {
            width: 196px;
            padding: 22px;
            border: 1px solid rgba(223, 231, 242, .9);
            border-radius: 8px;
            background: #fff;
            text-align: center;
            box-shadow: var(--dl-shadow);
        }

            .loading-card img {
                width: 64px;
                height: 64px;
            }

            .loading-card span {
                display: block;
                margin-top: 10px;
                color: var(--dl-muted);
                font-size: 13px;
                font-weight: 700;
            }

        .dl-alert {
            display: none;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
            padding: 12px 14px;
            border: 1px solid #fecdd3;
            border-radius: 8px;
            color: #9f1239;
            background: #fff1f2;
            font-size: 14px;
            font-weight: 700;
        }

        .dl-session-panel {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 14px;
            align-items: stretch;
            margin-bottom: 22px;
            padding: 12px 14px;
            border: 1px solid rgba(37, 99, 235, .12);
            border-radius: 8px;
            background: linear-gradient(135deg, #f8fbff, #eef6ff);
        }

        .dl-session-left {
            display: grid;
            grid-template-columns: repeat(3, minmax(170px, 1fr));
            gap: 10px;
        }

        .time-block {
            min-height: 74px;
            padding: 10px 12px;
            border: 1px solid var(--dl-border);
            border-radius: 8px;
            background: rgba(255, 255, 255, .86);
        }

            .time-block.is-current {
                border-color: rgba(15, 118, 110, .22);
                background: #f0fdfa;
            }

        .login-label {
            display: flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 5px;
            color: var(--dl-muted);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .04em;
        }

        .login-time {
            display: block;
            color: var(--dl-ink);
            font-size: 18px;
            font-weight: 900;
            line-height: 1.1;
        }

        .dl-live-seconds {
            color: #2563eb;
            font-weight: 900;
        }

        .dl-time-caption {
            display: block;
            min-height: 15px;
            margin-top: 5px;
            color: var(--dl-muted);
            font-size: 12px;
            font-weight: 700;
        }

        .login-actions {
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 10px;
            min-width: 180px;
        }

            .login-actions .btn,
            .dl-table-action {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                border: 0;
                color: white !important;
                border-radius: 8px;
                padding: 9px 15px;
                font-size: 14px;
                font-weight: 800;
                box-shadow: 0 10px 22px rgba(23, 32, 51, .12);
                transition: transform .18s ease, box-shadow .18s ease, opacity .18s ease;
            }

                .login-actions .btn:hover,
                .dl-table-action:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 14px 28px rgba(23, 32, 51, .16);
                }

        #loginout_btnlogin {
            background: #16803c;
        }

        #loginout_btnlogout {
            background: #be123c;
        }

        .dl-status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 32px;
            padding: 7px 11px;
            border: 1px solid #dbeafe;
            border-radius: 999px;
            color: #1d4ed8;
            background: #eff6ff;
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: .04em;
        }

            .dl-status-pill.is-in {
                color: #166534;
                border-color: #bbf7d0;
                background: #f0fdf4;
            }

            .dl-status-pill.is-out {
                color: #9f1239;
                border-color: #fecdd3;
                background: #fff1f2;
            }

            .dl-status-pill.is-closed {
                color: #475569;
                border-color: #cbd5e1;
                background: #f8fafc;
            }

        #spnNotLoggedOut {
            display: none;
            margin-bottom: 18px;
            padding: 13px 14px;
            border: 1px solid #fed7aa;
            border-radius: 8px;
            color: #9a3412 !important;
            background: #fff7ed;
            font-size: 14px;
            font-weight: 800;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(7, minmax(154px, 1fr));
            gap: 12px;
            margin-bottom: 30px;
        }

        .stat-card {
            position: relative;
            display: flex;
            align-items: center;
            gap: 11px;
            min-height: 66px;
            overflow: hidden;
            padding: 14px;
            border: 1px solid var(--dl-border);
            border-radius: 8px;
            background: #fff;
            transition: transform .18s ease, box-shadow .18s ease;
        }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 14px 30px rgba(23, 32, 51, .1);
            }

            .stat-card::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--accent);
            }

            .stat-card .stat-icon {
                display: inline-flex;
                flex: 0 0 auto;
                align-items: center;
                justify-content: center;
                width: 34px;
                height: 34px;
                border-radius: 8px;
                color: var(--accent);
                background: var(--accent-soft);
                font-size: 16px;
            }

        .stat-title {
            color: var(--dl-muted);
            font-size: 13px;
            font-weight: 800;
            line-height: 1.2;
            letter-spacing: 0;
            white-space: nowrap;
        }

            .stat-title::after {
                content: " :";
            }

        .stat-value {
            margin-left: auto;
            color: var(--dl-ink);
            font-size: 18px;
            font-weight: 900;
            line-height: 1;
            white-space: nowrap;
        }

        .stat-total {
            --accent: var(--dl-blue);
            --accent-soft: #eff6ff;
        }

        .stat-working {
            --accent: var(--dl-green);
            --accent-soft: #f0fdf4;
        }

        .stat-holiday {
            --accent: var(--dl-amber);
            --accent-soft: #fffbeb;
        }

        .stat-partial {
            --accent: var(--dl-cyan);
            --accent-soft: #ecfeff;
        }

        .stat-latemark {
            --accent: var(--dl-rose);
            --accent-soft: #fff1f2;
        }

        .stat-absent {
            --accent: #b91c1c;
            --accent-soft: #fef2f2;
        }

        .stat-workingholiday {
            --accent: var(--dl-teal);
            --accent-soft: #f0fdfa;
        }

        .table-section {
            overflow: hidden;
            border: 1px solid var(--dl-border);
            border-radius: 8px;
            background: #fff;
        }

        .table-section-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid var(--dl-border);
            background: #fbfdff;
        }

            .table-section-title h2 {
                margin: 0;
                color: var(--dl-ink);
                font-size: 17px;
                font-weight: 900;
                line-height: 1.2;
            }

            .table-section-title span {
                display: block;
                margin-top: 4px;
                color: var(--dl-muted);
                font-size: 12px;
                font-weight: 700;
            }

        .dl-table-tools {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
        }

        .dl-search {
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 260px;
            padding: 9px 12px;
            border: 1px solid var(--dl-border);
            border-radius: 8px;
            background: #fff;
        }

            .dl-search input {
                width: 100%;
                border: 0;
                outline: 0;
                color: var(--dl-ink);
                font-size: 14px;
                background: transparent;
            }

        .dl-table-action {
            min-height: 40px;
            color: #fff !important;
            background: #2563eb;
        }

        .table-responsive {
            padding: 14px;
        }

        #loginout_table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #loginout_table thead th,
            .table.dataTable th {
                border: 0 !important;
                background: #f1f5f9 !important;
                color: #334155 !important;
                font-size: 11px;
                font-weight: 900;
                text-transform: uppercase;
                letter-spacing: .04em;
                white-space: nowrap;
            }

            #loginout_table tbody td {
                padding: 5px !important;
                border-top: 1px solid #edf2f7;
                color: #334155;
                vertical-align: middle;
                background: #fff;
                font-size: 11px;
            }

            #loginout_table tbody tr:hover td {
                background: #f8fafc;
            }

        .dl-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 58px;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            line-height: 1;
        }

        .dl-badge-success {
            color: #166534;
            background: #dcfce7;
        }

        .dl-badge-warning {
            color: #92400e;
            background: #fef3c7;
        }

        .dl-badge-danger {
            color: #9f1239;
            background: #ffe4e6;
        }

        .dl-badge-muted {
            color: #475569;
            background: #f1f5f9;
        }

        .dl-badge-info {
            color: #075985;
            background: #e0f2fe;
        }

        .dl-table-footer,
        .dataTables_wrapper .row:last-child {
            align-items: center;
            padding: 8px 2px 0;
        }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: var(--dl-muted);
            font-size: 13px;
            font-weight: 700;
        }

        .dataTables_wrapper .page-link {
            border-color: var(--dl-border);
            color: var(--dl-blue);
        }

        .dataTables_wrapper .page-item.active .page-link {
            border-color: var(--dl-blue);
            background: var(--dl-blue);
        }

        .dt-buttons .btn,
        .dt-button.buttons-excel {
            border: 0 !important;
            border-radius: 8px !important;
            color: #fff !important;
            background: #16803c !important;
            font-weight: 800 !important;
            box-shadow: none !important;
        }

        .swal2-container {
            z-index: 20000 !important;
        }

        #waitingpanel .modal-dialog {
            margin-top: 18vh;
        }

        @media (max-width: 1199px) {
            .summary-grid {
                grid-template-columns: repeat(4, minmax(130px, 1fr));
            }

            .dl-session-left {
                grid-template-columns: repeat(2, minmax(170px, 1fr));
            }
        }

        @media (max-width: 767px) {
            .daily-login-page {
                padding-top: 8px;
            }

            .dl-hero-content,
            .dl-session-panel,
            .table-section-title {
                align-items: stretch;
                flex-direction: column;
                display: flex;
            }

            .dl-session-left,
            .summary-grid {
                grid-template-columns: 1fr;
            }

            .login-actions {
                min-width: 100%;
            }

            .dl-search {
                min-width: 100%;
            }

            #loginout_main {
                padding: 16px;
            }
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
            color: #8f0606 !important;
        }

        .row-current td {
            background: #d9ead3 !important;
            color: #274e13 !important;
        }

        .row-incomplete td {
            background-color: #fef2f2 !important;
            color: #FFDB58;
            font-weight: 600;
        }

        #osdlUpdateBreakModal .table-responsive {
            overflow: visible !important;
        }

        .nph-time-input-container {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .nph-clock-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            pointer-events: none;
            font-size: 14px;
        }

        .nph-time-picker-panel {
            display: none;
            position: absolute !important;
            top: 100% !important;
            left: 0 !important;
            z-index: 999999 !important;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            width: 140px;
            height: 160px;
            flex-direction: row;
            padding: 4px;
            margin-top: 4px;
        }

            .nph-time-picker-panel.active {
                display: flex !important;
            }

        .nph-time-column {
            flex: 1;
            overflow-y: auto;
            height: 100%;
            padding: 2px;
            scrollbar-width: thin;
        }

            .nph-time-column:first-child {
                border-right: 1px solid #e2e8f0;
            }

        .nph-time-option {
            padding: 5px 0;
            text-align: center;
            cursor: pointer;
            font-size: 13px;
            color: #495057;
            border-radius: 4px;
            user-select: none;
        }

            .nph-time-option:hover {
                background-color: #f1f5f9;
                color: #2563eb;
            }

            .nph-time-option.selected {
                background-color: #2563eb !important;
                color: #ffffff !important;
                font-weight: bold;
            }

        .nph-time-column::-webkit-scrollbar {
            width: 4px;
        }

        .nph-time-column::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }

        .editmodal-title {
            color: white;
            font-weight: 800 !important;
            letter-spacing: .1px;
        }

        .btn-secondaryupdate {
            background: linear-gradient(to right, #0961df, #5899ed) !important;
            color: #334155 !important;
            border: 0 !important;
            border-radius: 12px !important;
            font-weight: 700 !important;
        }

        #editModal .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 10px 14px;
            height: auto;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
        }

            #editModal .form-control:focus {
                border-color: #80bdff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.15);
                outline: none;
            }

            #editModal .form-control[readonly] {
                background-color: #f8f9fa;
                opacity: 1;
            }

        #editModal .nph-time-input-container .form-control {
            padding-right: 38px;
        }

        #editModal .modal-footer .btn {
            border-radius: 6px;
            padding: 8px 16px;
            font-weight: 500;
        }

        #editModal .btn-secondaryupdate {
            background-color: #007bff;
            border-color: #007bff;
            color: #fff;
            transition: background-color 0.2s;
        }

            #editModal .btn-secondaryupdate:hover {
                background-color: #0056b3;
                border-color: #004085;
            }

        #editModal .nph-time-picker-panel {
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border: 1px solid #e2e8f0;
        }
    </style>

    <script>
        $(document).ready(function () {
            GetAllEmpOnshoreDailyLogs();
            initTimePickers();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div class="loading-card">
            <img src="../images/Load_1.gif" alt="Loading" />
            <span>One moment, please</span>
        </div>
    </div>
    <div class="daily-login-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="fas fa-pen-to-square"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">Edit Daily Login/Logout</h1>
                <p class="ud-subtitle">edit daily login, logout, and break-in/break-out times.</p>
            </div>

        </section>
        <div class="card daily-login-card">
            <div class="card-body" id="loginout_main">

                <section class="table-section">
                    <div class="table-section-title">
                        <div>
                            <h2><i class="fas fa-calendar-check"></i>&nbsp;Edit Attendance</h2>
                        </div>

                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover" id="editonshoreloginout_table">
                            <thead>
                                <tr>
                                    <th>Action</th>
                                    <th style="display: none;">ID</th>
                                    <th style="display: none;">Code</th>

                                    <th>EmployeeName</th>
                                    <th>Date</th>
                                    <th>In Time</th>
                                    <th>Out Time</th>
                                    <th>Breaks</th>
                                    <th>Hours</th>
                                    <th>UpdateRemark</th>

                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <!-- Edit Popup Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document" style="max-width: 700px; width: 100%;">
            <div class="modal-content" style="min-height: 450px;">
                <div class="modal-header">
                    <h5 class="editmodal-title" id="editModalLabel"><i class="fas fa-edit"></i>Edit Attendance</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="min-height: 320px;">
                    <div class="form-group">
                        <label>Date</label>
                        <input type="text" id="editonshoretxtDate" class="form-control" readonly />
                    </div>

                    <!-- In Time -->
                    <div class="form-group">
                        <label>In Time</label>
                        <div class="nph-time-input-container" style="position: relative">
                            <input type="text" id="editonshoretxtInTime" class="form-control" placeholder="--:--" style="padding-right: 35px;" />
                            <i class="fas fa-clock" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #6c757d; pointer-events: none;"></i>
                            <div class="nph-time-picker-panel" id="in-time-panel">
                                <div class="nph-time-column" id="in-hours"></div>
                                <div class="nph-time-column" id="in-mins"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Out Time -->
                    <div class="form-group">
                        <label>Out Time</label>
                        <div class="nph-time-input-container" style="position: relative">
                            <input type="text" id="editonshoretxtOutTime" class="form-control" placeholder="--:--" style="padding-right: 35px;" />
                            <i class="fas fa-clock" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #6c757d; pointer-events: none;"></i>
                            <div class="nph-time-picker-panel" id="out-time-panel" style="top: auto; bottom: 100%; margin-bottom: 5px;">
                                <div class="nph-time-column" id="out-hours"></div>
                                <div class="nph-time-column" id="out-mins"></div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Update Remark</label>
                        <input type="text" id="editonshoretxtUpdateRemark" class="form-control" placeholder="Enter update remark..." />
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-secondaryupdate" id="btnUpdate">Update</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="osdlUpdateBreakModal" tabindex="-1" role="dialog" aria-labelledby="osdlUpdateBreakModal" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style="max-width: 1000px; width: 100%;">
            <div class="modal-content" style="height: 80vh;">
                <div class="modal-header">
                    <h5 class="editmodal-title" id="osdlUpdatelblBreakModal"><i class="fas fa-clock" aria-hidden="true"></i>Break Details</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <div class="table-responsive">
                        <table id="osdl_breakInOutForupdate_table" class="table table-hover table-striped table-bordered align-middle mb-0" style="width: 100%;">
                            <tfoot>
                                <tr>
                                    <th colspan="3" style="text-align: right; font-weight: bold; color: #007bff;">Total Break Hour:</th>
                                    <th id="totalBreakSum" style="font-size: 12px; font-weight: bold; color: #007bff;">0.00</th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
