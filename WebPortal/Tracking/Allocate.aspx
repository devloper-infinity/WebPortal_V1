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
        /* Tracking module header refresh */
        /*.sec-hero {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            min-height: 94px;
            height: 94px;
            margin: 0 0 18px 0 !important;
            padding: 22px 28px !important;
            border: 0 !important;
            border-radius: 20px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: flex-start !important;
            gap: 18px !important;
            background: linear-gradient(101deg, #2854df 0%, #285fe2 45%, #2ec1cf 100%) !important;
            box-shadow: none !important;
            color: #ffffff !important;
        }

        {
            content: "";
            position: absolute;
            z-index: 0;
            right: 70px;
            top: -94px;
            width: 210px;
            height: 210px;
            border-radius: 50%;
            background: rgba(255,255,255,.13);
            pointer-events: none;
        }

        {
            content: "";
            position: absolute;
            z-index: 0;
            right: -22px;
            top: -54px;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(255,255,255,.12);
            pointer-events: none;
        }

        .sec-hero > * {
            position: relative;
            z-index: 1;
        }

        .sec-hero-icon {
            order: -1;
            width: 50px !important;
            height: 50px !important;
            min-width: 50px !important;
            padding: 0 !important;
            border: 1px solid rgba(255,255,255,.28) !important;
            border-radius: 16px !important;
            background: rgba(255,255,255,.14) !important;
            color: #ffffff !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.06) !important;
        }

            .sec-hero-icon i {
                color: #ffffff !important;
                font-size: 21px !important;
                line-height: 1 !important;
                margin: 0 !important;
            }

            .sec-hero-icon span {
                display: none !important;
            }

        .sec-title {
            color: #ffffff !important;
            font-size: 18px !important;
            font-weight: 800 !important;
            letter-spacing: 0 !important;
            line-height: 1.2 !important;
            margin: 0 !important;
            text-transform: none !important;
            text-shadow: 0 1px 1px rgba(3, 48, 120, .35);
        }

        .sec-subtitle {
            color: rgba(255,255,255,.94) !important;
            font-size: 11px !important;
            font-weight: 700 !important;
            letter-spacing: 0 !important;
            line-height: 1.45 !important;
            margin: 8px 0 0 !important;
            max-width: 760px !important;
            text-transform: none !important;
            text-shadow: 0 1px 1px rgba(3, 48, 120, .28);
        }

        .sec-kicker {
            display: none !important;
        }

        .sec-title i {
            display: none !important;
        }*/

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

    <script>

        $(document).ready(function () {

            alert('1');

            allocate_bindProject();
            allocate_bindProcess();
            // allocate_bindAllocatedogrdes_Grid();
            allocate_bindCompleteOrder_Grid();

        });

        function allocate_bindProject() {

            $.ajax({
                type: "POST",
                url: "Allocate.aspx/GetAllProjectByUser",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (response) {

                    var ddl = $("#allocate_project");

                    ddl.empty().append($("<option></option>").val("0").text("Select Project"));

                    var data = response.d;

                    if (typeof data === "string") {
                        data = JSON.parse(data || "[]");
                    }

                    $.each(data, function (i, item) {
                        ddl.append(
                            $("<option></option>")
                                .val(item.ProjectID)
                                .text(item.ProjectName)
                        );
                    });
                },

                error: function (xhr) {
                    console.log(xhr.responseText);

                    Swal.fire({
                        icon: "error",
                        title: "Error",
                        text: "Unable to load project list."
                    });
                }
            });

            return false;
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Tracking/Allocate.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <input id="glass_filep" style="display: none;" />
    <input id="glasscomp_filep" style="display: none;" />

    <div class="sec-page">
        <%--  <div class="sec-hero">
            <span class="sec-hero-icon"><i class="fas fa-tasks"></i></span>
            <div>
                <div class="sec-kicker">Tracking Sheet</div>
                <h1 class="sec-title"><i class="fas fa-tasks mr-2"></i>Order Allocation & Tracking</h1>
                <p class="sec-subtitle">Allocate loan orders, monitor workflow progress, and track processing status from assignment to completion.</p>
            </div>
        </div>--%>

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
                                    <select id="allocate_project" name="allocate_project" class="form-control">
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
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan1 #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                </tr>
                            </thead>
                            <tbody style="text-align: left;"></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">

                        <div style="overflow: auto;">
                            <table class="table dataTable no-footer" id="table_OrderComplete" style="width: 100%;">
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
                        <li class="nav-item">
                            <a class="nav-link" id="allocfb-import-tab" data-toggle="tab" href="#allocfb-import" role="tab" aria-controls="allocfb-import" aria-selected="false">
                                <i class="fas fa-file-import"></i>Import Feedback
                            </a>
                        </li>
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



<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


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
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }    </style>

    <style>
        :root {
            --hr-primary: #4f46e5;
            --hr-primary-dark: #3730a3;
            --hr-accent: #0e7490;
            --hr-bg: #f6f8fc;
            --hr-surface: #ffffff;
            --hr-border: #d9e2f1;
            --hr-text: #0b1f3a;
            --hr-muted: #58708d;
            --hr-radius: 16px;
            --hr-shadow: 0 12px 28px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--hr-bg) !important;
        }

        .content-header {
            display: none;
        }

        .col-lg-12 {
            padding: 10px 12px 0 !important;
            width: 100%;
        }

        .card {
            border: 0 !important;
            box-shadow: none !important;
            background: transparent !important;
            width: 100%;
        }

            .card > .card-body {
                padding: 0 !important;
                width: 100%;
            }

        .card-tabs {
            border: 1px solid #dce6f4 !important;
            border-radius: 0 !important;
            background: #f8fbff !important;
            box-shadow: none !important;
            overflow: visible !important;
        }

            .card-tabs > .card-header {
                margin: 8px 0 12px !important;
                padding: 8px 6px !important;
                background: #eaf0fb !important;
                border: 0 !important;
                border-radius: 14px !important;
            }

        .nav-tabs {
            display: grid !important;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px !important;
            width: 100%;
        }

            .nav-tabs .nav-item {
                width: 100%;
            }

            .nav-tabs .nav-link {
                width: 100%;
                min-height: 42px;
                display: flex !important;
                align-items: center;
                justify-content: center;
                gap: 8px;
                border: 1px solid transparent !important;
                border-radius: 10px !important;
                background: transparent !important;
                color: #102a4c !important;
                font-size: 12px;
                font-weight: 800 !important;
                box-shadow: none !important;
            }

                .nav-tabs .nav-link.active {
                    background: #fff !important;
                    color: #083344 !important;
                    border-color: #d7e2f0 !important;
                    border-bottom: 3px solid #087c9a !important;
                    box-shadow: 0 8px 14px rgba(15, 23, 42, .10) !important;
                }

                .nav-tabs .nav-link:hover {
                    background: #f7fbff !important;
                    color: #083344 !important;
                }

        .card-tabs > .card-body {
            margin: 0 14px 14px !important;
            padding: 20px !important;
            background: #fff !important;
            border-radius: 18px !important;
            box-shadow: 0 8px 18px rgba(15, 23, 42, .04) !important;
        }

        .tab-pane > .table:first-child,
        .tab-pane > .table:first-child.hr-modern-form {
            display: block !important;
            width: 100%;
            margin: 0 0 22px !important;
            padding: 0 !important;
            border: 0 !important;
            border-radius: 0 !important;
            background: transparent !important;
        }

        .hr-modern-form tbody {
            display: block !important;
            width: 100%;
        }

        .hr-modern-form tr {
            display: grid !important;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px 18px !important;
            width: 100%;
            margin-bottom: 16px !important;
        }

        .hr-modern-form td,
        .tab-pane .table.hr-modern-form td {
            display: block !important;
            min-width: 0 !important;
            padding: 0 !important;
            border: 0 !important;
        }

        .hr-form-field label {
            display: block;
            margin: 0 0 8px;
            color: #17365d;
            font-size: 12px;
            font-weight: 700;
        }

        .hr-form-field .form-control,
        .hr-form-field select.form-control,
        .hr-form-field input.form-control,
        .hr-form-field textarea.form-control {
            width: 100% !important;
            height: 42px;
            min-height: 42px;
            border-radius: 10px !important;
            border: 1px solid #cfdced !important;
            background-color: #fff !important;
            color: #0f172a !important;
            font-size: 12px;
            box-shadow: none !important;
        }

        .hr-form-field textarea.form-control {
            height: auto;
            min-height: 86px;
        }

        .hr-form-field .form-control:focus {
            border-color: #087c9a !important;
            box-shadow: 0 0 0 3px rgba(8,124,154,.12) !important;
        }

        .hr-action-cell {
            display: flex !important;
            align-items: end;
            gap: 10px;
        }

        .btn.btn-primary {
            min-height: 42px;
            border-radius: 10px !important;
            background: linear-gradient(135deg, #2563eb, #6d28d9) !important;
            box-shadow: 0 8px 18px rgba(37, 99, 235, .25) !important;
            font-size: 12px;
            font-weight: 800;
        }

        .tab-pane > table[id] {
            width: 100% !important;
            margin-top: 18px;
            border: 1px solid #d9e2f1 !important;
            border-radius: 14px !important;
            overflow: hidden;
            background: #fff;
        }

            .tab-pane > table[id] thead th {
                background: #f4f7fb !important;
                color: #17365d !important;
                font-size: 12px !important;
            }

        @media (max-width: 992px) {
            .nav-tabs {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .hr-modern-form tr {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .nav-tabs, .hr-modern-form tr {
                grid-template-columns: 1fr;
            }

            .card-tabs > .card-body {
                margin: 0 8px 8px !important;
                padding: 14px !important;
            }
        }


        /* Final HR module polish: asset-style cards, modern tabs, and fixed data grids */
        .card-tabs {
            background: transparent !important;
            border: 0 !important;
        }

            .card-tabs > .card-header {
                margin: 0 0 14px !important;
                padding: 8px !important;
                background: #eaf1fb !important;
                border-radius: 14px !important;
                box-shadow: inset 0 0 0 1px #d9e5f4 !important;
            }

        .nav-tabs {
            gap: 12px !important;
        }

            .nav-tabs .nav-link {
                height: 46px !important;
                border-radius: 10px !important;
                letter-spacing: .01em;
            }

                .nav-tabs .nav-link.active {
                    border-bottom: 3px solid #087c9a !important;
                    box-shadow: 0 9px 18px rgba(15, 23, 42, .12) !important;
                }

        .card-tabs > .card-body {
            position: relative;
            padding: 18px !important;
            border: 1px solid #d9e5f4 !important;
            border-radius: 18px !important;
            background: #fff !important;
        }

        .tab-pane:before {
            display: block;
            margin: 2px 0 4px;
            color: #0b1f3a;
            font-size: 18px;
            font-weight: 800;
        }

        .tab-pane:after {
            content: "Fill in the details below and review the saved records.";
            display: block;
            margin: -2px 0 16px;
            padding-bottom: 14px;
            color: #58708d;
            font-size: 12px;
            border-bottom: 1px solid #d9e5f4;
        }

        .tab-pane > .table:first-child.hr-modern-form {
            padding: 0 6px 4px !important;
            margin-bottom: 22px !important;
        }

        .hr-modern-form tr {
            grid-template-columns: repeat(4, minmax(190px, 1fr)) !important;
            align-items: end !important;
        }

            .hr-modern-form tr:empty {
                display: none !important;
            }

        .hr-form-field label {
            text-transform: none !important;
            color: #17365d !important;
            font-size: 12px !important;
            font-weight: 700 !important;
        }

        .hr-form-field .form-control,
        .hr-form-field select.form-control,
        .hr-form-field input.form-control {
            height: 44px !important;
            min-height: 44px !important;
            border-radius: 10px !important;
            padding: 8px 13px !important;
        }

        .hr-action-cell {
            align-self: end !important;
        }

        .btn.btn-primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            height: 44px !important;
            min-width: 88px;
            padding: 0 22px !important;
        }

        hr {
            border: 0 !important;
            border-top: 1px solid #d9e5f4 !important;
            margin: 20px 0 16px !important;
        }

        /* Top Toolbar Alignment */
        .dataTables_wrapper .row:first-child {
            display: flex !important;
            align-items: center !important;
            justify-content: flex-start !important;
            gap: 15px !important;
            margin-bottom: 15px !important;
        }

        /* Page Length */
        .dataTables_wrapper .dataTables_length {
            display: flex !important;
            align-items: center !important;
            margin: 0 !important;
        }

            .dataTables_wrapper .dataTables_length label {
                display: flex !important;
                align-items: center !important;
                gap: 8px;
                margin: 0 !important;
                font-size: 13px;
            }

        /* Excel Button */
        .dt-buttons {
            margin: 0 !important;
            display: flex !important;
            align-items: center !important;
        }

        .buttons-excel {
            height: 40px !important;
            margin: 0 !important;
        }

        /* Search Box */
        .dataTables_wrapper .dataTables_filter {
            margin-left: auto !important;
            display: flex !important;
            align-items: center !important;
        }

            .dataTables_wrapper .dataTables_filter label {
                display: flex !important;
                align-items: center !important;
                gap: 8px;
                margin: 0 !important;
            }

            .dataTables_wrapper .dataTables_filter input {
                width: 240px !important;
                margin-left: 0 !important;
            }

        .dt-button, button.dt-button, .buttons-excel, .btn-secondary {
            min-height: 38px !important;
            border: 0 !important;
            border-radius: 10px !important;
            padding: 8px 16px !important;
            background: linear-gradient(135deg, #ff9f8e, #fb5f90) !important;
            color: #0b1f3a !important;
            font-weight: 800 !important;
            box-shadow: 0 8px 18px rgba(251, 95, 144, .22) !important;
        }

        /* Critical reset: record grids must remain real tables, not flex rows */
        .tab-pane > table[id],
        .dataTables_wrapper table[id],
        table.dataTable {
            display: table !important;
            width: 100% !important;
            min-width: 760px !important;
            table-layout: auto !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            border: 1px solid #d9e2f1 !important;
            border-radius: 12px !important;
            overflow: hidden !important;
        }

            .tab-pane > table[id] thead,
            .tab-pane > table[id] tbody,
            .dataTables_wrapper table[id] thead,
            .dataTables_wrapper table[id] tbody,
            table.dataTable thead,
            table.dataTable tbody {
                display: table-header-group !important;
                padding: 0px;
            }

            .tab-pane > table[id] tbody,
            .dataTables_wrapper table[id] tbody,
            table.dataTable tbody {
                display: table-row-group !important;
            }

            .tab-pane > table[id] tr,
            .dataTables_wrapper table[id] tr,
            table.dataTable tr {
                display: table-row !important;
                margin: 0 !important;
            }

            .tab-pane > table[id] th,
            .tab-pane > table[id] td,
            .dataTables_wrapper table[id] th,
            .dataTables_wrapper table[id] td,
            table.dataTable th,
            table.dataTable td {
                display: table-cell;
                min-width: auto !important;
                padding: 13px 14px !important;
                border-top: 0 !important;
                border-bottom: 1px solid #edf2f8 !important;
                white-space: nowrap !important;
            }

            .tab-pane > table[id] thead th,
            .dataTables_wrapper table[id] thead th,
            table.dataTable thead th {
                background: #eef6ff !important;
                color: #17365d !important;
                font-size: 12px !important;
                font-weight: 800 !important;
            }

            .tab-pane > table[id] tbody tr:hover td,
            .dataTables_wrapper table[id] tbody tr:hover td,
            table.dataTable tbody tr:hover td {
                background: #f8fbff !important;
            }

        .dataTables_scroll, .dataTables_scrollBody {
            width: 100% !important;
        }

        .dataTables_wrapper .row:nth-child(2) {
            overflow-x: auto !important;
            margin: 0 !important;
        }

        @media (max-width: 992px) {
            .hr-modern-form tr {
                grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
            }

            .dataTables_wrapper .row:first-child {
                align-items: stretch !important;
                flex-direction: column !important;
            }
        }

        @media (max-width: 576px) {
            .hr-modern-form tr {
                grid-template-columns: 1fr !important;
            }

            .card-tabs > .card-body {
                padding: 14px !important;
            }
        }    </style>

    <style>
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

        /* .bank-input,
        .bank-Select {
            min-height: 42px;
            border-radius: 10px;
            border-color: #d9e2ec;
        }*/


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
            height: 35px;
            border-radius: 10px;
            font-weight: 700;
            /* padding-left: 24px;
            padding-right: 24px;*/
            padding: 24px;
            box-shadow: 0 8px 18px rgba(13, 110, 253, 0.22);
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%) !important;
        }    </style>

    <script>

        $(document).ready(function () {

            allocate_bindProcess();
        });

    </script>

    <script src="../Scripts/TrackingSheet/Allocate.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep" style="display: none;" />
    <input id="glass_filep" style="display: none;" />
    <input id="glasscomp_filep" style="display: none;" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-tasks mr-2"></i>
                    Order Allocation & Tracking
                </div>
                <div class="dashboard-subtitle">
                    Allocate loan orders, monitor workflow progress, and track processing status from assignment to completion.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card card-tabs">
            <div class="card-header p-0 pt-1">
                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true"><b>Allocation</b></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false"><b>Update Status</b></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" id="custom-tabs-one-messages-tab" data-toggle="pill" href="#custom-tabs-one-messages" role="tab" aria-controls="custom-tabs-one-messages" aria-selected="false"><b>Report</b></a>
                    </li>
                </ul>
            </div>

            <div class="card-body">
                <div class="tab-content" id="custom-tabs-one-tabContent">
                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                        <div class="bank-form-panel mb-4">
                            <div class="row align-items-end">
                                <div class="col-lg-6 col-md-8 mb-3 mb-md-0">
                                    <label for="bank_name" class="bank-form-label">Process</label>
                                    <select id="allocate_process" name="allocate_process" class="form-control">
                                    </select>
                                </div>
                                <div class="col-lg-3 col-md-4">
                                    <button id="allocate_btnSubmit" class="btn btn-primary bank-submit-btn" onclick="return allocate_GetOrder();">
                                        <i class="fas fa-save mr-1"></i>Get Order
                                           
                                    </button>
                                </div>
                            </div>
                        </div>
                        <hr />
                        <table class="table" id="allocate_table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan1 #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">User</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                        <table class="table" id="table_completed" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan1 #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="custom-tabs-one-messages" role="tabpanel" aria-labelledby="custom-tabs-one-messages-tab">
                        <table class="table" id="table_report" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">User</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deal #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Loan1 #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process End Time</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>--%>
