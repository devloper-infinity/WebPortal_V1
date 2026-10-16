<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AutoBilling.aspx.cs" Inherits="WebPortal.Admin.AutoBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background: #f4f7fb;
        }

        .loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            width: 180px;
            min-height: 150px;
            margin-top: -90px;
            margin-left: -90px;
            padding: 22px 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.94);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.18);
            text-align: center;
            z-index: 99999;
        }

            .loading img {
                max-width: 64px;
                margin-bottom: 12px;
            }

        .attendance-header {
            position: relative;
            overflow: hidden;
            margin-bottom: 22px;
            padding: 14px 16px;
            border-radius: 8px;
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            color: #fff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

            .attendance-header::after {
                content: '';
                position: absolute;
                right: -72px;
                top: -64px;
                width: 220px;
                height: 220px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.12);
            }

        .attendance-header-title {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
            font-size: 20px;
            font-weight: 700;
        }

        .attendance-header-subtitle {
            position: relative;
            z-index: 1;
            margin: 5px 0 0;
            font-size: 12px;
            opacity: 0.92;
        }

        .attendance-page {
            width: 100%;
            max-width: 100%;
            padding: 0 2px 26px;
            overflow: hidden;
            box-sizing: border-box;
        }

        .attendance-shell {
            display: grid;
            gap: 18px;
            width: 100%;
            max-width: 100%;
            overflow: hidden;
            box-sizing: border-box;
        }

        .attendance-panel {
            width: 100%;
            max-width: 100%;
            overflow: hidden;
            box-sizing: border-box;
            background: #fff;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.07);
        }

        .attendance-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf3;
        }

        .attendance-panel-title {
            margin: 0;
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .attendance-panel-subtitle {
            margin: 4px 0 0;
            color: #6b7788;
            font-size: 12px;
        }

        .attendance-panel-body {
            padding: 18px;
        }

        /* .attendance-form-grid {
         display: grid;
         grid-template-columns: repeat(3, minmax(0, 1fr));
         gap: 15px;
     }

     .attendance-field {
         min-width: 0;
         width: 300px;
     }

         .attendance-field label {
             display: block;
             margin-bottom: 6px;
             color: #344054;
             font-size: 12px;
             font-weight: 700 !important;
             border: none !important;
         }

         .attendance-field .form-control,
         .attendance-field select,
         .attendance-field input,
         .attendance-field textarea {
             width: 100%;
             min-height: 38px;
             border: 1px solid #cad6e2;
             border-radius: 6px;
             box-shadow: none;
             color: #172033;
             font-size: 13px;
         }

         .attendance-field textarea {
             resize: vertical;
         }*/

        .attendance-form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            align-items: start;
            width: 100%;
            max-width: 100%;
            box-sizing: border-box;
        }

        .attendance-field {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

            .attendance-field label {
                height: 18px;
                margin-bottom: 6px;
            }

            .attendance-field .form-control,
            .attendance-field select,
            .attendance-field input,
            .attendance-field textarea {
                width: 100% !important;
                max-width: 100%;
                min-height: 40px;
                box-sizing: border-box;
            }

            .attendance-field textarea {
                min-height: 40px;
            }

            .attendance-field .form-control:disabled {
                background: #f1f5f9;
                color: #475569;
                opacity: 1;
            }

        .attendance-weekly-off {
            min-height: 38px;
            display: flex;
            align-items: center;
            padding: 8px 12px;
            border: 1px solid #badbcc;
            border-radius: 6px;
            background: #effaf3;
            color: #0f7a3d;
            font-weight: 700;
        }

        .attendance-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 18px;
        }

        .autobilling-tabs {
            display: flex;
            gap: 5px;
            overflow-x: auto;
            margin: 0;
            padding: 0;
            border-bottom: 1px solid #dbe5ec;
            list-style: none;
        }

        .autobilling-tab {
            padding: 10px 16px;
            border: 0;
            border-radius: 6px 6px 0 0;
            background: #edf3f6;
            color: #344054;
            font-weight: 700;
            white-space: nowrap;
        }

            .autobilling-tab.active {
                background: #1f6feb;
                color: #fff;
            }

        .autobilling-pane {
            display: none;
            padding-top: 14px;
            overflow-x: auto;
        }

            .autobilling-pane.active {
                display: block;
            }

        .autobilling-message {
            padding: 28px;
            text-align: center;
            color: #64748b;
        }

        .autobilling-summary {
            display: inline-block;
            margin: 0 18px 16px;
        }

        .autobilling-summary-title {
            padding: 6px 8px;
            border: 1px solid #172033;
            background: #a9dff2;
            color: #111827;
            font-size: 12px;
            font-weight: 700;
        }

        .autobilling-summary table {
            width: auto !important;
            font-weight: 700;
        }

        .autobilling-summary th, .autobilling-summary td {
            padding: 5px 8px !important;
            border: 1px solid #172033 !important;
            text-align: center;
        }

        .attendance-primary-action,
        .attendance-modal .btn-primary {
            min-width: 108px;
            border: 0;
            border-radius: 6px;
            background: #1f6feb;
            box-shadow: 0 8px 18px rgba(31, 111, 235, 0.22);
            font-weight: 700;
        }

        .attendance-table-wrap {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
            padding: 0 18px 18px;
            box-sizing: border-box;
        }

        .attendance-data-table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            color: #253044;
            font-size: 12px;
        }

            .attendance-data-table thead th,
            table.dataTable thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid #d7e2ea !important;
                color: #263342 !important;
                font-size: 12px;
                font-weight: 700;
                /*  padding: 10px 12px !important;*/
                white-space: nowrap;
            }

            .attendance-data-table tbody td,
            table.dataTable tbody td {
                border-bottom: 1px solid #edf2f7;
                padding: 10px 12px !important;
                vertical-align: top;
                background: #fff !important;
            }

            .attendance-data-table tbody tr:hover td,
            table.dataTable tbody tr:hover td {
                background: #f8fbfd !important;
            }

            .attendance-data-table tbody tr.pmatt-current-manager-row td,
            table.dataTable tbody tr.pmatt-current-manager-row td {
                background: #C1F5C1 !important;
            }

            .attendance-data-table tbody tr.pmatt-current-manager-row:hover td,
            table.dataTable tbody tr.pmatt-current-manager-row:hover td {
                background: #C1F5C1 !important;
            }

            .attendance-data-table tbody tr.pmatt-approval-disabled-row td,
            .attendance-data-table tbody tr.pmatt-approval-disabled-row:hover td,
            table.dataTable tbody tr.pmatt-approval-disabled-row td,
            table.dataTable tbody tr.pmatt-approval-disabled-row:hover td {
                background: #f2f4f7 !important;
                color: #8a94a3;
            }

            .attendance-data-table tbody tr.pmatt-disabled-current-manager-row td,
            .attendance-data-table tbody tr.pmatt-disabled-current-manager-row:hover td,
            table.dataTable tbody tr.pmatt-disabled-current-manager-row td,
            table.dataTable tbody tr.pmatt-disabled-current-manager-row:hover td {
                background: #C1F5C1 !important;
                color: #1f2937;
            }

            .attendance-data-table tbody tr.pmatt-approval-disabled-row td:not(:first-child),
            table.dataTable tbody tr.pmatt-approval-disabled-row td:not(:first-child) {
                pointer-events: none;
            }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter {
            margin: 0 18px 12px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_length {
            margin-left: 18px;
        }

            .dataTables_wrapper .dataTables_filter input,
            .dataTables_wrapper .dataTables_length select {
                height: 34px;
                border: 1px solid #cbd5e1;
                border-radius: 6px;
                padding: 5px 10px;
            }

        .dataTables_wrapper .dataTables_info {
            float: left !important;
            padding: 12px 18px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_paginate {
            padding: 12px 18px 0 0;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                border: 1px solid #d7e2ea !important;
                border-radius: 6px !important;
                background: #fff !important;
                color: #344054 !important;
                margin: 0 3px !important;
                padding: 5px 10px !important;
            }

                .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                    background: #1f6feb !important;
                    border-color: #1f6feb !important;
                    color: #fff !important;
                }

        div.dt-buttons {
            position: static;
            float: left;
            padding: 12px 0 0 14px;
        }

        .buttons-excel,
        .buttons-html5,
        .dt-button {
            border: 1px solid #c7d6e3 !important;
            border-radius: 6px !important;
            background: #fff !important;
            color: #1f2937 !important;
            box-shadow: none !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            margin-right: 8px !important;
            padding: 6px 12px !important;
        }

        #pmatt_table .dropdown-item {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            background: #eef6ff;
        }

        #pmatt_table .isDisabled {
            opacity: 0.45;
            pointer-events: none;
        }

        #pmatt_table .pmatt-approval-disabled-action {
            background: #eef0f3;
            cursor: not-allowed;
            opacity: 0.55;
        }

        .attendance-modal .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
        }

        .attendance-modal .modal-header {
            border-bottom: 1px solid #e5edf3;
            padding: 16px 18px;
        }

        .attendance-modal .modal-title {
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .attendance-modal .modal-footer {
            justify-content: center;
            border-top: 1px solid #e5edf3;
            padding: 14px 18px;
        }

        .attendance-waiting-panel .modal-dialog {
            margin-top: 22vh;
        }

        .attendance-waiting-content {
            display: inline-flex;
            align-items: center;
            gap: 14px;
            padding: 18px 22px;
            border-radius: 10px;
            background: rgba(15, 23, 42, 0.86);
            color: #fff;
            font-size: 16px;
            font-weight: 700;
        }

            .attendance-waiting-content img {
                width: 44px;
                height: 44px;
            }

        @media (max-width: 1199px) {
            .attendance-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .attendance-header {
                padding: 14px;
            }

            .attendance-panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .attendance-form-grid {
                grid-template-columns: 1fr;
            }

            .attendance-actions {
                justify-content: stretch;
            }

            .attendance-primary-action {
                width: 100%;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="attendance-header">
        <h1 class="attendance-header-title">
            <i class="fas fa-user-clock"></i>
            All Domain Auto Billing Requests
        </h1>
        <p class="attendance-header-subtitle">Manage all domain auto billing requests and review request status.</p>
    </div>
    <div class="attendance-page">
        <div class="attendance-shell">
            <div class="attendance-panel">
                <div class="attendance-panel-body">
                    <div class="attendance-form-grid">
                        <div class="attendance-field">
                            <label for="autobilling_domain">Domain</label>
                            <select id="autobilling_domain" name="autobilling_domain" class="form-control">
                                <option value="">Select Domain</option>
                                <option value="Title">Title</option>
                                <option value="Valuation">Valuation</option>
                                <option value="Freight">Freight</option>
                                <option value="FTE">FTE</option>
                                <option value="UnderwritingCredit">Underwriting Credit</option>
                                <option value="UnderwritingServicing">Underwriting Servicing</option>
                            </select>
                        </div>
                        <div class="attendance-field">
                            <label for="autobilling_month">Month - Year</label>
                            <input type="month" id="autobilling_month" class="form-control" />
                        </div>
                        <div class="attendance-field">
                            <label for="autobilling_cycle">Billing Cycle</label>
                            <select id="autobilling_cycle" class="form-control">
                                <option value="Monthly">Monthly</option>
                                <option value="Bi-Monthly">Bi-Monthly</option>
                            </select>
                        </div>
                        <div class="attendance-field">
                            <label for="autobilling_period">Billing Period</label>
                            <select id="autobilling_period" class="form-control"></select>
                        </div>
                        <div class="attendance-field">
                            <label>&nbsp;</label>
                            <button type="button" id="autobilling_show" class="btn btn-primary attendance-primary-action">Show</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="attendance-panel" id="autobilling_result_panel" style="display: none;">
                <div class="attendance-panel-header">
                    <div>
                        <h2 class="attendance-panel-title">Auto Billing Projects</h2>
                        <p class="attendance-panel-subtitle" id="autobilling_selected_period"></p>
                    </div>
                    <button type="button" id="autobilling_send" class="btn btn-success"><i class="fas fa-paper-plane"></i>Send Auto Billing</button>
                </div>
                <div class="attendance-panel-body">
                    <ul id="autobilling_tabs" class="autobilling-tabs"></ul>
                    <div id="autobilling_panes"></div>
                </div>
            </div>
            <div id="autobilling_message" class="attendance-panel autobilling-message">Select filters and click Show.</div>
        </div>
    </div>
    <script>
        (function ($) {
            var reportTables = [];
            var commitmentTemplate = {
                title: '{project}-Client Billing - {period} ({type})',
                columns: [
                    { label:'Project#', value:'project' },
                    { label:'Type', field:['Type','Process','ProductionType'], aggregate:'first' },
                    { label:'Total Orders', aggregate:'count' },
                    { label:'Dispatched', field:['Status','OrderStatus','Final Status'], equals:'Completed', aggregate:'count' },
                    { label:'Cancelled', field:['Status','OrderStatus','Final Status'], equals:'Cancelled', aggregate:'count' },
                    { label:'On Hold', field:['Status','OrderStatus','Final Status'], equals:'On Hold', aggregate:'count' }
                ]
            };
            var valuationTemplate = {
                title: '{project}-Client Billing - {period}',
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: ['Completed','Delivered','Rejected','Fail'], aggregate: 'count' },
                    { label: 'Cancelled', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Cancelled', aggregate: 'count' },
                    { label: 'On Hold', field: ['Status', 'OrderStatus', 'Final Status'], equals: ['On Hold', 'On Hold-Review Completed','On Hold-Review Pending'], aggregate: 'count' }
                ]
            };
            var updateNewTemplate = {
                title: '{project}-Client Billing {period}',
                columns: [
                    { label:'Project#', value:'project' },
                    { label:'Total Orders', aggregate:'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: ['Completed', 'Delivered', 'Rejected', 'Fail'], aggregate:'count' },
                    { label:'Update Orders', field:['Order #','Order#','OrderNo','Order No'], contains:'Update', aggregate:'count' },
                    { label:'New Orders', field:['Order #','Order#','OrderNo','Order No'], notContains:'Update', aggregate:'count' }
                ]
            };
            var originalUpdateProductTemplate = {
                title: '{project}-Client Billing {period}',
                type: 'QC Appraisal',
                columns: [
                    { label:'Project#', value:'project' },
                    { label:'Type', value:'QC Appraisal' },
                    { label:'Total Orders', aggregate:'count' },
                    { label:'Original files', aggregate:'count', match:'all', conditions:[
                        { field:['Order #','Order#','OrderNo','Order No'], notContains:'Update' },
                        { field:['Product Type','ProductType'], notContains:'1004D' }
                    ]},
                    { label:'1004D & Update file', aggregate:'count', match:'any', conditions:[
                        { field:['Order #','Order#','OrderNo','Order No'], contains:'Update' },
                        { field:['Product Type','ProductType'], contains:'1004D' }
                    ]}
                ]
            };
            var originalUpdateProductTemplate6009 = {
                title: '{project}-Client Billing {period}',
                type: 'QC Appraisal',
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Type', value: 'QC Appraisal' },
                    { label: 'Total Orders', aggregate: 'count' },
                    {
                        label: 'Original files', aggregate: 'count', match: 'all', conditions: [
                            { field: ['Order #', 'Order#', 'OrderNo', 'Order No'], notContains: 'Update' }
                        ]
                    },
                    {
                        label: 'Update files', aggregate: 'count', match: 'any', conditions: [{ field: ['Order #', 'Order#', 'OrderNo', 'Order No'], contains: 'Update' }]
                    }
                ]
            };
            var ValuationProductTemplate = {
                title: '{project}-Client Billing {period}',
                type: 'QC Appraisal',
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Type', value: 'QC Appraisal' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: ['Completed', 'Delivered', 'Rejected', 'Fail'], aggregate: 'count' },
                    { label: 'Other Product', field: ['Product Type'], notContains: '1004D', aggregate: 'count' },
                    { label: '1004D Product', field: ['Product Type'], Contains: '1004D', aggregate: 'count' }
                ]
            };
            var ValuationProductMappingTemplate = {
                title: '{project}-Client Billing {period}',
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Primary', field: ['Billing Type'], equals: ['Primary'], aggregate: 'count' },
                    { label: 'Secondary', field: ['Billing Type'], equals: 'Secondary', aggregate: 'count' },
                    { label: 'Supplementary', field: ['Billing Type'], equals: 'Supplementary', aggregate: 'count' },
                    { label: 'Update', field: ['Billing Type'], equals: 'Update', aggregate: 'count' },
                    { label: 'Mapping Not Set', field: ['Billing Type'], equals: 'Mapping Not Set', aggregate: 'count' }
                    
                ]
            };
          
            var FreightTemplate = {
                title: '{project}-Client Billing - {period} ({type})',
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Completed', aggregate: 'count' },
                    { label: 'Cancelled', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Cancelled', aggregate: 'count' },
                    { label: 'On Hold', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'On Hold', aggregate: 'count' }
                ]
            };

            var commitmentTemplateProductbased = {
                title: '{project}-Client Billing - {period} ({type})',
                groupBy: ['Product Type'],
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Type', field: ['Product Type'], aggregate: 'first' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Completed', aggregate: 'count' },
                    { label: 'Cancelled', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Cancelled', aggregate: 'count' },
                    { label: 'On Hold', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'On Hold', aggregate: 'count' }
                ]
            };

            var commitmentTemplateOrderbased = {
                title: '{project}-Client Billing - {period} ({type})',
                groupBy: ['OrderType'],
                columns: [
                    { label: 'Project#', value: 'project' },
                    { label: 'Type', field: ['OrderType'], aggregate: 'first' },
                    { label: 'Total Orders', aggregate: 'count' },
                    { label: 'Dispatched', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Completed', aggregate: 'count' },
                    { label: 'Cancelled', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'Cancelled', aggregate: 'count' },
                    { label: 'On Hold', field: ['Status', 'OrderStatus', 'Final Status'], equals: 'On Hold', aggregate: 'count' }
                ]
            };

            var summaryTemplates = {};
            $.each(['1002', '1014', '1018', '183-002', '183-004', '183-005', '183-006','343', '347', '364', '364-002', '364-006', '364-005', '364-010', '364-012', '364-013','371','388','414-002','801','809','888'], function (_, project) {
                summaryTemplates[project] = commitmentTemplate;
            });
            $.each(['3003-002', '711'], function (_, project) {
                summaryTemplates[project] = FreightTemplate;
            });
            $.each(['213','580-002','6002','6003','6006','6007','782','691'], function (_, project) {
                summaryTemplates[project] = valuationTemplate;
            });
            $.each(['282'], function (_, project) {
                summaryTemplates[project] = updateNewTemplate;
            });
            // Example: summaryTemplates['PROJECT-NO'] = originalUpdateProductTemplate;
            $.each(['6003'], function (_, project) {
                summaryTemplates[project] = ValuationProductTemplate;
            });
            $.each(['6006'], function (_, project) {
                summaryTemplates[project] = ValuationProductMappingTemplate;
            });
            originalUpdateProductTemplate6009
            $.each(['6007','206-001'], function (_, project) {
                summaryTemplates[project] = originalUpdateProductTemplate;
            });
            $.each(['6009','6013','6014'], function (_, project) {
                summaryTemplates[project] = originalUpdateProductTemplate6009;
            });
            // $.each(['303-003','476'], function (_, project) {
            //     summaryTemplates[project] = commitmentTemplateProductbased;
            // });
            $.each(['303-003', '476'], function (_, project) {
                summaryTemplates[project] = commitmentTemplateOrderbased;
            });

            $(function () {
                var now = new Date(), month = String(now.getMonth() + 1);
                $('#autobilling_month').val(now.getFullYear() + '-' + (month.length < 2 ? '0' + month : month));
                bindPeriods();
                $('#autobilling_month,#autobilling_cycle').on('change', bindPeriods);
                $('#autobilling_domain').on('change', renderTables);
                $('#autobilling_show').on('click', loadReport);
                $('#autobilling_send').on('click', sendBilling);
                $('#autobilling_tabs').on('click', '.autobilling-tab', function () { activateTab($(this).data('index')); });
            });
            function monthData() { var p = $('#autobilling_month').val().split('-'), y = +p[0], m = +p[1]; return y && m ? { y:y, m:m, last:new Date(y,m,0).getDate() } : null; }
            function iso(x,d) { return x.y + '-' + ('0'+x.m).slice(-2) + '-' + ('0'+d).slice(-2); }
            function text(x,d) { return ('0'+d).slice(-2) + '-' + ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][x.m-1] + '-' + x.y; }
            function addPeriod(x,a,b) { $('#autobilling_period').append($('<option>').val(iso(x,a)+'|'+iso(x,b)).text(text(x,a)+' ~ '+text(x,b))); }
            function bindPeriods() { var x=monthData(); $('#autobilling_period').empty(); if(!x)return; if($('#autobilling_cycle').val()==='Bi-Monthly'){addPeriod(x,1,15);addPeriod(x,16,x.last);}else addPeriod(x,1,x.last); }
            function loadReport() { var period=$('#autobilling_period').val(),domain=$('#autobilling_domain').val(); if(!domain){showMessage('Select Domain.');return;}if(!period)return; var d=period.split('|'); $('#autobilling_show').prop('disabled',true).text('Loading...'); showMessage('Loading billing projects...'); $.ajax({url:'AutoBilling.aspx/GetAutoBilling',type:'POST',data:JSON.stringify({domain:domain,from:d[0],to:d[1]}),contentType:'application/json; charset=utf-8',dataType:'json'}).done(function(r){reportTables=JSON.parse(r.d||'[]');$('#autobilling_selected_period').text($('#autobilling_period option:selected').text());renderTables();}).fail(function(x){showMessage((x.responseJSON&&x.responseJSON.Message)||'Unable to load data.');}).always(function(){$('#autobilling_show').prop('disabled',false).text('Show');}); }
            function sendBilling(){var d=$('#autobilling_period').val().split('|'),b=$('#autobilling_send'),summaries={};$('[data-index="send-failures"]').remove();$('.autobilling-pane').each(function(){var i=$(this).data('index'),project=$('.autobilling-tab[data-index="'+i+'"]').text();summaries[project]=$(this).find('.autobilling-summary').map(function(){return this.outerHTML;}).get().join('<br/>');});b.prop('disabled',true).text('Sending...');$.ajax({url:'AutoBilling.aspx/SendAutoBilling',type:'POST',data:JSON.stringify({domain:$('#autobilling_domain').val(),from:d[0],to:d[1],summariesJson:JSON.stringify(summaries)}),contentType:'application/json; charset=utf-8',dataType:'json'}).done(function(r){var x=JSON.parse(r.d||'{}');renderSendFailures(x.Failed||[]);alert(x.Message||'Completed.');}).fail(function(x){alert((x.responseJSON&&x.responseJSON.Message)||'Unable to send email.');}).always(function(){b.prop('disabled',false).html('<i class="fas fa-paper-plane"></i> Send Auto Billing');});}
            function renderSendFailures(rows){if(!rows.length)return;var body=$.map(rows,function(x){return'<tr><td>'+escapeHtml(x.Project)+'</td><td>'+escapeHtml(x.DisplayedCount)+'</td><td>'+escapeHtml(x.ActualCount)+'</td><td>'+escapeHtml(x.Reason)+'</td></tr>';}).join('');$('#autobilling_tabs').append('<li><button type="button" class="autobilling-tab" data-index="send-failures">Not Updated / Email Not Sent ('+rows.length+')</button></li>');$('#autobilling_panes').append('<div class="autobilling-pane" data-index="send-failures"><div class="attendance-table-wrap"><table class="attendance-data-table"><thead><tr><th>Project</th><th>Displayed Count</th><th>Update Count</th><th>Reason</th></tr></thead><tbody>'+body+'</tbody></table></div></div>');activateTab('send-failures');}
            function renderTables(){var list=[];$.each(reportTables,function(_,t){if(t.Project||(t.Rows||[]).length)list.push(t);});if(!list.length){showMessage('No billing projects found.');return;}var tabs='',panes='';$.each(list,function(i,t){var name=String(t.Project||(t.Rows[0]&&t.Rows[0][0])||('Project '+(i+1))),empty=!(t.Rows||[]).length;tabs+='<li><button type="button" class="autobilling-tab '+(i?'':'active')+'" data-index="'+i+'">'+escapeHtml(name)+'</button></li>';panes+='<div class="autobilling-pane '+(i?'':'active')+'" data-index="'+i+'">'+buildSummary(name,t)+(empty?'':'<div class="attendance-table-wrap"><table class="attendance-data-table"><thead><tr>'+$.map(t.Columns,function(c){return'<th>'+escapeHtml(c)+'</th>';}).join('')+'</tr></thead><tbody>'+$.map(t.Rows,function(row){return'<tr>'+$.map(row,function(v){return'<td>'+escapeHtml(v)+'</td>';}).join('')+'</tr>';}).join('')+'</tbody></table></div>')+'</div>';});$('#autobilling_tabs').html(tabs);$('#autobilling_panes').html(panes);$('#autobilling_message').hide();$('#autobilling_result_panel').show();}
            function buildSummary(project,t){if(!(t.Rows||[]).length)return'<div class="autobilling-summary autobilling-message">No dispatched Records found for current billing period.</div>';if(project==='694-010')return build694Summaries(t);var cfg=summaryTemplates[project]||{title:'{project} - '+$('#autobilling_period option:selected').text(),columns:[{label:'Project#',value:'project'},{label:'Total Records',aggregate:'count'}]},heads='',body='',groups=[t],type=cfg.type||first(t,cfg.groupBy||['Type','Process','ProductionType']);$.each(cfg.columns,function(_,c){heads+='<th>'+escapeHtml(c.label)+'</th>';});if(cfg.groupBy){groups=[];var gi=columnIndex(t,cfg.groupBy),map={};$.each(t.Rows,function(_,r){var key=String(r[gi]||'');(map[key]=map[key]||[]).push(r);});$.each(map,function(_,rows){groups.push({Columns:t.Columns,Rows:rows});});}$.each(groups,function(_,g){body+='<tr>';$.each(cfg.columns,function(_,c){body+='<td>'+escapeHtml(summaryValue(c,project,g))+'</td>';});body+='</tr>';});var title=cfg.title.replace('{project}',project).replace('{period}',$('#autobilling_period option:selected').text()).replace('{type}',type);return'<div class="autobilling-summary"><div class="autobilling-summary-title">'+escapeHtml(title)+'</div><table><thead><tr>'+heads+'</tr></thead><tbody>'+body+'</tbody></table></div>';}
            function build694Summaries(t)
            {
                var oi = columnIndex(t, ['Order #', 'Order#', 'OrderNo', 'Order No']),
                    ti = columnIndex(t, ['OrderType', 'Order Type']),
                    si = columnIndex(t, ['Status', 'OrderStatus', 'Final Status']),
                    pi = columnIndex(t, ['Process Type', 'ProcessType', 'Type']),
                    hi = columnIndex(t, ['Document Hyperlinked', 'Hyperlinked', '# of Hyperlinks', '# of Hyperlink']),
                    ci = columnIndex(t, ['Character Count', 'Char Count', 'Characters', '# of Character']),
                    types = ['SF files', 'CD files', 'RN, RS & RG files', 'KW files', 'All other files'],
                    map = {};
                $.each(types, function (_, f)
                {
                    map[f] = {
                        Commercial: [], Residential: []
                    };
                });
                $.each(t.Rows, function (_, r)
                {
                    var code = String(r[oi] || '').slice(-5).replace(/-01$/i, '').slice(-2).toUpperCase(),
                    f = code === 'SF' ? 'SF files' : code === 'CD' ? 'CD files' : /^(RN|RS|RG)$/.test(code) ? 'RN, RS & RG files' : code === 'KW' ? 'KW files' : 'All other files', ot = /commercial/i.test(r[ti]) ? 'Commercial' : 'Residential'; map[f][ot].push(r);
                }); function metrics(rows) {
                    var done = 0, cancel = 0, process = 0, hyper = 0;
                    $.each(rows, function (_, r) {
                        var s = String(r[si] || '').toLowerCase(); if (s === 'completed' || s === 'dispatched') done++;
                        if (s === 'cancelled') cancel++; if (s === 'in process' || s === 'query') process++;
                        if (hi >= 0) { var hv = $.trim(String(r[hi] == null ? '' : r[hi])), hn = parseFloat(hv.replace(/,/g, '')); if (!isNaN(hn)) hyper += hn; else if (/^(true|yes|completed|hyperlinked)$/i.test(hv)) hyper++; }
                    }); return [done, cancel, process, hyper, rows.length];
                } var body = '', tot = { Commercial: [0, 0, 0, 0, 0], Residential: [0, 0, 0, 0, 0] };
                $.each(types, function (_, f) {
                    body += '<tr><td>' + f + '</td>';
                    $.each(['Commercial', 'Residential'], function (_, o)
                    {
                        var m = metrics(map[f][o]); $.each(m, function (i, n)
                        { tot[o][i] += n; body += '<td>' + n + '</td>'; });
                    }); body += '</tr>';
                });
                body += '<tr><td>Total</td>' + $.map(tot.Commercial, function (n)
                { return '<td>' + n + '</td>'; }).join('') + $.map(tot.Residential, function (n)
                { return '<td>' + n + '</td>'; }).join('') + '</tr>';
                var period = escapeHtml($('#autobilling_period option:selected').text()),
                    one = '<div class="autobilling-summary"><div class="autobilling-summary-title">' + period + '</div><table><thead><tr><th rowspan="2">File Type</th><th colspan="5">Commercial</th><th colspan="5">Residential</th></tr><tr>' + repeat694Headers() + '</tr></thead><tbody>' + body + '</tbody></table></div>';
                var processes = {}, second = '';
                $.each(t.Rows, function (_, r)
                {
                    var p = String(r[pi] || 'Hyperlink');
                    (processes[p] = processes[p] || []).push(r);
                }); $.each(processes, function (p, rows)
                {
                    second += '<tr><td>' + period + '</td><td>' + escapeHtml(p) + '</td>';
                    $.each(['Residential', 'Commercial'], function (_, o)
                    {
                        var rs = $.grep(rows, function (r) { return (/commercial/i.test(r[ti]) ? 'Commercial' : 'Residential') === o; }),
                            m = metrics(rs), less = 0, more = 0, bill = 0;
                        $.each(rs, function (_, r)
                        {
                            var c = +(r[ci] || 0);
                            if (c < 800) less++;
                            else { more++; if (c > 800) bill++; }
                        });
                        second += '<td>' + rs.length + '</td><td>' + m[0] + '</td><td>' + m[1] + '</td><td>' + m[2] + '</td><td>' + less + '</td><td>' + more + '</td><td>' + bill + '</td><td>' + m[3] + '</td>';
                    }); second += '</tr>';
                });
                var two = '<div class="autobilling-summary"><table><thead><tr><th rowspan="2">Billing Cycle</th><th rowspan="2">Process Type</th><th colspan="8">Residential</th><th colspan="8">Commercial</th></tr><tr>' + repeat694ProcessHeaders() + '</tr></thead><tbody>' + second + '</tbody></table></div>';
                return one + two;
            }
            function repeat694Headers(){var h='<th>Dispatched</th><th>Cancelled</th><th>In process</th><th>Document Hyperlinked</th><th>Total</th>';return h+h;}
            function repeat694ProcessHeaders(){var h='<th>Total Orders</th><th>Dispatched</th><th>Cancelled</th><th>In process/Query</th><th>Less than 800 Orders (Char)</th><th>Greater than 800 Orders (Char)</th><th>Greater than 800+ Char for Billing</th><th>Document Hyperlinked</th>';return h+h;}
            function summaryValue(c,project,t){if(c.value)return c.value==='project'?project:c.value;if(c.aggregate==='count'){if(c.conditions)return $.grep(t.Rows,function(r){var hits=$.map(c.conditions,function(x){var i=columnIndex(t,x.field),v=i<0?'':String(r[i]||'').toLowerCase();return x.contains?v.indexOf(String(x.contains).toLowerCase())>=0:v.indexOf(String(x.notContains).toLowerCase())<0;});return c.match==='any'?$.inArray(true,hits)>=0:$.inArray(false,hits)<0;}).length;if(!c.field)return t.Rows.length;var i=columnIndex(t,c.field);if(i<0)return 0;if(c.contains)return $.grep(t.Rows,function(r){return String(r[i]||'').toLowerCase().indexOf(String(c.contains).toLowerCase())>=0;}).length;if(c.notContains)return $.grep(t.Rows,function(r){return String(r[i]||'').toLowerCase().indexOf(String(c.notContains).toLowerCase())<0;}).length;var values=$.isArray(c.equals)?c.equals:[c.equals];values=$.map(values,function(v){return $.trim(String(v||'')).toLowerCase();});return $.grep(t.Rows,function(r){return $.inArray($.trim(String(r[i]||'')).toLowerCase(),values)>=0;}).length;}return c.aggregate==='first'?first(t,c.field):'';}
            function columnIndex(t,names){var found=-1,clean=function(v){return $.trim(String(v||'')).replace(/\s+/g,' ').toLowerCase();};$.each(names||[],function(_,n){$.each(t.Columns,function(i,c){if(clean(c)===clean(n))found=i;});});return found;}
            function first(t,names){var i=columnIndex(t,names);return i>=0&&t.Rows.length?t.Rows[0][i]:'';}
            function activateTab(i) { $('.autobilling-tab,.autobilling-pane').removeClass('active');$('[data-index="'+i+'"]').addClass('active'); }
            function showMessage(s) { $('#autobilling_result_panel').hide();$('#autobilling_message').text(s).show(); }
            function escapeHtml(v) { return $('<div>').text(v==null?'':v).html(); }
        })(jQuery);
    </script>
</asp:Content>
