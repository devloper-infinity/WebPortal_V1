<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="All.aspx.cs" Inherits="WebPortal.All" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ERP Login Details</title>
    <script src="plugins/jquery/jquery.min.js"></script>
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css" />
    <link rel="stylesheet" href="plugins/datatables-bs4/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="plugins/datatables-select/css/select.bootstrap4.min.css" />
    <link rel="stylesheet" href="dist/css/adminlte.min.css" />
    <script src="plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
    <script src="plugins/datatables-select/js/dataTables.select.min.js"></script>
    <style>
        :root {
            --pn-primary: #1d4ed8;
            --pn-primary-2: #2563eb;
            --pn-cyan: #22c1dc;
            --pn-bg: #f4f7fb;
            --pn-card: #ffffff;
            --pn-text: #0f172a;
            --pn-muted: #64748b;
            --pn-border: #dbe7f5;
            --pn-shadow: 0 18px 45px rgba(15, 23, 42, .10);
            --pn-soft-shadow: 0 10px 28px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--pn-bg) !important;
        }

        .pn-page {
            width: 100%;
            color: var(--pn-text);
        }

        .pn-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 28px 32px;
            margin-bottom: 24px;
            border-radius: 24px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--pn-shadow);
        }

            .pn-hero:before,
            .pn-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .13);
                pointer-events: none;
            }

            .pn-hero:before {
                width: 230px;
                height: 230px;
                right: 100px;
                top: -135px;
            }

            .pn-hero:after {
                width: 340px;
                height: 340px;
                right: -120px;
                bottom: -210px;
            }

        .pn-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            flex: 0 0 50px;
            display: grid;
            place-items: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .24);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .20);
            font-size: 25px;
        }

        .pn-hero-content {
            position: relative;
            z-index: 1;
        }

        .pn-title {
            margin: 0;
            font-size: 19px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .pn-subtitle {
            margin: 10px 0 0;
            font-size: 12px;
            font-weight: 500;
            opacity: .92;
        }

        .pn-card {
            border: 1px solid rgba(219, 231, 245, .95) !important;
            border-radius: 22px !important;
            background: rgba(255, 255, 255, .94) !important;
            box-shadow: var(--pn-soft-shadow) !important;
            margin-bottom: 24px;
            overflow: hidden;
        }

            .pn-card:hover {
                transform: none !important;
            }

            .pn-card .card-body {
                padding: 22px 24px 24px !important;
            }

        .pn-section-title {
            display: inline-flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 18px;
            color: #0f172a;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .01em;
        }

            .pn-section-title i {
                width: 30px;
                height: 30px;
                display: grid;
                place-items: center;
                border-radius: 10px;
                color: #1d4ed8;
                background: #eaf2ff;
                font-size: 16px;
            }

        .main-container {
            width: 100%;
            padding: 0;
        }

        .my-row {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            align-items: end;
            width: 100%;
            margin-bottom: 20px;
        }

        .my-col-3,
        .my-col-12 {
            width: 100%;
            padding-right: 0;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
        }

        .req {
            color: #ef4444;
            font-weight: 900;
            margin-left: 3px;
        }

        .my-input,
        .my-select,
        .form-control,
        .form-select {
            width: 100%;
            min-height: 44px;
            border: 1px solid var(--pn-border) !important;
            border-radius: 13px !important;
            padding: 9px 13px !important;
            color: #0f172a;
            background-color: #fff !important;
            font-size: 13px;
            font-weight: 600;
            box-shadow: 0 1px 2px rgba(15, 23, 42, .03);
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

            .my-input:focus,
            .my-select:focus,
            .form-control:focus,
            .form-select:focus {
                border-color: #60a5fa !important;
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
                outline: none;
            }

        textarea.my-input {
            min-height: 80px;
            resize: none;
        }

        .btn,
        .my-btn {
            border-radius: 13px !important;
            border: 0 !important;
            font-weight: 800 !important;
        }

        .btn-gradient-primary,
        .primary {
            height: 44px;
            min-height: 44px;
            border-radius: 13px !important;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
            color: #fff !important;
            box-shadow: 0 12px 26px rgba(37, 99, 235, .25);
            transition: transform .2s ease, box-shadow .2s ease, filter .2s ease;
        }

            .btn-gradient-primary:hover,
            .primary:hover {
                transform: translateY(-2px);
                filter: brightness(1.03);
                box-shadow: 0 16px 34px rgba(37, 99, 235, .32);
                color: #fff !important;
            }

        .btn-gradient-success,
        .success {
            background: linear-gradient(120deg, #16a34a, #22c55e) !important;
            color: #fff !important;
        }

        .warning {
            background: linear-gradient(120deg, #f59e0b, #f97316) !important;
            color: #fff !important;
        }

        .pn-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

        .top {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }

        .dataTables_length {
            margin-right: 0;
            color: var(--pn-muted);
            font-size: 13px;
            font-weight: 600;
        }

            .dataTables_length select,
            .dataTables_filter input {
                height: 38px;
                border: 1px solid var(--pn-border) !important;
                border-radius: 12px !important;
                outline: none;
                background: #fff;
            }

        .dt-buttons {
            margin-right: auto;
        }

        .dt-button,
        button.dt-button,
        div.dt-button,
        a.dt-button,
        input.dt-button {
            border: 0 !important;
            border-radius: 13px !important;
            padding: 10px 18px !important;
            background: linear-gradient(120deg, #fb7185, #f472b6) !important;
            color: #fff !important;
            font-weight: 800 !important;
            box-shadow: 0 10px 22px rgba(244, 114, 182, .25) !important;
        }

        .dataTables_filter {
            margin-left: auto;
            float: none !important;
            text-align: right !important;
            color: var(--pn-muted);
            font-size: 13px;
            font-weight: 600;
        }

            .dataTables_filter input {
                margin-left: 8px;
            }

        table.dataTable,
        #table_updatePseudoName {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            color: #0f172a;
            font-size: 12px;
        }

            table.dataTable thead th,
            #table_updatePseudoName thead th {
                border: 0 !important;
                text-align: left !important;
                font-size: 12px;
                font-weight: 800;
                letter-spacing: .02em;
                vertical-align: middle;
                white-space: nowrap;
            }

                table.dataTable thead th:first-child,
                #table_updatePseudoName thead th:first-child {
                    border-top-left-radius: 16px;
                }

                table.dataTable thead th:last-child,
                #table_updatePseudoName thead th:last-child {
                    border-top-right-radius: 16px;
                }

                table.dataTable thead th::before,
                table.dataTable thead th::after {
                    display: none !important;
                }

            table.dataTable tbody td,
            #table_updatePseudoName tbody td {
                padding: 5px !important;
                border-top: 1px solid #e8eef7 !important;
                vertical-align: middle;
                background: #fff;
                text-align: left !important;
            }

            table.dataTable tbody tr:hover td,
            #table_updatePseudoName tbody tr:hover td {
                background: #f8fbff !important;
            }

            table.dataTable.no-footer {
                border-bottom: 0 !important;
            }

        .dataTables_info,
        .dataTables_paginate {
            margin-top: 14px;
            color: var(--pn-muted) !important;
            font-size: 13px;
            font-weight: 600;
        }

            .dataTables_paginate .paginate_button {
                border: 1px solid var(--pn-border) !important;
                border-radius: 11px !important;
                margin: 0 3px !important;
                color: #334155 !important;
                background: #fff !important;
            }

                .dataTables_paginate .paginate_button.current,
                .dataTables_paginate .paginate_button.current:hover {
                    background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%) !important;
                    color: #fff !important;
                    border-color: transparent !important;
                }

        #filter_rows input {
            width: 100%;
            height: 32px;
            padding: 5px 100px;
            font-size: 12px;
            box-sizing: border-box;
        }

        #filter_row input,
        #filter_row select {
            height: 30px;
            font-size: 12px;
            padding: 5px 100px;
            border-radius: 10px;
            border: 1px solid var(--pn-border);
        }

        #filter_row {
            background-color: #f8fbff;
        }

        .modal-content {
            border: 0;
            border-radius: 22px;
            box-shadow: var(--pn-shadow);
            overflow: hidden;
        }

        .modal-header {
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            border-bottom: 0;
        }

        .modal-title {
            font-weight: 800;
        }

        .modal-footer {
            border-top: 1px solid var(--pn-border);
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: .95;
            border-radius: 24px;
            width: 192px;
            min-height: 192px;
            z-index: 99999;
            padding: 18px;
            text-align: center;
            background: rgba(255, 255, 255, .92);
            box-shadow: var(--pn-shadow);
        }

        @media (max-width: 992px) {
            .my-row {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .pn-page {
                padding: 16px 12px 28px;
            }

            .pn-hero {
                align-items: flex-start;
                padding: 22px;
            }

            .pn-title {
                font-size: 24px;
            }

            .my-row {
                grid-template-columns: 1fr;
            }

            .top,
            .dataTables_filter {
                width: 100%;
                text-align: left !important;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            new_bindData_pwd();
        });

        function blankForNull(value) {
            return value === null || value === undefined || value === "null" ? "" : value;
        }

        function new_bindData_pwd() {

            $('#load1').show();

            $.ajax({
                url: "All.aspx/GetAllUserERPLoginDetails",
                type: "POST",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (response) {

                    let dataArray = [];

                    try {
                        dataArray = JSON.parse(response.d || "[]");
                    }
                    catch (e) {
                        console.error("Invalid JSON response:", e);
                        dataArray = [];
                    }

                    if ($.fn.DataTable.isDataTable('#table_pwdHistory')) {
                        $('#table_pwdHistory').DataTable().clear().destroy();
                        $('#table_pwdHistory').empty();   // Remove old headers
                    }

                    // Create columns dynamically
                    let columns = [];

                    // Sr. No.
                    columns.push({
                        data: null,
                        title: "Sr. No.",
                        className: "text-center text-nowrap",
                        width: "70px",
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    });

                    // Remaining columns
                    if (dataArray.length > 0) {

                        Object.keys(dataArray[0]).forEach(function (key) {

                            columns.push({
                                data: key,
                                title: key,
                                defaultContent: "",
                                className: "text-nowrap",
                                render: function (data) {
                                    return blankForNull(data);
                                }
                            });

                        });
                    }

                    $('#table_pwdHistory').DataTable({
                        data: dataArray,
                        columns: columns,

                        dom: 'lftp',
                        scrollX: true,
                        destroy: true,
                        paging: true,
                        autoWidth: true,
                        ordering: false,
                        processing: true,
                        select: {
                            style: 'single'
                        },

                        initComplete: function () {
                            $('#load1').hide();
                        }
                    });
                },

                error: function (xhr) {
                    $('#load1').hide();
                    console.error(xhr);
                }
            });

            return false;
        }

    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <div class="loading" id="load1">
                <img src="images/Load_1.gif" alt="Loading" />
                <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
            </div>
            <div class="pn-page">
                <section class="pn-hero">
                    <div class="pn-hero-icon"><i class="fas fa-copy"></i></div>
                    <div class="pn-hero-content">
                        <h1 class="pn-title">ERP Login Details</h1>

                    </div>
                </section>

                <div class="col-lg-12 p-0">
                    <div class="card pn-card">
                        <div class="card-body">
                            <div class="pn-section-title"><i class="bi bi-table"></i><span>Login Details</span></div>
                            <div class="pn-table-wrap">
                                <table class="table" id="table_pwdHistory">
                                    <thead></thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
