<%@ Page Title="" Language="C#" MasterPageFile="~/Search/Search.Master" AutoEventWireup="true" CodeBehind="ProcessOrders.aspx.cs" Inherits="WebPortal.Search.ProcessOrders" %>

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
    </style>

    <script>
        $(document).ready(function () {

            BindGrid_PendingOrders();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Process Orders</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div style="width: 100%; overflow: auto;">
                    <table class="table" id="invrec_SearchProcess" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Actions</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">OrderId</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Project Number</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Client Order No</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">OnOffLine</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Order Date</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Product Type</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Process</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Assigned Date</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="OrderCosting">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Order Costing :</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive">
                        <tr>
                            <td><b>Search Engine Type :</b></td>
                            <td>
                                <select id="ProcessOrders_SearchEType" name="ProcessOrders_SearchEType" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="Paid">Paid</option>
                                    <option value="Free">Free</option>
                                </select>
                            </td>
                            <td><b>Search Engine Link :</b></td>
                            <td>
                                <input type="text" id="ProcessOrders_SearchEnginelink" name="ProcessOrders_SearchEnginelink" class="form-control" style="width: 250px;" />
                            </td>
                            <%--  </tr>

                        <tr>--%>
                            <td><b>Search Cost</b></td>
                            <td>
                                <select id="ProcessOrders_Search Cost" name="ProcessOrders_Search Cost" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="NoOfSearchesMade">"No Of Searches Made"</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="text" id="ProcessOrders_txtNoOfSearchesMade" name="ProcessOrders_txtNoOfSearchesMade" class="form-control" style="width: 100px;" />
                            </td>
                            <td><b>Cost/Search :</b></td>
                            <td>
                                <input type="text" id="ProcessOrders_txtCostSearches" name="ProcessOrders_txtCostSearches" class="form-control" style="width: 100px;" />
                            </td>
                            <td><b>Total:</b></td>
                            <td>
                                <input type="text" id="ProcessOrders_Total" name="ProcessOrders_Total" class="form-control" style="width: 100px;" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnStep51" onclick="return OrderCosting();">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="CompleteOrder">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Complete Process :</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive">
                        <tr>
                            <td>
                                <label id="lblcompany" name="lblcompany" style="display: inline-block; font-size: 12px; font-weight: bold;"></label>
                            </td>

                            <td>
                                <label id="lblInvoiceType" name="lblInvoiceType" style="display: inline-block; font-size: 12px; font-weight: bold;"></label>
                            </td>

                            <%--<td>
                                <label id="lblInvoiceNo" name="lblInvoiceNo" class="form-control" style="display: inline;" padding: 5px 10px; font-size: 12px; font-weight: 250;" font-weight: bold;></label>
                            </td>--%>

                            <td>
                                <label id="lblInvoiceNo" name="lblInvoiceNo" style="display: inline-block; font-size: 12px; font-weight: bold;"></label>

                            </td>
                            <td>
                                <label id="lblInvoiceDate" name="lblInvoiceDate" style="display: inline-block; font-size: 12px; font-weight: bold;"></label>
                            </td>
                            <td>
                                <label id="lblInvoiceAmout" name="lblInvoiceAmout" class="form-control" style="display: inline-block; font-size: 12px; font-weight: bold;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Status :</b></td>
                            <td colspan="3">
                                <select id="Approval_Status" name="Approval_Status" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                    <option value="SPQA">SPQA</option>
                                    <option value="Hold">Hold</option>
                                    <option value="DispatchOrder">Dispatch Order</option>
                                    <option value="NoFeedback">No Feedback</option>

                                </select>
                            </td>
                        </tr>

                        <tr>

                            <td><b>Attachment:</b></td>
                            <td>
                                <input type="file" id="dashboard_attachment_upload" class="form-control" style="width: 250px;" />
                            </td>
                            <td></td>
                            <td></td>

                        </tr>

                        <tr>
                            <td><b>Remark : </b></td>
                            <td colspan="4">
                                <textarea id="Approval_remark" name="Approval_remark" class="form-control"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="btnStep5" onclick="return CompleteOrder();">Submit</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
    </div>

</asp:Content>
