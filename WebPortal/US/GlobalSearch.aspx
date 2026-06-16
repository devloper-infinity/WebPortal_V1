<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="GlobalSearch.aspx.cs" Inherits="WebPortal.US.GlobalSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            /* background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);*/
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
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
        }
    </style>


    <style id="condition-clearing-theme-redesign">
        :root {
            --cc-primary: #2563eb;
            --cc-primary-dark: #1d4ed8;
            --cc-primary-soft: #eff6ff;
            --cc-primary-border: #bfdbfe;
            --cc-text: #111827;
            --cc-muted: #6b7280;
            --cc-border: #e5e7eb;
            --cc-bg: #f8fafc;
            --cc-card: #ffffff;
            --cc-radius: 16px;
            --cc-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
        }

        body,
        .content-wrapper {
            background: var(--cc-bg) !important;
        }

        .content-header {
            padding: 18px 18px 0 !important;
        }

            .content-header .container-fluid,
            .content .container-fluid {
                max-width: 100%;
            }

            .content-header .callout,
            .content-header .card,
            .page-title-card,
            .condition-clearing-header {
                border: 0 !important;
                border-radius: 18px !important;
                background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
                color: #fff !important;
                box-shadow: 0 14px 34px rgba(37, 99, 235, 0.22) !important;
                overflow: hidden;
            }

            .content-header h1,
            .content-header h2,
            .content-header h3,
            .content-header h4,
            .content-header h5,
            .content-header h6,
            .content-header b,
            .content-header label,
            .content-header span {
                color: #fff !important;
            }

        .breadcrumb,
        .breadcrumb-item,
        .breadcrumb-item a {
            color: rgba(255,255,255,.88) !important;
            font-weight: 600;
        }

            .breadcrumb-item.active {
                color: #fff !important;
            }

        .card,
        .box,
        .panel,
        .section-card {
            border: 1px solid rgba(226, 232, 240, 0.9) !important;
            border-radius: var(--cc-radius) !important;
            background: var(--cc-card) !important;
            box-shadow: var(--cc-shadow) !important;
            overflow: hidden;
        }

        .card-header,
        .box-header,
        .panel-heading {
            border-bottom: 1px solid var(--cc-border) !important;
            background: linear-gradient(180deg, #ffffff, #f8fbff) !important;
            padding: 16px 20px !important;
        }

        .card-title,
        .box-title,
        .panel-title {
            color: var(--cc-text) !important;
            font-weight: 700 !important;
            letter-spacing: .2px;
        }

        .card-body,
        .box-body,
        .panel-body {
            padding: 22px !important;
        }

        label,
        .control-label {
            color: #374151 !important;
            font-weight: 700 !important;
            font-size: 13px;
            margin-bottom: 7px;
        }

        .form-control,
        input[type="text"],
        input[type="date"],
        input[type="number"],
        input[type="search"],
        select,
        textarea {
            border: 1px solid #dbe3ef !important;
            border-radius: 11px !important;
            background: #fff !important;
            color: var(--cc-text) !important;
            min-height: 40px;
            box-shadow: none !important;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

            .form-control:focus,
            input[type="text"]:focus,
            input[type="date"]:focus,
            input[type="number"]:focus,
            input[type="search"]:focus,
            select:focus,
            textarea:focus {
                border-color: var(--cc-primary) !important;
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
                outline: none !important;
            }

        .btn,
        button,
        input[type="button"],
        input[type="submit"] {
            border-radius: 11px !important;
            font-weight: 700 !important;
            letter-spacing: .1px;
            transition: transform .15s ease, box-shadow .15s ease, background .15s ease;
        }

            .btn:hover,
            button:hover,
            input[type="button"]:hover,
            input[type="submit"]:hover {
                transform: translateY(-1px);
            }

        .btn-primary,
        .btn-info,
        .btn-success,
        .buttons-excel,
        .dt-button,
        input[type="submit"],
        input[type="button"] {
            border-color: var(--cc-primary) !important;
            background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
            color: #fff !important;
            box-shadow: 0 8px 20px rgba(37, 99, 235, .22) !important;
        }

            .btn-primary:hover,
            .btn-info:hover,
            .btn-success:hover,
            .buttons-excel:hover,
            .dt-button:hover,
            input[type="submit"]:hover,
            input[type="button"]:hover {
                border-color: var(--cc-primary-dark) !important;
                background: linear-gradient(135deg, var(--cc-primary-dark), #1e40af) !important;
                color: #fff !important;
            }

        .btn-secondary,
        .btn-default {
            border-color: var(--cc-primary-border) !important;
            background: var(--cc-primary-soft) !important;
            color: var(--cc-primary-dark) !important;
        }

        /* Grid/table theme */
        /*.table-responsive,
        .dataTables_wrapper,
        .grid-wrapper {
            border-radius: 16px !important;
        }

        table,
        .table {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0 !important;
            background: #fff !important;
        }

            .table thead th,
            table.dataTable thead th,
            .gridView th,
            th {
                background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
                color: #fff !important;
                border: none !important;
                font-weight: 700 !important;
                padding: 12px 14px !important;
                white-space: nowrap;
            }

            .table tbody td,
            table.dataTable tbody td,
            .gridView td,
            td {
                border-top: 1px solid #eef2f7 !important;
                color: #374151;
                padding: 11px 14px !important;
                vertical-align: middle !important;
            }

            .table tbody tr:hover,
            table.dataTable tbody tr:hover,
            .gridView tr:hover {
                background: #f8fbff !important;
            }

        .dataTables_filter input,
        .dataTables_length select {
            border-radius: 10px !important;
            border: 1px solid #dbe3ef !important;
            padding: 6px 10px !important;
        }

        .dataTables_paginate .paginate_button {
            border-radius: 9px !important;
            border: 1px solid var(--cc-border) !important;
            color: var(--cc-primary-dark) !important;
            margin: 0 2px !important;
        }

            .dataTables_paginate .paginate_button.current,
            .dataTables_paginate .paginate_button.current:hover {
                background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
                color: #fff !important;
                border-color: var(--cc-primary) !important;
            }*/

        /* Match buttons inside grid with page theme */
        /*table .btn,
        .table .btn,
        .gridView .btn,
        table button,
        table input[type="button"],
        table input[type="submit"],
        table a.btn,
        .table a.btn,
        .gridView a,
        table a[class*="btn"],
        table a[onclick],
        table input[value*="View"],
        table input[value*="Edit"],
        table input[value*="Search"],
        table input[value*="Clear"],
        table input[value*="Details"] {
            border: 1px solid var(--cc-primary) !important;
            border-radius: 9px !important;
            background: var(--cc-primary-soft) !important;
            color: var(--cc-primary-dark) !important;
            font-weight: 700 !important;
            padding: 6px 12px !important;
            text-decoration: none !important;
            box-shadow: none !important;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
        }

            table .btn:hover,
            .table .btn:hover,
            .gridView .btn:hover,
            table button:hover,
            table input[type="button"]:hover,
            table input[type="submit"]:hover,
            table a.btn:hover,
            .table a.btn:hover,
            .gridView a:hover,
            table a[class*="btn"]:hover,
            table a[onclick]:hover {
                background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
                color: #fff !important;
                border-color: var(--cc-primary-dark) !important;
                transform: translateY(-1px);
            }*/
        .dataTables_scrollBody {
            min-height: 160px !important;
            height: auto;
        }

        .dataTables_length, .dataTables_info {
            float: left !important;
            color: var(--ca-muted);
            font-size: 13px;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #374151;
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 10px 20px rgba(37, 99, 235, .24);
                background: linear-gradient(135deg, var(--cc-primary), var(--cc-primary-dark)) !important;
            /*background: linear-gradient(135deg, var(--ca-primary), #7c3aed) !important;*/
            border: 0 !important;
            font-weight: 700;
            border-radius: 999px !important;
            margin: 0 6px;
            padding: 8px 14px !important;
        }

        .table.dataTable {
            border-collapse: separate !important;
            border-spacing: 0;
        }

            .table.dataTable th {
                white-space: nowrap;
                color: #374151;
                background: #f8fafc;
                border-bottom: 1px solid var(--ca-border) !important;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }

            .table.dataTable tr td {
                background: none !important;
                background-color: #fff !important;
                color: var(--ca-text);
                border-color: #eef2f7 !important;
                vertical-align: middle;
            }

            .table.dataTable tbody tr:hover td {
                background-color: #f8fbff !important;
            }

        #table_conAnalysis_wrapper, #table_conAnalysis {
            width: 100% !important;
        }

        .badge,
        .label {
            border-radius: 999px !important;
            padding: 5px 10px !important;
            font-weight: 700 !important;
        }

        @media (max-width: 768px) {
            .content-header {
                padding: 12px 10px 0 !important;
            }

            .card-body,
            .box-body,
            .panel-body {
                padding: 16px !important;
            }

            .table-responsive,
            .dataTables_wrapper {
                overflow-x: auto;
            }
        }
    </style>


    <script>
        $(document).ready(function () {
            us_getloansforglobalsearch();

        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-hand-holding-usd mr-2"></i>
                    <%--  <i class="fas fa-file-invoice-dollar mr-2"></i>--%>
                    Loan Details
                </div>

                <div class="dashboard-subtitle">
                    View and manage loan records, repayment schedules, balances, and transaction history.
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered" style="width: 100%;" id="usglobalsearch_table"></table>

            </div>
        </div>
    </div>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            /*  background-color: #ccc;*/
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

    

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
            color: #fff;
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            us_getloansforglobalsearch();

        });


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Loan Details</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table table-bordered" style="width: 100%;" id="usglobalsearch_table"></table>

            </div>
        </div>
    </div>
</asp:Content>--%>
