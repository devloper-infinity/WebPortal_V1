<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DailyLogin.aspx.cs" Inherits="WebPortal.Admin.DailyLogin" %>

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

        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dt-buttons {
            display: flex;
            align-items: center;
        }

        .dataTables_wrapper .dataTables_length {
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
        }

        .table.dataTable th {
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }

        .stat-card {
            border-radius: 10px;
            padding: 14px 18px;
            height: 70px;
            color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all .2s;
        }

            .stat-card:hover {
                transform: translateY(-2px);
            }

        .stat-title {
            font-size: 13px;
            opacity: .9;
        }

        .stat-value {
            font-size: 22px;
            font-weight: 600;
            margin-top: 2px;
        }

        /* SaaS colors */

        .bg-total {
            background: linear-gradient(135deg,#4f8dfd,#3b6df6);
        }

        .bg-working {
            background: linear-gradient(135deg,#28c76f,#1fa55b);
        }

        .bg-holiday {
            background: linear-gradient(135deg,#ffb020,#f59e0b);
        }

        .bg-partial {
            background: linear-gradient(135deg,#00cfe8,#0097b2);
        }

        .bg-latemark {
            background: linear-gradient(135deg,#ff6b6b,#ef4444);
        }

        .bg-absent {
            background: linear-gradient(135deg,#f87171,#dc2626);
        }

        .login-panel {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f7f8fb;
            padding: 12px 18px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            margin-bottom: 15px;
        }

        .login-left {
            display: flex;
            gap: 30px;
        }

        #trAfter {
            display: flex;
            align-items: center;
            gap: 40px;
        }

        .time-block {
            display: inline-block;
        }

        .login-label {
            font-size: 13px;
            color: #777;
        }

        .login-time {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
        }

        .login-actions button {
            margin-left: 8px;
        }

        .error-box {
            text-align: center;
            padding: 12px 20px;
            margin: 10px auto 20px auto;
            max-width: 500px;
            background: #fdecea;
            border: 1px solid #f5c2c7;
            color: #b02a37;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>

    <script>
        $(document).ready(function () {
            loginout_BindWorkingDetails();
            //loginout_BindLogDetails();
            updateTime();
            setInterval(updateTime, 1000);
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Daily Login/Logout</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body" id="loginout_main">
                <div id="dvError" class="error-box" style="display: none;">
                    <asp:Label ID="lblError"></asp:Label>
                </div>
                <div class="login-panel">

                    <div class="login-left">

                        <div id="trBefore" class="time-block" style="display: none;">
                            <span class="login-label">Login Time</span>
                            <span id="currentTime" class="login-time"></span>
                        </div>

                        <div id="trAfter" class="time-block" style="display: none;">
                            <div class="time-block">
                                <span class="login-label">Current Login</span>
                                <span id="SpnCurrentLogin" class="login-time"></span>
                            </div>

                            <div id="trAfter2" class="time-block">
                                <span class="login-label" id="bUptoTime">Upto Time</span>
                                <span id="SpnUptoTime" class="login-time"></span>
                            </div>
                        </div>
                    </div>

                    <div class="login-actions">

                        <button id="loginout_btnlogin" class="btn btn-success btn-sm" onclick="return loginout_login();">
                            <i class="uil uil-sign-in-alt"></i>Login
                        </button>

                        <button id="loginout_btnlogout" class="btn btn-danger btn-sm" onclick="return loginout_logout();">
                            <i class="uil uil-sign-out-alt"></i>Logout
                        </button>

                    </div>

                </div>
                <span id="spnNotLoggedOut" style="color: red; display: none; font-size: 14px; padding-bottom: 10px; font-weight: bold;">You have not logged out from last session. Please send request to your reporting manager for logout within 48 hours.</span>
                <div class="row align-items-center" style="padding-top: 20px; text-align: center;">

                    <div class="col-md-2">
                        <div class="stat-card bg-total">
                            <div class="stat-title">Total Days</div>
                            <div class="stat-value" id="spnTotalDays"></div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="stat-card bg-working">
                            <div class="stat-title">Working</div>
                            <div class="stat-value" id="spnWorking"></div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="stat-card bg-holiday">
                            <div class="stat-title">Holidays</div>
                            <div class="stat-value" id="spnHolidays"></div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="stat-card bg-partial">
                            <div class="stat-title">Partial</div>
                            <div class="stat-value" id="spnPartial"></div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="stat-card bg-latemark">
                            <div class="stat-title">Late Mark</div>
                            <div class="stat-value" id="spnLateMark"></div>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="stat-card bg-absent">
                            <div class="stat-title">Absent</div>
                            <div class="stat-value" id="spnAbsent"></div>
                        </div>
                    </div>

                </div>

                <hr />
                <table class="table" id="loginout_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Extra Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Late mark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Partial</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Shift Remark</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Day Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In IP</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out IP</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spntext">Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>
</asp:Content>
