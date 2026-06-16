<%@ Page Title="" Language="C#" MasterPageFile="~/FTE/FTE.Master" AutoEventWireup="true" CodeBehind="FTEBilling.aspx.cs" Inherits="WebPortal.FTE.FTEBilling" %>

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
            /*background: linear-gradient(to bottom, #c5c5c5, 3%, #fff) !important;*/
            color: #000;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
        }
    </style>

    <script>

        $(document).ready(function () {
            BindBillingProject();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>FTE Billing</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="card card-tabs">
                    <table class="table">
                        <tr>
                            <td><b>Project:</b></td>
                            <td>
                                <select id="fte_billingProject" name="fte_billingProject" onchange="return getBillingCycle(this);" class="form-control" style="width: 250px;">
                                    <option value="Select">Select</option>
                                </select>
                            </td>
                            <td><b>Billing Cycle:</b></td>
                            <td>
                                <select id="fte_billingCycle" name="fte_billingCycle" onchange="return getBillingPeriod(this);" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                            <td><b>Billing Period:</b></td>
                            <td>
                                <select id="fte_BillingPeriod" name="fte_BillingPeriod" class="form-control" style="width: 250px;">
                                    <option value="">Select</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Remark :</b></td>
                            <td>
                                <input type="text" id="fte_billingRemark" name="fte_billingRemark" class="form-control" style="width: 250px;" />
                            </td>
                            <td></td>
                            <td>
                                <button id="btnSendToAccounts" onclick="return btnSubmitSendToAccounts();" class="btn btn-primary" style="display: inline;">Submit</button>
                            </td>
                        </tr>
                    </table>

                    <table class="table table-bordered" id="table_FTE_UserConfig" style="width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top" style="text-align: center;">Action</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Sr #</th>
                                <th class="sort border-top" style="display: none;">ProjectID</th>
                                <th class="sort border-top" style="display: none;">ProcessID</th>
                                <th class="sort border-top">Project</th>
                                <th class="sort border-top">Process</th>
                                <th class="sort border-top">Employee</th>
                                <th class="sort border-top">Pseudo Name</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Employee Status</th>
                                <th class="sort border-top">Effective Date</th>
                                <th class="sort border-top" style="text-wrap: nowrap;">Notice Period Days</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>


                </div>
            </div>
        </div>
    </div>

</asp:Content>
