<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="CreditCardMaster.aspx.cs" Inherits="WebPortal.Accounts.CreditCardMaster" %>

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

        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            cardmaster_bindfrom();
            cardmaster_bindto();
            cardmaster_bindgrid();
            cardheader_bindgrid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Card Master</b></h6>
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
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Credit Card Master</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Credit Card Headers</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">

                                <table class="table">
                                    <tr>
                                        <td><b>Card Name:</b></td>
                                        <td>
                                            <input type="text" id="cardmaster_cardname" name="cardmaster_cardname" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Card # (Last 4 digit):</b></td>
                                        <td>
                                            <input type="text" id="cardmaster_cardno" name="cardmaster_cardno" class="form-control" style="width: 250px;" />
                                        </td>
                                        <td><b>Status:</b></td>
                                        <td>
                                            <select id="cardmaster_cardstatus" name="cardmaster_cardstatus" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                                <option value="Not In Use">Not In Use</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Billing Cycle (From):</b></td>
                                        <td>
                                            <select type="date" id="cardmaster_from" name="cardmaster_from" class="form-control" style="width: 250px;"></select></td>
                                        <td><b>Billing Cycle (To):</b></td>
                                        <td>
                                            <select type="date" id="cardmaster_to" name="cardmaster_to" class="form-control" style="width: 250px;"></select></td>
                                        <td><b>Description:</b></td>
                                        <td>
                                            <textarea id="cardmaster_description" name="cardmaster_description" class="form-control" style="width: 250px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">
                                            <button id="cardmaster_btnsubmit" class="btn btn-primary" onclick="return cardmaster_submit();">Submit</button>
                                            <button id="cardmaster_btnreset" class="btn btn-secondary" onclick="location.reload();" style="display: none;">Reset</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="cardmaster_mastergrid" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Card Name</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Card Number</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Status</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Billing Cycle (From)</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Billing Cycle (To)</th>
                                            <th class="sort border-top" style="text-wrap: wrap;">Description</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added Date</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center; display: none;">Master ID</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table">
                                    <tr>
                                        <td><b>Header:</b></td>
                                        <td>
                                            <input type="text" id="cardheader_header" name="cardheader_header" class="form-control" style="width: 300px;" />
                                        </td>
                                        <td><b>Status:</b></td>
                                        <td>
                                            <select id="cardheader_cardstatus" name="cardheader_cardstatus" class="form-control" style="width: 250px;">
                                                <option value="">Select</option>
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                                <option value="Not In Use">Not In Use</option>
                                            </select>
                                        </td>
                                        <td><b>Description:</b></td>
                                        <td>
                                            <textarea id="cardheader_description" name="cardheader_description" class="form-control" style="width: 250px;"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">
                                            <button id="cardheader_btnsubmit" class="btn btn-primary" onclick="return cardheader_submit();">Submit</button>
                                            <button id="cardheader_btnreset" class="btn btn-secondary" onclick="location.reload();" style="display: none;">Reset</button>
                                        </td>
                                    </tr>
                                </table>
                                <hr />
                                <table class="table" id="cardheader_mastergrid" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top" style="text-wrap: nowrap;">Edit</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Header</th>
                                            <th class="sort border-top" style="text-wrap: nowrap; text-align: center;">Status</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Description</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added By</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Added Date</th>
                                            <th class="sort border-top" style="text-wrap: wrap; text-align: center; display: none;">Master ID</th>
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
</asp:Content>
