<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="PendingToUpdateBankDetails.aspx.cs" Inherits="WebPortal.Admin.PendingToUpdateBankDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --bank-primary: #2457e6;
            --bank-cyan: #31c4d7;
            --bank-text: #111827;
            --bank-muted: #64748b;
            --bank-border: #e2e8f0;
            --bank-soft: #f6f9ff;
            --bank-card: #ffffff;
            --bank-shadow: 0 18px 45px rgba(15, 23, 42, .09);
        }

        .loading {
            display: none;
            position: fixed;
            top: 350px;
            left: 50%;
            margin-top: -96px;
            margin-left: -96px;
            opacity: .9;
            border-radius: 25px;
            width: 192px;
            height: 192px;
            z-index: 99999;
            text-align: center;
            color: var(--bank-text);
        }

        .bank-page {
        
            background: linear-gradient(180deg, #f4f8ff 0%, #ffffff 55%);
            min-height: calc(100vh - 80px);
        }

        .bank-hero {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            min-height: 96px;
            margin-bottom: 28px;
            padding: 22px 30px;
            border-radius: 20px;
            color: #fff;
            background: linear-gradient(120deg, #2457e6 0%, #2e73e9 46%, #35c6d7 100%);
            box-shadow: 0 18px 42px rgba(36, 87, 230, .22);
        }

        .bank-hero::before,
        .bank-hero::after {
            content: "";
            position: absolute;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            pointer-events: none;
        }

        .bank-hero::before {
            width: 220px;
            height: 220px;
            right: 72px;
            top: -118px;
        }

        .bank-hero::after {
            width: 132px;
            height: 132px;
            right: -22px;
            bottom: -52px;
        }

        .bank-hero-left {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .bank-hero-icon {
            width: 56px;
            height: 56px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            background: rgba(255, 255, 255, .15);
            border: 1px solid rgba(255, 255, 255, .28);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .20);
            flex-shrink: 0;
        }

        .bank-hero-icon i {
            font-size: 24px;
            color: #fff;
        }

        .bank-hero h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .bank-hero p {
            margin: 6px 0 0;
            font-size: 13px;
            font-weight: 600;
            color: rgba(255, 255, 255, .88);
        }

        .bank-chip {
            position: relative;
            z-index: 1;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            color: #fff;
            font-size: 12px;
            font-weight: 800;
            background: rgba(255, 255, 255, .16);
            border: 1px solid rgba(255, 255, 255, .28);
            white-space: nowrap;
        }

        .bank-panel {
            overflow: hidden;
            border-radius: 20px;
            border: 1px solid var(--bank-border);
            background: var(--bank-card);
            box-shadow: var(--bank-shadow);
        }

        .bank-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 18px 22px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
            border-bottom: 1px solid var(--bank-border);
        }

        .bank-panel-title {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--bank-text);
            font-size: 16px;
            font-weight: 800;
        }

        .bank-panel-title i {
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            color: var(--bank-primary);
            background: #edf4ff;
        }

        .bank-panel-subtitle {
            margin: 3px 0 0 48px;
            color: var(--bank-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .bank-table-wrap {
            padding: 20px 22px 24px;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
            border-radius: 14px;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--bank-muted);
            font-size: 12px;
            font-weight: 600;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: var(--bank-muted);
        }

        div.dt-buttons {
            position: static;
            padding-left: 18px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #fff !important;
            box-shadow: 0 10px 22px rgba(22, 163, 74, .18);
            background: linear-gradient(135deg, #16a34a, #22c55e) !important;
            border: 0 !important;
            border-radius: 12px !important;
            font-weight: 800 !important;
            margin: 0 8px;
            padding: 8px 14px !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
            border: 1px solid #cbd5e1 !important;
            border-radius: 12px !important;
            padding: 8px 12px !important;
            outline: none !important;
            box-shadow: none !important;
        }

        .dataTables_filter input:focus,
        .dataTables_length select:focus {
            border-color: var(--bank-primary) !important;
            box-shadow: 0 0 0 4px rgba(36, 87, 230, .10) !important;
        }

        #table_pendingBankdetails {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0 8px !important;
        }

        #table_pendingBankdetails thead th {
            color: #334155 !important;
            background: #d9ead3 !important;
            border: 0 !important;
            padding: 13px 14px !important;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .02em;
            white-space: nowrap;
        }

        #table_pendingBankdetails thead th:first-child {
            border-top-left-radius: 14px;
            border-bottom-left-radius: 14px;
        }

        #table_pendingBankdetails thead th:last-child {
            border-top-right-radius: 14px;
            border-bottom-right-radius: 14px;
        }

        #table_pendingBankdetails tbody td {
            background: #fff !important;
            border-top: 1px solid #eef2f7 !important;
            border-bottom: 1px solid #eef2f7 !important;
            padding: 14px !important;
            color: var(--bank-text);
            font-size: 13px;
            font-weight: 600;
            vertical-align: middle;
        }

        #table_pendingBankdetails tbody tr td:first-child {
            border-left: 1px solid #eef2f7 !important;
            border-top-left-radius: 14px;
            border-bottom-left-radius: 14px;
            text-align: center;
            color: var(--bank-primary);
            font-weight: 800;
        }

        #table_pendingBankdetails tbody tr td:last-child {
            border-right: 1px solid #eef2f7 !important;
            border-top-right-radius: 14px;
            border-bottom-right-radius: 14px;
        }

        #table_pendingBankdetails tbody tr {
            transition: transform .18s ease, box-shadow .18s ease;
        }

        #table_pendingBankdetails tbody tr:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 28px rgba(15, 23, 42, .08);
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        @media (max-width: 768px) {
            .bank-page {
                padding: 16px;
            }

            .bank-hero,
            .bank-panel-head {
                align-items: flex-start;
                flex-direction: column;
            }

            .bank-hero {
                padding: 20px;
            }

            .bank-hero h1 {
                font-size: 20px;
            }

            .bank-chip {
                align-self: flex-start;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            bindPendingToUpdateBankDetails_Grid();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="bank-page">
        <div class="bank-hero">
            <div class="bank-hero-left">
                <div class="bank-hero-icon">
                    <i class="fas fa-university"></i>
                </div>
                <div>
                    <h1>Pending Bank Accounts</h1>
                    <p>Review employees whose bank details are pending for update.</p>
                </div>
            </div>
            <div class="bank-chip">
                <i class="fas fa-bolt"></i>
                Bank Detail Operations
            </div>
        </div>

        <div class="bank-panel">
            <div class="bank-panel-head">
                <div>
                    <div class="bank-panel-title">
                        <i class="fas fa-list-check"></i>
                        Pending To Update Bank Details
                    </div>
                    <p class="bank-panel-subtitle">Employee bank account update pending list</p>
                </div>
            </div>

            <div class="bank-table-wrap">
                <table class="table" id="table_pendingBankdetails" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project Manager</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        $(document).ready(function () {

            bindPendingToUpdateBankDetails_Grid();

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Pending Bank Accounts</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="table_pendingBankdetails" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align:center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project Manager</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>--%>
