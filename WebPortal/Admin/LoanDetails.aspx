<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LoanDetails.aspx.cs" Inherits="WebPortal.Admin.LoanDetails" %>

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

    <script>

        $(document).ready(function () {

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Tracking Sheet</b></h6>
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
                        <td><b>From Date:</b></td>
                        <td>
                            <input type="date" id="trckloan_fromdate" name="trckloan_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="trckloan_todate" name="trckloan_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="trckloan_btnsubmit" name="trckloan_btnsubmit" onclick="return GetLoanAndProcesssummary();" class="btn btn-primary">Submit</button>
                            <button id="trckloan_btnexport" name="trckloan_btnsubmit" onclick="return trckloan_export();" class="btn btn-primary">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project Summary</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="GetLoanAndProcessDetails();" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Loan Details</a>
                            </li>
                            <li class="nav-item" style="display:none;">
                                <a class="nav-link" onclick="loandetails_getFeedbackDetails();" id="custom-tabs-one-feedback-tab" data-toggle="pill" href="#custom-tabs-one-feedback" role="tab" aria-controls="custom-tabs-one-feedback" aria-selected="false">Feedback Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" id="trckloan_summarytable" style="width: 100%;">
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table table-bordered" id="trckloan_tableprod" style="width: 100%;">
                                </table>
                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-feedback" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab" style="display:none;">
                                <table class="table table-bordered" id="trckloan_feedbacktable" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Project #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Deal #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Loan #</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Order Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Process</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Error Done By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Feedback Given By</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Error Type</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Severity</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Error Field</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Sub Category</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Error</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Should Be</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Feedback Type</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Feedback Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Explaination</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">PM Status</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">PM Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added Date</th>
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
