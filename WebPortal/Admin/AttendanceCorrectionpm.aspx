<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttendanceCorrectionpm.aspx.cs" Inherits="WebPortal.Admin.AttendanceCorrectionpm" %>

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

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            $.ajax({
                type: "POST", url: "AttendanceCorrectionpm.aspx/GetLoggedInUser", dataType: "json", contentType: "application/json",
                success: function (res) {
                    var dataArray = JSON.parse(res.d);
                    $.each(dataArray, function (data, value) {
                        if (value.Domain == 9 && value.WorkingBranch == 2) {
                            document.getElementById("attmain").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                        }
                        else if (currentUserName == 7036 || currentUserName == 12 || currentUserName == 216 || currentUserName == 285 || currentUserName == 8535 || currentUserName == 9738 || currentUserName == 277 || currentUserName == 99 || currentUserName == 8128 || currentUserName == 291 || currentUserName == 255 || currentUserName == 209) {
                            document.getElementById("attmain").style.display = "";
                            pmatt_bindusers();
                            pmatt_bindReasons();
                            pmatt_BindGrid();
                        }
                        else {
                            document.getElementById("attmain").style.display = "none";
                            alert("You are not authorized to view this page. Please contact your domain head.");
                            return;
                        }

                    })
                }
            });
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attendance Correction</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12" id="attmain">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>User:</b></td>
                        <td>
                            <select id="pmatt_user" name="pmatt_user" class="form-control" style="width: 250px;" onchange="return getattendancecount(this);"></select>
                        </td>
                        <td><b>Reason Type:</b></td>
                        <td>
                            <select id="pmatt_reason" name="pmatt_reason" class="form-control" style="width: 250px;" onchange="return pmatt_getIndates(this);"></select>
                        </td>
                        <td><b>In Date:</b></td>
                        <td>
                            <select id="pmatt_indate" name="pmatt_indate" class="form-control" style="width: 250px;" onchange="return pmatt_getInTime(this);"></select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>In Time:</b></td>
                        <td>
                            <input type="time" id="pmatt_intime" name="pmatt_intime" class="form-control" style="width: 250px;" onchange="return checkcutofftimetovalidate_pm(this);" />
                        </td>
                        <td><b>Out Date:</b></td>
                        <td>
                            <select id="pmatt_outdate" name="pmatt_outdate" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td><b>Out Time:</b></td>
                        <td>
                            <input type="time" id="pmatt_outtime" name="pmatt_outtime" class="form-control" style="width: 250px;" oninput="return pmatt_GetTotalHours();" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Total Hours:</b></td>
                        <td>
                            <input type="text" id="pmatt_totaltime" name="pmatt_totaltime" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>Reason:</b></td>
                        <td>
                            <textarea id="pmatt_userreason" name="pmatt_userreason" class="form-control" style="width: 250px;"></textarea>
                        </td>
                        <td id="pmweeklyofflabel" style="display: none;"><b>Weekly Off:</b></td>
                        <td id="pmweeklyofftext" style="display: none; color: green; font-weight: bold;"></td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="selfatt_btnsubmit" name="pmatt_btnsubmit" class="btn btn-primary" onclick="return pmatt_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="pmatt_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
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

    <div class="modal fade" id="pmatt_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="pmatt_errmsg"></h6>
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
