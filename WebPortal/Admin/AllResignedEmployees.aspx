<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AllResignedEmployees.aspx.cs" Inherits="WebPortal.Admin.AllResignedEmployees" %>

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
            allresigned_BindYear();
        });

        function allresigned_Exporttoexcel() {
            __doPostBack("<%= btn31.UniqueID %>", '');
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn31" runat="server" Style="display: none;" OnClick="btn31_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>All Resigned Employees</b></h6>
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
                        <td style="width: 50px;"><b>From Date:</b></td>
                        <td style="width: 150px;">
                            <input type="date" id="allresigned_from" name="allresigned_from" class="form-control" />
                            <select id="allresigned_month" name="allresigned_month" class="form-control" style="display: none;">
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
                            <b>To Date:</b>
                        </td>
                        <td style="width: 150px;">
                            <input type="date" id="allresigned_to" name="allresigned_to" class="form-control" />
                            <select id="allresigned_year" name="allresigned_year" class="form-control" style="display: none;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="allresigned_btnShow" class="btn btn-primary" onclick="return allresigned_Submit()">Show</button>
                            <button id="allresigned_btnExporttoexcel" class="btn btn-secondary" onclick="return allresigned_Exporttoexcel();">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home-summary" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile-detail" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home-summary" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table" id="table_resignedSummary" style="width: 100%;"></table>
                                <div class="col-lg-12">
                                    <div class="row">

                                        <%--  <div class="col-lg-12">
                                            <h5 class="card-title">Month wise Summary</h5>
                                            <table class="table" id="attrition_monthsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Location wise Summary</h5>
                                            <table class="table" id="attrition_locationsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain wise Summary</h5>
                                            <table class="table" id="attrition_domainsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Domain Head wise Summary</h5>
                                            <table class="table" id="attrition_domainheadsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain Head</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Opening Count</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">New Joiners</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Exit Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remaining Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Excluded Employees</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition %</th>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attrition Cost</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                            <hr />
                                        </div>--%>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-one-profile-detail" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="allresigned_table" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Birth Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Latest Login Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Type</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 1 Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 2 Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Step 3 Remark</th>
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
