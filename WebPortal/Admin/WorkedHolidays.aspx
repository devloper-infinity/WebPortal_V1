<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="WorkedHolidays.aspx.cs" Inherits="WebPortal.Admin.WorkedHolidays" %>

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

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 8px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {
            wholiday_bindgrid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Worked Holidays</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table" style="width: 100%;" id="wholidays_table">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="wholiday_detailspop">
        <div class="modal-dialog modal-xl">
            <div class="modal-content shadow-lg rounded">

                <!-- HEADER -->
                <div class="modal-header bg-primary text-white" style="background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;">
                    <div>
                        <h5 class="modal-title mb-0">
                            <i class="fa fa-user-circle mr-2"></i>Worked Holiday Details - <small id="wholiday_popup_name" class="font-weight-light"></small>
                        </h5>
                    </div>

                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>

                <!-- BODY -->
                <div class="modal-body">

                    <!-- LOG TABLE CARD -->
                    <div class="card border-0 shadow-sm mb-3">
                        <div class="card-header bg-light"><b><i class="fa fa-list mr-1"></i>Activity Log</b></div>

                        <div class="card-body p-0">
                            <div class="table-responsive w-100">
                                <table class="table table-hover w-100 mb-0" id="wholiday_logdetails">
                                    <thead>
                                        <tr>
                                            <th>Action</th>
                                            <th>Date</th>
                                            <th>In Time</th>
                                            <th>Out Time</th>
                                            <th>Total Hours</th>
                                            <th>In IP</th>
                                            <th>Out IP</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- REMARK -->
                    <div class="form-group">
                        <label><b>Remark</b></label>
                        <textarea id="wholiday_popup_remark" class="form-control" rows="3" placeholder="Enter your remark here..."></textarea>
                    </div>
                </div>

                <!-- FOOTER -->
                <div class="modal-footer">
                    <%-- <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">
                        <i class="fa fa-times"></i>Close
                    </button>--%>

                    <button class="btn btn-gradient-primary" type="button" id="wholiday_pupup_btnsubmit" onclick="return wholiday_pupup_submit();"><i class="fa fa-check"></i>Approve</button>
                </div>

            </div>
        </div>
    </div>

    <%--    <div class="modal fade" id="wholiday_detailspop">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">
                                <label id="wholiday_popup_name" class="form-control" style="width: 450px;"></label>
                    </h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <tr>
                            <td style="width:100px;"><b>Name:</b></td>
                            <td>
                                <label id="wholiday_popup_name" class="form-control" style="width: 450px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table class="table" id="wholiday_logdetails" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">In Time</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Out Time</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Total Hours</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">In IP</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Out IP</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark:</b></td>
                            <td>
                                <textarea id="wholiday_popup_remark" name="wholiday_popup_remark" class="form-control" style="width:250px;"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="wholiday_pupup_btnsubmit" onclick="return wholiday_pupup_submit();">Approve</button>
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>--%>
</asp:Content>
