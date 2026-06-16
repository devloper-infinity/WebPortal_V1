<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LeaveReport.aspx.cs" Inherits="WebPortal.Admin.LeaveReport" %>

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
            /*color: #fff;
             background-color: #28a745;
         border-color: #28a745;*/
            box-shadow: none;
            background: linear-gradient(to right, #ffbf96, #fe7096);
            border: 0;
            font-weight: bold;
            margin: 0px 10px;
        }

        .table.dataTable th {
            /*  background: linear-gradient(to bottom, #dddbdb, 3%, #fff) !important;*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        #table_leaveDetails tfoot {
            font-weight: bold;
            background-color: #f8f9fa;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {

            BindViewLeaveDetails_Grid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Leave Detail Report</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="leaveReport_FromDate" name="leaveReport_FromDate" class="form-control" style="width: 200px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="leaveReport_ToDate" name="leaveReport_ToDate" class="form-control" style="width: 200px;" />
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="leaveReport__Show" onclick="return BindViewLeaveDetails_Grid();">Show</button>
                            &nbsp;&nbsp;<%--BindLeaveReport_Grid--%>
                        </td>
                    </tr>
                </table>
                <hr />
                <div style="overflow: auto;">
                    <table class="table" id="table_leaveDetails" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; width: 50px; text-align: center;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 50px;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Employee Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Department</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Designation</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Reporting Manager</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Leave Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Actual Days</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Paid</th>
                                <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Un-Paid</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Reason For Leave</th>
                                <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                            </tr>

                            <!-- Filter Row -->
                            <tr class="filters" id="filterRow">
                                <th></th>
                                <!-- Sr # no filter -->
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <!-- Code -->
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <!-- Name -->
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                                <th>
                                    <input type="text" placeholder="Search" /></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <th colspan="8"></th>
                                <th style="text-align: left;">Total :</th>
                                <th style="text-align: center;"></th>
                                <!-- Days -->
                                <th></th>
                                <th></th>
                                <th></th>
                                <th style="text-align: center;"></th>
                                <!-- Actual Days -->
                                <th style="text-align: center;"></th>
                                <!-- Paid -->
                                <th style="text-align: center;"></th>
                                <!-- Unpaid -->
                                <th colspan="4"></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <table class="table" id="table_leaveReport_1" style="width: 100%; display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap;">Action</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Reason For Leave</th>
                            <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>


    <div class="modal fade" id="popUpViewLeaveDetails">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title">
                        <label id="leaveReport_empInfo" name="leaveReport_empInfo" style="font-size: 15px!important; font-weight: bold!important;"></label>
                    </h1>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div style="width: 100%; overflow: auto;">
                        <table class="table" id="table_leaveDetails_1" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Leave Type</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Days</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave From</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 80px;">Leave To</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 300px;">Reason For Leave</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Leave Status</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Actual Days</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Paid</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Un-Paid</th>
                                    <th class="sort border-top" style="text-wrap: nowrap; width: 400px;">Approval Remark</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Approved By</th>
                                    <th class="sort border-top" style="text-wrap: nowrap;">Approved Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="2" style="text-align: right">Total:</th>
                                    <th style="text-align: center"></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                    <th style="text-align: center"></th>
                                    <th style="text-align: center"></th>
                                    <th style="text-align: center"></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <%--onclick="return location.reload();"--%>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
