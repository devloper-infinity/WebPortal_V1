<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SLAReport.aspx.cs" Inherits="WebPortal.Admin.SLAReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <style>
        :root {
            --ud-primary: #2563eb;
            --ud-primary-dark: #1d4ed8;
            --ud-accent: #22c1dc;
            --ud-bg: #f5f7fb;
            --ud-card: #ffffff;
            --ud-text: #0f172a;
            --ud-muted: #64748b;
            --ud-border: #e2e8f0;
            --ud-soft: #eff6ff;
            --ud-shadow: 0 18px 45px rgba(15, 23, 42, .08);
        }

        body {
            background: var(--ud-bg);
        }

        .ud-page {
            width: 100%;
        }

        .ud-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 28px;
            border-radius: 22px;
            color: #fff;
            background: linear-gradient(120deg, #1d4ed8 0%, #2563eb 65%, #22c1dc 100%);
            box-shadow: var(--ud-shadow);
        }

            .ud-hero:before,
            .ud-hero:after {
                content: "";
                position: absolute;
                border-radius: 999px;
                background: rgba(255, 255, 255, .12);
            }

            .ud-hero:before {
                width: 220px;
                height: 220px;
                right: 70px;
                top: -120px;
            }

            .ud-hero:after {
                width: 300px;
                height: 300px;
                right: -90px;
                bottom: -170px;
            }

        .ud-hero-icon {
            position: relative;
            z-index: 1;
            width: 50px;
            height: 50px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 18px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .22);
            font-size: 24px;
        }

        .ud-hero-content {
            position: relative;
            z-index: 1;
        }

        .ud-title {
            margin: 0;
            font-size: 19px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .ud-subtitle {
            margin: 8px 0 0;
            font-size: 12px;
            opacity: .9;
        }

        .ud-card {
            margin-top: 22px;
            padding: 22px;
            border: 1px solid var(--ud-border);
            border-radius: 22px;
            background: var(--ud-card);
            box-shadow: var(--ud-shadow);
        }

        .ud-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 18px;
            color: var(--ud-text);
            font-size: 16px;
            font-weight: 800;
        }

            .ud-section-title i {
                width: 34px;
                height: 34px;
                display: inline-grid;
                place-items: center;
                border-radius: 12px;
                background: var(--ud-soft);
                color: var(--ud-primary);
            }

        .ud-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 16px;
            align-items: end;
        }

        label,
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--ud-muted);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: .02em;
        }

        .form-control,
        .form-select,
        select,
        input[type="date"] {
            width: 100%;
            height: 46px !important;
            border: 1px solid var(--ud-border) !important;
            padding: 9px 14px;
            border-radius: 14px !important;
            font-size: 13px;
            color: var(--ud-text);
            background-color: #fff;
            outline: none;
            box-shadow: none !important;
            transition: border-color .18s ease, box-shadow .18s ease, transform .18s ease;
        }

            .form-control:focus,
            .form-select:focus,
            select:focus,
            input[type="date"]:focus {
                border-color: var(--ud-primary) !important;
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12) !important;
            }

        .btn,
        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 0 18px;
            border: 0 !important;
            border-radius: 14px !important;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            cursor: pointer;
            transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
        }

            .btn:hover,
            .my-btn:hover {
                transform: translateY(-1px);
                text-decoration: none;
            }

        .btn-gradient-primary,
        .btn-primary,
        .primary {
            background: linear-gradient(135deg, var(--ud-primary), var(--ud-accent)) !important;
            color: #fff !important;
            box-shadow: 0 12px 24px rgba(37, 99, 235, .24);
        }

            .btn-gradient-primary:hover,
            .btn-primary:hover,
            .primary:hover {
                color: #fff !important;
                box-shadow: 0 16px 30px rgba(37, 99, 235, .32);
            }

        .btn-gradient-success,
        .buttons-excel {
            background: linear-gradient(to right, #ffbf96, #fe7096) !important;
            color: #fff !important;
            box-shadow: 0 12px 24px rgba(254, 112, 150, .24) !important;
        }

        .ud-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 18px;
            background: #fff;
        }

            .ud-table-wrap table {
                width: 100% !important;
                margin: 0 !important;
                border-collapse: separate !important;
                border-spacing: 0;
                white-space: nowrap;
            }

            .ud-table-wrap thead th,
            .table.dataTable thead th {
                border: 0 !important;
              
                font-size: 12px !important;
                font-weight: 900 !important;
                text-align: center !important;
                vertical-align: middle !important;
                letter-spacing: .02em;
            }

            .ud-table-wrap tbody td,
            .table.dataTable tbody td {
                border-bottom: 1px solid var(--ud-border) !important;
                color: #334155;
                font-size: 13px;
                vertical-align: middle;
                background: #fff;
            }

            .ud-table-wrap tbody tr:hover td,
            .table.dataTable tbody tr:hover td {
                background: #f8fbff !important;
            }

        table.dataTable thead th::before,
        table.dataTable thead th::after {
            display: none !important;
        }

        .top,
        div.dt-buttons {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            padding-bottom: 12px;
            float: none !important;
            position: static !important;
            padding-left: 0 !important;
        }

        .dataTables_filter {
            margin-left: auto;
        }

            .dataTables_filter input,
            .dataTables_length select {
                min-height: 34px !important;
                height: 34px !important;
                border: 1px solid var(--ud-border) !important;
                border-radius: 12px !important;
                padding: 6px 10px;
                font-size: 12px;
                outline: none;
            }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 22px;
            width: 210px;
            min-height: 190px;
            text-align: center;
            background: rgba(255,255,255,.92);
            border: 1px solid var(--ud-border);
            border-radius: 24px;
            box-shadow: var(--ud-shadow);
            z-index: 99999;
        }

        @media (max-width: 991px) {
            .ud-page {
                padding: 16px;
            }

            .ud-filter-grid {
                grid-template-columns: repeat(2, minmax(160px, 1fr));
            }

            .dataTables_filter {
                margin-left: 0;
            }
        }

        @media (max-width: 575px) {
            .ud-hero {
                align-items: flex-start;
                padding: 20px;
            }

            .ud-title {
                font-size: 20px;
            }

            .ud-filter-grid {
                grid-template-columns: 1fr;
            }
        }


        #table_slareport thead th {
            min-width: 92px;
        }

        #table_slareport thead tr:first-child th[colspan],
        #table_slareport thead tr:nth-child(2) th,
        #table_slareport thead tr:nth-child(3) th {
          
            
        }

        #table_slareport tbody tr.row-overdue td {
            color: #ef4444 !important;
            font-weight: 700;
        }

        #table_slareport tbody tr.row-left td {
            background-color: #f1f5f9 !important;
            font-weight: 700;
        }

        .right-border {
            border-right: 2px solid var(--ud-primary) !important;
        }

        .col-left {
            font-weight: 800 !important;
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

    <div class="ud-page">
        <section class="ud-hero">
            <div class="ud-hero-icon"><i class="bi bi-bar-chart-line-fill"></i></div>
            <div class="ud-hero-content">
                <h1 class="ud-title">SLA Report</h1>
                <p class="ud-subtitle">Review SLA timeline, TAT and process performance by date range.</p>
            </div>
        </section>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-sliders"></i><span>Report Filters</span></div>
            <div class="ud-filter-grid">
                <div>
                    <label class="form-label" for="slareport_fromDate">From Date</label>
                    <input type="date" id="slareport_fromDate" class="form-control" />
                </div>
                <div>
                    <label class="form-label" for="slareport_toDate">To Date</label>
                    <input type="date" id="slareport_toDate" class="form-control" />
                </div>
                <div>
                    <label>&nbsp;</label>
                    <button type="button" class="btn btn-gradient-primary w-100" onclick="loadSLAReport();"><i class="bi bi-bar-chart-line"></i>Get Report</button>
                </div>
                <div>
                    <label>&nbsp;</label>
                    <asp:Button ID="btn_exportslareport" Text="Export Excel" class="btn btn-gradient-success w-100" runat="server" OnClick="btn_ExportSLAReport_Click" />
                </div>
            </div>
        </div>

        <div class="ud-card">
            <div class="ud-section-title"><i class="bi bi-table"></i><span>SLA Report Results</span></div>
            <div class="ud-table-wrap">
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
</asp:Content>
