<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceReport.aspx.cs" Inherits="WebPortal.US.UserPerformanceReport" %>

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
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>

    <link href="../dist/multi/chosen.css" rel="stylesheet" />
    <link href="../dist/multi/chosen.min.css" rel="stylesheet" />
    <script src="../dist/multi/chosen.jquery.min.js"></script>
    <script src="../dist/multi/chosen.proto.min.js"></script>
    <script>

        $(document).ready(function () {

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            //if (currentUserName == 285) {
            //    document.getElementById("marketingPer").style.display = '';
            //}
            //else {
            //    document.getElementById("marketingPer").style.display = 'none';
            //}
            //us_BindUsers();
        });

        function us_export() {

            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Credit Summary";
            var fromdate = document.getElementById("us_fromdate").value;
            var todate = document.getElementById("us_todate").value;

            PageMethods.Credit_Summary(fromdate, todate, CredSumm_OnSuccess, CredSumm_OnError);
            return false;
        }


        function CredSumm_OnSuccess(result) {

            document.getElementById("spntext").innerHTML = "Generating excel sheet : Servicing Summary";
            var fromdate = document.getElementById("us_fromdate").value;
            var todate = document.getElementById("us_todate").value;

            PageMethods.Servicing_Summary(fromdate, todate, ServSumm_OnSuccess, ServSumm_OnError);
            return false;
        }

        function ServSumm_OnSuccess(result) {

            document.getElementById("spntext").innerHTML = "Generating excel sheet : Credit Production Details";
            var fromdate = document.getElementById("us_fromdate").value;
            var todate = document.getElementById("us_todate").value;

            PageMethods.Credit_ProductionDetails(fromdate, todate, CredProd_OnSuccess, CredProd_OnError);
            return false;
        }

        function CredProd_OnSuccess(result) {

            document.getElementById("spntext").innerHTML = "Generating excel sheet : Servicing Production Details";
            var fromdate = document.getElementById("us_fromdate").value;
            var todate = document.getElementById("us_todate").value;

            PageMethods.Servicing_ProductionDetails(fromdate, todate, ServProd_OnSuccess, ServProd_OnError);
            return false;
        }

        function ServProd_OnSuccess(result) {

            document.getElementById("spntext").innerHTML = "Downloading Report. . .";
            $('#waitingpanel').modal('hide');

            __doPostBack("<%= btnUSdetails.UniqueID %>", '');
            return false;
        }

        function CredSumm_OnError(error) {
            alert(error.responseText);
        }

        function ServSumm_OnError(error) {
            alert(error.responseText);
        }

        function CredProd_OnError(error) {
            alert(error.responseText);
        }

        function ServProd_OnError(error) {
            alert(error.responseText);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Button ID="btnUSdetails" runat="server" Style="display: none;" OnClick="btnUWDetails_Click"/>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Performance Report</b></h6>
                </div>
              <%--  <div class="col-sm-6" style="text-align: right; font-size: 14px;" id="marketingPer">
                    <a href="UserPerformanceReportMarketing.aspx"><b>User Performance Report Marketing</b></a>
                </div>--%>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table class="table">
                    <tr>
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="us_fromdate" name="us_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="us_todate" name="us_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="us_btnsubmit" name="us_btnsubmit" onclick="return us_bindCreditSummary();" class="btn btn-primary">Show</button>
                            <button id="us_btnexport" name="us_btnsubmit" onclick="return us_export();" class="btn btn-primary">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1" style="font-weight:bold;">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Credit Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="us_bindServicingSummary();" id="custom-tabs-one-ServSummary-tab" data-toggle="pill" href="#custom-tabs-one-ServSummary" role="tab" aria-controls="custom-tabs-one-ServSummary" aria-selected="false">Servicing Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="us_bindCreditProdDetails();" id="custom-tabs-one-CredProd-tab" data-toggle="pill" href="#custom-tabs-one-CredProd" role="tab" aria-controls="custom-tabs-one-CredProd" aria-selected="false">Credit Production Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="us_bindServicingProdDetails();" id="custom-tabs-one-ServProd-tab" data-toggle="pill" href="#custom-tabs-one-ServProd" role="tab" aria-controls="custom-tabs-one-ServProd" aria-selected="false">Servicing Production Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" id="table_CredSummary" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pseudoname</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Count</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance Grade</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-ServSummary" role="tabpanel" aria-labelledby="custom-tabs-one-ServSummary-tab">
                                <table class="table table-bordered" id="table_ServSummary" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pseudoname</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Count</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance Grade</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <div class="tab-pane fade show" id="custom-tabs-one-CredProd" role="tabpanel" aria-labelledby="custom-tabs-one-CredProd-tab">
                                <table class="table table-bordered" id="table_CredProduction" style="width: 100%;"></table>
                            </div>
                            <div class="tab-pane fade show" id="custom-tabs-one-ServProd" role="tabpanel" aria-labelledby="custom-tabs-one-ServProd-tab">
                                <table class="table table-bordered" id="table_ServProduction" style="width: 100%;"></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
