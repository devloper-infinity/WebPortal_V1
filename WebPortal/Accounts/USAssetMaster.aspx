<%@ Page Title="" Language="C#" MasterPageFile="~/Accounts/Accounts.Master" AutoEventWireup="true" CodeBehind="USAssetMaster.aspx.cs" Inherits="WebPortal.Accounts.USAssetMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
            Bind_Users();
            BindAsset_Grid();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>US Assets Master</b></h6>
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
                        <td>
                            <b>User :
                            </b>
                        </td>
                        <td>
                            <select id="usassets_user" name="usassets_user" class="form-control" style="width: 300px;">
                            </select>
                        </td>
                        <td>
                            <b>Brand :
                            </b>
                        </td>
                        <td>
                            <input type="text" id="usassets_brand" name="usassets_brand" class="form-control" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <b>Serial # :
                            </b>
                        </td>
                        <td>
                            <input type="text" id="usassets_serialNo" name="usassets_serialNo" class="form-control" style="width: 300px;" />
                        </td>
                        <td>
                            <b>Status :
                            </b>
                        </td>
                        <td>
                            <select id="usassets_status" name="usassets_status" class="form-control" style="width: 300px;">
                                <option value="Select">Select</option>
                                <option value="Issued">Issued</option>
                                <option value="Instock">Instock</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Issue Date :</b>
                        </td>
                        <td>
                            <input type="date" id="usassets_issueDate" name="usassets_issueDate" class="form-control" style="width: 300px;" />
                        </td>
                        <td>
                            <b>Remark :</b>
                        </td>
                        <td>
                            <textarea name="usassets_remark" id="usassets_remark" class="form-control" style="width: 300px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: center;">
                            <button id="usassets_btnsubmit" name="usassets_btnsubmit" class="btn btn-primary" onclick="return usassets_submit();">Submit</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_usassets" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sr. #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">User</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Brand</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Serial #</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Issue Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added On</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>


    <div class="modal fade" id="usassets_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="usassets_errmsg"></h6>
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
