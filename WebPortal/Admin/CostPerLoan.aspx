<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CostPerLoan.aspx.cs" Inherits="WebPortal.Admin.CostPerLoan" %>

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
            cploan_bindyear();
        });

        function cploan_export() {
            $('#waitingpanel').modal('show');
            var ddlmonth = document.getElementById("cploan_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("cploan_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            var ddldomain = document.getElementById("cploan_domain");
            var domain = ddldomain.options[ddldomain.selectedIndex].value;
            PageMethods.GetCostperLoanReportExport(month, year, domain, cp_loan_excel_OnSuccess, cp_loan_excel_OnError);
            return false;
        }

        function cp_loan_excel_OnSuccess(result) {
            document.getElementById("<%= btn1_excel.ClientID %>").click();
            $('#waitingpanel').modal('hide');
            return false;
        }

        function cp_loan_excel_OnError(error) {
            alert(error.get_message());
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Cost Per Loan</b></h6>
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
                        <td style="width: 50px;"><b>Month:</b></td>
                        <td style="width: 150px;">
                            <select id="cploan_month" name="cploan_month" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
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
                            <select id="cploan_year" name="cploan_year" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="cploan_domain" name="cploan_domain" class="form-control" style="width: 250px;">
                                <option value="">Select</option>
                                <option value="Credit">Credit</option>
                                <option value="Servicing">Servicing</option>
                            </select>
                        </td>
                        <td>
                            <button id="cploan_btnShow" class="btn btn-primary" onclick="return cploan_bindallgrids();">Show</button>&nbsp;
                                            <button id="cploan_btnExport" class="btn btn-primary" onclick="return cploan_export();">Export to excel</button>
                            <asp:Button ID="btn1_excel" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </td>
                    </tr>
                </table>
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab-IM" data-toggle="pill" href="#custom-tabs-one-home-IM" role="tab" aria-controls="custom-tabs-one-home-IM" aria-selected="true">Summary Report</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return cploan_bindprodgrid();" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Actual Production</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-IM" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab-IM">
                                <table class="table table-bordered" style="width: 100%;" id="cploan_table"></table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" style="width: 100%;" id="cploan_prodtable"></table>
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
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is generating excel. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
