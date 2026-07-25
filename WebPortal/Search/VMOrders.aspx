<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="VMOrders.aspx.cs" Inherits="WebPortal.Search.VMOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

    <style>
        .sec-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 17px 35px;
            margin-bottom: 25px;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(115deg,#0a5fd7 0%,#1976f3 35%,#1da8ea 70%,#22d3ee 100%);
            box-shadow: 0 12px 28px rgba(21, 98, 228, .25);
        }

            /* Top Wave */
            .sec-hero::before {
                content: "";
                position: absolute;
                top: -90px;
                left: -5%;
                width: 110%;
                height: 180px;
                border-radius: 50%;
                background: rgba(255,255,255,.08);
                transform: rotate(-3deg);
            }

            /* Bottom Waves */
            .sec-hero::after {
                content: "";
                position: absolute;
                left: -10%;
                bottom: -70px;
                width: 130%;
                height: 180px;
                background: repeating-radial-gradient( ellipse at center, rgba(255,255,255,.18) 0px, rgba(255,255,255,.18) 2px, transparent 3px, transparent 10px );
                opacity: .35;
                transform: rotate(-6deg);
            }

            .sec-hero > * {
                position: relative;
                z-index: 2;
            }

        .sec-hero-icon {
            width: 50px;
            height: 50px;
            min-width: 50px;
            border-radius: 20%;
            border: 2px solid rgba(255,255,255,.75);
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,.10);
            backdrop-filter: blur(4px);
        }

            .sec-hero-icon i {
                font-size: 34px;
                color: #fff;
            }

        .sec-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: -10px;
        }

        .sec-subtitle {
            margin: 10px 0 0;
            font-size: 14px;
            color: rgba(255,255,255,.92);
            line-height: 1.6;
            max-width: 900px;
        }

        .bank-form-panel {
            border: 1px solid #e9eef5;
            border-radius: 16px;
            background: #f8fafc;
            padding: 18px;
        }

        .bank-form-label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 8px;
        }


        .form-control {
            width: 100%;
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 9px 9px;
            height: 45px;
        }

        .bank-submit-btn {
            border-radius: 10px;
            font-weight: 700;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%) !important;
            height: 44px !important;
            min-width: 88px;
            padding: 0 22px !important;
            color: white;
            border: none;
        }

        .alloc-feedback-modal .modal-dialog {
            max-width: 1180px;
        }

        .alloc-status-modal .modal-dialog {
            max-width: 760px;
        }

        .alloc-feedback-modal .modal-content {
            border: 0;
            border-radius: 14px;
            box-shadow: 0 24px 60px rgba(15, 23, 42, .24);
            overflow: hidden;
        }

        .alloc-feedback-modal .modal-header {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border: 0;
            color: #fff;
            padding: 18px 22px;
        }

        .alloc-feedback-title {
            align-items: center;
            display: flex;
            gap: 12px;
        }

        .alloc-feedback-icon {
            align-items: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 8px;
            display: inline-flex;
            height: 46px;
            justify-content: center;
            width: 46px;
        }

        .alloc-feedback-title h5 {
            font-size: 19px;
            font-weight: 800;
            margin: 0;
        }

        .alloc-feedback-title p {
            color: rgba(255,255,255,.84);
            font-size: 12px;
            font-weight: 700;
            margin: 4px 0 0;
        }

        .alloc-feedback-modal .close {
            color: #fff;
            opacity: .9;
            text-shadow: none;
        }

        .alloc-feedback-modal .modal-body {
            background: #f5f8fc;
            padding: 18px;
        }

        .alloc-context-grid {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-radius: 12px;
            display: grid;
            gap: 1px;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            margin-bottom: 14px;
            overflow: hidden;
        }

        .alloc-status-context-grid {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .alloc-context-item {
            background: #fff;
            min-width: 0;
            padding: 12px 14px;
        }

            .alloc-context-item span {
                color: #64748b;
                display: block;
                font-size: 11px;
                font-weight: 800;
                letter-spacing: 0;
                margin-bottom: 5px;
                text-transform: uppercase;
            }

            .alloc-context-item strong {
                color: #102033;
                display: block;
                font-size: 13px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

        .alloc-feedback-tabs {
            background: #eaf1fb;
            border: 1px solid #d9e5f4;
            border-radius: 12px;
            display: grid !important;
            gap: 10px !important;
            grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
            margin-bottom: 14px !important;
            padding: 8px;
        }

            .alloc-feedback-tabs .nav-item {
                width: 100%;
            }

            .alloc-feedback-tabs .nav-link {
                align-items: center;
                border: 1px solid transparent !important;
                border-radius: 9px !important;
                color: #17365d !important;
                display: flex !important;
                font-size: 12px;
                font-weight: 800 !important;
                gap: 8px;
                height: 42px !important;
                justify-content: center;
                width: 100%;
            }

                .alloc-feedback-tabs .nav-link.active {
                    background: #fff !important;
                    border-color: #d7e2f0 !important;
                    border-bottom: 3px solid #087c9a !important;
                    color: #083344 !important;
                    box-shadow: 0 8px 16px rgba(15,23,42,.10) !important;
                }

        .alloc-feedback-panel {
            background: #fff;
            border: 1px solid #e0e8f1;
            border-radius: 12px;
            padding: 16px;
        }

        .alloc-feedback-field {
            margin-bottom: 14px;
        }

            .alloc-feedback-field label {
                color: #334155;
                display: block;
                font-size: 12px;
                font-weight: 800;
                margin-bottom: 7px;
            }

            .alloc-feedback-field .form-control {
                background: #fff;
                border: 1px solid #cfd9e7;
                border-radius: 8px;
                font-size: 13px;
                min-height: 42px;
            }

            .alloc-feedback-field textarea.form-control {
                height: auto;
                min-height: 74px;
                resize: vertical;
            }

        .alloc-status-modal .alloc-feedback-panel {
            padding-bottom: 14px;
        }

        .alloc-status-modal .alloc-feedback-field textarea.form-control {
            min-height: 96px;
        }

        .alloc-feedback-actions {
            align-items: center;
            border-top: 1px solid #edf2f8;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 4px;
            padding-top: 14px;
        }

        .alloc-outline-btn {
            background: #eefaf8;
            border: 1px solid #c9e5e1;
            border-radius: 10px;
            color: #075e57;
            font-weight: 800;
            height: 42px;
            padding: 0 18px;
        }

        .alloc-dropzone {
            align-items: center;
            background: #f8fafc;
            border: 2px dashed #b8c8dc;
            border-radius: 12px;
            color: #334155;
            cursor: pointer;
            display: flex;
            gap: 16px;
            min-height: 126px;
            padding: 20px;
            transition: border-color .18s ease, background .18s ease;
        }

            .alloc-dropzone i {
                color: #0f766e;
                font-size: 32px;
            }

            .alloc-dropzone strong {
                color: #102033;
                display: block;
                font-size: 15px;
                margin-bottom: 4px;
            }

            .alloc-dropzone span {
                color: #64748b;
                display: block;
                font-size: 12px;
                font-weight: 700;
            }

            .alloc-dropzone.is-dragover {
                background: #ecfdf5;
                border-color: #0f766e;
            }

        .alloc-import-summary {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin: 14px 0;
        }

        .alloc-import-pill {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-left: 4px solid #1d4ed8;
            border-radius: 10px;
            padding: 11px 13px;
        }

            .alloc-import-pill span {
                color: #64748b;
                display: block;
                font-size: 11px;
                font-weight: 800;
                margin-bottom: 4px;
                text-transform: uppercase;
            }

            .alloc-import-pill strong {
                color: #0f172a;
                font-size: 18px;
            }

        .alloc-import-results {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .alloc-result-table {
            border: 1px solid #e0e8f1;
            border-radius: 10px;
            overflow: hidden;
        }

        .alloc-result-title {
            background: #eef6ff;
            color: #17365d;
            font-size: 12px;
            font-weight: 800;
            padding: 10px 12px;
        }

        .alloc-result-scroll {
            max-height: 220px;
            overflow: auto;
        }

            .alloc-result-scroll table {
                margin: 0;
                width: 100%;
            }

            .alloc-result-scroll th,
            .alloc-result-scroll td {
                border-bottom: 1px solid #edf2f8;
                font-size: 12px;
                padding: 8px 10px;
                white-space: nowrap;
                text-align: left;
            }

        @media (max-width: 991px) {
            .alloc-context-grid,
            .alloc-import-results {
                grid-template-columns: 1fr;
            }

            .alloc-import-summary {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sec-hero {
                height: auto;
                min-height: 94px;
                padding: 18px 18px !important;
                border-radius: 18px !important;
            }

            .sec-hero-icon {
                width: 46px !important;
                height: 46px !important;
                min-width: 46px !important;
            }

            .sec-title {
                font-size: 16px !important;
            }

            .sec-subtitle {
                font-size: 10px !important;
            }
        }
        /* End tracking module header refresh */
    </style>

    <style>
        /* Keep tab style */
        .card-tabs > .card-header {
            margin: 0 0 14px !important;
            padding: 8px !important;
            background: #eaf1fb !important;
            border-radius: 14px !important;
            box-shadow: inset 0 0 0 1px #d9e5f4 !important;
        }

        .nav-tabs {
            display: grid !important;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px !important;
            width: 100%;
            border-bottom: 0 !important;
        }

            .nav-tabs .nav-link {
                height: 46px !important;
                display: flex !important;
                align-items: center;
                justify-content: center;
                border-radius: 10px !important;
                color: #102a4c !important;
                font-size: 12px;
                font-weight: 800 !important;
                background: transparent !important;
                border: 1px solid transparent !important;
            }

                .nav-tabs .nav-link.active {
                    background: #ffffff !important;
                    color: #083344 !important;
                    border-color: #d7e2f0 !important;
                    border-bottom: 3px solid #087c9a !important;
                    box-shadow: 0 9px 18px rgba(15, 23, 42, .12) !important;
                }

        /* DataTable wrapper */
        .dataTables_wrapper {
            width: 100%;
        }

        /* Keep DataTables' sizing header available, but visually hidden */
        .dataTables_scrollBody thead {
            visibility: collapse !important;
        }

            .dataTables_scrollBody thead th,
            .dataTables_scrollBody thead td {
                border: 0 !important;
                height: 0 !important;
                line-height: 0 !important;
                padding-bottom: 0 !important;
                padding-top: 0 !important;
                text-align: left;
            }

        /* Main visible DataTable header */
        .dataTables_scrollHead thead th,
        table.dataTable thead th {
            background: #eef6ff !important;
            color: #17365d !important;
            font-size: 12px !important;
            font-weight: 800 !important;
            padding: 13px 14px !important;
            border-bottom: 1px solid #d9e2f1 !important;
            white-space: nowrap !important;
            text-align: left !important;
            /* vertical-align: middle !important;*/
        }

        /* Body cells */
        table.dataTable tbody td {
            padding: 13px 14px !important;
            border-bottom: 1px solid #edf2f8 !important;
            white-space: nowrap !important;
            vertical-align: middle !important;
            text-align: left !important;
        }

        /* Remove forced duplicate table header display */
        .tab-pane > table[id] thead,
        .dataTables_wrapper table[id] thead,
        table.dataTable thead {
            display: table-header-group;
            text-align: left !important;
        }

        /* Scroll fix */
        .dataTables_scroll,
        .dataTables_scrollHead,
        .dataTables_scrollBody {
            width: 100% !important;
        }

        .dataTables_scrollHead {
            overflow: hidden !important;
        }

        .dataTables_scrollHeadInner,
        .dataTables_scrollHeadInner table,
        .dataTables_scrollBody table {
            box-sizing: border-box !important;
            margin: 0 !important;
            width: 100% !important;
        }

        .dataTables_scrollBody {
            overflow-x: auto !important;
        }
    </style>

    <style>
        /* allocate-rnr-datatable: RnR table treatment for Update Status */
        .allocate-status-grid {
            width: 100%;
            margin-top: 18px;
            overflow-x: visible !important;
        }

        #table_OrderComplete_wrapper {
            width: 100% !important;
            overflow: visible !important;
        }

            #table_OrderComplete_wrapper .row:nth-child(2) {
                overflow-x: visible !important;
                margin: 0 !important;
            }

        #table_OrderComplete,
        #table_OrderComplete.dataTable {
            width: 100% !important;
            min-width: 1100px !important;
            table-layout: auto !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            border: 1px solid #d9e2f1 !important;
            border-radius: 8px !important;
            overflow: hidden !important;
            background: #fff;
        }

            #table_OrderComplete thead th,
            #table_OrderComplete.dataTable thead th {
                background: #f8fafc !important;
                color: #344054 !important;
                border-bottom: 1px solid #d9e2f1 !important;
                font-size: 12px !important;
                font-weight: 800 !important;
                text-transform: uppercase;
                letter-spacing: 0;
                white-space: nowrap !important;
                line-height: 1.2 !important;
                padding: 12px 10px !important;
                text-align: left !important;
                box-sizing: border-box !important;
            }

            #table_OrderComplete tbody td,
            #table_OrderComplete.dataTable tbody td {
                vertical-align: middle !important;
                border-color: #edf2f8 !important;
                background: #fff !important;
                color: #344054;
                font-size: 13px;
                padding: 12px 10px !important;
                white-space: nowrap !important;
                text-align: left !important;
                box-sizing: border-box !important;
            }

        #table_OrderComplete_wrapper .dataTables_scrollHead thead th,
        #table_OrderComplete_wrapper .dataTables_scrollBody tbody td {
            white-space: nowrap !important;
        }

            #table_OrderComplete_wrapper .dataTables_scrollHead thead th:nth-child(-n+2),
            #table_OrderComplete_wrapper .dataTables_scrollBody tbody td:nth-child(-n+2),
            #table_OrderComplete thead th:nth-child(-n+2),
            #table_OrderComplete tbody td:nth-child(-n+2) {
                text-align: center !important;
            }

            #table_OrderComplete_wrapper .dataTables_scrollHead thead th:nth-child(n+3),
            #table_OrderComplete_wrapper .dataTables_scrollBody tbody td:nth-child(n+3),
            #table_OrderComplete thead th:nth-child(n+3),
            #table_OrderComplete tbody td:nth-child(n+3) {
                text-align: left !important;
            }

        #table_OrderComplete_wrapper th.action-column,
        #table_OrderComplete_wrapper td.action-column,
        #table_OrderComplete th.action-column,
        #table_OrderComplete td.action-column {
            width: 65px !important;
            min-width: 65px !important;
            max-width: 65px !important;
            text-align: center !important;
        }

        #table_OrderComplete tbody tr:hover td {
            background: #f8fafc !important;
        }

        #table_OrderComplete th:nth-child(1),
        #table_OrderComplete td:nth-child(1) {
            width: 4% !important;
        }

        #table_OrderComplete th:nth-child(2),
        #table_OrderComplete td:nth-child(2) {
            width: 9% !important;
        }

        #table_OrderComplete th:nth-child(3),
        #table_OrderComplete td:nth-child(3) {
            width: 8% !important;
        }

        #table_OrderComplete th:nth-child(4),
        #table_OrderComplete td:nth-child(4) {
            width: 9% !important;
        }

        #table_OrderComplete th:nth-child(5),
        #table_OrderComplete td:nth-child(5) {
            width: 10% !important;
        }

        #table_OrderComplete th:nth-child(6),
        #table_OrderComplete td:nth-child(6) {
            width: 13% !important;
        }

        #table_OrderComplete th:nth-child(7),
        #table_OrderComplete td:nth-child(7) {
            width: 15% !important;
        }

        #table_OrderComplete th:nth-child(8),
        #table_OrderComplete td:nth-child(8) {
            width: 10% !important;
        }

        #table_OrderComplete th:nth-child(9),
        #table_OrderComplete td:nth-child(9) {
            width: 10% !important;
        }

        #table_OrderComplete th:nth-child(10),
        #table_OrderComplete td:nth-child(10) {
            width: 12% !important;
        }

        #table_OrderComplete .alloc-table-empty {
            color: #98a2b3;
        }

        .alloc-icon-btn {
            align-items: center;
            background: transparent;
            border: 0;
            border-radius: 8px;
            cursor: pointer;
            display: inline-flex;
            font-size: 18px;
            height: 32px;
            justify-content: center;
            padding: 0;
            transition: background .2s ease, color .2s ease;
            width: 32px;
        }

            .alloc-icon-btn:focus {
                box-shadow: none;
                outline: none;
            }

        .status-icon {
            color: #0d6efd;
        }

            .status-icon:hover {
                background: #0d6efd;
                color: #fff;
            }

        .feedback-icon {
            color: #16a34a;
        }

            .feedback-icon:hover {
                background: #16a34a;
                color: #fff;
            }
    </style>


    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <%-- <portal:VersionedScript Src="~/Scripts/Tracking/Allocate.js" runat="server"></portal:VersionedScript>--%>

    <script>

        $(document).ready(function () {


        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="sec-page">
        <div class="sec-hero">
            <span class="sec-hero-icon">
                <i class="fas fa-tasks"></i>
            </span>
            <div>
                <h1 class="sec-title">VM Allocation And Process Order</h1>
                <p class="sec-subtitle">
                    Allocate loan orders, monitor workflow progress, and track processing status from assignment to completion.
                </p>
            </div>
        </div>

        <div class="sec-panel">
            <div class="card card-tabs">
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b>Order Allocation</b></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><b>Order Queue</b></a>
                        </li>
                    </ul>
                </div>
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="bank-form-panel mb-5">
                            <div class="row align-items-end g-3">

                                <div class="col">
                                    <label for="allocate_project" class="bank-form-label">Project</label>
                                    <select id="allocate_project" name="allocate_project"
                                        class="form-control"
                                        onchange="return allocate_bindProcess(this);">
                                    </select>
                                </div>

                                <div class="col">
                                    <label for="allocate_dealNo" class="bank-form-label">Deal #</label>
                                    <select id="allocate_dealNo" name="allocate_dealno"
                                        class="form-control">
                                    </select>
                                </div>

                                <div class="col">
                                    <label for="allocate_process" class="bank-form-label">Process</label>
                                    <select id="allocate_process" name="allocate_process"
                                        class="form-control">
                                    </select>
                                </div>

                                <div class="col-auto">
                                    <button id="allocate_btnShow"
                                        type="button"
                                        class="btn btn-primary"
                                        onclick="return GetLoansToAllocate_bindGrid();">
                                        <i class="fas fa-search me-1"></i>&nbsp;Show Loans
                                    </button>
                                </div>

                                <div class="col-auto">
                                    <button id="allocate_btnSubmit"
                                        type="button"
                                        class="bank-submit-btn"
                                        onclick="return AllocateOrders();">
                                        <i class="fas fa-tasks me-1"></i>&nbsp;Allocate Loans
                                    </button>
                                </div>

                            </div>
                        </div>
                        <hr />
                        <table class="table" id="table_OrderAllocate" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan1 #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                </tr>
                            </thead>
                            <tbody style="text-align: left;"></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">

                        <div class="allocate-status-grid">
                            <table class="table" id="table_OrderComplete">
                                <thead>
                                    <tr>
                                        <th>Update Status</th>
                                        <th>Add Feedback</th>
                                        <th>Project</th>
                                        <th>Deal #</th>
                                        <th>Loan #</th>
                                        <th>Status</th>
                                        <th>Hold Reason</th>
                                        <th>Remark</th>
                                        <th>Allocated Date</th>
                                        <th>Completion Date</th>
                                        <th>PrevID</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</asp:Content>
