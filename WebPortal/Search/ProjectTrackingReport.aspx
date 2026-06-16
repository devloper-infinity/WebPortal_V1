<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="ProjectTrackingReport.aspx.cs" Inherits="WebPortal.Search.ProjectTrackingReport" %>

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
            --track-danger: #dc2626;
            --track-warning: #b45309;
            --track-success: #15803d;
            --track-info: #0369a1;
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

        .tracking-page {
            min-height: calc(100vh - 72px);
            padding: 18px;
            background: var(--track-bg);
        }

        .tracking-header,
        .tracking-shell {
            max-width: 1440px;
            margin: 0 auto;
        }

        .tracking-header {
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

        .tracking-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--track-text);
            font-size: 22px;
            font-weight: 700;
        }

        .tracking-title i {
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

        .tracking-context {
            margin-top: 2px;
            color: var(--track-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .tracking-shell {
            background: var(--track-surface);
            border: 1px solid var(--track-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .tracking-filter-panel {
            padding: 16px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--track-soft);
        }

        .tracking-filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
            align-items: end;
        }

        .tracking-field {
            margin-bottom: 0;
        }

        .tracking-field label,
        .tracking-edit-field label {
            display: block;
            margin-bottom: 5px;
            color: var(--track-text);
            font-size: 12px;
            font-weight: 700 !important;
            line-height: 1.25;
            border: 0 !important;
        }

        .tracking-field .form-control,
        .tracking-edit-field .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            color: var(--track-text);
            font-size: 13px;
            box-shadow: none;
        }

        .tracking-field .form-control:focus,
        .tracking-edit-field .form-control:focus {
            border-color: var(--track-primary);
            box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
        }

        .tracking-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-tracking-primary,
        .btn-tracking-secondary,
        .btn-tracking-success {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 38px;
            border-radius: 7px;
            font-weight: 700;
        }

        .btn-tracking-primary {
            color: #ffffff;
            background: var(--track-primary);
            border-color: var(--track-primary);
        }

        .btn-tracking-primary:hover,
        .btn-tracking-primary:focus {
            color: #ffffff;
            background: var(--track-primary-dark);
            border-color: var(--track-primary-dark);
        }

        .btn-tracking-secondary {
            color: var(--track-text);
            background: #ffffff;
            border-color: var(--track-border);
        }

        .btn-tracking-secondary:hover,
        .btn-tracking-secondary:focus {
            color: var(--track-primary-dark);
            background: #edf7f5;
            border-color: #b7d9d4;
        }

        .btn-tracking-success {
            color: #ffffff;
            background: var(--track-success);
            border-color: var(--track-success);
        }

        .tracking-grid-panel {
            padding: 16px;
        }

        .tracking-grid-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .tracking-grid-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: var(--track-text);
            font-size: 15px;
            font-weight: 700;
        }

        .tracking-grid-header h2 i {
            color: var(--track-accent);
        }

        .tracking-grid-subtitle {
            margin: 0;
            color: var(--track-muted);
            font-size: 12px;
            font-weight: 600;
        }

        .tracking-table-frame {
            border: 1px solid var(--track-soft);
            border-radius: 8px;
            overflow: hidden;
            background: #ffffff;
        }

        .tracking-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        .tracking-table,
        #Search_ProjectTracking,
        #table_track_attachment {
            width: 100% !important;
            margin-bottom: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
        }

        #Search_ProjectTracking {
            min-width: 3400px;
        }

        #table_track_attachment {
            min-width: 980px;
        }

        .tracking-table thead th,
        #Search_ProjectTracking thead th,
        #table_track_attachment thead th {
            color: var(--track-text);
            background: #edf3f6 !important;
            background-image: none !important;
            border-color: #d7e2ea !important;
            border-bottom: 1px solid #d7e2ea !important;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            vertical-align: middle;
        }

        .tracking-table tbody td,
        #Search_ProjectTracking tbody td,
        #table_track_attachment tbody td {
            color: var(--track-text);
            background: #ffffff !important;
            font-size: 12px;
            vertical-align: middle;
        }

        .tracking-table tbody tr:hover td,
        #Search_ProjectTracking tbody tr:hover td,
        #table_track_attachment tbody tr:hover td {
            background: #f8fbfb !important;
        }

        #Search_ProjectTracking tbody tr.tracking-row-hold td {
            background: #fff7cc !important;
        }

        #Search_ProjectTracking tbody tr.tracking-row-dispatch td {
            background: #e5f8ed !important;
        }

        .tracking-icon-btn {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            border-radius: 7px;
        }

        .tracking-chip {
            display: inline-flex;
            align-items: center;
            min-height: 24px;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            line-height: 1.2;
            white-space: nowrap;
        }

        .tracking-chip-neutral {
            color: var(--track-text);
            background: #eef2f7;
        }

        .tracking-chip-success {
            color: #166534;
            background: #dcfce7;
        }

        .tracking-chip-info {
            color: var(--track-info);
            background: #e0f2fe;
        }

        .tracking-chip-warning {
            color: var(--track-warning);
            background: #fef3c7;
        }

        .tracking-chip-danger {
            color: #ffffff;
            background: var(--track-danger);
        }

        .tracking-cell-muted {
            color: var(--track-muted);
            font-weight: 700;
        }

        .tracking-text-wrap {
            min-width: 240px;
            max-width: 360px;
            white-space: normal;
        }

        .dataTables_wrapper .tracking-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 10px;
            flex-wrap: wrap;
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

        .dataTables_wrapper .dt-buttons {
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
        }

        .tracking-modal .modal-dialog {
            max-width: min(1280px, calc(100vw - 32px));
        }

        .tracking-modal .modal-content {
            border: 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 18px 45px rgba(31, 41, 55, .18);
        }

        .tracking-modal .modal-header {
            align-items: center;
            padding: 14px 18px;
            color: #ffffff;
            background: var(--track-primary);
            border-bottom: 0;
        }

        .tracking-modal .modal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            color: #ffffff;
            font-size: 17px;
            font-weight: 700;
        }

        .tracking-modal .close {
            color: #ffffff;
            opacity: 1;
            text-shadow: none;
        }

        .tracking-modal .modal-body {
            padding: 14px;
            background: #fbfcfd;
        }

        .tracking-modal .modal-footer {
            border-top: 1px solid var(--track-soft);
        }

        .tracking-edit-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
        }

        .tracking-edit-field-wide {
            grid-column: span 2;
        }

        .tracking-download-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 7px;
            color: var(--track-primary);
            background: #e7f6f3;
        }

        @media (max-width: 1199px) {
            .tracking-edit-grid {
                grid-template-columns: repeat(3, minmax(180px, 1fr));
            }
        }

        @media (max-width: 991px) {
            .tracking-filter-grid,
            .tracking-edit-grid {
                grid-template-columns: repeat(2, minmax(180px, 1fr));
            }

            .tracking-edit-field-wide {
                grid-column: span 2;
            }
        }

        @media (max-width: 575px) {
            .tracking-page {
                padding: 12px;
            }

            .tracking-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .tracking-title {
                font-size: 19px;
            }

            .tracking-filter-grid,
            .tracking-edit-grid {
                grid-template-columns: 1fr;
            }

            .tracking-edit-field-wide {
                grid-column: span 1;
            }

            .tracking-actions {
                flex-direction: column;
            }

            .tracking-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            if (typeof ProjectTracking_InitPage === "function") {
                ProjectTracking_InitPage();
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="tracking-page">
        <div class="loading" id="load1">
            <div>
                <img src="../images/Load_1.gif" alt="Loading" />
                <div>One moment, please . . . .</div>
            </div>
        </div>

        <div class="tracking-header">
            <div>
                <h1 class="tracking-title"><i class="fas fa-project-diagram"></i><span>Project Tracking Report</span></h1>
                <div class="tracking-context">Search Operations</div>
            </div>
        </div>

        <div class="tracking-shell">
            <div class="tracking-filter-panel">
                <div class="tracking-filter-grid">
                    <div class="form-group tracking-field">
                        <label for="ProjectTracking_projectno">Project #</label>
                        <select id="ProjectTracking_projectno" name="ProjectTracking_projectno" class="form-control"></select>
                    </div>
                    <div class="form-group tracking-field">
                        <label for="ProjectTracking_FromDate">From Date</label>
                        <input type="date" class="form-control" id="ProjectTracking_FromDate" name="ProjectTracking_FromDate" />
                    </div>
                    <div class="form-group tracking-field">
                        <label for="ProjectTracking_ToDate">To Date</label>
                        <input type="date" class="form-control" id="ProjectTracking_ToDate" name="ProjectTracking_ToDate" />
                    </div>
                    <div class="tracking-actions">
                        <button class="btn btn-tracking-secondary" type="button" id="ProjectTracking_btnClear" onclick="return ProjectTracking_ClearReport();">
                            <i class="fas fa-eraser"></i><span>Clear</span>
                        </button>
                        <button class="btn btn-tracking-primary" type="button" id="ProjectTracking_btnShow" onclick="return ProjectTrackingg_btnShowDetails();">
                            <i class="fas fa-search"></i><span>Show</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="tracking-grid-panel">
                <div class="tracking-grid-header">
                    <div>
                        <h2><i class="fas fa-table"></i><span>Tracking Results</span></h2>
                        <p class="tracking-grid-subtitle">Order timeline, ownership, and fulfillment details</p>
                    </div>
                </div>

                <div class="tracking-table-frame">
                    <div class="tracking-table-wrap">
                        <table class="table table-hover table-sm tracking-table" id="Search_ProjectTracking">
                            <thead>
                                <tr>
                                    <th>Actions</th>
                                    <th>Sr. #</th>
                                    <th>OrderID</th>
                                    <th>Project</th>
                                    <th>Client Order #</th>
                                    <th>Order Date</th>
                                    <th>Order DateTime</th>
                                    <th>Order Status</th>
                                    <th>Product Type</th>
                                    <th>Borrower Name</th>
                                    <th>Transaction Type</th>
                                    <th>Property Address</th>
                                    <th>State</th>
                                    <th>County</th>
                                    <th>On / Offline</th>
                                    <th>Search</th>
                                    <th>Search Start Date</th>
                                    <th>Search End Date</th>
                                    <th>ReSearch</th>
                                    <th>Research Start Date</th>
                                    <th>Research End Date</th>
                                    <th>Audit By</th>
                                    <th>Audit Start Date</th>
                                    <th>Audit End Date</th>
                                    <th>Tax By</th>
                                    <th>Tax Start Date</th>
                                    <th>Tax End Date</th>
                                    <th>Typing By</th>
                                    <th>Typing Start Date</th>
                                    <th>Typing End Date</th>
                                    <th>QA By</th>
                                    <th>QA Start Date</th>
                                    <th>QA End Date</th>
                                    <th>Dispatch By</th>
                                    <th>Dispatch Start Date</th>
                                    <th>Dispatch End Date</th>
                                    <th>Legal Description</th>
                                    <th>Client ID</th>
                                    <th>Customer Type</th>
                                    <th>Order Priority</th>
                                    <th>Pin</th>
                                    <th>Instruction</th>
                                    <th>Remark</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade tracking-modal" id="PrjTracking_EditOrder" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title">
                            <i class="fas fa-edit"></i>
                            <span id="searchEditOrder_lbl">Edit Order</span>
                        </h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="modal-body">
                        <div class="tracking-edit-grid">
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_OrderDate">Order Date</label>
                                <input type="date" class="form-control" id="Edit_OrderDate" name="Edit_OrderDate" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_receiveddate">Received Datetime</label>
                                <input type="date" id="Edit_receiveddate" name="Edit_receiveddate" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_projectno">Project #</label>
                                <select id="Edit_projectno" name="Edit_projectno" class="form-control" onchange="return prjTrack_BindTemplate(this);" readonly="readonly"></select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_ClientOrder">Client Order #</label>
                                <input type="text" id="Edit_ClientOrder" name="Edit_ClientOrder" class="form-control" readonly="readonly" />
                            </div>

                            <div class="form-group tracking-edit-field">
                                <label for="Edit_BorrowerName">Borrower Name</label>
                                <input type="text" id="Edit_BorrowerName" name="Edit_BorrowerName" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_State">State</label>
                                <select id="Edit_State" name="Edit_State" class="form-control" onchange="return prjTrack_BindCounty(this);"></select>
                            </div>
                            <div class="form-group tracking-edit-field tracking-edit-field-wide">
                                <label for="Edit_PropertyAddress">Property Address</label>
                                <textarea id="Edit_PropertyAddress" name="Edit_PropertyAddress" class="form-control" rows="2"></textarea>
                            </div>

                            <div class="form-group tracking-edit-field">
                                <label for="Edit_County">County</label>
                                <select id="Edit_County" name="Edit_County" class="form-control"></select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_Producttype">Product Type</label>
                                <select id="Edit_Producttype" name="Edit_Producttype" class="form-control"></select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_template">Template</label>
                                <select id="Edit_template" name="Edit_template" class="form-control" readonly="readonly"></select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_expTAT">Expected TAT</label>
                                <select id="Edit_expTAT" name="Edit_expTAT" class="form-control">
                                    <option value="">Select</option>
                                    <option value="24">24 Hours</option>
                                    <option value="48">48 Hours</option>
                                    <option value="72">72 Hours</option>
                                    <option value="OverNight">OverNight</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="form-group tracking-edit-field">
                                <label for="Edit_onoffline">On / Offline</label>
                                <select id="Edit_onoffline" name="Edit_onoffline" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Online">Online</option>
                                    <option value="Online-Trace">Online-Trace</option>
                                    <option value="Online-MS">Online-MS</option>
                                    <option value="Offline">Offline</option>
                                    <option value="Online to Offline">Online to Offline</option>
                                    <option value="OnTrace to Offline">On-Trace to Offline</option>
                                </select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_exhibit">Exhibit</label>
                                <select id="Edit_exhibit" name="Edit_exhibit" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Exhibit-B">Exhibit-B</option>
                                    <option value="Exhibit-D">Exhibit-D</option>
                                </select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_transaction">Transaction</label>
                                <select id="Edit_transaction" name="Edit_transaction" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Refinance">Refinance</option>
                                    <option value="Purchase">Purchase</option>
                                </select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_salesprice">Sales Price</label>
                                <input type="text" id="Edit_salesprice" name="Edit_salesprice" class="form-control" />
                            </div>

                            <div class="form-group tracking-edit-field">
                                <label for="Edit_sellername">Seller Name</label>
                                <input type="text" id="Edit_sellername" name="Edit_sellername" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_clientId">Client ID</label>
                                <input type="text" id="Edit_clientId" name="Edit_clientId" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_customerType">Customer Type</label>
                                <select id="Edit_customerType" name="Edit_customerType" class="form-control">
                                    <option value="">Select</option>
                                    <option value="NA">NA</option>
                                    <option value="DTO">DTO</option>
                                    <option value="EQUITY">EQUITY</option>
                                    <option value="PostClose">PostClose</option>
                                </select>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_orderpriority">Order Priority</label>
                                <select id="Edit_orderpriority" name="Edit_orderpriority" class="form-control">
                                    <option value="">Select</option>
                                    <option value="Normal">Normal</option>
                                    <option value="Rush">Rush</option>
                                </select>
                            </div>

                            <div class="form-group tracking-edit-field">
                                <label for="Edit_pin">Pin #</label>
                                <input type="text" id="Edit_pin" name="Edit_pin" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_instruction">Instruction</label>
                                <input type="text" id="Edit_instruction" name="Edit_instruction" class="form-control" />
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="Edit_searcher">Searcher</label>
                                <input type="text" id="Edit_searcher" name="Edit_searcher" class="form-control" readonly="readonly" />
                                <label id="lbl_searcher" name="lbl_searcher" style="display: none;"></label>
                            </div>
                            <div class="form-group tracking-edit-field">
                                <label for="orderentry_attachment">Attachment</label>
                                <input type="file" id="orderentry_attachment" name="orderentry_attachment" class="form-control" />
                            </div>

                            <div class="form-group tracking-edit-field tracking-edit-field-wide">
                                <label for="Edit_legaldescription">Legal Description</label>
                                <textarea id="Edit_legaldescription" name="Edit_legaldescription" class="form-control" rows="2"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-tracking-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>Close</span>
                        </button>
                        <button class="btn btn-tracking-success" type="button" id="btnStep5" onclick="return prjTrack_UpdateOrder();">
                            <i class="fas fa-save"></i><span>Update</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade tracking-modal" id="popUp_prjTrack_Attachment" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title"><i class="fas fa-paperclip"></i><span>Attachments</span></h1>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="modal-body">
                        <div class="tracking-table-frame">
                            <div class="tracking-table-wrap">
                                <table class="table table-hover table-sm tracking-table" id="table_track_attachment">
                                    <thead>
                                        <tr>
                                            <th>Current Doc</th>
                                            <th>Backup Doc</th>
                                            <th>Order #</th>
                                            <th>Status</th>
                                            <th>Process</th>
                                            <th>Remark</th>
                                            <th>Added By</th>
                                            <th>Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-tracking-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>Close</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
