<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SecuritizationBilling.aspx.cs" Inherits="WebPortal.Admin.SecuritizationBilling" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
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

        .sec-stat-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .sec-stat {
            background: #fff;
            border: 1px solid #dce5ec;
            border-left: 4px solid #0f766e;
            border-radius: 8px;
            box-shadow: 0 8px 18px rgba(31, 51, 71, 0.06);
            padding: 14px 16px;
        }

            .sec-stat span {
                color: #667789;
                display: block;
                font-size: 12px;
                font-weight: 700;
                margin-bottom: 4px;
            }

            .sec-stat strong {
                color: #172737;
                display: block;
                font-size: 22px;
                line-height: 1;
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
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .sec-field {
            min-width: 0;
        }

        .sec-field-wide {
            grid-column: span 2;
        }

        .sec-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .sec-field .form-control {
            border-color: #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .sec-field textarea.form-control {
            min-height: 76px;
            resize: vertical;
        }

        .sec-field .form-control:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
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

        .sec-table-toolbar {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
        }

        .sec-table-tools {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .sec-search {
            min-width: 280px;
            position: relative;
        }

            .sec-search i {
                color: #7d8d9c;
                left: 12px;
                position: absolute;
                top: 11px;
            }

            .sec-search input {
                padding-left: 34px;
            }

        .sec-table-wrap {
            padding: 0 18px 18px;
        }

        #table_secrBillingDealRecs {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

            #table_secrBillingDealRecs thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_secrBillingDealRecs tbody td {
                background: #fff;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #table_secrBillingDealRecs tbody tr:hover td {
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

        div.dt-buttons {
            float: left;
            padding: 0 0 8px;
            position: static;
        }

        .buttons-excel {
            background: #0f766e;
            border: 0;
            border-radius: 6px;
            box-shadow: none;
            color: #fff;
            font-weight: 700;
            margin: 0 10px 0 0;
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
            .sec-form-grid,
            .sec-stat-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .sec-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .sec-hero-actions,
            .sec-action-row,
            .sec-table-toolbar,
            .sec-table-tools {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .sec-btn,
            .sec-search,
            .sec-search input {
                width: 100%;
            }

            .sec-form-grid,
            .sec-stat-grid {
                grid-template-columns: 1fr;
            }

            .sec-field-wide {
                grid-column: span 1;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            secrBilling_BindDeals();
            secRBilling_BindDetails();
            secrBilling_InitEnhancements();
        });

        function secrBilling_InitEnhancements() {
            $("#secrBilling_table_search").on("input", function () {
                if ($.fn.DataTable && $.fn.DataTable.isDataTable("#table_secrBillingDealRecs")) {
                    $("#table_secrBillingDealRecs").DataTable().search(this.value).draw();
                }
            });

            $("#secrBilling_refresh_grid").on("click", function () {
                secRBilling_BindDetails();
                return false;
            });

            $("#secrBilling_clear_form").on("click", function () {
                secrBilling_ClearEntryForm();
                return false;
            });

            $("#secrBilling_BillingType, #secrBilling_DealNo, #secrBilling_NoOfLoans, #secrBilling_AssociatedHourd").on("change input", secrBilling_UpdateSummary);
            secrBilling_UpdateSummary();
        }

        function secrBilling_UpdateSummary() {
            var billingType = $("#secrBilling_BillingType").val();
            var dealText = $("#secrBilling_DealNo option:selected").text();

            $("#secrBilling_stat_type").text(billingType && billingType !== "Select" ? billingType : "--");
            $("#secrBilling_stat_deal").text(dealText ? dealText : "--");
            $("#secrBilling_stat_loans").text($("#secrBilling_NoOfLoans").val() || "0");
            $("#secrBilling_stat_hours").text($("#secrBilling_AssociatedHourd").val() || "0");
        }

        function secrBilling_ClearEntryForm() {
            $("#secrBilling_BillingType").val("Select");
            $("#secrBilling_DealNo").val("").trigger("change");
            $("#secrBilling_NoOfLoans, #secrBilling_AssociatedHourd, #secrBilling_Remark").val("");
            $("#secrBilling_lblProjectId, #secrBilling_lblClientDealName, #secrBilling_lblProjectName").text("");
            secrBilling_UpdateSummary();
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <label id="secrBilling_lblProjectId" name="secrBilling_lblProjectId" style="display: none"></label>
    <label id="secrBilling_lblClientDealName" name="secrBilling_lblClientDealName" style="display: none"></label>
    <label id="secrBilling_lblProjectName" name="secrBilling_lblProjectName" style="display: none"></label>

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Operations</div>
                <h1 class="sec-title"><i class="fas fa-file-invoice-dollar mr-2"></i>Securitization Billing</h1>
                <p class="sec-subtitle">Prepare billing requests for reliance letters and securitization work, then send selected details to audit.</p>
            </div>
            <div class="sec-hero-actions">
                <a href="SecuritizationBillingSent.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-paper-plane"></i>
                    Sent To Audit
                </a>
            </div>
        </div>

       <%-- <div class="sec-stat-grid">
            <div class="sec-stat">
                <span>Billing Type</span>
                <strong id="secrBilling_stat_type">--</strong>
            </div>
            <div class="sec-stat">
                <span>Selected Deal</span>
                <strong id="secrBilling_stat_deal">--</strong>
            </div>
            <div class="sec-stat">
                <span># of Loans</span>
                <strong id="secrBilling_stat_loans">0</strong>
            </div>
            <div class="sec-stat">
                <span>Associate Hours</span>
                <strong id="secrBilling_stat_hours">0</strong>
            </div>
        </div>--%>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-plus-circle"></i>New Billing Request</h2>
                    <p class="sec-panel-subtitle">Select billing type and deal details before sending to audit.</p>
                </div>
                <button id="secrBilling_clear_form" type="button" class="sec-btn sec-btn-outline">
                    <i class="fas fa-rotate-left"></i>
                    Clear
               
                </button>
            </div>
            <div class="sec-panel-body">
                <div class="sec-section-title"><i class="fas fa-briefcase"></i>Billing Details</div>
                <div class="sec-form-grid">
                    <div class="sec-field">
                        <label for="secrBilling_BillingType">Billing Type</label>
                        <select id="secrBilling_BillingType" name="secrBilling_BillingType" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Reliance Letter">Reliance Letter</option>
                            <option value="Securitization">Securitization</option>
                        </select>
                    </div>
                    <div class="sec-field">
                        <label for="secrBilling_DealNo">Deal #</label>
                        <select id="secrBilling_DealNo" name="secrBilling_DealNo" class="form-control" onchange="secrBilling_ChnageDealLoans(this);"></select>
                    </div>
                    <div class="sec-field">
                        <label for="secrBilling_NoOfLoans"># of Loans</label>
                        <input type="number" min="0" step="1" id="secrBilling_NoOfLoans" name="secrBilling_NoOfLoans" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="secrBilling_AssociatedHourd">Associates # of Hours</label>
                        <input type="number" min="0" step="0.25" id="secrBilling_AssociatedHourd" name="secrBilling_AssociatedHourd" class="form-control" />
                    </div>
                    <div class="sec-field sec-field-wide">
                        <label for="secrBilling_Remark">Remark</label>
                        <textarea id="secrBilling_Remark" name="secrBilling_Remark" class="form-control"></textarea>
                    </div>
                </div>
                <div class="sec-action-row">
                    <button type="submit" id="secrBilling_SendToAudit" name="secrBilling_SendToAudit" class="sec-btn sec-btn-primary" onclick="return btnSecrBilling_SentToAudit1();">
                        <i class="fas fa-paper-plane"></i>
                        Send To Audit
                   
                    </button>
                </div>
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-table"></i>Billing Deal Records</h2>
                    <p class="sec-panel-subtitle">Review deal records, copies, delivery dates, and billing hours.</p>
                </div>
                <div class="sec-table-toolbar">
                    <div class="sec-search">
                        <i class="fas fa-search"></i>
                        <input id="secrBilling_table_search" type="search" class="form-control" placeholder="Search billing data" />
                    </div>
                    <div class="sec-table-tools">
                        <button id="secrBilling_refresh_grid" type="button" class="sec-btn sec-btn-outline">
                            <i class="fas fa-arrows-rotate"></i>
                            Refresh
                       
                        </button>
                    </div>
                </div>
            </div>
            <div class="sec-table-wrap">
                <table class="table table-bordered" id="table_secrBillingDealRecs" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Project #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Client Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Loan Count</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Task Name</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Copy</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Requested Date</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Billing Hours</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="secrBilling_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="sec-message-icon">
                        <i class="fas fa-circle-info"></i>
                    </div>
                    <h6 class="modal-title" id="secrBilling_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="sec-btn sec-btn-primary" type="button" id="secrBilling_btnMessage" onclick="location.reload();">Okay</button>
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

        .dataTables_paginate {
            float: left !important;
        }

        div.dt-buttons {
            position: static;
            padding-left: 50px;
            float: left;
        }

        .buttons-excel {
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .dt-center {
            text-align: center;
        }
    </style>

    <script>

        $(document).ready(function () {

            secrBilling_BindDeals();

          
           secRBilling_BindDetails();
        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <label id="secrBilling_lblProjectId" name="secrBilling_lblProjectId" style="display: none"></label>
    <label id="secrBilling_lblClientDealName" name="secrBilling_lblClientDealName" style="display: none"></label>
    <label id="secrBilling_lblProjectName" name="secrBilling_lblProjectName" style="display: none"></label>

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Securitization Billing</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="SecuritizationBillingSent.aspx" style="font-size: 13px; text-decoration: underline; float: right; margin-right: 100px; font-weight: bold;">Sent To Audit >> </a>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Billing Type:</b></td>
                        <td>
                            <select id="secrBilling_BillingType" name="secrBilling_BillingType" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                                <option value="Reliance Letter">Reliance Letter</option>
                                <option value="Securitization">Securitization</option>
                            </select>
                        </td>
                        <td><b>Deal #:</b></td>
                        <td>
                            <select id="secrBilling_DealNo" name="secrBilling_DealNo" class="form-control" style="width: 300px;" onchange="secrBilling_ChnageDealLoans(this);"></select>
                        </td>
                    </tr>
                    <tr>
                        <td><b># of Loans:</b></td>
                        <td>
                            <input type="text" id="secrBilling_NoOfLoans" name="secrBilling_NoOfLoans" class="form-control" style="width: 300px;" />
                        </td>
                        <td><b>Associates # of Hours:</b></td>
                        <td>
                            <input type="text" id="secrBilling_AssociatedHourd" name="secrBilling_AssociatedHourd" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Remark :</b></td>
                        <td>
                            <input type="text" id="secrBilling_Remark" name="secrBilling_Remark" textmode="MultiLine" class="form-control" style="width: 300px;" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td>
                            <button type="submit" id="secrBilling_SendToAudit" name="secrBilling_SendToAudit" class="btn btn-primary" onclick="return btnSecrBilling_SentToAudit1();">Send To Audit</button>
                       
                        </td>
                        <td></td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_secrBillingDealRecs">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 80px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Project #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Client Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px; text-align: center;">Loan Count</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Task Name</th>
                            <th class="sort border-top ps-3" style="width: 100px; text-align: center;">Copy</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Requested Date</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 120px; text-align: center;">Billing Hours</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="secrBilling_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="secrBilling_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="secrBilling_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

</asp:Content>--%>
