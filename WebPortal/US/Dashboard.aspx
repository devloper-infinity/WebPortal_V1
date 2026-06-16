<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="WebPortal.US.Dashboard" %>

<%--<%@ Page Title="" Language="C#" MasterPageFile="~/US/USAdmin.Master" AutoEventWireup="true" CodeBehind="DashboardEmployee.aspx.cs" Inherits="WebPortal.Admin.DashboardEmployee" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #dashboard_alert_table_wrapper .dataTables_scroll {
            height: 225px !important;
        }

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }
    </style>
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
            Dashboard_BindFormInformation();
            Dashboard_GetDashboardAlerts();
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            if (currentUserName == 12 || currentUserName == 7036 || currentUserName == 8082 || currentUserName == 8938) {
                document.getElementById("onlymgmt").style.display = '';
                Dashboard_GetManpowerSumary('All');
            }
            else {
                document.getElementById("onlymgmt").style.display = 'none';
            }
            getPendingTaskNotifications();

        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="display: none;">

        <div class="row" style="padding-top: 10px;">
            <div class="col-md-4">
                <!-- Widget: user widget style 1 -->
                <div class="card card-widget widget-user shadow" style="height: 270px;">
                    <!-- Add the bg color to the header using any of the bg-* classes -->
                    <div class="widget-user-header bg-gradient-success">
                        <h3 class="widget-user-username" id="dashboard_spnusername" onclick="return dashboard_profileinfo();" style="font-style: italic; font-weight: bold; cursor: pointer; text-decoration: underline;"></h3>
                        <h6 class="widget-user-desc" id="dashboard_spndesignation"></h6>
                    </div>
                    <div class="widget-user-image">
                        <img class="img-circle elevation-2" id="dashboard_userimg" alt="User Avatar" />
                    </div>
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-sm-4 border-right">
                                <div class="description-block">
                                    <h5 class="description-header">100</h5>
                                    <span class="description-text"><a href="#url" style="text-decoration: underline;">Productivity</a></span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                            <div class="col-sm-4 border-right">
                                <div class="description-block">
                                    <h5 class="description-header">100</h5>
                                    <span class="description-text"><a href="#url" style="text-decoration: underline;">Quality</a></span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                            <div class="col-sm-4">
                                <div class="description-block">
                                    <h5 class="description-header">100</h5>
                                    <span class="description-text"><a href="Log.aspx" style="text-decoration: underline;">Attendance</a></span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                    </div>
                </div>
                <!-- /.widget-user -->
            </div>
            <div class="col-md-2">
                <!-- Info Boxes Style 2 -->
                <div class="info-box mb-3 bg-gradient-info">
                    <span class="info-box-icon"><i class="far fa-chart-bar"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: white;" href="DailyProductivity.aspx">
                            <span class="info-box-number">Daily Productivity</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <!-- /.info-box -->
                <div class="info-box mb-3 bg-gradient-success">
                    <span class="info-box-icon"><i class="fa fa-circle-notch"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: white;" href="ProposedSalaryReport.aspx">
                            <span class="info-box-number">Proposed Salary Report</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <div class="info-box mb-3 bg-gradient-blue">
                    <span class="info-box-icon"><i class="fas fa-birthday-cake"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: white;" href="ViewBirthdays.aspx">
                            <span class="info-box-number">Today's Birthday</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>

            </div>
            <div class="col-md-2">
                <!-- /.info-box -->
                <div class="info-box mb-3 bg-danger">
                    <span class="info-box-icon"><i class="fas fa-luggage-cart"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: white;" href="SelfLeaves.aspx">
                            <span class="info-box-number">My Leaves</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <!-- /.info-box -->
                <div class="info-box mb-3 bg-warning">
                    <span class="info-box-icon"><i class="fas fa-check"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: black;" href="AttendanceCorrectionSelf.aspx">
                            <span class="info-box-number">Attendance Corrections</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>
                <div class="info-box mb-3 bg-gradient-teal">
                    <span class="info-box-icon"><i class="fas fa-list-ol"></i></span>

                    <div class="info-box-content">
                        <a class="animation__shake" style="color: white;" href="#" data-target="#ClientHolidays" data-toggle="modal">
                            <span class="info-box-number" data-target="ClientHolidays" data-toggle="modal">Client Holidays List</span></a>
                    </div>
                    <!-- /.info-box-content -->
                </div>


            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header ui-sortable-handle" style="padding: 5px 1.25rem!important;">
                        <h3 class="card-title">
                            <i class="fas fa-info-circle mr-1"></i>
                            Important Notifications
                    </h3>
                        <div class="card-tools">
                            <a class="nav-link active" href="Notiications.aspx">View All</a>
                        </div>
                    </div>
                    <table class="table" id="dashboard_alert_table" style="padding-top: 0px; font-size: 11px; width: 100%;">
                        <thead>
                            <tr>
                                <th class="sort border-top ps-3" style="display: none;">Alert Id</th>
                                <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                <th class="sort border-top ps-3">Subject</th>
                                <th class="sort border-top ps-3">Attachment</th>
                                <th class="sort border-top ps-3">View</th>
                                <th class="sort border-top ps-3" style="display: none;">Attachment</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card" id="onlymgmt">
                    <div class="card-header">
                        <h5 class="card-title">Branch > Domain > Subdomain wise Manpower Summary</h5>

                        <div class="card-tools">
                            <strong id="dashboard_graphperiod">Period: </strong>
                            <div class="btn-group">
                                <button type="button" class="btn btn-tool dropdown-toggle" data-toggle="dropdown">
                                    <i class="fas fa-wrench"></i>&nbsp;&nbsp;<span style="font-size: 12px;" id="summary_gridheaderfilter">All Employees</span>
                                </button>
                                <div class="dropdown-menu dropdown-menu-right" role="menu">
                                    <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('All');">All Employees</a>
                                    <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('Present');">Present Today</a>
                                    <a href="#" class="dropdown-item" onclick="return Dashboard_GetManpowerSumary('Leave');">Users on Leave</a>
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body">
                        <div class="row">

                            <div class="col-md-12">
                                <table class="table" id="dasboard_currentmanpower" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                            <th class="sort border-top ps-3" style="display: none;">Sr. #</th>
                                            <th class="sort border-top ps-3">Branch</th>
                                            <th class="sort border-top ps-3">Domain</th>
                                            <th class="sort border-top ps-3">Subdomain</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">Total</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">On Floor</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">Resigned</th>
                                            <th class="sort border-top ps-3" style="text-align: center;">Absconding</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <!-- /.col -->
                        </div>
                        <!-- /.row -->
                    </div>
                    <!-- ./card-body -->
                    <div class="card-footer">
                        <div class="row">
                            <div class="col-sm-3 col-6">
                                <div class="description-block border-right">
                                    <h5 class="description-header" id="dashboard_totalemployees"></h5>
                                    <span class="description-text">TOTAL EMPLOYEES</span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                            <div class="col-sm-3 col-6">
                                <div class="description-block border-right">
                                    <h5 class="description-header" id="dashboard_onfloormployees"></h5>
                                    <span class="description-text">TOTAL ON FLOOR</span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                            <div class="col-sm-3 col-6">
                                <div class="description-block border-right">
                                    <h5 class="description-header" id="dashboard_resignedemployees"></h5>
                                    <span class="description-text">TOTAL RESIGNED</span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                            <!-- /.col -->
                            <div class="col-sm-3 col-6">
                                <div class="description-block">
                                    <h5 class="description-header" id="dashboard_abscondingemployees"></h5>
                                    <span class="description-text">TOTAL ABSCONDING</span>
                                </div>
                                <!-- /.description-block -->
                            </div>
                        </div>
                        <!-- /.row -->
                    </div>
                    <!-- /.card-footer -->
                </div>
                <!-- /.card -->
            </div>
            <!-- /.col -->
        </div>

        <div class="modal fade" id="dashboard_profileinfopopup">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Profile Information</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body card-primary card-outline">
                        <div class="card card-tabs">
                            <div class="card-header p-0 pt-1">
                                <ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
                                    <li class="nav-item">
                                        <a class="nav-link active" id="custom-tabs-one-home-tab" data-toggle="pill" href="#custom-tabs-one-home" role="tab" aria-controls="custom-tabs-one-home" aria-selected="true">Personal Information</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Official Information</a>
                                    </li>

                                </ul>
                            </div>
                            <div class="card-body">
                                <div class="tab-content" id="custom-tabs-one-tabContent">
                                    <input id="filep" style="display: none;" />
                                    <asp:HiddenField ID="filepath" runat="server" />
                                    <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                        <div class="col-sm-12">
                                            <table class="table">
                                                <tr>
                                                    <td><b>Name:</b></td>
                                                    <td>
                                                        <label id="dasboard_popname" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Date of Birth:</b></td>
                                                    <td>
                                                        <label id="dasboard_popdob" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Present Address:</b></td>
                                                    <td>
                                                        <label id="dasboard_poppresentaddress" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Permanent Address:</b></td>
                                                    <td>
                                                        <label id="dasboard_poppermanentaddress" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Contact #:</b></td>
                                                    <td>
                                                        <label id="dasboard_popcontact" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>PAN:</b></td>
                                                    <td>
                                                        <label id="dasboard_poppan" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Qualification:</b></td>
                                                    <td>
                                                        <label id="dasboard_popqualification" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Blood Group:</b></td>
                                                    <td>
                                                        <label id="dasboard_popbloodgroup" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Email Address:</b></td>
                                                    <td>
                                                        <label id="dasboard_popemail" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                        <div class="col-sm-12">
                                            <table class="table">
                                                <tr>
                                                    <td><b>Employee ID:</b></td>
                                                    <td>
                                                        <label id="dasboard_popemployeeid" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Code:</b></td>
                                                    <td>
                                                        <label id="dasboard_popcode" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Joining Date:</b></td>
                                                    <td>
                                                        <label id="dasboard_popjoiningdate" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Working Branch:</b></td>
                                                    <td>
                                                        <label id="dasboard_popbranch" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Department:</b></td>
                                                    <td>
                                                        <label id="dasboard_popdepartment" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Designation:</b></td>
                                                    <td>
                                                        <label id="dasboard_popdesignation" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Shift:</b></td>
                                                    <td>
                                                        <label id="dasboard_popshift" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Working Hours:</b></td>
                                                    <td>
                                                        <label id="dasboard_popworkinghours" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Cut off Time:</b></td>
                                                    <td>
                                                        <label id="dasboard_popcutofftime" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Weekly Holiday:</b></td>
                                                    <td>
                                                        <label id="dasboard_popweeklyholiday" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Official Email:</b></td>
                                                    <td>
                                                        <label id="dasboard_popofficialemail" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Bank Name:</b></td>
                                                    <td>
                                                        <label id="dasboard_popbankname" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Account #:</b></td>
                                                    <td>
                                                        <label id="dasboard_popaccountno" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>IFSC Code:</b></td>
                                                    <td>
                                                        <label id="dasboard_popifsccode" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>EISC #:</b></td>
                                                    <td>
                                                        <label id="dasboard_popesicno" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>PF #:</b></td>
                                                    <td>
                                                        <label id="dasboard_poppfno" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b>UAN:</b></td>
                                                    <td>
                                                        <label id="dasboard_popuan" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                    <td><b>Reporting Manager:</b></td>
                                                    <td>
                                                        <label id="dasboard_popreportingmanager" class="form-control" style="width: 350px;"></label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>



                                </div>
                            </div>
                            <div class="modal-footer justify-content-between">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
            </div>
        </div>

        <div class="modal fade" id="dashboard_alertdetails">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Important Notification</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body card-primary card-outline">
                        <div class="card card-tabs">
                            <table class="table table-borderless">
                                <tr>
                                    <td><b>Subject:</b></td>
                                    <td>
                                        <label id="dasboard_popalertsubject" class="form-control" style="border: none;"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Message:</b></td>
                                    <td>
                                        <label id="dasboard_popalertmessage" class="form-control" style="border: none; min-height: 100px; height: auto;"></label>
                                    </td>
                                </tr>

                            </table>

                        </div>
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                    <!-- /.modal-dialog -->
                </div>
            </div>
        </div>

        <div class="modal fade" id="dashboard_summarydetails">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title" id="details_popupheader">Employee Details</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body card-primary card-outline">
                        <div class="card card-tabs" style="min-height: 400px; height: auto;">
                            <table class="table" id="details_table" style="width: 100%; font-size: 10px!important;">
                                <thead>
                                    <tr>
                                        <th class="sort border-top ps-3">Sr. #</th>
                                        <th class="sort border-top ps-3">Code</th>
                                        <th class="sort border-top ps-3">Employee Name</th>
                                        <th class="sort border-top ps-3">Joining Date</th>
                                        <th class="sort border-top ps-3">Branch</th>
                                        <th class="sort border-top ps-3">Domain</th>
                                        <th class="sort border-top ps-3">Subdomain</th>
                                        <th class="sort border-top ps-3">Departmnet</th>
                                        <th class="sort border-top ps-3">Designation</th>
                                        <th class="sort border-top ps-3">Reporting Manager</th>
                                        <th class="sort border-top ps-3">Domain Head</th>
                                        <th class="sort border-top ps-3">Resignation Type</th>
                                        <th class="sort border-top ps-3">Resignation Date</th>
                                        <th class="sort border-top ps-3">Last Working Date</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>

                        </div>
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                    <!-- /.modal-dialog -->
                </div>
            </div>
        </div>

        <div class="modal fade" id="dash_notifications" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-danger">
                        <h5 class="modal-title" id="staticBackdropLabel"><i class="fas fa-bell"></i>&nbsp;&nbsp;Pending Task List</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" style="min-height: 400px; height: auto;">
                        <table id="dash_tblnotifications" class="table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal fade" id="ClientHolidays" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="ClientHolidaysLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="ClientHolidaysLabel">Client Holidays</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <table id="ClientHolidayList" runat="server" class="table table-bordered">
                            <tr>
                                <th style="border-bottom: solid 1px gray;">Holiday Name</th>
                                <th style="border-bottom: solid 1px gray;">Day</th>
                                <th style="border-bottom: solid 1px gray;">Date</th>
                            </tr>

                            <tr>
                                <td>New Year's Day</td>
                                <td>Monday</td>
                                <td>01-January</td>
                            </tr>
                            <tr>
                                <td>Memorial Day</td>
                                <td>Monday</td>
                                <td>27-May</td>
                            </tr>
                            <tr>
                                <td>Independence Day</td>
                                <td>Thursday</td>
                                <td>04-July</td>
                            </tr>
                            <tr>
                                <td>Labor Day</td>
                                <td>Monday</td>
                                <td>02-September</td>
                            </tr>
                            <tr>
                                <td>Thanks Giving Day</td>
                                <td>Thursday</td>
                                <td>28-November</td>
                            </tr>
                            <tr>
                                <td>Christmas Day</td>
                                <td>Wednesday</td>
                                <td>25-December</td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
