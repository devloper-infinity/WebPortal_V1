<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeLeaves.aspx.cs" Inherits="WebPortal.Admin.EmployeeLeaves" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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

        .leave-page {
            width: 100%;
            padding: 0 2px 26px;
        }

        .leave-shell {
            display: grid;
            gap: 18px;
        }

        .leave-panel {
            background: #fff;
            border: 1px solid #dbe5ec;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.07);
        }

        .leave-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5edf3;
        }

        .leave-panel-title {
            margin: 0;
            color: #172033;
            font-size: 15px;
            font-weight: 700;
        }

        .leave-panel-subtitle {
            margin: 4px 0 0;
            color: #6b7788;
            font-size: 12px;
        }

        .leave-panel-body {
            padding: 18px;
        }

        .leave-form-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 15px;
        }

        .leave-field {
            min-width: 0;
        }

        .leave-field label {
            display: block;
            margin-bottom: 6px;
            color: #344054;
            font-size: 12px;
            font-weight: 700;
        }

        .leave-field .form-control,
        .leave-field select,
        .leave-field textarea {
            width: 100%;
            min-height: 38px;
            border: 1px solid #cad6e2;
            border-radius: 6px;
            box-shadow: none;
            color: #172033;
            font-size: 13px;
        }

        .leave-field textarea {
            min-height: 38px;
            resize: vertical;
        }

        .leave-field--wide {
            grid-column: span 2;
        }

        .leave-optional-grid {
            margin-top: 15px;
        }

        .leave-metrics-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .leave-metric-value {
            display: flex;
            align-items: center;
            min-height: 38px;
            padding: 8px 12px;
            border: 1px solid #d7e2ea;
            border-radius: 6px;
            background: #f8fafc;
            color: #172033;
            font-weight: 700;
        }

        .leave-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 18px;
        }

        .leave-primary-action,
        .leave-modal .btn-primary {
            border: 0;
            border-radius: 6px;
            background: #1f6feb;
            box-shadow: 0 8px 18px rgba(31, 111, 235, 0.22);
            font-weight: 700;
            min-width: 108px;
        }

        .leave-secondary-action,
        .leave-modal .btn-default {
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            background: #fff;
            color: #334155;
            font-weight: 700;
            min-width: 92px;
        }

        .leave-table-panel .leave-panel-header {
            padding-bottom: 12px;
        }

        .leave-table-wrap {
            width: 100%;
            overflow-x: auto;
            padding: 0 18px 18px;
        }

        .leave-data-table {
            width: 100% !important;
            margin: 0 !important;
            border-collapse: separate !important;
            border-spacing: 0;
            color: #253044;
            font-size: 12px;
        }

        .leave-data-table thead th,
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

        .leave-data-table tbody td,
        table.dataTable tbody td {
            border-bottom: 1px solid #edf2f7;
            padding: 10px 12px !important;
            vertical-align: top;
            background: #fff;
        }

        .leave-data-table tbody tr:hover td,
        table.dataTable tbody tr:hover td {
            background: #f8fbfd;
        }

        .dataTables_wrapper {
            padding: 0;
        }

        .dataTables_wrapper .dataTables_filter {
            margin: 0 18px 12px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_wrapper .dataTables_filter input {
            height: 34px;
            min-width: 220px;
            margin-left: 8px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_info {
            padding: 12px 18px 0;
            color: #64748b;
            font-size: 12px;
        }

        .dataTables_paginate {
            float: left !important;
            padding: 14px 0 0 18px !important;
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

        .btn-datatable,
        .dt-button.btn-datatable,
        .buttons-excel,
        .buttons-pdf {
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

        #empleaves_table .dropdown-menu {
            border: 1px solid #d8e2ea;
            border-radius: 8px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.14);
            font-size: 12px;
        }

        #empleaves_table .dropdown-item {
            padding: 8px 14px;
        }

        .leave-modal .modal-content {
            border: 0;
            border-radius: 10px;
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
        }

        .leave-modal .modal-header {
            border-bottom: 1px solid #e5edf3;
            padding: 16px 18px;
        }

        .leave-modal .modal-title {
            color: #172033;
            font-size: 16px;
            font-weight: 700;
        }

        .leave-modal .modal-body {
            padding: 18px;
        }

        .leave-modal label {
            display: block;
            margin-bottom: 6px;
            color: #344054;
            font-size: 12px;
            font-weight: 700;
        }

        .leave-modal .form-control {
            width: 100%;
            min-height: 38px;
            border: 1px solid #cad6e2;
            border-radius: 6px;
            box-shadow: none;
            color: #172033;
            font-size: 13px;
        }

        .leave-modal textarea.form-control {
            min-height: 76px;
            resize: vertical;
        }

        .leave-modal .modal-footer {
            border-top: 1px solid #e5edf3;
            padding: 14px 18px;
        }

        .leave-modal-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
        }

        .leave-hidden {
            display: none;
        }

        .leave-date-range {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px;
        }

        .leave-message-modal .modal-content {
            text-align: center;
        }

        .leave-waiting-panel .modal-dialog {
            margin-top: 22vh;
        }

        .leave-waiting-content {
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

        .leave-waiting-content img {
            width: 44px;
            height: 44px;
        }

        @media (max-width: 1199px) {
            .leave-form-grid,
            .leave-modal-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .leave-field--wide {
                grid-column: span 1;
            }
        }

        @media (max-width: 767px) {
            .leave-panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .leave-form-grid,
            .leave-modal-grid,
            .leave-metrics-grid,
            .leave-date-range {
                grid-template-columns: 1fr;
            }

            .leave-actions {
                justify-content: stretch;
            }

            .leave-primary-action {
                width: 100%;
            }
        }
    </style>

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
        }
    </style>

    <script>
        $(document).ready(function () {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            if (currentUserName == 7036 || currentUserName == 12 || currentUserName == 216 || currentUserName == 285 || currentUserName == 8535 || currentUserName == 9738 || currentUserName == 277 || currentUserName == 99 || currentUserName == 8128 || currentUserName == 291 || currentUserName == 255 || currentUserName == 7171) {
                document.getElementById("mainleaveuser").style.display = "";
                empleave_bindemployee();
                empleave_bindgrid();
            }
            else {
                document.getElementById("mainleaveuser").style.display = "none";
                alert("You are not authorized to access this page. Please reach out to your domain head for assistance.");
                return;
            }

        });

        document.addEventListener("DOMContentLoaded", function () {
            const today = new Date().toISOString().split("T")[0];

            document.getElementById("empleave_fromdate").setAttribute("min", today);
        });
    </script>

    <script src="../Scripts/Functions/EmpLeave.js?v=1"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <%--    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Employee Leaves</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>--%>

   <div class="dashboard-header">
    <div class="d-flex justify-content-between align-items-start mb-1">
        <div>
            <div class="dashboard-title">
                <i class="fas fa-calendar-alt mr-2"></i>
                Employee Leaves
            </div>
            <div class="dashboard-subtitle">
                Manage employee leave requests, track approvals, monitor leave balances, and review leave history.
            </div>
        </div>
    </div>
