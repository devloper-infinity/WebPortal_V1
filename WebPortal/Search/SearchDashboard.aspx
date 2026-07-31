<%@ Page Title="Search Operations Dashboard" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="SearchDashboard.aspx.cs" Inherits="WebPortal.Search.SearchDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css" />
    <style>
        :root {
            --sd-primary: #0f766e;
            --sd-dark: #115e59;
            --sd-border: #dbe4ea;
            --sd-bg: #f4f6f8;
            --sd-muted: #64748b;
        }

        #sdLoader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 2147483647;
            background: rgba(248,250,252,.76);
            align-items: center;
            justify-content: center;
        }

            #sdLoader.active {
                display: flex;
            }

        .sd-spinner {
            width: 54px;
            height: 54px;
            border: 5px solid #dbe7e5;
            border-top-color: var(--sd-primary);
            border-radius: 50%;
            animation: sdSpin .75s linear infinite;
        }

        @keyframes sdSpin {
            to {
                transform: rotate(360deg);
            }
        }

        .sd-page {
            background: var(--sd-bg);
            min-height: calc(100vh - 70px);
            /*   padding: 14px;*/
            color: #1f2937;
        }

        .sd-shell {
            max-width: 1600px;
            margin: 0 auto;
        }

        .sd-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 15px 18px;
            background: #fff;
            border: 1px solid var(--sd-border);
            border-left: 4px solid var(--sd-primary);
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .sd-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .sd-subtitle {
            color: var(--sd-muted);
            font-size: 12px;
            margin-top: 3px;
        }

        .sd-header-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .sd-auto-refresh-note {
            color: #dc2626;
            font-size: 11px;
            font-weight: 700;
        }

        .sd-tabs {
            background: #fff;
            border: 1px solid var(--sd-border);
            border-radius: 8px;
            overflow: hidden;
        }

            .sd-tabs .nav {
                gap: 2px;
                padding: 10px 10px 0;
                border-bottom: 1px solid var(--sd-border);
                flex-wrap: wrap;
            }

            .sd-tabs .nav-link {
                border: 0;
                border-radius: 6px 6px 0 0;
                color: #475569;
                font-weight: 600;
                padding: 10px 14px;
            }

                .sd-tabs .nav-link.active {
                    color: #fff;
                    background: var(--sd-primary);
                }

            .sd-tabs .tab-pane {
                padding: 14px;
            }

        .sd-card {
            background: #fff;
            border: 1px solid var(--sd-border);
            border-radius: 8px;
            margin-bottom: 12px;
        }

        .sd-card-title {
            padding: 10px 13px;
            border-bottom: 1px solid var(--sd-border);
            font-size: 13px;
            font-weight: 700;
            color: #065f5b;
        }

        .sd-card-body {
            padding: 13px;
        }

        .sd-grid {
            display: grid;
            grid-template-columns: repeat(12,minmax(0,1fr));
            gap: 10px;
            align-items: end;
        }

        .sd-col-2 {
            grid-column: span 2
        }

        .sd-col-3 {
            grid-column: span 3
        }

        .sd-col-4 {
            grid-column: span 4
        }

        .sd-col-6 {
            grid-column: span 6
        }

        .sd-col-12 {
            grid-column: span 12
        }

        .sd-field label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            margin-bottom: 4px;
            color: #334155;
        }

        .sd-field .form-control {
            height: 36px;
            font-size: 12px;
            border-color: #cbd5e1;
            border-radius: 6px;
            padding: 1%;
        }

        .sd-field textarea.form-control {
            height: 72px;
            resize: vertical;
        }

        .sd-required:after {
            content: " *";
            color: #dc2626;
        }

        .sd-actions {
            /* display: flex;*/
            text-align: right;
            flex-wrap: wrap;
            gap: 7px;
            align-items: center;
        }

        .sd-btn {
            height: 36px;
            padding: 0 14px;
            border: 0;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
        }

        .sd-btn-primary {
            background: var(--sd-primary);
            color: #fff;
        }

            .sd-btn-primary:hover {
                background: var(--sd-dark);
                color: #fff
            }

        .sd-btn-light {
            background: #eef2f6;
            color: #334155;
            border: 1px solid #d5dee6;
        }

        .sd-table-wrap {
            overflow: auto;
            max-width: 100%;
        }

        .sd-table {
            width: 100% !important;
            white-space: nowrap;
            font-size: 11px;
        }

            .sd-table thead th {
                background: #e9f2f5;
                color: #183b4c;
                border-bottom: 2px solid #7cb6d2 !important;
                vertical-align: middle;
            }

            .sd-table tbody tr.sd-selected {
                background: #e8f5f3 !important;
            }

        .sd-get-orders {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            padding: 0;
            color: #fff;
            background: var(--sd-primary);
            border: 0;
            border-radius: 50%;
            box-shadow: 0 5px 12px rgba(15,118,110,.2);
            cursor: pointer;
            transition: background-color .15s ease, transform .15s ease, box-shadow .15s ease;
        }

            .sd-get-orders:hover,
            .sd-get-orders:focus {
                color: #fff;
                background: var(--sd-dark);
                box-shadow: 0 7px 16px rgba(15,118,110,.28);
                outline: none;
                transform: translateY(-1px);
            }

        .sd-focus-target:focus {
            outline: none;
            border-color: var(--sd-primary);
            box-shadow: 0 0 0 3px rgba(15,118,110,.16), 0 10px 24px rgba(31,41,55,.06);
        }

        .sd-checks {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            min-height: 36px;
            align-items: center;
        }

        .checkbox-wrapper-24 {
            display: inline-flex;
            align-items: center;
            vertical-align: middle;
        }

            .checkbox-wrapper-24 label {
                display: inline-flex;
                align-items: center;
                margin: 0;
                color: #334155;
                cursor: pointer;
                position: relative;
                font-size: 12px;
                font-weight: 700;
                line-height: 1.2;
                user-select: none;
            }

                .checkbox-wrapper-24 label span {
                    display: inline-block;
                    position: relative;
                    flex: 0 0 auto;
                    width: 22px;
                    height: 22px;
                    margin-right: 8px;
                    background-color: transparent;
                    border: 2px solid #64748b;
                    border-radius: 50%;
                    transform-origin: center;
                    transition: background-color 150ms 200ms, border-color 150ms ease, transform 350ms cubic-bezier(.78,-1.22,.17,1.89);
                }

                    .checkbox-wrapper-24 label span::before,
                    .checkbox-wrapper-24 label span::after {
                        content: "";
                        width: 0;
                        height: 2px;
                        border-radius: 2px;
                        background: #64748b;
                        position: absolute;
                        transform-origin: 0 0;
                    }

                    .checkbox-wrapper-24 label span::before {
                        transform: rotate(45deg);
                        top: 11px;
                        left: 7px;
                        transition: width 50ms ease 50ms;
                    }

                    .checkbox-wrapper-24 label span::after {
                        transform: rotate(305deg);
                        top: 14px;
                        left: 8px;
                        transition: width 50ms ease;
                    }

                .checkbox-wrapper-24 label:hover span {
                    border-color: var(--sd-primary);
                }

                    .checkbox-wrapper-24 label:hover span::before {
                        width: 5px;
                        transition: width 100ms ease;
                    }

                    .checkbox-wrapper-24 label:hover span::after {
                        width: 10px;
                        transition: width 150ms ease 100ms;
                    }

            .checkbox-wrapper-24 input[type="checkbox"] {
                position: absolute;
                width: 1px;
                height: 1px;
                opacity: 0;
                pointer-events: none;
            }

                .checkbox-wrapper-24 input[type="checkbox"]:focus-visible + label span {
                    outline: 3px solid rgba(15,118,110,.22);
                    outline-offset: 2px;
                }

                .checkbox-wrapper-24 input[type="checkbox"]:checked + label span {
                    background-color: var(--sd-primary);
                    border-color: var(--sd-primary);
                    transform: scale(1.14);
                    box-shadow: 0 4px 10px rgba(15,118,110,.22);
                }

                    .checkbox-wrapper-24 input[type="checkbox"]:checked + label span::after {
                        width: 10px;
                        background: #fff;
                        transition: width 150ms ease 100ms;
                    }

                    .checkbox-wrapper-24 input[type="checkbox"]:checked + label span::before {
                        width: 5px;
                        background: #fff;
                        transition: width 150ms ease 100ms;
                    }

                .checkbox-wrapper-24 input[type="checkbox"]:disabled + label {
                    cursor: not-allowed;
                    opacity: .48;
                }

            .checkbox-wrapper-24.compact label span {
                width: 19px;
                height: 19px;
                margin-right: 0;
            }

                .checkbox-wrapper-24.compact label span::before {
                    top: 9px;
                    left: 6px;
                }

                .checkbox-wrapper-24.compact label span::after {
                    top: 12px;
                    left: 7px;
                }

        .sd-file-control {
            height: 42px !important;
            padding: 4px 6px !important;
            color: #475569;
            background: linear-gradient(135deg,#fff 0%,#f8fafc 100%);
            border: 1px dashed #94a3b8 !important;
            border-radius: 8px !important;
            cursor: pointer;
            transition: border-color .15s ease, box-shadow .15s ease, background-color .15s ease;
        }

            .sd-file-control:hover,
            .sd-file-control:focus {
                border-color: var(--sd-primary) !important;
                box-shadow: 0 0 0 3px rgba(15,118,110,.12);
                outline: none;
            }

            .sd-file-control::file-selector-button {
                height: 32px;
                margin: 0 12px 0 0;
                padding: 0 14px;
                color: #fff;
                background: var(--sd-primary);
                border: 0;
                border-radius: 6px;
                font-size: 11px;
                font-weight: 800;
                cursor: pointer;
                transition: background-color .15s ease, transform .15s ease;
            }

            .sd-file-control:hover::file-selector-button {
                background: var(--sd-dark);
                transform: translateY(-1px);
            }

        .sd-band {
            background: #d7ece9 !important;
            color: #0f5f59 !important;
            text-align: center;
            font-weight: 800 !important;
        }

        /* ViewBilling-compatible styling scoped to the Edit Costing DataTable. */
        .cost-table-frame {
            overflow: hidden;
            padding: 12px !important;
            background: #ffffff;
        }

        #costTable {
            width: 100% !important;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        #costTable_wrapper .dataTables_scroll {
            clear: both;
            overflow: hidden;
            border: 1px solid #dbe4ea;
            border-radius: 8px;
            background: #ffffff;
        }

        #costTable_wrapper .dataTables_scrollHead {
            background: #edf3f6;
        }

        #costTable_wrapper table.dataTable {
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #costTable_wrapper table.dataTable thead th {
                padding: 8px 10px !important;
                color: #263747;
                background: #edf3f6 !important;
                background-image: none !important;
                border-top: 0 !important;
                border-right: 1px solid rgba(148, 163, 184, .24) !important;
                border-bottom: 1px solid #dce5ec !important;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: .015em;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

                #costTable_wrapper table.dataTable thead th.costing-band-header {
                    border-bottom: 0 !important;
                    letter-spacing: .055em;
                    text-transform: uppercase;
                }

                #costTable_wrapper table.dataTable thead .band-core {
                    color: #1e3a8a !important;
                    background: #dbeafe !important;
                    box-shadow: inset 0 3px 0 #3b82f6;
                }

                #costTable_wrapper table.dataTable thead .band-search {
                    color: #1e3a8a !important;
                    background: #bfdbfe !important;
                    box-shadow: inset 0 3px 0 #2563eb;
                }

                #costTable_wrapper table.dataTable thead .band-search-copy {
                    color: #115e59 !important;
                    background: #ccfbf1 !important;
                    box-shadow: inset 0 3px 0 #0d9488;
                }

                #costTable_wrapper table.dataTable thead .band-judgment-search {
                    color: #6b21a8 !important;
                    background: #e9d5ff !important;
                    box-shadow: inset 0 3px 0 #9333ea;
                }

                #costTable_wrapper table.dataTable thead .band-judgment-copy {
                    color: #9d174d !important;
                    background: #fce7f3 !important;
                    box-shadow: inset 0 3px 0 #db2777;
                }

                #costTable_wrapper table.dataTable thead .band-abstractor {
                    color: #166534 !important;
                    background: #dcfce7 !important;
                    box-shadow: inset 0 3px 0 #16a34a;
                }

                #costTable_wrapper table.dataTable thead .band-tax {
                    color: #92400e !important;
                    background: #fef3c7 !important;
                    box-shadow: inset 0 3px 0 #d97706;
                }

                #costTable_wrapper table.dataTable thead .band-other {
                    color: #9a3412 !important;
                    background: #ffedd5 !important;
                    box-shadow: inset 0 3px 0 #ea580c;
                }

                #costTable_wrapper table.dataTable thead .band-core-sub {
                    color: #1e3a8a !important;
                    background: #eff6ff !important;
                    border-bottom-color: #60a5fa !important;
                }

                #costTable_wrapper table.dataTable thead .band-search-sub {
                    color: #1e3a8a !important;
                    background: #eff6ff !important;
                    border-bottom-color: #60a5fa !important;
                }

                #costTable_wrapper table.dataTable thead .band-search-copy-sub {
                    color: #115e59 !important;
                    background: #f0fdfa !important;
                    border-bottom-color: #2dd4bf !important;
                }

                #costTable_wrapper table.dataTable thead .band-judgment-search-sub {
                    color: #6b21a8 !important;
                    background: #faf5ff !important;
                    border-bottom-color: #c084fc !important;
                }

                #costTable_wrapper table.dataTable thead .band-judgment-copy-sub {
                    color: #9d174d !important;
                    background: #fdf2f8 !important;
                    border-bottom-color: #f472b6 !important;
                }

                #costTable_wrapper table.dataTable thead .band-abstractor-sub {
                    color: #166534 !important;
                    background: #f0fdf4 !important;
                    border-bottom-color: #4ade80 !important;
                }

                #costTable_wrapper table.dataTable thead .band-tax-sub {
                    color: #92400e !important;
                    background: #fffbeb !important;
                    border-bottom-color: #fbbf24 !important;
                }

                #costTable_wrapper table.dataTable thead .band-other-sub {
                    color: #9a3412 !important;
                    background: #fff7ed !important;
                    border-bottom-color: #fb923c !important;
                }

        #costTable tbody td {
            padding: 9px 11px !important;
            color: #263747;
            background: #ffffff !important;
            border-right: 1px solid #edf2f7 !important;
            border-bottom: 1px solid #e8eef3 !important;
            font-size: 11px;
            vertical-align: middle;
            white-space: nowrap;
        }

            #costTable tbody td.band-core-sub,
            #costTable tbody td.band-search-sub {
                background: rgba(37, 99, 235, .035) !important;
            }

            #costTable tbody td.band-search-copy-sub {
                background: rgba(13, 148, 136, .04) !important;
            }

            #costTable tbody td.band-judgment-search-sub {
                background: rgba(147, 51, 234, .04) !important;
            }

            #costTable tbody td.band-judgment-copy-sub {
                background: rgba(219, 39, 119, .035) !important;
            }

            #costTable tbody td.band-abstractor-sub {
                background: rgba(22, 163, 74, .04) !important;
            }

            #costTable tbody td.band-tax-sub {
                background: rgba(217, 119, 6, .05) !important;
            }

            #costTable tbody td.band-other-sub {
                background: rgba(234, 88, 12, .04) !important;
            }

        #costTable tbody tr:nth-child(even) td {
            box-shadow: inset 0 0 0 999px rgba(248, 250, 252, .3);
        }

        #costTable tbody tr:hover td {
            background: #eaf4f7 !important;
            box-shadow: none;
        }

        #costTable_wrapper .dataTables_filter {
            float: right;
            margin-bottom: 10px;
            text-align: left;
        }

        #costTable_wrapper .dataTables_filter label,
        #costTable_wrapper .dataTables_length label,
        #costTable_wrapper .dataTables_info {
            color: #64748b;
            font-size: 12px;
            font-weight: 700 !important;
        }

        #costTable_wrapper .dataTables_filter input,
        #costTable_wrapper .dataTables_length select {
            min-height: 34px;
            margin-left: 6px;
            padding: 5px 10px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            background: #ffffff;
            box-shadow: none;
        }

            #costTable_wrapper .dataTables_filter input:focus,
            #costTable_wrapper .dataTables_length select:focus {
                border-color: var(--sd-primary);
                box-shadow: 0 0 0 .16rem rgba(15, 118, 110, .12);
                outline: 0;
            }

        #costTable_wrapper .dataTables_scrollBody {
            min-height: 0 !important;
            height: auto;
            scrollbar-color: #94a3b8 #edf2f5;
            scrollbar-width: thin;
        }

            #costTable_wrapper .dataTables_scrollBody::-webkit-scrollbar {
                width: 8px;
                height: 8px;
            }

            #costTable_wrapper .dataTables_scrollBody::-webkit-scrollbar-track {
                background: #edf2f5;
            }

            #costTable_wrapper .dataTables_scrollBody::-webkit-scrollbar-thumb {
                background: #94a3b8;
                border-radius: 999px;
            }

        #costTable_wrapper .dataTables_info,
        #costTable_wrapper .dataTables_paginate {
            padding-top: 10px;
        }

        #costTable_wrapper .dataTables_paginate .paginate_button {
            min-width: 34px;
            margin: 0 2px;
            padding: 6px 10px !important;
            color: #475569 !important;
            background: #ffffff !important;
            border: 1px solid #dbe4ea !important;
            border-radius: 7px !important;
        }

            #costTable_wrapper .dataTables_paginate .paginate_button.current,
            #costTable_wrapper .dataTables_paginate .paginate_button.current:hover {
                color: #ffffff !important;
                background: var(--sd-primary) !important;
                border-color: var(--sd-primary) !important;
            }

        @media(max-width:576px) {
            #costTable_wrapper .dataTables_filter {
                float: none;
                width: 100%;
            }

                #costTable_wrapper .dataTables_filter label,
                #costTable_wrapper .dataTables_filter input {
                    width: 100%;
                }
        }

        .sd-help {
            font-size: 11px;
            color: var(--sd-muted);
            margin-top: 5px;
        }

        .sd-alert {
            display: none;
            margin-bottom: 12px;
            font-size: 12px;
        }

        .sd-empty {
            text-align: center;
            padding: 30px;
            color: var(--sd-muted);
        }

        @media(max-width:900px) {
            .sd-col-2, .sd-col-3, .sd-col-4, .sd-col-6 {
                grid-column: span 12
            }

            .sd-header {
                align-items: flex-start;
                flex-direction: column
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="sdLoader">
        <div>
            <div class="sd-spinner"></div>
            <div class="mt-2 font-weight-bold">Please wait...</div>
        </div>
    </div>
    <main class="sd-page">
        <div class="sd-shell">
            <header class="sd-header search-modern-header">
                <div class="search-header-identity">
                    <span class="search-header-icon"><i class="fas fa-tachometer-alt"></i></span>
                    <div class="search-header-copy">
                    <h1 class="sd-title"><span>Search Operations Dashboard</span></h1>
                    <div class="sd-subtitle">Allocation, PM processing, document exchange and costing in one workspace</div>
                    </div>
                </div>
                <div class="sd-header-actions">
                    <span class="sd-auto-refresh-note">Note: Allocation tabs auto refresh every 5 minutes</span>
                    <button type="button" id="sdRefresh" class="sd-btn sd-btn-light"><i class="fas fa-sync-alt mr-1"></i>Refresh active tab</button>
                </div>
            </header>
            <div id="sdAlert" class="alert sd-alert"></div>
            <section class="sd-tabs">
                <ul class="nav nav-tabs" id="sdMainTabs" role="tablist">
                    <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#sdAllocation" data-module="allocation">Allocation</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#sdQueue" data-module="queue">Order Queue</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#sdProcess" data-module="process">Process Order</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#sdUpload" data-module="upload">Upload And Download</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#sdCosting" data-module="costing">Edit Costing</a></li>
                </ul>
                <div class="tab-content">
                    <div id="sdAllocation" class="tab-pane fade show active">
                        <div class="sd-card">
                            <div class="sd-card-title">Allocation Criteria</div>
                            <div class="sd-card-body">
                                <div class="sd-grid">
                                    <div class="sd-field sd-col-4">
                                        <label class="sd-required">Project</label><select id="allocProject" class="form-control sd-project"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-4">
                                        <label class="sd-required">Process</label><select id="allocProcess" class="form-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-4">
                                        <button type="button" id="allocShowSummary" class="sd-btn sd-btn-primary">Show Orders</button>
                                    </div>
                                </div>

                                <div class="sd-card-body sd-table-wrap">
                                    <table id="allocSummaryTable" class="table table-bordered table-striped sd-table"></table>
                                </div>
                            </div>
                        </div>
                        <%--  <div class="sd-card">
                            <div class="sd-card-title">Order Summary <span class="float-right font-weight-normal">Select a row to load orders</span></div>
                            <div class="sd-card-body sd-table-wrap">
                                <table id="allocSummaryTable" class="table table-bordered table-striped sd-table"></table>
                            </div>
                        </div>--%>
                        <div id="allocOrdersSection" class="sd-card sd-focus-target" tabindex="-1">
                            <div class="sd-card-title">Orders Available for Allocation</div>
                            <div class="sd-card-body">
                                <div class="sd-grid">
                                    <div class="sd-field sd-col-4">
                                        <label>Allocate To</label><select id="allocType" class="form-control">
                                            <option value="Searcher">User</option>
                                            <option value="Vendor">Vendor</option>
                                            <option value="VM">VM</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-4">
                                        <label class="sd-required">Assignee</label><select id="allocUser" class="form-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-4">
                                        <button type="button" id="allocSubmit" class="sd-btn sd-btn-primary"><i class="fas fa-user-check mr-1"></i>Allocate selected orders</button>
                                    </div>
                                </div>
                                <div class="sd-card-body sd-table-wrap">
                                    <table id="allocOrdersTable" class="table table-bordered table-striped sd-table"></table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="sdQueue" class="tab-pane fade">
                        <div class="sd-card">
                            <div class="sd-card-title">User-InfinityOrderStatus</div>
                            <div class="sd-card-body sd-table-wrap">
                                <table id="queueTable" class="table table-bordered table-striped sd-table"></table>
                            </div>
                        </div>
                    </div>

                    <div id="sdProcess" class="tab-pane fade">
                        <div class="sd-card">
                            <div class="sd-card-title">Process Order</div>
                            <div class="sd-card-body">
                                <div class="sd-grid">
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Project</label><select id="pmProject" class="form-control sd-project"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Order</label><select id="pmOrder" class="form-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label>Current Process</label><input id="pmProcess" class="form-control" readonly /><input id="pmProcessId" type="hidden" />
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label>Assigned User</label><input id="pmAssignedUser" class="form-control" readonly /><input id="pmAssignedId" type="hidden" />
                                    </div>

                                    <div class="sd-field sd-col-6">
                                        <label>Task Remark</label><textarea id="pmRemark" class="form-control"></textarea>
                                    </div>
                                    <div class="sd-field sd-col-6">
                                        <label class="sd-required">Completion Attachment</label><input id="pmFile" type="file" class="form-control sd-file-control" /><div class="sd-help">File name (without extension) must match the client order number.</div>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label>Action</label><select id="pmAction" class="form-control"><option>Complete</option>
                                            <option>Hold</option>
                                            <option>Cancel</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label>Cancelled By</label><select id="pmCancelledBy" class="form-control" disabled><option>Cancelled by Client</option>
                                            <option>Cancelled by Infinity</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label>Cancel Reason</label><input id="pmCancelReason" class="form-control" disabled />
                                    </div>
                                    <br />
                                    <div class="sd-checks sd-col-12">
                                        <div class="checkbox-wrapper-24">
                                            <input id="pmDispatch" type="checkbox" /><label for="pmDispatch"><span></span>Dispatch</label>
                                        </div>
                                        <div class="checkbox-wrapper-24">
                                            <input id="pmNoFeedback" type="checkbox" /><label for="pmNoFeedback"><span></span>No Feedback</label>
                                        </div>
                                        <div class="checkbox-wrapper-24">
                                            <input id="pmTax" type="checkbox" /><label for="pmTax"><span></span>Tax Calling</label>
                                        </div>
                                        <div class="checkbox-wrapper-24">
                                            <input id="pmAudit" type="checkbox" /><label for="pmAudit"><span></span>Audit</label>
                                        </div>
                                        <div class="checkbox-wrapper-24">
                                            <input id="pmOffline" type="checkbox" /><label for="pmOffline"><span></span>Offline</label>
                                        </div>
                                    </div>
                                    <div class="sd-actions sd-col-12">
                                        <button type="button" id="pmComplete" class="sd-btn sd-btn-primary">Submit Process</button>
                                        <button type="button" id="pmViewDetails" class="sd-btn sd-btn-light">Order Details</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="sd-card">
                            <div class="sd-card-title">Process Tasks <span class="float-right font-weight-normal">Use Status to complete, hold, cancel or transfer an individual task</span></div>
                            <div class="sd-card-body sd-table-wrap">
                                <table id="pmTaskTable" class="table table-bordered table-striped sd-table"></table>
                            </div>
                        </div>
                    </div>
                    <div id="sdUpload" class="tab-pane fade">
                        <div class="sd-card">
                            <div class="sd-card-title">Upload And Download</div>
                            <div class="sd-card-body">
                                <div class="sd-grid">
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Date</label><input id="upDate" class="form-control" placeholder="dd-MMM-yyyy" />
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Project</label><select id="upProject" class="form-control sd-project"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Order</label><select id="upOrder" class="form-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-3">
                                        <label class="sd-required">Process</label><select id="upProcess" class="form-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-4">
                                        <label class="sd-required">Attachment</label><input id="upFile" type="file" class="form-control sd-file-control" /><div class="sd-help">The saved package is prefixed with RevisedPackage_.</div>
                                    </div>
                                    <div class="sd-field sd-col-2"></div>
                                    <div class="sd-field sd-col-2"></div>
                                    <div class="sd-field sd-col-4">
                                        <button type="button" id="upSubmit" class="sd-btn sd-btn-primary"><i class="fas fa-upload mr-1"></i>Upload</button>
                                        <button type="button" id="upLoad" class="sd-btn sd-btn-light">Load Documents</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="sd-card">
                            <div class="sd-card-title">Uploaded Documents</div>
                            <div class="sd-card-body sd-table-wrap">
                                <table id="upTable" class="table table-bordered table-striped sd-table"></table>
                            </div>
                        </div>
                    </div>

                    <div id="sdCosting" class="tab-pane fade">
                        <div class="sd-card">
                            <div class="sd-card-title">Production Costing Report</div>
                            <div class="sd-card-body">
                                <div class="sd-grid">
                                    <div class="sd-field sd-col-4">
                                        <label class="sd-required">Project</label><select id="costProject" class="form-control sd-project"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="sd-field sd-col-2">
                                        <label class="sd-required">From Date</label><input id="costFrom" class="form-control" placeholder="dd-MMM-yyyy" />
                                    </div>
                                    <div class="sd-field sd-col-2">
                                        <label class="sd-required">To Date</label><input id="costTo" class="form-control" placeholder="dd-MMM-yyyy" />
                                    </div>
                                    <div class="sd-actions sd-col-4">
                                        <button type="button" id="costShow" class="sd-btn sd-btn-primary">Show Report</button>
                                        <button type="button" id="costExport" class="sd-btn sd-btn-light"><i class="fas fa-file-excel mr-1"></i>Export Excel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="sd-card">
                            <div class="sd-card-title">Costing Orders</div>
                            <div class="sd-card-body sd-table-wrap cost-table-frame">
                                <table id="costTable" class="table table-bordered table-striped sd-table"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="pmStatusModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Task Status</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <input id="statusTaskId" type="hidden" /><input id="statusDocumentType" type="hidden" />
                    <div class="form-group">
                        <label>Status</label><select id="statusValue" class="form-control"><option value="">Select</option>
                            <option>Complete</option>
                            <option>Hold</option>
                            <option>Cancel</option>
                            <option>Transfer</option>
                        </select>
                    </div>
                    <div id="statusTransferBox" class="form-group" style="display: none">
                        <label>Transfer To</label><select id="statusCaller" class="form-control"><option value="">Select</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-dismiss="modal">Close</button>
                    <button type="button" id="statusSave" class="btn btn-success">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="pmDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Order Details</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body sd-table-wrap">
                    <table id="pmDetailsTable" class="table table-bordered table-striped sd-table"></table>
                </div>
            </div>
        </div>
    </div>

    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>
    <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
    <script src="../plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
    <script src="../plugins/jszip/jszip.min.js"></script>
    <script src="../plugins/datatables-buttons/js/buttons.html5.min.js"></script>
    <script src="../Scripts/Search/SearchDashboard.js?v=8"></script>
</asp:Content>
