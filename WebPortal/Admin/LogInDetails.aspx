<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="LogInDetails.aspx.cs" Inherits="WebPortal.Admin.LogInDetails" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">



    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

    <script src="~/Scripts/Functions/LogInDetails.js"></script>

    <script>
        $(document).ready(function () {

            refershGrid();
        });

        function refershGrid() {
            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            const urlParams = new URLSearchParams(window.location.search);

            const Code = urlParams.get('EmployeeID');

            if (Code == "" || Code == null)
                PMCode = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            else
                PMCode = Code;

            let date = new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-');

            New_BindLogGrid(date, PMCode);
        }

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-user-clock mr-2"></i>
                    Attendance Log
               
                </div>

                <div class="dashboard-subtitle">
                    View employee attendance records, check-in/check-out times, working hours, and attendance history.
               
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card modern-card">
            <div class="card-body modern-card-body modern-form">

                <!-- Card Container -->
                <div class="card shadow-sm border-0 custom-datatable-card">

                    <!-- Header -->
                    <div class="card-header d-flex justify-content-between align-items-center flex-wrap">

                        <!-- Status Filter -->
                        <div class="btn-group status-filter" data-toggle="buttons">

                            <label class="btn btn-all active">
                                <input type="radio" name="status" value="all" checked>All</label>
                            <label class="btn btn-active">
                                <input type="radio" name="status" value="active">Active</label>
                            <label class="btn btn-await">
                                <input type="radio" name="status" value="awaited">Awaited</label>
                            <label class="btn btn-leave">
                                <input type="radio" name="status" value="leave">On Leave</label>
                            <label class="btn btn-block">
                                <input type="radio" name="status" value="block">Blocked</label>
                            <label class="btn btn-abscond">
                                <input type="radio" name="status" value="abscond">
                                Absconded
                           
                            </label>

                        </div>
                        <div style="text-align: right;">
                            <button type="button" class="btn btn-soft" onclick="refershGrid(); return false;">
                                <i class="fas fa-sync-alt"></i>&nbsp; Refresh
                           
                            </button>
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="card-body modern-card-body modern-form">
                        <div class="table-responsive">

                            <div class="table-panel">
                                <table id="log" class="table custom-table align-middle nowrap table table-hover table-striped table-bordered" style="width: 100%">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Actions</th>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Cut Off Time</th>
                                            <th>In Time</th>
                                            <th>Out Time</th>
                                            <th>Latest Login Date</th>
                                            <th>IN IP</th>
                                            <th>Out IP</th>
                                            <th>Status</th>
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


    <!-- Stylish Modal -->
    <div class="modal fade custom-modal" id="blockunblock" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <!-- Header -->
                <div class="modal-header custom-modal-header">
                    <div>
                        <h1 class="modal-title mb-1" id="blockunblockLabel"></h1>
                    </div>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>

                <!-- Body -->
                <div class="modal-body px-4 py-4">
                    <div class="row">
                        <!-- Latest Login -->
                        <div class="col-md-6 mb-4">
                            <label class="custom-label">Latest Login Date</label>
                            <div id="lbllatestlogindate" class="custom-info-box"></div>
                        </div>

                        <!-- Current Status -->
                        <div class="col-md-6 mb-4">
                            <label class="custom-label">Current Status</label>
                            <div id="lblcurrentstatus" class="custom-info-box status-box"></div>
                        </div>

                        <!-- Remark -->
                        <div class="col-12">
                            <label class="custom-label">Remark</label>
                            <textarea id="remark" name="remark" rows="4" class="form-control custom-textarea" placeholder="Enter your remarks here..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="modal-footer border-0 px-4 pb-4">
                    <button type="button" class="btn btn-light custom-close-btn" data-dismiss="modal">Close</button>
                    <button class="btn custom-save-btn" type="button" id="btnApprove" onclick="setActions();">Confirm Action</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Popup Modal -->

    <%--  <div class="modal fade custom-modal" id="attendanceModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <!-- Header -->
                <div class="modal-header custom-modal-header">
                    <!-- Header -->

                    <h3>Attendance Details</h3>
                    <span class="close-btn" onclick="closeAttendancePopup()">&times;</span>
                </div>

                <!-- Employee Info Card -->
                <div class="employee-card">

                    <div class="info-box">
                        <span class="title">Code</span>
                        <label id="lblcode1" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box">
                        <span class="title">Name</span>
                        <label id="lblname1" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box">
                        <span class="title">Pseudoname</span>
                        <label id="lblPseudoname" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box report-link">
                        <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server">Proposed Salary Report
                </a>
                    </div>

                </div>

                <!-- Filter Section -->
                <div class="filter-section">

                    <div class="filter-item">
                        <label>Month</label>
                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="custom-dropdown">
                            <asp:ListItem Value="January">January</asp:ListItem>
                            <asp:ListItem Value="February">February</asp:ListItem>
                            <asp:ListItem Value="March">March</asp:ListItem>
                            <asp:ListItem Value="April">April</asp:ListItem>
                            <asp:ListItem Value="May">May</asp:ListItem>
                            <asp:ListItem Value="June">June</asp:ListItem>
                            <asp:ListItem Value="July">July</asp:ListItem>
                            <asp:ListItem Value="August">August</asp:ListItem>
                            <asp:ListItem Value="September">September</asp:ListItem>
                            <asp:ListItem Value="October">October</asp:ListItem>
                            <asp:ListItem Value="November">November</asp:ListItem>
                            <asp:ListItem Value="December">December</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-item">
                        <label>Year</label>
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="custom-dropdown"></asp:DropDownList>
                    </div>

                    <div class="filter-item">
                        <asp:Button ID="btnshow" runat="server" Text="Show" CssClass="show-btn" />
                    </div>

                </div>

                <!-- Grid -->
                <div class="table-container">
                    <asp:GridView ID="grdLog" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="table table-bordered table-hover custom-grid"
                        HeaderStyle-CssClass="grid-header">

                        <Columns>
                            <asp:BoundField DataField="Date" HeaderText="Date" />
                            <asp:BoundField DataField="InTime" HeaderText="In Time" />
                            <asp:BoundField DataField="OutTime" HeaderText="Out Time" />
                            <asp:BoundField DataField="ShiftTime" HeaderText="Hours" />
                            <asp:BoundField DataField="BreakOutTime" HeaderText="Break Out" />
                            <asp:BoundField DataField="BreakInTime" HeaderText="Break In" />
                            <asp:BoundField DataField="TotalBreakHours" HeaderText="Break Time" />
                            <asp:BoundField DataField="Hours" HeaderText="Total Hours" />
                            <asp:BoundField DataField="ExtraHours" HeaderText="Extra Hours" />
                            <asp:BoundField DataField="NoofHours" HeaderText="Deducted Hours" />
                            <asp:BoundField DataField="LateMark" HeaderText="Late Mark" />
                            <asp:BoundField DataField="Partial" HeaderText="Partial" />
                            <asp:BoundField DataField="ShiftRemark" HeaderText="Shift Remark" />
                            <asp:BoundField DataField="LeaveType" HeaderText="Day Status" />
                            <asp:BoundField DataField="INIP" HeaderText="In IP" />
                            <asp:BoundField DataField="OutIP" HeaderText="Out IP" />
                        </Columns>

                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>--%>


    <%--block unblock style--%>
    <style>
        /* =========================
   CARD DESIGN
========================= */

        .btn-soft {
            background: #eef4ff;
            color: #1f3c88;
            border: 1px solid #d9e6ff;
            border-radius: 10px;
            padding: 9px 18px;
            font-weight: 600;
        }


        .custom-datatable-card {
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }

            /* =========================
   HEADER
========================= */

            .custom-datatable-card .card-header {
                background: #cad1d2;
                padding: 18px 25px;
                border: none;
            }

            .custom-datatable-card h4 {
                color: #fff;
                font-size: 30px;
                margin: 0;
            }

        .dataTables_info {
            font-weight: 700;
            font-size: 14px;
            /*   margin-top: 0 !important;
            padding-top: 0 !important;*/
        }
        /* =========================
   STATUS BUTTONS
========================= */

        /* =========================
   STATUS FILTER CONTAINER
========================= */

        .status-filter {
            display: inline;
            gap: 10px;
            flex-wrap: wrap;
        }

            /* =========================
   COMMON BUTTON STYLE
========================= */

            .status-filter .btn {
                border: none;
                /* border-radius: 14px;*/
                padding: 10px 22px;
                font-size: 14px;
                font-weight: 400;
                color: #fff;
                transition: all 0.25s ease;
                position: relative;
                overflow: hidden;
                display: inline;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            }

                /* Hide Radio */
                .status-filter .btn input[type="radio"] {
                    /*  display: none;*/
                }

        /* =========================
   BUTTON COLORS
========================= */

        /* All */
        .btn-all {
            /*background: linear-gradient(135deg, #4b5563, #6b7280);*/
            background: linear-gradient(135deg, #0077cc, #0096FF);
        }

        /* Active */
        .btn-active {
            background: linear-gradient(135deg, #00751F, #00D138);
        }

        /* Awaited */
        .btn-await {
            background: linear-gradient(135deg, #d97706, #facc15);
            color: #fff;
        }

        /* Leave */
        .btn-leave {
            background: linear-gradient(135deg, #75006D, #D100C3);
            /*   background: linear-gradient(135deg, #D100C3, #FF2EF1);*/
            color: #fff;
        }

        /* Blocked */
        .btn-block {
            /*   background: linear-gradient(135deg, #334155, #475569);*/
            background: linear-gradient(135deg,#FF4800, #FFAB8A);
        }

        /* Absconded */
        .btn-abscond {
            /* background: linear-gradient(135deg, #b91c1c, #ef4444);*/
            background: linear-gradient(135deg, #D10000, #FF3131);
        }

        /* =========================
   HOVER EFFECT
========================= */

        .status-filter .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.15);
        }

        /* =========================
   ACTIVE BUTTON
========================= */

        .status-filter .btn.active {
            transform: scale(1.03);
            box-shadow: 0 0 0 3px rgba(255,255,255,0.35), 0 8px 20px rgba(0,0,0,0.18);
        }

        /* =========================
   OPTIONAL DOT INDICATOR
========================= */

        .status-filter .btn::before {
            content: '';
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255,255,255,0.9);
        }
        /* =========================
   TABLE
========================= */

        .custom-table {
            margin-bottom: 0;
        }

            .custom-table thead th {
                background: #f8f9fa;
                color: #222;
                font-weight: 700;
                border-top: none !important;
                border-bottom: 2px solid #dee2e6;
                padding: 14px 16px;
                white-space: nowrap;
            }

            .custom-table tbody td {
                padding: 14px 16px;
                vertical-align: middle;
                border-color: #ececec;
                white-space: nowrap;
            }

            .custom-table tbody tr:hover {
                background: #f5fbff;
                transition: 1.01s;
            }

        /* =========================
   STATUS BADGES
========================= */

        .badge-status {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: #fff;
        }

        .badge-active {
            /* background: #28a745;*/
            background: linear-gradient(135deg, #15803d, #22c55e);
        }

        .badge-await {
            /*  background: #ffc107; color: #000;*/
            background: linear-gradient(135deg, #d97706, #facc15);
        }

        .badge-leave {
            background: linear-gradient(135deg, #75006D, #D100C3);
        }

        .badge-abscond {
            background: linear-gradient(135deg, #b91c1c, #ef4444);
        }

        /* Blocked Badge */
        .badge-block {
            /*background: #5bc8c1;*/ /*#6f42c1;*/
            background: linear-gradient(135deg, #FF4800, #FF8A5C);
        }
        /* =========================
   ACTION BUTTON
========================= */

        .btn-manage {
            background: #20c997;
            color: #fff;
            border: none;
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
        }

            .btn-manage:hover {
                background: #18b086;
                color: #fff;
            }

        /* =========================
   DATATABLE CUSTOM
========================= */

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #ced4da;
            border-radius: 5px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_length select {
            width: 50px !important;
            border-radius: 5px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #003b57 !important;
            color: #fff !important;
            border: none !important;
            text-align: right !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #0d6efd !important;
            color: #fff !important;
        }
    </style>

    <style>
        /* Dropdown Design */

        .dropdown-menu {
            border: none;
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.12);
            padding: 8px 0;
        }

        .dropdown-item:hover {
            background: #f4f8fb;
        }

        /* Disabled */

        .dropdown-item.disabled,
        .dropdown-item:disabled {
            opacity: 0.6;
            pointer-events: none;
        }

        /* Pagination */

        .dataTables_paginate {
            /* margin-top: 10px !important;*/
        }

        .dataTables_info {
            padding-top: 15px !important;
        }

        /* Search Box */

        .dataTables_filter input {
            height: 38px;
            min-width: 240px;
        }

        /* Length Dropdown */

        .dataTables_length select {
            height: 38px;
        }

        /* Responsive */

        .table-responsive {
            overflow-x: auto;
        }

        .status-filter label {
            margin-right: 15px;
            font-weight: 500;
            cursor: pointer;
        }

        .status-filter input {
            margin-right: 6px;
        }
    </style>

    <style>
        /* =========================
   MODAL CONTAINER
========================= */

        .custom-modal .modal-content {
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
        }

        /* =========================
   HEADER
========================= */

        .custom-modal-header {
            /* background: linear-gradient(135deg, #003b57, #005b87);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            padding: 20px 25px;
            border-bottom: none;
        }

            .custom-modal-header .modal-title {
                color: #fff;
                font-weight: 700;
                font-size: 24px;
            }

            .custom-modal-header .close {
                font-size: 28px;
                opacity: 1;
                outline: none;
            }

        /* =========================
   LABELS
========================= */

        .custom-label {
            font-size: 13px;
            font-weight: 700;
            color: #6c757d;
            margin-bottom: 8px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* =========================
   INFO BOXES
========================= */

        .custom-info-box {
            min-height: 46px;
            background: #f8f9fb;
            border: 1px solid #e3e6ea;
            border-radius: 8px;
            padding: 12px 14px;
            font-size: 15px;
            color: #212529;
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        /* =========================
   STATUS BOX
========================= */

        .status-box {
            font-weight: 700;
            color: #198754;
        }

        /* =========================
   TEXTAREA
========================= */

        .custom-textarea {
            border-radius: 10px;
            border: 1px solid #dce1e7;
            padding: 12px 14px;
            resize: none;
            font-size: 14px;
            transition: 0.3s;
        }

            .custom-textarea:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.15rem rgba(13,110,253,.15);
            }

        /* =========================
   FOOTER BUTTONS
========================= */

        .custom-close-btn {
            padding: 10px 22px;
            border-radius: 8px;
            font-weight: 600;
        }

        .custom-save-btn {
            background: linear-gradient(135deg, #0d6efd, #0056d2);
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.3s;
        }

            .custom-save-btn:hover {
                background: linear-gradient(135deg, #0056d2, #0041a8);
                color: #fff;
            }

        /* =========================
   MOBILE RESPONSIVE
========================= */

        @media (max-width: 768px) {

            .custom-modal-header {
                padding: 18px;
            }

            .custom-modal .modal-body {
                padding: 20px !important;
            }

            .custom-save-btn,
            .custom-close-btn {
                width: 100%;
            }

            .modal-footer {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />

    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>

    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>

</asp:Content>






<%--<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background: #f4f7fb;
        }

        .dashboard-header {
            background: linear-gradient(90deg, #1f3c88 0%, #2575fc 55%, #1bc5e8 100%);
            border-radius: 15px;
            padding: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

            .dashboard-header::after {
                content: '';
                position: absolute;
                right: -70px;
                top: -50px;
                width: 220px;
                height: 220px;
                background: rgba(255,255,255,0.12);
                border-radius: 50%;
            }

        .dashboard-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .dashboard-subtitle {
            font-size: 12px;
            opacity: 0.9;
            /*text-transform: uppercase;*/
        }
    </style>

    <script src="~/Scripts/Functions/LogInDetails.js"></script>

    <script>
        $(document).ready(function () {

            var currentUserName = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';

            const urlParams = new URLSearchParams(window.location.search);

            const Code = urlParams.get('EmployeeID');

            if (Code == "" || Code == null)
                PMCode = '<%= HttpContext.Current.User.Identity.Name.ToString() %>';
            else
                PMCode = Code;

            let date = new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-');

            New_BindLogGrid(date, PMCode);
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="dashboard-header">
        <div class="d-flex justify-content-between align-items-start mb-1">
            <div>
                <div class="dashboard-title">
                    <i class="fas fa-user-clock mr-2"></i>
                    Attendance Log
                </div>

                <div class="dashboard-subtitle">
                    View employee attendance records, check-in/check-out times, working hours, and attendance history.
                </div>

            </div>
        </div>
    </div>



    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">

                <!-- Card Container -->
                <div class="card shadow-sm border-0 custom-datatable-card">

                    <!-- Header -->
                    <div class="card-header d-flex justify-content-between align-items-center flex-wrap">

                        <!-- Status Filter -->
                        <div class="btn-group status-filter" data-toggle="buttons">

                            <label class="btn btn-all active">
                                <input type="radio" name="status" value="all" checked>All</label>
                            <label class="btn btn-active">
                                <input type="radio" name="status" value="active">Active</label>
                            <label class="btn btn-await">
                                <input type="radio" name="status" value="awaited">Awaited</label>
                            <label class="btn btn-leave">
                                <input type="radio" name="status" value="leave">On Leave</label>
                            <label class="btn btn-block">
                                <input type="radio" name="status" value="block">Blocked</label>
                            <label class="btn btn-abscond">
                                <input type="radio" name="status" value="abscond">
                                Absconded
                            </label>

                        </div>
                    </div>

                    <!-- Table -->
                    <div class="card-body">
                        <div class="table-responsive">

                            <table id="log" class="table custom-table align-middle nowrap" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Actions</th>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Cut Off Time</th>
                                        <th>In Time</th>
                                        <th>Out Time</th>
                                        <th>Latest Login Date</th>
                                        <th>IN IP</th>
                                        <th>Out IP</th>
                                        <th>Status</th>
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


    <!-- Stylish Modal -->
    <div class="modal fade custom-modal" id="blockunblock" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <!-- Header -->
                <div class="modal-header custom-modal-header">
                    <div>
                        <h1 class="modal-title mb-1" id="blockunblockLabel"></h1>
                    </div>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                </div>

                <!-- Body -->
                <div class="modal-body px-4 py-4">
                    <div class="row">
                        <!-- Latest Login -->
                        <div class="col-md-6 mb-4">
                            <label class="custom-label">Latest Login Date</label>
                            <div id="lbllatestlogindate" class="custom-info-box"></div>
                        </div>

                        <!-- Current Status -->
                        <div class="col-md-6 mb-4">
                            <label class="custom-label">Current Status</label>
                            <div id="lblcurrentstatus" class="custom-info-box status-box"></div>
                        </div>

                        <!-- Remark -->
                        <div class="col-12">
                            <label class="custom-label">Remark</label>
                            <textarea id="remark" name="remark" rows="4" class="form-control custom-textarea" placeholder="Enter your remarks here..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="modal-footer border-0 px-4 pb-4">
                    <button type="button" class="btn btn-light custom-close-btn" data-dismiss="modal">Close</button>
                    <button class="btn custom-save-btn" type="button" id="btnApprove" onclick="setActions();">Confirm Action</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Popup Modal -->

  <%--  <div class="modal fade custom-modal" id="attendanceModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <!-- Header -->
                <div class="modal-header custom-modal-header">
                    <!-- Header -->

                    <h3>Attendance Details</h3>
                    <span class="close-btn" onclick="closeAttendancePopup()">&times;</span>
                </div>

                <!-- Employee Info Card -->
                <div class="employee-card">

                    <div class="info-box">
                        <span class="title">Code</span>
                        <label id="lblcode1" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box">
                        <span class="title">Name</span>
                        <label id="lblname1" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box">
                        <span class="title">Pseudoname</span>
                        <label id="lblPseudoname" runat="server" class="label-text"></label>
                    </div>

                    <div class="info-box report-link">
                        <a href="ProposedSalaryReport.aspx" id="aProposed" runat="server">Proposed Salary Report
                </a>
                    </div>

                </div>

                <!-- Filter Section -->
                <div class="filter-section">

                    <div class="filter-item">
                        <label>Month</label>
                        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="custom-dropdown">
                            <asp:ListItem Value="January">January</asp:ListItem>
                            <asp:ListItem Value="February">February</asp:ListItem>
                            <asp:ListItem Value="March">March</asp:ListItem>
                            <asp:ListItem Value="April">April</asp:ListItem>
                            <asp:ListItem Value="May">May</asp:ListItem>
                            <asp:ListItem Value="June">June</asp:ListItem>
                            <asp:ListItem Value="July">July</asp:ListItem>
                            <asp:ListItem Value="August">August</asp:ListItem>
                            <asp:ListItem Value="September">September</asp:ListItem>
                            <asp:ListItem Value="October">October</asp:ListItem>
                            <asp:ListItem Value="November">November</asp:ListItem>
                            <asp:ListItem Value="December">December</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-item">
                        <label>Year</label>
                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="custom-dropdown"></asp:DropDownList>
                    </div>

                    <div class="filter-item">
                        <asp:Button ID="btnshow" runat="server" Text="Show" CssClass="show-btn" />
                    </div>

                </div>

                <!-- Grid -->
                <div class="table-container">
                    <asp:GridView ID="grdLog" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="table table-bordered table-hover custom-grid"
                        HeaderStyle-CssClass="grid-header">

                        <Columns>
                            <asp:BoundField DataField="Date" HeaderText="Date" />
                            <asp:BoundField DataField="InTime" HeaderText="In Time" />
                            <asp:BoundField DataField="OutTime" HeaderText="Out Time" />
                            <asp:BoundField DataField="ShiftTime" HeaderText="Hours" />
                            <asp:BoundField DataField="BreakOutTime" HeaderText="Break Out" />
                            <asp:BoundField DataField="BreakInTime" HeaderText="Break In" />
                            <asp:BoundField DataField="TotalBreakHours" HeaderText="Break Time" />
                            <asp:BoundField DataField="Hours" HeaderText="Total Hours" />
                            <asp:BoundField DataField="ExtraHours" HeaderText="Extra Hours" />
                            <asp:BoundField DataField="NoofHours" HeaderText="Deducted Hours" />
                            <asp:BoundField DataField="LateMark" HeaderText="Late Mark" />
                            <asp:BoundField DataField="Partial" HeaderText="Partial" />
                            <asp:BoundField DataField="ShiftRemark" HeaderText="Shift Remark" />
                            <asp:BoundField DataField="LeaveType" HeaderText="Day Status" />
                            <asp:BoundField DataField="INIP" HeaderText="In IP" />
                            <asp:BoundField DataField="OutIP" HeaderText="Out IP" />
                        </Columns>

                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>--%>


<%--block unblock style
    <style>
        /* =========================
   CARD DESIGN
========================= */

        .custom-datatable-card {
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }

            /* =========================
   HEADER
========================= */

            .custom-datatable-card .card-header {
                background: #cad1d2;
                padding: 18px 25px;
                border: none;
            }

            .custom-datatable-card h4 {
                color: #fff;
                font-size: 30px;
                margin: 0;
            }

        .dataTables_info {
            font-weight: 700;
            font-size: 14px;
            /*   margin-top: 0 !important;
            padding-top: 0 !important;*/
        }
        /* =========================
   STATUS BUTTONS
========================= */

        /* =========================
   STATUS FILTER CONTAINER
========================= */

        .status-filter {
            display: inline;
            gap: 10px;
            flex-wrap: wrap;
        }

            /* =========================
   COMMON BUTTON STYLE
========================= */

            .status-filter .btn {
                border: none;
                /* border-radius: 14px;*/
                padding: 10px 22px;
                font-size: 14px;
                font-weight: 400;
                color: #fff;
                transition: all 0.25s ease;
                position: relative;
                overflow: hidden;
                display: inline;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            }

                /* Hide Radio */
                .status-filter .btn input[type="radio"] {
                    /*  display: none;*/
                }

        /* =========================
   BUTTON COLORS
========================= */

        /* All */
        .btn-all {
            /*background: linear-gradient(135deg, #4b5563, #6b7280);*/
            background: linear-gradient(135deg, #0077cc, #0096FF);
        }

        /* Active */
        .btn-active {
            background: linear-gradient(135deg, #00751F, #00D138);
        }

        /* Awaited */
        .btn-await {
            background: linear-gradient(135deg, #d97706, #facc15);
            color: #fff;
        }

        /* Leave */
        .btn-leave {
            background: linear-gradient(135deg, #75006D, #D100C3);
            /*   background: linear-gradient(135deg, #D100C3, #FF2EF1);*/
            color: #fff;
        }

        /* Blocked */
        .btn-block {
            /*   background: linear-gradient(135deg, #334155, #475569);*/
            background: linear-gradient(135deg,#FF4800, #FFAB8A);
        }

        /* Absconded */
        .btn-abscond {
            /* background: linear-gradient(135deg, #b91c1c, #ef4444);*/
            background: linear-gradient(135deg, #D10000, #FF3131);
        }

        /* =========================
   HOVER EFFECT
========================= */

        .status-filter .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.15);
        }

        /* =========================
   ACTIVE BUTTON
========================= */

        .status-filter .btn.active {
            transform: scale(1.03);
            box-shadow: 0 0 0 3px rgba(255,255,255,0.35), 0 8px 20px rgba(0,0,0,0.18);
        }

        /* =========================
   OPTIONAL DOT INDICATOR
========================= */

        .status-filter .btn::before {
            content: '';
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: rgba(255,255,255,0.9);
        }
        /* =========================
   TABLE
========================= */

        .custom-table {
            margin-bottom: 0;
        }

            .custom-table thead th {
                background: #f8f9fa;
                color: #222;
                font-weight: 700;
                border-top: none !important;
                border-bottom: 2px solid #dee2e6;
                padding: 14px 16px;
                white-space: nowrap;
            }

            .custom-table tbody td {
                padding: 14px 16px;
                vertical-align: middle;
                border-color: #ececec;
                white-space: nowrap;
            }

            .custom-table tbody tr:hover {
                background: #f5fbff;
                transition: 1.01s;
            }

        /* =========================
   STATUS BADGES
========================= */

        .badge-status {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            color: #fff;
        }

        .badge-active {
            /* background: #28a745;*/
            background: linear-gradient(135deg, #15803d, #22c55e);
        }

        .badge-await {
            /*  background: #ffc107; color: #000;*/
            background: linear-gradient(135deg, #d97706, #facc15);
        }

        .badge-leave {
            background: linear-gradient(135deg, #75006D, #D100C3);
        }

        .badge-abscond {
            background: linear-gradient(135deg, #b91c1c, #ef4444);
        }

        /* Blocked Badge */
        .badge-block {
            /*background: #5bc8c1;*/ /*#6f42c1;*/
            background: linear-gradient(135deg, #FF4800, #FF8A5C);
        }
        /* =========================
   ACTION BUTTON
========================= */

        .btn-manage {
            background: #20c997;
            color: #fff;
            border: none;
            padding: 6px 14px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
        }

            .btn-manage:hover {
                background: #18b086;
                color: #fff;
            }

        /* =========================
   DATATABLE CUSTOM
========================= */

        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #ced4da;
            border-radius: 5px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_length select {
            width: 50px !important;
            border-radius: 5px;
            padding: 6px 10px;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #003b57 !important;
            color: #fff !important;
            border: none !important;
            text-align: right !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #0d6efd !important;
            color: #fff !important;
        }
    </style>

    <style>
        /* Dropdown Design */

        .dropdown-menu {
            border: none;
            border-radius: 8px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.12);
            padding: 8px 0;
        }

        .dropdown-item:hover {
            background: #f4f8fb;
        }

        /* Disabled */

        .dropdown-item.disabled,
        .dropdown-item:disabled {
            opacity: 0.6;
            pointer-events: none;
        }

        /* Pagination */

        .dataTables_paginate {
            /* margin-top: 10px !important;*/
        }

        .dataTables_info {
            padding-top: 15px !important;
        }

        /* Search Box */

        .dataTables_filter input {
            height: 38px;
            min-width: 240px;
        }

        /* Length Dropdown */

        .dataTables_length select {
            height: 38px;
        }

        /* Responsive */

        .table-responsive {
            overflow-x: auto;
        }

        .status-filter label {
            margin-right: 15px;
            font-weight: 500;
            cursor: pointer;
        }

        .status-filter input {
            margin-right: 6px;
        }
    </style>

    <style>
        /* =========================
   MODAL CONTAINER
========================= */

        .custom-modal .modal-content {
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
        }

        /* =========================
   HEADER
========================= */

        .custom-modal-header {
            /* background: linear-gradient(135deg, #003b57, #005b87);*/
            background: linear-gradient(to right, #90caf9, 10%, #047edf);
            padding: 20px 25px;
            border-bottom: none;
        }

            .custom-modal-header .modal-title {
                color: #fff;
                font-weight: 700;
                font-size: 24px;
            }

            .custom-modal-header .close {
                font-size: 28px;
                opacity: 1;
                outline: none;
            }

        /* =========================
   LABELS
========================= */

        .custom-label {
            font-size: 13px;
            font-weight: 700;
            color: #6c757d;
            margin-bottom: 8px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* =========================
   INFO BOXES
========================= */

        .custom-info-box {
            min-height: 46px;
            background: #f8f9fb;
            border: 1px solid #e3e6ea;
            border-radius: 8px;
            padding: 12px 14px;
            font-size: 15px;
            color: #212529;
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        /* =========================
   STATUS BOX
========================= */

        .status-box {
            font-weight: 700;
            color: #198754;
        }

        /* =========================
   TEXTAREA
========================= */

        .custom-textarea {
            border-radius: 10px;
            border: 1px solid #dce1e7;
            padding: 12px 14px;
            resize: none;
            font-size: 14px;
            transition: 0.3s;
        }

            .custom-textarea:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.15rem rgba(13,110,253,.15);
            }

        /* =========================
   FOOTER BUTTONS
========================= */

        .custom-close-btn {
            padding: 10px 22px;
            border-radius: 8px;
            font-weight: 600;
        }

        .custom-save-btn {
            background: linear-gradient(135deg, #0d6efd, #0056d2);
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.3s;
        }

            .custom-save-btn:hover {
                background: linear-gradient(135deg, #0056d2, #0041a8);
                color: #fff;
            }

        /* =========================
   MOBILE RESPONSIVE
========================= */

        @media (max-width: 768px) {

            .custom-modal-header {
                padding: 18px;
            }

            .custom-modal .modal-body {
                padding: 20px !important;
            }

            .custom-save-btn,
            .custom-close-btn {
                width: 100%;
            }

            .modal-footer {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />

    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>

    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>

</asp:Content>--%>
