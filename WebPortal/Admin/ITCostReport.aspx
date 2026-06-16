<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ITCostReport.aspx.cs" Inherits="WebPortal.Admin.ITCostReport" %>

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

        }
    </style>

    <script>
        $(document).ready(function () {

            // BindITCostReport_Grid("01-Jan-2025", "31-May-2025");
            // BindITCreditCardSummary_Grid("01-Jan-2024", "30-Apr-2025");
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>IT Cost Report</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <table class="table">
                    <tr>
                        <td style="width: 100px;"><b>From Date :</b></td>
                        <td style="width: 200px;">
                            <input type="date" class="form-control" id="ITCost_FromDate" name="ITCost_FromDate" style="width: 200px;" />
                        </td>
                        <td style="width: 100px;"><b>To Date :</b></td>
                        <td style="width: 200px;">
                            <input type="date" class="form-control" id="ITCost_ToDate" name="ITCost_ToDate" style="width: 200px;" />
                        </td>
                        <td>
                            <button class="btn btn-primary" type="button" id="ITCost_btnShow" onclick="return showITCostReport();">Show</button>
                        </td>
                    </tr>
                </table>
                <hr />

                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-ItCost-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-ItCostSummary-tab" data-toggle="pill" href="#custom-tabs-one-ItCostSummary" role="tab" aria-controls="custom-tabs-one-ItCostSummary-control" aria-selected="true"><b>Summary</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-ItCostDetail-tab" data-toggle="pill" href="#custom-tabs-one-ItCostDetail" role="tab" aria-controls="custom-tabs-one-ItCostDetail" aria-selected="false"><b>Detail</b></a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-CreditCardSummary-tab" data-toggle="pill" href="#custom-tabs-one-CreditCardSummary" role="tab" aria-controls="custom-tabs-one-CreditCardSummary" aria-selected="false"><b>Credit Card Summary</b></a>
                            </li>
                            <li class="nav-item" style="display:none;">
                                <a class="nav-link" id="custom-tabs-one-CreditCardDeviationReport-tab" data-toggle="pill" href="#custom-tabs-one-CreditCardDeviationReport" role="tab" aria-controls="custom-tabs-one-CreditCardDeviationReport" aria-selected="false"><b>Credit Card Deviation</b></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-ItCostSummary-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-ItCostSummary" role="tabpanel" aria-labelledby="custom-tabs-one-ItCostSummary-tab">
                                <table class="table" id="table_ITCostReport" style="width: 100%;">
                                    <thead>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div class="tab-pane fade show fade" id="custom-tabs-one-ItCostDetail" role="tabpanel" aria-labelledby="custom-tabs-one-ItCostDetail-tab">
                                <table class="table" id="table_ITCostReportDetail" style="width: 100%;">
                                    <thead>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div class="tab-pane fade show fade" id="custom-tabs-one-CreditCardSummary" role="tabpanel" aria-labelledby="custom-tabs-one-CreditCardSummary-tab">
                                <table class="table" id="table_CreditCardSummaryReport" style="width: 100%;">
                                    <thead>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show fade" id="custom-tabs-one-CreditCardDeviationReport" role="tabpanel" aria-labelledby="custom-tabs-one-CreditCardDeviationReport-tab">
                                <table class="table" id="table_CreditCardDeviation" style="width: 100%;">
                                    <thead></thead>
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
