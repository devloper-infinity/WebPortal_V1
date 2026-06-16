<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CreditConsolidatedReport.aspx.cs" Inherits="WebPortal.Admin.CreditConsolidatedReport" %>

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
            creditcons_bindyear();
        });
        function creditcons_Submit() {
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Project Inflow";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.CreateProjectInflow(month, year, creditcons_OnSuccess, creditcons_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');

            return false;
        }
        function creditcons_OnSuccess(result) {
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Project Quality";
            PageMethods.ProjectQ(month, year, creditconsPQ_OnSuccess, creditconsPQ_OnError);
            return false;
        }
        function creditcons_OnError(error) {
            alert(error.responseText);
        }
        function creditconsPQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Segment Quality";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentQ(month, year, creditconsSQ_OnSuccess, creditconsSQ_OnError);
            return false;
        }
        function creditconsPQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsSQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Reviewer Quality";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ReviewerQ(month, year, creditconsRQ_OnSuccess, creditconsRQ_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function creditconsSQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsRQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : QCer Quality";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.QualityQ(month, year, creditconsQQ_OnSuccess, creditconsQQ_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function creditconsRQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsQQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Segment wise utilisation";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentwiseUtilisation(month, year, creditconsSU_OnSuccess, creditconsSU_OnError);
            return false;
        }
        function creditconsQQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsSU_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Individual Performance";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.IndividualPerformance(month, year, creditconsIP_OnSuccess, creditconsIP_OnError);
            return false;
        }
        function creditconsSU_OnError(error) {
            alert(error.responseText);
        }
        function creditconsIP_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Performance Report";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ProductionReport(month, year, creditconsPR_OnSuccess, creditconsPR_OnError);
            return false;
        }
        function creditconsIP_OnError(error) {
            alert(error.responseText);
        }
        function creditconsPR_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Dump";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.FeedbackDump(month, year, creditconsFD_OnSuccess, creditconsFD_OnError);
            return false;
        }
        function creditconsPR_OnError(error) {
            alert(error.responseText);
        }
        function creditconsFD_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Weekly Trending Report";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.WeeklyTrendingReport(month, year, creditconsWT_OnSuccess, creditconsWT_OnError);
            return false;
        }
        function creditconsFD_OnError(error) {
            alert(error.responseText);
        }

        function creditconsWT_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Monthly Trending Report";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.MonthlyTrendingReport(month, year, creditconsMT_OnSuccess, creditconsMT_OnError);
            return false;
        }
        function creditconsWT_OnError(error) {
            alert(error.responseText);
        }

        function creditconsMT_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Error Trending - All";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ErrorTrendingAll(month, year, creditconsETA_OnSuccess, creditconsETA_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function creditconsMT_OnError(error) {
            alert(error.responseText);
        }

        function creditconsETA_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Error Trending - User";
            var ddlmonth = document.getElementById("creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ErrorTrendingUser(month, year, creditconsETU_OnSuccess, creditconsETU_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function creditconsETA_OnError(error) {
            alert(error.responseText);
        }

        function creditconsETU_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Report Prepeation Completed. Downloading Report";
            //var ddlmonth = document.getElementById("creditcons_month");
            //var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            //var ddlyear = document.getElementById("creditcons_year");
            //var year = ddlyear.options[ddlyear.selectedIndex].value;
            //PageMethods.WeeklyTrendingReport(month, year, creditconsFD_OnSuccess, creditconsFD_OnError);
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= btn1.UniqueID %>", '');
            $('#waitingpanel').modal('hide');
            return false;
        }
        function creditconsETU_OnError(error) {
            alert(error.responseText);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Credit Consolidated Report</b></h6>
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
                            <select id="creditcons_month" name="creditcons_month" class="form-control">
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
                            <select id="creditcons_year" name="creditcons_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="btnShow" class="btn btn-primary" onclick="return BindAllGrids();">Show</button>
                            &nbsp;
                            <button id="creditcons_btnexport" class="btn btn-primary" onclick="return creditcons_Submit()">Export to excel</button>
                            <%--onclick="return BindMagnaGrid();"--%>
                            <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </td>
                    </tr>
                </table>
                <hr />

                <div class="card-header p-0 pt-1">
                    <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project Inflow</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(2);" id="custom-tabs-one-projectQ-tab" data-toggle="pill" href="#custom-tabs-one-projectQ" role="tab" aria-controls="custom-tabs-one-projectQ" aria-selected="false">Project Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(3);" id="custom-tabs-one-segmentQ-tab" data-toggle="pill" href="#custom-tabs-one-segmentQ" role="tab" aria-controls="custom-tabs-one-segmentQ" aria-selected="false">Segment Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(4);" id="custom-tabs-one-reviewerQ-tab" data-toggle="pill" href="#custom-tabs-one-reviewerQ" role="tab" aria-controls="custom-tabs-one-reviewerQ" aria-selected="false">Reviewer Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(5);" id="custom-tabs-one-qualityQ-tab" data-toggle="pill" href="#custom-tabs-one-qualityQ" role="tab" aria-controls="custom-tabs-one-qualityQ" aria-selected="false">Quality Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(6);" id="custom-tabs-one-segmentwiseutilisation-tab" data-toggle="pill" href="#custom-tabs-one-segmentwiseutilisation" role="tab" aria-controls="custom-tabs-one-segmentwiseutilisation" aria-selected="false">Segment Wise Utilisation</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(7);" id="custom-tabs-one-indvperformance-tab" data-toggle="pill" href="#custom-tabs-one-indvperformance" role="tab" aria-controls="custom-tabs-one-indvperformance" aria-selected="false">Individual Performance</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(8);" id="custom-tabs-one-production-tab" data-toggle="pill" href="#custom-tabs-one-production" role="tab" aria-controls="custom-tabs-one-production" aria-selected="false">Production Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(9);" id="custom-tabs-one-feedback-tab" data-toggle="pill" href="#custom-tabs-one-feedback" role="tab" aria-controls="custom-tabs-one-feedback" aria-selected="false">Feedback Dump</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(10);" id="custom-tabs-one-weeklytrending-tab" data-toggle="pill" href="#custom-tabs-one-weeklytrending" role="tab" aria-controls="custom-tabs-one-weeklytrending" aria-selected="false">Weekly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(11);" id="custom-tabs-one-monthlytrending-tab" data-toggle="pill" href="#custom-tabs-one-monthlytrending" role="tab" aria-controls="custom-tabs-one-monthlytrending" aria-selected="false">Monthly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(12);" id="custom-tabs-one-errortrendingall-tab" data-toggle="pill" href="#custom-tabs-one-errortrendingall" role="tab" aria-controls="custom-tabs-one-errortrendingall" aria-selected="false">Error Trending - All</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Credit_OpenReport(13);" id="custom-tabs-one-errortrendinguser-tab" data-toggle="pill" href="#custom-tabs-one-errortrendinguser" role="tab" aria-controls="custom-tabs-one-errortrendinguser" aria-selected="false">Error Trending - User wise</a>
                        </li>
                       
                    </ul>
                </div>

                <div class="card-body">
                    <div class="tab-content" id="custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <table class="table table-bordered" id="project_table" style="width: 100%;"></table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-projectQ" role="tabpanel" aria-labelledby="custom-tabs-one-projectQ-tab">
                            <table class="table table-bordered" id="projectQ_table" style="width: 100%;"></table>

                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-segmentQ" role="tabpanel" aria-labelledby="custom-tabs-one-segmentQ-tab">
                            <table class="table table-bordered" id="segmentQ_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-reviewerQ" role="tabpanel" aria-labelledby="custom-tabs-one-reviewewQ-tab">
                            <table class="table table-bordered" id="ReviewerQ_table" style="width: 100%;">
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-qualityQ" role="tabpanel" aria-labelledby="custom-tabs-one-qualityQ-tab">
                            <table class="table table-bordered" id="qualityQ_table" style="width: 100%;">
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-segmentwiseutilisation" role="tabpanel" aria-labelledby="custom-tabs-one-segmentwiseutilisation-tab">
                            <table class="table table-bordered" id="segmentwiseutilisation_table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Month</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Process</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">FTE</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Total Prod</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">AVG Prod</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Target</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Capacity</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Utilisation</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-indvperformance" role="tabpanel" aria-labelledby="custom-tabs-one-indvperformance-tab">
                            <table class="table table-bordered" id="indvPerformance_table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Segment</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Stage</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Code</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Joining Date</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Name</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Pseudoname</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Tenured</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Utilisation %</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Quality %</th>
                                        <th class="sort border-top ps-3" style="text-wrap: wrap; text-align: center;">Loan Count</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-production" role="tabpanel" aria-labelledby="custom-tabs-one-production-tab">
                            <table class="table table-bordered" id="production_table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Employee</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Project</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Deal #</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Loan #</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Process</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Date</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Process Start Time</th>
                                        <th class="sort border-top" style="text-wrap: wrap; text-align: center;">Process End Time</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-feedback" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                            <table class="table table-bordered" id="feedbackDump_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-weeklytrending" role="tabpanel" aria-labelledby="custom-tabs-one-weeklytrending-tab">
                            <table class="table table-bordered" id="weeklytrending_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-monthlytrending" role="tabpanel" aria-labelledby="custom-tabs-one-monthlytrending-tab">
                            <table class="table table-bordered" id="monthlytrending_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-errortrendingall" role="tabpanel" aria-labelledby="custom-tabs-one-errortrendingall-tab">
                            <table class="table table-bordered" id="errortrendingall_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="custom-tabs-one-errortrendinguser" role="tabpanel" aria-labelledby="custom-tabs-one-errortrendinguser-tab">
                            <table class="table table-bordered" id="errortrendinguser_table" style="width: 100%;"></table>
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
