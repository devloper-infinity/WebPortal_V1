<%@ Page Title="Add Feedback" Language="C#" MasterPageFile="~/Tracking/Tracking.Master" AutoEventWireup="true" CodeBehind="AddFeedback.aspx.cs" Inherits="WebPortal.Tracking.AddFeedback" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        :root {
            --af-primary: #1d4ed8;
            --af-secondary: #0f766e;
            --af-text: #102033;
            --af-muted: #64748b;
            --af-border: #dce6f2;
            --af-surface: #ffffff;
            --af-soft: #f5f8fc;
        }

        .af-page {
            color: var(--af-text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            max-width: 100%;
        }

        .af-dialog {
            background: var(--af-surface);
            border: 1px solid var(--af-border);
            border-radius: 18px;
            box-shadow: 0 22px 55px rgba(15, 23, 42, .14);
            margin: 0 auto;
            max-width: 100%;
            overflow: hidden;
        }

        .af-dialog-header {
            align-items: center;
            background: linear-gradient(135deg, var(--af-secondary) 0%, var(--af-primary) 100%);
            color: #fff;
            display: flex;
            justify-content: space-between;
            min-height: 84px;
            padding: 17px 22px;
            position: relative;
        }

            .af-dialog-header::after {
                background: rgba(255,255,255,.09);
                border-radius: 50%;
                content: "";
                height: 160px;
                position: absolute;
                right: 70px;
                top: -112px;
                width: 160px;
            }

        .af-title-wrap {
            align-items: center;
            display: flex;
            gap: 13px;
            position: relative;
            z-index: 1;
        }

        .af-title-icon {
            align-items: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 12px;
            display: inline-flex;
            font-size: 25px;
            height: 60px;
            justify-content: center;
            width: 60px;
        }

        .af-title-wrap h1 {
            font-size: 20px;
            font-weight: 800;
            margin: 0;
        }

        .af-title-wrap p {
            color: rgba(255,255,255,.86);
            font-size: 12px;
            font-weight: 600;
            margin: 4px 0 0;
        }

        .af-close-btn {
            align-items: center;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 10px;
            color: #fff;
            display: inline-flex;
            height: 38px;
            justify-content: center;
            position: relative;
            width: 38px;
            z-index: 1;
        }

            .af-close-btn:hover,
            .af-close-btn:focus {
                background: rgba(255,255,255,.24);
                color: #fff;
                outline: none;
            }

        .af-dialog-body {
            background: var(--af-soft);
            padding: 18px;
        }

        .af-context-grid {
            background: #fff;
            border: 1px solid var(--af-border);
            border-radius: 13px;
            display: grid;
            gap: 1px;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            margin-bottom: 15px;
            overflow: hidden;
        }

        .af-context-item {
            background: linear-gradient(180deg, #fff 0%, #fbfdff 100%);
            min-width: 0;
            padding: 12px 14px;
        }

            .af-context-item span {
                color: var(--af-muted);
                display: block;
                font-size: 10px;
                font-weight: 800;
                letter-spacing: .35px;
                margin-bottom: 5px;
                text-transform: uppercase;
            }

            .af-context-item strong {
                color: var(--af-text);
                display: block;
                font-size: 13px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

        .af-tabs {
            background: #e8f0fa;
            border: 1px solid #d7e2f0;
            border-radius: 12px;
            display: grid;
            gap: 9px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            margin-bottom: 14px;
            padding: 7px;
        }

        .af-tab-btn {
            align-items: center;
            background: transparent;
            border: 1px solid transparent;
            border-radius: 9px;
            color: #294765;
            display: flex;
            font-size: 12px;
            font-weight: 800;
            gap: 8px;
            height: 42px;
            justify-content: center;
        }

            .af-tab-btn.active {
                background: #fff;
                border-color: #d3deeb;
                box-shadow: 0 7px 16px rgba(15,23,42,.09);
                color: #083344;
            }

                .af-tab-btn.active::after {
                    background: var(--af-secondary);
                    border-radius: 999px;
                    bottom: -1px;
                    content: "";
                    height: 3px;
                    left: 22%;
                    position: absolute;
                    right: 22%;
                }

        .af-tab-btn {
            position: relative;
        }

        .af-tab-panel {
            display: none;
        }

            .af-tab-panel.active {
                animation: afFade .18s ease;
                display: block;
            }

        @keyframes afFade {
            from {
                opacity: 0;
                transform: translateY(4px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .af-panel {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-radius: 13px;
            padding: 17px;
        }

        .af-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .af-field {
            min-width: 0;
        }

            .af-field.af-span-2 {
                grid-column: span 2;
            }

            .af-field.af-span-3 {
                grid-column: 1 / -1;
            }

            .af-field label {
                color: #334155;
                display: block;
                font-size: 11px;
                font-weight: 800;
                margin-bottom: 7px;
            }

        .af-control {
            background: #fff;
            border: 1px solid #cbd7e5;
            border-radius: 9px;
            color: #1f2937;
            font-size: 13px;
            height: 42px;
            outline: none;
            padding: 8px 10px;
            transition: border-color .18s ease, box-shadow .18s ease;
            width: 100%;
        }

            .af-control:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59,130,246,.12);
            }

            .af-control[disabled],
            .af-control[readonly] {
                background: #eef2f7;
                color: #64748b;
            }

        textarea.af-control {
            height: auto;
            line-height: 1.45;
            min-height: 78px;
            resize: vertical;
        }

        .af-panel-actions {
            align-items: center;
            border-top: 1px solid #eaf0f6;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 16px;
            padding-top: 14px;
        }

        .af-btn {
            align-items: center;
            border: 1px solid transparent;
            border-radius: 9px;
            display: inline-flex;
            font-size: 12px;
            font-weight: 800;
            gap: 7px;
            height: 41px;
            justify-content: center;
            min-width: 108px;
            padding: 0 17px;
        }

        .af-btn-primary {
            background: linear-gradient(135deg, var(--af-secondary), var(--af-primary));
            box-shadow: 0 8px 18px rgba(29,78,216,.20);
            color: #fff;
        }

            .af-btn-primary:hover,
            .af-btn-primary:focus {
                color: #fff;
                filter: brightness(.97);
                outline: none;
            }

        .af-btn-secondary {
            background: #eefaf8;
            border-color: #c8e5e0;
            color: #075e57;
        }

            .af-btn-secondary:hover,
            .af-btn-secondary:focus {
                background: #def6f1;
                color: #064e47;
                outline: none;
            }

        .af-dropzone {
            align-items: center;
            background: #f8fafc;
            border: 2px dashed #b9c9dc;
            border-radius: 13px;
            cursor: pointer;
            display: flex;
            gap: 16px;
            min-height: 122px;
            padding: 20px;
            transition: background .18s ease, border-color .18s ease;
        }

            .af-dropzone:hover,
            .af-dropzone.is-dragover {
                background: #ecfdf5;
                border-color: var(--af-secondary);
            }

            .af-dropzone i {
                color: var(--af-secondary);
                font-size: 32px;
            }

            .af-dropzone strong {
                color: var(--af-text);
                display: block;
                font-size: 14px;
                margin-bottom: 5px;
            }

            .af-dropzone span {
                color: var(--af-muted);
                display: block;
                font-size: 12px;
                font-weight: 600;
            }

        .af-import-summary {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin: 14px 0;
        }

        .af-summary-card {
            background: #fff;
            border: 1px solid #dce6f2;
            border-left: 4px solid var(--af-primary);
            border-radius: 10px;
            padding: 11px 13px;
        }

            .af-summary-card span {
                color: var(--af-muted);
                display: block;
                font-size: 10px;
                font-weight: 800;
                text-transform: uppercase;
            }

            .af-summary-card strong {
                color: var(--af-text);
                display: block;
                font-size: 20px;
                margin-top: 3px;
            }

        .af-result-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .af-result-card {
            border: 1px solid #dfe7f0;
            border-radius: 11px;
            min-width: 0;
            overflow: hidden;
        }

        .af-result-title {
            background: #f8fafc;
            border-bottom: 1px solid #e4ebf3;
            color: #334155;
            font-size: 11px;
            font-weight: 800;
            padding: 9px 11px;
        }

        .af-result-scroll {
            max-height: 190px;
            overflow: auto;
        }

        .af-result-table {
            border-collapse: collapse;
            font-size: 11px;
            margin: 0;
            width: 100%;
        }

            .af-result-table th,
            .af-result-table td {
                border-bottom: 1px solid #edf2f7;
                padding: 8px 9px;
                text-align: left;
                vertical-align: top;
            }

            .af-result-table th {
                background: #fff;
                color: #475569;
                font-weight: 800;
                position: sticky;
                top: 0;
            }

        .af-history-panel {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-radius: 13px;
            margin-top: 15px;
            overflow: hidden;
        }

        .af-history-head {
            align-items: center;
            background: linear-gradient(180deg, #fff 0%, #f8fbff 100%);
            border-bottom: 1px solid #e3ebf4;
            display: flex;
            gap: 12px;
            justify-content: space-between;
            padding: 12px 15px;
        }

        .af-history-title {
            align-items: center;
            color: #1e3a5f;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 0;
        }

        .af-history-count {
            background: #e8f1ff;
            border-radius: 999px;
            color: #1849a9;
            font-size: 10px;
            font-weight: 800;
            padding: 4px 8px;
        }

        .af-refresh-btn {
            align-items: center;
            background: #fff;
            border: 1px solid #cfdbe8;
            border-radius: 8px;
            color: #34506e;
            display: inline-flex;
            font-size: 11px;
            font-weight: 800;
            gap: 6px;
            height: 34px;
            padding: 0 11px;
        }

        .af-history-body {
            overflow-x: auto;
            padding: 12px 14px 14px;
        }

        #af_feedbackTable {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            min-width: 900px;
            width: 100% !important;
        }

            #af_feedbackTable thead th {
                background: #f4f7fb;
                border-bottom: 1px solid #dbe5f0 !important;
                color: #42526a;
                font-size: 10px;
                font-weight: 800;
                padding: 10px 9px !important;
                text-transform: uppercase;
                white-space: nowrap;
            }

            #af_feedbackTable tbody td {
                border-bottom: 1px solid #edf2f7 !important;
                color: #344054;
                font-size: 11px;
                padding: 10px 9px !important;
                vertical-align: top;
            }

        #af_feedbackTable_wrapper .dataTables_info,
        #af_feedbackTable_wrapper .dataTables_paginate {
            color: #64748b;
            font-size: 11px;
            padding-top: 11px;
        }

        .af-page-header {
            align-items: center;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,.12);
            color: #fff;
            display: flex;
            justify-content: space-between;
            margin: 0 auto 18px;
            max-width: 1180px;
            overflow: hidden;
            padding: 22px 16px;
            position: relative;
        }

            .af-page-header::after {
                background: rgba(255,255,255,.12);
                border-radius: 50%;
                content: "";
                height: 220px;
                position: absolute;
                right: -70px;
                top: -70px;
                width: 220px;
            }

            .af-page-header .af-title-wrap,
            .af-page-header .af-close-btn {
                position: relative;
                z-index: 1;
            }

            .af-page-header .af-title-icon {
                height: 42px;
                width: 42px;
            }

            .af-page-header .af-title-wrap h1 {
                font-size: 20px;
                font-weight: 600;
            }

            .af-page-header .af-title-wrap p {
                font-size: 12px;
                margin-top: 3px;
            }

        .af-dialog {
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(0,0,0,.08);
        }

        .af-main-dialog {
            max-width: 1180px;
        }

        .af-card-section {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 14px;
            box-shadow: 0 8px 24px rgba(0,0,0,.08);
            margin: 18px auto 0;
            max-width: 1180px;
            overflow: hidden;
        }

        .af-card-header {
            align-items: center;
            background: linear-gradient(135deg, #0d6efd, #4dabf7);
            color: #fff;
            display: flex;
            gap: 10px;
            padding: 14px 18px;
        }

            .af-card-header i {
                font-size: 16px;
            }

            .af-card-header h2 {
                font-size: 16px;
                font-weight: 600;
                margin: 0;
            }

            .af-card-header p {
                color: rgba(255,255,255,.88);
                font-size: 11px;
                margin: 2px 0 0;
            }

        .af-card-body {
            background: var(--af-soft);
            padding: 18px;
        }

        .af-status-dialog {
            margin-top: 18px;
            max-width: 1180px;
        }

        .af-status-context-grid {
            grid-template-columns: repeat(5, minmax(0, 1fr));
        }

        .af-status-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

            .af-status-grid .af-status-remark {
                grid-column: 1 / -1;
            }

        .af-loading {
            align-items: center;
            background: rgba(15,23,42,.32);
            display: none;
            inset: 0;
            justify-content: center;
            position: fixed;
            z-index: 3000;
        }

        .af-loading-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 16px 38px rgba(15,23,42,.24);
            color: #334155;
            font-size: 12px;
            font-weight: 800;
            padding: 19px 24px;
            text-align: center;
        }

            .af-loading-card img {
                display: block;
                height: 46px;
                margin: 0 auto 8px;
                width: 46px;
            }

        @media (max-width: 900px) {
            .af-context-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .af-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .af-field.af-span-3 {
                grid-column: 1 / -1;
            }

            .af-status-context-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .af-page {
                padding: 7px;
            }

            .af-dialog {
                border-radius: 13px;
            }

            .af-dialog-header {
                padding: 15px;
            }

            .af-title-wrap p {
                display: none;
            }

            .af-dialog-body {
                padding: 11px;
            }

            .af-context-grid, .af-form-grid, .af-import-summary, .af-result-grid, .af-status-grid {
                grid-template-columns: 1fr;
            }

            .af-field.af-span-2, .af-field.af-span-3 {
                grid-column: auto;
            }

            .af-status-grid .af-status-remark {
                grid-column: auto;
            }

            .af-tabs {
                gap: 6px;
            }

            .af-panel {
                padding: 13px;
            }

            .af-panel-actions {
                align-items: stretch;
                flex-direction: column-reverse;
            }

                .af-panel-actions .af-btn {
                    width: 100%;
                }
        }
    </style>


    <script>

        $(document).ready(function () {

           <%-- alert($("#<%= af_loginPseudoName.ClientID %>").val());--%>

            $("#af_feedbackBy").val($("#<%= af_loginPseudoName.ClientID %>").val());

            var processID = $("#<%= af_processID.ClientID %>").val();

            bind_LoanDetails(processID)

        });

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="af-loading" id="af_loading" aria-hidden="true">
        <div class="af-loading-card">
            <img src="../images/Load_1.gif" alt="" />
            <span id="af_loadingText">Please wait...</span>
        </div>
    </div>

    <input type="hidden" id="af_processID" name="af_processID" runat="server" />
    <input type="hidden" id="af_loginPseudoName" name="af_loginPseudoName" runat="server" />

    <input type="hidden" id="hdnProjectNo" />
    <input type="hidden" id="hdnProjectId" />
    <input type="hidden" id="hdnDealNo" />
    <input type="hidden" id="hdnLoanNo" />
    <input type="hidden" id="hdnOrderDate" />
    <input type="hidden" id="hdnProcess" />
    <input type="hidden" id="hdnErrorBy" />

    <main class="af-page">
        <header class="af-page-header">
            <div class="af-title-wrap">
                <span class="af-title-icon"><i class="fas fa-comment-dots"></i></span>
                <div>
                    <h1 id="af_pageTitle">Tracking Feedback</h1>
                    <p id="af_pageDescription">Add or import feedback and update the selected loan status from one place.</p>
                </div>
            </div>
            <button type="button" class="af-close-btn" id="af_btnClose" aria-label="Close">
                <i class="fas fa-arrow-left"></i>
            </button>
        </header>

        <section class="af-dialog af-main-dialog" id="popUp_addTrackingFeedback" role="region" aria-labelledby="af_pageTitle" aria-describedby="af_pageDescription">
            <div class="af-dialog-body">
                <div class="af-context-grid" aria-label="Selected order details">
                    <div class="af-context-item">
                        <span>Project</span>
                        <strong id="af_ctxProject">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Deal No</span>
                        <strong id="af_ctxDeal">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Loan No</span>
                        <strong id="af_ctxLoan">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Process</span>
                        <strong id="af_ctxProcess">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Order Date</span>
                        <strong id="af_ctxOrderDate">-</strong>
                    </div>
                </div>

                <nav class="af-tabs" role="tablist" aria-label="Feedback actions">
                    <button type="button" class="af-tab-btn active" id="af_addTab" data-panel="af_addPanel" role="tab" aria-controls="af_addPanel" aria-selected="true">
                        <i class="fas fa-plus-circle"></i>Add Feedback
                   
                    </button>
                    <button type="button" class="af-tab-btn" id="af_importTab" data-panel="af_importPanel" role="tab" aria-controls="af_importPanel" aria-selected="true">
                        <i class="fas fa-file-import"></i>Import Feedback
                   
                    </button>
                </nav>

                <section class="af-tab-panel active" id="af_addPanel" role="tabpanel" aria-labelledby="af_addTab">
                    <div class="af-panel">
                        <div class="af-form-grid">
                            <div class="af-field">
                                <label for="af_markedTo">Marked to</label>
                                <select id="af_markedTo" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Review">Review</option>
                                    <option value="CNCReview">CNCReview</option>
                                    <option value="SSReview">SSReview</option>
                                    <option value="Loan Setup">Loan Setup</option>
                                    <option value="Credit">Credit</option>
                                    <option value="Compliance">Compliance</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_errorBy">Error By</label>
                                <select id="af_errorBy" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_feedbackBy">Feedback By</label>
                                <input id="af_feedbackBy" type="text" class="af-control" readonly="readonly" />
                            </div>

                            <div class="af-field">
                                <label for="af_errorType">Error Type</label>
                                <select id="af_errorType" class="af-control">
                                    <option value="">Select</option>
                                    <option value="NoFeedback">NoFeedback</option>
                                    <option value="Misindexed">Misindexed</option>
                                    <option value="Misinterpretation">Misinterpretation</option>
                                    <option value="Miscalculation">Miscalculation</option>
                                    <option value="Conceptual">Conceptual</option>
                                    <option value="Scienna Data Entry">Scienna Data Entry</option>
                                    <option value="Careless">Careless</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_category">Category</label>
                                <select id="af_category" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_subCategory">Subcategory</label>
                                <select id="af_subCategory" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>

                            <div class="af-field">
                                <label for="af_severity">Severity</label>
                                <select id="af_severity" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Non-Critical">Non-Critical</option>
                                    <option value="Critical">Critical</option>
                                    <option value="Critical-Saleable">Critical-Saleable</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_errorField">Error Field</label>
                                <input id="af_errorField" type="text" class="af-control" autocomplete="off" />
                            </div>
                            <div class="af-field">
                                <label for="af_feedbackType">Feedback Type</label>
                                <select id="af_feedbackType" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Internal">Internal</option>
                                    <option value="Client">Client</option>
                                    <option value="On-Shore">On-Shore</option>
                                </select>
                            </div>

                            <div class="af-field af-span-2">
                                <label for="af_error">Error</label>
                                <textarea id="af_error" class="af-control"></textarea>
                            </div>
                            <div class="af-field">
                                <label for="af_shouldBe">Should be</label>
                                <textarea id="af_shouldBe" class="af-control"></textarea>
                            </div>
                            <div class="af-field af-span-3">
                                <label for="af_remark">Remark</label>
                                <textarea id="af_remark" class="af-control"></textarea>
                            </div>
                        </div>

                        <div class="af-panel-actions">
                            <button type="button" class="af-btn af-btn-secondary" id="af_btnClear">
                                <i class="fas fa-eraser"></i>Clear
                           
                            </button>
                            <button type="button" class="af-btn af-btn-primary" id="af_btnSave">
                                <i class="fas fa-save"></i>Add
                           
                            </button>
                            <button type="button" class="af-btn af-btn-primary" id="af_btnCompleteOrder" onclick="return af_completeOrder();">
                                <i class="fas fa-save"></i>Complete Order</button>
                        </div>
                    </div>

                    <div class="af-history-panel">
                        <div class="af-history-head">
                            <h2 class="af-history-title">
                                <i class="fas fa-list-alt"></i>Feedback Records
                               
                                <span class="af-history-count" id="af_feedbackCount">0</span>
                            </h2>
                            <button type="button" class="af-refresh-btn" id="af_btnRefreshFeedback">
                                <i class="fas fa-sync-alt"></i>Refresh
                           
                            </button>
                        </div>
                        <div class="af-history-body">
                            <table id="af_feedbackTable" class="table table-sm" aria-label="Feedback records">
                                <thead>
                                    <tr>
                                        <th>Sr. #</th>
                                        <th>Process</th>
                                        <th>Error By</th>
                                        <th>Error Type</th>
                                        <th>Category</th>
                                        <th>Subcategory</th>
                                        <th>Severity</th>
                                        <th>Feedback Type</th>
                                        <th>Remark</th>
                                        <th>Added On</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <section class="af-tab-panel" id="af_importPanel" role="tabpanel" aria-labelledby="af_importTab" hidden="hidden">
                    <div class="af-panel">
                        <input id="af_importFile" type="file" accept=".xls,.xlsx,.csv" hidden="hidden" />
                        <div class="af-dropzone" id="af_dropzone" role="button" tabindex="0" aria-label="Select feedback import file">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <div>
                                <strong id="af_fileName">Drop feedback file here or click to browse</strong>
                                <span>Supported formats: .xls, .xlsx, and .csv. Columns must match the feedback import format.</span>
                            </div>
                        </div>

                        <div class="af-panel-actions">
                            <button type="button" class="af-btn af-btn-secondary" id="af_btnFormat">
                                <i class="fas fa-download"></i>Download Format
                           
                            </button>
                            <button type="button" class="af-btn af-btn-primary" id="af_btnUpload">
                                <i class="fas fa-file-upload"></i>Upload
                           
                            </button>
                        </div>

                        <div class="af-import-summary" aria-label="Import summary">
                            <div class="af-summary-card">
                                <span>Total Rows</span>
                                <strong id="af_importTotal">0</strong>
                            </div>
                            <div class="af-summary-card" style="border-left-color: #0f766e;">
                                <span>Imported</span>
                                <strong id="af_importAdded">0</strong>
                            </div>
                            <div class="af-summary-card" style="border-left-color: #dc2626;">
                                <span>Not Imported</span>
                                <strong id="af_importFailed">0</strong>
                            </div>
                        </div>

                        <div class="af-result-grid">
                            <div class="af-result-card">
                                <div class="af-result-title">Imported feedback</div>
                                <div class="af-result-scroll">
                                    <table class="af-result-table" id="af_addedTable">
                                        <thead>
                                            <tr>
                                                <th>Deal No</th>
                                                <th>Loan 1 #</th>
                                                <th>Process</th>
                                                <th>Error Type</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="af-result-card">
                                <div class="af-result-title">Could not import</div>
                                <div class="af-result-scroll">
                                    <table class="af-result-table" id="af_failedTable">
                                        <thead>
                                            <tr>
                                                <th>Deal No</th>
                                                <th>Loan 1 #</th>
                                                <th>Process</th>
                                                <th>Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </section>

        <section class="af-card-section af-status-dialog" id="popUp_updateOrderStatus" role="region" aria-labelledby="af_statusTitle" aria-describedby="af_statusDescription">
            <div class="af-card-header">
                <i class="fas fa-tasks"></i>
                <div>
                    <h2 id="af_statusTitle">Update Loan Status</h2>
                    <p id="af_statusDescription">Update the selected loan after reviewing its feedback records.</p>
                </div>
            </div>

            <div class="af-card-body">
                <div class="af-context-grid af-status-context-grid" aria-label="Loan status context">
                    <div class="af-context-item">
                        <span>Project</span>
                        <strong id="af_statusProject">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Deal No</span>
                        <strong id="af_statusDeal">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Loan No</span>
                        <strong id="af_statusLoan">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Process</span>
                        <strong id="af_statusProcess">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Order Date</span>
                        <strong id="af_statusOrderDate">-</strong>
                    </div>
                </div>

                <div class="af-panel">
                    <div class="af-status-grid">
                        <div class="af-field">
                            <label for="af_status">Status</label>
                            <select id="af_status" class="af-control" onchange="toggleHoldReason();">
                                <option value="">Select</option>
                                <option value="Completed">Completed</option>
                                <option value="Hold">Hold</option>
                            </select>
                        </div>
                        <div class="af-field">
                            <label for="af_holdReason">Hold Reason</label>
                            <select id="af_holdReason" class="af-control" disabled="disabled">
                                <option value="">Select</option>
                                <option value="PDF Issue">PDF Issue</option>
                                <option value="Audit Worksheet Not available in Box">Audit Worksheet Not available in Box</option>
                                <option value="Partially Review in Scienna">Partially Review in Scienna</option>
                                <option value="Wrongly pulled in ERP">Wrongly pulled in ERP</option>
                                <option value="Miscellaneous – Any other issue with comments">Miscellaneous – Any other issue with comments</option>
                            </select>
                        </div>
                        <div class="af-field af-status-remark">
                            <label for="af_statusRemark">Remark</label>
                            <textarea id="af_statusRemark" class="af-control" placeholder="Enter a status remark if required"></textarea>
                        </div>
                    </div>

                    <div class="af-panel-actions">
                        <button type="reset" class="af-btn af-btn-secondary" id="af_btnClearStatus">
                            <i class="fas fa-eraser"></i>Clear
                       
                        </button>
                        <button type="button" class="af-btn af-btn-primary" id="af_btnUpdateStatus">
                            <i class="fas fa-save"></i>Update Status
                       
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <%--  <script src="../Scripts/Tracking/AddFeedback.js"></script>--%>
    <portal:VersionedScript Src="~/Scripts/Tracking/Feedback.js" runat="server"></portal:VersionedScript>
