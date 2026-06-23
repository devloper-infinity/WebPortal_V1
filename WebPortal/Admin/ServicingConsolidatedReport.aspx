<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ServicingConsolidatedReport.aspx.cs" Inherits="WebPortal.Admin.ServicingConsolidatedReport" %>

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
    <link rel="stylesheet" href="ModernReportSecuritization.css" />
    <script>
        $(document).ready(function () {
            servcons_bindyear();
        });
        function servcons_Submit() {
            $('#waitingpanel').modal('show');
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Project Inflow";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.CreateProjectInflow(month, year, servcons_OnSuccess, servcons_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');

            return false;
        }
        function servcons_OnSuccess(result) {
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Project Quality";
            PageMethods.ProjectQ(month, year, servconsPQ_OnSuccess, servconsPQ_OnError);
            return false;
        }
        function servcons_OnError(error) {
            alert(error.responseText);
        }
        function servconsPQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Segment Quality";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentQ(month, year, servconsSQ_OnSuccess, servconsSQ_OnError);
            return false;
        }
        function servconsPQ_OnError(error) {
            alert(error.responseText);
        }

        function servconsSQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Reviewer Quality";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ReviewerQ(month, year, servconsRQ_OnSuccess, servconsRQ_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function servconsSQ_OnError(error) {
            alert(error.responseText);
        }

        function servconsRQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : QCer Quality";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.QualityQ(month, year, servconsQQ_OnSuccess, servconsQQ_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function servconsRQ_OnError(error) {
            alert(error.responseText);
        }

        function servconsQQ_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet and chart : Segment wise utilisation";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentwiseUtilisation(month, year, servconsSU_OnSuccess, servconsSU_OnError);
            return false;
        }
        function servconsQQ_OnError(error) {
            alert(error.responseText);
        }

        function servconsSU_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Individual Performance";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.IndividualPerformance(month, year, servconsIP_OnSuccess, servconsIP_OnError);
            return false;
        }
        function servconsSU_OnError(error) {
            alert(error.responseText);
        }
        function servconsIP_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Performance Report";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ProductionReport(month, year, servconsPR_OnSuccess, servconsPR_OnError);
            return false;
        }
        function servconsIP_OnError(error) {
            alert(error.responseText);
        }
        function servconsPR_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Dump";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.FeedbackDump(month, year, servconsFD_OnSuccess, servconsFD_OnError);
            return false;
        }
        function servconsPR_OnError(error) {
            alert(error.responseText);
        }
        function servconsFD_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Weekly Trending Report";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.WeeklyTrendingReport(month, year, servconsWT_OnSuccess, servconsWT_OnError);
            return false;
        }
        function servconsFD_OnError(error) {
            alert(error.responseText);
        }

        function servconsWT_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Monthly Trending Report";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.MonthlyTrendingReport(month, year, servconsMT_OnSuccess, servconsMT_OnError);
            return false;
        }
        function servconsWT_OnError(error) {
            alert(error.responseText);
        }

        function servconsMT_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Error Trending - All";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ErrorTrendingAll(month, year, servconsETA_OnSuccess, servconsETA_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function servconsMT_OnError(error) {
            alert(error.responseText);
        }

        function servconsETA_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Error Trending - User";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;

            PageMethods.ErrorTrendingUser(month, year, servconsETU_OnSuccess, servconsETU_OnError);
            //__doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }

        function servconsETA_OnError(error) {
            alert(error.responseText);
        }
      
        function servconsETU_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Dump English";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.FeedbackDumpEnglish(month, year, servconsFeedbackEnglish_OnSuccess, servconsFeedbackEnglish_OnError);
            return false;
        }
        function servconsETU_OnError(error) {
            alert(error.responseText);
        }


        function servconsFeedbackEnglish_OnError(error) {
            alert(error.responseText);
        }

        function servconsFeedbackEnglish_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Dump Delivery";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.GetFeedbackDump_RQC_1(month, year, servconsFeedbackDelivery_OnSuccess, servconsFeedbackDelivery_OnError);
            return false;
        }

        function servconsFeedbackDelivery_OnError(error) {
            alert(error.responseText);
        }


        function servconsFeedbackDelivery_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Feedback Dump Re-QC";
            var ddlmonth = document.getElementById("servcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("servcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.GetFeedbackDump_RW(month, year, servconsFeedbackReQC_OnSuccess, servconsFeedbackReQC_OnError);
            return false;
        }


        function servconsFeedbackReQC_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Report Prepeation Completed. Downloading Report";
            //var ddlmonth = document.getElementById("servcons_month");
            //var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            //var ddlyear = document.getElementById("servcons_year");
            //var year = ddlyear.options[ddlyear.selectedIndex].value;
            //PageMethods.WeeklyTrendingReport(month, year, servconsFD_OnSuccess, servconsFD_OnError);
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= btn1.UniqueID %>", '');
            $('#waitingpanel').modal('hide');
            return false;
        }
        function servconsFeedbackReQC_OnError(error) {
            alert(error.responseText);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="credit-report-header">
        <div class="credit-report-title">
            <span class="credit-report-title-icon"><i class="bi bi-diagram-3-fill"></i></span>
            <div>
                <h1>Servicing Consolidated Report</h1>
                <span>Monthly servicing reporting workspace</span>
            </div>
        </div>
        <div class="credit-report-badge">
            <i class="fas fa-layer-group"></i>
            <span>16 report views</span>
        </div>
    </div>
    <div class="col-lg-12 report-main">
        <div class="card report-shell">
            <div class="card-body report-shell-body">
                <div class="report-filter-panel">
                    <div class="report-filter-grid">
                        <div class="report-filter-field">
                            <label for="servcons_month">Month</label>
                            <select id="servcons_month" name="servcons_month" class="form-control">
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
                        </div>
                        <div class="report-filter-field">
                            <label for="servcons_year">Year</label>
                            <select id="servcons_year" name="servcons_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div class="report-button-group">
                            <button id="btnShow" class="btn report-btn report-btn-primary" onclick="return BindAllGrids_Serv();"><i class="fas fa-search"></i><span>Show</span></button>
                            <button id="servcons_btnexport" class="btn report-btn report-btn-secondary" onclick="return servcons_Submit()"><i class="fas fa-file-excel"></i><span>Export to Excel</span></button>
                            <%--onclick="return BindMagnaGrid();"--%>
                            <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </div>
                    </div>
                </div>

                <div class="card-header report-tabs-bar">
                    <ul class="nav nav-tabs credit-report-tabs" id="custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project Inflow</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(2);" id="custom-tabs-one-projectQ-tab" data-toggle="pill" href="#custom-tabs-one-projectQ" role="tab" aria-controls="custom-tabs-one-projectQ" aria-selected="false">Project Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(3);" id="custom-tabs-one-segmentQ-tab" data-toggle="pill" href="#custom-tabs-one-segmentQ" role="tab" aria-controls="custom-tabs-one-segmentQ" aria-selected="false">Segment Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(4);" id="custom-tabs-one-reviewerQ-tab" data-toggle="pill" href="#custom-tabs-one-reviewerQ" role="tab" aria-controls="custom-tabs-one-reviewerQ" aria-selected="false">Reviewer Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(5);" id="custom-tabs-one-qualityQ-tab" data-toggle="pill" href="#custom-tabs-one-qualityQ" role="tab" aria-controls="custom-tabs-one-qualityQ" aria-selected="false">Quality Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(6);" id="custom-tabs-one-segmentwiseutilisation-tab" data-toggle="pill" href="#custom-tabs-one-segmentwiseutilisation" role="tab" aria-controls="custom-tabs-one-segmentwiseutilisation" aria-selected="false">Segment Wise Utilisation</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(7);" id="custom-tabs-one-indvperformance-tab" data-toggle="pill" href="#custom-tabs-one-indvperformance" role="tab" aria-controls="custom-tabs-one-indvperformance" aria-selected="false">Individual Performance</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(8);" id="custom-tabs-one-production-tab" data-toggle="pill" href="#custom-tabs-one-production" role="tab" aria-controls="custom-tabs-one-production" aria-selected="false">Production Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(9);" id="custom-tabs-one-feedback-tab" data-toggle="pill" href="#custom-tabs-one-feedback" role="tab" aria-controls="custom-tabs-one-feedback" aria-selected="false">Feedback Dump</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(10);" id="custom-tabs-one-weeklytrending-tab" data-toggle="pill" href="#custom-tabs-one-weeklytrending" role="tab" aria-controls="custom-tabs-one-weeklytrending" aria-selected="false">Weekly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(11);" id="custom-tabs-one-monthlytrending-tab" data-toggle="pill" href="#custom-tabs-one-monthlytrending" role="tab" aria-controls="custom-tabs-one-monthlytrending" aria-selected="false">Monthly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(12);" id="custom-tabs-one-errortrendingall-tab" data-toggle="pill" href="#custom-tabs-one-errortrendingall" role="tab" aria-controls="custom-tabs-one-errortrendingall" aria-selected="false">Error Trending - All</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(13);" id="custom-tabs-one-errortrendinguser-tab" data-toggle="pill" href="#custom-tabs-one-errortrendinguser" role="tab" aria-controls="custom-tabs-one-errortrendinguser" aria-selected="false">Error Trending - User wise</a>
                        </li>

                          <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(14);" id="custom-tabs-one-feedbackEnglish-tab" data-toggle="pill" href="#custom-tabs-one-feedbackEnglish" role="tab" aria-controls="custom-tabs-one-feedbackEnglish" aria-selected="false">Feedback Dump-English</a>
                        </li>

                          <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(15);" id="custom-tabs-one-feedbackDelivery-tab" data-toggle="pill" href="#custom-tabs-one-feedbackDelivery" role="tab" aria-controls="custom-tabs-one-feedbackEnglish" aria-selected="false">Feedback Dump-Delivery</a>
                        </li>

                         <li class="nav-item">
                            <a class="nav-link" onclick="return Servicing_OpenReport(16);" id="custom-tabs-one-feedbackReQC-tab" data-toggle="pill" href="#custom-tabs-one-feedbackReQC" role="tab" aria-controls="custom-tabs-one-feedbackEnglish" aria-selected="false">Feedback Dump-Re-QC</a>
                        </li>

                    </ul>
                </div>

                <div class="card-body report-content">
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

                        <div class="tab-pane fade" id="custom-tabs-one-feedbackEnglish" role="tabpanel" aria-labelledby="custom-tabs-one-feedbackEnglish-tab">
                            <table class="table table-bordered" id="feedbackDumpEnglish_table" style="width: 100%;"></table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-feedbackDelivery" role="tabpanel" aria-labelledby="custom-tabs-one-feedbackDelivery-tab">
                            <table class="table table-bordered" id="feedbackDumpDelivery_table" style="width: 100%;"></table>
                        </div>

                        <div class="tab-pane fade" id="custom-tabs-one-feedbackReQC" role="tabpanel" aria-labelledby="custom-tabs-one-feedbackReQC-tab">
                            <table class="table table-bordered" id="feedbackDumpReQC_table" style="width: 100%;"></table>
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
            <span class="report-waiting-text" id="spntext">System is updating details. Please wait</span>
            <span class="report-waiting-dots">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
