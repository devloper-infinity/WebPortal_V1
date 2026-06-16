<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Securitization561.aspx.cs" Inherits="WebPortal.Admin.Securitization561" %>

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
    <script>
        $(document).ready(function () {
            sectrack561_BindDeals();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Securitization Billing</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table">
                    <tr>
                        <td><b>Deal #:</b></td>
                        <td>
                            <select id="sec561_dealno" name="sec561_dealno" class="form-control" style="width: 250px;" onchange="return sec561_Getdealdetails(this)"></select>
                        </td>
                        <td><b>Type:</b></td>
                        <td>
                            <select id="sec561_type" name="sec561_type" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="PH">PH</option>
                                <option value="CCs">CCs</option>
                                <option value="ASF Data Update">ASF Data Update</option>
                                <option value="TPOL Pull">TPOL Pull</option>
                                <option value="Data Team">Data Team</option>
                                <option value="Mike/Leads (reporting)">Mike/Leads (reporting)</option>
                                <option value="Reliance Letter">Reliance Letter</option>
                            </select>
                        </td>
                        <td>
                            <input type="text" id="sec561_loancount" name="sec561_loancount" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="sec561_btnsubmit" name="sec561_btnsubmit" class="btn btn-primary" onclick="return sec561_submit();">Add</button>
                        </td>
                    </tr>
                </table>
                <hr />

                <table class="table" id="sec561_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">BillingID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; display: none;">ProjectID</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loans</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Hours</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>

                <hr />
                <div style="width: 100%; text-align: center;">
                    <button id="sec561_btnBilling" name="sec561_btnBilling" class="btn btn-secondary" style="text-align: center; vertical-align: top;" onclick="sec561_sendBilling();">Send To Accounts</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="sec561_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="sec561_errmsg"></h6>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="sec561_btnMessage" onclick="sec561_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
