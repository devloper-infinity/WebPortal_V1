<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ExcelBillingReport.aspx.cs" Inherits="WebPortal.Admin.ExcelBillingReport" %>

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
    </style>

    <script>

        $(document).ready(function () {

            BindDomainWise_ExcelProject(9);
            //Excel_bindDeals();
            //excelBilling_BindDetails();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Excel Billing Report</b></h6>
                </div>
                <div class="col-sm-6" style="text-align: right;">
                    <a href="OtherBilling.aspx" class="m-0" style="font-size: 13px; text-decoration: underline; float: right; margin-right: 100px; font-weight: bold;"><< Import Billing Excel</a>
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
                        <td><b>Project Type:</b></td>
                        <td>
                            <select id="excelBilling_ProjectType" name="excelBilling_ProjectType" class="form-control" style="width: 250px;">
                                <option value="Select">Select</option>
                                <option value="Rebuttal">Condition Clearing</option>
                                <option value="Research">Research</option>
                            </select>
                        </td>
                        <td><b>Project :</b></td>
                        <td>
                            <select id="excelBilling_Project" name="excelBilling_Project" class="form-control" style="width: 250px;" onchange="return Excel_bindDeals(this);">
                                <%-- <option value="Select">Select</option>--%>
                            </select>
                        </td>
                        <td><b>Deal #:</b></td>
                        <td>
                            <select id="excelBilling_DealNo" name="excelBilling_DealNo" class="form-control" style="width: 250px;"></select>
                        </td>
                        <td>
                            <button type="button" id="excelBilling_Submit" name="excelBilling_Submit" class="btn btn-primary" onclick="return btnexcelBilling_Submit();">Show</button>
                        </td>
                    </tr>
                    <tr>
                    </tr>
                </table>
                <hr />
                <table class="table" id="table_excelRebuttal" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Loan #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Condition</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Clients Rebuttal</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Cleared (Yes/No)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">End Date/Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Total Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Infinity Response</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Billing Type</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>


                <table class="table" id="table_excelResearch" style="display: none;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="width: 50px;">Sr. #</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Deal #</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Deal Name</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Subject Line</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Requested Docs/Tasks Performed</th>
                            <th class="sort border-top ps-3" style="width: 100px;">No of Loans/Docs</th>
                            <th class="sort border-top ps-3" style="width: 100px;">Total Time Taken (in Minutes)</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received from</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Request Received Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Documents Delivered Date</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Remark</th>
                            <th class="sort border-top ps-3" style="width: 150px;">Time (In Hours)</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td style="font-weight: bold; font-size: 13px;"></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>


</asp:Content>