</asp:Content>


<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../plugins/sweetalert2/sweetalert2.min.css" />
    <style>
        :root {
            --af-primary: #1d4ed8;
            --af-secondary: #0f766e;
            --af-text: #102033;
            --af-muted: #64748b;
            --af-border: #dce6f2;
            --af-surface: #ffffff;
            --af-soft: #f5f8fc;
        }

        .af-page {
            color: var(--af-text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            padding: 18px;
        }

        .af-dialog {
            background: var(--af-surface);
            border: 1px solid var(--af-border);
            border-radius: 18px;
            box-shadow: 0 22px 55px rgba(15, 23, 42, .14);
            margin: 0 auto;
            max-width: 1180px;
            overflow: hidden;
        }

        .af-dialog-header {
            align-items: center;
            background: linear-gradient(135deg, var(--af-secondary) 0%, var(--af-primary) 100%);
            color: #fff;
            display: flex;
            justify-content: space-between;
            min-height: 84px;
            padding: 17px 22px;
            position: relative;
        }

        .af-dialog-header::after {
            background: rgba(255,255,255,.09);
            border-radius: 50%;
            content: "";
            height: 160px;
            position: absolute;
            right: 70px;
            top: -112px;
            width: 160px;
        }

        .af-title-wrap {
            align-items: center;
            display: flex;
            gap: 13px;
            position: relative;
            z-index: 1;
        }

        .af-title-icon {
            align-items: center;
            background: rgba(255,255,255,.16);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 12px;
            display: inline-flex;
            font-size: 19px;
            height: 48px;
            justify-content: center;
            width: 48px;
        }

        .af-title-wrap h1 {
            font-size: 20px;
            font-weight: 800;
            margin: 0;
        }

        .af-title-wrap p {
            color: rgba(255,255,255,.86);
            font-size: 12px;
            font-weight: 600;
            margin: 4px 0 0;
        }

        .af-close-btn {
            align-items: center;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.28);
            border-radius: 10px;
            color: #fff;
            display: inline-flex;
            height: 38px;
            justify-content: center;
            position: relative;
            width: 38px;
            z-index: 1;
        }

        .af-close-btn:hover,
        .af-close-btn:focus {
            background: rgba(255,255,255,.24);
            color: #fff;
            outline: none;
        }

        .af-dialog-body {
            background: var(--af-soft);
            padding: 18px;
        }

        .af-context-grid {
            background: #fff;
            border: 1px solid var(--af-border);
            border-radius: 13px;
            display: grid;
            gap: 1px;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            margin-bottom: 15px;
            overflow: hidden;
        }

        .af-context-item {
            background: linear-gradient(180deg, #fff 0%, #fbfdff 100%);
            min-width: 0;
            padding: 12px 14px;
        }

        .af-context-item span {
            color: var(--af-muted);
            display: block;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: .35px;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .af-context-item strong {
            color: var(--af-text);
            display: block;
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .af-tabs {
            background: #e8f0fa;
            border: 1px solid #d7e2f0;
            border-radius: 12px;
            display: grid;
            gap: 9px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            margin-bottom: 14px;
            padding: 7px;
        }

        .af-tab-btn {
            align-items: center;
            background: transparent;
            border: 1px solid transparent;
            border-radius: 9px;
            color: #294765;
            display: flex;
            font-size: 12px;
            font-weight: 800;
            gap: 8px;
            height: 42px;
            justify-content: center;
        }

        .af-tab-btn.active {
            background: #fff;
            border-color: #d3deeb;
            box-shadow: 0 7px 16px rgba(15,23,42,.09);
            color: #083344;
        }

        .af-tab-btn.active::after {
            background: var(--af-secondary);
            border-radius: 999px;
            bottom: -1px;
            content: "";
            height: 3px;
            left: 22%;
            position: absolute;
            right: 22%;
        }

        .af-tab-btn { position: relative; }
        .af-tab-panel { display: none; }
        .af-tab-panel.active { animation: afFade .18s ease; display: block; }

        @keyframes afFade {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .af-panel {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-radius: 13px;
            padding: 17px;
        }

        .af-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        .af-field { min-width: 0; }
        .af-field.af-span-2 { grid-column: span 2; }
        .af-field.af-span-3 { grid-column: 1 / -1; }

        .af-field label {
            color: #334155;
            display: block;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 7px;
        }

        .af-control {
            background: #fff;
            border: 1px solid #cbd7e5;
            border-radius: 9px;
            color: #1f2937;
            font-size: 13px;
            height: 42px;
            outline: none;
            padding: 8px 10px;
            transition: border-color .18s ease, box-shadow .18s ease;
            width: 100%;
        }

        .af-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59,130,246,.12);
        }

        .af-control[disabled],
        .af-control[readonly] {
            background: #eef2f7;
            color: #64748b;
        }

        textarea.af-control {
            height: auto;
            line-height: 1.45;
            min-height: 78px;
            resize: vertical;
        }

        .af-panel-actions {
            align-items: center;
            border-top: 1px solid #eaf0f6;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 16px;
            padding-top: 14px;
        }

        .af-btn {
            align-items: center;
            border: 1px solid transparent;
            border-radius: 9px;
            display: inline-flex;
            font-size: 12px;
            font-weight: 800;
            gap: 7px;
            height: 41px;
            justify-content: center;
            min-width: 108px;
            padding: 0 17px;
        }

        .af-btn-primary {
            background: linear-gradient(135deg, var(--af-secondary), var(--af-primary));
            box-shadow: 0 8px 18px rgba(29,78,216,.20);
            color: #fff;
        }

        .af-btn-primary:hover,
        .af-btn-primary:focus { color: #fff; filter: brightness(.97); outline: none; }

        .af-btn-secondary {
            background: #eefaf8;
            border-color: #c8e5e0;
            color: #075e57;
        }

        .af-btn-secondary:hover,
        .af-btn-secondary:focus { background: #def6f1; color: #064e47; outline: none; }

        .af-dropzone {
            align-items: center;
            background: #f8fafc;
            border: 2px dashed #b9c9dc;
            border-radius: 13px;
            cursor: pointer;
            display: flex;
            gap: 16px;
            min-height: 122px;
            padding: 20px;
            transition: background .18s ease, border-color .18s ease;
        }

        .af-dropzone:hover,
        .af-dropzone.is-dragover {
            background: #ecfdf5;
            border-color: var(--af-secondary);
        }

        .af-dropzone i {
            color: var(--af-secondary);
            font-size: 32px;
        }

        .af-dropzone strong {
            color: var(--af-text);
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .af-dropzone span {
            color: var(--af-muted);
            display: block;
            font-size: 12px;
            font-weight: 600;
        }

        .af-import-summary {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            margin: 14px 0;
        }

        .af-summary-card {
            background: #fff;
            border: 1px solid #dce6f2;
            border-left: 4px solid var(--af-primary);
            border-radius: 10px;
            padding: 11px 13px;
        }

        .af-summary-card span {
            color: var(--af-muted);
            display: block;
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .af-summary-card strong {
            color: var(--af-text);
            display: block;
            font-size: 20px;
            margin-top: 3px;
        }

        .af-result-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .af-result-card {
            border: 1px solid #dfe7f0;
            border-radius: 11px;
            min-width: 0;
            overflow: hidden;
        }

        .af-result-title {
            background: #f8fafc;
            border-bottom: 1px solid #e4ebf3;
            color: #334155;
            font-size: 11px;
            font-weight: 800;
            padding: 9px 11px;
        }

        .af-result-scroll { max-height: 190px; overflow: auto; }

        .af-result-table {
            border-collapse: collapse;
            font-size: 11px;
            margin: 0;
            width: 100%;
        }

        .af-result-table th,
        .af-result-table td {
            border-bottom: 1px solid #edf2f7;
            padding: 8px 9px;
            text-align: left;
            vertical-align: top;
        }

        .af-result-table th {
            background: #fff;
            color: #475569;
            font-weight: 800;
            position: sticky;
            top: 0;
        }

        .af-history-panel {
            background: #fff;
            border: 1px solid #dfe8f2;
            border-radius: 13px;
            margin-top: 15px;
            overflow: hidden;
        }

        .af-history-head {
            align-items: center;
            background: linear-gradient(180deg, #fff 0%, #f8fbff 100%);
            border-bottom: 1px solid #e3ebf4;
            display: flex;
            gap: 12px;
            justify-content: space-between;
            padding: 12px 15px;
        }

        .af-history-title {
            align-items: center;
            color: #1e3a5f;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 0;
        }

        .af-history-count {
            background: #e8f1ff;
            border-radius: 999px;
            color: #1849a9;
            font-size: 10px;
            font-weight: 800;
            padding: 4px 8px;
        }

        .af-refresh-btn {
            align-items: center;
            background: #fff;
            border: 1px solid #cfdbe8;
            border-radius: 8px;
            color: #34506e;
            display: inline-flex;
            font-size: 11px;
            font-weight: 800;
            gap: 6px;
            height: 34px;
            padding: 0 11px;
        }

        .af-history-body {
            overflow-x: auto;
            padding: 12px 14px 14px;
        }

        #af_feedbackTable {
            border-collapse: separate !important;
            border-spacing: 0 !important;
            min-width: 900px;
            width: 100% !important;
        }

        #af_feedbackTable thead th {
            background: #f4f7fb;
            border-bottom: 1px solid #dbe5f0 !important;
            color: #42526a;
            font-size: 10px;
            font-weight: 800;
            padding: 10px 9px !important;
            text-transform: uppercase;
            white-space: nowrap;
        }

        #af_feedbackTable tbody td {
            border-bottom: 1px solid #edf2f7 !important;
            color: #344054;
            font-size: 11px;
            padding: 10px 9px !important;
            vertical-align: top;
        }

        #af_feedbackTable_wrapper .dataTables_info,
        #af_feedbackTable_wrapper .dataTables_paginate {
            color: #64748b;
            font-size: 11px;
            padding-top: 11px;
        }

        .af-status-dialog {
            margin-top: 18px;
            max-width: 900px;
        }

        .af-status-dialog .af-dialog-header {
            background: linear-gradient(135deg, #334155 0%, #0f766e 100%);
        }

        .af-status-context-grid {
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .af-status-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .af-status-grid .af-status-remark {
            grid-column: 1 / -1;
        }

        .af-loading {
            align-items: center;
            background: rgba(15,23,42,.32);
            display: none;
            inset: 0;
            justify-content: center;
            position: fixed;
            z-index: 3000;
        }

        .af-loading-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 16px 38px rgba(15,23,42,.24);
            color: #334155;
            font-size: 12px;
            font-weight: 800;
            padding: 19px 24px;
            text-align: center;
        }

        .af-loading-card img {
            display: block;
            height: 46px;
            margin: 0 auto 8px;
            width: 46px;
        }

        @media (max-width: 900px) {
            .af-context-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
            .af-form-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
            .af-field.af-span-3 { grid-column: 1 / -1; }
            .af-status-context-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 640px) {
            .af-page { padding: 7px; }
            .af-dialog { border-radius: 13px; }
            .af-dialog-header { padding: 15px; }
            .af-title-wrap p { display: none; }
            .af-dialog-body { padding: 11px; }
            .af-context-grid, .af-form-grid, .af-import-summary, .af-result-grid, .af-status-grid { grid-template-columns: 1fr; }
            .af-field.af-span-2, .af-field.af-span-3 { grid-column: auto; }
            .af-status-grid .af-status-remark { grid-column: auto; }
            .af-tabs { gap: 6px; }
            .af-panel { padding: 13px; }
            .af-panel-actions { align-items: stretch; flex-direction: column-reverse; }
            .af-panel-actions .af-btn { width: 100%; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="af-loading" id="af_loading" aria-hidden="true">
        <div class="af-loading-card">
            <img src="../images/Load_1.gif" alt="" />
            <span id="af_loadingText">Please wait...</span>
        </div>
    </div>

    <input type="hidden" id="hdnProjectNo" />
    <input type="hidden" id="hdnProjectId" />
    <input type="hidden" id="hdnDealNo" />
    <input type="hidden" id="hdnLoanNo" />
    <input type="hidden" id="hdnOrderDate" />
    <input type="hidden" id="hdnProcess" />
    <input type="hidden" id="hdnErrorBy" />

    <main class="af-page">
        <section class="af-dialog" id="popUp_addTrackingFeedback" role="dialog" aria-labelledby="af_pageTitle" aria-describedby="af_pageDescription">
            <header class="af-dialog-header">
                <div class="af-title-wrap">
                    <span class="af-title-icon"><i class="fas fa-comment-dots"></i></span>
                    <div>
                        <h1 id="af_pageTitle">Tracking Feedback</h1>
                        <p id="af_pageDescription">Add feedback or prepare feedback rows for the selected loan.</p>
                    </div>
                </div>
                <button type="button" class="af-close-btn" id="af_btnClose" aria-label="Close">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <div class="af-dialog-body">
                <div class="af-context-grid" aria-label="Selected order details">
                    <div class="af-context-item">
                        <span>Project</span>
                        <strong id="af_ctxProject">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Deal No</span>
                        <strong id="af_ctxDeal">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Loan No</span>
                        <strong id="af_ctxLoan">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Process</span>
                        <strong id="af_ctxProcess">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Order Date</span>
                        <strong id="af_ctxOrderDate">-</strong>
                    </div>
                </div>

                <nav class="af-tabs" role="tablist" aria-label="Feedback actions">
                    <button type="button" class="af-tab-btn active" id="af_addTab" data-panel="af_addPanel" role="tab" aria-controls="af_addPanel" aria-selected="true">
                        <i class="fas fa-plus-circle"></i>Add Feedback
                    </button>
                    <button type="button" class="af-tab-btn" id="af_importTab" data-panel="af_importPanel" role="tab" aria-controls="af_importPanel" aria-selected="false">
                        <i class="fas fa-file-import"></i>Import Feedback
                    </button>
                </nav>

                <section class="af-tab-panel active" id="af_addPanel" role="tabpanel" aria-labelledby="af_addTab">
                    <div class="af-panel">
                        <div class="af-form-grid">
                            <div class="af-field">
                                <label for="af_markedTo">Marked to</label>
                                <select id="af_markedTo" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Review">Review</option>
                                    <option value="CNCReview">CNCReview</option>
                                    <option value="SSReview">SSReview</option>
                                    <option value="Loan Setup">Loan Setup</option>
                                    <option value="Credit">Credit</option>
                                    <option value="Compliance">Compliance</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_errorBy">Error By</label>
                                <select id="af_errorBy" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_feedbackBy">Feedback By</label>
                                <input id="af_feedbackBy" type="text" class="af-control" readonly="readonly" />
                            </div>

                            <div class="af-field">
                                <label for="af_errorType">Error Type</label>
                                <select id="af_errorType" class="af-control">
                                    <option value="">Select</option>
                                    <option value="NoFeedback">NoFeedback</option>
                                    <option value="Misindexed">Misindexed</option>
                                    <option value="Misinterpretation">Misinterpretation</option>
                                    <option value="Miscalculation">Miscalculation</option>
                                    <option value="Conceptual">Conceptual</option>
                                    <option value="Scienna Data Entry">Scienna Data Entry</option>
                                    <option value="Careless">Careless</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_category">Category</label>
                                <select id="af_category" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_subCategory">Subcategory</label>
                                <select id="af_subCategory" class="af-control">
                                    <option value="">Select</option>
                                </select>
                            </div>

                            <div class="af-field">
                                <label for="af_severity">Severity</label>
                                <select id="af_severity" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Non-Critical">Non-Critical</option>
                                    <option value="Critical">Critical</option>
                                    <option value="Critical-Saleable">Critical-Saleable</option>
                                </select>
                            </div>
                            <div class="af-field">
                                <label for="af_errorField">Error Field</label>
                                <input id="af_errorField" type="text" class="af-control" autocomplete="off" />
                            </div>
                            <div class="af-field">
                                <label for="af_feedbackType">Feedback Type</label>
                                <select id="af_feedbackType" class="af-control">
                                    <option value="">Select</option>
                                    <option value="Internal">Internal</option>
                                    <option value="Client">Client</option>
                                    <option value="On-Shore">On-Shore</option>
                                </select>
                            </div>

                            <div class="af-field af-span-2">
                                <label for="af_error">Error</label>
                                <textarea id="af_error" class="af-control"></textarea>
                            </div>
                            <div class="af-field">
                                <label for="af_shouldBe">Should be</label>
                                <textarea id="af_shouldBe" class="af-control"></textarea>
                            </div>
                            <div class="af-field af-span-3">
                                <label for="af_remark">Remark</label>
                                <textarea id="af_remark" class="af-control"></textarea>
                            </div>
                        </div>

                        <div class="af-panel-actions">
                            <button type="button" class="af-btn af-btn-secondary" id="af_btnClear">
                                <i class="fas fa-eraser"></i>Clear
                            </button>
                            <button type="button" class="af-btn af-btn-primary" id="af_btnSave">
                                <i class="fas fa-save"></i>Add
                            </button>
                        </div>
                    </div>

                    <div class="af-history-panel">
                        <div class="af-history-head">
                            <h2 class="af-history-title">
                                <i class="fas fa-list-alt"></i>Feedback Records
                                <span class="af-history-count" id="af_feedbackCount">0</span>
                            </h2>
                            <button type="button" class="af-refresh-btn" id="af_btnRefreshFeedback">
                                <i class="fas fa-sync-alt"></i>Refresh
                            </button>
                        </div>
                        <div class="af-history-body">
                            <table id="af_feedbackTable" class="table table-sm" aria-label="Feedback records">
                                <thead>
                                    <tr>
                                        <th>Sr. #</th>
                                        <th>Process</th>
                                        <th>Error By</th>
                                        <th>Error Type</th>
                                        <th>Category</th>
                                        <th>Subcategory</th>
                                        <th>Severity</th>
                                        <th>Feedback Type</th>
                                        <th>Remark</th>
                                        <th>Added On</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <section class="af-tab-panel" id="af_importPanel" role="tabpanel" aria-labelledby="af_importTab" hidden="hidden">
                    <div class="af-panel">
                        <input id="af_importFile" type="file" accept=".xls,.xlsx,.csv" hidden="hidden" />
                        <div class="af-dropzone" id="af_dropzone" role="button" tabindex="0" aria-label="Select feedback import file">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <div>
                                <strong id="af_fileName">Drop feedback file here or click to browse</strong>
                                <span>Supported formats: .xls, .xlsx, and .csv. Columns must match the feedback import format.</span>
                            </div>
                        </div>

                        <div class="af-panel-actions">
                            <button type="button" class="af-btn af-btn-secondary" id="af_btnFormat">
                                <i class="fas fa-download"></i>Download Format
                            </button>
                            <button type="button" class="af-btn af-btn-primary" id="af_btnUpload">
                                <i class="fas fa-file-upload"></i>Upload
                            </button>
                        </div>

                        <div class="af-import-summary" aria-label="Import summary">
                            <div class="af-summary-card">
                                <span>Total Rows</span>
                                <strong id="af_importTotal">0</strong>
                            </div>
                            <div class="af-summary-card" style="border-left-color: #0f766e;">
                                <span>Imported</span>
                                <strong id="af_importAdded">0</strong>
                            </div>
                            <div class="af-summary-card" style="border-left-color: #dc2626;">
                                <span>Not Imported</span>
                                <strong id="af_importFailed">0</strong>
                            </div>
                        </div>

                        <div class="af-result-grid">
                            <div class="af-result-card">
                                <div class="af-result-title">Imported feedback</div>
                                <div class="af-result-scroll">
                                    <table class="af-result-table" id="af_addedTable">
                                        <thead>
                                            <tr>
                                                <th>Deal No</th>
                                                <th>Loan 1 #</th>
                                                <th>Process</th>
                                                <th>Error Type</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="af-result-card">
                                <div class="af-result-title">Could not import</div>
                                <div class="af-result-scroll">
                                    <table class="af-result-table" id="af_failedTable">
                                        <thead>
                                            <tr>
                                                <th>Deal No</th>
                                                <th>Loan 1 #</th>
                                                <th>Process</th>
                                                <th>Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </section>

        <section class="af-dialog af-status-dialog" id="popUp_updateOrderStatus" role="dialog" aria-labelledby="af_statusTitle" aria-describedby="af_statusDescription">
            <header class="af-dialog-header">
                <div class="af-title-wrap">
                    <span class="af-title-icon"><i class="fas fa-tasks"></i></span>
                    <div>
                        <h1 id="af_statusTitle">Update Loan Status</h1>
                        <p id="af_statusDescription">Update the selected loan after reviewing its feedback records.</p>
                    </div>
                </div>
            </header>

            <div class="af-dialog-body">
                <div class="af-context-grid af-status-context-grid" aria-label="Loan status context">
                    <div class="af-context-item">
                        <span>Project</span>
                        <strong id="af_statusProject">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Deal No</span>
                        <strong id="af_statusDeal">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Loan No</span>
                        <strong id="af_statusLoan">-</strong>
                    </div>
                    <div class="af-context-item">
                        <span>Process</span>
                        <strong id="af_statusProcess">-</strong>
                    </div>
                </div>

                <div class="af-panel">
                    <div class="af-status-grid">
                        <div class="af-field">
                            <label for="af_status">Status</label>
                            <select id="af_status" class="af-control">
                                <option value="">Select</option>
                                <option value="Completed">Completed</option>
                                <option value="Hold">Hold</option>
                            </select>
                        </div>
                        <div class="af-field">
                            <label for="af_holdReason">Hold Reason</label>
                            <select id="af_holdReason" class="af-control" disabled="disabled">
                                <option value="">Select</option>
                                <option value="PDF Issue">PDF Issue</option>
                                <option value="Audit Worksheet Not available in Box">Audit Worksheet Not available in Box</option>
                                <option value="Partially Review in Scienna">Partially Review in Scienna</option>
                                <option value="Wrongly pulled in ERP">Wrongly pulled in ERP</option>
                                <option value="Miscellaneous – Any other issue with comments">Miscellaneous – Any other issue with comments</option>
                            </select>
                        </div>
                        <div class="af-field af-status-remark">
                            <label for="af_statusRemark">Remark</label>
                            <textarea id="af_statusRemark" class="af-control" placeholder="Enter a status remark if required"></textarea>
                        </div>
                    </div>

                    <div class="af-panel-actions">
                        <button type="button" class="af-btn af-btn-secondary" id="af_btnClearStatus">
                            <i class="fas fa-eraser"></i>Clear
                        </button>
                        <button type="button" class="af-btn af-btn-primary" id="af_btnUpdateStatus">
                            <i class="fas fa-save"></i>Update Status
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Tracking/AddFeedback.js"></script>
</asp:Content>--%>
