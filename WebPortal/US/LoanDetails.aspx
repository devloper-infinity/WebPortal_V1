<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="LoanDetails.aspx.cs" Inherits="WebPortal.US.LoanDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        :root {
            --ca-primary: #2563eb;
            --ca-primary-dark: #1d4ed8;
            --ca-primary-soft: #eff6ff;
            --ca-success: #16a34a;
            --ca-success-dark: #15803d;
            --ca-bg: #f5f7fb;
            --ca-surface: #ffffff;
            --ca-text: #111827;
            --ca-muted: #6b7280;
            --ca-border: #e5e7eb;
            --ca-ring: rgba(37, 99, 235, .18);
            --ca-shadow: 0 18px 45px rgba(15, 23, 42, .10);
            --ca-radius-lg: 20px;
            --ca-radius-md: 12px;
        }

        .loading {
            display: flex;
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            z-index: 200000;
            background: rgba(15, 23, 42, .30);
            backdrop-filter: blur(4px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading img {
                width: 74px;
                height: 74px;
                padding: 12px;
                background: var(--ca-surface);
                border-radius: 18px;
                box-shadow: var(--ca-shadow);
            }

            .loading div {
                display: inline-block;
                margin-top: 12px;
                padding: 8px 14px;
                color: var(--ca-text);
                background: var(--ca-surface);
                border-radius: 999px;
                box-shadow: 0 8px 25px rgba(15, 23, 42, .12);
            }

        .condition-page {
            width: 100%;
            background: var(--ca-bg);
            min-height: calc(100vh - 80px);
        }

        .condition-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px;
            margin-bottom: 18px;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            border-radius: var(--ca-radius-lg);
            box-shadow: var(--ca-shadow);
            overflow: hidden;
            position: relative;
        }

            .condition-hero:after {
                content: "";
                position: absolute;
                right: -64px;
                top: -64px;
                width: 190px;
                height: 190px;
                border-radius: 999px;
                background: rgba(255, 255, 255, .15);
            }

        .condition-title-wrap {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .condition-title-icon {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: rgba(255, 255, 255, .18);
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .20);
            font-size: 20px;
        }

        .condition-title {
            margin: 0;
            font-size: 24px;
            line-height: 1.2;
            font-weight: 800;
            letter-spacing: -.02em;
        }

        .condition-subtitle {
            margin: 4px 0 0;
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
        }

        .condition-card {
            width: 100%;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-lg);
            background: var(--ca-surface);
            box-shadow: 0 14px 35px rgba(15, 23, 42, .07);
            overflow: hidden;
        }

        .condition-card-header {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-bottom: 1px solid var(--ca-border);
            background: linear-gradient(180deg, #fff 0%, #f8fafc 100%);
        }

        .condition-card-title {
            margin: 0;
            font-size: 16px;
            font-weight: 750;
            color: var(--ca-text);
        }

        .condition-card-hint {
            margin: 3px 0 0;
            color: var(--ca-muted);
            font-size: 12px;
        }

        .condition-card-body {
            padding: 18px 20px 22px;
        }

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
            background: linear-gradient(135deg, var(--ca-primary), #7c3aed) !important;
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

        .swal2-container {
            z-index: 200000 !important;
        }

        .custom-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            inset: 0;
            width: 100%;
            height: 100%;
            overflow-y: auto;
            padding: 28px 16px;
            background: rgba(15, 23, 42, .58);
            backdrop-filter: blur(6px);
        }

        .custom-modal-content {
            background: var(--ca-surface);
            margin: 0 auto;
            width: min(980px, 96vw);
            border: 1px solid rgba(255, 255, 255, .5);
            border-radius: 24px;
            box-shadow: 0 28px 70px rgba(15, 23, 42, .28);
            overflow: hidden;
            animation: modalIn .18s ease-out;
        }

        @keyframes modalIn {
            from {
                transform: translateY(12px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .custom-modal-header {
            padding: 18px 22px;
            background: linear-gradient(135deg, #1d4ed8 0%, #4338ca 55%, #7c3aed 100%) !important;
            font-weight: 700;
            display: flex;
            font-size: 16px;
            color: white;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

            .custom-modal-header h5 {
                margin: 0;
                font-size: 18px;
                font-weight: 800;
                line-height: 1.3;
            }

        #ana_popupheader {
            display: inline-block;
            margin-left: 6px;
            font-weight: 500 !important;
            color: rgba(255, 255, 255, .86);
            font-size: 16px !important;
        }

        .custom-modal-body {
            padding: 22px;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .analysiscon-container {
            width: 100%;
        }

        .close-btn {
            cursor: pointer;
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            background: rgba(255, 255, 255, .16);
            color: #fff;
            font-size: 26px;
            line-height: 1;
            transition: .16s ease;
        }

            .close-btn:hover {
                background: rgba(255, 255, 255, .26);
                transform: rotate(90deg);
            }

        .my-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
        }

        .my-col-3, .my-col-4, .my-col-6, .my-col-12 {
            padding-right: 0;
        }

        .my-col-3 {
            flex: 1 1 220px;
            max-width: calc(25% - 12px);
        }

        .my-col-4 {
            flex: 1 1 260px;
            max-width: calc(33.333% - 11px);
        }

        .my-col-6 {
            flex: 1 1 360px;
            max-width: calc(50% - 8px);
        }

        .my-col-12 {
            flex: 1 1 100%;
            width: 100%;
            max-width: 100%;
        }

        .my-row label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            letter-spacing: .01em;
            color: #374151;
        }

        .my-input, .my-select, .my-textarea {
            width: 100%;
            border: 1px solid var(--ca-border);
            padding: 9px 11px;
            border-radius: 12px;
            font-size: 13px;
            color: var(--ca-text);
            background-color: #fff;
            transition: border-color .16s ease, box-shadow .16s ease, background-color .16s ease;
        }

        .my-input, .my-select {
            height: 40px;
        }

        .my-textarea {
            min-height: 88px;
            resize: vertical;
        }

            .my-input[readonly], .my-textarea[readonly] {
                color: #4b5563;
                background: #f9fafb;
            }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: var(--ca-primary);
                box-shadow: 0 0 0 4px var(--ca-ring);
                outline: none;
            }

        .section-title-line {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 800;
            margin: 22px 0 14px;
            color: var(--ca-primary-dark);
        }

            .section-title-line:after {
                content: "";
                flex: 1;
                height: 1px;
                background: linear-gradient(90deg, rgba(37, 99, 235, .28), transparent);
            }

            .section-title-line i {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-right: 0;
                font-size: 15px;
                border-radius: 10px;
                color: var(--ca-primary);
                background: var(--ca-primary-soft);
            }

        .card-blue.card-outline {
            display: none;
        }

        .my-row:last-child {
            margin-bottom: 0;
        }

        .my-col-12[style*="text-align: right"] {
            display: flex;
            justify-content: flex-end;
        }

        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 9px 20px;
            border: none;
            border-radius: 30px;
            color: white;
            margin-right: 0;
            font-weight: 800;
            letter-spacing: .01em;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
        }

            .my-btn:hover {
                transform: translateY(-1px);
            }

        .primary {
            background: #64748b;
            box-shadow: 0 10px 20px rgba(100, 116, 139, .22);
        }

        .success {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 13px;
        }

        @media (max-width: 768px) {
            .condition-page {
                padding: 12px;
            }

            .condition-hero {
                padding: 18px;
            }

            .condition-title {
                font-size: 20px;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 10px;
            }

            .custom-modal {
                padding: 12px;
            }

            .custom-modal-body {
                padding: 16px;
            }

            .my-col-3, .my-col-4, .my-col-6 {
                max-width: 100%;
                flex-basis: 100%;
            }
        }
    </style>


    <script>
        $(document).ready(function () {

            BindUSLoanDetails_Grid();

        });

    </script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
   <%--  <script src="../Scripts/US/LoanDetails.js"></script>--%>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="condition-hero">
        <div class="condition-title-wrap">
            <span class="condition-title-icon"><i class="fas fa-copy"></i></span>
            <div>
                <h1 class="condition-title">My Task</h1>
                <p class="condition-subtitle">Review and complete assigned loan tasks.</p>
            </div>
        </div>
    </div>


    <div class="loan-page">
        <input id="usfilep_ap" style="display: none;" />
        <div class="condition-page">
            <div class="condition-card">
                <div class="condition-card-header">
                    <div>
                        <h2 class="condition-card-title">Analysis Queue</h2>
                        <p class="condition-card-hint">Use the table action to start loan feedback.</p>
                    </div>
                </div>
                <div class="condition-card-body">
                    <table class="table table-sm table-hover loan-table" id="table_USLoanDetails" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="loan-hidden" style="display: none;">Actions</th>
                                <th style="width: 130px; text-align: center;">Action</th>
                                <th class="loan-hidden" style="display: none;">End Date/Time</th>
                                <th class="loan-hidden" style="display: none;">ProcessID</th>
                                <th>Client</th>
                                <th>Deal #</th>
                                <th>Loan #</th>
                                <th>Received Date</th>
                                <th>Process</th>
                                <th class="loan-hidden" style="display: none;">UW Name</th>
                                <th class="loan-hidden" style="display: none;">Date Reviewed</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade loan-modal" id="us_completeLoan" tabindex="-1" role="dialog" aria-labelledby="usCompleteLoanTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="usCompleteLoanTitle">Loan Status</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="loan-success-body">
                        <span class="loan-success-mark"><i class="fas fa-check"></i></span>
                        <p>The loan process has been successfully completed. You are now being redirected to the feedback page.</p>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="roam_btnYes" onclick="return us_redirectAddFeedback_1();">
                        <i class="fas fa-arrow-right mr-1"></i>Go to Feedback
                   
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center waiting-panel-content">
            <img src="../Images/Load.gif" alt="Loading" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">Please wait . . </span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
