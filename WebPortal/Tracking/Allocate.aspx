<%@ Page Title="" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="Allocate.aspx.cs" Inherits="WebPortal.Tracking.Allocate" %>

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

        .sec-kicker {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            opacity: .9;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .sec-title {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            margin-bottom: -10px;
        }

            .sec-title i {
                margin-right: 10px;
            }

        .sec-subtitle {
            margin: 10px 0 0;
            font-size: 14px;
            color: rgba(255,255,255,.92);
            line-height: 1.6;
            max-width: 900px;
        }

        .sec-stat-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .sec-stat {
            background: #fff;
            border: 1px solid #dce5ec;
            border-left: 4px solid #0f766e;
            border-radius: 8px;
            box-shadow: 0 8px 18px rgba(31, 51, 71, 0.06);
            padding: 14px 16px;
        }

            .sec-stat span {
                color: #667789;
                display: block;
                font-size: 12px;
                font-weight: 700;
                margin-bottom: 4px;
            }

            .sec-stat strong {
                color: #172737;
                display: block;
                font-size: 22px;
                line-height: 1;
            }

        .bank-shell-card {
            background: white;
            border: 0;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
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

        .bank-input:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.12);
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

        .alloc-open-feedback {
            align-items: center;
            background: #eefaf8;
            border: 1px solid #c9e5e1;
            border-radius: 8px;
            color: #075e57;
            display: inline-flex;
            font-size: 12px;
            font-weight: 800;
            gap: 7px;
            height: 34px;
            justify-content: center;
            padding: 0 12px;
            white-space: nowrap;
        }

            .alloc-open-feedback:hover,
            .alloc-open-feedback:focus {
                background: #dcf7f2;
                color: #064e47;
                outline: none;
                text-decoration: none;
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
            text-align: left;
        }

        /* Remove forced duplicate table header display */
        .tab-pane > table[id] thead,
        .dataTables_wrapper table[id] thead,
        table.dataTable thead {
            display: table-header-group;
            text-align: left;
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

    <script>

        function applyModernHrFormLayout() {
            $('.tab-pane > table.table:first-child').each(function () {
                var $table = $(this);
                if ($table.data('modernized') === true) return;

                $table.find('tr').each(function () {
                    var $row = $(this);
                    var $cells = $row.children('td').toArray();
                    var $newCells = $();

                    for (var i = 0; i < $cells.length; i++) {
                        var $cell = $($cells[i]);
                        var $label = $cell.children('b').first();
                        var next = $cells[i + 1] ? $($cells[i + 1]) : null;

                        if ($label.length && next && !next.children('b').length) {
                            var $fieldCell = $('<td class="hr-field-cell"></td>');
                            var $field = $('<div class="hr-form-field"></div>');
                            $('<label></label>').html($label.html().replace(':', '')).appendTo($field);
                            next.contents().appendTo($field);
                            $field.appendTo($fieldCell);
                            $newCells = $newCells.add($fieldCell);
                            i++;
                        } else if ($.trim($cell.text()).length || $cell.children().length) {
                            $cell.addClass('hr-action-cell');
                            $newCells = $newCells.add($cell);
                        }
                    }

                    $row.empty().append($newCells);
                });

                $table.data('modernized', true).addClass('hr-modern-form');
            });
        }

        $(document).ready(function () {
            applyModernHrFormLayout();
            $('a[data-toggle="pill"]').on('shown.bs.tab', applyModernHrFormLayout);
        });
    </script>

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
            min-width: 0 !important;
            table-layout: fixed !important;
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
                white-space: normal !important;
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
                white-space: normal !important;
                overflow-wrap: anywhere;
                box-sizing: border-box !important;
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
                width: 7% !important;
            }

            #table_OrderComplete th:nth-child(3),
            #table_OrderComplete td:nth-child(3) {
                width: 7% !important;
            }

            #table_OrderComplete th:nth-child(4),
            #table_OrderComplete td:nth-child(4) {
                width: 7% !important;
            }

            #table_OrderComplete th:nth-child(5),
            #table_OrderComplete td:nth-child(5) {
                width: 11% !important;
            }

            #table_OrderComplete th:nth-child(6),
            #table_OrderComplete td:nth-child(6) {
                width: 16% !important;
            }

            #table_OrderComplete th:nth-child(7),
            #table_OrderComplete td:nth-child(7) {
                width: 11% !important;
            }

            #table_OrderComplete th:nth-child(8),
            #table_OrderComplete td:nth-child(8) {
                width: 15% !important;
            }

            #table_OrderComplete th:nth-child(9),
            #table_OrderComplete td:nth-child(9) {
                width: 8% !important;
            }

            #table_OrderComplete th:nth-child(10),
            #table_OrderComplete td:nth-child(10) {
                width: 8% !important;
            }

            #table_OrderComplete th:nth-child(11),
            #table_OrderComplete td:nth-child(11) {
                width: 6% !important;
            }

            #table_OrderComplete .form-control {
                width: 100% !important;
                min-width: 0 !important;
                max-width: 100% !important;
                height: 44px;
                border-radius: 8px;
                font-size: 12px;
                padding: 8px 9px !important;
            }

            #table_OrderComplete textarea.Remark {
                height: 54px !important;
                min-height: 54px !important;
                line-height: 1.35;
                resize: vertical;
            }

            #table_OrderComplete .alloc-open-feedback,
            #table_OrderComplete .btn.btn-sm {
                width: 100%;
                min-width: 0 !important;
                height: 34px;
                padding: 0 7px !important;
                border-radius: 8px !important;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                font-size: 11px;
                font-weight: 800;
                white-space: nowrap !important;
            }
    </style>


    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Tracking/Allocate.js"></script>

    <script>

        $(document).ready(function () {

            allocate_bindProject();
            // allocate_bindProcess();
            // allocate_bindAllocatedogrdes_Grid();
            allocate_CompleteOrder_bindGrid();

        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <input id="glass_filep" style="display: none;" />
    <input id="glasscomp_filep" style="display: none;" />

    <div class="sec-page">
        <div class="sec-hero">
            <span class="sec-hero-icon">
                <i class="fas fa-tasks"></i>
            </span>
            <div>
                <h1 class="sec-title">Order Allocation & Tracking</h1>
                <p class="sec-subtitle">
                    Allocate loan orders, monitor workflow progress, and track processing status from assignment to completion.
                </p>
            </div>
        </div>

        <div class="sec-stat-grid" style="display: none;">
            <div class="sec-stat">
                <span>Allocated</span>
                <strong id="sectrack_stat_deals"></strong>
            </div>
            <div class="sec-stat">
                <span>Open Order</span>
                <strong id="sectrack_stat_pending">0</strong>
            </div>
            <div class="sec-stat">
                <span>Completed</span>
                <strong id="sectrack_stat_completed">0</strong>
            </div>
        </div>

        <div class="sec-panel">
            <div class="card card-tabs">
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b>Allocation</b></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><b>Update Loan Status</b></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false"><b>Report</b></a>
                        </li>
                    </ul>
                </div>
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="bank-form-panel mb-4">
                            <div class="row align-items-end">
                                <div class="col-lg-3 col-md-8 mb-3 mb-md-0">
                                    <label for="bank_name" class="bank-form-label">Project</label>
                                    <select id="allocate_project" name="allocate_project" class="form-control" onchange="return allocate_bindProcess(this);">
                                    </select>
                                </div>
                                <div class="col-lg-3 col-md-8 mb-3 mb-md-0">
                                    <label for="bank_name" class="bank-form-label">Process</label>
                                    <select id="allocate_process" name="allocate_process" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-3 col-md-4">
                                    <button id="allocate_btnShow" type="button" class="btn btn-primary w-100" onclick="return GetLoansToAllocate_bindGrid();">
                                        <i class="fas fa-search me-1"></i>&nbsp;&nbsp;Show Loans
                                    </button>
                                </div>
                                <div class="col-lg-3 col-md-4">
                                    <button id="allocate_btnSubmit" type="button" class="bank-submit-btn w-100" onclick="return AllocateOrders();">
                                        <i class="fas fa-tasks me-1"></i>&nbsp;&nbsp;Allocate Loans
                                    </button>
                                </div>
                            </div>
                        </div>
                        <hr />
                        <table class="table dataTable no-footer" id="table_OrderAllocate" style="width: 100%;">
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
                            <table class="table allocate-fixed-table" id="table_OrderComplete" style="width: 100%;">
                                <thead style="text-align: left;">
                                    <tr>
                                        <th>Sr. #</th>
                                        <th>Project</th>
                                        <th>Deal #</th>
                                        <th>Loan #</th>
                                        <th>Status</th>
                                        <th>Hold Reason</th>
                                        <th>Add Feedback</th>
                                        <th>Remark</th>
                                        <th>Allocated Date</th>
                                        <th>Complition Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                        <div class="bank-form-panel mb-4">
                            <div class="row align-items-end">
                                <div class="col-lg-4 col-md-8 mb-3 mb-md-0">
                                    <label for="bank_name" class="bank-form-label">From Date</label>
                                    <input type="date" id="allocate_FromDate" name="allocate_FromDate" class="form-control" />
                                </div>
                                <div class="col-lg-4 col-md-8 mb-3 mb-md-0">
                                    <label for="bank_name" class="bank-form-label">To Date</label>
                                    <input type="date" id="allocate_ToDate" name="allocate_ToDate" class="form-control" />
                                </div>
                                <div class="col-lg-4 col-md-8 mb-3 mb-md-0">
                                    <button type="button" id="allocate_btnGetData" class="bank-submit-btn" onclick="return allocate_GetLoanReport();">
                                        <i class="fas fa-search"></i>&nbsp;&nbsp;Get Report
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div>
                            <table class="table dataTable no-footer" id="table_Orderreport" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th style="width: 60px">Sr. #</th>
                                        <th style="width: 100px">Project</th>
                                        <th style="width: 100px">Deal #</th>
                                        <th style="width: 100px">Loan #</th>
                                        <th style="width: 170px">Status</th>
                                        <th style="width: 220px">Hold Reason</th>
                                        <th style="width: 140px">Remark</th>
                                        <th style="width: 250px">Start Date</th>
                                        <th style="width: 150px">Complition Date</th>
                                        <th style="width: 150px">TAT</th>
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

    <div class="modal fade alloc-feedback-modal" id="popUp_addTrackingFeedback" tabindex="-1" role="dialog" aria-labelledby="allocFeedbackTitle" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="alloc-feedback-title">
                        <span class="alloc-feedback-icon"><i class="fas fa-comment-dots"></i></span>
                        <div>
                            <h5 id="allocFeedbackTitle">Tracking Feedback</h5>
                            <p>Add feedback or import feedback rows for the selected loan.</p>
                        </div>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="alloc-context-grid">
                        <div class="alloc-context-item">
                            <span>Project</span>
                            <strong id="allocfb_ctxProject">-</strong>
                        </div>
                        <div class="alloc-context-item">
                            <span>Deal No</span>
                            <strong id="allocfb_ctxDeal">-</strong>
                        </div>
                        <div class="alloc-context-item">
                            <span>Loan No</span>
                            <strong id="allocfb_ctxLoan">-</strong>
                        </div>
                        <div class="alloc-context-item">
                            <span>Process</span>
                            <strong id="allocfb_ctxProcess">-</strong>
                        </div>
                        <div class="alloc-context-item">
                            <span>Order Date</span>
                            <strong id="allocfb_ctxOrderDate">-</strong>
                        </div>
                    </div>

                    <ul class="nav nav-tabs alloc-feedback-tabs" id="allocFeedbackTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="allocfb-add-tab" data-toggle="tab" href="#allocfb-add" role="tab" aria-controls="allocfb-add" aria-selected="true">
                                <i class="fas fa-plus-circle"></i>Add Feedback
                            </a>
                        </li>
                        <%--    <li class="nav-item">
                            <a class="nav-link" id="allocfb-import-tab" data-toggle="tab" href="#allocfb-import" role="tab" aria-controls="allocfb-import" aria-selected="false">
                                <i class="fas fa-file-import"></i>Import Feedback
                            </a>
                        </li>--%>
                    </ul>

                    <div class="tab-content" id="allocFeedbackTabContent">
                        <div class="tab-pane fade show active" id="allocfb-add" role="tabpanel" aria-labelledby="allocfb-add-tab">
                            <div class="alloc-feedback-panel">
                                <div class="row">
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_markedTo">Marked to</label>
                                            <select id="allocfb_markedTo" class="form-control">
                                                <option value="">Select</option>
                                                <option value="Review">Review</option>
                                                <option value="CNCReview">CNCReview</option>
                                                <option value="SSReview">SSReview</option>
                                                <option value="Loan Setup">Loan Setup</option>
                                                <option value="Credit">Credit</option>
                                                <option value="Compliance">Compliance</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_errorBy">Error By</label>
                                            <select id="allocfb_errorBy" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_feedbackBy">Feedback By</label>
                                            <input id="allocfb_feedbackBy" type="text" class="form-control" readonly="readonly" />
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_errorType">Error Type</label>
                                            <select id="allocfb_errorType" class="form-control">
                                                <option value="">Select</option>
                                                <option value="NoFeedback">NoFeedback</option>
                                                <option value="Misindexed">Misindexed</option>
                                                <option value="Misinterpretation">Misinterpretation</option>
                                                <option value="Miscalculation">Miscalculation</option>
                                                <option value="Conceptual">Conceptual</option>
                                                <option value="Scienna Data Entry">Scienna Data Entry</option>
                                                <option value="Careless">Careless</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_category">Category</label>
                                            <select id="allocfb_category" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_subCategory">Subcategory</label>
                                            <select id="allocfb_subCategory" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_severity">Severity</label>
                                            <select id="allocfb_severity" class="form-control">
                                                <option value="">Select</option>
                                                <option value="Non-Critical">Non-Critical</option>
                                                <option value="Critical">Critical</option>
                                                <option value="Critical-Saleable">Critical-Saleable</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_errorField">Error Field</label>
                                            <input id="allocfb_errorField" type="text" class="form-control" autocomplete="off" />
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_feedbackType">Feedback Type</label>
                                            <select id="allocfb_feedbackType" class="form-control">
                                                <option value="">Select</option>
                                                <option value="Internal">Internal</option>
                                                <option value="Client">Client</option>
                                                <option value="On-Shore">On-Shore</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_error">Error</label>
                                            <textarea id="allocfb_error" class="form-control"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_shouldBe">Should be</label>
                                            <textarea id="allocfb_shouldBe" class="form-control"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-lg-12">
                                        <div class="alloc-feedback-field">
                                            <label for="allocfb_remark">Remark</label>
                                            <textarea id="allocfb_remark" class="form-control"></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="alloc-feedback-actions">
                                    <button type="button" class="alloc-outline-btn" id="allocfb_btnClear">
                                        <i class="fas fa-eraser mr-1"></i>Clear
                                   
                                    </button>
                                    <button type="button" class="bank-submit-btn" id="allocfb_btnSave">
                                        <i class="fas fa-save mr-1"></i>Add
                                   
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="allocfb-import" role="tabpanel" aria-labelledby="allocfb-import-tab">
                            <div class="alloc-feedback-panel">
                                <input id="allocfb_importFile" type="file" accept=".xls,.xlsx,.csv" style="display: none;" />
                                <div class="alloc-dropzone" id="allocfb_dropzone">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <div>
                                        <strong id="allocfb_fileName">Drop feedback file here or click to browse</strong>
                                        <span>Supported formats: .xls, .xlsx, .csv. Columns must match the feedback import format.</span>
                                    </div>
                                </div>

                                <div class="alloc-feedback-actions">
                                    <button type="button" class="alloc-outline-btn" id="allocfb_btnFormat">
                                        <i class="fas fa-download mr-1"></i>Download Format
                                   
                                    </button>
                                    <button type="button" class="bank-submit-btn" id="allocfb_btnUpload">
                                        <i class="fas fa-file-upload mr-1"></i>Upload
                                   
                                    </button>
                                </div>

                                <div class="alloc-import-summary">
                                    <div class="alloc-import-pill">
                                        <span>Total Rows</span>
                                        <strong id="allocfb_importTotal">0</strong>
                                    </div>
                                    <div class="alloc-import-pill" style="border-left-color: #0f766e;">
                                        <span>Imported</span>
                                        <strong id="allocfb_importAdded">0</strong>
                                    </div>
                                    <div class="alloc-import-pill" style="border-left-color: #dc2626;">
                                        <span>Not Imported</span>
                                        <strong id="allocfb_importFailed">0</strong>
                                    </div>
                                </div>

                                <div class="alloc-import-results">
                                    <div class="alloc-result-table">
                                        <div class="alloc-result-title">Imported feedback</div>
                                        <div class="alloc-result-scroll">
                                            <table id="allocfb_addedTable" class="table table-sm">
                                                <thead>
                                                    <tr>
                                                        <th>Deal No</th>
                                                        <th>Loan 1 #</th>
                                                        <th>Process</th>
                                                        <th>Error Type</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="alloc-result-table">
                                        <div class="alloc-result-title">Could not import</div>
                                        <div class="alloc-result-scroll">
                                            <table id="allocfb_failedTable" class="table table-sm">
                                                <thead>
                                                    <tr>
                                                        <th>Deal No</th>
                                                        <th>Loan 1 #</th>
                                                        <th>Process</th>
                                                        <th>Reason</th>
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
                </div>
            </div>
        </div>
    </div>

</asp:Content>

