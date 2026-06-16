<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="DasboardPerformanceDetails.aspx.cs" Inherits="WebPortal.Admin.DasboardPerformanceDetails" %>

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
        /*.form-control {
     font-size: 11px !important;
 }*/
    </style>
    <script>
        $(document).ready(function () {
            GetDashboardPerformanceDetails();
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
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Performance Details</b></h6>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right" style="font-size: 12px; font-weight: bold;">
                        <li class="breadcrumb-item"><a href="#utl" id="aBack" runat="server" style="color: saddlebrown" onclick="window.history.go(-1); return false;"><< Go back </a></li>

                    </ol>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <table id="dup_table" class="table table-bordered" style="width: 100%; text-align: center;">
                    <thead>
                        <tr>
                            <th>Month-Year</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Joining Date</th>
                            <th>Tenure with company</th>
                            <th># Days Worked</th>
                            <th>Total Production</th>
                            <th>Expected Productivity</th>
                            <th>Avg Target</th>
                            <th>Internal Error</th>
                            <th>Client Error</th>
                            <th>Total Error</th>
                            <th>Appreciations</th>
                            <th>Warnings</th>
                            <th>Production %</th>
                            <th>Accuracy %</th>
                            <th>Attendance %</th>
                            <th style="background: salmon;">Production Grade</th>
                            <th style="background: salmon;">QA Grade</th>
                            <th style="background: salmon;">Attendance Grade</th>
                        </tr>
                    </thead>
                    <tbody id="tblIncrementBody_DUP">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
