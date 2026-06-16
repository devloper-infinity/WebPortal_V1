<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="ViewBilling.aspx.cs" Inherits="WebPortal.Search.ViewBilling" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --track-bg: #f4f6f8;
            --track-surface: #ffffff;
            --track-border: #d7e2ea;
            --track-soft: #edf3f6;
            --track-text: #1f2937;
            --track-muted: #64748b;
            --track-primary: #0f766e;
            --track-primary-dark: #115e59;
            --track-accent: #2563eb;
            --track-success: #15803d;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            align-items: center;
            justify-content: center;
            background: rgba(248, 250, 252, .74);
            backdrop-filter: blur(2px);
            text-align: center;
        }

            .loading img {
                width: 64px;
                height: 64px;
                display: block;
                margin: 0 auto 10px;
            }

            .loading div {
                color: var(--track-text);
                font-size: 12px;
                font-weight: 700;
            }

        .billing-page {
            min-height: calc(100vh - 72px);
            padding: 18px;
            background: var(--track-bg);
        }

        .billing-header,
        .billing-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .billing-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 14px;
            padding: 14px 18px;
            background: var(--track-surface);
            border: 1px solid var(--track-border);
            border-left: 4px solid var(--track-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .billing-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--track-text);
            font-size: 22px;
            font-weight: 700;
        }

            .billing-title i {
                width: 36px;
                height: 36px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                background: var(--track-primary);
                border-radius: 8px;
                font-size: 15px;
            }

        .billing-context {
            margin-top: 2px;
            color: var(--track-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .billing-shell {
            background: var(--track-surface);
            border: 1px solid var(--track-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .billing-filter-panel {
            padding: 16px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--track-soft);
        }

        .billing-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .billing-field {
            margin-bottom: 0;
        }

            .billing-field label {
                display: block;
                margin-bottom: 5px;
                color: var(--track-text);
                font-size: 12px;
                font-weight: 700 !important;
                line-height: 1.25;
                border: 0 !important;
            }

            .billing-field .form-control {
                width: 100%;
                min-height: 38px;
                border: 1px solid #ccd6df;
                border-radius: 7px;
                color: var(--track-text);
                font-size: 13px;
                box-shadow: none;
            }

                .billing-field .form-control:focus {
                    border-color: var(--track-primary);
                    box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
                }

        .billing-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-billing-primary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            border-radius: 7px;
            color: #ffffff;
            background: var(--track-primary);
            border-color: var(--track-primary);
            font-weight: 700;
        }

            .btn-billing-primary:hover,
            .btn-billing-primary:focus {
                color: #ffffff;
                background: var(--track-primary-dark);
                border-color: var(--track-primary-dark);
            }

        .billing-grid-panel {
            padding: 16px;
        }

        .billing-grid-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

            .billing-grid-header h2 {
                display: flex;
                align-items: center;
                gap: 8px;
                margin: 0;
                color: var(--track-text);
                font-size: 15px;
                font-weight: 700;
            }

                .billing-grid-header h2 i {
                    color: var(--track-accent);
                }

        .billing-grid-subtitle {
            margin: 0;
            color: var(--track-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .billing-table-frame {
            border: 1px solid var(--track-soft);
            border-radius: 8px;
            overflow: hidden;
            background: #ffffff;
        }

        .billing-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        #costingTable {
            width: 100% !important;
            min-width: 5200px;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #costingTable thead th {
                color: var(--track-text);
                background: #edf3f6 !important;
                background-image: none !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid #d7e2ea !important;
                font-size: 12px;
                font-weight: 700;
                white-space: nowrap;
                vertical-align: middle;
                text-align: center;
            }

            #costingTable tbody td {
                color: var(--track-text);
                background: #ffffff !important;
                font-size: 12px;
                vertical-align: middle;
                white-space: nowrap;
            }

            #costingTable tbody tr:hover td {
                background: #f8fbfb !important;
            }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_wrapper .dataTables_filter {
            text-align: left;
        }

            .dataTables_wrapper .dataTables_filter label,
            .dataTables_wrapper .dataTables_length label {
                color: var(--track-muted);
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
            color: var(--track-muted);
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate {
            padding-top: 8px;
        }

        .dataTables_wrapper .paginate_button {
            border-radius: 7px !important;
        }

        .dataTables_wrapper .dt-buttons,
        div.dt-buttons {
            float: none;
            padding-left: 0;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #ffffff !important;
            background: var(--track-accent) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            box-shadow: none !important;
            margin: 0 8px 8px 0;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            border: none !important;
        }

        @media (max-width: 991px) {
            .billing-filter-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }
        }

        @media (max-width: 575px) {
            .billing-page {
                padding: 12px;
            }

            .billing-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .billing-title {
                font-size: 19px;
            }

            .billing-filter-grid {
                grid-template-columns: 1fr;
            }

            .billing-actions,
            .billing-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            //BindInternal_Costing_Report(735, "2025-12-01", "2025-12-05")
            ViewBilling_BindProject();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="billing-page">
        <div class="loading" id="load1">
            <div>
                <img src="../images/Load_1.gif" alt="Loading" />
                <div>One moment, please . . . .</div>
            </div>
        </div>

        <div class="billing-header">
            <div>
                <h1 class="billing-title"><i class="fas fa-file-invoice-dollar"></i><span>Internal Costing Report</span></h1>
                <div class="billing-context">Billing and production costing summary</div>
            </div>
        </div>

        <div class="billing-shell">
            <div class="billing-filter-panel">
                <div class="billing-filter-grid">
                    <div class="form-group billing-field">
                        <label for="ViewBilling_projectno">Project #</label>
                        <select id="ViewBilling_projectno" name="ViewBilling_projectno" class="form-control">
                            <option value="">Select</option>
                        </select>
                    </div>
                    <div class="form-group billing-field">
                        <label for="ViewBilling_FromDate">From Date</label>
                        <input type="date" class="form-control" id="ViewBilling_FromDate" name="ViewBilling_FromDate" />
                    </div>
                    <div class="form-group billing-field">
                        <label for="ViewBilling_ToDate">To Date</label>
                        <input type="date" class="form-control" id="ViewBilling_ToDate" name="ViewBilling_ToDate" />
                    </div>
                    <div class="billing-actions">
                        <button class="btn btn-billing-primary" type="button" id="ViewBilling_btnShow" onclick="return ViewBilling_btnShowDetails();">
                            <i class="fas fa-search"></i><span>Show</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="billing-grid-panel">
                <div class="billing-grid-header">
                    <div>
                        <h2><i class="fas fa-table"></i><span>Costing Results</span></h2>
                        <p class="billing-grid-subtitle">Production, abstractor, tax, other charges, and credit card payment details</p>
                    </div>
                </div>

                <div class="billing-table-frame">
                    <div class="billing-table-wrap">
                        <table class="table table-hover table-sm" id="costingTable">
                            <thead>
                                <tr>
                                    <th rowspan="3">Sr. #</th>
                                    <th rowspan="3">Order No</th>
                                    <th rowspan="3">Received Date</th>
                                    <th rowspan="3">Search Engine</th>
                                    <th rowspan="3">Search Engine Type</th>
                                    <th rowspan="3">State</th>
                                    <th rowspan="3">County</th>
                                    <th rowspan="3">Dispatch Date</th>
                                    <th rowspan="3">No of Documents</th>
                                    <th rowspan="3">No of Pages</th>
                                    <th rowspan="3">Tax Information</th>
                                    <th rowspan="3">Taxes Calling (Y/N)</th>
                                    <th rowspan="3">Borrower Name</th>
                                    <th rowspan="3">Property Address</th>
                                    <th rowspan="3">Online/ Offline</th>
                                    <th rowspan="3">Property Type</th>
                                    <th rowspan="3">Product Type</th>
                                    <th rowspan="3">Process Done</th>
                                    <th rowspan="3">Status</th>
                                    <th colspan="28">Production Costing</th>
                                    <th colspan="5">Abstractory Costing</th>
                                    <th rowspan="3">Total Cost</th>
                                    <th colspan="6">Credit Card Payment Information</th>
                                </tr>
                                <tr>
                                    <th colspan="3">Search Cost</th>
                                    <th colspan="8">Search Copy Cost</th>
                                    <th colspan="3">Judgement Search Cost</th>
                                    <th colspan="8">Judgement Search Copy Cost</th>
                                    <th colspan="2">Tax Charges</th>
                                    <th colspan="2">Other Charges</th>
                                    <th rowspan="2">Remark</th>
                                    <th rowspan="2">Production</th>
                                    <th>Search Cost</th>
                                    <th colspan="2">Search Copy Cost</th>
                                    <th>Other Cost</th>
                                    <th rowspan="2">Abstractor Cost</th>
                                    <th colspan="6"></th>
                                </tr>
                                <tr>
                                    <th>No of Searches Made</th>
                                    <th>Cost/Search</th>
                                    <th>Search Total Cost</th>
                                    <th>Costing pattern</th>
                                    <th>No. Of Pages/Doc</th>
                                    <th>Cost/Page or Doc</th>
                                    <th>Total</th>
                                    <th>No. Of Pages/Doc</th>
                                    <th>Cost/Page or Doc</th>
                                    <th>Total</th>
                                    <th>Search Copy Cost Total</th>
                                    <th>No of Searches Made</th>
                                    <th>Cost/Search</th>
                                    <th>Judgement Search Total Cost</th>
                                    <th>Costing Pattern</th>
                                    <th>No. Of Pages/Doc</th>
                                    <th>Cost/Page or Doc</th>
                                    <th>Total</th>
                                    <th>No. Of Pages/Doc</th>
                                    <th>Cost/Page or Doc</th>
                                    <th>Total</th>
                                    <th>Judgement Search Copy Cost Total</th>
                                    <th>Desription</th>
                                    <th>Amount</th>
                                    <th>Desription</th>
                                    <th>Amount</th>
                                    <th>Amount</th>
                                    <th>No of Pages</th>
                                    <th>Total</th>
                                    <th>Amount</th>
                                    <th>Name of the Card</th>
                                    <th>Credit Card No</th>
                                    <th>Name of the Plant</th>
                                    <th>Searching Amount</th>
                                    <th>Downloading Amount</th>
                                    <th>Valid Upto</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
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
            /*     background-color: #28a745;
            border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*    background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>
        $(document).ready(function () {
            //BindInternal_Costing_Report(735, "2025-12-01", "2025-12-05")
            ViewBilling_BindProject();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Internal Costing Report</b></h6>
                </div>
            </div>
        </div>
    </div>


    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>Project #:</b></td>
                        <td>
                            <select id="ViewBilling_projectno" name="ViewBilling_projectno" class="form-control" style="width: 200px;">
                                <option value="">Select</option>
                            </select>
                        </td>

                        <td><b>From Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="ViewBilling_FromDate" name="ViewBilling_FromDate" style="width: 200px;" />
                        </td>
                        <td><b>To Date :</b></td>
                        <td>
                            <input type="date" class="form-control" id="ViewBilling_ToDate" name="ViewBilling_ToDate" style="width: 200px;" />
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="ViewBilling_btnShow" onclick="return ViewBilling_btnShowDetails();">Show</button>
                        </td>
                    </tr>
                </table>

                <table class="table table-bordered" id="costingTable">
                    <thead>
                        <tr>
                            <th rowspan="3">Sr. #</th>
                            <th rowspan="3">Order No</th>
                            <th rowspan="3">Received Date</th>
                            <th rowspan="3">Search Engine</th>
                            <th rowspan="3">Search Engine Type</th>
                            <th rowspan="3">State</th>
                            <th rowspan="3">County</th>
                            <th rowspan="3">Dispatch Date</th>
                            <th rowspan="3">No of Documents</th>
                            <th rowspan="3">No of Pages</th>
                            <th rowspan="3">Tax Information</th>
                            <th rowspan="3">Taxes Calling (Y/N)</th>
                            <th rowspan="3">Borrower Name</th>
                            <th rowspan="3">Property Address</th>
                            <th rowspan="3">Online/ Offline</th>
                            <th rowspan="3">Property Type</th>
                            <th rowspan="3">Product Type</th>
                            <th rowspan="3">Process Done</th>
                            <th rowspan="3">Status</th>
                            <th colspan="28">Production Costing</th>
                            <th colspan="5">Abstractory Costing</th>
                            <th rowspan="3">Total Cost</th>
                            <th colspan="6">Credit Card Payment Information</th>
                        </tr>
                        <tr>
                            <th colspan="3">Search Cost</th>
                            <th colspan="8">Search Copy Cost</th>
                            <th colspan="3">Judgement Search Cost</th>
                            <th colspan="8">Judgement Search Copy Cost</th>
                            <th colspan="2">Tax Charges</th>
                            <th colspan="2">Other Charges</th>
                            <th rowspan="2">Remark</th>
                            <th rowspan="2">Production</th>
                            <th>Search Cost</th>
                            <th colspan="2">Search Copy Cost</th>
                            <th>Other Cost</th>
                            <th rowspan="2">Abstractor Cost</th>
                            <th colspan="6"></th>
                        </tr>
                        <tr>
                            <th>No of Searches Made</th>
                            <th>Cost/Search</th>
                            <th>Search Total Cost</th>
                            <th>Costing pattern</th>
                            <th>No. Of Pages/Doc</th>
                            <th>Cost/Page or Doc</th>
                            <th>Total</th>
                            <th>No. Of Pages/Doc</th>
                            <th>Cost/Page or Doc</th>
                            <th>Total</th>
                            <th>Search Copy Cost Total</th>
                            <th>No of Searches Made</th>
                            <th>Cost/Search</th>
                            <th>Judgement Search Total Cost</th>
                            <th>Costing Pattern</th>
                            <th>No. Of Pages/Doc</th>
                            <th>Cost/Page or Doc</th>
                            <th>Total</th>
                            <th>No. Of Pages/Doc</th>
                            <th>Cost/Page or Doc</th>
                            <th>Total</th>
                            <th>Judgement Search Copy Cost Total</th>
                            <th>Desription</th>
                            <th>Amount</th>
                            <th>Desription</th>
                            <th>Amount</th>
                            <th>Amount</th>
                            <th>No of Pages</th>
                            <th>Total</th>
                            <th>Amount</th>
                            <th>Name of the Card</th>
                            <th>Credit Card No</th>
                            <th>Name of the Plant</th>
                            <th>Searching Amount</th>
                            <th>Downloading Amount</th>
                            <th>Valid Upto</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

</asp:Content>--%>
