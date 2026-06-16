<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="SelfLeaves.aspx.cs" Inherits="WebPortal.Admin.SelfLeaves" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #loader {
            border: 16px solid #f3f3f3;
            border-radius: 50%;
            border-top: 16px solid #3498db;
            width: 120px;
            height: 120px;
            -webkit-animation: spin 2s linear infinite;
            animation: spin 2s linear infinite;
            margin-left: 250px;
            margin-top: 250px;
        }


        @-webkit-keyframes spin {
            0% {
                -webkit-transform: rotate(0deg);
            }

            100% {
                -webkit-transform: rotate(360deg);
            }
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_paginate {
            float: left !important;
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
            /*background:linear-gradient(to bottom, #0070C0, 80%, #ffffff);*/
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
    </style>

    <script>

        $(document).ready(function () {
            selfleave_load();
        });

        document.addEventListener("DOMContentLoaded", function () {
            let tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);

            const minDate = tomorrow.toISOString().split("T")[0];

            document.getElementById("selfleave_fromdate").setAttribute("min", minDate);
        });

    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../Scripts/Functions/Leaves.js"></script>

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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Add Leaves</b></h6>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <div class="container-fluid">

                    <!-- Row 1 -->
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label><b>Leave Type:</b></label>
                            <select id="selfleave_leavetype" name="selfleave_leavetype" class="form-control" required>
                                <option value="">Select</option>
                                <option value="Personal">Personal</option>
                                <option value="Sick">Sick</option>
                                <option value="Casual">Casual</option>
                                <option value="Maternity/Paternity">Maternity/Paternity</option>
                                <option value="Marriage">Marriage</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label><b>Days:</b></label>
                            <select id="selfleave_days" name="selfleave_days" class="form-control" onchange="return selfleave_validatedates();" required>
                                <option value="0">Select</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                                <option value="13">13</option>
                                <option value="14">14</option>
                                <option value="15">15</option>
                                <option value="16">16</option>
                                <option value="17">17</option>
                                <option value="18">18</option>
                                <option value="19">19</option>
                                <option value="20">20</option>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label><b>From Date:</b></label>
                            <input type="date" id="selfleave_fromdate" name="selfleave_fromdate" class="form-control" onchange="return selfleave_validatedates();" />
                        </div>

                        <div class="col-md-3">
                            <label><b>To Date:</b></label>
                            <input type="date" id="selfleave_todate" name="selfleave_todate" class="form-control" style="background: white;" readonly />
                        </div>
                    </div>

                    <!-- Row 2 -->
                    <div class="row">
                        <div class="col-md-9">
                            <label><b>Reason:</b></label>
                            <textarea id="selfleave_reason" name="selfleave_reason" class="form-control" required></textarea>
                        </div>

                        <div class="col-md-3 d-flex align-items-end">
                            <button id="selfleave_btnsubmit" class="btn btn-primary w-100" onclick="return selfleave_Submit();">Submit</button>
                        </div>
                    </div>
                </div>

                <hr />
                <table class="table" id="selfleave_table" style="width: 100%;" data-order="">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Leave Type</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;"># of days</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">From Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">To Date</th>
                            <th class="sort border-top ps-3">Reason</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Added Date</th>
                            <th class="sort border-top ps-3">Status</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status Updated By</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Status Updated Date</th>
                            <th class="sort border-top ps-3">Remark</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="slefleave_waitingpanel" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
        <div class="modal-dialog text-center">
            <img src="../Images/Load.gif" />
            <br />
            <span style="color: #fff; font-size: 24px; font-weight: bold; font-style: italic;">System is sending email notification. Please wait</span>
            <span style="color: #fff; font-size: 48px; font-weight: bold; font-style: italic; animation: animate 1s linear infinite;">&nbsp;. . . .</span>
        </div>
    </div>

    <div class="modal fade" id="selfleave_dverror">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="selfleave_errmsg"></h6>
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>--%>
                </div>

                <div class="modal-footer align-content-center">
                    <button class="btn btn-primary" type="button" id="btnMessage" onclick="return selfleave_Message();">Okay</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</asp:Content>
