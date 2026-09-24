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
    <style>
        .user-perf-ack-header .callout { max-width: 1008px; margin: 0 auto; padding: 15px 20px; border-left: 4px solid #cda866; border-radius: 10px; background: #fff; box-shadow: 0 6px 20px rgba(31, 43, 38, .08); }
        .user-perf-ack-header h6 { color: #24352f; font-size: 18px; }
        .user-perf-ack { max-width: 1040px; margin: 0 auto; padding: 0 16px 28px; color: #303933; }
        .user-perf-ack .card { border: 1px solid #e5e2d9; border-top: 4px solid #cda866; border-radius: 14px; background: #fff; box-shadow: 0 12px 32px rgba(31, 43, 38, .1); }
        .user-perf-ack .card-body { padding: clamp(18px, 4vw, 38px); }
        .user-perf-ack .letter-content { font-size: 14px; line-height: 1.65; color: #17251e; }
        .user-perf-ack .letter-content > table:not(.table) { width: 100%; }
        .user-perf-ack .letter-content > table:not(.table) label { color: #17251e !important; opacity: 1; }
        .user-perf-ack .table { width: 100%; margin: 12px 0 24px; border: 1px solid #e3e4df; border-radius: 8px; background: #fff; }
        .user-perf-ack .table td { padding: 11px 12px; border-color: #e6e8e2; vertical-align: middle; }
        .user-perf-ack .table tr:first-child td { background: #28564b !important; color: #fff; font-weight: 700; }
        .user-perf-ack .table tr:nth-child(even) td { background: #faf9f6; }
        .user-perf-ack .table .form-control { min-height: 34px; height: auto; margin: 0; padding: 5px 8px; border: 0; background: transparent; font-weight: 600; }
        .user-perf-ack .performance-summary-table { table-layout: fixed; }
        .user-perf-ack .performance-summary-table td { vertical-align: middle; text-align: center; font-size: 15px; }
        .user-perf-ack .performance-summary-table td:nth-child(1) { width: 34%; }
        .user-perf-ack .performance-summary-table td:nth-child(2) { width: 26%; }
        .user-perf-ack .performance-summary-table td:nth-child(3) { width: 40%; }
        .user-perf-ack .performance-summary-table .form-control { display: flex; align-items: center; justify-content: center; width: 100%; min-height: 40px; padding: 7px 10px; font-size: 15px !important; line-height: 1.4; text-align: center; }
        .user-perf-ack .performance-summary-table td:nth-child(2) .form-control { background: #fff7e9; color: #66491c; border: 1px solid #f0dfbc; border-radius: 8px; }
        .user-perf-ack .performance-summary-table td:nth-child(3) .form-control { background: #edf7f2; color: #1f604d; border: 1px solid #d5e9dd; border-radius: 8px; }
        .user-perf-ack .performance-summary-table .form-control br { display: none; }
        .user-perf-ack .ack-consent { width: 100%; margin-top: 20px; padding: 18px; background: #edf7f2; border: 1px solid #cfe4d8; border-radius: 10px; }
        .user-perf-ack .ack-consent td { padding: 4px; }
        .user-perf-ack .checkbox-wrapper-26 { display: inline-flex; vertical-align: middle; margin-right: 8px; }
        .user-perf-ack .checkbox-wrapper-26 input { position: absolute; width: 1px; height: 1px; opacity: 0; }
        .user-perf-ack .checkbox-wrapper-26 label { --size: 36px; --shadow: calc(var(--size) * .07) calc(var(--size) * .1); position: relative; display: block; width: var(--size); height: var(--size); margin: 0; background: #cda866; border-radius: 50%; box-shadow: 0 var(--shadow) #e9dcc2; cursor: pointer; overflow: hidden; transition: transform .2s ease, background-color .2s ease, box-shadow .2s ease; }
        .user-perf-ack .checkbox-wrapper-26 label::before { content: ""; position: absolute; top: 50%; left: 0; right: 0; width: calc(var(--size) * .7); height: calc(var(--size) * .7); margin: 0 auto; background: #fff; border-radius: 50%; box-shadow: inset 0 var(--shadow) #e9dcc2; transform: translateY(-50%); transition: width .2s ease, height .2s ease; }
        .user-perf-ack .checkbox-wrapper-26 label:hover::before { width: calc(var(--size) * .55); height: calc(var(--size) * .55); }
        .user-perf-ack .checkbox-wrapper-26 label:active { transform: scale(.9); }
        .user-perf-ack .checkbox-wrapper-26 input:focus-visible + label { outline: 3px solid #16765f; outline-offset: 3px; }
        .user-perf-ack .checkbox-wrapper-26 .tick_mark { position: absolute; top: -1px; left: calc(var(--size) * -.05); right: 0; width: calc(var(--size) * .6); height: calc(var(--size) * .6); margin: 0 auto 0 calc(var(--size) * .14); transform: rotate(-40deg); }
        .user-perf-ack .checkbox-wrapper-26 .tick_mark::before, .user-perf-ack .checkbox-wrapper-26 .tick_mark::after { content: ""; position: absolute; background: #fff; border-radius: 2px; opacity: 0; transition: transform .2s ease, opacity .2s ease; }
        .user-perf-ack .checkbox-wrapper-26 .tick_mark::before { left: 0; bottom: 0; width: calc(var(--size) * .1); height: calc(var(--size) * .3); transform: translateY(calc(var(--size) * -.68)); }
        .user-perf-ack .checkbox-wrapper-26 .tick_mark::after { left: 0; bottom: 0; width: 100%; height: calc(var(--size) * .1); transform: translateX(calc(var(--size) * .78)); }
        .user-perf-ack .checkbox-wrapper-26 input:checked + label { background: #16765f; box-shadow: 0 var(--shadow) #a8d1c2; }
        .user-perf-ack .checkbox-wrapper-26 input:checked + label::before { width: 0; height: 0; }
        .user-perf-ack .checkbox-wrapper-26 input:checked + label .tick_mark::before, .user-perf-ack .checkbox-wrapper-26 input:checked + label .tick_mark::after { transform: translate(0); opacity: 1; }
        .user-perf-ack #userPerfAck_lblDesclaimer { display: inline; margin-left: 6px; color: #214a3d; font-weight: 600; }
        .user-perf-ack #userPerfAck_btnAccept { min-width: 180px; margin-top: 16px; padding: 10px 20px; border: 0; border-radius: 8px; background: #28564b; font-weight: 700; box-shadow: 0 6px 16px rgba(40, 86, 75, .22); }
        .user-perf-ack #userPerfAck_btnAccept:hover { background: #1f463d; }
        @media (max-width: 640px) {
            .user-perf-ack { padding: 0 8px 18px; }
            .user-perf-ack .card-body { padding: 16px; }
            .user-perf-ack .table { display: block; overflow-x: auto; white-space: nowrap; }
            .user-perf-ack .table td { padding: 8px; }
        }
    </style>
    <style>
        .ack-popup-mode body { background: #f5f4f0; }
        .ack-popup-mode .main-header, .ack-popup-mode .main-footer { display: none !important; }
        .ack-popup-mode .content-wrapper { margin: 0 !important; background: transparent; }
        .ack-popup-mode .content-header { display: none; }
        .ack-popup-mode .content .container { width: 100%; max-width: none; padding: 0 16px; }
        .ack-popup-mode .user-perf-ack { width: 100%; max-width: none; padding: 12px 0 16px; }
        .ack-popup-mode .user-perf-ack .card-body { padding: 18px 24px; }
        .ack-popup-mode .user-perf-ack .table { margin: 8px 0 14px; }
        .ack-popup-mode .user-perf-ack .table td { padding: 7px 10px; white-space: nowrap; }
        .ack-popup-mode .user-perf-ack .ack-consent { margin-top: 12px; padding: 12px; }
        @media (max-width: 1100px) {
            .ack-popup-mode .user-perf-ack .table { display: block; overflow-x: auto; }
        }
        @media (max-width: 640px) {
            .ack-popup-mode .content .container { padding: 0 8px; }
            .ack-popup-mode .user-perf-ack .card-body { padding: 14px; }
        }
    </style>
    <script>
        if (new URLSearchParams(window.location.search).get("popup") === "1") {
            document.documentElement.classList.add("ack-popup-mode");
        }
    </script>

    <script>
        $(document).ready(function () {

            // bindDomain();
            BindUserPerformanceInfo();

        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="content-header user-perf-ack-header">
        <div class="container">
            <div class="row mb-2 callout callout-info">
                <div class="col-sm-6">
                    <h6 class="m-0"><i class="fas fa-copy"></i>&nbsp;&nbsp;<b>Performance Acknowledgement</b></h6>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-12 user-perf-ack">
        <div class="card">
            <div class="card-body">
                <div class="col-lg-12">
                    <div class="row">
                       
                        <div class="col-12 letter-content">
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
                            <table border="1" class="table performance-summary-table" style="text-align: center;">
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
                            <table class="ack-consent" style="font-size: 17px;">
                                <tr>
                                    <td>
                                        <br />
                                       &nbsp; <div class="checkbox-wrapper-26">
                                            <input type="checkbox" id="chk_UserPerfDesclaimer" name="chk_UserPerfDesclaimer" aria-labelledby="userPerfAck_lblDesclaimer" />
                                            <label for="chk_UserPerfDesclaimer"><span class="tick_mark"></span></label>
                                        </div>
                                        <label id="userPerfAck_lblDesclaimer" style="font-weight: bold;"></label>
                                    </td>
                                </tr>
                                <tr style="text-align: center;">
                                    <td>
                                        <button id="userPerfAck_btnAccept" name="userPerfAck_btnAccept" class="btn btn-primary" onclick="return Onclick_userPerfAck_btnAccept();">Accept Performance</button>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                        <div class="d-none">
                            <label id="userPerfAck_lblPerformanceID" name="userPerfAck_lblPerformanceID" style="display: none;"></label>
                            <label id="userPerfAck_lblCode" name="userPerfAck_lblCode" style="display: none;"></label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
