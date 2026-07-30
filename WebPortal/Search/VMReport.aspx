<%@ Page Title="VM Reports" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="VMReport.aspx.cs" Inherits="WebPortal.Search.VMReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../plugins/sweetalert2-theme-bootstrap-4/bootstrap-4.min.css" rel="stylesheet" />
    <style>
        :root {
            --vmr-primary: #0f766e;
            --vmr-primary-dark: #115e59;
            --vmr-border: #dbe4ea;
            --vmr-bg: #f4f6f8;
            --vmr-muted: #64748b;
        }

        .vmr-page {
            min-height: calc(100vh - 70px);
            padding: 14px;
            color: #1f2937;
            background: var(--vmr-bg);
        }

        .vmr-shell {
            max-width: 1700px;
            margin: 0 auto;
        }

        .vmr-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 12px;
            padding: 15px 18px;
            background: #fff;
            border: 1px solid var(--vmr-border);
            border-left: 4px solid var(--vmr-primary);
            border-radius: 9px;
        }

        .vmr-title {
            margin: 0;
            color: #172033;
            font-size: 21px;
            font-weight: 700;
        }

        .vmr-subtitle {
            margin-top: 3px;
            color: var(--vmr-muted);
            font-size: 12px;
        }

        .vmr-tabs {
            overflow: hidden;
            background: #fff;
            border: 1px solid var(--vmr-border);
            border-radius: 9px;
        }

            .vmr-tabs > .nav {
                gap: 3px;
                padding: 10px 10px 0;
                border-bottom: 1px solid var(--vmr-border);
            }

                .vmr-tabs > .nav .nav-link {
                    padding: 10px 16px;
                    color: #475569;
                    background: #eef2f6;
                    border: 0;
                    border-radius: 6px 6px 0 0;
                    font-weight: 700;
                }

                    .vmr-tabs > .nav .nav-link.active {
                        color: #fff;
                        background: var(--vmr-primary);
                    }

            .vmr-tabs .tab-pane {
                padding: 14px;
            }

        .vmr-subtabs {
            display: flex;
            gap: 7px;
            margin-bottom: 12px;
        }

        .vmr-subtab {
            min-height: 34px;
            padding: 7px 14px;
            color: #475569;
            background: #f1f5f9;
            border: 1px solid #dbe4ea;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

            .vmr-subtab.active {
                color: #fff;
                background: #2563a6;
                border-color: #2563a6;
            }

        .vmr-card {
            margin-bottom: 12px;
            background: #fff;
            border: 1px solid var(--vmr-border);
            border-radius: 8px;
        }

        .vmr-card-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 10px 13px;
            color: #065f5b;
            border-bottom: 1px solid var(--vmr-border);
            font-size: 13px;
            font-weight: 700;
        }

        .vmr-card-body {
            padding: 13px;
        }

        .vmr-grid {
            display: grid;
            grid-template-columns: repeat(12,minmax(0,1fr));
            gap: 11px;
            align-items: end;
        }

        .vmr-col-2 {
            grid-column: span 2;
        }

        .vmr-col-3 {
            grid-column: span 3;
        }

        .vmr-col-4 {
            grid-column: span 4;
        }

        .vmr-col-6 {
            grid-column: span 6;
        }

        .vmr-col-8 {
            grid-column: span 8;
        }

        .vmr-col-12 {
            grid-column: span 12;
        }

        .vmr-field label {
            display: block;
            margin-bottom: 5px;
            color: #334155;
            font-size: 11px;
            font-weight: 700;
        }

        .vmr-field .required:after {
            content: " *";
            color: #dc2626;
        }

        .vmr-control {
            width: 100%;
            min-height: 38px;
            padding: 7px 10px;
            color: #1f2937;
            background: #fff;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
        }

            .vmr-control:focus {
                border-color: var(--vmr-primary);
                box-shadow: 0 0 0 3px rgba(15,118,110,.11);
                outline: 0;
            }

        textarea.vmr-control {
            min-height: 78px;
            resize: vertical;
        }

        .vmr-radio-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            min-height: 38px;
        }

            .vmr-radio-row label {
                margin: 0;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
            }

        .vmr-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-height: 36px;
            padding: 7px 13px;
            border: 1px solid transparent;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .vmr-btn-primary {
            color: #fff;
            background: var(--vmr-primary);
        }

            .vmr-btn-primary:hover {
                color: #fff;
                background: var(--vmr-primary-dark);
            }

        .vmr-btn-light {
            color: #334155;
            background: #f8fafc;
            border-color: #d5dee7;
        }

        .vmr-btn-success {
            color: #fff;
            background: #15803d;
        }

        .vmr-btn-xs {
            min-width: 30px;
            min-height: 29px;
            padding: 4px 7px;
        }

        .vmr-actions {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            flex-wrap: nowrap;
            white-space: nowrap;
        }

        .vmr-action-attachment {
            color: #7e22ce;
            background: #f3e8ff;
            border-color: #d8b4fe;
        }

        .vmr-action-comment {
            color: #0f766e;
            background: #ccfbf1;
            border-color: #5eead4;
        }

        .vmr-action-feedback {
            color: #0369a1;
            background: #e0f2fe;
            border-color: #7dd3fc;
        }

        .vmr-download-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 31px;
            height: 31px;
            color: #fff;
            background: linear-gradient(135deg,#7c3aed,#2563eb);
            border: 1px solid #6d28d9;
            border-radius: 9px;
            box-shadow: 0 3px 8px rgba(79,70,229,.25);
            font-size: 14px;
            transition: transform .15s ease,box-shadow .15s ease;
        }

            .vmr-download-icon:hover {
                color: #fff;
                transform: translateY(-1px);
                box-shadow: 0 5px 12px rgba(79,70,229,.35);
                text-decoration: none;
            }

        .vmr-record-count {
            padding: 4px 10px;
            color: #03695f;
            background: #e8f7f4;
            border: 1px solid #c6e9e3;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
        }

        .vmr-table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        .vmr-table {
            width: 100% !important;
            margin: 0 !important;
            font-size: 11px;
        }

            .vmr-table thead th {
                color: #0f3d56;
                background: #e8f2f7;
                border-bottom: 2px solid #58a0c4 !important;
                white-space: nowrap;
            }

            .vmr-table tbody td {
                vertical-align: middle;
                white-space: nowrap;
            }

        .vmr-row-hold td {
            background: #fff4bf !important;
        }

        .vmr-row-cancel td {
            background: #f8d3d3 !important;
        }

        .vmr-row-purple td {
            color: #7e22ce;
        }

        .vmr-remark {
            color: #3b82b6;
            font-weight: 600;
        }

        .vmr-modal-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 11px;
        }

            .vmr-modal-table th, .vmr-modal-table td {
                padding: 7px;
                border: 1px solid #dce4eb;
            }

            .vmr-modal-table th {
                color: #0f4c5c;
                background: #e6f4f6;
                border-bottom: 2px solid #25a6b8;
                white-space: nowrap;
            }

        .vmr-empty {
            padding: 18px !important;
            color: #64748b;
            text-align: center;
        }

        .vmr-comment-summary, .vmr-comment-form {
            padding: 12px;
            border: 1px solid #dce6ee;
            border-radius: 8px;
        }

        .vmr-comment-summary {
            background: #f8fafc;
        }

        .vmr-comment-form {
            margin-top: 12px;
            background: #fff;
        }

        #vmrLoader {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 2147483647;
            align-items: center;
            justify-content: center;
            background: rgba(248,250,252,.76);
        }

            #vmrLoader.active {
                display: flex;
            }

        .vmr-spinner {
            width: 52px;
            height: 52px;
            border: 5px solid #dbe7e5;
            border-top-color: var(--vmr-primary);
            border-radius: 50%;
            animation: vmrSpin .75s linear infinite;
        }

        @keyframes vmrSpin {
            to {
                transform: rotate(360deg);
            }
        }

        .dataTables_wrapper .dataTables_filter input, .dataTables_wrapper .dataTables_length select {
            border: 1px solid #cbd5e1;
            border-radius: 7px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0 !important;
            border: 0 !important;
        }

        @media(max-width:992px) {
            .vmr-col-2, .vmr-col-3, .vmr-col-4, .vmr-col-6, .vmr-col-8 {
                grid-column: span 6;
            }
        }

        @media(max-width:576px) {
            .vmr-page {
                padding: 8px;
            }

            .vmr-col-2, .vmr-col-3, .vmr-col-4, .vmr-col-6, .vmr-col-8 {
                grid-column: span 12;
            }

            .vmr-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="vmrLoader">
        <div class="vmr-spinner"></div>
    </div>
    <main class="vmr-page">
        <div class="vmr-shell">
            <header class="vmr-header search-modern-header">
                <div class="search-header-identity">
                    <span class="search-header-icon"><i class="fas fa-chart-pie"></i></span>
                    <div class="search-header-copy">
                        <h1 class="vmr-title"><span>VM Reports</span></h1>
                        <div class="vmr-subtitle">Billing analysis and VM tracking in one workspace</div>
                    </div>
                </div>
                <button type="button" id="vmrRefreshActive" class="vmr-btn vmr-btn-light"><i class="fas fa-sync-alt"></i>Refresh active tab</button>
            </header>

            <section class="vmr-tabs">
                <ul class="nav nav-tabs" id="vmrMainTabs" role="tablist">
                    <li class="nav-item"><a class="nav-link active" id="vmrBillingTab" data-toggle="tab" href="#vmrBillingPane" role="tab"><i class="fas fa-file-invoice-dollar mr-1"></i>Billing Report</a></li>
                    <li class="nav-item"><a class="nav-link" id="vmrTrackingTab" data-toggle="tab" href="#vmrTrackingPane" role="tab"><i class="fas fa-route mr-1"></i>Tracking Sheet</a></li>
                </ul>

                <div class="tab-content">
                    <section class="tab-pane fade show active" id="vmrBillingPane" role="tabpanel">
                        <div class="vmr-subtabs">
                            <button type="button" class="vmr-subtab active" data-billing-view="summary">VM Billing Report</button>
                            <button type="button" class="vmr-subtab" data-billing-view="details">VM Billing Report (Details)</button>
                        </div>

                        <div id="vmrBillingSummaryView">
                            <div class="vmr-card">
                                <div class="vmr-card-title"><span>Billing Filters</span></div>
                                <div class="vmr-card-body">
                                    <div class="vmr-grid">
                                        <div class="vmr-col-4 vmr-field">
                                            <label class="required">Project</label><select id="vmrBillingProject" class="vmr-control"><option value="">Select</option>
                                            </select></div>
                                        <div class="vmr-col-3 vmr-field">
                                            <label class="required">From Date</label><input id="vmrBillingFrom" type="date" class="vmr-control" /></div>
                                        <div class="vmr-col-3 vmr-field">
                                            <label class="required">To Date</label><input id="vmrBillingTo" type="date" class="vmr-control" /></div>
                                        <div class="vmr-col-2">
                                            <button type="button" id="vmrShowBilling" class="vmr-btn vmr-btn-primary w-100"><i class="fas fa-search"></i>Show</button></div>
                                    </div>
                                </div>
                            </div>
                            <div class="vmr-card">
                                <div class="vmr-card-title"><span>VM Billing Report</span><div class="vmr-actions">
                                    <button type="button" id="vmrExportBilling" class="vmr-btn vmr-btn-success vmr-btn-xs"><i class="fas fa-file-excel"></i>Export Excel</button><span id="vmrBillingCount" class="vmr-record-count">0 records</span></div>
                                </div>
                                <div class="vmr-card-body vmr-table-wrap">
                                    <table id="vmrBillingTable" class="table table-striped table-hover vmr-table">
                                        <thead>
                                            <tr></tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div id="vmrBillingDetailsView" style="display: none">
                            <div class="vmr-card">
                                <div class="vmr-card-title"><span>Billing Details Filters</span></div>
                                <div class="vmr-card-body">
                                    <div class="vmr-grid">
                                        <div class="vmr-col-4 vmr-field">
                                            <label class="required">Project</label><select id="vmrBillingDetailsProject" class="vmr-control"><option value="">Select</option>
                                            </select></div>
                                        <div class="vmr-col-3 vmr-field">
                                            <label class="required">From Date</label><input id="vmrBillingDetailsFrom" type="date" class="vmr-control" /></div>
                                        <div class="vmr-col-3 vmr-field">
                                            <label class="required">To Date</label><input id="vmrBillingDetailsTo" type="date" class="vmr-control" /></div>
                                        <div class="vmr-col-2">
                                            <button type="button" id="vmrShowBillingDetails" class="vmr-btn vmr-btn-primary w-100"><i class="fas fa-search"></i>Show</button></div>
                                    </div>
                                </div>
                            </div>
                            <div class="vmr-card">
                                <div class="vmr-card-title"><span>VM Billing Report (Details)</span><div class="vmr-actions">
                                    <button type="button" id="vmrExportBillingDetails" class="vmr-btn vmr-btn-success vmr-btn-xs"><i class="fas fa-file-excel"></i>Export Excel</button><span id="vmrBillingDetailsCount" class="vmr-record-count">0 records</span></div>
                                </div>
                                <div class="vmr-card-body vmr-table-wrap">
                                    <table id="vmrBillingDetailsTable" class="table table-striped table-hover vmr-table">
                                        <thead>
                                            <tr></tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="tab-pane fade" id="vmrTrackingPane" role="tabpanel">
                        <div class="vmr-card">
                            <div class="vmr-card-title"><span>Tracking Filters</span></div>
                            <div class="vmr-card-body">
                                <div class="vmr-grid">
                                    <div class="vmr-col-3 vmr-field">
                                        <label class="required">Project</label><select id="vmrTrackingProject" class="vmr-control"><option value="">Select</option>
                                        </select></div>
                                    <div class="vmr-col-2 vmr-field">
                                        <label class="required">From Date</label><input id="vmrTrackingFrom" type="date" class="vmr-control" /></div>
                                    <div class="vmr-col-2 vmr-field">
                                        <label class="required">To Date</label><input id="vmrTrackingTo" type="date" class="vmr-control" /></div>
                                    <div class="vmr-col-3 vmr-field">
                                        <label>Order View</label><div class="vmr-radio-row">
                                            <label id="vmrAllOrdersOption">
                                                <input type="radio" name="vmrTrackingView" value="all" />
                                                Tracking Sheet</label><label><input type="radio" name="vmrTrackingView" value="mine" checked />
                                                    My Orders</label></div>
                                    </div>
                                    <div class="vmr-col-2">
                                        <button type="button" id="vmrShowTracking" class="vmr-btn vmr-btn-primary w-100"><i class="fas fa-search"></i>Show</button></div>
                                </div>
                            </div>
                        </div>
                        <div class="vmr-card">
                            <div class="vmr-card-title"><span>VM Tracking Sheet</span><div class="vmr-actions">
                                <button type="button" id="vmrExportTracking" class="vmr-btn vmr-btn-success vmr-btn-xs"><i class="fas fa-file-excel"></i>Export Excel</button><span id="vmrTrackingCount" class="vmr-record-count">0 records</span></div>
                            </div>
                            <div class="vmr-card-body vmr-table-wrap">
                                <table id="vmrTrackingTable" class="table table-striped table-hover vmr-table">
                                    <thead>
                                        <tr></tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </div>
            </section>
        </div>
    </main>

    <div class="modal fade" id="vmrDetailModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 id="vmrDetailTitle" class="modal-title">Details</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button></div>
                <div id="vmrDetailContent" class="modal-body vmr-table-wrap"></div>
                <div class="modal-footer">
                    <button type="button" class="vmr-btn vmr-btn-light" data-dismiss="modal">Close</button></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="vmrCommentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-comment-dots mr-2"></i>FollowUp</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button></div>
                <div class="modal-body">
                    <input id="vmrCommentOrderId" type="hidden" />
                    <div class="vmr-comment-summary">
                        <div class="vmr-grid">
                            <div class="vmr-col-3 vmr-field">
                                <label>Order #</label><input id="vmrCommentOrderNo" class="vmr-control" readonly /></div>
                            <div class="vmr-col-3 vmr-field">
                                <label>Order Date</label><input id="vmrCommentOrderDate" class="vmr-control" readonly /></div>
                            <div class="vmr-col-3 vmr-field">
                                <label>VM</label><input id="vmrCommentVm" class="vmr-control" readonly /></div>
                            <div class="vmr-col-3 vmr-field">
                                <label>Abstractor</label><input id="vmrCommentAbstractor" class="vmr-control" readonly /></div>
                        </div>
                    </div>
                    <div class="vmr-comment-form">
                        <div class="vmr-grid">
                            <div class="vmr-col-4 vmr-field">
                                <label class="required">Type</label><select id="vmrCommentType" class="vmr-control"><option value="Select">Select</option>
                                    <option value="Connect With Abstractor">Connect With Abstractor</option>
                                    <option value="Disconnect With Abstractor">Disconnect With Abstractor</option>
                                </select></div>
                            <div class="vmr-col-8 vmr-field">
                                <label class="required">Remark</label><textarea id="vmrCommentText" class="vmr-control"></textarea></div>
                            <div class="vmr-col-12">
                                <button id="vmrSaveComment" type="button" class="vmr-btn vmr-btn-primary"><i class="fas fa-paper-plane"></i>Submit</button></div>
                        </div>
                    </div>
                    <div id="vmrCommentsContent" class="vmr-table-wrap mt-3"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="../plugins/sweetalert2/sweetalert2.all.min.js"></script>
    <script src="../Scripts/Search/VMReport.js?v=4"></script>
</asp:Content>
