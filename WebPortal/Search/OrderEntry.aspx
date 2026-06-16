<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="OrderEntry.aspx.cs" Inherits="WebPortal.Search.OrderEntry" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --order-bg: #f4f6f8;
            --order-surface: #ffffff;
            --order-border: #d9e1e8;
            --order-border-soft: #eef2f5;
            --order-text: #1f2937;
            --order-muted: #667085;
            --order-primary: #0f766e;
            --order-primary-dark: #115e59;
            --order-accent: #2563eb;
            --order-warning: #f59e0b;
        }

        .loading {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 99999;
            background: rgba(248, 250, 252, .72);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            text-align: center;
        }

            .loading img {
                width: 64px;
                height: 64px;
                display: block;
                margin: 0 auto 10px;
            }

            .loading div {
                font-size: 12px;
                font-weight: 700;
                color: var(--order-text);
            }

        .order-entry-page {
            background: var(--order-bg);
            min-height: calc(100vh - 72px);
            padding: 18px;
        }

        .order-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            max-width: 1440px;
            margin: 0 auto 14px;
            padding: 14px 18px;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-left: 4px solid var(--order-primary);
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 41, 55, .05);
        }

        .order-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
            color: var(--order-text);
            font-size: 22px;
            font-weight: 700;
        }

            .order-title i {
                width: 36px;
                height: 36px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: #ffffff;
                background: var(--order-primary);
                border-radius: 8px;
                font-size: 15px;
            }

        .order-context {
            color: var(--order-muted);
            font-size: 12px;
            font-weight: 600;
            margin-top: 2px;
        }

        .order-shell {
            max-width: 1440px;
            margin: 0 auto;
            background: var(--order-surface);
            border: 1px solid var(--order-border);
            border-radius: 8px;
            box-shadow: 0 12px 30px rgba(31, 41, 55, .06);
            overflow: hidden;
        }

        .order-tabs {
            gap: 4px;
            padding: 10px 12px 0;
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border);
            font-weight: 700;
        }

            .order-tabs .nav-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: var(--order-muted);
                border: 0;
                border-radius: 8px 8px 0 0;
                padding: 11px 16px;
                min-height: 42px;
                transition: background-color .18s ease, color .18s ease;
            }

                .order-tabs .nav-link:hover {
                    color: var(--order-primary);
                    background: #edf7f5;
                }

                .order-tabs .nav-link.active {
                    color: var(--order-primary-dark);
                    background: var(--order-surface);
                    border: 1px solid var(--order-border);
                    border-bottom-color: var(--order-surface);
                    margin-bottom: -1px;
                }

        .order-tab-content {
            padding: 16px;
            background: var(--order-surface);
        }

        .order-form-panel {
            border: 1px solid var(--order-border-soft);
            border-radius: 8px;
            background: #ffffff;
            overflow: hidden;
        }

        .order-section {
            padding: 16px;
            border-bottom: 1px solid var(--order-border-soft);
        }

            .order-section:last-child {
                border-bottom: 0;
            }

        .section-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 0 12px;
            color: var(--order-text);
            font-size: 14px;
            font-weight: 700;
        }

            .section-title i {
                color: var(--order-primary);
            }

        .field-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 14px 16px;
        }

            .field-grid.two-col {
                grid-template-columns: repeat(4, minmax(180px, 1fr));
            }

            .field-grid .wide {
                grid-column: span 1;
            }

        .property-grid .property-address-field {
            grid-column: 1 / span 2;
            grid-row: 2;
        }

        .property-grid .property-legal-field {
            grid-column: 3 / span 2;
            grid-row: 2;
        }

        .order-field {
            margin-bottom: 0;
        }

            .order-field label {
                display: block;
                margin-bottom: 5px;
                color: var(--order-text);
                font-size: 12px;
                font-weight: 700 !important;
                border: 0 !important;
                line-height: 1.25;
            }

            .order-field .required {
                color: #dc2626;
            }

            .order-field .form-control {
                width: 100%;
                min-height: 38px;
                border: 1px solid #ccd6df;
                border-radius: 7px;
                font-size: 13px;
                color: var(--order-text);
                box-shadow: none;
            }

            .order-field textarea.form-control {
                min-height: 78px;
                resize: vertical;
            }

            .order-field .form-control:focus {
                border-color: var(--order-primary);
                box-shadow: 0 0 0 3px rgba(15, 118, 110, .12);
            }

            .order-field .form-control.is-invalid {
                border-color: #dc2626;
                box-shadow: 0 0 0 3px rgba(220, 38, 38, .12);
            }

        .order-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            padding: 14px 16px;
            background: #fbfcfd;
            border-top: 1px solid var(--order-border-soft);
        }

            .order-actions .btn,
            .import-actions .btn,
            .modal-footer .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                min-height: 38px;
                border-radius: 7px;
                font-weight: 700;
            }

        .btn-order-primary {
            color: #ffffff;
            background: var(--order-primary);
            border-color: var(--order-primary);
        }

            .btn-order-primary:hover,
            .btn-order-primary:focus {
                color: #ffffff;
                background: var(--order-primary-dark);
                border-color: var(--order-primary-dark);
            }

        .btn-order-secondary {
            color: var(--order-text);
            background: #ffffff;
            border-color: var(--order-border);
        }

            .btn-order-secondary:hover,
            .btn-order-secondary:focus {
                color: var(--order-primary-dark);
                background: #edf7f5;
                border-color: #b7d9d4;
            }

        .order-grid-panel {
            margin-top: 16px;
            border: 1px solid var(--order-border-soft);
            border-radius: 8px;
            overflow: hidden;
        }

        .grid-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border-soft);
        }

            .grid-panel-header h2 {
                display: flex;
                align-items: center;
                gap: 8px;
                margin: 0;
                font-size: 15px;
                font-weight: 700;
                color: var(--order-text);
            }

                .grid-panel-header h2 i {
                    color: var(--order-accent);
                }

        .order-table-wrap {
            padding: 12px;
            overflow-x: auto;
        }

        #table_orderentry {
            width: 100% !important;
            margin-bottom: 0;
            border-collapse: separate !important;
            border-spacing: 0;
        }

            #table_orderentry thead th {
                  background: #edf3f6 !important;
  border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                /*text-align: center;*/
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_orderentry tbody td {
                vertical-align: middle;
                font-size: 12px;
                color: #263747;
                background: #ffffff;
            }

            #table_orderentry tbody tr:hover td {
              /*  background: #f8fbfb;*/
               background: #f7fbfa;
            }

        table.dataTable tbody tr.selected-row > td {
            background-color: #dff3ef !important;
            color: var(--order-primary-dark);
            font-weight: 700;
        }

        .order-icon-btn {
            width: 32px;
            height: 32px;
            padding: 0;
            border-radius: 7px;
        }

        .order-grid-tools,
        .dataTables_wrapper .order-table-toolbar {
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

            .dataTables_wrapper .dataTables_filter input {
                min-height: 34px;
                border: 1px solid #ccd6df;
                border-radius: 7px;
                margin-left: 6px;
            }

        .dataTables_wrapper .dataTables_info {
            float: none !important;
            padding-top: 10px;
            color: var(--order-muted);
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate {
            padding-top: 8px;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #ffffff !important;
            background: var(--order-accent) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            box-shadow: none !important;
        }

        .import-panel {
            display: grid;
            grid-template-columns: minmax(260px, 1fr) auto;
            gap: 16px;
            align-items: end;
            border: 1px solid var(--order-border-soft);
            border-radius: 8px;
            padding: 16px;
            background: #ffffff;
        }

        .import-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: flex-end;
        }

        .modal-content {
            border-radius: 8px;
            border: 0;
            box-shadow: 0 18px 45px rgba(31, 41, 55, .18);
        }

        .modal-header {
            align-items: center;
            border-bottom-color: var(--order-border-soft);
        }

        .modal-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 17px;
            font-weight: 700;
            color: var(--order-text);
        }

            .modal-title i {
                color: #dc2626;
            }

        @media (max-width: 991px) {
            .field-grid {
                grid-template-columns: repeat(2, minmax(220px, 1fr));
            }

                .field-grid.two-col {
                    grid-template-columns: repeat(2, minmax(220px, 1fr));
                }

            .property-grid .property-address-field,
            .property-grid .property-legal-field {
                grid-column: 1 / -1;
                grid-row: auto;
            }
        }

        @media (max-width: 767px) {
            .order-entry-page {
                padding: 12px;
            }

            .order-page-header,
            .grid-panel-header,
            .order-actions,
            .import-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .order-title {
                font-size: 19px;
            }

            .field-grid,
            .field-grid.two-col,
            .import-panel {
                grid-template-columns: 1fr;
            }

                .field-grid .wide {
                    grid-column: span 1;
                }

            .order-tabs .nav-link {
                width: 100%;
                justify-content: center;
            }

            .order-actions .btn,
            .import-actions .btn {
                width: 100%;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            if (typeof OrderEntry_InitPage === "function") {
                OrderEntry_InitPage();
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="order-entry-page">
        <div class="loading" id="load1">
            <div>
                <img src="../images/Load_1.gif" alt="Loading" />
                <div>One moment, please . . . .</div>
            </div>
        </div>

        <div class="order-page-header">
            <div>
                <h1 class="order-title"><i class="fas fa-clipboard-list"></i><span>Order Entry</span></h1>
                <div class="order-context">Search Operations</div>
            </div>
        </div>

        <div class="order-shell">
            <ul class="nav nav-tabs order-tabs" id="custom-tabs-one-tab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">
                        <i class="fas fa-file-signature"></i><span>Single Order Entry</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="custom-tabs-one-excel-tab" data-toggle="pill" href="#custom-tabs-one-excel" role="tab" aria-controls="custom-tabs-one-excel" aria-selected="false">
                        <i class="fas fa-file-excel"></i><span>Import Excel</span>
                    </a>
                </li>
                <li class="nav-item" style="display: none;">
                    <a class="nav-link" id="custom-tabs-one-662-tab" data-toggle="pill" href="#custom-tabs-one-662" role="tab" aria-controls="custom-tabs-one-662" aria-selected="false">
                        <i class="fas fa-folder-plus"></i><span>Order Entry - 662-002</span>
                    </a>
                </li>
            </ul>

            <div class="tab-content order-tab-content" id="custom-tabs-one-tabContent">
                <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                    <div class="order-form-panel">
                        <div class="order-section">
                            <div class="section-title"><i class="fas fa-calendar-check"></i><span>Order</span></div>
                            <div class="field-grid">
                                <div class="form-group order-field">
                                    <label for="orderentry_orderdate">Order Date <span class="required">*</span></label>
                                    <input type="date" id="orderentry_orderdate" name="orderentry_orderdate" class="form-control" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_receiveddate">Received Datetime <span class="required">*</span></label>
                                    <input type="datetime-local" id="orderentry_receiveddate" name="orderentry_receiveddate" class="form-control" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_orderpriority">Order Priority</label>
                                    <select id="orderentry_orderpriority" name="orderentry_orderpriority" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Normal">Normal</option>
                                        <option value="Rush">Rush</option>
                                    </select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_projectno">Project # <span class="required">*</span></label>
                                    <select id="orderentry_projectno" name="orderentry_projectno" class="form-control" onchange="return OrderEntry_BindTemplate(this);"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_clientorderno">Client Order # <span class="required">*</span></label>
                                    <input type="text" id="orderentry_clientorderno" name="orderentry_clientorderno" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_borrowername">Borrower / Co-borrower Name <span class="required">*</span></label>
                                    <input type="text" id="orderentry_borrowername" name="orderentry_borrowername" class="form-control" autocomplete="off" />
                                </div>
                            </div>
                        </div>

                        <div class="order-section">
                            <div class="section-title"><i class="fas fa-map-marker-alt"></i><span>Property</span></div>
                            <div class="field-grid property-grid">
                                <div class="form-group order-field">
                                    <label for="orderentry_state">State <span class="required">*</span></label>
                                    <select id="orderentry_state" name="orderentry_state" class="form-control" onchange="return OrderEntry_BindCounty(this);"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_county">County <span class="required">*</span></label>
                                    <select id="orderentry_county" name="orderentry_county" class="form-control"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_pinno">Pin #</label>
                                    <input type="text" id="orderentry_pinno" name="orderentry_pinno" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field property-address-field">
                                    <label for="orderentry_propertyaddress">Property Address <span class="required">*</span></label>
                                    <textarea id="orderentry_propertyaddress" name="orderentry_propertyaddress" class="form-control"></textarea>
                                </div>
                                <div class="form-group order-field property-legal-field">
                                    <label for="orderentry_legaldescription">Legal Description</label>
                                    <textarea id="orderentry_legaldescription" name="orderentry_legaldescription" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="order-section">
                            <div class="section-title"><i class="fas fa-layer-group"></i><span>Product</span></div>
                            <div class="field-grid">
                                <div class="form-group order-field">
                                    <label for="orderentry_producttype">Product Type <span class="required">*</span></label>
                                    <select id="orderentry_producttype" name="orderentry_producttype" class="form-control"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_template">Template</label>
                                    <select id="orderentry_template" name="orderentry_template" class="form-control"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_expectedtat">Expected TAT <span class="required">*</span></label>
                                    <select id="orderentry_expectedtat" name="orderentry_expectedtat" class="form-control">
                                        <option value="">Select</option>
                                        <option value="24">24 Hours</option>
                                        <option value="48">48 Hours</option>
                                        <option value="72">72 Hours</option>
                                        <option value="OverNight">OverNight</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_onoffline">On / Offline <span class="required">*</span></label>
                                    <select id="orderentry_onoffline" name="orderentry_onoffline" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Online">Online</option>
                                        <option value="Online-Trace">Online-Trace</option>
                                        <option value="Online-MS">Online-MS</option>
                                        <option value="Offline">Offline</option>
                                        <option value="Online to Offline">Online to Offline</option>
                                        <option value="OnTrace to Offline">On-Trace to Offline</option>
                                    </select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_exhibit">Exhibit</label>
                                    <select id="orderentry_exhibit" name="orderentry_exhibit" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Exhibit-B">Exhibit-B</option>
                                        <option value="Exhibit-D">Exhibit-D</option>
                                    </select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_transaction">Transaction <span class="required">*</span></label>
                                    <select id="orderentry_transaction" name="orderentry_transaction" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Refinance">Refinance</option>
                                        <option value="Purchase">Purchase</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="order-section">
                            <div class="section-title"><i class="fas fa-briefcase"></i><span>Additional Details</span></div>
                            <div class="field-grid">
                                <div class="form-group order-field">
                                    <label for="orderentry_salesprice">Sales Price</label>
                                    <input type="text" id="orderentry_salesprice" name="orderentry_salesprice" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_sellername">Seller Name</label>
                                    <input type="text" id="orderentry_sellername" name="orderentry_sellername" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_clientid">Client ID <span class="required">*</span></label>
                                    <input type="text" id="orderentry_clientid" name="orderentry_clientid" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_customertype">Customer Type <span class="required">*</span></label>
                                    <select id="orderentry_customertype" name="orderentry_customertype" class="form-control">
                                        <option value="">Select</option>
                                        <option value="NA">NA</option>
                                        <option value="DTO">DTO</option>
                                        <option value="EQUITY">EQUITY</option>
                                        <option value="PostClose">PostClose</option>
                                    </select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_attachment">Attachment</label>
                                    <input type="file" id="orderentry_attachment" name="orderentry_attachment" class="form-control" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_searcher">Searcher</label>
                                    <select id="orderentry_searcher" name="orderentry_searcher" class="form-control"></select>
                                </div>
                                <div class="form-group order-field wide">
                                    <label for="orderentry_instruction">Instruction</label>
                                    <textarea id="orderentry_instruction" name="orderentry_instruction" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="order-actions">
                            <button type="button" id="orderentry_btnreset" class="btn btn-order-secondary" onclick="return orderentry_reset();" style="display: none;">
                                <i class="fas fa-undo"></i><span>Reset</span>
                            </button>
                            <button type="button" id="orderentry_btnsubmit" class="btn btn-order-primary" onclick="return orderentry_submit();">
                                <i class="fas fa-save"></i><span>Submit</span>
                            </button>
                        </div>
                    </div>

                    <div class="order-grid-panel">
                        <div class="grid-panel-header">
                            <h2><i class="fas fa-table"></i><span>Orders</span></h2>
                        </div>
                        <div class="order-table-wrap">
                            <table id="table_orderentry" class="table table-hover table-sm">
                                <thead>
                                    <tr>
                                        <th>Actions</th>
                                        <th>Sr. #</th>
                                        <th>Order Date</th>
                                        <th>Project #</th>
                                        <th>Order #</th>
                                        <th>Product Type</th>
                                        <th>Borrower Name</th>
                                        <th>Property Address</th>
                                        <th>State</th>
                                        <th>County</th>
                                        <th>Added By</th>
                                        <th>Added Date</th>
                                        <th style="display: none;">OrderID</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="custom-tabs-one-excel" role="tabpanel" aria-labelledby="custom-tabs-one-excel-tab">
                    <div class="import-panel">
                        <div class="form-group order-field">
                            <label for="importorder_attachment">Excel</label>
                            <input type="file" id="importorder_attachment" name="importorder_attachment" class="form-control" accept=".xlsx" />
                        </div>
                        <div class="import-actions">
                            <button type="button" id="importorder_btnsubmit" class="btn btn-order-primary" onclick="return importorder_submit();">
                                <i class="fas fa-upload"></i><span>Import</span>
                            </button>
                            <a href="OSTExcel.xlsx" class="btn btn-order-secondary">
                                <i class="fas fa-download"></i><span>Format</span>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="custom-tabs-one-662" role="tabpanel" aria-labelledby="custom-tabs-one-662-tab">
                    <div class="order-form-panel">
                        <div class="order-section">
                            <div class="section-title"><i class="fas fa-folder-plus"></i><span>662-002 Order</span></div>
                            <div class="field-grid">
                                <div class="form-group order-field">
                                    <label for="orderentry_receiveddate_662">Receiver Datetime <span class="required">*</span></label>
                                    <input type="datetime-local" id="orderentry_receiveddate_662" name="orderentry_receiveddate_662" class="form-control" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_clientorderno_662">Client Order # <span class="required">*</span></label>
                                    <input type="text" id="orderentry_clientorderno_662" name="orderentry_clientorderno_662" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_borrowername_662">Borrower / Co-borrower Name <span class="required">*</span></label>
                                    <input type="text" id="orderentry_borrowername_662" name="orderentry_borrowername_662" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_sellername_662">Seller Name</label>
                                    <input type="text" id="orderentry_sellername_662" name="orderentry_sellername_662" class="form-control" autocomplete="off" />
                                </div>
                                <div class="form-group order-field wide">
                                    <label for="orderentry_propertyaddress_662">Property Address <span class="required">*</span></label>
                                    <textarea id="orderentry_propertyaddress_662" name="orderentry_propertyaddress_662" class="form-control"></textarea>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_state_662">State <span class="required">*</span></label>
                                    <select id="orderentry_state_662" name="orderentry_state_662" class="form-control" onchange="return OrderEntry662_BindCounty(this);"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_county_662">County <span class="required">*</span></label>
                                    <select id="orderentry_county_662" name="orderentry_county_662" class="form-control"></select>
                                </div>
                                <div class="form-group order-field">
                                    <label for="orderentry_loantype_662">Transaction <span class="required">*</span></label>
                                    <select id="orderentry_loantype_662" name="orderentry_loantype_662" class="form-control">
                                        <option value="">Select</option>
                                        <option value="Refinance">Refinance</option>
                                        <option value="Purchase">Purchase</option>
                                    </select>
                                </div>
                                <div class="form-group order-field wide">
                                    <label for="orderentry_instruction_662">Instruction</label>
                                    <textarea id="orderentry_instruction_662" name="orderentry_instruction_662" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="order-actions">
                            <button type="button" id="orderentry_btnreset_662" class="btn btn-order-secondary" onclick="return orderentry_reset_662();">
                                <i class="fas fa-undo"></i><span>Reset</span>
                            </button>
                            <button type="button" id="orderentry_btnsubmit_662" class="btn btn-order-primary" onclick="return orderentry_submit_662();">
                                <i class="fas fa-save"></i><span>Submit</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="orderentry_deleteOrder">
            <div class="modal-dialog modal-l">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><i class="fas fa-trash-alt"></i><span>Delete Order</span></h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-0" style="font-size: 15px;">Are you sure you want to delete order?</p>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-order-secondary" data-dismiss="modal">
                            <i class="fas fa-times"></i><span>No</span>
                        </button>
                        <button class="btn btn-order-primary" type="button" id="orderentry_btnYes" onclick="return orderentry_deleteOrder();">
                            <i class="fas fa-check"></i><span>Yes</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
