<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SecuritizationBillingSent.aspx.cs" Inherits="WebPortal.Admin.SecuritizationBillingSent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style id="st1">
        body {
            background: #f3f6f8;
        }

        .sec-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .sec-hero {
            align-items: center;
            background: linear-gradient(135deg, #0f766e 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .sec-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .sec-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .sec-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .sec-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .sec-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-size: 13px;
            font-weight: 700;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .sec-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

        .sec-btn-primary:hover,
        .sec-btn-primary:focus {
            background: #0b5f59;
            border-color: #0b5f59;
            color: #fff;
        }

        .sec-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
        }

        .sec-btn-soft {
            background: #eef6f5;
            border: 1px solid #cce3df;
            color: #0f5f58;
        }

        .sec-btn-outline {
            background: #fff;
            border: 1px solid #cbd6df;
            color: #263747;
        }

        .sec-btn-danger {
            background: #fff5f5;
            border: 1px solid #f4c7c7;
            color: #b42318;
        }

        .sec-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .sec-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .sec-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .sec-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .sec-panel-body {
            padding: 18px;
        }

        .sec-section-title {
            align-items: center;
            color: #2d3f50;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 0 0 12px;
        }

        .sec-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .sec-field {
            min-width: 0;
        }

        .sec-field-wide {
            grid-column: span 1;
        }

        .sec-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .sec-field .form-control,
        .sec-field select,
        .sec-field textarea {
            border: 1px solid #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .sec-field textarea.form-control {
            min-height: 86px;
            resize: vertical;
        }

        .sec-field .form-control:focus,
        .sec-field select:focus,
        .sec-field textarea:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
            outline: none;
        }

        .sec-required {
            color: #dc3545;
            margin-left: 2px;
        }

        .sec-file-preview {
            background: #f7fbfa;
            border: 1px dashed #bfd8d4;
            border-radius: 6px;
            color: #46596b;
            font-size: 12px;
            margin-top: 8px;
            padding: 8px 10px;
        }

        .sec-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .sec-tabs {
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 8px;
            margin: 0;
            padding: 12px 18px 0;
        }

        .sec-tabs .nav-link {
            border: 1px solid transparent;
            border-radius: 8px 8px 0 0;
            color: #5c6f82;
            font-size: 13px;
            font-weight: 700;
            padding: 10px 14px;
        }

        .sec-tabs .nav-link.active {
            background: #fff;
            border-color: #dce5ec #dce5ec #fff;
            color: #0f5f58;
        }

        .sec-table-toolbar {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
        }

        .sec-table-wrap {
            padding: 0 18px 18px;
            overflow-x: auto;
        }

        #table_NewLoanList,
        #table_ExistingLoanList {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

        #table_NewLoanList thead th,
        #table_ExistingLoanList thead th {
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            color: #263747;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        #table_NewLoanList tbody td,
        #table_ExistingLoanList tbody td {
            background: #fff;
            border-color: #e2e9ef !important;
            color: #263747;
            font-size: 12px;
            vertical-align: middle;
        }

        #table_NewLoanList tbody tr:hover td,
        #table_ExistingLoanList tbody tr:hover td {
            background: #f7fbfa;
        }

        .dataTables_wrapper .dataTables_info,
        .dataTables_wrapper .dataTables_paginate {
            color: #5c6f82;
            font-size: 12px;
            padding: 12px 0 0;
        }

        .dataTables_wrapper .dataTables_paginate {
            float: right !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 6px !important;
            padding: 4px 10px !important;
        }

        .loading {
            align-items: center;
            background: rgba(255,255,255,0.92);
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(20, 33, 45, 0.18);
            color: #263747;
            display: none;
            font-size: 12px;
            font-weight: 700;
            left: 50%;
            min-width: 220px;
            padding: 18px;
            position: fixed;
            text-align: center;
            top: 42%;
            transform: translate(-50%, -50%);
            z-index: 99999;
        }

        .loading img {
            display: block;
            margin: 0 auto 10px;
            max-width: 44px;
        }

        .sec-message-icon {
            align-items: center;
            background: #eef6f5;
            border-radius: 8px;
            color: #0f766e;
            display: flex;
            font-size: 28px;
            height: 58px;
            justify-content: center;
            margin: 4px auto 14px;
            width: 58px;
        }

        @media (max-width: 1199px) {
            .sec-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .sec-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .sec-hero-actions,
            .sec-action-row {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .sec-btn {
                width: 100%;
            }

            .sec-form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>

        $(document).ready(function () {
            secrBillingSent_BindGrid();
        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Operations</div>
                <h1 class="sec-title"><i class="fas fa-copy mr-2"></i>Securitization Billing Sent</h1>
                <p class="sec-subtitle">Review billing records that have already been sent and verify billing period, project, deal, and remarks.</p>
            </div>
            <div class="sec-hero-actions">
                <a href="SecuritizationBilling.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-arrow-left"></i>
                    Back To Billing
                </a>
            </div>
        </div>

        <div class="col-lg-12 p-0">
            <div class="card shadow-sm border-0">
            <div class="card-body">
                <div class="sec-table-wrap"><table class="table" id="table_secrBillingSent">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Billing Type</th>
                            <th class="sort border-top ps-3" style="width: 80px;">Project #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3">Billing Period</th>
                            <th class="sort border-top ps-3">Description</th>
                            <th class="sort border-top ps-3">No of Loans/Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: none;">Billing Sent On</th>
                            <th class="sort border-top ps-3" style="text-align: center;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table></div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
