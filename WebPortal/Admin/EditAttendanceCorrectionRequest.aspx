<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditAttendanceCorrectionRequest.aspx.cs" Inherits="WebPortal.Admin.EditAttendanceCorrectionRequest" %>

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



        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <script>
        $(document).ready(function () {
            Edit_BindInformation();
            editatt_bindbranches();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Approve/ Reject Attendance Correction</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="AttendanceCorrectionpm.aspx" style="color: saddlebrown" ><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12" id="rightsdiv">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>User:</b></td>
                        <td>
                            <label id="editatt_user" class="form-control" style="width: 300px;"></label>
                        </td>
                        <td><b>In Date:</b></td>
                        <td>
                            <input id="editatt_indate" class="form-control" style="width: 250px;" type="date" />
                        </td>
                        <td><b>In Time:</b></td>
                        <td>
                            <input id="editatt_intime" class="form-control" style="width: 250px;" type="time" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Out Date:</b></td>
                        <td>
                            <input id="editatt_outdate" class="form-control" style="width: 300px;" type="date" />
                        </td>
                        <td><b>Out Time:</b></td>
                        <td>
                            <input id="editatt_outtime" class="form-control" style="width: 250px;" type="time" />
                        </td>
                        <td><b>Total Hours:</b></td>
                        <td>
                            <label id="editatt_totalhours" class="form-control" style="width: 250px;"></label>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Reason:</b></td>
                        <td>
                            <label id="editatt_reason" class="form-control" style="width: 300px;"></label>
                        </td>
                        <td><b>Status:</b></td>
                        <td>
                            <select id="editatt_status" name="editatt_status" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Approve">Approve</option>
                                <option value="Reject">Reject</option>
                            </select>
                        </td>
                        <td><b>Location:</b></td>
                        <td>
                            <select id="editatt_location" name="editatt_location" class="form-control" style="width: 250px;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Remark:</b></td>
                        <td colspan="3">
                            <textarea id="editatt_remark" name="editatt_remark" class="form-control" style="width: 100%;"></textarea>
                        </td>
                        <td></td>
                        <td></td>

                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="editatt_btnsubmit" name="editatt_btnsubmit" class="btn btn-primary" onclick="return editatt_submit();">Submit</button>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>
      <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
    <div class="modal fade" id="editatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="editatt_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="editatt_btnMessage" onclick="editatt_gotodashboard();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
