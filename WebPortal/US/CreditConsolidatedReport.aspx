<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="CreditConsolidatedReport.aspx.cs" Inherits="WebPortal.US.CreditConsolidatedReport" %>

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

        .credit-report-header {
            align-items: center;
            background: #fff;
            border: 1px solid #e4e9f2;
            border-left: 4px solid #2563eb;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, .06);
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            justify-content: space-between;
            margin: 12px 15px 16px;
            padding: 16px 18px;
        }

        .credit-report-title {
            align-items: center;
            display: flex;
            gap: 12px;
        }

        .credit-report-title-icon {
            align-items: center;
            background: #edf4ff;
            border-radius: 8px;
            color: #1d4ed8;
            display: inline-flex;
            font-size: 18px;
            height: 40px;
            justify-content: center;
            width: 40px;
        }

        .credit-report-title h1 {
            color: #172033;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .credit-report-title span {
            color: #667085;
            display: block;
            font-size: 12px;
            margin-top: 2px;
        }

        .credit-report-badge {
            align-items: center;
            background: #f8fafc;
            border: 1px solid #e4e9f2;
            border-radius: 6px;
            color: #344054;
            display: inline-flex;
            font-size: 12px;
            font-weight: 600;
            gap: 8px;
            padding: 8px 10px;
        }

        .report-main {
            padding: 0 15px 24px;
        }

        .report-shell {
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .report-shell-body {
            padding: 0;
        }

        .report-filter-panel {
            background: #fff;
            border-bottom: 1px solid #e4e9f2;
            padding: 16px;
        }

        .report-filter-grid {
            align-items: flex-end;
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
        }

        .report-filter-field {
            flex: 0 1 220px;
            min-width: 180px;
        }

        .report-filter-field label {
            border: none !important;
            color: #475467;
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            margin-bottom: 6px;
        }

        .report-filter-field .form-control {
            border-color: #d0d7e2;
            border-radius: 6px;
            box-shadow: none;
            height: 38px;
        }

        .report-filter-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 .15rem rgba(37, 99, 235, .12);
        }

        .report-button-group {
            align-items: center;
            display: flex;
            flex: 1 1 280px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .report-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-weight: 600;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
        }

        .report-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }

        .report-btn-primary:hover,
        .report-btn-primary:focus {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #fff;
        }

        .report-btn-secondary {
            background: #111827;
            border-color: #111827;
            color: #fff;
        }

        .report-btn-secondary:hover,
        .report-btn-secondary:focus {
            background: #0f172a;
            border-color: #0f172a;
            color: #fff;
        }

        .report-tabs-bar {
            background: #f8fafc;
            border-bottom: 1px solid #e4e9f2;
            padding: 10px 12px 0;
        }

        .credit-report-tabs {
            border-bottom: 0;
            display: flex;
            flex-wrap: nowrap;
            gap: 6px;
            overflow-x: auto;
            overflow-y: hidden;
            padding-bottom: 10px;
        }

        .credit-report-tabs .nav-item {
            flex: 0 0 auto;
        }

        .credit-report-tabs .nav-link {
            background: #fff;
            border: 1px solid #d8e0ec !important;
            border-radius: 6px !important;
            color: #42526e;
            font-size: 12px;
            font-weight: 600;
            padding: 8px 12px;
            white-space: nowrap;
        }

        .credit-report-tabs .nav-link.active {
            background: #2563eb !important;
            border-color: #2563eb !important;
            box-shadow: 0 8px 16px rgba(37, 99, 235, .18);
            color: #fff !important;
        }

        .report-content {
            padding: 16px;
        }

        .report-content .tab-pane {
            min-height: 260px;
            overflow-x: auto;
        }

        .loading {
            background: #fff;
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, .16);
            display: none;
            height: auto;
            left: 50%;
            margin: 0;
            min-height: 154px;
            opacity: .96;
            padding: 20px;
            position: fixed;
            text-align: center;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 180px;
            z-index: 99999;
        }

        .loading img {
            max-width: 72px;
        }

        .loading div {
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            margin-top: 12px;
        }

        .dataTables_scrollBody {
            border: 1px solid #e8edf5;
            border-radius: 6px;
        }

        .buttons-excel, .buttons-html5 {
            background: #16a34a;
            border-radius: 6px;
        }

        .table.dataTable th {
            background: #f3f6fb !important;
            border-bottom: 1px solid #d8e0ec !important;
            color: #172033;
            font-weight: 700;
        }

        .table.dataTable tr td {
            background: none !important;
            background-color: #fff !important;
            color: #344054;
        }

        .table.dataTable tbody tr:hover td {
            background-color: #f8fbff !important;
        }

        #waitingpanel .modal-dialog,
        #us_waitingpanel .modal-dialog {
            align-items: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 55vh;
        }

        .report-waiting-text {
            color: #fff;
            display: inline-block;
            font-size: 22px;
            font-style: normal;
            font-weight: 700;
            margin-top: 10px;
        }

        .report-waiting-dots {
            color: #fff;
            display: inline-block;
            font-size: 42px;
            font-style: normal;
            font-weight: 700;
            animation: animate 1s linear infinite;
        }

        @media (max-width: 767px) {
            .credit-report-header {
                margin-left: 8px;
                margin-right: 8px;
            }

            .report-main {
                padding-left: 8px;
                padding-right: 8px;
            }

            .report-filter-field,
            .report-button-group {
                flex-basis: 100%;
            }

            .report-btn {
                width: 100%;
            }
        }
    </style>
    <script>
        $(document).ready(function () {
            us_creditcons_bindyear();
        });
        function creditcons_Submit() {
            $('#us_waitingpanel').modal('show');
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Project Inflow";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.CreateProjectInflow(month, year, creditcons_OnSuccess, creditcons_OnError);
            //__doPostBack("<%= us_btn1.UniqueID %>", '');

            return false;
        }
        function creditcons_OnSuccess(result) {
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet and chart : Project Quality";
            PageMethods.ProjectQ(month, year, creditconsPQ_OnSuccess, creditconsPQ_OnError);
            return false;
        }
        function creditcons_OnError(error) {
            alert(error.responseText);
        }
        function creditconsPQ_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet and chart : Segment Quality";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentQ(month, year, creditconsSQ_OnSuccess, creditconsSQ_OnError);
            return false;
        }
        function creditconsPQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsSQ_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Reviewer Quality";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ReviewerQ(month, year, creditconsRQ_OnSuccess, creditconsRQ_OnError);
            //__doPostBack("<%= us_btn1.UniqueID %>", '');
            return false;
        }
        function creditconsSQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsRQ_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : QCer Quality";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.QualityQ(month, year, creditconsQQ_OnSuccess, creditconsQQ_OnError);
            //__doPostBack("<%= us_btn1.UniqueID %>", '');
            return false;
        }
        function creditconsRQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsQQ_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet and chart : Segment wise utilisation";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.SegmentwiseUtilisation(month, year, creditconsSU_OnSuccess, creditconsSU_OnError);
            return false;
        }
        function creditconsQQ_OnError(error) {
            alert(error.responseText);
        }

        function creditconsSU_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Individual Performance";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.IndividualPerformance(month, year, creditconsIP_OnSuccess, creditconsIP_OnError);
            return false;
        }
        function creditconsSU_OnError(error) {
            alert(error.responseText);
        }
        function creditconsIP_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Performance Report";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ProductionReport(month, year, creditconsPR_OnSuccess, creditconsPR_OnError);
            return false;
        }
        function creditconsIP_OnError(error) {
            alert(error.responseText);
        }
        function creditconsPR_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Feedback Dump";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.FeedbackDump(month, year, creditconsFD_OnSuccess, creditconsFD_OnError);
            return false;
        }
        function creditconsPR_OnError(error) {
            alert(error.responseText);
        }
        function creditconsFD_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Weekly Trending Report";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.WeeklyTrendingReport(month, year, creditconsWT_OnSuccess, creditconsWT_OnError);
            return false;
        }
        function creditconsFD_OnError(error) {
            alert(error.responseText);
        }

        function creditconsWT_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Monthly Trending Report";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.MonthlyTrendingReport(month, year, creditconsMT_OnSuccess, creditconsMT_OnError);
            return false;
        }
        function creditconsWT_OnError(error) {
            alert(error.responseText);
        }

        function creditconsMT_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Generating excel sheet : Error Trending - All";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ErrorTrendingAll(month, year, creditconsETA_OnSuccess, creditconsETA_OnError);
            //__doPostBack("<%= us_btn1.UniqueID %>", '');
            return false;
        }
        function creditconsMT_OnError(error) {
            alert(error.responseText);
        }

        function creditconsETA_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Generating excel sheet : Error Trending - User";
            var ddlmonth = document.getElementById("us_creditcons_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("us_creditcons_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            PageMethods.ErrorTrendingUser(month, year, creditconsETU_OnSuccess, creditconsETU_OnError);
            //__doPostBack("<%= us_btn1.UniqueID %>", '');
            return false;
        }
        function creditconsETA_OnError(error) {
            alert(error.responseText);
        }

        function creditconsETU_OnSuccess(result) {
            document.getElementById("us_spntext").innerHTML = "Report Prepeation Completed. Downloading Report";
            //var ddlmonth = document.getElementById("creditcons_month");
            //var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            //var ddlyear = document.getElementById("creditcons_year");
            //var year = ddlyear.options[ddlyear.selectedIndex].value;
            //PageMethods.WeeklyTrendingReport(month, year, creditconsFD_OnSuccess, creditconsFD_OnError);
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= us_btn1.UniqueID %>", '');
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
    <div class="credit-report-header">
        <div class="credit-report-title">
            <span class="credit-report-title-icon"><i class="fas fa-chart-line"></i></span>
            <div>
                <h1>Credit Consolidated Report</h1>
                <span>Monthly credit reporting workspace</span>
            </div>
        </div>
        <div class="credit-report-badge">
            <i class="fas fa-layer-group"></i>
            <span>13 report views</span>
        </div>
    </div>
    <div class="col-lg-12 report-main">
        <div class="card report-shell">
            <div class="card-body report-shell-body">
                <div class="report-filter-panel">
                    <div class="report-filter-grid">
                        <div class="report-filter-field">
                            <label for="us_creditcons_month">Month</label>
                            <select id="us_creditcons_month" name="us_creditcons_month" class="form-control">
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
                            <label for="us_creditcons_year">Year</label>
                            <select id="us_creditcons_year" name="us_creditcons_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div class="report-button-group">
                            <button id="us_btnShow" class="btn report-btn report-btn-primary" onclick="return US_BindAllGrids();"><i class="fas fa-search"></i><span>Show</span></button>
                            <button id="us_creditcons_btnexport" class="btn report-btn report-btn-secondary" onclick="return us_creditcons_Submit()"><i class="fas fa-file-excel"></i><span>Export to Excel</span></button>
                            <%--onclick="return BindMagnaGrid();"--%>
                            <asp:Button id="us_btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
                        </div>
                    </div>
                </div>

                <div class="card-header report-tabs-bar">
                    <ul class="nav nav-tabs credit-report-tabs" id="us_custom-tabs-one-tab" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="us_custom-tabs-one-home-tab" data-toggle="pill" href="#us_custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Project Inflow</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(2);" id="us_custom-tabs-one-projectQ-tab" data-toggle="pill" href="#us_custom-tabs-one-projectQ" role="tab" aria-controls="custom-tabs-one-projectQ" aria-selected="false">Project Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(3);" id="us_custom-tabs-one-segmentQ-tab" data-toggle="pill" href="#us_custom-tabs-one-segmentQ" role="tab" aria-controls="custom-tabs-one-segmentQ" aria-selected="false">Segment Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(4);" id="us_custom-tabs-one-reviewerQ-tab" data-toggle="pill" href="#us_custom-tabs-one-reviewerQ" role="tab" aria-controls="custom-tabs-one-reviewerQ" aria-selected="false">Reviewer Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(5);" id="us_custom-tabs-one-qualityQ-tab" data-toggle="pill" href="#us_custom-tabs-one-qualityQ" role="tab" aria-controls="custom-tabs-one-qualityQ" aria-selected="false">Quality Q</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(6);" id="us_custom-tabs-one-segmentwiseutilisation-tab" data-toggle="pill" href="#us_custom-tabs-one-segmentwiseutilisation" role="tab" aria-controls="custom-tabs-one-segmentwiseutilisation" aria-selected="false">Segment Wise Utilisation</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(7);" id="us_custom-tabs-one-indvperformance-tab" data-toggle="pill" href="#us_custom-tabs-one-indvperformance" role="tab" aria-controls="custom-tabs-one-indvperformance" aria-selected="false">Individual Performance</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(8);" id="us_custom-tabs-one-production-tab" data-toggle="pill" href="#us_custom-tabs-one-production" role="tab" aria-controls="custom-tabs-one-production" aria-selected="false">Production Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(9);" id="us_custom-tabs-one-feedback-tab" data-toggle="pill" href="#us_custom-tabs-one-feedback" role="tab" aria-controls="custom-tabs-one-feedback" aria-selected="false">Feedback Dump</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(10);" id="us_custom-tabs-one-weeklytrending-tab" data-toggle="pill" href="#us_custom-tabs-one-weeklytrending" role="tab" aria-controls="custom-tabs-one-weeklytrending" aria-selected="false">Weekly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(11);" id="us_custom-tabs-one-monthlytrending-tab" data-toggle="pill" href="#us_custom-tabs-one-monthlytrending" role="tab" aria-controls="custom-tabs-one-monthlytrending" aria-selected="false">Monthly Trending Report</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(12);" id="us_custom-tabs-one-errortrendingall-tab" data-toggle="pill" href="#us_custom-tabs-one-errortrendingall" role="tab" aria-controls="custom-tabs-one-errortrendingall" aria-selected="false">Error Trending - All</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" onclick="return US_Credit_OpenReport(13);" id="us_custom-tabs-one-errortrendinguser-tab" data-toggle="pill" href="#us_custom-tabs-one-errortrendinguser" role="tab" aria-controls="custom-tabs-one-errortrendinguser" aria-selected="false">Error Trending - User wise</a>
                        </li>
                       
                    </ul>
                </div>

                <div class="card-body report-content">
                    <div class="tab-content" id="us_custom-tabs-one-tabContent">
                        <div class="tab-pane fade show active" id="us_custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                            <table class="table table-bordered" id="us_project_table" style="width: 100%;"></table>
                        </div>

                        <div class="tab-pane fade" id="us_custom-tabs-one-projectQ" role="tabpanel" aria-labelledby="custom-tabs-one-projectQ-tab">
                            <table class="table table-bordered" id="us_projectQ_table" style="width: 100%;"></table>

                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-segmentQ" role="tabpanel" aria-labelledby="custom-tabs-one-segmentQ-tab">
                            <table class="table table-bordered" id="us_segmentQ_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-reviewerQ" role="tabpanel" aria-labelledby="custom-tabs-one-reviewewQ-tab">
                            <table class="table table-bordered" id="us_ReviewerQ_table" style="width: 100%;">
                            </table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-qualityQ" role="tabpanel" aria-labelledby="custom-tabs-one-qualityQ-tab">
                            <table class="table table-bordered" id="us_qualityQ_table" style="width: 100%;">
                            </table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-segmentwiseutilisation" role="tabpanel" aria-labelledby="custom-tabs-one-segmentwiseutilisation-tab">
                            <table class="table table-bordered" id="us_segmentwiseutilisation_table" style="width: 100%;">
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
                        <div class="tab-pane fade" id="us_custom-tabs-one-indvperformance" role="tabpanel" aria-labelledby="custom-tabs-one-indvperformance-tab">
                            <table class="table table-bordered" id="us_indvPerformance_table" style="width: 100%;">
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
                        <div class="tab-pane fade" id="us_custom-tabs-one-production" role="tabpanel" aria-labelledby="custom-tabs-one-production-tab">
                            <table class="table table-bordered" id="us_production_table" style="width: 100%;">
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
                        <div class="tab-pane fade" id="us_custom-tabs-one-feedback" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                            <table class="table table-bordered" id="us_feedbackDump_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-weeklytrending" role="tabpanel" aria-labelledby="custom-tabs-one-weeklytrending-tab">
                            <table class="table table-bordered" id="us_weeklytrending_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-monthlytrending" role="tabpanel" aria-labelledby="custom-tabs-one-monthlytrending-tab">
                            <table class="table table-bordered" id="us_monthlytrending_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-errortrendingall" role="tabpanel" aria-labelledby="custom-tabs-one-errortrendingall-tab">
                            <table class="table table-bordered" id="us_errortrendingall_table" style="width: 100%;"></table>
                        </div>
                        <div class="tab-pane fade" id="us_custom-tabs-one-errortrendinguser" role="tabpanel" aria-labelledby="custom-tabs-one-errortrendinguser-tab">
                            <table class="table table-bordered" id="us_errortrendinguser_table" style="width: 100%;"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="us_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span class="report-waiting-text" id="us_spntext">System is updating details. Please wait</span>
            <span class="report-waiting-dots">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
