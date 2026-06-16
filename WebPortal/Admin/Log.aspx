<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Log.aspx.cs" Inherits="WebPortal.Admin.Log" %>
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

        label:not(.form-check-label):not(.custom-file-label) {
            font-weight: normal !important;
            border: none !important;
        }

        .dataTables_scroll {
            overflow: auto;
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
            background: linear-gradient(to bottom, #cbd0dd, 3%, #fff) !important;
            color: #000;
        }

        .table.dataTable tr td {
            background: none;
        }
        /*.form-control {
            font-size: 11px !important;
        }*/
    </style>
    <script>
        $(document).ready(function () {
            log_BindLogDetails();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Daily Log</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="DetailedAttendancePercentage.aspx" id="a1" runat="server" style="color: saddlebrown"> Detailed Attendance Percentage </a></li>
                        <li class="breadcrumb-item"><a href="DashboardEmployee.aspx" id="aBack" runat="server" style="color: saddlebrown"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title"></h5>
                <table class="table" id="log_table" style="width: 100%;">
                    <thead>
                        <tr>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Date</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">In Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Out Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Out</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break In</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Break Time</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Total Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Extra Hours</th>
                            <th class="sort border-top ps-3" style="text-wrap: nowrap;">Deducted Hours</th>
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
</asp:Content>
