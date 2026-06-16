<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceReportMarketing.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceReportMarketing" %>

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

   <%-- <link href="../dist/multi/chosen.css" rel="stylesheet" />
    <link href="../dist/multi/chosen.min.css" rel="stylesheet" />
    <script src="../dist/multi/chosen.jquery.min.js"></script>
    <script src="../dist/multi/chosen.proto.min.js"></script>--%>

    <script>

        $(document).ready(function () {

            //uprMark_BindSummaryGrid("26-Jun-2025", "25-Jul-2025");
            //uprMark_BindProductionGrid("26-Jun-2025", "25-Jul-2025");
            //uprMark_BindAttendanceGrid("26-Jun-2025", "25-Jul-2025");
        });
            
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  <%-- <asp:Button ID="btnMarketing" runat="server" Style="display: none;" OnClick="btnMarketing_Click" />--%>
    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Performance Report Marketing</b></h6>
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
                            <input type="date" id="uprMark_fromdate" name="uprMark_fromdate" class="form-control" style="width: 250px;" />
                        </td>
                        <td><b>To Date:</b></td>
                        <td>
                            <input type="date" id="uprMark_todate" name="uprMark_todate" class="form-control" style="width: 250px;" />
                        </td>
                        <td>
                            <button id="uprMark_btnsubmit"  type="button" name="uprMark_btnsubmit" onclick="return uprMark_submit();" class="btn btn-primary">Show</button>
                            <button id="uprMark_btnexport" type="button" name="uprMark_btnsubmit" onclick="return uprMark_export();" class="btn btn-primary">Export to excel</button>
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
                                <a class="nav-link" id="custom-tabs-one-profile-tab" data-toggle="pill" href="#custom-tabs-one-profile" role="tab" aria-controls="custom-tabs-one-profile" aria-selected="false">Production Details</a>
                            </li>
                            <li class="nav-item"><%--onclick="uprMark_getAttendanceDetails();" onclick="uprMark_getProdDetails();"--%>
                                <a class="nav-link" id="custom-tabs-one-attendance-tab" data-toggle="pill" href="#custom-tabs-one-attendance" role="tab" aria-controls="custom-tabs-one-attendance" aria-selected="false">Attendance Details</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-one-home" role="tabpanel" aria-labelledby="custom-tabs-one-home-tab">
                                <table class="table table-bordered" id="table_uprSummaryMark" style="width: 100%;">
                                    <thead>
                                        <tr>
                                          <%--  <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Month</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Year</th>--%>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Pseudo Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Count</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Quality Grade</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance %</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Attendance Grade</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>

                            </div>
                            <div class="tab-pane fade" id="custom-tabs-one-profile" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <table class="table table-bordered" id="uprMark_tableprod" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Code</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Name</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Date</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Domain</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Criteria</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Target</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Production</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Leads</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Time Spent</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Source</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Remark</th>
                                            <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;">Added Date</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>

                            <div class="tab-pane fade show" id="custom-tabs-one-attendance" role="tabpanel" aria-labelledby="custom-tabs-one-attendance-tab">
                                <table class="table table-bordered" id="uprMark_attendancetable" style="width: 100%;">
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
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;" id="spnMarktext">System is updating details. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

</asp:Content>
