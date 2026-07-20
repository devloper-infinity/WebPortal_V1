<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="InfinityFeedbackOnshore.aspx.cs" Inherits="WebPortal.US.InfinityFeedbackOnshore" %>

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
            display: none;
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
            padding: 0 15px 24px;
            background: var(--ca-bg);
            min-height: calc(100vh - 80px);
        }

        .condition-hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 24px;
            margin: 0 15px 18px;
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
            width: 56px;
            height: 56px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            background: rgba(255, 255, 255, .18);
            box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .20);
            font-size: 30px;
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
            margin-bottom: 18px;
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

        .main-container {
            width: 100%;
        }

        .my-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 16px;
            width: 100%;
        }

        .my-col-3, .my-col-4, .my-col-6, .my-col-12 {
            padding-right: 0;
        }

        .my-col-4 {
            flex: 1 1 260px;
            max-width: calc(33.333% - 11px);
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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: 600 !important;
            border: none !important;
            color: #374151;
        }

        .req {
            color: #ef4444;
            font-weight: 800;
            margin-left: 3px;
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

        textarea.my-input, .my-textarea {
            min-height: 88px;
            height: auto;
            resize: vertical;
        }

            .my-input:focus, .my-select:focus, .my-textarea:focus {
                border-color: var(--ca-primary);
                box-shadow: 0 0 0 4px var(--ca-ring);
                outline: none;
            }

        .my-row:last-child {
            margin-bottom: 0;
        }

        .action-row {
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .my-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 9px 22px;
            border: none;
            border-radius: 13px;
            color: white;
            margin-right: 0;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: .01em;
            cursor: pointer;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%) !important;
        }

            .my-btn:hover {
                transform: translateY(-1px);
                opacity: 1;
            }

        .primary {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            box-shadow: 0 10px 20px rgba(37, 99, 235, .24);
        }

        .success {
            background: linear-gradient(90deg, #16a34a 0%, #22c55e 100%);
            box-shadow: 0 10px 20px rgba(34, 197, 94, .22);
        }

        .warning {
            background: #f59e0b;
            box-shadow: 0 10px 20px rgba(245, 158, 11, .22);
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

        .top {
            display: flex;
            align-items: center;
        }

        .dataTables_length {
            margin-right: 10px;
        }

        .dt-buttons {
            margin-right: auto;
        }

        .dataTables_filter {
            margin-left: auto;
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

        #table_condclear_wrapper, #table_condclear {
            width: 100% !important;
        }

        .swal2-container {
            z-index: 200000 !important;
        }

        .feedback-action-link {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--ca-primary);
            border: 1px solid rgba(37, 99, 235, .18);
            border-radius: 999px;
            background: var(--ca-primary-soft);
            text-decoration: none;
        }

            .feedback-action-link:hover, .feedback-action-link:focus {
                color: #fff;
                background: var(--ca-primary);
                text-decoration: none;
            }

        .feedback-loan-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--ca-primary);
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
        }

            .feedback-loan-link:hover, .feedback-loan-link:focus {
                color: var(--ca-primary-dark);
                text-decoration: underline;
            }

        .feedback-remark-modal .modal-content {
            border: 0;
            border-radius: var(--ca-radius-lg);
            box-shadow: var(--ca-shadow);
            overflow: hidden;
        }

        .feedback-remark-modal .modal-header {
            align-items: center;
            color: #fff;
            background: linear-gradient(135deg, #2563eb 0%, #7c3aed 100%);
            border-bottom: 0;
            padding: 18px 20px;
        }

        .feedback-remark-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 800;
        }

        .feedback-remark-modal .close {
            color: #fff;
            opacity: .9;
            text-shadow: none;
        }

        .feedback-remark-context {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .feedback-remark-context-item {
            padding: 10px 12px;
            border: 1px solid var(--ca-border);
            border-radius: var(--ca-radius-md);
            background: #f8fafc;
        }

            .feedback-remark-context-item span {
                display: block;
                color: var(--ca-muted);
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
            }

            .feedback-remark-context-item strong {
                display: block;
                margin-top: 3px;
                color: var(--ca-text);
                font-size: 13px;
                word-break: break-word;
            }

            .feedback-remark-context-item.wide {
                grid-column: 1 / -1;
            }

            .feedback-remark-context-item .feedback-detail-text {
                max-height: 92px;
                overflow-y: auto;
                white-space: pre-wrap;
            }

        #txtInfinityOnshoreRemark {
            min-height: 130px;
        }

        .feedback-remark-modal .modal-footer {
            border-top: 1px solid var(--ca-border);
            background: #f8fafc;
        }

        @media (max-width: 576px) {
            .feedback-remark-context {
                grid-template-columns: 1fr;
            }
        }

        .custom-dropdown {
            position: relative;
            width: 200px;
            font-family: Arial, sans-serif;
        }

        .selected {
            border: 1px solid var(--ca-border);
            padding: 8px;
            border-radius: 12px;
            cursor: pointer;
            user-select: none;
            background: #fff;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            border: 1px solid var(--ca-border);
            border-top: none;
            background: #fff;
            max-height: 200px;
            overflow-y: auto;
            z-index: 10;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, .12);
        }

            .dropdown-menu.hidden {
                display: none;
            }

        .search-box {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 10px;
            border: none;
            border-bottom: 1px solid var(--ca-border);
        }

        .options div {
            padding: 8px;
            cursor: pointer;
        }

            .options div:hover {
                background-color: var(--ca-primary-soft);
            }

        @media (max-width: 768px) {
            .condition-page {
                padding: 0 12px 18px;
            }

            .condition-hero {
                margin: 0 12px 16px;
                padding: 18px;
            }

            .condition-title {
                font-size: 20px;
            }

            .condition-card-header, .condition-card-body {
                padding: 16px;
            }

            div.dt-buttons {
                padding-left: 0;
                margin-top: 10px;
            }

            .my-col-4 {
                max-width: 100%;
                flex-basis: 100%;
            }
        }

        .nowrap {
            white-space: nowrap !important;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        #table_InfinityFeedbackOnShore tbody tr.row-disagree td {
            background-color: #AFEEEE !important;
            font-weight: 600;
        }
    </style>
    <script>

        $(document).ready(function () {

            // bind_onshoredata("01-Apr-2026", "01-Jul-2026");

        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="filep_ap" style="display: none;" />
    <%-- <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>--%>
    <div class="condition-hero">
        <div class="condition-title-wrap">
            <span class="condition-title-icon"><i class="fas fa-comments"></i></span>
            <div>
                <h1 class="condition-title">Infinity Feedback Onshore</h1>
                <p class="condition-subtitle">Review, track, and manage onshore feedback records efficiently.</p>
            </div>
        </div>
    </div>
    <div class="condition-page">
        <div class="condition-card">
            <div class="condition-card-header">
                <div>
                    <h2 class="condition-card-title">Onshore Feedback Queue</h2>
                    <p class="condition-card-hint">Monitor pending and completed feedback items.</p>
                </div>
            </div>
            <div class="card-body">
                <div class="main-container">
                    <div class="row align-items-end">
                        <div class="col-md-4">
                            <label for="infFeedback_FromDateOnShore" class="form-label">
                                <b>From Date</b>
                            </label>
                            <input type="date" class="my-input" id="infFeedback_FromDateOnShore" name="infFeedback_FromDateOnShore" />
                        </div>
                        <div class="col-md-4">
                            <label for="Condition_ToDate" class="form-label">
                                <b>To Date</b>
                            </label>
                            <input type="date" class="my-input" id="infFeedback_ToDateOnShore" name="infFeedback_ToDateOnShore" />
                        </div>
                        <div class="col-md-4">
                            <label for="Condition_ToDate" class="form-label">
                            </label>
                            <button type="button" style="width: 100%" class="my-btn primary" id="btnEditFeedbackShowOnShore" onclick="return showdata1();">Show</button>
                        </div>
                    </div>
                </div>
                <hr />
                <div style="overflow: auto;">
                    <div id="feedbackLoader" class="table-loader">
                        <div class="spinner-border text-primary" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        <div class="mt-2">Loading feedback records...</div>
                    </div>

                    <table class="table" id="table_InfinityFeedbackOnShore" style="width: 100%;">
                        <thead>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade feedback-remark-modal" id="popUp_InfinityOnshoreRemark" tabindex="-1" role="dialog" aria-labelledby="infinityOnshoreRemarkTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="infinityOnshoreRemarkTitle"><i class="fas fa-comment-medical"></i>Add Remark</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="hdnInfinityOnshoreFeedbackId" />
                    <div class="feedback-remark-context">
                        <div class="feedback-remark-context-item">
                            <span>Loan Number</span>
                            <strong id="spnInfinityOnshoreLoanNumber">-</strong>
                        </div>
                        <div class="feedback-remark-context-item">
                            <span>Client</span>
                            <strong id="spnInfinityOnshoreClient">-</strong>
                        </div>
                        <div class="feedback-remark-context-item wide">
                            <span>RCA</span>
                            <strong id="spnInfinityOnshoreRCA" class="feedback-detail-text">-</strong>
                        </div>
                        <div class="feedback-remark-context-item wide">
                            <span>Rebuttal Status</span>
                            <select id="ddlInfinityOnshore_RebuttalStatus">
                                <option value="">Select Status</option>
                                <option value="Agree">Agree</option>
                                <option value="Rebuttal">Rebuttal</option>
                            </select>
                        </div>
                    </div>
                    <label for="txtInfinityOnshoreRemark">Remark <span class="req">*</span></label>
                    <textarea id="txtInfinityOnshoreRemark" class="my-textarea" maxlength="4000" placeholder="Enter remark"></textarea>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="btnSaveInfinityOnshoreRemark" onclick="return saveInfinityOnshoreRemark();">
                        <i class="fas fa-save mr-1"></i>Save Remark
                   
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
