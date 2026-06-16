<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SecuritizationTracking.aspx.cs" Inherits="WebPortal.Admin.SecuritizationTracking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Functions/Securitization.js"></script>

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
            margin: 18px 0 12px;
        }

        .sec-section-title:first-child {
            margin-top: 0;
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

        #sectracking_table {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

        #sectracking_table thead th {
            background: #edf3f6 !important;
            border-color: #d7e2ea !important;
            color: #263747;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

        #sectracking_table tbody td {
            background: #fff;
            border-color: #e2e9ef !important;
            color: #263747;
            font-size: 12px;
            vertical-align: middle;
        }

        #sectracking_table tbody tr:hover td {
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

        .sec-modal-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(2, minmax(0, 1fr));
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
            .sec-stat-grid,
            .sec-modal-grid {
                grid-template-columns: 1fr;
            }

            .sec-field-wide {
                grid-column: span 1;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            sectrack_BindDeals();
            sectrack_BindClient2();
            sectrack_BindPivotGrid();
            sectrack_InitEnhancements();
        });

        function sectrack_InitEnhancements() {
            $("#sectrack_RequestedDate, #sectrack_SLADeliveryDate").on("change", sectrack_UpdateDeliveryDays);

            $("#sectrack_SLADeliveryDays").on("input", function () {
                $(this).data("manual", true);
            });

            $("#sectrack_table_search").on("input", function () {
                if ($.fn.DataTable.isDataTable("#sectracking_table")) {
                    $("#sectracking_table").DataTable().search(this.value).draw();
                }
            });

            $("#sectrack_refresh_grid").on("click", function () {
                sectrack_BindPivotGrid();
                return false;
            });

            $("#sectrack_clear_form").on("click", function () {
                sectrack_ClearEntryForm();
                return false;
            });
        }

        function sectrack_UpdateDeliveryDays() {
            var requestedDate = $("#sectrack_RequestedDate").val();
            var slaDate = $("#sectrack_SLADeliveryDate").val();
            var $days = $("#sectrack_SLADeliveryDays");

            if (!requestedDate || !slaDate || $days.data("manual")) {
                return;
            }

            var start = new Date(requestedDate + "T00:00:00");
            var end = new Date(slaDate + "T00:00:00");
            var diff = Math.round((end - start) / 86400000);

            if (!isNaN(diff)) {
                $days.val(diff);
            }
        }

        function sectrack_ClearEntryForm() {
            $("#sectrack_DealNo").val("").trigger("change");
            $("#sectrack_Project").val("").trigger("change");
            $("#sectrack_ClientDealName, #sectrack_NoOfLoans, #sectrack_newdealno, #sectrack_newprojectno").val("");
            $("#sectrack_RequestedDate, #sectrack_SLADeliveryDate, #sectrack_ActualDeliveredDate").val("");
            $("#sectrack_SLADeliveryDays, #sectrack_BillingHours").val("").data("manual", false);
            $("#sectrack_TaskName, #sectrack_RLSigned, #sectrack_Status").val("Select");
            $("#sectrack_ClientNameAddress, #sectrack_RecipientNameAddress, #sectrack_sAgencyNameAddress, #sectrack_Remark").val("");
            $("#tdnewdealheader, #tdnewdealdetail, #tdnewclientheader, #tdnewclientdetail").hide();
        }

        function sectrack_OnPivotBound(rows, copies) {
            var copyCount = copies ? copies.length : 0;
            var pending = 0;
            var completed = 0;

            rows = rows || [];
            copies = copies || [];

            rows.forEach(function (row) {
                copies.forEach(function (copy) {
                    var status = (row[copy + "_Status"] || "").toString().toLowerCase();
                    if (status === "pending" || status === "in process") {
                        pending++;
                    }
                    if (status === "completed") {
                        completed++;
                    }
                });
            });

            $("#sectrack_stat_deals").text(rows.length);
            $("#sectrack_stat_copies").text(copyCount);
            $("#sectrack_stat_pending").text(pending);
            $("#sectrack_stat_completed").text(completed);
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="sec-page">
        <div class="sec-hero">
            <div>
                <div class="sec-kicker">Operations</div>
                <h1 class="sec-title"><i class="fas fa-chart-line mr-2"></i>Securitization Tracking Master</h1>
                <p class="sec-subtitle">Reliance letter, 15E, narrative, reporting, and delivery tracking.</p>
            </div>
            <div class="sec-hero-actions">
                <a href="EditSecuritizationTracking.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-pen-to-square"></i>
                    Edit Records
                </a>
                <a href="ImportSecuritizationLoans.aspx" class="sec-btn sec-btn-light">
                    <i class="fas fa-file-import"></i>
                    Import Loans
                </a>
            </div>
        </div>

    <%--    <div class="sec-stat-grid">
            <div class="sec-stat">
                <span>Deals Loaded</span>
                <strong id="sectrack_stat_deals">0</strong>
            </div>
            <div class="sec-stat">
                <span>Copy Groups</span>
                <strong id="sectrack_stat_copies">0</strong>
            </div>
            <div class="sec-stat">
                <span>Open Items</span>
                <strong id="sectrack_stat_pending">0</strong>
            </div>
            <div class="sec-stat">
                <span>Completed</span>
                <strong id="sectrack_stat_completed">0</strong>
            </div>
        </div>--%>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-plus-circle"></i>New Tracking Entry</h2>
                    <p class="sec-panel-subtitle">Create a tracking row for the selected deal and client.</p>
                </div>
                <button id="sectrack_clear_form" type="button" class="sec-btn sec-btn-outline">
                    <i class="fas fa-rotate-left"></i>
                    Clear
                </button>
            </div>
            <div class="sec-panel-body">
                <div class="sec-section-title"><i class="fas fa-briefcase"></i>Deal Details</div>
                <div class="sec-form-grid">
                    <div class="sec-field">
                        <label for="sectrack_DealNo">Deal #</label>
                        <select id="sectrack_DealNo" name="sectrack_DealNo" class="form-control" onchange="sectrack_GetNewDeal(this);"></select>
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_Project">Client Name</label>
                        <select id="sectrack_Project" name="sectrack_Project" class="form-control" onchange="sectrack_GetNewProject(this);"></select>
                    </div>
                    <div class="sec-field" id="tdnewdealheader" style="display: none;">
                        <label for="sectrack_newdealno">New Deal #</label>
                        <input type="text" id="sectrack_newdealno" name="sectrack_newdealno" class="form-control" />
                    </div>
                    <div class="sec-field" id="tdnewdealdetail" style="display: none;"></div>
                    <div class="sec-field" id="tdnewclientheader" style="display: none;">
                        <label for="sectrack_newprojectno">New Client Name</label>
                        <input type="text" id="sectrack_newprojectno" name="sectrack_newprojectno" class="form-control" />
                    </div>
                    <div class="sec-field" id="tdnewclientdetail" style="display: none;"></div>
                    <div class="sec-field">
                        <label for="sectrack_ClientDealName">Client's Deal Name</label>
                        <input type="text" id="sectrack_ClientDealName" name="sectrack_ClientDealName" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_NoOfLoans"># of Loans</label>
                        <input type="number" min="0" step="1" id="sectrack_NoOfLoans" name="sectrack_NoOfLoans" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_TaskName">Task Name</label>
                        <select id="sectrack_TaskName" name="sectrack_TaskName" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Reports">Reports</option>
                            <option value="15E">15E</option>
                            <option value="Narrative">Narrative</option>
                            <option value="15E/ Narrative">15E/ Narrative</option>
                            <option value="15E and Attestations">15E and Attestations</option>
                            <option value="Attestations">Attestations</option>
                            <option value="Reliance Letter">Reliance Letter</option>
                            <option value="Redacted Reports">Redacted Reports</option>
                            <option value="Unredacted Reports">Unredacted Reports</option>
                            <option value="Securitization Reports">Securitization Reports</option>
                            <option value="RAG Report">RAG Report</option>
                        </select>
                    </div>
                </div>

                <div class="sec-section-title"><i class="fas fa-calendar-check"></i>Delivery And Billing</div>
                <div class="sec-form-grid">
                    <div class="sec-field">
                        <label for="sectrack_RequestedDate">Requested Date</label>
                        <input type="date" id="sectrack_RequestedDate" name="sectrack_RequestedDate" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_SLADeliveryDate">SLA/Client Delivery Date</label>
                        <input type="date" id="sectrack_SLADeliveryDate" name="sectrack_SLADeliveryDate" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_SLADeliveryDays">SLA/Client Delivery Days</label>
                        <input type="number" step="1" id="sectrack_SLADeliveryDays" name="sectrack_SLADeliveryDays" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_ActualDeliveredDate">Actual Delivered Date</label>
                        <input type="date" id="sectrack_ActualDeliveredDate" name="sectrack_ActualDeliveredDate" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_RLSigned">15E or RL signed?</label>
                        <select id="sectrack_RLSigned" name="sectrack_RLSigned" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                            <option value="Not Applicable">Not Applicable</option>
                        </select>
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_BillingHours">Billing Hours</label>
                        <input type="number" min="0" step="0.25" id="sectrack_BillingHours" name="sectrack_BillingHours" class="form-control" />
                    </div>
                    <div class="sec-field">
                        <label for="sectrack_Status">Status</label>
                        <select id="sectrack_Status" name="sectrack_Status" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Pending">Pending</option>
                            <option value="In Process">In Process</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>

                <div class="sec-section-title"><i class="fas fa-address-card"></i>Parties And Remarks</div>
                <div class="sec-form-grid">
                    <div class="sec-field sec-field-wide">
                        <label for="sectrack_ClientNameAddress">Full Name and Address of Client/Seller</label>
                        <textarea id="sectrack_ClientNameAddress" name="sectrack_ClientNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="sec-field sec-field-wide">
                        <label for="sectrack_RecipientNameAddress">Full Name and Address of Recipient/Buyer</label>
                        <textarea id="sectrack_RecipientNameAddress" name="sectrack_RecipientNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="sec-field sec-field-wide">
                        <label for="sectrack_sAgencyNameAddress">Full Name of Rating Agencies</label>
                        <textarea id="sectrack_sAgencyNameAddress" name="sectrack_AgencyNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="sec-field sec-field-wide">
                        <label for="sectrack_Remark">Remark</label>
                        <textarea id="sectrack_Remark" name="sectrack_Remark" class="form-control"></textarea>
                    </div>
                </div>

                <div class="sec-action-row">
                    <button id="sectracking_btnsubmit" name="sectracking_btnsubmit" type="button" class="sec-btn sec-btn-primary" onclick="return sectracking_submit();">
                        <i class="fas fa-check"></i>
                        Submit
                    </button>
                </div>
            </div>
        </div>

        <div class="sec-panel">
            <div class="sec-panel-header">
                <div>
                    <h2 class="sec-panel-title"><i class="fas fa-table"></i>Tracking Matrix</h2>
                    <p class="sec-panel-subtitle">Pivot view by deal and copy group.</p>
                </div>
                <div class="sec-table-toolbar">
                    <div class="sec-search">
                        <i class="fas fa-search"></i>
                        <input id="sectrack_table_search" type="search" class="form-control" placeholder="Search tracking data" />
                    </div>
                    <div class="sec-table-tools">
                        <button id="sectrack_refresh_grid" type="button" class="sec-btn sec-btn-outline">
                            <i class="fas fa-arrows-rotate"></i>
                            Refresh
                        </button>
                        <button id="sectracking_btnsectracking_exportpivot" type="button" name="sectracking_btnsectracking_exportpivot" class="sec-btn sec-btn-soft" onclick="return sectracking_exportpivot(event);">
                            <i class="fas fa-file-excel"></i>
                            Export
                        </button>
                    </div>
                </div>
            </div>
            <div class="sec-table-wrap">
                <table id="sectracking_table" class="table table-bordered" style="width: 100%">
                    <thead>
                        <tr id="hdrTop">
                            <th>Deal #</th>
                            <th>Client</th>
                            <th>Sales Person</th>
                            <th>Client Deal #</th>
                            <th>Loan Count</th>
                            <th>Task Name</th>
                        </tr>
                        <tr id="hdrSub"></tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="sectrack_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="sec-message-icon">
                        <i class="fas fa-circle-info"></i>
                    </div>
                    <h6 class="modal-title" id="sectrack_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="sec-btn sec-btn-primary" type="button" id="sectrack_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="popup_addNewClient">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-building mr-2"></i>Add New Client</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="sec-modal-grid">
                        <div class="sec-field">
                            <label for="addNewClient_prjNo">Project #</label>
                            <input type="text" id="addNewClient_prjNo" name="addNewClient_prjNo" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_company">Company Name</label>
                            <input type="text" id="addNewClient_company" name="addNewClient_company" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_cntPerson">Contact Person</label>
                            <input type="text" id="addNewClient_cntPerson" name="addNewClient_cntPerson" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_cntNo">Contact #</label>
                            <input type="tel" id="addNewClient_cntNo" name="addNewClient_cntNo" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_email">Email ID</label>
                            <input type="email" id="addNewClient_email" name="addNewClient_email" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_website">Website URL</label>
                            <input type="url" id="addNewClient_website" name="addNewClient_website" class="form-control" />
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_address">Address</label>
                            <textarea id="addNewClient_address" name="addNewClient_address" class="form-control"></textarea>
                        </div>
                        <div class="sec-field">
                            <label for="addNewClient_remark">Remark</label>
                            <textarea id="addNewClient_remark" name="addNewClient_remark" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="sec-btn sec-btn-outline" data-dismiss="modal">
                        <i class="fas fa-xmark"></i>
                        Close
                    </button>
                    <button class="sec-btn sec-btn-primary" type="button" id="addNewClient_btn" onclick="addNewClient_btnSubmit();">
                        <i class="fas fa-plus"></i>
                        Add Client
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
