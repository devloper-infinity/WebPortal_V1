<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CanopyData.aspx.cs" Inherits="WebPortal.Admin.CanopyData" %>

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
            background: linear-gradient(to bottom, #007bff, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }

        .dataTables_scroll {
            overflow: auto;
        }

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
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
            canopydata_bindyear();
        });
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Lauramac Database Volume</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row align-items-end g-4">
                    <div class="col-md-4">
                        <label class="form-label"><b>Month</b></label>
                        <div class="input-group">
                            <select id="can_fromdate" name="can_fromdate" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                        </div>
                    </div>

                    <!-- Year -->
                    <div class="col-md-4">
                        <label class="form-label"><b>Year </b></label>
                        <div class="input-group">
                            <select id="can_todate" name="can_todate" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-4">
                        <button id="can_btnexport" class="btn btn-gradient-primary w-100" onclick="return getcanopyData()">Get Record</button>
                    </div>
                </div>

                <hr />
                <div class="col-lg-12">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Loan Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Task Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">

                                <table class="table" id="can_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Task Details</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">Loan ID</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Created Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Submitted Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Transaction Identifier</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Script</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Buyer</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Seller</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="candetails_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Transaction Identifier</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Created Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Submitted Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Script</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Task</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Process Flow</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Assigned User</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Assigned Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Due Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Task Status</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Delivered Date</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Buyer</th>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Seller</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="can_details">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Task Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" id="cantaskdetails" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Loan #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Process</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Task</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Assigned User</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Assigned Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Due Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Completed Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
