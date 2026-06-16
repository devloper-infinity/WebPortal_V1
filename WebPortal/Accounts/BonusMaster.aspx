<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="BonusMaster.aspx.cs" Inherits="WebPortal.Accounts.BonusMaster" %>

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

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
    <script>
        $(document).ready(function () {
            bonusentry_bindyear();
            bonusentry_bindemployee();
            bonusentrye_bindgrid();
            bonusreport_bindyear();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Bonus Master</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Bonus Entry</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Bonus Report</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Employee:</b></td>
                                        <td>
                                            <select id="bonusentry_employee" name="bonusentry_employee" class="form-control" style="width: 250px;"></select>
                                        </td>
                                        <td><b>Month:</b></td>
                                        <td>
                                            <select id="bonusentry_month" name="bonusentry_month" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="All">All</option>
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
                                        <td>
                                            <b>Year:</b>
                                        </td>
                                        <td>
                                            <select id="bonusentry_year" name="bonusentry_year" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Amount:</b></td>
                                        <td>
                                            <input type="number" id="bonusentry_amount" name="bonusentry_amount" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Remark:</b></td>
                                        <td>
                                            <textarea id="bonusentry_remark" name="bonusentry_remark" class="form-control" style="width: 250px;"></textarea>
                                        </td>
                                        <td>
                                            <button id="bonusentry_btnShow" class="btn btn-primary" onclick="return bonusentry_addbonus();">Submit</button>

                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="bonusentry_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>                                            
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td style="width: 50px;"><b>Month:</b></td>
                                        <td style="width: 150px;">
                                            <select id="bonusreport_month" name="bonusreport_month" class="form-control">
                                                <option value="">Select</option>
                                                <option value="All">All</option>
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
                                        <td style="width: 50px;">
                                            <b>Year:</b>
                                        </td>
                                        <td style="width: 150px;">
                                            <select id="bonusreport_year" name="bonusreport_year" class="form-control">
                                                <option value="">Select</option>
                                            </select>
                                        </td>
                                        <td style="width: 100px;">
                                            <button id="bonusreport_btnShow" class="btn btn-primary" onclick="return bonusreport_bindgrid();">Show</button>

                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table table-bordered" style="width: 100%;" id="bonusreport_table">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Amount</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Silver Coin/ Chip</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">SWEET BOX Type 1</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">SWEET BOX Type 2</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">SWEET BOX Type 3</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Machine IP</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

       <div class="modal fade" id="bonusentry_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="bonusentry_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="empleave_btnMessage" onclick="location.reload();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
