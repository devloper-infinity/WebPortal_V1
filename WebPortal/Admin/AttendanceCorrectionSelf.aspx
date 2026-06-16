<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceCorrectionSelf.aspx.cs" Inherits="WebPortal.Admin.AttendanceCorrectionSelf" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
            getattendancecountSelf();
            selfatt_bindReasons();
            selfatt_BindGrid();
        });
        function getattendancecountSelf() {
            PageMethods.getAttendanceCount(attcountself_OnSuccess, attcountself_OnError);
            return false;
        }
        function attcountself_OnSuccess(result) {
            if (result >= 4) {
                document.getElementById("tblselfatt").style.display = 'none';
                alert("You have already exceeded maximum number of attendance correction request limit.!");
            }
            else {
                document.getElementById("tblselfatt").style.display = '';

            }

            return false;
        }

        function attcountself_OnError(error) {
            alert(error.get_message());
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attendance Correction</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" id="tblselfatt">
                    <tr>
                        <td><b>Reason Type:</b></td>
                        <td>
                            <select id="selfatt_reason" name="selfatt_reason" class="form-control" style="width: 250px;" onchange="return selfatt_getIndates(this);"></select>
                        </td>
                        <td><b>In Date:</b></td>
                        <td>
                            <select id="selfatt_indate" name="selfatt_indate" class="form-control" style="width: 250px;" onchange="return selfatt_getInTime(this);"></select>
                        </td>
                        <td><b>In Time:</b></td>
                        <td>
                            <input type="time" id="selfatt_intime" name="selfatt_intime" class="form-control" style="width: 250px;" onchange="return checkcutofftimetovalidate(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Out Date:</b></td>
                        <td>
                            <select id="selfatt_outdate" name="selfatt_outdate" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>Out Time:</b></td>
                        <td>
                            <input type="time" id="selfatt_outtime" name="selfatt_outtime" class="form-control" style="width: 250px;" onchange="return selfatt_GetTotalHours();" />
                        </td>
                        <td><b>Total Hours:</b></td>
                        <td>
                            <input type="text" id="selfatt_totaltime" name="selfatt_totaltime" class="form-control" style="width: 250px;" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Reason:</b></td>
                        <td colspan="3">
                            <textarea id="selfatt_userreason" name="selfatt_userreason" class="form-control" style="width: 700px;"></textarea>
                        </td>
                        <td id="weeklyofflabel" style="display: none;"><b>Weekly Off:</b></td>
                        <td id="weeklyofftext" style="display: none; color: green; font-weight: bold;"></td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="selfatt_btnsubmit" name="selfatt_btnsubmit" class="btn btn-primary" onclick="return selfatt_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="selfatt_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added On</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Updated On</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
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

    <div class="modal fade" id="selfatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="selfatt_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="bank_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
