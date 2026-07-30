<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="OSTReport.aspx.cs" Inherits="WebPortal.Search.OSTReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --ost-bg: #f4f6f8;
            --ost-surface: #ffffff;
            --ost-border: #d8e1e8;
            --ost-soft: #edf2f6;
            --ost-text: #1f2937;
            --ost-muted: #64748b;
            --ost-primary: #0f766e;
            --ost-primary-dark: #115e59;
            --ost-accent: #2563eb;
            --ost-danger: #dc2626;
            --ost-warning: #b45309;
            --ost-success: #15803d;
            --ost-info: #0369a1;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .74);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .loading img {
            width: 64px;
            height: 64px;
            display: block;
            margin: 0 auto 10px;
        }

        .loading div {
            color: var(--ost-text);
            font-size: 12px;
            font-weight: 700;
        }

        .ost-page {
            min-height: calc(100vh - 72px);
            background: var(--ost-bg);
        }

        .ost-header,
        .ost-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .ost-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 14px;
            padding: 14px 18px;
            background: var(--ost-surface);
            border: 1px solid var(--ost-border);
            border-left: 4px solid var(--ost-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .ost-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--ost-text);
            font-size: 22px;
            font-weight: 700;
        }

        .ost-title i {
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: var(--ost-primary);
            border-radius: 8px;
            font-size: 15px;
        }

        .ost-context {
            margin-top: 2px;
            color: var(--ost-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .ost-shell {
            background: var(--ost-surface);
            border: 1px solid var(--ost-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .ost-filter-panel {
            padding: 16px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--ost-soft);
        }

        .ost-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .ost-field {
            margin-bottom: 0;
        }

        .ost-field label {
            display: block;
            margin-bottom: 5px;
            color: var(--ost-text);
            font-size: 12px;
            font-weight: 700 !important;
            line-height: 1.25;
            border: 0 !important;
        }

        .ost-field .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            color: var(--ost-text);
            font-size: 13px;
            box-shadow: none;
        }

        .ost-field .form-control:focus {
            border-color: var(--ost-primary);
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .ost-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-ost-primary,
        .btn-ost-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            border-radius: 7px;
            font-weight: 700;
        }

        .btn-ost-primary {
            color: #ffffff;
            background: var(--ost-primary);
            border-color: var(--ost-primary);
        }

        .btn-ost-primary:hover,
        .btn-ost-primary:focus {
            color: #ffffff;
            background: var(--ost-primary-dark);
            border-color: var(--ost-primary-dark);
        }

        .btn-ost-secondary {
            color: var(--ost-text);
            background: #ffffff;
            border-color: var(--ost-border);
        }

        .btn-ost-secondary:hover,
        .btn-ost-secondary:focus {
            color: var(--ost-primary-dark);
            background: #edf7f5;
            border-color: #b7d9d4;
        }

        .ost-grid-panel {
            padding: 16px;
        }

        .ost-grid-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .ost-grid-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: var(--ost-text);
            font-size: 15px;
            font-weight: 700;
        }

        .ost-grid-header h2 i {
            color: var(--ost-accent);
        }

        .ost-grid-subtitle {
            margin: 0;
            color: var(--ost-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .ost-table-frame {
            border: 1px solid var(--ost-soft);
            border-radius: 8px;
            overflow: hidden;
            background: #ffffff;
        }

        .ost-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        .ost-table,
        #table_OSTReport {
            width: 100% !important;
            min-width: 1780px;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        .ost-table thead th,
        #table_OSTReport thead th {
            color: var(--ost-text);
            background: #edf3f6 !important;
            background-image: none !important;
            border-color: #d7e2ea !important;
            border-bottom: 1px solid #d7e2ea !important;
            font-size: 12px;
            font-weight: 700;
            text-align: left;
            white-space: nowrap;
            vertical-align: middle;
        }

        #table_OSTReport thead tr:nth-child(2) th {
            padding: 6px;
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
        }

        .ost-table tbody td,
        #table_OSTReport tbody td {
            color: var(--ost-text);
            background: #ffffff !important;
            font-size: 12px;
            vertical-align: middle;
        }

        .ost-table tbody tr:hover td,
        #table_OSTReport tbody tr:hover td {
            background: #f8fbfb !important;
        }

        .column-filter {
            width: 100%;
            min-width: 104px;
            min-height: 32px;
            padding: 5px 9px;
            color: var(--ost-text);
            background-color: #ffffff;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            font-size: 11px;
            font-weight: 600;
            outline: none;
            box-shadow: none;
        }

        .column-filter:focus {
            border-color: var(--ost-primary);
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .ost-chip {
            display: inline-flex;
            align-items: center;
            min-height: 24px;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            line-height: 1.2;
            white-space: nowrap;
        }

        .ost-chip-neutral {
            color: var(--ost-text);
            background: #eef2f7;
        }

        .ost-chip-success {
            color: #166534;
            background: #dcfce7;
        }

        .ost-chip-info {
            color: var(--ost-info);
            background: #e0f2fe;
        }

        .ost-chip-warning {
            color: var(--ost-warning);
            background: #fef3c7;
        }

        .ost-chip-danger {
            color: #ffffff;
            background: var(--ost-danger);
        }

        .ost-chip-priority {
            color: #365314;
            background: #d9f99d;
        }

        .ost-cell-muted {
            color: var(--ost-muted);
            font-weight: 700;
        }

        .ost-text-wrap {
            min-width: 240px;
            max-width: 360px;
            white-space: normal;
        }

        .dataTables_wrapper .ost-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .dataTables_wrapper .dataTables_filter {
            text-align: left;
        }

        .dataTables_wrapper .dataTables_filter label,
        .dataTables_wrapper .dataTables_length label {
            color: var(--ost-muted);
            font-size: 12px;
            font-weight: 700 !important;
        }

        .dataTables_wrapper .dataTables_filter input,
        .dataTables_wrapper .dataTables_length select {
            min-height: 34px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            margin-left: 6px;
        }

        .dataTables_wrapper .dataTables_info {
            float: none !important;
            padding-top: 10px;
            color: var(--ost-muted);
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate {
            padding-top: 8px;
        }

        .dataTables_wrapper .paginate_button {
            border-radius: 7px !important;
        }

        .dataTables_wrapper .dt-buttons {
            float: none;
            padding-left: 0;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #ffffff !important;
            background: var(--ost-accent) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            box-shadow: none !important;
        }

        @media (max-width: 991px) {
            .ost-filter-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 575px) {
            .ost-page {
                padding: 12px;
            }

            .ost-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .ost-title {
                font-size: 19px;
            }

            .ost-filter-grid {
                grid-template-columns: 1fr;
            }

            .ost-actions {
                flex-direction: column;
            }

            .ost-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            if (typeof OSTReport_InitPage === "function") {
                OSTReport_InitPage();
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ost-page">
        <div class="loading search-page-loader" id="load1">
            <div>
                <img src="../images/Load_1.gif" alt="Loading" />
                <div>One moment, please . . . .</div>
            </div>
        </div>

        <div class="ost-header search-modern-header">
            <div class="search-header-identity">
                <span class="search-header-icon"><i class="fas fa-chart-bar"></i></span>
                <div class="search-header-copy">
                <h1 class="ost-title"><span>OST Report</span></h1>
                <div class="ost-context">Search Operations</div>
                </div>
            </div>
        </div>

        <div class="ost-shell">
            <div class="ost-filter-panel">
                <div class="ost-filter-grid">
                    <div class="form-group ost-field">
                        <label for="OSTReport_projectno">Project #</label>
                        <select id="OSTReport_projectno" name="OSTReport_projectno" class="form-control"></select>
                    </div>
                    <div class="form-group ost-field">
                        <label for="OSTReportFromDate">From Date</label>
                        <input type="date" id="OSTReportFromDate" name="OSTReportFromDate" class="form-control" />
                    </div>
                    <div class="form-group ost-field">
                        <label for="OSTReportToDate">To Date</label>
                        <input type="date" id="OSTReportToDate" name="OSTReportToDate" class="form-control" />
                    </div>
                    <div class="ost-actions">
                        <button class="btn btn-ost-secondary" type="button" id="OSTReport_Clear" onclick="return OSTReport_ClearFilters();">
                            <i class="fas fa-eraser"></i><span>Clear</span>
                        </button>
                        <button class="btn btn-ost-primary" type="button" id="OSTReport_Show" onclick="return OSTReportShow();">
                            <i class="fas fa-search"></i><span>Show</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="ost-grid-panel">
                <div class="ost-grid-header">
                    <div>
                        <h2><i class="fas fa-table"></i><span>Report Results</span></h2>
                        <p class="ost-grid-subtitle">Status, assignment, and order details</p>
                    </div>
                </div>

                <div class="ost-table-frame">
                    <div class="ost-table-wrap">
                        <table class="table table-hover table-sm ost-table" id="table_OSTReport">
                            <thead>
                                <tr>
                                    <th>Sr. #</th>
                                    <th>Project</th>
                                    <th>Order #</th>
                                    <th>Order Date</th>
                                    <th>On / Offline</th>
                                    <th>Product Type</th>
                                    <th>Priority</th>
                                    <th>State</th>
                                    <th>County</th>
                                    <th>Status</th>
                                    <th>Search</th>
                                    <th>Research</th>
                                    <th>DE</th>
                                    <th>QA</th>
                                    <th>Audit</th>
                                    <th>Dispatch</th>
                                    <th>Remark</th>
                                    <th>Client ID</th>
                                    <th>Customer Type</th>
                                    <th>Legal Description</th>
                                    <th>Instruction</th>
                                    <th>APN #</th>
                                    <th>Transaction Type</th>
                                </tr>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th>
                                        <select id="filterStatus" class="column-filter">
                                            <option value="">All</option>
                                        </select>
                                    </th>
                                    <th>
                                        <select id="filterSearch" class="column-filter">
                                            <option value="">All</option>
                                        </select>
                                    </th>
                                    <th>
                                        <select id="filterResearch" class="column-filter">
                                            <option value="">All</option>
                                        </select>
                                    </th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
