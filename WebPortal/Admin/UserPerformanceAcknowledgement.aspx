<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="UserPerformanceAcknowledgement.aspx.cs" Inherits="WebPortal.Admin.UserPerformanceAcknowledgement" %>

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

        }
    </style>

    <script>
        $(document).ready(function () {

            // bindDomain();
            BindUserPerformanceInfo();

        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Performance Acknowledgement</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
                <div class="col-lg-12">
                    <div class="row">
                       
                        <div class="col-md-8" style="font-size: 14px;">
                            <table>
                                <tr>
                                    <td>
                                        <label id="userPerfAck_lblDate"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        <label id="userPerfAck_lblTo"></label>
                                        <br />
                                        <label id="userPerfAck_lblDomain"></label>
                                        <br />
                                        <label id="userPerfAck_lblPosition"></label>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        <b>Subject : </b>Acknowledgement of Performance Grading – Quality, Attendance, and Productivity
                                   <br />
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label id="userPerfAck_lblEmpName"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>This letter serves to formally acknowledge the review of your 
                        recent performance evaluation covering the key performance areas of 
                        <b>Quality, Attendance,</b> and <b>Productivity</b> for
                                        <label id="userPerfAck_lblMonthYear"></label>
                                    </td>
                                </tr>
                                <tr></tr>
                            </table>
                            <br />
                            <span>Below is a summary of your grading compared to the company’s expected performance rating categories:</span>
                            <br />
                            <br />
                            <table border="1" class="table" style="text-align: center;">
                                <tr>
                                    <td style="background-color: lightgray;">
                                        <b>Category</b>
                                    </td>
                                    <td style="background-color: lightgray;">
                                        <b>Your Score</b>
                                    </td>
                                    <td style="background-color: lightgray;">
                                        <b>Rating Category</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Quality
                                        <br />
                                        <label id="userPerfAck_lblQCritical" style="font-size: 11px;"></label>
                                        &nbsp;&nbsp;
                                        <label id="userPerfAck_lblQNonCritical" style="font-size: 11px;"></label>
                                    </td>
                                    <td>
                                        <label id="userPerfAck_lblQuality" class="form-control" style="font-size: 14px;"></label>
                                    </td>
                                    <td>
                                        <label id="userPerfAck_lblQuaRatingCat" class="form-control"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Attendance</td>
                                    <td>
                                        <label id="userPerfAck_lblAttendance" class="form-control" style="font-size: 14px;"></label>
                                    </td>
                                    <td>
                                        <label id="userPerfAck_lblAttRatingCat" class="form-control"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Productivity</td>
                                    <td>
                                        <label id="userPerfAck_lblProductivity" class="form-control"></label>
                                    </td>
                                    <td>
                                        <label id="userPerfAck_lblPrRatingCat" class="form-control"></label>
                                    </td>
                                </tr>
                            </table>

                            <table>
                                <tr>
                                    <td>Should you have any questions or wish to discuss your evaluation in more detail, 
                            please feel free to schedule a meeting with your supervisor or the HR department.
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <span>Performance Rating Scale:</span>
                            <br />
                            <br />
                            <table border="1" class="table" style="text-align: center;">
                                <tr>
                                    <td style="background-color: lightgray;"><b>Rating Category</b></td>
                                    <td style="background-color: lightgray;"><b>Quality (Total Error/Loan)</b></td>
                                    <td style="background-color: lightgray;"><b>Productivity</b></td>
                                    <td style="background-color: lightgray;"><b>Attendance</b></td>
                                </tr>
                                <tr>
                                    <td>Outstanding</td>
                                    <td>< 0.50</td>
                                    <td>> 100.00%</td>
                                    <td>100%</td>
                                </tr>
                                <tr>
                                    <td>Exceeds Expectations</td>
                                    <td>0.50 - 0.75</td>
                                    <td>90.00% - 100.00%</td>
                                    <td>98.00% - 99.99%</td>
                                </tr>
                                <tr>
                                    <td>Meets Expectations</td>
                                    <td>0.76 - 1.00</td>
                                    <td>80.00% - 89.99%</td>
                                    <td>95.00% - 97.99%</td>
                                </tr>
                                <tr>
                                    <td>Needs Improvement</td>
                                    <td>1.00 - 2.00</td>
                                    <td>70.00% - 79.99%</td>
                                    <td>90.00% - 94.99%</td>
                                </tr>
                                <tr>
                                    <td>Unsatisfactory</td>
                                    <td>> 2.00</td>
                                    <td>< 70.00%</td>
                                    <td>< 90.00%</td>
                                </tr>
                            </table>
                            <hr />
                            <table style="font-size: 17px;">
                                <tr>
                                    <td>
                                        <br />
                                        <input type="checkbox" id="chk_UserPerfDesclaimer" name="chk_UserPerfDesclaimer" />&nbsp;&nbsp;
                                        <label id="userPerfAck_lblDesclaimer" style="font-weight: bold;"></label>
                                    </td>
                                </tr>
                                <tr style="text-align: center;">
                                    <td>
                                        <button id="userPerfAck_btnAccept" name="userPerfAck_btnAccept" class="btn btn-primary" onclick="return Onclick_userPerfAck_btnAccept();">Accept</button>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-2">
                            <label id="userPerfAck_lblPerformanceID" name="userPerfAck_lblPerformanceID" style="display: none;"></label>
                            <label id="userPerfAck_lblCode" name="userPerfAck_lblCode" style="display: none;"></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
