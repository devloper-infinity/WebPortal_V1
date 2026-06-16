<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SLAReport.aspx.cs" Inherits="WebPortal.Admin.SLAReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <%--    <style>
        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .85;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
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
            color: #fff;
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>--%>

    <style>
    
        .btn-gradient-primary {
            /*  background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

        .my-col-5 {
            width: 45%;
            padding-right: 15px;
            height: 50px;
            font-weight: bold;
        }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 12px;
            height: 40px;
            width: 100%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }

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

        .right-border {
            border-right: 2px solid #000;
            border-color: #047edf;
        }

        /*   .row-overdue {
            background-color: #ffcccc !important;
        }*/

        .col-left {
            font-weight: bold !important;
        }

        #table_slareport tbody tr.row-overdue td {
            /*background-color: #f00000 !important;*/
            color: #f00000 !important;
        }

        #table_slareport tbody tr.row-left td {
            background-color: #d6d6d6 !important; /*ffee32  #ffff24*/
            /* color: yellow !important;*/
        }
    </style>

    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

    <script>
        $(document).ready(function () {

            /*  slareport_bindgrid('01-May-2026', '30-May-2026');*/

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>SLA Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>


    <div class="col-lg-12">
        <div class="card">
            <div class="card sla-card">
                <div class="card-body">
                    <div class="row align-items-end g-4">

                        <!-- From Date -->
                        <div class="col-md-3">
                            <label class="form-label"><b>From Date</b></label>
                            <div class="input-group">
                                <input type="date" id="slareport_fromDate" class="form-control" style="height: 40px;">
                            </div>
                        </div>

                        <!-- To Date -->
                        <div class="col-md-3">
                            <label class="form-label"><b>To Date</b></label>
                            <div class="input-group">
                                <input type="date" id="slareport_toDate" class="form-control" style="height: 40px;">
                            </div>
                        </div>

                        <!-- Get Report -->
                        <div class="col-md-3">
                            <button type="button" class="btn btn-gradient-primary w-100" onclick="loadSLAReport();"><i class="bi bi-bar-chart-line"></i>Get Report</button>
                        </div>

                        <!-- Export -->
                        <div class="col-md-3">
                            <asp:Button ID="btn_exportslareport" Text="Export Excel" class="btn btn-gradient-success flex-grow-1" Style="background: linear-gradient(to right, #ffbf96, #fe7096);" runat="server" OnClick="btn_ExportSLAReport_Click" />
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <div style="overflow: auto;">
                        <%--<table id="table_slareport" class="table table-bordered w-100"><thead></thead></table>--%>

                        <table id="table_slareport" class="table table-bordered w-100">
                            <thead>
                                <!-- Level 1 -->
                                <tr>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Sr #</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Deal #</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Loan #</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Unique Loan #</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Received Date</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Due Date</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Elapsed Time</th>

                                    <th colspan="4" style="text-align: center; font-size: 14px; background: #cce5ff;">Loan Setup</th>
                                    <th colspan="4" style="text-align: center; font-size: 14px; background: #99caff;">Credit</th>
                                    <th colspan="8" style="text-align: center; font-size: 14px; background: #66b0ff;">Compliance</th>

                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Dispatch Date</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Total TAT</th>
                                    <th rowspan="3" style="text-align: center; font-size: 12px;">Business Days</th>
                                </tr>

                                <!-- Level 2 -->
                                <tr>
                                    <th colspan="4" style="text-align: center; font-size: 12px; background: #cce5ff;">Setup</th>

                                    <th colspan="4" style="text-align: center; font-size: 12px; background: #99caff;">Process</th>

                                    <th colspan="4" style="text-align: center; font-size: 12px; background: #66b0ff;">Review</th>
                                    <th colspan="4" style="text-align: center; font-size: 12px; background: #66b0ff;">QC</th>
                                </tr>

                                <!-- Level 3 -->
                                <tr>
                                    <!-- Loan Setup -->
                                    <th style="text-align: center; font-size: 10px; background: #cce5ff;">User</th>
                                    <th style="text-align: center; font-size: 10px; background: #cce5ff;">Start Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #cce5ff;">End Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #cce5ff;">TAT</th>

                                    <!-- Credit -->
                                    <th style="text-align: center; font-size: 10px; background: #99caff;">User</th>
                                    <th style="text-align: center; font-size: 10px; background: #99caff;">Start Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #99caff;">End Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #99caff;">TAT</th>

                                    <!-- Compliance Review -->
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">Reviewer</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">Start Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">End Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">TAT</th>

                                    <!-- Compliance QC -->
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">Q-Cier</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">Start Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">End Date</th>
                                    <th style="text-align: center; font-size: 10px; background: #66b0ff;">TAT Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Main Bands */
        .band-loan {
            background: #cce5ff; /* light blue */
            color: #1e3a8a;
            font-weight: 600;
            text-align: center;
        }

        .band-credit {
            background: #99caff; /* light green */
            color: #065f46;
            font-weight: 600;
            text-align: center;
        }

        .band-compliance {
            background: #66b0ff; /* light yellow */
            color: #92400e;
            font-weight: 600;
            text-align: center;
        }

        /* Sub Bands */
        .band-loan-sub {
            background: #cce5ff;
        }

        .band-credit-sub {
            background: #ecfdf5;
        }

        .band-compliance-sub {
            background: #fffbeb;
        }

        /* Lowest Level */
        .band-loan-light {
            background: #f8fbff;
        }

        .band-credit-light {
            background: #f3fdf8;
        }

        .band-compliance-light {
            background: #fffdf5;
        }

        /* General header styling */
        #table_slareport thead th {
            text-align: center;
            vertical-align: middle;
            font-size: 12px;
        }
    </style>

    <%--  <style>
        /* Container feel */
        #table_slareport {
            border-collapse: separate;
            border-spacing: 0;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
        }

            /* Header styling */
            #table_slareport thead {
                /*   background: linear-gradient(90deg, #4f46e5, #6366f1);*/
                color: white;
            }

                #table_slareport thead th {
                    padding: 14px 16px;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 13px;
                    letter-spacing: 0.5px;
                }

            /* Body cells */
            #table_slareport tbody td {
                padding: 12px 16px;
                border-bottom: 1px solid #f1f1f1;
                font-size: 14px;
                color: #333;
            }

            /* Hover effect */
            #table_slareport tbody tr {
                transition: all 0.2s ease-in-out;
            }

                #table_slareport tbody tr:hover {
                    background: #f8fafc;
                    transform: scale(1.01);
                }

                /* Zebra striping */
                #table_slareport tbody tr:nth-child(even) {
                    background: #fcfcfc;
                }

                /* Rounded bottom */
                #table_slareport tbody tr:last-child td {
                    border-bottom: none;
                }

        /* Optional: small badge style (for status columns etc.) */
        .badge-soft {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            background: #eef2ff;
            color: #4f46e5;
        }
    </style>--%>
</asp:Content>
