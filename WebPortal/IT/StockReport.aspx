<%@ Page Title="" Language="C#" MasterPageFile="~/IT/Admin.Master" AutoEventWireup="true" CodeBehind="StockReport.aspx.cs" Inherits="WebPortal.IT.StockReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --asset-primary: #2563eb;
            --asset-primary-dark: #1e40af;
            --asset-accent: #06b6d4;
            --asset-bg: #f4f7fb;
            --asset-card: #ffffff;
            --asset-text: #1f2937;
            --asset-muted: #6b7280;
            --asset-border: #e5e7eb;
            --asset-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        .asset-page-shell {
            background: var(--asset-bg);
            border-radius: 24px;
            width: 100%;
            padding: 18px;
        }

        .asset-hero {
            position: relative;
            overflow: hidden;
            color: #fff;
            padding: 24px 28px;
            border-radius: 24px;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-primary-dark));
            box-shadow: var(--asset-shadow);
            margin-bottom: 20px;
        }

        .asset-hero:after {
            content: "";
            position: absolute;
            right: -70px;
            top: -80px;
            width: 240px;
            height: 240px;
            border-radius: 50%;
            background: rgba(255,255,255,.13);
        }

        .asset-hero .eyebrow {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1.8px;
            opacity: .8;
            margin-bottom: 6px;
        }

        .asset-hero h4 {
            margin: 0;
            font-weight: 800;
        }

        .asset-hero p {
            margin: 7px 0 0;
            max-width: 720px;
            opacity: .9;
        }

        .asset-panel {
            background: var(--asset-card);
            border: 0;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .06);
            margin-bottom: 20px;
        }

        .asset-panel-header {
            padding: 18px 22px;
            border-bottom: 1px solid var(--asset-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .asset-panel-header h5 {
            margin: 0;
            font-size: 16px;
            font-weight: 800;
            color: var(--asset-text);
        }

        .asset-panel-header span {
            color: var(--asset-muted);
            font-size: 12px;
        }

        .asset-panel-body {
            padding: 22px;
        }

        .asset-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px 16px;
            align-items: start;
        }

        .asset-field label {
            display: block;
            color: #1e3a5f !important;
            font-weight: 600 !important;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .asset-field .form-control, .asset-field select, .asset-field textarea {
            width: 100% !important;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            min-height: 40px;
            padding: 8px 14px;
            font-size: 13px;
            color: #0f172a;
            background: #fff;
            box-shadow: none;
        }

        .asset-field .form-control:focus, .asset-field textarea:focus, .asset-field select:focus {
            border-color: #93c5fd;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
            outline: 0;
        }

        .asset-field textarea {
            min-height: 82px;
            resize: vertical;
        }

        .asset-field.full-width { grid-column: 1 / -1; }
        .asset-field.half-width { grid-column: span 2; }

        .asset-actions {
            grid-column: 1 / -1;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-end;
            margin-top: 6px;
        }

        .asset-actions .btn, .asset-panel .btn {
            border-radius: 999px;
            padding: 9px 20px;
            font-weight: 700;
            box-shadow: none !important;
        }

        .asset-actions .btn-primary, .asset-panel .btn-primary {
            border: 0;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent));
        }

        .asset-actions .btn-secondary {
            border: 0;
            background: #e5e7eb;
            color: #374151;
        }

        .asset-table-wrap { overflow-x: auto; }

        .asset-panel table.dataTable, .asset-panel table.table {
            margin-bottom: 0;
            border-collapse: separate !important;
            border-spacing: 0;
            width: 100% !important;
        }

        .asset-panel table thead th {
            background: #eef5ff !important;
            color: #1e3a8a !important;
            border-top: 0 !important;
            border-bottom: 1px solid #dbeafe !important;
            white-space: nowrap;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .35px;
        }

        .asset-panel table tbody td {
            vertical-align: middle;
            background: #fff !important;
            border-color: #eef2f7 !important;
        }

        .dataTables_length, .dataTables_info, .dataTables_paginate { float: left !important; }
        div.dt-buttons { position: static; padding-left: 20px; float: left; }
        .buttons-excel, .buttons-html5 {
            color: #fff !important;
            box-shadow: none !important;
            background: linear-gradient(135deg, var(--asset-primary), var(--asset-accent)) !important;
            border: 0 !important;
            font-weight: 700 !important;
            border-radius: 999px !important;
            margin: 0 8px !important;
            padding: 7px 16px !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            margin: auto;
            width: 210px;
            height: 210px;
            z-index: 99999;
            background: rgba(255,255,255,.94);
            border-radius: 24px;
            box-shadow: var(--asset-shadow);
            text-align: center;
            padding-top: 35px;
        }

        .loading img { max-width: 72px; }
        .dt-center { text-align: center; }
        .selected-row { background-color: #dbeafe !important; font-weight: bold; }

        .modal-content {
            border: 0;
            border-radius: 20px;
            box-shadow: var(--asset-shadow);
        }

        @media (max-width: 1199px) { .asset-form-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 991px) { .asset-form-grid { grid-template-columns: repeat(2, 1fr); } .asset-field.half-width { grid-column: span 1; } }
        @media (max-width: 575px) { .asset-page-shell { padding: 10px; } .asset-form-grid { grid-template-columns: 1fr; } .asset-field.half-width { grid-column: span 1; } }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            BindStockDetail_Grid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="asset-page-shell">
        <div class="asset-hero">
            <div class="eyebrow">Inventory Report</div>
            <h4><i class="fas fa-copy"></i>&nbsp;&nbsp;Stock Details Report</h4>
            <p>Review stock allocation, device barcodes, serial numbers, desk details, shifts, and remarks.</p>
        </div>

        <div class="asset-panel">
            <div class="asset-panel-header">
                <div>
                    <h5>Stock Details</h5>
                    <span>Complete stock list with keyboard, mouse, monitor, CPU, and shift details.</span>
                </div>
            </div>
            <div class="asset-panel-body">
                <div class="asset-table-wrap">
                    <table class="table" id="table_stockDetails" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Section</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Desk #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Keyboard Barcode</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Keyboard Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Mouse Barcode</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Mouse Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Monitor Barcode</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Monitor Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">CPU Barcode</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">CPU Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">IP Address</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Day</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Eve</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Night</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Is-Dedicated</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
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

     .dataTables_length, .dataTables_info {
         float: left !important;
     }

     label:not(.form-check-label):not(.custom-file-label) {
         font-weight: normal !important;
         border: none !important;
     }

     div.dt-buttons {
         position: static;
         padding-left: 50px;
         float: left;
     }

     .buttons-excel, .buttons-html5 {
          /*color: #fff;
             background-color: #28a745;
         border-color: #28a745;*/
         box-shadow: none;
         background: linear-gradient(to right, #ffbf96, #fe7096);
         border: 0;
         font-weight: bold;
         margin: 0px 10px;
     }

     .table.dataTable th {
         background: linear-gradient(to bottom, #dddbdb, 3%, #fff) !important;
         color: #000;
     }

     .table.dataTable tr td {
         background: none !important;
         background-color: #fff !important;
     }
 </style>

    <script type="text/javascript">
        $(document).ready(function () {

            BindStockDetail_Grid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Stock Details Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <table class="table" id="table_stockDetails" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 200px;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Section</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Desk #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Keyboard Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Keyboard Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Mouse Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Mouse Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Monitor Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Monitor Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">CPU Barcode</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">CPU Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">IP Address</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Day</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Eve</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Night</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Is-Dedicated</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>--%>
