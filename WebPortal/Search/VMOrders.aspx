<%@ Page Title="VM Orders" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="VMOrders.aspx.cs" Inherits="WebPortal.Search.VMOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" rel="stylesheet" />
    <style>
        :root {
            --vm-primary: #0f766e;
            --vm-primary-dark: #115e59;
            --vm-border: #dbe4ea;
            --vm-muted: #64748b;
            --vm-bg: #f4f6f8;
        }

        .vm-page {
            min-height: calc(100vh - 70px);
            background: var(--vm-bg);
            color: #1f2937;
        }

        .vm-shell {
            max-width: 1600px;
            margin: 0 auto;
        }

        .vm-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 15px 18px;
            margin-bottom: 12px;
            background: #fff;
            border: 1px solid var(--vm-border);
            border-left: 4px solid var(--vm-primary);
            border-radius: 8px;
        }

        .vm-title {
            margin: 0;
            font-size: 21px;
            font-weight: 700;
        }

        .vm-subtitle {
            margin-top: 3px;
            color: var(--vm-muted);
            font-size: 12px;
        }

        .vm-tabs {
            overflow: hidden;
            background: #fff;
            border: 1px solid var(--vm-border);
            border-radius: 8px;
        }

            .vm-tabs > .nav {
                gap: 2px;
                padding: 10px 10px 0;
                border-bottom: 1px solid var(--vm-border);
            }

                .vm-tabs > .nav .nav-link {
                    padding: 10px 16px;
                    color: #475569;
                    background: #eef2f6;
                    border: 0;
                    border-radius: 6px 6px 0 0;
                    font-weight: 700;
                }

                    .vm-tabs > .nav .nav-link.active {
                        color: #fff;
                        background: var(--vm-primary);
                    }

            .vm-tabs .tab-pane {
                padding: 14px;
            }

        .vm-card {
            margin-bottom: 12px;
            background: #fff;
            border: 1px solid var(--vm-border);
            border-radius: 8px;
        }

        .vm-card-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 10px 13px;
            color: #065f5b;
            border-bottom: 1px solid var(--vm-border);
            font-size: 13px;
            font-weight: 700;
        }

        .vm-card-body {
            padding: 13px;
        }

        .vm-grid {
            display: grid;
            grid-template-columns: repeat(12,minmax(0,1fr));
            gap: 11px;
            align-items: end;
        }

        .vm-col-2 {
            grid-column: span 2;
        }

        .vm-col-3 {
            grid-column: span 3;
        }

        .vm-col-4 {
            grid-column: span 4;
        }

        .vm-col-6 {
            grid-column: span 6;
        }

        .vm-col-8 {
            grid-column: span 8;
        }

        .vm-col-12 {
            grid-column: span 12;
        }

        .vm-field label {
            display: block;
            margin-bottom: 5px;
            color: #334155;
            font-size: 11px;
            font-weight: 700;
        }

        .vm-field .required:after {
            content: " *";
            color: #dc2626;
        }

        .vm-control {
            width: 100%;
            min-height: 38px;
            padding: 7px 10px;
            color: #1f2937;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
        }

            .vm-control:focus {
                border-color: var(--vm-primary);
                box-shadow: 0 0 0 3px rgba(15,118,110,.11);
                outline: 0;
            }

        textarea.vm-control {
            min-height: 76px;
            resize: vertical;
        }

        .vm-radio-row, .vm-check-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            min-height: 38px;
        }

            .vm-radio-row label, .vm-check-row label {
                margin: 0;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
            }

        .vm-radio-row {
            gap: 10px;
        }

            .vm-radio-row label {
                min-height: 38px;
                padding: 7px 13px 7px 9px;
                display: inline-flex;
                align-items: center;
                gap: 9px;
                font-weight: 700;
                line-height: 1.2;
                color: #334155;
                background: #ffffff;
                border: 1px solid #cbd5e1;
                border-radius: 20px;
                box-shadow: 0 2px 6px rgba(15, 23, 42, .06);
                user-select: none;
                transition: border-color .2s ease, background-color .2s ease, color .2s ease, box-shadow .2s ease, transform .2s ease;
            }

                .vm-radio-row label:hover {
                    color: #0f766e;
                    border-color: #5eead4;
                    background: #f0fdfa;
                    box-shadow: 0 4px 10px rgba(15, 118, 110, .12);
                    transform: translateY(-1px);
                }

                .vm-radio-row label:has(input[type="radio"]:checked) {
                    color: #0f766e;
                    border-color: #14b8a6;
                    background: #ecfdf5;
                    box-shadow: 0 0 0 3px rgba(20, 184, 166, .11), 0 4px 10px rgba(15, 118, 110, .10);
                }

            .vm-radio-row input[type="radio"] {
                appearance: none;
                -webkit-appearance: none;
                width: 20px;
                height: 20px;
                margin: 0;
                flex: 0 0 20px;
                display: inline-grid;
                place-content: center;
                background: #ffffff;
                border: 2px solid #94a3b8;
                border-radius: 50%;
                cursor: pointer;
                transition: border-color .2s ease, background-color .2s ease, box-shadow .2s ease;
            }

                .vm-radio-row input[type="radio"]::before {
                    content: "";
                    width: 10px;
                    height: 10px;
                    border-radius: 50%;
                    background: #ffffff;
                    transform: scale(0);
                    transition: transform .18s ease;
                }

                .vm-radio-row input[type="radio"]:checked {
                    background: #0f8578;
                    border-color: #0f8578;
                    box-shadow: 0 0 0 3px rgba(15, 133, 120, .14);
                }

                    .vm-radio-row input[type="radio"]:checked::before {
                        transform: scale(1);
                    }

                .vm-radio-row input[type="radio"]:focus-visible {
                    outline: 2px solid #2563eb;
                    outline-offset: 2px;
                }

                .vm-radio-row input[type="radio"]:disabled {
                    cursor: not-allowed;
                    opacity: .55;
                }

        .vm-check-row {
            gap: 8px;
        }

            .vm-check-row label,
            .vm-doc-list label {
                position: relative;
                min-height: 36px;
                margin: 0;
                padding: 7px 13px 7px 9px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #475569;
                background: rgba(255, 255, 255, .96);
                border: 1px solid #cbd5e1;
                border-radius: 20px;
                box-shadow: 0 2px 6px rgba(15, 23, 42, .06);
                font-weight: 700;
                line-height: 1.2;
                cursor: pointer;
                user-select: none;
                transition: border-color .2s ease, background-color .2s ease, color .2s ease, box-shadow .2s ease, transform .2s ease;
            }

                .vm-check-row label::before,
                .vm-doc-list label::before {
                    content: "+";
                    width: 18px;
                    height: 18px;
                    flex: 0 0 18px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    color: #0f8578;
                    background: #ecfdf5;
                    border: 1px solid #99f6e4;
                    border-radius: 50%;
                    font-size: 14px;
                    font-weight: 800;
                    line-height: 1;
                    transition: color .2s ease, background-color .2s ease, border-color .2s ease, transform .3s ease;
                }

                .vm-check-row label:hover,
                .vm-doc-list label:hover {
                    color: #0f766e;
                    border-color: #5eead4;
                    background: #f0fdfa;
                    box-shadow: 0 4px 10px rgba(15, 118, 110, .12);
                    transform: translateY(-1px);
                }

                .vm-check-row label:has(input[type="checkbox"]:checked),
                .vm-doc-list label:has(input[type="checkbox"]:checked) {
                    color: #ffffff;
                    border-color: #0f8578;
                    background: #0f8578;
                    box-shadow: 0 0 0 3px rgba(15, 133, 120, .13), 0 4px 10px rgba(15, 118, 110, .15);
                }

                    .vm-check-row label:has(input[type="checkbox"]:checked)::before,
                    .vm-doc-list label:has(input[type="checkbox"]:checked)::before {
                        content: "\2713";
                        color: #0f8578;
                        background: #ffffff;
                        border-color: #ffffff;
                        transform: rotate(-360deg);
                    }

                .vm-check-row label:has(input[type="checkbox"]:focus-visible),
                .vm-doc-list label:has(input[type="checkbox"]:focus-visible) {
                    outline: 2px solid #2563eb;
                    outline-offset: 2px;
                }

                .vm-check-row label:has(input[type="checkbox"]:disabled),
                .vm-doc-list label:has(input[type="checkbox"]:disabled) {
                    cursor: not-allowed;
                    opacity: .55;
                    transform: none;
                }

            .vm-check-row input[type="checkbox"],
            .vm-doc-list input[type="checkbox"] {
                position: absolute;
                width: 1px;
                height: 1px;
                margin: 0;
                opacity: 0;
                pointer-events: none;
            }

        .vm-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-height: 36px;
            padding: 7px 13px;
            border: 1px solid transparent;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .vm-btn-primary {
            color: #fff;
            background: var(--vm-primary);
        }

            .vm-btn-primary:hover {
                color: #fff;
                background: var(--vm-primary-dark);
            }

        .vm-btn-light {
            color: #334155;
            background: #f8fafc;
            border-color: #d5dee7;
        }

        .vm-btn-success {
            color: #fff;
            background: #15803d;
        }

        .vm-btn-danger {
            color: #fff;
            background: #b91c1c;
        }

        .vm-btn-xs {
            min-height: 29px;
            padding: 4px 8px;
        }

        .vm-actions {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            flex-wrap: nowrap;
            white-space: nowrap;
        }

            .vm-actions .vm-btn {
                /* width: 30px;*/
                min-width: 30px;
                padding: 4px;
            }

        #vmQueueTable thead th:first-child, #vmQueueTable tbody td:first-child {
            width: 112px !important;
            min-width: 112px !important;
            max-width: 112px;
        }

        .vm-action-process {
            color: #1d4ed8;
            background: #dbeafe;
            border-color: #93c5fd;
        }

        .vm-action-status {
            color: #7e22ce;
            background: #f3e8ff;
            border-color: #d8b4fe;
        }

        .vm-action-comments {
            color: #0f766e;
            background: #ccfbf1;
            border-color: #5eead4;
        }

        .vm-actions .vm-btn:hover, .vm-actions .vm-btn:focus {
            color: #fff;
            filter: brightness(.84);
        }

        .vm-summary {
            display: grid;
            grid-template-columns: repeat(4,minmax(0,1fr));
            gap: 8px;
        }

        .vm-summary-item {
            padding: 9px 11px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 7px;
        }

        .vm-summary-label {
            color: #64748b;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .vm-summary-value {
            margin-top: 3px;
            color: #0f172a;
            font-size: 12px;
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .vm-mode-panel {
            margin-top: 12px;
            padding: 12px;
            background: #fbfcfd;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
        }

        .vm-doc-list {
            display: grid;
            grid-template-columns: repeat(2,minmax(0,1fr));
            gap: 7px 12px;
            max-height: 170px;
            overflow: auto;
            padding: 8px;
            background: #fff;
            border: 1px solid #d8e1e9;
            border-radius: 7px;
        }

            .vm-doc-list label {
                margin: 0;
                font-size: 11px;
                font-weight: 600;
            }

        .vm-file {
            padding: 5px;
            border: 1px dashed #94a3b8;
            border-radius: 7px;
            background: #fff;
        }

        .vm-field label.vm-import-upload {
            position: relative;
            display: flex;
            flex-direction: row;
            align-items: center;
            width: 100%;
            min-height: 54px;
            margin: 0;
            padding: 8px 12px;
            border: 1px dashed #74b8ae;
            border-radius: 10px;
            background: linear-gradient(135deg, #f0fdfa 0%, #ffffff 72%);
            cursor: pointer;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

            .vm-field label.vm-import-upload:hover,
            .vm-field label.vm-import-upload:focus-within {
                border-color: #0f8a7c;
                box-shadow: 0 5px 16px rgba(15, 138, 124, .13);
                transform: translateY(-1px);
            }

            .vm-field label.vm-import-upload.is-selected {
                border-style: solid;
                border-color: #0f8a7c;
                background: #ecfdf8;
            }

        .vm-import-file-input {
            position: absolute;
            width: 1px;
            height: 1px;
            opacity: 0;
            overflow: hidden;
        }

        .vm-import-upload-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 38px;
            width: 38px;
            height: 38px;
            margin-right: 10px;
            border-radius: 9px;
            color: #fff;
            background: linear-gradient(135deg, #0f8a7c, #22b8a7);
            box-shadow: 0 5px 12px rgba(15, 138, 124, .22);
            font-size: 16px;
        }

        .vm-import-upload-copy {
            display: block;
            flex: 1 1 auto;
            min-width: 0;
            line-height: 1.25;
        }

        .vm-import-file-name {
            display: block;
            overflow: hidden;
            color: #163f4a;
            font-size: 12px;
            font-weight: 700;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .vm-import-file-hint {
            display: block;
            margin-top: 3px;
            color: #6b7f89;
            font-size: 10px;
            font-weight: 500;
        }

        .vm-import-browse {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex: 0 0 auto;
            margin-left: auto;
            padding: 7px 11px;
            border: 1px solid #b9dcd6;
            border-radius: 7px;
            color: #0f766e;
            background: #fff;
            font-size: 10px;
            font-weight: 700;
        }

        .vm-import-action .vm-btn {
            min-height: 54px;
            justify-content: center;
            border-radius: 9px;
        }

        .vm-col-3 .vm-file-upload .vm-import-browse,
        .vm-col-3 .vm-file-upload .vm-import-file-hint {
            display: none;
        }

        .vm-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .vm-table {
            width: 100% !important;
            margin: 0 !important;
            font-size: 11px;
        }

            .vm-table thead th {
                color: #0f3d56;
                background: #e8f2f7;
                border-bottom: 2px solid #58a0c4 !important;
                white-space: nowrap;
            }

            .vm-table tbody td {
                vertical-align: middle;
                white-space: nowrap;
            }

        .vm-row-hold td {
            background: #fff4bf !important;
        }

        .vm-row-cancel td {
            background: #f8d3d3 !important;
        }

        .vm-row-purple td {
            color: #7e22ce;
        }

        .vm-remark {
            color: #3b82b6;
            font-weight: 600;
        }

        .vm-process-link.disabled {
            color: #94a3b8;
            pointer-events: none;
            text-decoration: none;
        }

        .vm-record-count {
            padding: 4px 10px;
            color: #03695f;
            background: #e8f7f4;
            border: 1px solid #c6e9e3;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .vm-empty {
            padding: 22px;
            color: #64748b;
            text-align: center;
        }

        .vm-modal-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 11px;
        }

            .vm-modal-table th, .vm-modal-table td {
                padding: 7px;
                border: 1px solid #dce4eb;
                white-space: nowrap;
            }

            .vm-modal-table th {
                color: #334155;
                background: #edf3f7;
            }

        .vm-comment-summary {
            padding: 12px;
            background: #f8fafc;
            border: 1px solid #dce6ee;
            border-radius: 8px;
        }

        .vm-comment-form {
            margin-top: 12px;
            padding: 12px;
            background: #fff;
            border: 1px solid #dce6ee;
            border-radius: 8px;
        }

        .vm-comment-actions {
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }

        .vm-comment-history {
            margin-top: 12px;
            border: 1px solid #dce6ee;
            border-radius: 8px;
            overflow: auto;
        }

            .vm-comment-history .vm-modal-table th {
                color: #0f4c5c;
                background: #e6f4f6;
                border-bottom: 2px solid #25a6b8;
            }

            .vm-comment-history .vm-modal-table td {
                white-space: normal;
            }

        .vm-comment-history-empty {
            padding: 18px !important;
            color: #64748b;
            text-align: center;
        }

        #vmLoader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 2147483647;
            align-items: center;
            justify-content: center;
            background: rgba(248,250,252,.76);
            backdrop-filter: blur(2px);
        }

            #vmLoader.active {
                display: flex;
            }

        .vm-spinner {
            width: 52px;
            height: 52px;
            border: 5px solid #dbe7e5;
            border-top-color: var(--vm-primary);
            border-radius: 50%;
            animation: vmSpin .75s linear infinite;
        }

        .vm-loader-card {
            min-width: 310px;
            padding: 24px 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
            color: #0f172a;
            background: #ffffff;
            border: 1px solid #dbe4ea;
            border-radius: 14px;
            box-shadow: 0 18px 45px rgba(15,23,42,.16);
            text-align: center;
        }

        .vm-loader-message {
            max-width: 300px;
            font-size: 14px;
            font-weight: 700;
            line-height: 1.45;
        }

        .vm-loader-note {
            color: #64748b;
            font-size: 11px;
        }

        @keyframes vmSpin {
            to {
                transform: rotate(360deg);
            }
        }

        .dataTables_wrapper .dataTables_filter input, .dataTables_wrapper .dataTables_length select {
            border: 1px solid #cbd5e1;
            border-radius: 7px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0 !important;
            border: 0 !important;
        }

        @media(max-width:992px) {
            .vm-col-2, .vm-col-3, .vm-col-4, .vm-col-6 {
                grid-column: span 6;
            }

            .vm-summary {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }
        }

        @media(max-width:576px) {
            .vm-col-2, .vm-col-3, .vm-col-4, .vm-col-6 {
                grid-column: span 12;
            }

            .vm-summary {
                grid-template-columns: 1fr;
            }

            .vm-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="vmLoader">
        <div class="vm-loader-card" role="status" aria-live="polite">
            <div class="vm-spinner"></div>
            <div id="vmLoaderMessage" class="vm-loader-message">Please wait while your request is being processed...</div>
            <div class="vm-loader-note">Please do not close or refresh this page.</div>
        </div>
    </div>
    <main class="vm-page">
        <div class="vm-shell">
            <header class="vm-header search-modern-header">
                <div class="search-header-identity">
                    <span class="search-header-icon"><i class="fas fa-boxes"></i></span>
                    <div class="search-header-copy">
                        <h1 class="vm-title"><span>VM Orders</span></h1>
                        <div class="vm-subtitle">Abstractor allocation, VM processing and queue management in one workspace</div>
                    </div>
                </div>
                <button type="button" id="vmRefreshActive" class="vm-btn vm-btn-light"><i class="fas fa-sync-alt"></i>Refresh active tab</button>
            </header>

            <section class="vm-tabs">
                <ul class="nav nav-tabs" id="vmMainTabs" role="tablist">
                    <li class="nav-item"><a class="nav-link active" id="vmAllocationTab" data-toggle="tab" href="#vmAllocationPane" role="tab"><i class="fas fa-user-check mr-1"></i>Order Allocation</a></li>
                    <li class="nav-item"><a class="nav-link" id="vmQueueTab" data-toggle="tab" href="#vmQueuePane" role="tab"><i class="fas fa-list-alt mr-1"></i>Order Queue</a></li>
                </ul>
                <div class="tab-content">
                    <section class="tab-pane fade show active" id="vmAllocationPane" role="tabpanel">
                        <div id="vmAllocationList">
                            <div class="vm-card">
                                <div class="vm-card-title">
                                    <span>Orders Available for VM Allocation</span><div class="vm-actions">
                                        <button type="button" id="vmOpenImport" class="vm-btn vm-btn-success"><i class="fas fa-file-import"></i>Bulk Import</button><span id="vmAllocationCount" class="vm-record-count">0 records</span>
                                    </div>
                                </div>
                                <div class="vm-card-body vm-table-wrap">
                                    <table id="vmAllocationTable" class="table table-striped table-hover vm-table">
                                        <thead>
                                            <tr></tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div id="vmAllocationEditor" style="display: none">
                            <div class="vm-card">
                                <div class="vm-card-title">
                                    <span>Selected Order</span>
                                    <button type="button" id="vmBackToAllocation" class="vm-btn vm-btn-light vm-btn-xs"><i class="fas fa-arrow-left"></i>Back to orders</button>
                                </div>
                                <div class="vm-card-body">
                                    <div id="vmOrderSummary" class="vm-summary"></div>
                                </div>
                            </div>
                            <div class="vm-card">
                                <div class="vm-card-title">
                                    <span>Assign To Abstractor</span>
                                    <button type="button" id="vmViewCoverage" class="vm-btn vm-btn-light vm-btn-xs"><i class="fas fa-map-marked-alt"></i>Abstractor coverage</button>
                                </div>
                                <div class="vm-card-body">
                                    <div class="vm-field">
                                        <label>Allocation Mode</label><div class="vm-radio-row">
                                            <label>
                                                <input type="radio" name="vmAllocationMode" value="Offline" checked />
                                                Full Offline</label><label><input type="radio" name="vmAllocationMode" value="Partial" />
                                                    Partial</label>
                                        </div>
                                    </div>
                                    <div id="vmFullOfflinePanel" class="vm-mode-panel">
                                        <div class="vm-grid">
                                            <div class="vm-col-4 vm-field">
                                                <label class="required">Company Name</label><select id="vmFullAbstractor" class="vm-control"><option value="">Select</option>
                                                </select>
                                            </div>
                                            <div class="vm-col-2 vm-field">
                                                <label>ETA (Hours)</label><input id="vmFullEta" class="vm-control vm-number" inputmode="numeric" />
                                            </div>
                                            <div class="vm-col-3 vm-field">
                                                <label>Delivery Method</label><div class="vm-radio-row">
                                                    <label>
                                                        <input type="radio" name="vmDeliveryMethod" value="Email" />
                                                        Email</label><label><input type="radio" name="vmDeliveryMethod" value="Fax" />
                                                            Fax</label>
                                                </div>
                                            </div>
                                            <div class="vm-col-3 vm-field">
                                                <label>Attachment</label><input id="vmFullAttachment" type="file" class="vm-file" />
                                            </div>
                                            <div class="vm-col-12 vm-field">
                                                <label>Product Type</label><div class="vm-check-row">
                                                    <label>
                                                        <input type="checkbox" value="Current Owner" /><b>Current Owner</b></label>
                                                    <label>
                                                        <input type="checkbox" value="Two Owner" /><b>Two Owner</b></label>
                                                    <label>
                                                        <input type="checkbox" value="L&V" /><b>L&V</b></label>
                                                    <label>
                                                        <input type="checkbox" value="Full Search" /><b>Full Search</b></label>
                                                    <label>
                                                        <input type="checkbox" value="Document Request" /><b>Document Request</b></label>
                                                    <label>
                                                        <input type="checkbox" value="Other" /><b>Other</b></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="vmPartialPanel" class="vm-mode-panel" style="display: none">
                                        <div class="vm-grid">
                                            <div class="vm-col-4">
                                                <div class="vm-field">
                                                    <label class="required">Searcher 1</label><select id="vmPartialAbstractor1" class="vm-control"><option value="">Select</option>
                                                    </select>
                                                </div>
                                                <div class="vm-field mt-2">
                                                    <label>ETA (Hours)</label><input id="vmPartialEta1" class="vm-control vm-number" />
                                                </div>
                                                <div id="vmPartialDocs1" class="vm-doc-list mt-2"></div>
                                            </div>
                                            <div class="vm-col-4">
                                                <div class="vm-field">
                                                    <label class="required">Searcher 2</label><select id="vmPartialAbstractor2" class="vm-control"><option value="">Select</option>
                                                    </select>
                                                </div>
                                                <div class="vm-field mt-2">
                                                    <label>ETA (Hours)</label><input id="vmPartialEta2" class="vm-control vm-number" />
                                                </div>
                                                <div id="vmPartialDocs2" class="vm-doc-list mt-2"></div>
                                            </div>
                                            <div class="vm-col-4">
                                                <div class="vm-field">
                                                    <label>Return to PM</label><input class="vm-control" value="VM / PM" readonly />
                                                </div>
                                                <div class="vm-field mt-2">
                                                    <label>Attachment</label><input id="vmPartialAttachment" type="file" class="vm-file" />
                                                </div>
                                                <div id="vmPartialDocs3" class="vm-doc-list mt-2"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="vm-mode-panel">
                                        <div class="vm-grid">
                                            <div class="vm-col-3 vm-field">
                                                <label>Search Cost</label><input id="vmSearchCost" class="vm-control vm-money" value="0.00" />
                                            </div>
                                            <div class="vm-col-3 vm-field">
                                                <label>Copy Cost</label><input id="vmCopyCost" class="vm-control vm-money" value="0.00" />
                                            </div>
                                            <div class="vm-col-3 vm-field">
                                                <label>Total</label><input id="vmTotalCost" class="vm-control" value="0.00" readonly />
                                            </div>
                                            <div class="vm-col-3">
                                                <button type="button" id="vmAllocateOrder" class="vm-btn vm-btn-primary w-100"><i class="fas fa-user-check"></i>Allocate</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="tab-pane fade" id="vmQueuePane" role="tabpanel">
                        <div class="vm-card">
                            <div class="vm-card-title">Queue Filters</div>
                            <div class="vm-card-body">
                                <div class="vm-grid">
                                    <div class="vm-col-2 vm-field">
                                        <label class="required">From Date</label><input id="vmQueueFromDate" type="date" class="vm-control" />
                                    </div>
                                    <div class="vm-col-2 vm-field">
                                        <label class="required">To Date</label><input id="vmQueueToDate" type="date" class="vm-control" />
                                    </div>
                                    <div class="vm-col-2 vm-field">
                                        <label>Project</label><select id="vmQueueProject" class="vm-control"><option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="vm-col-4 vm-field">
                                        <label>Order View</label><div class="vm-radio-row">
                                            <label id="vmAllOrdersOption">
                                                <input type="radio" name="vmQueueView" value="all" />
                                                All Orders</label><label><input type="radio" name="vmQueueView" value="mine" checked />
                                                    My Orders</label><label id="vmAllProjectsOption"><input type="radio" name="vmQueueView" value="allProjects" />
                                                        All Projects</label>
                                        </div>
                                    </div>

                                    <div class="vm-col-2">
                                        <button type="button" id="vmShowQueue" class="vm-btn vm-btn-primary w-100"><i class="fas fa-search"></i>Show Orders</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="vm-card">
                            <div class="vm-card-title">
                                <span>VM Order Queue</span><div class="vm-actions">
                                    <button type="button" id="vmExportQueue" class="vm-btn vm-btn-success vm-btn-xs"><i class="fas fa-file-excel"></i>Export Excel</button><span id="vmQueueCount" class="vm-record-count">0 records</span>
                                </div>
                            </div>
                            <div class="vm-card-body vm-table-wrap">
                                <table id="vmQueueTable" class="table table-striped table-hover vm-table">
                                    <thead>
                                        <tr></tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="vmCoverageModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Abstractor Coverage</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body vm-table-wrap">
                    <table id="vmCoverageTable" class="table table-striped table-bordered vm-table">
                        <thead>
                            <tr></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmImportModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Import Bulk VM Orders</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="vm-grid">
                        <div class="vm-col-6 vm-field">
                            <label class="required">Excel File</label>
                            <label id="vmImportUpload" class="vm-import-upload" for="vmImportFile" tabindex="0">
                                <input id="vmImportFile" type="file" accept=".xls,.xlsx" class="vm-import-file-input" />
                                <span class="vm-import-upload-icon"><i class="fas fa-file-excel"></i></span>
                                <span class="vm-import-upload-copy">
                                    <span id="vmImportFileName" class="vm-import-file-name">Choose an Excel file</span>
                                    <span class="vm-import-file-hint">Supported formats: .xls and .xlsx</span>
                                </span>
                                <span class="vm-import-browse">Browse</span>
                            </label>
                        </div>
                        <div class="vm-col-3 vm-import-action">
                            <button type="button" id="vmImportOrders" class="vm-btn vm-btn-primary w-100"><i class="fas fa-upload"></i>Import Excel</button>
                        </div>
                        <div class="vm-col-3 vm-import-action"><a href="../VMExcel.xlsx" class="vm-btn vm-btn-light w-100"><i class="fas fa-download"></i>Download Format</a></div>
                    </div>
                    <div id="vmImportMessage" class="mt-3"></div>
                    <div class="vm-table-wrap mt-3">
                        <table id="vmImportResultTable" class="table table-bordered vm-table">
                            <thead>
                                <tr></tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmDetailModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="vmDetailTitle" class="modal-title">Order Details</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div id="vmDetailContent" class="modal-body vm-table-wrap"></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmCommentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-comment-dots mr-2"></i>FollowUp</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <input id="vmCommentOrderId" type="hidden" />
                    <div class="vm-comment-summary">
                        <div class="vm-grid">
                            <div class="vm-col-3 vm-field">
                                <label>Order #</label><input id="vmCommentOrderNo" class="vm-control" readonly />
                            </div>
                            <div class="vm-col-3 vm-field">
                                <label>Order Date</label><input id="vmCommentOrderDate" class="vm-control" readonly />
                            </div>
                            <div class="vm-col-3 vm-field">
                                <label>VM</label><input id="vmCommentVm" class="vm-control" readonly />
                            </div>
                            <div class="vm-col-3 vm-field">
                                <label>Abstractor</label><input id="vmCommentAbstractor" class="vm-control" readonly />
                            </div>
                        </div>
                    </div>
                    <div class="vm-comment-form">
                        <div class="vm-grid">
                            <div class="vm-col-4 vm-field">
                                <label class="required">Type</label>
                                <select id="vmCommentType" class="vm-control">
                                    <option value="Select">Select</option>
                                    <option value="Connect With Abstractor">Connect With Abstractor</option>
                                    <option value="Disconnect With Abstractor">Disconnect With Abstractor</option>
                                </select>
                            </div>
                            <div class="vm-col-8 vm-field">
                                <label class="required">Remark</label><textarea id="vmCommentText" class="vm-control" maxlength="40000"></textarea>
                            </div>
                            <div class="vm-col-12 vm-comment-actions" style="text-align: right !important;">
                                <button id="vmSaveComment" type="button" class="vm-btn vm-btn-primary"><i class="fas fa-paper-plane"></i>Submit</button>
                            </div>
                        </div>
                    </div>
                    <div id="vmCommentRecordCount" class="text-muted mb-2"></div>
                    <div id="vmCommentsContent" class="vm-comment-history"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmOrderProcessModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Process Order</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="vm-grid">
                        <div class="vm-col-4 vm-field">
                            <label>TaskId</label><input id="vmOrderProcessTaskId" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>Project #</label><input id="vmOrderProcessProject" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>Client Order #</label><input id="vmOrderProcessOrderNo" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>Order Date</label><input id="vmOrderProcessDate" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>Process</label><input id="vmOrderProcessName" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>VM</label><input id="vmOrderProcessVm" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-12 vm-field">
                            <label>Abstractor</label><input id="vmOrderProcessAbstractor" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-12 vm-field">
                            <label class="required">Attachment</label><input id="vmOrderProcessFile" type="file" class="vm-file w-100" />
                        </div>
                        <div class="vm-col-12 vm-field">
                            <label class="required">Remark</label><textarea id="vmOrderProcessRemark" class="vm-control" maxlength="4000"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="vmCompleteOrder" class="vm-btn vm-btn-primary"><i class="fas fa-check"></i>Complete Process</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmOrderStatusModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Status</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="vm-grid">
                        <div class="vm-col-2 vm-field">
                            <label>TaskId</label><input id="vmOrderStatusTaskId" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-2 vm-field">
                            <label>Project #</label><input id="vmOrderStatusProject" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>Order #</label><input id="vmOrderStatusOrderNo" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-4 vm-field">
                            <label>OrderDate</label><input id="vmOrderStatusDate" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-12 vm-field">
                            <label>Abstractor</label><input id="vmOrderStatusAbstractor" class="vm-control" readonly />
                        </div>
                        <div class="vm-col-6 vm-field">
                            <label class="required">Select</label><select id="vmOrderStatusAction" class="vm-control"><option value="Re-Allocate">Re-Allocate</option>
                                <option value="Multi-Allocate">Multi-Allocate</option>
                            </select>
                        </div>
                        <div class="vm-col-6 vm-field">
                            <label class="required">Reallocate To</label><select id="vmOrderStatusVendor" class="vm-control"><option value="">Select</option>
                            </select>
                        </div>
                        <div class="vm-col-12 vm-field">
                            <label class="required">Remark</label><textarea id="vmOrderStatusRemark" class="vm-control" maxlength="4000"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="vmAllocateStatusOrder" class="vm-btn vm-btn-primary"><i class="fas fa-user-check"></i>Allocate Order</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmProcessModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Process VM Order</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <input id="vmProcessOrderId" type="hidden" /><input id="vmProcessId" type="hidden" /><input id="vmProcessAssignedId" type="hidden" /><div id="vmProcessSummary" class="vm-summary mb-3"></div>
                    <div id="vmProcessTasks" class="vm-table-wrap mb-3"></div>
                    <div class="vm-grid">
                        <div class="vm-col-3 vm-field">
                            <label class="required">Action</label><select id="vmProcessAction" class="vm-control"><option>Complete</option>
                                <option>Hold</option>
                                <option>Cancel</option>
                            </select>
                        </div>
                        <div class="vm-col-3 vm-field">
                            <label>Completion Attachment</label><input id="vmProcessFile" type="file" class="vm-file w-100" />
                        </div>
                        <div class="vm-col-6 vm-field">
                            <label>Remark</label><textarea id="vmProcessRemark" class="vm-control"></textarea>
                        </div>
                        <div id="vmCancelFields" class="vm-col-12" style="display: none">
                            <div class="vm-grid">
                                <div class="vm-col-4 vm-field">
                                    <label class="required">Cancelled By</label><input id="vmCancelledBy" class="vm-control" />
                                </div>
                                <div class="vm-col-8 vm-field">
                                    <label class="required">Cancel Reason</label><input id="vmCancelReason" class="vm-control" />
                                </div>
                            </div>
                        </div>
                        <div class="vm-col-12 vm-check-row">
                            <label>
                                <input id="vmTaxCalling" type="checkbox" />
                                Tax Calling</label><label><input id="vmAudit" type="checkbox" />
                                    Audit</label><label><input id="vmOffline" type="checkbox" />
                                        Offline</label><label><input id="vmDispatch" type="checkbox" />
                                            Dispatch</label><label><input id="vmNoFeedback" type="checkbox" />
                                                No Feedback</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="vm-btn vm-btn-light" data-dismiss="modal">Close</button>
                    <button type="button" id="vmSubmitProcess" class="vm-btn vm-btn-primary"><i class="fas fa-check"></i>Submit Process</button>
                </div>
            </div>
        </div>
    </div>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Search/VmOrders.js?v=11"></script>
</asp:Content>
