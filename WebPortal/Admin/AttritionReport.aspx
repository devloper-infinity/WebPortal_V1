<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AttritionReport.aspx.cs" Inherits="WebPortal.Admin.AttritionReport" %>

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

        .dataTables_scrollBody {
            min-height: 20px !important;
            height: auto !important;
        }

        .btn-gradient-primary {
            /*  background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 7px;
            width: 100%;
            height: 35px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

        .btn-gradient-success {
            background: linear-gradient(135deg, #1cc88a, #13855c);
            color: #fff;
            border-radius: 7px;
            height: 35px;
            width: 100%;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-success:hover {
                transform: translateY(-2px);
                color: #fff;
            }
    </style>

    <script>
        $(document).ready(function () {
            // AttritionDetails("26-Jun-2025", "25-Jul-2025", 0);
            attrition_binddomains();
            BindYear_Attrition();
        });

        function attrition_Exporttoexcel() {
            __doPostBack("<%= btn21.UniqueID %>", '');
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn21" runat="server" Style="display: none;" OnClick="btn1_Click" />
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Attrition Report</b></h6>
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
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="attrition_from" name="attrition_from" class="form-control" style="width: 170px;" />
                            <select id="attrition_month" name="attrition_month" class="form-control" style="display: none;">
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
                        <td>
                            <b>To Date:</b>
                        </td>
                        <td>
                            <input type="date" id="attrition_to" name="attrition_to" class="form-control" style="width: 170px;" />
                            <select id="attrition_year" name="attrition_year" class="form-control" style="display: none;">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td><b>Domain:</b></td>
                        <td>
                            <select id="attrition_domain" name="attrition_domain" class="form-control" style="width: 170px;"></select>
                        </td>
                        <%-- </tr>
                    <tr>--%>
                        <%-- <td colspan="6" style="text-align: center;">--%>
                        <td>
                            <button id="attrition_btnShow" class="btn btn-gradient-primary w-100" onclick="return attrition_Submit()">Show</button>
                        </td>
                        <td>
                            <button id="attrition_btnExporttoexcel" class="btn btn-gradient-success flex-grow-1" style="background: linear-gradient(to right, #ffbf96, #fe7096);" onclick="return attrition_Exporttoexcel();">Export to excel</button>

                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="return bindexcludedemployees();" id="custom-tabs-one-exclude-tab" data-toggle="pill" href="#custom-tabs-one-exclude" role="tab" aria-controls="custom-tabs-one-exclude" aria-selected="false">Excluded Employees</a>
                            </li>

                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <div class="col-lg-12">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Month wise Summary</h5>
                                            <table class="table" id="attrition_monthsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
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
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Branch</th>
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
                                            <h5 class="card-title">Category wise Summary</h5>
                                            <table class="table" id="attrition_categorysummary" style="padding-top: 10px; width: 100%;">
                                                <thead style="text-align: center;">
                                                    <tr></tr>
                                                </thead>
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
                                        </div>
                                        <div class="col-lg-12">
                                            <h5 class="card-title">Location Head wise Summary</h5>
                                            <table class="table" id="attrition_locationheadsummary" style="padding-top: 10px; width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Location Head</th>
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
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table" id="attritiontable" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Actions</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pseudo Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Location Head</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: left;">PM/ System Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Attrition Cost</th>
                                        </tr>

                                    </thead>
                                    <tbody></tbody>

                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-exclude" role="tabpanel" aria-labelledby="custom-tabs-one-exclude-tab">
                                <table class="table" id="excludetable" style="padding-top: 10px; width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Employee Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Pseudoname</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Joining Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Branch</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Department</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Designation</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reporting Manager</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Tenure</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Current Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Resignation Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Last Working Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">PM/ System Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Domain Head Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Reason to exclude</th>
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

    <div class="modal fade" id="attexclude">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Exclude Employee From Report</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive">
                        <tr>
                            <td><b>Employee:</b></td>
                            <td>
                                <label id="attpop_empname" name="attpop_empname" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Joining Date:</b></td>
                            <td>
                                <label id="attpop_doj" name="attpop_doj" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Reporting Manager</b></td>
                            <td>
                                <label id="attpop_reportingmanager" name="attpop_reportingmanager" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Resignation Type:</b></td>
                            <td>
                                <label id="attpop_resignationtype" name="attpop_resignationtype" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Resignation Date:</b></td>
                            <td>
                                <label id="attpop_resignationdate" name="attpop_resignationdate" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Last Working Date:</b></td>
                            <td>
                                <label id="attpop_lastworkingdate" name="attpop_lastworkingdate" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Step 1 Remark:</b></td>
                            <td>
                                <label id="attpop_step1remark" name="attpop_step1remark" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Step 2 Remark:</b></td>
                            <td>
                                <label id="attpop_step2remark" name="attpop_step2remark" class="form-control" style="width: 300px;"></label>
                            </td>
                        </tr>
                        <tr>
                            <td><b>Step 3 Remark:</b></td>
                            <td>
                                <label id="attpop_step3remark" name="attpop_step3remark" class="form-control" style="width: 300px;"></label>
                            </td>
                            <td><b>Reason to exclude:</b></td>
                            <td>
                                <textarea id="attpop_reasontoexclude" name="attpop_reasontoexclude" class="form-control" style="width: 300px;" maxlength="500"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer justify-content-between">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-primary" type="button" id="attpop_btnexclude" onclick="attpop_Addexcluderemark();">Update</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
