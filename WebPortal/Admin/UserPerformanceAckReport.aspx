<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceAckReport.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceAckReport" %>

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

        .btn-gradient-primary {
            background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
            color: #fff;
            border-radius: 12px;
            height: 40px;
            font-weight: 400;
            transition: 0.3s;
        }

            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                /*background: linear-gradient(135deg, #4da6ff, #1a8cff);*/
                background: linear-gradient(to right, #90caf9, 10%, #047edf) !important;
                color: #fff;
            }

        .text-center {
            text-align: center;
        }

        .column-search {
            margin-top: 4px;
            padding: 2px;
            font-size: 12px;
        }

        .modern-report-header {
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

        .modern-report-title {
            align-items: center;
            display: flex;
            gap: 12px;
        }

        .modern-report-title-icon {
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

        .modern-report-title h1 {
            color: #172033;
            font-size: 20px;
            font-weight: 700;
            line-height: 1.2;
            margin: 0;
        }

        .modern-report-title span {
            color: #667085;
            display: block;
            font-size: 12px;
            margin-top: 2px;
        }

        .modern-report-badge {
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

        .modern-report-main {
            padding: 0 15px 24px;
        }

        .modern-report-card {
            border: 1px solid #e4e9f2;
            border-radius: 8px;
            box-shadow: 0 10px 28px rgba(15, 23, 42, .06);
            overflow: hidden;
        }

        .modern-report-card > .card-body {
            padding: 0;
        }

        .modern-filter-panel {
            background: #fff;
            border-bottom: 1px solid #e4e9f2;
            padding: 16px;
        }

        .modern-filter-grid {
            align-items: flex-end;
            display: grid;
            gap: 14px;
            grid-template-columns: minmax(180px, 1fr) minmax(180px, 1fr) minmax(220px, 1fr);
        }

        .modern-field label {
            border: none !important;
            color: #475467;
            display: block;
            font-size: 12px;
            font-weight: 700 !important;
            margin-bottom: 6px;
        }

        .modern-field .form-control {
            border-color: #d0d7e2;
            border-radius: 6px;
            box-shadow: none;
            height: 38px !important;
        }

        .modern-field .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 .15rem rgba(37, 99, 235, .12);
        }

        .modern-btn {
            align-items: center;
            border-radius: 6px;
            display: inline-flex;
            font-weight: 600;
            gap: 8px;
            justify-content: center;
            min-height: 38px;
            padding: 8px 14px;
            white-space: nowrap;
            width: 100%;
        }

        .modern-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }

        .modern-btn-primary:hover,
        .modern-btn-primary:focus {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: #fff;
        }

        .modern-table-panel {
            background: #fff;
            overflow-x: auto;
            padding: 16px;
        }

        .table.dataTable th {
            background: #f3f6fb !important;
            border-bottom: 1px solid #d8e0ec !important;
            color: #172033;
            font-weight: 700;
        }

        .table.dataTable tr td {
            background-color: #fff !important;
            color: #344054;
        }

        .table.dataTable tbody tr:hover td {
            background-color: #f8fbff !important;
        }

        @media (max-width: 767px) {
            .modern-report-header {
                margin-left: 8px;
                margin-right: 8px;
            }

            .modern-report-main {
                padding-left: 8px;
                padding-right: 8px;
            }

            .modern-filter-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <link rel="stylesheet" href="ModernReportSecuritization.css" />

    <script>
        $(document).ready(function () {

            ackrp_BindYear();

        });


        document.getElementById("ackMonthly_btnShow").addEventListener("click", function () {
            showUserAckReport();
        });


    </script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--------------- UserPerformanceAcknowledgement.js ---------------------%>

    <div class="modern-report-header">
        <div class="modern-report-title">
            <span class="modern-report-title-icon"><i class="bi bi-diagram-3-fill"></i></span>
            <div>
                <h1>Monthly Performance Acknowledgement Report</h1>
                <span>Review acknowledgement status and download performance letters</span>
            </div>
        </div>
        <div class="modern-report-badge">
            <i class="fas fa-file-pdf"></i>
            <span>PDF acknowledgement</span>
        </div>
    </div>

    <div class="col-lg-12 modern-report-main">
        <div class="card modern-report-card">
            <div class="card-body">
                <div class="modern-filter-panel">
                    <div class="modern-filter-grid">
                        <div class="modern-field">
                            <label for="ack_month">Month</label>
                            <select id="ack_month" name="ack_month" class="form-control" style="height: 40px;">
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
                        <div class="modern-field">
                            <label for="ack_year">Year</label>
                            <select id="ack_year" name="ack_year" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                        <div>
                            <button id="ackMonthly_btnShow" type="button" class="btn modern-btn modern-btn-primary" onclick="return showUserAckReport()"><i class="fas fa-search"></i><span>Get Record</span></button>
                        </div>
                    </div>
                </div>

                <div class="modern-table-panel">
                    <table class="table" id="table_ackUserReport" style="width: 100%;">
                        <thead>
                            <tr>
                                <%-- <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width:200px;" rowspan="2">View</th>--%>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 200px;" rowspan="2">Download</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; width: 100px;" rowspan="2">Sr. #</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center; vertical-align: center;" rowspan="2">Code</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Pseudo Name</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Reporting Manager</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Sub Domain</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;" colspan="3">Production</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;" colspan="3">Quality</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;" colspan="3">Attendance</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap; text-align: center;" colspan="2">Error Count</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Acknowledgement Status</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;" rowspan="2">Acknowledgement Date</th>
                            </tr>
                            <tr>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Grade</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Rating Category</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Grade</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Rating Category</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Percentage</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Grade</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Rating Category</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Critical</th>
                                <th class="sort border-top ps-3" style="text-wrap: nowrap;">Non-Critical</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="div_print" style="display: none; width: 800px; padding: 25px; font-family: Calibri, Arial; color: #000; background: #fff;">

        <!-- HEADER -->
        <table style="width: 100%; border-bottom: 2px solid #1a73e8; margin-bottom: 15px;">
            <tr>
                <td style="font-size: 18px; font-weight: bold; color: #1a73e8;">PERFORMANCE ACKNOWLEDGEMENT</td>
                <td style="text-align: right; font-size: 12px;"></td>
            </tr>
        </table>

        <!-- EMP DETAILS -->
        <table style="width: 100%; margin-bottom: 15px; font-size: 13px;">
            <tr>
                <td style="width: 60px;"><b>To :</b></td>
                <td><span id="userPerfAckPdf_lblTo"></span></td>
            </tr>
            <tr>
                <td><b>Domain :</b></td>
                <td><span id="userPerfAckPdf_lblDomain"></span></td>
            </tr>
            <tr>
                <td><b>Position :</b></td>
                <td><span id="userPerfAckPdf_lblPosition"></span></td>
            </tr>
        </table>

        <!-- SUBJECT -->
        <table style="width: 100%; margin-bottom: 15px;">
            <tr>
                <td style="padding: 6px 0; border-bottom: 1px solid #1a73e8; font-size: 13px;">
                    <b>Subject :</b> Acknowledgement of Performance Grading – Quality, Attendance, and Productivity
                </td>
            </tr>
        </table>

        <!-- BODY -->
        <table style="width: 100%; margin-bottom: 15px; font-size: 13px; line-height: 1.6;">
            <tr>
                <td><b id="userPerfAckPdf_lblEmpName"></b></td>
            </tr>
            <tr>
                <td style="padding-top: 10px;">This letter is to formally acknowledge the review of your recent performance evaluation
                covering the key performance areas of <b>Quality, Attendance,</b> and <b>Productivity</b> for
                <b id="userPerfAckPdf_lblMonthYear"></b>.
                </td>
            </tr>
        </table>

        <!-- TITLE -->
        <div style="color: #1a73e8; margin-bottom: 5px; font-size: 13px;">Performance Summary</div>

        <!-- TABLE -->
        <table style="width: 100%; border-collapse: collapse; font-size: 13px; margin-bottom: 20px;">
            <tr style="background: #1a73e8; color: #fff;">
                <th style="border: 1px; padding: 6px;">Category</th>
                <th style="border: 1px; padding: 6px; text-align: center;">Your Score</th>
                <th style="border: 1px; padding: 6px; text-align: center;">Rating Category</th>
            </tr>

            <tr>
                <td style="border: 1px; padding: 6px;">Quality<br>
                    <span style="font-size: 11px;" id="userPerfAckPdf_lblQCritical"></span>
                    <span style="font-size: 11px;" id="userPerfAckPdf_lblQNonCritical"></span>
                </td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblQuality"></td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblQuaRatingCat"></td>
            </tr>

            <tr style="background: #f5f7fb;">
                <td style="border: 1px; padding: 6px;">Attendance</td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblAttendance"></td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblAttRatingCat"></td>
            </tr>

            <tr>
                <td style="border: 1px; padding: 6px;">Productivity</td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblProductivity"></td>
                <td style="border: 1px; text-align: center;" id="userPerfAckPdf_lblPrRatingCat"></td>
            </tr>
        </table>

        <!-- NOTE -->
        <table style="width: 100%; margin-bottom: 20px; font-size: 13px;">
            <tr>
                <td><span style="color: red; text-align: left;">* &nbsp;</span> If you have any questions or would like to discuss your evaluation in more detail, 
                    please feel free to reach out to your supervisor or the HR department.
                </td>
            </tr>
        </table>

        <!-- TITLE -->
        <div style="color: #1a73e8; margin-bottom: 5px; font-size: 13px;">Performance Rating Scale</div>

        <!-- TABLE -->
        <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
            <tr style="background: #1a73e8; color: #fff;">
                <th style="border: 1px; padding: 5px;">Rating</th>
                <th style="border: 1px; padding: 5px;">Quality</th>
                <th style="border: 1px; padding: 5px;">Productivity</th>
                <th style="border: 1px; padding: 5px;">Attendance</th>
            </tr>

            <tr>
                <td style="border: 1px; padding: 5px;">Outstanding</td>
                <td>&lt;0.50</td>
                <td>&gt;100%</td>
                <td>100%</td>
            </tr>
            <tr style="background: #f5f7fb;">
                <td style="border: 1px; padding: 5px;">Exceeds Expectations</td>
                <td>0.50-0.75</td>
                <td>90%-100%</td>
                <td>98%-99%</td>
            </tr>
            <tr>
                <td style="border: 1px; padding: 5px;">Meets Expectations</td>
                <td>0.76-1.00</td>
                <td>80%-89%</td>
                <td>95%-97%</td>
            </tr>
            <tr style="background: #f5f7fb;">
                <td style="border: 1px; padding: 5px;">Needs Improvement</td>
                <td>1.00-2.00</td>
                <td>70%-79%</td>
                <td>90%-94%</td>
            </tr>
            <tr>
                <td style="border: 1px; padding: 5px;">Unsatisfactory</td>
                <td>&gt;2.00</td>
                <td>&lt;70%</td>
                <td>&lt;90%</td>
            </tr>
        </table>

    </div>
    <style>
        .pdf-container {
            width: 800px;
            margin: auto;
            padding: 25px;
            font-family: 'Segoe UI', sans-serif;
            color: #333;
            background: #fff;
        }

        .pdf-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

            .pdf-header h2 {
                margin: 0;
                color: #007bff;
            }

            .pdf-header .sub {
                font-size: 12px;
                color: #777;
            }

        .pdf-section {
            margin-bottom: 20px;
        }

        .pdf-subject {
            background: #f1f7ff;
            padding: 10px;
            border-left: 4px solid #007bff;
            margin-bottom: 20px;
        }

        .pdf-body p {
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .section-title {
            font-weight: 600;
            margin-bottom: 10px;
            color: #007bff;
        }

        /* TABLE */
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

            .styled-table th {
                background: #007bff;
                color: #fff;
                padding: 10px;
                text-align: center;
            }

            .styled-table td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }

            .styled-table tr:nth-child(even) {
                background: #f9f9f9;
            }

            .styled-table.small td,
            .styled-table.small th {
                font-size: 12px;
                padding: 6px;
            }
    </style>

    <div id="pdfLoader" style="display: none;">
        <div class="loader-overlay">
            <div class="loader-box">
                <div class="spinner"></div>
                <div class="loader-text">Generating PDF, please wait...</div>
            </div>
        </div>
    </div>
    <style>
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
            z-index: 9999;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .loader-box {
            background: #fff;
            padding: 20px 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }

        .loader-text {
            margin-top: 10px;
            font-size: 14px;
            font-weight: 500;
        }

        /* Spinner */
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: auto;
        }

        @keyframes spin {
            100% {
                transform: rotate(360deg);
            }
        }
    </style>

    <div class="modal fade" id="tablePreviewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Performance Details</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