</div>

    <div class="leave-page" id="mainleaveuser">
        <div class="leave-shell">
            <div class="leave-panel">
                <div class="leave-panel-header">
                    <div>
                        <h3 class="leave-panel-title">Leave Request</h3>
                        <p class="leave-panel-subtitle">Enter leave information and eligibility details.</p>
                    </div>
                </div>
                <div class="leave-panel-body">
                <%--     <table class="table">
                    <tr>
                        <td><b>Code:</b></td>
                        <td>
                            <select id="empleave_user" name="empleave_user" class="form-control" style="width: 250px;" onchange="return getPaidEligibility(this);"></select>
                        </td>
                        <td><b>Inform Type:</b></td>
                        <td>
                            <select id="empleave_informtype" name="empleave_informtype" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Inform On CallSMS">Inform On CallSMS</option>
                                <option value="Inform By Other Person">Inform By Other Person</option>
                                <option value="ByEmail">By Email</option>
                                <option value="Other">Other</option>
                            </select>
                        </td>
                        <td><b>Days:</b></td>
                        <td>
                            <select id="empleave_days" name="empleave_days" class="form-control" style="width: 250px;" onchange="return GetLeavesToDate();">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                                <option value="13">13</option>
                                <option value="14">14</option>
                                <option value="15">15</option>
                                <option value="16">16</option>
                                <option value="17">17</option>
                                <option value="18">18</option>
                                <option value="19">19</option>
                                <option value="20">20</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="empleave_fromdate" name="empleave_fromdate" class="form-control" style="width: 250px;" onchange="return GetLeavesToDate();" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="empleave_todate" name="empleave_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Reason:</b></td>
                        <td>
                            <textarea id="empleave_reason" name="empleave_reason" class="form-control" style="width: 250px;"></textarea>
                        </td>
                    </tr>
                    <tr id="paidunpid" style="display: none;">
                        <td><b>Paid/ Unpaid?</b></td>
                        <td>
                            <select id="empleave_paidunpaid" name="empleave_paidunpaid" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr id="empleave_leavedetails" style="display: none;">
                        <td><b>Total Leaves:</b></td>
                        <td>
                            <span id="empleave_totalleaves" name="empleave_totalleaves" class="form-control" style="width: 250px; font-weight: bold; background-color: lightgray;"></span>
                        </td>
                        <td><b>Applied Leaves:</b></td>
                        <td>
                            <span id="empleave_appliedleaves" name="empleave_appliedleaves" class="form-control" style="width: 250px; font-weight: bold; background-color: powderblue;"></span>
                        </td>
                        <td><b>Pending Leaves:</b></td>
                        <td>
                            <span id="empleave_pendingleaves" name="empleave_pendingleaves" class="form-control" style="width: 250px; font-weight: bold; background-color: lightgreen;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="empleave_btnsubmit" name="empleave_btnsubmit" class="btn btn-primary" onclick="return empleave_submit();">Submit</button>
                        </td>
                    </tr>
                </table>--%>

                    <div class="leave-form-grid">
                        <div class="leave-field">
                            <label for="empleave_user">Code</label>
                            <select id="empleave_user" name="empleave_user" class="form-control" onchange="return getPaidEligibility(this);"></select>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_informtype">Inform Type</label>
                            <select id="empleave_informtype" name="empleave_informtype" class="form-control">
                                <option value="">Select</option>
                                <option value="Inform On CallSMS">Inform On CallSMS</option>
                                <option value="Inform By Other Person">Inform By Other Person</option>
                                <option value="ByEmail">By Email</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_days">Days</label>
                            <select id="empleave_days" name="empleave_days" class="form-control" onchange="return GetLeavesToDate();">
                                <option value="">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                                <option value="13">13</option>
                                <option value="14">14</option>
                                <option value="15">15</option>
                                <option value="16">16</option>
                                <option value="17">17</option>
                                <option value="18">18</option>
                                <option value="19">19</option>
                                <option value="20">20</option>
                            </select>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_fromdate">From Date</label>
                            <input type="date" id="empleave_fromdate" name="empleave_fromdate" class="form-control" onchange="return GetLeavesToDate();" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_todate">To Date</label>
                            <input type="date" id="empleave_todate" name="empleave_todate" class="form-control" />
                        </div>

                        <div class="leave-field leave-field--wide">
                            <label for="empleave_reason">Reason</label>
                            <textarea id="empleave_reason" name="empleave_reason" class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="leave-form-grid leave-optional-grid" id="paidunpid" style="display: none;">
                        <div class="leave-field">
                            <label for="empleave_paidunpaid">Paid / Unpaid</label>
                            <select id="empleave_paidunpaid" name="empleave_paidunpaid" class="form-control">
                                <option value="">Select</option>
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </div>
                    </div>

                    <div class="leave-metrics-grid" id="empleave_leavedetails" style="display: none;">
                        <div class="leave-field">
                            <label for="empleave_totalleaves">Total Leaves</label>
                            <span id="empleave_totalleaves" name="empleave_totalleaves" class="leave-metric-value"></span>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_appliedleaves">Applied Leaves</label>
                            <span id="empleave_appliedleaves" name="empleave_appliedleaves" class="leave-metric-value"></span>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_pendingleaves">Pending Leaves</label>
                            <span id="empleave_pendingleaves" name="empleave_pendingleaves" class="leave-metric-value"></span>
                        </div>
                    </div>

                    <div class="leave-actions">
                        <button id="empleave_btnsubmit" name="empleave_btnsubmit" class="btn btn-primary leave-primary-action" onclick="return empleave_submit();">Submit</button>
                    </div>

                </div>
            </div>

            <div class="leave-panel leave-table-panel">
                <div class="leave-panel-header">
                    <div>
                        <h3 class="leave-panel-title">Leave History</h3>
                        <p class="leave-panel-subtitle">Review approvals, pending items, and completed leave records.</p>
                    </div>
                </div>
                <div class="leave-table-wrap">
                    <table class="table table-hover leave-data-table" id="empleaves_table">
                        <thead>
                            <tr>
                                <th>Actions</th>
                                <th>Employee</th>
                                <th>Leave Type</th>
                                <th># of days</th>
                                <th>From Date</th>
                                <th>To Date</th>
                                <th>Status</th>
                                <th>Reason</th>
                                <th>Approved/Rejected By</th>
                                <th>Approved/Rejected Date</th>
                                <th>Approved/Rejected Remark</th>
                                <th style="display: none;">Eligible</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade leave-waiting-panel" id="empleave_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <div class="leave-waiting-content">
                <img src="../Images/Load.gif" />
                <span>System is sending email notification. Please wait . . .</span>
            </div>
        </div>
    </div>

    <div class="modal fade leave-modal leave-message-modal" id="empleave_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="empleave_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="empleave_btnMessage" onclick="return empleave_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade leave-modal" id="empleave_approvalrejection">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><span id="leave_username"></span></h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <%--  <div class="modal-body">

                    <table class="table table-responsive">
                        <tr>
                            <td><b>Code:</b></td>
                            <td>
                                <input class="form-control" id="empleave_approve_code" value="Code" style="width: 300px;" />
                            </td>

                            <td><b>Leave Type:</b></td>
                            <td>
                                <input class="form-control" id="empleave_approve_leavetype" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Date Range:</b></td>
                            <td>
                                <input class="form-control" id="empleave_approve_daterange" style="width: 300px;" />
                                <input class="form-control" id="empleave_approve_fordays" style="display: none;" />
                            </td>

                            <td><b>Reason:</b></td>
                            <td>
                                <textarea class="form-control" id="empleave_approve_reason" style="width: 300px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Action:</b></td>
                            <td>
                                <select name="empleave_approve_ddaction" required id="empleave_approve_ddaction" class="form-control" onchange="changebuttontext();" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Approve">Approve</option>
                                    <option value="Reject">Reject</option>
                                </select>
                            </td>
                            <td><b>Comments:</b></td>
                            <td>
                                <textarea name="empleave_approve_comments" id="empleave_approve_comments" class="form-control" style="width: 300px;"></textarea>
                            </td>

                        </tr>
                        <tr>
                            <td id="leavestatus"><b>Status:</b></td>
                            <td id="leavestatusrow">
                                <select name="empleave_approve_leavestatus" id="empleave_approve_leavestatus" class="form-control" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Unpaid">Unpaid</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>--%>

                <div class="modal-body">
                    <div class="leave-modal-grid">
                        <div class="leave-field leave-hidden">
                            <label for="empleave_approve_code">Code</label>
                            <input class="form-control" id="empleave_approve_code" value="Code" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_approve_leavetype">Leave Type</label>
                            <input class="form-control" id="empleave_approve_leavetype" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_approve_daterange">Date Range</label>
                            <input class="form-control" id="empleave_approve_daterange" />
                            <input class="form-control leave-hidden" id="empleave_approve_fordays" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_approve_reason">Reason</label>
                            <textarea class="form-control" id="empleave_approve_reason"></textarea>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_approve_ddaction">Action</label>
                            <select name="empleave_approve_ddaction" id="empleave_approve_ddaction" class="form-control" onchange="changebuttontext();">
                                <option value="">Select</option>
                                <option value="Approve">Approve</option>
                                <option value="Reject">Reject</option>
                            </select>
                        </div>

                        <div class="leave-field" id="leavestatusrow">
                            <label id="leavestatus" for="empleave_approve_leavestatus">Status</label>
                            <select name="empleave_approve_leavestatus" id="empleave_approve_leavestatus" class="form-control">
                                <option value="">Select</option>
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_approve_comments">Comments</label>
                            <textarea name="empleave_approve_comments" id="empleave_approve_comments" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="empleave_approve_btnApprove" onclick="empleave_approve_SubmitAction();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade leave-modal" id="empleave_leaveentendshorten">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><span id="empleave_extend_username"></span></h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <%--      <table class="table">
                        <tr>
                            <td><b>Code:</b></td>
                            <td>
                                <input class="form-control" id="empleave_extend_code" style="width: 300px;" />
                            </td>

                            <td><b>Leave Type:</b></td>
                            <td>
                                <input class="form-control" id="empleave_extend_lavetype" style="width: 300px;" />
                            </td>
                        </tr>
                        <tr>
                            <td><b>Reason:</b></td>
                            <td>
                                <textarea class="form-control" id="empleave_extend_reason" style="width: 300px;"></textarea>
                            </td>

                            <td><b>Action:</b></td>
                            <td>
                                <select name="empleave_extend_ddaction" required id="empleave_extend_ddaction" class="form-control" onchange="changebuttontextEx();" style="width: 300px;">
                                    <option value="">Select</option>
                                    <option value="Extend">Extend</option>
                                    <option value="Shorten">Shorten</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Days:</b></td>
                            <td>
                                <label id="empleave_extend_days_hidden" style="display: none;"></label>
                                <select name="empleave_extend_days" id="empleave_extend_days" class="form-control" onchange="GetLeavesToDateEx();" style="width: 300px;">
                                </select>
                            </td>

                            <td><b>Date Range:</b></td>
                            <td>
                                <input class="form-control" id="empleave_extend_fromdate" style="display: inline; width: 150px;" />
                                &nbsp;&nbsp;<input class="form-control" id="empleave_extend_todate" style="display: inline; width: 150px;" />
                            </td>
                        </tr>


                        <tr>
                            <td><b>Comments:</b></td>
                            <td>
                                <textarea name="empleave_extend_comments" id="empleave_extend_comments" class="form-control" style="width: 300px;"></textarea>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>--%>

                    <div class="leave-modal-grid">
                        <div class="leave-field leave-hidden">
                            <label for="empleave_extend_code">Code</label>
                            <input class="form-control" id="empleave_extend_code" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_extend_lavetype">Leave Type</label>
                            <input class="form-control" id="empleave_extend_lavetype" />
                        </div>

                        <div class="leave-field">
                            <label for="empleave_extend_reason">Reason</label>
                            <textarea class="form-control" id="empleave_extend_reason"></textarea>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_extend_ddaction">Action</label>
                            <select name="empleave_extend_ddaction" id="empleave_extend_ddaction" class="form-control" onchange="changebuttontextEx();">
                                <option value="">Select</option>
                                <option value="Extend">Extend</option>
                                <option value="Shorten">Shorten</option>
                            </select>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_extend_days">Days</label>
                            <label id="empleave_extend_days_hidden" style="display: none;"></label>
                            <select name="empleave_extend_days" id="empleave_extend_days" class="form-control" onchange="GetLeavesToDateEx();"></select>
                        </div>

                        <div class="leave-field">
                            <label>Date Range</label>
                            <div class="leave-date-range">
                                <input class="form-control" id="empleave_extend_fromdate" />
                                <input class="form-control" id="empleave_extend_todate" />
                            </div>
                        </div>

                        <div class="leave-field">
                            <label for="empleave_extend_comments">Comments</label>
                            <textarea name="empleave_extend_comments" id="empleave_extend_comments" class="form-control"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="empleave_extend_btnApprove" onclick="empleave_extend_submit();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade leave-modal leave-message-modal" id="empleave_Cancelleave">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Cancel Leave</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <p>Are you sure you want to cancel leave?</p>

                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="empleave_cancel_btnYes" onclick="empleave_cancel_Submit();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
