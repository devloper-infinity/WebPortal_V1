<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="VerifyBilling.aspx.cs" Inherits="WebPortal.Search.VerifyBilling" %>



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

        .verify-billing-page {
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
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 14px 16px;
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

        .order-field .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #ccd6df;
            border-radius: 7px;
            font-size: 13px;
            color: var(--order-text);
            box-shadow: none;
        }

            .order-field .form-control:focus {
                border-color: var(--order-primary);
                box-shadow: 0 0 0 .16rem rgba(15, 118, 110, .12);
            }

        .remark-actions-grid {
            display: grid;
            grid-template-columns: minmax(320px, 2fr) minmax(300px, 1fr);
            gap: 16px;
            align-items: end;
        }

        .verify-action-group {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 10px;
        }

            .verify-action-group .btn,
            .modal .btn-primary {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 7px;
                min-height: 38px;
                padding: 8px 16px;
                border: 0;
                border-radius: 7px;
                font-size: 13px;
                font-weight: 700;
                box-shadow: none;
            }

            .verify-action-group .btn-primary,
            .modal .btn-primary {
                background: var(--order-primary) !important;
                color: #ffffff !important;
            }

                .verify-action-group .btn-primary:hover,
                .modal .btn-primary:hover {
                    background: var(--order-primary-dark) !important;
                }

        .verify-card {
            border: 1px solid var(--order-border-soft);
            border-radius: 8px;
            background: #ffffff;
            overflow: hidden;
            margin-bottom: 16px;
        }

            .verify-card:last-child {
                margin-bottom: 0;
            }

        .verify-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 14px;
            color: var(--order-text);
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border-soft);
            font-size: 14px;
            font-weight: 700;
        }

            .verify-card-header i {
                color: var(--order-primary);
                margin-right: 6px;
            }

        .verify-card-body {
            padding: 14px;
        }

        .count-badge {
            display: inline-flex !important;
            align-items: center;
            min-height: 26px;
            padding: 3px 9px;
            margin-left: 8px;
            border-radius: 999px;
            background: #edf7f5;
            color: var(--order-primary-dark) !important;
            font-size: 13px !important;
            font-weight: 700 !important;
        }

        #lblfiltercount {
            background: #fff7ed;
            color: #9a3412 !important;
        }

        .dataTables_scrollBody {
            min-height: 100px !important;
            height: auto;
        }

        .dataTables_length,
        .dataTables_info {
            float: left !important;
            color: var(--order-muted);
            font-size: 12px;
            font-weight: 600;
        }

        div.dt-buttons {
            position: static;
            padding-left: 16px;
            float: left;
        }

        .buttons-excel,
        .buttons-html5 {
            color: #263747;
            box-shadow: none;
            background: var(--order-primary) !important;
            border: 0 !important;
            border-radius: 7px !important;
            font-weight: 700 !important;
            margin: 0 6px;
            padding: 7px 14px !important;
        }

        /* Center checkbox */
        #VerifyOrders_Search_Billing thead th:first-child label {
            margin: 0 auto;
        }


        /* Keep all header cells same height */
        #VerifyOrders_Search_Billing thead th {
            height: 42px;
            vertical-align: middle !important;
        }

            /* First header column same as other headers */
            #VerifyOrders_Search_Billing thead th:first-child {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid var(--order-border) !important;
                text-align: center;
                vertical-align: middle;
                width: 44px;
                padding: 8px 6px;
            }

        .VerifyOrders_Search_Billing thead th,
        .VerifyOrders_Search_Billing.dataTable th {
            color: #263747;
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            border-bottom: 1px solid var(--order-border) !important;
            font-size: 12px;
            font-weight: 700;
            vertical-align: middle;
            white-space: nowrap;
        }

        #VerifyOrders_Search_Billing th:first-child,
        #VerifyOrders_Search_Billing td:first-child {
            text-align: center;
            width: 44px;
        }

        /* hide real checkbox but keep clickable */
        #VerifyOrders_Search_Billing input[type="checkbox"] {
            display: none;
        }

            /* custom visible checkbox */
            #VerifyOrders_Search_Billing input[type="checkbox"] + label {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 20px;
                height: 20px;
                margin: 0;
                border: 2px solid darkcyan;
                border-radius: 4px;
                background: #EDF3F6;
                cursor: pointer;
            }

            /* checked style */
            #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label {
                background: var(--order-primary);
                border-color: var(--order-primary);
            }

                #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label::after {
                    content: "\2713";
                    color: #fff;
                    font-size: 13px;
                    font-weight: 700;
                }

        /*.table {
            margin-bottom: 0;
            color: var(--order-text);
            font-size: 13px;
        }

            .table thead th,
            .table.dataTable th {
                color: #263747;
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                border-bottom: 1px solid var(--order-border) !important;
                font-size: 12px;
                font-weight: 700;
                vertical-align: middle;
                white-space: nowrap;
            }

            .table td,
            .table.dataTable tr td {
                background: #ffffff !important;
                border-color: var(--order-border-soft) !important;
                vertical-align: middle;
            }

            .table tbody tr:hover td {
                background: #f8fbfb !important;
            }

        #VerifyOrders_Search_Billing th:first-child,
        #VerifyOrders_Search_Billing td:first-child {
            text-align: center;
            width: 44px;
            position: relative;
        }

        VerifyOrders_Search_Billing

        #VerifyOrders_Search_Billing input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }

        #VerifyOrders_Search_Billing td:first-child label,
        #VerifyOrders_Search_Billing th:first-child label {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 20px;
            height: 20px;
            margin: 0;
            border: 2px solid #94a3b8;
            border-radius: 4px;
            background: #EDF3F6;
            border-color: darkcyan;
            cursor: pointer;
            transition: all .2s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,.08);
        }*/

        /* Hover */
        /*#VerifyOrders_Search_Billing td:first-child label:hover,
            #VerifyOrders_Search_Billing th:first-child label:hover {
                border-color: var(--order-primary);
            }

        #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label {
            background: var(--order-primary);
            border-color: var(--order-primary);
        }

            #VerifyOrders_Search_Billing input[type="checkbox"]:checked + label:after {
                content: "\2713";
                color: #fff;
                font-size: 13px;
                font-weight: 700;
                line-height: 1;
            }


        #VerifyOrders_Search_Billing tr.selected-row td {
            background-color: #e7f1ff !important;
        }*/

        .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 20px 45px rgba(31, 41, 55, .2);
            overflow: hidden;
        }

        .modal-header {
            background: #fbfcfd;
            border-bottom: 1px solid var(--order-border-soft);
        }

        .modal-title {
            color: var(--order-text);
            font-size: 16px;
            font-weight: 700;
        }

        @media (max-width: 992px) {
            .field-grid,
            .remark-actions-grid {
                grid-template-columns: 1fr;
            }

            .verify-action-group {
                justify-content: flex-start;
            }
        }
    </style>

    <script>
        $(document).ready(function () {

            verifyOrdres_BindProject();

            Bind_SearchBilling_Grid("735", "01-Jun-2026", "15-Jun-2026");
        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <div>
            <img src="../images/Load_1.gif" />
            <div>One moment, please . . . .</div>
        </div>
    </div>

    <div class="verify-billing-page">
        <div class="order-page-header">
            <div>
                <h1 class="order-title"><i class="fas fa-copy"></i><span>Verify Billing Orders</span></h1>
                <div class="order-context">Review billable orders, add remarks, verify, and send selected orders to accounts.</div>
            </div>
        </div>

        <div class="order-shell">
            <div class="order-section">
                <h2 class="section-title"><i class="fas fa-filter"></i>Billing Filters</h2>
                <div class="field-grid">
                    <div class="order-field">
                        <label for="VerifyOrdres_projectno">Project #</label>
                        <select id="VerifyOrdres_projectno" name="VerifyOrdres_projectno" onchange="return BindBillingCycle(this)" class="form-control">
                        </select>
                    </div>
                    <div class="order-field">
                        <label for="VerifyOrdres_BillingCycle">Billing Cycle</label>
                        <select id="VerifyOrdres_BillingCycle" name="VerifyOrdres_BillingCycle" onchange="return BindDatePeriod(this)" class="form-control">
                        </select>
                    </div>
                    <div class="order-field">
                        <label for="VerifyOrdres_dateperild">Date Period</label>
                        <select id="VerifyOrdres_dateperild" name="VerifyOrdres_dateperild" class="form-control">
                        </select>
                    </div>
                </div>
            </div>

            <div class="order-section">
                <h2 class="section-title"><i class="fas fa-comment-alt"></i>Verification Remark</h2>
                <div class="remark-actions-grid">
                    <div class="order-field">
                        <label for="VerifyOrdres_Remark">Remark</label>
                        <textarea id="VerifyOrdres_Remark" name="VerifyOrdres_Remark" class="form-control" textmode="MultiLine" rows="3"></textarea>
                    </div>
                    <div class="verify-action-group">
                        <button type="button" id="VerifyOrdres_btnsubmit" class="btn btn-primary" onclick="return VerifyOrdres_Show();"><i class="fas fa-search"></i>Show</button>
                        <button type="button" id="VerifyOrdres_btnVerify" class="btn btn-primary" onclick="return VerifyOrdres_Verify();"><i class="fas fa-check-circle"></i>Verify</button>
                        <button type="button" id="VerifyOrdres_btnSendToAccount" class="btn btn-primary" onclick="return VerifyOrdres_SendToAccount();"><i class="fas fa-paper-plane"></i>Send To Accounts</button>
                    </div>
                </div>
            </div>

            <div class="order-section">
                <div class="verify-card">
                    <div class="verify-card-header"><span><i class="fas fa-table"></i>Total Orders</span></div>
                    <div class="verify-card-body">
                        <table class="table" id="table_grdPending" style="width: 100% !important;">
                            <thead>
                                <tr>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">BillingPeriod</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Received</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Dispatch</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Cancel</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Hold</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Search</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Typing</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Tax</th>
                                </tr>
                            </thead>
                            <tbody style="font-size: 14px;"></tbody>
                        </table>
                    </div>
                </div>

                <div class="verify-card">
                    <div class="verify-card-header">
                        <span><i class="fas fa-table"></i>Billable Orders (Dispatch + Cancel + Previous)</span>
                        <span>
                            <label id="lbltotalcount" name="lbltotalcount" class="count-badge"></label>
                            <label id="lblfiltercount" name="lblfiltercount" class="count-badge"></label>
                        </span>
                    </div>
                    <div class="ost-table-frame">
                        <table class="table" id="VerifyOrders_Search_Billing">
                            <thead>
                                <tr>
                                    <th class="text-center">
                                        <input type="checkbox" id="chkall" />
                                        <label for="chkall"></label>
                                    </th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Sr. #</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Order No</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">State</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">County</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Received Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Dispatch Date</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">No of Documents</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">No of Pages</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Tax Information</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Taxes Calling(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name + Property Search cost in title plant</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Document Download Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Retrieval Cost (Searching + Downloading)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Property Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Product Type</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process Done</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Online Offline</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Typing(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">SnippingTools(Y/N)</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Production Remark</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Search Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Copy Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Cost paid for Independent Abstractor</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 200px;">Abstractor Name</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Cost</th>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">OrderID</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                            <%--<tfoot>
                            <tr>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                                <td style="text-align: center;"></td>
                            </tr>
                        </tfoot>--%>
                        </table>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Order verification in progress. Please wait.</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="popUp_viewBilling_addRemark">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <label id="lblupdateRemark" style="font-weight: bold!important;"></label>
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td>
                                <b>Order Cost :</b>
                            </td>
                            <td>
                                <input type="number" name="vrbil_orderCost" id="vrbil_orderCost" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Remark :</b>
                            </td>
                            <td>
                                <textarea name="vrbil_remark" id="vrbil_remark" class="form-control" style="width: 360px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="clearBillingFields()">Close</button>
                    <button class="btn btn-primary" type="submit" id="btnvrfBilling" onclick="return btnverfybilling_AddRemark();">Add Remark</button>
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

    <style>
        Header checkbox alignment
        #VerifyOrders_Search_Billing th:first-child {
            vertical-align: middle;
        }

        Ensure header checkbox uses same look
        #VerifyOrders_Search_Billing th:first-child input[type="checkbox"] {
            position: absolute;
            opacity: 0;
        }

        #VerifyOrders_Search_Billing th:first-child label {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin: auto;
        }

        Hide default checkbox but keep it clickable
        #VerifyOrders_Search_Billing input[type="checkbox"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        Highlight selected row
        #VerifyOrders_Search_Billing tr.selected-row {
            background-color: #e7f1ff !important;
            softer blue
        }

        Center the checkbox column
        #VerifyOrders_Search_Billing td:first-child,
        #VerifyOrders_Search_Billing th:first-child {
            text-align: center;
            width: 44px;
            position: relative;
        }

            Custom checkbox box
            #VerifyOrders_Search_Billing td:first-child label,
            #VerifyOrders_Search_Billing th:first-child label {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 18px;
                height: 18px;
                border: 2px solid #2563eb;
                modern blue border-radius: 5px;
                cursor: pointer;
                transition: all 0.2s ease;
                background-color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {

            verifyOrdres_BindProject();

            //Bind_SearchBilling_Grid("591", "15-Jan-2026", "31-Jan-2026");
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Verify Billing Orders</b></h6>
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
                            <select id="VerifyOrdres_projectno" name="VerifyOrdres_projectno" onchange="return BindBillingCycle(this)" class="form-control" style="width: 300px;">
                            </select>
                        </td>
                        <td><b>Billing Cycle:</b></td>
                        <td>
                            <select id="VerifyOrdres_BillingCycle" name="VerifyOrdres_BillingCycle" onchange="return BindDatePeriod(this)" class="form-control" style="width: 300px;">
                            </select>
                        </td>

                        <td><b>Date Period:</b></td>
                        <td>
                            <select id="VerifyOrdres_dateperild" name="VerifyOrdres_dateperild" class="form-control" style="width: 300px;">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Remark:</b></td>
                        <td colspan="3">
                            <textarea id="VerifyOrdres_Remark" name="VerifyOrdres_Remark" class="form-control" textmode="MultiLine" width="580px"></textarea>
                        </td>
                        <td></td>
                        <td style="vertical-align: central;">
                            <button type="button" id="VerifyOrdres_btnsubmit" class="btn btn-primary" onclick="return VerifyOrdres_Show();">Show</button>
                            &nbsp;&nbsp;
                             <button type="button" id="VerifyOrdres_btnVerify" class="btn btn-primary" onclick="return VerifyOrdres_Verify();">Verify</button>
                            &nbsp;&nbsp;         
                            <button type="button" id="VerifyOrdres_btnSendToAccount" class="btn btn-primary" onclick="return VerifyOrdres_SendToAccount();">Send To Accounts</button>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <div class="card">
                    <h6 class="card-header"><i class="fas fa-table"></i>&nbsp; Total Orders</h6>
                    <br />
                    <table class="table" id="table_grdPending" style="width: 100% !important;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">BillingPeriod</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Received</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Dispatch</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Cancel</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Hold</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Search</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Typing</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Pending Tax</th>
                            </tr>
                        </thead>
                        <tbody style="font-size: 14px;"></tbody>
                    </table>
                </div>
                <br />
                <br />
                <div class="card">
                    <h6 class="card-header"><i class="fas fa-table"></i>&nbsp; Billable Orders (Dispatch + Cancel + Previous) :
                    <label id="lbltotalcount" name="lbltotalcount" style="font-size: 16px; font-weight: bold!important; display: inline;"></label>
                        &nbsp;&nbsp;
                        <label id="lblfiltercount" name="lblfiltercount" style="font-size: 16px; font-weight: bold!important; color: brown; text-align: right;"></label>
                    </h6>
                    <br />
                    <table class="table" id="VerifyOrders_Search_Billing">
                        <thead>
                            <tr>
                                <th class="text-center">
                                    <input type="checkbox" id="chkall" />
                                    <label for="chkall"></label>
                                </th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Remark</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Order No</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">State</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">County</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Received Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 150px;">Dispatch Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">No of Documents</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">No of Pages</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Tax Information</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Taxes Calling(Y/N)</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name + Property Search cost in title plant</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Document Download Cost</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Retrieval Cost (Searching + Downloading)</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Property Type</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 100px;">Product Type</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process Done</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Online Offline</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Typing(Y/N)</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">SnippingTools(Y/N)</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Production Remark</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Search Cost</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Abstractor Copy Cost</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Cost paid for Independent Abstractor</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 200px;">Abstractor Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Cost</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">OrderID</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                      
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">Order verification in progress. Please wait.</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="popUp_viewBilling_addRemark">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <label id="lblupdateRemark" style="font-weight: bold!important;"></label>
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td>
                                <b>Order Cost :</b>
                            </td>
                            <td>
                                <input type="number" name="vrbil_orderCost" id="vrbil_orderCost" class="form-control" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Remark :</b>
                            </td>
                            <td>
                                <textarea name="vrbil_remark" id="vrbil_remark" class="form-control" style="width: 360px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="clearBillingFields()">Close</button>
                    <button class="btn btn-primary" type="submit" id="btnvrfBilling" onclick="return btnverfybilling_AddRemark();">Add Remark</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>--%>
