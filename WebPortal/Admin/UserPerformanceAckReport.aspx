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
    </style>

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

    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Monthly Performance Acknowledgement Report</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="row align-items-end g-4">
                    <div class="col-md-4">
                        <label class="form-label"><b>Month</b></label>
                        <div class="input-group">
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
                    </div>

                    <!-- Year -->
                    <div class="col-md-4">
                        <label class="form-label"><b>Year </b></label>
                        <div class="input-group">
                            <select id="ack_year" name="ack_year" class="form-control" style="height: 40px;">
                                <option value="">Select</option>
                            </select>
                        </div>
                    </div>

                    <!-- Get Report -->
                    <div class="col-md-4">
                        <button id="ackMonthly_btnShow" type="button" class="btn btn-gradient-primary w-100" onclick="return showUserAckReport()">
                            Get Record
                        </button>
                    </div>
                </div>

                <br />
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
