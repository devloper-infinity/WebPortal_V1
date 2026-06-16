<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="OrderAllocation.aspx.cs" Inherits="WebPortal.Search.OrderAllocation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --alloc-bg: #f4f6f8;
            --alloc-surface: #ffffff;
            --alloc-border: #d9e1e8;
            --alloc-soft: #eef2f5;
            --alloc-text: #1f2937;
            --alloc-muted: #667085;
            --alloc-primary: #0f766e;
            --alloc-primary-dark: #115e59;
            --alloc-accent: #2563eb;
            --alloc-success: #16a34a;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .72);
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
            color: var(--alloc-text);
            font-size: 12px;
            font-weight: 700;
        }

        .allocation-page {
            min-height: calc(100vh - 72px);
            padding: 18px;
            background: var(--alloc-bg);
        }

        .allocation-header,
        .allocation-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .allocation-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 14px;
            padding: 14px 18px;
            background: var(--alloc-surface);
            border: 1px solid var(--alloc-border);
            border-left: 4px solid var(--alloc-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .allocation-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--alloc-text);
            font-size: 22px;
            font-weight: 700;
        }

        .allocation-title i {
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: var(--alloc-primary);
            border-radius: 8px;
            font-size: 15px;
        }

        .allocation-context {
            margin-top: 2px;
            color: var(--alloc-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .allocation-shell {
            background: var(--alloc-surface);
            border: 1px solid var(--alloc-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .allocation-filter-panel {
            padding: 16px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--alloc-soft);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .allocation-field {
            margin-bottom: 0;
        }

        .allocation-field label {
            display: block;
            margin-bottom: 5px;
            color: var(--alloc-text);
            font-size: 12px;
            font-weight: 700 !important;
            line-height: 1.25;
            border: 0 !important;
        }

        .allocation-field .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            color: var(--alloc-text);
            font-size: 13px;
            box-shadow: none;
        }

        .allocation-field .form-control:focus {
            border-color: var(--alloc-primary);
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .allocation-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-allocation-primary,
        .btn-allocation-secondary,
        .btn-allocation-success {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            border-radius: 7px;
            font-weight: 700;
        }

        .btn-allocation-primary {
            color: #ffffff;
            background: var(--alloc-primary);
            border-color: var(--alloc-primary);
        }

        .btn-allocation-primary:hover,
        .btn-allocation-primary:focus {
            color: #ffffff;
            background: var(--alloc-primary-dark);
            border-color: var(--alloc-primary-dark);
        }

        .btn-allocation-secondary {
            color: var(--alloc-text);
            background: #ffffff;
            border-color: var(--alloc-border);
        }

        .btn-allocation-secondary:hover,
        .btn-allocation-secondary:focus {
            color: var(--alloc-primary-dark);
            background: #edf7f5;
            border-color: #b7d9d4;
        }

        .btn-allocation-success {
            color: #ffffff;
            background: var(--alloc-success);
            border-color: var(--alloc-success);
        }

        .allocation-grid-panel {
            padding: 16px;
        }

        .grid-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
        }

        .grid-panel-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: var(--alloc-text);
            font-size: 15px;
            font-weight: 700;
        }

        .grid-panel-header h2 i {
            color: var(--alloc-accent);
        }

        .grid-subtitle {
            margin: 0;
            color: var(--alloc-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .allocation-table-frame {
            border: 1px solid var(--alloc-soft);
            border-radius: 8px;
            overflow: hidden;
            background: #ffffff;
        }

        .allocation-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        .allocation-table,
        #table_OrderAllocation,
        #table_viewloanDetails {
            width: 100% !important;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        .allocation-table thead th,
        #table_OrderAllocation thead th,
        #table_viewloanDetails thead th {
            color: var(--alloc-text);
            background: #f3f6f9 !important;
            background-image: none !important;
            border-bottom: 1px solid var(--alloc-border) !important;
            font-size: 12px;
            font-weight: 700;
            text-align: left;
            white-space: nowrap;
            vertical-align: middle;
        }

        .allocation-table tbody td,
        #table_OrderAllocation tbody td,
        #table_viewloanDetails tbody td {
            color: var(--alloc-text);
            background: #ffffff !important;
            font-size: 12px;
            vertical-align: middle;
        }

        .allocation-table tbody tr:hover td,
        #table_OrderAllocation tbody tr:hover td,
        #table_viewloanDetails tbody tr:hover td {
            background: #f8fbfb !important;
        }

        #table_viewloanDetails tbody tr.selected-row td {
            background: #dff3ef !important;
            color: var(--alloc-primary-dark);
            font-weight: 700;
        }

        .allocation-count-pill {
            display: inline-flex;
            min-width: 34px;
            justify-content: center;
            padding: 4px 10px;
            color: #1d4ed8;
            background: #dbeafe;
            border-radius: 999px;
            font-weight: 800;
        }

        .allocation-icon-btn {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            border-radius: 7px;
        }

        .text-wrap-cell {
            min-width: 240px;
            max-width: 340px;
            white-space: normal;
        }

        .dataTables_wrapper .allocation-toolbar {
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

        .dataTables_wrapper .dataTables_filter label {
            color: var(--alloc-muted);
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
            color: var(--alloc-muted);
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
            background: var(--alloc-accent) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            box-shadow: none !important;
        }

        .custom-modal .modal-content {
            border: 0;
            border-radius: 8px;
            box-shadow: 0 18px 45px rgba(31, 41, 55, .18);
            overflow: hidden;
        }

        .custom-modal .modal-header {
            align-items: center;
            padding: 14px 18px;
            color: #ffffff;
            background: var(--alloc-primary);
            border-bottom: 0;
        }

        .custom-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: #ffffff;
            font-size: 17px;
            font-weight: 700;
        }

        .custom-modal .close {
            color: #ffffff;
            opacity: 1;
            text-shadow: none;
        }

        .custom-modal .modal-body {
            padding: 14px;
            background: #fbfcfd;
        }

        .custom-modal .modal-footer {
            border-top: 1px solid var(--alloc-soft);
        }

        .order-checkbox {
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        #waitingpanel .modal-dialog {
            padding-top: 140px;
        }

        @media (max-width: 991px) {
            .filter-grid {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }
        }

        @media (max-width: 767px) {
            .allocation-page {
                padding: 12px;
            }

            .allocation-header,
            .grid-panel-header,
            .allocation-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .allocation-title {
                font-size: 19px;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }

            .allocation-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            if (typeof OrderAllocation_InitPage === "function") {
                OrderAllocation_InitPage();
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="allocation-page">
        <div class="loading" id="load1">
            <div>
                <img src="../images/Load_1.gif" alt="Loading" />
                <div>One moment, please . . . .</div>
            </div>
        </div>

        <div class="allocation-header">
            <div>
                <h1 class="allocation-title"><i class="fas fa-tasks"></i><span>Order Allocation</span></h1>
                <div class="allocation-context">Search Operations</div>
            </div>
        </div>

        <div class="allocation-shell">
            <div class="allocation-filter-panel">
                <div class="filter-grid">
                    <div class="form-group allocation-field">
                        <label for="OrdreAllocation_projectno">Project</label>
                        <select id="OrdreAllocation_projectno" name="OrdreAllocation_projectno" onchange="return orderAllocation_BindProcess(this)" class="form-control"></select>
                    </div>
                    <div class="form-group allocation-field">
                        <label for="OrdreAllocation_process">Process</label>
                        <select id="OrdreAllocation_process" name="OrdreAllocation_process" onchange="return orderAllocationSummary(this)" class="form-control"></select>
                    </div>
                    <div class="form-group allocation-field">
                        <label for="OrdreAllocation_Date">Date</label>
                        <input type="text" id="OrdreAllocation_Date" name="OrdreAllocation_Date" class="form-control" readonly="readonly" />
                    </div>
                    <div class="allocation-actions">
                        <button type="button" id="OrdreAllocation_btnRefresh" class="btn btn-allocation-primary" onclick="return orderAllocationSummary();">
                            <i class="fas fa-sync-alt"></i><span>Refresh</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="allocation-grid-panel">
                <div class="grid-panel-header">
                    <div>
                        <h2><i class="fas fa-table"></i><span>Allocation Summary</span></h2>
                        <p class="grid-subtitle">Grouped by order date, project, and product type</p>
                    </div>
                </div>
                <div class="allocation-table-frame">
                    <div class="allocation-table-wrap">
                        <table class="table table-hover table-sm allocation-table" id="table_OrderAllocation">
                            <thead>
                                <tr>
                                    <th>Actions</th>
                                    <th>Sr. #</th>
                                    <th>Order Date</th>
                                    <th>Project #</th>
                                    <th>Product Type</th>
                                    <th>Count</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade custom-modal" id="popUpViewLoanDetails" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title">
                            <i class="fas fa-list"></i>
                            <span id="invApp_ViewLoan"></span>
                        </h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="allocation-table-frame">
                            <div class="allocation-table-wrap">
                                <table class="table table-hover table-sm allocation-table" id="table_viewloanDetails">
                                    <thead>
                                        <tr>
                                            <th class="text-center">
                                                <input type="checkbox" id="chkAll_Order" class="order-checkbox" />
                                            </th>
                                            <th>Order No</th>
                                            <th>On / Offline</th>
                                            <th>Date-Time</th>
                                            <th>Priority</th>
                                            <th>Borrower Name</th>
                                            <th>Property Address</th>
                                            <th>State</th>
                                            <th>County</th>
                                            <th>Client ID</th>
                                            <th>Customer Type</th>
                                            <th>Transaction Type</th>
                                            <th>Legal Description</th>
                                            <th>Instruction</th>
                                            <th>Last Process</th>
                                            <th>Last User</th>
                                            <th style="display: none;">OrderID</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-allocation-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>Close</span>
                        </button>
                        <button type="button" id="approveSelectedLoans" class="btn btn-allocation-success" onclick="return allocateOrder_Submit();">
                            <i class="fas fa-check"></i><span>Allocate</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="waitingpanel" tabindex="-1" data-backdrop="static" aria-hidden="true">
            <div class="modal-dialog text-center">
                <img src="../Images/Load.gif" alt="Loading" />
                <br />
                <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Order verification in progress. Please wait.</span>
                <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
            </div>
        </div>
    </div>
</asp:Content>
