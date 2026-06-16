<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceReport.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceReport" %>

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

            if (currentUserName == 285) {
                document.getElementById("marketingPer").style.display = '';
            }
            else {
                document.getElementById("marketingPer").style.display = 'none';
            }
            //upr_BindUsers();
        });

        function upr_export() {
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Summary";
            var fromdate = document.getElementById("upr_fromdate").value;
            var todate = document.getElementById("upr_todate").value;
            PageMethods.OverallSummary(fromdate, todate, uper_OnSuccess, uper_OnError);
            return false;
        }

        function uper_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Production Details";
            var fromdate = document.getElementById("upr_fromdate").value;
            var todate = document.getElementById("upr_todate").value;
            PageMethods.ProductionDetails(fromdate, todate, uper1_OnSuccess, uper1_OnError);
            return false;
        }
        function uper1_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Details";
            var fromdate = document.getElementById("upr_fromdate").value;
            var todate = document.getElementById("upr_todate").value;
            PageMethods.FeedbackDetails(fromdate, todate, uper2_OnSuccess, uper2_OnError);
            return false;
        }
        function uper2_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Attendance Details";
            var fromdate = document.getElementById("upr_fromdate").value;
            var todate = document.getElementById("upr_todate").value;
            PageMethods.AttendanceDetails(fromdate, todate,  uper3_OnSuccess, uper3_OnError);
            return false;
        }

        //function uper31_OnSuccess(result) {
        //    document.getElementById("spntext").innerHTML = "Generating excel sheet : Other Task";
        //    var fromdate = document.getElementById("upr_fromdate").value;
        //    var todate = document.getElementById("upr_todate").value;
        //    PageMethods.ProductionOtherTask(fromdate, todate, uper3_OnSuccess, uper3_OnError);
        //    return false;
        //}


        function uper3_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Downloading Report. . .";
            var fromdate = document.getElementById("upr_fromdate").value;
            var todate = document.getElementById("upr_todate").value;
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }


        function uper3_OnError(error) {
            alert(error.responseText);
        }
        function uper2_OnError(error) {
            alert(error.responseText);
        }
        function uper1_OnError(error) {
            alert(error.responseText);
        }
        function uper_OnError(error) {
            alert(error.responseText);
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
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
                <div class="col-sm-6" style="text-align: right; font-size: 14px;" id="marketingPer">
                    <%--<h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Performance Report Marketing</b></h6>--%>
                    <a href="UserPerformanceReportMarketing.aspx"><b>User Performance Report Marketing</b></a>
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
                            <input type="date" id="upr_fromdate" name="upr_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="upr_todate" name="upr_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="upr_btnsubmit" name="upr_btnsubmit" onclick="return upr_submit();" class="btn btn-primary">Submit</button>
                            <button id="upr_btnexport" name="upr_btnsubmit" onclick="return upr_export();" class="btn btn-primary">Export to excel</button>
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
                                <a class="nav-link" onclick="upr_getProdDetails();" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Production Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="upr_getFeedbackDetails();" id="custom-tabs-one-feedback-tab" data-toggle="pill" href="#custom-tabs-one-feedback" role="tab" aria-controls="custom-tabs-one-feedback" aria-selected="false">Feedback Details</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" onclick="upr_getAttendanceDetails();" id="custom-tabs-one-attendance-tab" data-toggle="pill" href="#custom-tabs-one-attendance" role="tab" aria-controls="custom-tabs-one-attendance" aria-selected="false">Attendance Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" id="upr_table" style="width: 100%;">
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
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table table-bordered" id="upr_tableprod" style="width: 100%;">
                                </table>
                            </div>
                            <div class="tab-pane fade show" id="custom-tabs-one-feedback" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                                <table class="table table-bordered" id="upr_feedbacktable" style="width: 100%;">
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
                            <div class="tab-pane fade show" id="custom-tabs-one-attendance" role="tabpanel" aria-labelledby="custom-tabs-one-attendance-tab">
                                <table class="table table-bordered" id="upr_attendancetable" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total Days
                                                <br />
                                                (Calender Days)</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Absent Days
                                                <br />
                                                (Full Days)</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Partial Days</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Partial days
                                                <br />
                                                (equivalent full days)</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total Absents
                                                <br />
                                                (Full day + Partial Days)</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Present Days
                                                <br />
                                                (as per Final Salary Calculation)</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance % on Total Days</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Latemarks</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Latemarks Removed</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Total Latemarks</th>
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

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
