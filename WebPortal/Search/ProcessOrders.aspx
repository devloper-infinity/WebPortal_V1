<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="ProcessOrders.aspx.cs" Inherits="WebPortal.Search.ProcessOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" rel="stylesheet" />
    <link href="../plugins/jquery-ui/jquery-ui.min.css" rel="stylesheet" />

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
        #invrec_SearchProcess {
            width: 100% !important;
            min-width: 1120px;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            .ost-table thead th,
            #invrec_SearchProcess thead th {
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

            .ost-table tbody td,
            #invrec_SearchProcess tbody td {
                color: var(--ost-text);
                background: #ffffff !important;
                font-size: 12px;
                vertical-align: middle;
            }

            .ost-table tbody tr:hover td,
            #invrec_SearchProcess tbody tr:hover td {
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

        .ost-actions-cell .btn-link {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            color: var(--ost-accent);
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 7px;
            line-height: 1;
        }

        .ost-actions-cell .dropdown-menu {
            min-width: 170px;
            padding: 6px;
            border: 1px solid var(--ost-border);
            border-radius: 8px;
            box-shadow: 0 12px 28px rgba(31, 41, 55, .14);
        }

        .ost-actions-cell .dropdown-item {
            display: flex;
            align-items: center;
            gap: 8px;
            min-height: 34px;
            padding: 7px 9px;
            color: var(--ost-text);
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
        }

            .ost-actions-cell .dropdown-item:hover {
                color: var(--ost-primary-dark);
                background: #edf7f5;
            }

        .ost-modal .modal-dialog {
            max-width: min(980px, calc(100vw - 32px));
        }

        .ost-modal .modal-content {
            border: 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 18px 45px rgba(31, 41, 55, .18);
        }

        .ost-modal .modal-header {
            align-items: center;
            padding: 14px 18px;
            color: #ffffff;
            background: var(--ost-primary);
            border-bottom: 0;
        }

        .ost-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: #ffffff;
            font-size: 17px;
            font-weight: 700;
        }

        .ost-modal .close {
            color: #ffffff;
            opacity: 1;
            text-shadow: none;
        }

        .ost-modal .modal-body {
            padding: 20px;
            background: #fbfcfd;
        }

        .ost-modal .modal-footer {
            padding: 12px 14px;
            background: #ffffff;
            border-top: 1px solid var(--ost-soft);
        }

        .ost-modal-summary {
            display: grid;
            grid-template-columns: repeat(5, minmax(180px, 1fr));
            gap: 8px 14px;
            margin-bottom: 16px;
            padding: 12px;
            background: #f8fafc;
            border: 1px solid var(--ost-soft);
            border-radius: 8px;
        }

            .ost-modal-summary label {
                margin: 0;
                color: var(--ost-text);
                font-size: 12px;
                color: dodgerblue;
            }

        .ost-modal-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(220px, 1fr));
            gap: 14px 16px;
        }

            .ost-modal-grid .full {
                grid-column: 1 / -1;
            }

        .ost-modal.tax-modal .modal-dialog {
            max-width: 1180px;
        }

        .tax-installment-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .tax-installment-card {
            min-width: 0;
            padding: 16px;
            border: 1px solid #d8e1e8;
            border-top: 3px solid #0f766e;
            border-radius: 10px;
            background: #f8fafc;
            box-shadow: 0 4px 14px rgba(15, 23, 42, .05);
        }

        .tax-installment-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 14px;
            color: #0f766e;
            font-size: 15px;
            font-weight: 700;
        }

            .tax-installment-title i {
                font-size: 7px;
            }

        .tax-installment-card .ost-field {
            position: relative;
            margin-bottom: 12px;
        }

            .tax-installment-card .ost-field:last-child {
                margin-bottom: 0;
            }

        .tax-currency-control {
            position: relative;
        }

            .tax-currency-control > span {
                position: absolute;
                z-index: 2;
                top: 50%;
                left: 12px;
                color: #64748b;
                transform: translateY(-50%);
            }

            .tax-currency-control .form-control {
                padding-left: 28px;
            }

        .tax-date-picker {
            padding-right: 38px !important;
        }

        .tax-installment-card .ui-datepicker-trigger {
            position: absolute;
            right: 7px;
            bottom: 5px;
            width: 30px;
            height: 30px;
            padding: 0;
            color: #0f766e;
            background: transparent;
            border: 0;
            border-radius: 6px;
        }

            .tax-installment-card .ui-datepicker-trigger:hover,
            .tax-installment-card .ui-datepicker-trigger:focus {
                color: #ffffff;
                background: #0f766e;
                outline: 0;
            }

        .ui-datepicker {
            z-index: 100000 !important;
        }

        .swal2-container {
            z-index: 200000 !important;
        }

        .tax-remark-panel {
            margin-top: 16px;
            padding: 16px;
            border: 1px solid #d8e1e8;
            border-radius: 10px;
            background: #fff;
        }

        .tax-required {
            color: #dc2626;
        }

        .ost-choice-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px 20px;
            padding-top: 4px;
        }

        .ost-order-details-panel {
            margin-top: 2px;
            padding: 12px;
            background: #ffffff;
            border: 1px solid var(--ost-border);
            border-radius: 8px;
        }

        .ost-order-details-title {
            display: flex;
            align-items: center;
            gap: 7px;
            margin: 0 0 10px;
            color: var(--ost-text);
            font-size: 13px;
            font-weight: 700;
        }

            .ost-order-details-title i {
                color: var(--ost-primary);
            }

        #ProcessOrders_OrderDetails {
            width: 100% !important;
            min-width: 1580px;
        }

            #ProcessOrders_OrderDetails th,
            #ProcessOrders_OrderDetails td {
                font-size: 11px !important;
                vertical-align: middle;
                white-space: nowrap;
            }

                #ProcessOrders_OrderDetails td.ost-detail-text {
                    max-width: 240px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }

        .ost-order-details-panel .dataTables_wrapper {
            width: 100%;
        }

        .ost-order-details-panel .dataTables_filter,
        .ost-order-details-panel .dataTables_info,
        .ost-order-details-panel .dataTables_paginate {
            margin: 4px 0;
            font-size: 11px;
        }

        .ost-document-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: var(--ost-accent);
            font-weight: 700;
            text-decoration: none;
        }

            .ost-document-link:hover,
            .ost-document-link:focus {
                color: #1d4ed8;
                text-decoration: underline;
            }

        .ost-choice-row .checkbox-wrapper-24 {
            display: inline-flex;
            align-items: center;
        }

            .ost-choice-row .checkbox-wrapper-24 label {
                display: inline-flex;
                align-items: center;
                margin: 0;
                color: var(--ost-text);
                cursor: pointer;
                font-size: 12px;
                font-weight: 700;
                line-height: 25px;
                position: relative;
            }

                .ost-choice-row .checkbox-wrapper-24 label span {
                    display: inline-block;
                    position: relative;
                    width: 25px;
                    height: 25px;
                    margin-right: 9px;
                    background-color: transparent;
                    border: 2px solid var(--ost-primary);
                    border-radius: 50%;
                    transform-origin: center;
                    transition: background-color 150ms 200ms, transform 350ms cubic-bezier(.78, -1.22, .17, 1.89);
                }

                    .ost-choice-row .checkbox-wrapper-24 label span::before {
                        content: "";
                        width: 0;
                        height: 2px;
                        border-radius: 2px;
                        background: var(--ost-primary);
                        position: absolute;
                        transform: rotate(45deg);
                        top: 11px;
                        left: 7px;
                        transform-origin: 0 0;
                        transition: width 50ms ease 50ms;
                    }

                    .ost-choice-row .checkbox-wrapper-24 label span::after {
                        content: "";
                        width: 0;
                        height: 2px;
                        border-radius: 2px;
                        background: var(--ost-primary);
                        position: absolute;
                        transform: rotate(305deg);
                        top: 14px;
                        left: 8px;
                        transform-origin: 0 0;
                        transition: width 50ms ease;
                    }

                .ost-choice-row .checkbox-wrapper-24 label:hover span::before {
                    width: 5px;
                    transition: width 100ms ease;
                }

                .ost-choice-row .checkbox-wrapper-24 label:hover span::after {
                    width: 10px;
                    transition: width 150ms ease 100ms;
                }

            .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"] {
                position: absolute;
                width: 1px;
                height: 1px;
                opacity: 0;
                pointer-events: none;
            }

                .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"]:focus + label span {
                    box-shadow: 0 0 0 3px rgba(15, 118, 110, .18);
                }

                .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"]:checked + label span {
                    background-color: var(--ost-primary);
                    transform: scale(1.12);
                }

                    .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"]:checked + label span::before {
                        width: 5px;
                        background: #ffffff;
                        transition: width 150ms ease 100ms;
                    }

                    .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"]:checked + label span::after {
                        width: 10px;
                        background: #ffffff;
                        transition: width 150ms ease 100ms;
                    }

                .ost-choice-row .checkbox-wrapper-24 input[type="checkbox"]:disabled + label {
                    cursor: not-allowed;
                    opacity: .55;
                }

        @media (prefers-reduced-motion: reduce) {
            .ost-choice-row .checkbox-wrapper-24 label span,
            .ost-choice-row .checkbox-wrapper-24 label span::before,
            .ost-choice-row .checkbox-wrapper-24 label span::after {
                transition: none;
            }
        }

        #processOrderAlert {
            display: none;
            max-width: 1440px;
            margin: 0 auto 12px;
            font-size: 13px;
            font-weight: 700;
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

            .tax-installment-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
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

            .ost-modal-summary,
            .ost-modal-grid {
                grid-template-columns: 1fr;
            }

            .tax-installment-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            BindGrid_PendingOrders();
        });
    </script>
    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../plugins/jquery-ui/jquery-ui.min.js"></script>
    <portal:VersionedScript Src="~/Scripts/Search/ProcessOrders.js" runat="server"></portal:VersionedScript>

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
                <span class="search-header-icon"><i class="fas fa-cogs"></i></span>
                <div class="search-header-copy">
                    <h1 class="ost-title">
                        <span>Process Orders</span>
                    </h1>
                    <div class="ost-context">
                        Review, assign, and manage pending orders across operational processes
               
                    </div>
                </div>
            </div>
        </div>

        <div class="ost-shell">
            <div id="processOrderAlert" class="alert" role="alert"></div>
            <div class="ost-grid-panel">
                <div class="ost-grid-header">
                    <div>
                        <h2>
                            <i class="fas fa-clipboard-list"></i>
                            <span>Pending Order Queue</span>
                        </h2>
                        <p class="ost-grid-subtitle">
                            View order status, assignment details, process information, and available actions
                       
                        </p>
                    </div>
                </div>
                <div class="ost-table-frame">
                    <div class="ost-table-wrap">
                        <table class="table table-bordered table-hover" id="invrec_SearchProcess">
                            <thead>
                                <tr>
                                    <th>Actions</th>
                                    <th>Sr. #</th>
                                    <th>OrderId</th>
                                    <th>Project Number</th>
                                    <th>Client Order No</th>
                                    <th>OnOffLine</th>
                                    <th>Order Date</th>
                                    <th>Product Type</th>
                                    <th>Process</th>
                                    <th>Assigned Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade ost-modal" id="CompleteOrder" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title"><i class="fas fa-check-circle"></i><span>Complete Process</span></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="ost-modal-summary">
                            <label id="completeProject"></label>
                            <label id="completeProcess"></label>
                            <label id="completeOrderNo" style="text-wrap: nowrap;"></label>
                            <label id="completeOrderDate"></label>
                            <label id="completeOnline"></label>

                        </div>

                        <div class="ost-modal-grid">
                            <div class="ost-field">
                                <label for="Approval_Status">Status</label>
                                <select id="Approval_Status" name="Approval_Status" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Complete">Complete Process</option>
                                    <option value="Hold">Hold Order</option>
                                    <option value="Cancel">Cancel Order</option>
                                </select>
                            </div>
                            <div class="ost-field">
                                <label for="dashboard_attachment_upload">Attachment</label>
                                <input type="file" id="dashboard_attachment_upload" name="dashboard_attachment_upload" class="form-control" />
                            </div>
                            <div class="ost-field full">
                                <label>Additional Action</label>
                                <div class="ost-choice-row">
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_DispatchOrder" />
                                        <label for="ProcessOrders_DispatchOrder"><span></span>Dispatch Order</label>
                                    </div>
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_NoFeedback" />
                                        <label for="ProcessOrders_NoFeedback"><span></span>No Feedback</label>
                                    </div>
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_TaxCalling" />
                                        <label for="ProcessOrders_TaxCalling"><span></span>Tax Calling</label>
                                    </div>
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_Audit" />
                                        <label for="ProcessOrders_Audit"><span></span>Audit</label>
                                    </div>
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_SPQA" />
                                        <label for="ProcessOrders_SPQA"><span></span>SPQA</label>
                                    </div>
                                    <div class="checkbox-wrapper-24">
                                        <input type="checkbox" id="ProcessOrders_Offline" />
                                        <label for="ProcessOrders_Offline"><span></span>Offline</label>
                                    </div>
                                </div>
                            </div>
                            <div class="ost-field full">
                                <label for="Approval_remark">Remark</label>
                                <textarea id="Approval_remark" name="Approval_remark" class="form-control" rows="4"></textarea>
                            </div>
                            <div class="ost-field full ost-order-details-panel">
                                <h2 class="ost-order-details-title">
                                    <i class="fas fa-list-alt"></i>
                                    <span>Order Process Details</span>
                                </h2>
                                <div class="ost-table-wrap">
                                    <table id="ProcessOrders_OrderDetails" class="table table-bordered table-hover ost-table">
                                        <thead>
                                            <tr>
                                                <th>Sr. #</th>
                                                <th>Process Name</th>
                                                <th>OrderPriority</th>
                                                <th>Order No</th>
                                                <th>Remark</th>
                                                <th>AttachedDocument</th>
                                                <th>ClientId</th>
                                                <th>CustomerType</th>
                                                <th>LegalDescription</th>
                                                <th>Instruction</th>
                                                <th>OrderSheet</th>
                                                <th>AddedBy</th>
                                                <th>AddedDate</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-ost-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>Close</span>
                        </button>
                        <button class="btn btn-ost-primary" type="button" id="btnStep5" onclick="return CompleteOrder();">
                            <i class="fas fa-paper-plane"></i><span>Submit</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade ost-modal tax-modal" id="TaxDetails" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="TaxDetailsTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title" id="TaxDetailsTitle"><i class="fas fa-receipt"></i><span>Tax Details</span></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="ProcessOrders_TaxOrderID" />
                        <div class="tax-installment-grid">
                            <div class="tax-installment-card">
                                <h2 class="tax-installment-title"><i class="fas fa-circle"></i><span>1st Installment</span></h2>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstBaseAmount">Base Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFirstBaseAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstPaidAmount">Paid Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFirstPaidAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstPaidDate">Paid Date</label><input type="text" id="ProcessOrders_TaxFirstPaidDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstDueAmount">Due Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFirstDueAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstDueDate">Due Date</label><input type="text" id="ProcessOrders_TaxFirstDueDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstPenalty">Penalty and Interest</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFirstPenalty" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFirstDelinquency">Delinquency</label><select id="ProcessOrders_TaxFirstDelinquency" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select></div>
                            </div>
                            <div class="tax-installment-card">
                                <h2 class="tax-installment-title"><i class="fas fa-circle"></i><span>2nd Installment</span></h2>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondBaseAmount">Base Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxSecondBaseAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondPaidAmount">Paid Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxSecondPaidAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondPaidDate">Paid Date</label><input type="text" id="ProcessOrders_TaxSecondPaidDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondDueAmount">Due Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxSecondDueAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondDueDate">Due Date</label><input type="text" id="ProcessOrders_TaxSecondDueDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondPenalty">Penalty and Interest</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxSecondPenalty" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxSecondDelinquency">Delinquency</label><select id="ProcessOrders_TaxSecondDelinquency" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select></div>
                            </div>
                            <div class="tax-installment-card">
                                <h2 class="tax-installment-title"><i class="fas fa-circle"></i><span>3rd Installment</span></h2>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdBaseAmount">Base Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxThirdBaseAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdPaidAmount">Paid Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxThirdPaidAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdPaidDate">Paid Date</label><input type="text" id="ProcessOrders_TaxThirdPaidDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdDueAmount">Due Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxThirdDueAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdDueDate">Due Date</label><input type="text" id="ProcessOrders_TaxThirdDueDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdPenalty">Penalty and Interest</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxThirdPenalty" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxThirdDelinquency">Delinquency</label><select id="ProcessOrders_TaxThirdDelinquency" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select></div>
                            </div>
                            <div class="tax-installment-card">
                                <h2 class="tax-installment-title"><i class="fas fa-circle"></i><span>4th Installment</span></h2>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthBaseAmount">Base Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFourthBaseAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthPaidAmount">Paid Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFourthPaidAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthPaidDate">Paid Date</label><input type="text" id="ProcessOrders_TaxFourthPaidDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthDueAmount">Due Amount</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFourthDueAmount" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthDueDate">Due Date</label><input type="text" id="ProcessOrders_TaxFourthDueDate" class="form-control tax-date-picker" placeholder="dd-MMM-yyyy" autocomplete="off" readonly="readonly" /></div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthPenalty">Penalty and Interest</label><div class="tax-currency-control"><span>$</span><input type="number" min="0" step="0.01" id="ProcessOrders_TaxFourthPenalty" class="form-control" /></div>
                                </div>
                                <div class="ost-field">
                                    <label for="ProcessOrders_TaxFourthDelinquency">Delinquency</label><select id="ProcessOrders_TaxFourthDelinquency" class="form-control"><option value="Select">Select</option>
                                        <option value="Yes">Yes</option>
                                        <option value="No">No</option>
                                    </select></div>
                            </div>
                        </div>
                        <div class="tax-remark-panel ost-field">
                            <label for="ProcessOrders_TaxRemark">Remark <span class="tax-required">*</span></label>
                            <textarea id="ProcessOrders_TaxRemark" class="form-control" rows="4" maxlength="5000"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-ost-secondary" data-dismiss="modal"><i class="fas fa-times"></i><span>Close</span></button>
                        <button type="button" class="btn btn-ost-primary" id="ProcessOrders_TaxSave" onclick="return SaveTaxDetails();"><i class="fas fa-save"></i><span>Submit</span></button>
                    </div>
                </div>
            </div>
        </div>

        <%--        <div class="modal fade ost-modal" id="OrderCosting" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title"><i class="fas fa-file-invoice-dollar"></i><span>Order Costing</span></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="ost-modal-summary">
                            <label id="costingProject"></label>
                            <label id="costingOrderDate"></label>
                            <label id="costingOrderNo"></label>
                            <label id="costingOnline"></label>
                            <label id="costingProcess"></label>
                        </div>

                        <div class="ost-modal-grid">
                            <div class="ost-field">
                                <label for="ProcessOrders_SearchEType">Search Engine Type</label>
                                <select id="ProcessOrders_SearchEType" name="ProcessOrders_SearchEType" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Free">Free</option>
                                </select>
                            </div>
                            <div class="ost-field">
                                <label for="ProcessOrders_SearchEnginelink">Search Engine Link</label>
                                <input type="text" id="ProcessOrders_SearchEnginelink" name="ProcessOrders_SearchEnginelink" class="form-control" />
                            </div>
                            <div class="ost-field">
                                <label for="ProcessOrders_txtNoOfSearchesMade">No Of Searches Made</label>
                                <input type="number" min="0" step="1" id="ProcessOrders_txtNoOfSearchesMade" name="ProcessOrders_txtNoOfSearchesMade" class="form-control" />
                            </div>
                            <div class="ost-field">
                                <label for="ProcessOrders_txtCostSearches">Cost/Search</label>
                                <input type="number" min="0" step="0.01" id="ProcessOrders_txtCostSearches" name="ProcessOrders_txtCostSearches" class="form-control" />
                            </div>
                            <div class="ost-field">
                                <label for="ProcessOrders_Total">Total</label>
                                <input type="number" min="0" step="0.01" id="ProcessOrders_Total" name="ProcessOrders_Total" class="form-control" />
                            </div>
                            <div class="ost-field full">
                                <label for="ProcessOrders_CostRemark">Remark</label>
                                <textarea id="ProcessOrders_CostRemark" name="ProcessOrders_CostRemark" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-ost-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>Close</span>
                        </button>
                        <button class="btn btn-ost-primary" type="button" id="btnStep51" onclick="return OrderCosting();">
                            <i class="fas fa-save"></i><span>Submit</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>--%>
    </div>
</asp:Content>

