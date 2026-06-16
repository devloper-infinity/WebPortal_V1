<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="IncentiveMaster.aspx.cs" Inherits="WebPortal.Accounts.IncentiveMaster" %>

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

        .dt-center {
            text-align: center;
        }

        .highlightRow {
            background-color: #84d9d2 !important;
            font-weight: bold !important;
        }
    </style>

    <script>
        $(document).ready(function () {

            /*Tab 1*/
            incentive_bindEmployees();
            incentive_bindYear();

            var today = new Date();
            var currentMonth = today.toLocaleString('default', { month: 'long' });
            var currentYear = today.getFullYear();     // e.g., 2026

            $("#incentive_month").val(currentMonth);
            $("#incentive_year").val(currentYear);

            Incentive_bindGrid(currentMonth, currentYear);

            $('#incentive_btnreset').on('click', function () {
                clearTableHighlight();
            });

            $('#incentive_btnsubmit').on('click', function () {
                clearTableHighlight();
            });

            /*-- Tab 2 --*/
            /*  incentiveReport_bindYear();*/

            /*-- Tab 3 --*/
            prodIncv_bindYear();
            $("#prodIncv_month").val(currentMonth);
            $("#prodIncv_year").val(currentYear);

            prodIncv_bindGrid(currentMonth, currentYear);

            /*-- Tab 4 --*/
            prodReport_bindYear();
        });

        function clearTableHighlight() {

            $('#table_incentive tbody tr').removeClass('highlightRow highlight bold-row selected').removeAttr('style');
        }
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Incentive</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist" style="font-weight: bold;">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Other Incentive</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-report-tab" data-toggle="pill" href="#custom-tabs-one-report" role="tab" aria-controls="custom-tabs-one-report" aria-selected="false" onclick="incentiveReport_bindYear();">Other Incentive Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-prod-tab" data-toggle="pill" href="#custom-tabs-one-prod" role="tab" aria-controls="custom-tabs-one-prod" aria-selected="false" onclick="prodIncv_bindEmployees();">Production Incentive</a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" id="custom-tabs-one-prodreport-tab" data-toggle="pill" href="#custom-tabs-one-prodreport" role="tab" aria-controls="custom-tabs-one-prodreport" aria-selected="false">Production Incentive Report</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <table class="table">
                                <tr>
                                    <td>
                                        <b>Employee :</b>
                                    </td>
                                    <td>
                                        <select id="incentive_employee" name="incentive_employee" class="form-control" style="width: 250px;"></select>
                                    </td>
                                    <td><b>Month :</b></td>
                                    <td>
                                        <select id="incentive_month" name="incentive_month" class="form-control" style="width: 250px;">
                                            <option value="Select">Select</option>
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
                                    </td>
                                    <td><b>Year :</b></td>
                                    <td>
                                        <select id="incentive_year" name="incentive_year" class="form-control" style="width: 250px;"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Amount :</b>
                                    </td>
                                    <td>
                                        <input id="incentive_amount" name="incentive_amount" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td>
                                        <b>Remark :
                                        </b>
                                    </td>
                                    <td colspan="3">
                                        <textarea id="incentive_remark" name="incentive_remark" class="form-control" style="width: 650px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" style="text-align: center;">
                                        <button type="button" id="incentive_btnsubmit" name="incentive_btnsubmit" class="btn btn-primary" onclick="return incentive_submit();">Submit</button>
                                        <button type="reset" id="incentive_btnreset" name="incentive_btnsubmit" class="btn btn-primary" style="display: none;" onclick="return location.reload();">Reset</button>
                                    </td>
                                </tr>
                            </table>
                            <hr />
                            <table class="table" id="table_incentive" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">ID</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-report" role="tabpanel" aria-labelledby="custom-tabs-one-report-tab">
                            <table class="table">
                                <tr>
                                    <td><b>Month :</b></td>
                                    <td>
                                        <select id="incentiveReport_month" name="incentiveReport_month" class="form-control" style="width: 250px;">
                                            <option value="Select">Select</option>
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
                                    </td>
                                    <td><b>Year :</b></td>
                                    <td>
                                        <select id="incentiveReport_year" name="incentiveReport_year" class="form-control" style="width: 250px;"></select>
                                    </td>
                                    <td>
                                        <button type="button" id="incentiveReport_Show" name="incentiveReport_Show" class="btn btn-primary" onclick="return incentiveReport_btnShow();">Show</button>
                                    </td>
                                </tr>
                            </table>
                            <table class="table" id="table_incentiveReport" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th colspan="8" style="text-align: right;">Total :</th>
                                        <th style="text-align: center;"></th>
                                        <th colspan="4"></th>
                                    </tr>
                                </tfoot>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-prod" role="tabpanel" aria-labelledby="custom-tabs-one-prod-tab">
                            <table class="table">
                                <tr>
                                    <td>
                                        <b>Employee :</b>
                                    </td>
                                    <td>
                                        <select id="prodIncv_employee" name="prodIncv_employee" class="form-control" style="width: 250px;"></select>
                                    </td>
                                    <td><b>Month :</b></td>
                                    <td>
                                        <select id="prodIncv_month" name="prodIncv_month" class="form-control" style="width: 250px;">
                                            <option value="Select">Select</option>
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
                                    </td>
                                    <td><b>Year :</b></td>
                                    <td>
                                        <select id="prodIncv_year" name="prodIncv_year" class="form-control" style="width: 250px;"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Amount :</b>
                                    </td>
                                    <td>
                                        <input id="prodIncv_amount" name="prodIncv_amount" class="form-control" style="width: 250px;" />
                                    </td>
                                    <td>
                                        <b>Remark :
                                        </b>
                                    </td>
                                    <td colspan="3">
                                        <textarea id="prodIncv_remark" name="prodIncv_remark" class="form-control" style="width: 650px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" style="text-align: center;">
                                        <button id="prodIncv_btnsubmit" name="prodIncv_btnsubmit" class="btn btn-primary" onclick="return prodIncv_submit();">Submit</button>
                                        <button type="reset" id="prodIncv_btnreset" name="incentive_btnsubmit" class="btn btn-primary" style="display: none;" onclick="return location.reload();">Reset</button>
                                    </td>
                                </tr>
                            </table>
                            <hr />
                            <table class="table" id="table_prodIncentive" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Action</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">ID</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-prodreport" role="tabpanel" aria-labelledby="custom-tabs-one-prodreport-tab">

                            <table class="table">
                                <tr>
                                    <td><b>Month :</b></td>
                                    <td>
                                        <select id="prodreport_month" name="prodreport_month" class="form-control" style="width: 250px;">
                                            <option value="Select">Select</option>
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
                                    </td>
                                    <td><b>Year :</b></td>
                                    <td>
                                        <select id="prodreport_year" name="prodreport_year" class="form-control" style="width: 250px;"></select>
                                    </td>
                                    <td>
                                        <button type="button" id="prodreport_Show" name="prodreport_Show" class="btn btn-primary" onclick="return prodReport_btnShow();">Show</button>
                                    </td>
                                </tr>
                            </table>

                            <table class="table" id="table_prodreport" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Bank Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Account #</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">IFSC</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th colspan="8" style="text-align: right;">Total :</th>
                                        <th style="text-align: center;"></th>
                                        <th colspan="3"></th>
                                    </tr>
                                </tfoot>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="incentive_delete">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Incentive Entry</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <p><b>Are you sure you want to delete this record?</b></p>

                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="incentive_btnYes" onclick="return incentive_btndelete();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>


    <div class="modal fade" id="prodincv_delete">
        <div class="modal-dialog modal-l">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Incentive Entry</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">

                    <p>Are you sure you want to delete?</p>

                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
                    <button class="btn btn-primary" type="button" id="prodincv_btnYes" onclick="return prodincv_btndelete();">Yes</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>

    <div class="modal fade" id="incentive_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="incentive_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="incentive_btnMessage" onclick="return incentive_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
