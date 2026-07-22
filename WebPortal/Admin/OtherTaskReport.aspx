<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OtherTaskReport.aspx.cs" Inherits="WebPortal.Admin.OtherTaskReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --otr-primary: #1d4ed8;
            --otr-primary-light: #2563eb;
            --otr-accent: #22c1dc;
            --otr-bg: #f4f7fb;
            --otr-border: #e5edf6;
            --otr-text: #1f2937;
            --otr-muted: #64748b;
        }

        .otr-page {
            background: var(--otr-bg);
            min-height: calc(100vh - 90px);
        }

        .otr-hero {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            padding: 22px 24px;
            margin-bottom: 18px;
            background: linear-gradient(120deg, var(--otr-primary) 0%, var(--otr-primary-light) 65%, var(--otr-accent) 100%);
            color: #fff;
            box-shadow: 0 14px 34px rgba(37, 99, 235, .25);
        }

            .otr-hero:before {
                content: "";
                position: absolute;
                right: -70px;
                top: -70px;
                width: 210px;
                height: 210px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .14);
            }

            .otr-hero:after {
                content: "";
                position: absolute;
                right: 85px;
                bottom: -85px;
                width: 180px;
                height: 180px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .10);
            }

        .otr-hero-content {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        .otr-title-wrap {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .otr-icon-box {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, .18);
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .18);
        }

            .otr-icon-box i {
                font-size: 25px;
                color: #fff;
            }

        .otr-hero h4 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .otr-hero p {
            margin: 5px 0 0;
            color: rgba(255, 255, 255, .88);
            font-size: 13px;
        }

        .otr-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 13px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .24);
            color: #fff;
            font-size: 12px;
            white-space: nowrap;
        }

        .otr-card {
            border: 1px solid var(--otr-border);
            border-radius: 18px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .06);
            margin-bottom: 16px;
        }

        .otr-card-header {
            padding: 16px 18px 0;
        }

        .otr-card-title {
            display: flex;
            align-items: center;
            gap: 9px;
            color: var(--otr-text);
            font-size: 15px;
            font-weight: 800;
            margin: 0;
        }

            .otr-card-title i {
                color: var(--otr-primary-light);
            }

        .otr-card-body {
            padding: 18px;
        }

        .otr-field label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            color: #334155;
            margin-bottom: 7px;
        }

        .otr-field .form-control {
            height: 42px;
            border-radius: 12px;
            border: 1px solid #dbe5f0;
            font-size: 13px;
            box-shadow: none;
            transition: all .2s ease;
        }

            .otr-field .form-control:focus {
                border-color: var(--otr-primary-light);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .10);
            }

        .otr-btn-primary {
            height: 42px;
            width: 100%;
            border: 0;
            border-radius: 12px;
            color: #fff !important;
            font-weight: 800;
            font-size: 13px;
            background: linear-gradient(120deg, var(--otr-primary) 0%, var(--otr-primary-light) 62%, var(--otr-accent) 100%) !important;
            box-shadow: 0 10px 18px rgba(37, 99, 235, .20);
            transition: all .2s ease;
        }

            .otr-btn-primary:hover,
            .otr-btn-primary:focus {
                color: #fff !important;
                transform: translateY(-1px);
                box-shadow: 0 13px 24px rgba(37, 99, 235, .28);
            }

        .otr-table-card .otr-card-body {
            padding-top: 12px;
        }

        #table_otherTaskReport {
            width: 100% !important;
            border-collapse: separate !important;
            border-spacing: 0;
            font-size: 12px;
        }

            #table_otherTaskReport thead th {
                background: #edf3f6 !important;
                color: #263445;
                font-weight: 800;
                border-bottom: 1px solid #d7e3ee !important;
                height: 42px;
                vertical-align: middle;
                text-align: center;
                white-space: nowrap;
            }

            #table_otherTaskReport tbody td {
                vertical-align: middle;
                border-color: #eef2f7;
                white-space: nowrap;
            }

            #table_otherTaskReport tbody tr:hover {
                background: #f8fbff;
            }

        .dataTables_wrapper .top,
        .dataTables_wrapper .dt-top,
        .dataTables_wrapper .row:first-child {
            align-items: center;
        }

        .dataTables_length label,
        .dataTables_filter label {
            font-size: 12px;
            color: var(--otr-muted);
            font-weight: 700;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #dbe5f0;
            border-radius: 10px;
            min-height: 34px;
            font-size: 12px;
            outline: none;
        }

        .dt-buttons .btn,
        .dt-button {
            border-radius: 10px !important;
            border: 0 !important;
            background: linear-gradient(120deg, var(--otr-primary) 0%, var(--otr-primary-light) 70%, var(--otr-accent) 100%) !important;
            color: #fff !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            padding: 7px 13px !important;
            margin-right: 6px !important;
        }

        .dataTables_info,
        .dataTables_paginate {
            font-size: 12px;
            color: var(--otr-muted) !important;
            padding-top: 12px !important;
        }

        .page-item.active .page-link,
        .paginate_button.current {
            background: var(--otr-primary-light) !important;
            border-color: var(--otr-primary-light) !important;
            color: #fff !important;
            border-radius: 9px !important;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(15, 23, 42, .30);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading .otr-loader-box {
                width: 190px;
                min-height: 155px;
                border-radius: 22px;
                background: #fff;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                box-shadow: 0 22px 55px rgba(15, 23, 42, .22);
                color: #334155;
                font-size: 12px;
                font-weight: 800;
                padding: 18px;
            }

            .loading img {
                max-width: 72px;
                margin-bottom: 10px;
            }

        @media (max-width: 767px) {
            .otr-page {
                padding: 12px;
            }

            .otr-hero {
                padding: 18px;
                border-radius: 16px;
            }

            .otr-hero-content {
                align-items: flex-start;
                flex-direction: column;
            }

            .otr-hero h4 {
                font-size: 19px;
            }

            .otr-icon-box {
                width: 48px;
                height: 48px;
            }

            .otr-card-body {
                padding: 14px;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            var userId = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            otherTaskReport_bindGrid(userId);
        });
    </script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <div class="otr-loader-box">
            <img src="../images/Load_1.gif" alt="Loading" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="otr-page">
        <div class="otr-hero">
            <div class="otr-hero-content">
                <div class="otr-title-wrap">
                    <div class="otr-icon-box">
                        <i class="bi bi-list-task"></i>
                    </div>
                    <div>
                        <h4>Other Task Report</h4>
                        <p>Track assigned other task details with date-wise reporting and quick export access.</p>
                    </div>
                </div>
                <div class="otr-chip">
                    <i class="bi bi-graph-up-arrow"></i>
                    Fast Employee Operations
               
                </div>
            </div>
        </div>

        <div class="otr-card">
            <div class="otr-card-header">
                <h5 class="otr-card-title"><i class="bi bi-funnel-fill"></i>Report Filters</h5>
            </div>
            <div class="otr-card-body">
                <div class="row align-items-end g-3">
                    <div class="col-lg-4 col-md-6">
                        <div class="otr-field">
                            <label for="othertaskreport_fromDate">From Date</label>
                            <input type="date" id="pmothertaskreport_fromDate" class="form-control" />
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6">
                        <div class="otr-field">
                            <label for="othertaskreport_toDate">To Date</label>
                            <input type="date" id="pmothertaskreport_toDate" class="form-control" />
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-12">
                        <button type="button" class="btn otr-btn-primary" onclick="pm_loadOtherTaskReport();">
                            <i class="bi bi-bar-chart-line"></i>&nbsp; Get Report
                       
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="otr-card otr-table-card">
            <div class="otr-card-header">
                <h5 class="otr-card-title"><i class="bi bi-table"></i>Report Details</h5>
            </div>
            <div class="otr-card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle" id="table_PMotherTaskReport" style="width: 100%;">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
