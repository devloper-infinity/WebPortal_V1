<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreditCardReconiliation.aspx.cs" Inherits="WebPortal.Admin.CreditCardReconiliation" %>

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
        #invtable_summary_wrapper {
            height:160px!important;
        }
    </style>
    <script>
        $(document).ready(function () {
            BindYear_INV_Rec();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Card Reconciliation</b></h6>
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
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="inv_month_rec" name="inv_month_rec" class="form-control">
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
                            <select id="inv_year_rec" name="inv_year_rec" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return BindInvoiceGrid_Rec();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <h6> Summary  </h6>
                <table class="table" id="invtable_summary" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align:center;">Credit Card</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align:center;">Contractual Cost</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align:center;" id="summonth">Invoice Generated</th>
                            <th class="sort border-top" style="text-wrap: nowrap; text-align:center;">Difference</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
                <hr />
                <h6>  Details  </h6>
                <table class="table" id="invtable_rec" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">HeaderID</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Details</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display: none;">SubHeader</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Header</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Product</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Subscription</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Cost Type</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align:center;">Contractual Quantity</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align:center;">Contractual Per Unit Cost</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align:center;">Chargeable Amount</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Current Quantity</th>
                            <th class="sort border-top" style="text-wrap: wrap; text-align:center;">Amount Charged</th>
                            <th class="sort border-top" style="text-wrap: wrap;">Difference</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Invoice #</th>
                            <th class="sort border-top" style="text-wrap: nowrap; display:none;">Invoice Attachment</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">Utilization</th>
                            <th class="sort border-top" style="text-wrap: nowrap;">CC #</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="inv_detailspop">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Details</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive" id="inv_details" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr. #</th>
                                <th class="sort border-top" style="text-wrap: nowrap;" id="inv_headername">Number</th>
                                <th class="sort border-top" style="text-wrap: nowrap;" id="inv_headercost">Cost</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Code</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Pseudoname</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Branch</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Domain</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Current Status</th>
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
