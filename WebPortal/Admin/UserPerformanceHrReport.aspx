<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceHrReport.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceHrReport" %>

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
            float: right;
            text-align: right;
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

        table.dataTable thead th {
            white-space: normal !important;
            word-wrap: break-word;
            text-align: left !important;
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

    <%--    
    <style>
        /* ===== CARD ===== */
        .card {
            border: 1px solid #dee2e6;
            border-radius: 0;
            box-shadow: none;
        }

        /* ===== MAIN TABS ===== */
        .nav-tabs {
            border-bottom: 1px solid #dee2e6;
        }

            .nav-tabs .nav-link {
                border: none;
                background: transparent;
                color: #495057;
                padding: 8px 14px;
                font-weight: 500;
                transition: background 0.2s ease;
            }

                /* Hover (very light) */
                .nav-tabs .nav-link:hover {
                    background: #f8f9fa;
                }

                /* Active tab (flat underline only) */
                .nav-tabs .nav-link.active {
                    color: #000;
                    background: transparent;
                    border-bottom: 2px solid #000;
                }

        /* ===== SUB TABS ===== */
        .card-tabs .nav-link {
            border: none;
            background: transparent;
            color: #6c757d;
          /*  padding: 6px 12px;*/
        }

            .card-tabs .nav-link:hover {
                background: #f8f9fa;
            }

            .card-tabs .nav-link.active {
                color: #000;
                border-bottom: 2px solid #000;
            }

        /* ===== TABLE ===== */
        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

            /* Header */
            .table thead th {
                background: #f5f5f5;
                border: 1px solid #dee2e6;
                font-weight: 600;
                text-align: center;
                white-space: nowrap;
            }

            /* Body */
            .table td {
                border: 1px solid #dee2e6;
                padding: 6px;
                text-align: center;
            }

            /* Light hover */
            .table tbody tr:hover {
                background: #fafafa;
            }

        /* ===== CONTENT ANIMATION (minimal) ===== */
        .tab-pane {
            animation: fadeIn 0.2s ease;
        }

        /* ===== RESPONSIVE ===== */
        .table-responsive {
            overflow-x: auto;
        }

        /* ===== SIMPLE ANIMATION ===== */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        /* ===== MOBILE ===== */
        @media (max-width: 768px) {
            .nav-tabs .nav-link {
                padding: 6px 10px;
                font-size: 13px;
            }

            .table {
                font-size: 12px;
            }

            .card-body {
                padding: 10px;
            }
        }
    </style>--%>

    <script>

        $(document).ready(function () {

            $("#hrUser_fromDate").val("2025-03-26");
            $("#hrUser_toDate").val("2025-04-25");

            //$("#hrUser_fromDate").datepicker("setDate", new Date(2026, 0, 26)); // Month is 0-indexed

            //$("#hrUser_fromDate").val("01/26/2026");
            //$("#hrUser_toDate").val("02/25/2026");
        });


        function showData() {

            fromDate = $("#hrUser_fromDate").val();
            toDate = $("#hrUser_toDate").val();

            // fromDate = "26-Jan-2026";
            // toDate = "25-Feb-2026";

            if (!fromDate || !toDate) {
                alert("Select dates");
                return;
            }

            NonDD_summary_bindGrid(fromDate, toDate);
        }

    </script>
   <%-- <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--    <asp:Button ID="btnhr1" runat="server" Style="display: none;" OnClick="btnhr1_Click" />--%>

    <div class="loading" id="load1">
        <img src="../images/Load_1.gif" />
        <div style="font-size: 12px; font-weight: bold;">One moment, please . . . .</div>
    </div>

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>User Performance HR Report</b></h6>
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
                        <td>
                            <b>From Date :</b>
                        </td>
                        <td>
                            <input type="date" id="hrUser_fromDate" class="form-control">
                        </td>
                        <td>
                            <b>To Date :</b>
                        </td>
                        <td>
                            <input type="date" id="hrUser_toDate" class="form-control">
                        </td>
                        <td>
                            <button type="button" class="btn btn-primary" onclick="showData();">Show</button>
                            <button type="button" class="btn btn-success" onclick="exportAllDataTables()">Export All Excel</button>
                        </td>
                    </tr>
                </table>
                <hr />
                <div class="card card-tabs">
                    <div class="card-header p-0 pt-1">
                        <ul class="nav nav-tabs" id="custom-tabs-main-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="custom-tabs-main-nonDD-tab" data-toggle="pill" href="#custom-tabs-main-nonDD" role="tab" aria-controls="custom-tabs-main-nonDD" aria-selected="true">Non-DD</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-profile-tab" data-toggle="pill" onclick="cred_summary_bindGrid();" href="#custom-tabs-main-Crdit" role="tab" aria-controls="custom-tabs-main-Crdit" aria-selected="false">Credit</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="custom-tabs-main-feedback-tab" data-toggle="pill" onclick="serv_summary_bindGrid();" href="#custom-tabs-main-Servicing" role="tab" aria-controls="custom-tabs-main-Servicing" aria-selected="false">Servicing</a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="custom-tabs-one-tabContent">
                            <div class="tab-pane fade show active" id="custom-tabs-main-nonDD" role="tabpanel" aria-labelledby="custom-tabs-main-nonDD-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_1" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-nonDD-tab-1" onclick="NonDD_summary_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-1" role="tab" aria-controls="custom-tabs-nonDD" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-2" onclick="NonDD_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-2" role="tab" aria-controls="custom-tabs-nonDD_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-3" onclick="NonDD_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-3" role="tab" aria-controls="custom-tabs-nonDD_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-nonDD-tab-4" onclick="NonDD_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-nonDD-sub-4" role="tab" aria-controls="custom-tabs-nonDD_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-nonDD">
                                            <div class="tab-pane fade show active" id="custom-tabs-nonDD-sub-1" role="tabpanel" aria-labelledby="custom-tabs-nonDD">
                                                <div class="table-responsive">
                                                    <table class="table" id="table_nondd_Summary" style="width: 100%">
                                                        <thead> </thead>
                                                        <tbody></tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-2" role="tabpanel" aria-labelledby="custom-tabs-nonDD-Prod">
                                                <table class="table" id="table_nondd_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-3" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Qual">
                                                <table class="table" id="table_nondd_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-nonDD-sub-4" role="tabpanel" aria-labelledby="custom-tabs-nonDD_Attn">
                                                <table class="table" id="table_nondd_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="custom-tabs-main-Crdit" role="tabpanel" aria-labelledby="custom-tabs-one-profile-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_2" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-Crdit-tab-1" data-toggle="pill" href="#custom-tabs-Crdit-sub-1" role="tab" aria-controls="custom-tabs-Crdit" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-2" onclick="cred_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-2" role="tab" aria-controls="custom-tabs-Crdit_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-3" onclick="cred_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-3" role="tab" aria-controls="custom-tabs-Crdit_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Crdit-tab-4" onclick="cred_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Crdit-sub-4" role="tab" aria-controls="custom-tabs-Crdit_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Crdit">
                                            <div class="tab-pane fade show active" id="custom-tabs-Crdit-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Crdit">
                                                <table class="table" id="table_cred_Summary" style="width: 100%">
                                                    <thead> </thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Prod">
                                                <table class="table" id="table_cred_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Qual">
                                                <table class="table" id="table_cred_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Crdit-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Crdit_Attn">
                                                <table class="table" id="table_cred_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tab-pane fade show" id="custom-tabs-main-Servicing" role="tabpanel" aria-labelledby="custom-tabs-one-feedback-tab">
                                <div class="card card-tabs">
                                    <div class="card-header p-0 pt-1">
                                        <ul class="nav nav-tabs" id="custom-tabs-inner-tab_3" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="custom-tabs-Servicing-tab-1" data-toggle="pill" href="#custom-tabs-Servicing-sub-1" role="tab" aria-controls="custom-tabs-Servicing" aria-selected="true">Summary</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-2" onclick="serv_Prod_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-2" role="tab" aria-controls="custom-tabs-Servicing_Prod" aria-selected="false">Production Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-3" onclick="serv_feedback_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-3" role="tab" aria-controls="custom-tabs-Servicing_Qual" aria-selected="false">Feedback Details</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="custom-tabs-Servicing-tab-4" onclick="serv_attn_bindGrid();" data-toggle="pill" href="#custom-tabs-Servicing-sub-4" role="tab" aria-controls="custom-tabs-Servicingt_Attn" aria-selected="false">Attendance Details</a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body">
                                        <div class="tab-content" id="custom-tabs-Servicing">
                                            <div class="tab-pane fade show active" id="custom-tabs-Servicing-sub-1" role="tabpanel" aria-labelledby="custom-tabs-Servicing">
                                                <table class="table" id="table_serv_Summary" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-2" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Prod">
                                                <table class="table" id="table_serv_prod" style="width: 100%"></table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-3" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Qual">
                                                <table class="table" id="table_serv_feedback" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                            <div class="tab-pane" id="custom-tabs-Servicing-sub-4" role="tabpanel" aria-labelledby="custom-tabs-Servicing_Attn">
                                                <table class="table" id="table_serv_attn" style="width: 100%">
                                                    <thead></thead>
                                                    <tbody></tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="modal fade" id="waitingpanel" tabindex="-1" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-4 waiting-box">

                <div class="text-center mb-3">
                    <div class="spinner-border text-success" role="status" style="width: 3rem; height: 3rem;">
                    </div>
                    <h5 class="mt-3">Preparing Excel File<span class="dots"></span></h5>
                    <div class="progress mt-3">
                        <div id="excelProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" style="width: 0%"></div>
                    </div>
                </div>

                <ul id="excelSteps" class="excel-steps">
                    <li id="step1">⬜ NonDD Summary</li>
                    <li id="step2">⬜ NonDD Production</li>
                    <li id="step3">⬜ NonDD Feedback</li>
                    <li id="step4">⬜ NonDD Attendance</li>

                    <li id="step5">⬜ Credit Summary</li>
                    <li id="step6">⬜ Credit Production</li>
                    <li id="step7">⬜ Credit Feedback</li>
                    <li id="step8">⬜ Credit Attendance</li>

                    <li id="step9">⬜ Servicing Summary</li>
                    <li id="step10">⬜ Servicing Production</li>
                    <li id="step11">⬜ Servicing Feedback</li>
                    <li id="step12">⬜ Servicing Attendance</li>

                    <li id="step13">⬜ Finalizing Excel</li>
                </ul>
            </div>
        </div>
    </div>

    <iframe id="downloadFrame" style="display: none;"></iframe>

    <style>
        #excelSteps li {
            padding: 6px;
        }

        .activeStep {
            background-color: #E6FFE6;
            border-left: 4px solid #228B22;
            font-weight: bold;
        }

        .step-done {
            background-color: #d4edda;
            color: #155724;
            border-radius: 5px;
        }

        .dots::after {
            content: '';
            animation: dots 1.5s steps(4, end) infinite;
        }

        @keyframes dots {
            0% {
                content: '';
            }

            25% {
                content: '.';
            }

            50% {
                content: '..';
            }

            75% {
                content: '...';
            }

            100% {
                content: '';
            }
        }

        .waiting-box {
            border-radius: 12px;
        }

        .excel-steps {
            list-style: none;
            padding-left: 0;
            font-size: 14px;
            max-height: 220px;
            overflow-y: auto;
        }

            .excel-steps li {
                padding: 6px 10px;
                border-radius: 6px;
                margin-bottom: 4px;
                transition: all 0.3s ease;
            }

        .step-active {
            background-color: #e9f7ef;
            font-weight: 600;
        }

        .step-done {
            background-color: #d4edda;
            color: #155724;
        }
    </style>

    <%--1st Changes--%>
    <%--  <style>
        /* Remove extra card spacing */
        .card-tabs .card-body {
            padding: 8px !important;
        }

        /* Reduce space between tab header and content */
        .card-tabs .nav-tabs {
            margin-bottom: 5px;
        }

        .nav-tabs .nav-link {
            border: none;
            background: #f1f1f1;
            margin-right: 4px;
            border-radius: 6px;
            transition: 0.2s;
        }

            .nav-tabs .nav-link:hover {
                background: #dfe9ff;
            }

            .nav-tabs .nav-link.active {
                background: linear-gradient(45deg, #007bff, #0056b3);
                color: white !important;
            }

        .card-tabs {
            box-shadow: none !important;
            border: 1px solid #e5e5e5;
        }

            .card-tabs .card {
                margin-bottom: 0px;
            }

        /* Sub tabs different color */
        #custom-tabs-inner-tab_1 .nav-link.active,
        #custom-tabs-inner-tab_2 .nav-link.active,
        #custom-tabs-inner-tab_3 .nav-link.active {
            background-color: #17a2b8;
        }

        /* Table spacing */
        .table {
            margin-bottom: 0px !important;
        }

        /* Make tabs responsive */
        .nav-tabs {
            flex-wrap: wrap;
        }

        /* Smaller card header */
        .card-header {
            padding: 4px 6px !important;
        }
    </style>--%>


    <%--2nd Changes--%>
   <style>

   </style>
     <link rel="stylesheet" href="dist/css/adminlte.min.css">
 <link rel="stylesheet" href="dist/css/custom-style.css">
</asp:Content>
