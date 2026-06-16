<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EmployeeLeaves.aspx.cs" Inherits="WebPortal.Admin.EmployeeLeaves" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        /*.form-control {
            font-size: 11px !important;
        }*/
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

    <script src="../Scripts/Functions/EmpLeave.js"></script>
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

    <div class="col-lg-12" id="mainleaveuser">
        <div class="card">
            <div class="card-body">
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

                <div class="container-fluid">

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label><b>Code:</b></label>
                            <select id="empleave_user" name="empleave_user" class="form-control"
                                onchange="return getPaidEligibility(this);">
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label><b>Inform Type:</b></label>
                            <select id="empleave_informtype" name="empleave_informtype" class="form-control">
                                <option value="">Select</option>
                                <option value="Inform On CallSMS">Inform On CallSMS</option>
                                <option value="Inform By Other Person">Inform By Other Person</option>
                                <option value="ByEmail">By Email</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label><b>Days:</b></label>
                            <select id="empleave_days" name="empleave_days" class="form-control"
                                onchange="return GetLeavesToDate();">
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
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label><b>From Date:</b></label>
                            <input type="date" id="empleave_fromdate" name="empleave_fromdate"
                                class="form-control" onchange="return GetLeavesToDate();" />
                        </div>

                        <div class="col-md-4">
                            <label><b>To Date:</b></label>
                            <input type="date" id="empleave_todate" name="empleave_todate"
                                class="form-control" />
                        </div>

                        <div class="col-md-4">
                            <label><b>Reason:</b></label>
                            <textarea id="empleave_reason" name="empleave_reason"
                                class="form-control"></textarea>
                        </div>
                    </div>

                    <div class="row mb-3" id="paidunpid" style="display: none;">
                        <div class="col-md-4">
                            <label><b>Paid/ Unpaid?</b></label>
                            <select id="empleave_paidunpaid" name="empleave_paidunpaid" class="form-control">
                                <option value="">Select</option>
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3" id="empleave_leavedetails" style="display: none;">
                        <div class="col-md-4">
                            <label><b>Total Leaves:</b></label>
                            <span id="empleave_totalleaves" name="empleave_totalleaves"
                                class="form-control font-weight-bold"
                                style="background-color: lightgray;"></span>
                        </div>

                        <div class="col-md-4">
                            <label><b>Applied Leaves:</b></label>
                            <span id="empleave_appliedleaves" name="empleave_appliedleaves"
                                class="form-control font-weight-bold"
                                style="background-color: powderblue;"></span>
                        </div>

                        <div class="col-md-4">
                            <label><b>Pending Leaves:</b></label>
                            <span id="empleave_pendingleaves" name="empleave_pendingleaves"
                                class="form-control font-weight-bold"
                                style="background-color: lightgreen;"></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12 text-center">
                            <button id="empleave_btnsubmit" name="empleave_btnsubmit"
                                class="btn btn-primary"
                                onclick="return empleave_submit();">
                                Submit
                            </button>
                        </div>
                    </div>

                </div>

                <hr />
                <table class="table" id="empleaves_table" style="padding-top: 10px; width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"># of days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved/Rejected By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved/Rejected Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Approved/Rejected Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">Eligible</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="empleave_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="empleave_dverror">
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

    <div class="modal fade" id="empleave_approvalrejection">
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

                    <!-- Row 1 -->
                    <div class="row mb-3">
                        <div class="col-md-4" style="display: none;">
                            <label><b>Code:</b></label>
                            <input class="form-control" id="empleave_approve_code" value="Code" />
                        </div>

                        <div class="col-md-4">
                            <label><b>Leave Type:</b></label>
                            <input class="form-control" id="empleave_approve_leavetype" />
                        </div>

                        <div class="col-md-4">
                            <label><b>Date Range:</b></label>
                            <input class="form-control" id="empleave_approve_daterange" />
                            <input class="form-control" id="empleave_approve_fordays" style="display: none;" />
                        </div>
                        <div class="col-md-4">
                            <label><b>Reason:</b></label>
                            <textarea class="form-control" id="empleave_approve_reason"></textarea>
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label><b>Action:</b></label>
                            <select name="empleave_approve_ddaction"
                                id="empleave_approve_ddaction"
                                class="form-control"
                                onchange="changebuttontext();">
                                <option value="">Select</option>
                                <option value="Approve">Approve</option>
                                <option value="Reject">Reject</option>
                            </select>
                        </div>
                        <div class="col-md-4" id="leavestatusrow">
                            <label id="leavestatus"><b>Status:</b></label>
                            <select name="empleave_approve_leavestatus"
                                id="empleave_approve_leavestatus"
                                class="form-control">
                                <option value="">Select</option>
                                <option value="Paid">Paid</option>
                                <option value="Unpaid">Unpaid</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label><b>Comments:</b></label>
                            <textarea name="empleave_approve_comments"
                                id="empleave_approve_comments"
                                class="form-control"></textarea>
                        </div>
                    </div>

                    <!-- Row 3 -->
                    <div class="row mb-3">
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

    <div class="modal fade" id="empleave_leaveentendshorten">
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

                    <div class="container-fluid">

                        <!-- Row 1 -->
                        <div class="row mb-3">
                            <div class="col-md-4" style="display: none;">
                                <label><b>Code:</b></label>
                                <input class="form-control" id="empleave_extend_code" />
                            </div>

                            <div class="col-md-4">
                                <label><b>Leave Type:</b></label>
                                <input class="form-control" id="empleave_extend_lavetype" />
                            </div>

                            <div class="col-md-4">
                                <label><b>Reason:</b></label>
                                <textarea class="form-control" id="empleave_extend_reason"></textarea>
                            </div>
                            <div class="col-md-4">
                                <label><b>Action:</b></label>
                                <select name="empleave_extend_ddaction"
                                    id="empleave_extend_ddaction"
                                    class="form-control"
                                    onchange="changebuttontextEx();">
                                    <option value="">Select</option>
                                    <option value="Extend">Extend</option>
                                    <option value="Shorten">Shorten</option>
                                </select>
                            </div>
                        </div>

                        <!-- Row 2 -->
                        <div class="row mb-3">


                            <div class="col-md-4">
                                <label><b>Days:</b></label>
                                <label id="empleave_extend_days_hidden" style="display: none;"></label>
                                <select name="empleave_extend_days"
                                    id="empleave_extend_days"
                                    class="form-control"
                                    onchange="GetLeavesToDateEx();">
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label><b>Date Range:</b></label>
                                <div class="row">
                                    <div class="col-6 pe-1">
                                        <input class="form-control" id="empleave_extend_fromdate" />
                                    </div>
                                    <div class="col-6 ps-1">
                                        <input class="form-control" id="empleave_extend_todate" />
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label><b>Comments:</b></label>
                                <textarea name="empleave_extend_comments" id="empleave_extend_comments" class="form-control"></textarea>
                            </div>
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

    <div class="modal fade" id="empleave_Cancelleave">
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
