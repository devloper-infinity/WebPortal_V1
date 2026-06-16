<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="HRReport.aspx.cs" Inherits="WebPortal.Admin.HRReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        function hr_Submit() {
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
    </script>
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
            hr_BindYear();
        });

        function RecruitmentSummary() {
            $('#waitingpanel').modal('show');
            var ddlmonth = document.getElementById("hr_month");
            var month = ddlmonth.options[ddlmonth.selectedIndex].value;
            var ddlyear = document.getElementById("hr_year");
            var year = ddlyear.options[ddlyear.selectedIndex].value;
            document.getElementById("spntext").innerHTML = "Preparing sheet : Recruitment Summary . . . ";
            PageMethods.RecruitmentSummary(month, year, Recruit_OnSuccess, Recruit_OnError);
            return false;
        }
        function Recruit_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Hiring . . . ";
            PageMethods.Hiring(Hiring_OnSuccess, Hiring_OnError);
            return false;
        }
        function Recruit_OnError(error) {
            alert(error.get_message());
        }
        //Hiring
        function Hiring_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Manpower . . . ";
            PageMethods.Manpower(Manpower_OnSuccess, Manpower_OnError);
            return false;
        }
        function Hiring_OnError(error) {
            alert(error.get_message());
        }
        //SkipLevel
        function Manpower_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Skip Level Summary . . . ";
            PageMethods.SkipLevel(SkipLevel_OnSuccess, SkipLevel_OnError);
            return false;
        }
        function Manpower_OnError(error) {
            alert(error.get_message());
        }
        //Skip Level Details
        function SkipLevel_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Skip Level Details . . . ";
            PageMethods.SkipLevelDetails(SkipLevelDetails_OnSuccess, SkipLevelDetails_OnError);
            return false;
        }
        function SkipLevel_OnError(error) {
            alert(error.get_message());
        }
        //Background Verification
        function SkipLevelDetails_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Background Verification . . . ";
            PageMethods.BackgroundVerification(BackgroundVerification_OnSuccess, BackgroundVerification_OnError);
            return false;
        }
        function SkipLevelDetails_OnError(error) {
            alert(error.get_message());
        }
        //Absconding
        function BackgroundVerification_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Absconding . . . ";
            PageMethods.Absconding(Absconding_OnSuccess, Absconding_OnError);
            return false;
        }
        function BackgroundVerification_OnError(error) {
            alert(error.get_message());
        }
        //Resigned
        function Absconding_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Resigned . . . ";
            PageMethods.Resigned(Resigned_OnSuccess, Resigned_OnError);
            return false;
        }
        function Absconding_OnError(error) {
            alert(error.get_message());
        }

        //FunFriday
        function Resigned_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Fun Friday Details . . . ";
            PageMethods.FunFriday(FunFriday_OnSuccess, FunFriday_OnError);
            return false;
        }
        function Resigned_OnError(error) {
            alert(error.get_message());
        }
        //FunFridaySnaps
        function FunFriday_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Fun Friday Snaps . . . ";
            PageMethods.FunFridaySnaps(FunFridaySnaps_OnSuccess, FunFridaySnaps_OnError);
            return false;
        }
        function FunFriday_OnError(error) {
            alert(error.get_message());
        }
        //Naukri
        function FunFridaySnaps_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Naukri . . . ";
            PageMethods.Naukri(Naukri_OnSuccess, Naukri_OnError);
            return false;
        }
        function FunFridaySnaps_OnError(error) {
            alert(error.get_message());
        }
        //LinkedIn
        function Naukri_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : LinkedIn . . . ";
            PageMethods.LinkedIn(LinkedIn_OnSuccess, LinkedIn_OnError);
            return false;
        }
        function Naukri_OnError(error) {
            alert(error.get_message());
        }
        //Glassdoor Infinity
        function LinkedIn_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Glassdoor Infinity . . . ";
            PageMethods.GlassdoorInfinity(GlassdoorInfinity_OnSuccess, GlassdoorInfinity_OnError);
            return false;
        }
        function LinkedIn_OnError(error) {
            alert(error.get_message());
        }
        //Glassdoor Competitors
        function GlassdoorInfinity_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Glassdoor Competitors . . . ";
            PageMethods.GlassdoorCompetitors(GlassdoorCompetitors_OnSuccess, GlassdoorCompetitors_OnError);
            return false;
        }
        function GlassdoorInfinity_OnError(error) {
            alert(error.get_message());
        }
        //RnR
        function GlassdoorCompetitors_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Reward and Recognition Details . . . ";
            PageMethods.RnR(RnR_OnSuccess, RnR_OnError);
            return false;
        }
        function GlassdoorCompetitors_OnError(error) {
            alert(error.get_message());
        }
        //RnRSnaps
        function RnR_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Reward and Recognition Snaps . . . ";
            PageMethods.RnRSnaps(RnRSnaps_OnSuccess, RnRSnaps_OnError);
            return false;
        }
        function RnR_OnError(error) {
            alert(error.get_message());
        }
        //StamppaperPurchase
        function RnRSnaps_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Stamp Paper Purchase . . . ";
            PageMethods.StamppaperPurchase(StamppaperPurchase_OnSuccess, StamppaperPurchase_OnError);
            return false;
        }
        function RnRSnaps_OnError(error) {
            alert(error.get_message());
        }
        //Master Data
        function StamppaperPurchase_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Master Data . . . ";
            PageMethods.MasterData(MasterData_OnSuccess, MasterData_OnError);
            return false;
        }
        function StamppaperPurchase_OnError(error) {
            alert(error.get_message());
        }

        //HRInductionReport
        function MasterData_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : HR Induction Report . . . ";
            PageMethods.HRInductionReport(HRInductionReport_OnSuccess, HRInductionReport_OnError);
            return false;
        }
        function MasterData_OnError(error) {
            alert(error.get_message());
        }

        //NewJoineeFollowUp
        function HRInductionReport_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : New Joinee Followup . . . ";
            PageMethods.NewJoineeFollowUp(NewJoineeFollowUp_OnSuccess, NewJoineeFollowUp_OnError);
            return false;
        }
        function HRInductionReport_OnError(error) {
            alert(error.get_message());
        }
        //AddressVerification
        function NewJoineeFollowUp_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Address Verification . . . ";
            PageMethods.AddressVerification(AddressVerification_OnSuccess, AddressVerification_OnError);
            return false;
        }
        function NewJoineeFollowUp_OnError(error) {
            alert(error.get_message());
        }
        //ExitEmployees
        function AddressVerification_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Exit Employees . . . ";
            PageMethods.ExitEmployees(ExitEmployees_OnSuccess, ExitEmployees_OnError);
            return false;
        }
        function AddressVerification_OnError(error) {
            alert(error.get_message());
        }
        //TicketReport
        function ExitEmployees_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Ticket Report . . . ";
            PageMethods.TicketReport(TicketReport_OnSuccess, TicketReport_OnError);
            return false;
        }
        function ExitEmployees_OnError(error) {
            alert(error.get_message());
        }
        //EditDashboard
        function TicketReport_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Editing Dashboard Summary . . . ";
            PageMethods.EditDashboard(EditDashboard_OnSuccess, EditDashboard_OnError);
            return false;
        }
        function TicketReport_OnError(error) {
            alert(error.get_message());
        }
        //AttritionReport
        function EditDashboard_OnSuccess(result) {
            document.getElementById("spntext").innerHTML = "Preparing sheet : Attrition Report . . . ";
            PageMethods.AttritionReport(AttritionReport_OnSuccess, AttritionReport_OnError);
            return false;
        }
        function EditDashboard_OnError(error) {
            alert(error.get_message());
        }

        //Export final Excel
        function AttritionReport_OnSuccess(result) {
          
            $('#waitingpanel').modal('hide');
            __doPostBack("<%= btn1.UniqueID %>", '');
            return false;
        }
        function AttritionReport_OnError(error) {
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>HR Report</b></h6>
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
                            <select id="hr_month" name="hr_month" class="form-control">
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
                            <select id="hr_year" name="hr_year" class="form-control">
                                <option value="">Select</option>
                            </select>
                        </td>
                        <td style="width: 100px;">
                            <button id="hr_btnShow" class="btn btn-primary" onclick="return RecruitmentSummary()">Export to excel</button>
                        </td>
                    </tr>
                </table>
                <asp:Button ID="btn1" runat="server" Style="display: none;" OnClick="btn1_Click" />
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
