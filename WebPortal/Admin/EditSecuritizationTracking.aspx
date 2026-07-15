<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditSecuritizationTracking.aspx.cs" Inherits="WebPortal.Admin.EditSecuritizationTracking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <portal:VersionedScript Src="~/Scripts/Functions/EditSecruitization.js" runat="server"></portal:VersionedScript>

    <style>
        body {
            background: #f3f6f8;
        }

        .edit-sec-page {
            color: #16202a;
            padding-bottom: 28px;
        }

        .edit-sec-hero {
            align-items: center;
            background: linear-gradient(135deg, #164e63 0%, #1d4ed8 100%);
            border-radius: 8px;
            box-shadow: 0 14px 28px rgba(28, 58, 85, 0.16);
            color: #fff;
            display: flex;
            gap: 20px;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 22px 24px;
        }

        .edit-sec-kicker {
            color: rgba(255,255,255,0.82);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .edit-sec-title {
            font-size: 24px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .edit-sec-subtitle {
            color: rgba(255,255,255,0.88);
            font-size: 13px;
            margin: 8px 0 0;
            max-width: 760px;
        }

        .edit-sec-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
        }

        .edit-sec-btn {
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

        .edit-sec-btn-primary {
            background: #0f766e;
            border: 1px solid #0f766e;
            color: #fff;
        }

            .edit-sec-btn-primary:hover,
            .edit-sec-btn-primary:focus {
                background: #0b5f59;
                border-color: #0b5f59;
                color: #fff;
            }

        .edit-sec-btn-light {
            background: rgba(255,255,255,0.96);
            border: 1px solid rgba(255,255,255,0.96);
            color: #17324d;
        }

        .edit-sec-btn-soft {
            background: #eef6f5;
            border: 1px solid #cce3df;
            color: #0f5f58;
        }

        .edit-sec-btn-outline {
            background: #fff;
            border: 1px solid #cbd6df;
            color: #263747;
        }

        .edit-sec-stat-grid {
            display: grid;
            gap: 12px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            margin-bottom: 18px;
        }

        .edit-sec-stat {
            background: #fff;
            border: 1px solid #dce5ec;
            border-left: 4px solid #164e63;
            border-radius: 8px;
            box-shadow: 0 8px 18px rgba(31, 51, 71, 0.06);
            padding: 14px 16px;
        }

            .edit-sec-stat span {
                color: #667789;
                display: block;
                font-size: 12px;
                font-weight: 700;
                margin-bottom: 4px;
            }

            .edit-sec-stat strong {
                color: #172737;
                display: block;
                font-size: 22px;
                line-height: 1;
            }

        .edit-sec-panel {
            background: #fff;
            border: 1px solid #dce5ec;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(31, 51, 71, 0.06);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .edit-sec-panel-header {
            align-items: center;
            border-bottom: 1px solid #e7edf2;
            display: flex;
            gap: 14px;
            justify-content: space-between;
            padding: 16px 18px;
        }

        .edit-sec-panel-title {
            align-items: center;
            color: #172737;
            display: flex;
            font-size: 16px;
            font-weight: 700;
            gap: 9px;
            margin: 0;
        }

        .edit-sec-panel-subtitle {
            color: #6d7f90;
            font-size: 12px;
            margin: 4px 0 0;
        }

        .edit-sec-panel-body {
            padding: 18px;
        }

        .edit-sec-section-title {
            align-items: center;
            color: #2d3f50;
            display: flex;
            font-size: 13px;
            font-weight: 800;
            gap: 8px;
            margin: 18px 0 12px;
        }

            .edit-sec-section-title:first-child {
                margin-top: 0;
            }

        .edit-sec-form-grid {
            display: grid;
            gap: 14px 16px;
            grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .edit-sec-field {
            min-width: 0;
        }

        .edit-sec-field-wide {
            grid-column: span 2;
        }

        .edit-sec-field label {
            color: #46596b;
            display: block;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .edit-sec-field .form-control {
            border-color: #cfdbe5;
            border-radius: 6px;
            box-shadow: none;
            color: #172737;
            font-size: 13px;
            min-height: 38px;
            width: 100%;
        }

        .edit-sec-field textarea.form-control {
            min-height: 76px;
            resize: vertical;
        }

        .edit-sec-field .form-control:focus {
            border-color: #164e63;
            box-shadow: 0 0 0 3px rgba(22, 78, 99, 0.14);
        }

        .edit-sec-action-row {
            align-items: center;
            border-top: 1px solid #e7edf2;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
            padding-top: 16px;
        }

        .edit-sec-table-toolbar {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
        }

        .edit-sec-table-tools {
            align-items: center;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .edit-sec-search {
            min-width: 280px;
            position: relative;
        }

            .edit-sec-search i {
                color: #7d8d9c;
                left: 12px;
                position: absolute;
                top: 11px;
            }

            .edit-sec-search input {
                padding-left: 34px;
            }

        .edit-sec-table-wrap {
            padding: 0 18px 18px;
        }

        #table_editSectracking {
            border-collapse: separate !important;
            border-spacing: 0;
            margin-top: 0 !important;
            width: 100% !important;
        }

            #table_editSectracking thead th {
                background: #edf3f6 !important;
                border-color: #d7e2ea !important;
                color: #263747;
                font-size: 12px;
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }

            #table_editSectracking tbody td {
                background: #fff;
                border-color: #e2e9ef !important;
                color: #263747;
                font-size: 12px;
                vertical-align: middle;
            }

            #table_editSectracking tbody tr:hover td {
                background: #f7fbfa;
            }

            #table_editSectracking tbody tr.edit-sec-selected-row td {
                background: #e7f5f2 !important;
                font-weight: 700;
            }

            #table_editSectracking a.dropdown-item {
                align-items: center;
                background: #eef6f5;
                border: 1px solid #cce3df;
                border-radius: 6px;
                color: #0f5f58;
                display: inline-flex;
                height: 30px;
                justify-content: center;
                padding: 0;
                width: 34px;
            }

                #table_editSectracking a.dropdown-item span,
                #table_editSectracking a.dropdown-item i {
                    color: inherit !important;
                }

        .dataTables_wrapper .dataTables_length,
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

        .edit-sec-message-icon {
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
            .edit-sec-form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .edit-sec-stat-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 767px) {
            .edit-sec-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .edit-sec-hero-actions,
            .edit-sec-action-row,
            .edit-sec-table-toolbar,
            .edit-sec-table-tools {
                align-items: stretch;
                flex-direction: column;
                width: 100%;
            }

            .edit-sec-btn,
            .edit-sec-search,
            .edit-sec-search input {
                width: 100%;
            }

            .edit-sec-form-grid,
            .edit-sec-stat-grid {
                grid-template-columns: 1fr;
            }

            .edit-sec-field-wide {
                grid-column: span 1;
            }
        }
    </style>

    <script>
        $(document).ready(function () {
            bindGrid_forEdit();
            sectrack_BindClient();
            editSectrack_BindDeals();
            editSectrack_InitEnhancements();
        });

        function editSectrack_InitEnhancements() {
            $("#editSectrack_RequestedDate, #editSectrack_SLADeliveryDate").on("change", editSectrack_UpdateDeliveryDays);

            $("#editSectrack_SLADeliveryDays").on("input", function () {
                $(this).data("manual", true);
            });

            $("#editSectrack_table_search").on("input", function () {
                if ($.fn.DataTable.isDataTable("#table_editSectracking")) {
                    $("#table_editSectracking").DataTable().search(this.value).draw();
                }
            });

            $("#editSectrack_refresh_grid").on("click", function () {
                bindGrid_forEdit();
                return false;
            });

            $("#editSectrack_btnReset").on("click", function () {
                editSectrack_ClearForm();
                editSectrack_ClearTableSelection();
                return false;
            });
        }

        function editSectrack_UpdateDeliveryDays() {

            var requestedDate = $("#editSectrack_RequestedDate").val();
            var slaDate = $("#editSectrack_SLADeliveryDate").val();
            var $days = $("#editSectrack_SLADeliveryDays");

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

        function editSectrack_ClearForm() {
            window.secureID = 0;
            $("#editSectrack_DealNo, #editSectrack_Project").val("");
            $("#editSectrack_ClientDealName, #editSectrack_NoOfLoans").val("");
            $("#editSectrack_RequestedDate, #editSectrack_SLADeliveryDate, #editSectrack_ActualDeliveredDate").val("");
            $("#editSectrack_SLADeliveryDays, #editSectrack_BillingHours").val("").data("manual", false);
            $("#editSectrack_TaskName, #editSectrack_RLSigned, #editSectrack_Status").val("Select");
            $("#editSectrack_ClientNameAddress, #editSectrack_RecipientNameAddress, #editSectrack_AgencyNameAddress, #editSectrack_Remark").val("");
            $("#editSectrack_stat_selected").text("-");
        }

        function editSectrack_ClearTableSelection() {
            $("#table_editSectracking")
                .find("tr")
                .removeAttr("style")
                .removeClass("highlight bold-row selected edit-sec-selected-row")
                .css({
                    "background-color": "",
                    "font-weight": "normal"
                });
        }

        function editSectrack_OnGridBound(rows) {
            rows = rows || [];
            var openItems = 0;
            var completed = 0;

            rows.forEach(function (row) {
                var status = (row.Status || "").toString().toLowerCase();
                if (status === "pending" || status === "in process") {
                    openItems++;
                }
                if (status === "completed") {
                    completed++;
                }
            });

            $("#editSectrack_stat_records").text(rows.length);
            $("#editSectrack_stat_open").text(openItems);
            $("#editSectrack_stat_completed").text(completed);
        }

        function editSectrack_OnRecordSelected(row) {
            $("#editSectrack_stat_selected").text(row && row[2] ? row[2] : "-");
            $("#editSectrack_SLADeliveryDays").data("manual", !!$("#editSectrack_SLADeliveryDays").val());
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" alt="Loading" />
        <div>One moment, please...</div>
    </div>

    <div class="edit-sec-page">
        <div class="edit-sec-hero">
            <div>
                <div class="edit-sec-kicker">Operations</div>
                <h1 class="edit-sec-title"><i class="fas fa-edit mr-2"></i>Edit Securitization Tracking</h1>
                <p class="edit-sec-subtitle">Update delivery, compliance, billing, and party details.</p>
            </div>
            <div class="edit-sec-hero-actions">
                <a href="SecuritizationTracking.aspx" class="edit-sec-btn edit-sec-btn-light">
                    <i class="fas fa-arrow-left"></i>
                    Back
                </a>
                <a href="ImportSecuritizationLoans.aspx" class="edit-sec-btn edit-sec-btn-light">
                    <i class="fas fa-file-import"></i>
                    Import Loans
                </a>
            </div>
        </div>
        <div class="edit-sec-panel">
            <div class="edit-sec-panel-header">
                <div>
                    <h2 class="edit-sec-panel-title"><i class="fas fa-file-alt"></i>Record Details</h2>
                    <p class="edit-sec-panel-subtitle">Selected tracking record</p>
                </div>
                <button type="button" id="editSectrack_btnReset" name="editSectrack_btnReset" class="edit-sec-btn edit-sec-btn-outline">
                    <i class="fas fa-undo"></i>
                    Reset
               
                </button>
            </div>
            <div class="edit-sec-panel-body">
                <div class="edit-sec-section-title"><i class="fas fa-briefcase"></i>Deal Details</div>
                <div class="edit-sec-form-grid">
                    <div class="edit-sec-field">
                        <label for="editSectrack_DealNo">Deal #</label>
                        <select id="editSectrack_DealNo" name="editSectrack_DealNo" class="form-control"></select>
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_Project">Client Name</label>
                        <select id="editSectrack_Project" name="editSectrack_Project" class="form-control"></select>
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_ClientDealName">Client's Deal Name</label>
                        <input type="text" id="editSectrack_ClientDealName" name="editSectrack_ClientDealName" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_NoOfLoans"># of Loans</label>
                        <input type="number" min="0" step="1" id="editSectrack_NoOfLoans" name="editSectrack_NoOfLoans" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_TaskName">Task Name</label>
                        <select id="editSectrack_TaskName" name="editSectrack_TaskName" class="form-control">
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

                <div class="edit-sec-section-title"><i class="fas fa-calendar-check"></i>Delivery And Billing</div>
                <div class="edit-sec-form-grid">
                    <div class="edit-sec-field">
                        <label for="editSectrack_RequestedDate">Requested Date</label>
                        <input type="date" id="editSectrack_RequestedDate" name="editSectrack_RequestedDate" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_SLADeliveryDate">SLA/Client Delivery Date</label>
                        <input type="date" id="editSectrack_SLADeliveryDate" name="editSectrack_SLADeliveryDate" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_SLADeliveryDays">SLA/Client Delivery Days</label>
                        <input type="number" step="1" id="editSectrack_SLADeliveryDays" name="editSectrack_SLADeliveryDays" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_ActualDeliveredDate">Actual Delivered Date</label>
                        <input type="date" id="editSectrack_ActualDeliveredDate" name="editSectrack_ActualDeliveredDate" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_RLSigned">15E or RL signed?</label>
                        <select id="editSectrack_RLSigned" name="editSectrack_RLSigned" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                            <option value="Not Applicable">Not Applicable</option>
                        </select>
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_BillingHours">Billing Hours</label>
                        <input type="number" min="0" step="0.25" id="editSectrack_BillingHours" name="editSectrack_BillingHours" class="form-control" />
                    </div>
                    <div class="edit-sec-field">
                        <label for="editSectrack_Status">Status</label>
                        <select id="editSectrack_Status" name="editSectrack_Status" class="form-control">
                            <option value="Select">Select</option>
                            <option value="Pending">Pending</option>
                            <option value="In Process">In Process</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>

                <div class="edit-sec-section-title"><i class="fas fa-address-card"></i>Parties And Remarks</div>
                <div class="edit-sec-form-grid">
                    <div class="edit-sec-field edit-sec-field-wide">
                        <label for="editSectrack_ClientNameAddress">Full Name and Address of Client/Seller</label>
                        <textarea id="editSectrack_ClientNameAddress" name="editSectrack_ClientNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="edit-sec-field edit-sec-field-wide">
                        <label for="editSectrack_RecipientNameAddress">Full Name and Address of Recipient/Buyer</label>
                        <textarea id="editSectrack_RecipientNameAddress" name="editSectrack_RecipientNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="edit-sec-field edit-sec-field-wide">
                        <label for="editSectrack_AgencyNameAddress">Full Name of Rating Agencies</label>
                        <textarea id="editSectrack_AgencyNameAddress" name="editSectrack_AgencyNameAddress" class="form-control"></textarea>
                    </div>
                    <div class="edit-sec-field edit-sec-field-wide">
                        <label for="editSectrack_Remark">Remark</label>
                        <textarea id="editSectrack_Remark" name="editSectrack_Remark" class="form-control"></textarea>
                    </div>
                </div>

                <div class="edit-sec-action-row">
                    <button id="editSectracking_btnsubmit" name="editSectracking_btnsubmit" type="button" class="edit-sec-btn edit-sec-btn-primary" onclick="return EditSectracking_submit1();">
                        <i class="fas fa-check"></i>
                        Submit
                   
                    </button>
                </div>
            </div>
        </div>

        <div class="edit-sec-panel">
            <div class="edit-sec-panel-header">
                <div>
                    <h2 class="edit-sec-panel-title"><i class="fas fa-table"></i>Tracking Records</h2>
                    <p class="edit-sec-panel-subtitle">Securitization tracking list</p>
                </div>
                <div class="edit-sec-table-toolbar">
                    <div class="edit-sec-search">
                        <i class="fas fa-search"></i>
                        <input id="editSectrack_table_search" type="search" class="form-control" placeholder="Search tracking records" />
                    </div>
                    <div class="edit-sec-table-tools">
                        <button id="editSectrack_refresh_grid" type="button" class="edit-sec-btn edit-sec-btn-outline">
                            <i class="fas fa-sync-alt"></i>
                            Refresh
                       
                        </button>
                    </div>
                </div>
            </div>
            <div class="edit-sec-table-wrap">
                <table id="table_editSectracking" class="table table-bordered" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3">Actions</th>
                            <th class="sort border-top ps-3" style="display: none; text-align: center">ProjectId</th>
                            <th class="sort border-top ps-3">Deal #</th>
                            <th class="sort border-top ps-3">Client</th>
                            <th class="sort border-top ps-3">Sales Person</th>
                            <th class="sort border-top ps-3">Client Deal #</th>
                            <th class="sort border-top ps-3">Loan Count</th>
                            <th class="sort border-top ps-3">Task Name</th>
                            <th class="sort border-top ps-3">Copies</th>
                            <th class="sort border-top ps-3">Request Date</th>
                            <th class="sort border-top ps-3">SLA/Client Delivery Date</th>
                            <th class="sort border-top ps-3">SLA/Client Delivery Days</th>
                            <th class="sort border-top ps-3">Actual Delivered Date</th>
                            <th class="sort border-top ps-3">Achieved TAT (in days)</th>
                            <th class="sort border-top ps-3"># of days leading/delayed</th>
                            <th class="sort border-top ps-3">% savings in Turntime</th>
                            <th class="sort border-top ps-3">15E or RL signed?</th>
                            <th class="sort border-top ps-3">Billing Hours</th>
                            <th class="sort border-top ps-3">Status</th>
                            <th class="sort border-top ps-3">Remark</th>
                            <th class="sort border-top ps-3">Full Name and Address of Client/Seller</th>
                            <th class="sort border-top ps-3">Full Name and Address of Recipient/Buyer</th>
                            <th class="sort border-top ps-3">Full Name of Rating Agencies</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editSectrack_dverror">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="edit-sec-message-icon">
                        <i class="fas fa-info-circle"></i>
                    </div>
                    <h6 class="modal-title" id="editSectrack_errmsg"></h6>
                </div>
                <div class="modal-footer justify-content-center">
                    <button class="edit-sec-btn edit-sec-btn-primary" type="button" id="editSectrack_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
